#!/usr/bin/env python3
"""Materialize the consolidated matroid--Potts follow-up paper."""
from __future__ import annotations
import base64
import io
from pathlib import Path
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[1]
CHUNKS = ROOT / "scripts/materialize_chunks"
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

parts = sorted(CHUNKS.glob("*.txt"))
if not parts:
    raise SystemExit("materializer chunks are missing")
payload = "".join(path.read_text(encoding="ascii").strip() for path in parts)
raw = base64.b64decode(payload, validate=True)
with zipfile.ZipFile(io.BytesIO(raw)) as archive:
    names = archive.namelist()
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
print(f"materialized {len(EXPECTED)} consolidated paper files from {len(parts)} chunks")
