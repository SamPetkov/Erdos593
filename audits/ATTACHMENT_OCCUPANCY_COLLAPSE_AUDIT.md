# Audit of the canonical attachment occupancy collapse

## Verdict

The occupancy reduction is an exact consequence of the coefficient formula
from the capacity-respecting attachment enumeration.  Its load-bearing
substitution is

\[
(v-1)_{t-1}=(v)_t/v,
\qquad
v=\sum_i|V(A_i)|-k+1.
\]

The resulting normalized coefficients are exactly the classical occupancy
probabilities for `k-1` labelled balls and `v` labelled boxes.

## Dependency boundary

This extension depends on the exact quotient-attachment count

\[
N_t=P S(k-1,t)(v-1)_{t-1}
\]

from the immediately preceding PR.  It does not independently re-prove the
bipartite Prüfer enumeration or the injective-port condition.

It uses only:

- the Stirling falling-factorial identity;
- elementary balls-into-boxes counting;
- the differential recurrence for the occupancy polynomial;
- an interlacing sign argument;
- Newton inequalities;
- indicator-variable moment calculations; and
- the elementary central limit theorem for bounded independent Bernoulli
  triangular arrays after real-root factorization.

## Counting convention audit

The counted objects are quotient equivalence relations on fixed labelled atom
vertex sets.  Shared points have no external labels.  Atom labels and all
internal vertex labels are retained.  The count is not divided by automorphism
groups and does not count histories of binary amalgamation operations.

The factor

\[
P=\prod_i|V(A_i)|
\]

comes from one anchor choice per atom in the normalized Prüfer encoding.  The
remaining alphabet has exactly

\[
1+\sum_i(|V(A_i)|-1)=v
\]

symbols.  The first code position is fixed to the special symbol.  This is why
the normalized code count is `v^(k-2)`, not `v^(k-1)`.

## Profile-law audit

A code-value block of size `r` corresponds to one shared point of excess `r`,
hence physical multiplicity `r+1`.  The occupancy load profile therefore
matches the shared-point excess profile, not the raw multiplicity profile.

For counts `c_r`, the denominator

\[
\prod_r c_r!(r!)^{c_r}
\]

has two distinct roles:

- `(r!)^(c_r)` forgets order inside every load block;
- `c_r!` forgets permutations among boxes carrying the same load.

No additional `t!` factor is present because `(v)_t` already selects and orders
the occupied boxes before equal-load symmetries are removed.

## Quotient-order audit

For a connected assembly,

\[
v=\sum_iw_i-k+1
\]

is the actual number of quotient vertices.  Total atom vertex counts `w_i`
are required.  Replacing them by bipartite-core orders gives a false formula.

Every canonical atom has at least three vertices, so `v>k-1`.  This guarantees
that all coefficients through degree `k-1` are positive and that the
real-rooted polynomial has full degree.

## Real-rootedness audit

The proof is self-contained.  It does not infer real-rootedness merely from
ordinary log-concavity.  The exact recurrence is

\[
\Omega_{h+1,v}=vz\Omega_{h,v}+z(1-z)\Omega'_{h,v}.
\]

At every old negative root `rho`, the new polynomial has sign

\[
\operatorname{sgn}(rho(1-rho)\Omega'(rho)),
\]

which alternates.  The sign immediately left of zero and the leading sign at
negative infinity supply the two endpoint intervals.  The proof counts all
roots, so simplicity and strict interlacing are not inferred from a numerical
plot.

The Poisson--binomial representation is distributional.  It follows by
factoring the probability generating polynomial over its negative roots.  It
must not be interpreted as independence of physical shared-point events.

## Asymptotic audit

Two regimes are separated explicitly.

1. `k` fixed and `v -> infinity`: the binary endpoint has probability tending
   to one.
2. `k -> infinity` and `v/(k-1) -> gamma`: the number of shared points is
   asymptotically a nontrivial linear fraction of `k`.

The second regime prevents an incorrect extrapolation of binary dominance to
lists of many fixed-size atoms.

For proportional capacity, the variance constant is

\[
\gamma e^{-1/\gamma}-(\gamma+1)e^{-2/\gamma},
\]

which is positive for the relevant range `gamma >= 1`.  The CLT uses the
Poisson--binomial representation and linear variance; no independence claim is
made for the original occupancy indicators.

For fixed `r`, the law of large numbers for `C_r` uses the exact two-box load
probability and `Var(C_r)=O(k)`.  No statement about the maximum load is made.

## Component audit

For a prescribed atom-label component partition, each block is counted by the
connected formula and the product is exact.  A singleton block contributes one
quotient.  Writing its formal factor as `w_i * w_i^(-1)` is only a mnemonic;
no negative-power integer arithmetic is used in the verifier.

When only the number of components is specified, the sum is over set
partitions of atom labels.  It is not a sum over integer partitions of `k` and
not an unlabelled component count.

## Edge cases

- `k=1`: one quotient, zero shared points; the total formula is stated
  separately.
- `k=2`: exactly one shared point, and the total count is `w_1 w_2`.
- `t=1`: all atoms meet at one shared point.
- `t=k-1`: all shared points are binary.
- repeated atom isomorphism types do not change the labelled formulas but do
  matter for any future automorphism quotient.
- disconnected systems require a prescribed or summed atom-label set
  partition as in the component theorem.

## Executable audit

The standard-library verifier checks:

- the coefficient-to-occupancy identity and total count over 260 parameter
  pairs and 2,730 coefficient positions;
- 29,372 normalized occupancy words and 76 complete load profiles;
- 260 exact mean/variance comparisons and 1,170 factorial-moment identities;
- 260 exact Sturm root counts, certifying 2,470 negative roots;
- 2,223 strict ultra-log-concavity inequalities;
- 1,365 fixed-load expectation identities; and
- 275 prescribed component-partition factorizations.

Sturm sequences are computed over exact rational arithmetic.  No floating-point
root finder is used.

## Non-goals

The audit does not certify:

- unlabelled isomorphism counts;
- automorphism-weighted generating functions;
- a closed form for the individual Bernoulli parameters;
- growing-load extreme-value asymptotics;
- the canonical atom theorem itself; or
- any new Lean endpoint.
