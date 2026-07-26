# High-girth limit laws for monochromatic hyperedges

This note records asymptotic consequences of the exact dependence law in PR
#28. It is a transfer principle from Berge girth to probability laws for random
vertex colorings.

## 1. Setup

For each \(n\), let

\[
F_n\in\mathcal B_{r_n}
\]

have \(m_n\) hyperedges and Berge girth \(g_n\). Color its vertices independently
and uniformly with \(q_n\ge2\) colors, and let

\[
M_n=\#\{e\in E(F_n):e\text{ is monochromatic}\}.
\]

Put

\[
p_n=q_n^{1-r_n}.
\]

The dependence theorem gives, for every fixed \(k<g_n\),

\[
\boxed{
\mathbb E[(M_n)_k]=(m_n)_k p_n^k.
}
\tag{1.1}
\]

The right-hand side is exactly the \(k\)-th factorial moment of
\(\operatorname{Binomial}(m_n,p_n)\).

Thus, when \(g_n\to\infty\), every fixed factorial moment of \(M_n\) eventually
agrees **exactly** with the corresponding binomial factorial moment. This is
stronger than an asymptotic approximation at each fixed order.

## 2. Poisson regime

### Theorem 2.1

Assume

\[
g_n\longrightarrow\infty,\qquad
p_n\longrightarrow0,\qquad
m_np_n\longrightarrow\lambda\in[0,\infty).
\]

Then

\[
\boxed{
M_n\xrightarrow{d}\operatorname{Poisson}(\lambda).
}
\tag{2.1}
\]

### Proof

Fix \(k\ge1\). Eventually \(k<g_n\), so by (1.1),

\[
\mathbb E[(M_n)_k]=(m_n)_kp_n^k.
\]

If \(\lambda>0\), the assumptions imply \(m_n\to\infty\), and hence

\[
(m_n)_kp_n^k
=(m_np_n)^k
\prod_{j=0}^{k-1}\left(1-\frac{j}{m_n}\right)
\longrightarrow\lambda^k.
\]

For \(\lambda=0\), the same conclusion is immediate. These are the factorial
moments of \(\operatorname{Poisson}(\lambda)\). The first-moment bound gives
tightness, and the Poisson law is factorial-moment determinate. Therefore
(2.1) follows. \(\square\)

This regime includes increasing numbers of colors or increasing uniformities,
provided \(m_nq_n^{1-r_n}\) has a finite limit and the Berge girth diverges.

## 3. Gaussian regime

### Theorem 3.1

Assume

\[
g_n\longrightarrow\infty,\qquad
\sigma_n^2:=m_np_n(1-p_n)\longrightarrow\infty.
\]

Then

\[
\boxed{
\frac{M_n-m_np_n}{\sqrt{m_np_n(1-p_n)}}
\xrightarrow{d}N(0,1).
}
\tag{3.1}
\]

### Proof

For every fixed \(k\), the \(k\)-th ordinary moment is a fixed linear
combination of factorial moments of orders at most \(k\). Since
\(g_n\to\infty\), these factorial moments eventually agree exactly with those
of

\[
B_n\sim\operatorname{Binomial}(m_n,p_n).
\]

Consequently, every fixed centered and standardized moment of \(M_n\) eventually
equals the corresponding moment of \(B_n\). The triangular-array binomial CLT
holds under \(\sigma_n^2\to\infty\), so these moments converge to the Gaussian
moments. The standardized second moments are identically one, which gives
tightness; the normal law is moment determinate. This proves (3.1).
\(\square\)

Thus large Berge girth removes every fixed-order cyclic correction before the
thermodynamic limit is taken.

## 4. First correction when the girth is finite

Let \(g_n<\infty\), and let \(N_{g_n}(F_n)\) be the number of shortest
Berge-circuit edge sets. The first factorial moment that differs from the
binomial law is

\[
\boxed{
\mathbb E[(M_n)_{g_n}]
-(m_n)_{g_n}p_n^{g_n}
=
g_n!\,N_{g_n}(F_n)(q_n-1)p_n^{g_n}.
}
\tag{4.1}
\]

Hence the obstruction to the binomial, Poisson, or Gaussian approximation first
appears through the shortest Berge cycles and with an explicitly positive
coefficient.

Equation (4.1) suggests refined asymptotics in which

\[
N_{g_n}(F_n)(q_n-1)p_n^{g_n}
\]

controls the first non-binomial correction.

## 5. Relation to random-coloring limit theory

Bhattacharya, Diaconis, and Mukherjee developed universal limit theorems for the
number of monochromatic edges in uniformly colored graphs, with moment
calculations tied to graph-cycle counts. Fang subsequently obtained a universal
quantitative CLT bound. More recent work studies Poisson approximation for
monochromatic hyperedges in substantially broader hypergraph classes.

The statements above do not claim that this general limit theory is new. The
point is that the obligatory-hypergraph bridge-block structure makes every
fixed factorial moment exactly matroidal and gives the high-Berge-girth transfer
without reducing the original random coloring to an ordinary uniform graph
coloring.

## 6. Verification boundary

The finite verifier in PR #28 checks (1.1) through the first circuit order on
all directly enumerable examples. The asymptotic theorems are exact deductions
from (1.1) and the classical binomial Poisson and normal limits; they do not
require additional simulation.

These corollaries should remain in the follow-up research branch pending review
of the underlying canonical rank theorem.
