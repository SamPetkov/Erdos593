#!/usr/bin/env python3
"""Materialize the consolidated matroid--Potts follow-up paper."""
from __future__ import annotations
import base64
import binascii
import io
from pathlib import Path
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[1]
CHUNKS = ROOT / "scripts/materialize_chunks"
DIAGNOSTICS = ROOT / "payload-diagnostics.txt"
EXPECTED = [
    "followup/matroid_potts/README.md",
    "followup/matroid_potts/00_structure_matroid_polytope.md",
    "followup/matroid_potts/01_coloring_tutte.md",
    "followup/matroid_potts/02_dependence_limits_ising.md",
    "followup/matroid_potts/03_verification_literature_audit.md",
    "MATROID_POTTS_FOLLOWUP_MANUSCRIPT.md",
    "MATROID_POTTS_FOLLOWUP_REFERENCES.bib",
    "MATROID_POTTS_PAPER_BUILD.md",
    "JOINT_MONOCHROMATIC_LAW.md",
    "HIGH_GIRTH_MONOCHROMATIC_LIMITS.md",
    "scripts/check_matroid_potts_followup.py",
    "experiments/matroid_polytope_check.py",
    "experiments/matroid_polytope_results.json",
    ".github/workflows/consolidated-matroid-potts-paper.yml",
]

records: list[str] = []
def log(message: str) -> None:
    records.append(message)
    print(message)
    DIAGNOSTICS.write_text("\n".join(records) + "\n", encoding="utf-8")

parts = sorted(CHUNKS.glob("*.txt"))
if not parts:
    raise SystemExit("materializer chunks are missing")
texts = [path.read_text(encoding="ascii").strip() for path in parts]

# Two one-character transport defects were identified from the archived CI
# payload. Correct them deterministically before decoding; the final commit
# removes this loader and all transport files.
if len(texts) == 7 and len(texts[0]) == 7001 and texts[0].endswith("GWPY"):
    texts[0] = texts[0][:-1]
    log("normalized chunk 00: removed duplicated terminal 'Y'")
if (
    len(texts) == 7
    and len(texts[6]) == 4215
    and texts[6][1131:1191]
    == "Yi0WwcuUzIqtuIKPxZNV8yLJbnrIimzLJ6lisNMp112vlXA0028qxqpN9Zos"
):
    texts[6] = texts[6][:1161] + "i" + texts[6][1161:]
    log("normalized chunk 06: restored the missing base64 character at offset 1161")

for path, text in zip(parts, texts):
    log(
        f"chunk {path.name}: chars={len(text)} "
        f"head={text[:40]!r} tail={text[-40:]!r}"
    )
payload = "".join(texts)
log(f"combined payload chars={len(payload)}")
try:
    raw = base64.b64decode(payload, validate=True)
except binascii.Error as exc:
    log(f"base64 decode failed: {exc}")
    raise
log(f"decoded payload bytes={len(raw)} head={raw[:8]!r} tail={raw[-22:]!r}")
try:
    archive_context = zipfile.ZipFile(io.BytesIO(raw))
except zipfile.BadZipFile as exc:
    log(f"ZIP decode failed: {exc}")
    raise
with archive_context as archive:
    names = archive.namelist()
    log(f"archive names={names}")
    if sorted(names) != sorted(EXPECTED):
        raise SystemExit(f"archive manifest mismatch: {names}")
    for name in names:
        target = (ROOT / name).resolve()
        if ROOT.resolve() not in target.parents:
            raise SystemExit(f"unsafe archive path: {name}")
    archive.extractall(ROOT)

for rel in EXPECTED:
    if not (ROOT / rel).is_file():
        raise SystemExit(f"failed to materialize {rel}")

shutil.rmtree(CHUNKS)
Path(__file__).unlink()
workflow = ROOT / ".github/workflows/materialize-consolidated-matroid-potts.yml"
if workflow.exists():
    workflow.unlink()
if DIAGNOSTICS.exists():
    DIAGNOSTICS.unlink()
print(f"materialized {len(EXPECTED)} consolidated paper files from {len(parts)} chunks")
