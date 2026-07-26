#!/usr/bin/env python3
"""Static checks for the consolidated matroid/Potts follow-up manuscript."""

from __future__ import annotations

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PARTS = [
    ROOT / "followup/matroid_potts/00_structure_matroid_polytope.md",
    ROOT / "followup/matroid_potts/01_coloring_tutte.md",
    ROOT / "followup/matroid_potts/02_dependence_limits_ising.md",
    ROOT / "followup/matroid_potts/03_verification_literature_audit.md",
]
FULL = ROOT / "MATROID_POTTS_FOLLOWUP_MANUSCRIPT.md"
TEXT_FILES = [
    *PARTS,
    FULL,
    ROOT / "followup/matroid_potts/README.md",
    ROOT / "JOINT_MONOCHROMATIC_LAW.md",
    ROOT / "HIGH_GIRTH_MONOCHROMATIC_LIMITS.md",
]
BIB = ROOT / "MATROID_POTTS_FOLLOWUP_REFERENCES.bib"


def fail(message: str) -> None:
    raise SystemExit(message)


def main() -> int:
    for path in [*TEXT_FILES, BIB]:
        if not path.exists():
            fail(f"missing required file: {path.relative_to(ROOT)}")
        text = path.read_text(encoding="utf-8")
        bad = [
            (index, ord(char))
            for index, char in enumerate(text)
            if ord(char) < 32 and char not in "\n\r"
        ]
        if bad:
            fail(f"{path.name}: forbidden control character(s): {bad[:8]}")
        if "\ufffd" in text:
            fail(f"{path.name}: Unicode replacement character found")
        if text.count(r"\[") != text.count(r"\]"):
            fail(f"{path.name}: unbalanced display-math delimiters")
        if text.count("```") % 2:
            fail(f"{path.name}: unbalanced fenced code block")

    manuscript = "\n".join(path.read_text(encoding="utf-8") for path in PARTS)
    if FULL.read_text(encoding="utf-8") != manuscript:
        fail("assembled manuscript differs from the four canonical parts")
    bib = BIB.read_text(encoding="utf-8")
    cited = set()
    for group in re.findall(r"\[@([^\]]+)\]", manuscript):
        for item in group.split(";"):
            key = item.strip().lstrip("@").split(",", 1)[0].strip()
            if key:
                cited.add(key)
    defined = set(re.findall(r"@\w+\{([^,]+),", bib))
    missing = sorted(cited - defined)
    if missing:
        fail(f"undefined bibliography keys: {missing}")

    markers = [
        "Theorem 2.2. Intrinsic subset-rank formula",
        "Theorem 3.2. Base-polytope translation",
        "Theorem 4.2. Exact Potts reduction",
        "Theorem 7.1. Hypergraph-Tutte specialization",
        "Theorem 8.2. Probabilistic dependence matroid",
        "Theorem 8.3. Complete joint law",
        "Theorem 10.1. Poisson transfer",
        "Theorem 10.2. Gaussian transfer",
        "Property B and ferromagnetic Ising",
        "Audit status and dependency map",
    ]
    for marker in markers:
        if marker not in manuscript:
            fail(f"missing manuscript marker: {marker}")

    print(
        "follow-up manuscript checks passed: "
        f"{len(PARTS)} parts, {len(cited)} citations, "
        f"{len(defined)} bibliography entries"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
