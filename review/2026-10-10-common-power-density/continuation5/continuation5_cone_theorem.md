# A common-cone transfer for arbitrary projection channels

**Verdict and scope.** The unrestricted common-power density inequality
remains unresolved. This note proves a restricted, quantitative transfer
theorem for an actual binary root whose signed-channel square is a scalar
times an arbitrary orthogonal projection. Unlike the paired-star comparison
in PR #60, this transfer applies to **every six positive edge exponents**
when the six coarse kernels lie in one cone `conv{I,Pi,C}`. It has no tuple
ordering or reflection requirement. The fine square can have more than two
values on its entire centered space. No claim of literature novelty or of a
new unrestricted Lean theorem is made.

The new step is the common-cone triangle lemma in Section 2. The
quadrilateral lemma and the coarse common-cone `K4` density lemma are the
previously proved inputs, attributed below. All measures stay original.

## 1. Original-law conventions and the actual multiplication field

Let `(X,pi)` be a finite probability space with every `pi_x>0`. A relative
kernel acts by

\[
(Lf)(x)=\sum_y\pi_yL(x,y)f(y),\qquad
(LM)(x,y)=\sum_z\pi_zL(x,z)M(z,y).
\]

Write `I(x,y)=1_{x=y}/pi_y` and `Pi(x,y)=1`. All kernels in this note are
real. Let `Q=Q*=Q^2` be an orthogonal projection on `L^2(pi)` with rank `d`.
Its entries may be negative; `Q1` need be neither zero nor one. No
commutation of `Q` with any coarse kernel is assumed.

On `E=ran Q`, let `D_f` denote multiplication by `f` and define

\[
R_t=QD_{\mathbf1_{\{t\}}/\pi_t}Q\big|_E.
\tag{1}
\]

These are the **actual** rank-at-most-one PSD multiplication operators.
They satisfy

\[
\mathbb E_{t\sim\pi}R_t=I_E,\qquad
\operatorname{tr}(R_aR_bR_c)=Q(a,b)Q(b,c)Q(c,a).
\tag{2}
\]

For the trace identity, put `e_t=1_{t}/sqrt(pi_t)` in the original
orthonormal coordinate basis. Then
`R_t=|Qe_t><Qe_t|/pi_t` and
`<Qe_a,Qe_b>=sqrt(pi_a*pi_b) Q(a,b)`. This proves (2), including its
normalization factors.

For a nonnegative self-adjoint Markov kernel `L`, its action on a field is

\[
(LR)_t=\sum_a\pi_aL(t,a)R_a=QD_{L(\cdot,t)}Q\big|_E.
\tag{3}
\]

It is PSD at every `t` and has original-law mean `I_E`. Consequently the
triangle with complementary star kernels `L_1,L_2,L_3` is exactly

\[
\begin{aligned}
\mathcal J_Q(L_1,L_2,L_3)
&=\mathbb E_{a,b,c,t\sim\pi}
 Q(a,b)Q(b,c)Q(c,a)L_1(a,t)L_2(b,t)L_3(c,t)\\
&=\mathbb E_t\operatorname{tr}
 [(L_1R)_t(L_2R)_t(L_3R)_t].
\end{aligned}
\tag{4}
\]

This trilinear form is symmetric in its three arguments. Cyclicity and
transpose make the trace of three real symmetric matrices invariant under
all permutations. This is a symmetry statement, **not a positivity claim**.

## 2. The common-cone triangle lemma

**Lemma.** Let `C` be one entrywise nonnegative, self-adjoint PSD Markov
kernel on `(X,pi)`. If the three independently chosen kernels `L_i` lie in
`conv{I,Pi,C}`, then

\[
\boxed{\mathcal J_Q(L_1,L_2,L_3)\ge d.}
\tag{5}
\]

Here `C` need not be an actual square, and may have any number of spectral
values. These are auxiliary kernels in a contraction lemma; the actual-root
requirement is verified separately in Section 4.

**Proof.** The rank-zero case is identically zero. Suppose `d>0`. For PSD
fields `U_t,V_t` with `E V_t=I_E`, Cauchy--Schwarz in the direct sum of
original-law Hilbert--Schmidt spaces gives

\[
\left(\mathbb E_t\operatorname{tr}(U_tV_t)\right)^2
\le d\,\mathbb E_t\operatorname{tr}(U_t^2V_t).
\tag{6}
\]

Indeed use the two fields `U_t V_t^(1/2)` and `V_t^(1/2)`. Their squared
norms are respectively `E tr(U_t^2 V_t)` and `d`.

Put `Z=CR` and

\[
a=\mathbb E\operatorname{tr}(R_t^2),\quad
b=\mathbb E\operatorname{tr}(R_tZ_t),\quad
c=\mathbb E\operatorname{tr}(Z_t^2).
\tag{7}
\]

All three numbers are at least `d`. For `a,c` this follows from the
Hilbert-space mean inequality and `E R=E Z=I_E`. For `b`, the operator
`C-Pi` is PSD: constants have eigenvalue one, and the centered space is
invariant with nonnegative spectrum. Acting on each matrix coefficient,

\[
b=\langle R,CR\rangle
=d+\langle R-\mathbb ER,C(R-\mathbb ER)\rangle\ge d.
\tag{8}
\]

By symmetry and trilinearity it suffices to check the ten unordered triples
of the three generators. The following table gives an exact value or a
lower bound. Each entry is at least `d`.

| Generator triple | Value or lower bound | Justification |
|---|---:|---|
| `I,I,I` | `a^2/d` | (6), `U=V=R` |
| `I,I,Pi` | `a` | `Pi R=I_E` |
| `I,I,C` | `b^2/d` | (6), `U=R,V=Z` |
| `I,Pi,Pi` | `d` | Original-law mean of `R` |
| `I,Pi,C` | `b` | (7)--(8) |
| `I,C,C` | `b^2/d` | (6), `U=Z,V=R` |
| `Pi,Pi,Pi` | `d` | Trace of `I_E` |
| `Pi,Pi,C` | `d` | Original-law mean of `Z` |
| `Pi,C,C` | `c` | (7) |
| `C,C,C` | `c^2/d` | (6), `U=V=Z` |

Write `L_i=alpha_i I+eta_i Pi+gamma_i C`, with nonnegative coefficients
summing to one for each `i`. Expanding (4) gives a convex combination of
these ten types. Their bounds prove (5). The weighted sum of the displayed
bounds also gives an optional explicit surplus over `d`. No pointwise sign
of `tr((L_1R)_t(L_2R)_t(L_3R)_t)` was used. QED.

The all-distinct generator triple is the essential extra case beyond the
previous paired-star proof. Its `Pi` factor leaves the positive two-field
pairing (8). There is no reduction here of an arbitrary unequal-star triple
from an unrestricted common semigroup to these ten cases.

## 3. Four-cycle input and the six-kernel transfer

We recall, with its short original-law proof, the arbitrary-projection
quadrilateral lemma from
[PR #60](../continuation4/continuation4_tensor_projection_lemmas.md).
For independently chosen nonnegative PSD Markov kernels `L,M`,

\[
\mathbb E Q_{ab}Q_{bc}Q_{cd}Q_{da}L_{ac}M_{bd}\ge d.
\tag{9}
\]

To check it, set `v_bd(a)=Q(a,b)Q(a,d)` and
`G(a,c)=E_bd M(b,d)v_bd(a)v_bd(c)`. The kernel `G` is a nonnegative
mixture of rank-one PSD operators, so `J>=<Pi,G>_HS`. Original-law
`Q^2=Q` gives `<Pi,G>_HS=<M,Q circ Q>_HS`. The Schur square `Q circ Q`
is PSD; pairing it with `M-Pi` leaves the bound
`<Pi,Q circ Q>_HS=tr Q^2=d`. Thus (9) does not assert that an arbitrary
product of three or more PSD matrices has nonnegative trace.

Index the six edges by `ab,ac,ad,bc,bd,cd`. Choose independent coarse
kernels `L_e in conv{I,Pi,C}` and numbers `tau_e>=0`. On the **original**
fine probability space

\[
\mu(i,\sigma)=\pi_i/2,\qquad \sigma\in\{-1,1\},
\]

define edge kernels `M_e((i,sigma),(j,rho))=L_e(i,j)+tau_e Q(i,j)sigma rho`.
This algebraic transfer remains true even if those auxiliary `M_e` are
not individually nonnegative; actual nonnegativity will hold in the
common-power application. Let `F(M)` and `F(L)` be their `K4` densities.
Expanding the four independent signs removes every edge subset with an
odd vertex degree. The only nonempty even subsets of `K4` are its four
triangles and three quadrilaterals. Therefore, exactly,

\[
F(M)=F(L)+\sum_{D\in\mathcal C}
 \left(\prod_{e\in D}\tau_e\right)J_D,
\tag{10}
\]

where `J_D` places `Q` on the edges of `D` and `L_e` on its complement.
For triangles (5) applies; for quadrilaterals (9) applies. Hence

\[
\boxed{F(M)\ge F(L)+d\sum_{D\in\mathcal C}\prod_{e\in D}\tau_e.}
\tag{11}
\]

No equality of complementary star exponents is required. This is a
finite original-law calculation, with no change to component measures.

## 4. Application to one actual nonnegative root

Let `S` be a nonnegative self-adjoint Markov kernel on `(X,pi)`. Let `H`
be self-adjoint with `|H(i,j)|<=S(i,j)` and

\[
H^2=\beta Q,\qquad\beta\ge0.
\tag{12}
\]

Then

\[
T((i,\sigma),(j,\rho))=S(i,j)+H(i,j)\sigma\rho
\tag{13}
\]

is nonnegative, symmetric and Markov under `mu(i,sigma)=pi_i/2`. For
`0<p<=1/max T`, `W=pT` is an admissible bounded host and all its original
weighted row sums are `p`. Fine function space splits orthogonally into
fiberwise even and odd functions, on which `T` acts as `S` and `H`.
Equivalently, direct composition averages the middle sign and removes
both cross terms. Thus for every positive integer `n`,

\[
T^{2n}((i,\sigma),(j,\rho))
 =S^{2n}(i,j)+\beta^nQ(i,j)\sigma\rho.
\tag{14}
\]

This proves the transport from the one actual root under its original
fine measure; it does not construct unrelated edge kernels as a host.

If every one of the six coarse powers `S^(2n_e)` lies in one common cone
`conv{I,Pi,C}`, (11) gives the announced theorem:

\[
\boxed{F(T;n)\ge F(S;n)+d\sum_{D\in\mathcal C}\beta^{q_D},
\qquad q_D=\sum_{e\in D}n_e.}
\tag{15}
\]

This is valid for all six positive integers `n_e`, and in particular for
the exact target exponents `(k,r+h,u,r,u,l)`. It preserves the entire
actual coarse density. When `d>0` and `beta>0`, the retained channel
surplus is strictly positive.

## 5. A uniform all-exponent corollary with four fine spectral values

The previously established coarse common-cone `K4` lemma, from
[PR #57](https://github.com/SamPetkov/Erdos593/pull/57), says that the
coarse density is at least one for six independent kernels in this cone.
It is a proved restricted input, not an assumed unrestricted inequality.

In particular suppose `B=S^2` has **at most two values on its entire
centered space**, so it can be written

\[
B=yI+(1-y)\Pi+(x-y)P,
\qquad 0\le y\le x\le1,
\tag{16}
\]

where `P` is a centered orthogonal projection and `B` is nonnegative.
For `y<1` set `C=(B-yI)/(1-y)`. Its off-diagonal entries are nonnegative.
On the diagonal,
`B(i,i)-y/pi_i=(1-y)+(x-y)P(i,i)>=0`. Its centered eigenvalues are
`(x-y)/(1-y)` and zero, so it is PSD and Markov. For `x>y`,

\[
B^n=y^n I+
\left[1-y^n-(1-y)\frac{x^n-y^n}{x-y}\right]\Pi
+(1-y)\frac{x^n-y^n}{x-y}\,C.
\tag{17}
\]

The coefficients are nonnegative and sum to one: use
`(x^n-y^n)/(x-y)=sum_{j=0}^{n-1} x^(n-1-j)y^j <= sum_{j=0}^{n-1}y^j`.
The case `x=y<1` is just `B^n=y^n I+(1-y^n)Pi`; the case `y=1` is
`B=I`. A zero centered band is counted in (16). **Two distinct positive
centered bands plus an additional zero are three values and do not
automatically meet this hypothesis.**

All coarse powers now lie in one cone. Retaining the all-identity term in
its six-edge expansion gives the known coarse surplus

\[
F(S;n)\ge1+
\left(\sum_i\pi_i^{-2}-1\right)y^N,
\qquad N=\sum_e n_e.
\tag{18}
\]

Indeed its coefficient is `y^N`, its `K4` density is `sum_i pi_i^(-2)`,
and every other generator term has density at least one. Combining the
proved inputs with the new transfer gives

\[
\boxed{F(T;n)\ge1+
 \left(\sum_i\pi_i^{-2}-1\right)y^N
 +d\sum_{D\in\mathcal C}\beta^{q_D}\ge1.}
\tag{19}
\]

The fine square is `B` on the even sector and `beta Q` on the odd sector.
Its entire centered spectrum may therefore contain `x,y,beta,0`, with
their actual multiplicities. This is not an application of the two-value
common-cone theorem directly to the fine square. The channel projection
may be signed, noncentral and noncommuting with `S`.

The explicit eight-state witness and the all-exponent extension of its
bound are in [the example](continuation5_cone_example.md). The exact
checker includes unequal-star tuples outside all three reflection
families, boundary tuples, zero channels, equality, disconnected roots,
and connected bipartite roots with disconnected squares.

## 6. Exact limit of this result

The general target need have neither a binary projection-channel
decomposition nor a common cone for its coarse powers. If an unrestricted
coarse semigroup supplies three distinct star powers, trilinearity does
not express them in the three generators used above. The general
unequal-star inequality for actual multiplication fields remains a
distinct missing lemma. Even that stronger contraction lemma alone would
not prove the target for every actual root without a further valid
structural reduction.

Earlier negative coarse-domination examples with general `H` are
consistent with (15): they do not satisfy `H^2=beta Q`. The pointwise
trace and fractional-surplus obstructions in this packet likewise do
not refute (5), (15), or the target. No local continuity radius is being
promoted into a global argument.
