# Exact indecomposability spectrum for obligatory triple systems

## Purpose

The canonical atom normal form identifies the one-point-indecomposable finite
reduced obligatory triple systems: they are exactly one triple and the
private-vertex expansions \(J^+\) of finite 2-connected bipartite graphs
\(J\).  The finite parameter theorem, on the other hand, records only which
pairs \((m,n)\) occur for connected obligatory systems.

Combining the two gives a sharper quantitative statement.  For every feasible
connected parameter pair one can decide whether the parameters force
one-point decomposability, allow both behaviours, or force a single canonical
atom.  The transition is governed by the sharp maximum number of edges in a
connected bipartite graph with a cut vertex.

This is intended as a short corollary section after the canonical atom theorem,
not as a second classification proof.

## Notation

Let \(F\) be a connected reduced triple system with

\[
  m=|E(F)|,\qquad n=|V(F)|,
\]

and put

\[
  s=n-m.
\]

For an obligatory system, \(s\) is the order of a connected bipartite shadow
with \(m\) edges.  Define, for \(s\ge 3\),

\[
\alpha(s)=
\begin{cases}
 s, & s\text{ even},\\
 s+1, & s\text{ odd},
\end{cases}
\qquad
\delta(s)=\left\lfloor\frac{(s-1)^2}{4}\right\rfloor+1.
\]

Equivalently,

\[
\delta(s)=\left\lfloor\frac{s^2}{4}\right\rfloor
          -\left\lfloor\frac{s}{2}\right\rfloor+1.
\]

Recall that an edge-bearing connected triple system is **one-point
indecomposable** if it is not a one-point amalgamation of two triple systems
that both contain a hyperedge.

## The exact indecomposable spectrum

### Theorem

There exists a connected reduced one-point-indecomposable obligatory triple
system with \(m\ge 1\) hyperedges and \(n\) vertices if and only if either

\[
(m,n)=(1,3),
\]

or, with \(s=n-m\),

\[
 s\ge 4
 \qquad\text{and}\qquad
 \alpha(s)\le m\le \left\lfloor\frac{s^2}{4}\right\rfloor.
\]

### Proof

By the canonical atom theorem, an indecomposable system is either one triple or
isomorphic to \(J^+\) for a finite 2-connected simple bipartite graph \(J\).
The one-triple case gives \((m,n)=(1,3)\).  Otherwise

\[
 |V(J)|=s,\qquad |E(J)|=m.
\]

Write the bipartition sizes of \(J\) as \(a+b=s\).  Simplicity gives

\[
 m\le ab\le \left\lfloor\frac{s^2}{4}\right\rfloor.
\]

Since a 2-connected graph has minimum degree at least two,
\(2m\ge 2s\), so \(m\ge s\).  If \(m=s\), every vertex has degree exactly
two, hence \(J\) is a cycle.  A bipartite cycle has even order.  Therefore an
odd value of \(s\) forces \(m\ge s+1\).  This proves necessity.

For sufficiency, first suppose \(s=2t\ge4\).  The cycle \(C_{2t}\) is a
spanning 2-connected subgraph of \(K_{t,t}\) with \(s\) edges.  Adding edges
preserves 2-connectivity, so every

\[
 s\le m\le t^2=\left\lfloor\frac{s^2}{4}\right\rfloor
\]

is realized by a 2-connected bipartite graph.

Now suppose \(s=2t+1\ge5\).  Start with a cycle \(C_{2t}\) with parts of size
\(t,t\), add one new vertex to one side, and join it to two distinct vertices
of the opposite side.  Adding a new vertex with at least two neighbours to a
2-connected graph preserves 2-connectivity.  The resulting graph is a spanning
2-connected subgraph of \(K_{t,t+1}\) with

\[
 2t+2=s+1
\]

edges.  Again, adding arbitrary missing edges realizes every edge count up to
\(t(t+1)=\lfloor s^2/4\rfloor\).  Expanding the resulting graph by private
vertices gives the required obligatory triple system. \(\square\)

## The exact decomposable spectrum

### Theorem

There exists a connected reduced one-point-decomposable obligatory triple
system with \(m\) hyperedges and \(n\) vertices if and only if, with
\(s=n-m\),

\[
 s\ge3
 \qquad\text{and}\qquad
 s-1\le m\le \delta(s)
 =\left\lfloor\frac{(s-1)^2}{4}\right\rfloor+1.
\]

### Proof

Suppose first that \(F\) is decomposable.  Its canonical atom forest has at
least two edge-bearing atoms.  One-point-summing their bipartite cores along a
tree, representing a singleton atom by \(K_2\), gives a connected bipartite
shadow \(J\) with

\[
 |V(J)|=s,\qquad |E(J)|=m,
\]

and with a cut vertex.  Connectedness gives \(m\ge s-1\).

It remains to bound the number of edges of a bipartite graph with a cut
vertex.  Let \(x\) be a cut vertex in one part, of size \(a\), and let the
other part have size \(b\), so \(a+b=s\).  Delete \(x\).  If the components
have part sizes \((a_i,b_i)\), then every component contains at least one
vertex of the opposite part, so at least two of the \(b_i\) are positive.
The edges incident with \(x\) contribute at most \(b\), while the remaining
edges contribute at most

\[
 \sum_i a_i b_i\le (a-1)(b-1).
\]

Hence

\[
 m\le ab-a+1.
\]

The symmetric estimate applies if the cut vertex lies in the other part.
Therefore

\[
 m\le ab-\min\{a,b\}+1
   \le \left\lfloor\frac{(s-1)^2}{4}\right\rfloor+1
   =\delta(s).
\]

For sharpness, fix any

\[
 s-1\le m\le\delta(s).
\]

Then

\[
 s-2\le m-1\le \left\lfloor\frac{(s-1)^2}{4}\right\rfloor.
\]

The connected bipartite order--size theorem supplies a connected bipartite
graph \(H\) on \(s-1\) vertices with \(m-1\) edges.  Attach one new leaf to
any vertex of \(H\).  The resulting connected bipartite graph \(J\) has
\(s\) vertices, \(m\) edges, and a cut vertex.  Its expansion \(J^+\) is a
one-point amalgamation of \(H^+\) and one triple, so it is obligatory and
one-point decomposable. \(\square\)

## A sharp three-zone phase diagram

### Corollary

Let \(m\ge1\), let \(F\) range over connected reduced obligatory triple
systems with \(m\) hyperedges and \(n\) vertices, and put \(s=n-m\).  The
feasible region is

\[
 s\ge2,
 \qquad
 s-1\le m\le\left\lfloor\frac{s^2}{4}\right\rfloor.
\]

The pair \((m,n)\) then lies in exactly one of the following regimes.

1. **Single-triple exception:** \((s,m)=(2,1)\).  The unique system is one
   triple and is indecomposable.
2. **Forced decomposable:** \(s\ge3\) and
   \[
     s-1\le m<\alpha(s).
   \]
   No 2-connected bipartite shadow with these parameters exists.
3. **Mixed:**
   \[
     \alpha(s)\le m\le\delta(s).
   \]
   Both decomposable and indecomposable obligatory systems with the same
   \((m,n)\) exist.  This interval is empty for some small \(s\).
4. **Forced indecomposable:**
   \[
     \delta(s)<m\le\left\lfloor\frac{s^2}{4}\right\rfloor.
   \]
   Every connected reduced obligatory system with these parameters consists of
   one canonical atom.

Thus the finite order--size data do more than determine existence: near the
bipartite extremal boundary they force the entire one-point decomposition to
collapse.

### Fixed-size form of the dense threshold

For \(m\ge2\), the forced-indecomposable inequality is equivalent to

\[
 s=n-m\le \left\lceil 2\sqrt{m-1}\right\rceil.
\]

Indeed,

\[
 m>\left\lfloor\frac{(s-1)^2}{4}\right\rfloor+1
\quad\Longleftrightarrow\quad
(s-1)^2<4(m-1).
\]

Combined with ordinary feasibility, this identifies the exact lower-order
strip in which every obligatory system is a single 2-connected expansion.

## Boundary examples

The theorem is sharp on both sides.

- For every admissible \(s,m\) with \(m\le\delta(s)\), a decomposable witness
  is obtained from a connected bipartite graph on \(s-1\) vertices with
  \(m-1\) edges by attaching one leaf and then taking the private-vertex
  expansion.
- For even \(s\), indecomposable witnesses start with \(C_s^+\); for odd
  \(s\ge5\), they start with the expansion of a \(C_{s-1}\) plus one new
  degree-two vertex.  Adding core edges fills the entire indecomposable
  interval.
- At the absolute upper endpoint \(m=\lfloor s^2/4\rfloor\), the core is a
  balanced complete bipartite graph, recovering the rigidity families already
  present in the finite parameter theorem.

For example, at shadow order \(s=6\), connected obligatory systems exist for
\(5\le m\le9\).  The value \(m=5\) is forced decomposable, \(m=6,7\) is
mixed, and \(m=8,9\) is forced indecomposable.

## Manuscript use

This result should be integrated compactly.

1. State the exact indecomposable and decomposable spectra immediately after
   the canonical atom corollary.
2. Present the three-zone phase diagram as the quantitative payoff.
3. Keep the two elementary graph constructions in the proof, rather than
   creating a separate extremal-graph section.
4. Reuse \(s=n-m\) from the bipartite-shadow parameter discussion.
5. Do not enlarge the Problem 593 theorem statement itself; this is a finite
   structural corollary.

A small \((s,m)\)-diagram would communicate the result better than additional
prose: the lower connected boundary \(m=s-1\), the atomic lower boundary
\(m=\alpha(s)\), the cut-vertex ceiling \(m=\delta(s)\), and the bipartite
Turán ceiling \(m=\lfloor s^2/4\rfloor\).

## Exact finite audit

`experiments/verify_indecomposable_parameter_spectrum.py` checks the theorem
independently of the hypergraph implementation.

- It exhaustively enumerates all fixed-bipartition labelled simple bipartite
  graphs for every shadow order \(2\le s\le8\), over all part-size pairs up to
  swapping the two sides.
- Among **108,622** enumerated graphs, **53,510** are connected,
  **45,318** connected graphs have a cut vertex, and **8,191** are
  2-connected.
- For every \(s\le8\), the observed connected edge spectrum is exactly
  \([s-1,\lfloor s^2/4\rfloor]\), the cut-vertex spectrum is exactly
  \([s-1,\delta(s)]\), and the 2-connected spectrum is exactly
  \([\alpha(s),\lfloor s^2/4\rfloor]\) for \(s\ge4\).
- A separate constructive audit realizes every relevant edge count through
  \(s=64\): **20,399** connected witnesses, **19,437** cut-vertex witnesses,
  and **20,307** indecomposable witnesses including the single-triple case.

The exhaustive search checks necessity at small order; the constructive audit
checks every claimed sufficiency interval over a much larger deterministic
range.

## Literature and priority boundary

The input that obligatoriness reduces to 2-connected pieces is classical in
Komjáth's work, and the canonical atom formulation is the structural result of
the preceding PR.  The graph estimates used here are elementary consequences
of the bipartite edge bound and cut-vertex decomposition.  The current version
of Li's arXiv:2606.24882 records Komjáth's 2-connected reduction and the full
obligatory classification, but a targeted check did not locate this exact
finite indecomposable/decomposable parameter phase diagram there.

Accordingly, the paper should present this as a new corollary of the present
normal form unless a broader literature check finds an earlier identical
parameter statement.  No priority claim is made for the underlying graph
extremal inequalities.
