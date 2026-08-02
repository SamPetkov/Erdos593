#!/usr/bin/env python3
"""Audit the Erdős 593 manuscript against the AMS writing checklist.

The default ``audit`` mode records deviations in the current canonical source
without failing.  ``enforce`` mode is intended for the later publication-
integration branch and fails if any protected deviation remains.

The program also checks the copy-ready AMS front-matter fragment strictly:
its abstract must be a single self-contained paragraph of at most 150 words,
with no citation, footnote, display, or numbered equation.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "erdos593_obligatory_triple_systems.tex"
FRONT = ROOT / "reader-first" / "AMS_COMPLIANT_FRONT_MATTER.tex"
AUDIT = ROOT / "audits" / "AMS_WRITING_AND_STYLE_AUDIT.md"
PATCHES = ROOT / "audits" / "AMS_WRITING_LINE_PATCHES.md"


def read(path: Path) -> str:
    if not path.is_file():
        raise AssertionError(f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def extract_environment(text: str, name: str) -> str:
    match = re.search(
        rf"\\begin\{{{re.escape(name)}\}}(.*?)\\end\{{{re.escape(name)}\}}",
        text,
        flags=re.DOTALL,
    )
    if match is None:
        raise AssertionError(f"missing {name} environment")
    return match.group(1).strip()


def strip_comments(text: str) -> str:
    return re.sub(r"(?<!\\)%.*", "", text)


def prose_word_count(tex: str) -> int:
    text = strip_comments(tex)
    text = re.sub(r"\$.*?\$", " ", text, flags=re.DOTALL)
    text = re.sub(r"\\\(.*?\\\)", " ", text, flags=re.DOTALL)
    text = re.sub(r"\\\[.*?\\\]", " ", text, flags=re.DOTALL)
    text = re.sub(
        r"\\begin\{(?:equation\*?|align\*?|gather\*?|multline\*?)\}.*?"
        r"\\end\{(?:equation\*?|align\*?|gather\*?|multline\*?)\}",
        " ",
        text,
        flags=re.DOTALL,
    )
    # Preserve command arguments as prose while removing command names.
    text = re.sub(r"\\[A-Za-z@]+\*?(?:\[[^\]]*\])?", " ", text)
    text = text.replace("{", " ").replace("}", " ")
    text = re.sub(r"[^A-Za-zÀ-ÖØ-öø-ÿ0-9'’-]+", " ", text)
    return len([word for word in text.split() if word])


def check_front_matter(front: str) -> dict[str, object]:
    abstract = extract_environment(front, "abstract")
    word_count = prose_word_count(abstract)

    failures: list[str] = []
    if word_count > 150:
        failures.append(f"abstract has {word_count} prose words; maximum is 150")
    if re.search(r"\n\s*\n", abstract):
        failures.append("abstract is not a single paragraph")

    forbidden_abstract_patterns = {
        "citation": r"\\cite",
        "cross-reference": r"\\(?:ref|eqref|pageref)",
        "footnote": r"\\footnote",
        "display math": r"\\\[|\\begin\{(?:equation|align|gather|multline)",
        "manual equation tag": r"\\tag\{",
    }
    for description, pattern in forbidden_abstract_patterns.items():
        if re.search(pattern, abstract):
            failures.append(f"abstract contains {description}")

    required_markers = {
        "title": r"\\title(?:\[[^\]]*\])?\s*\{",
        "author": r"\\author\{Samuil Petkov\}",
        "address": r"\\address\{",
        "email": r"\\email\{samuil\.petkov@ens\.psl\.eu\}",
        "2020 MSC": r"\\subjclass\[2020\]\{",
        "keywords": r"\\keywords\{",
        "numbered introduction": r"\\section\{Introduction\}",
        "isomorphism closure": r"understood up to\s+triple-system isomorphism",
        "weak coloring convention": r"uncountable weak chromatic number",
    }
    for description, pattern in required_markers.items():
        if re.search(pattern, front, flags=re.DOTALL) is None:
            failures.append(f"front matter is missing {description}")

    if re.search(r"\\date\s*\{", front):
        failures.append("front matter contains an author-supplied date")

    title_match = re.search(
        r"\\title(?:\[[^\]]*\])?\s*\{(.*?)\}\s*\\author",
        front,
        flags=re.DOTALL,
    )
    if title_match is None:
        failures.append("could not parse the full title")
        title = ""
    else:
        title = " ".join(title_match.group(1).split())
        if re.search(r"\$|\\\(|\\\[", title):
            failures.append("title contains mathematical notation")

    theorem = extract_environment(front, "theoremA")
    if "the following assertions are equivalent." not in theorem:
        failures.append("Theorem A is not introduced as a complete sentence")
    if re.search(r"even length\.\s*\\end\{enumerate\}\s*$", theorem) is None:
        failures.append("Theorem A's final assertion does not end with punctuation")

    if failures:
        raise AssertionError("; ".join(failures))

    return {
        "abstract_prose_words": word_count,
        "abstract_single_paragraph": True,
        "abstract_has_citations": False,
        "abstract_has_display_math": False,
        "title": title,
        "address_present": True,
        "email_present": True,
        "msc_2020_present": True,
        "keywords_present": True,
        "author_date_present": False,
        "theorem_a_grammatical": True,
    }


def canonical_findings(tex: str) -> list[dict[str, str]]:
    abstract = extract_environment(tex, "abstract")
    findings: list[dict[str, str]] = []

    def add(code: str, severity: str, message: str) -> None:
        findings.append({"code": code, "severity": severity, "message": message})

    if re.search(r"\\date\s*\{", tex):
        add("front.date", "required", "remove the author-supplied title-block date")
    if re.search(r"\\address\s*\{", tex) is None:
        add("front.address", "required", "add an amsart address")
    if re.search(r"\\email\s*\{", tex) is None:
        add("front.email", "required", "add an amsart email")
    if re.search(r"\\\[|\\begin\{(?:equation|align|gather|multline)", abstract):
        add("abstract.display", "required", "remove displayed mathematics from the abstract")
    if prose_word_count(abstract) > 150:
        add("abstract.length", "required", "reduce the abstract to at most 150 prose words")
    if r"\section*{Introduction}" in tex:
        add("structure.introduction", "recommended", "number the introduction")
    if r"\usepackage[margin=1in]{geometry}" in tex:
        add("source.geometry", "submission", "let amsart control the submission geometry")
    if "newtxtext,newtxmath" in tex:
        add("source.fonts", "submission", "remove custom fonts from the AMS submission source")
    if any(package in tex for package in (r"\usepackage{needspace}", r"\usepackage{enumitem}")):
        add("source.layout-packages", "submission", "remove layout-only packages from the AMS submission source")
    if r"\BeforeBeginEnvironment" in tex:
        add("source.theorem-spacing", "submission", "remove custom theorem-spacing hooks")
    if r"\boxed{" in tex:
        add("math.boxed", "recommended", "remove decorative boxes from theorem statements")
    if r"\def\labelenumi" in tex or r"\tightlist" in tex:
        add("source.generated-lists", "recommended", "replace generated list boilerplate")
    if "the following are equivalent:" in tex:
        add("prose.theorem-colon", "recommended", "introduce equivalence lists with a complete sentence")
    if "deletes selected Levi-graph bridges" in tex:
        add("prose.selected-bridges", "required", "write that all Levi bridges are deleted")
    if "incidence of every hyperedge-node" in abstract:
        add("prose.abstract-nominalisation", "recommended", "replace nominal prose by a finite clause")
    if "prescribed odd girth" in tex:
        add("prose.odd-girth", "required", "use lower-bound language for odd girth")
    if r"\section*{AI assistance}" in tex:
        add("back.ai-heading", "recommended", "consolidate disclosure headings unless the target journal requires them")
    if r"\section*{Funding}" in tex or r"\section*{Competing interests}" in tex:
        add("back.disclosure-headings", "recommended", "consolidate funding and competing-interest statements")

    full_journal_names = (
        "Proceedings of the American Mathematical Society",
        "Bulletin of the American Mathematical Society",
        "Acta Mathematica Hungarica",
    )
    if any(name in tex for name in full_journal_names):
        add("bibliography.abbreviations", "required", "normalise journal abbreviations")
    if r"\penalty0" in tex:
        add("bibliography.generated-penalties", "recommended", "remove generated bibliography penalties")

    british_terms = {
        "colour": len(re.findall(r"\bcolour(?:ing|ed|s)?\b", tex, flags=re.IGNORECASE)),
        "formalisation": len(re.findall(r"\bformalis(?:ation|ed|e)\b", tex, flags=re.IGNORECASE)),
        "characterisation": len(re.findall(r"\bcharacterisation\b", tex, flags=re.IGNORECASE)),
    }
    if any(british_terms.values()):
        add(
            "prose.spelling-system",
            "choice",
            "retain one spelling system; use a global American-English pass for an AMS-targeted branch",
        )

    return findings


def check_ledgers(audit: str, patches: str) -> dict[str, int]:
    audit_markers = (
        "MATHEMATICALLY WELL WRITTEN, BUT NOT YET AMS-SUBMISSION CLEAN",
        "Publication acceptance test",
        "Punctuate displayed mathematics",
        "Bibliography",
        "Formalisation, acknowledgments, and disclosures",
    )
    for marker in audit_markers:
        if marker not in audit:
            raise AssertionError(f"AMS audit marker missing: {marker}")

    patch_numbers = re.findall(r"^## Patch (\d+):", patches, flags=re.MULTILINE)
    expected = [str(number) for number in range(1, 25)]
    if patch_numbers != expected:
        raise AssertionError(
            f"AMS patch ledger mismatch: actual={patch_numbers}, expected={expected}"
        )
    return {"audit_markers": len(audit_markers), "copy_ready_patches": len(expected)}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("audit", "enforce"), default="audit")
    args = parser.parse_args()

    tex = read(TEX)
    front = read(FRONT)
    audit = read(AUDIT)
    patches = read(PATCHES)

    front_result = check_front_matter(front)
    ledger_result = check_ledgers(audit, patches)
    findings = canonical_findings(tex)

    required = [item for item in findings if item["severity"] == "required"]
    submission = [item for item in findings if item["severity"] == "submission"]

    result = {
        "manuscript": str(TEX.relative_to(ROOT)),
        "mode": args.mode,
        "front_matter_fragment": front_result,
        "ledgers": ledger_result,
        "canonical_findings": findings,
        "finding_count": len(findings),
        "required_finding_count": len(required),
        "submission_layout_finding_count": len(submission),
        "status": "AMS_STYLE_CLEAN" if not findings else "AUDIT_FINDINGS_RECORDED",
    }

    print("Erdos 593 AMS writing audit")
    print(json.dumps(result, indent=2, sort_keys=True, ensure_ascii=False))

    if args.mode == "enforce" and findings:
        sys.stderr.write(
            f"AMS enforcement failed: {len(findings)} finding(s) remain in {TEX.name}\n"
        )
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
