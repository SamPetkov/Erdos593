# Build and review instructions for the matroid--Potts follow-up

The canonical paper source is split into four reviewable parts under:

```text
followup/matroid_potts/
```

The bibliography is:

```text
MATROID_POTTS_FOLLOWUP_REFERENCES.bib
```

## Local verification

From the repository root:

```bash
python scripts/check_matroid_potts_followup.py

python experiments/matroid_polytope_check.py \
  --check experiments/matroid_polytope_results.json

python experiments/berge_matroid_coloring.py \
  --check experiments/berge_matroid_coloring_results.json

python experiments/monochromatic_dependence_hypertutte.py \
  --state-limit 2000000 \
  --check experiments/monochromatic_dependence_hypertutte_results.json
```

All programs use only the Python standard library.

## Optional PDF build

With Pandoc, a TeX distribution, and citeproc support installed:

```bash
pandoc \
  followup/matroid_potts/00_structure_matroid_polytope.md \
  followup/matroid_potts/01_coloring_tutte.md \
  followup/matroid_potts/02_dependence_limits_ising.md \
  followup/matroid_potts/03_verification_literature_audit.md \
  --standalone \
  --citeproc \
  --bibliography MATROID_POTTS_FOLLOWUP_REFERENCES.bib \
  --pdf-engine=pdflatex \
  -V documentclass=amsart \
  -V geometry:margin=1in \
  -o MATROID_POTTS_FOLLOWUP_MANUSCRIPT.pdf
```

The PDF is intentionally not committed until the ordinary proofs and
literature positioning have received independent review.

## Logical scope

The manuscript uses the finite cycle-shadow theorem from the uniform
bridge-block work. It does not use the proposed all-uniformity avoidance
classification.

For \(r=3\), it applies to all reduced obligatory triple systems. For general
\(r\), it applies unconditionally to the generated expansion-amalgamation
class \(\mathcal B_r\).

## Review order

1. Cycle-shadow theorem and edge-subset heredity.
2. Intrinsic matroid rank formula.
3. Polymatroid and base-polytope translation.
4. Weak/strong coloring and Tutte--Potts transformations.
5. Hypergraph-Tutte specialization against the exact source convention.
6. Monochromatic-event dependence and complete joint law.
7. Factorial-moment and high-girth limit arguments.
8. Ising gauge transformation and algorithmic interpretation.
9. Final novelty and attribution audit.
