# Power-selected collective payment for two active modes

A nonnegative kernel at a selected integer power pays the remaining negative-X channel on a larger domain. This is an analytical extension of [the two-mode compensation proof](rank-two-general-compensation.md), not a proof of the arbitrary-rank or unrestricted ordered density theorem.

## Statement and inherited definitions

Use the original finite positive probability law, self-adjoint PSD entrywise nonnegative Markov operator A, and exactly two active nonconstant orthonormal modes x,y of eigenvalues 1>=p>=q>0. Inactive zero modes and extra unit modes are retained as in the linked proof. Use its actual six-edge expression F, original ordered integers k>=u>=1,r>=l>=1,h>=1, and definitions

\[
J=r+h,\quad N=k+u+r+l,\quad a=Ex^3,\ b=Ex^2y,\ c=Exy^2,\ d=Ey^3,
\quad X_j=p^j a+q^j c,\quad Y_j=p^j b+q^j d.
\]

Suppose

\[
J-l<u<r+l,\qquad r\le2u-1.
\tag{1}
\]

Then

\[
F\ge1+\tfrac12p^{u+r+l}>1.
\tag{2}
\]

The proof inside this strip is A-only. Keeping an actual nonnegative symmetric Markov root A=T^2, the previously proved outer regions and the rank-zero/rank-one cases imply F>=1 for every original ordered tuple with rank(A-Pi)<=2 and r<2u. The earlier h>=l-1 corollary remains valid. Neither root positivity nor the rank restriction is dropped when stitching these statements.

## Proof of the new channel payment

The strip gives l,u>=2. If p=q or J=u, the complete contraction has no negative channel. Otherwise put t=q/p in (0,1), m=min(J,u), g=|J-u|>=1, and n=min(u,l). The complete contraction in the linked proof has only the two possibly signed channels b^2 X_J X_u and c^2 Y_J Y_u, with weights

\[
V_X=p^N(t^l+t^r+t^u+t^k),\qquad
V_Y=p^N(t^{k+u+l}+t^{k+u+r}+t^{u+r+l}+t^{k+r+l}).
\tag{3}
\]

All other entries are nonnegative. The constant term 1 and the two distinct triangles p^{u+r+l},p^{k+2u} are outside these channels. The joint-wedge branch and the negative-Y branch are already paid throughout the strip. It remains to treat X_J X_u<0 and bd>=0. A negative contribution has b,c nonzero; write

\[
a=-zc,\quad d=\tau b,\quad\tau\ge0,\quad t^{m+g}<z<t^m.
\tag{4}
\]

Let f(z) be the positive crossing product of z with the two endpoints t^m,t^{m+g}. Then

\[
-X_JX_u=p^{J+u}c^2 f(z),\quad
0<f(z)\le\tfrac14t^{2m}(1-t^g)^2,
\quad Y_JY_u=p^{J+u}b^2(1+\tau t^J)(1+\tau t^u).
\tag{5}
\]

If the weighted positive Y channel pays the X channel, there is nothing more to bound. Otherwise cancellation of the common positive p^{J+u}b^2c^2 gives

\[
f(z)>\frac{V_Y}{V_X}(1+\tau t^J)(1+\tau t^u).
\tag{6}
\]

The exact weight-ratio identity in the linked proof gives V_Y/V_X>=t^{k+r}. Since J+u=2m+g, equations (5)--(6) imply

\[
\tau<\tfrac12(1-t^g)t^{-(k+r+g)/2}.
\tag{7}
\]

Select the positive integer

\[
v=\left\lceil\frac{k+r+g}{2}\right\rceil.
\tag{8}
\]

Then tau t^v<1/2. Entrywise nonnegativity of the actual kernel K_v supplies a wedge inequality at this very power:

\[
1-p^v(b^2-ac)-q^v(c^2-bd)
=\tfrac12 E K_v(X_0,Y_0)[x(X_0)y(Y_0)-y(X_0)x(Y_0)]^2\ge0.
\]

Using (4), it becomes

\[
p^v(1-\tau t^v)b^2+p^v(t^v+z)c^2\le1.
\tag{9}
\]

Both coefficients are positive. The product of the two summands is at most 1/4. Thus

\[
b^2c^2\le\frac1{4p^{2v}(1-\tau t^v)(t^v+z)}
<\frac1{2p^{2v}t^{m+g}}.
\tag{10}
\]

From V_X<=4p^N t^n and (5), the entire negative X contribution is therefore bounded by

\[
\tfrac12p^{N+J+u-2v}t^{n+m-g}(1-t^g)^2
\le\tfrac12p^{J+2u+l-g-1}t^{n+m-g}(1-t^g)^2.
\tag{11}
\]

The last inequality uses 2v<=k+r+g+1 and 0<p<=1; the inequality direction is important. We now compare this bound with half the retained triangle p^{u+r+l}.

If u>=l and J>=u, the p-exponent difference is 2u-r-1>=1, because the integer strip gives r<=u+l-h-1<=2u-2. Its t-exponent is l+2u-J>=u+1, because J<=u+l-1.

If J<u, then u>r>=l. The p-exponent difference is 2J-r-1=r+2h-1>0. The t-exponent is l+2J-u>=r+2h+1>0, using u<=r+l-1.

If u<l, necessarily J>u. Here n=m=u. Assumption (1) gives the p-exponent difference 2u-r-1>=0. Moreover J<=u+l-1 and l<=r<=2u-1 imply the t-exponent 3u-J>=2.

These cases exhaust (1), so (11) is at most p^{u+r+l}/2. The new negative-X branch keeps at least half this triangle and all of p^{k+2u}. The earlier joint-wedge branch loses at most p^{k+2u} and keeps all of p^{u+r+l}; the negative-Y branch loses at most half p^{k+2u}. Nonnegative channels need no payment. The moment-sign exhaustion and zero cases are exactly those audited in the linked complete contraction. The common bound (2) follows.

## Exact boundary retained

After this new domain, the older exponent guard and small-tau guard, matching opposite pairs and all-host outer regions, any remaining X-negative tuple of this two-mode route must satisfy

\[
r\ge2u,\quad J-l<u<r+l,\quad l\ge u+h+1,\quad1\le h\le u-1.
\]

It must also fail the older guards; those inequalities alone do not assert that every host there is unresolved by every existing mass, cap or mixing certificate. An interpolation in k can transfer an independently proved endpoint when its fast-decaying coefficient is nonpositive, but its other sign branch still needs actual collective surplus. That transfer is not an unrestricted proof.

This proof uses only actual integer powers and original-law moments. It does not assume product closure, a generic PSD cross-form sign, a changed law, an unproved processed-overlap bound, or an equivalent hard lemma as a solution. No finite testing, Lean validation, literature-wide novelty claim, manuscript insertion or clock restart is claimed.
