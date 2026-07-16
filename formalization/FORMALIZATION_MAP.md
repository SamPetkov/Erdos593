# Finite structural kernel

## Target

For every finite triple system `F`, prove that membership in the constructive
class is equivalent to the intrinsic conditions on the isolated-point reduction
of `F`.

## Planned dependency layers

1. Finite graph infrastructure: bridges, bridge deletion, components, quotient
   forests, bipartiteness, and cycle parity.
2. Triple systems: edges, isolated points, linearity, Levi graphs, embeddings,
   and relabellings.
3. Generators: finite edgeless systems and private-vertex expansions of finite
   bipartite graphs.
4. Operations: finite disjoint union and one-point amalgamation.
5. Forward structural direction: the intrinsic conditions hold for generators
   and are preserved by the operations.
6. Reverse structural direction: delete all Levi bridges, construct expansion
   pieces, prove that the component quotient is a forest, establish the running
   intersection property, and reconstruct by disjoint unions and one-point
   amalgamations.

Each item is first posed to Aristotle as a fixed complete theorem-sized task.
It is split into smaller obligations only after a concrete failure or an
adversarial audit exposes a false or over-strong formulation.

## Current kernel status

| ID | Lean declaration | Status |
|---|---|---|
| G1 | `isBridge_of_adj_of_unique_neighbor` | Aristotle proof accepted after a documented 4.28-to-4.32 bridge-API repair |
| G3/G4 | `bridgeFree_degree_ne_one`, `bridgeFree_degree_eq_zero_or_two` | proved and compiled locally |
| G5 | `two_colorable_iff_every_cycle_even` | independent strong-induction proof accepted under canonical 4.32; Aristotle run retained as an adversarial comparison |
| G6 | `edge_eq_of_bridgeFree_reachable_endpoints_of_isBridge` | proved and compiled locally; supplies quotient-edge uniqueness |
| G7 | `bridgeQuotient`, `bridgeQuotient_isAcyclic` | exact bridge-component quotient forest proved and compiled locally; completed Aristotle return independently confirmed the proof and was rejected as no improvement |
| G8 | `eq_or_bridgeQuotient_adj_of_adj_mem_supp`, `component_eq_or_leviBridgeQuotient_adj_of_inc` | generic closed-star theorem and its Levi-incidence specialization proved and compiled locally |
| G9 | `closedStar_earlier_direction` | rooted-depth separation lemma proved and compiled locally; completed Aristotle return confirmed the statement but its automated proof was less explicit and was not merged |
| B1 | `linear_iff_pairwise_inter_subsingleton` | Aristotle proof accepted unchanged under canonical 4.32 |
| B2 | `levi_edge_neighbor_ncard` | Aristotle proof accepted unchanged under canonical 4.32 |
| R1 | `levi_bridgeFree_edge_degree_eq_zero_or_two` | proved locally from B2 and the generic bridge-free degree theorem; compiled under canonical 4.32 |
| F1 | `privateVertexExpansion_linear` | Aristotle proof accepted after a non-logical 4.32 linter repair |
| F2 | `privateVertexExpansion_bridgeAtEveryEdge` | Aristotle proof accepted unchanged under canonical 4.32 |
| F3/F4 | `privateVertexExpansion_evenBergeCycles`, `privateVertexExpansion_intrinsic` | exact two-colourable-generator parity and complete intrinsic packaging proved locally without a finiteness assumption; completed direct and F3A Aristotle returns independently confirmed the proof, and the redundant F3B cross-check was cancelled to free capacity |
| O1 | `OnePointAmalgamation.amalgam`, `OnePointAmalgamation.isoOfMaps` | explicit quotient construction, factor embeddings, universal map, and reconstruction isomorphism proved locally |
| D1 | `Embedding.disjointUnionInl`, `Embedding.disjointUnionInr`, `disjointUnion_linear` | canonical factor embeddings and preservation of linearity proved locally |
| D2 | `disjointUnionLeviIso`, `disjointUnion_bridgeAtEveryEdge`, `disjointUnion_evenBergeCycles`, `disjointUnion_intrinsic` | Levi-sum identification and preservation of all three intrinsic conditions proved locally and compiled under canonical 4.32; direct and split Aristotle runs retained as independent comparisons |
| R2 | `BridgeBlock.contractedGraph`, `BridgeBlock.contractedGraph_existsUnique_edge` | component contraction and unique tagged-edge witness proved locally |
| R3/R4 | `BridgeBlock.exists_levi_cycle_of_contractedGraph_cycle`, `BridgeBlock.contractedGraph_colorable_two` | doubled-length Levi-cycle lift and parity transfer proved locally; Aristotle independently confirmed the helper obligations, with its alternate file rejected to preserve the canonical API |
| R5/R6 | `BridgeBlock.contractibleEdge_existsUnique_privatePoint`, `BridgeBlock.privatePoint_injective`, `BridgeBlock.inc_iff_bridgeFree_or_privatePoint`, `BridgeBlock.activeComponent_privateVertexExpansionData` | exact private-point and active-component expansion data proved locally and compiled under canonical 4.32; a direct six-proof Aristotle task is retained for independent comparison |
| S1 | `BridgeSelector`, `nonempty_bridgeSelector_iff` | compiled compatibility interface with Li's selected-bridge formulation; the all-bridges decomposition remains the main proof route |
| I1 | `Iso.intrinsic_iff` | all three intrinsic conditions proved invariant under triple-system isomorphism |
| C0 | `Constructible`, `edgeless_intrinsic` | exact inductive constructive class and its edgeless generator formalized |
| O2 | `OnePointAmalgamation.amalgam_linear`, `amalgam_bridgeAtEveryEdge`, `amalgam_evenBergeCycles`, `amalgam_intrinsic` | complete one-point-amalgamation preservation proved and compiled; the cut-vertex cycle boundary was independently checked by Aristotle |
| C1 | `Constructible.intrinsic` | full forward structural direction proved by induction on the exact constructive derivation |
| R7 | `BridgeBlock.graphEdgeEquivHyperedge`, `componentExpansionEmbedding`, `activeComponentExpansionRestrictionIso`, `activeComponentRestriction_constructible` | every active bridge-free component is proved isomorphic to, and constructible as, its exact ambient edge restriction |
| R8 | `edgeRestrictionUnionIsoDisjointUnion`, `edgeRestrictionUnionIsoOnePointAmalgamation`, `RunningEdgeAssembly`, `runningEdgeAssembly_constructible` | exact empty/disjoint/singleton-gluing reconstruction and finite running-union induction proved |
| R9 | `singleEdgePiece_constructible`, `singletonEdgeRestriction_constructible`, `BridgeBlock.degreeZeroComponentRestriction_constructible` | degree-zero bridge-free components proved to be exact constructible one-edge restrictions via a universe-polymorphic `K₂` expansion |
| R10 | `mem_edgeSupportSet_univ`, `edgeRestrictionUnivIso` | exact full-restriction isomorphism prepared for the final no-isolated reverse theorem |
| R11 | `rootedComponentPieceList_runningEdgeAssemblyGeometry`, `hyperedgeComponentRestriction_constructible`, `constructible_of_intrinsic_of_hasNoIsolatedPoints`, `isolatedReduction_constructible_iff_intrinsic` | exact bridge-forest ordering, running intersection, full reverse reconstruction, and finite constructive/intrinsic classification proved |
| O3 | `chromaticCardinal_le_mk_iff`, `aleph0_lt_chromaticCardinal_deleteVertices`, `Embedding.disjointUnionOfDisjoint`, `IsObligatory.disjointUnion` | exact finite-deletion lemma and closure of finite obligatory systems under disjoint union proved |
| O4 | `Embedding.extendIsolatedReduction`, `isObligatory_iff_isolatedReduction` | exact isolated-vertex reduction for finite obligatoriness proved, including extension over finitely many isolated source vertices in an infinite host |
| O5 | `SimpleGraph.copyCompleteBipartiteNN`, `privateVertexExpansionEmbeddingOfCopy`, `privateVertexExpansion_isObligatory_of_completeBipartiteNN` | conditional exact finite Corollary 3.3 reduction proved: assuming every balanced complete-bipartite expansion atom is obligatory, every finite two-colourable graph expansion reduces through isolated-point deletion and restoration to that universe-compatible atom family; O10 now discharges this atom premise |
| O6 | `RainbowBipartite.LocallyBounded`, `RainbowBipartite.IsRainbow`, `exists_rainbow_bipartite_submatrix` | exact manuscript Lemma 3.1 proved by a finite union bound with replacement: for arbitrary colours and positive `n,t`, an explicit finite `q` yields injective `n`-row and `n`-column selections whose `n²` colours are pairwise distinct; compiled under canonical 4.32 |
| O7 | `FiniteOutdegreeColoring.exists_coloring`, `IsObligatory.rootedAbundance`, `IsObligatory.onePointAmalgamation` | exact Section 4 rooted-abundance argument and obligatory closure under one-point amalgamation, including singleton factors, proved under canonical 4.32; an audited full-theorem Aristotle return supplies an independent proof body for the final endpoint |
| O8 | `SequenceLift.system`, `not_isProperColoring_nat`, `aleph0_lt_chromaticCardinal` | the one-apex sequence lift and its chromatic lower bound are proved: a proper countable colouring would recursively generate an `ω₁`-long branch with pairwise distinct colours |
| O9 | `SimpleGraph.NonInducedFactor`, `CompleteBipartiteEdges.coords_edge`, `Constructible.isObligatory_of_completeBipartiteNN` | non-induced graph-factor API, exact balanced-bipartite edge coordinates, and a focused-compiled conditional closure package: the atom hypothesis implies obligatoriness of every constructible system |
| O10 | `completeBipartiteExpansionAtom_positive_isObligatory`, `completeBipartiteExpansionAtom_isObligatory`, `Constructible.isObligatory`, `intrinsic_isolatedReduction_isObligatory` | a classical cardinal-minimal low-pair-closure argument proves every positive balanced `K_{n,n}⁺` expansion atom obligatory; together with the zero atom it proves the all-parameter atom theorem, discharges O5/O9, yields obligatoriness of every constructible triple system, and yields the finite isolated-reduction-intrinsic corollary |
| O11 | `SequenceLift.Node.letter_eq_of_extendsBy_same_target`, `SequenceLift.edgeLetter_eq_of_apex_eq`, `SequenceLift.mkEdge_eq_of_same_basePair_of_linearTrace`, `SequenceLift.mkEdge_eq_of_same_edgeLetter_of_linearTrace` | local finite-trace rigidity advanced: a fixed source/target extension determines its appended letter; coincident apexes over a common base trace determine the underlying graph-edge letter; and, in a linear restriction, the common trace and unordered base edge determine the lifted edge |
| O12 | `SequenceLift.BasedAt`, `SequenceLift.basedAt_unique`, `SequenceLift.baseNode`, `SequenceLift.baseNode_mkEdge` | every sequence-lift edge has a unique node carrying two distinct edge points; the classically selected canonical base node is characterized by `BasedAt` and recovers the displayed base node of every `mkEdge`, giving the finite-trace program a stable edge-grouping index |
| O13 | `SequenceLift.exists_mkEdge_at_baseNode`, `SequenceLift.exists_basePair_at_baseNode`, `SequenceLift.point_eq_of_inc_of_ne_baseNode` | every lift edge admits a representation at its canonical base; there its fibre is exactly the endpoints of one base graph edge, while every non-base fibre is singleton-or-empty, preparing a canonical finite-trace key and arbitrary-edge use of the O11 rigidity package |
| O14 | `SequenceLift.baseLetter`, `SequenceLift.traceKey`, `SequenceLift.traceKey_injOn_of_linear` | each lift edge has one canonical unordered graph-edge letter at its selected base node; the resulting `(baseNode, baseLetter)` key is injective on every linear edge restriction, giving a verified local bridge to later finite-trace cardinality arguments without claiming a global finite-trace decomposition |
| O15 | `SequenceLift.traceKey_image_finite_iff_of_linear`, `SequenceLift.traceKey_image_encard_eq_of_linear`, `SequenceLift.ncard_traceKey_image_eq_of_linear`, `SequenceLift.finiteLinear_traceKey_image` | on a specified linear edge restriction, the canonical trace-key image preserves `Set.encard`, is finite exactly when the restriction is finite, and has the same `Set.ncard` there; a finite linear source with no isolated points contributes exactly one key per edge under an embedding into the sequence lift. These are local transfer facts, not a global finite-trace decomposition |
| O16 | `SequenceLift.baseFiber`, `SequenceLift.baseLetter_injOn_baseFiber_of_linear`, `SequenceLift.baseLetter_image_encard_eq_on_baseFiber_of_linear`, `SequenceLift.baseFiber_edgeImage_eq_range` | each selected canonical base fibre is a local subfamily; within a linear restriction its base letter is injective and preserves `Set.encard`, with finite-`ncard` corollaries; an embedded source fibre is indexed exactly by source edges mapping to that base. This is fibre-local, not a global finite-trace decomposition |
| O17 | `SequenceLift.baseFiberIndex`, `SequenceLift.encard_baseFiber_edgeImage_eq_baseFiberIndex`, `SequenceLift.encard_baseLetter_image_eq_baseFiberIndex_of_linear`, `SequenceLift.finiteLinear_baseLetter_image_ncard_eq_baseFiberIndex_card` | the exact source-edge subtype at one selected canonical base indexes the embedded fibre; its full `ENat.card`, and for a finite source its explicit finite cardinal, agrees with the fibre and with its linear base-letter image. This is a local indexing interface, not a global fibre sum or trace decomposition |
| O18 | `SequenceLift.activeBaseNodes`, `SequenceLift.pairwiseDisjoint_baseFiber`, `SequenceLift.iUnion_baseFiber_activeBaseNodes`, `SequenceLift.finite_activeBaseNodes_edgeImage` | canonical base fibres are pairwise disjoint and set-theoretically recover a selected family over precisely its active base nodes; a finite selected family, hence a finite embedded source image, has finite active support. This intentionally asserts no fibre-cardinality sum or finite-trace decomposition |
| O19 | `SequenceLift.IsBaseApex`, `SequenceLift.baseApex`, `SequenceLift.baseApex_inc_iff_eq_of_linear`, `SequenceLift.baseApex_injOn_baseFiber_of_linear` | every lifted edge has exactly one point away from its canonical base node; inside a linear canonical base fibre that apex is private to its own edge and consequently apex-injective. This is factor-local private-vertex geometry, not a global trace decomposition or fibre-cardinality sum |
| O20 | `SequenceLift.activeBaseNodeIndex`, `SequenceLift.iUnion_baseFiber_activeBaseNodeIndex`, `SequenceLift.baseNodeIndexMap`, `SequenceLift.surjective_baseNodeIndexMap`, `SequenceLift.activeBaseNodeIndex_natCard_le_edge_card` | the active-base subtype reindexes the disjoint fibre partition, with every index labelling a nonempty fibre; for a finite embedded source, source edges map surjectively onto this finite index, yielding `Nat.card` and chosen-`Fintype.card` upper bounds. This is finite support/reindexing only, not a fibre-cardinality sum or global trace decomposition |
| O21 | `SequenceLift.ncard_eq_sum_baseFiber_activeBaseNodeIndex`, `SequenceLift.edgeIndexEquiv_sigmaBaseFiberIndex`, `SequenceLift.edgeImage_ncard_eq_sum_baseFiberIndex`, `SequenceLift.edge_card_eq_sum_baseFiberIndex_card` | the finite selected-edge partition has its exact fibre-cardinality sum; for an embedded finite source its source-edge type is equivalent to the sigma of the exact fibre-index subtypes, yielding the corresponding finite cardinal sum. This does not sum global base-letter images or traces. |
| O22 | `SequenceLift.ncard_eq_sum_baseLetter_image_activeBaseNodeIndex_of_linear`, `SequenceLift.edgeImage_ncard_eq_sum_baseLetter_image_ncard`, `SequenceLift.edge_card_eq_sum_baseLetter_image_ncard`, `SequenceLift.traceKey_image_ncard_eq_sum_baseLetter_image_ncard` | for a finite linear selected family, the exact fibre sum is the sum of distinct base-letter images inside separate active base fibres. For a finite linear no-isolated source, the same sum counts its edge image, source-edge type, and trace-key image. This retains multiplicity across base fibres and neither identifies base letters across fibres nor asserts a global base-letter union or full trace decomposition. |
| O23 | `SequenceLift.baseFiberEquivBaseLetterImage_of_linear` | under a linear restriction, each individual canonical base fibre is explicitly equivalent to its own base-letter image. This packages fibre-local injectivity only: it does not identify equal letters across different fibres, construct a global base-letter union, or assert a trace decomposition. |
| O24 | `SequenceLift.sigmaBaseFiberEquivSelectedEdge`, `SequenceLift.selectedEdgeEquiv_sigmaBaseLetterImage_of_linear` | every selected edge family is equivalent to the sigma of its active canonical base fibres; under linearity, this becomes the sigma of their separate base-letter images. The active base-node tag is retained, so this neither identifies letters across fibres nor constructs an untagged global image or trace decomposition. |
| O25 | `SequenceLift.edgeIndexEquiv_sigmaBaseLetterImage_of_linear` | for an embedded source with a linear selected image, its source-edge type is equivalent to the sigma of the separate base-letter images of the active canonical base fibres. The sigma tag is retained, so no untagged union, cross-fibre identification, finite cardinality, or trace decomposition is asserted. |
| O26 | `SequenceLift.baseFiberEquivBaseApexImage_of_linear` | under a linear restriction, each individual canonical base fibre is explicitly equivalent to the image of its canonical apex map. This packages fibre-local apex injectivity only: it neither identifies apexes across distinct fibres nor asserts a global union, cardinality statement, trace decomposition, or atom claim. |
| O27 | `SequenceLift.selectedEdgeEquiv_sigmaBaseApexImage_of_linear` | under a linear restriction, the selected edge family is equivalent to the sigma of the canonical-apex images of its separate canonical base fibres. The active base-node tag is retained, so this creates neither an untagged union nor cross-fibre apex identification, and it makes no cardinality, trace, or atom claim. |
| O28 | `SequenceLift.edgeIndexEquiv_sigmaBaseApexImage_of_linear` | for an embedded source with a linear selected image, its source-edge type is equivalent to the sigma of the separate canonical-apex images of the active canonical base fibres. The sigma tag is retained, so no untagged union, cross-fibre apex identification, finite cardinality, trace decomposition, or atom claim is asserted. |
| O30 | `SequenceLift.baseFiberIndexEquivBaseApexImage_of_linear` | for one explicitly chosen base node of an embedded source with linear image, the source-edge index subtype in that base fibre is equivalent to that fibre's canonical-apex image. The chosen fibre is preserved; this makes no cross-fibre identification, untagged union, cardinality, trace, or atom claim. |
| O32 | `finiteEdgeEndpointFinset`, `finiteEdgeFactorGraph`, `finiteEdgeFactor`, `exists_finiteEdgeFactor` | every finite selected host-edge set has an explicit finite endpoint type and a canonical `fromEdgeSet` graph admitting a non-induced factor into the host. This records only the factor direction; it does not yet prove exact selected-edge recovery or a private-vertex-expansion isomorphism. |
| O33 | `SequenceLift.inc_iff_baseNode_baseLetter_or_baseApex`, `SequenceLift.baseLetterSubgraph`, `SequenceLift.baseLetterSubgraph_edgeSet`, `SequenceLift.baseLetterSubgraph_finite_verts`, `SequenceLift.baseLetterSubgraphEdgeEquiv` | every lift edge has its exact base-pair-or-apex incidence normal form, and any selected canonical base letters define a host subgraph with exactly those edges, finite endpoint support for a finite selection, and a canonical edge equivalence. This is the local graph-side spine for N1 only; it does not yet construct a non-induced-factor wrapper or prove a private-vertex-expansion isomorphism. |
| O34 | `SequenceLift.baseFiberLetterSubgraph_finite`, `SequenceLift.baseFiberLetterSubgraphFactor`, `SequenceLift.baseFiberLetterSubgraphEdgeEquiv_of_linear`, `SequenceLift.exists_fintype_baseFiberLetterSubgraphFactor` | for a finite selected family and one chosen base node, the graph selected by that base fibre's canonical letters has a finite vertex carrier and an explicit non-induced factor into the host; its factor prefix is also existentially packaged with a `Fintype` carrier. Under linearity, its edges are equivalent to precisely that base fibre. This is still factor-local and does not yet prove the triple-system private-vertex-expansion isomorphism. |
| N1 | `SequenceLift.baseFiber_privateVertexExpansionIso_of_linear`, `SequenceLift.exists_fintype_baseFiberLetterSubgraphFactorExpansionIso_of_linear` | a linear selected base fibre is exactly isomorphic to the private-vertex expansion of the host subgraph selected by its canonical base letters. For finite `S`, the same fixed carrier is packaged with a `Fintype` instance and its canonical non-induced factor into `G`. This is fibre-local: it neither compares distinct fibres nor infers bipartiteness/constructibility, a global trace decomposition, or an atom claim. |
| N2 | `SequenceLift.finite_baseFiberExpansionFactorSpine_of_linear` | a finite linear selected family has a finite active-base index, is exactly the union of pairwise edge-disjoint nonempty canonical base fibres, and each indexed fibre carries N1's finite factor and private-vertex-expansion package. The theorem records the indexed local data only: it does not glue graph factors, identify the selected system with a disjoint union, compare vertex supports or base-letter images across fibres, or make a bipartite/constructibility/atom claim. |
| N3 | `SequenceLift.baseFiber_constructible_of_linear_of_colorable`, `SequenceLift.baseFiber_constructible_of_linear_of_hostColorable` | a finite linear base fibre is constructible provided its canonical base-letter subgraph is two-colourable. The explicit non-induced factor also pulls a two-colouring of the ambient host graph back to that subgraph. Linearity alone supplies no bipartiteness. This remains fibre-local and does not yield a global decomposition or constructibility theorem for the whole selected family. |
| N4 | `SequenceLift.baseFiber_isObligatory_of_linear_of_colorable`, `SequenceLift.baseFiber_isObligatory_of_linear_of_hostColorable` | the same explicitly two-colourable finite linear base fibre is obligatory, by N3 and the completed classical theorem that constructible systems are obligatory; host two-colourability is a derived local sufficient condition. It is a local use of the positive-atom theorem, not a global sequence-lift atom or trace result. |
| N5 | `SequenceLift.baseFiberAssemblyCompatible`, `SequenceLift.edgePieceUnion_baseFiber_eq_of_baseNode_mem`, `SequenceLift.activeBaseNodeList`, `SequenceLift.edgePieceUnion_activeBaseNodeList`, `SequenceLift.baseFiberAssemblyCompatible.runningEdgeAssembly`, `SequenceLift.edgeRestriction_constructible_of_linear_of_hostColorable_of_baseFiberAssembly`, `SequenceLift.edgeRestriction_constructible_of_linear_of_hostColorable_of_baseNodeCover`, `SequenceLift.edgeRestriction_constructible_of_linear_of_hostColorable_of_activeBaseNodeAssembly`, `SequenceLift.edgeRestriction_isObligatory_of_linear_of_hostColorable_of_baseFiberAssembly`, `SequenceLift.edgeRestriction_isObligatory_of_linear_of_hostColorable_of_baseNodeCover`, `SequenceLift.edgeRestriction_isObligatory_of_linear_of_hostColorable_of_activeBaseNodeAssembly` | an explicitly ordered finite family of linear base fibres over a two-colourable host can be glued to an exact constructible, hence obligatory, restriction when its list satisfies the literal running-intersection condition: each new fibre is edge-disjoint from the accumulated tail and has disjoint or singleton-intersecting total vertex support. The finite canonical active-base list now supplies the exact fibre cover automatically. This does not derive that support geometry or its required order from the existing edge-fibre partition. |
| N6 | `SequenceLift.baseFiber_support_inter_subsingleton_of_linear`, `SequenceLift.activeBaseNodeList_pairwise_support_inter_subsingleton_of_linear` | linearity gives the sharp pairwise support geometry: distinct canonical base fibres have at most one common supported point, and the finite canonical active-base enumeration is pairwise singleton-or-empty in that sense. This is not a running-intersection theorem: several separate singleton overlaps can accumulate at one assembly step, so it supplies neither an assembly order nor the N5 compatibility hypothesis. |
| N7 | `SequenceLift.baseFiberSupportTailOverlapCoherent`, `SequenceLift.baseFiberAssemblyCompatible_of_linear_of_nodup_of_supportTailOverlapCoherent` | a noduplicated newest-first list whose nonempty head-to-tail pairwise support intersections all agree is a valid N5 base-fibre running assembly under linearity. This permits multiple fibres to share a single apex, but the coherence/order premise is explicit: finite linearity and the canonical active-base enumeration do not derive it. |
| N8 | `SequenceLift.activeBaseNodeList_nodup`, `SequenceLift.edgeRestriction_constructible_of_linear_of_hostColorable_of_coherentBaseFiberAssembly`, `SequenceLift.edgeRestriction_constructible_of_linear_of_hostColorable_of_coherentBaseNodeCover`, `SequenceLift.edgeRestriction_constructible_of_linear_of_hostColorable_of_activeBaseNodeSupportTailOverlapCoherent`, `SequenceLift.edgeRestriction_isObligatory_of_linear_of_hostColorable_of_coherentBaseFiberAssembly`, `SequenceLift.edgeRestriction_isObligatory_of_linear_of_hostColorable_of_coherentBaseNodeCover`, `SequenceLift.edgeRestriction_isObligatory_of_linear_of_hostColorable_of_activeBaseNodeSupportTailOverlapCoherent` | N7’s explicit coherence bridge now feeds the existing N5 constructible and obligatory endpoints in exact-cover, base-node-cover, and canonical-active-list forms. The local coherence premise remains explicit; these wrappers do not derive it from linearity or claim a global trace reconstruction. |

The representation layer now also contains compiled, gap-free definitions of
non-induced embeddings, triple-system isomorphisms, isolated-point reduction,
the canonical private-vertex expansion, binary disjoint union, explicit
one-point amalgamation, edge restrictions, and the exact constructive class.
A private-vertex expansion of any two-colourable graph satisfies all three
intrinsic conditions without a finiteness assumption.  Disjoint union,
one-point amalgamation, and isomorphism preserve the intrinsic conditions, so
the full forward theorem `Constructible.intrinsic` is now proved.  In the
reverse direction, every active bridge-free component is an exact constructible
edge restriction, degree-zero components are exact constructible one-edge
restrictions, and the rooted bridge-forest ordering supplies the full
`RunningEdgeAssembly`. Consequently the exact finite structural theorem
`isolatedReduction_constructible_iff_intrinsic` is proved.  The positive
complete-bipartite atom and constructible-to-obligatory directions are now
proved as well. The sequence-lift layer now also has its local linear-trace
rigidity package and canonical base-node normal forms: an edge has exactly one
node carrying two distinct edge points, the classical selector agrees with
each displayed `mkEdge` base, its base fibre is exactly one graph pair, and
every other fibre has at most one point. Its canonical trace key is now also
injective on each linear edge restriction and preserves extended natural
cardinality there, with finite and exact-natural-cardinality corollaries for finite
restrictions. The local refinement layers now isolate arbitrary canonical base
fibres, prove their base-letter injectivity and cardinality transfer under
linearity, index each embedded fibre by its exact source-edge subtype, and
partition a selected family over finite active support. The complementary apex
layer identifies the unique non-base point of every lifted edge and proves it
private within a linear canonical base fibre. The finite fibre-cardinality sum
is now proved, and for a finite linear no-isolated source it is also the sum
of the separate local base-letter images and of the trace-key image. Each
individual fibre's local base-letter map is now also packaged as an explicit
equivalence. The local factor spine now also identifies each linear chosen
base fibre with the private-vertex expansion of its canonical base-letter
subgraph, with finite factor packaging when the selected family is finite.
These interfaces still do not identify base letters across distinct base
fibres or assemble them into a global trace decomposition. The
remaining project work lies in reconstruction of a constructible system across
isolated vertices, the global finite-trace decomposition beyond the local
rigidity, grouping, and key steps,
and the infinitary avoidance direction; it is not a gap in the verified
bridge-block reconstruction or one-point closure.

The underlying O9 transfer remains a reusable conditional API, but
`completeBipartiteExpansionAtom_isObligatory` now discharges its premise;
`Constructible.isObligatory` records the unconditional consequence.

The canonical project uses Lean/mathlib `v4.32.0`.  Aristotle currently works
best with `v4.28.0`; therefore results produced in a 4.28 staging project are
accepted only after the unchanged theorem statement and transplanted proof body
compile under 4.32.  In particular, `SimpleGraph.IsBridge` changed semantics
between those versions, so bridge proofs require an explicit compatibility
audit.

## Reverse-direction obligations

After the generic graph kernel, the bridge-block reconstruction is divided into
the following bounded obligations:

1. Each Levi hyperedge-node has bridge-free degree zero or two.
2. A nontrivial bridge-free component contracts to a simple ordinary graph.
3. Cycles in that graph lift length-preservingly to Berge cycles.
4. Even Berge cycles imply that the contracted graph is bipartite.
5. Every hyperedge has a unique third point across a bridge, and these private
   points are pairwise distinct within a component.
6. Each active component therefore determines a private-vertex expansion piece.
7. The quotient by bridge-free connected components is a simple forest.
8. Active pieces containing a fixed point lie in the closed star of its quotient
   component.
9. The rooted-depth lemma forces each new piece to meet the earlier union only at
   its parent attachment point.
10. A finite induction reconstructs the original system by disjoint unions and
    one-point amalgamations.

The contraction object, its unique-edge incidence theorem, the cycle lift, the
bipartiteness transfer, the exact private-vertex expansion of every active
component, and the bridge-component quotient-forest theorem are compiled.
Here Berge length is preserved while Levi length doubles.  Each active
component hyperedge has exactly two surviving core incidences and one
component-external private point, and this now yields a literal isomorphism to
the exact ambient edge restriction, including surjectivity onto its full vertex
support.  The generic closed-star/rooted-depth graph kernels and the exact
finite running-assembly consumer are also complete.  The hyperedge-containing
components are now enumerated in parent-after-child list order, their edge sets
partition the ambient edge type, their support intersections are empty or a
single parent attachment point, and the active/degree-zero split makes every
listed restriction constructible.  The finite reverse direction is therefore
closed without an unverified structural block.
