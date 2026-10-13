# Third continuation: bounded signed binary-channel experiment

## Verdict and scope

This finite experiment found no negative individual channel-cycle contribution, no failure of coarse-density monotonicity, and no instance of the target density below 1. It proves none of those universal assertions. In particular, the accompanying analytical work constructs a separate obstruction to unrestricted signed-channel coarse monotonicity; this unsuccessful numerical search must not be used to assert that stronger property.

The completed run consists of **180 exact rational hosts**, followed by **12 local optimization starts**, with every start capped at 100 iterations. The search used coarse state counts 3, 4, and 5, hence actual fine hosts of 6, 8, and 10 states. All 180 original measures are nonuniform. The coarse three-state hosts are controls: their entire centered coarse space has at most two spectral values.

An exact rational audit confirms that 177 sampled hosts have maximal normalization `p < 1/4`; 173 have both `p < 1/4` and `max A > 4`. This reaches beyond the blanket `p >= 1/4` compensation condition that covered the preceding sign-host batch. It does not establish failure of every previously proved sufficient condition. No root, tuple, or measure from this experiment is offered as a counterexample to the requested density inequality.

## Actual-host parameterization and original measure

Let `G` be a symmetric nonnegative matrix with positive row sums `s_i`, let `C = sum_i s_i`, and define

\[
\pi_i=s_i/C,\qquad S_{ij}=\frac{C G_{ij}}{s_i s_j}.
\]

Choose a symmetric matrix `q` with `|q_ij| <= 1` and set `H_ij = S_ij q_ij`. The fine state space is the set of pairs `(i,a)` with `a` in `{-1,+1}`, with its **original measure** `mu(i,a)=pi_i/2`. Define

\[
T((i,a),(j,b))=S_{ij}+abH_{ij}.
\]

This kernel is symmetric and nonnegative. Summation over `b` gives every original-`mu` weighted row sum equal to 1. Thus `A = T^2` is an actual entrywise nonnegative, self-adjoint PSD Markov square. Taking `p=1/max T` and `W=pT` gives `0 <= W <= 1` with every original-`mu` weighted row sum equal to `p`.

The even and odd binary-fiber subspaces are invariant. Consequently

\[
T^{2e}((i,a),(j,b))=S^{2e}(i,j)+abH^{2e}(i,j),
\]

where both coarse compositions use the original `pi`. The numerical implementation uses the ordinary transition matrices `P_S(i,j)=G_ij/s_i` and `P_H=P_S*q`, raises them to the even exponent `2e`, and divides column `j` by `pi_j` to recover the relative-measure kernel. It does not replace operator multiplication by entrywise multiplication.

Samples use the frozen integer `G`, integer channel numerators, and channel denominator 8. Every reported optimization best point stores symmetric nonnegative binary64 `G` and a symmetric binary64 `q` in `[-1,1]`. Interpreting those stored finite floats as exact dyadic rationals gives an exact admissible root by the same formulas. This parameterization uses no subtraction to force a boundary and needs no tolerance-based claim of root nonnegativity. Numerical powers and contractions remain floating-point evaluations of those admissible inputs.

## Exact decomposition evaluated

The tuple order is `(k,u,r,l,h)`. In edge order `(ab,ac,ad,bc,bd,cd)`, the six powers of `A` are

\[
(k,r+h,u,r,u,l).
\]

Only even-degree subsets survive averaging the four independent binary signs. For the simple graph `K4`, these are the empty subset, its four triangles, and its three 4-cycles. Therefore the exact identity is

\[
F_{\rm fine}=F_{\rm coarse}+\sum_{C\in\mathcal C}\Gamma_C,
\]

where each `Gamma_C` uses `H^(2e)` on the cycle edges and `S^(2e)` on the remaining edges, integrated against the original fourfold `pi` measure. The seven cycle edge-index sets, numbered from zero, are

```
0: (0,1,3)       1: (0,2,4)       2: (1,2,5)       3: (3,4,5)
4: (0,3,5,2)     5: (0,4,5,1)     6: (1,3,4,2)
```

A negative `Gamma_C` would refute the corresponding individual-cycle sufficient lemma. A negative sum of these seven terms would refute the stronger coarse-monotonicity statement. Either could occur while the requested `Ffine >= 1` remains true; those flags are kept separate in the exact certificate schema.

The local objective divides a cycle's signed sum by the sum of the absolute values of that cycle's individual weighted integrand terms. The total-monotonicity objective divides the sum of the seven signed cycle sums by the sum of all seven absolute integrand sums. This normalization reduces the flat behavior from scaling `H` close to zero. It introduces no mathematical positivity inference.

## Frozen design and completed counts

The configuration seed is **20261013**. It contains all 180 exact host inputs, their assigned tuple, the numerical caps, and a SHA256 binding of the search source. No unrecorded random inputs are needed to reproduce this batch.

For each `n` in `{3,4,5}`, there are ten hosts from each of six integer-flow families: diagonal weights, weighted stars, weighted paths, sparse integer flows, bridged blocks, and dense flows spanning powers of two. The generator often makes one state rare by reducing its incident integer flows. Some channel matrices use general multiples of `1/8`; others use only signs. The frozen configuration is the authoritative list of actual inputs.

The 12 tuples are below. Each was assigned to exactly 15 hosts; this is **180 host–tuple pairs**, not the Cartesian product of all hosts and tuples.

| `k` | `u` | `r` | `l` | `h` |
|---:|---:|---:|---:|---:|
| 1 | 1 | 1 | 1 | 1 |
| 2 | 2 | 1 | 1 | 1 |
| 3 | 1 | 1 | 1 | 1 |
| 6 | 1 | 1 | 1 | 1 |
| 1 | 1 | 3 | 3 | 1 |
| 2 | 1 | 3 | 1 | 1 |
| 4 | 4 | 1 | 1 | 8 |
| 8 | 4 | 1 | 1 | 8 |
| 3 | 2 | 5 | 3 | 7 |
| 1 | 1 | 1 | 1 | 16 |
| 4 | 1 | 2 | 1 | 6 |
| 4 | 4 | 2 | 2 | 1 |

All tuples satisfy `k >= u >= 1`, `r >= l >= 1`, and `h >= 1`. No relaxed tuple was used.

The samples supplied **1,260 individual cycle evaluations**, plus 180 coarse and fine densities. An exact audit found 173 sample roots with at least one zero entry, 120 coarse flows with at least one zero entry, and two fine squares with an exact zero band on the centered space. The exact centered coarse band counts were: one value for 3 samples, two for 59, three for 59, and four for 59. In the entire centered fine space, the count ranged from one through nine. These counts come from rational characteristic polynomials and include a zero value whenever it occurs.

For each of `n=4` and `n=5`, start selection took four distinct eligible sample records with the weakest individual cycle score, and two records with the weakest whole-monotonicity score. Eligibility required `p < 1/4`, `max A > 4`, and at least three numerically distinct centered coarse values; the subsequent exact audit verified three values for all six `n=4` starts and four for all six `n=5` starts. The eight individual-cycle starts all selected **cycle 4, `ab-bc-cd-da`**. Thus the optimization stage concentrated on one cycle, although every sample and retained best point was evaluated for all seven cycles.

The optimization used L-BFGS-B with finite-difference gradients, `maxiter=100`, `ftol=1e-12`, `gtol=1e-8`, and `maxls=25`. Positive entries of `G` were represented by exponential coordinates in `[-10,10]`; channel coordinates used `tanh` on `[-6,6]`. The positive support of each coarse flow was fixed within that start. The explicit initial vectors, all retained best vectors, objective-call counts, best-call indices, and termination messages are in the data files.

| Completed optimization result | Count |
|---|---:|
| Individual-cycle starts | 8 |
| Whole-monotonicity starts | 4 |
| Total iterations | 1,097 |
| Total objective calls | 29,050 |
| Relative-function-reduction convergence | 4 |
| 100-iteration cap reached | 8 |

The 29,050 calls refer to the selected optimization objective. They are not a claim that all seven cycles and the full target were evaluated and retained at every intermediate point. Every selected best point was subsequently evaluated for all seven cycles and both full densities.

## Numerical results and exact scope audit

| Quantity | Samples | Retained optimization best points |
|---|---:|---:|
| Minimum individual signed/absolute ratio | 0.8270543110484553 | 0.6279118130251526 |
| Minimum total signed/absolute ratio | 0.8823450362726888 | 0.7729184087816959 |
| Minimum `Ffine` | 1.0000493522745078 | 1.6991042836928925 |
| Minimum `Ffine - Fcoarse` | 2.4475545050732576e-9 | 8.141164549051439e-7 |
| Inputs with `p < 1/4` | 177 of 180 | 12 of 12 |
| Inputs with `max A > 4` | 173 of 180 | 12 of 12 |

The weakest sampled cycle ratio occurs at sample 9, cycle 4. The weakest optimized ratio occurs at run 0, cycle 4. The smallest sample normalization is exactly `p=16/39045`, and the largest sample `max A` is exactly `294139/128`; both occur at sample 99. The optimizer points reach still smaller `p` and larger `max A`, with exact rational values recorded in the audit. Every optimizer best point has seven (`n=4`) or nine (`n=5`) distinct values on the entire centered fine space.

No candidate crossed the frozen negative normalized threshold `-1e-8`, and no stored fine density fell below `1-1e-8`. In fact all displayed cycle and monotonicity ratios are positive, well away from the threshold. No counterexample certificate file was produced, because there was no candidate sign violation to certify.

## Verification and reproducibility

The independent engine gate uses a weighted six-state actual root with zeros. It composes fine kernels using Python `Fraction` arithmetic and the original fine measure, directly sums its four-vertex density, and checks each coarse cycle sum separately. It verifies the binary-channel power decomposition, all seven cycle terms, and `Ffine = Fcoarse + sum cycles` exactly. A separate ordinary-matrix integer certificate engine independently returns the same fine density. Twelve malformed tuple or channel inputs were rejected. These checks test the computational identities and admissibility of the gate input; they are not a proof that every cycle term is nonnegative.

The rational certificate routine would produce explicit original `mu`, `W`, `p`, all cycle values, both densities, and separate cycle/monotonicity/target flags. For integer coarse flow `G` and channel denominator `d`, it sets `L=lcm(s_i)` and clears denominators in the ordinary matrices `P_S` and `P_H`. Its full common denominator is

\[
C^4 L^{2N+6}d^{2N},\qquad N=k+(r+h)+u+r+u+l.
\]

For an independent fine-host check it uses the integer symmetric flow

\[
G_{\rm fine}((i,a),(j,b))=G_{ij}(d+q^{\rm num}_{ij}ab).
\]

Its row sums are `2d s_i` and total mass is `4d C`, giving the required original fine measure `s_i/(2C)` exactly.

The detached audit replayed all 180 frozen numeric inputs and matched every stored sample value exactly in the recorded binary64 environment. It reconstructed all 12 adaptive start choices and initial vectors, reconstructed each retained best point from its stored coordinate vector, and recomputed its stored values. Exact rational arithmetic checked all original measures, root nonnegativity, `p` comparisons, `max A` comparisons, and full centered band counts. Rational band counts use the squarefree characteristic polynomial of `P_S^2` with one constant eigenvalue removed, multiplied by the characteristic polynomial of `P_H^2` for the fine centered space. No approximate cutoff determines the final band counts.

Run the following in a directory containing the allowlisted files:

```
python continuation3_engine_checks.py
python continuation3_audit.py
```

To repeat the same frozen search, without regenerating its inputs:

```
python continuation3_channel.py sample
python continuation3_channel.py optimize
```

The sample replay is deterministic in the recorded environment. Optimization trajectories can vary with numerical-library versions; the archived explicit starts, best coordinates, and termination records remain the definitive record of this completed run. `continuation3_audit.json` records the runtime versions and SHA256 input bindings. `continuation3_allowlist.json` identifies the complete compact dependency set and hashes. `continuation3_config.json` is already frozen; running the `freeze` command is unnecessary for replay.

No further samples, restarts, or continuation were launched after these fixed caps. The absence of a negative result from this batch supplies only finite numerical evidence and no missing theorem.
