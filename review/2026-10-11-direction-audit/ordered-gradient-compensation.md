# Ordered norm budget and weighted gradient compensation

The original exponent ordering pays for the entire unweighted centered flag
norm. The remaining step is a weighted mixed-gradient estimate. The norm
comparison below holds for every admissible host, but it does not prove the
unrestricted density inequality. The distinction matters: replacing the
kernel weight by one would lose precisely the unresolved contribution.

## Target and conventions

Let \(X\) be finite and nonempty, with a positive probability law \(\mu\).
Let \(T\) be a symmetric, entrywise nonnegative relative Markov kernel under
that original law. All compositions, expectations and inner products use
\(\mu\). Put \(A=T^2\), \(K_j=A^j\), \(\Pi=1\), and \(R_j=K_j-\Pi\).
For integers \(k\ge u\ge1,\ r\ge l\ge1,\ h\ge1\), the target is
\[
F=\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
                      K_r(b,c)K_u(b,d)K_l(c,d)\ge1.
\tag{1}
\]
Zeros, reducibility, periodicity, nonuniform weights, extra unit modes and
zero eigenvalues are allowed. A negative eigenvalue of the root is squared
in \(A\); no arbitrary PSD replacement for the actual root is made.

Choose an original-law orthonormal eigenbasis \(A\phi_i=\theta_i\phi_i\),
with \(\phi_0=1\). Every centered index below means \(i\ne0\), including any
additional unit modes. Define
\[
\sigma(a)=\sum_{i\ne0}\theta_i^a,\qquad
\mathcal M(a,b,c)=\sum_{i,j,s\ne0}\theta_i^a\theta_j^b\theta_s^c
   \bigl(\mathbb E_\mu\phi_i\phi_j\phi_s\bigr)^2.
\tag{2}
\]
Thus \(\mathcal M\) is symmetric in its three exponents and nonnegative.

## The retained collective decomposition

The exact [Schur grouping](collective-compensation-positive-pass.md) gives
\[
F=U_0+U_1+U_2+M_0+M_1,
\tag{3}
\]
where all factors in each two-point expression share the displayed pair:
\[
\begin{aligned}
U_0&=\mathbb E_{\mu^2}K_{k+r}K_{r+h},\\
U_1&=\mathbb E_{\mu^2}K_{k+r}K_{r+h}R_{u+l},\\
U_2&=\mathbb E_{\mu^2}K_{k+r+h}K_rR_{u+l},\\
M_0&=\mathbb E_{\mu^2}K_lR_{r+u}R_{r+h+u}.
\end{aligned}
\]
Weighted convolution gives \(U_0=\operatorname{tr}A^{k+2r+h}\ge1\).
Expanding the other three expressions in the same eigenbasis makes each a
sum of nonnegative cubic-moment squares. Hence \(U_1,U_2,M_0\ge0\).
The triangle and three diamonds remain grouped with the signed tetrahedron
in \(M_1\); they are not discarded or bounded independently.

Let multiplication by \(\phi_i\) be \(D_{\phi_i}\), and define the kernels
\[
q_i=A^rD_{\phi_i}R_u,\qquad v_i=R_rD_{\phi_i}R_u.
\]
Their coordinates are
\[
q_i(c,d)=\mathbb E_aK_r(c,a)\phi_i(a)R_u(a,d),\qquad
q_i(c,d)=\theta_i^u\phi_i(d)+v_i(c,d).
\tag{4}
\]
Expanding the \(ab\) centered edge in the original expression for \(M_1\)
and integrating \(a,b\) gives
\[
M_1=\sum_{i\ne0}\theta_i^k
 \mathbb E_{c,d}K_l(c,d)q_i(c,d)(A_c^hq_i)(c,d).
\tag{5}
\]
The operator \(A_c^h\) acts only on the first coordinate.

## An all-host positive norm budget

The constant part and the two cross terms of (5) give exactly
\[
M_1=Z+\sum_{i\ne0}\theta_i^k
 \mathbb E_{c,d}K_l(c,d)v_i(c,d)(A_c^hv_i)(c,d),
\tag{6}
\]
where
\[
Z=\sigma(k+2u)+\mathcal M(k+u,u,r+l)
                  +\mathcal M(k+u,u,r+l+h)\ge0.
\tag{7}
\]
For example, the first cross term integrates to
\(\mathcal M(k+u,u,r+l)\); applying \(A_c^h\) adds \(h\) to the last
exponent in the other cross term. No contribution from an extra unit mode
is removed.

The unweighted centered norm satisfies
\[
N:=\sum_{i\ne0}\theta_i^k\|v_i\|_{L^2(\mu^2)}^2
  =\mathcal M(k,2u,2r)
  \le\mathcal M(k+u,u,r+l)\le Z.
\tag{8}
\]
Here is the complete comparison. In the first two indices, symmetrize each
cubic-moment coefficient and use, for \(x,y\in[0,1]\),
\[
\begin{aligned}
&x^{k+u}y^u+y^{k+u}x^u-x^ky^{2u}-y^kx^{2u}\\
&\qquad=(xy)^u(x^u-y^u)(x^{k-u}-y^{k-u})\ge0.
\end{aligned}
\tag{9}
\]
The sign follows from \(k\ge u\). When \(k=u\) the difference is zero;
the exponent-zero monomial is the constant polynomial one, also at zero.
Multiplication by the nonnegative remaining eigenvalue weight and summation
therefore give
\(\mathcal M(k,2u,2r)\le\mathcal M(k+u,u,2r)\).
Since \(2r\ge r+l\) and every eigenvalue lies in \([0,1]\), decreasing the
last exponent gives the second comparison in (8).
This is a dimension-free budget using both original ordering assumptions.

## Isolating the weighted mixed gradient

Set \(s_d(c)=\sqrt{K_l(c,d)}\), including at zero entries. Define
\[
\begin{aligned}
G_v&=\sum_{i\ne0}\theta_i^k\mathbb E_d
       \langle s_dv_i,A^h(s_dv_i)\rangle_\mu,\\
P_v&=\frac12\sum_{i\ne0}\theta_i^k\mathbb E_{c,x,d}
       K_h(c,x)v_i(c,d)^2\bigl(s_d(c)-s_d(x)\bigr)^2,\\
E_v&=\frac14\sum_{i\ne0}\theta_i^k\mathbb E_{c,x,d}
       K_h(c,x)\bigl(s_d(c)-s_d(x)\bigr)^2
                  \bigl(v_i(c,d)-v_i(x,d)\bigr)^2.
\end{aligned}
\tag{10}
\]
All three quantities are nonnegative. For \(G_v\) this uses PSD of \(A^h\);
for the other two it uses actual entrywise nonnegativity of \(K_h\).
These are separate properties.

Symmetrizing the weighted cross form under \(c\leftrightarrow x\) shows that
its difference from \(G_v\) is
\[
\frac12\sum_{i\ne0}\theta_i^k\mathbb E_{c,x,d}
 K_h(c,x)\bigl(s_d(c)-s_d(x)\bigr)^2v_i(c,d)v_i(x,d).
\]
Polarization, \(2ab=a^2+b^2-(a-b)^2\), now proves the exact identity
\[
M_1=Z+G_v+P_v-E_v.
\tag{11}
\]
Also \(E_v\le2P_v\), by \((a-b)^2\le2(a^2+b^2)\) and symmetry.
Consequently \(M_1\ge Z+G_v-P_v\).

One genuine sufficient certificate is \(P_v\le Z+G_v\).
More generally, all proper-subgraph surplus remains available:
\[
\boxed{\quad
E_v\le Z+G_v+P_v+(U_0-1)+U_1+U_2+M_0.
\quad}
\tag{12}
\]
For these explicitly defined quantities, (12) is equivalent to \(F\ge1\)
by (3) and (11). It is therefore an exact remaining obligation, not a
proof concealed behind a renamed lemma. The stronger \(M_1\ge0\) would
require only \(E_v\le Z+G_v+P_v\).

The unweighted estimate (8) does not imply (12): \(K_l(c,d)\) can be large
under the original law, and its square-root gradient remains coupled to
the flag gradient. An estimate replacing that weight by one is unjustified.
The next proof step must control these coupled gradients using their
actual semigroup origins, or use the other three positive budgets.

There is no division by a kernel in (4)--(12). If \(A\) is a Markov
projection, the weight is constant on its components and \(P_v=E_v=0\).
The auxiliary case \(h=0\) likewise has zero gradients. These checks do
not add either condition to the target.

## A calibrated full-flag budget

The actual nonnegative root supplies a second useful flag, without centered
mode coefficients:
\[
q(e,c,d)=\mathbb E_a T^k(e,a)K_r(a,c)K_u(a,d)\ge0,
\qquad b=q-1,\qquad m=r+u.
\]
It integrates to one against \(\mu^3\). Integrating two copies over \(e\),
\(c\) and \(d\) gives the exact unweighted norm
\[
\begin{aligned}
N_b:=\mathbb E_{e,c,d}b^2
 &=\mathbb E_{a,a'}K_k(a,a')K_{2r}(a,a')K_{2u}(a,a')-1\\
 &=\sigma(k+2r)+\sigma(k+2u)+\sigma(2m)
                  +\mathcal M(k,2r,2u).
\end{aligned}
\]
The cubic comparison (8), using symmetry of \(\mathcal M\), bounds its
last term by \(\mathcal M(k+u,u,r+l)\). Also
\(k+2r\ge m+l\) and \(2m\ge m+l\), so monotonicity of \(\sigma\) yields
\[
N_b\le Z+2\sigma(m+l)\le Z+2U_2.
\]
For the last comparison, the complete packet expansion is
\[
U_2=\sigma(k+r+h+u+l)+\sigma(r+u+l)
                  +\mathcal M(k+r+h,r,u+l).
\]
Thus the retained proper-subgraph packets pay for the entire unweighted
centered full flag as well as the earlier \(v_i\)-flags. No additional
stationary mode has been discarded.

The flag also gives an exact calibration, since
\(\mathbb E_e q(e,c,d)=K_m(c,d)\):
\[
F(h)=1+\sigma(m+l)+\sigma(m+l+h)
 +\mathbb E_{e,c,d}K_l(c,d)b(e,c,d)(A_c^hb)(e,c,d).
\]
Both linear trace terms are nonnegative. The final cross form still has
the actual kernel weight; the bound on \(N_b\) does not sign it. This is a
second constructive norm budget for the same collective proof attempt,
not a new density region or a solution of the weighted gap.

## Status and proof boundary

There is also a genuinely sufficient quantitative certificate, as distinct
from the equivalent remaining obligation (12). Put
\[
\varepsilon_l=\max_{c,d}|K_l(c,d)-1|,\qquad
N_h=\mathcal M(k,2u,2r+2h),\qquad
V_h=\mathcal M(k,2u,2r+h),
\]
and \(B=(U_0-1)+U_1+U_2+M_0\ge0\). Parseval gives
\(N_h=\sum_{i\ne0}\theta_i^k\|A_c^hv_i\|^2\le N\) and
\(V_h=\sum_{i\ne0}\theta_i^k\langle v_i,A_c^hv_i\rangle\ge0\).
Splitting the weight as \(K_l=1+R_l\), followed by Cauchy--Schwarz on
the original product probability space and the centered mode sum, proves
\[
F\ge1+B+Z+V_h-\varepsilon_l\sqrt{NN_h}.
\tag{13}
\]
Consequently
\[
\varepsilon_l\sqrt{NN_h}\le B+Z+V_h
\tag{14}
\]
is a sufficient, explicitly evaluable certificate. This is not equivalent
to the target: the pointwise absolute-value and Cauchy--Schwarz estimates
discard information. No division is necessary if \(N N_h=0\).
The estimate uses the actual moment budgets and semigroup contraction,
not an assumed bound on a weighted operator norm.

For example, \(\varepsilon_l\le1\) suffices by \(N_h\le N\le Z\).
However, this simple consequence supplies no newly established coverage:
the earlier maximum-kernel mixing criterion already covers
\(\max K_l\le4\), whereas this consequence only requires
\(\max K_l\le2\). The quantitative budget (14) is retained as a tool
for the collective argument, without a claim that it enlarges every
previous sufficient family. It does not close the unrestricted problem.

The norm comparison and mixed-gradient identities are analytical statements.
They do not add a newly covered exponent region or an accepted Lean result.
The unrestricted estimate (12) remains unproved. In particular, neither a
generic weighted Jordan-product inequality nor positivity of an unequal
cross form follows from PSD alone.

The [previous correction budgets](collective-correction-budgets.md) and this
note address the same target with different retained terms. The manuscript,
its theorem claims, the accepted structural Lean tree and the paused
monitors are unchanged.
