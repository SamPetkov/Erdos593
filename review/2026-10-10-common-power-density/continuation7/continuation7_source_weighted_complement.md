# Weighted flat complements: a uniform contraction beyond balanced trace

**Verdict and scope.** The unrestricted common-power density target is
unresolved. This note proves the actual averaged projection-star
inequality for a specified family of nonuniform original measures and
flat codimension-one projections. The criterion is uniform over all
actual roots and all positive exponent triples; it is not a continuity
radius about a fixed host or a fixed tuple. It permits arbitrarily large
rank, a nonconstant surviving source trace, and actual source norms above
the Jordan cap. It does not reduce arbitrary projections or arbitrary
target roots to this family. No novelty assertion is made.

## 1. Statement under the original law

Let `I` have `n>=4` elements, let `pi_i>0`, `sum_i pi_i=1`, and let `S`
be a real symmetric nonnegative Markov kernel relative to this ORIGINAL
law. Put `B=S^2` and `K_s=B^s`. Choose arbitrary signs `f_i in {-1,1}`
and set

\[
Q=I-f\otimes f,
\qquad Q(i,j)=\frac{\mathbf1_{i=j}}{\pi_i}-f_if_j.
\tag{1}
\]

Here `E_pi f^2=1`, so `Q` is an original-law orthogonal projection of
rank `d=n-1`. There is no requirement that `f` be centered, stationary,
or an eigenfunction of `S`. Let

\[
a_i=\pi_i^{-1}-n,\qquad
\delta=\max_i|a_i|,\qquad
m=n-2-\delta,\qquad M=n+\delta-1.
\tag{2}
\]

The actual fields on `E=ran Q` are

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_E,
\qquad M_s(i)=[B^sR]_i,
\qquad X_s(i)=M_s(i)-I_E.
\tag{3}
\]

Every composition and expectation in this note uses `pi`; in particular
`E_pi R=I_E`. Define

\[
J_{xyz}=\mathbb E_i\operatorname{tr}(M_x(i)M_y(i)M_z(i)).
\tag{4}
\]

**Theorem.** Suppose

\[
\boxed{\delta<n-2,\qquad
\delta^2(n+\delta-1)\le8(n-3)(n-2-\delta).}
\tag{5}
\]

Then, for every positive integer triple,

\[
\boxed{J_{xyz}\ge n-1.}\tag{6}
\]

Equality holds if and only if `S=Pi`. This includes disconnected roots
and roots with additional stationary modes in their squares: those modes
are retained, and imply strictness. One simple sufficient condition for
(5), valid for every `n>=4`, is

\[
\boxed{\delta\le\frac{\sqrt n}{2}.}\tag{7}
\]

In particular `delta<=1` is sufficient for every `n>=4`.

## 2. Exact multiplication-tensor identities

Choose a complete original orthonormal eigenbasis `phi_0=1,phi_j`,
with `B phi_j=lambda_j phi_j`, `lambda_j in [0,1]`. Only the chosen
constant vector is omitted from sums over `j>0`: all other eigenvalue-one
modes and all zero modes remain. Let

\[
Z_j=QD_{\phi_j}Q\big|_E,\qquad
c_{jkl}=\mathbb E_\pi\phi_j\phi_k\phi_l.
\tag{8}
\]

For `j,k,l>0`, direct expansion of `Q=I-f tensor f`, using `f_i^2=1`
and `E_pi phi_j=0`, gives

\[
\operatorname{tr}(Z_jZ_k)
=(n-2)\mathbf1_{j=k}+\mathbb E_\pi(a\phi_j\phi_k),
\tag{9}
\]

and

\[
\operatorname{tr}(Z_jZ_kZ_l)
=(n-3)c_{jkl}+\mathbb E_\pi(a\phi_j\phi_k\phi_l).
\tag{10}
\]

Here is the normalization calculation. The ordinary operator trace of a
diagonal multiplier is `tr D_g=sum_i g_i=E_pi[(n+a)g]`. The trace of
`(f tensor f)D_g` is `E_pi f^2 g=E_pi g`. Expanding two compressed
multipliers gives `tr D_(phi_j phi_k)-2 E_pi phi_j phi_k`, since the
product of their two individual means is zero. Expanding three gives
`tr D_(phi_j phi_k phi_l)-3 E_pi phi_j phi_k phi_l`; all other terms
contain an individual centered mean. These are (9)--(10), with no
replacement of the original measure by the uniform law.

For positive `s,t`, put

\[
g_{st}=\mathbb E\operatorname{tr}(X_sX_t),
\qquad \sigma_q=\operatorname{tr}(B^q)-1
=\sum_{j>0}\lambda_j^q\ge0.
\tag{11}
\]

The actual field expansion and (9) imply

\[
\begin{aligned}
g_{st}
&=\sum_{j>0}\lambda_j^{s+t}
  \left[n-2+\mathbb E(a\phi_j^2)\right]\\
&\ge m\sigma_{s+t}.
\end{aligned}\tag{12}
\]

The bound uses `E phi_j^2=1` and `|a|<=delta`. Linear terms in the
expansion of (4) vanish because `E X_s=0`, hence

\[
J_{xyz}-(n-1)=g_{xy}+g_{xz}+g_{yz}+C_{xyz},
\quad C_{xyz}=\mathbb E\operatorname{tr}(X_xX_yX_z).
\tag{13}
\]

## 3. A positive Schur form controls the nonuniform cubic error

Write `L_s=K_s-Pi=B^s-Pi` as a relative kernel. Each `L_s` is PSD and
annihilates the constant vector. Define the ENTRYWISE product

\[
H=L_x\circ L_y\circ L_z.\tag{14}
\]

The weighted matrix representing `H` is a diagonal congruence of a
Schur product of PSD matrices, so the Schur product theorem proves that
`H` is a PSD operator on the original `L^2(pi)`. Entrywise nonnegativity
of `H` is not claimed or needed. Expanding the eigenfunctions in (14)
and using (10) yields the exact identity

\[
\boxed{C_{xyz}=(n-3)\langle1,H1\rangle+\langle a,H1\rangle.}
\tag{15}
\]

This is the additional mechanism: the uniform part is a positive Schur
quadratic form, and the nonuniform error couples its same two arguments.
Complete the square in this PSD form:

\[
\begin{aligned}
C_{xyz}
&=(n-3)\left\langle1+\frac{a}{2(n-3)},
 H\left(1+\frac{a}{2(n-3)}\right)\right\rangle
 -\frac{\langle a,Ha\rangle}{4(n-3)}\\
&\ge-\frac{\langle a,Ha\rangle}{4(n-3)}.
\end{aligned}\tag{16}
\]

Thus neither a modewise sign nor a pointwise sign of a triple matrix
product is assumed. The term on the right of (16) is bounded next by
quadratic spectral quantities of `B`, with no unknown cubic source term.

The trilinear trace of real symmetric matrices is invariant under every
permutation, so sort `x<=y<=z`. Since `0<=L_x<=I-Pi` in PSD order,

\[
|L_x(i,t)|\le\sqrt{L_x(i,i)L_x(t,t)}
\le\max_j(\pi_j^{-1}-1)\le M.
\tag{17}
\]

In (17), the first inequality is the PSD two-by-two minor inequality;
the second uses the diagonal of the relative identity kernel, which is
`1/pi_j`, not one. Therefore Cauchy--Schwarz under the ORIGINAL product
law gives

\[
\begin{aligned}
0\le\langle a,Ha\rangle
&\le\delta^2 M\mathbb E_{i,t}|L_y(i,t)L_z(i,t)|\\
&\le\delta^2 M
\sqrt{\mathbb E L_y^2\,\mathbb E L_z^2}\\
&=\delta^2 M\sqrt{\sigma_{2y}\sigma_{2z}}.
\end{aligned}\tag{18}
\]

The absolute values in the first line are essential: entrywise products
of different centered powers are not assigned a sign. Composition of
the self-adjoint powers gives the final Hilbert--Schmidt norms.

## 4. Absorption by the retained quadratic surplus

Combining (12), (13), (16), and (18) proves the quantitative estimate

\[
\boxed{J_{xyz}-(n-1)\ge
m(\sigma_{x+y}+\sigma_{x+z}+\sigma_{y+z})
-\frac{\delta^2 M}{4(n-3)}\sqrt{\sigma_{2y}\sigma_{2z}}.}
\tag{19}
\]

For `x<=y<=z`, spectral ordering gives
`sigma_(2y)<=sigma_(x+y)` and
`sigma_(2z)<=sigma_(y+z)`. Arithmetic--geometric mean then gives

\[
\sqrt{\sigma_{2y}\sigma_{2z}}
\le\frac{\sigma_{x+y}+\sigma_{y+z}}2.
\tag{20}
\]

Consequently the completely rational certificate is

\[
\boxed{\begin{aligned}
J_{xyz}-(n-1)\ge{}&m\sigma_{x+z}\\
&+\left(m-\frac{\delta^2M}{8(n-3)}\right)
(\sigma_{x+y}+\sigma_{y+z}).
\end{aligned}}\tag{21}
\]

For a second lower bound, let `v_y=sigma_(2y)` and `v_z=sigma_(2z)`.
Under (5), (19) and spectral ordering also give the useful lower bound

\[
J_{xyz}-(n-1)\ge
m\left[(\sqrt{v_y}-\sqrt{v_z})^2+v_z\right].
\tag{21a}
\]

For this version, use `sigma_(x+y)>=v_y`,
`sigma_(x+z)>=sigma_(y+z)>=v_z`, and
`delta^2 M/[4(n-3)]<=2m` directly in (19).

Under (5), its two coefficients are respectively positive and
nonnegative, proving (6). If equality holds, `sigma_(x+z)=0`. All
centered eigenvalues of `B` are therefore zero, so `B=Pi`. Since `S`
is self-adjoint and `S^2=Pi`, its centered eigenvalues also vanish and
`S=Pi`. Conversely `S=Pi` makes every actual positive-time field `I_E`,
giving equality. This proof also works at equality in the second
condition of (5); the first coefficient remains strictly positive.

To check (7), for `n>=4` use `sqrt(n)<=n-2`. Then
`m>= (n-2)/2`, `M<=5n/4`, and

\[
\delta^2M\le\frac{5n^2}{16}
<\frac{n^2}{2}
\le4(n-3)(n-2)
\le8(n-3)m.
\tag{22}
\]

The middle weak inequality follows from
`(n-3)/n>=1/4` and `(n-2)/n>=1/2`. In particular the smallest boundary
`n=4,delta=1` gives `m=1`, `M=4` and
`delta^2M=4<8=8(n-3)m`; it is included. These constants are sufficient,
not asserted optimal.

## 5. An actual nonuniform rank-twelve example

Take `n=13` and the explicit ORIGINAL coarse law

\[
\pi_0=\frac{17}{208},\qquad
\pi_1=\frac{15}{208},\qquad
\pi_i=\frac1{13}\quad(2\le i\le12).
\tag{23}
\]

Thus `a_0=-13/17`, `a_1=13/15`, and all other `a_i=0`;
`delta=13/15<1`. Put `c=1/4096` and define the ordinary reversible
path transition matrix by

\[
(P_0)_{i,i+1}=c/\pi_i,\qquad
(P_0)_{i+1,i}=c/\pi_{i+1},\qquad
(P_0)_{ii}=1-\deg_{\rm path}(i)c/\pi_i.
\tag{24}
\]

All other entries are zero. Set the relative kernels

\[
S_0(i,j)=(P_0)_{ij}/\pi_j,\qquad
S=\frac{1023}{1024}S_0+\frac1{1024}\Pi,
\quad f_i=(-1)^i,\quad Q=I-f\otimes f.
\tag{25}
\]

This root is symmetric, strictly positive, and Markov under (23). Its
ordinary holding probabilities are at least `1907/1920`, so every
eigenvalue of `P0` is at least `947/960>0`. The corresponding symmetric
tridiagonal matrix has strictly positive adjacent entries, and therefore
simple eigenvalues. Refresh preserves simplicity and scales every
centered eigenvalue by `1023/1024`. The coarse square consequently has
twelve distinct positive centered eigenvalues. Every one is visible in
the actual source: (12) gives
`||QD_(phi_j)Q||_HS^2>=m=152/15>0` for every centered normalized mode.

The projection rank is twelve and its raw diagonal is
`1/pi_i-1`, which is nonconstant. Since `B` is invertible, applying `B`
cannot make this nonconstant diagonal constant. The visible trace is
therefore unbalanced. The positive summand at state one gives

\[
\lambda_{\max}(M_1(1))
\ge (P^2)_{11}Q(1,1)
\ge P_{11}^2\frac{193}{15}>12>4+4\sqrt2,
\tag{26}
\]

where `P=(1023/1024)P0+(1/1024)1 tensor pi`. Thus the earlier universal
source-cap theorem fails as a sufficient test on this host. The
projection is signed, noncentral, and noncommuting with the root; the
exact checker records the corresponding entries. The new theorem proves
all actual stars for this weighted example at every positive triple.

For a complete actual binary projection channel on 26 states, set

\[
\alpha=\frac1{32768},\quad\beta=\alpha^2,\qquad
\mu(i,\sigma)=\pi_i/2,
\quad T((i,\sigma),(j,\tau))=S(i,j)+\sigma\tau\alpha Q(i,j).
\tag{27}
\]

Since `max|Q|=193/15<13` and `S>=1/1024`, we have
`|alpha Q|<13/32768<1/1024`, so `T` is strictly positive. It is
symmetric and Markov under the stated original `mu`. Define

\[
p=(\max_{i,j,\sigma,\tau}T((i,\sigma),(j,\tau)))^{-1},
\qquad W=pT.
\tag{28}
\]

Then `W` lies in `(0,1]` and every original-weighted row sum is the
same positive `p`. Exact evaluation gives

\[
\min T=\frac{31}{32768},\qquad
\max T=\frac{11272763}{819200},\qquad
p=\frac{819200}{11272763},\qquad
\min W=\frac{775}{11272763}.
\tag{28a}
\]

The complete coarse matrices and parameters determining `T` and `W` are
recorded in the companion certificate. Original sign
averaging, not a change of measure, proves

\[
T^{2s}((i,\sigma),(j,\tau))
=S^{2s}(i,j)+\sigma\tau\beta^sQ(i,j),\qquad s\ge1.
\tag{29}
\]

The fine square adds the positive value `beta` with multiplicity twelve
and zero with multiplicity one. Its entire centered spectrum has
fourteen distinct values, including zero. The coarse values are all
larger than `[(1023/1024)(947/960)]^2`, so no collision with `beta` is
possible.

The already proved projection four-cycle contraction, this theorem for
triangles, and (29) give the comparison

\[
F(T;n_e)\ge F(S;n_e)+12\sum_{D\in\mathcal C(K_4)}
\beta^{\sum_{e\in D}n_e}
\tag{30}
\]

for all six positive exponents. The coarse density has a separate
already proved input: `S0` is TP2 in path order, and the prior
common-order convex-TP2 density theorem applies to all powers of its
mixture with `Pi`. The mixture itself is not asserted TP2. Thus (30)
proves `F(T;n_e)>1` for this actual host, with every original law and
root specified. This positive example is not a counterexample or a
proof of the unrestricted target.

## 6. Reproduction and exact limits

The completion of the square is needed even inside the sufficient range:
the cubic in (15) need not be nonnegative. An independently supplied
exact sanity check uses

\[
\pi=(1/5,1/4,1/4,3/10),\qquad
v=(-4,-4,-1,41/6),\qquad
S=\Pi+(v\otimes v)/128.
\tag{31}
\]

Here `E_pi v=0`, `E_pi v^2=515/24`, and `S` is a strictly positive
actual Markov root, with minimum entry `151/192`. With any flat signs
and `Q=I-f tensor f`, `n=4` and `delta=1`. Its single active centered
mode has

\[
\mathbb E_\pi v^3=\frac{9601}{144}>0,
\qquad
\sum_i v_i^3-3\mathbb E_\pi v^3=-\frac{4295}{432}<0.
\tag{32}
\]

Consequently the actual averaged centered cubic is strictly negative for
every positive exponent triple. Formula (21) still proves the star
bound. This small host is already covered by the earlier source-cap
theorem; it is a test of the collective mechanism, not an additional
coverage claim. It is not an obstruction to the target.

The companion standard-library verifier checks the full original-law
construction, the weighted projection, the source-cap and balance
obstructions, all ordered TP2 minors, the actual square identity,
and direct four-variable star integrals against (13), (15), and (21).
It includes refresh equality, a disconnected identity root, a
connected bipartite root whose square disconnects, repeated exponents,
and the `n=4,delta=1` boundary of the stated sufficient range. No
numerical eigenvalue matching is used as a proof.

Condition (5) is a restriction on the original measure and projection
shape; it is not assumed for arbitrary actual sources. Its significance
here is uniformity over all roots and positive exponent triples within
that shape, while admitting large rank and unbalanced trace. The two
unrestricted obligations in the parent route registry remain open.
