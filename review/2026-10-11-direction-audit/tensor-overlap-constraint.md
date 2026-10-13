# Tensor constraint for collective overlap payment

The actual processed-overlap bound has a precise tensor constraint. On
tensor powers its exponential rate is the largest of three nonnegative
one-copy quantities. Thus tensor amplification alone does not supply a
missing universal payment. A lower bound for one of these quantities,
the processed overlap \(W_u\), would suffice for the ordered density
theorem, but that lower bound remains open.

## Original law and the three quantities

Use the original finite positive law, actual symmetric nonnegative Markov
root, exponents and functions \(q_k,f,s_d,H_k\) of
[Hellinger channel payment](hellinger-channel-payment.md), equations
(1)--(5). All expectations below use that law. In particular,
\[
q_k=T^k[K_r(\cdot,c)K_u(\cdot,d)],\qquad
f_{cd}=K_{r+u}(c,d),\qquad s_d(c)=\sqrt{K_l(c,d)}.
\]
Retain \(k\ge u\ge1,r\ge l\ge1,h\ge1\), and define
\[
\begin{aligned}
S&=\mathbb E_{e,d}(\mathbb E_c s_d(c)q_k(e,c,d))^2,\\
S_0&=\mathbb E_d(\mathbb E_c s_d(c)f_{cd})^2,\\
W_k&=\mathbb E_{c,x,d}K_h(c,x)K_l(c,d)H_k(c,x,d)^2,\\
X_k&=\mathbb E_{c,x,d}K_h(c,x)s_d(c)s_d(x)H_k(c,x,d)^2.
\end{aligned}
\tag{1}
\]
The existing Gram baseline is
\(G_0=\mathbb E_d\langle s_df,A^h(s_df)\rangle_\mu\).
All five quantities are nonnegative. Their comparisons are
\[
G_0\ge S_0,\qquad S\ge S_0,\qquad W_k\ge X_k,\qquad G_0\ge X_k.
\tag{2}
\]
The first comparison uses \(A^h-\Pi\succeq0\); the second is variance
under \(\mu_e\), since \(\mathbb E_eq_k=f\). Symmetry in \(c,x\) gives
\[
W_k-X_k=\tfrac12\mathbb E_{c,x,d}K_h(c,x)
 (s_d(c)-s_d(x))^2H_k(c,x,d)^2\ge0.
\]
Finally \(H_k^2\le f_{cd}f_{xd}\), with nonnegative remaining factors,
gives \(X_k\le G_0\).

## Exact tensor calculation

For an integer \(N\ge1\), use the actual root \(T^{\otimes N}\) and
original law \(\mu^{\otimes N}\), with the same exponents in every
coordinate. This is again a symmetric nonnegative Markov root. Its
kernels, flags, square-root weights and overlaps factor coordinatewise;
therefore \(F_N=F^N\), \(D_N=D^N\), and the quantities in (1) and
\(G_0\) become their respective \(N\)-th powers.

The retained Gram credit is exactly
\(\mathcal C_k=S-S_0\). If \(J_{H,k}\) denotes the square-gradient
term using \(H_k^2\), symmetry gives
\(J_{H,k}=W_k-X_k\). Since
\(\mathcal P_H=J_0-J_{H,k}\) and \(D=G_0+J_0\), the earlier bound is
\[
F\ge\mathrm{LB}:=G_0+S-S_0+W_k-X_k.
\tag{3}
\]
On the tensor host it becomes exactly
\[
\boxed{F^N\ge\mathrm{LB}_N
 =G_0^N+S^N-S_0^N+W_k^N-X_k^N.}
\tag{4}
\]
This is not the generally false replacement
\(\mathrm{LB}_N=\mathrm{LB}^N\).
For example, the actual relative identity root on the uniform two-state
law has \(G_0=S=W_k=X_k=4\) and \(S_0=2\), at any allowed tuple:
its kernels are \(2\mathbf1_{x=y}\), and
\(q_k(e,c,d)=4\mathbf1_{e=c=d}\). Thus
\(\mathrm{LB}=6\) but \(\mathrm{LB}_2=28\ne36\).

Put \(M=\max\{G_0,S,W_k\}\). Each of the three lower comparisons
follows separately from (2):
\[
\begin{aligned}
\mathrm{LB}_N-G_0^N&=(S^N-S_0^N)+(W_k^N-X_k^N)\ge0,\\
\mathrm{LB}_N-S^N&=(G_0^N-S_0^N)+(W_k^N-X_k^N)\ge0,\\
\mathrm{LB}_N-W_k^N&=(G_0^N-X_k^N)+(S^N-S_0^N)\ge0.
\end{aligned}
\]
Dropping the two subtracted nonnegative terms gives the upper bound.
Consequently
\[
\boxed{M^N\le\mathrm{LB}_N\le3M^N,\qquad
\lim_{N\to\infty}\mathrm{LB}_N^{1/N}=M.}
\tag{5}
\]
The limit also holds when \(M=0\), since then all terms vanish.

## Consequences for a universal certificate

Within this class of actual hosts, the following universal statements are
equivalent:

1. The retained certificate \(\mathrm{LB}\ge1\) holds on every host
   at every allowed tuple.
2. \(\max\{G_0,S,W_k\}\ge1\) holds on every such host and tuple.

The second implies the first by (5) with \(N=1\). Conversely, if some
host has \(M<1\), its actual tensor powers have
\(\mathrm{LB}_N\le3M^N<1\) for sufficiently large \(N\), contradicting
the first universal statement. This would refute the certificate, not
the density theorem: the omitted remainder in the earlier bound is
nonnegative and need not vanish. No admissible host with \(M<1\) is
established here.

There is a smaller positive sufficient route. Actual-channel data
processing gives \(H_n\ge H_k\) for \(n\ge k\); hence
\(W_n\ge W_k\), with all its other weights fixed. Equations (3)--(5)
therefore give
\[
\boxed{W_u\ge1\quad\Longrightarrow\quad F(k)\ge1
       \text{ for every }k\ge u.}
\tag{6}
\]
The universal claim \(W_u\ge1\) is unproved. It is stronger than the
maximum condition and has not been shown necessary for density. Replacing
the actual \(H_u\) by the input overlap would discard precisely the
smoothing needed in the [skew-binary separation](actual-feature-processing.md).

Zeros require no division in (1)--(6). Reducibility, periodicity, negative
eigenvalues of \(T\), and extra unit modes remain admitted. The constant
root has all five quantities equal to one. These analytical identities
do not close the unrestricted theorem, add density coverage, or supply
an accepted Lean endpoint.
