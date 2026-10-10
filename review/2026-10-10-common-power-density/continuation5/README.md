# Unequal-star bounds and common-cone projection transfer

**The unrestricted common-power density inequality remains unresolved.
This packet contains no admissible host with `F<1`.** It proves an
all-exponent projection-channel transfer, proves an unconditional quadratic
lower estimate for actual unequal-star sources, and supplies exact
obstructions to several stronger proof mechanisms.

This is a bounded draft continuation of [PR #60](https://github.com/SamPetkov/Erdos593/pull/60),
based on its frozen head `06d17d7ce4d6a1d09891f79ec6feb59cdf68819b`.
Earlier proof and review files are preserved. No unrestricted theorem,
novelty classification, or Lean promotion is claimed.

## Exact target

On a finite positive original probability space, `T=W/p` is an actual
nonnegative self-adjoint Markov root, `A=T^2`, and `K_j=A^j`. All six
factors come from this single root and every composition uses the original
measure. The requested inequality is

\[
F=\mathbb E_{\mu^4}
K_k(a,b)K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d)\ge1
\]

for `k>=u>=1`, `r>=l>=1`, `h>=1`. Code tuple order is `(k,u,r,l,h)`;
edge order is `(ab,ac,ad,bc,bd,cd)` and edge exponents are
`(k,r+h,u,r,u,l)`.

## 1. New positive transfer for every six exponents

Let `S` be an actual coarse root on the original law `pi`, and let `H`
be self-adjoint with `|H|<=S` and `H^2=beta Q`, where `Q` is an arbitrary
original-law orthogonal projection of rank `d`. It may have negative
entries, may be noncentral, and need not commute with `S`. Then

\[
T((i,a),(j,b))=S(i,j)+abH(i,j),\qquad \mu(i,a)=\pi_i/2
\]

is an actual nonnegative Markov root. Original sign averaging proves

`T^(2n)=S^(2n)+ab beta^n Q`.

If the six independently chosen coarse powers lie in one cone
`conv{I,Pi,C}`, with one nonnegative PSD Markov `C`, the
[complete finite proof](continuation5_cone_theorem.md) gives

\[
\boxed{F(T;n)\ge F(S;n)+d\sum_{D\in\mathcal C}\beta^{q_D},
\qquad q_D=\sum_{e\in D}n_e,}
\tag{1}
\]

where the sum runs over the four triangles and three quadrilaterals of K4.
The same proof allows six independent nonnegative channel strengths,
with `beta^(q_D)` replaced by their product around `D`.

The new mechanism is the triangle lemma

\[
\mathbb E Q_{ab}Q_{bc}Q_{ca}L_1(a,t)L_2(b,t)L_3(c,t)\ge d
\quad(L_i\in\operatorname{conv}\{I,\Pi,C\}).
\tag{2}
\]

The actual multiplication field `R_t=Q D_(1_t/pi_t) Q` has mean `I` on
`ran Q`. Trilinearity reduces (2) to ten unordered generator triples.
Repeated factors use legitimate two-field Cauchy--Schwarz; the only
all-distinct triple `I,Pi,C` reduces to `b=<R,CR> >= d`. The previous
quadrilateral lemma handles the other three cycles. No pointwise
positivity of a trace of three PSD matrices is assumed.

**Unlike the PR #60 paired-star comparison, (1) has no reflection or
exponent-equality requirement.** The old common-cone K4 lemma supplies
`F(S;n)>=1` in its stated scope. In particular, if the coarse square has
at most two values `x,y` on its **entire** centered space, all its powers
lie in such a cone and

\[
F(T;n)\ge1+
\left(\sum_i\pi_i^{-2}-1\right)y^{\sum_e n_e}
+d\sum_D\beta^{q_D}.
\tag{3}
\]

This is a restricted density corollary. It does not apply the two-value
theorem directly to a fine square with four centered values.

### An exact signed four-band example outside reflection

The [example](continuation5_cone_example.md) reuses PR #60's eight-state
noncentral weighted host, with `pi=(1/2,1/4,1/8,1/8)`, rank-two signed
projection, `p=76/507`, and `min W=3/676`. Its complete centered fine
spectrum is

`(105/128)^2` twice, `(45/64)^2` once, `1/4096` twice, and zero twice.

For every six positive exponents, (3) now certifies its quantitative
comparison. At the nonreflection target tuple `(3,1,1,1,1)`, writing
`y=(45/64)^2`, `beta=1/4096`, this gives

\[
F\ge1+147y^9+
2(\beta^3+\beta^4+2\beta^5+2\beta^6+\beta^7)>1.
\tag{4}
\]

The host is reused data; the all-exponent comparison is the extension.

## 2. A quadratic certificate beyond two coarse centered bands

The [second positive derivation](continuation5_unequal_quadratic_bound.md)
works with every actual coarse square `B=S^2` and every original-law
projection `Q`. Let

\[
M_s(t)=(B^sR)_t,\quad
g_{sz}=\mathbb E\operatorname{tr}(M_sM_z),\quad
v_{xy}=\mathbb E\operatorname{tr}(M_x-M_y)^2,\quad
m_z=\max_{i,t}B^z(i,t).
\]

For `d>0`, the unconditional estimate is

\[
\boxed{J_{x,y,z}\ge
\frac{g_{xz}^2+g_{yz}^2}{2d}-\frac{m_z}{2}v_{xy}.}
\tag{5}
\]

The proof combines exact trace polarization, the paired-star
Cauchy--Schwarz estimate, and the actual multiplication bound
`0<=M_z(t)<=m_z I`. Its right-hand side contains **no unknown cubic**.
The quantities `g,v` are explicit quadratic spectral sums of the actual
compressions `Q D_phi_i Q`, or can be evaluated by rational weighted
matrix multiplication.

At the frozen PR #60 heavy-atom host, with
`pi=(3/5,1/5,1/10,1/10)`, signed `Q`, and **three distinct positive coarse
centered values**, the bound at `(x,y,z)=(2,8,1)` is exactly greater than
`24/5`. This is not automatically inside the two-coarse-band corollary.
At target tuple `(1,1,2,1,6)`, the unique unequal complementary star is
`(8,2,1)`. With `beta=1/16384`, the exact comparison is

\[
\boxed{F(T)\ge F(S)+\frac{24}{5}\beta^3+
2(\beta^4+\beta^5+\beta^{10}+2\beta^{11}+\beta^{12}).}
\tag{6}
\]

The complete fine square has five centered values, including zero.
Both full finite densities and every cycle coefficient are certified
exactly. This is one explicit instance and an unconditional lower
estimate, not a universal three-band theorem.

There is also a decisive limitation control: on the cancellation example
below, all three orientations of (5) are strictly negative although
`J>2`. Thus maximizing (5) is not a universal certificate for `J>=d`.

## 3. Exact failures of stronger proof mechanisms

| Mechanism | Exact result | What remains positive |
|---|---|---|
| Retain a universal positive fraction of pair surplus | [A rational family](continuation5_unequal_cancellation.md) at fixed star `(1,2,8)` has `J->8`, `t^2 P->4`, and cubic term `C/P->-1`. This disproves every fixed `c>0` in `J>=2+cP`. | Strict-positive actual eight-state realization; `J>=2` throughout the family; complete checked target density `Ffine>Fcoarse>1`. |
| Pointwise unequal-star positivity | [An actual rational 18-state host](continuation5_search_pointwise.md) has `-2^-24<tr[(AR)_0(A^2R)_0(A^3R)_0]<-2^-25`. | Original-law average `31<J<32`; full target `F>=16-9/2048>15`; nine entire-centered values including zero. |
| Coefficientwise positivity for a complete cover defect on an actual root ray | [The cover note](continuation5_cover_obstructions.md) gives negative coefficients `-7/73728` and `-1/294912` in `F(T_tau)^2-Z_ab(T_tau)`. | The entire polynomial has a written nonnegative regrouping. |
| Every proper centered cover core is nonnegative | The same note gives an actual negative cross-barbell, persisting in a strictly positive five-state host with three positive centered values plus zero. | Exact complete `F>1` and `Z_ab<F^2`; the length-indexed barbell matrix has a valid Gram representation. |

No row of this table is a counterexample to the unrestricted target.
The cancellation family even has commuting pointwise fields, so its
failure is not explained away by noncommuting matrix products.

## 4. Bounded diagnostics and adversarial review

The [diagnostic report](continuation5_search_report.md) archives 24
configured unequal-star optimization runs: 2,962 iterations, seven
projected-gradient terminations and seventeen iteration caps. The
variables are actual coarse roots and original-law projections. Sparse
roots do not automatically admit a nonzero binary channel for every
chosen projection, so these are explicitly **projection-lemma
diagnostics**, not a claimed collection of full target host tests. No
averaged-star violation was certified. The exact pointwise construction
supplies its own complete actual lift independently of these numerics.

Three independent research agents worked on the unequal-star, cover and
search routes. They cross-reviewed the mathematics and replayed the exact
certificates. The main theorem and example each have a separate
hash-bound independent review. The root additionally evaluated the
two-state cover polynomial directly as a polynomial-valued eight-vertex
integral, independently of the author's edge-subset enumeration.

The [root audit](continuation5_root_audit.json) replayed seven exact
programs and one separate floating diagnostic audit in isolated copies.
All archived values matched, ignoring elapsed time only where recorded;
the frozen packet was preserved. The cone checker covers 55 lemma
comparisons, seven distinct actual roots, eight projection/root
specifications, and thirteen distinct root/tuple pairs. Boundary tuples,
weighted normalization, zero modes, constant-root equality, disconnected
roots and connected roots with disconnected squares are explicit.

To reproduce the full verification without rerunning an optimizer, from
this directory use:

```bash
python continuation5_root_audit.py
```

The exact programs use only the Python standard library. The separate
numerical diagnostic replay requires NumPy and SciPy; the archived audit
records its versions. The cone checker imports the unchanged rational
arithmetic module from the sibling `continuation4` directory. Successful
finite checks are not substituted for universal or asymptotic proofs.

## 5. Remaining obligations and literature scope

The [route registry](continuation5_route_registry.md) retains **two** exact,
distinct open obligations: the actual averaged unequal-star projection
lemma, and a collective all-sheet common-power cover comparison. The
first would extend the projection-channel route; it would not alone
cover every actual root. The second, together with the previously proved
original-law cover entropy lower bound, would imply the target. Both
remain theorem-strength gaps.

The [primary-source scope check](continuation5_literature_scope.md)
records the recent Sidorenko preprint inspected during this consultation.
Its stated graph is not an all-even subdivision of K4, and no result from
that preprint is assumed in any proof here. Neither absent citations nor
the new derivations are used to infer novelty.
