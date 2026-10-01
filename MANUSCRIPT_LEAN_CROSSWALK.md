# Erdős 593 manuscript-to-Lean crosswalk

Snapshot: 1 October 2026. The synchronized source manifest, rather than the
age of a draft PR, determines the verified scope. This is a compact current map;
an exhaustive statement-by-statement check of the extended manuscript remains open.

| Mathematical role | Representative Lean endpoint or module | Current status |
|---|---|---|
| Original finite classification | `isObligatory_iff_isolatedReduction_intrinsic`; `isObligatory_iff_constructible_isolatedReduction` | Verified |
| Canonical atom forest and reconstruction | `canonicalAtom_reconstruction`; `CanonicalAtomForestReconstruction.lean` | Verified |
| Atom canonicity | `exists_canonicityTransport`; `CanonicalAtomCanonicity.lean` | Verified |
| Finite parameter and cycle-rank spectra | `exists_obligatory_fixed_order_iff`; `exists_obligatory_cycleRank_iff` | Verified |
| Connected atom-count spectrum and maximizers | `exists_connected_atom_count_iff`; `exists_maximum_atom_count`; `every_maximizer_structure` | Verified; separate explicit uniqueness checkpoint excluded |
| Quantitative atom-deficit accounting | `connected_atom_deficit_accounting` | Verified for connected systems of positive actual rank with explicit additive deficit; actual atom count and core-order slack, not assembly-list counts |
| Literal original-edge decomposition/product | `obligatory_supported_decomposition_product` | Verified |
| Standard partition-product and lattice bounds | `obligatory_supported_standard_product`; `obligatory_supported_has_bounds` | Verified |
| Unrestricted classical supported-block characterization | `SupportedBlocks.isObligatory_iff_forall_supportedBlock_allowed` | Verified; unrestricted finite statement, no Intrinsic premise |
| Classical blocks as unique canonical atom labels | `SupportedBlocks.supportedBlock_iff_canonicalAtom` | Verified under `Intrinsic F`; unique actual label with exactly the original edge set |
| Retained all-maximal-block running order | Separate exact interface | Open; label identification does not supply an ordering |
| Grading, attachment profile/capacity realization and later enumeration | Separate retained manuscript statements | Open; existing product is not the whole result |
| Atomic/theta original-carrier boundary endpoints | Supplied candidate branch | Not fully accepted |
| Entire extended manuscript and final release | Exhaustive statement/evidence crosswalk | Incomplete |

All verified rows refer to the 234-module snapshot detailed in
[CURRENT_FORMALIZATION_STATUS.md](CURRENT_FORMALIZATION_STATUS.md).
Only standard foundational axiom dependencies were admitted in the permanent
ordered audit. No hypothesis weakening, assumed `Intrinsic` converse, or
assembly-list count was substituted for the intended original-carrier statements.

The original classification does not acquire a gap merely because a later
extension is unfinished. Conversely, its completed formalization does not certify
every later manuscript result. Existing literature attribution is unchanged.
