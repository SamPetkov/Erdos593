# Common-power density: signed-channel bounds and exact contraction obstructions

**The unrestricted common-power density inequality remains unresolved. This
packet supplies no admissible finite host with `F<1`.** It proves restricted
contraction theorems for actual nonnegative Markov roots, including a
quantitative signed-channel theorem with arbitrary coarse dynamics and an
extension to unequal original weights. It also certifies failure of broader
coarse domination, even with commuting coarse and channel operators.

This is one coherent follow-up to [PR58](https://github.com/SamPetkov/Erdos593/pull/58)
at `707ce09c971083e9ee533f898aa7a88f075c81ea`, stacked on
[PR57](https://github.com/SamPetkov/Erdos593/pull/57) and
[PR56](https://github.com/SamPetkov/Erdos593/pull/56).
The `continuation2_*` and `continuation3_*` names retain the two bounded
research batches and the user's subsequent request to improve the mathematics.
Every composition and density uses its original measure.

## Exact target retained

For an actual nonnegative self-adjoint Markov root `T=W/p`, write `A=T^2` and
`K_j=A^j`. The target remains

\[
F=\mathbb E_{\mu^4}
K_k(a,b)K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d)\ge1,
\]

with `k>=u>=1`, `r>=l>=1`, `h>=1`. Code tuples use `(k,u,r,l,h)` and edge
order `(ab,ac,ad,bc,bd,cd)`, so the six exponents are `(k,r+h,u,r,u,l)`.
No density, dimension, mixing, spectral-band or novelty premise is added to
this target. The following extra hypotheses belong only to the proved
partial theorems.

## Strongest new quantitative theorem

Let

\[
T((i,a),(j,b))=S(i,j)+H(i,j)ab,\qquad \mu(i,a)=\pi_i/2,
\]

where `S` is an actual nonnegative symmetric Markov kernel, `H` is symmetric,
and `|H(i,j)|<=S(i,j)`. Suppose, in original-`pi` composition,

\[
H^2=\beta\mathrm{Id}+(\alpha-\beta)\Pi,\qquad0\le\alpha\le\beta.
\]

For uniform coarse measure on `m` states, all six independent positive edge
exponents satisfy

\[
\boxed{F(T;n)\ge F(S;n)+
\sum_C[\alpha^{q_C}+(m-1)\beta^{q_C}],\qquad
q_C=\sum_{e\in C}n_e.}
\]

The sum runs over the four triangles and three quadrilaterals. The coarse
kernel `S` is arbitrary. This transfers any established coarse lower bound;
it does not assume an unrestricted proof of `F(S)>=1`.

For unequal original weights with `d=1/max_i pi_i>=4`, the same statement
holds with `d-1` replacing `m-1`. That coefficient is not the centered
dimension. The [uniform proof](continuation3_channel_spectrum.md) and
[weighted extension](continuation3_weighted_spectrum.md) expand the cycle
edges into `Id` and the signed projection `Id-Pi`. Exact contractions retain
the original weights. The uniform three-point exception is settled by an
explicit fourth-moment identity and ordering of common powers.

Strictly positive ten- and twelve-state examples have four entire-centered
values, including zero, and fail both previous compensation tests. Their
all-exponent bounds retain the known coarse surplus and seven additional
cycle terms. All host data are rational and explicit.

## Other complete contraction theorems

| Result | Exact hypothesis and scope |
|---|---|
| [Arbitrary signed binary channel](continuation2_signed_channel.md) | If `S^2=rho Id+(1-rho)Pi`, then `F(S+Hab)>=F(S)>=1` for all six independent positive exponents. Unequal original weights, signed even channel powers and both endpoints are allowed. The first comparison is strict for nonzero `H`. |
| [Coarse Markov-projection extension](continuation3_tensor.md) | If `S^2=rho Id+(1-rho)P` with `P` a nonnegative Markov projection, support forces the even channel powers to preserve its blocks. Conditional transport retains exactly `m_B^-2`, and proves the same contraction. |
| [Actual multiplication-coefficient theorem](continuation2_markov.md) | Nonnegative actual fiber cubic moments and entrywise nonnegative squared coarse channels give contraction for graphs of maximum degree three. Complete bases extend it to every finite graph. Distinct coarse channels need not commute. |

The last theorem uses actual orthonormal fiber functions and their original
probabilities. It neither substitutes arbitrary sources for actual cubic
sources nor assumes a sign gauge that changes the multiplication constants.

## Exact examples and what they establish

| Example | Certified facts |
|---|---|
| Uniform ten-state star | `p=512/2373`, `max A=551157/131072>4`; four entire-centered values including zero. New bound `F>=1+124(341/512)^(2N)+4 sum_C 4096^(-q_C)`. |
| Weighted twelve-state star | `p=1024/9853`, `max A=38294287/4194304>4`; unequal original masses, four centered values including zero, no nonnegative sign gauge for the squared channel. Weighted bound `F>=1+299(1701/2048)^(2N)+4 sum_C 16384^(-q_C)`. |
| Eight-state star channel | `mu=1/8`, `p=2/13`; six positive centered values. The proof rules out all ordered convex-TP2 representations, every proper constant-cross-block module, and every nontrivial tensor-product representation. |
| Weighted six-state signed channel | `p=1/6`, `max A=157/32`; four positive centered values and three frustrated negative off-diagonal channel-square entries. Both old compensation tests fail. |
| Weighted eight-state three-character host | Six positive centered values plus zero; interacting actual character cubic moments, noncommuting coarse channels and a negative eigenvalue of the strictly positive root. This example's base density is already in the earlier compensation class. |
| Six-state conditional obstruction | A fixed coarse-color fiber average is `1-34433/134217728<1`, while the full original-measure density is `1+70177/134217728>1`. Only a pointwise premise fails. |

See the spectrum notes, [channel note](continuation2_markov.md), and
[weighted appendix](continuation2_weighted_examples.md) for matrices, spectra,
normalizations and proofs. No example is claimed to exclude every previous
fixed-host local neighborhood.

## Exact failures of stronger sufficient mechanisms

### Coarse domination can fail even with commutation

[Section 3 of the complete tensor note](continuation3_tensor.md) gives a
strictly positive rational eighteen-state actual root at tuple `(8,2,3,1,1)`
with original weighted commutation `SH=HS` and

\[
\boxed{1<F(T;n)<F(S;n).}
\]

Its coarse square lies in `conv{Id,Pi,P}` for a nonnegative Markov projection
`P`, with all three coefficients strictly positive. The construction embeds
an exact negative trace of three compressed common even powers into actual
block-centered channels. Unequal original block masses amplify that trace
in the unique leading channel triangle. Explicit rational estimates bound
every other cycle and the strictly positive mixing perturbation. The note
proves a positive lower bound for the full target, separately from the
negative coarse difference.

The [ten-state construction](continuation3_markov.md) proves the same failure
without the extra commutation feature. These close the former proposed
obligation that all signed-cycle terms remain nonnegative for arbitrary
coarse kernels. A channel seed alone is never called an admissible host.

### Ordered actual fans can have a negative mode

The [actual thirty-two-state certificate](continuation2_tensor.md) uses root
coefficients `(2^-20,1/8,1/8,1/2,2^-10,1/8)` and tuple `(6,1,1,1,1)`.
Its actual ordered-fan coefficient satisfies `w_1<-2^-57`, whereas the full
original-measure density is exactly `1+G/2^400>1` for the positive integer
printed in the note. This blocks modewise ordered-fan positivity and the
associated PSD reflection premise. It refutes neither the target nor a
complete-cover comparison.

## Bounded numerical work

The [two-cover report](continuation2_optimization_report.md) retains 224
exact rational roots, 2,688 host/tuple evaluations, 18,816 nontrivial cover
comparisons and twelve capped optimizations. **All its base-density hosts
already satisfy the earlier compensation theorem.** The support family has
`p>=2/5`. Tiny negative entries in literal rounded boundary vectors are
explicitly distinguished from the exact admissible rational rays. Full
sample data are retained losslessly in [the archive](continuation2_samples.json.gz).

The subsequent [signed-channel report](continuation3_numerical_report.md)
records 180 exact rational hosts and twelve fixed local starts. It includes
173 sampled hosts and all twelve retained optimizer points with both
`p<1/4` and `max A>4`. Eight starts reached their 100-iteration cap, and four
reported convergence; totals were 1,097 iterations and 29,050 objective
calls. No numerical negative cycle, coarse difference or target difference
appeared. The exact analytic counterexample to coarse domination above
supersedes any universal positivity interpretation of this unsuccessful
scan. Original inputs, starts, all seven cycle values, termination statuses,
exact support/band audits and limitations are retained.

## Reproduce the exact finite checks

The displayed example checkers require only the Python standard library:

```sh
python continuation2_root_verify.py
python continuation2_markov_verify.py > continuation2_markov_checks.json
python continuation2_weighted_channels_verify.py
python continuation3_channel_spectrum_verify.py
python continuation3_optimize_obstruction_verify.py
```

The adjacent `*_checks.json` files contain expected outputs. The new spectrum
checker verifies 144 exact cycle/identity contractions and six fixed actual
hosts, including unequal original masses, equality, disconnected squares,
negative root eigenvalues and tuple boundaries. Exact spectral checks count
all centered zeros. The tensor note supplies complete executable rational
certificates for its compressed-power seed and commuting actual-root embedding.
Numerical engines have their own fixed gates and reproduction commands;
replaying those gates is validation, not new search coverage.

The infinite families are established by the written proofs, not inferred
from the finite computations.

## Independent review, provenance and remaining work

Separate tensor, Markov and numerical agents reviewed the mathematics and
finite certificates. Detached review files bind the exact mathematical
sources and data by SHA256. The earlier provisional characteristic-polynomial
expected value was corrected before publication; the numerical audit also
corrected the scope of target coverage and rounded boundary vectors. The
main proof assumptions are explicit in their statements.

The principal detached reviews are
[uniform channel-spectrum](continuation3_channel_spectrum_review.json),
[weighted theorem and independent exact reconstruction](continuation3_optimize_weighted_review.json),
[weighted and ten-state peer review](continuation3_peer_notes_review.json),
[root review of the actual obstruction](continuation3_root_obstruction_review.json),
[independent eighteen-state audit](continuation3_optimize_obstruction_review.json),
and the earlier [channel](continuation2_channel_review.json),
[weighted examples](continuation2_weighted_review.json), and
[numerical provenance](continuation2_optimize_independent_review.json) reviews.

The [route registry](route-registry.md) retains one precise outstanding
complete-cover obligation, closes the false general signed-cycle premise,
and records verified primary-literature hypotheses. The supplied Dirichlet
reformulation is not counted as progress. No unrestricted completion,
external referee review, literature novelty or new Lean theorem is claimed.
