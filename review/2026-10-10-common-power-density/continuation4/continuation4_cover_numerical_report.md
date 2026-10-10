# Bounded canonical-channel diagnostics

## Result and what was searched

No negative canonical individual-cycle coefficient was found. No convergence claim, universal positivity claim, target proof, or complete-cover counterexample follows from this run.

The exact actual flow parameterization is `pi_i=s_i/Z`, `T_ij=Z G_ij/(s_i s_j)` for a symmetric nonnegative flow `G`, row sums `s_i>0`, and total `Z=sum_i s_i`. The source then forms the canonical unordered-pair permanent and determinant channels from the actual common powers `T^(2n_e)`. It evaluates one signed K4 cycle coefficient and its absolute summand sum. The optimized scalar is their ratio, so it is not dominated by a large common normalization factor.

There are 252 integer-flow seeds, 84 each in original dimensions 3,4,5. Every seed receives one of the six fixed target-compatible tuples and one of the seven cycles according to its source index. There is no Cartesian sweep of every tuple/cycle. The four lowest stored scores in each dimension select 12 starts. The optimizer uses symmetric positive flow entries `exp(x)` with `-9<=x<=9`, at most 60 iterations, and finite-difference derivatives.

The `starting_ratio` field in the optimization output denotes the score of the selected **integer seed**. The source replaces zero seed entries by `1e-4` before taking logarithms, and the optimizer enforces its coordinate bounds; that field is therefore not a claim that the first actual bounded iterate has exactly that score.

## Actual termination and coverage

| Item | Recorded result |
|---|---:|
| Integer seeds | 252 |
| Optimizer starts | 12 |
| Total optimizer iterations | 644 |
| Objective calls, including finite differences and line searches | 15,046 |
| Starts reaching the iteration cap | 9 |
| Starts with an abnormal line-search status | 3 |
| Starts reporting successful convergence | 0 |
| Minimum sampled signed/absolute ratio | approximately 0.743836 |
| Minimum retained optimized ratio | approximately 0.532248 |
| Negative sampled or retained optimized coefficients | 0 |
| Seeds with exact `p<1/4` | 95 |
| Seeds with exact `p<1/4` and `max A>4` | 72 |
| Seeds containing actual root zeros | 146 |
| Retained optimized points with exact `p<1/4` | 1 |

The optimizer mainly moved into `p>=1/4`, a previously density-covered region. This search concerns the stronger canonical cycle sign diagnostic, so it should not be reported as new numerical exploration of the unrestricted density deficit at all of those points. Dimension 4 or 5 by itself is not a certificate of a particular number of distinct spectral bands.

## Reproducibility and proof boundary

`continuation4_cover_search.py` contains the complete deterministic seed-generation and optimization schedule. `continuation4_cover_samples.json` and `continuation4_cover_optimizations.json` retain every seed and every final retained flow. `continuation4_cover_audit.py` verifies symmetry and nonnegativity and reconstructs the **exact rational** original measure, Markov root, `p`, and square-entry test for every stored flow. For the optimizer's finite floating-point flow entries, the exact dyadic numbers represented by those entries define admissible finite hosts. This establishes admissibility, not the sign of a density or a cycle coefficient.

The audit separately recomputes the floating scores and records the source/dependency hashes. That numerical matching checks reproduction; it is not a proof. The unchanged common-power/cover dependency is `continuation_cover_engine.py`, SHA-256 `1187d00bdafdec7f1ffd3b7ad7ee1b2f2eb8d27f2593fd6ee12808628a14495a`.

A separate exact checker, `continuation4_cover_verify.py`, reconstructs eight rational test hosts and proves its recorded identities without floating-point arithmetic. Seven hosts undergo all seven nontrivial two-cover comparisons, using an independent integer contraction engine for the cover value. These 49 finite comparisons validate the canonical cycle formula against actual cover integrals. The remaining five-state test has three distinct positive centered square eigenvalues and an additional zero eigenvalue; it checks transport, trace, rank, and commutator identities only. The general source-structure theorems are proved in `continuation4_cover_structure.md`; none of the numerical search statistics is used in those proofs.
