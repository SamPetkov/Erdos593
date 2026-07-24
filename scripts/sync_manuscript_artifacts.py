#!/usr/bin/env python3
"""Synchronize the public Erdős 593 manuscript artifacts.

The authoritative source is ``erdos593_obligatory_triple_systems.tex``.
This script applies release-metadata normalizations, compiles the canonical PDF,
regenerates the readable Markdown rendering, and mirrors all arXiv-facing files.
It deliberately does not inspect or modify the Lean development.
"""

from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
CANONICAL_BASENAME = "erdos593_obligatory_triple_systems"
CANONICAL_TEX = ROOT / f"{CANONICAL_BASENAME}.tex"
CANONICAL_PDF = ROOT / f"{CANONICAL_BASENAME}.pdf"
CANONICAL_MD = ROOT / f"{CANONICAL_BASENAME}.md"

TEX_MIRRORS = [
    ROOT / "arxiv" / "main.tex",
    ROOT / "Erdos593_revised.tex",
]
PDF_MIRRORS = [ROOT / "arxiv" / "main.pdf"]
MD_MIRRORS = [ROOT / "arxiv" / "main.md"]
ARXIV_ZIP = ROOT / "arxiv" / "Erdos593_arxiv_source.zip"
PANDOC = os.environ.get("PANDOC", "pandoc")
EXPECTED_PANDOC_VERSION = "3.1.3"

SYNC_NOTE = """## Manuscript synchronization

`erdos593_obligatory_triple_systems.tex` is the sole authoritative manuscript
source.  The root PDF and Markdown file, the `arxiv/main.*` mirrors,
`Erdos593_revised.tex`, and `arxiv/Erdos593_arxiv_source.zip` are deterministic
generated artifacts.  The arXiv ZIP contains only `main.tex`, since the
bibliography is embedded in that file.  Regenerate everything with:

```bash
python scripts/sync_manuscript_artifacts.py
```

CI reruns the same synchronization and fails when a committed mirror differs
from the canonical TeX source.  The synchronization script does not modify the
Lean formalization.  Markdown generation is pinned to Pandoc 3.1.3; set the
`PANDOC` environment variable to a compatible executable when another version
is first on `PATH`.
"""


def run(command: list[str], *, cwd: Path | None = None, env: dict[str, str] | None = None) -> None:
    subprocess.run(command, cwd=cwd, env=env, check=True)


def normalize_tex(text: str) -> str:
    """Apply idempotent publication metadata and citation cleanups."""
    text = re.sub(r"^\\author\{.*?\}\s*$", r"\\author{Samuil Petkov}", text, count=1, flags=re.MULTILINE)
    text = re.sub(r"^\\address\{.*?\}\s*\n?", "", text, flags=re.MULTILINE)
    text = re.sub(r"^\\email\{.*?\}\s*\n?", "", text, flags=re.MULTILINE)
    text = text.replace(
        "\\newblock Accepted for publication; arXiv:2403.11223.\n",
        "\\newblock arXiv:2403.11223.\n",
    )
    text = text.replace("Samuil Pekov", "Samuil Petkov")
    text = text.replace("Samuil Petkob", "Samuil Petkov")

    required = [
        r"\title[Obligatory triple systems]{Obligatory Triple Systems: An Alternative Proof, Lean Formalisation, and Finite Consequences}",
        r"\author{Samuil Petkov}",
        "first publicly posted complete",
        "earliest complete public Lean",
        "Exact finite order--size--component spectrum",
    ]
    missing = [needle for needle in required if needle not in text]
    if missing:
        raise RuntimeError(f"canonical TeX is missing required release wording: {missing}")

    forbidden = [
        "The proof here is self-contained and does not use that manuscript",
        "The proof presented here was developed without consulting Li's manuscript",
        "No statement or argument from Li's preprint is used in the proof",
        "Samuil Petkov & ChatGPT",
        "Samuil Petkov and ChatGPT",
    ]
    present = [needle for needle in forbidden if needle in text]
    if present:
        raise RuntimeError(f"canonical TeX contains obsolete authorship/priority wording: {present}")
    return text


def generate_markdown(tex_path: Path, output_path: Path) -> None:
    """Generate a readable GitHub Markdown rendering from the canonical TeX."""
    pandoc_version = subprocess.check_output([PANDOC, "--version"], text=True).splitlines()[0]
    if pandoc_version.rsplit(maxsplit=1)[-1] != EXPECTED_PANDOC_VERSION:
        raise RuntimeError(
            f"deterministic Markdown generation requires Pandoc {EXPECTED_PANDOC_VERSION}; "
            f"found {pandoc_version}. Set PANDOC to a compatible executable."
        )
    with tempfile.TemporaryDirectory(prefix="erdos593-pandoc-") as tmp:
        raw = Path(tmp) / "raw.md"
        run(
            [
                PANDOC,
                str(tex_path),
                "--from=latex",
                "--to=gfm+tex_math_dollars",
                "--wrap=none",
                "--markdown-headings=atx",
                "--output",
                str(raw),
            ],
            cwd=ROOT,
        )
        body = raw.read_text(encoding="utf-8")

    # Pandoc deliberately omits \maketitle in non-standalone Markdown output.
    # Add a stable compact publication header, then retain the converted body.
    header = """# Obligatory Triple Systems: An Alternative Proof, Lean Formalisation, and Finite Consequences

**Samuil Petkov**  
24 July 2026

**2020 Mathematics Subject Classification.** Primary 05C65; Secondary 05C15, 05C63, 03E05

**Keywords.** obligatory triple system; finite parameter spectrum; hypergraph colouring; Levi graph; Berge cycle; balanced hypergraph; chromatic polynomial; Erdős Problem 593

"""
    body = re.sub(r"^#?\s*Obligatory\ Triple\ Systems:\ An\ Alternative\ Proof,\ Lean\ Formalisation,\ and\ Finite\ Consequences\s*\n+", "", body, count=1)
    body = body.replace("Samuil Pekov", "Samuil Petkov").replace("Samuil Petkob", "Samuil Petkov")
    output_path.write_text(header + body.lstrip(), encoding="utf-8", newline="\n")


def compile_pdf(tex_path: Path, output_path: Path) -> None:
    with tempfile.TemporaryDirectory(prefix="erdos593-latex-") as tmp:
        build = Path(tmp)
        local_tex = build / tex_path.name
        shutil.copy2(tex_path, local_tex)
        env = os.environ.copy()
        env.update(
            {
                "TZ": "UTC",
                "SOURCE_DATE_EPOCH": "1784894400",
                "FORCE_SOURCE_DATE": "1",
            }
        )
        run(
            [
                "latexmk",
                "-pdf",
                f"-outdir={build}",
                "-interaction=nonstopmode",
                "-halt-on-error",
                "-file-line-error",
                local_tex.name,
            ],
            cwd=build,
            env=env,
        )
        built_pdf = build / f"{tex_path.stem}.pdf"
        shutil.copy2(built_pdf, output_path)


def copy_file(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)


def make_arxiv_archive() -> None:
    """Write a cross-platform deterministic arXiv source ZIP."""
    ARXIV_ZIP.parent.mkdir(parents=True, exist_ok=True)
    info = zipfile.ZipInfo("main.tex", date_time=(2026, 7, 24, 12, 0, 0))
    info.create_system = 3
    info.external_attr = 0o100644 << 16
    info.compress_type = zipfile.ZIP_STORED
    with zipfile.ZipFile(ARXIV_ZIP, "w") as archive:
        archive.writestr(info, CANONICAL_TEX.read_bytes())


def validate_arxiv_archive() -> None:
    with zipfile.ZipFile(ARXIV_ZIP) as archive:
        names = archive.namelist()
        if names != ["main.tex"]:
            raise RuntimeError(f"arXiv ZIP has unexpected members: {names}")
        if archive.read("main.tex") != CANONICAL_TEX.read_bytes():
            raise RuntimeError("arXiv ZIP main.tex differs from the canonical TeX source")


def update_readme() -> None:
    readme = ROOT / "README.md"
    text = readme.read_text(encoding="utf-8")
    marker = "## Manuscript synchronization"
    if marker in text:
        text = text[: text.index(marker)].rstrip() + "\n\n" + SYNC_NOTE
    else:
        text = text.rstrip() + "\n\n" + SYNC_NOTE
    readme.write_text(text.rstrip() + "\n", encoding="utf-8", newline="\n")


def validate_public_text_files() -> None:
    public_files = [CANONICAL_TEX, CANONICAL_MD, *TEX_MIRRORS, *MD_MIRRORS, ROOT / "README.md", ROOT / "CITATION.cff"]
    forbidden = [
        "Samuil Pekov",
        "Samuil Petkob",
        "Samuil Petkov & ChatGPT",
        "Samuil Petkov and ChatGPT",
        "The proof here is self-contained and does not use that manuscript",
        "The proof presented here was developed without consulting Li's manuscript",
        "No statement or argument from Li's preprint is used in the proof",
    ]
    for path in public_files:
        if not path.exists():
            continue
        text = path.read_text(encoding="utf-8")
        hits = [needle for needle in forbidden if needle in text]
        if hits:
            raise RuntimeError(f"{path.relative_to(ROOT)} contains forbidden stale wording: {hits}")


def update_manifest_and_hashes() -> None:
    tracked = set(subprocess.check_output(["git", "ls-files"], cwd=ROOT, text=True).splitlines())
    tracked.add(ARXIV_ZIP.relative_to(ROOT).as_posix())
    tracked = sorted(path for path in tracked if path)
    (ROOT / "MANIFEST.txt").write_text("\n".join(tracked) + "\n", encoding="utf-8", newline="\n")

    # Hash every tracked regular file except the checksum file itself.
    lines: list[str] = []
    for rel in tracked:
        if rel == "SHA256SUMS":
            continue
        path = ROOT / rel
        if path.is_file():
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            lines.append(f"{digest}  {rel}")
    (ROOT / "SHA256SUMS").write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")


def synchronize() -> None:
    canonical = normalize_tex(CANONICAL_TEX.read_text(encoding="utf-8"))
    CANONICAL_TEX.write_text(canonical, encoding="utf-8", newline="\n")

    compile_pdf(CANONICAL_TEX, CANONICAL_PDF)
    generate_markdown(CANONICAL_TEX, CANONICAL_MD)

    for destination in TEX_MIRRORS:
        copy_file(CANONICAL_TEX, destination)
    for destination in PDF_MIRRORS:
        copy_file(CANONICAL_PDF, destination)
    for destination in MD_MIRRORS:
        copy_file(CANONICAL_MD, destination)

    make_arxiv_archive()
    update_readme()
    validate_public_text_files()
    validate_arxiv_archive()
    update_manifest_and_hashes()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="run synchronization and fail if it changes tracked files",
    )
    args = parser.parse_args()

    synchronize()
    if args.check:
        run(["git", "diff", "--exit-code", "--", "."], cwd=ROOT)
