# A connected transfer result, not a universal reduction

## Exact original-law contract

Let `pi_i>0`, `sum pi_i=1`, on `n>=4` states. Let `S` be a symmetric
nonnegative Markov relative kernel on that law. Choose arbitrary signs
`f_i=+-1`; neither centering nor an eigenfunction condition is assumed.
Define the orthogonal rank-`d=n-1` projection

\[
Q(i,j)=\mathbf1_{i=j}/\pi_j-f_if_j,\qquad
\delta=\max_i|\pi_i^{-1}-n|.
\]

Require

\[
\delta<n-2,\qquad
\delta^2(n+\delta-1)\le8(n-3)(n-2-\delta).
\]

Let `H` be self-adjoint, `H^2=beta Q`, `beta>=0`, and entrywise
`|H(i,j)|<=S(i,j)`. The lifted law is `mu(i,epsilon)=pi_i/2`; its actual root is

\[
T((i,\epsilon),(j,\eta))=S(i,j)+\epsilon\eta H(i,j).
\]

For six positive integers `a_e`, define `F(a;R)` by integrating the product
of `R^(2a_e)` over the four original-law vertices of `K4`. All powers and
integrals use the relevant original measure, not a spectral surrogate.

## Complete analytical deduction

For the four triangles and three quadrilaterals `C` of `K4`, put
`q_C=sum_(e in C) a_e`. Then

\[
\boxed{F(a;T)\ge F(a;S)+(n-1)\sum_C\beta^{q_C}.}
\]

Thus a valid coarse density bound transfers to the fine root. If `beta>0`
the margin is strict. A fine violation would force a coarse violation;
the coarse density would be strictly smaller only when `beta>0`.
At `beta=0`, `H=0` and both densities agree.

The sufficient range `delta<=1` works for every `n>=4`; it is not a
tuple-specific continuity radius. The statement permits arbitrarily many
coarse spectral values. An existing 13-state weighted example yields an
unbalanced rank-twelve channel with fourteen values on the entire fine
centered space, including zero. No arbitrary projection/root reduction follows.

### Stronger retained remainder

Write `B=S^2`, `sigma_t=tr(B^t)-1`, `b0=n-2-delta`, and
`b1=b0-delta^2(n+delta-1)/(8(n-3))>=0`. For each triangle order the three
complementary-star exponents as `x<=y<=z`. In addition to the boxed margin,
retain

\[
\sum_{C\text{ triangle}}\beta^{q_C}
\left[b_0\sigma_{x+z}+b_1(\sigma_{x+y}+\sigma_{y+z})\right].
\]

All centered modes are retained, including additional eigenvalue-one modes
and zero modes. This quantitative refinement is not a claim that every
individual cubic summand is positive.

### Proof location and provenance

The main manuscript states the proposition and its scope; Appendix B gives
the full trace/Schur-form proof and seven-cycle transport. Its input source
identity is audited at the fixed PR63
[weighted-complement note](../2026-10-10-common-power-density/continuation7/continuation7_source_weighted_complement.md).
The new manuscript deduction combines that triangle estimate with the exact
binary-channel expansion and the quadrilateral two-PSD comparison. Actual
separate-agent review approved the final proposition and proof. No numerical
diagnostic is used as a substitute for this analytical argument.

## Why this belongs in the story

The classification identifies rigid allowable cores; canonical atoms expose
flexible finite assembly. Quantitative questions on the resulting graph cores
then ask how a global budget survives local signed defects. The transfer
theorem supplies one precise mechanism: nonuniform cubic error can be absorbed
by quadratic surplus, retaining rather than discarding the coarse contribution.
This is more informative than a list of host tests, but is still structured
mathematics, not an exceptional-advance designation or novelty clearance.

## Two distinct remaining routes

Give the conjectural programme real mathematical space without presenting it
as a proved extension. These are research obligations, not ready service jobs.

1. **Source geometry.** Seek a verifiable invariant wider than flat complements,
   caps, visible balance or zero cubic trace which controls the actual averaged
   projection-star contraction. A counterexample to `J>=rank(Q)` must retain
   an actual nonnegative root and original weights. A positive answer alone
   still needs a route from arbitrary roots to a controlled channel class.
2. **Global cover compensation.** Seek an original-law simultaneous-cover
   argument beyond connected degree three, allowing genuinely noncommuting
   monodromy. The finite list does not induct to all degrees automatically.
   An obstruction to cover domination need not be a density counterexample:
   the underlying `F>=1` can survive failure of that proof route.

Neither route permits discarding negative modes or assuming positivity of a
triple PSD trace. An unrestricted proof must handle the full actual root,
all required exponent tuples and compatibility across every edge. These
obligations have not been hidden behind the transfer statement.

The arbitrary finite-alphabet exact-edge entropy question is a separate
remaining target. Inaccessible consultation text cannot be used to close it.
The prior two-level/cone and local exact-marginal results remain restricted.
No general majorization programme or unrelated theorem inventory is added.

## Formalization boundary

The accepted structural Lean baseline remains unchanged. This transfer and
the research stack's entropy/density arguments are analytical manuscript work,
not accepted Lean endpoints. A later formalization checkpoint must freeze
weighted kernel composition, actual root admissibility, trace identities,
mode conventions and the exact comparison before compiling. No compiler,
Aristotle request, Pro request or proof-budget reset occurred in this pass.
