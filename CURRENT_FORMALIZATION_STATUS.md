# Erdős 593 formalization status

Snapshot: 1 October 2026. This page describes the synchronized, validated
Lean source snapshot, not a claim that the entire extended manuscript is verified.

## Verified and synchronized source

The modular project and generated `formalization/Erdos593SelfContained.lean`
contain **234 internal modules**, 62 external imports and 39,659 standalone lines.
The source manifest covers 242 files (3,325,820 bytes); the permanent audit contains
330 ordered declarations. Both repositories carry the same manifest and proof bytes.

- Lean 4.32.0, compiler commit `8c9756b28d64dab099da31a4c09229a9e6a2ef35`.
- Mathlib `81a5d257c8e410db227a6665ed08f64fea08e997`; all nine dependency pins checked.
- Warning-fatal all-root build: 3,365 jobs, exit 0.
- All 330 ordered axiom records use only `propext`, `Classical.choice`,
  `Quot.sound`, or subsets.
- Deterministic standalone regeneration and compilation passed.
- Final live source, dependency-link, pin, original-evidence and process-exit
  reconciliation passed.

Standalone SHA-256:
`0e423b3b08d91897aa873d9b6eaf6217473022bd993d034629847f62babfb0b7`.

The original finite classification is complete. The verified extensions now include
the canonical atom forest and canonicity, finite parameter/cycle-rank/atom-count
spectra, maximizer structure, finite attachment support, and original-edge supported
decomposition and standard partition-product/lattice interfaces, and the unrestricted
classical supported-block characterization. Under `Intrinsic F`, each classical
supported block is now identified with a unique actual canonical-atom label
having exactly its original edge set. This conditional identification does not
add an `Intrinsic` premise to the unrestricted characterization, nor assert
uniqueness of a core isomorphism type.

The verified atom-deficit theorem adds an exact accounting identity for connected
systems of positive cycle rank. Using actual canonical atom labels, the number
of positive-rank atoms plus total excess core order is at most the deficit plus
one. Its explicit hypotheses and additive deficit equation are preserved in
`connected_atom_deficit_accounting`; this does not supply the pending profile
realization or core-isomorphism uniqueness results.

The latest combined integration was reviewed by Codex under the author's explicit
self-review authorization. This is **not an external independent audit**; that
audit remains pending. Earlier independent reviews are retained in project history.

## Still pending

The unrestricted classical-block equivalence now passed both focused and full
canonical/standalone checks, followed by final live reconciliation. It covers
empty, disconnected and isolated-point cases without an assumed `Intrinsic`
converse. The separate explicit uniqueness checkpoint remains outside this snapshot.

The retained all-maximal-block running-order interface,
graded rank/profile/capacity results, remaining atomic/theta original-carrier
endpoints and the complete extended-manuscript crosswalk remain open.

Draft manuscript and research branches are not silently promoted by this source
synchronization. Existing attribution and manuscript files are preserved. No
Palomar submission or whole-paper publication-readiness claim is made.

## Reproduce and inspect

See [validation notes](FORMALIZATION_VALIDATION_2026-10-01.md) and the
[manuscript crosswalk](MANUSCRIPT_LEAN_CROSSWALK.md).
Run `python scripts/check_verified_snapshot.py` for a read-only source/evidence
hash check. That script is not a replacement for Lean compilation.
