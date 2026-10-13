# Unequal smoothing can cancel asymptotically all pair surplus

## Verdict and exact scope

This note proves an obstruction to one proposed proof mechanism. It does
**not** refute either the unequal-star lower bound `J >= rank Q` or the
unrestricted common-power K4 density inequality.

There are explicit rational, strictly positive, actual nonnegative Markov
roots and original-law orthogonal projections for which the three-time
centered cubic term cancels asymptotically all of the sum of the three
positive pair correlations. The averaged star itself remains above its
constant baseline. This holds even with entrywise nonnegative projections
and pointwise commuting compressed multiplication fields.

Every kernel and composition below uses the displayed original measure.
The exact verifier is `continuation5_unequal_cancellation_verify.py`.

## 1. Quantities whose cancellation is being tested

Let `S` be an actual nonnegative self-adjoint Markov root on a finite
positive probability `(I,pi)`, let `B=S^2`, and let `Q=Q*=Q^2` have rank
`d`. On `E=ran Q`, put

`R_t=Q D_(1_(.=t)/pi_t) Q`,  `M_s(t)=(B^s R)_t`,  `X_s(t)=M_s(t)-I_E`.

Then `E_pi R=E_pi M_s=I_E`. Define

`P_st=E_pi tr(X_s X_t)`,

`P=P_xy+P_xz+P_yz`,

`C=E_pi tr(X_x X_y X_z)`,

`J=E_pi tr(M_x M_y M_z)`.

The original-law common-power spectral theorem gives

`P_st=sum_(i>0) lambda_i^(s+t) ||Q D_phi_i Q||_HS^2 >=0`.

Expansion, using the zero mean of every `X_s`, gives the exact identity

`J=d+P+C`.                                                   (1)

The mechanism ruled out is a universal estimate

`J >= d+c P`, equivalently `C >= -(1-c)P`,                     (2)

with any fixed `c>0`, even for the one fixed genuinely unequal triple
`(x,y,z)=(1,2,8)`. This is substantially stronger than `J>=d`.

## 2. A rational four-state family

Fix a rational parameter `0<t<=1/2`, and set

`e=t^22`, `a=t^(-9)`, `D=1+t^4-t^22`, `delta=t^4/D`.

Take the original probability

`pi=(e/2,e/2,(1-e)/2,(1-e)/2)`.

The states are ordered as `(rare,+),(rare,-),(bulk,+),(bulk,-)`.
On the rare/bulk space, with original conditional law `nu=(e,1-e)`, put

`C0=(1-t^2)Pi_nu+t^2 Id_nu`.

Let `S0=C0 tensor Flip`, where `Flip(sign,sign')=2 1_(sign'=-sign)` is
relative to the uniform sign law. In the displayed four-state order,

\[
S_0=2\begin{pmatrix}
0&1-t^2+t^2/e&0&1-t^2\\
1-t^2+t^2/e&0&1-t^2&0\\
0&1-t^2&0&1-t^2+t^2/(1-e)\\
1-t^2&0&1-t^2+t^2/(1-e)&0
\end{pmatrix}.                                                \tag{3}
\]

The original `pi`-weighted rows are one. The root is nonnegative,
symmetric and connected bipartite. Its square preserves the two sign
classes. The full spectrum of `S0` is `1,-1,t^2,-t^2`, so that of `B0=S0^2`
is `1,1,t^4,t^4`. The additional stationary eigenvalue is retained.

Let `V` have rows `(a,0),(0,a),(0,1),(1,0)`. Its original weighted Gram
matrix is exactly `(D/2)Id_2`. Therefore the relative kernel

\[
Q=\frac2D VV^\top
=\frac2D\begin{pmatrix}
a^2&0&0&a\\
0&a^2&a&0\\
0&a&1&0\\
a&0&0&1
\end{pmatrix}                                                 \tag{4}
\]

is a rank-two original-law orthogonal projection. It is rational and
entrywise nonnegative. The normalized columns of `sqrt(2/D)V` are an
orthonormal basis of its range. In this basis every `R_t`, and hence every
`M_s(t)`, is diagonal. Thus the example does not depend on noncommuting
matrix traces or on a negative projection-triangle product.

## 3. Exact scalar formulas

For three numbers `r_x,r_y,r_z` in `[0,1]`, write

`E2=r_x r_y+r_x r_z+r_y r_z`,  `E3=r_x r_y r_z`,

and define

\[
H_p= p\prod_{s\in\{x,y,z\}}
       \left(1+\frac{1-p}{p}r_s\right)
 +(1-p)\prod_{s\in\{x,y,z\}}(1-r_s).
\]

Direct expansion gives

\[
H_p=1+\frac{1-p}{p}E_2
       +\frac{(1-p)(1-2p)}{p^2}E_3.                            \tag{5}
\]

For the family (3)--(4), `r_s=t^(4s)`. Conditioning within each ORIGINAL
sign component, whose mass is `1/2`, and summing both diagonal matrix
coordinates gives

\[
J=8\{\delta^3 H_e+(1-\delta)^3H_{1-e}\}.                       \tag{6}
\]

For each pair of exponents,

\[
P_{st}=2(2\delta-1)^2
 +4\left[\delta^2\frac{1-e}{e}
        +(1-\delta)^2\frac e{1-e}\right]r_s r_t.               \tag{7}
\]

The factors in (6)--(7) arise from the original sign masses and from the
normalization of (4); no conditional measure replaces `pi` in `J` or `P`.

At `(x,y,z)=(1,2,8)`,

`E2=t^12+t^36+t^40`,  `E3=t^44`.

Substitution into (6)--(7) gives the following rational functions with no
remaining matrix quantities:

\[
\begin{aligned}
J=\frac8{D^3}\big[& (1-e)^3+t^{12}
 +(1-e)(t^2+t^{26}+t^{30})\\
&+e(1-e)^2(t^{12}+t^{36}+t^{40})
 +t^{12}(1-e)(1-2e)
 +e(1-e)(2e-1)t^{44}\big],                                    \tag{8}
\end{aligned}
\]

\[
P=\frac1{D^2}\big[
6(t^4-1+t^{22})^2
+4(1-e)(t^{-2}+t^{22}+t^{26})
+4e(1-e)(t^{12}+t^{36}+t^{40})\big].                           \tag{9}
\]

Consequently,

\[
\boxed{\lim_{t\downarrow0}J=8,\quad
       \lim_{t\downarrow0}t^2P=4,\quad
       \lim_{t\downarrow0}\frac{J-2}{t^2P}=\frac32.}           \tag{10}
\]

Together with (1), this proves

\[
\boxed{\frac C P\longrightarrow-1,\qquad J-2\longrightarrow6.}\tag{11}
\]

Thus every fixed `c>0` in (2) fails for sufficiently small positive
rational `t`. The conclusion is obtained from the exact rational formulas,
not from numerical matching.

The family does not cross the desired lower bound. Indeed (5) has
`H_p>=1` for every `0<p<1`: if `p<=1/2` both additional coefficients are
nonnegative; if `p>1/2`, use `E2>=3E3` and `(2p-1)/p<1`. Hence

`J>=8[delta^3+(1-delta)^3]>=2`.

## 4. Strict positivity preserves the cancellation limit

Put `zeta=t^8` and

`S=(1-zeta)S0+zeta Pi_pi`.

This is a rational strictly positive actual Markov root under the same
original `pi`. Its minimum entry is `zeta`. Because `S0 Pi=Pi S0=Pi`,
for every `s>=1`,

`S^(2s)=Pi+(1-zeta)^(2s)(S0^(2s)-Pi)`.

It follows directly for the actual compressed fields that

`X_s^+=(1-zeta)^(2s) X_s`.

Therefore

\[
P^+=\sum_{s<t}(1-\zeta)^{2(s+t)}P_{st},\qquad
C^+=(1-\zeta)^{22}C.                                         \tag{12}
\]

The notation `s<t` in this sum selects the three unordered pairs among
`1,2,8`; it does not change the original measure. Since all `P_st>=0`,

`(1-zeta)^20 P <= P^+ <= P`.

For small `t`, (11) implies `|C|=O(P)`. The elementary inequality
`1-(1-zeta)^m<=m zeta` gives

`|J^+-J| <=20 zeta P+22 zeta |C|=O(t^6)`.

The perturbed average also remains at least two for every parameter in
the stated range. Indeed `M_s^+=(1-c_s)I_E+c_s M_s`, where
`c_s=(1-zeta)^(2s)` lies in `[0,1]`. Multilinearity expands `J^+` as a
convex combination of the original `J>=2`, the three pair averages
`2+P_st>=2`, the single-factor means `2`, and the empty value `2`.

Thus (10)--(11) hold for `J^+,P^+,C^+` as well. In particular the failed
fixed-fraction estimate cannot be rescued by requiring strict positivity
or by requiring the square to be connected.

## 5. Actual eight-state binary realization and exact target tuple

Set

`alpha=D t^26/4`, `mu(i,b)=pi_i/2`, `b in {-1,+1}`,

\[
T((i,b),(j,c))=S(i,j)+\alpha Q(i,j)bc,
\qquad p=t^{20}/4,
\qquad W=pT.                                                  \tag{13}
\]

The largest entry of `Q` is `2t^(-18)/D`, so

`alpha max Q=zeta/2`.

Hence `T>=zeta/2>0`. Also

`max S0=2(1-t^2+t^(-20))<=2+2t^(-20)`,

and, for `0<t<=1/2`,

`max T <=2+2t^(-20)+zeta/2 <=4t^(-20)`.

It follows that `0<W<=1`. Original sign averaging cancels the channel in
every row, so every original-`mu` row of `T` is one and every row of `W`
is the stated `p`. This proves full actual-host admissibility, without
using a nonrealizable PSD square root.

Original sign averaging at each intermediate vertex proves the power
transport

`T^(2s)((i,b),(j,c))=S^(2s)(i,j)+alpha^(2s) Q(i,j)bc`.

The complete centered spectrum of `T^2` consists of

| Value | Multiplicity |
|---|---:|
| `(1-zeta)^2` | 1 |
| `(1-zeta)^2 t^4` | 2 |
| `alpha^2` | 2 |
| `0` | 2 |

All four displayed values are distinct for `0<t<=1/2`. This accounts for
all seven centered dimensions, including the zero modes. The root itself
is strictly positive, while its signed channel has rank two.

In the ordered K4 target, choose

`(k,u,r,l,h)=(1,1,2,1,6)`.

The six edge powers in the fixed order `ab,ac,ad,bc,bd,cd` are
`(1,8,1,2,1,1)`. The complementary star at `c` has exponents `(8,2,1)`.
This tuple belongs to none of the three reflection families in the frozen
boundary note.

This host is deliberately not claimed as new density coverage. The coarse
square is a convex combination of `Id`, `Pi`, and the nonnegative Markov
projection onto the two sign classes, and `Q` is entrywise nonnegative.
Thus the previously proved coarse-cone result and the nonnegative channel
cycle expansion already give `F(T)>=F(S)>=1` for all six positive powers.
The family refutes only a uniform fractional retention of the pair budget
inside an individual unequal-star contraction.
