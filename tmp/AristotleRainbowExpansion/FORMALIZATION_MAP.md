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
| O5 | `SimpleGraph.copyCompleteBipartiteNN`, `privateVertexExpansionEmbeddingOfCopy`, `privateVertexExpansion_isObligatory_of_completeBipartiteNN` | exact finite Corollary 3.3 reduction proved: every finite two-colourable graph expansion reduces, through isolated-point deletion and restoration, to the universe-compatible family of balanced complete-bipartite expansion atoms |
| O6 | `RainbowBipartite.LocallyBounded`, `RainbowBipartite.IsRainbow`, `exists_rainbow_bipartite_submatrix` | exact manuscript Lemma 3.1 proved by a finite union bound with replacement: for arbitrary colours and positive `n,t`, an explicit finite `q` yields injective `n`-row and `n`-column selections whose `n²` colours are pairwise distinct; compiled under canonical 4.32 |
| O7 | `FiniteOutdegreeColoring.exists_coloring`, `IsObligatory.rootedAbundance`, `IsObligatory.onePointAmalgamation` | exact Section 4 rooted-abundance argument and obligatory closure under one-point amalgamation, including singleton factors, proved under canonical 4.32; an audited full-theorem Aristotle return supplies an independent proof body for the final endpoint |
| O8 | `SequenceLift.system`, `not_isProperColoring_nat`, `aleph0_lt_chromaticCardinal` | the one-apex sequence lift and its chromatic lower bound are proved: a proper countable colouring would recursively generate an `ω₁`-long branch with pairwise distinct colours |

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
`isolatedReduction_constructible_iff_intrinsic` is proved. The remaining
project work lies in the complete-bipartite positive atom, the finite-trace
decomposition, and the infinitary avoidance direction, not in the finite
reconstruction or the one-point closure.

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
