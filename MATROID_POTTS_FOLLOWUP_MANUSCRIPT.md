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


# 4. Weak colorings and the antiferromagnetic Potts model

Let \(W_F(q)\) count vertex colorings \(V(F)\to[q]\) with no monochromatic
hyperedge.

## Theorem 4.1. Rank expansion of the weak chromatic polynomial

For every positive integer \(q\),

\[
\boxed{
W_F(q)
=
\sum_{A\subseteq E(F)}
(-1)^{|A|}
q^{n-(r-2)|A|-r_{\mathrm B}(A)}.
}
\tag{4.1}
\]

### Proof

Use inclusion--exclusion over the events that an edge is monochromatic. If all
edges in \(A\) are monochromatic, every component of the supported subsystem
has one common color, while the \(n-|V_F(A)|\) remaining vertices are free.
The number of such colorings is

\[
q^{n-|V_F(A)|+c_F(A)}.
\]

Substitute (2.1). \(\square\)

Thus \(W_F\) is determined by \(r\), \(n\), and the labelled Berge-cycle
matroid. In particular, attachment geometry that does not change the matroid
does not change the weak chromatic polynomial.

Let

\[
Z_J(q,\{v_e\})
=
\sum_{A\subseteq E(J)}
q^{\kappa_J(A)}
\prod_{e\in A}v_e
\tag{4.2}
\]

be the multivariate Fortuin--Kasteleyn partition function, with
\(\kappa_J(A)\) counting isolated shadow vertices.

## Theorem 4.2. Exact Potts reduction

For every cycle shadow \(J\),

\[
\boxed{
W_F(q)
=
q^{(r-2)m}
Z_J\!\left(q,-q^{-(r-2)}\right).
}
\tag{4.3}
\]

### Proof

For the shadow matroid,

\[
r_{\mathrm B}(A)=|V(J)|-\kappa_J(A).
\]

Using (1.1),

\[
n-(r-2)|A|-r_{\mathrm B}(A)
=
(r-2)(m-|A|)+\kappa_J(A).
\]

Substitution in (4.1) gives (4.3). \(\square\)

For one expansion edge, integrating out its \(r-2\) private spins gives the
edge factor

\[
q^{r-2}
\left(
1-q^{-(r-2)}
\mathbf 1_{\{\sigma_u=\sigma_v\}}
\right).
\]

Thus the effective shadow interaction is antiferromagnetic with

\[
v_r=-q^{-(r-2)}.
\tag{4.4}
\]

As \(r\to\infty\), this interaction approaches the independent-spin point.

## Corollary 4.3. Tutte evaluation

\[
\boxed{
W_F(q)
=
(-1)^\rho
q^{(r-2)\beta+c}
T_F\!\left(
1-q^{r-1},
1-q^{-(r-2)}
\right).
}
\tag{4.5}
\]

The apparent negative powers cancel in the rank expansion (4.1).

# 5. Strong colorings

Let \(S_F(q)\) count colorings in which every \(r\)-edge is rainbow, and put

\[
\lambda_r(q)
=
(q-2)_{\underline{r-2}}
=
(q-2)(q-3)\cdots(q-r+1),
\tag{5.1}
\]

with the empty product equal to one for \(r=2\).

## Theorem 5.1. Strong-coloring factorization

For every cycle shadow \(J\),

\[
\boxed{
S_F(q)=\lambda_r(q)^mP_J(q),
}
\tag{5.2}
\]

where \(P_J\) is the ordinary graph chromatic polynomial. Equivalently,

\[
\boxed{
S_F(q)
=
(-1)^\rho q^c\lambda_r(q)^mT_F(1-q,0).
}
\tag{5.3}
\]

### Proof

For a single atom \(J^{(r)}\), the two core endpoints of every edge must have
different colors, giving \(P_J(q)\) choices on the core. The \(r-2\) private
vertices then receive ordered distinct colors from the remaining \(q-2\)
colors, giving \(\lambda_r(q)\) independent choices per edge.

Under a one-point amalgamation, fixing the color of the amalgamation point
divides the product of the two coloring counts by \(q\), by color symmetry.
The graph chromatic polynomial satisfies the identical one-vertex-sum
factorization. Multiplying over the bridge-block decomposition gives (5.2).
Equation (5.3) is the standard graphic Tutte evaluation of \(P_J\). \(\square\)

Every nonempty \(F\in\mathcal B_r\) has strong chromatic number exactly \(r\),
and

\[
S_F(r)=((r-2)!)^mP_J(r).
\tag{5.4}
\]

The equality of the strong chromatic number and the rank is classical for
balanced hypergraphs [@berge1972]; (5.2) is the exact enumerative refinement
for this class.

# 6. Closed forms at small cycle rank

## 6.1. Berge forests

If \(\beta=0\), then the shadow is a forest and

\[
n=(r-1)m+c.
\]

The exact coloring polynomials are

\[
\boxed{
W_F(q)=q^c(q^{r-1}-1)^m,
}
\tag{6.1}
\]

and

\[
\boxed{
S_F(q)
=
q^c\left((q-1)_{\underline{r-1}}\right)^m.
}
\tag{6.2}
\]

Thus all reduced Berge forests with the same \(r,m,c\) are indistinguishable
by both coloring polynomials, regardless of their incidence-tree geometry.

## 6.2. Connected unicyclic systems

Assume \(F\) is connected, \(\beta=1\), and its unique Berge circuit has even
length \(\ell\). Put

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
\tag{6.3}
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
\tag{6.4}
\]

The number of maximal Berge forests is \(\ell\). Tree attachments are invisible
to these formulas.

# 7. Collapse of the hypergraph Tutte polynomial

Berrekkal, Ellis-Monaghan, and Moody define a hypergraph Tutte polynomial
\(T_{\mathrm{HG}}\) and relate it to associated polymatroids and many-body
Potts models [@berrekkal2026]. In their notation,

\[
T_{\mathrm{HG}}(H;X,Y)
=
\sum_{A\subseteq E(H)}
(X-1)^{\kappa_H(A)-\kappa_H(H)}
(Y-1)^{d(A)-|A|-|V(H)|+\kappa_H(A)},
\tag{7.1}
\]

where \(d(A)\) is the sum of the sizes of the hyperedges in \(A\).

For an \(r\)-uniform \(F\), \(d(A)=r|A|\). Put \(u=X-1\) and \(v=Y-1\).

## Theorem 7.1. Hypergraph-Tutte specialization

\[
\boxed{
T_{\mathrm{HG}}(F;1+u,1+v)
=
u^{(r-2)\beta}
T_F\!\left(
1+u^{r-1},
1+v\,u^{-(r-2)}
\right).
}
\tag{7.2}
\]

The right side belongs to \(\mathbb Z[u,v]\), despite its Laurent presentation.

### Proof

By (3.2),

\[
\kappa_F(A)-c
=
(r-2)(m-|A|)+\rho-r_{\mathrm B}(A),
\tag{7.3}
\]

and

\[
r|A|-|A|-n+\kappa_F(A)
=
|A|-r_{\mathrm B}(A).
\tag{7.4}
\]

The term of the right side of (7.2) indexed by \(A\) has \(v\)-exponent
\(|A|-r_{\mathrm B}(A)\) and \(u\)-exponent

\[
(r-2)\beta
+(r-1)(\rho-r_{\mathrm B}(A))
-(r-2)(|A|-r_{\mathrm B}(A)),
\]

which simplifies to the exponent in (7.3). This proves termwise equality.
\(\square\)

Thus this general hypergraph Tutte polynomial contains no additional
nonmodular information on \(\mathcal B_r\) beyond \(M_{\mathrm B}(F)\) and the
elementary uniformity parameters.


# 8. Full monochromatic-edge process

Color the vertices independently and uniformly with \(q\ge2\) colors, and set

\[
X_e=\mathbf1_{\{e\text{ is monochromatic}\}},
\qquad
M_F=\sum_{e\in E(F)}X_e.
\]

A single edge is monochromatic with probability

\[
p=q^{1-r}.
\tag{8.1}
\]

## Theorem 8.1. Intersection probabilities

For every \(A\subseteq E(F)\),

\[
\boxed{
\Pr(X_e=1\text{ for all }e\in A)
=
q^{-(r-2)|A|-r_{\mathrm B}(A)}
=
q^{\nu_{\mathrm B}(A)}p^{|A|},
}
\tag{8.2}
\]

where

\[
\nu_{\mathrm B}(A)=|A|-r_{\mathrm B}(A).
\]

### Proof

Forcing every edge of \(A\) to be monochromatic forces one color on each
component of the spanning subhypergraph \((V(F),A)\). Hence

\[
\Pr(X_e=1\ \forall e\in A)
=
q^{\kappa_F(A)-n}.
\]

Use (3.2). \(\square\)

## Theorem 8.2. Probabilistic dependence matroid

For \(A\subseteq E(F)\), the following are equivalent:

1. \(A\) is independent in \(M_{\mathrm B}(F)\);
2. \(F[A]\) is Berge-acyclic;
3. the events \(\{X_e=1:e\in A\}\) are mutually independent.

### Proof

If \(A\) is matroid-independent, every \(B\subseteq A\) has
\(\nu_{\mathrm B}(B)=0\), so (8.2) factorizes for every subfamily. Conversely,
mutual independence applied to the entire family \(A\) forces
\(q^{\nu_{\mathrm B}(A)}=1\), hence \(\nu_{\mathrm B}(A)=0\). \(\square\)

Therefore Berge circuits are exactly the minimal dependent event families. For
a circuit \(C\),

\[
\Pr(X_e=1\ \forall e\in C)=q\,p^{|C|},
\tag{8.3}
\]

while every proper subfamily is independent.

If \(g\) is the Berge girth, the indicators are \((g-1)\)-wise independent.
Because a simple bipartite shadow has no circuit of size below four, the
indicators are automatically three-wise independent.

## Theorem 8.3. Complete joint law

For every \(S\subseteq E(F)\),

\[
\boxed{
\Pr\!\left(\{e:X_e=1\}=S\right)
=
\sum_{A:\,S\subseteq A\subseteq E(F)}
(-1)^{|A|-|S|}
q^{-(r-2)|A|-r_{\mathrm B}(A)}.
}
\tag{8.4}
\]

### Proof

Expand

\[
\prod_{e\in S}X_e
\prod_{e\notin S}(1-X_e)
\]

and apply (8.2) to every resulting upper-set probability. \(\square\)

Thus the complete labelled random subset of monochromatic edges is a labelled
matroid invariant once \(r\) and \(q\) are fixed. Every mixed moment, joint
cumulant, and exact-set probability is determined by the rank function.

# 9. The monochromatic-edge enumerator and exact laws

Define

\[
\Phi_F(q;\{t_e\})
=
\sum_{\phi:V(F)\to[q]}
\prod_{e\in E(F)}t_e^{X_e(\phi)}.
\tag{9.1}
\]

Expanding \(t_e^{X_e}=1+(t_e-1)X_e\) gives

\[
\Phi_F(q;\{t_e\})
=
\sum_{A\subseteq E(F)}
q^{\kappa_F(A)}
\prod_{e\in A}(t_e-1).
\tag{9.2}
\]

## Theorem 9.1. Multivariate many-body-to-pairwise reduction

For every cycle shadow \(J\),

\[
\boxed{
\Phi_F(q;\{t_e\})
=
q^{(r-2)m}
Z_J\!\left(
q,\{(t_e-1)q^{-(r-2)}\}_{e\in E(J)}
\right).
}
\tag{9.3}
\]

In the univariate case,

\[
\boxed{
\Phi_F(q,t)
=
q^{(r-2)m}
Z_J\!\left(
q,(t-1)q^{-(r-2)}
\right).
}
\tag{9.4}
\]

The probability-generating function of \(M_F\) is
\(q^{-n}\Phi_F(q,t)\).

## Corollary 9.2. Binomial first two moments

Pairwise independence gives

\[
\boxed{
\mathbb E[M_F]=mp,
\qquad
\operatorname{Var}(M_F)=mp(1-p).
}
\tag{9.5}
\]

Cycles are invisible to the first two moments.

## Theorem 9.3. The first non-binomial factorial moment

Let \(g\) be the Berge girth and \(N_g(F)\) the number of shortest
Berge-circuit edge sets. Then

\[
\boxed{
\mathbb E[(M_F)_k]=(m)_kp^k
\qquad(k<g),
}
\tag{9.6}
\]

and

\[
\boxed{
\mathbb E[(M_F)_g]
=
(m)_gp^g
+
g!N_g(F)(q-1)p^g.
}
\tag{9.7}
\]

### Proof

For any \(k\),

\[
\mathbb E[(M_F)_k]
=
k!\sum_{\substack{A\subseteq E(F)\\|A|=k}}
\Pr(X_e=1\ \forall e\in A).
\]

If \(k<g\), every \(A\) is independent. If \(k=g\), every dependent \(g\)-set
is exactly a circuit and has nullity one. Apply (8.2). \(\square\)

The distribution of \(M_F\) therefore determines the Berge girth and the
number of shortest Berge circuits.

## Corollary 9.4. Exact forest law

The following are equivalent:

1. \(F\) is Berge-acyclic;
2. all events \(X_e=1\) are mutually independent;
3.
   \[
   M_F\sim\operatorname{Binomial}(m,q^{1-r}).
   \tag{9.8}
   \]

Equivalently,

\[
\Phi_F(q,t)
=
q^c(q^{r-1}+t-1)^m.
\tag{9.9}
\]

## Corollary 9.5. Connected unicyclic law

If \(F\) is connected, \(\beta=1\), and the unique circuit has length
\(\ell\), put

\[
Y=q^{r-1}+t-1.
\]

Then

\[
\boxed{
\Phi_F(q,t)
=
Y^{m-\ell}
\left(
Y^\ell+(q-1)(t-1)^\ell
\right).
}
\tag{9.10}
\]

# 10. High-girth limit laws

Consider \(F_n\in\mathcal B_{r_n}\) with \(m_n\) edges and Berge girth \(g_n\).
Color with \(q_n\) colors and put

\[
p_n=q_n^{1-r_n}.
\]

## Theorem 10.1. Poisson transfer

If

\[
g_n\to\infty,\qquad
p_n\to0,\qquad
m_np_n\to\lambda\in[0,\infty),
\]

then

\[
M_n\xrightarrow{d}\operatorname{Poisson}(\lambda).
\tag{10.1}
\]

### Proof

For each fixed \(k\), eventually \(k<g_n\), so

\[
\mathbb E[(M_n)_k]=(m_n)_kp_n^k\to\lambda^k.
\]

These are the Poisson factorial moments. The first moments are bounded, giving
tightness, and the Poisson law is factorial-moment determinate. \(\square\)

## Theorem 10.2. Gaussian transfer

If

\[
g_n\to\infty,\qquad
m_np_n(1-p_n)\to\infty,
\]

then

\[
\frac{M_n-m_np_n}{\sqrt{m_np_n(1-p_n)}}
\xrightarrow{d}N(0,1).
\tag{10.2}
\]

### Proof

For each fixed order, the ordinary moments are fixed linear combinations of
factorial moments. They eventually equal the corresponding moments of
\(\operatorname{Binomial}(m_n,p_n)\). The standardized binomial moments
converge to Gaussian moments under the displayed variance condition. The
standardized second moments are one, giving tightness, and the normal law is
moment determinate. \(\square\)

General monochromatic-edge and hyperedge limit theory is substantially broader
[@bhattacharya2013; @fang2014; @xie2024]. The point here is the exact
fixed-order agreement induced by Berge girth.

# 11. Property B and ferromagnetic Ising

Take \(q=2\), \(r\ge3\), and \(t=0\). From (4.3),

\[
W_F(2)
=
2^{(r-2)m}
Z_J\!\left(2,-2^{-(r-2)}\right).
\tag{11.1}
\]

Since \(J\) is bipartite, flip the two spin labels on one bipartition class.
Equal and unequal endpoint relations are exchanged. For

\[
a=2^{-(r-2)},
\]

this gives

\[
Z_J(2,-a)
=
(1-a)^m
Z_J\!\left(2,\frac{a}{1-a}\right).
\tag{11.2}
\]

Therefore

\[
\boxed{
W_F(2)
=
(2^{r-2}-1)^m
Z_J\!\left(
2,\frac{1}{2^{r-2}-1}
\right).
}
\tag{11.3}
\]

The parameter on the right is positive, so Property-B counting is an exact
ferromagnetic Ising evaluation on the shadow. The Jerrum--Sinclair FPRAS for
ferromagnetic Ising [@jerrum1993] therefore yields an FPRAS for \(W_F(2)\)
whenever a cycle-shadow certificate is available. Combined with the
certificate-producing recognition algorithm from the bridge-block theorem,
this gives an end-to-end randomized approximation procedure for explicitly
represented members of \(\mathcal B_r\), conditional on that recognition
implementation.


# 12. Uniqueness and transfer of shadow invariants

Any two cycle shadows \(J,J'\) represent the same labelled graphic matroid.
Whitney's 2-isomorphism theorem implies that connected shadows differ only by
Whitney switches and the standard cut-vertex operations [@whitney1933;
@truemper1980]. If the matroid has a simple 3-connected graphic
representation, the shadow is unique up to graph isomorphism.

Thus the reduction is canonically graph-valued in the 3-connected case and
canonically matroid-valued in general.

Every graphic-matroid invariant transfers to \(F\), including:

- ranks and nullities of all edge subsets;
- spanning-forest counts;
- reliability, flow, and tension evaluations;
- broken-circuit and activity data;
- the base-polytope face structure;
- deletion--contraction identities at the matroid level.

# 13. Computational verification

Two independent standard-library programs support the derivations:

1. `experiments/berge_matroid_coloring.py`;
2. `experiments/monochromatic_dependence_hypertutte.py`.

The first constructs expansion atoms and one-point amalgamations for
\(r=3,4,5\), including attachments at private hypergraph points that do not
correspond canonically to a selected shadow core vertex. It checks the subset
rank formula, incidence nullity, weak and strong colorings, Potts evaluations,
and the forest and unicyclic formulas.

The second constructs 24 deterministic examples and checks:

- 1,410 subset-rank identities;
- 1,410 modular-plus-graphic polymatroid identities;
- 1,410 termwise hypergraph-Tutte transformations;
- 2,820 exact dependence identities;
- 48 multivariate Potts-polynomial identities;
- 32 direct coloring distributions, totaling 5,383,754 colorings;
- 24 bipartite Ising gauge identities;
- forest and unicyclic laws.

All committed checks report zero failures. These computations verify finite
instances and algebraic transformations; they do not replace review of the
cycle-shadow theorem or the general proofs.

# 14. Literature and novelty boundary

The following inputs and surrounding theories are established:

- the complete \(r=3\) obligatory classification and its one-apex trace method
  [@li2026];
- obligatory uniform expansions of complete bipartite graphs [@reiher2024];
- graph and matroid Tutte--Potts theory [@sokal2005];
- multivariate hypergraph chromatic polynomials [@white2010];
- balanced-hypergraph strong coloring [@berge1972];
- polymatroid Tutte theory and translation invariance [@bernardi2020];
- the general 2026 hypergraph Tutte polynomial and its Potts relations
  [@berrekkal2026];
- monochromatic-edge limit theory [@bhattacharya2013; @fang2014; @xie2024];
- Whitney 2-isomorphism [@whitney1933; @truemper1980];
- the ferromagnetic-Ising FPRAS [@jerrum1993].

The contributions under review are the exact consequences of the bridge-block
cycle shadow:

1. the canonical Berge-cycle matroid and intrinsic rank formula;
2. the modular-plus-graphic polymatroid and base-polytope translation;
3. the weak and strong Tutte--Potts coloring formulas;
4. the specialization (7.2) of the 2026 hypergraph Tutte polynomial;
5. the exact monochromatic-event dependence matroid;
6. the complete joint law and factorial-moment reconstruction;
7. the high-Berge-girth transfer theorems;
8. the Property-B-to-ferromagnetic-Ising reduction.

Targeted searches did not locate this combined package. This is not an
absolute priority claim. The manuscript should remain a draft until the
cycle-shadow theorem and the probabilistic and polyhedral consequences receive
independent specialist review.

# 15. Audit status and dependency map

The logical dependency is:

\[
\text{bridge-block theorem}
\Longrightarrow
\text{cycle shadow}
\Longrightarrow
\text{canonical matroid and rank}
\Longrightarrow
\begin{cases}
\text{coloring and Potts identities},\\
\text{polymatroid and polytope identities},\\
\text{probabilistic dependence laws}.
\end{cases}
\]

The \(r\ge4\) avoidance proof is **not** used. For \(r=3\), the results apply to
all obligatory triple systems after isolated vertices are removed. For general
\(r\), they apply unconditionally to the generated class \(\mathcal B_r\).

Before external submission:

1. independently audit the cycle-shadow theorem and subset-rank formula;
2. compare (7.2) directly against the authors' exact convention for
   \(T_{\mathrm{HG}}\);
3. obtain a matroid/polymatroid specialist check of Section 3;
4. obtain a probability specialist check of Sections 8--10;
5. rerun the complete deterministic verification workflow;
6. perform a final literature and attribution audit.
