# Unequal projection stars with a constant trace after one actual step

## Verdict and scope

This note proves the arbitrary-exponent averaged projection-star inequality
under a new algebraic condition. The coarse actual Markov square may have
arbitrarily many centered spectral values, its projection need not commute
with it or fix constants, and individual projection triangles may be
negative. The condition is that the projection has rank two and the
diagonal of the projection becomes constant after one step of the actual
square. This does not prove the unrestricted density target or the
unrestricted projection-star inequality.

The displayed twelve-state host satisfies the density inequality for
every six positive exponents. Its coarse bound uses the previously
proved common-order convex-TP2 theorem, explicitly identified below;
the new projection calculation transfers that bound to the fine host.

All measures, kernels, powers, and traces below use the indicated original
probability measure. There is no change to a measure weighted by a
projection diagonal. No novelty claim is inferred from this proof.

## 1. Exact theorem

Let `pi` be a positive probability on a finite set. Let `S` be a
nonnegative self-adjoint Markov kernel, let `B=S^2`, and let `Q=Q*=Q^2`
be an original-law orthogonal projection of rank two. On `E=ran Q`, set

\[
 R_t=QD_{\mathbf 1_t/\pi_t}Q\big|_E,
 \quad M_s(t)=(B^sR)_t,
 \quad q(t)=Q(t,t).
\]

Assume the explicitly linear condition

\[
                         Bq=2\mathbf 1.                 \tag{1}
\]

In particular, (1) holds for every balanced projection `Q(t,t)=2`.
It also allows nonconstant diagonals whose variation lies in `ker B`.
For all positive integers `x,y,z`,

\[
\begin{split}
J_{x,y,z}
&:=\mathbb E_\pi\operatorname{tr}(M_xM_yM_z)\\
&=2+\mathbb E_\pi\operatorname{tr}(X_xX_y)
    +\mathbb E_\pi\operatorname{tr}(X_xX_z)
    +\mathbb E_\pi\operatorname{tr}(X_yX_z)\ge2,
\qquad X_s=M_s-I_E.                                    \tag{2}
\end{split}
\]

This is an exact identity, retaining the entire quadratic surplus, not
an estimate of its size by a mixing constant.

### Proof

The original-law identities are

\[
R_t\succeq0,\quad \mathbb E_\pi R_t=I_E,
\quad \operatorname{tr}R_t=Q(t,t).
\]

Consequently `M_s>=0`, `E M_s=I_E`, and
`tr M_s=B^s q=2` for every `s>=1`, by (1) and the Markov property.
Thus each `X_s(t)` is a real symmetric traceless two-by-two matrix.

For two such matrices `U,V`, direct multiplication gives

\[
                    UV+VU=\operatorname{tr}(UV)I_2.       \tag{3}
\]

For three real symmetric matrices, the trace of their product is
invariant under all permutations: cyclicity gives cyclic permutations,
and transposition gives reversal. If also `Z` is traceless, (3) yields

\[
2\operatorname{tr}(UVZ)
=\operatorname{tr}((UV+VU)Z)
=\operatorname{tr}(UV)\operatorname{tr}Z=0.               \tag{4}
\]

Expand `tr[(I+X_x)(I+X_y)(I+X_z)]`. The linear terms vanish and (4)
annihilates the cubic term pointwise. This proves the equality in (2).

For positivity of its three quadratic terms, use the original-law
Hilbert space of matrix fields with scalar product
`<U,V>=E_pi tr(U(t)V(t))`. The actual kernel `B` acts on each real
matrix coefficient. Since `B=S^2` is self-adjoint and PSD,

\[
\mathbb E_\pi\operatorname{tr}(X_sX_t)
=\langle R-I_E,B^{s+t}(R-I_E)\rangle\ge0.                \tag{5}
\]

This uses positivity of one operator on a Hilbert space. It does not
assert pointwise nonnegativity of the product of three PSD matrices.

### Spectral formula and equality

For a complete original-law orthonormal eigenbasis of `B`, choose
`phi_0=1`, `lambda_0=1`; include all other eigenvectors, including further
stationary modes and zero modes. Put

\[
 C_i=QD_{\phi_i}Q\big|_E,\qquad c_i=\|C_i\|_{HS}^2.
\]

Then (2) is equivalently

\[
\boxed{J_{x,y,z}=2+
\sum_{i>0}
(\lambda_i^{x+y}+\lambda_i^{x+z}+\lambda_i^{y+z})c_i.}     \tag{6}
\]

Zero modes contribute zero because all exponents are positive. Formula
(6) is valid for disconnected roots and squares. Equality in (2), for
one and therefore every positive triple, is equivalent to

\[
                 (BR)_t=I_E\quad\hbox{for every }t.       \tag{7}
\]

Indeed, all coefficients multiplying `c_i` with `lambda_i>0` are
strictly positive. The remaining modes are annihilated by `B`. Rank zero
has identically zero star integrals; it does not require condition (1).

## 2. Consequence for an actual projection channel

Suppose in addition that `H=H*`, `|H(i,j)|<=S(i,j)`, and
`H^2=beta Q`, `beta>=0`. With original fine measure
`mu(i,a)=pi_i/2`, define the actual root

\[
 T((i,a),(j,b))=S(i,j)+abH(i,j),\quad a,b\in\{-1,1\}.
\]

It is nonnegative, symmetric, and Markov. Averaging the original uniform
sign at every composition gives

\[
                 T^{2n}=S^{2n}+ab\,\beta^nQ.              \tag{8}
\]

For arbitrary six positive exponents `n_e` on the edges of `K4`, expand
the density using (8) and average its four independent signs. The
surviving nonempty sign selections are exactly the four triangles and
three quadrilaterals. For a selected triangle, the complementary three
edges form a star, whose contraction is (2). For a selected quadrilateral,
the arbitrary-projection quadrilateral lemma applies to its two remaining
actual PSD Markov powers. That lemma gives a lower bound `rank Q=2`.

Writing `C` for the seven cycles and `q_D=sum_{e in D} n_e`, one obtains

\[
\boxed{F(T;n)\ge F(S;n)+2\sum_{D\in C}\beta^{q_D}.}       \tag{9}
\]

No equal-leg, reflection, exponent-order, or common-cone condition is
needed. The four triangle contributions can be strengthened by their
exact quadratic surpluses in (2).

For completeness, the quadrilateral lemma used here is

`E Q_ab Q_bc Q_cd Q_da L_ac M_bd >= rank Q`

for independent nonnegative PSD Markov `L,M`. Define
`G_ac=E_bd M_bd Q_ab Q_ad Q_cb Q_cd`. Since `M_bd>=0`, `G` is a positive
mixture of rank-one PSD kernels. Pairing `L-Pi>=0` with `G>=0` first
removes `L`. The projection identity integrates the opposite vertices
and leaves `<M,Q o Q>`, where `o` denotes the entrywise product. The
Schur square `Q o Q` is PSD, so pairing `M-Pi>=0` with it removes `M`.
The remaining sum `E Q_ab^2` is `rank Q`. Schur products and operator
products are distinct throughout this argument.

Formula (9) is a comparison with the coarse density. It becomes a proof
of `F(T)>=1` only when the corresponding coarse density is itself
proved at least one. It does not supply such a proof for every `S`.

## 3. Exact twelve-state example with seven centered bands

Use six coarse states, with

\[
\pi=(1/4,1/12,1/4,1/12,1/4,1/12).
\]

Let `g(i)=floor(i/2)` take values `0,1,2`, and define

\[
 Q(i,j)=q_{g(i),g(j)},\qquad
 q=\begin{pmatrix}2&1&-1\\1&2&1\\-1&1&2\end{pmatrix}.
                                                               \tag{10}
\]

Each group has original mass `1/3`. Direct multiplication gives
`Q^2=Q`, `rank Q=2`, and `Q(i,i)=2`. Geometrically, (10) is twice the
Gram matrix of unit vectors at angles `0,60,120` degrees, repeated in
pairs; the rational matrix (10) suffices for every check. It is signed:

`Q(0,2) Q(2,4) Q(4,0)=-1`.

It is noncentral:

`Q1=(2/3,2/3,4/3,4/3,2/3,2/3)`.

Define the relative root

\[
S_0=\begin{pmatrix}
23/6&1/2&0&0&0&0\\
1/2&9&1/2&0&0&0\\
0&1/2&89/24&3/8&0&0\\
0&0&3/8&75/8&1/2&0\\
0&0&0&1/2&11/3&1/2\\
0&0&0&0&1/2&21/2
\end{pmatrix},\quad
S=\frac{15}{16}S_0+\frac1{16}\Pi.                            \tag{11}
\]

The adjacent original conductances `pi_i pi_j S0(i,j)`, in path order,
are `(1/96,1/96,1/128,1/96,1/96)`.
The diagonal entries in (11) provide exactly the remaining mass at each
vertex, so `S0` and `S` are actual self-adjoint Markov kernels. Set

\[
H=Q/64,\quad \beta=1/4096,\quad
\mu(i,a)=\pi_i/2,\quad p=16/159,\quad W=p(S+abH).           \tag{12}
\]

The exact extrema are

`min T=3/64`, `max T=159/16`, `min W=1/212`, `max W=1`.

Consequently (12) is a strictly positive admissible host. The certificate
also verifies `max T^2>4`, so the example is not presented as a mere
small-entry instance. `S` and `Q` do not commute.

The coarse transition of `S0` is an irreducible reversible tridiagonal
matrix. Its minimum diagonal holding probability is `3/4`, hence
`S0=(3/4)I+(1/4)R` for an actual reversible Markov `R`; every eigenvalue
is at least `1/2`. The symmetric Jacobi conjugate has nonzero neighboring
off-diagonal entries. Its elementary eigenvector recurrence makes every
eigenspace at most one-dimensional. Thus all six eigenvalues are
distinct, and the Markov eigenvalue one is simple. It follows that `S^2`
has five distinct positive centered eigenvalues, each at least
`(15/32)^2`. The fine square adds `beta` with multiplicity two and zero
with multiplicity four. It has **seven distinct values on its entire
eleven-dimensional centered space**. A zero band is counted as a band.

All five coarse centered bands interact with the projection. One way to
certify this without approximate eigenvectors is to use the centered
source functions

`f0=(2,2,-1,-1,-1,-1)`, `f2=(-1,-1,-1,-1,2,2)`.

Both are linear combinations of actual functions `Q(i,.)Q(.,j)` and
the constant function. The exact verifier shows that the spans of their
successive `S0` images together with the constant function have full
rank six. In fact, the six rows
`1,f0,f2,S0 f0,S0 f2,S0^2 f0` have determinant `-9/4096`.
Thus no nonconstant eigenvector is orthogonal to every
compressed source coefficient. Every coefficient `c_i` in (6) for a
coarse centered eigenvector is nonzero.

The coarse bound for this particular host follows from an explicit prior
input: Corollaries 2 and 3 of
[`tp2-class.md`](../tp2-class.md), the frozen common-order convex-TP2
theorem from this consultation. In the displayed path order, `S0` is
nonnegative and TP2. Its tridiagonal support means that a nonzero crossed
term in a two-by-two minor forces the rows and columns to be the same
adjacent pair. Those five principal minors are

`137/4, 265/8, 277/8, 273/8, 153/4`,

all positive; the other minors have zero crossed term and are
nonnegative. The exact verifier checks all `binom(6,2)^2=225` minors.
Both `S0` and `Pi` are bistochastic for the original `pi`. Since
`S0 Pi=Pi S0=Pi`, every coarse power is

\[
 S^{2n}=\left(\frac{15}{16}\right)^{2n}S_0^{2n}
       +\left[1-\left(\frac{15}{16}\right)^{2n}\right]\Pi.
                                                               \tag{13}
\]

Weighted Cauchy--Binet keeps `S0^(2n)` TP2 in the same order. The cited
base-density theorem for six independent kernels in this common convex
class therefore gives `F(S;n)>=1` for every six positive exponents.
Together with (9), this proves for the actual twelve-state host (12)

\[
\boxed{F(T;n)\ge1+2\sum_{D\in C}\beta^{q_D}>1
       \quad\text{for every }n_e\ge1.}                         \tag{14}
\]

This application does not assume that a convex mixture is itself TP2,
or that the fine root has a common TP2 ordering. It uses the stated
coarse theorem and the original-law binary-channel comparison.

The checker evaluates the full original twelve-state density at
`(k,u,r,l,h)=(3,1,1,1,1)` and `(1,1,2,1,6)`, both outside the three
previous reflection families. It verifies (8), all seven cycle
contractions, their exact sum, the strengthened form of (9), and
`F(T)>F(S)>1` by rational arithmetic. These two complete finite sums
independently check the host construction and formula (9); the proof of
the all-exponent bound (14) is the preceding TP2 and projection argument.

## 4. Why the one-step condition is genuinely broader than balance

Refine each coarse state of the example into two states of conditional
weights `nu=(1/3,2/3)`. Pull back `S` so that it ignores this new
coordinate, retaining original measure `pi_i nu_a`. Define

`Q'((i,a),(j,b))=(3/2) Q(i,j)` when `a=b=1`, and zero otherwise.

Then `Q'` is an original-law rank-two projection. Its diagonal takes
the two values zero and three. The actual pulled-back square satisfies
`B' diag(Q')=2`, since the conditional average of each diagonal is two.
For every positive power the projected field is the corresponding
unrefined field transported to this range. This proves that (1) includes
actual zero-band trace variation, with no change of the original law.
The exact verifier checks the projection, actual root, one-step
condition, zero modes, and star identity for this refinement.

This construction should not be confused with changing an existing law
to `nu_i=pi_i Q(i,i)/2`. Under that change the old relative kernel `B`
has new row sum `(Bq)(i)/2`, which need not be one. Its powers also use a
different composition measure. There is no reduction of an arbitrary
rank-two source to this theorem by that normalization.

## 5. Exact realization of general PSD fields (structural lemma)

This lemma explains the freedom of actual projection sources after a
refinement. It is useful for testing the unrestricted projection-star
problem, but by itself is not a solution or a positive inequality.

Let `L_i` be real `d` by `m` matrices, let
`G=sum_i pi_i L_i L_i^T` be positive definite, and write their columns
as `l_ij`. Put

\[
C_i=G^{-1/2}L_iL_i^TG^{-1/2},\qquad
\mu(i,j)=\pi_i/m,
\quad Q((i,j),(k,l))=m\,l_{ij}^TG^{-1}l_{kl}.             \tag{15}
\]

The feature rows `sqrt(m) G^{-1/2}l_ij` have original-law Gram matrix
`I_d`. Hence (15) is an original-law rank-`d` orthogonal projection.
Pull back the actual coarse root by `S'((i,j),(k,l))=S(i,k)`; this is
again an actual self-adjoint nonnegative Markov root. In the feature
coordinates the conditional average of its rank-one source over `j`
is exactly `C_i`. For each `s>=1`,

\[
((S'^2)^sR)_{(i,j)}=(B^sC)_i.                              \tag{16}
\]

All expectations on the left of (16) use `mu`; those on the right use
the original `pi`. Thus averaged projection-star traces and the coarse
PSD-field traces agree exactly for positive exponents. Rational
`pi,L_i` give rational `Q` in (15), even though the coordinate map uses
`G^{-1/2}`. One may evaluate the coarse triple trace rationally as
`tr(G^-1 U_x G^-1 U_y G^-1 U_z)`, where `U_s=B^s[L L^T]`.

Every finite PSD field with mean `I_d` admits such a decomposition,
padding columns to a common `m` if necessary. In particular, arbitrary
PSD mean-one fields cannot be dismissed as unrealizable in the
projection-star problem. A failure of that auxiliary star inequality
would still not by itself be a failure of the original six-power density
target, nor automatically satisfy a nonzero binary channel domination
condition `|H|<=S`.

## Verification

`continuation6_unequal_balanced_verify.py` uses only standard-library
exact rational arithmetic and imports the unchanged weighted-kernel
arithmetic from the frozen continuation4 packet. It does not run the
old packet's restricted host checker. Its JSON records source hashes,
actual root checks, full original-law densities, the seven-cycle
identity, one-step trace flattening, zero and stationary modes, and
the rank calculation for interaction of all five coarse bands. It also
records the 225 coarse TP2 minor checks and the hash of the explicitly
used prior coarse theorem; the minor checks alone are not a proof of
that theorem.
