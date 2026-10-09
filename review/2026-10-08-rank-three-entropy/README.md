# Rank-three research checkpoint — 9 October 2026

This packet preserves progress recovered after the Windows restart. It is a
research draft, not the authoritative manuscript or an accepted Lean integration.
The accepted 250-module, 401-audit checkpoint remains unchanged.

The mathematical connection is the transition from cycle/theta atoms to the
next trivalent core, K4. The exact edge-marginal entropy target now holds
analytically for every uniform binary pair law with correlation in [-1/3, 1],
on every simple bipartite K4 subdivision satisfying the parity-cut condition.
All positive path lengths are allowed, including length one.

The binary proof establishes a stronger graph statement: for every finite
simple graph of maximum degree at most three and every correlation r in [0, 1],
there is a law with uniform binary singleton marginals, exactly the prescribed
pair marginal on every actual edge, and divergence at most |E| I(r).
For bipartite graphs the range is [-1, 1]. A finite constrained Gibbs fit and
a two-neighbor conditional-mean argument control the fitted model's
zero-coupling edges. Isolated vertices and the endpoint correlations are
included. This is an analytical proof, not a numerical fit or Lean validation;
no novelty or B-level significance is claimed.

## Contents and status

- `research-note.tex`: the full uniform binary exact-marginal theorem for
  simple subcubic graphs and its whole-triple-interval K4 application;
  restricted compensation proofs;
  density-free flat-spectrum comparison with a quantitative bound; component
  and independent-coordinate extensions; a host-dependent mixing bound and a
  nested conditional-expectation theorem allowing interacting spectra;
  an all-six-exponent theorem for every weighted three-state host and a
  one-spike spectral family, with a quantitative bound and constant-host
  equality case; an exact source-dissipation identity;
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
- `KernelEnergyTransportCandidate.lean`, `kernel-transport-checkpoint.json`:
  direct finite kernel-energy identity and coefficient application, with eight
  complete theorem bodies and five definitions. Source-reviewed, **UNCOMPILED**;
  no equivalent energy identity is assumed as a premise. Original-host spectral
  extraction and the remaining graph transports are separate.
- `pass4_checks.py`, `pass4-exact-results.json`: one predetermined sparse
  three-state host, all its 64 identity/rank-one branches, and a second exact
  generic-function obstruction. These are diagnostics, not universal proofs.
- `actual-source-obstruction-pass5.json`: an exact analytical negative
  source term for an actual positive eigenmode of one strictly positive
  common-power host. It refutes modewise positivity, not the full density
  inequality; the historical generic-function obstruction is retained.
- `pass4-review.json`: historical source-bound analytical audit, retained unchanged.
- `pass5-review.json`: current binary proof, actual-source obstruction and
  exact transport-package/resource-stop audit; primary-method overlap and
  analytical/formal-validation boundaries are explicit.
- `exact_checks.py`, `route-diagnostics.json`, `exact-check-results.json`:
  deterministic rational examples and exhaustive 64-subset classification.
  No random campaign or universal conclusion is inferred from the examples.
- `analytical-review.json`, `review-status.json`, `editorial-comparison.json`:
  scoped obligation audit, current claim boundaries and comparison notes.

Run the checks from the repository root:

```sh
python -B review/2026-10-08-rank-three-entropy/exact_checks.py
python -B review/2026-10-08-rank-three-entropy/continuation_checks.py
python -B review/2026-10-08-rank-three-entropy/pass4_checks.py
```

The printed JSON must match each corresponding saved results file as parsed data. Decimal
values are for display; all assertions use exact integer or rational arithmetic.
The four-state negative coefficient refutes only individual coefficient
positivity. All its old and shifted prefixes are positive, and it is not a
counterexample to the density target.

## What remains open

The universal density-free inequality for arbitrary interacting spectra, the
exact-marginal entropy statement for nonuniform binary singletons and arbitrary
finite alphabets, formal validation of the binary theorem, pinned validation of the new
finite transport candidate and original-host kernel/graph extraction, literature
novelty, and significance
remain separate obligations. The coefficient proof now has a real pinned focused
check, not a whole graph theorem or canonical integration. Job66955 completed
with actual child/wrapper/accounting zero; no proof job remains active and the
green focused gate must not be repeated. No novelty or B-level result is claimed.

This is an update to public draft PR55, not a new duplicate PR or a merge. No
live manuscript, PDF, bibliography, accepted source root, private coordination
material or recurring clock is changed by this packet.
