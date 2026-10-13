# Collective payment for the two mode midpoint

The two-mode midpoint density is paid by a joint wedge budget and the positive companion channels. Every sign case is included, without a mixing bound, a lower mass bound, or closure of products of eigenfunctions. This closes the last two-mode exponent case when l=2; the unrestricted arbitrary-spectrum theorem remains open.

## Statement and original law

Let X be finite and nonempty with a strictly positive probability law mu. Let A be a self-adjoint, positive-semidefinite, entrywise nonnegative Markov operator on L2(mu), and write K_v for the relative kernel of A^v. This includes A=T^2 for an actual symmetric nonnegative Markov root T. All expectations and compositions use the original mu.

Suppose A has exactly two active nonconstant modes x,y, with orthonormal eigenfunctions and eigenvalues 1>=p>=q>0. An active mode has a positive eigenvalue; additional unit modes count as active, and inactive zero modes are allowed. Set

\[
a=Ex^3,\quad b=Ex^2y,\quad c=Exy^2,\quad d=Ey^3,
\qquad \eta=b^2-ac,\quad \zeta=c^2-bd.
\tag{1}
\]

For integers u>=3 and k>=u, define the retained midpoint density

\[
F=E_{\mu^4}K_k(A_0,B_0)K_{u+1}(A_0,C_0)K_u(A_0,D_0)
K_{u-1}(B_0,C_0)K_u(B_0,D_0)K_2(C_0,D_0).
\tag{2}
\]

The vertex names in (2) are not spectral labels. This is the original ordered tuple r=u-1, l=2, h=2, k>=u. The first payment branch is

\[
\eta\ge0,\qquad\zeta\ge0,
\tag{3}
\]

The theorem does not assume (3): the complementary branches are paid below as well. For every host in the stated two-mode scope,

\[
F\ge1+p^{2u+1}+p^{k+2u}-p^{k+4u}>1.
\tag{4}
\]

Rank zero and rank one are already covered by the flat-spectrum theorem; rank zero gives equality. If p=q, both filters in (7) are squares and every entry is nonnegative. The two retained triangles then prove (4) directly, so the complementary-branch argument may assume p>q. Negative eigenvalues of a root T, kernel zeros, extra stationary modes, and arbitrary positive masses require no change to the argument. This is an analytical theorem in the stated spectral rank, not a proof-assistant validation or a claim of novelty.

## The actual wedge budget

The complete expansion of K_1 has only the constant mode and the two active modes. Thus

\[
\begin{aligned}
1-p\eta-q\zeta
&=1+pac+qbd-pb^2-qc^2\\
&=\frac12E_{X_0,Y_0}K_1(X_0,Y_0)
\big[x(X_0)y(Y_0)-y(X_0)x(Y_0)\big]^2\ge0.
\end{aligned}
\tag{5}
\]

Indeed the two square terms each have expectation 1+pac+qbd, and the cross term has expectation pb^2+qc^2. Nonnegativity in (5) uses the actual kernel K_1, not a generic PSD bilinear sign. Under (3), it gives a joint nonnegative budget

\[
p\eta+q\zeta\le1.
\tag{6}
\]

There is no three-state associativity assumption. Products such as xy may have components in inactive modes; positive powers of A annihilate those components in (5).

## The only potentially negative channels

Use the exact pair matrix from the preceding spectral density proof. Its full contraction is

\[
F=\sum_{i,j,s,t}\theta_i^k\theta_j^u
\theta_s^{u-1}\theta_t^2 H_{ij,st},
\quad\theta_0=1,\ \theta_1=p,\ \theta_2=q,
\tag{7}
\]

where

\[
H_{ij,st}=\left(\sum_v\theta_v^{u+1}m_{ijv}m_{stv}\right)
\left(\sum_v\theta_v^u m_{isv}m_{jtv}\right),
\qquad m_{ijv}=E\phi_i\phi_j\phi_v.
\tag{8}
\]

All entries with a constant index are nonnegative. In the centered block, define

\[
X_v=p^va+q^vc,\qquad Y_v=p^vb+q^vd.
\]

The only entries that may be negative are the two pairs of channels b^2 X_{u+1}X_u and c^2 Y_{u+1}Y_u. The other centered entries are products of nonnegative quantities. In particular their factor

\[
D_v=1+p^vac+q^vbd
=E K_v(X_0,Y_0)x(X_0)^2y(Y_0)^2\ge0
\]

uses actual kernel nonnegativity. This preserves the whole positive part of the contraction; no signed entry is silently discarded.

Put Delta=(sqrt(p)-sqrt(q))^2. The exact square identity

\[
X_{u+1}X_u
=(p^{u+1/2}a+q^{u+1/2}c)^2
 +\Delta(pq)^u ac
\tag{9}
\]

has no extra prefactor on the square. If ac>=0, its left side is nonnegative. If ac<0, then eta=b^2+|ac| and b^2|ac|<=eta^2/4. Therefore, under (3),

\[
b^2X_{u+1}X_u\ge-\frac{\Delta(pq)^u}{4}\eta^2,
\qquad
c^2Y_{u+1}Y_u\ge-\frac{\Delta(pq)^u}{4}\zeta^2.
\tag{10}
\]

The second bound follows identically with b,d replacing a,c. These are bounds for the actual two channels, not assumed signs of individual moments.

## Paying both channels with one triangle

Summing every occurrence of the two channels in (7) gives their exact positive weights

\[
\begin{aligned}
V_X={}&p^{k+2u-1}q^2+p^{k+u+2}q^{u-1}
 +p^{k+u+1}q^u+p^{2u+1}q^k,\\
V_Y={}&p^{u-1}q^{k+u+2}+p^2q^{k+2u-1}
 +p^kq^{2u+1}+p^uq^{k+u+1}.
\end{aligned}
\tag{11}
\]

Since k>=u>=3 and p>=q,

\[
V_X\le4p^{k+2u-1}q^2,\qquad
V_Y\le4p^kq^{2u+1}.
\tag{12}
\]

For example, dividing the four terms of V_X by p^{k+2u-1}q^2 gives 1, (q/p)^{u-3}, (q/p)^{u-2}, and (q/p)^{k-2}. For V_Y, division by p^kq^{2u+1} gives (q/p)^{k-u+1}, (q/p)^{k-2}, 1, and (q/p)^{k-u}. Every exponent is nonnegative.

The joint budget (6), not separate uncontrolled moment norms, now pays the combined loss:

\[
\begin{aligned}
V_X\eta^2+V_Y\zeta^2
&\le\max(V_X/p^2,V_Y/q^2)
\big[(p\eta)^2+(q\zeta)^2\big]\\
&\le\max(V_X/p^2,V_Y/q^2)(p\eta+q\zeta)^2\\
&\le\max(V_X/p^2,V_Y/q^2).
\end{aligned}
\tag{13}
\]

By (10)--(13), the combined negative contribution is at most

\[
\begin{aligned}
\frac{\Delta(pq)^u}{4}\max(V_X/p^2,V_Y/q^2)
&\le\max\{\Delta p^{k+3u-3}q^{u+2},
\Delta p^{k+u}q^{3u-1}\}\\
&\le p^{k+4u}\le p^{2u+1}.
\end{aligned}
\tag{14}
\]

Here Delta<=p and q<=p; also 0<p<=1 and k+4u>=2u+1. Division only used positive active eigenvalues.

The all-constant entry of (7) contributes one. The actual entry H_{00,11}=p^u has outer weight p^{u+1}, hence contributes the B_0 C_0 D_0 triangle p^{2u+1}. Its distinct transpose H_{11,00}=p^u has outer weight p^{k+u}, giving another retained triangle p^{k+2u}. All remaining entries are nonnegative apart from the two jointly bounded channels. This proves (4), with strictness because p^{k+2u}>0.

## Paying the complementary branches

If b=0, the X channel vanishes and the Y filter product is a nonnegative square times q^{2u+1}. If c=0, the Y channel vanishes and the X filter product is a nonnegative square times p^{2u+1}. Thus both cases are paid. If both filter products are nonnegative, (7) pays the density directly. If ac<0 and bd<0, then eta,zeta>0, so the joint payment already proved applies. Zero products also fall within that payment or have no negative channel. It remains to pay the cases with opposite signs of ac and bd.

Assume p>q, and put

\[
t=q/p\in(0,1),\qquad C_*=p^{k+2u+1}.
\]

The exact weights (11)--(12) give both upper and lower bounds

\[
C_*t^2\le V_X\le4C_*t^2,\qquad
C_*t^{2u+1}\le V_Y\le4C_*t^{2u+1}.
\tag{15}
\]

The lower bounds simply retain one actual term of each weight.

### Negative X and positive Y

Suppose ac<0 and bd>=0. The only possible negative channel is X. If it is negative, write a=-zc; then

\[
t^{u+1}<z<t^u,
\qquad
-X_{u+1}X_u
=p^{2u+1}c^2(t^u-z)(z-t^{u+1})
\le\frac{p^{2u+1}c^2t^{2u}(1-t)^2}{4}.
\tag{16}
\]

Since bd>=0, the other filter has

\[
Y_{u+1}Y_u\ge p^{2u+1}b^2.
\tag{17}
\]

The negative X channel vanishes if b=0 or c=0. Otherwise its loss divided by the retained positive Y contribution is bounded, using (15)--(17), by

\[
\frac{V_X}{V_Y}\frac{t^{2u}(1-t)^2}{4}
\le t(1-t)^2<1.
\tag{18}
\]

Thus the positive companion channel pays the whole loss. This argument does not require a nonnegative wedge coordinate or three-state associativity.

### Negative Y and positive X

Suppose ac>0 and bd<0. The only possible negative channel is Y. If it is negative, b and c are nonzero. Write a=tau c and d=-zb, where tau>0. The filter crossing gives

\[
t^{-u}<z<t^{-u-1},
\qquad
-Y_{u+1}Y_u
=p^{2u+1}b^2(1-t^uz)(t^{u+1}z-1)
\le\frac{p^{2u+1}b^2(1-t)^2}{4t}.
\tag{19}
\]

The expression before the last inequality is positive because both displayed factors are negative. The last inequality is the maximum of that concave quadratic in z. The companion filter satisfies

\[
X_{u+1}X_u
=p^{2u+1}c^2(\mathrm{tau}+t^u)(\mathrm{tau}+t^{u+1})
\ge p^{2u+1}c^2\mathrm{tau}^2.
\tag{20}
\]

Put tau_0=t^{u-1}(1-t). Since u>=3,

\[
\mathrm{tau}_0/t=t^{u-2}(1-t)\le t(1-t)\le1/4.
\tag{21}
\]

If tau>=tau_0, the negative Y loss divided by the positive X contribution is at most

\[
\frac{V_Y}{V_X}\frac{(1-t)^2}{4t\,\mathrm{tau}^2}
\le\frac{t^{2u-2}(1-t)^2}{\mathrm{tau}^2}\le1.
\tag{22}
\]

Again the companion channel pays the whole loss.

If 0<tau<tau_0, use the actual wedge inequality (5) in its original signed form. Here eta=b^2-tau c^2 and zeta=c^2+zb^2, so it becomes

\[
p(t-\mathrm{tau})c^2+p(1+tz)b^2\le1.
\tag{23}
\]

Both coefficients are positive. The product of these two nonnegative summands is at most 1/4. By (19) and (21), t-tau>=3t/4 and 1+tz>t^{1-u}; consequently

\[
b^2c^2\le\frac{1}{4p^2(t-\mathrm{tau})(1+tz)}
\le\frac{t^{u-2}}{3p^2}.
\tag{24}
\]

Using (15), (19), and (24), the entire negative Y contribution is at most

\[
\begin{aligned}
V_Yc^2(-Y_{u+1}Y_u)
&\le p^{k+4u+2}t^{2u}(1-t)^2b^2c^2\\
&\le\frac{p^{k+4u}}3t^{3u-2}(1-t)^2
\le\frac{p^{k+4u}}3.
\end{aligned}
\tag{25}
\]

The retained triangle p^{2u+1} pays this. No unconditional sign of an unequal PSD cross form has been used.

The joint-wedge branch loses at most p^{k+4u}; the two companion-channel branches lose nothing; and the small-tau branch loses at most p^{k+4u}/3. The distinct triangle p^{k+2u} remains unused in every case. Thus the unconditional lower bound (4) follows. Moment zeros, filter zeros, p=q, and positive unit modes have already been included; no inactive eigenvalue was divided by.

## Consequence and remaining theorem

For the original actual-root setting A=T^2, combining this midpoint result with the retained all-host regions u+l<=r+h or u>=r+l and the two-mode matching-opposite-pair theorem pays every ordered tuple with l=2 and at most two active nonconstant modes. The all-host region proof uses integer powers of the actual nonnegative root T; that root hypothesis is retained in this corollary. For h>=3 there is no residual integer strip. For h=1 its two residual possibilities are u=r and u=r+1, paid by matching r,u or r+h,u respectively. For h=2 its only residual possibility is u=r+1, exactly (2). The case l=1 was already covered on arbitrary actual-root hosts.

This is a collective compensation proof in a low spectral rank, not a proof for arbitrary active rank or all l>=3. The original unrestricted density theorem, its potential novelty and its formalization remain separate obligations.

