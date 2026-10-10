# Vanishing cubic traces in actual multiplication fields

**Verdict and scope.** This is a restricted, all-exponent contraction
mechanism. It does not prove or refute the unrestricted common-power
density target. It requires an explicit algebraic condition on the actual
source field. Unlike a bound that spends the positive pair surplus to
control an unknown cubic term, the condition makes that term identically
zero, so the entire pair surplus remains. No novelty claim is made.

All spaces below are finite and real. Every probability is original; an
introduced refinement is assigned its own explicit original probability.

## 1. A matrix-field theorem

Let `S` be a nonnegative self-adjoint Markov kernel on `(I,pi)`, and put
`B=S^2`. Let `C_i` be positive semidefinite `d` by `d` real symmetric
matrices with `E_pi C_i=I_d`. Write `X_i=C_i-I_d` and suppose their real
linear span `V` satisfies

\[
\operatorname{tr}(XYZ)=0\quad\text{for all }X,Y,Z\in V.\tag{1}
\]

This is a finite algebraic condition: it suffices to test triples from any
basis of `V`. For real symmetric matrices, cyclicity and transpose make
the trilinear trace symmetric in all three arguments. Equivalently, the
homogeneous polynomial `tr(X^3)` vanishes identically on `V`, by
polarization. Condition (1) is independent of the exponent tuple.

For positive integers `x,y,z`, put `M_s=B^s C`. Then

\[
\boxed{\begin{aligned}
J_{xyz}&:=\mathbb E_i\operatorname{tr}(M_x(i)M_y(i)M_z(i))\\
&=d+\langle X,B^{x+y}X\rangle
    +\langle X,B^{x+z}X\rangle
    +\langle X,B^{y+z}X\rangle\ge d.
\end{aligned}}\tag{2}
\]

Here the inner product is the original-law Hilbert--Schmidt inner product
on matrix fields. In particular, no commutation of the matrices `C_i` is
required. The pointwise factors `M_s(i)` are PSD, but no general sign rule
for a product of three PSD matrices is used.

**Proof.** The Markov property gives `M_s=I_d+B^s X`. Every `B^s X(i)`
lies in `V`, and its original-law mean is zero. Expand the triple product
inside the trace. The three linear terms have zero average; the cubic
term is zero pointwise by (1). Self-adjointness and composition give
`E tr((B^sX)(B^tX))=<X,B^(s+t)X>`. This is nonnegative because `B` is
PSD. These facts prove (2). QED.

For a complete original orthonormal eigenbasis of `B`, with
`phi_0=1`, eigenvalues `lambda_i in [0,1]`, and
`Xhat_i=E_pi phi_i X`, formula (2) reads

\[
J_{xyz}=d+\sum_{i>0}
(\lambda_i^{x+y}+\lambda_i^{x+z}+\lambda_i^{y+z})
\|\widehat X_i\|_{HS}^2.\tag{3}
\]

All additional eigenvalue-one modes of disconnected squares are retained.
Zero modes contribute zero at these positive exponents. Equality in (2)
holds exactly when `B X=0`, equivalently `B C=I_d`. There is no assertion
that equality requires `S=Pi`.

## 2. Applying the mechanism after one actual smoothing step

Let `Q=Q*=Q^2` be an original-law orthogonal projection of rank `d`, with
its actual field on `E=ran Q`

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_E,
\qquad \mathbb E_\pi R_i=I_E.\tag{4}
\]

It is enough that the span of `(B R)_i-I_E` satisfies (1); the raw
rank-one fields in (4) need not do so. For `x,y,z>=1`, take `C=BR` and
use `B^(s-1)C=B^sR`. The same expansion proves

\[
\boxed{\begin{aligned}
\mathbb E_i\operatorname{tr}[(B^xR)_i(B^yR)_i(B^zR)_i]
=d+\sum_{j>0}(
\lambda_j^{x+y}+\lambda_j^{x+z}+\lambda_j^{y+z})
\|QD_{\phi_j}Q\|_{HS}^2\ge d.
\end{aligned}}\tag{5}
\]

This formula keeps the original source, rather than replacing it with an
arbitrary function. The visible condition is allowed to hold only after
one step. Consequently no conclusion at exponent zero is implied. In
(5), equality is equivalent to `BR=I_E`.

## 3. Explicit algebraic mechanisms satisfying (1)

### 3.1 A fixed block grading, in arbitrary dimension

Split `R^d=R^a direct-sum R^b`, with `a,b>=1`. Matrices

\[
X=\begin{pmatrix}0&Z\\Z^T&0\end{pmatrix}\tag{6}
\]

form a linear space satisfying (1): the product of three off-diagonal
block matrices has zero diagonal blocks. Equivalently, conjugation by
`G=diag(I_a,-I_b)` sends every `X` to `-X`, so invariance of trace gives
`tr(XYZ)=-tr(XYZ)`. The matrices in this space need not commute.

Thus any mean-zero family `Z_i` with operator norm at most one defines
PSD fields

\[
C_i=\begin{pmatrix}I_a&Z_i\\Z_i^T&I_b\end{pmatrix}\tag{7}
\]

to which (2) applies for every actual root `S`, with no spectral-band
bound. The PSD assertion follows from
`||Z_i||<=1`, or from the Schur complement. The contraction identity
does not depend on a small-norm estimate.

### 3.2 Balanced real rank two

The space of traceless real symmetric `2` by `2` matrices also satisfies
(1). If
`X=[[a,b],[b,-a]]` and `Y=[[c,e],[e,-c]]`, then
`XY+YX=2(ac+be)I_2`. For traceless `Z`, cyclicity and transpose yield
`tr(XYZ)=tr((XY+YX)Z)/2=0`.

Consequently an actual rank-two projection with
`B[Q(i,i)]=2` satisfies (5) at every positive triple. Constant diagonal
`Q(i,i)=2` is sufficient, but is not necessary when `B` has a zero
eigenspace. The independently developed rank-two note gives a weighted
actual host with five interacting coarse bands; it is not being counted
as a separate unrestricted solution.

### 3.3 Constant trace is not required by the general theorem

Set `D=diag(1,12,-9,-10)`. Then
`tr(D^3)=1+1728-729-1000=0`, while `tr D=-6`. Hence the line `span{D}`
satisfies (1). Choose any scalar field `t_i` of mean zero with
`-1/12<=t_i<=1/10`; the matrices `C_i=I_4+t_iD` are PSD and satisfy
(2), even when their traces vary. This is a simple algebraic example,
not a universal reduction of arbitrary varying-trace sources.

## 4. Exact original-law projection realization

We include the finite realization argument used in the independent
unequal-star route. Suppose `C_i=sum_a v_(i,a) v_(i,a)^T` is a finite
rank-one decomposition, using only nonzero vectors, and choose arbitrary
positive conditional probabilities `nu_(i,a)` summing to one at each
`i`. Set

\[
\widehat\pi_{i,a}=\pi_i\nu_{i,a},\qquad
\psi_{i,a}=v_{i,a}/\sqrt{\nu_{i,a}},\qquad
Q((i,a),(j,b))=\psi_{i,a}^T\psi_{j,b}.\tag{8}
\]

The frame identity
`sum_(i,a) pi_hat_(i,a) psi_(i,a) psi_(i,a)^T=I_d`
proves directly that `Q` is an original-law orthogonal projection of rank
`d`. Under this isometry its actual field is
`R_(i,a)=psi_(i,a) psi_(i,a)^T`.

Pull back the original root by

\[
\widehat S((i,a),(j,b))=S(i,j).\tag{9}
\]

It is symmetric, nonnegative and Markov on `pi_hat`. In each original
composition, summing `nu_(j,b)` gives one, so every positive power is the
pullback of the same power of `S`. Averaging the source over a fiber gives
`sum_a nu_(i,a)R_(i,a)=C_i`. Therefore, for every `s>=1`,

\[
[(\widehat S^2)^sR]_{i,a}=[B^s C]_i.\tag{10}
\]

This proves original-measure transport, including the additional zero
modes of the refinement. It is a realization lemma, not by itself a
sign proof. Section 1 supplies the additional mechanism.

Zero matrices `C_i` can be handled by a one-point fiber with `psi=0`;
the frame identity and the stated transport remain valid. No strictly
positive eigenvalue of a `C_i` is silently assumed.

## 5. Consequence for an actual binary projection channel

Let `H=H*` be real, `beta>=0`, `H^2=beta Q`, `|H|<=S_hat`, and

\[
T((i,a,\sigma),(j,b,\tau))
=\widehat S((i,a),(j,b))+\sigma\tau H((i,a),(j,b)),
\quad \mu(i,a,\sigma)=\widehat\pi_{i,a}/2.\tag{11}
\]

Then `T` is one actual nonnegative self-adjoint Markov root. Averaging the
middle sign in each original-law composition gives
`T^(2n)=S_hat^(2n)+sigma tau beta^n Q`. The six-edge sign expansion has
only its empty subset and the seven cycles of `K4`. Formula (5) bounds
every triangle coefficient by `d`; the previously proved arbitrary-
projection quadrilateral lemma bounds each four-cycle coefficient by
`d`. Thus for **every six positive exponents** `n_e`,

\[
\boxed{F(T;n)\ge F(\widehat S;n)
       +d\sum_{D\in\mathcal C(K_4)}\beta^{\sum_{e\in D}n_e}.}\tag{12}
\]

No tuple ordering, reflection condition, or number of coarse spectral
bands is needed for this restricted transfer. A separate theorem or exact
certificate for `F(S_hat;n)>=1` is still necessary to infer the target
for that host. If the base `S` is strictly positive, choosing
`H=alpha Q` with sufficiently small positive `alpha` ensures (11) is
actual; a root with zeros need not admit such a nonzero channel.

The weighted 16-state example in the companion note verifies this
construction with rank four, signed noncentral `Q`, noncommutation,
three interacting positive coarse bands, a new positive channel band,
and zero. Its coarse density is covered by the earlier common-order
TP2-convex-hull theorem, explicitly identified there.

## 6. Relation to the stronger Jordan bounds in this packet

The block-graded fields (7) have `0<=C_i<=2I`; their lower bound is also
covered by the new Jordan source-cap theorem. The algebraic calculation
has the additional conclusion of the **exact** full-pair identity (2).
It is not counted as a second independent coverage claim for the same
16-state host.

The general zero-cubic condition is not restricted to a bounded visible
norm. For any positive integer `m`, let
`d=m^3+1` and `D=diag(m,-1,...,-1)`, with `m^3` copies of `-1`.
Then `tr(D^3)=0`. Take two original masses
`1/(m+1),m/(m+1)` and scalar values `t=1,-1/m`, respectively.
The PSD fields `C=I_d+tD` have mean `I_d` and satisfy (2).
For the actual root `S=(1-epsilon)I+epsilon Pi`, put
`rho=(1-epsilon)^2`; direct calculation gives

\[
J_{xyz}=d+m(m+1)
\bigl(\rho^{x+y}+\rho^{x+z}+\rho^{y+z}\bigr).\tag{13}
\]

At the first original state,
`lambda_max(B C)=1+m rho`. For example `m=9,epsilon=1/1024`
gives `1+9rho>97/10>4+4sqrt2`, and the traces of the two visible
fields differ. The exact original-law realization in Section 4 turns
these fields into a finite projection example. This illustrates the
scope of the algebraic identity, not new unrestricted density coverage
or a new host outside every earlier restricted theorem.

## Limits

Condition (1) is not automatic. The prior exact cancellation and negative
pointwise examples retain nonzero cubic terms, and are not contradicted.
The unrestricted averaged inequality (U) and all-sheet cover comparison
(C) remain open. No structural reduction of every actual root to (11),
or of every actual field to (1), is assumed.
