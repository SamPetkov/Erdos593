# Actual pointwise failure for an unequal projection star

## Verdict and exact scope

The unrestricted common-power density inequality remains unresolved.
The example below is a strictly positive, rational, actual 18-state host.
It has nine values on its entire centered square spectrum, including a
zero band. At the admissible tuple

\[
(k,u,r,l,h)=(3,1,1,1,1),
\]

which lies outside all three reflection families recorded in PR #60, one
**pointwise complementary-star coefficient** is strictly negative even
though all its factors arise from the actual common coarse square and
one actual weighted projection.

This refutes only a pointwise sufficient lemma. The full original-law
average of this star satisfies `31<J<32`, whereas the proposed averaged
projection bound is `J>=2`. The full requested density satisfies the
explicit bound

\[
 F\ge16(1-2^{-16})^{18}
 \ge16(1-18\,2^{-16})
 =16-\frac9{2048}>15.
\]

Thus neither the averaged projection contraction nor `F>=1` is refuted.
The construction shows why a proof of the unequal-star inequality must
use its original-law average; pointwise positivity cannot replace that
step, including for an actual projection channel.

All assertions below are checked by the standard-library script
`continuation5_search_pointwise_verify.py`. Exact rational comparisons,
not the decimal approximations, certify the signs.

## 1. Complete rational coarse root and original probability

Put

\[
q=64,\qquad D=2\sum_{i=0}^{5}q^i+q^6=70\,901\,047\,426.
\]

On path vertices `0,...,6`, let the symmetric flow matrix `G` have

\[
G(i,i+1)=G(i+1,i)=q^i\quad(0\le i<6),
\qquad G(6,6)=q^6,
\]

and all other entries zero. Define its row sums

\[
s_0=1,\qquad s_i=q^{i-1}+q^i\quad(1\le i\le6).
\]

They satisfy `sum_i s_i=D`. Add two states `7,8`, and prescribe the
**original** coarse probability

\[
\pi_i=\frac{s_i}{2D}\quad(0\le i\le6),
\qquad \pi_7=\pi_8=\frac14.
\]

The path has original mass `1/2`. The following is a relative kernel,
not a row-stochastic matrix:

\[
S_0(i,j)=\frac{2D\,G(i,j)}{s_i s_j}\quad(0\le i,j\le6),
\qquad S_0(7,7)=S_0(8,8)=4,
\]

with every other entry zero. Its original-weighted rows sum to one and
it is symmetric and nonnegative. Its associated row-stochastic matrix
on the path moves from `0` to `1` with probability one, from an interior
vertex left with probability `1/65` and right with probability `64/65`,
and at `6` moves left with probability `1/65` or holds with probability
`64/65`.

Let `Pi` denote the relative kernel identically equal to one. Set

\[
\delta=2^{-16},\qquad S=(1-\delta)S_0+\delta\Pi,
\qquad A=S^2,\qquad K_j=A^j=S^{2j}.
\]

Every entry of `S` is at least `delta`. It is an actual, strictly positive,
self-adjoint Markov root on the original probability `pi`.
Since `S_0 Pi=Pi S_0=Pi`, original-weighted composition gives exactly

\[
S^{2j}=(1-\delta)^{2j}S_0^{2j}
       +[1-(1-\delta)^{2j}]\Pi.
\]

No conditional renormalization is substituted for `pi` in these powers.

## 2. Actual rank-two projection

Let the `9 by 2` rational matrix `V` have the following nonzero rows:

\[
V_2=(1/10,0),\qquad
V_4=(3/50,2/25),\qquad
V_6=(3/50,-2/25),
\]

\[
V_7=(2,0),\qquad V_8=(0,2).
\]

The rows `0,1,3,5` vanish. Define

\[
B=V^\top\operatorname{diag}(\pi)V,
\qquad Q=V B^{-1}V^\top.
\]

The two completion rows `7,8` contribute exactly `I_2` to `B`, so
`B>=I_2`. In particular `B` is invertible, and direct multiplication gives

\[
Q\operatorname{diag}(\pi)Q=Q,
\qquad Q^\top=Q,
\qquad\operatorname{tr}_{L^2(\pi)}Q=2.
\]

Thus `Q` is the original-law orthogonal projection of rank two. It neither
fixes nor annihilates constants. It does not commute with `S`; the
checker verifies `(SQ-QS)(1,7)>0` using original-weighted composition.
It has a negative triangle:

\[
Q(2,4)Q(4,6)Q(6,2)<0.
\]

Since `B^{-1}<=I_2` and every row of `V` has Euclidean norm at most two,
Cauchy--Schwarz gives `|Q(i,j)|<=4` for every pair.

## 3. Certified negative pointwise star from the actual sources

On `E=ran Q`, define the actual multiplication sources

\[
R_t=Q D_{\mathbf1_{\{\cdot=t\}}/\pi_t}Q.
\]

Their original-law mean is `I_E`. For `j>=1`, put

\[
C_j(t)=(A^jR)_t=Q D_{K_j(\cdot,t)}Q\big|_E.
\]

The latter identity follows by expanding the original-`pi` average and
using the symmetry of `K_j`. Each `C_j(t)` is PSD. In the basis of `E`
given by the columns of `V`, its coordinate matrix is

\[
\mathsf C_j(t)
=B^{-1}V^\top\operatorname{diag}
  \bigl(\pi_i K_j(i,t)\bigr)V.
\]

These coordinate matrices need not be symmetric for the ordinary
Euclidean inner product, but they represent the self-adjoint PSD
operators above in the common positive Gram metric `B`. Ordinary matrix
trace is invariant under this change of coordinates.

For the actual point `t=0`, exact rational arithmetic gives

\[
\boxed{
-2^{-24}
<\operatorname{tr}_E[C_1(0)C_2(0)C_3(0)]
<-2^{-25}<0.
}
\]

Its decimal value is approximately `-3.9568352940272726e-8`.
The checker independently expands the original-law triple integral

\[
L(t)=\sum_{a,b,c}\pi_a\pi_b\pi_c
Q(a,b)Q(b,c)Q(c,a)
K_1(a,t)K_2(b,t)K_3(c,t)
\]

and verifies `L(t)=tr_E[C_1(t)C_2(t)C_3(t)]` at all nine values of `t`.
It then verifies the exact averaged bounds

\[
31<J_{1,2,3}:=\sum_t\pi_t L(t)<32.
\]

The approximate average is `31.761112053807004`. Its size is not inferred
from numerical matching: both inequalities are exact fraction comparisons.

The negative term is therefore an actual compressed multiplication-field
term, not a freely chosen triple of PSD matrices or an arbitrary source
substituted into the density identity.

## 4. Full admissible 18-state host and target tuple

Put

\[
\alpha=\delta/8=2^{-19},\qquad
\beta=\alpha^2=2^{-38},\qquad H=\alpha Q.
\]

On fine states `(i,a)` with `0<=i<=8` and `a in {-1,1}`, prescribe the
**original fine probability** and root

\[
\mu(i,a)=\frac{\pi_i}{2},\qquad
T((i,a),(j,b))=S(i,j)+ab H(i,j).
\]

The bound `|H|<=delta/2` gives `T>=delta/2>0`, and averaging the original
sign `b` proves every original-weighted row of `T` sums to one. Set

\[
\boxed{
p=\frac1{4D}=\frac1{283\,604\,189\,704},
\qquad W=pT.
}
\]

Since `pi_min=1/(2D)`, Markovness gives `S(i,j)<=1/pi_min`. Consequently

\[
0<W(i,a;j,b)
\le\frac12+\frac{\pi_{\min}\delta}{4}<1.
\]

Thus `W` is symmetric, lies in `[0,1]`, and has every original-weighted
row sum equal to the displayed positive `p`. This is a complete actual
host specification with no unrealizable square root.

Original sign averaging proves for every `j>=1`

\[
T^{2j}((i,a),(j',b))
=S^{2j}(i,j')+ab\,\beta^j Q(i,j').
\]

The exact checker independently composes the full `18 by 18` relative
kernel using `mu` and verifies this identity for powers `2,4,6`.

For `(k,u,r,l,h)=(3,1,1,1,1)`, the six edge exponents are

\[
(n_{ab},n_{ac},n_{ad},n_{bc},n_{bd},n_{cd})=(3,2,1,1,1,1).
\]

The binary sign expansion of the density leaves the empty edge set and
the seven cycles. The `bcd` channel cycle has complementary star at `a`
with exponents `(3,2,1)`. Real self-adjoint triple traces are invariant
under reversal, so at `a=0` its coarse conditional coefficient is exactly
the negative number certified above, multiplied by the positive factor
`beta^3`. Averaging over `a` gives `beta^3 J_{1,2,3}>0`.

The tuple satisfies the target inequalities, including `r=l` and `h=1`,
but satisfies none of

`k=u,r=l`; `k=r,u=l`; `k=r+h,u=l`.

### A direct original-measure lower bound for the complete F

Let `B_7={(7,-1),(7,+1)}`. Its original fine mass is `1/4`. For both
endpoints in this block,

\[
T\ge S(7,7)-|H(7,7)|
\ge4-3\delta-\delta/2\ge4(1-\delta).
\]

Restricting all `2j-1` intermediate vertices in a `2j`-step composition
to `B_7`, with their original weights, gives

\[
T^{2j}(x,y)
\ge(1/4)^{2j-1}[4(1-\delta)]^{2j}
=4(1-\delta)^{2j}\qquad(x,y\in B_7).
\]

Restricting the four branch vertices to the same block then gives

\[
F\ge(1/4)^4\,4^6(1-\delta)^{2\sum_e n_e}
=16(1-\delta)^{18}
\ge16(1-18\delta)>15.
\]

All restrictions retain nonnegative summands. This proof does not assume
the missing density theorem, coarse domination, or positivity of the
other signed-cycle terms.

## 5. The entire centered spectrum: nine bands, including zeros

The path transition operator `C` of Section 1 is similar to a real
symmetric tridiagonal matrix with strictly positive adjacent entries.
Every eigenvector is determined by its first coordinate through the
three-term recurrence, so all seven eigenvalues are simple. The only
nonzero diagonal entry is the last one, `64/65`.

Let `p_j` be the characteristic polynomial of the first `j` coordinates
of that symmetric matrix. For `j<=6`, the diagonal vanishes and `p_j` has
the parity of `j`. For the full matrix,

\[
p_7(z)=(z-d)p_6(z)-b^2p_5(z),\qquad d=64/65,\ b>0.
\]

If a nonzero pair `z,-z` were both roots, adding the two equations would
force `p_6(z)=0`, and then `p_5(z)=0`. The three-term recurrence prevents
two successive characteristic polynomials from sharing a root. Also
`p_7(0)=-d p_6(0)` is nonzero. Thus no two path eigenvalues have the same
square, and none is zero. The exact checker independently verifies the
corresponding two rational polynomial gcds.

The connected path has a positive holding probability, so besides its
simple stationary eigenvalue one, all six eigenvalues have absolute
value strictly below one. The full `S_0` has three stationary modes: the
path and the two singleton blocks. Mixing with `Pi` retains one global
stationary mode and multiplies the entire centered spectrum by
`1-delta`.

For a separation from the fine channel band, exact elimination gives

\[
|\det C|=\frac{64^3}{65^6}.
\]

Since all path eigenvalues have absolute value at most one, each has
absolute value at least `|det C|`. Exact rational comparison gives

\[
\beta<(1-\delta)^2|\det C|^2.
\]

The coarse square therefore has seven distinct positive centered values:
`(1-delta)^2` with multiplicity two and six different path values below
it, all strictly greater than `beta`. The fine sign decomposition adds
the eigenvalue `beta` with multiplicity two and zero with multiplicity
seven. The full accounting is

| Centered sector | Multiplicity | Number of distinct values |
|---|---:|---:|
| Coarse stationary contrasts | 2 | 1 |
| Six nonconstant path modes | 6 | 6 |
| Actual projection channel | 2 | 1 |
| Channel kernel | 7 | 1 |
| Total centered space | 17 | 9 |

The root is strictly positive even though its square has a zero band.
This example cannot be described as a two-centered-value host.

## 6. Reproduction and limitation

Run `python continuation5_search_pointwise_verify.py`. The checker uses
only exact `fractions.Fraction` arithmetic for all assertions; decimal
numbers appear only in its output for scale. It checks the original
weights and kernel normalization, actual `W`, projection and its rank,
negative projection triangle, noncommutation, all three required full
fine powers, all nine direct star expansions, the strict pointwise sign,
the averaged bounds, the full-density lower bound, and the path spectrum
separation. The JSON records the source hash and the proof-note hash.

No primary-literature priority claim is made for this construction.
The new certificate only rules out pointwise unequal-star positivity in
the exact actual-source setting. The averaged theorem-strength
obligation remains open in this packet.
