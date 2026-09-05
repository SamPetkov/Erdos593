# Direction 1 — Functorial canonical atom forest

## Status

The canonical atom normal form is already present in the manuscript: every reduced obligatory triple system has a canonical hyperedge partition into atoms, each atom is either one triple or `J^+` for a finite 2-connected simple bipartite graph `J`, and the atom--shared-point incidence graph is a forest.

This note pushes strictly beyond that statement. The new content is a functorial reconstruction theorem, an isomorphism criterion, and an automorphism exact sequence.

Throughout, `F` is a finite reduced obligatory triple system. Let `A(F)` be its canonical atom set. Let

`S(F) = {p in V(F) : p belongs to at least two canonical atoms}`.

Define the bipartite graph `Q(F)` with vertex classes `A(F)` and `S(F)`, with `A--p` when `p in V(A)`. By the canonical atom theorem, `Q(F)` is a forest; its connected components are the connected components of `F`.

## Theorem A — functorial canonical atom forest

Let `F,G` be finite reduced obligatory triple systems and let `phi : F -> G` be a triple-system isomorphism. Then:

1. `phi` sends canonical atoms of `F` bijectively to canonical atoms of `G`;
2. `phi(S(F)) = S(G)`;
3. the assignments

   `A -> phi(A)` and `p -> phi(p)`

   induce a unique bipartite forest isomorphism

   `Q(phi) : Q(F) -> Q(G)`;

4. `Q(id_F)=id_{Q(F)}` and `Q(psi o phi)=Q(psi)oQ(phi)`.

Hence `F -> Q(F)` is functorial on the groupoid of finite reduced obligatory triple systems and isomorphisms.

### Proof

The canonical atom partition is defined intrinsically from the Levi graph: cyclic atoms come from cyclic Levi blocks and all-bridge hyperedges give the singleton atoms. An isomorphism of triple systems induces a bipartition-preserving Levi-graph isomorphism. Graph isomorphisms preserve bridges, cyclic blocks, and incidence. Therefore the atom edge sets are carried bijectively to the canonical atom edge sets of `G`.

A point belongs to at least two atoms precisely when its image does, so shared points are preserved. Incidence `p in V(A)` is preserved by `phi`, giving `Q(phi)`. Uniqueness is immediate because the images of both vertex classes have already been prescribed. Identity and composition follow from the corresponding properties of the underlying point and hyperedge maps.

## Theorem B — exact reconstruction and uniqueness among irreducible forest assemblies

Let

`D(F) = disjoint union over A in A(F) of a private copy of A`.

For every shared point `p`, identify all copies of `p` occurring in atoms incident with the shared-point node `p` of `Q(F)`. Make no other identifications. The resulting quotient is canonically isomorphic to `F`.

Moreover, suppose `F` is expressed as a forest assembly of connected one-point-indecomposable obligatory pieces whose hyperedge sets partition `E(F)`. Then those pieces are exactly the canonical atoms of `F`, and its piece--shared-point incidence forest is `Q(F)`.

### Proof

Distinct canonical atoms meet in at most one point. Every point appearing in two or more atoms is represented by a unique shared-point node of `Q(F)`. Therefore the quotient identifies exactly those atom-vertex copies that are equal in `F`, and no other pair. The edge sets were already a partition of `E(F)`, so the quotient map is an isomorphism.

For the second statement, each proposed piece is one-point indecomposable and obligatory. By the indecomposable classification in the manuscript, it is one triple or `J^+` for a finite 2-connected simple bipartite graph `J`. A one-point amalgamation is a vertex-sum of Levi graphs, so a simple Levi cycle cannot cross from one piece to another. Hence every cyclic Levi block of `F` lies in a single piece, and every all-bridge hyperedge of a single-triple piece remains all-bridge in the assembly. The canonical atom extractor therefore recovers exactly the proposed pieces. Since shared points are actual vertices of `F`, their incidence forest is then forced and equals `Q(F)`.

This is the precise uniqueness statement useful for the paper: not merely that one decomposition exists, but that every decomposition into irreducible obligatory factors agrees with the canonical one.

## Theorem C — isomorphism reduction to a decorated forest

Let `F,G` be finite reduced obligatory triple systems. Then `F ~= G` if and only if there exist:

1. a bipartite forest isomorphism `theta : Q(F) -> Q(G)` carrying atom nodes to atom nodes and shared-point nodes to shared-point nodes; and
2. for every atom `A` of `F`, an atom isomorphism

   `f_A : A -> theta(A)`

   such that for every shared point `p in V(A)`,

   `f_A(p) = theta(p)`.

### Proof

Necessity is Theorem A. Conversely, the local maps agree on every overlap because every overlap is a shared point and the compatibility condition prescribes the same image there. Theorem B allows the local maps to glue to a global vertex bijection. The atom edge sets partition the hyperedges, so the glued map preserves and reflects every hyperedge.

## Theorem D — automorphism exact sequence

For an atom `A`, let

`P_A = S(F) intersect V(A)`

be its set of ports, and define

`K_A = Aut(A; P_A pointwise)`.

Let `Aut_dec(Q(F))` be the group of bipartite forest automorphisms `theta` of `Q(F)` for which every atom node `A` admits a port-compatible atom isomorphism `A -> theta(A)`.

Restriction to atoms and shared points gives a surjective homomorphism

`pi : Aut(F) -> Aut_dec(Q(F))`

with kernel

`ker(pi) ~= product_{A in A(F)} K_A`.

Consequently

`|Aut(F)| = |Aut_dec(Q(F))| * product_A |K_A|`.

### Proof

If a global automorphism acts trivially on `Q(F)`, it fixes every atom set and every shared point. Its restrictions are therefore independent elements of the pointwise port-fixing groups `K_A`; conversely such local automorphisms glue because they agree on all overlaps. This identifies the kernel.

By definition of `Aut_dec(Q(F))`, for every decorated forest automorphism `theta` choose one compatible local atom isomorphism on each atom. The local maps agree on shared points and therefore glue by Theorem B to a global automorphism inducing `theta`. Hence `pi` is surjective. The finite group-order formula follows.

No canonical splitting is asserted. A semidirect-product statement would require coherent choices of local lifts and is deliberately not claimed here.

## Algorithmic corollary

The canonical atom partition and the forest `Q(F)` can be extracted using the existing Levi-bridge/cyclic-block algorithm in linear time after linearity has been checked. Thus:

- recognition and canonical decomposition are certificate-producing;
- global isomorphism reduces to decorated-forest isomorphism plus port-marked atom isomorphisms;
- automorphism counting reduces to the decorated forest action and the local port-fixing automorphism groups.

This does not make the local atom-isomorphism problem trivial: a single atom already contains an arbitrary finite 2-connected bipartite core. The theorem isolates the global tree-like part rather than claiming a new worst-case bound for graph isomorphism.

## Suggested main-manuscript integration

The main paper should not import this whole note. After the canonical atom theorem, add one compact proposition:

> The canonical atom forest is functorial under isomorphisms and is the unique forest decomposition into one-point-indecomposable obligatory factors. Consequently two reduced obligatory systems are isomorphic exactly when their decorated atom forests are isomorphic through port-compatible atom isomorphisms.

The automorphism exact sequence is better placed in an appendix or follow-up note unless space permits.

## Remaining work

1. Independent hostile review of Theorems B--D.
2. Formalize the atom/shared-point forest in Lean.
3. Prove functoriality and reconstruction in Lean.
4. Decide whether the automorphism statement belongs in the main 593 paper or a structural follow-up.
5. Literature check against canonical decomposition frameworks for hypergraphs and incidence structures before making a novelty claim.
