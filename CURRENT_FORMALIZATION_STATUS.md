# Erdős 593 formalization status

Snapshot: 30 September 2026. This page describes the synchronized, validated
Lean source snapshot, not a claim that the entire extended manuscript is verified.

## Verified and synchronized source

The modular project and generated `formalization/Erdos593SelfContained.lean`
contain **232 internal modules**, 62 external imports and 39,403 standalone lines.
The source manifest covers 240 files (3,304,049 bytes); the permanent audit contains
325 ordered declarations. Both repositories carry the same manifest and proof bytes.

- Lean 4.32.0, compiler commit `8c9756b28d64dab099da31a4c09229a9e6a2ef35`.
- Mathlib `81a5d257c8e410db227a6665ed08f64fea08e997`; all nine dependency pins checked.
- Warning-fatal all-root build: 3,363 jobs, exit 0.
- All 325 ordered axiom records use only `propext`, `Classical.choice`,
  `Quot.sound`, or subsets.
- Deterministic standalone regeneration and compilation passed.
- Final live source, dependency-link, pin, original-evidence and process-exit
  reconciliation passed.

Standalone SHA-256:
`8e8b8fe53deb405793419fbf2227337ec70e72ebda2b4b9753f89b5790325667`.

The original finite classification is complete. The verified extensions now include
the canonical atom forest and canonicity, finite parameter/cycle-rank/atom-count
spectra, maximizer structure, finite attachment support, and original-edge supported
decomposition and standard partition-product/lattice interfaces, and the unrestricted
classical supported-block characterization.

The latest combined integration was reviewed by Codex under the author's explicit
self-review authorization. This is **not an external independent audit**; that
audit remains pending. Earlier independent reviews are retained in project history.

## Still pending

The unrestricted classical-block equivalence now passed both focused and full
canonical/standalone checks, followed by final live reconciliation. It covers
empty, disconnected and isolated-point cases without an assumed `Intrinsic`
converse. The separate explicit uniqueness checkpoint remains outside this snapshot.

Exact classical-block/canonical-atom labels, the retained running-order interface,
graded rank/profile/capacity results, remaining atomic/theta original-carrier
endpoints and the complete extended-manuscript crosswalk remain open.

Draft manuscript and research branches are not silently promoted by this source
synchronization. Existing attribution and manuscript files are preserved. No
Palomar submission or whole-paper publication-readiness claim is made.

## Reproduce and inspect

See [validation notes](FORMALIZATION_VALIDATION_2026-09-30.md) and the
[manuscript crosswalk](MANUSCRIPT_LEAN_CROSSWALK.md).
Run `python scripts/check_verified_snapshot.py` for a read-only source/evidence
hash check. That script is not a replacement for Lean compilation.
