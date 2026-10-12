# A quantitative output-compensation tail

For each fixed finite actual host, the processed overlap is at least one once the output exponent is sufficiently large. The cutoff below is explicit and uniform in the remaining long-edge exponent. This is a partial certificate, not the unrestricted density theorem. It complements the earlier certificate that varies the long-edge exponent while holding the four base exponents fixed.

## Definitions

Let \(X\) be finite and nonempty, with a strictly positive probability law \(\mu\). Let \(T\) be a symmetric, entrywise nonnegative relative Markov kernel. Products and all expectations use the original law \(\mu\). Set \(A=T^2\), \(K_j=A^j\), and take integers \(r\ge l\ge1\), \(u,h\ge1\). Define

\[
q_r(e,c,d)=\mathbb E_a T^u(e,a)K_r(a,c)K_u(a,d),
\qquad
f_r(c,d)=\mathbb E_e q_r(e,c,d)=K_{r+u}(c,d),
\]
\[
H_r(c,x,d)=\mathbb E_e\sqrt{q_r(e,c,d)q_r(e,x,d)},
\qquad
W_r=\mathbb E_{c,x,d}K_h(c,x)K_l(c,d)H_r(c,x,d)^2.
\]

The feature-processing exponent remains \(u\); only the output exponent \(r\) varies here. For \(k\ge u\), write the original density as

\[
F(k)=\mathbb E_{a,b,c,d}
K_k(a,b)K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d).
\]

The retained actual-feature certificate and feature data processing give \(F(k)\ge W_r\). No converse implication is asserted, and that retained certificate is not being reproved here.

Put

\[
U_r(c,x,d)=f_r(c,d)f_r(x,d)-H_r(c,x,d)^2\ge0,
\quad
L_r=\mathbb E K_h(c,x)K_l(c,d)U_r(c,x,d).
\]

Writing \(b=r+u\), integrating \(x\) gives the exact identity

\[
W_r=D_r-L_r,
\qquad
D_r=\mathbb E_{c,d}K_l(c,d)K_b(c,d)K_{b+h}(c,d).
\tag{1}
\]

## An explicit mixing-host cutoff

Suppose the support graph of \(A\), rather than \(T\), is connected. Its eigenvalues are nonnegative. If it has a positive nonconstant eigenvalue, let \(0<\rho<1\) be the largest such eigenvalue and set \(J=\mu_{\min}^{-1}-1\). Then

\[
J\rho^r\le\tfrac12
\quad\Longrightarrow\quad
W_r-1\ge \rho^{r+u+l}-6J^2\rho^{2r}.
\tag{2}
\]

In particular, the explicit sufficient conditions

\[
\rho^r\le
\min\left\{\frac1{2J},\frac{\rho^{u+l}}{12J^2}\right\}
\tag{3}
\]

give \(W_r-1\ge\tfrac12\rho^{r+u+l}>0\), for every \(h\ge1\). For each fixed host and fixed \(u,l\), an integer satisfying (3) exists. This is not a host-uniform cutoff.

### Proof of the loss bound

Orthonormal completeness and spectral Cauchy–Schwarz give

\[
|K_r(a,c)-1|
\le\rho^r\sqrt{(\mu_a^{-1}-1)(\mu_c^{-1}-1)}
\le J\rho^r=:\varepsilon.
\]

Let \(m_{ed}=\mathbb E_a T^u(e,a)K_u(a,d)=T^{3u}(e,d)\). Nonnegativity of the original summands implies

\[
|q_r(e,c,d)-m_{ed}|\le\varepsilon m_{ed}.
\tag{4}
\]

If \(m_{ed}=0\), the entire \(q_r(e,\cdot,d)\) row is zero. Otherwise write \(q_r(e,c,d)=m_{ed}(1+v_{ec})\), with \(|v_{ec}|\le\varepsilon\). Thus no division by a zero entry is required.

The exact Gram identity is

\[
U_r(c,x,d)=\tfrac12\mathbb E_{e,f}
\left(
\sqrt{q_r(e,c,d)q_r(f,x,d)}
-\sqrt{q_r(e,x,d)q_r(f,c,d)}
\right)^2.
\tag{5}
\]

When \(\varepsilon\le1/2\), each partial derivative of \(\sqrt{st}\) on \([1/2,3/2]^2\) is at most \(\sqrt3/2\). The two coordinates change by at most \(2\varepsilon\) each. Hence the absolute bracket in (5) is at most \(2\sqrt3\varepsilon\sqrt{m_{ed}m_{fd}}\). Since \(\mathbb E_e m_{ed}=1\),

\[
0\le U_r(c,x,d)\le6\varepsilon^2.
\]

The original external weight is a normalized tree law:
\(\mathbb E_{c,x,d}K_h(c,x)K_l(c,d)=1\). Consequently

\[
0\le L_r\le6J^2\rho^{2r}.
\tag{6}
\]

### Proof of the spectral surplus

Take an orthonormal eigenbasis \(\phi_0=1,\phi_1,\ldots\) of \(A\), with eigenvalues \(\theta_0=1\) and \(0\le\theta_i<1\) for \(i>0\). Set

\[
\sigma(t)=\sum_{i>0}\theta_i^t,
\quad
M(a,b,c)=\sum_{i,j,s>0}\theta_i^a\theta_j^b\theta_s^c
\bigl(\mathbb E_\mu\phi_i\phi_j\phi_s\bigr)^2.
\]

Expansion of the three factors in (1), retaining every nonconstant mode, gives

\[
D_r-1=
\sigma(2b+h)+\sigma(b+l)+\sigma(b+h+l)+M(l,b,b+h).
\tag{7}
\]

All terms are nonnegative, so \(D_r-1\ge\rho^{r+u+l}\). Equations (1) and (6) prove (2), and (3) pays at most half this surplus. Negative eigenvalues of \(T\) have not been discarded; \(\rho\) is an eigenvalue of \(T^2\).

If there is no positive nonconstant eigenvalue, \(A=\Pi\). Self-adjointness then gives \(T=\Pi\), and \(W_r=1\). The one-state case is included here; no expression involving \(1/J\) is used in that case.

## Eventual decrease toward one

For the same mixing host, (7) has nonnegative coefficients and each term decreases when \(r\) increases. In particular,

\[
D_r-D_{r+1}\ge(1-\rho)\rho^{r+u+l}.
\]

Since \(L_{r+1}\ge0\), (1) and (6) give

\[
W_r-W_{r+1}\ge
(1-\rho)\rho^{r+u+l}-6J^2\rho^{2r}.
\tag{8}
\]

Thus

\[
\rho^r\le
\min\left\{\frac1{2J},
\frac{(1-\rho)\rho^{u+l}}{12J^2}\right\}
\]

implies \(W_r-W_{r+1}\ge\tfrac12(1-\rho)\rho^{r+u+l}>0\), uniformly in \(h\). This proves eventual decreasing monotonicity, not monotonicity at all admissible exponents. Equations (4)–(6) and (7) also imply \(W_r\to1\).

## Reducible and periodic roots

Let \(C\) be a support component of \(A\) and \(p_C=\mu(C)\). Positivity of a power of \(T\) is equivalent to existence of a walk of that length in its support graph. Any two neighbours of vertices linked by an even walk are linked by an even walk themselves. Therefore \(T\) sends \(C\) into one \(A\)-component \(\tau C\), and \(\tau\) is an involution. Symmetry and the Markov condition imply \(p_{\tau C}=p_C\). This includes a periodic root interchanging two components.

Write \(\mu_C=\mu|_C/p_C\), and normalize the square by \(A_C=p_CA|_{C^2}\), so that \(K_j^C=p_CK_j|_{C^2}\). The feature variable lies in \(E=\tau^u C\). The kernel

\[
B_u(e,a)=p_CT^u(e,a),\qquad (e,a)\in E\times C,
\]

is a nonnegative rectangular channel with both normalized Markov marginals. It is not asserted to be a symmetric root within \(C\). Define the component quantities using the state law \(\mu_C\) and feature law \(\mu_E\). Direct scaling gives

\[
q_r^C=p_C^2q_r,\qquad
H_r=p_C^{-1}H_r^C,\qquad
W_r=\sum_Cp_C^{-1}W_r^C.
\tag{9}
\]

For completeness, the first equality follows from the three factors \(B_u,K_r^C,K_u^C\) and the input law \(\mu_C\): their scaling is \(p_C^3/p_C=p_C^2\). The second uses the feature law \(\mu_E\). In the last equality the three endpoint masses contribute \(p_C^3\), the two external kernels \(p_C^{-2}\), and \(H_r^2\) contributes \(p_C^{-2}\).

Let \(\rho_C\in[0,1)\) be the largest nonconstant eigenvalue of \(A_C\), taking zero if none is positive, and put \(J_C=p_C/\min_{a\in C}\mu_a-1\). The proof of (4)–(6) uses only the rectangular channel's nonnegative coefficients and its two normalized marginals. It therefore applies without a within-component root. The component version of (7) still gives \(D_r^C\ge1\). Whenever every \(J_C\rho_C^r\le1/2\),

\[
W_r\ge
\sum_Cp_C^{-1}
-6\sum_Cp_C^{-1}J_C^2\rho_C^{2r}.
\tag{10}
\]

If \(\rho_C=0\), every \(K_r^C=1\), the row \(q_r^C\) is independent of \(c\), and \(W_r^C=1\) exactly. This also covers singleton components. In every component \(W_r^C\to1\), so

\[
\lim_{r\to\infty}W_r=\sum_Cp_C^{-1}.
\tag{11}
\]

For multiple components this limit exceeds one. In particular, the explicit additional condition

\[
6\sum_Cp_C^{-1}J_C^2\rho_C^{2r}
<\sum_Cp_C^{-1}-1
\]

proves \(W_r>1\). This reducible cutoff is uniform in \(u,h\ge1\) and \(1\le l\le r\). No stationary mode has been treated as a decaying mode.

## Retaining actual feature smoothing

There is a complementary bound that keeps the decay supplied by \(T^u\), rather than replacing it by a generic channel. Continue to assume a mixing host with \(0<\rho<1\), and put \(C=J(1+J)\). If

\[
J\rho^{3u/2}\le\tfrac12,
\qquad 2C\rho^{r+u/2}\le\tfrac12,
\tag{12}
\]

then

\[
W_r-1\ge\rho^{r+u+l}-24C^2\rho^{2r+u}.
\tag{13}
\]

Consequently, adding the condition

\[
\rho^{r-l}\le\frac1{48C^2}
\tag{14}
\]

gives \(W_r-1\ge\tfrac12\rho^{r+u+l}>0\), uniformly in \(h\). Here \(u\) can vary with \(r\); unlike (3), the final payment cutoff (14) involves \(r-l\), not \(r-u-l\). Conditions (12) remain necessary for this particular estimate.

To prove it, symmetry of the actual root and the same spectral completeness bound give
\(|T^u(e,a)-1|\le J\rho^{u/2}\) and \(|T^{3u}(e,d)-1|\le J\rho^{3u/2}\). These bounds use absolute values of the root eigenvalues, so odd powers and negative modes remain included. With \(R_r=K_r-\Pi\), the exact centred identity is

\[
\begin{split}
q_r(e,c,d)-m_{ed}
&=R_{r+u}(c,d)\\
&\quad+\mathbb E_a
(T^u(e,a)-1)K_u(a,d)R_r(a,c).
\end{split}
\tag{15}
\]

The nonnegative kernel \(K_u(\cdot,d)\) has mean one. Hence

\[
|q_r(e,c,d)-m_{ed}|
\le J\rho^{r+u}+J^2\rho^{r+u/2}
\le C\rho^{r+u/2}.
\]

The first guard in (12) gives \(m_{ed}\ge1/2\), so the relative error is at most \(\varepsilon'=2C\rho^{r+u/2}\). The second guard allows the exact same Gram-wedge estimate (5), now with \(\varepsilon'\), and yields \(L_r\le6(\varepsilon')^2=24C^2\rho^{2r+u}\). Combining with (7) proves (13) and (14). This is a direct actual-root calculation under the original law, not a stationary-norm estimate under a posterior law. It does not assert that an arbitrary PSD channel supplies the same decay.

## What remains open

The estimate pays the original weighted Gram defect by a genuine spectral surplus for large \(r\). It does not pay that defect at every finite \(r\ge l\), establish global output monotonicity, or settle the unrestricted ordered density inequality. A spectral-gap and minimum-mass dependent cutoff is not uniform over all finite hosts. Existing density-region results and the earlier long-edge tail certificate must not be presented as new coverage or novelty on the strength of this note. No Lean validation, manuscript theorem, publication-readiness claim, or new literature claim is made here.
