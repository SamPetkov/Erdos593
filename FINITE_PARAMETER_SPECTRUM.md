# Finite parameter spectrum for obligatory triple systems

**Revision date:** 24 July 2026  
**Status:** proved consequence of the finite classification; manuscript integration proposed on this branch

This note records finite consequences that are not part of the statement of Erdős
Problem 593 itself.  Throughout, a triple system is **reduced** when it has no
isolated vertices, and its connected components are the connected components of
its Levi graph.

For an integer `r >= 1`, put

\[
q(r)=\left\lceil 2\sqrt r\right\rceil.
\]

## Bipartite-shadow principle

Let `F` be a reduced obligatory triple system.  There is a finite bipartite graph
`J`, without isolated vertices, such that

\[
|E(J)|=|E(F)|,\qquad |V(J)|=|V(F)|-|E(F)|,
\]

and `J` has the same number of connected components as `F`.

Indeed, the bridge-block reconstruction writes each connected component of `F`
as a tree-like one-point amalgamation of connected pieces `J_i^+`.  If
`m_i=|E(J_i)|` and `s_i=|V(J_i)|`, then a component assembled from `k` pieces has

\[
|E(F)|=\sum_i m_i,\qquad
|V(F)|=\sum_i(m_i+s_i)-(k-1).
\]

Taking a one-point sum of the bipartite graphs `J_i` along an arbitrary tree
(swapping the two bipartition classes before an identification when necessary)
produces the required bipartite shadow.  Conversely, `J^+` is obligatory for
every finite bipartite `J` and has exactly the displayed parameters.

## Exact order--size--component theorem

Let `m >= 1`, `1 <= c <= m`, and let `n` be an integer.  There exists a reduced
obligatory triple system with `m` hyperedges, `n` vertices, and exactly `c`
connected components if and only if

\[
\boxed{
 m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
 \le n\le 2m+c.
}
\]

Every integer in this interval occurs.

### Proof

A connected simple bipartite graph with `r >= 1` edges and `s` vertices exists
if and only if

\[
\left\lceil2\sqrt r\right\rceil\le s\le r+1.
\]

Necessity follows from connectedness (`r >= s-1`) and from
`r <= ab <= floor(s^2/4)` for bipartition sizes `a+b=s`.  Conversely, the
balanced complete bipartite graph on `s` vertices contains a spanning tree, so
starting with that tree and adding arbitrary unused edges realizes every edge
count from `s-1` through `floor(s^2/4)`.

Now let the `c` shadow components have positive edge counts
`m_1+...+m_c=m`.  Their total number of vertices is at most `m+c`.  For the
lower bound, for all positive integers `a,b`,

\[
q(a)+q(b)\ge q(a+b-1)+2.
\]

This follows from

\[
\sqrt a+\sqrt b\ge\sqrt{a+b-1}+1,
\]

which is equivalent after squaring to
`(sqrt(a)-1)(sqrt(b)-1) >= 0`.  Repeatedly merging component sizes gives

\[
\sum_{i=1}^c q(m_i)
\ge q(m-c+1)+2(c-1).
\]

For sharpness, take `c-1` components equal to `K_2` and one connected bipartite
component with `m-c+1` edges.  Varying the order of the latter component through
its entire allowed interval realizes every total order between the two bounds.
Private-vertex expansion adds exactly `m` vertices.

## Immediate corollaries

### Connected systems

A connected reduced obligatory triple system with `m` hyperedges and `n`
vertices exists exactly when

\[
\boxed{m+\left\lceil2\sqrt m\right\rceil\le n\le2m+1.}
\]

### Components unrestricted

A reduced obligatory triple system with `m` hyperedges and `n` vertices exists
exactly when

\[
\boxed{m+\left\lceil2\sqrt m\right\rceil\le n\le3m.}
\]

If isolated vertices are allowed, the exact condition becomes simply

\[
n\ge m+\left\lceil2\sqrt m\right\rceil,
\]

because isolated vertices can be added freely.

### Exact Levi cycle rank

For a reduced obligatory system with `m` hyperedges, `n` vertices, and `c`
components, the cyclomatic number of the Levi graph is

\[
\beta(I(F))=3m-(n+m)+c=2m-n+c.
\]

Consequently every integer in

\[
0\le\beta(I(F))\le
m-c+2-\left\lceil2\sqrt{m-c+1}\right\rceil
\]

occurs, and no other value occurs.  The upper order endpoint `n=2m+c` is
equivalent to `I(F)` being a forest.

### Rigidity at balanced lower endpoints

For `t >= 1`, the minimum-order connected system is unique up to isomorphism
in the two extremal families

\[
|E(F)|=t^2
\quad\Longrightarrow\quad
F\cong K_{t,t}^+,
\]

and

\[
|E(F)|=t(t+1)
\quad\Longrightarrow\quad
F\cong K_{t,t+1}^+.
\]

At these values the bipartite shadow attains the balanced bipartite extremal
bound.  Hence it is the corresponding complete bipartite graph.  For `t >= 2`
that graph has no cut vertex, whereas a nontrivial one-point sum of two or more
connected shadow pieces necessarily has a cut vertex; therefore there is only
one expansion piece.  The cases `t=1` are immediate.

## Hypergraph-native bridge test

For a hyperedge `e={x,y,z}`, let `F-e` be obtained by deleting `e` while
retaining all vertices.  The hyperedge-node `e` has no incident bridge in the
Levi graph if and only if `x,y,z` lie in one connected component of `F-e`.
Thus the bridge condition in the classification can equivalently be written:

> for every hyperedge `e`, deleting `e` separates its three vertices into at
> least two connected components.

For an incidence `xe`, non-bridgehood is equivalent to the existence of an
alternate Levi path from `e` to `x`; after its first step through `y` or `z`,
that path lies in `F-e`.  Hence `xe` is non-bridging exactly when `x` is
connected in `F-e` to at least one of the other two vertices.  All three
incidences are non-bridging exactly when all three vertices belong to one
component.

## Novelty screen and sources checked

The statements above were checked against the following sources and records:

- Eric Li, *A Resolution of Erdős Problems 593 and 1177: Obligatory Triple
  Systems and Exact Spectra*, arXiv:2606.24882, both the 23 June 2026 v1 and the
  23 July 2026 v2;
- Péter Komjáth, *Some Remarks on Obligatory Subsystems of Uncountably Chromatic
  Triple Systems*, Combinatorica 21 (2001), 233--238;
- András Hajnal and Péter Komjáth, *Obligatory Subsystems of Triple Systems*,
  Acta Math. Hungar. 119 (2008), 1--13;
- Christian Reiher, *Obligatory Hypergraphs*, Proc. Amer. Math. Soc.,
  DOI 10.1090/proc/17021;
- Yichen Wang, Mengyu Duan, Dániel Gerbner, and Hilal Hama Karim,
  *On the Largest Chromatic Number of F-free Hypergraphs*, arXiv:2604.21551.

No matching exact order--size--component theorem, Levi cycle-rank spectrum, or
edge-deletion reformulation was found in that targeted search.  This is a
novelty screen rather than a definitive claim about all possible literature.
