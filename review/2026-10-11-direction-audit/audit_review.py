"""Read-only source/PDF checks; emits a mechanical report, not proof acceptance."""
import hashlib
import json
import re
import subprocess
from pathlib import Path

from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[2]
BASE = "be6f7637147e0a02e8f03fa4f0ad770370b2327a"
REL = "review/2026-10-02/erdos593_obligatory_triple_systems.tex"
old = subprocess.run(
    ["git", "show", f"{BASE}:{REL}"], cwd=ROOT, check=True,
    capture_output=True, text=True, encoding="utf-8",
).stdout
new = (ROOT / REL).read_text(encoding="utf-8")
statement_re = re.compile(
    r"\\begin\{(theoremA|theorem|lemma|proposition|corollary|claim|definition|problem)\}"
    r"(.*?)\\end\{\1\}", re.S,
)
proof_re = re.compile(r"\\begin\{proof\}(.*?)\\end\{proof\}", re.S)
display_re = re.compile(r"\\\[(.*?)\\\]", re.S)
label_re = re.compile(r"\\label\{([^}]+)\}")
citation_re = re.compile(r"\\cite\w*\*?(?:\[[^\]]*\])*\{([^}]+)\}")
item_re = re.compile(r"\\bibitem(?:\[[^\]]*\])?\{([^}]+)\}")


def ordered_subsequence(before, after):
    it = iter(after)
    return all(any(item == target for item in it) for target in before)


def cites(source):
    return [key.strip() for group in citation_re.findall(source)
            for key in group.split(",")]


old_labels, new_labels = label_re.findall(old), label_re.findall(new)
old_items, new_items = item_re.findall(old), item_re.findall(new)
new_cites = cites(new)
first_cites = list(dict.fromkeys(new_cites))
bib = ROOT / "review/2026-10-02/references.bib"
bib_keys = re.findall(r"@\w+\s*\{\s*([^,\s]+)\s*,", bib.read_text(encoding="utf-8"))
local = ROOT / "review/2026-10-02"
pdf = local / "erdos593_obligatory_triple_systems.pdf"
reader = PdfReader(pdf)
checks = {
    "old_labels_preserved_in_order": ordered_subsequence(old_labels, new_labels),
    "all_labels_unique": len(new_labels) == len(set(new_labels)),
    "old_statement_bodies_preserved_in_order": ordered_subsequence(
        statement_re.findall(old), statement_re.findall(new)),
    "old_proof_bodies_preserved_in_order": ordered_subsequence(
        proof_re.findall(old), proof_re.findall(new)),
    "old_bracket_displays_preserved_in_order": ordered_subsequence(
        display_re.findall(old), display_re.findall(new)),
    "existing_citation_sequence_preserved": cites(old) == new_cites,
    "existing_inline_bibliography_keys_preserved": old_items == new_items,
    "all_references_cited_and_keys_match_bibtex":
        set(new_items) == set(new_cites) == set(bib_keys),
    "reference_numbers_first_citation_order": new_items == first_cites,
    "references_and_bibtex_keys_unique":
        len(new_items) == len(set(new_items)) and len(bib_keys) == len(set(bib_keys)),
    "pdf_has_59_pages": len(reader.pages) == 59,
    "date_and_new_theorem_in_pdf": "11 October 2026" in reader.pages[0].extract_text()
        and any("Weighted flat-complement transfer" in p.extract_text() for p in reader.pages),
}
report = {
    "baseline": BASE,
    "scope": "Source preservation, citation consistency and PDF presence; not proof or Lean acceptance",
    "checks": checks,
    "counts": {
        "labels_before_after": [len(old_labels), len(new_labels)],
        "statements_before_after": [len(statement_re.findall(old)), len(statement_re.findall(new))],
        "proofs_before_after": [len(proof_re.findall(old)), len(proof_re.findall(new))],
        "bracket_displays_before_after": [len(display_re.findall(old)), len(display_re.findall(new))],
        "references": len(new_items),
        "citation_commands": len(citation_re.findall(new)),
        "pdf_pages": len(reader.pages),
    },
    "new_labels": [x for x in new_labels if x not in old_labels],
    "files": {
        name: {"sha256": hashlib.sha256((local / name).read_bytes()).hexdigest(),
               "bytes": (local / name).stat().st_size}
        for name in ["erdos593_obligatory_triple_systems.tex",
                     "erdos593_obligatory_triple_systems.pdf", "references.bib"]
    },
}
print(json.dumps(report, indent=2))
(Path(__file__).parent / "static-qa.json").write_text(
    json.dumps(report, indent=2) + "\n", encoding="utf-8", newline="\n")
if not all(checks.values()):
    raise SystemExit("One or more source/PDF checks failed")
