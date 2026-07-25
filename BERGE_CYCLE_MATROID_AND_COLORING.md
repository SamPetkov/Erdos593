# Berge-cycle matroids, Tutte invariants, and Potts colorings

**Status:** proved finite consequences of the bridge-block classification, with
deterministic finite verification. This note is separate from the current
Problem 593 manuscript and from the still-audited all-uniformity avoidance
claim.

## 1. Setting

Fix an integer \(r\ge 2\). For a finite graph \(J\), write \(J^{(r)}\) for
the \(r\)-uniform expansion obtained by adjoining \(r-2\) new private vertices
to each graph edge. Let \(\mathcal B_r\) be the smallest class containing
\(J^{(r)}\) for every finite bipartite graph \(J\), together with finite
edgeless systems, and closed under disjoint unions and one-point
amalgamations.

Throughout, \(F\in\mathcal B_r\) is finite and reduced (it has no isolated
vertices), with

\[
n=|V(F)|,\qquad m=|E(F)|,\qquad c=c(F).
\]

The uniform bridge-block theorem gives a finite bipartite **cycle shadow**
\(J\), without isolated vertices, and an edge bijection

\[
\phi:E(F)\longrightarrow E(J)
\]

such that a set of hyperedges is the edge set of a Berge cycle in \(F\) if
and only if its image is the edge set of an ordinary cycle in \(J\). Moreover

\[
|E(J)|=m,\qquad |V(J)|=n-(r-2)m,\qquad c(J)=c.
\tag{1.1}
\]

The graph \(J\) is not necessarily unique. The invariants below are
independent of its choice.

## 2. The canonical Berge-cycle matroid

### Theorem 2.1

The edge sets of Berge cycles of \(F\) are the circuits of a matroid on
\(E(F)\). Under any cycle-shadow bijection \(\phi\), this matroid is
isomorphic to the ordinary cycle matroid \(M(J)\).

We denote it by

\[
M_{\mathrm B}(F)
\]

and call it the **Berge-cycle matroid** of \(F\).

#### Proof

The cycle-shadow bijection sends the proposed circuit family exactly to the
circuits of the graphic matroid \(M(J)\). Pulling the matroid structure back
along \(\phi\) proves existence. Since a matroid is determined by its
circuits, the resulting matroid does not depend on which cycle shadow is
chosen. \(\square\)

Thus \(M_{\mathrm B}(F)\) is graphic, binary, regular, and representable over
every field. It has a bipartite graphic representation.

For \(A\subseteq E(F)\), let \(V_F(A)\) be the set of points incident with at
least one edge of \(A\), and let \(c_F(A)\) be the number of connected
components of the incidence graph of the subsystem on \(A\) and \(V_F(A)\).
Put both quantities equal to zero when \(A=\varnothing\).

### Theorem 2.2: intrinsic rank formula

For every \(A\subseteq E(F)\),

\[
\boxed{
\operatorname{rk}_{\mathrm B}(A)
=
|V_F(A)|-c_F(A)-(r-2)|A|.
}
\tag{2.1}
\]

In particular, the global rank and nullity are

\[
\boxed{
\rho(F)=n-(r-2)m-c,
\qquad
\beta(F)=(r-1)m-n+c.
}
\tag{2.2}
\]

#### Proof

Deleting hyperedges preserves membership in \(\mathcal B_r\), after isolated
vertices are removed. Apply the cycle-shadow theorem to the subsystem
\(F[A]\). Its shadow has \(|A|\) edges,

\[
|V_F(A)|-(r-2)|A|
\]

vertices, and \(c_F(A)\) components. The rank of its cycle matroid is its
number of vertices minus its number of components, giving (2.1). Equation
(2.2) is the case \(A=E(F)\). \(\square\)

### Corollary 2.3: Berge forests and feedback sets

1. A set \(A\subseteq E(F)\) is independent in \(M_{\mathrm B}(F)\) exactly
   when the subsystem \(F[A]\) contains no Berge cycle.
2. Every maximal Berge-acyclic edge set has the same cardinality
   \(\rho(F)\).
3. The minimum number of hyperedges whose deletion destroys every Berge
   cycle is exactly
   \[
   \beta(F)=(r-1)m-n+c.
   \]
4. The number of maximal Berge-acyclic edge sets is the number of spanning
   forests of any cycle shadow \(J\). For connected \(F\), it is the
   spanning-tree number of \(J\), hence is computable by the Matrix--Tree
   theorem.

These equicardinality and exact feedback statements need not hold for an
arbitrary family of hypergraph cycles; here they follow from graphic
matroidality.

### Definition 2.4: canonical Tutte polynomial

Define

\[
T_F(x,y):=T_{M_{\mathrm B}(F)}(x,y).
\tag{2.3}
\]

Equivalently,

\[
T_F(x,y)
=
\sum_{A\subseteq E(F)}
(x-1)^{\rho(F)-\operatorname{rk}_{\mathrm B}(A)}
(y-1)^{|A|-\operatorname{rk}_{\mathrm B}(A)}.
\tag{2.4}
\]

For a one-point amalgamation or disjoint union, Berge cycles stay inside one
factor. Consequently the Berge-cycle matroid is a direct sum and

\[
T_{F_1\vee F_2}=T_{F_1}T_{F_2},
\qquad
T_{F_1\sqcup F_2}=T_{F_1}T_{F_2}.
\tag{2.5}
\]

If \(F\) is assembled from expansion pieces \(J_i^{(r)}\), then

\[
T_F(x,y)=\prod_i T_{J_i}(x,y).
\tag{2.6}
\]

This is the ordinary Tutte polynomial of a canonical matroid. It is
different from other hypergraph Tutte polynomials built from hypertrees or
polymatroids.

## 3. Weak coloring polynomial as an antiferromagnetic Potts model

Let \(W_F(q)\) be the number of colorings

\[
V(F)\longrightarrow [q]
\]

with no monochromatic hyperedge.

### Theorem 3.1: matroid rank formula

For every positive integer \(q\),

\[
\boxed{
W_F(q)
=
\sum_{A\subseteq E(F)}
(-1)^{|A|}
q^{\,n-(r-2)|A|-\operatorname{rk}_{\mathrm B}(A)}.
}
\tag{3.1}
\]

The right-hand side is therefore the weak chromatic polynomial of \(F\).

#### Proof

Use inclusion--exclusion over the events that a hyperedge is monochromatic.
If every edge in \(A\) is required to be monochromatic, all vertices inside
one connected component of \(F[A]\) must receive one common color. Vertices
outside \(V_F(A)\) remain free. Hence the number of such colorings is

\[
q^{\,n-|V_F(A)|+c_F(A)}.
\]

Substituting the rank identity (2.1) gives (3.1). \(\square\)

A first consequence is a rigidity statement.

### Corollary 3.2: color-equivalence from cycle data

The weak chromatic polynomial of \(F\) is determined by

\[
r,\quad n,\quad\text{and}\quad M_{\mathrm B}(F).
\]

In particular, two reduced members of \(\mathcal B_r\) with the same order
and isomorphic Berge-cycle matroids have the same weak chromatic polynomial,
even when their one-point attachment geometry is different.

Now let

\[
Z_J(q,v)
=
\sum_{A\subseteq E(J)}q^{k_J(A)}v^{|A|}
\tag{3.2}
\]

be the Fortuin--Kasteleyn/random-cluster form of the \(q\)-state Potts
partition function, where \(k_J(A)\) counts the components of the spanning
subgraph \((V(J),A)\).

### Theorem 3.3: Potts representation

For every cycle shadow \(J\),

\[
\boxed{
W_F(q)
=
q^{(r-2)m}
Z_J\!\left(q,-q^{-(r-2)}\right).
}
\tag{3.3}
\]

#### Proof

For the shadow matroid,

\[
k_J(A)=|V(J)|-\operatorname{rk}_{\mathrm B}(A).
\]

Using (1.1), the exponent in (3.1) becomes

\[
n-(r-2)|A|-\operatorname{rk}_{\mathrm B}(A)
=
(r-2)(m-|A|)+k_J(A).
\]

Factoring \(q^{(r-2)m}\) gives (3.3). \(\square\)

There is also a direct spin interpretation. For one expansion atom
\(J^{(r)}\), fix colors on the core vertices of \(J\). For a core edge
\(uv\),

- if the endpoint colors differ, its \(r-2\) private vertices have
  \(q^{r-2}\) assignments;
- if the endpoint colors agree, exactly one private assignment is forbidden,
  leaving \(q^{r-2}-1\).

Thus each graph edge has effective Potts factor

\[
q^{r-2}
\left(1-q^{-(r-2)}
\mathbf 1_{\{\sigma(u)=\sigma(v)\}}\right).
\]

The private expansion vertices therefore renormalize the weak-coloring
problem to an antiferromagnetic Potts model at

\[
v_r=-q^{-(r-2)}.
\tag{3.4}
\]

As the uniformity grows, \(v_r\) approaches the independent-spin point
\(v=0\).

### Corollary 3.4: Tutte evaluation

Let \(\rho=\rho(F)\) and \(\beta=\beta(F)=m-\rho\). Then

\[
\boxed{
W_F(q)
=
(-1)^\rho
q^{(r-2)\beta+c}
T_F\!\left(1-q^{r-1},\,1-q^{-(r-2)}\right).
}
\tag{3.5}
\]

Although the displayed Tutte evaluation contains negative powers of \(q\),
the prefactor cancels them; the polynomial form is (3.1).

For \(r=2\), equation (3.5) reduces to the usual chromatic-polynomial
evaluation of the Tutte polynomial.

## 4. Strong coloring polynomial

Let \(S_F(q)\) count colorings in which every hyperedge is rainbow. Put

\[
\lambda_r(q)
=
(q-2)_{\underline{r-2}}
=
(q-2)(q-3)\cdots(q-r+1),
\tag{4.1}
\]

with the empty product equal to \(1\) for \(r=2\).

### Theorem 4.1

For every cycle shadow \(J\),

\[
\boxed{
S_F(q)=\lambda_r(q)^m P_J(q),
}
\tag{4.2}
\]

where \(P_J(q)\) is the ordinary graph chromatic polynomial.

Equivalently,

\[
\boxed{
S_F(q)
=
(-1)^\rho q^c\lambda_r(q)^m T_F(1-q,0).
}
\tag{4.3}
\]

#### Proof

For one atom \(J^{(r)}\), the two core endpoints of every edge must have
different colors, giving \(P_J(q)\) core colorings. The \(r-2\) private
vertices on each edge then receive distinct colors chosen in order from the
remaining \(q-2\) colors, giving \(\lambda_r(q)\) choices independently per
edge.

If two hypergraphs are amalgamated at one point, the number of valid
colorings with that point fixed to a prescribed color is \(1/q\) of the
total, by color symmetry. Hence both weak and strong coloring polynomials
multiply with a factor \(1/q\) under one-point amalgamation. The same
factorization holds for graph chromatic polynomials under a graph one-vertex
sum. Applying this over the bridge-block decomposition proves (4.2). The
standard graphic-matroid identity

\[
P_J(q)=(-1)^\rho q^cT_{M(J)}(1-q,0)
\]

gives (4.3). \(\square\)

### Corollary 4.2

Every nonempty \(F\in\mathcal B_r\) has strong chromatic number exactly \(r\),
and the exact number of strong \(r\)-colorings is

\[
S_F(r)=((r-2)!)^m P_J(r).
\tag{4.4}
\]

The equality of the strong chromatic number with the rank is classical for
balanced hypergraphs; equation (4.4) supplies the complete count for this
class.

## 5. Closed forms at small cycle rank

### Corollary 5.1: Berge forests

Suppose \(\beta(F)=0\). Then the Levi graph is a forest and

\[
n=(r-1)m+c.
\]

The Berge-cycle matroid is the free matroid on \(m\) elements, so

\[
\boxed{
W_F(q)=q^c\left(q^{r-1}-1\right)^m,
}
\tag{5.1}
\]

and

\[
\boxed{
S_F(q)=q^c
\left((q-1)_{\underline{r-1}}\right)^m.
}
\tag{5.2}
\]

Thus all reduced \(r\)-uniform Berge forests with the same \(m\) and \(c\)
are indistinguishable by both weak and strong coloring polynomials.

These hypertree formulas are known in broader chromatic-polynomial
literature; here they appear as the nullity-zero specialization of the
canonical matroid formula.

### Corollary 5.2: connected unicyclic systems

Suppose \(F\) is connected and \(\beta(F)=1\). Then
\(M_{\mathrm B}(F)\) has one circuit, of an even length \(\ell\), and
\(m-\ell\) coloops. Put

\[
X_r(q)=q^{r-1}-1.
\]

Then

\[
\boxed{
W_F(q)
=
X_r(q)^{m-\ell}
\left(X_r(q)^\ell+q-1\right),
}
\tag{5.3}
\]

and

\[
\boxed{
S_F(q)
=
\lambda_r(q)^m
(q-1)^{m-\ell}
\left((q-1)^\ell+q-1\right).
}
\tag{5.4}
\]

Consequently, all connected unicyclic members of \(\mathcal B_r\) with the
same \(m\) and unique Berge-circuit length \(\ell\) have identical weak and
strong coloring polynomials, independently of how trees are attached.

The feedback number is \(1\), and the number of maximal Berge forests is
exactly \(\ell\).

## 6. Transfer principle

The cycle shadow transfers every invariant depending only on the cycle
matroid:

- ranks and nullities of all hyperedge subsets;
- the Tutte and rank-generating polynomials;
- the number of maximal Berge forests;
- feedback-edge number;
- cycle-space dimension and the number \(2^{\beta(F)}\) of binary
  Berge-cycle-space elements;
- reliability, flow, and tension evaluations of the cycle matroid.

The two coloring identities above are stronger: after the elementary
uniformity factors are included, both weak and strong vertex-coloring
polynomials are evaluations of this same canonical Tutte invariant.

## 7. Computational verification

The script

```text
experiments/berge_matroid_coloring.py
```

constructs expansion atoms and one-point amalgamations for \(r=3,4,5\).
Attachments include private points and a one-edge atom with several distinct
hypergraph attachment points, while the independently chosen graph shadow
uses only two core endpoints.

For every tested edge subset it checks

\[
\operatorname{rk}_{\mathrm B}(A)
=
|V_F(A)|-c_F(A)-(r-2)|A|
=
\operatorname{rk}_{J}(A)
\]

and equality of the incidence nullity with the shadow cycle nullity. It then
compares:

1. direct hypergraph inclusion--exclusion;
2. the matroid rank formula (3.1);
3. the Potts expression (3.3);
4. direct weak-coloring enumeration on the small cases;
5. direct strong-coloring enumeration against (4.2);
6. the forest and unicyclic closed forms.

The checked result is in

```text
experiments/berge_matroid_coloring_results.json
```

and is reproduced in GitHub Actions.

## 8. Literature and novelty boundary

The general theory of hypergraph chromatic polynomials is classical; see,
among others:

- M. Walter, *Some Results on Chromatic Polynomials of Hypergraphs*,
  Electronic Journal of Combinatorics 16 (2009), R94;
- J. A. White, *On Multivariate Chromatic Polynomials of Hypergraphs and
  Hyperedge Elimination*, Electronic Journal of Combinatorics 18 (2011),
  P160.

The graph/matroid Potts--Tutte dictionary used in Section 3 is standard; see:

- A. D. Sokal, *The multivariate Tutte polynomial (alias Potts model) for
  graphs and matroids*, Surveys in Combinatorics (2005),
  arXiv:math/0503607.

The equality of strong chromatic number and rank for balanced hypergraphs
goes back to:

- C. Berge, *Balanced matrices*, Mathematical Programming 2 (1972), 19--31.

Other notions called a hypergraph Tutte polynomial exist, notably the
hypertree/polymatroid invariant of Kálmán. The invariant \(T_F\) here is
instead the ordinary Tutte polynomial of the canonical Berge-cycle matroid.

The structural inputs are the obligatory-system classification and the
uniform bridge-block decomposition. A targeted search of those sources and
the chromatic-polynomial literature did not locate the combined canonical
Berge-cycle-matroid theorem, the rank formula (2.1), or the exact weak/strong
Potts--Tutte identities (3.1)--(4.3) for the obligatory
expansion-amalgamation class. This is a targeted source screen, not an
absolute priority claim.
