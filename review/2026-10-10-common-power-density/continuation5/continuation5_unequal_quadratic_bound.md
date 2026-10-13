# A quadratic certificate for genuinely unequal projection stars

## Scope

This note proves a lower estimate valid for every actual finite root and
arbitrary original-law orthogonal projection. Its inputs are two-field
correlations, an ordinary field variance, and an entry bound on one
actual power. It supplies a checkable sufficient condition for an
individual unequal-star contraction; it does not prove that condition
universally.

The estimate gives an exact positive comparison for the frozen PR60
weighted eight-state host at a tuple outside all reflection families.
Its coarse square has three positive values on the entire centered
space, so the new common-cone theorem for at most two coarse centered
values does not automatically cover this example.

No novelty claim is inferred from this derivation. The unrestricted
common-power density target remains unresolved.

## 1. Universal lower estimate

Use the original positive probability `pi`, an actual nonnegative
self-adjoint Markov root `S`, its square `B=S^2`, and a projection
`Q=Q*=Q^2` of rank `d>0`. Set, on `E=ran Q`,

`R_t=Q D_(1_(.=t)/pi_t)Q`, `M_s(t)=(B^s R)_t`.

Every `M_s(t)` is PSD and `E_pi M_s=I_E`. Define the quadratic quantities

`g_sz=E_pi tr(M_s M_z)`,

`v_xy=E_pi tr((M_x-M_y)^2)`,

and the explicit kernel maximum `m_z=max_(i,t) B^z(i,t)`.
Then

\[
\boxed{
J_{x,y,z}\ge
\frac{g_{xz}^2+g_{yz}^2}{2d}-\frac{m_z}{2}v_{xy}.}
\tag{1}
\]

The three indices can be permuted, so the maximum of the three resulting
bounds is also valid. Rank zero is trivial.

### Proof

For real symmetric matrices `U,V,W`, trace cyclicity and transposition
imply

`2 tr(UVW)=tr(U^2 W)+tr(V^2 W)-tr((U-V)^2 W)`.

Apply this pointwise to `M_x,M_y,M_z` and average under the original law.
The paired-star Cauchy--Schwarz proof, which uses `E M_z=I_E`, gives

`E tr(M_x^2 M_z)>=g_xz^2/d`,

and the corresponding bound with `x` replaced by `y`.

Because every entry `B^z(i,t)` lies in `[0,m_z]`, compression of the
actual multiplication operator gives

`0 <= M_z(t)=Q D_(B^z(.,t))Q <= m_z I_E`.

The matrix `(M_x-M_y)^2` is PSD. The pairwise PSD trace inequality
therefore bounds the remaining term by `m_z v_xy`. This proves (1).
It does not apply an operator order to a product of two different PSD
matrices, and it does not assume that the trace of three PSD matrices
is nonnegative.

### Explicit original-source spectral inputs

For a complete original-law orthonormal eigenbasis of `B`, write
`B phi_i=lambda_i phi_i`, `phi_0=1`, and
`c_i=||Q D_phi_i Q||_HS^2`. Then

\[
g_{sz}=d+\sum_{i>0}\lambda_i^{s+z}c_i,
\qquad
v_{xy}=\sum_{i>0}(\lambda_i^x-\lambda_i^y)^2c_i.
\tag{2}
\]

All `c_i` are squared norms of the actual compressed multiplication
operators; every eigenvalue, including zero and additional stationary
modes, is included. Formula (2) follows from self-adjoint action of `B`
on each scalar matrix coefficient. Equivalently, the quadratic inputs
can be evaluated directly by original-law matrix multiplication, with
no eigensolver or cubic star integral.

A sufficient condition for `J_xyz>=d` is therefore

\[
m_z v_{xy}\le
\frac{g_{xz}^2+g_{yz}^2-2d^2}{d}.
\tag{3}
\]

This condition is not asserted for all hosts. It is an independently
computable quadratic certificate and supplies a quantitative lower
bound even when (3) fails.

The condition is not necessary. On the strictly positive cancellation
family from `continuation5_unequal_cancellation.md`, at the exact parameter
`t=1/16`, all three orientation bounds in (1) are strictly negative,
while the exact averaged star lies between two and nine. The checker
verifies those three signs by rational arithmetic. Thus maximizing the
three orientations does not supply a universal proof of `J>=d`.

## 2. Exact three-coarse-band certificate beyond reflection

Retain the frozen PR60 primary example, using the same original measure
and actual root; no host is replaced by a nonrealizable PSD kernel.
The coarse law and flow data are

`pi=(3/5,1/5,1/10,1/10)`, `s=(60,20,10,10)`,

\[
M=\begin{pmatrix}59&1&0&0\\1&18&1&0\\0&1&8&1\\0&0&1&9\end{pmatrix},
\qquad
S_0(i,j)=\frac{100M_{ij}}{s_i s_j},
\qquad S=\frac{31}{32}S_0+\frac1{32}\Pi.
\]

Put `f=(1,0,-3,-3)` and

\[
Q=\Pi+\frac5{12}f\otimes f
=\begin{pmatrix}
17/12&1&-1/4&-1/4\\
1&1&1&1\\
-1/4&1&19/4&19/4\\
-1/4&1&19/4&19/4
\end{pmatrix}.
\]

Original weighting gives `E_pi f=0`, `E_pi f^2=12/5`, so `Q` is a
rank-two projection. It has negative entries and does not commute with
`S`; for example `(Sf)(1)=-31/320`, while `f(1)=0`.

The actual fine root is

`mu(i,a)=pi_i/2`,

`T((i,a),(j,b))=S(i,j)+(1/128)Q(i,j)ab`,

`p=512/4499`, `W=pT`, `beta=1/16384`.

Its exact minimum and maximum are `min T=3/128` and
`max T=4499/512`, so `0<W<=1`. Every original weighted row of `W`
is `p`. The original sign average gives

`T^(2n)=S^(2n)+beta^n Q ab`.

### Why the centered spectrum really has more than two values

The coarse transition of `S0` is an irreducible tridiagonal reversible
matrix, with minimum diagonal holding probability `4/5`. Hence
`S0=(4/5)Id+(1/5)R` for a self-adjoint nonnegative Markov operator `R`,
so every eigenvalue of `S0` is at least `3/5`. Conjugation by the square
roots of the positive stationary weights produces an irreducible real
symmetric tridiagonal matrix. The eigenvector recurrence, starting at
its first coordinate, makes each eigenspace at most one-dimensional;
therefore all four eigenvalues are distinct. The Markov eigenvalue one
is simple. Thus the entire centered space of `S^2` has three distinct
positive eigenvalues, all at least `(93/160)^2`.

The signed channel square contributes `beta` twice and zero twice,
with `beta<(93/160)^2`. The fine square consequently has five distinct
values on its entire seven-dimensional centered space, including zero.

### The genuinely unequal star and its quadratic certificate

Choose the target tuple

`(k,u,r,l,h)=(1,1,2,1,6)`,

so the six powers in the fixed order are `(1,8,1,2,1,1)`. The star
centered at `c` has exponents `(8,2,1)`. Apply (1) with
`(x,y,z)=(2,8,1)` and `d=2`. Exact original-law arithmetic proves

\[
\boxed{\frac{g_{2,1}^2+g_{8,1}^2}{4}
       -\frac{m_1}{2}v_{2,8}>\frac{24}{5}>2.}
\tag{4}
\]

The certificate stores the exact rational values of all four quadratic
inputs and the lower bound. For orientation only, that lower bound is
approximately `4.8159043478`, while the direct original star average
is approximately `8.3034656781`; these decimals do not establish (4).

The other three complementary stars are `(1,1,1)`, `(1,2,1)`, and
`(1,8,1)`, all covered by the paired-star proof. Every quadrilateral is
covered by the arbitrary-projection quadrilateral lemma. Original sign
averaging leaves exactly the seven cycles, of weights
`(11,3,10,4,5,11,12)` in the order
`abc,abd,acd,bcd,abcd,abdc,acbd`.

The exceptional star is complementary to `abd`, the weight-three cycle.
Consequently,

\[
\boxed{
F(T)\ge F(S)+\frac{24}{5}\beta^3
 +2(\beta^4+\beta^5+\beta^{10}+2\beta^{11}+\beta^{12}).}
\tag{5}
\]

This is a quantitative coarse-density comparison on an exact actual
host with three coarse centered bands, a signed projection, and a tuple
outside all three reflection families. It is not a proof for arbitrary
projections or arbitrary three-band hosts. No new global density result
is claimed. The independently known coarse bound, or the exact finite
coarse density certificate included here, gives `F(S)>1` for this host.

## Verification

`continuation5_unequal_quadratic_verify.py` uses only Python rational
arithmetic. It checks actual weighted roots and the projection, the
quadratic bound and its exact gap above `24/5`, direct star integration,
the seven original-law cycle contractions, exact original-sign power
transport, and both full fine and coarse target densities. It checks
the displayed five-band factorization without rounding eigenvalues.
These finite checks support the instance; the universal estimate is
proved in Section 1.
