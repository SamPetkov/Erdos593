# Fifth continuation: bounded unequal-star diagnostics and exact obstruction

## Mathematical verdict

No admissible finite counterexample to `F>=1` was certified. No averaged
projection-star counterexample `J_xyz<rank Q` was found or certified.

The completed exact result is instead the actual pointwise obstruction in
`continuation5_search_pointwise.md`: a strictly positive rational
18-state host, with nine entire-centered square values including zero,
has a negative actual pointwise `(1,2,3)` compressed projection star.
Its averaged star lies strictly between 31 and 32, and its full target
density at `(k,u,r,l,h)=(3,1,1,1,1)` is greater than 15. The pointwise
obstruction is therefore a failure of a sufficient mechanism, not of the
averaged star bound or the requested density inequality.

This report records two completed numerical diagnostics that preceded
the exact construction. The analytic cancellation family supplied by the
independent unequal-star route is stronger than their numerical
cancellation evidence; no numerical priority or theorem is claimed.

## 1. Objects actually searched

Each numerical coarse root was constructed from a nonnegative symmetric
flow matrix `G`, with

`s=G 1`, `pi_i=s_i/sum_j s_j`, `P_ij=G_ij/s_i`.

Thus `P` is row-stochastic, reversible under the original `pi`, and the
relative actual root is `S_ij=P_ij/pi_j`. The powers used throughout are
`K_j=P^(2j)/pi_j`, i.e. the relative kernels of `(S^2)^j` under this same
original probability.

A rank-two Euclidean chart `V=[I_2;Y]` gives the original-law functions
`U_i=V_i/sqrt(pi_i)` and projection

`Q=U (V^T V)^(-1) U^T`.

For each assigned genuinely unequal triple `x<y<z`, the objective was the
actual compressed multiplication-field average

`J_xyz=E_pi tr(C_x(t) C_y(t) C_z(t))`,

where

`C_j(t)=(V^T V)^(-1) U^T diag(pi_i K_j(i,t)) U`.

These coordinate matrices represent PSD operators in a common Gram
metric. They need not be Euclidean-symmetric or commute.

**Scope of the search variables.** Every coarse `S` and original-law
projection `Q` has the stated algebraic form. The sparse flow families do
not enforce `|alpha Q|<=S` for a nonzero channel scale. Consequently the
numerical runs directly test the unrestricted *averaged projection-star
lemma*. They are not a collection of actual binary lifts, complete-cover
evaluations, or full target-density evaluations. A strict candidate would
have required a separate actual-host realization and exact sign
certificate; none appeared. The separate pointwise construction supplies
that complete realization explicitly.

Every triple has the target-compatible interpretation

`(k,u,r,l,h)=(z,x,y-1,1,1)`.

The complementary star of the `bcd` cycle has exponents `(z,y,x)`, and
trace reversal gives the same value as `(x,y,z)`. Since `z>y>x>=1`, these
tuples lie outside all three reflection families in PR #60.

## 2. Frozen designs and caps

Seed: `202610105`. Each stage has exactly twelve archived starts: six on
six coarse states and six on eight coarse states. The three geometries
are rare-state paths, rare-state fans, and sparse transport graphs. Each
geometry appears four times. The twelve triples and exact initial arrays
are stored in the JSON. These targeted designs were chosen to separate
the time scales and rotate the compressed matrix fields; they are not
uniform draws from a host population.

All positive flow entries are exponentials of bounded log variables;
the zero support is fixed. The bounds are `[-24,5]` for each flow log and
`[-8,8]` for each chart coordinate. Optimization uses SciPy L-BFGS-B and
complex-step derivatives of the actual formulas, with one BLAS thread.

Stage one minimizes `J/2` directly. Its per-start caps are 140 iterations,
24,000 objective evaluations, and 30 line-search steps. The retained
points approached the constant-field value 2, making cancellation hard
to assess with that objective alone.

Stage two reuses the same twelve initial points and minimizes a different
fixed objective. Writing `B_j=C_j-I`, define

`P=E tr(B_x B_y+B_x B_z+B_y B_z)`,

`C=E tr(B_x B_y B_z)`.

The exact identity is `J-2=P+C`; the common-power spectral expansion
makes the unregularized `P` nonnegative. The implemented objective is
`C/(P+10^-14)`. Its per-start caps are 180 iterations, 32,000 objective
evaluations, and 30 line-search steps. The regularization is numerical
and is not a claimed inequality. This second stage was motivated by a
concrete limitation of the direct objective and was stopped after its
twelve predefined starts. No further search stages were run after the
exact pointwise construction was completed.

## 3. Completed counts and numerical findings

| Archived diagnostic | Direct `J/2` | Cubic/pair budget |
|---|---:|---:|
| Starts | 12 | 12 |
| Iterations | 1,290 | 1,672 |
| Real objective evaluations | 1,538 | 2,186 |
| All evaluations, including complex-step derivatives | 43,260 | 58,466 |
| Projected-gradient termination | 4 | 3 |
| Iteration cap | 8 | 9 |
| Smallest retained numerical `J` | 2.0000000000892886 | 2.000036732068603 |
| Smallest retained regularized `C/P` | — | -0.9108008774326003 |

The direct minimum is extremely close to the proposed lower bound; its
positive floating-point sign is not promoted to an exact certificate.
The budget minimum retains a positive averaged surplus. Neither minimum
proves a universal inequality. The many capped runs prevent an
interpretation as a completed global minimization.

The archived counts concern the two completed configured stages. During
initial development, a first-case run encountered JSON serialization of
NumPy integer indices before its record was saved; after that input-type
fix, the whole first stage was run from the same seed. That discarded
development attempt supplies no additional mathematical evidence.

## 4. Audit and exact result

`continuation5_search_projection_audit.py` verifies source hashes and the
stage-two dependency hash, replays all 48 start/retained evaluations,
checks normalization, reversible flux, weighted projection identities,
parameter bounds, tuple boundaries and iteration counts, and checks the
centered identity. Replayed scalar values match the stored values in the
same environment. The maximum centered-identity relative discrepancy is
below `6e-15`. Six independent directional finite-difference comparisons
against the complex-step derivatives have relative error below `3e-10`.
These are numerical implementation checks, not exact inequality proofs.

The environment versions recorded by the audit are NumPy 2.3.5 and SciPy
1.17.0. The exact pointwise verifier is independent of both libraries and
uses Python's `Fraction` type throughout its assertions.

The exact construction arose from the reversible-path geometry: different
even times can emphasize different noncommuting frame directions at a
single rare source. Two additional states complete the weighted
projection, and a small global Markov mixture permits an actual signed
channel while preserving the negative pointwise term. Its proof keeps
the original-law average and full-density lower bound explicit. No
additional spectral assumption is asserted for the unrestricted target.

## 5. Files and reproduction

The two optimization scripts reproduce the configured bounded stages:

`continuation5_search_projection_opt.py`

`continuation5_search_projection_budget_opt.py`

Their JSON files preserve all initial and retained arrays, the complete
iteration histories, solver termination messages, and original-law
statistics. The matching `.log` files contain one progress line per
completed start. The source-bound replay is

`python continuation5_search_projection_audit.py`.

The complete actual-host certificate is reproduced with

`python continuation5_search_pointwise_verify.py`.

Only the last command proves the finite sign and density assertions
stated here. The search does not change the verdict on the averaged
projection-star inequality or the unrestricted common-power target.
