# Uniform flat codimension-one projections: an all-rank contraction

**Verdict.** This is a restricted all-rank proof of the actual averaged
projection-star inequality. It does not solve the unrestricted density
target. It supplies a uniform codimension-one family beyond the general
balanced-rank-ten and source-cap criteria proved in this continuation.
No novelty claim is made.

## 1. Exact uniform-measure identity

Let the original law be uniform on `n` states. Let `S` be any actual
nonnegative real self-adjoint Markov root, let `B=S^2`, and let `K_j=B^j`
be its relative kernels under this ORIGINAL law. Pick signs `f_i in
{-1,1}` and put

`Q=I-f tensor f`, so `Q(i,j)=n 1_(i=j)-f_i f_j`.

Since `E f^2=1`, this is an original-law orthogonal projection of rank
`n-1`, with constant diagonal `n-1`. The sign function need not be
centered and need not be an eigenvector of `S`.

For any positive integers `x,y,z`, define its actual averaged star by

\[
J_{xyz}=\mathbb E_{a,b,c,t}
 Q(a,b)Q(b,c)Q(c,a)K_x(a,t)K_y(b,t)K_z(c,t).
\]

Put

\[
L_{xyz}=\mathbb E_{a,t}K_x(a,t)K_y(a,t)K_z(a,t),
\qquad \tau_{st}=\operatorname{tr}(B^{s+t}).
\]

Then the exact identity is

\[
\boxed{J_{xyz}=(n-3)L_{xyz}+\tau_{xy}+\tau_{xz}+\tau_{yz}-1.}\tag{1}
\]

**Proof with the uniform factors retained.** Write the relative identity
kernel as `I_ab=n 1_(a=b)`. Because `f_i^2=1`, the triangle product is
unchanged by the signs and equals

\[
I_{ab}I_{bc}I_{ca}
 -(I_{ab}I_{bc}+I_{bc}I_{ca}+I_{ca}I_{ab})
 +(I_{ab}+I_{bc}+I_{ca})-1.
\]

The three-identity term integrates to `n L_xyz`: three original weights
`n^-3` multiply `n^3` on the diagonal, leaving a sum over `a`, whereas
`L_xyz` uses the average over `a`. Each two-identity term integrates to
`L_xyz`, so their combined contribution is `(n-3)L_xyz`. For a
one-identity term, average the third leaf using Markovness, then compose
the two remaining kernels with the original uniform law. The result is
respectively `tr B^(x+y)`, `tr B^(x+z)`, or `tr B^(y+z)`. The empty
term integrates to one by the three Markov rows. This proves (1).

No change of conditional probability or unweighted matrix composition is
hidden in the coefficients.

## 2. A Schur-product lower bound

The entrywise product `K_y circ K_z` is a PSD kernel by the Schur product
theorem. Also `K_x-Pi` is a PSD operator, since `B` is PSD and Markov.
The original-law Hilbert--Schmidt pairing of two PSD operators is
nonnegative. Consequently

\[
\begin{aligned}
L_{xyz}
 &=\langle K_x,K_y\circ K_z\rangle_{HS}\\
 &\ge\langle\Pi,K_y\circ K_z\rangle_{HS}
 =\langle K_y,K_z\rangle_{HS}
 =\operatorname{tr}(B^{y+z})\ge1.
\end{aligned}\tag{2}
\]

The same argument applies to each choice of the omitted exponent, so
`L_xyz>=max(tau_xy,tau_xz,tau_yz)`. The Schur product in (2) is an
entrywise product; the final trace uses ordinary operator composition.
Only a pairing of TWO PSD operators is assigned a nonnegative trace.

For `n>=3`, equation (1) therefore proves the quantitative bound

\[
\boxed{J_{xyz}\ge n-1
 +(n-3)\max_{s<t}(\tau_{st}-1)
 +\sum_{s<t}(\tau_{st}-1)\ge n-1.}\tag{3}
\]

The pairs in (3) are the three labeled pairs of exponent positions, also
when numerical exponent values repeat. This theorem has no rank,
spectral-band, commutation, or exponent-order restriction within the
specified uniform flat-complement family. For `n>=3`, equality holds
exactly when `B=Pi`, equivalently `S=Pi`: equality in (3) forces a
positive-power trace to be one, so all centered eigenvalues vanish.

For `n=2`, the rank-one projection has actual one-dimensional sources
`R_i=1`, so `J=1` for every root. For `n=1`, the projection has rank zero
and `J=0`. These boundaries are handled separately because the
coefficient `n-3` in (1) is then negative.

## 3. A complete actual rank-twelve example

Let `n=13`, original `pi_i=1/13`, and let `L_path` be the ordinary
combinatorial Laplacian of the path `0,...,12`. Set

\[
P_0=I-\frac1{64}L_{path},\qquad
S_0(i,j)=13(P_0)_{ij},\qquad
\delta=\frac1{1024},\qquad
S=(1-\delta)S_0+\delta\Pi.
\]

Here `P0` is an ordinary row-stochastic matrix and `S0,S` are relative
kernels. Choose `f_i=(-1)^i` and `Q(i,j)=13 1_(i=j)-f_i f_j`.
Then `rank Q=12`, `Q(i,i)=12`, and
`Q1(i)=1-f_i/13` is neither the zero vector nor the constant one vector.
The projection does not commute with `S`; the exact checker records a
nonzero commutator entry. Every triangle on three distinct states has
projection product `-1`.

On the 26 fine states `(i,sigma)`, with ORIGINAL law `mu=1/26`, put

\[
\alpha=\frac1{24576},\quad\beta=\alpha^2,\quad
T((i,\sigma),(j,\tau))=S(i,j)+\sigma\tau\alpha Q(i,j),
\quad p=\frac{65536}{837933},\quad W=pT.\tag{4}
\]

The bound `|Q|<=12` gives `|alpha Q|<=delta/2`, while `S>=delta`.
Thus `T` is nonnegative and symmetric. Averaging the original sign
variable proves every original-weighted row sum equals one. Direct exact
calculation gives

`min T=23/24576`, `max T=837933/65536`,

so `0<W<=1` and every original-weighted row sum of `W` is exactly the
positive `p` in (4). This is one actual admissible host, not a proposed
counterexample. Original sign averaging gives, for every `j>=1`,

\[
T^{2j}((i,\sigma),(k,\tau))
 =S^{2j}(i,k)+\sigma\tau\beta^j Q(i,k).\tag{5}
\]

### Conditions excluded by the example

The minimum holding probability of `P0` is `31/32`; hence every
nonconstant eigenvalue lies in `[15/16,1)`. The reversible tridiagonal
path has strictly positive adjacent entries, so its eigenvalues are
simple. Refresh scales every centered eigenvalue by `1023/1024`.
Consequently the coarse square has twelve distinct positive centered
values, all at least `[(1023/1024)(15/16)]^2`. The fine square adds
`beta` with multiplicity twelve and zero with multiplicity one. Its
ENTIRE centered spectrum therefore has fourteen distinct values,
including zero.

This rank-twelve projection lies outside the balanced-rank-at-most-ten
criterion. It also fails the first-step cap from the Jordan theorem:
if `M_1` is its actual compressed field, then the positive summand at
state zero gives

\[
\lambda_{max}(M_1(0))\ge12(P^2)_{00}>10>4+4\sqrt2,
\]

where `P=(1-delta)P0+delta Pi` is the ordinary transition matrix of `S`.
The checker also verifies that `tr[(M_1(0)-I_E)^3]>0`, so the vanishing
cubic-source hypothesis does not hold. These are failures of sufficient
conditions, while (3) still proves the actual averaged star bound.

### Density transport and its scope

`S0` is TP2 in the displayed path order: every crossed nonzero term in
an ordered two-by-two minor is adjacent and principal, and the positive
holding probabilities make those determinants positive. The checker
verifies all 6,084 ordered minors. The earlier
[convex-TP2 density theorem](../tp2-class.md) applies to all powers of
`S`, because `S` belongs to the finite convex hull of the TP2 Markov
kernels `S0` and `Pi`, and that convex class is closed under original-law
composition. The refreshed kernel itself is not asserted to be TP2.
Thus `F(S;n)>=1` for all six positive exponents by that already proved
restricted theorem.

The new star bound (3), the previously proved quadrilateral projection
lemma, and the exact binary sign expansion then give

\[
F(T;n)\ge F(S;n)+12\sum_{D\in\mathcal C(K_4)}
                       \beta^{\sum_{e\in D}n_e}>1.\tag{6}
\]

All powers in (6) come from the single actual root (4), with the same
original `mu`. Equation (6) covers this host at every admissible target
tuple and every other six-positive-exponent assignment. It does not
extend the uniform flat-complement condition to arbitrary projections
or the coarse convex-TP2 condition to arbitrary roots.

## 4. Exact reproduction

Run `python continuation6_search_codimension_one_verify.py`. It uses
only standard-library integers and `Fraction`. It checks the complete
host (4), all original-law normalizations, the projection and negative
triangle, noncommutation, all TP2 minors, the actual square identity,
and one original four-vertex star integral at `(x,y,z)=(1,2,3)` against
(1)--(3). It also checks the cap obstruction, the nonzero actual cubic,
rank-zero and two-state boundaries, and refresh equality. It does not
enumerate the full 26-state target density; the all-exponent conclusion
(6) is the finite mathematical proof above, with its coarse input named.
