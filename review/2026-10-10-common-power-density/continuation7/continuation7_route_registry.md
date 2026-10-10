# Distinct mechanisms and exact remaining scope

**Unrestricted verdict:** no complete proof of the requested common-power
density inequality and no admissible finite `F<1` are established. All
six powers remain powers of one actual nonnegative self-adjoint Markov
root under the original finite positive probability. No novelty or
B-level assumption is introduced.

The base is PR62 at `bb919054eab3248e45ce1cd0c9a8cf1f39329025`.
PR62 was open, draft and unmerged, with no new comments or reviews when
this pass began. The previous route history is retained in
[continuation6](../continuation6/continuation6_route_registry.md).

## Route A: actual cubic multiplication tensors and retained surplus

**New proved mechanism.** For the flat complement `Q=I-f tensor f`, with
`f_i=+-1` under nonuniform original `pi`, put `a_i=1/pi_i-n`. The
compressed cubic multiplication tensor splits exactly into a uniform
positive part and one error in the same Schur form:

\[
C=(n-3)\langle1,H1\rangle+\langle a,H1\rangle,
\quad H=(B^x-Pi)\circ(B^y-Pi)\circ(B^z-Pi)\succeq0.
\]

Completing this square bounds the negative contribution by
`<a,Ha>/[4(n-3)]`. Original-law diagonal bounds and Hilbert--Schmidt
norms reduce that error to quadratic spectral quantities. The retained
pair surplus absorbs it under the explicit reciprocal-mass criterion in
the [weighted theorem](continuation7_source_weighted_complement.md).
This is uniform over roots and exponents within the stated class; it is
not a fixed-host local radius and not a sign assumption on the cubic.
An actual negative cubic sanity example confirms the distinction.

**Limits identified.** Arbitrary projections do not satisfy the exact
flat-complement tensor identity. Larger reciprocal-mass errors are not
absorbed by the displayed constants. A size-biased change of law would
need a different Markov transport; no such normalization is asserted.
These limits belong to U below, rather than being labeled routine final
compatibility checks.

**Actual-host search.** Twelve fixed direct `J/rank` starts used weighted
codimension-two/three projections of ranks eleven through sixteen. Every
retained field was far outside the previous source-cap test and had
varying visible trace. No strict candidate appeared. The solver caps,
unconverged termination messages and independent original-law replay
are in the numerical report. Absence of sampled violations is not a
theorem about U.

## Route B: complete covers and exact character-flow budgets

**New proved mechanism.** The supplied sign host's actual cubic moments
give a three-bit character-flow representation of every complete lifted
partition function. Gauge fixing and finite group classification reduce
all connected degree-two and degree-three covers to 48 explicit types.
Each full defect polynomial retains negative coefficients. A rational
bound on the entire negative tail proves the comparison for every
`k>=4` in the fixed tuple family, including 28 noncommuting types.
Thirty-six connected types are genuinely beyond the prior one-edge
cover family; twelve overlap it.

**Original-law transport is proved.** Vertexwise sheet relabeling
permutes the actual independent variables. The chord subgroup orbits
are the cover components, whose integrals factor because they use
disjoint original variables. No component law is normalized. This
extends the certificate to every total sheet count whose component
degrees are at most three.

**Limits identified.** The polynomial enumeration is not a proof
uniform in connected covering degree. It also fixes the actual host
and the tuple family. The proof does not supply all of C below, nor
does the previous single-edge power-sum argument control a general
multi-edge transfer. A too-large provisional coefficient margin
`2^-30` failed; the checked final margin is `2^-60`. No cover defect
failed in the exact certified family.

**Actual-host diagnostics.** The bounded 1,512-comparison double-cover
scan found no violation above its tolerance. It used actual reversible
integer-flow roots and original row-sum laws. It is not a universal
cover proof.

## Adverse check: the ordered ac-mode shortcut is false

This pass separately tested a plausible consequence of `k>=u` and
`r>=l`: nonnegativity of each active coefficient obtained by expanding
only the `ac` edge. This is not the previously refuted `ab` mode and
does not replace an actual eigenfunction by an arbitrary source.

The exact ten-state positive rational host at `(8,1,2,1,1)` refutes
this shortcut. A positive commuting trace-one rational spectral filter
has a negative weighted ac average, root invertibility makes every
mode active, and the constant coefficient is positive. Hence a
centered actual active mode is negative. The same certificate gives
`F>4`. The [complete note](continuation7_opt_ac_obstruction.md) and
[discovery provenance](continuation7_opt_ac_discovery.md) distinguish
all exploratory checks from the final integer certificate.

This sufficient lemma is closed as false. It does not establish failure
of the complete density, its monotonicity in `h`, U or C. It creates no
third missing theorem obligation.

## Checked literature scope

The new algebraic proofs use no unverified literature premise. The
positive 26-state density example explicitly invokes the earlier
projection four-cycle lemma and the already checked common-order
convex-TP2 density theorem; the latter is applied to the unrefreshed
TP2 path and its convex powers, not to an unproved assertion that the
refreshed root is TP2.

The primary text of A. Sidorenko, *Inequalities for doubly nonnegative
functions*, Electronic Journal of Combinatorics 28(1), P1.32 (2021),
[arXiv:1905.08210v3](https://arxiv.org/abs/1905.08210), was rechecked.
Corollary5.2 concerns complete graphs evaluated with one common doubly
nonnegative kernel. Definition(1.3) of extra-goodness retains vertex
weights through the geometric-product function with exponent
`1/(2e(G))`; Corollary6.4 includes trees. These precise statements do
not by themselves assert the six independently timed powers here or
the mean-one scalar three-source contraction. No such transfer is
claimed. This observation is a hypothesis check, not an assertion of
literature novelty or a new obstruction.

## Exactly two unresolved theorem-strength obligations

### (U) General actual averaged projection stars

For every original finite positive `pi`, actual nonnegative symmetric
Markov root `S`, `B=S^2`, original-law orthogonal projection `Q` of
rank `d`, and positive integer triple, with the actual fixed source

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_{\operatorname{ran}Q},
\]

prove or refute

\[
\mathbb E_\pi\operatorname{tr}[(B^xR)(B^yR)(B^zR)]\ge d.
\]

This is an auxiliary source theorem with its own realizability
constraints, not the supplied Dirichlet defect renamed. Its general
truth would extend projection-channel surplus comparisons while
retaining a separately controlled coarse density term. No reduction
of every target root to those channels is supplied or assumed.

### (C) Arbitrary simultaneous original-law covers

For every actual target host and admissible tuple, every sheet count
`M` and six permutations `sigma_e`, define

\[
Z_\sigma=
\mathbb E_{\mu^{4M}}
\prod_{e=vw}\prod_{s=1}^M
K_{n_e}(x_{v,s},x_{w,\sigma_e(s)}).
\]

Prove or refute

\[
Z_\sigma\le F^M.
\]

The earlier original-law type/entropy lower bound
`limsup_M(E_sigma Z_sigma)^(1/M)>=1` would turn a full C proof into
the target. C is a stronger, structurally different cover comparison;
a C counterexample would still require a separate exact `F<1`
calculation before it could refute the user's target. The present
finite type certificates do not settle arbitrary connected degree.

These two obligations remain substantive. Neither is called a final
routine normalization, a modewise PSD fact, or a consequence of the
unchanged Dirichlet reformulation. The consultation is bounded and
contains no automatic retry or continuation promise.
