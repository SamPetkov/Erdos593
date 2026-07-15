# Self-Contained Lean Checkpoint

`Erdos593SelfContained.lean` is generated from the exact transitive closure of
the local modules imported by `Erdos593.lean`. It has no project-local imports:
the local source bodies appear in dependency order, while the external Mathlib
imports remain at the top. Every source boundary records a repository-relative
path and the SHA-256 of the normalized UTF-8 source.

The generated file is the current verified **partial formalization**, not yet a
full formal proof of Erdős Problem 593. Its finite structural endpoint is
exactly
`Constructible F.isolatedReduction ↔ F.isolatedReduction.Intrinsic`: generator
and intrinsic-operation preservation, exact active and degree-zero bridge
blocks, the rooted quotient-forest running intersection, and reverse
reconstruction after isolated vertices are removed. It does not yet prove
`Constructible F ↔ F.Intrinsic` for arbitrary `F`, nor a full
obligatoriness classification. It also contains the chromatic-cardinal
interface, finite-deletion and obligatory closure facts, the exact
isolated-vertex reduction for obligatoriness, the all-parameter theorem that
every balanced complete-bipartite expansion atom is obligatory, the resulting
theorem that every constructible triple system is obligatory, the finite
intrinsic-isolated-reduction obligatoriness corollary, exact `Kₙ,ₙ` edge
coordinates, a finite rainbow-bipartite lemma, a non-induced graph-factor
interface, a finite selected-edge endpoint/factor construction, rooted abundance
and obligatory one-point-amalgamation closure, and
the one-apex sequence lift with its countable-colouring obstruction and local
linear-trace rigidity package: extension-letter determinacy, apex-to-edge-letter
collision, and lifted-edge uniqueness up to base-edge orientation. It also
contains the canonical base-node interface: `BasedAt q e` records that `q`
carries two distinct points of `e`, `basedAt_unique` proves uniqueness, the
noncomputable `baseNode e` selects the witness, and `baseNode_mkEdge` recovers
the displayed base of every lift edge. The normal-form bridge additionally
normalizes an arbitrary lift edge at that selector, identifies its exact
two-point graph-base fibre, and proves every non-base fibre is
singleton-or-empty. The canonical base-letter bridge now selects the unique
unordered graph-edge letter at that base and packages `(baseNode, baseLetter)`
as a key injective on every linear edge restriction. On every specified such
restriction, the key image preserves `encard`, is finite exactly when the
restriction is finite, and then has the same `Set.ncard`; a finite linear
no-isolated embedded source consequently has exactly one key per edge. The
base-fibre layer further makes a chosen canonical base node local: its base
letter is injective within that fibre, preserves the fibre's `encard` under
linearity, and identifies an embedded source fibre with its exact source-edge
index subtype. Its source-index layer proves that the fibre, and under
linearity its base-letter image, have the full `ENat.card` of that exact
subtype; it also provides `Nat.card` and, for a finite source, the
corresponding explicit finite cardinal. The support layer proves separately
that canonical base fibres are pairwise disjoint and set-theoretically recover
a selected family over exactly its active base nodes, with finite active
support for finite selected families. The complementary apex layer identifies
the unique point of every lifted edge away from its canonical base and proves
that, inside a linear canonical base fibre, it is private to its edge and
apex-injective. Its fibre-local equivalence layer identifies that same fibre
with its own canonical-apex image, without identifying apexes across fibres
or asserting a global union, cardinality, or trace theorem. The support-index
layer reindexes this partition by the exact
active-base subtype and, for a finite embedded source, supplies a source-edge
surjection and the corresponding active-index cardinal upper bounds. The
finite fibre-cardinality layer proves the exact selected-edge and source-index
sum; its local-letter-sum refinement rewrites that sum as the distinct
base-letter images in separate active fibres and as the trace-key image. It
does not identify base letters across fibres or prove a global finite-trace
decomposition. The tagged base-letter sigma equivalences identify a selected
edge family, and then an embedded source-edge type, with separate local
base-letter images only under a linearity hypothesis. The companion tagged
apex-image sigma equivalence identifies selected edges, and then an embedded
source-edge type, with the separate canonical-apex images of their active
base fibres. The active base-node tag remains present throughout; these
interfaces create neither an untagged global
union nor a cross-fibre identification, and make no cardinality, trace, or
atom claim. The global finite-trace decomposition remains open alongside
reconstruction across isolated vertices and the remaining infinitary avoidance
direction.

## Reproduction and exactness check

From the `formalization` directory:

```text
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
lake env lean Erdos593SelfContained.lean
```

The first command is the only supported way to update the generated file. The
second command exits unsuccessfully if the checked-in artifact differs by even
one byte from deterministic regeneration. The third checks the combined source
against the Lean and Mathlib versions pinned by `lean-toolchain` and
`lake-manifest.json`; run that aggregate command only in a sufficiently
provisioned pinned environment. Routine release validation uses the focused
module checks recorded below.

## Recorded verification (15 July 2026)

- Deterministic regeneration check: passed for 100 source modules, 44 external
  Mathlib imports, 14,654 physical lines, 12,818 nonblank lines, 595,663 UTF-8
  bytes, and SHA-256
  `c346a32719d085cad0d09251272dddaada6bae241a33940f531e30e461c06bed`.
- Canonical focused checks: strict source checks and targeted builds for
  `Erdos593.TripleSystem.CompleteBipartiteAtomObligatory` (1,512 Lake jobs)
  and `Erdos593.TripleSystem.ConstructiblePositiveObligatory` (1,566 Lake
  jobs), plus `Erdos593.TripleSystem.SequenceLiftTrace` (976 Lake jobs),
  `Erdos593.TripleSystem.SequenceLiftBaseNode` (975 Lake jobs),
  `Erdos593.TripleSystem.SequenceLiftBaseNormalForm` (976 Lake jobs), and
  `Erdos593.TripleSystem.SequenceLiftBaseLetter` (979 Lake jobs),
  `Erdos593.TripleSystem.SequenceLiftFiniteTrace` (1,224 Lake jobs), and
  `Erdos593.TripleSystem.SequenceLiftBaseFiber` (1,225 Lake jobs), and
  `Erdos593.TripleSystem.SequenceLiftBaseFiberIndex` (1,226 Lake jobs),
  and `Erdos593.TripleSystem.SequenceLiftBaseFiberPartition` (1,227 Lake
  jobs), and `Erdos593.TripleSystem.SequenceLiftBaseApex` (1,226 Lake jobs),
  and `Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIndex` (1,228 Lake
  jobs), and `Erdos593.TripleSystem.SequenceLiftBaseFiberCardinality` (1,289
  Lake jobs), and `Erdos593.TripleSystem.SequenceLiftBaseFiberTraceSum` (1,290
  Lake jobs), and `Erdos593.TripleSystem.SequenceLiftBaseFiberEquiv` (1,226
  Lake jobs), and
  `Erdos593.TripleSystem.SequenceLiftTaggedBaseLetterEquiv` (1,230 Lake
  jobs), and
  `Erdos593.TripleSystem.SequenceLiftTaggedBaseLetterSourceEquiv` (1,231
  Lake jobs), and `Erdos593.TripleSystem.SequenceLiftBaseApexEquiv` (1,227
  Lake jobs), and `Erdos593.TripleSystem.SequenceLiftTaggedBaseApexEquiv`
  (1,233 Lake jobs), and
  `Erdos593.TripleSystem.SequenceLiftTaggedBaseApexSourceEquiv` (1,234
  Lake jobs),
  passed under the pinned Lean/mathlib `v4.32.0` toolchain.
- Source audit: the complete imported closure, including
  `SequenceLiftBaseNode`, `SequenceLiftBaseNormalForm`, and
  `SequenceLiftBaseLetter`, `SequenceLiftFiniteTrace`, and
  `SequenceLiftBaseFiber`, `SequenceLiftBaseFiberIndex`,
  `SequenceLiftBaseFiberPartition`, `SequenceLiftBaseApex`,
  `SequenceLiftBaseFiberSupportIndex`, `SequenceLiftBaseFiberCardinality`,
  `SequenceLiftBaseFiberTraceSum`, `SequenceLiftBaseFiberEquiv`,
  `SequenceLiftTaggedBaseLetterEquiv`,
  `SequenceLiftTaggedBaseLetterSourceEquiv`, `SequenceLiftBaseApexEquiv`,
  `SequenceLiftTaggedBaseApexEquiv`,
  `SequenceLiftTaggedBaseApexSourceEquiv`, and
  the generated
  artifact are clear of `sorry`, `admit`, project `axiom`, `unsafe`, and
  `sorryAx`; the repository secret scan is also clear.
- Axiom audit: the representative central declarations and the new public
  endpoint declarations listed below report only `propext`, `Classical.choice`,
  and `Quot.sound`.

## Separate axiom audit

No `#print axioms` commands are embedded in the generated artifact. This keeps
packaging separate from audit output and avoids changing the compiled program
merely to select a reporting set. After compiling the generated file, create a
temporary Lean file that imports `Erdos593` and run `#print axioms` for the
central declarations, for example:

```lean
import Erdos593

#print axioms Erdos593.SimpleGraph.two_colorable_iff_every_cycle_even
#print axioms Erdos593.TripleSystem.privateVertexExpansion_linear
#print axioms Erdos593.TripleSystem.OnePointAmalgamation.amalgam
#print axioms Erdos593.TripleSystem.OnePointAmalgamation.isoOfMaps
#print axioms Erdos593.TripleSystem.BridgeBlock.contractedGraph_colorable_two
#print axioms Erdos593.SimpleGraph.bridgeQuotient_isAcyclic
#print axioms Erdos593.TripleSystem.BridgeBlock.activeComponent_privateVertexExpansionData
#print axioms Erdos593.TripleSystem.disjointUnion_intrinsic
#print axioms Erdos593.SimpleGraph.closedStar_earlier_direction
#print axioms Erdos593.TripleSystem.OnePointAmalgamation.amalgam_intrinsic
#print axioms Erdos593.TripleSystem.Constructible.intrinsic
#print axioms Erdos593.TripleSystem.BridgeBlock.isolatedReduction_constructible_iff_intrinsic
#print axioms Erdos593.TripleSystem.IsObligatory.disjointUnion
#print axioms Erdos593.TripleSystem.isObligatory_iff_isolatedReduction
#print axioms Erdos593.RainbowBipartite.exists_rainbow_bipartite_submatrix
#print axioms Erdos593.TripleSystem.IsObligatory.rootedAbundance
#print axioms Erdos593.TripleSystem.IsObligatory.onePointAmalgamation
#print axioms Erdos593.SequenceLift.not_isProperColoring_nat
#print axioms Erdos593.SequenceLift.aleph0_lt_chromaticCardinal
#print axioms Erdos593.SimpleGraph.NonInducedFactor.trans
#print axioms Erdos593.CompleteBipartiteEdges.coords_edge
#print axioms Erdos593.TripleSystem.Constructible.isObligatory_of_completeBipartiteNN
#print axioms Erdos593.TripleSystem.completeBipartiteExpansionAtom_positive_isObligatory
#print axioms Erdos593.TripleSystem.completeBipartiteExpansionAtom_isObligatory
#print axioms Erdos593.TripleSystem.Constructible.isObligatory
#print axioms Erdos593.TripleSystem.intrinsic_isolatedReduction_isObligatory
#print axioms Erdos593.SequenceLift.Node.letter_eq_of_extendsBy_same_target
#print axioms Erdos593.SequenceLift.edgeLetter_eq_of_apex_eq
#print axioms Erdos593.SequenceLift.mkEdge_eq_of_same_basePair_of_linearTrace
#print axioms Erdos593.SequenceLift.mkEdge_eq_of_same_edgeLetter_of_linearTrace
#print axioms Erdos593.SequenceLift.basedAt_unique
#print axioms Erdos593.SequenceLift.baseNode_eq_of_mkEdge_eq
#print axioms Erdos593.SequenceLift.baseNode
#print axioms Erdos593.SequenceLift.baseNode_basedAt
#print axioms Erdos593.SequenceLift.baseNode_mkEdge
#print axioms Erdos593.SequenceLift.exists_mkEdge_at_baseNode
#print axioms Erdos593.SequenceLift.eq_baseNode_iff_exists_distinct_incident
#print axioms Erdos593.SequenceLift.point_eq_of_inc_of_ne_baseNode
#print axioms Erdos593.SequenceLift.exists_basePair_at_baseNode
#print axioms Erdos593.SequenceLift.isBaseLetter_unique
#print axioms Erdos593.SequenceLift.baseLetter_mkEdge
#print axioms Erdos593.SequenceLift.eq_of_traceKey_eq_of_mem_of_linear
#print axioms Erdos593.SequenceLift.traceKey_injOn_of_linear
#print axioms Erdos593.SequenceLift.traceKey_image_finite_iff_of_linear
#print axioms Erdos593.SequenceLift.traceKey_image_encard_eq_of_linear
#print axioms Erdos593.SequenceLift.ncard_traceKey_image_eq_of_linear
#print axioms Erdos593.SequenceLift.finiteLinear_traceKey_image
#print axioms Erdos593.SequenceLift.baseLetter_injOn_baseFiber_of_linear
#print axioms Erdos593.SequenceLift.baseLetter_image_encard_eq_on_baseFiber_of_linear
#print axioms Erdos593.SequenceLift.baseFiber_edgeImage_eq_range
#print axioms Erdos593.SequenceLift.finiteLinear_baseFiber_baseLetter_image
#print axioms Erdos593.SequenceLift.ncard_baseFiber_edgeImage_eq_natCard_baseFiberIndex
#print axioms Erdos593.SequenceLift.encard_baseFiber_edgeImage_eq_baseFiberIndex
#print axioms Erdos593.SequenceLift.encard_baseLetter_image_eq_baseFiberIndex_of_linear
#print axioms Erdos593.SequenceLift.baseFiber_edgeImage_ncard_eq_baseFiberIndex_card
#print axioms Erdos593.SequenceLift.finiteLinear_baseLetter_image_ncard_eq_baseFiberIndex_card
#print axioms Erdos593.SequenceLift.existsUnique_isBaseApex
#print axioms Erdos593.SequenceLift.baseApex
#print axioms Erdos593.SequenceLift.inc_baseApex
#print axioms Erdos593.SequenceLift.isBaseApex_iff_eq_baseApex
#print axioms Erdos593.SequenceLift.baseApex_mkEdge
#print axioms Erdos593.SequenceLift.baseApex_inc_iff_eq_of_linear
#print axioms Erdos593.SequenceLift.baseApex_injOn_baseFiber_of_linear
#print axioms Erdos593.SequenceLift.finite_activeBaseNodeIndex
#print axioms Erdos593.SequenceLift.iUnion_baseFiber_activeBaseNodeIndex
#print axioms Erdos593.SequenceLift.surjective_baseNodeIndexMap
#print axioms Erdos593.SequenceLift.activeBaseNodeIndex_natCard_le_edge_card
#print axioms Erdos593.SequenceLift.activeBaseNodeIndex_card_le_edge_card
#print axioms Erdos593.SequenceLift.ncard_eq_sum_baseFiber_activeBaseNodeIndex
#print axioms Erdos593.SequenceLift.edgeIndexEquiv_sigmaBaseFiberIndex
#print axioms Erdos593.SequenceLift.edgeImage_ncard_eq_sum_baseFiberIndex
#print axioms Erdos593.SequenceLift.edge_card_eq_sum_baseFiberIndex_card
```

For the fibre-local O22 endpoint, a focused audit need not rely on rebuilding
the umbrella module; import its focused module directly:

```lean
import Erdos593.TripleSystem.SequenceLiftBaseFiberTraceSum

#print axioms Erdos593.SequenceLift.ncard_eq_sum_baseLetter_image_activeBaseNodeIndex_of_linear
#print axioms Erdos593.SequenceLift.edgeImage_ncard_eq_sum_baseLetter_image_ncard
#print axioms Erdos593.SequenceLift.edge_card_eq_sum_baseLetter_image_ncard
#print axioms Erdos593.SequenceLift.traceKey_image_ncard_eq_sum_baseLetter_image_ncard
```

The fibre-local O23 equivalence can likewise be audited directly:

```lean
import Erdos593.TripleSystem.SequenceLiftBaseFiberEquiv

#print axioms Erdos593.SequenceLift.baseFiberEquivBaseLetterImage_of_linear
```

The tagged O24 sigma equivalences can be audited independently:

```lean
import Erdos593.TripleSystem.SequenceLiftTaggedBaseLetterEquiv

#print axioms Erdos593.SequenceLift.sigmaBaseFiberEquivSelectedEdge
#print axioms Erdos593.SequenceLift.selectedEdgeEquiv_sigmaBaseLetterImage_of_linear
```

The embedded-source O25 tagged equivalence can also be audited directly:

```lean
import Erdos593.TripleSystem.SequenceLiftTaggedBaseLetterSourceEquiv

#print axioms Erdos593.SequenceLift.edgeIndexEquiv_sigmaBaseLetterImage_of_linear
```

The local O26 apex-image equivalence can also be audited directly:

```lean
import Erdos593.TripleSystem.SequenceLiftBaseApexEquiv

#print axioms Erdos593.SequenceLift.baseFiberEquivBaseApexImage_of_linear
```

The O27 tagged apex-image equivalence can also be audited directly:

```lean
import Erdos593.TripleSystem.SequenceLiftTaggedBaseApexEquiv

#print axioms Erdos593.SequenceLift.selectedEdgeEquiv_sigmaBaseApexImage_of_linear
```

The O28 embedded-source tagged apex-image equivalence can also be audited directly:

```lean
import Erdos593.TripleSystem.SequenceLiftTaggedBaseApexSourceEquiv

#print axioms Erdos593.SequenceLift.edgeIndexEquiv_sigmaBaseApexImage_of_linear
```

In addition to this declaration-level check, scan every source in the local
closure for proof placeholders such as `sorry`, `admit`, `axiom`, `unsafe`, and
`sorryAx`. Standard Mathlib foundations such as propositional extensionality,
classical choice, and quotient soundness are not project-specific axioms.
