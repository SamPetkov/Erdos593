# A uniform bridge-block theorem for expanded bipartite hypergraphs

**Status:** proved finite structural theorem and certificate algorithm; stacked on
the experimental PR. The theorem concerns the generated class
\(\mathcal B_r\). It does **not** settle the classification of all obligatory
\(r\)-uniform hypergraphs when \(r\ge 4\).

## 1. Definitions

Fix an integer \(r\ge 2\). For a finite simple graph \(J\), let \(J^{(r)}\)
denote the \(r\)-uniform expansion obtained by adjoining \(r-2\) new private
vertices to every edge of \(J\). Let \(\mathcal B_r\) be the smallest class of
finite \(r\)-uniform hypergraphs that

1. contains \(J^{(r)}\) for every finite bipartite graph \(J\);
2. contains every finite edgeless system; and
3. is closed under finite disjoint unions and one-point amalgamations.

For a hypergraph \(F\), write \(I(F)\) for its Levi graph. A Berge cycle of
length \(\ell\) is a cycle of length \(2\ell\) in \(I(F)\). Write \(F^\circ\)
for the result of deleting isolated vertices.

## 2. Uniform bridge-block theorem

### Theorem A

For every finite \(r\)-uniform hypergraph \(F\), the following are equivalent.

1. \(F^\circ\in\mathcal B_r\).
2. \(F^\circ\) is linear, every hyperedge-node of \(I(F^\circ)\) is incident
   with at least \(r-2\) bridges, and every Berge cycle of \(F^\circ\) has even
   length.

For \(r=2\), this is the usual characterization of bipartite graphs. For
\(r=3\), it is the finite constructive/intrinsic theorem used in the Problem
593 classification. The content here is that the **finite bridge-block
equivalence itself is uniform in \(r\)**.

### Proof

It is enough to work without isolated vertices.

#### Forward implication

An expansion \(J^{(r)}\) of a simple bipartite graph is linear. Every expanded
hyperedge has \(r-2\) private vertices, and each corresponding Levi incidence
is a bridge. Its Berge cycles correspond, preserving length, to ordinary
cycles of \(J\), so they are even.

Disjoint union preserves all three conditions. In a one-point amalgamation,
edges from different factors meet only at the identified point, so linearity is
preserved. A bridge inside either factor remains a bridge in the one-vertex
sum. Finally, a simple Levi cycle cannot pass through both factors: it would
have to visit the identified point twice. Hence every Berge cycle remains
inside one factor and is even.

#### Reverse implication: delete every Levi bridge

Let \(B\) be the set of bridges of \(I(F)\), and put

\[
I_0:=I(F)-B.
\]

At a hyperedge-node \(e\), at most two incidences remain in \(I_0\), because
at least \(r-2\) of its \(r\) incidences are bridges.

The remaining degree of \(e\) cannot be one. Every nonbridge edge of a finite
graph lies on a cycle, and a cycle entering the node \(e\) through one
incidence must leave through another. Thus every hyperedge-node has degree

\[
0\quad\text{or}\quad 2
\]

in \(I_0\).

#### Active components are graph subdivisions

Let \(C\) be a component of \(I_0\) containing a hyperedge-node of degree two.
For each such node \(e\), let \(u_e,v_e\) be its two point-neighbours in \(C\).
Suppress the hyperedge-nodes and define an ordinary graph \(J_C\) with edges

\[
u_ev_e\qquad(e\in E_C),
\]

where \(E_C\) is the set of hyperedges represented in \(C\).

The graph \(J_C\) is simple. A loop is impossible, and two parallel edges
would mean that two hyperedges of \(F\) contain both of the same two points,
contrary to linearity.

Every cycle of \(J_C\) lifts to a Berge cycle of the same length in \(F\), and
every Berge cycle supported in \(C\) suppresses to a cycle of \(J_C\).
Consequently all cycles of \(J_C\) are even, so \(J_C\) is bipartite.

For each \(e\in E_C\), the other \(r-2\) vertices of \(e\) are private inside
this piece. Indeed, suppose that such a point \(p\) belonged to two
hyperedges \(e,f\in E_C\). Since \(e\) and \(f\) are connected inside \(C\),
the path in \(C\) between their hyperedge-nodes, together with
\(e-p-f\), would form a cycle containing the supposedly bridging incidence
\(ep\), a contradiction.

Therefore the hypergraph piece supported by \(C\) is exactly

\[
J_C^{(r)}.
\]

#### Zero-degree hyperedge-nodes

If a hyperedge-node has degree zero in \(I_0\), all of its incidences are
bridges. The single hyperedge is an expansion \(K_2^{(r)}\), after choosing
any two of its \(r\) vertices as the graph core. It is therefore another
allowed atom.

#### Reassembly

Contract every component of \(I_0\) in \(I(F)\). Since the deleted edges were
precisely the bridges, the resulting graph is a forest.

Root each tree. Point-only components act as articulation points. Traverse
the forest away from the root and add the edge-containing pieces in that
order. A new piece meets the union of the preceding pieces in exactly the
point at the parent bridge. If it met the earlier union in a second point,
the two connections together with paths inside the piece and the earlier
union would create a cycle containing a deleted bridge.

Thus the pieces admit a running-intersection order in which every step is a
one-point amalgamation. The pieces are bipartite expansions or one-edge
expansions, so \(F\in\mathcal B_r\). This proves Theorem A. \(\square\)

## 3. Canonical decomposition and recognition

The proof gives a certificate-producing recognition algorithm for fixed
\(r\).

1. Check linearity by inserting every vertex pair from each hyperedge into a
   hash table.
2. Build the Levi graph and find all bridges by a Tarjan depth-first search.
3. Check that every hyperedge-node has at least \(r-2\) incident bridges.
4. Delete all bridges.
5. In every active component, suppress its degree-two hyperedge-nodes and test
   the resulting ordinary graph for bipartiteness.
6. Record the expansion pieces and the attachment forest.

For fixed \(r\), the running time is linear in the size of the incidence
representation. More explicitly, the linearity test takes \(O(mr^2)\), and
all subsequent graph operations take \(O(n+rm)\).

The active bridge blocks are canonical. A one-edge all-bridge atom has a
noncanonical choice of two core points, but this choice does not affect class
membership, the attachment forest, or any cycle invariant.

## 4. A cycle-preserving bipartite shadow

### Theorem B

Let \(F\in\mathcal B_r\) have no isolated vertices, \(m\) hyperedges, \(n\)
vertices, and \(c\) connected components. There is a finite bipartite graph
\(J\), without isolated vertices, and a bijection

\[
\varphi:E(F)\longrightarrow E(J)
\]

such that

\[
|E(J)|=m,\qquad |V(J)|=n-(r-2)m,
\]

\(J\) has \(c\) connected components, and a set of hyperedges is the edge set
of a Berge cycle in \(F\) if and only if its image is the edge set of an
ordinary cycle in \(J\).

#### Proof

Apply Theorem A and write each component of \(F\) as a tree of expansion
pieces \(J_i^{(r)}\). Cycles cannot cross a one-point amalgamation, so the
Berge-cycle system of \(F\) is the direct sum of the ordinary cycle systems of
the \(J_i\).

Take arbitrary one-vertex sums of the bipartite graphs \(J_i\) along the same
number of forest edges, swapping bipartition classes before a gluing when
necessary. One-vertex sums create no new cross-piece cycles. The evident
edge bijections therefore combine into \(\varphi\). Counting vertices gives

\[
|V(J)|=\sum_i |V(J_i)|-(k-c)=n-(r-2)m.
\]

\(\square\)

Hence the Berge-cycle sets of \(F\) are the circuits of a bipartite graphic
matroid. Conversely every finite bipartite graphic matroid is realised by
\(J^{(r)}\).

## 5. Exact finite parameter consequences

Put

\[
q(t)=\left\lceil2\sqrt t\right\rceil.
\]

A connected bipartite graph with \(t\ge1\) edges has every order from
\(q(t)\) through \(t+1\), and no other order. Applying Theorem B gives the
following uniform spectrum.

### Corollary C: exact order--size--component spectrum

For integers \(m\ge1\) and \(1\le c\le m\), a member \(F\in\mathcal B_r\)
without isolated vertices exists with \(m\) hyperedges, \(n\) vertices, and
exactly \(c\) connected components if and only if

\[
\boxed{
(r-2)m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
\le n\le
(r-1)m+c.
}
\]

Every integer in the interval occurs.

For connected systems,

\[
\boxed{
(r-2)m+\left\lceil2\sqrt m\right\rceil
\le n\le
(r-1)m+1.
}
\]

### Corollary D: cycle-rank spectrum independent of uniformity

The Levi cyclomatic number is

\[
\beta(I(F))
=rm-(n+m)+c
=(r-1)m-n+c.
\]

For fixed \(m,c\), its exact range is

\[
\boxed{
0\le\beta(I(F))
\le
m-c+2-\left\lceil2\sqrt{m-c+1}\right\rceil.
}
\]

Notably, this range is independent of \(r\). Every integer in it occurs.

Moreover,

\[
|V(F)|=(r-1)|E(F)|+c
\quad\Longleftrightarrow\quad
I(F)\text{ is a forest}.
\]

### Corollary E: two rigidity families

If \(F\in\mathcal B_r\) is connected and reduced, then

\[
|E(F)|=t^2,\qquad
|V(F)|=(r-2)t^2+2t
\]

forces

\[
F\cong K_{t,t}^{(r)},
\]

and

\[
|E(F)|=t(t+1),\qquad
|V(F)|=(r-2)t(t+1)+2t+1
\]

forces

\[
F\cong K_{t,t+1}^{(r)}.
\]

The proof is equality in the balanced bipartite edge bound, followed by the
fact that \(K_{t,t}\) and \(K_{t,t+1}\) have no cut vertex for \(t\ge2\).

## 6. Consequence for obligatory hypergraphs

Reiher proved that \(K_{N,N}^{(r)}\) is obligatory for every finite
\(r\ge2\) and \(N\ge1\). Since every finite bipartite graph embeds in a
sufficiently large \(K_{N,N}\), every \(J^{(r)}\) with \(J\) bipartite is
obligatory. The obligatory \(r\)-uniform systems are closed under disjoint
unions and one-point amalgamations. Therefore

\[
\mathcal B_r
\subseteq
\{\text{obligatory finite \(r\)-uniform hypergraphs}\}.
\]

The remaining open direction for \(r\ge4\) is **not finite decomposition**.
It is the infinitary avoidance statement:

> if a finite \(r\)-uniform hypergraph fails one of the three conditions in
> Theorem A, construct an uncountably chromatic \(r\)-uniform host that avoids
> it.

For \(r=3\), Li's classification and the alternative Problem 593 development
supply these avoidance hosts. No analogous complete \(r\ge4\) theorem was
located in the targeted search.

## 7. Independent computational certificate

`experiments/uniform_bridge_certificate.py` implements the proof literally:

- delete all Levi bridges at once;
- certify the \(0/2\) nonbridge-degree dichotomy;
- suppress active edge-nodes to bipartite core graphs;
- verify private-vertex uniqueness inside each piece;
- verify that distinct pieces meet in at most one point;
- verify that the piece/attachment incidence graph is a forest; and
- compare the Levi and core cycle ranks.

This differs from `uniformity_conjecture.py`, whose recogniser recursively
splits at articulation points and then searches over possible graph cores.
The workflow cross-checks the two implementations, and the original intrinsic
test, over the complete labelled search through six hyperedges for
\(r=3,4,5\).

## 8. Literature boundary

The primary external interface is:

- Christian Reiher, *Obligatory Hypergraphs*, arXiv:2403.11223,
  Theorem 1.2 and the closure discussion in the introduction.
- Eric Li, *A Resolution of Erdős Problems 593 and 1177: Obligatory Triple
  Systems and Exact Spectra*, arXiv:2606.24882, for the complete \(r=3\)
  classification.

A targeted search for the exact uniform bridge-block equivalence and the
cycle-preserving shadow did not locate matching statements. This is a
source-screen record, not an absolute priority claim.
