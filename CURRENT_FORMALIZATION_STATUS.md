# Erdős 593 formalization status

Snapshot: 1 October 2026. This is an accepted source checkpoint, not a
claim that the entire extended manuscript is verified.

Final live reconciliation: **passed**. The exact boundary/profile source
checkpoint is accepted following canonical run 66490 and source-only final run
66491. This record certifies the exact source checkpoint; repository
synchronization is recorded by the scoped pull requests and post-merge byte checks.

## Accepted modular and standalone checkpoint

The modular project and generated `formalization/Erdos593SelfContained.lean`
contain **245 internal modules**, 69 external imports and 41,324 standalone lines.
The new source manifest covers 253 files (3,465,834 bytes); the permanent audit
contains 379 ordered declarations.

- Lean 4.32.0, compiler commit `8c9756b28d64dab099da31a4c09229a9e6a2ef35`.
- Mathlib `81a5d257c8e410db227a6665ed08f64fea08e997`; all nine dependency pins fixed.
- Canonical run 66490 used explicit sequential warning-fatal Lean compilation
  of all 245 root-closure modules, followed by the separate permanent audit.
  This was **not a Lake build** and did not reuse old project artifacts.
- The 379 ordered audit records use only standard foundational axioms or subsets.
- Deterministic standalone regeneration and compilation passed.
- Final run 66491 completed with child, wrapper, scheduler and batch exit 0
  in five seconds. It reconciled all 253 source files, nine clean pinned
  dependencies, the actual dependency link, all 508 original records,
  246 generated artifacts and three executed tools. No Lean rebuild occurred.
- Actual final output and accounting were reviewed by root and a separate agent;
  acceptance does not rest on scheduler success alone.

Standalone SHA-256:
`325b14dd3c181b3f37d92b69070ae717e6738db6d4bb4ef1c5fbc0c8fefafae1`.

## Mathematical coverage

The previously synchronized 234-module snapshot remains accepted. It covers the
original finite classification, canonical atom forest and canonicity, finite
parameter/cycle-rank/atom-count spectra, maximizers, finite attachment support,
original-edge supported decomposition and partition-product/lattice interfaces,
the unrestricted classical supported-block characterization, and exact connected
positive-rank atom-deficit accounting. Conditional identification of classical
blocks with unique actual atom labels does not assert core-isomorphism uniqueness.

The accepted addition supplies genuine cycle/theta recognition and the
original-system endpoint `E593AtomicBoundary.obligatory_atomic_alpha_boundary`.
It retains obligatory, reduced, connected and one-point-indecomposable hypotheses,
`s ≥ 4`, `|V| = |E| + s`, and `|E| = s + s % 2`. It concludes an actual
incidence isomorphism to an even cycle expansion or an even positive-length
theta expansion. No supplied core, intrinsicity or desired presentation replaces
the final input hypotheses.

The separate Stage A endpoint `E593Profile.exists_incidence_forest` realizes
an abstract bipartite incidence forest with the prescribed number of components,
positive shared-point excess weights, and at most two attachments per left
vertex. It does **not** yet attach a fixed list of canonical atoms or prove the
resulting vertex/edge/rank identities. `RequestedTheorem` is a definition,
not additional proof evidence.

## Still pending

The retained all-maximal-block running order, genuine graded/profile/capacity
realization and fixed-atom assembly, remaining boundary interfaces,
core-isomorphism uniqueness, exhaustive manuscript crosswalk and external audit
remain separate. The sorted theta half-length convention in the manuscript is
not silently identified with the present unordered three-length witness.

Root acceptance uses the author's self-review authorization. Separate agent
reviews are identified in the evidence history; this is not an external audit.
Research branches and manuscript claims are not promoted wholesale. Manuscript,
bibliography and attribution files are unchanged. No Palomar submission or
whole-paper publication-readiness claim is made.

Final original SHA-256:
`a36ad6b28cbf8c6f588124faea07742e51108ddc7a4663c788ad37c71c94c308`.
Final wrapper SHA-256:
`a11930a7310ee721486b5e6d040255a3935a08f4ef914d5463ce9aae4e6faa7e`.
These identify retained operational originals; machine-path records are not
exported in the public-safe evidence set.

See [validation notes](FORMALIZATION_VALIDATION_BOUNDARY_PROFILE_2026-10-01.md),
[the crosswalk](MANUSCRIPT_LEAN_CROSSWALK.md), and the preserved
[previous accepted validation](FORMALIZATION_VALIDATION_2026-10-01.md).
The read-only `python scripts/check_verified_snapshot.py` checks hashes only.
