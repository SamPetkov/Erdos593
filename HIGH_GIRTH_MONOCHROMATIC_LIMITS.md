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
M_n=\#\{e\in E(F_n):e	ext{ is monochromatic}\}.
\]

Put

\[
p_n=q_n^{1-r_n}.
\]

The dependence theorem gives, for every fixed \(k<g_n\),

\[
oxed{
\mathbb E[(M_n)_k]=(m_n)_k p_n^k.
}
	ag{1.1}
\]

The right-hand side is exactly the \(k\)-th factorial moment of
\(\operatorname{Binomial}(m_n,p_n)\).

Thus, when \(g_n	o\infty\), every fixed factorial moment of \(M_n\) eventually
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
oxed{
M_n\xrightarrow{d}\operatorname{Poisson}(\lambda).
}
	ag{2.1}
\]

### Proof

Fix \(k\ge1\). Eventually \(k<g_n\), so by (1.1),

\[
\mathbb E[(M_n)_k]=(m_n)_kp_n^k.
\]

If \(\lambda>0\), the assumptions imply \(m_n	o\infty\), and hence

\[
(m_n)_kp_n^k
=(m_np_n)^k\prod_{j=0}^{k-1}\left(1-rac{j}{m_n}ight)
\longrightarrow\lambda^k.
\]

For \(\lambda=0\), the same conclusion is immediate. These are the factorial
moments of \(\operatorname{Poisson}(\lambda)\). The first moment bounds give
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
oxed{
rac{M_n-m_np_n}{\sqrt{m_np_n(1-p_n)}}
\xrightarrow{d}N(0,1).
}
	ag{3.1}
\]

### Proof

For every fixed \(k\), the \(k\)-th ordinary moment is a fixed linear
combination of factorial moments of orders at most \(k\). Since \(g_n	o\infty\),
these factorial moments eventually agree exactly with those of

\[
B_n\sim\operatorname{Binomial}(m_n,p_n).
\]

Therefore every fixed standardized moment of \(M_n\) eventually equals the
corresponding standardized moment of \(B_n\). The triangular-array binomial CLT
holds under \(\sigma_n^2	o\infty\), so those moments converge to the Gaussian
moments. The normal law is moment determinate, which gives (3.1). \(\square\)

Thus large Berge girth removes every fixed-order cyclic correction before the
thermodynamic limit is taken.

## 4. First correction when the girth is finite

Let \(g_n<\infty\), and let \(N_{g_n}(F_n)\) be the number of shortest
Berge-circuit edge sets. The first factorial moment that differs from the
binomial law is

\[
oxed{
\mathbb E[(M_n)_{g_n}]
-(m_n)_{g_n}p_n^{g_n}
=
 g_n!\,N_{g_n}(F_n)(q_n-1)p_n^{g_n}.
}
	ag{4.1}
\]

Hence the obstruction to the binomial, Poisson, or Gaussian approximation first
appears through the shortest Berge cycles and with an explicitly positive
coefficient.

Equation (4.1) suggests refined asymptotics in which the quantity

\[
N_{g_n}(F_n)(q_n-1)p_n^{g_n}
\]

controls the first non-binomial correction.

## 5. Relation to graph-coloring probability

Bhattacharya, Diaconis, and Mukherjee developed universal limit theorems for the
number of monochromatic edges in uniformly colored graphs, with moment
calculations tied to graph-cycle counts:

- B. B. Bhattacharya, P. Diaconis, and S. Mukherjee,
  *Universal Limit Theorems in Graph Coloring Problems With Connections to
  Extremal Combinatorics*, arXiv:1310.2336.

Fang subsequently obtained a universal quantitative CLT bound:

- X. Fang, *A universal error bound in the CLT for counting monochromatic
  edges in uniformly colored graphs*, arXiv:1408.0509.

The statements above are not claims that the general graph limit theory is new.
The point is that the obligatory-hypergraph bridge-block structure makes the
factorial moments exactly matroidal and yields the high-Berge-girth transfer
without reducing the random coloring itself to an ordinary uniform graph
coloring.

## 6. Verification boundary

The finite verifier in PR #28 checks (1.1) through the first circuit order on
all directly enumerable examples. The asymptotic theorems are exact deductions
from (1.1) and the classical binomial Poisson/normal limits; they do not require
additional simulation.

These corollaries should remain in the follow-up research branch pending review
of the underlying canonical rank theorem.
