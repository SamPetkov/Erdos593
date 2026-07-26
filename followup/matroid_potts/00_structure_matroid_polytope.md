---
title: "Graphic Shadows of Expanded Bipartite Hypergraphs"
subtitle: "Berge-cycle matroids, Tutte–Potts reductions, and monochromatic dependence"
author: "Samuil Petkov"
date: "26 July 2026"
bibliography: MATROID_POTTS_FOLLOWUP_REFERENCES.bib
link-citations: true
geometry: margin=1in
fontsize: 11pt
---

# Abstract

Fix \(r\ge2\). Let \(\mathcal B_r\) be the finite \(r\)-uniform hypergraphs
generated from private-vertex expansions of finite bipartite graphs, together
with edgeless systems, by disjoint unions and one-point amalgamations. The
bridge-block theorem associates to every reduced \(F\in\mathcal B_r\) a
bipartite graph \(J\) with the same edge set, up to a bijection, such that
Berge-cycle edge sets of \(F\) are exactly graph-cycle edge sets of \(J\).

We develop the finite algebraic and probabilistic consequences of this shadow.
The Berge cycles form the circuits of a canonical graphic matroid
\(M_{\mathrm B}(F)\), whose rank on every edge set \(A\) is

\[
r_{\mathrm B}(A)
=
|V_F(A)|-c_F(A)-(r-2)|A|.
\]

The associated hypergraphic polymatroid is the sum of this graphic rank and the
modular function \((r-2)|A|\); its base polytope is a translation of the
graphic-matroid base polytope. We derive canonical Tutte invariants, exact weak
and strong coloring polynomials, and an exact reduction of the many-body
hypergraph Potts model to a pairwise Potts model on \(J\).

For a uniformly random \(q\)-coloring, the monochromatic-edge indicators
\((X_e)\) satisfy

\[
\Pr(X_e=1\text{ for all }e\in A)
=
q^{-(r-2)|A|-r_{\mathrm B}(A)}.
\]

Thus Berge-acyclic edge sets are exactly mutually independent event families,
Berge circuits are the minimal dependencies, and the full labelled
monochromatic-edge process is determined by the labelled matroid. The first
factorial moment that differs from a binomial law recovers the Berge girth and
the number of shortest Berge cycles. Diverging Berge girth gives exact
fixed-order binomial moments and hence Poisson and Gaussian transfer theorems.
For \(q=2\), bipartiteness of \(J\) gauges the antiferromagnetic model to a
ferromagnetic Ising model, yielding an approximation algorithm once a shadow
certificate is supplied.

The results are conditional only on the finite cycle-shadow theorem, not on the
still-audited all-uniformity classification of obligatory hypergraphs.

# 1. Structural setting

## 1.1. Uniform expansions

Let \(J\) be a finite simple graph. Its \(r\)-uniform expansion \(J^{(r)}\) is
obtained by replacing every graph edge \(uv\) with

\[
\{u,v\}\cup P_{uv},
\]

where \(P_{uv}\) is a new set of \(r-2\) private vertices and the sets
\(P_{uv}\) are pairwise disjoint and disjoint from \(V(J)\).

Let \(\mathcal B_r\) be the smallest class of finite \(r\)-uniform hypergraphs
that contains every \(J^{(r)}\) with \(J\) bipartite, contains every finite
edgeless system, and is closed under disjoint unions and one-point
amalgamations.

For \(r=3\), the finite classification of Erdős Problem 593 identifies
\(\mathcal B_3\), after isolated vertices are removed, with the obligatory
triple systems [@li2026]. Reiher's expansion theorem and the standard closure
operations imply that every member of \(\mathcal B_r\) is obligatory for every
finite \(r\) [@reiher2024]. None of the results below requires the converse for
\(r\ge4\).

Throughout, \(F\in\mathcal B_r\) is finite and reduced, and

\[
n=|V(F)|,\qquad m=|E(F)|,\qquad c=c(F).
\]

For \(A\subseteq E(F)\), write \(V_F(A)\) for the set of points incident with
an edge of \(A\), and \(c_F(A)\) for the number of components of the supported
incidence subsystem on \(A\cup V_F(A)\). We set both quantities to zero when
\(A=\varnothing\).

## 1.2. Cycle-shadow input

The finite bridge-block theorem gives a finite simple bipartite graph \(J\),
without isolated vertices, and an edge bijection

\[
\varphi:E(F)\longrightarrow E(J)
\]

with the following properties:

1. a subset \(C\subseteq E(F)\) is the edge set of a Berge cycle in \(F\) if
   and only if \(\varphi(C)\) is the edge set of a graph cycle in \(J\);
2. cycle lengths are preserved;
3. \(J\) has \(m\) edges and \(c\) components;
4.
   \[
   |V(J)|=n-(r-2)m.
   \tag{1.1}
   \]

The graph \(J\) is called a **cycle shadow** of \(F\). It need not be unique,
but its cycle matroid will be canonical.

# 2. The canonical Berge-cycle matroid

## Theorem 2.1. Circuit theorem

The edge sets of Berge cycles of \(F\) are the circuits of a matroid on
\(E(F)\). Under every cycle-shadow bijection, this matroid is isomorphic to the
ordinary cycle matroid \(M(J)\).

We denote it by

\[
M_{\mathrm B}(F)
\]

and call it the **Berge-cycle matroid**.

### Proof

Transport the cycle matroid \(M(J)\) from \(E(J)\) to \(E(F)\) through
\(\varphi\). By the cycle-shadow theorem, the transported circuits are exactly
the Berge-cycle edge sets. A matroid is determined by its circuits, so the
result is independent of the selected cycle shadow. \(\square\)

Hence \(M_{\mathrm B}(F)\) is graphic, binary, regular, and representable over
every field. It also has a bipartite graphic representation.

## Theorem 2.2. Intrinsic subset-rank formula

For every \(A\subseteq E(F)\),

\[
\boxed{
r_{\mathrm B}(A)
=
|V_F(A)|-c_F(A)-(r-2)|A|.
}
\tag{2.1}
\]

In particular,

\[
\boxed{
\rho:=r_{\mathrm B}(E(F))
=
n-(r-2)m-c,
}
\tag{2.2}
\]

and

\[
\boxed{
\beta:=m-\rho
=
(r-1)m-n+c.
}
\tag{2.3}
\]

### Proof

Delete the hyperedges outside \(A\) and then remove isolated vertices. The
result remains in \(\mathcal B_r\): on every expansion atom this operation
deletes graph edges, and the closure operations remain valid after empty
pieces are discarded.

Apply the cycle-shadow theorem to this supported subsystem. Its shadow has
\(|A|\) edges,

\[
|V_F(A)|-(r-2)|A|
\]

vertices, and \(c_F(A)\) connected components. The rank of a graphic cycle
matroid is the number of vertices minus the number of connected components.
This gives (2.1). Equations (2.2) and (2.3) follow by taking
\(A=E(F)\). \(\square\)

## Corollary 2.3. Forests, feedback sets, and the cycle space

For \(A\subseteq E(F)\), the following are equivalent:

1. \(A\) is independent in \(M_{\mathrm B}(F)\);
2. the supported subsystem \(F[A]\) has no Berge cycle.

Consequently:

\[
\max\{|A|:F[A]\text{ is Berge-acyclic}\}=\rho,
\]

every maximal Berge-acyclic edge set has exactly \(\rho\) edges, and

\[
\min\{|D|:F-D\text{ is Berge-acyclic}\}=\beta.
\]

The binary Berge-cycle space has dimension \(\beta\) and therefore contains

\[
2^\beta
\]

elements.

The number of maximal Berge forests is the number of spanning forests of any
cycle shadow. In the connected case, the Matrix--Tree theorem computes it as a
cofactor of the shadow Laplacian.

## Definition 2.4. Canonical Tutte polynomial

Define

\[
T_F(x,y)
=
T_{M_{\mathrm B}(F)}(x,y)
=
\sum_{A\subseteq E(F)}
(x-1)^{\rho-r_{\mathrm B}(A)}
(y-1)^{|A|-r_{\mathrm B}(A)}.
\tag{2.4}
\]

Berge cycles do not cross disjoint unions or one-point amalgamations, so the
matroid is a direct sum under either operation. Hence

\[
T_{F_1\sqcup F_2}=T_{F_1}T_{F_2},
\qquad
T_{F_1\vee F_2}=T_{F_1}T_{F_2}.
\tag{2.5}
\]

If the bridge-block decomposition has expansion pieces
\(J_1^{(r)},\ldots,J_k^{(r)}\), then

\[
T_F(x,y)=\prod_{i=1}^k T_{J_i}(x,y).
\tag{2.6}
\]

This is the ordinary Tutte polynomial of the canonical Berge-cycle matroid,
not a new general definition of a hypergraph Tutte polynomial.

# 3. Polymatroid and base-polytope collapse

Let \(\kappa_F(A)\) be the number of connected components of the **spanning**
subhypergraph \((V(F),A)\); vertices outside \(V_F(A)\) are counted as isolated
components. Then

\[
\kappa_F(A)=c_F(A)+n-|V_F(A)|.
\tag{3.1}
\]

Define the associated hypergraphic rank

\[
p_F(A)=n-\kappa_F(A).
\]

For an \(r\)-uniform hypergraph this is an \((r-1)\)-polymatroid rank function.

## Theorem 3.1. Modular-plus-graphic decomposition

For every \(A\subseteq E(F)\),

\[
\boxed{
p_F(A)=(r-2)|A|+r_{\mathrm B}(A).
}
\tag{3.2}
\]

### Proof

Substitute (3.1) into (2.1):

\[
\begin{aligned}
p_F(A)
&=n-\kappa_F(A)\\
&=|V_F(A)|-c_F(A)\\
&=(r-2)|A|+r_{\mathrm B}(A).
\end{aligned}
\]

\(\square\)

Thus every nonmodular dependence in the hypergraphic polymatroid is graphic.
Changing the uniformity contributes only the modular term \((r-2)|A|\).

## Theorem 3.2. Base-polytope translation

Let

\[
B(p_F)
=
\left\{
x\in\mathbb R^{E(F)}:
x(A)\le p_F(A)\ \forall A\subseteq E(F),\
x(E(F))=p_F(E(F))
\right\}
\]

be the polymatroid base polytope, and let \(B(M_{\mathrm B}(F))\) be the
matroid base polytope. If \(\mathbf 1\) denotes the all-one vector on
\(E(F)\), then

\[
\boxed{
B(p_F)
=
(r-2)\mathbf 1+B(M_{\mathrm B}(F)).
}
\tag{3.3}
\]

### Proof

Put \(y=x-(r-2)\mathbf 1\). By (3.2),

\[
x(A)\le p_F(A)
\quad\Longleftrightarrow\quad
y(A)\le r_{\mathrm B}(A)
\]

for every \(A\), and

\[
x(E)=p_F(E)
\quad\Longleftrightarrow\quad
y(E)=\rho.
\]

These are exactly the defining inequalities of the matroid base polytope.
\(\square\)

## Corollary 3.3. Integer bases and weighted optimization

Every integer point \(x\in B(p_F)\) has coordinates in
\(\{r-2,r-1\}\). The set

\[
\{e:x_e=r-1\}
\]

is a basis of \(M_{\mathrm B}(F)\), equivalently a maximal Berge forest.
Conversely every maximal Berge forest gives such an integer point.

Therefore:

1. the number of integer polymatroid bases equals the number of maximal Berge
   forests;
2. the face lattice, Ehrhart polynomial, normalized volume, and
   \(h^\ast\)-polynomial of \(B(p_F)\) agree with those of the graphic matroid
   base polytope;
3. linear optimization reduces to a weighted spanning-forest problem:
   \[
   \max_{x\in B(p_F)}w\cdot x
   =
   (r-2)\sum_{e\in E(F)}w_e
   +
   \max_{B\text{ basis of }M_{\mathrm B}(F)}
   \sum_{e\in B}w_e.
   \tag{3.4}
   \]

The translation invariance of polymatroid Tutte theory is classical
[@bernardi2020]; the contribution here is the explicit identification (3.3)
forced by the bridge-block structure.

