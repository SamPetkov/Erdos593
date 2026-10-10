# Actual cover expansions require collective compensation

## Verdict and scope

The unrestricted common-power inequality and unrestricted finite-cover
comparison remain open. This note proves two precise obstructions to
coefficientwise proof mechanisms for the cover route:

1. Even along an **actual one-root radial family**, the complete two-cover
   defect can have negative polynomial coefficients.
2. A proper centered subgraph of an actual two-cover can have strictly
   negative density. The example persists in a strictly positive
   five-state actual host with three positive centered square bands and
   an additional zero band.

Neither example violates the complete density or cover inequality. The
first has an explicit nonnegative regrouping for its whole defect. The
second has exact certificates `F>1` and `Z_ab<F^2`. These are obstructions
to termwise arguments, not counterexamples to the requested target.

All measures below are the original displayed probabilities. Every
`K_j=T^(2j)` comes from the one stated actual nonnegative self-adjoint
Markov root. Write `A=T^2`, `C_j=A^j-Pi`, and `Pi(x,y)=1`. Thus the centered
operators `C_j=(A-Pi)^j` are PSD and commute, but their entries need not be
nonnegative.

The companion `continuation5_cover_obstructions_verify.py` uses only the
Python standard library and exact rational arithmetic. It verifies the
finite polynomial identity independently against literal eight-vertex
integration, checks the negative six-vertex integral, and records every
entry of the actual hosts and all complete comparisons stated here.

## 1. The cover and its exact five-edge source

Let `Z_ab` be the two-cover of K4 with the two `ab` edges crossed between
sheets and all other edges kept within their sheets. This is equivalent
to chord gauge `(bc,bd,cd)=(swap,swap,identity)`. Its variables are
`a_0,b_0,c_0,d_0,a_1,b_1,c_1,d_1`, each independently distributed under
`mu` before multiplication by the twelve actual edge factors.

For the fixed target edge order `ab,ac,ad,bc,bd,cd`, put

\[
D(a,b)=\mathbb E_{c,d}
 K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d).
\]

Then the original-measure operator `R=K_k D^*` satisfies

\[
F=\operatorname{tr}R,\qquad Z_{ab}=\operatorname{tr}R^2.       \tag{1}
\]

This follows by integrating the two internal vertices separately in each
sheet and then retaining the crossed `ab` factors. No positivity claim
about `D`, its symmetric part, or a product of three PSD operators is
needed for (1). The verifier also evaluates the eight-variable expression
directly in the binary examples, independently of (1).

## 2. Negative coefficients on an actual common-power radial ray

Take

\[
\mu=(1/10,9/10),\qquad \phi=(3,-1/3).
\]

Then `E_mu phi=0`, `E_mu phi^2=1`, and `E_mu phi^3=8/3`. For
`0<=lambda<=1`, define the actual root

\[
T_\lambda=\Pi+\lambda\phi\otimes\phi,
\qquad K_j=\Pi+\lambda^{2j}\phi\otimes\phi.                  \tag{2}
\]

Every entry is nonnegative: the off-diagonal entry is `1-lambda`, while
the two diagonal entries are positive. Original weighted rows are one.
For example, at `lambda=1/2`,

\[
 p=\frac2{11},\qquad
 W=pT_{1/2}=
 \begin{pmatrix}1&1/11\\1/11&19/99\end{pmatrix}.             \tag{3}
\]

The actual target tuple is the smallest one,
`(k,u,r,l,h)=(1,1,1,1,1)`, so its six square exponents are
`(1,2,1,1,1,1)`. Put `z=lambda^2` and, temporarily,
`c=(E_mu phi^3)^2`. Exact expansion gives

\[
\begin{aligned}
\Delta_c(z):=F(T_\lambda)^2-Z_{ab}(T_\lambda)
={}&2z^3+4z^4+(2+2c)z^5+(2+8c)z^6\\
 &+(6+2c^2)z^7+(8-2c)z^8\\
 &+(6+8c)z^9+(2+2c)z^{10}-2cz^{11}.                         \tag{4}
\end{aligned}
\]

For completeness, the coefficient table is

| Power of `z` | Coefficient |
|---|---:|
| 3 | `2` |
| 4 | `4` |
| 5 | `2+2c` |
| 6 | `2+8c` |
| 7 | `6+2c^2` |
| 8 | `8-2c` |
| 9 | `6+8c` |
| 10 | `2+2c` |
| 11 | `-2c` |

### A finite derivation of the table

Expand each factor in (2) into its constant and rank-one parts. For any
selected subset `E'` of the twelve cover edges, a vertex of selected
degree one kills the term because `E phi=0`; selected degree two
contributes one, and selected degree three contributes `E phi^3`.
The number of degree-three vertices is even by the handshaking identity.
Consequently a surviving term is exactly

`z^(sum_(e in E') n_e) c^(number of degree-three vertices/2)`.

Enumerating the `2^12` finite edge subsets gives 225 surviving subsets for
two disjoint copies of K4 and 175 for the crossed cover. Their difference
is precisely the displayed nine-row table. The checker carries out this
integer enumeration and separately checks (4) against actual integrations
at `lambda=0,1/2,1`. The argument applies symbolically to every `c>=0`
arising from a binary original law; the three evaluations are independent
implementation checks, not the proof of the polynomial identity.

In our actual example `c=64/9`. Thus the coefficients of `z^8` and `z^11`
are `-56/9` and `-128/9`. More specifically, for the actual radial family

\[
T_\tau=\Pi+\tau(T_{1/2}-\Pi),\quad 0\le\tau\le1,
\]

one has `z=tau^2/4`, and the coefficients of `tau^16` and `tau^22` in the
**complete** cover defect are exactly

\[
\boxed{-\frac7{73728},\qquad -\frac1{294912}.}                \tag{5}
\]

Every member of this radial family is an actual root under the same
original law; indeed its entries are at least `1/2`. This is stronger
than a negative coefficient obtained by varying six independently chosen
kernels. It rules out coefficientwise positivity for this actual-ray
cover defect, but says nothing against a proof that groups coefficients.

### Exact compensation for the whole polynomial

The complete expression in (4) remains nonnegative. In fact

\[
\begin{aligned}
\Delta_c(z)={}&2z^3+4z^4+2(1+c)z^5+2z^6
 +2cz^6(4-z^2)\\
&+(6+2c^2)z^7+8z^8+(6+8c)z^9
 +2z^{10}+2cz^{10}(1-z).                                   \tag{6}
\end{aligned}
\]

Every term on the right is nonnegative when `c>=0`, `0<=z<=1`.
For `z>0` the first term is positive. Thus this example explicitly
requires compensation while still satisfying the full cover comparison.
The binary density class itself was already covered; (4)--(6) are used
here to diagnose a proposed coefficientwise extension of the cover
argument, not to claim new density coverage.

## 3. An actual negative proper centered barbell

For positive integers `s,k,t`, define the actual diagonal fields
`d_s(x)=C_s(x,x)` and the centered barbell density

\[
\mathcal B(s,k,t)
=\langle d_s,C_kd_t\rangle_\mu
=\mathbb E_{x,y}C_s(x,x)C_k(x,y)C_t(y,y).                    \tag{7}
\]

This comes directly from the specified cover. Keep the triangle
`a_0c_0d_0`, the crossed bridge `a_0b_1`, and the triangle `b_1c_1d_1`, and
use centered actual factors on those seven edges. Integrating the two
non-bridge vertices of each triangle gives

\[
 s=r+h+u+l,\qquad t=r+u+l,
\]

and its density is exactly (7), using original-measure common-power
composition. The other two cover vertices are isolated and integrate to
one. This is a proper centered subgraph with no selected degree-one
vertex, not a source chosen independently of the host.

### Complete rational three-state data

Let

\[
G=\begin{pmatrix}21&0&8\\0&7&5\\8&5&43\end{pmatrix},\qquad
s=(29,12,56),\qquad
\mu_i=s_i/97,
\]

\[
T(i,j)=\frac{97G_{ij}}{s_i s_j},\qquad
p=\frac{144}{679},\qquad W=pT.                              \tag{8}
\]

Symmetry and nonnegativity are explicit. Summing a row against the
original mass `s_j/97` gives one; the maximum entry of `T` is `679/144`,
so `W` lies in `[0,1]` and all its original weighted rows equal `p`.

The two centered root eigenvalues are the roots of

\[
 q(v)=v^2-\frac{5239}{4872}v+\frac{191}{696}.                 \tag{9}
\]

One lies in `(1/4,1/2)` and the other in `(1/2,3/4)`, as follows by the
three alternating signs of `q` at those rational endpoints. In particular
the root is PSD, although that extra condition is not needed for actual
admissibility.

At the admissible tuple

\[
\boxed{(k,u,r,l,h)=(10,1,1,1,1)},
\]

original rational matrix multiplication and the independent six-variable
integral give the exact bound

\[
\boxed{\mathcal B(4,10,3)<-\frac1{2\cdot10^{10}}<0.}         \tag{10}
\]

The verifier gives the numerator and positive denominator, and checks the
bound by integer comparison. No rounded sign is used. It also certifies,
for this same original host and tuple,

`F>1` and `Z_ab<F^2`.

### This survives grouping the two lifted copies of each base edge

Temporarily write each base-edge factor as `Pi+z_e C_(n_e)`, using the
same `z_e` for its two lifts. Consider the coefficient of

`z_ab z_ac z_ad z_bc z_bd z_cd^2`.

In the crossed cover exactly two selected edge sets have no degree-one
vertex: the barbell above and its sheet exchange. Its coefficient is
therefore exactly `2 B(s,k,t)`, strictly negative in (10). In two disjoint
copies of K4 there are no surviving subsets at this exact multidegree.
The checker enumerates all 32 choices of the five singly selected base
edges and verifies the counts `0` and `2`.

This multivariate diagnostic does not assert that independently varying
the `z_e` keeps all factors powers of one root. The actual negative
barbell and the separate actual radial obstruction (5) already meet their
stated common-root hypotheses; this paragraph only records that grouping
by base-edge labels does not restore the negative barbell coefficient.

## 4. Strictly positive example with three positive centered bands and zero

The negative barbell is not an artifact of a root zero, a two-band whole
centered space, or a density threshold. Here is a complete five-state
rational extension of (8).

Set

`gamma=1/100`, `eta=gamma^4=1/10^8`, `tau=1/2`.

Replace coarse state 0 by two states of conditional weights
`eta,1-eta`; replace coarse state 1 by two identical states of conditional
weights `1/2,1/2`; leave coarse state 2 unchanged. In the resulting order,

`q=(0,0,1,1,2)`, `nu=(eta,1-eta,1/2,1/2,1)`,

and the **original fine probability** is

`mu'_i=mu_(q_i) nu_i`.

Define a relative projection `Q_f`, zero unless `i,j in {0,1}`, by

\[
Q_f(i,j)=\frac{\mathbf1_{i=j}/\nu_i-1}{\mu_0}.
\]

Then `Q_f^2=Q_f`, `tr Q_f=1`, and the pulled-back coarse root
`L(i,j)=T(q_i,q_j)` annihilates it on both sides. Define

\[
U=L+\gamma Q_f,\qquad T'=\Pi+\tau(U-\Pi),\qquad
p'=\frac1{\max_{i,j}T'(i,j)},\qquad W'=p'T'.                 \tag{11}
\]

The only possibly decreased entries of `U` lie between the two pieces of
coarse state 0. They equal

`T(0,0)-gamma/mu_0 >0`,

because `gamma < mu_0 T(0,0)=21/29`. Thus `U` is an actual nonnegative
Markov root. Its original row normalization follows from that of `L` and
the zero rows of `Q_f`. Consequently `T'>=1/2` entrywise, and (11) gives
an actual strictly positive `W'` with its exact common weighted row sum.

### Original-measure transport and full spectrum

Direct weighted composition gives `L Q_f=Q_f L=0` and `Q_f^2=Q_f`.
Pure duplication pulls back every positive coarse power. Therefore, for
all `j>=1`,

\[
(T')^{2j}(i,j')
=1+\tau^{2j}\{T^{2j}(q_i,q_{j'})-1
                  +\gamma^{2j}Q_f(i,j')\}.                \tag{12}
\]

No conditional measure replaces `mu'` in this equation. The two pieces of
state 1 give one additional zero mode. If `lambda_1,lambda_2` are the two
roots in (9), the entire centered square spectrum is exactly

\[
\tau^2\lambda_1^2,\quad \tau^2\lambda_2^2,
\quad\tau^2\gamma^2,\quad0,
\]

all with multiplicity one. They are four distinct values on all four
centered dimensions. The checker verifies the full characteristic
polynomial, not just the positive eigenvalues. It also verifies

`p'<1/10000` and `max (T')^2>1000`.

### Independent reduction of the barbell

Let `m(i)=1_(i=0)/mu_0` on the original three-state space. The conditional
mean of the split projection's diagonal equals `m`. Its only centered
fine component has squared coefficient

`(1-2eta)^2/[mu_0 eta(1-eta)]`.

Orthogonality of that component to pulled-back coarse fields and (12)
therefore give the exact scalar reduction

\[
\begin{aligned}
\mathcal B'(s,k,t)=\tau^{2(s+k+t)}\big[&
\langle d_s+\gamma^{2s}m,
 C_k(d_t+\gamma^{2t}m)\rangle_\mu\\
&+\gamma^{2(s+k+t)}
 \frac{(1-2\eta)^2}{\mu_0\eta(1-\eta)}\big].                \tag{13}
\end{aligned}
\]

For the explicit parameters above, direct original-five-state arithmetic
and the independent reduction (13) both certify

\[
\boxed{\mathcal B'(4,10,3)
 <-\frac1{2\cdot10^{10}\cdot2^{34}}<0.}                     \tag{14}
\]

The same checker independently certifies `F(T')>1` and
`Z_ab(T')<F(T')^2` at `(10,1,1,1,1)`.

These hosts are used as proof-mechanism diagnostics. Their density does
not represent new coverage: the three-state coarse root lies in the old
whole-centered two-band class, and the refinement has the previously
proved block-refinement structure. The additional strict-positive mixing
still has a three-state coarse root and the same local refinement form.

## 5. A legitimate collective rule for the bad barbell terms

Although individual cross-barbells can be negative, their length-indexed
matrix is positive semidefinite. For a fixed bridge exponent `k`, any
finite positive lengths `s_i` and real coefficients `a_i` satisfy

\[
\sum_{i,j}a_i a_j\mathcal B(s_i,k,s_j)
=\left\|C_k^{1/2}\sum_i a_i d_{s_i}\right\|_{L^2(\mu)}^2
\ge0.                                                       \tag{15}
\]

In particular

\[
|\mathcal B(s,k,t)|^2
\le\mathcal B(s,k,s)\mathcal B(t,k,t).                        \tag{16}
\]

More generally `B_ij=<d_(s_i),C_(a_i+a_j)d_(s_j)>` is a Gram matrix when
`a_i` are positive integers: its vectors are `C_(a_i)d_(s_i)` under the
original law. Hence any PSD coefficient matrix paired with this matrix
produces a nonnegative collective contribution. This is a valid grouping
mechanism retaining actual fields, as opposed to assigning signs to each
cross term. It does not assert that an unrestricted cover expansion
supplies the required diagonal terms or PSD coefficient matrix.

There is consequently no extension here from the seven two-cover
comparisons to all sheet numbers. Both coefficientwise routes are blocked
by the explicit actual examples above. A successful cover proof must
supply a collective budget, such as (6) or an appropriate use of (15),
with its availability in the full expansion proved separately.
