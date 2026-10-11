# Exact finite exception reduction for the density problem

For a fixed finite actual host and fixed four base exponents, the remaining
long-edge exponent has an explicit eventual lower bound. Rational inputs admit
a rational certificate and only finitely many exponents remain to check.
This does not settle the inequality for all hosts and all exponent tuples.

## Original law and operator conventions

Let \(X\) be finite and nonempty, with positive probability law \(\mu\).
Let \(T(x,y)\ge0\) be a symmetric relative kernel satisfying
\(\sum_y\mu_yT(x,y)=1\). Composition always means
\((BC)(x,y)=\sum_z\mu_zB(x,z)C(z,y)\).
The retained bounded host is \(W=pT\in[0,1]\), \(p>0\). Put
\(A=T^2\), \(K_t=A^t\), and fix positive integers \(k,u,r,l\).
For positive integer \(h\), define

\[
F(h)=\mathbb E_{\mu^4}
 K_k(a,b)K_{r+h}(a,c)K_u(a,d)
 K_r(b,c)K_u(b,d)K_l(c,d).
\]

The target ordering \(k\ge u,r\ge l\) is unnecessary for this particular
tail theorem. All original weights, zero entries and stationary components
are retained.

Let \(C_j\) be the connected components of the positive-support graph of
**\(A\), not \(T\)**, and set

\[
\rho_j=\mu(C_j),\quad \nu_j=\mu|_{C_j}/\rho_j,\qquad
P(x,y)=\begin{cases}\rho_j^{-1},&x,y\in C_j,\\0,&\text{otherwise.}\end{cases}
\]

The normalized relative kernel \(B_j=\rho_jA|_{C_j^2}\) is nonnegative,
PSD and Markov for \(\nu_j\). Its powers are
\(K^{(j)}_t=\rho_jK_t|_{C_j^2}\). A periodic \(T\) can interchange these
components; the proof does not restrict \(T\) to them.

Define

\[
\begin{split}
D_j&=\mathbb E_{\nu_j^2}
 K^{(j)}_{k+u}(x,y)K^{(j)}_u(x,y)K^{(j)}_{r+l}(x,y),\\
D&=\sum_j\rho_j^{-1}D_j,\qquad
L=\sum_j\rho_j^{-2}D_j,\qquad
M_r=\max_x(K_r-P)(x,x).
\end{split}
\]

## The tail certificate

The spectral projection of \(A\) onto eigenvalue one is \(P\).
Let \(\lambda<1\) be its largest eigenvalue on \(\operatorname{ran}(I-P)\),
with \(\lambda=0\) if that space has no positive eigenvalue. Then

\[
\boxed{\ |F(h)-L|\le\lambda^hM_rD.\ }
\tag{1}
\]

Moreover, \(L>1\) unless \(A=\Pi\), where \(\Pi(x,y)=1\) is the global
constant kernel. If \(A=\Pi\), every \(F(h)=1\). Thus, for \(A\ne\Pi\),

\[
\lambda^hM_rD\le L-1\quad\Longrightarrow\quad F(h)\ge1.
\tag{2}
\]

There is an exact rational alternative to estimating \(\lambda\). Set

\[
m=\max(1,|X|-1),\qquad
\varepsilon=\min_j\min_{x,y\in C_j}\rho_jK_m(x,y).
\]

Then \(0<\varepsilon\le1\). If \(\varepsilon=1\), \(A=P\) and every
\(F(h)=L\ge1\). Otherwise, for \(h=qm+s\), \(0\le s<m\),

\[
\boxed{\ |F(h)-L|\le(1-\varepsilon)^qM_rD.\ }
\tag{3}
\]

For \(A\ne\Pi\) and \(\varepsilon<1\), let \(q_*\) be the least
nonnegative integer with

\[
(1-\varepsilon)^{q_*}M_rD\le L-1.
\]

It exists, and every \(h\ge\max(1,mq_*)\) satisfies \(F(h)\ge1\).
For rational \(\mu,T\), every constant and comparison in this test is
rational. The remaining positive \(h\)'s can therefore be checked by finitely
many exact sums. The number of tests is host-dependent, not a uniform
polynomial-time or host-uniform bound.

## Proof

On a normalized component, take a full orthonormal eigenbasis
\(\phi_0=1,\phi_1,\ldots\), with eigenvalues
\(\theta_0=1\), \(0\le\theta_i<1\) for \(i>0\). The finite spectral theorem
and expansion of three relative kernels give

\[
D_j=\sum_{\alpha,\beta,\gamma}
 \theta_\alpha^{k+u}\theta_\beta^u\theta_\gamma^{r+l}
 \bigl(\mathbb E_{\nu_j}\phi_\alpha\phi_\beta\phi_\gamma\bigr)^2.
\tag{4}
\]

Every term is nonnegative. The all-constant term is one. The three disjoint
families with exactly one constant index and two identical nonconstant
indices show

\[
D_j-1\ge\sigma_j(k+2u)+\sigma_j(k+u+r+l)+\sigma_j(u+r+l),
\quad \sigma_j(t)=\operatorname{tr}(B_j^t)-1.
\tag{5}
\]

Hence \(D_j\ge1\), strictly if \(B_j\ne\Pi_j\). Multiple components give
\(L\ge\sum_j\rho_j^{-2}>1\); one component gives strictness unless
\(A=\Pi\). Zero eigenvalues need no separate positivity assumption.

Integrating the five unchanged edges first at \(a\) and \(c\) gives

\[
\mathbb E_{\mu^4}K_k(a,b)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d)
=\mathbb E_{\mu^2}K_{k+u}(b,d)K_u(b,d)K_{r+l}(b,d)=D.
\tag{6}
\]

Replacing the remaining \(ac\) edge by \(P\) forces all four vertices into
one component. The four original vertex masses and six relative-kernel
factors leave \(\rho_j^{-2}\), so the resulting integral is \(L\).

Put \(R_r=K_r-P\succeq0\). Spectral Cauchy–Schwarz gives

\[
|K_{r+h}(a,c)-P(a,c)|
\le\lambda^h\sqrt{R_r(a,a)R_r(c,c)}\le\lambda^hM_r.
\]

The five-edge integrand in (6) is nonnegative, so integration proves (1)
and \(F(h)\to L\).

For the rational bound,
\(A(x,x)=\sum_z\mu_zT(x,z)^2>0\), since each Markov row is nonzero.
A simple path in a support component has length at most \(|X|-1\), and
positive loops pad it to length \(m\). Thus \(K_m\) is positive on each
component. Each normalized row has mean one, proving
\(0<\varepsilon\le1\). If \(\varepsilon=1\), every such row equals one,
so \(A^m=P\). Nonnegative eigenvalues imply \(A=P\).

If \(\varepsilon<1\),

\[
C=\frac{K_m-\varepsilon P}{1-\varepsilon}
\]

is nonnegative and Markov with \(CP=P\). It is also PSD: its eigenvalues
are one on the stationary space and \(\theta^m/(1-\varepsilon)\) otherwise.
Using \(PR_r=0\),

\[
K_{r+h}-P=(1-\varepsilon)^q C^qA^sR_r.
\]

Left convolution by a Markov kernel contracts the maximum absolute relative
kernel entry under the original law. PSD gives
\(\max_{x,y}|R_r(x,y)|\le M_r\). Applying (6) proves (3).

## A cutoff for a quantitative connected class

For a connected quantitative mixing class, there is also a cutoff uniform
in two of the base exponents. Suppose the positive-support graph of
\(A=T^2\) is connected, \(|X|=n\), \(\min_x\mu_x\ge a_0>0\),
and the largest centered eigenvalue of \(A\) is at most \(s_0<1\).
For \(0<s_0<1\), set
\[
C_0=\frac n{a_0}(a_0^{-1}-1),\qquad
H=\min\{q\in\mathbb Z_{\ge0}:C_0s_0^q\le1\}.
\]
Every \(h\ge u+l+H\) then gives \(F(h)\ge1\), for all positive \(k,r\).
To see this, let \(a=\min\mu\) and \(0<\lambda<1\) be the actual largest
centered eigenvalue. Orthonormal completeness and the Markov row bound give
\[
M_r\le\lambda^r(a^{-1}-1),\quad
D\le a^{-1}\operatorname{tr}(A^{k+u+r+l})\le n/a,\quad
D-1\ge\lambda^{u+r+l}.
\]
Since \(D=L\) in the connected case, (1) yields
\[
F(h)-1\ge\lambda^{u+r+l}
\left[1-\frac n a(a^{-1}-1)\lambda^{h-u-l}\right].
\]
For \(h\ge u+l\), replacing the last power by \(s_0^{h-u-l}\) proves
the claim. If the actual centered eigenvalue is zero, \(A=\Pi\) and
the density is exactly one. The class \(s_0=0\) is handled by that equality
case directly. This additional sufficient bound is not uniform without
the lower mass and quantitative mixing assumptions.

## What the certificate does not permit

The tail certificate does not show that all exceptional \(h\)'s pass.
Nor does it bound the cutoff uniformly over hosts without the quantitative
mass and mixing restrictions above. It supplements the earlier mixing
compensation route; no novelty, unrestricted proof or Lean acceptance is
claimed.

A separate direct reflection shortcut fails on an actual two-state host.
For \(\mu=(1/2,1/2)\),
\(W=\left(\begin{smallmatrix}1&1/3\\1/3&1\end{smallmatrix}\right)\),
\(p=2/3\), the Hermitian part of
\(D_{K_1(\cdot,d)}K_4\), with \(d\) the first state, is the following
operator matrix in the orthonormal coordinate basis of \(L^2(\mu)\):

\[
\frac1{2048}\begin{pmatrix}1285&1020\\1020&771\end{pmatrix}.
\]

Its determinant is \(-49665/4194304\), and its quadratic form at
\((4,-5)\) is \(-965/2048\). Thus a generic PSD trace insertion is not
available, despite all kernels coming from the actual root. This is not a
density counterexample: at \((k,u,r,l,h)=(1,1,1,1,4)\), the same host gives
\(F=1+1157/32768>1\).
