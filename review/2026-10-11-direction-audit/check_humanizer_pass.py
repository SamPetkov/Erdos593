"""Mechanical preservation check and comparison; not proof or detector validation."""
import hashlib
import json
import re
import subprocess
from pathlib import Path

from pypdf import PdfReader

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BASE = "2f09f5800d7c7b551ef2783103c4b5df48148d85"
REL = "review/2026-10-02/erdos593_obligatory_triple_systems.tex"
OPEN = Path("C:/Users/petko/OneDrive - Université Paris Sciences et Lettres/"
            "Documents/Erdos/research/e593-audit-2026-10-02/journal-pass/"
            "erdos593_obligatory_triple_systems.tex")
old_bytes = subprocess.run(["git", "show", f"{BASE}:{REL}"], cwd=ROOT,
                           check=True, capture_output=True).stdout
new_bytes = (ROOT / REL).read_bytes()
old = old_bytes.decode("utf-8").replace("\r\n", "\n")
new = new_bytes.decode("utf-8").replace("\r\n", "\n")
pdf = (ROOT / REL).with_suffix(".pdf")
reader = PdfReader(pdf)

patterns = {
    "statement_bodies": r"\\begin\{(theoremA|theorem|lemma|proposition|corollary|claim|definition|problem)\}(.*?)\\end\{\1\}",
    "proof_bodies": r"\\begin\{proof\}(.*?)\\end\{proof\}",
    "bracket_displays": r"\\\[(.*?)\\\]",
    "equation_bodies": r"\\begin\{(equation\*?|align\*?|gather\*?|multline\*?)\}(.*?)\\end\{\1\}",
    "inline_math": r"(?<!\\)\$(.*?)(?<!\\)\$",
    "labels": r"\\label\{([^}]+)\}",
    "reference_calls": r"\\(?:eqref|ref|autoref)\{([^}]+)\}",
    "citation_calls": r"\\cite\w*\*?(?:\[[^\]]*\])*\{[^}]+\}",
}
matches = {name: [re.findall(pattern, text, re.S) for text in (old, new)]
           for name, pattern in patterns.items()}
checks = {f"exact_{name}_preserved": a == b for name, (a, b) in matches.items()}
checks.update({
    "inline_bibliography_preserved":
        old[old.index(r"\begin{thebibliography}"):]
        == new[new.index(r"\begin{thebibliography}"):],
    "date_preserved": re.findall(r"\\date\{[^}]+\}", old)
        == re.findall(r"\\date\{[^}]+\}", new),
    "open_source_equals_public_review_source": OPEN.read_bytes() == new_bytes,
    "open_pdf_equals_public_review_pdf": OPEN.with_suffix(".pdf").read_bytes() == pdf.read_bytes(),
    "pdf_59_pages": len(reader.pages) == 59,
})


def between(text, start, end):
    begin = text.index(start)
    finish = text.index(end, begin)
    return text[begin:finish].strip()


groups = [
    ("Abstract", r"\begin{abstract}", r"\end{abstract}",
     "Separate contribution clauses and make the Lean acceptance boundary a separate sentence; all mathematical restrictions remain."),
    ("Introduction: finite classifications", "The finite results ", "The numerical consequences ",
     "Distinguish possible global parameters from decompositions of fixed atoms without suggesting core-isomorphism uniqueness."),
    ("Introduction: formalization boundary", "The classification and substantial structural extensions ", r"\subsection*{Context",
     "Name the unfinished interfaces directly and distinguish manuscript proofs from accepted Lean exports."),
    ("Appendix B: conventions and scope", r"\section{Exact marginal entropy", r"\subsection{Uniform Potts",
     "State actual specified marginals and restricted-versus-open boundaries without repetitive hedging."),
]
fence = chr(96) * 3
comparison = [
    "# Academic readability pass — 11 October 2026", "",
    "Setting: medium English academic edit using the academic-humanizer skill.",
    "The clean revision is the existing open TeX source and matching public review copy.",
    "This comparison covers every changed paragraph group, not the unchanged paper.",
    "No detector score was used to rewrite the source, and no authorship or novelty claim is inferred from a score.", "",
]
for heading, start, end, note in groups:
    comparison.extend([
        f"## {heading}", "", "### Original", "", fence + "latex",
        between(old, start, end), fence, "", "### Revised", "", fence + "latex",
        between(new, start, end), fence, "", f"Note: {note}", "",
    ])
comparison.extend([
    "## Validation boundary", "",
    "The read-only checker compares against the exact previous draft head.",
    "All statement/proof bodies, inline and displayed mathematical expressions,",
    "labels, reference/citation calls, bibliography and revision date remain unchanged.",
    "The full separate-agent claim review passes, but this is not a full external",
    "mathematical audit, new Lean acceptance, or a detector guarantee.", "",
])
(HERE / "humanizer-comparison.md").write_text("\n".join(comparison), encoding="utf-8", newline="\n")

abstract = between(new, r"\begin{abstract}", r"\end{abstract}")
abstract = abstract[len(r"\begin{abstract}"):]
plain_abstract = " ".join(abstract.replace("~", " ").replace("$", "").split())
section_names = re.findall(r"\\section\{([^}]+)\}", new)
seed = int(hashlib.sha256(old_bytes).hexdigest()[:8], 16)
selected = seed % len(section_names)
report = {
    "baseline": BASE,
    "scope": "Mechanical source preservation and artifact matching; not mathematical, Lean or authorship certification",
    "checks": checks,
    "counts": {name: [len(a), len(b)] for name, (a, b) in matches.items()},
    "files": {
        name: {"sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
               "bytes": path.stat().st_size}
        for name, path in {
            "source_after": ROOT / REL, "pdf_after": pdf,
            "collective_correction_note": HERE / "collective-correction-budgets.md",
        }.items()
    },
    "source_before_sha256": hashlib.sha256(old_bytes).hexdigest(),
    "abstract": {"characters": len(plain_abstract),
                 "words": len(plain_abstract.split())},
    "selected_detector_section": {
        "method": "First eight hex characters of baseline source SHA256, unsigned integer modulo ordinary section count",
        "seed_hex": hashlib.sha256(old_bytes).hexdigest()[:8],
        "ordinary_sections": len(section_names), "one_based_index": selected + 1,
        "section": section_names[selected],
        "excerpt": "The removed-edge sign: a complete prose proof paragraph within the selected section",
        "limitation": "One section is reproducibly selected; the paragraph is a readable bounded excerpt, not a random sample of every sentence",
    },
    "changed_passage_pdf_pages": {
        term: [i + 1 for i, page in enumerate(reader.pages) if term in page.extract_text()]
        for term in ["formal interfaces remain unfinished", "Every marginal below",
                     "All logarithms in this appendix"]
    },
}
(HERE / "humanizer-static-qa.json").write_text(
    json.dumps(report, indent=2) + "\n", encoding="utf-8", newline="\n")
print(json.dumps(report, indent=2))
if not all(checks.values()):
    raise SystemExit("Preservation or artifact matching failed")
