# Bounded direct search beyond the balanced-rank and source-cap criteria

## Verdict

The twelve configured runs produced **no strict numerical candidate** for
the actual averaged-star failure `J_xyz < rank Q`. No finite counterexample
was certified. All twelve runs reached their iteration cap. These
computations do not prove the averaged-star inequality, rule out a failure
in the searched charts, or evaluate the full target density `F`.

The parameterization differs from the frozen continuation6 searches:
it uses weighted projections of codimension two or three and ranks eleven
through sixteen, and directly minimizes `J/rank Q`. The earlier searches
used scalar projections/complements, rank-two/three refinable PSD fields,
and a rank-two completion construction. No additional cancellation
objective, restart, or follow-on stage was run here.

## 1. Original-law actual-root and projection chart

Let `G` be the nonnegative symmetric conductance matrix specified by each
case. All diagonal conductances and every listed edge conductance are
strictly positive. Set

\[
s_i=\sum_jG_{ij},\qquad
\pi_i=\frac{s_i}{\sum_js_j},\qquad
(P_0)_{ij}=\frac{G_{ij}}{s_i}.
\]

Thus `P0` is a row-stochastic matrix reversible under the displayed
**original** probability `pi`. With `delta=1/4096`, define

\[
P=(1-\delta)P_0+\delta\mathbf1\pi^\top,
\qquad S(i,j)=\frac{P_{ij}}{\pi_j}.
\]

The relative kernel `S` is symmetric, strictly positive and Markov under
that same probability. Every power used in the objective is

\[
B^s=S^{2s},\qquad K_s(i,j)=\frac{(P^{2s})_{ij}}{\pi_j}.
\]

No independent PSD kernel or artificial nonnegative square root is
substituted. The coarse actual host is `W=pS`, where
`p=1/max_ij S(i,j)>0`, so `0<W<=1` and each original weighted row equals
`p`.

For `q in {2,3}`, let `V` be the `n by q` frame whose last `q` rows are
a positive diagonal matrix and whose other coordinates are optimized.
The fixed row scales are powers of two. Consequently

\[
\Gamma=V^\top\operatorname{diag}(\pi)V
\]

is positive definite, and the relative kernel

\[
Q(i,j)=\frac{\mathbf1_{i=j}}{\pi_i}
       -V_i\Gamma^{-1}V_j^\top
\]

is an original-law orthogonal projection of rank `d=n-q`. This follows
directly by multiplying with `diag(pi)`; its complement is the projection
onto the columns of `V`. The frame chart is rational when conductances
and free frame coordinates are rational. No rational reconstruction was
needed because no strict numerical candidate appeared.

The actual sources are

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_{\operatorname{ran}Q},
\qquad M_s=B^sR,
\qquad J_{xyz}=\sum_t\pi_t\operatorname{tr}(M_x(t)M_y(t)M_z(t)).
\]

They have `E_pi R=I` on the range of `Q`. The numerical implementation
uses their equivalent Euclidean representation

\[
\widehat Q_{ij}=\sqrt{\pi_i\pi_j}Q(i,j),\qquad
M_s(t)=\widehat Q\,D_{K_s(t,\cdot)}\,\widehat Q
\]

on the ambient space; the orthogonal complement contributes zero to the
trace. Hence the optimized quantity is the actual projected star.

Strict positivity also permits an actual binary projection channel with
`alpha=delta/(2 max|Q|)` and root `S+sigma*tau*alpha*Q` under original
law `pi/2`. The audit checks that bound. No binary-host density is computed
and this permission is not presented as a full-target reduction.

## 2. Fixed geometries and scope

The first conductance support is an asymmetric fork: two arms of unequal
shape and conductance scales end in a slowly communicating reservoir.
The second is a weighted path with alternating traps and an interior
bypass edge. All conductances are symmetric. Their differing transition
probabilities arise from the original row sums; no directed root is used.

The fixed grid contains two supports, two codimensions, and three state
counts `n=14,16,18`, for twelve starts. Its ranks are `11,12,13,14,15,16`.
All triples are positive and unequal. Each triple `(x,y,z)` corresponds
to the actual complementary star of the admissible target tuple
`(k,u,r,l,h)=(z,x,y-1,1,1)`. This is a correspondence of the star
exponents; it is not an evaluation of the complete target `F`.

The stored actual square spectra are floating diagnostics. No exact
claim about the number of distinct or interacting spectral bands is
made. The chart imposes no two-band, simultaneous-diagonalization, visible
trace balance, or source-cap condition.

## 3. Completed counts and outcomes

Seed: `202610107`. Solver: L-BFGS-B, complex-step derivatives, one BLAS
thread. Each case has a fixed cap of 200 iterations, 32,000 objective
evaluations, and 25 line-search steps. Conductance logarithms lie in
`[-18,5]`; free frame coordinates lie in `[-8,8]`. The objective is
`J/rank Q`. The predeclared early-stop trigger was `J/rank Q<1-10^-6`,
which would have required exact reconstruction before any failure claim.

All twelve starts completed their 200-iteration limit. There were
**2,400 completed iterations, 2,740 real objective calls, and 181,001
total calls including complex-step derivative evaluations**. No run
terminated by a gradient/convergence criterion or by the evaluation cap.
All initial and retained coordinates, their original laws, actual roots,
relative projections, iteration histories, and solver termination
messages are archived.

The table gives retained floating values. The source cap shown is the
actual shortest-time cap `max_t ||M_x(t)||op`; for triples beginning with
`x=2`, this is smaller than the first-step cap stored separately.

| Case | States | Rank | Triple | Retained J/rank | Shortest-time source cap |
|---:|---:|---:|---|---:|---:|
| 0 | 14 | 12 | (1,2,3) | 3.55447309509 | 34251.6812 |
| 1 | 14 | 12 | (1,2,8) | 1.55360479371 | 64327.2120 |
| 2 | 14 | 11 | (1,3,16) | 1.60368891792 | 3785.86901 |
| 3 | 14 | 11 | (2,3,7) | 1.00092644154 | 2049.96578 |
| 4 | 16 | 14 | (1,4,12) | 2.73739230608 | 3979.25957 |
| 5 | 16 | 14 | (2,5,13) | 1.01032171036 | 91506.6634 |
| 6 | 16 | 13 | (1,2,3) | 3.77422142602 | 67833.6682 |
| 7 | 16 | 13 | (1,2,8) | 1.73811547899 | 188155.532 |
| 8 | 18 | 16 | (1,3,16) | 3.55322018571 | 3653.65094 |
| 9 | 18 | 16 | (2,3,7) | 2.88036494522 | 34733.2452 |
| 10 | 18 | 15 | (1,4,12) | 2.46281002530 | 25570.0471 |
| 11 | 18 | 15 | (2,5,13) | 1.03439903270 | 392226.971 |

Every retained shortest-time cap lies far above `4+4 sqrt(2)`, and every
retained visible trace has substantial variation. For the closest case,
the first-step cap is about `392593.89`, its first-step trace residual
`max|tr M_1-d|` is about `405594.98`, and its shortest-time trace residual
is about `2166.99`. Thus the numerical cases do test outside the two
continuation6 criteria. Their positive retained values are not evidence
of a uniform or global lower bound.

## 4. Independent replay

`continuation7_opt_highrank_audit.py` performs no optimization. It replays
all 24 initial/retained evaluations and independently reconstructs the
original-law relative projection from `V` and its weighted Gram matrix,
without using the optimizer's Euclidean projection or compressed fields.
It then evaluates

\[
\sum_{t,a,b,c}\pi_t
(P^{2x})_{ta}(P^{2y})_{tb}(P^{2z})_{tc}
Q(a,b)Q(b,c)Q(c,a)
\]

directly. This is the original-law star because each original factor
`pi_a K_x(t,a)` equals `(P^(2x))_ta`; the cancellation is explicit and
does not change measure.

The replay also checks original-law normalization, reversible root
symmetry, weighted projection multiplication and trace, the centered
pair/cubic expansion, admissibility of `W=pS`, and positivity of the
permitted binary channel. The largest scaled discrepancy is
`8.437775604747404e-13`, under the predeclared numerical audit tolerance
`2e-8`. The smallest archived original atom mass is approximately
`4.703196867311648e-10`.

The minimum independently replayed retained ratio is
`1.0009264415412857`. No floating sign is a proof. No exact-sign
certificate is inferred from agreement between implementations.

Versions: Python 3.12.14, NumPy 2.3.5, SciPy 1.17.0. Run
`python continuation7_opt_highrank_audit.py` for replay only. Running
`continuation7_opt_highrank.py` would repeat the bounded optimization;
it is not needed to audit this record.

## Remaining scope

This record leaves the same general actual-star obligation open. It adds
no further theorem-strength missing lemma. The full target and the
simultaneous-cover route remain separate from these diagnostics. No
literature priority, novelty, asymptotic coverage, or Lean acceptance
claim is made.
