# Positive cases of the actual processed-overlap bound

The actual processed-overlap sufficient bound is proved here for every balanced two-state root and for sufficiently small centered perturbations of the constant root on each fixed finite positive probability space. The unrestricted finite-state overlap and density inequalities remain open. These are analytical proofs, not Lean-verified endpoints or novelty claims.

## Definitions and target

Let \(\mu\) be a strictly positive probability law on a finite nonempty set. Let \(T\) be a symmetric, entrywise nonnegative relative Markov kernel, with composition under the original law \(\mu\). Put \(A=T^2\) and \(K_j=A^j\). Integers satisfy \(k\ge u\ge1\), \(r\ge l\ge1\), and \(h\ge1\). Define

\[
q_u(e,c,d)=\mathbb E_a T^u(e,a)K_r(a,c)K_u(a,d),
\quad
H_u(c,x,d)=\mathbb E_e\sqrt{q_u(e,c,d)q_u(e,x,d)},
\]
\[
W_u=\mathbb E_{c,x,d}K_h(c,x)K_l(c,d)H_u(c,x,d)^2.
\]

All expectations use \(\mu\), including the output coordinates. The previously established actual-feature certificate gives \(F(k)\ge W_k\), and actual Markov processing gives \(W_k\ge W_u\) when \(k\ge u\). Thus universal \(W_u\ge1\) would suffice for the original ordered density theorem. It is a stronger proposed statement, not an equivalent reformulation or an accepted hypothesis.

## A complete balanced two-state bound

Take \(X=\{-1,1\}\), \(\mu=1/2\), and \(T(x,y)=1+txy\), where \(-1\le t\le1\). Write

\[
\lambda=t^2,\quad a=\lambda^r,\quad b=\lambda^u,
\quad L=\lambda^l,\quad H=\lambda^h,\quad z=t^u.
\]

Then \(z^2=b\), \(L\ge a\), and direct convolution gives

\[
q_u(e,c,d)=1+ab\,cd+ze(ac+bd).
\tag{1}
\]

For \(c=x\), \(H_u(c,c,d)=1+ab\,cd\). For \(c=-x\), its square is independent of \(d\) and equals \(J(a^2)\), where

\[
J(v)=\frac12\bigl(R(v)+\sqrt{Q(v)}\bigr),
\quad R(v)=1+b^3-v(b+b^2),
\]
\[
Q(v)=R(v)^2-4b^3(1-v)^2
      =\alpha-\beta v+\gamma v^2,
\]
\[
\alpha=(1-b^3)^2,\qquad
\beta=2b(1-b)^2(1+3b+b^2),\qquad
\gamma=b^2(1-b)^2.
\tag{2}
\]

For \(0<b<1\), every entry of (1) is positive for \(0\le a\le1\): this holds at \(a=0,1\) and each entry is affine in \(a\). Hence \(Q(v)>0\) on \([0,1]\). Moreover

\[
\beta^2-4\alpha\gamma=16b^3(1-b)^4(1+b)^2\ge0.
\]

The second derivative of \(\sqrt{Q}\) is therefore nonpositive. Thus \(J\) is concave. Its endpoints are

\[
J(0)=1,\qquad J(1)=(1-b)^2(1+b),
\]

so the endpoint chord yields

\[
J(a^2)\ge1-a^2b(1+b-b^2).
\tag{3}
\]

When \(b=0\), \(J=1\). When \(b=1\), \(J(v)=1-v\). These formulas also establish (3) at the endpoints without dividing by a vanishing quantity. The sign of \(z\) does not affect \(J\).

Separating \(c=x\) and \(c=-x\) gives the exact expression

\[
W_u=\frac12\bigl[(1+H)(1+a^2b^2+2Lab)+(1-H)J(a^2)\bigr].
\tag{4}
\]

Use (3) and \(L\ge a\) in (4). Since \(0\le H\le1\), both substitutions have the correct sign. After collecting terms,

\[
\boxed{W_u\ge1+\frac12a^2b\bigl[1+b^2+H(3+2b-b^2)\bigr]\ge1.}
\tag{5}
\]

This includes zero and negative nonconstant eigenvalues of \(T\), the constant root, the identity root, and the deterministic flip. It proves the stronger overlap statement in this family, but adds no host family to the already proved density cases.

## Local payment near the constant root

Fix the finite positive law \(\mu\), the exponents, and a nonzero symmetric relative kernel \(B\) satisfying \(B1=0\). For sufficiently small real \(\varepsilon\),

\[
T_\varepsilon=\Pi+\varepsilon B>0,
\qquad \Pi(c,x)=1,
\]

is an actual symmetric Markov root. Symmetry also gives \(\Pi B=B\Pi=0\), so for positive integers \(j\),

\[
T_\varepsilon^j=\Pi+\varepsilon^jB^j,
\qquad K_j=\Pi+\varepsilon^{2j}B^{2j}.
\]

There exists \(\varepsilon_0>0\), depending on this fixed law, kernel, and exponents, such that \(W_u>1\) whenever \(0<|\varepsilon|<\varepsilon_0\). No radius uniform in the host is asserted.

### Exact expansion and cancellation

Put \(p=u+2r\) and \(m=r+u\). Multiplying the three root factors defining \(q_u\) gives

\[
q_u(e,c,d)=1+\varepsilon^p B^p(e,c)
 +\varepsilon^{3u}B^{3u}(e,d)
 +\varepsilon^{2m}B^{2m}(c,d)
 +\varepsilon^{2r+3u}C(e,c,d),
\]
\[
C(e,c,d)=\mathbb E_aB^u(e,a)B^{2r}(a,c)B^{2u}(a,d).
\tag{6}
\]

Every omitted single-factor term vanishes by centering. Write
\(q_u(e,c,d)=a(e,d)+\delta(e,c,d)\), with

\[
a(e,d)=1+\varepsilon^{3u}B^{3u}(e,d),\qquad
\delta(e,c,d)=\varepsilon^p B^p(e,c)+O(|\varepsilon|^{p+u}).
\]

All remainders are uniform over the fixed finite state space. The term \(a(e,d)\) may have lower order than \(\varepsilon^p\), but it is independent of \(c\). In

\[
q_u(e,c,d)q_u(f,x,d)-q_u(e,x,d)q_u(f,c,d).
\]

only the pure product \(a(e,d)a(f,d)\) cancels. Writing \(a_e=a(e,d)\) and suppressing \(d\), the exact remaining expression is

\[
a_f(\delta_{ec}-\delta_{ex})+a_e(\delta_{fx}-\delta_{fc})
 +\delta_{ec}\delta_{fx}-\delta_{ex}\delta_{fc}.
\]

The factors \(a_e-1\) contribute only \(O(|\varepsilon|^{p+3u})\). Thus the resulting expression is

\[
\varepsilon^p\bigl[B^p(e,c)-B^p(e,x)-B^p(f,c)+B^p(f,x)\bigr]
 +O(|\varepsilon|^{p+u}).
\]

Rationalize the square-root difference. Its denominator is
\(2+O(|\varepsilon|^{\min(3u,p)})\); it is bounded away from zero for sufficiently small \(|\varepsilon|\). Hence

\[
\sqrt{q_u(e,c,d)q_u(f,x,d)}-
\sqrt{q_u(e,x,d)q_u(f,c,d)}
\]
\[
=\frac{\varepsilon^p}{2}
 [B^p(e,c)-B^p(e,x)-B^p(f,c)+B^p(f,x)]
 +O(|\varepsilon|^{p+u}).
\tag{7}
\]

With \(f_d(c)=\mathbb E_e q_u(e,c,d)=K_m(c,d)\), the exact Gram determinant identity is

\[
f_d(c)f_d(x)-H_u(c,x,d)^2
=\frac12\mathbb E_{e,f}
 \bigl[\sqrt{q_u(e,c,d)q_u(f,x,d)}-
       \sqrt{q_u(e,x,d)q_u(f,c,d)}\bigr]^2.
\tag{8}
\]

Because \(\mathbb E_eB^p(e,c)=0\), (7) and (8) imply

\[
f_d(c)f_d(x)-H_u(c,x,d)^2
=\frac{\varepsilon^{2p}}4\mathbb E_e
 [B^p(e,c)-B^p(e,x)]^2+O(|\varepsilon|^{2p+u}).
\]

Let \(\eta=\min(u,2h,2l)>0\). Multiplying by the actual weight
\(K_h(c,x)K_l(c,d)=1+O(|\varepsilon|^{2\min(h,l)})\) and averaging gives

\[
\mathbb E K_hK_l(f_df_d-H_u^2)
=\frac12\varepsilon^{2p}\operatorname{tr}(B^{2p})
 +O(|\varepsilon|^{2p+\eta}).
\tag{9}
\]

Here \(\mathbb E_{e,c,x}[B^p(e,c)-B^p(e,x)]^2
=2\operatorname{tr}(B^{2p})\), by centering and self-adjointness.

### The spectral surplus pays the loss

Convolution gives

\[
D=\mathbb E_{c,d}K_l(c,d)K_m(c,d)K_{m+h}(c,d),
\qquad W_u=D-\mathbb E K_hK_l(f_df_d-H_u^2).
\]

The three pair terms in \(D-1\) are

\[
\varepsilon^{2(m+l)}\operatorname{tr}(B^{2(m+l)}),\quad
\varepsilon^{2(m+l+h)}\operatorname{tr}(B^{2(m+l+h)}),\quad
\varepsilon^{2(2m+h)}\operatorname{tr}(B^{2(2m+h)}).
\]

The remaining triple term has order \(2(l+2m+h)\). Thus

\[
D-1=\varepsilon^{2(m+l)}\operatorname{tr}(B^{2(m+l)})
       +O(|\varepsilon|^{2(m+l)+2h}).
\tag{10}
\]

If \(l<r\), write \(n=2(m+l)<2p\). Equations (9) and (10) give

\[
W_u-1=\varepsilon^n\operatorname{tr}(B^n)
       +O(|\varepsilon|^{n+2\min(h,r-l)}).
\tag{11}
\]

If \(l=r\), the two leading orders coincide, and their coefficients leave

\[
W_u-1=\frac12\varepsilon^{2p}\operatorname{tr}(B^{2p})
       +O(|\varepsilon|^{2p+\eta}).
\tag{12}
\]

Every displayed leading exponent is even. A nonzero self-adjoint \(B\) has a positive trace at every positive even power, including when some eigenvalues vanish. Choosing \(\varepsilon_0\) so that the remainder is smaller than half the leading term proves strict positivity for both signs of \(\varepsilon\). When \(B=0\), \(W_u=1\) exactly. There is no conclusion here about a host-uniform neighborhood, distant roots, or unrestricted density coverage.

## Scope and next obligation

The dependencies connecting this overlap to density are the [actual-feature processing formulas](actual-feature-processing.md) and the [tensor-overlap certificate](tensor-overlap-constraint.md). The two positive results here do not prove the unrestricted inequality or enlarge the previously covered weak-host and binary density families. The local radius depends on the fixed host, kernel and exponents; no quantitative host-uniform radius is asserted.

The remaining task is genuine collective payment on arbitrary actual roots, including rare-state, zero-entry, reducible and periodic hosts. Source review of these partial results does not establish that task. No manuscript theorem, revision date, Lean source, compiler attempt, service request or monitor is changed by this packet.
