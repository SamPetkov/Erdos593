# Erdős 593 manuscript-to-Lean crosswalk

Snapshot: 1 October 2026. The exact 245-module source checkpoint passed canonical
compilation and final live reconciliation 66491. This record certifies the exact
source checkpoint; repository synchronization is recorded by the scoped pull
requests and post-merge byte checks.
The prior 234-module snapshot remains accepted. This compact map does not replace
an exhaustive statement-by-statement audit of the extended manuscript.

| Mathematical role | Lean endpoint or module | Status |
|---|---|---|
| Original finite classification | `isObligatory_iff_isolatedReduction_intrinsic`; `isObligatory_iff_constructible_isolatedReduction` | Previously accepted |
| Canonical atom forest/reconstruction and canonicity | `canonicalAtom_reconstruction`; `exists_canonicityTransport` | Previously accepted |
| Finite parameter and cycle-rank spectra | `exists_obligatory_fixed_order_iff`; `exists_obligatory_cycleRank_iff` | Previously accepted |
| Connected atom-count spectrum and maximizers | `exists_connected_atom_count_iff`; `exists_maximum_atom_count`; `every_maximizer_structure` | Previously accepted; separate explicit uniqueness interface excluded |
| Quantitative deficit accounting | `connected_atom_deficit_accounting` | Previously accepted; connected, positive actual rank and explicit additive deficit |
| Original-edge decomposition/product and standard lattice bounds | `obligatory_supported_decomposition_product`; `obligatory_supported_standard_product`; `obligatory_supported_has_bounds` | Previously accepted |
| Unrestricted classical supported-block characterization | `SupportedBlocks.isObligatory_iff_forall_supportedBlock_allowed` | Previously accepted; no intrinsicity premise |
| Classical blocks as unique canonical labels | `SupportedBlocks.supportedBlock_iff_canonicalAtom` | Previously accepted under intrinsicity; exact original edge set, not core-isomorphism uniqueness |
| Original-carrier minimum atomic cycle/theta boundary | `E593AtomicBoundary.obligatory_atomic_alpha_boundary` | Accepted exact checkpoint |
| Abstract attachment-profile incidence forest, Stage A | `E593Profile.exists_incidence_forest` | Accepted exact checkpoint |
| Fixed canonical-atom capacity-safe assembly and parameter preservation | Retained capacity-safe profile lemma | Open; Stage A is only its graph skeleton |
| All-maximal-block running order, grading and full factorization-lattice spectrum | Separate retained statements | Open; product and graph skeleton do not discharge the whole result |
| Entire extended manuscript and release | Exhaustive statement/evidence crosswalk | Incomplete |

The new atomic endpoint assumes arbitrary common finite carriers, obligatoriness,
reducedness, connectedness, one-point indecomposability, `s ≥ 4`,
`|V| = |E| + s` and `|E| = s + s % 2`. It derives its actual core and an
incidence-preserving cycle or theta normal form. The theta witness consists of
three positive even lengths summing to `s + 1`; a sorted half-length convention
requires a separate permutation/normalization bridge. This does not newly certify
every assertion of the manuscript's structural-boundary corollary or a converse.

Stage A assumes `1 ≤ c ≤ k`, positive weights on `Fin t` and total weight
`k - c`. It supplies an acyclic actual bipartite incidence graph with exactly
`c` components, left degree at most two, and right degree `weight + 1`.
The empty weight family is included when `k = c`. Realization by a fixed atom
list, choice of distinct ports and preservation of original-system parameters
remain open obligations.

See [status](CURRENT_FORMALIZATION_STATUS.md) and
[validation](FORMALIZATION_VALIDATION_BOUNDARY_PROFILE_2026-10-01.md).
The original classification does not acquire a gap because a later extension
is unfinished; its proof does not certify every later manuscript result.
Manuscript text, chronology and literature attribution remain unchanged.
