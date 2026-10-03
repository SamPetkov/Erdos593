# Erdős 593 manuscript-to-Lean crosswalk

Snapshot: 3 October 2026. Exact piece-accounting source
`bc36a54a0239a5c46d52752d7125d3259d7dd38a` passed canonical 66494 and final live
source-only reconciliation 66495: 246 modules and 383 permanent audits.
Actual push, merge and post-merge byte readback are recorded separately, not
certified by this source packet. This compact source map is not an exhaustive
statement-by-statement audit of the extended manuscript.

| Mathematical role | Lean endpoint or module | Status |
|---|---|---|
| Original finite classification | `isObligatory_iff_isolatedReduction_intrinsic`; `isObligatory_iff_constructible_isolatedReduction` | Previously accepted |
| Canonical atom forest/reconstruction and canonicity | `canonicalAtom_reconstruction`; `exists_canonicityTransport` | Previously accepted |
| Finite parameter and cycle-rank spectra | `exists_obligatory_fixed_order_iff`; `exists_obligatory_cycleRank_iff` | Previously accepted |
| Connected atom-count spectrum and maximizers | `exists_connected_atom_count_iff`; `exists_maximum_atom_count`; `every_maximizer_structure` | Previously accepted; separate explicit uniqueness interface excluded |
| Quantitative deficit accounting | `connected_atom_deficit_accounting` | Previously accepted; connected, positive actual rank and explicit additive deficit |
| Original-edge decomposition/product and standard lattice bounds | `obligatory_supported_decomposition_product`; `obligatory_supported_standard_product`; `obligatory_supported_has_bounds` | Previously accepted; not a cover/grading endpoint |
| Unrestricted classical supported-block characterization | `SupportedBlocks.isObligatory_iff_forall_supportedBlock_allowed` | Previously accepted; no intrinsicity premise |
| Classical blocks as unique actual canonical labels | `SupportedBlocks.supportedBlock_iff_canonicalAtom` | Previously accepted under intrinsicity; exact original edge sets, not core-isomorphism uniqueness |
| Original-carrier minimum atomic cycle/theta boundary | `E593AtomicBoundary.obligatory_atomic_alpha_boundary` | Previously accepted exact checkpoint |
| Abstract attachment-profile incidence forest, Stage A | `E593Profile.exists_incidence_forest` | Previously accepted; not fixed-atom realization |
| Accepted product coordinate and full supported-piece accounting | `CanonicalAtom.supportedDecompositionProduct_apply_eq`; `CanonicalAtom.supportedPartitions_full_block_card_accounting` | Accepted exact piece-accounting checkpoint |
| Nonshared piece incidence and shared-coordinate accounting | `CanonicalAtom.nonshared_piece_incidence_card`; `CanonicalAtom.supportedPartitions_block_card_accounting` | Accepted exact piece-accounting checkpoint |
| Covers, actual-piece grading and maximal-chain lengths | Separate retained grading statements | Open; piece counting and maximum height alone do not prove grading |
| Fixed canonical-atom capacity-safe assembly and parameter preservation | Retained capacity-safe profile lemma | Open; Stage A is only its graph skeleton |
| Retained all-maximal-block running order and full factorization-lattice spectrum | Separate retained interfaces | Open; an existing canonical running assembly is not the entire retained export |
| New manuscript cyclic-budget and sharp piece-count corollaries | New exact Lean endpoints needed | Mathematically source-reviewed; not newly Lean-accepted |
| Entire extended manuscript and release | Exhaustive statement/evidence crosswalk | Incomplete |

The four new theorem names use namespace
`Erdos593.TripleSystem.CanonicalAtom`. Their module is
`Erdos593.TripleSystem.SupportedPieceAccountingCandidate`; the name and historical
candidate header are preserved byte-for-byte. The accepted finite intrinsic
piece-count identity uses original edge-partition quotient cardinality and actual
`CanonicalAtom.Index`, rather than assembly-list counts. It requires neither
reducedness, globally connected parent nor nonempty-edge hypotheses. Genuine
component and local-quotient transports are part of the accepted module.

The atomic endpoint retains arbitrary finite carriers, obligatoriness,
reducedness, connectedness, one-point indecomposability, `s >= 4`,
`|V| = |E| + s` and `|E| = s + s % 2`. It derives an actual cycle/theta
incidence isomorphism. The theta witness has three positive even lengths summing
to `s + 1`; a sorted half-length convention requires a separate normalization
bridge. No core-isomorphism uniqueness or every-manuscript-boundary claim follows.

Stage A assumes `1 <= c <= k`, positive weights on `Fin t` and total weight
`k - c`. It constructs an acyclic actual bipartite relation with `c` components,
left degree at most two and right degree `weight + 1`. The empty weight family
is included when `k = c`. Distinct ports, geometry on the fixed atom list,
intrinsic admission, original-system parameters and actual canonical labels
remain separate obligations.

Root adoption is **independent=false** under explicit author authorization;
full external audit remains pending. No new proof run or reviewer is inferred
from delivery. Separate retained 048 integration and the complete release
crosswalk are still open. The original classification remains accepted even
while later extensions are unfinished.

See [status](CURRENT_FORMALIZATION_STATUS.md),
[piece validation](FORMALIZATION_VALIDATION_PIECE_ACCOUNTING_2026-10-02.md) and
[preceding validation](FORMALIZATION_VALIDATION_BOUNDARY_PROFILE_2026-10-01.md).
This source delivery does not modify the manuscript, bibliography or attribution.
