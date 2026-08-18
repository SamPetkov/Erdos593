# Boundary rigidity for the canonical atom spectra

## Purpose

The canonical atom theorem and the exact indecomposability spectrum determine
the parameter intervals in which a connected reduced obligatory triple system
is decomposable, may be indecomposable, or must be indecomposable.  The
endpoints themselves have additional structure.  This note classifies them
exactly.

Let \(F\) be connected and reduced, with \(m\) hyperedges and \(n\) points, and
put

\[
 s=n-m.
\]

Thus \(s\) is the order of a connected bipartite parameter shadow.  Define

\[
 \alpha(s)=
 \begin{cases}
 s,&s\ \text{even},\\
 s+1,&s\ \text{odd},
 \end{cases}
 \qquad
 \delta(s)=
 \left\lfloor\frac{(s-1)^2}{4}\right\rfloor+1.
\]

The indecomposable interval is

\[
 \alpha(s)\le m\le\left\lfloor\frac{s^2}{4}\right\rfloor
 \qquad(s\ge4),
\]

and the decomposable interval ends at \(m=\delta(s)\).

For positive integers \(p,q,r\), write
\(\Theta(p,q,r)\) for the theta graph formed by three internally disjoint paths
of lengths \(p,q,r\) with common endpoints.  For a graph \(J\), \(J^+\) denotes
its private-vertex expansion.

## Atomic lower-bound rigidity

### Theorem

Let \(F\) be a connected reduced one-point-indecomposable obligatory triple
system other than one triple.  Put \(s=n-m\).  Then \(s\ge4\) and
\(m\ge\alpha(s)\).  Equality is classified as follows.

1. If \(s\) is even, then
   \[
   m=s
   \quad\Longleftrightarrow\quad
   F\cong C_s^+.
   \]
   In particular, the lower-bound system is unique up to isomorphism.

2. If \(s\) is odd, then
   \[
   m=s+1
   \quad\Longleftrightarrow\quad
   F\cong\Theta(2a,2b,2c)^+
   \]
   for positive integers \(a\le b\le c\) satisfying
   \[
   a+b+c=\frac{s+1}{2}.
   \]

Consequently, for odd \(s\ge5\), the number of isomorphism types on the atomic
lower boundary is

\[
 \boxed{
 \left\lfloor
 \frac{\bigl((s+1)/2\bigr)^2+3}{12}
 \right\rfloor.
 }
\]

### Proof

By the canonical atom theorem, \(F\cong J^+\) for a finite 2-connected simple
bipartite graph \(J\), and

\[
 |V(J)|=s,\qquad |E(J)|=m.
\]

Every vertex of \(J\) has degree at least two.

Suppose first that \(s\) is even and \(m=s\).  The average degree is two, so
every vertex has degree two.  A connected 2-regular graph is a cycle, and
bipartiteness forces that cycle to have even length.  Thus \(J\cong C_s\).
The converse is immediate.

Now suppose that \(s\) is odd and \(m=s+1\).  Then

\[
 \sum_{v\in V(J)}(\deg v-2)=2m-2s=2.
\]

There are only two possible degree-excess patterns:

- one vertex of degree four and every other vertex of degree two; or
- two vertices of degree three and every other vertex of degree two.

The first pattern is incompatible with 2-connectivity.  Deleting the
degree-four vertex leaves at least two path components, because all remaining
vertices have degree two in \(J\) and no one path can absorb all four incident
half-edges.  The degree-four vertex would therefore be a cut vertex.

Hence \(J\) has exactly two degree-three vertices, say \(x,y\), and every other
vertex has degree two.  Suppressing the degree-two chains shows that \(J\) is a
theta graph with three internally disjoint \(x\)-\(y\) paths.  Bipartiteness
forces the three path lengths to have the same parity, since the union of any
two paths is an even cycle.  Their sum is

\[
 |E(J)|=s+1,
\]

which is even.  Thus all three path lengths are even, giving
\(J\cong\Theta(2a,2b,2c)\).  Conversely, every such theta graph is finite,
simple, bipartite and 2-connected, has \(s\) vertices and \(s+1\) edges, and
therefore gives an atomic lower-bound system after expansion.

The isomorphism type of a theta graph is determined by the unordered multiset
of its three path lengths.  The number of positive integer triples
\(a\le b\le c\) with sum \(N\) is

\[
 \sum_{a=1}^{\lfloor N/3\rfloor}
 \left(
 \left\lfloor\frac{N-a}{2}\right\rfloor-a+1
 \right)
 =
 \left\lfloor\frac{N^2+3}{12}\right\rfloor.
\]

Taking \(N=(s+1)/2\) proves the count. \(\square\)

## Atomic upper-bound rigidity

### Theorem

Let \(F\) be as above.  Then

\[
 m\le\left\lfloor\frac{s^2}{4}\right\rfloor,
\]

with equality if and only if

\[
 \boxed{
 F\cong K_{\lfloor s/2\rfloor,\lceil s/2\rceil}^{+}.
 }
\]

### Proof

Write the bipartition sizes of the 2-connected core \(J\) as \(a+b=s\).
Simplicity gives

\[
 m\le ab\le\left\lfloor\frac{s^2}{4}\right\rfloor.
\]

Equality in the second inequality forces
\(\{a,b\}=\{\lfloor s/2\rfloor,\lceil s/2\rceil\}\), and equality in the first
forces every cross-edge to be present.  Thus \(J\) is the balanced complete
bipartite graph.  The converse is immediate. \(\square\)

## The cut-vertex extremal lemma

### Lemma

Let \(J\) be a connected simple bipartite graph on \(s\ge3\) vertices with a
cut vertex.  Then

\[
 |E(J)|\le
 \delta(s)=
 \left\lfloor\frac{(s-1)^2}{4}\right\rfloor+1.
\]

Equality holds if and only if \(J\) is obtained from the balanced complete
bipartite graph on \(s-1\) vertices by adjoining one leaf at an arbitrary
vertex.

### Proof

Let the bipartition be \(A\sqcup B\), with \(|A|=a\), \(|B|=b\), and suppose
that a cut vertex \(x\) lies in \(A\).  Let the components of \(J-x\) have
bipartition sizes \((a_i,b_i)\).  Every component contains a vertex of \(B\);
otherwise it could not be joined to \(x\) in the original bipartite graph.
There are at least two components, so \(b_i\le b-1\) for every \(i\).  Therefore

\[
\begin{aligned}
 |E(J)|
 &\le b+\sum_i a_i b_i\\
 &\le b+(a-1)(b-1)\\
 &=ab-a+1.
\end{aligned}
\]

If the cut vertex lies in \(B\), the symmetric estimate is
\(|E(J)|\le ab-b+1\).  In either case,

\[
 |E(J)|\le ab-\min(a,b)+1.
\]

Maximising over \(a+b=s\) gives

\[
 \max_{a+b=s}\bigl(ab-\min(a,b)+1\bigr)
 =
 \left\lfloor\frac{(s-1)^2}{4}\right\rfloor+1.
\]

For equality, all inequalities above must be equalities.  If the cut-vertex
side has size at least two, the cut vertex is adjacent to every vertex on the
opposite side; all but one of those opposite-side vertices lie in one
component of \(J-x\); every remaining vertex on the cut-vertex side lies in
that same component; and all possible cross-edges in the large component are
present.  The remaining component is one isolated opposite-side vertex, which
is a leaf in \(J\).  Removing it leaves a complete bipartite graph on
\(s-1\) vertices.

If the cut-vertex side has size one, then \(J\) is a star.  Equality in the
global bound occurs only for \(s=3\) or \(s=4\), and the same conclusion
still holds: remove one leaf and the remainder is the balanced complete
bipartite graph on \(s-1\) vertices.  In every case, equality in the final
maximisation makes the complete bipartite remainder balanced.

Conversely, adjoining a leaf to a balanced complete bipartite graph on
\(s-1\) vertices gives a connected bipartite graph with a cut vertex and
exactly \(\delta(s)\) edges. \(\square\)

## Decomposable upper-bound rigidity

### Theorem

Let \(F\) be a connected reduced one-point-decomposable obligatory triple
system, with \(s=n-m\).  Then

\[
 m\le\delta(s).
\]

Equality holds if and only if there are integers \(a,b\ge1\) with

\[
 a+b=s-1,\qquad |a-b|\le1,
\]

such that \(F\) is a one-point amalgamation of \(K_{a,b}^{+}\) and one
additional triple.  The amalgamation point may be any point of either system.

For \(s\ge5\), the canonical atom forest therefore has exactly two atoms:

- one atom \(K_{a,b}^{+}\); and
- one single-triple atom.

For \(s=3,4\), the same statement holds with \(K_{a,b}^{+}\) itself decomposing
into single-triple atoms.

### Proof

The canonical atom forest supplies a connected bipartite parameter shadow
whose blocks are the atom cores.  Since \(F\) is decomposable, this shadow has
a cut vertex.  The cut-vertex extremal lemma gives the bound.

At equality, the shadow is a balanced complete bipartite graph on \(s-1\)
vertices plus one leaf.  Its nontrivial block is \(K_{a,b}\), and its remaining
edge is a bridge.  Translating the block decomposition back through the
canonical atom theorem gives \(K_{a,b}^{+}\) together with one single-triple
piece.  The actual one-point identification in \(F\) may occur at a core point
or at a private point; this does not change the parameter shadow or the atom
multiset.

Conversely, any one-point amalgamation of \(K_{a,b}^{+}\) and one triple has

\[
 m=ab+1,\qquad s=a+b+1.
\]

For balanced \(a,b\), this is exactly \(m=\delta(s)\). \(\square\)

## Complete boundary table

For connected reduced obligatory systems, excluding the single triple, the
extremal boundaries are therefore:

| Regime | Edge count | Exact structure |
|---|---:|---|
| decomposable lower boundary | \(m=s-1\) | Berge forest; every canonical atom is one triple |
| atomic lower boundary, \(s\) even | \(m=s\) | \(C_s^+\) |
| atomic lower boundary, \(s\) odd | \(m=s+1\) | \(\Theta(2a,2b,2c)^+\) |
| decomposable upper boundary | \(m=\delta(s)\) | balanced \(K_{a,b}^+\) plus one triple |
| atomic upper boundary | \(m=\lfloor s^2/4\rfloor\) | balanced \(K_{\lfloor s/2\rfloor,\lceil s/2\rceil}^+\) |

The first row is flexible; the other four rows are rigid up to the explicitly
listed cycle, theta, attachment, or bipartition choices.

## Manuscript placement

This material should not become a separate long section.  After the
indecomposability phase diagram, the final paper can state:

1. the atomic lower-bound classification;
2. the decomposable ceiling rigidity lemma;
3. the balanced-complete upper endpoint as a one-line corollary; and
4. the five-row boundary table.

The theta enumeration is suitable for a remark or appendix.

## Exact finite audit

`experiments/verify_canonical_atom_boundary_rigidity.py` checks the
graph-theoretic reduction independently.

Its exhaustive fixed-bipartition search through \(s=8\) covers:

- 108,622 labelled bipartite graphs;
- 53,510 connected graphs;
- 116 atomic lower-bound graphs;
- 97 decomposable upper-bound graphs; and
- 5 atomic upper-bound graphs.

Every atomic lower-bound graph is a cycle or an even theta as prescribed.
Every decomposable upper-bound graph is a balanced complete bipartite graph
plus a leaf.  Every atomic upper-bound graph is balanced complete bipartite.

The constructive audit through \(s=64\) checks:

- 981 atomic lower-bound witnesses;
- all 950 odd-order theta isomorphism types in that range;
- 61 atomic upper-bound witnesses; and
- 62 decomposable upper-bound witnesses.

The arithmetic audit checks the cut-vertex maximisation through \(s=4096\),
performing 16,773,118 bipartition-side checks, and verifies the theta partition
formula for 2,046 odd orders.

## Literature and priority boundary

The block-cut reduction is classical, and Komjáth's reduction of obligatoriness
to 2-connected components predates the present classification.  The complete
bipartite extremal bound and the degree-excess description of bicyclic
2-connected graphs are elementary graph theory.  The point of the result is
their exact translation into the canonical atom and finite-spectrum language
of Problem 593.

No absolute novelty claim is made.  These statements are presented as
structural corollaries under review.
