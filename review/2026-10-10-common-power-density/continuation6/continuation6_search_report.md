# Bounded continuation6 diagnostics for the averaged projection star

## Verdict and scope

These computations produced **no strict numerical candidate** for the
averaged-star violation `J_xyz<rank Q`, and no exact violation was
certified. They do not prove the averaged-star inequality or the full
common-power density inequality. No complete target `F` optimization or
counterexample certificate is claimed in this record.

The mathematical results in this continuation are established in the
separate Jordan, vanishing-cubic-source, and uniform codimension-one
notes. The numerical evidence here is only
a bounded adversarial check of three additional parameterizations. In
particular, the retained values close to `J=rank Q` are within the scale at
which floating-point roundoff matters; their printed positive signs are
not certificates.

## Three fixed stages

All roots use the ORIGINAL stationary probability obtained from a
nonnegative symmetric flow: `s_i=sum_j G_ij`, `pi_i=s_i/sum_j s_j`, and
`P_ij=G_ij/s_i`. The relative root is `S_ij=P_ij/pi_j`, its square is the
actual `B=S^2`, and every power is computed as `P^(2s)` under this same
law. No independent commuting kernels are substituted.

The first stage searches scalar projections and complements of scalar
projections on 8, 10, and 12 coarse states. A probability vector `q`
defines the Euclidean projection `Qhat=ww^T`, `w_i=sqrt(q_i)`, or
`Qhat=I-ww^T`. Relative original-law kernels are obtained by dividing the
`ij` entry by `sqrt(pi_i pi_j)`. Thus the ranks are one and `n-1`.
The geometries are rare geometric paths, rare bipartite flow graphs, and
two reservoirs with rare intervening atoms.

The second stage uses the exact rank-one-refinement realization proved in
this continuation. On 4, 5, or 6 coarse states, with matrix dimension two
or three, let `V_last=I`, `D_i=V_i V_i^T`, and `Gframe=sum_i D_i`. In the
common Gram metric the field is

`C_i=Gframe^(-1) D_i/pi_i`, with `E_pi C_i=I`.

It is PSD in that metric. The positive-exponent field is `B^s C`. For a
concrete refinement, set `mu(i,a)=pi_i/d`,
`U_(i,a)=sqrt(d/pi_i) V_i[:,a]`, and
`Q((i,a),(j,b))=U_(i,a)^T Gframe^(-1) U_(j,b)`. Pulling back the actual
coarse root gives exactly the same averaged star after every positive
power. Thus this stage is not an arbitrary-source relaxation. A proposed
strict failure would still require rational reconstruction and exact
verification; none appeared. The sparse coarse roots do not automatically
permit a nonzero binary projection channel on their zero entries, and no
full binary-host count is claimed.

The third stage directly varies the positive completion cost in the
previous exact pointwise-negative path construction. It uses a seven-state
geometric path plus two completion states, a rank-two projection with the
last two frame rows fixed to the identity, and a positive refresh
`S=(1-delta)S0+delta Pi`. Both component masses and frame coordinates vary.
This stage had already finished when the request to stop optional searches
arrived; no further optimization was launched afterward.

Every tested triple has three distinct positive exponents. It corresponds
to the admissible target tuple `(k,u,r,l,h)=(z,x,y-1,1,1)` via the
complementary star `(k,r+h,u)=(z,y,x)`. This correspondence identifies the
actual star; it does not turn a star computation into a full density
computation.

## Caps, counts, and numerical outcomes

These counts cover the three retained, configured search stages. Other
exploratory scalar and cover probes from this consultation are not included
in this record or used as evidence. Each recorded stage was run once from
its frozen seed. The first minimizes
`Cubic/(Pair+10^-14)`. The other two have preconfigured cancellation and
direct `J/d` cases. The denominator regularizer is numerical and is not a
mathematical assumption. Every solver is L-BFGS-B with complex-step
derivatives and one BLAS thread. The scripts retain all initial and best
parameters, iteration histories, termination messages, and original-law
data.

| Stage | Starts | Iteration cap per start | Iterations completed | Real objective calls | All calls, including complex-step derivatives |
|---|---:|---:|---:|---:|---:|
| Scalar / codimension one | 18 | 180 | 1,900 | 2,465 | 100,910 |
| Refinable PSD fields | 24 | 200 | 3,569 | 4,373 | 157,792 |
| Path completion cost | 12 | 400 | 1,807 | 2,429 | 60,725 |
| Total | 54 | — | 7,276 | 9,267 | 319,427 |

The configured objective-evaluation caps are respectively 36,000, 44,000,
and 44,000 per start; all stages allow at most 30 line-search steps.
There are 27 gradient/convergence terminations and 27 iteration-cap
terminations. This is not a global optimization certificate.

The minimum retained numerical `J/d` values are respectively
`1.0000002817904654`, `1.0000000000017175`, and
`1.000000000135019`. The closest-to-baseline values are not interpreted
as exact signs.

The strongest retained cancellation diagnostic occurs in the PSD-field
stage, case 2:

`Pair=64674.77650298578`, `Cubic=-64663.455002553004`,
`Cubic/(Pair+10^-14)=-0.9998249472043826`,
`J=13.32150043276144`, `rank Q=2`.

Its positive averaged surplus is large. This numerical near-cancellation
is weaker evidence than the exact asymptotic cancellation family already
proved in continuation5; it is not presented as a new theorem.

## Replay and limits of the audit

`continuation6_search_audit.py` performs no optimization. It checks source
hashes, replays all 108 start/retained evaluations, checks original-law
normalization, reversible flux, and projection identities, and independently
contracts the original-law three-leaf triangle source. For every PSD-field
case it also checks the rank-one refinement transport using the full
refined root and projection.

Stored objective values replay exactly in the same environment. The
largest relative discrepancy between independently assembled compressed
operators and stored `J` is about `1.65e-10`; the largest centered-identity
scaled discrepancy is about `3.68e-10`. These worst errors occur in the
very rare completion charts, where the smallest original mass is about
`5.83e-29`. The original provisional centered-identity audit tolerance of
`2e-12` did not hold for that stage; the audit records the observed errors
and uses an explicit `1e-8` diagnostic tolerance. This is a numerical
conditioning limitation, not a sign certificate or a mathematical fix.
The PSD-field refinement discrepancy is below `2.11e-12`, and its worst
weighted-projection discrepancy is below `6.52e-14`.

Versions: Python 3.12.14, NumPy 2.3.5, SciPy 1.17.0. Reproduction commands
are the three `continuation6_search_*_opt.py` files for the frozen bounded
runs, and `python continuation6_search_audit.py` for replay only. The JSON
and log files preserve the completed counts, including every capped run.
No additional stages, retries, full-density samples, or exact certificates
are silently included in these counts.
