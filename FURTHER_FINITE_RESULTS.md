# Further finite consequences of the Erdős 593 classification

**Author:** Samuil Petkov  
**Revision date:** 24 July 2026

This note records finite consequences of the classification proved in the
manuscript.  They are intended for incorporation into the canonical paper after
independent checking.  Throughout, a triple system is finite and simple,
`connected` means connected in the Levi graph, and isolated vertices are
excluded unless explicitly restored at the end.

The main new deduction is an exact order--size--component spectrum.  The same
bridge-block decomposition also gives a forbidden-Levi-subgraph formulation,
matching--cover consequences through balanced-hypergraph theory, and exact
factorisations of weak and strong colouring polynomials.

A targeted comparison against arXiv:2606.24882v1 and v2 and the classical
obligatory-system references did not locate these exact statements.  This is a
source audit, not an absolute priority claim.

## 1. A numerical bipartite shadow

For an integer `r >= 1`, put

\[
\sigma(r):=\left\lceil 2\sqrt r\right\rceil.
\]

### Proposition 1 (numerical bipartite shadow)

Let `F` be an obligatory triple system with no isolated vertices.  Write

\[
m=|E(F)|,\qquad n=|V(F)|,
\]

and let `c` be the number of connected components of its Levi graph.  There is
a finite bipartite graph `J`, without isolated vertices and with exactly `c`
connected components, such that

\[
|E(J)|=m,\qquad |V(J)|=n-m.
\]

Conversely, if `J` is any finite bipartite graph without isolated vertices,
then its private-vertex expansion `J^+` is obligatory and satisfies

\[
|E(J^+)|=|E(J)|,\qquad |V(J^+)|=|E(J)|+|V(J)|,
\]

with the same number of connected components.

#### Proof

Consider one connected component `H` of `F`.  The bridge-block reconstruction
in the manuscript writes `H` as a succession of one-point amalgamations of
connected pieces

\[
J_1^+,\ldots,J_k^+,
\]

where each `J_i` is a connected finite bipartite graph.  Put

\[
m_i=|E(J_i)|,\qquad v_i=|V(J_i)|.
\]

Every piece `J_i^+` has `m_i` hyperedges and `m_i+v_i` vertices.  Since a
connected assembly of `k` pieces makes exactly `k-1` one-point
identifications,

\[
|E(H)|=\sum_{i=1}^k m_i,
\qquad
|V(H)|=\sum_{i=1}^k(m_i+v_i)-(k-1).
\tag{1.1}
\]

Take vertex-disjoint copies of the graphs `J_i` and join them by arbitrary
one-vertex sums along a tree.  Before each identification, interchange the two
bipartition classes in one factor when necessary.  The resulting graph `J_H`
is connected and bipartite, and (1.1) gives

\[
|E(J_H)|=|E(H)|,
\qquad
|V(J_H)|=|V(H)|-|E(H)|.
\]

The disjoint union of the graphs `J_H` over the components of `F` is the
required graph `J`.  Notice that this shadow is a numerical reduction; it is
not asserted to retain the original attachment points of `F`.

The converse follows directly from the classification, because every finite
bipartite expansion is obligatory.  The displayed parameter identities are
immediate from the definition of private-vertex expansion.  ∎

## 2. Connected bipartite parameters

### Lemma 2

A connected simple bipartite graph with `r >= 1` edges and `s` vertices exists
if and only if

\[
\sigma(r)\le s\le r+1.
\tag{2.1}
\]

Equivalently,

\[
s-1\le r\le \left\lfloor\frac{s^2}{4}\right\rfloor.
\tag{2.2}
\]

#### Proof

Connectedness gives `r >= s-1`.  If the two bipartition classes have sizes
`a,b`, then

\[
r\le ab\le\left\lfloor\frac{(a+b)^2}{4}\right\rfloor
 =\left\lfloor\frac{s^2}{4}\right\rfloor.
\]

Conversely, let

\[
a=\lfloor s/2\rfloor,\qquad b=\lceil s/2\rceil.
\]

The graph `K_{a,b}` has `floor(s^2/4)` edges and contains a spanning tree with
`s-1` edges.  Starting with that tree and adding arbitrary unused edges
realises every integer in the interval (2.2).  Finally,
`r <= floor(s^2/4)` is equivalent to `ceil(2 sqrt(r)) <= s`.  ∎

## 3. Exact order--size--component spectrum

### Theorem 3

Let `m >= 1`, `1 <= c <= m`, and `n` be integers.  There exists an obligatory
triple system `F` with no isolated vertices, exactly `c` connected components,

\[
|E(F)|=m,\qquad |V(F)|=n,
\]

if and only if

\[
\boxed{
 m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
 \ \le n\le\ 2m+c.
}
\tag{3.1}
\]

Every integer in this interval occurs.

#### Proof

By Proposition 1, it is enough to determine the possible numbers of vertices
in a bipartite graph with `m` edges and `c` nontrivial connected components.
Let their edge counts be

\[
m_1+\cdots+m_c=m,\qquad m_i\ge1.
\]

Lemma 2 shows that the `i`th component has between `sigma(m_i)` and `m_i+1`
vertices.  The elementary inequality

\[
\sigma(a)+\sigma(b)\ge \sigma(a+b-1)+2
\qquad(a,b\ge1)
\tag{3.2}
\]

follows from

\[
2\sqrt a+2\sqrt b
 \ge 2\sqrt{a+b-1}+2,
\]

because

\[
(\sqrt a+\sqrt b-1)^2-(a+b-1)
 =2(\sqrt a-1)(\sqrt b-1)\ge0,
\]

and then from the elementary ceiling inequalities.  Iterating (3.2) gives

\[
\sum_{i=1}^c\sigma(m_i)
 \ge \sigma(m-c+1)+2(c-1).
\tag{3.3}
\]

The maximum graph-shadow order is

\[
\sum_{i=1}^c(m_i+1)=m+c.
\]

Adding the `m` private expansion vertices gives the two bounds in (3.1).

For attainability, take `c-1` components equal to `K_2`, and let the remaining
connected bipartite component have

\[
r=m-c+1
\]

edges.  By Lemma 2 its order can be any integer from `sigma(r)` through `r+1`.
After expansion, this realises every integer in (3.1).  ∎

### Corollary 4 (connected spectrum)

A connected obligatory triple system with `m >= 1` hyperedges, no isolated
vertices, and `n` vertices exists if and only if

\[
\boxed{
 m+\left\lceil2\sqrt m\right\rceil
 \ \le n\le\ 2m+1.
}
\tag{3.4}
\]

### Corollary 5 (unrestricted reduced order)

An obligatory triple system with `m >= 1` hyperedges, no isolated vertices,
and `n` vertices exists if and only if

\[
\boxed{
 m+\left\lceil2\sqrt m\right\rceil
 \ \le n\le\ 3m.
}
\tag{3.5}
\]

Indeed, the fixed-component intervals from Theorem 3 are consecutive: the
lower endpoint for `c+1` is at most one more than the upper endpoint for `c`
because `sigma(r) <= r+1`.

If `z` isolated vertices are allowed, simply replace `n` by `n-z` in these
statements.

## 4. Levi cycle rank and endpoint structure

Let `beta(G)=|E(G)|-|V(G)|+c(G)` be the cyclomatic number of a finite graph.
For a reduced triple system with `m` hyperedges, `n` vertices, and `c`
components,

\[
|E(I(F))|=3m,\qquad |V(I(F))|=n+m,
\]

so

\[
\beta(I(F))=2m-n+c.
\tag{4.1}
\]

### Corollary 6 (exact cycle-rank spectrum)

For obligatory reduced systems with `m >= 1` hyperedges and exactly `c`
components, the possible Levi cycle ranks are precisely

\[
\boxed{
0\le \beta(I(F))
 \le m-c+2-\left\lceil2\sqrt{m-c+1}\right\rceil.
}
\tag{4.2}
\]

Every integer in the interval occurs.  In the connected case this becomes

\[
0\le\beta(I(F))
 \le m+1-\left\lceil2\sqrt m\right\rceil.
\tag{4.3}
\]

### Corollary 7 (upper endpoint)

For an obligatory reduced system with `m` hyperedges and `c` components,

\[
|V(F)|=2m+c
\]

if and only if its Levi graph is a forest.  In particular, a connected system
has `2m+1` vertices exactly when its Levi graph is a tree.

### Proposition 8 (rigidity at two lower-endpoint families)

Let `F` be connected and reduced.

1. If `|E(F)|=t^2` and `|V(F)|=t^2+2t`, then
   \[
   F\cong K_{t,t}^+.
   \]
2. If `|E(F)|=t(t+1)` and `|V(F)|=t(t+1)+2t+1`, then
   \[
   F\cong K_{t,t+1}^+.
   \]

#### Proof

At the lower endpoint, the bipartite shadow from Proposition 1 has the minimum
possible order and attains equality in the balanced bipartite edge bound.
Hence it is respectively `K_{t,t}` or `K_{t,t+1}`.  For `t >= 2` these graphs
have no cut vertex.  A nontrivial one-vertex sum of two or more connected
bridge-block shadows has a cut vertex, so the canonical decomposition can have
only one expansion piece.  The cases `t=1` are immediate.  ∎

## 5. A forbidden-Levi-subgraph formulation

Let `e` be a degree-three hyperedge-node of a Levi graph, with point-neighbours
`x,y,z`.  A **full theta rooted at `e`** consists of a vertex `w != e` and three
pairwise internally vertex-disjoint `e`--`w` paths whose first edges are
respectively `ex,ey,ez`.

### Lemma 9

The node `e` has no incident bridge if and only if the Levi graph contains a
full theta rooted at `e`.

#### Proof

No incidence at `e` is a bridge exactly when `x,y,z` all lie in one connected
component after `e` is deleted.  In that component, take a minimal tree joining
`x,y,z`.  Its unique branch point (possibly one of the three terminals) gives
three internally disjoint terminal-to-branch paths; adjoining the three
incidences at `e` gives the required full theta.  Conversely, a full theta
provides an alternative route around each of the three incidences at `e`, so
none is a bridge.  ∎

### Corollary 10 (forbidden Levi configurations)

A finite triple system `F` is obligatory if and only if `I(F^circ)` contains
none of the following:

1. a four-cycle;
2. a cycle whose length is congruent to `2 mod 4`;
3. a full theta rooted at a hyperedge-node.

The three exclusions are respectively equivalent to linearity, evenness of all
Berge cycles, and the existence of an incident bridge at every hyperedge-node.

## 6. Balanced-hypergraph consequences

A hypergraph is balanced when its incidence matrix has no odd square submatrix
with exactly two `1`s in each row and column; equivalently, it has no strong
odd Berge cycle.  Since an obligatory reduced triple system has no odd Berge
cycle at all, it is balanced.

### Corollary 11 (hereditary König property)

Let `F` be obligatory.  Every hypergraph obtained from `F^circ` by deleting
vertices and/or hyperedges has

\[
\nu(H)=\tau(H),
\]

where `nu` is the maximum size of a matching and `tau` is the minimum size of a
vertex transversal.

This is the classical König theorem for balanced hypergraphs, due to Berge and
Las Vergnas.  The conclusion is stronger than the visible tripartiteness of
obligatory systems: tripartite hypergraphs need not be balanced.

## 7. Colouring-polynomial factorisations

For a finite hypergraph `H`, let `P_H(q)` denote the number of weak proper
`q`-colourings, meaning colourings with no monochromatic hyperedge.  Let
`S_H(q)` denote the number of strong `q`-colourings, meaning colourings in which
the three vertices of every hyperedge have pairwise distinct colours.

For a graph `J` and `A subseteq E(J)`, let `k_J(A)` be the number of connected
components of the spanning graph `(V(J),A)`, including isolated graph vertices,
and put

\[
Q_J(q):=\sum_{A\subseteq E(J)}
 (-1)^{|A|}q^{|E(J)|-|A|+k_J(A)}.
\tag{7.1}
\]

Equivalently, if

\[
Z_J(q,v)=\sum_{A\subseteq E(J)}q^{k_J(A)}v^{|A|}
\]

is the Fortuin--Kasteleyn/Potts partition function, then

\[
Q_J(q)=q^{|E(J)|}Z_J(q,-q^{-1}).
\tag{7.2}
\]

### Proposition 12 (one expansion atom)

For every finite graph `J`,

\[
P_{J^+}(q)=Q_J(q),
\tag{7.3}
\]

and

\[
S_{J^+}(q)=(q-2)^{|E(J)|}P_J(q),
\tag{7.4}
\]

where `P_J` on the right of (7.4) is the ordinary graph chromatic polynomial.

#### Proof

For (7.3), apply inclusion--exclusion to the events that an expanded triple is
monochromatic.  If the events indexed by `A subseteq E(J)` are imposed, the
core vertices collapse according to the `k_J(A)` components of `(V(J),A)`;
private vertices belonging to `A` collapse into those components, while the
`|E(J)|-|A|` other private vertices remain free.  This gives exactly (7.1).

For (7.4), a strong colouring first gives a proper colouring of the graph core.
For every graph edge, its private vertex may then receive any of the `q-2`
colours different from the two endpoint colours, independently.  ∎

### Lemma 13 (one-point amalgamation)

If `H` is a one-point amalgamation of `H_0` and `H_1`, then

\[
qP_H(q)=P_{H_0}(q)P_{H_1}(q),
\qquad
qS_H(q)=S_{H_0}(q)S_{H_1}(q).
\tag{7.5}
\]

For positive integral `q`, colour symmetry shows that exactly `1/q` of the
colourings of each factor assign any prescribed colour to its selected point.
The polynomial identities follow because they hold for infinitely many `q`.

### Theorem 14 (canonical factorisation)

Let the canonical bridge-block decomposition of `F^circ` have `k` active
expansion pieces

\[
J_1^+,\ldots,J_k^+,
\]

and let `c` be the number of connected components of `F^circ`.  If `F` has `z`
isolated vertices and `m=|E(F)|`, then

\[
\boxed{
 q^{k-c}P_F(q)=q^z\prod_{i=1}^k Q_{J_i}(q)
}
\tag{7.6}
\]

and

\[
\boxed{
 q^{k-c}S_F(q)
 =q^z(q-2)^m\prod_{i=1}^k P_{J_i}(q).
}
\tag{7.7}
\]

Indeed, there are exactly `k-c` one-point amalgamation steps, disjoint unions
multiply colouring polynomials, and each isolated vertex contributes a factor
`q`.

## 8. Source interfaces

The balanced-hypergraph consequence uses the classical theorem of C. Berge and
M. Las Vergnas that balanced hypergraphs, hereditarily, have the König
matching--transversal property:

- C. Berge and M. Las Vergnas, *Sur un théorème du type König pour
  hypergraphes*, Annals of the New York Academy of Sciences **175** (1970),
  32--40, DOI `10.1111/j.1749-6632.1970.tb56451.x`.
- C. Berge, *Balanced Matrices*, Mathematical Programming **2** (1972), 19--31,
  DOI `10.1007/BF01584535`.

For background on hypergraph chromatic polynomials and the multivariate
Tutte/Potts polynomial:

- J. A. White, *On Multivariate Chromatic Polynomials of Hypergraphs and
  Hyperedge Elimination*, Electronic Journal of Combinatorics **18** (2011),
  P160, DOI `10.37236/647`.
- A. D. Sokal, *The multivariate Tutte polynomial (alias Potts model) for graphs
  and matroids*, in *Surveys in Combinatorics 2005*, 173--226, DOI
  `10.1017/CBO9780511734885.009`, arXiv:`math/0503607`.
