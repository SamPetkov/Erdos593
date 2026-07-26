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

