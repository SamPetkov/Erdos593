# Projection-channel contractions under the original measure

## Scope

These are finite contraction lemmas for an actual binary-fiber root whose
signed-channel square is one scalar times an orthogonal projection. They
do not prove the unrestricted common-power target. They allow arbitrary
positive original coarse weights, arbitrary projection rank, projections
with negative entries, and projections that do not annihilate constants.

The density inequality `F>=1` on the boundary `k=u, r=l` already follows
for every actual root from the
[direct reflection proof](continuation4_boundary_scope.md), without a
channel hypothesis. The content here is a quantitative comparison with
the **original coarse density**, together with retained channel surplus.
It gives no new density coverage of that reflection boundary, and no
claim of literature novelty is made for the comparison.

All kernels below are relative kernels on a finite probability space
`(I,pi)`, where every `pi_i>0`. Composition always means

`(BC)(i,j)=sum_t pi_t B(i,t)C(t,j)`.

The Hilbert--Schmidt pairing is
`<B,C>_HS=sum_(i,j) pi_i pi_j B(i,j)C(i,j)` for real kernels.
Let `Q=Q*=Q^2` be any orthogonal projection, of rank `d`. In particular
`tr Q=tr Q^2=d`; no coordinate or entrywise interpretation of its rank is
being substituted. Let `Pi(i,j)=1`.

## 1. Quadrilateral lemma for two independent diagonal kernels

Let `L` and `M` be entrywise nonnegative, self-adjoint PSD Markov kernels.
They need not commute and need not come from one root. Then

\[
J=\mathbb E_{a,b,c,d\sim\pi}
 Q(a,b)Q(b,c)Q(c,d)Q(d,a)L(a,c)M(b,d)
 \ \ge\ \operatorname{rank}Q.
\tag{1}
\]

The four cycle factors in (1) are the **same projection**. The claim does
not concern four independently chosen PSD kernels.

For each ordered pair `(b,d)`, define

`v_(b,d)(a)=Q(a,b)Q(a,d)`.

The relative kernel

\[
G(a,c)=\mathbb E_{b,d\sim\pi}
 M(b,d)v_{b,d}(a)v_{b,d}(c)
\tag{2}
\]

is PSD: every coefficient `pi_b pi_d M(b,d)` is nonnegative, so (2) is
a finite nonnegative sum of rank-one positive operators. Because `L` is
PSD and Markov, `L-Pi` is PSD. The Hilbert--Schmidt pairing of two
self-adjoint PSD operators is nonnegative. Therefore

\[
J=\langle L,G\rangle_{\rm HS}
 \ge\langle\Pi,G\rangle_{\rm HS}.
\tag{3}
\]

Original-measure composition and `Q^2=Q` give

\[
\mathbb E_a v_{b,d}(a)
 =\mathbb E_a Q(b,a)Q(a,d)=Q^2(b,d)=Q(b,d).
\tag{4}
\]

Using (4) twice in (2),

\[
\langle\Pi,G\rangle_{\rm HS}
 =\mathbb E_{b,d}M(b,d)Q(b,d)^2
 =\langle M,Q\circ Q\rangle_{\rm HS}.
\tag{5}
\]

Here `Q circ Q` denotes the entrywise Schur square, **not** the operator
square. The Schur product theorem makes `Q circ Q` PSD. Also `M-Pi` is
PSD, hence

\[
\langle M,Q\circ Q\rangle_{\rm HS}
 \ge\langle\Pi,Q\circ Q\rangle_{\rm HS}
 =\mathbb E_{b,d}Q(b,d)^2
 =\operatorname{tr}Q^2=d.
\tag{6}
\]

Equations (3)--(6) prove (1). In fact they give the exact nonnegative
surplus decomposition

\[
J-d=\langle L-\Pi,G\rangle_{\rm HS}
     +\langle M-\Pi,Q\circ Q\rangle_{\rm HS}.
\tag{7}
\]

This uses only pairwise PSD Hilbert--Schmidt pairings and an actual
nonnegative rank-one mixture. No sign claim about the trace of three or
more arbitrary PSD matrices occurs.

## 2. Paired-star triangle and a spectral surplus

Let `A` be an entrywise nonnegative, self-adjoint PSD Markov kernel and
let `L_s=A^s` for positive integers `s`. Let `x,z>=1`. Then

\[
J_{x,x,z}=\mathbb E_{a,b,c,d\sim\pi}
 Q(a,b)Q(b,c)Q(c,a)L_x(a,d)L_x(b,d)L_z(c,d)
 \ge d.
\tag{8}
\]

For `d=0`, all quantities vanish. Suppose `d>0`, and work on the
`d`-dimensional Hilbert space `E=ran Q`. Let `D_f` be multiplication by a
real function `f`. For a coarse color `t` define the PSD operator

`R_t=Q D_(1_(.=t)/pi_t) Q` on `E`.

Its original-law mean is `E_t R_t=I_E`. Define matrix fields

`B_t=Q D_(L_x(.,t)) Q`, `C_t=Q D_(L_z(.,t)) Q`.

Both are PSD because every `L_s(i,t)>=0`. The original-law action in the
field variable gives exactly `B=A^x R`, `C=A^z R`, and `E C=I_E`.
Expanding the three compressed multiplication operators in the original
weighted coordinate basis gives

`J_(x,x,z)=E_t tr_E(B_t^2 C_t)`.

Let

`g=E_t tr_E(B_t C_t)`.

The operator `A` acts self-adjointly and positively on each scalar matrix
coefficient of a field. Since its constant mode is one,

\[
g=\langle R,A^{x+z}R\rangle
 \ge\|\mathbb E R\|_{\rm HS}^2
 =d.
\tag{9}
\]

Cauchy--Schwarz in the direct sum, over original colors `t`, of the
Hilbert--Schmidt spaces, applied to `B_t C_t^(1/2)` and `C_t^(1/2)`, yields

\[
g^2\le
 \left(\mathbb E_t\operatorname{tr}(B_t^2C_t)\right)
 \left(\mathbb E_t\operatorname{tr}C_t\right)
 =d J_{x,x,z}.
\tag{10}
\]

Thus `J_(x,x,z)>=g^2/d>=d`, proving (8).

This retains an explicit spectral surplus. Choose a complete original-law
orthonormal eigenbasis `phi_0=1,phi_1,...`, with `A phi_i=lambda_i phi_i`.
Zero eigenvalues and multiplicity-one eigenvalues of a disconnected
kernel are both allowed. Field expansion gives

\[
g=d+\sum_{i>0}\lambda_i^{x+z}
       \|Q D_{\phi_i} Q\|_{\rm HS}^2.
\tag{11}
\]

Every summand in (11) is nonnegative; it is a squared norm of an actual
multiplication operator. Consequently

\[
J_{x,x,z}\ge
\frac1d\left[d+\sum_{i>0}\lambda_i^{x+z}
       \|Q D_{\phi_i}Q\|_{\rm HS}^2\right]^2.
\tag{12}
\]

The special choice `Q=Id-Pi` permits the exact simplification

\[
\|Q D_{\phi_i}Q\|_{\rm HS}^2
 =\sum_{t\in I}\phi_i(t)^2-2\qquad(i>0).
\tag{13}
\]

Indeed the Hilbert--Schmidt square of multiplication by `phi_i` equals
the unweighted coordinate sum in (13). Removing the row and column of
the constant vector removes two squared norms equal to one; their
intersection is zero because `phi_i` is centered. This is a nonnegative
quantity because it equals the squared compressed-operator norm. Under
uniform `pi` on `m` points, it is `m-2`.

## 3. Consequence for the actual target boundary

Let `S` be any actual nonnegative self-adjoint Markov kernel, and let `H`
be self-adjoint with `|H(i,j)|<=S(i,j)`. On the original binary-fiber law
`mu(i,a)=pi_i/2`, put

`T((i,a),(j,b))=S(i,j)+H(i,j)ab`, `a,b in {-1,1}`.

Assume `H^2=beta Q`, `beta>=0`, in original-`pi` composition. For every
positive power, averaging the intermediate sign gives

`T^(2n)=S^(2n)+beta^n Q ab`.

The complete four-sign average leaves the empty edge set, four triangles
and three quadrilaterals. At `k=u>=1`, `r=l>=1`, and `h>=1`, each triangle's
three complementary star exponents have a repeated pair. The pairs are
`(u,u,r)`, `(r+h,r,r)`, `(u,r,u)`, and `(u,r+h,u)` for stars centered at
`d,c,b,a` respectively. Lemma (8) applies to every triangle with
`A=S^2`; lemma (1) applies to every quadrilateral. If `q_C` is the sum of
the edge exponents on the cycle, then

\[
F(T;n)\ge F(S;n)+d\sum_C\beta^{q_C}.
\tag{14}
\]

At this boundary, the independent reflection argument already gives
`F(S;n)>=tr((S^2)^(2(u+r)))>=1` for every actual coarse root. Formula (14)
preserves the entire value `F(S;n)` and adds the displayed channel-cycle
terms. The scalar reflection inequalities for the fine and coarse roots
do not themselves compare those two densities. No nonnegativity of the
projection or of the signed channel is assumed, and no replacement of
the original law is made.

For the triangle with paired star lengths `(x,x,z)`, (12) can replace the
coefficient `d` in (14) by its explicit larger quantity. For a
quadrilateral, (7) records its exact nonnegative surplus. These formulas
remain restricted to this projection-channel structure and, for the
triangle statement used in (14), the paired-star target boundary.

More generally, the same cycle proof applies to any six positive edge
exponents for which every complementary star has a repeated pair. Within
the ordered target, this occurs exactly when `r=l, k=u`, or when
`r=l=u, k=u+h`. The second family also has a direct reflection proof of
`F>=1`; the classification and that scope check are in
[continuation4_boundary_scope.md](continuation4_boundary_scope.md).

### A strict quantitative improvement on the direct trace lower bound

On `k=u, r=l`, write `A_S=S^2` for the coarse square and `A_T=T^2` for
the fine square. The exact channel decomposition gives

`tr A_T^(2(u+r))=tr A_S^(2(u+r))+d beta^(2(u+r))`.

Combining coarse reflection with (14),

\[
F(T;n)\ge\operatorname{tr} A_S^{2(u+r)}
                   +d\sum_C\beta^{q_C}.
\tag{15}
\]

One quadrilateral has `q_C=2(u+r)`. Thus (15) is the direct fine trace
lower bound plus the other **six** cycle terms. It is strictly stronger
than that trace lower bound whenever `d>0` and `beta>0`. This is a
quantitative strengthening on an already density-covered boundary; it
does not extend the unrestricted range of tuples.

