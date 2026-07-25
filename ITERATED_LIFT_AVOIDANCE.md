# Iterated one-apex lifts and the uniform avoidance direction

**Status:** complete proof draft with finite computational stress tests; not yet
independently refereed or Lean-formalised.

This note investigates the missing infinitary direction left by the uniform
bridge-block theorem.  The main observation is that the one-apex lift used for
triple systems extends to an arbitrary base uniformity and can then be iterated.
The iteration appears to provide exactly one additional forced bridge incidence
at every increase of uniformity, while preserving the length of every Berge
cycle down to an ordinary cycle in the initial graph.

The construction in one step and the cycle-collapse mechanism for the
`graph -> triple system` case are due to Eric Li.  The uniform one-step
formulation, its iteration, and the resulting all-uniformity avoidance argument
are the new deductions investigated here.

## 1. The uniform one-apex lift

Let `H` be a simple `s`-uniform hypergraph, where `s >= 2`, and let `kappa` be
an infinite cardinal.  Put

\[
T(H,\kappa)
 =\bigcup_{\alpha<\kappa}E(H)^\alpha.
\]

Thus a node is a sequence of hyperedges of `H` of ordinal length less than
`kappa`.  For nodes `sigma,tau`, write `sigma proper-prefix tau` when `sigma`
is a proper initial segment of `tau`.

Define the `(s+1)`-uniform hypergraph

\[
\operatorname{Lift}_{\kappa}(H)
\]

on the vertex set

\[
T(H,\kappa)\times V(H).
\]

For

\[
\sigma\subsetneq\tau,
\qquad
\tau(\operatorname{lh}\sigma)=a\in E(H),
\qquad
z\in V(H),
\]

include the hyperedge

\[
\widehat a(\sigma,\tau,z)
 =\{(\sigma,x):x\in a\}\cup\{(\tau,z)\}.
\tag{1.1}
\]

The `s` points at node `sigma` form the **base**, and the unique point at node
`tau` is the **apex**.  Since `s >= 2`, the apex is determined intrinsically by
the lifted edge: it is the only point whose sequence node differs from the
other points.

### Lemma 1.1: chromatic preservation

If

\[
\chi(H)=\kappa,
\]

then

\[
\chi(\operatorname{Lift}_{\kappa}(H))=\kappa.
\tag{1.2}
\]

#### Proof

A proper `kappa`-colouring of `H` colours `(sigma,x)` by the colour of `x`.
Every lifted edge contains an entire edge of `H` in its base, so this colouring
is proper.

Conversely, suppose that the lift is coloured with `theta < kappa` colours.
Recursively construct a branch

\[
t\in E(H)^\kappa.
\]

At stage `alpha`, the colouring of the slice

\[
x\longmapsto c(t\mathbin{\upharpoonright}\alpha,x)
\]

is a `theta`-colouring of `H`, hence is not proper.  Choose an edge `t(alpha)`
whose complete slice is monochromatic, and denote its colour by `d_alpha`.
Choose `alpha < beta < kappa` with `d_alpha=d_beta`, and choose
`z in t(beta)`.  Then

\[
\{(t\mathbin{\upharpoonright}\alpha,x):x\in t(\alpha)\}
 \cup
\{(t\mathbin{\upharpoonright}\beta,z)\}
\]

is a monochromatic lifted edge.  No regularity or cofinality assumption on
`kappa` is used.  This proves (1.2).  `square`

## 2. Uniform cycle collapse

Let `F` be a finite linear `(s+1)`-uniform hypergraph, and suppose that

\[
\varphi:F\hookrightarrow\operatorname{Lift}_{\kappa}(H)
\]

is an embedding.  For a point `v in V(F)`, write

\[
\varphi(v)=(\nu(v),\xi(v)),
\]

where `nu(v)` is its sequence node.

### Lemma 2.1: cycle collapse

On every Berge cycle

\[
v_0,e_0,v_1,e_1,\ldots,v_{m-1},e_{m-1},v_0
\]

of `F`, all connector nodes

\[
\nu(v_0),\ldots,\nu(v_{m-1})
\]

are equal.

#### Proof

Consecutive connector nodes are equal or comparable in the initial-segment
order, because two connectors lie in one lifted edge and a lifted edge has one
apex node and one repeated base node.  Choose a connector node `sigma` of
minimum ordinal length.  Traversing the cycle shows that every connector node
extends `sigma`.

Suppose that some connector properly extends `sigma`.  Choose a maximal cyclic
interval of connectors with nodes properly above `sigma`, bounded at both ends
by connectors at `sigma`.  All nodes in the interval take the same value

\[
a\in E(H)
\]

at coordinate `lh(sigma)`, because consecutive nodes are comparable.

At the first boundary edge, the connector above `sigma` is the unique apex.
Consequently the other connector and the remaining `s-1` points of that source
edge form the complete base

\[
\{(\sigma,x):x\in a\}.
\]

The other boundary edge contains the same complete `s`-point base.  The two
boundary source edges are distinct, while injectivity of `varphi` gives the
same `s` source points in both.  Since `s >= 2`, this contradicts linearity.
Therefore no connector node properly extends `sigma`.  `square`

The proof is exactly the triple-system cycle-collapse argument with a base of
size `s` rather than two.  Its contradiction becomes stronger as `s`
increases.

## 3. The one-step forward trace theorem

For every source edge `e in E(F)`, let `p(e)` be the preimage of the unique apex
of `varphi(e)`.

### Lemma 3.1: the apex incidence is a bridge

For every `e`, the Levi incidence

\[
ep(e)
\]

is a bridge of `I(F)`.

#### Proof

If `ep(e)` were not a bridge, it would lie on a Levi cycle, hence on a Berge
cycle of the finite linear system `F`.  On that cycle the connector `p(e)` has
the apex node of `varphi(e)`, while the other connector of `e` has its base
node.  These nodes are distinct, contradicting Lemma 2.1.  `square`

Delete every selected incidence `ep(e)`.  Let `C` be a resulting component
containing at least one hyperedge-node.  Each hyperedge-node in `C` retains
exactly `s` point-neighbours.

### Lemma 3.2: derivative components embed in the base

The `s`-uniform derivative supported by `C` embeds in `H`.

#### Proof

For each source edge `e in C`, all remaining points of `e` are mapped to the
base node of `varphi(e)`.  If two edge-nodes are joined through a remaining
point, their base nodes are equal.  Connectedness of `C` therefore gives one
common sequence node `sigma_C` for all points and all edge bases in `C`.

Map a source point `v in C` to `xi(v)`.  This map is injective, because all its
images in the lift have the same first coordinate `sigma_C` and `varphi` is
injective.  For each source edge, its `s` remaining points map to the base edge
of `H` specified by the corresponding apex sequence.  Distinct derivative
edges cannot map to the same edge of `H`, since then the source edges would
share all `s >= 2` remaining points, contrary to linearity.  Thus this is a
hypergraph embedding.  `square`

### Lemma 3.3: cycles descend without changing length

Every Berge cycle of `F` avoids the selected bridge incidences, lies in one
active component `C`, and becomes a Berge cycle of the same length in the
`s`-uniform derivative of `C`.

#### Proof

A bridge does not lie on a cycle, so all displayed incidences of the Berge cycle
survive.  The cycle is therefore contained in one component after deletion.
For each cycle edge, its two connector points are among the `s` remaining base
points.  The same alternating point-edge sequence is a Berge cycle in the
derivative.  `square`

Only this forward direction is needed for avoidance.  A full converse
bridge-trace theorem can also be formulated, but it is unnecessary for the
classification argument below.

## 4. Iteration

Let `A` be a graph with `chi(A)=kappa`.  Define

\[
L_2(A,\kappa)=A,
\qquad
L_{q+1}(A,\kappa)
 =\operatorname{Lift}_{\kappa}(L_q(A,\kappa)).
\tag{4.1}
\]

By Lemma 1.1, `L_q(A,kappa)` is `q`-uniform and has chromatic number exactly
`kappa` for every finite `q >= 2`.

We use the following elementary persistence fact.

### Lemma 4.1: bridge persistence

Let `G` be a finite graph, let `S` be a set of bridges of `G`, and let `C` be a
component of `G-S`.  If an edge `f` of `C` is a bridge of `C`, then `f` is a
bridge of `G`.

#### Proof

If `f` were not a bridge of `G`, it would lie on a cycle of `G`.  No cycle can
contain an edge of `S`, since every edge of `S` is a bridge.  The cycle would
therefore lie in `G-S`, and hence in `C`, contradicting that `f` is a bridge of
`C`.  `square`

### Theorem 4.2: iterated trace theorem

Let `q >= 2`, let `F` be a finite linear `q`-uniform hypergraph, and suppose

\[
F\hookrightarrow L_q(A,\kappa).
\]

Then:

1. every hyperedge-node of `I(F)` is incident with at least `q-2` bridges;
2. every Berge cycle of `F` projects, preserving its length, to an ordinary
   cycle of `A`.

#### Proof

Induct on `q`.  The case `q=2` is immediate.

For `q+1`, apply Lemmas 3.1--3.3 at the top lift level.  Every source edge gains
one selected apex incidence that is a bridge.  Each derivative component is a
finite linear `q`-uniform system embedded in `L_q(A,kappa)`.  By induction,
every derivative edge has at least `q-2` derivative bridge incidences.  Lemma
4.1 promotes each of these incidences to a bridge of the original Levi graph.
They are distinct from the selected apex incidence, giving

\[
1+(q-2)=q-1
\]

bridges at every `(q+1)`-edge.

A Berge cycle avoids all selected apex bridges and descends, with the same
length, to a derivative component.  Apply the induction hypothesis to obtain a
cycle of the same length in `A`.  `square`

The proof also constructs a certificate: at each lift level, record the apex
point selected for every edge.  The resulting `q-2` incidences are distinct and
are all bridges in the original trace.

## 5. Uniform avoidance hosts

Let `F` be a finite `r`-uniform hypergraph and remove its isolated vertices.
There are three possible failures of the proposed intrinsic criterion.

### 5.1 Nonlinearity

If two edges of `F` meet in at least two points, the classical
Erdos--Hajnal--Rothschild theorem supplies an uncountably chromatic linear
`r`-uniform host.  Such a host cannot contain `F`.

### 5.2 Too few incident bridges

Assume that `F` is linear and that some hyperedge-node is incident with fewer
than `r-2` bridges.  Let `kappa` be uncountable and take

\[
A=K_\kappa.
\]

Then `chi(L_r(A,kappa))=kappa`.  By Theorem 4.2 every finite linear trace in
this host has at least `r-2` bridge incidences at every edge-node.  Hence the
host avoids `F`.

### 5.3 An odd Berge cycle

Assume that `F` is linear and contains an odd Berge cycle of length `ell`.  By
the Erdos--Hajnal high-odd-girth theorem, choose a graph `A` of uncountable
chromatic number `kappa` with no odd cycle of length at most `ell` (or at most
`|E(F)|`).  The iterated lift `L_r(A,kappa)` has chromatic number `kappa`.
If `F` embedded, Theorem 4.2 would project its odd Berge cycle to an odd cycle
of the same length in `A`, a contradiction.

Thus every finite `r`-uniform system failing one of the three conditions is
non-obligatory.

## 6. Candidate all-uniformity classification

Combine the avoidance theorem above with the finite uniform bridge-block
theorem and Reiher's positive expansion theorem.

Let `B_r` be generated from the `r`-uniform expansions `J^(r)` of finite
bipartite graphs, together with finite edgeless systems, under disjoint unions
and one-point amalgamations.

Reiher proves that the expansions of complete bipartite graphs are obligatory
for every finite uniformity, and the obligatory systems are closed under the
two assembly operations.  Since every finite bipartite graph embeds in a
sufficiently large complete bipartite graph,

\[
B_r\subseteq\{\text{obligatory finite `r`-uniform hypergraphs}\}.
\]

The uniform bridge-block theorem gives

\[
F^\circ\in B_r
\quad\Longleftrightarrow\quad
\begin{cases}
F^\circ\text{ is linear},\\
\text{every hyperedge-node has at least `r-2` incident bridges},\\
\text{every Berge cycle is even}.
\end{cases}
\]

Section 5 proves the converse implication from obligatoriness to the intrinsic
conditions.  Consequently the combined proof draft yields:

> **Uniform obligatory-hypergraph classification (proof draft).**  For every
> finite `r >= 2` and every finite `r`-uniform hypergraph `F`, the following are
> equivalent:
>
> 1. `F` occurs in every `r`-uniform hypergraph of uncountable chromatic number;
> 2. `F^circ in B_r`;
> 3. `F^circ` is linear, every hyperedge-node of its Levi graph is incident with
>    at least `r-2` bridges, and every Berge cycle is even.

For `r=2` this is the classical graph theorem.  For `r=3` it is the known
Problem 593 classification.  The argument above proposes the extension to all
finite uniformities.

## 7. Audit points before any publication claim

The deduction is short enough to be plausible but consequential enough to
require adversarial checking.  The following points are the mandatory review
gates.

1. Verify the uniform cycle-collapse lemma with transfinite sequence lengths,
   including the case in which the minimum node occurs only once on the cycle.
2. Verify that every selected apex incidence is a bridge, using the exact
   equivalence between nonbridges and membership in a finite Levi cycle.
3. Check that each derivative component has a single common source node and
   embeds injectively, including injectivity on edge indices.
4. Verify bridge persistence when derivative bridge incidences are promoted
   through several lift levels.
5. Check that the same Berge cycle descends at every level without connector or
   edge identifications.
6. Recheck the imported nonlinear and high-odd-girth host statements in the
   exact weak-colouring convention.
7. Obtain independent expert review before describing the all-uniformity
   classification as established.

The finite experiment in this branch tests items 2, 4, and 5 on truncated
four- and five-uniform lifts.  It is evidence, not a replacement for these
proof checks.

## 8. Literature boundary

The primary sources checked are:

- Eric Li, *A Resolution of Erdos Problems 593 and 1177: Obligatory Triple
  Systems and Exact Spectra*, arXiv:2606.24882, for the complete-rank one-apex
  lift, chromatic preservation, cycle collapse, and exact bridge-trace theorem
  in the graph-to-triple case;
- Christian Reiher, *Obligatory Hypergraphs*, arXiv:2403.11223, for obligatory
  uniform expansions of complete bipartite graphs and the closure discussion;
- the Erdos--Hajnal--Rothschild linear-host theorem and the Erdos--Hajnal
  high-odd-girth theorem through the exact interfaces recorded in Li's paper.

Targeted searches for `iterated one-apex lift`, `uniform obligatory hypergraph
classification`, and the `r-2` bridge criterion did not locate a matching
all-uniformity result.  This is a source screen rather than an absolute priority
claim.
