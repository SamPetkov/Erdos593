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

Each item will be split into theorem-sized Aristotle tasks whose statements are
fixed before submission.

## Current kernel status

| ID | Lean declaration | Status |
|---|---|---|
| G1 | `isBridge_of_adj_of_unique_neighbor` | Aristotle proof accepted after a documented 4.28-to-4.32 bridge-API repair |
| G3/G4 | `bridgeFree_degree_ne_one`, `bridgeFree_degree_eq_zero_or_two` | proved and compiled locally |
| G5 | `two_colorable_iff_every_cycle_even` | independent strong-induction proof accepted under canonical 4.32; Aristotle run retained as an adversarial comparison |
| G6 | `edge_eq_of_bridgeFree_reachable_endpoints_of_isBridge` | proved and compiled locally; supplies quotient-edge uniqueness |
| G9 | `closedStar_earlier_direction` | proved and compiled locally |
| B1 | `linear_iff_pairwise_inter_subsingleton` | Aristotle proof accepted unchanged under canonical 4.32 |
| B2 | `levi_edge_neighbor_ncard` | Aristotle proof accepted unchanged under canonical 4.32 |
| R1 | `levi_bridgeFree_edge_degree_eq_zero_or_two` | proved locally from B2 and the generic bridge-free degree theorem; compiled under canonical 4.32 |
| F1 | `privateVertexExpansion_linear` | Aristotle proof accepted after a non-logical 4.32 linter repair |
| F2 | `privateVertexExpansion_bridgeAtEveryEdge` | Aristotle proof accepted unchanged under canonical 4.32 |
| O1 | `OnePointAmalgamation.amalgam`, `OnePointAmalgamation.isoOfMaps` | explicit quotient construction, factor embeddings, universal map, and reconstruction isomorphism proved locally |
| D1 | `Embedding.disjointUnionInl`, `Embedding.disjointUnionInr`, `disjointUnion_linear` | canonical factor embeddings and preservation of linearity proved locally |
| R2 | `BridgeBlock.contractedGraph`, `BridgeBlock.contractedGraph_existsUnique_edge` | component contraction and unique tagged-edge witness proved locally |
| R3/R4 | `BridgeBlock.exists_levi_cycle_of_contractedGraph_cycle`, `BridgeBlock.contractedGraph_colorable_two` | doubled-length Levi-cycle lift and parity transfer proved locally; Aristotle independently confirmed the helper obligations, with its alternate file rejected to preserve the canonical API |

The representation layer now also contains compiled, gap-free definitions of
non-induced embeddings, triple-system isomorphisms, isolated-point reduction,
the canonical private-vertex expansion, binary disjoint union, and explicit
one-point amalgamation. These declarations are scaffold, not yet a proof of the
forward or reverse classification.

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

The contraction object, its unique-edge incidence theorem, the cycle lift, and
the bipartiteness transfer are now compiled.  Here Berge length is preserved
while Levi length doubles.  The quotient-forest theorem and the final
reconstruction induction are kept as separate tasks: combining them would hide
the largest graph-theoretic proof obligation inside the hypergraph construction.
