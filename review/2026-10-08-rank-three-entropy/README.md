# Rank-three research checkpoint — 9 October 2026

This packet preserves progress recovered after the Windows restart. It is a
research draft, not the authoritative manuscript or an accepted Lean integration.
The accepted 250-module, 401-audit checkpoint remains unchanged.

The mathematical connection is the transition from cycle/theta atoms to the
next trivalent core, K4: which parts of a common-power density inequality follow
from the same Markov structure, and where an exact entropy construction needs
additional work?

## Contents and status

- `research-note.tex`: restricted compensation and binary entropy proofs;
  density-free flat-spectrum comparison with a quantitative bound; component
  and independent-coordinate extensions; a host-dependent mixing bound and a
  nested conditional-expectation theorem allowing interacting spectra;
  explicit obstructions and the remaining
  general spectral-prefix obligation. Analytical review only, no novelty claim.
- `CoefficientCompensationCandidate.lean`: returned Aristotle coefficient proof,
  with only documentary comments adapted for public delivery. It is not imported
  by any accepted root. Its unchanged original passed pinned Lean4.32.0 with
  warnings fatal in job66955. Kernel transport and canonical acceptance are pending.
- `coefficient-checkpoint.json`: exact statement, service provenance, hashes,
  statement-only API history and the actual focused proof-check boundary.
- `coefficient-proof-output.log`, `coefficient-proof-check.json`: actual complete
  proof output and eleven-original reconciliation;12fulltypes,3definitions and
  12orderedstandard-only axiom lists. Historical dependency lineage remains pending.
- `continuation_checks.py`, `continuation-exact-results.json`: two fixed exact
  examples distinguishing the mixing and hierarchical sufficient conditions.
- `continuation-review.json`: source-mapped mathematical and proof-status review.
- `exact_checks.py`, `route-diagnostics.json`, `exact-check-results.json`:
  deterministic rational examples and exhaustive 64-subset classification.
  No random campaign or universal conclusion is inferred from the examples.
- `analytical-review.json`, `review-status.json`, `editorial-comparison.json`:
  scoped obligation audit, current claim boundaries and comparison notes.

Run the checks from the repository root:

```sh
python -B review/2026-10-08-rank-three-entropy/exact_checks.py
python -B review/2026-10-08-rank-three-entropy/continuation_checks.py
```

The printed JSON must match each corresponding saved results file as parsed data. Decimal
values are for display; all assertions use exact integer or rational arithmetic.
The four-state negative coefficient refutes only individual coefficient
positivity. All its old and shifted prefixes are positive, and it is not a
counterexample to the density target.

## What remains open

The universal density-free inequality for arbitrary interacting spectra, the
unrestricted exact-marginal entropy statement, formal transport from the
coefficient lemma to the kernel theorem, literature novelty, and significance
remain separate obligations. The coefficient proof now has a real pinned focused
check, not a whole graph theorem or canonical integration. Job66955 completed
with actual child/wrapper/accounting zero; no proof job remains active and the
green focused gate must not be repeated. No novelty or B-level result is claimed.

This is an update to public draft PR55, not a new duplicate PR or a merge. No
live manuscript, PDF, bibliography, accepted source root, private coordination
material or recurring clock is changed by this packet.
