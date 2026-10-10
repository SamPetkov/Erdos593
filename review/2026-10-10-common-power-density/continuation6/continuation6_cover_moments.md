# A second-moment certificate for every sheet count in a one-edge cover

## Verdict and scope

The unrestricted density inequality and unrestricted cover comparison (C)
remain unresolved. This note proves a collective mechanism that permits
negative actual transfer eigenvalues: a real-spectrum second-moment budget
controls **every** sheet-cycle length. It then gives an exact certificate
for all six choices of a single permuted edge, every sheet number, and
every tuple

\[
(k,u,r,l,h)=(k,4,1,1,8),\qquad k\ge4,
\]

on the actual 32-state sign host supplied in the original question.
In particular, its negative modewise contribution is retained in the
calculation. The host is reused, and its density was already covered by
previous restricted arguments. The result here is the infinite family of
cover comparisons, with an explicit deficit, rather than new unrestricted
density coverage.

Only one base edge is permuted at a time; the other five have identity
sheet matchings. This does not establish (C) for arbitrary six-permutation
covers. No assertion that a general actual transfer has real spectrum is
made. No implication from the seven two-covers to arbitrary sheet numbers
is assumed.

The companion `continuation6_cover_moments_verify.py` and its generated
`continuation6_cover_moments_checks.json` use integer and rational
arithmetic only. Numerical probes are not inputs to this certificate.

## 1. Exact original-measure transport to one transfer matrix

Fix any finite original probability space and any nonnegative symmetric
edge kernels on K4; they need not be common powers for this paragraph.
Orient an edge `e=vw`. With the values at `v,w` fixed to `x,y`, define

\[
D_e(x,y)=\mathbb E_{\text{other two vertices}}
             \prod_{f\ne e} K_{n_f}(x_{f^-},x_{f^+}),
\qquad R_e=K_{n_e}D_e^*.
\tag{1}
\]

Composition and adjoints here use the original measure. Thus the relative
kernel of the latter operator is

\[
R_e(x,z)=\mathbb E_{y\sim\mu}K_{n_e}(x,y)D_e(z,y),
\qquad \operatorname{tr}R_e=F.
\tag{2}
\]

It is an entrywise nonnegative operator, but it is not asserted to be
self-adjoint or PSD.

Let `sigma` be a permutation of `M` sheets, used only on edge `e`.
Integrating the two internal vertices in each sheet leaves

\[
\mathbb E_{x_1,y_1,\ldots,x_M,y_M}
\prod_{a=1}^M D_e(x_a,y_a)K_{n_e}(x_a,y_{\sigma(a)}).
\]

In the sum over `y_a`, its incident edge factor is
`K_(n_e)(x_(sigma^{-1}(a)),y_a)`. By (2), integrating this original variable
gives `R_e(x_(sigma^{-1}(a)),x_a)`. Each cycle of `sigma` therefore gives
one original-measure operator trace. If its cycle lengths are
`m_1,...,m_s`, then

\[
\boxed{Z_{e,\sigma}=\prod_{j=1}^s\operatorname{tr}(R_e^{m_j}).}
\tag{3}
\]

The variables belonging to different permutation cycles are independent
under the full original product measure, which proves the product in (3).
No conditional or component measure is substituted.

## 2. A collective spectral certificate, allowing negative eigenvalues

**Lemma 1.** Let `R` be a finite real matrix with real eigenvalues, counted
with algebraic multiplicity. Suppose `F=tr R>0` and

\[
S_2=\operatorname{tr}(R^2)\le F^2.
\]

For every integer `m>=2`,

\[
\operatorname{tr}(R^m)
\le S_2^{m/2}\le F^m.                                    \tag{4}
\]

**Proof.** If the real eigenvalues are `lambda_j`, then traces of powers
equal the corresponding power sums, even if `R` is not diagonalizable.
Consequently

\[
|\operatorname{tr}(R^m)|\le\sum_j|\lambda_j|^m
\le\left(\sum_j\lambda_j^2\right)^{m/2}=S_2^{m/2}.
\]

The middle inequality is the finite-dimensional `l_m<=l_2` inequality.
This uses real spectrum, not positivity of each eigenvalue. In the actual
application, entrywise nonnegativity also implies
`tr(R^m)>=0`. Together with (3), the lemma proves all sheet counts for the
specified one-edge family. \(\square\)

The following elementary budget will certify the lemma's hypothesis.

**Lemma 2.** Suppose the real spectrum consists of numbers

\[
\rho\ge1,\quad 0<w<1,\quad z\ge-w/4,
\quad\text{and any further nonnegative numbers.}
\]

Then `F=tr R>0` and

\[
F^2-\operatorname{tr}(R^2)>w.                              \tag{5}
\]

**Proof.** If `z>=0`, all eigenvalues are nonnegative and the two distinct
entries `rho,w` alone contribute `2rho w>=2w` to the defect. If `z=-v<0`,
then `0<v<=w/4`, and the three displayed modes give

\[
(\rho+w-v)^2-(\rho^2+w^2+v^2)
=2\{\rho(w-v)-wv\}
\ge\tfrac32 w-\tfrac12 w^2>w.
\tag{6}
\]

Their sum is positive. Adding any nonnegative eigenvalues increases this
square defect by twice their product with the preceding positive sum,
plus their nonnegative pairwise cross terms. \(\square\)

This is a collective compensation rule. The negative eigenvalue is not
discarded or declared positive.

## 3. The actual host and its seven active characters

Use the edge order `ab,ac,ad,bc,bd,cd`. For six signs `R_e`, let

\[
S_a=R_{ab}R_{ac}R_{ad},\quad
S_b=R_{ab}R_{bc}R_{bd},\quad
S_c=R_{ac}R_{bc}R_{cd},\quad
S_d=R_{ad}R_{bd}R_{cd}.
\]

The original state space consists of the 32 sign assignments satisfying
`S_a+S_b+S_c-S_d=2`, each of mass `1/32`. Put

\[
s=(2^{-64},2^{-5},2^{-2},2^{-3},2^{-4},2^{-3}),\qquad
T(x,y)=1+\sum_{e=1}^6s_eR_e(x)R_e(y),
\]

\[
p=(51/32+2^{-64})^{-1},\qquad W=pT.                       \tag{7}
\]

The six signs are centered and orthonormal. Thus `T` is self-adjoint
Markov, with these six eigenvalues, the constant eigenvalue one, and
25 zero eigenvalues. Moreover

\[
T(x,y)\ge13/32-2^{-64}>0,
\quad \max T=51/32+2^{-64}=1/p.
\]

It follows that `W` is strictly positive, symmetric, at most one, and all
its original weighted rows equal `p`. The square powers are exactly

\[
K_j(x,y)=1+\sum_{i=1}^6\theta_i^jR_i(x)R_i(y),\qquad
\theta=(2^{-128},2^{-10},2^{-4},2^{-6},2^{-8},2^{-6}).
\tag{8}
\]

The entire centered square spectrum has five distinct positive values
and the additional zero value. The value `2^-6` has multiplicity two;
zero has multiplicity 25. This is not a two-value whole-centered host.

Flip signs on any of the triangles `abc`, `abd`, and `acd`. These three
independent transformations generate a group of order eight, preserve the
original state space and measure, and preserve every simultaneous kernel
value `K_j(gx,gy)=K_j(x,y)`. On the seven functions
`phi_0=1,phi_i=R_i`, their three generator characters are

| Function | Character |
|---|---|
| `1` | `(+,+,+)` |
| `R_ab` | `(-,-,+)` |
| `R_ac` | `(-,+,-)` |
| `R_ad` | `(+,-,-)` |
| `R_bc` | `(-,+,+)` |
| `R_bd` | `(+,-,+)` |
| `R_cd` | `(+,+,-)` |

They are pairwise distinct. Each actual `D_e` in (1) commutes with these
measure-preserving transformations, since all of its kernels and original
integration laws are invariant. Therefore its compression to the span
of the seven active functions is diagonal in this character basis.

The range of `R_e=K_(n_e)D_e^*` is contained in this seven-dimensional
space. It follows that its nonzero eigenvalues are

\[
\lambda_{e,i}=\theta_i^{n_e}
                 \langle\phi_i,D_e\phi_i\rangle_\mu,
\quad i=0,\ldots,6,                                     \tag{9}
\]

where `theta_0=1`, together with 25 zeros. The possible map from the
orthogonal complement into the active space changes neither this list
nor traces of powers. This proves the needed real-spectrum property for
these actual transfers; it is not a general PSD claim.

## 4. Exact coefficient certificate for every k>=4

The only nonzero cubic moments
`M_ijk=E_mu phi_i phi_j phi_k` are

\[
M_{000}=1,\qquad M_{0ii}=1\ (i>0),
\]

together with their permutations and the four distinct centered triples

\[
M_{123}=M_{145}=M_{246}=1/2,\qquad M_{356}=-1/2.
\tag{10}
\]

For an edge-mode assignment
`a=(a_ab,a_ac,a_ad,a_bc,a_bd,a_cd)` in `{0,...,6}^6`, put

\[
c(a)=M_{a_{ab}a_{ac}a_{ad}}
     M_{a_{ab}a_{bc}a_{bd}}
     M_{a_{ac}a_{bc}a_{cd}}
     M_{a_{ad}a_{bd}a_{cd}}.
\]

There are exactly 235 assignments with nonzero `c(a)`. Define the explicit
dyadic rational coefficients

\[
b_{e,i,j}=\sum_{\substack{a_e=i\\a_{ab}=j}}
c(a)\theta_{a_{ac}}^9\theta_{a_{ad}}^4
     \theta_{a_{bc}}\theta_{a_{bd}}^4\theta_{a_{cd}}.
\tag{11}
\]

Expanding the actual kernels (8) in the finite original integral proves

\[
\boxed{\lambda_{e,i}(k)=\sum_{j=0}^6b_{e,i,j}\theta_j^k.}
\tag{12}
\]

This is an exact multiplication-tensor identity, with every cubic moment
from the stated original law. The coefficient arrays are included in the
JSON certificate. They are not adjustable sources.

### The ab transfer and its negative eigenvalue

For `e=ab`, only `b_(ab,i,i)=q_i` can be nonzero. Direct rational
evaluation of (10)--(11) gives

\[
1<q_0<1+2^{-23},\qquad
-2^{-117}<q_1<-66554167313/2^{154}<0,
\]

\[
2^{-25}<q_3<2^{-23},\qquad q_2,q_4,q_5,q_6>0.              \tag{13}
\]

These are the actual sources at `u=4,r=l=1,h=8` from the question.
The verifier independently replays the complete 7-by-7 compressed source
matrix using literal sums over the original 32 states:

\[
g_i(c,d)=\mathbb E_x\phi_i(x)K_1(x,c)K_4(x,d),
\quad
\widetilde g_i(c,d)=\mathbb E_x\phi_i(x)K_9(x,c)K_4(x,d),
\]

\[
\mathbb E_{c,d}K_1(c,d)\widetilde g_i(c,d)g_j(c,d)
=q_i\mathbf1_{i=j}.                                      \tag{14}
\]

Original-measure composition `K_8 K_1=K_9` gives
`widetilde g_i=A_c^8 g_i`. The program verifies that composition and
`T^2=K_1` directly as integer matrix sums.

For every `k>=4`, choose `rho=q_0`, `w=2^(-4k)q_3`, and
`z=2^(-128k)q_1`. The other four centered eigenvalues are positive. Also

\[
0<-z/w<2^{-124k-92}<1/4,
\quad 0<w<1,
\quad w>2^{-(4k+25)}.
\]

Lemma 2 therefore gives

\[
F(k)^2-\operatorname{tr}(R_{ab}(k)^2)>2^{-(4k+25)}.
\tag{15}
\]

In particular, the transfer has a **strictly negative eigenvalue for
every k>=4**. Similarity to a PSD matrix would be false even in this
certified all-sheet comparison.

### The other five edge transfers

For `e!=ab`, define finite coefficient bounds

\[
L_{e,i}=b_{e,i,0}+\sum_{j=1}^6\min(0,b_{e,i,j})\theta_j^4,
\quad
U_{e,i}=b_{e,i,0}+\sum_{j=1}^6\max(0,b_{e,i,j})\theta_j^4.
\tag{16}
\]

Since `0<=theta_j^k<=theta_j^4` for every `k>=4`, these give
`L_(e,i)<=lambda_(e,i)(k)<=U_(e,i)` without an asymptotic or numerical
inference. Rational evaluation of (11) proves the following finite
certificate for **each** of `e=ac,ad,bc,bd,cd`:

| Mode | Exact bounds needed |
|---|---|
| constant, `i=0` | `L_(e,0)>=1` |
| paired positive mode, `i=3` | `2^-60<L_(e,3)<=U_(e,3)<1` |
| only potentially negative mode, `i=1` | `L_(e,1)>-2^-200` |
| `i=2,4,5,6` | `L_(e,i)>0` |

All 35 intervals are written as exact dyadic fractions in the JSON
certificate. Equations (10), (11), and (16) provide the complete finite
arithmetic recipe for checking each entry. The possible negative mode
has absolute value less than one quarter of the paired positive mode,
because `2^-200<2^-60/4`. Lemma 2 now gives, uniformly in `k>=4`,

\[
F(k)^2-\operatorname{tr}(R_e(k)^2)>2^{-60}
\quad(e\ne ab).                                         \tag{17}
\]

## 5. The all-sheet conclusion and its limit

Set

\[
\delta_e(k)=
\begin{cases}2^{-(4k+25)},&e=ab,\\2^{-60},&e\ne ab.\end{cases}
\]

For every integer `k>=4`, every sheet count `M>=1`, every edge `e`, and
every permutation `sigma` placed on that single edge, let `L` be the
number of sheets in permutation cycles of length at least two. Combining
(3)--(5), (15), and (17) proves

\[
\boxed{
Z_{e,\sigma}(k)\le F(k)^M
\left(1-\frac{\delta_e(k)}{F(k)^2}\right)^{L/2}.
}
\tag{18}
\]

For a nonidentity permutation, `L>0` and this is strictly smaller than
`F(k)^M`. The identity permutation has exactly `F(k)^M`, as required.
The certificate also directly sums the `32^4=1,048,576` original
four-variable assignments at `k=4`, independently checking the common
trace `F(4)>1` against all six coefficient decompositions.

The transport implementation is separately checked on the nonuniform law
`mu=(1/3,2/3)` with `T=(I+Pi)/2`: for each of the six possible edges, a
literal 12-variable sum for a three-cycle sheet permutation agrees with
`tr(R_e^3)` at the boundary tuple `(3,1,1,1,1)`. The same literal check
covers `T=Pi` equality and the disconnected root `T=I`; in the latter
case it gives `F=45/4` and `Z=47385/64` under that unchanged original law.
There are eight such cover controls, with 4096 assignments each. They
validate the normalization and orientation of (3), rather than enlarge
the theorem's host scope.

The new mechanism uses a small **collective second-moment budget**, not
modewise positivity. Its precise scope is every one-edge cover of the
displayed actual host and the entire integer family `k>=4`. Arbitrary
multi-edge permutations need additional interactions between transfers;
they do not factor into (3). Arbitrary hosts also need not have the
character decomposition used in (9). Neither of those unresolved points
is treated as routine compatibility or as a proved theorem.
