# Erdős 593 manuscript-to-Lean crosswalk

Source-delivery preparation: 3 October 2026. Exact four-module source
`51c7fa59619f88dacc010a934fda1fde441655b8` passed canonical 66570 and final
source-only reconciliation 66573: 250 modules / 401 permanent audits.
Acceptance SHA-256: `21ae71b360bf270915064398bc5b7044266e0d31ce57726dac32d36c90eb47bd`. This compact map is not an exhaustive
statement-by-statement audit of the extended manuscript. Push, merge and actual
post-merge byte readback are recorded separately.

| Mathematical role | Lean endpoint or module | Status |
|---|---|---|
| Original finite classification | `isObligatory_iff_isolatedReduction_intrinsic`; `isObligatory_iff_constructible_isolatedReduction` | Previously accepted |
| Canonical atom forest/reconstruction and canonicity | `canonicalAtom_reconstruction`; `exists_canonicityTransport` | Previously accepted |
| Finite parameter and cycle-rank spectra | `exists_obligatory_fixed_order_iff`; `exists_obligatory_cycleRank_iff` | Previously accepted |
| Connected atom-count spectrum and maximizers | `exists_connected_atom_count_iff`; `exists_maximum_atom_count`; `every_maximizer_structure` | Previously accepted; separate core-isomorphism uniqueness excluded |
| Connected quantitative deficit | `connected_atom_deficit_accounting` | Previously accepted under exact connected positive-rank hypotheses |
| Original-edge decomposition/product and standard lattice bounds | `obligatory_supported_decomposition_product`; `obligatory_supported_standard_product`; `obligatory_supported_has_bounds` | Previously accepted |
| Unrestricted classical supported-block characterization | `SupportedBlocks.isObligatory_iff_forall_supportedBlock_allowed` | Previously accepted without an intrinsicity premise |
| Classical blocks as unique actual canonical labels | `SupportedBlocks.supportedBlock_iff_canonicalAtom` | Previously accepted under intrinsicity; exact original edge sets |
| Original-carrier minimum atomic cycle/theta boundary | `E593AtomicBoundary.obligatory_atomic_alpha_boundary` | Previously accepted; sorted half-length normalization separate |
| Abstract capacity-two attachment-profile forest | `E593Profile.exists_incidence_forest` | Previously accepted Stage A, not fixed-atom realization |
| Actual product coordinate and supported-piece counting | `supportedDecompositionProduct_apply_eq`; `supportedPartitions_full_block_card_accounting`; `nonshared_piece_incidence_card`; `supportedPartitions_block_card_accounting` | Previously accepted exact original-edge accounting |
| Finite partition covers | `E593FiniteSetoid.covBy_iff_quotient_card` and six prerequisite lemmas | Accepted four-module checkpoint; finite carriers, no nonemptiness assumption |
| Supported covers and unique changed coordinate | `supportedPartitions_covBy_iff`; `supportedPartitions_covBy_iff_exists_unique`; `supportedPartitions_standard_covBy_iff`; `obligatory_supportedPartitions_covBy_iff` | Accepted in the supported subtype, not an ambient-cover assertion |
| Actual-piece additive deficit | `supportedProduct_block_card_le`; `supportedPieceDeficit_eq_sum`; `supportedPieces_add_deficit` | Accepted; actual `CanonicalAtom.Index` and original-edge quotient cardinalities |
| Strict piece monotonicity and one-step grading | `supportedPartitions_block_card_strict_antitone`; `supportedPartitions_block_card_of_covBy`; `supportedPartitions_covBy_iff_block_card`; `supportedPartitions_covBy_iff_piece_deficit` | Accepted; converse criteria retain strict comparability |
| Equal maximal-chain lengths, flags and exact height | Separate retained endpoints | Not certified by this four-module packet |
| Fixed canonical-atom capacity-safe assembly | Distinct ports, forest geometry, intrinsic admission and label transport | Not certified; Stage A alone is insufficient |
| All-maximal-block running order and full retained spectrum | Separate retained interfaces | Not certified by this packet |
| New manuscript rank-resolved counting, merger monotonicity and Boolean criterion | Exact original-system endpoints needed | Proposals are not converted into Lean acceptance by this delivery |
| Retained 048 and complete manuscript/release crosswalk | Separate integration and exhaustive audit | Pending |

The project declarations use namespace `Erdos593.TripleSystem.CanonicalAtom`;
generic finite-setoid declarations use `E593FiniteSetoid`. All four proof sources
remain byte-identical to the accepted focused packet, including their historical
candidate headers. Exact theorem types and the actual deficit definition were
reviewed in the preserved focused output; canonical audit records match them.

Relation inclusion is refinement, so upward movement coarsens the partition.
The local product is indexed by actual original shared points, with actual
canonical-atom stars as factor carriers. The standardized version changes only
each factor carrier to `Fin pointMultiplicity`; it keeps the original point index.
Cover transport uses an order isomorphism of `SupportedPartitions F` itself;
a supported-subtype cover is not silently treated as a full partition-lattice cover.

The exact deficit is `Nat.card (CanonicalAtom.Index F) - Nat.card D.val.Block`.
Local surjective quotient bounds and accepted piece accounting prove the necessary
inequalities before natural subtraction. No assembly-list count replaces either
actual cardinality. The intrinsic general result permits empty edges, isolated
points and disconnected parents; an empty shared-point product is a singleton
and has no strict comparable pair or cover.

This source packet contains 18 new declarations and one deficit definition. It
does not export the pending chains/flags/height, theta, running-order, geometry,
component-spectrum or other candidate sources. Root adoption is honestly
**independent=false**; the full external audit remains pending. The whole extended
manuscript is incomplete even though the original classification stays accepted.

See [status](CURRENT_FORMALIZATION_STATUS.md),
[covers validation](FORMALIZATION_VALIDATION_COVERS_GRADING_2026-10-03.md) and
[preceding piece validation](FORMALIZATION_VALIDATION_PIECE_ACCOUNTING_2026-10-02.md).
This delivery does not change the manuscript, bibliography or attribution.
