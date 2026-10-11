# Actual channel compensation for the density tail

The actual nonnegative root supplies a positive remainder that is lost by
centering its flags too early. Retaining it gives a conditional payment
certificate with no maximum-kernel or minimum-mass assumption. A separate
variance identity isolates the effect of increasing the distinguished edge
length. Neither proves the unrestricted density theorem.

## Original root and target

Use the finite positive probability law and weighted compositions in
[the ordered compensation derivation](ordered-gradient-compensation.md).
Thus \(T\ge0\) is symmetric and Markov under the original law \(\mu\),
\(A=T^2\), \(K_j=A^j\), and \(R_j=K_j-1\). Retain
\(k\ge u\ge1, r\ge l\ge1, h\ge1\) and the target
\[
F=\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
                         K_r(b,c)K_u(b,d)K_l(c,d)\ge1.
\]
All arguments below permit zero entries, extra stationary modes and periodic
or reducible roots. A conditional certificate need not succeed on every
such root.

## A positive full flag remainder

Put \(m=r+u\), \(w_d(c)=K_l(c,d)\), \(s_d=\sqrt{w_d}\), and
\(f_d(c)=K_m(c,d)\). The full flag is
\[
q(e,c,d)=\mathbb E_a T^k(e,a)K_r(a,c)K_u(a,d)\ge0,
\qquad \mathbb E_e q(e,c,d)=f_d(c).
\tag{1}
\]
Integrating two copies over \(e\) gives \(T^{2k}=K_k\), so
\[
F=\mathbb E_{e,c,d}w_d(c)q(e,c,d)(A_c^hq)(e,c,d).
\]
Symmetry under \(c\leftrightarrow x\) proves the exact identity
\[
\begin{aligned}
F&=G_q+J_q,\\
G_q&=\mathbb E_{e,d}\langle s_dq(e,\cdot,d),
                         A^h[s_dq(e,\cdot,d)]\rangle_\mu,\\
J_q&=\tfrac12\mathbb E_{e,c,x,d}K_h(c,x)
      (s_d(c)-s_d(x))^2q(e,c,d)q(e,x,d).
\end{aligned}
\tag{2}
\]
Both terms are nonnegative: \(A^h\succeq0\) controls \(G_q\), while
entrywise nonnegativity of the actual kernels and flags controls \(J_q\).
No PSD assertion about a weighted Jordan product is used.

Define the two-coordinate baseline
\[
\begin{aligned}
D&=\mathbb E_{c,d}K_l(c,d)K_m(c,d)K_{m+h}(c,d),\\
G_0&=\mathbb E_d\langle s_df_d,A^h(s_df_d)\rangle_\mu,
\qquad J_0=D-G_0\ge0.
\end{aligned}
\tag{3}
\]
The same identity (2) with \(q=f_d\) shows that \(J_0\) is its nonnegative
square-gradient remainder. Since \(\mathbb E_e(q-f_d)=0\), expansion gives
\[
G_q-G_0=\mathbb E_{e,d}\langle s_d(q-f_d),
                       A^h[s_d(q-f_d)]\rangle_\mu\ge0.
\tag{4}
\]
The triangle surplus is already explicit in the original eigenbasis:
\[
D=1+\sigma(l+m)+\sigma(l+m+h)+\sigma(2m+h)
        +\mathcal M(l,m,m+h)\ge1.
\tag{5}
\]
The centered sums \(\sigma,\mathcal M\) retain every additional unit mode.

## A root minorization pays the remainder

Suppose \(0\le\beta<1\) and the **actual** powered root satisfies
\(T^k(e,a)\ge\beta\) entrywise. Then
\[
P=\frac{T^k-\beta\Pi}{1-\beta},\qquad
p(e,c,d)=\mathbb E_aP(e,a)K_r(a,c)K_u(a,d)
\]
are nonnegative, \(P\) is symmetric Markov, and
\[
q=\beta f_d+(1-\beta)p,\qquad \mathbb E_ep=f_d.
\]
No claim that \(P\) is another nonnegative square root is needed.
Expand the bilinear expression defining \(J_q\) in (2), and integrate \(e\).
Both cross terms equal \(J_0\), giving
\[
J_q=(2\beta-\beta^2)J_0+(1-\beta)^2J_p
       \ge(2\beta-\beta^2)J_0.
\]
Together with (3)--(4), this proves
\[
\boxed{F\ge D-(1-\beta)^2(D-G_0).}
\tag{6}
\]
Thus the genuinely sufficient, non-equivalent certificate is
\[
\boxed{(1-\beta)^2(D-G_0)\le D-1.}
\tag{7}
\]
It uses the actual root floor and two-coordinate geometry, not the original
four-vertex density as an assumed input. For example \(\beta=\min T^k\) is
admissible. At \(\beta=1\), Markov normalization forces \(T^k=\Pi\), hence
\(q=f_d\) and \(F=D\); the statement is handled without division.
At \(\beta=0\), (6) gives only \(F\ge G_0\), which need not reach one.

The simpler consequence \(F\ge\beta(2-\beta)D\) follows from \(G_0\ge0\).
The estimate is not a reformulation of the transition cap: it can certify
families with arbitrarily large \(K_l\). For a direct illustration, take
two states of masses \(p,1-p\), with weighted identity \(I\), and
\(T=\Pi+\tfrac12(I-\Pi)\). It is an actual positive symmetric Markov root.
Here \(\theta=1/4\), \(\beta=1-2^{-k}>0\), and
\[
\mathcal M(l,m,m+h)
=\theta^{l+2m+h}\frac{(1-2p)^2}{p(1-p)}.
\]
Consequently \(D\to\infty\) as \(p\downarrow0\), so the simpler certificate
eventually succeeds although
\(K_l(\text{rare},\text{rare})=1+\theta^l(1-p)/p\to\infty\).
This rank-one family was already covered by earlier density arguments;
it illustrates payment without a cap, not a new density class.

The earlier [conditional channel floors](collective-correction-budgets.md)
minorize \(H\) and \(\Gamma\) in a different overlap representation. Equation
(6) instead minorizes \(T^k\) before forming the positive full flag and keeps
its complete square-gradient remainder. Neither set of floors is universal.

## Conditional covariance when the edge length increases

Let \(d=k-u\ge0\). For real original-law functions \(v,z\), put
\[
\mathcal E_d(v,z)=\langle v,(I-A^d)z\rangle_\mu
=\mathbb E_\mu\{T^d(vz)-(T^dv)(T^dz)\}.
\tag{8}
\]
This is the integrated actual Markov conditional covariance. It is PSD by
conditional variance, or the spectrum of \(I-A^d\). Every unit mode is in
its null space, including every component-stationary mode.

Write \(C_6(k)\) for the integral of the six **centered** edge kernels with
the target exponents. For \(t=0,h\), define
\[
b_t^{x,y}(z)=R_{r+t}(x,z)R_u(y,z),\qquad
a_t^{x,y}=T^u b_t^{x,y}.
\]
Let
\[
\begin{aligned}
L_t&=\mathbb E_{x,y}K_l(x,y)\mathcal E_d(a_t,a_t)\ge0,\\
L_{\rm diff}&=\mathbb E_{x,y}K_l(x,y)
                      \mathcal E_d(a_h-a_0,a_h-a_0)\ge0,\\
V_h&=\mathcal M(u,2r+h,2u)-\mathcal M(k,2r+h,2u)\ge0.
\end{aligned}
\]
The following identity retains the constant-index correction explicitly:
\[
\boxed{C_6(k)=C_6(u)+V_h
             -\tfrac12(L_0+L_h)+\tfrac12L_{\rm diff}.}
\tag{9}
\]
Indeed integrating the two endpoints of the \(ab\) edge gives
\[
C_6(k)-C_6(u)
=-\mathbb E_{x,y}R_l(x,y)\mathcal E_d(a_h,a_0),
\]
since
\(T^u(I-A^d)T^u=A^u-A^k\).
Replace \(R_l\) by \(K_l-1\). The term with weight one is \(V_h\), by
weighted composition of the two \(r\)-legs and the two \(u\)-legs.
Polarization of the remaining covariance proves (9). In particular,
\[
C_6(k)\ge C_6(u)+V_h-\sqrt{L_0L_h}.
\tag{10}
\]
At \(k=u\), all covariance terms and \(V_h\) vanish. There is no implicit
removal of stationary modes and no division by a kernel.

Identity (9) does not pay its variance losses or establish the base
\(C_6(u)\). Averaging it with another centered-edge grouping supplies no
extra positive budget: both groupings contain the same signed tetrahedron.
The needed comparison with the retained proper-subgraph surplus is still
unproved.

## Proof boundary

Equations (6)--(7) give an actual conditional payment, rather than a sign
claim for an arbitrary PSD cross form. Equations (9)--(10) isolate the
remaining length-transfer losses using genuine conditional variances.
Poorly mixed, periodic or reducible roots can have zero root floor, and
the variance losses have no universal payment here. The exact unrestricted
tail inequality in [the negative-mass derivation](ordered-negative-mass.md)
therefore remains open.

The [bounded conclusion-first audit](actual-channel-tail-audit.md) records
these distinct routes. These analytical statements do not add an accepted
Lean endpoint or a manuscript theorem, and they carry no novelty claim.
