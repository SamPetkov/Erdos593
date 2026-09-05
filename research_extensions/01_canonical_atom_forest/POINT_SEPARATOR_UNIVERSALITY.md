# Point separators and the universal one-point decomposition

## Status and purpose

The manuscript already proves that every finite reduced obligatory triple system has a canonical atom partition and an atom--shared-point incidence forest.  This note identifies that structure intrinsically in terms of **one-point separation**, proves a universal refinement theorem for *all* one-point forest decompositions, and identifies the complete decomposition poset with a classical connected-partition (bond) lattice.

The main new structural slogan is

```text
canonical atoms = maximal edge sets inseparable by deleting one point.
```

This is stronger than merely constructing the atoms from cyclic Levi blocks: it characterizes them by a universal property that does not mention the construction.

Throughout, `F` is a finite reduced obligatory triple system.  Its canonical atom set is `A(F)`.  The canonical bipartite atom--shared-point forest is `Q(F)`.

The graph-theoretic language of block/cut decompositions and connected partition lattices is classical.  The contribution considered here is the exact specialization to the obligatory-triple-system atoms and the resulting universal factorization statement.  No priority claim is made for block-cut trees or bond lattices themselves.

---

## 1. Edge-support point separators

Let `I(F)` be the Levi graph.  Write

```text
kappa_E(F)
```

for the number of connected components of `I(F)` that contain at least one hyperedge-node.  Since `F` is reduced, this is just the number of connected components of `F`, but the notation is useful after a point is deleted.

For a point `p`, let `I(F)-p` mean deletion of the point-node `p` and all its incident Levi edges, while every hyperedge-node is retained.

### Definition 1.1 — edge-articulation point

A point `p` is an **edge-articulation point** if

```text
kappa_E(F-p) > kappa_E(F).
```

Equivalently, deleting `p` separates hyperedge-nodes that were previously in one edge-support component.

This definition deliberately ignores separation that would matter only to isolated point-nodes; the canonical decomposition is a decomposition of the hyperedge support.

### Theorem 1.2 — shared points are exactly edge-articulation points

For a finite reduced obligatory triple system `F`,

```text
p belongs to at least two canonical atoms
    iff
p is an edge-articulation point.
```

#### Proof

Every canonical atom is one-point indecomposable.  For a single-triple atom this is immediate.  For a cyclic atom `J^+`, it is the already-proved classification of one-point-indecomposable obligatory systems, with `J` finite, simple, bipartite and 2-connected.  Thus deleting one point from one atom never separates that atom's hyperedge-nodes into two edge-support components.

Suppose first that `p` is shared by at least two canonical atoms.  In `Q(F)`, the shared-point node `p` has degree at least two.  Removing it disconnects the incident atom branches because `Q(F)` is a forest.  By exact reconstruction, any path in the Levi graph from an edge in one branch to an edge in another must pass through an overlap between consecutive atoms, and the unique branch connection at this cut is the point `p`.  Hence `I(F)-p` separates those hyperedge-nodes and `p` is an edge-articulation point.

Conversely suppose that `p` belongs to only one atom `A`.  Deleting `p` leaves the hyperedge-nodes of `A` in one component because `A` is one-point indecomposable.  All other atoms attach to `A` only through shared points different from `p`; the canonical forest therefore retains exactly the same connections between atom branches.  Hence deletion of `p` does not increase the number of edge-support components.  So `p` is not an edge-articulation point.

This proves the equivalence.

### Consequence

The shared-point set can be defined without first mentioning the atom construction:

```text
S(F) = { p : deleting p increases the edge-support component count }.
```

This is the correct one-point separator set for the canonical factorization.

---

## 2. Point-inseparability recovers the atom partition

### Definition 2.1 — point-inseparable hyperedges

For hyperedges `e,f` of `F`, write

```text
e ~_F f
```

when

1. `e` and `f` lie in the same connected component of `I(F)`; and
2. for every point `p` of `F`, the hyperedge-nodes `e` and `f` remain in the same connected component of `I(F)-p`.

Thus no deletion of one point separates `e` from `f`.

### Theorem 2.2 — canonical atoms are the point-inseparability classes

The relation `~_F` is an equivalence relation, and its equivalence classes are exactly the canonical atom edge sets.

Equivalently, the canonical atoms are precisely the maximal nonempty edge-supported subsystems whose hyperedge-nodes cannot be separated from one another by deleting a single point.

#### Proof

Take two hyperedges in the same canonical atom `A`.  Deleting a point outside `A` cannot separate them.  Deleting a point of `A` also cannot separate them because `A` is one-point indecomposable.  Therefore every two hyperedges of `A` are `~_F`-equivalent.

Now take hyperedges `e` and `f` in distinct canonical atoms but in the same connected component of `F`.  The unique path in the canonical forest `Q(F)` from the atom containing `e` to the atom containing `f` contains at least one shared-point node `p`.  Removing `p` separates the two sides of this tree path.  Exact reconstruction then shows that `e` and `f` lie in different components of `I(F)-p`.  Hence they are not `~_F`-equivalent.

Hyperedges in different connected components are excluded by condition 1.  Therefore the `~_F`-classes are exactly the canonical atom edge sets.  In particular `~_F` is an equivalence relation.

### Why this reformulation matters

The original cyclic-block construction is the efficient way to *compute* the atoms.  The point-inseparability theorem explains what they *are*: the unique 1-sum-prime edge blocks under point adhesion.

This also provides a useful independent certificate interface.  To prove two hyperedges belong to different atoms it suffices to exhibit one point whose deletion separates them.

---

## 3. Universal refinement theorem

We now remove the assumption that the pieces in a proposed decomposition are themselves canonical, obligatory, or indecomposable.

### Definition 3.1 — one-point forest decomposition

A **supported one-point forest decomposition** of `F` consists of a partition

```text
E(F) = E_1 dot-union ... dot-union E_t
```

into nonempty sets such that, writing `P_i` for the supported subsystem on `E_i`:

1. every `P_i` is connected;
2. two distinct pieces meet in at most one point; and
3. the bipartite incidence graph between pieces and points belonging to at least two pieces is a forest.

No assumption of obligatoriness is imposed on the pieces.

### Theorem 3.2 — canonical atoms refine every one-point forest decomposition

Let `(P_i)` be any supported one-point forest decomposition of `F`.  Then every canonical atom of `F` is contained in a unique piece `P_i`.

Hence the canonical atom partition is the **unique finest supported one-point forest decomposition** of the hyperedge set.

#### Proof

Suppose a canonical atom `A` were split between two distinct pieces `P_i` and `P_j`.  Choose hyperedges `e` and `f` of `A` lying in different pieces.  The piece--shared-point incidence forest has a unique path from `P_i` to `P_j`.  Let `p` be the first shared-point node on that path when leaving `P_i`.

Deleting `p` separates the piece incidence forest at that edge.  Because the pieces meet only at the recorded shared points, any Levi path from the `P_i` side to the `P_j` side would induce an alternative path in the piece incidence graph, contradicting acyclicity.  Thus `p` separates `e` from `f` in `I(F)-p`.

But Theorem 2.2 says that two hyperedges in the same canonical atom are not separated by deleting any point.  Contradiction.  Therefore each canonical atom lies wholly inside one piece.  Uniqueness of that containing piece follows from the edge partition.

### Corollary 3.3 — irreducible uniqueness without an obligatoriness hypothesis on competitors

If every piece of a supported one-point forest decomposition is itself one-point indecomposable, then the pieces are exactly the canonical atoms.

Indeed Theorem 3.2 writes each piece as a union of canonical atoms.  A connected union of two or more canonical atoms has a shared point separating its edge support and is therefore one-point decomposable.

This strengthens the earlier uniqueness statement: the competing irreducible factors need not be assumed obligatory in advance.

---

## 4. The atom intersection block graph

Define the **atom intersection graph** `B(F)` by

```text
V(B(F)) = A(F),
A -- A'  iff  V(A) intersect V(A') is nonempty.
```

Two distinct canonical atoms meet in at most one point, so every edge of `B(F)` has a unique shared-point label.

For a shared point `p`, let

```text
C_p = { A in A(F) : p in V(A) }.
```

### Proposition 4.1 — `B(F)` is a block graph

The atom intersection graph `B(F)` is a block graph.  Its maximal cliques of size at least two are exactly the sets `C_p`, one for each shared point `p`.

#### Proof

Each `C_p` is a clique.  Two distinct such cliques meet in at most one atom: if two atoms both contained two distinct shared points, those atoms would meet in two points, contrary to the canonical atom theorem.

More strongly, any cycle of `B(F)` that uses adjacency edges coming from more than one shared point would lift to a cycle in the bipartite atom--shared-point incidence graph `Q(F)`.  Since `Q(F)` is a forest, every 2-connected block of `B(F)` is contained in a single `C_p`, and that block is complete.  Conversely each edge of `B(F)` lies in its unique clique `C_p`.  Thus all graph blocks are cliques and `B(F)` is a block graph, with the stated maximal cliques.

### Interpretation

`Q(F)` and `B(F)` carry the same global gluing information in two familiar forms:

- `Q(F)` is the atom/shared-point incidence forest;
- `B(F)` is its atom-side half-square, a block graph whose clique blocks are the shared points.

The incidence forest is better for proofs; the block graph is better for connected-partition language.

---

## 5. Classification of every one-point decomposition

A set partition `Pi` of `A(F)` is called **connected in `B(F)`** if every block `X` of `Pi` induces a connected subgraph `B(F)[X]`.

For such a block `X`, let `F_X` be the subsystem formed by the union of the hyperedges of the atoms in `X`.

### Theorem 5.1 — all one-point decompositions are connected atom partitions

The assignments

```text
supported one-point forest decomposition of F
    -> partition of A(F) by the atoms contained in each piece
```

and

```text
connected set partition Pi of B(F)
    -> pieces { F_X : X in Pi }
```

are mutually inverse.

Consequently, ordered by refinement, the poset of supported one-point forest decompositions of `F` is canonically isomorphic to the connected-partition lattice (bond lattice) of `B(F)`.

#### Proof

For the forward map, Theorem 3.2 shows that every piece is a union of whole canonical atoms.  Since the piece is connected, those atoms form a connected subgraph of `B(F)`.

Conversely let `Pi` be a partition of the atom set into blocks connected in `B(F)`.  Each union `F_X` is connected: a path in `B(F)[X]` is a sequence of atoms in `X` meeting successively at shared points.

Consider two distinct blocks `X,Y`.  Their unions cannot meet in two different points `p,q`.  Otherwise connected paths inside `X` and inside `Y`, together with the incidences at `p` and `q`, would produce a cycle in `Q(F)`.  Hence two pieces meet in at most one point.

Finally suppose the resulting piece--shared-point incidence graph had a cycle.  Choose a shortest such cycle.  For each piece on the cycle, connectivity of its atom set supplies a path in `Q(F)` joining the two boundary shared points using only atoms of that piece.  Because the cycle was chosen shortest, nonconsecutive lifted paths cannot meet at an additional shared point; such a meeting would give a chord and a shorter cycle in the piece incidence graph.  Concatenating the lifted paths therefore produces a cycle in `Q(F)`, contradiction.  Thus the piece incidence graph is a forest.

The two constructions clearly undo each other, proving the bijection and the refinement-poset statement.

### Corollary 5.2 — decomposition polynomial

Let `d_j(F)` be the number of supported one-point forest decompositions of `F` into exactly `j` connected pieces.  If

```text
Q_B(x) = sum_j q_j(B(F)) x^j
```

is the classical connected-set-partition polynomial of the atom intersection graph, then

```text
sum_j d_j(F) x^j = Q_B(x).
```

This is a translation to a classical graph invariant, not a claim of a new graph polynomial.

### Literature boundary

Connected set partitions and the bond lattice are standard.  See, for example, F. Simon, P. Tittmann and M. Trinks, *Counting Connected Set Partitions of Graphs*, Electronic Journal of Combinatorics 18 (2011), P14, DOI 10.37236/501.  The point here is that **all one-point decompositions of an obligatory triple system are controlled by the bond lattice of its canonical atom block graph**.

---

## 6. Canonical center and rooted recursion

Assume now that `F` is connected.  Then `Q(F)` is a finite tree, so it has a canonical center: either one node or one edge.

### Corollary 6.1 — canonical decomposition center

Every automorphism of `F` fixes the center of `Q(F)` setwise.  More precisely:

- if the center is an atom node, that canonical atom is setwise fixed by every automorphism;
- if the center is a shared-point node, that point is fixed by every automorphism;
- if the center is an edge `A--p`, then both `A` and `p` are individually fixed, because automorphisms preserve the atom/shared-point bipartition.

Thus every connected obligatory system has an intrinsic center object that can be used to root recursive reconstruction and canonization.

This is a standard center property of trees, but it becomes useful because the canonical atom forest is functorial.

---

## 7. Algorithmic and formalization consequences

The point-separator theorem does not require an inefficient all-points deletion algorithm in an implementation.  The existing Levi bridge / cyclic-block extractor already obtains the canonical atoms in linear graph time after the incidence structure and linearity checks have been prepared.

The new results give additional certificate semantics:

1. a shared point is exactly an edge-support articulation point;
2. to certify that two edges belong to different atoms, exhibit one separating point;
3. the canonical atom partition is a certificate that every other one-point forest decomposition is a coarsening;
4. every coarsening is encoded by a connected partition of the block graph `B(F)`.

For Lean, the highest-value sequence is:

1. define edge-support point separation;
2. prove canonical atoms are point-inseparability classes;
3. package the universal refinement theorem;
4. define `B(F)` and prove it is a block graph;
5. only then formalize functoriality and the decorated-forest isomorphism theorem.

This route gives a construction-independent specification of the atom partition, which should make later uniqueness statements cleaner.

---

## 8. Exact finite audit

`experiments/verify_point_separator_universality.py` independently checks the new statements.

The committed deterministic run covers:

- 5,000 random forest assemblies;
- 20,231 source canonical atoms;
- 72,807 hyperedges;
- 134,425 point-separator checks;
- 745,222 pairwise point-inseparability checks;
- 5,000 atom-intersection block-graph checks;
- 56 small systems subjected to exhaustive edge-partition search;
- 9,352 edge partitions examined;
- 249 valid one-point forest decompositions recovered;
- 842 universal-refinement containment checks; and
- 249 connected atom partitions checked in the converse direction.

The audit uses single triples, `C4^+`, `C6^+`, and `K_{2,3}^+`, including higher-multiplicity shared points.

Finite verification is evidence for the implementation and statement interfaces; the general result rests on the proofs above.

---

## 9. Manuscript recommendation

For the main Erdős 593 paper, the strongest compact addition is not the full bond-lattice discussion.  A useful insertion is one proposition immediately after the canonical atom theorem:

> **Universal canonical one-point factorization.**  The canonical atoms are exactly the maximal hyperedge sets inseparable by deletion of one point.  They form the unique finest supported one-point forest decomposition.  Every other such decomposition is obtained by grouping canonical atoms into connected blocks of the atom intersection graph.

This statement makes the normal form feel like a genuine unique factorization theorem.  The block-graph/bond-lattice, automorphism and complexity consequences are better kept in an appendix or structural follow-up unless the main paper has room.
