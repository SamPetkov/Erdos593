# A forest-assembly master lemma for Erdős 593

## Scope

This note isolates a finite combinatorial lemma used twice in the Problem 593
proof:

1. in the bridge-block reconstruction of the intrinsic finite structure;
2. in the base-fibre decomposition of a finite trace in the one-apex lift.

The current manuscript proves the two running-intersection statements
separately. The common mechanism is simpler: pieces whose shared-point
incidence graph is a forest can be assembled, and only assembled, by disjoint
unions and one-point amalgamations. Simple cycles remain inside one piece, and
bridges already present in a piece remain bridges after assembly.

This is a proof compression, not a new classification claim. No novelty claim
is made for the abstract finite lemma.

## 1. Piece systems

Let \(K\) be a finite hypergraph. A **piece decomposition** of \(K\) is a finite
family

\[
  \mathscr P=(P_i)_{i\in I}
\]

of subhypergraphs such that

\[
  E(K)=\mathop{\dot\bigcup}_{i\in I}E(P_i),
  \qquad
  V(K)=\bigcup_{i\in I}V(P_i).
\]

Assume throughout that distinct pieces meet in at most one point:

\[
  |V(P_i)\cap V(P_j)|\le 1
  \qquad(i\ne j).
  \tag{1.1}
\]

Let

\[
  S=\{p\in V(K):p\text{ belongs to at least two pieces}\}.
\]

The **piece--point incidence graph** is the finite bipartite graph
\(Q(\mathscr P)\) with classes \(I\) and \(S\), where \(i\) is adjacent to \(p\)
exactly when \(p\in V(P_i)\).

A **running-intersection order** on one connected group of pieces is an order
\(i_1,\ldots,i_t\) such that, for every \(r\ge2\),

\[
  V(P_{i_r})\cap\bigcup_{q<r}V(P_{i_q})
\]

is empty or a singleton.

## 2. Forest-assembly theorem

### Theorem 2.1 (forest assembly)

Under (1.1), the following are equivalent.

1. The piece--point incidence graph \(Q(\mathscr P)\) is a forest.
2. The pieces admit a running-intersection order in every connected component.
3. The hypergraph \(K\) is obtainable from the pieces \(P_i\), with no
   unintended vertex identifications, by finite disjoint unions and one-point
   amalgamations.

Whenever these conditions hold:

4. every Berge cycle of \(K\) is contained in a single piece;
5. every Levi-graph bridge of a piece remains a bridge of \(I(K)\).

Here a one-point amalgamation is taken at a point-node, exactly as in the
Problem 593 manuscript.

### Proof

#### \(1\Rightarrow2\)

Root each component of \(Q(\mathscr P)\) at a piece-node and order the
piece-nodes by nondecreasing distance from the root. Piece-nodes occur at even
distance and shared-point nodes at odd distance.

Let \(i\) be a nonroot piece-node at distance \(2d\), and let \(p_i\) be the
shared-point node immediately preceding \(i\) on the unique path to the root.
Suppose an earlier piece \(j\) meets \(P_i\) in a point \(p\). Then
\(i-p-j\) is a length-two path in \(Q(\mathscr P)\). The point-node \(p\) has
distance either \(2d-1\) or \(2d+1\) from the root. In the second case, every
piece neighbor of \(p\) other than \(i\) has distance \(2d+2\), so it cannot be
earlier. Therefore \(p\) has distance \(2d-1\). Uniqueness of the root path in
a tree gives \(p=p_i\).

Thus every earlier piece meeting \(P_i\) meets it at the same point \(p_i\), and
(1.1) gives

\[
  V(P_i)\cap\bigcup_{j\text{ earlier}}V(P_j)\subseteq\{p_i\}.
\]

A root piece has empty earlier intersection. This is the required order.

#### \(2\Rightarrow3\)

Add the pieces in a running-intersection order. If the next piece has empty
intersection with the previous union, use a disjoint union. If the intersection
is the singleton \(\{p\}\), use a one-point amalgamation at \(p\).

The edge sets of the pieces are disjoint, and the running-intersection condition
shows that the construction identifies exactly the vertices already equal in
\(K\). Induction therefore gives an incidence isomorphism from the assembled
hypergraph onto \(K\).

#### \(3\Rightarrow1\)

Proceed by induction over an assembly of the pieces. The incidence graph of one
piece has no shared-point node and is a forest. Disjoint union preserves this
property.

Suppose a new piece is amalgamated to the previous union at a point \(p\). If
\(p\) already belongs to at least two old pieces, its shared-point node is
already present in \(Q\), and the new piece-node is added as a leaf adjacent to
\(p\). If \(p\) belongs to exactly one old piece \(j\), then \(p\) was not yet a
shared-point node; the update adds the pendant path \(j-p-i\). In either case a
tree is enlarged by a leaf or by a two-edge pendant path, so no cycle is
created. Hence \(Q(\mathscr P)\) is a forest.

#### Cycle localization

It is enough to consider one one-point amalgamation \(A\vee_p B\). Its Levi
graph is the vertex-sum of \(I(A)\) and \(I(B)\) at the point-node \(p\). A
simple cycle using edges from both sides would have to enter and leave each side
through \(p\), and would therefore visit \(p\) twice. This is impossible for a
simple cycle. Hence every Levi cycle, equivalently every Berge cycle, lies in
one factor. Induction over the assembly proves assertion 4.

#### Bridge preservation

Again consider \(A\vee_p B\). Let \(e\) be a bridge of \(I(A)\). If an
alternative path in the amalgamated Levi graph joined the endpoints of \(e\)
after \(e\) was deleted, every excursion into \(I(B)\) would enter and leave at
\(p\). Removing such excursions would give an alternative path in \(I(A)-e\),
contradicting that \(e\) is a bridge. Thus bridges in \(A\) remain bridges, and
the same argument applies to \(B\). Induction proves assertion 5. \(\square\)

## 3. First application: the bridge-block reconstruction

In Proposition 5.2 of the manuscript, delete all Levi bridges and form the
expansion pieces \(P_C\) indexed by active bridge-free components \(C\). The
local part of the proof establishes:

- every hyperedge belongs to exactly one piece;
- the piece vertex sets cover \(V(F)\);
- every piece is isomorphic to \(J_C^+\) for a finite bipartite graph \(J_C\);
- the quotient of bridge-free components is a forest;
- the depth order in that quotient has the running-intersection property.

At this point Theorem 2.1 applies directly. The final manual assembly paragraph
can be replaced by one sentence:

> The active pieces have the running-intersection order supplied by the quotient
> forest. The forest-assembly lemma therefore reconstructs \(F\) from the
> bipartite expansion pieces by disjoint unions and one-point amalgamations.

This keeps the genuinely problem-specific work visible: residual degree
\(0/2\), suppression to bipartite cores, distinct private points, and the
bridge quotient.

## 4. Second application: finite traces in the one-apex lift

For a finite linear trace \(K\subseteq\mathcal L(G)\), let \(K_s\) be the base
fibres. The current proof establishes:

1. every fibre \(K_s\) is an expansion \(J_s^+\);
2. two distinct fibres meet in at most one point;
3. the support-incidence graph of fibres and shared points is a forest.

These are precisely the hypotheses of Theorem 2.1. Therefore Claims 6.3.4 and
6.3.5 can be replaced by a direct invocation of the master lemma:

> The support-incidence graph is a forest, so the fibres admit a
> running-intersection order and assemble by disjoint unions and one-point
> amalgamations.

The two structural conclusions used in the avoidance argument are then
immediate from assertions 4 and 5 of the same lemma:

- the private-point incidence in every \(J_s^+\) remains a Levi bridge in the
  full trace;
- every Berge cycle of the trace lies in one fibre and hence projects, with the
  same length, to a cycle in \(J_s\subseteq G\).

Thus the finite trace theorem and its corollary become one fibre identification,
one intersection lemma, one acyclicity lemma, and one invocation of the forest
assembly theorem.

## 5. Manuscript-level simplification

The proposed main-text dependency becomes

```text
Forest-assembly lemma
        |
        +--> bridge-block pieces + quotient running intersection
        |       -> constructive/intrinsic equivalence
        |
        +--> base fibres + support-incidence forest
                -> finite trace decomposition
                -> bridge persistence and cycle localization
```

This removes duplicated proofs of:

- rooted piece ordering;
- exact assembly without unintended identifications;
- cycle localization under one-point sums;
- bridge persistence under one-point sums.

The copy-ready TeX is in `reader-first/FOREST_ASSEMBLY_MASTER_LEMMA.tex`.

## 6. Terminology boundary

Several inequivalent notions of hypergraph acyclicity occur in the literature.
The manuscript should therefore avoid labelling the piece family simply
`acyclic`. The precise standard graph statement is that the bipartite
piece--point incidence graph is a forest. The conclusion is then stated in the
manuscript's existing language of disjoint unions and one-point amalgamations.

## 7. Exact finite audit

`experiments/verify_forest_assembly_master_lemma.py` performs two independent
checks.

1. It exhaustively enumerates small bipartite piece--point incidence graphs
   satisfying the pairwise-intersection condition and verifies

   ```text
   incidence graph is a forest
     iff
   a running-intersection order exists.
   ```

2. For every accepted incidence graph it builds a synthetic graph assembly with
   one internal cycle per piece and bridge attachments at the shared points. It
   checks that all attachment bridges remain bridges after the pieces are
   identified and that every surviving cycle component uses one piece.

Cyclic incidence graphs are retained as negative controls: the final piece in
any proposed order must meet the earlier union in at least two distinct shared
points.

## 8. Claim boundary

This lemma simplifies two existing arguments. It does not change:

- the definition of obligatory triple system;
- the classification theorem;
- the one-apex lift;
- the imported infinitary host theorems;
- the finite parameter spectrum;
- the Lean endpoints;
- any priority statement.

A later integration PR may place the lemma after the preliminaries and shorten
Proposition 5.2, Theorem 6.3, and Corollary 6.4 accordingly.
