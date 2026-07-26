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

