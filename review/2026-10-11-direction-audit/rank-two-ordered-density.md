# Ordered density with two active nonconstant modes

The ordered common-power density inequality holds on every original-law host with at most two active nonconstant modes. The proof pays the full signed channel rather than requiring each spectral entry to be nonnegative. Arbitrary active rank remains open.

## Theorem

Let X be a finite nonempty set with a strictly positive probability law mu. Let T be a nonnegative symmetric relative Markov kernel: symmetry is with respect to the original mu, and T1=1. Put A=T^2, let Pi be projection onto constants, and let K_j be the relative kernel of A^j. Suppose

\[
\operatorname{rank}(A-\Pi)\le2.
\tag{1}
\]

For all integers k>=u>=1, r>=l>=1 and h>=1, set J=r+h. Then

\[
F=E_{\mu^4}K_k(a_0,b_0)K_J(a_0,c_0)K_u(a_0,d_0)
K_r(b_0,c_0)K_u(b_0,d_0)K_l(c_0,d_0)\ge1.
\tag{2}
\]

All nonconstant unit modes count toward (1). Zero modes, reducible hosts, periodic roots and negative eigenvalues of T are allowed. This is not an arbitrary-rank theorem or a statement for arbitrary unordered six labels.

More precisely, suppose A is any self-adjoint PSD entrywise nonnegative Markov operator with exactly two active nonconstant modes of eigenvalues 1>=p>=q>0. Inside the strip

\[
J-l<u<r+l,
\tag{3}
\]

an A-only proof gives F>=1+p^{u+r+l}/2>1. If u<l, it gives the stronger F>=1+p^{u+r+l}. An entrywise nonnegative root is not needed for these strip statements; it is retained in (2) for stitching the previously proved outer regions.

## Retained complete expansion

Rank zero and rank one follow from [flat-spectrum density](non-mixing-spectral-density.md). For rank two, use its complete expansion, with orthonormal modes x,y and moments

\[
a=Ex^3,\quad b=Ex^2y,\quad c=Exy^2,\quad d=Ey^3,
\quad X_j=p^ja+q^jc,\quad Y_j=p^jb+q^jd.
\]

The complete grouped contraction has only two possibly negative channels: b^2 X_JX_u and c^2 Y_JY_u. Each occurs four times. All other grouped entries are nonnegative, including the even adjacent channels, whose complete constant-containing factors are E K_v x^2y^2 and p^vb^2+q^vc^2. No quartic-only summand of those entries is silently assumed nonnegative.

Besides the constant 1, retain the separate BCD and ABD triangles p^{u+r+l} and p^{k+2u}. [The complete two-mode compensation proof](rank-two-general-compensation.md) pays the joint-wedge and negative-Y branches throughout (3), preserving the entire BCD triangle. [The selected-power proof](rank-two-power-selected-compensation.md) pays the remaining negative-X branch whenever u>=l; its common strip bound is 1+p^{u+r+l}/2. The only branch left to prove is therefore u<l with X_JX_u<0 and bd>=0.

If p=q or J=u, the possibly signed channels are squares and need no payment. Otherwise put t=q/p in (0,1). In the remaining u<l case, J>u. Define

\[
N=k+u+r+l,\quad g=J-u>0,\quad \alpha=l-u>0,\quad\beta=r-u\ge\alpha.
\tag{4}
\]

The strip forces u,l>=2, g<=l-1 and J<=u+l-1.

## A ratio uniform in k

The exact complete channel weights are

\[
V_X=p^N(t^l+t^r+t^u+t^k),\qquad
V_Y=p^N(t^{k+u+l}+t^{k+u+r}+t^{u+r+l}+t^{k+r+l}).
\tag{5}
\]

Write xi=t^k, A_0=t^u+t^l+t^r, B_0=t^{u+l}+t^{u+r}+t^{r+l}, and C_0=t^{u+r+l}. Since B_0 A_0>=C_0,

\[
\frac{V_Y}{V_X}=\frac{B_0\xi+C_0}{A_0+\xi}
\ge\frac{C_0}{A_0}
=\frac{t^{l+r}}{1+t^\alpha+t^\beta}.
\tag{6}
\]

This retains the actual finite k and supplies a lower bound uniform in k; it does not replace the density by its k-infinity limit.

## Selecting an actual power

A negative contribution requires b,c nonzero. Write a=-zc and d=tau b, with tau>=0 and

\[
t^J<z<t^u,\qquad f(z)=(t^u-z)(z-t^J)>0.
\]

The negative X loss and positive Y companion, including all four occurrences, are

\[
L_X=V_Xp^{J+u}b^2c^2 f(z),\qquad
P_Y=V_Yp^{J+u}b^2c^2(1+\tau t^J)(1+\tau t^u).
\tag{7}
\]

If L_X<=P_Y, the companion pays directly. Otherwise (6), the sharp bound f(z)<=t^{2u}(1-t^g)^2/4, and (1+tau t^J)(1+tau t^u)>=tau^2 t^{J+u} give

\[
\tau^2<\frac{(1+t^\alpha+t^\beta)(1-t^g)^2}{4t^{l+r+g}}.
\tag{8}
\]

Choose the positive integer

\[
v=\left\lceil\frac{3r+2h-u}{2}\right\rceil,
\qquad e=2v-l-r-g\ge r-l+h=g-\alpha>0.
\tag{9}
\]

Since beta>=alpha,

\[
t^e(1+t^\alpha+t^\beta)\le1+2t^g.
\]

For w=t^g in (0,1), equations (8)--(9) yield

\[
\tau^2t^{2v}<\tfrac14(1+2w)(1-w)^2
=\tfrac14(1-3w^2+2w^3)\le\tfrac14.
\tag{10}
\]

Thus tau t^v<1/2. The actual nonnegative integer-power kernel supplies

\[
1-p^v(b^2-ac)-q^v(c^2-bd)
=\tfrac12 E K_v(s_0,t_0)[x(s_0)y(t_0)-y(s_0)x(t_0)]^2\ge0,
\]

or

\[
p^v(1-\tau t^v)b^2+p^v(t^v+z)c^2\le1.
\tag{11}
\]

The two coefficients are positive. Multiplying the two nonnegative summands and using their sum at most 1 gives

\[
b^2c^2\le\frac1{4p^{2v}(1-\tau t^v)(t^v+z)}
<\frac1{2p^{2v}z}.
\tag{12}
\]

Keeping z, rather than replacing it by its small endpoint, is the decisive improvement.

## Paying the crossing collectively

The exact crossing quotient satisfies

\[
\frac{f(z)}z=t^u+t^J-z-\frac{t^{u+J}}z
\le(\sqrt{t^u}-\sqrt{t^J})^2
=t^u(1-t^{g/2})^2.
\tag{13}
\]

This is ordinary scalar AM-GM, not a fractional Markov power. Also k>=u gives V_X<=p^N t^u(2+t^alpha+t^beta). Put E=N+J+u-2v and s=t^{g/2}. Equations (7), (12)--(13) imply

\[
L_X<\tfrac12p^E t^{2u}(2+t^\alpha+t^\beta)(1-s)^2.
\tag{14}
\]

The rounding in (9) and the integer strip give

\[
E-(k+2u)=r+l+J-2v\ge u+l-J-1\ge0.
\tag{15}
\]

Since beta>=alpha and 2u+alpha=u+l>=g,

\[
\tfrac12t^{2u}(2+t^\alpha+t^\beta)
\le t^{2u}+t^{2u+\alpha}\le1+s^2.
\]

Finally

\[
(1+s^2)(1-s)^2\le(1+s)(1-s)^2
=(1-s^2)(1-s)\le1.
\tag{16}
\]

Combining (14)--(16), with 0<p<=1, proves L_X<p^{k+2u}. The distinct ABD triangle pays the entire negative channel. The BCD triangle remains intact, proving F>=1+p^{u+r+l} in this last u<l branch. The other sign branches already retain that triangle. The u>=l strip is covered by the linked selected-power proof, so the entire rank-two strip is paid.

Outside the strip, either u+l<=J or u>=r+l. The [previous actual-root Markov-Jensen regions](markov-jensen-compensation.md) prove F>=1 there. Combining these regions, the complete strip payment and the flat rank-zero/rank-one cases proves (2) for every original ordered tuple under (1).

## Remaining research question

The full ordered inequality for at most two active modes is now established analytically. Arbitrary active rank has additional coupled channels, so summing these two-mode payments is not licensed. Its collective compensation, Lean formalization and a literature-wide novelty comparison remain separate obligations. The proof changes neither the original law nor the target edge placement, and uses no unproved processed-overlap estimate.
