# Monochromatic-edge dependence, hypergraph Tutte collapse, and Ising reduction

**Status:** research note with complete derivations and reproducible finite checks;
stacked on the Berge-cycle matroid PR. It does not modify the Problem 593
manuscript, the completed triple-system Lean development, or the all-uniformity
avoidance proof draft.

## 1. Setting

Fix an integer \(r\ge 2\). Let \(\mathcal B_r\) be the class generated from
\(r\)-uniform expansions of finite bipartite graphs, finite edgeless systems,
disjoint unions, and one-point amalgamations. Let

\[
F\in\mathcal B_r
\]

be finite and reduced, with

\[
n=|V(F)|,\qquad m=|E(F)|,\qquad c=c(F).
\]

The cycle-shadow theorem gives a finite bipartite graph \(J\), without isolated
vertices, together with an edge bijection

\[
E(F)\longleftrightarrow E(J)
\]

that preserves Berge-cycle edge sets. The resulting canonical matroid on
\(E(F)\) is denoted by

\[
M_{\mathrm B}(F).
\]

Write \(r_{\mathrm B}(A)\) and

\[
\nu_{\mathrm B}(A)=|A|-r_{\mathrm B}(A)
\]

for its rank and nullity on \(A\subseteq E(F)\). Put

\[
\rho=r_{\mathrm B}(E(F)),\qquad
\beta=m-\rho.
\]

For an edge set \(A\), let \(V_F(A)\) be the points incident with at least one
edge in \(A\), and let \(c_F(A)\) be the number of connected components of the
supported incidence subsystem. The preceding PR proves

\[
r_{\mathrm B}(A)
=
|V_F(A)|-c_F(A)-(r-2)|A|.
\tag{1.1}
\]

All graph partition functions below use the spanning-subgraph convention

\[
Z_J(q,\{v_e\})
=
\sum_{A\subseteq E(J)}
q^{\kappa_J(A)}
\prod_{e\in A}v_e,
\tag{1.2}
\]

where isolated shadow vertices are counted in \(\kappa_J(A)\).

## 2. The associated hypergraphic polymatroid is modular plus graphic

Let \(\kappa_F(A)\) be the number of connected components of the **spanning**
subhypergraph \((V(F),A)\), so points outside \(V_F(A)\) count as isolated
components. Then

\[
\kappa_F(A)
=
c_F(A)+n-|V_F(A)|.
\]

Using (1.1),

\[
\boxed{
n-\kappa_F(A)
=
(r-2)|A|+r_{\mathrm B}(A).
}
\tag{2.1}
\]

Thus the associated \((r-1)\)-polymatroid has rank function

\[
p_F(A)=(r-2)|A|+r_{\mathrm B}(A).
\tag{2.2}
\]

In polymatroid language, every nonmodular dependence is graphic: \(p_F\) is the
sum of the graphic matroid rank and the modular function
\((r-2)|A|\). The increase from graphs to uniformity \(r\) contributes only
the modular term.

Globally,

\[
n-c=(r-2)m+\rho.
\tag{2.3}
\]

This is the rank-theoretic explanation for the cycle-rank identity

\[
\beta=(r-1)m-n+c.
\tag{2.4}
\]

## 3. Collapse of the 2026 hypergraph Tutte polynomial

Berrekkal, Ellis-Monaghan, and Moody define, for a finite hypergraph \(H\),

\[
T_{\mathrm{HG}}(H;X,Y)
=
\sum_{A\subseteq E(H)}
(X-1)^{\kappa_H(A)-\kappa_H(H)}
(Y-1)^{d(A)-|A|-|V(H)|+\kappa_H(A)}.
\tag{3.1}
\]

For an \(r\)-uniform hypergraph, \(d(A)=r|A|\). For \(F\in\mathcal B_r\),
(2.1) gives, term by term,

\[
\kappa_F(A)-c
=
(r-2)(m-|A|)+\rho-r_{\mathrm B}(A),
\tag{3.2}
\]

and

\[
r|A|-|A|-n+\kappa_F(A)
=
|A|-r_{\mathrm B}(A)
=
\nu_{\mathrm B}(A).
\tag{3.3}
\]

Let

\[
T_F(x,y):=T_{M_{\mathrm B}(F)}(x,y)
\]

be the canonical Berge-cycle matroid Tutte polynomial introduced in the
preceding PR. With \(u=X-1\) and \(v=Y-1\), equations (3.2)--(3.3) give

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
\tag{3.4}
\]

The right-hand side is written in a Laurent ring, but its subset expansion
shows that all negative powers cancel. Hence it belongs to
\(\mathbb Z[u,v]\).

For \(r=2\), (3.4) is the ordinary graph identity. For \(r\ge3\), it says that
the general hypergraph Tutte polynomial of this class contains no additional
nonmodular information beyond the canonical graphic matroid and the elementary
parameters \(r,m,n,c\).

This is not a competing definition of a hypergraph Tutte polynomial. It is an
explicit specialization theorem for the polynomial of:

> Khallil Berrekkal, Joanna A. Ellis-Monaghan, and Merijn Moody,
> *A Hypergraph Tutte Polynomial*, arXiv:2607.16334 (2026).

## 4. Full monochromatic-edge enumerator

For an integer \(q\ge2\), assign \(q\) labelled colors to the vertices of
\(F\). For each hyperedge \(e\), let

\[
X_e(\phi)
=
\mathbf 1_{\{e\text{ is monochromatic under }\phi\}}.
\]

Define the multivariate monochromatic-edge enumerator

\[
\Phi_F(q;\{t_e\})
=
\sum_{\phi:V(F)\to[q]}
\prod_{e\in E(F)}t_e^{X_e(\phi)}.
\tag{4.1}
\]

This is the multivariate form of the many-body Potts partition function.
Expanding

\[
t_e^{X_e}=1+(t_e-1)X_e
\]

and summing over colorings gives

\[
\Phi_F(q;\{t_e\})
=
\sum_{A\subseteq E(F)}
q^{\kappa_F(A)}
\prod_{e\in A}(t_e-1).
\tag{4.2}
\]

Using

\[
\kappa_F(A)
=
(r-2)(m-|A|)+\kappa_J(A),
\tag{4.3}
\]

we obtain the exact graph reduction

\[
\boxed{
\Phi_F(q;\{t_e\})
=
q^{(r-2)m}
Z_J\!\left(
q,\left\{(t_e-1)q^{-(r-2)}\right\}_{e\in E(J)}
\right).
}
\tag{4.4}
\]

Thus integrating out the private hypergraph vertices converts the many-body
interaction into a pair interaction on the bipartite shadow.

In the univariate case,

\[
\Phi_F(q,t)
=
\sum_{\phi}t^{M_F(\phi)},
\qquad
M_F(\phi)=\sum_e X_e(\phi),
\]

and

\[
\boxed{
\Phi_F(q,t)
=
q^{(r-2)m}
Z_J\!\left(q,(t-1)q^{-(r-2)}\right).
}
\tag{4.5}
\]

The weak chromatic polynomial is the specialization

\[
W_F(q)=\Phi_F(q,0).
\]

The general many-body Potts function is classical. The contribution here is
the exact reduction (4.4) for the bridge-block class.

## 5. The Berge-cycle matroid as a probabilistic dependence matroid

Choose a uniformly random \(q\)-coloring of \(V(F)\). For
\(A\subseteq E(F)\), requiring every edge in \(A\) to be monochromatic forces
one color on each spanning component of \((V(F),A)\). Therefore

\[
\Pr(X_e=1\text{ for all }e\in A)
=
q^{\kappa_F(A)-n}.
\tag{5.1}
\]

Combining (2.1) with (5.1),

\[
\boxed{
\Pr(X_e=1\text{ for all }e\in A)
=
q^{-(r-2)|A|-r_{\mathrm B}(A)}.
}
\tag{5.2}
\]

Since one edge is monochromatic with probability

\[
p=q^{1-r},
\tag{5.3}
\]

equation (5.2) becomes

\[
\boxed{
\Pr(X_e=1\text{ for all }e\in A)
=
q^{\nu_{\mathrm B}(A)}
\prod_{e\in A}\Pr(X_e=1).
}
\tag{5.4}
\]

This gives several exact equivalences.

### Theorem 5.1: probabilistic independence criterion

For \(A\subseteq E(F)\), the following are equivalent:

1. \(A\) is independent in \(M_{\mathrm B}(F)\);
2. the supported hypergraph \(F[A]\) is Berge-acyclic;
3. the events \(\{X_e=1:e\in A\}\) are mutually independent.

Indeed, if \(A\) is matroid-independent, every \(B\subseteq A\) has
\(\nu_{\mathrm B}(B)=0\), so (5.4) gives mutual independence. Conversely,
mutual independence applied to \(A\) forces \(\nu_{\mathrm B}(A)=0\).

Consequently the edge sets of Berge cycles are exactly the **minimal**
families of monochromatic-edge events that fail mutual independence.

For every Berge circuit \(C\),

\[
\Pr(X_e=1\text{ for all }e\in C)
=
q\prod_{e\in C}\Pr(X_e=1),
\tag{5.5}
\]

while every proper subfamily is mutually independent.

### Corollary 5.2: higher-order independence and Berge girth

Let \(g\) be the Berge girth of \(F\), with \(g=\infty\) for a Berge forest.
Then the family \((X_e)_{e\in E(F)}\) is \((g-1)\)-wise independent.

Because every cycle shadow is bipartite and simple, every finite circuit has
even size at least four. Hence **all monochromatic-edge indicators in this
class are automatically 3-wise independent**, even when the system contains
cycles.

### Corollary 5.3: mean and variance are always binomial

Let

\[
M_F=\sum_{e\in E(F)}X_e.
\]

Pairwise independence gives

\[
\boxed{
\mathbb E[M_F]=mp,
\qquad
\operatorname{Var}(M_F)=mp(1-p),
\qquad
p=q^{1-r}.
}
\tag{5.6}
\]

Cycles are invisible to the first two moments. They first appear in higher
moments.

## 6. The first non-binomial factorial moment detects shortest Berge cycles

Write

\[
(x)_k=x(x-1)\cdots(x-k+1).
\]

If \(k<g\), every \(k\)-edge subset is independent, so

\[
\boxed{
\mathbb E[(M_F)_k]
=
(m)_k p^k
\qquad(k<g).
}
\tag{6.1}
\]

Let \(N_g(F)\) be the number of Berge-circuit edge sets of minimum size \(g\).
Every dependent \(g\)-set is then one such circuit and has nullity one.
Therefore

\[
\boxed{
\mathbb E[(M_F)_g]
=
(m)_g p^g
+
g!\,N_g(F)(q-1)p^g.
}
\tag{6.2}
\]

Thus the distribution of \(M_F\) determines:

1. the Berge girth \(g\), as the first factorial-moment order that differs
   from a binomial law;
2. the exact number \(N_g(F)\) of shortest Berge cycles, through

\[
\boxed{
N_g(F)
=
\frac{
\mathbb E[(M_F)_g]-(m)_g p^g
}{
g!(q-1)p^g
}.
}
\tag{6.3}
\]

This gives a probabilistic reconstruction of the first circuit layer of the
canonical matroid.

## 7. Exact forest and unicyclic laws

### Berge forests

The following are equivalent:

1. \(F\) is Berge-acyclic;
2. \(M_{\mathrm B}(F)\) is a free matroid;
3. all monochromatic-edge events are mutually independent;
4. \(M_F\) has the binomial law

\[
\boxed{
M_F\sim\operatorname{Binomial}(m,q^{1-r}).
}
\tag{7.1}
\]

Equivalently,

\[
\boxed{
\Phi_F(q,t)
=
q^c\left(q^{r-1}+t-1\right)^m.
}
\tag{7.2}
\]

At \(t=0\), this recovers

\[
W_F(q)=q^c(q^{r-1}-1)^m.
\]

### Connected unicyclic systems

Suppose \(F\) is connected, \(\beta=1\), and the unique Berge circuit has
length \(\ell\). Put

\[
Y=q^{r-1}+t-1.
\]

The shadow is an \(\ell\)-cycle with attached trees, so

\[
\boxed{
\Phi_F(q,t)
=
Y^{m-\ell}
\left(
Y^\ell+(q-1)(t-1)^\ell
\right).
}
\tag{7.3}
\]

The unique cycle contributes exactly the first higher-order dependence term.

## 8. Property B as a ferromagnetic Ising partition function

Take \(q=2\) and \(t=0\), and assume \(r\ge3\). Equation (4.5) gives

\[
W_F(2)
=
2^{(r-2)m}
Z_J\!\left(2,-2^{-(r-2)}\right).
\tag{8.1}
\]

The interaction on the shadow is antiferromagnetic. Since \(J\) is bipartite,
flip the two spin values on one bipartition class. Equal and unequal endpoint
relations are exchanged. Factoring the edge weight gives the exact gauge
identity

\[
Z_J(2,-a)
=
(1-a)^m
Z_J\!\left(2,\frac{a}{1-a}\right),
\qquad
a=2^{-(r-2)}.
\tag{8.2}
\]

Consequently

\[
\boxed{
W_F(2)
=
(2^{r-2}-1)^m
Z_J\!\left(
2,\frac{1}{2^{r-2}-1}
\right).
}
\tag{8.3}
\]

The parameter on the right is positive, so the number of Property-B
colorings is an exact **ferromagnetic Ising** partition-function evaluation
on the cycle shadow.

Jerrum and Sinclair give an FPRAS for the ferromagnetic Ising partition
function on arbitrary graphs. Therefore, for a member of \(\mathcal B_r\)
supplied with a cycle-shadow certificate, (8.3) gives an FPRAS for counting
weak proper 2-colorings.

## 9. Uniqueness of the shadow up to Whitney moves

Any two cycle shadows \(J,J'\) of \(F\) represent the same labelled graphic
matroid:

\[
M(J)=M(J')=M_{\mathrm B}(F).
\]

Whitney's 2-isomorphism theorem therefore implies that connected shadows are
related by Whitney switches and the standard cut-vertex operations. In
particular, if the canonical Berge-cycle matroid is represented by a simple
3-connected shadow, then the shadow is unique up to graph isomorphism.

Thus the Potts/Ising reduction is canonically graph-valued in the
3-connected case and canonically matroid-valued in general.

## 10. Verification

The standard-library program

```text
experiments/monochromatic_dependence_hypertutte.py
```

constructs deterministic examples for \(r=3,4,5\), including:

- single expansion atoms;
- paths, even cycles, and \(K_{2,3}\);
- one-edge pieces attached at core points;
- the same pieces attached at private points;
- two cyclic pieces joined at one point;
- disconnected examples.

For every edge subset it checks:

1. the intrinsic Berge-rank formula;
2. the modular-plus-graphic polymatroid identity (2.1);
3. the termwise hypergraph-Tutte transformation (3.4);
4. the many-body-Potts reduction (4.4);
5. the exact dependence factor (5.4).

For manageable cases it directly enumerates all \(q\)-colorings for
\(q=2,3\), checks the full distribution of \(M_F\), verifies the factorial
moment theorem, the forest and unicyclic laws, and the bipartite Ising gauge
identity.

The checked result is stored in

```text
experiments/monochromatic_dependence_hypertutte_results.json
```

and reproduced by GitHub Actions.

## 11. Literature and novelty boundary

The following theories are not claimed as new:

- the general hypergraph Tutte polynomial and its uniform-polymatroid
  interpretation;
- Grimmett's many-body Potts partition function;
- the Fortuin--Kasteleyn graph random-cluster model;
- Whitney's 2-isomorphism theorem;
- the Jerrum--Sinclair FPRAS for ferromagnetic Ising.

The contributions under review are the special collapse caused by the
obligatory-system bridge-block structure:

\[
p_F(A)=(r-2)|A|+r_{\mathrm B}(A),
\]

the explicit transformation (3.4), the graph reduction (4.4), the exact
probabilistic dependence law (5.4), the girth/factorial-moment reconstruction,
and the ferromagnetic Property-B formula (8.3).

A targeted search did not locate this combined specialization. This is not an
absolute priority guarantee. The most relevant newly located source is:

- Khallil Berrekkal, Joanna A. Ellis-Monaghan, and Merijn Moody,
  *A Hypergraph Tutte Polynomial*, arXiv:2607.16334 (submitted 16 July 2026).

Additional comparison points are:

- H. Whitney, *2-Isomorphic Graphs*, American Journal of Mathematics 55
  (1933), 245--254;
- K. Truemper, *On Whitney's 2-isomorphism theorem for graphs*,
  Journal of Graph Theory 4 (1980), 43--49;
- M. Jerrum and A. Sinclair, *Polynomial-Time Approximation Algorithms for
  the Ising Model*, SIAM Journal on Computing 22 (1993), 1087--1116.

This note should remain a draft until the subset-rank theorem and the
probabilistic consequences receive independent specialist review.
