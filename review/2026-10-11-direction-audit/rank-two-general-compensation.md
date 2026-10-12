# A larger two-mode compensation domain

The midpoint payment extends to a larger exponent domain. On hosts with at most two active nonconstant modes, every original ordered tuple with h>=l-1 is now paid. The earlier all-host result required h>=2l-1. This is a low-spectral-rank extension, not the unrestricted density theorem or a novelty claim.

## Exact theorem and scope

Let X be finite and nonempty, with strictly positive original probability law mu. Let A be a self-adjoint, PSD, entrywise nonnegative Markov operator, and K_v its relative kernel at the positive integer power v. Suppose A has exactly two active nonconstant orthonormal modes x,y, with eigenvalues 1>=p>=q>0. Extra unit modes are active; arbitrary inactive zero modes are permitted.

Take integers k>=u>=1, r>=l>=1 and h>=1. Write J=r+h and

\[
F=E_{\mu^4}K_k(A_0,B_0)K_J(A_0,C_0)K_u(A_0,D_0)
K_r(B_0,C_0)K_u(B_0,D_0)K_l(C_0,D_0).
\tag{1}
\]

The analytical theorem below concerns the remaining strip

\[
J-l<u<r+l
\tag{2}
\]

and the additional, explicit exponent condition

\[
2\min(J,u)\ge\max(u,l)+\min(k,r).
\tag{3}
\]

It gives, with N=k+u+r+l,

\[
F\ge1+p^{u+r+l}+p^{k+2u}-p^{N+J+u-2}
\ge1+p^{u+r+l}>1.
\tag{4}
\]

No moment-sign, mixing or minimum-mass condition is imposed. This theorem is A-only: an entrywise nonnegative square root is not used in its proof. For the corollary combining (4) with the earlier all-host regions, the actual nonnegative symmetric Markov root A=T^2 is expressly retained.

The strip (2) forces l,u>=2. If p=q, or J=u, all potentially signed channels are nonnegative and the retained two triangles prove (4) immediately. Otherwise put

\[
t=q/p\in(0,1),\quad m=\min(J,u),\quad g=|J-u|\ge1.
\tag{5}
\]

The strip gives g<=l-1. No inactive mode is divided by.

## Complete channels and retained credits

Use the full active pair expansion from [the spectral density proof](non-mixing-spectral-density.md). Define

\[
a=Ex^3,\quad b=Ex^2y,\quad c=Exy^2,\quad d=Ey^3,
\qquad \eta=b^2-ac,\quad\zeta=c^2-bd,
\]

and X_v=p^v a+q^v c, Y_v=p^v b+q^v d. Set phi_0=1, phi_1=x, phi_2=y, theta_0=1, theta_1=p, theta_2=q, and m_ijv=E phi_i phi_j phi_v. All indices in the following complete active contraction range over {0,1,2}:

\[
F=\sum_{i,j,s,t}\theta_i^k\theta_j^u\theta_s^r\theta_t^lH_{ij,st},
\quad
H_{ij,st}=\Big(\sum_v\theta_v^Jm_{ijv}m_{stv}\Big)
\Big(\sum_v\theta_v^um_{isv}m_{jtv}\Big),
\tag{6}
\]

all entries outside the two signed channels are nonnegative. The channels are b^2 X_J X_u and c^2 Y_J Y_u, each occurring four times. Their exact weights are

\[
\begin{aligned}
V_X&=p^N(t^l+t^r+t^u+t^k),\\
V_Y&=p^N(t^{k+u+l}+t^{k+u+r}+t^{u+r+l}+t^{k+r+l}).
\end{aligned}
\tag{7}
\]

The constant entry contributes 1. Two distinct constant-index entries retain the triangles p^{u+r+l} and p^{k+2u}. They are not among the signed channels. The proof pays the entire signed loss while keeping these credits.

The actual kernel supplies the signed wedge inequality

\[
1-p\eta-q\zeta
=\frac12 E K_1(X_0,Y_0)
[x(X_0)y(Y_0)-y(X_0)x(Y_0)]^2\ge0.
\tag{8}
\]

This does not assume multiplication closure of the active eigenfunctions; positive powers kill their inactive product components. Individual eta,zeta need not be nonnegative.

## The joint-wedge branch throughout the strip

First suppose eta,zeta>=0. The general unequal-filter square is

\[
X_JX_u=(p^{(J+u)/2}a+q^{(J+u)/2}c)^2+Lac,
\quad L=(p^{J/2}q^{u/2}-p^{u/2}q^{J/2})^2\le p^{J+u}.
\tag{9}
\]

If ac<0, b^2|ac|<=eta^2/4; if ac>=0, the channel is nonnegative. The analogous bound uses zeta for Y. Thus their combined loss is at most

\[
\frac L4(V_X\eta^2+V_Y\zeta^2)
\le\frac L4\max(V_X/p^2,V_Y/q^2).
\tag{10}
\]

The last step uses (8) and (p eta)^2+(q zeta)^2<=(p eta+q zeta)^2<=1. Since every outer exponent is at least two, (7) gives

\[
\max(V_X/p^2,V_Y/q^2)\le4p^{N-2}.
\tag{11}
\]

For V_Y/q^2 its four t-exponents are N-r-2, N-l-2, N-k-2 and N-u-2, all nonnegative. Consequently loss is at most

\[
p^{N+J+u-2}\le p^{k+2u},
\tag{12}
\]

because the exponent difference is r+l+J-2>=0. This branch is paid throughout (2), without (3).

## Negative Y with a positive companion

Suppose Y_JY_u<0 and ac>=0. A negative Y contribution requires b,c nonzero. Write a=tau c, d=-zb, with tau>=0 and

\[
t^{-m}<z<t^{-m-g}.
\tag{13}
\]

The sharp crossing quadratic gives

\[
-Y_JY_u\le p^{J+u}b^2\frac{(1-t^g)^2}{4t^g},
\qquad
X_JX_u\ge p^{J+u}c^2\mathrm{tau}^2.
\tag{14}
\]

The first inequality is the maximum of the concave quadratic in z. From (7), the exact weighted-average identity

\[
\frac{V_Y}{V_X}
=\frac{t^{k+r}(t^l+t^u)+t^{u+l}(t^k+t^r)}
{(t^l+t^u)+(t^k+t^r)}
\]

and k+r>=u+l imply

\[
t^{k+r}\le V_Y/V_X\le t^{u+l}.
\tag{15}
\]

Set

\[
\mathrm{tau}_0=\frac12t^{(u+l-g)/2}(1-t^g)\le t/2.
\tag{16}
\]

The inequality follows from g<=l-1 and u>=2. If tau>=tau_0, equations (14)--(16) show that the positive X channel pays the entire Y loss.

If 0<=tau<tau_0, the original signed wedge (8) reads

\[
p(t-\mathrm{tau})c^2+p(1+tz)b^2\le1.
\tag{17}
\]

Both summands are nonnegative. Their product is at most 1/4. Since t-tau>=t/2 and 1+tz>t^{1-m},

\[
b^2c^2\le\frac{1}{4p^2(t-\mathrm{tau})(1+tz)}
\le\frac{t^{m-2}}{2p^2}.
\tag{18}
\]

Put beta=u+l+min(k,r). Equation (7) gives V_Y<=4p^N t^beta, so the whole negative Y contribution is at most

\[
\frac12p^{N+J+u-2}t^{\beta+m-g-2}(1-t^g)^2
\le\frac12p^{N+J+u-2}.
\tag{19}
\]

The t-exponent is positive: if J>=u it is at least 2u+min(k,r)-1, using g<=l-1; if J<u it is at least beta+r-l+1, using u<=r+l-1 and h>=1. This branch is therefore paid by the retained triangle throughout (2), again without (3).

## Negative X and the exponent domain

Suppose X_JX_u<0 and bd>=0. Write a=-zc and d=tau b, tau>=0; a negative contribution requires b,c nonzero and

\[
t^{m+g}<z<t^m.
\]

The sharp crossing bound and positive companion give

\[
-X_JX_u\le p^{J+u}c^2\frac{t^{2m}(1-t^g)^2}{4},
\qquad Y_JY_u\ge p^{J+u}b^2.
\tag{20}
\]

Writing n=min(u,l), equation (7) implies

\[
V_X\le4p^Nt^n,\quad V_Y\ge p^Nt^\beta,
\quad V_Y/V_X\ge\frac14t^{\max(u,l)+\min(k,r)}.
\tag{21}
\]

Thus the negative X loss divided by its positive Y companion is at most

\[
t^{2m-\max(u,l)-\min(k,r)}(1-t^g)^2\le1
\tag{22}
\]

under the exponent condition (3). The companion pays the entire loss.

These cases are exhaustive. If both filter products are nonnegative, there is nothing to pay. If ac,bd<0, then eta,zeta>0 and the joint branch applies. If eta<0 then ac>0; if zeta<0 then bd>0. If both wedge coordinates are negative both filter products are nonnegative. Moment zeros either remove a channel or fall into the nonnegative/companion cases. Consequently the maximum possible loss in (2)--(3) is the bound (12), proving (4). This is actual collective payment, not an assumed sign of a generic PSD cross form.

## Ordered actual-root corollary

Condition (3) holds whenever

\[
r\le u\le r+2h.
\tag{23}
\]

Indeed k>=u>=r>=l then gives max(u,l)+min(k,r)=u+r. If u<=J, condition (3) reduces to u>=r; if u>=J, it reduces to u<=r+2h.

For h>=l-1, every remaining integer tuple (2) satisfies (23): u>=J-l+1>=r, and u<=r+l-1<=r+2h. Outside (2), the previously proved [all-host regions](markov-jensen-compensation.md) apply. Those regions use integer powers of an actual nonnegative symmetric root T. Keeping that hypothesis, this proves

\[
A=T^2,\quad\operatorname{rank}(A-\Pi)\le2,\quad h\ge l-1
\quad\Longrightarrow\quad F\ge1
\tag{24}
\]

for every original ordered tuple. Rank zero and rank one are already covered by the flat-spectrum proof. The case l=1 on arbitrary actual-root hosts is covered by Markov Jensen. The [midpoint note](rank-two-midpoint-density.md) gives its sharper explicit loss estimate when l=2,h=2; it is not rerun or weakened by this extension.

## Remaining leaf of this two-mode payment route

Without (3), the joint-wedge and negative-Y branches above remain paid. The remaining X-negative case can also be paid if tau=d/b<=1/(2t): the signed wedge is p(1-t tau)b^2+p(t+z)c^2<=1, giving b^2c^2<=1/(2p^2t). Equations (7) and (20) then bound its loss by p^{N+J+u-2}/2, since min(u,l)+2m-1>=0.

After also removing the previously paid matching-opposite-pair family k=l, the remaining leaf of this spectral route is an actual X-negative host in (2), outside (3), with k!=l, bd>0, zeta<0 and tau>1/(2t). Other retained mass, cap or mixing guards may still pay particular hosts in that leaf; it is not asserted that every such host is unresolved by every previous method. Any such tuple lies outside r<=u<=r+2h, but that alone does not refute density. Actual Jensen also gives

\[
(p^2-q)b^2\le1-p^2+p(1-p)z^2c^2.
\tag{25}
\]

It follows from E x^2[A(x^2)-p^2x^2]>=0 and Ex^4>=1+a^2+b^2. This is a genuine additional constraint, not a completed payment by the retained diagonal budget. In particular q>=p^2 makes its coefficient nonpositive. No universal use of (25) to close the leaf has been established.

The arbitrary-rank theorem, a universal payment of this remaining two-mode leaf, a literature-wide novelty comparison and Lean formalization remain open. No computation, new service request, manuscript theorem insertion or clock restart is evidence for this analytical note.
