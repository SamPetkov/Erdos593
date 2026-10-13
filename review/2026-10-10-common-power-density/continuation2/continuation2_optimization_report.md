# Structured actual-root two-cover search — bounded continuation 2

## Verdict and exact scope

**No counterexample to the original target or to the stronger two-cover comparison was found. Neither statement is proved by this search.** The entire authorized fixed sample and all twelve capped optimizations completed. No relaxed tuple was tested and no further search followed the caps.

**Target-scope correction:** every sampled exact root already satisfies the prior density compensation criterion: the largest recorded root entry is exactly 241/102, so the smallest recorded p is 102/241>1/4. The exact boundary roots reconstructed from all twelve stored optimizer directions also have p>1/4. Since the prior compensation threshold Gamma_(r-l,h) is at most 1/4 for the requested tuples, these target evaluations are calibration on an already proved class. The genuinely stronger unresolved diagnostic in this batch is the complete two-cover comparison.

This pass used actual six-sign hosts with asymmetric cubic moments, five to seven distinct bands on the entire centered space, substantial zero eigenspaces, and exact zero-entry root boundaries. It did not repeat the preceding generic weighted three- to six-state batches. The original target remains separate from the stronger comparison: a negative value of F²−Z for a two-cover would refute that comparison only, while F<1 is the original target violation.

## Actual finite hosts and original measure

Index the six signs by the edges ab, ac, ad, bc, bd, cd of a host K4. For r in {-1,+1}^6, let S_v(r) be the product of the three incident signs. Choose four rational coefficients t_v and put

    mu(r) = [1 + sum_v t_v S_v(r)]/64.

The state set consists precisely of the positive-mass sign vectors. The engine checks all 64 numerator values exactly and discards only zero-mass states. The total mass is one. Fourier orthogonality on the full cube gives

    E_mu r_i = 0,    E_mu r_i r_j = delta_ij.

For six rational root coefficients lambda_i, set

    T(r,r') = 1 + sum_i lambda_i r_i r'_i.

The engine checks entrywise nonnegativity on the actual positive-mass support. This T is symmetric and has every original-mu row sum equal to one. Thus p=1/max(T) and W=pT give an admissible host in the user's sense. The six signs are eigenfunctions with eigenvalues lambda_i; every other centered eigenvalue is zero. Consequently A=T² has active eigenvalues lambda_i², and the prescribed kernels are exactly

    K_e(r,r') = 1 + sum_i lambda_i^(2e) r_i r'_i.

Negative root eigenvalues are allowed in some patterns; A remains the actual nonnegative Markov square T². No arbitrary PSD kernel or independently chosen family of edge kernels is substituted.

Both an interior root and its exact boundary projection were tested. With q=min_{r,r'} sum_i lambda_i r_i r'_i<0, the boundary coefficients are lambda_i/(-q). This is exactly (T-min(T))/(1-min(T)); it preserves the original measure and has a zero entry. The minimum is computed over actual pairs of positive-mass states using rational arithmetic.

Sample admissibility refers to the stored rational numerators and denominator. Numerical polynomial evaluation uses their floating point approximations. For optimized points, admissibility refers to the exact boundary projection of the stored floating point direction interpreted as six exact dyadic rationals. Literal rounded `boundary_lambda_endpoint` values are approximations: their smallest entrywise root values can be slightly negative, with a minimum of approximately -9.93e-17 in this audit. They are not independently asserted to be exact admissible hosts. The exact projected directions all have root minimum zero; the largest coefficient discrepancy from the stored rounded vector was below 3.78e-17.

The seven laws were:

| Law | (t_a,t_b,t_c,t_d) | Positive-mass states |
|---|---|---:|
| Supplied half-star law | (1/2,1/2,1/2,-1/2) | 32 |
| One-star face | (3/4,1/4,1/4,-1/4) | 40 |
| Two-star face | (1/2,1/2,1/4,-1/4) | 48 |
| Opposite-star face | (1/2,1/4,1/4,-1/2) | 48 |
| Asymmetric interior | (9/20,2/5,7/20,-3/10) | 64 |
| Attenuated half-star law | (17/40,17/40,17/40,-17/40) | 64 |
| Skew-star face | (4/5,1/5,1/10,-1/10) | 48 |

The sixteen root patterns include the user's supplied spectrum, unequal near-equal weights, geometric and steep weights, a permutation of the steep weights, signed versions, mild separation, and eight seeded integer directions. Four of the seeded patterns have additional exactly zero active coefficients. The seed was **20261012**. Every coefficient is frozen as an exact rational string in `continuation2_config.json`; the seed is not needed to recover an input from that file.

Across the sixteen patterns, the number of distinct eigenvalues on the whole centered space, counting zero, was five for two patterns, six for six patterns, and seven for eight patterns. Boundary dilation preserves these counts.

These large band counts do not place the family beyond the prior density criterion. In fact, all seven supports contain the supplied 32-state support. Its possible pair-product sign vectors are all 64 cube vectors except the eight for which all four star products equal -1. For any nonzero direction lambda, write B=sum_i |lambda_i|. If the sign vector that minimizes the unconstrained dot product is excluded, changing the sign at a coordinate of smallest absolute weight makes it allowed. Thus the actual minimum dot product is at most -B+2 min_i|lambda_i|, which is at most -2B/3. The maximum dot product is at most B. Every boundary ray in these seven support families therefore has max(T)<=5/2 and p>=2/5. The sampled interior roots satisfy the same lower bound. This also explains why the optimization never leaves the already covered density regime, regardless of its endpoint.

## Sparse cubic-tensor reduction

Write phi_0=1 and phi_i=r_i for i=1,...,6. The actual cubic multiplication tensor has only 43 potentially nonzero entries:

    C_000 = 1;
    C_0ii = C_i0i = C_ii0 = 1;
    C_ijk = t_v when {i,j,k} is the incident-edge triple at v;
    every other entry is zero.

For each ordered pair (i,j), at most one k has C_ijk nonzero. This gives a deterministic finite contraction algorithm. Choose a spanning tree of the lifted graph, assign colors in {0,...,6} to its non-tree edges, and process tree leaves inward. The two known incident colors at a processed vertex determine the remaining edge color, or invalidate the assignment. The last vertex supplies the final compatibility check.

A base K4 has three non-tree edges, so the base enumeration has 7³=343 assignments, of which 235 survive. Every nontrivial two-cover is connected and has five non-tree edges, so its enumeration has 7⁵=16,807 assignments. There are 7,993 surviving colorings for each of switching patterns 1 through 6 and 7,093 for pattern 7. Bits refer, in order, to crossings on bc, bd and cd after ab, ac and ad have been gauged to parallel matchings.

Each surviving coloring is an exact monomial in the four t_v and the six lambda_i. The engine coalesces these monomials and forms the polynomial **F²−Z directly**, canceling the stationary constant symbolically. It also forms F−1 directly. Thus a tiny computed defect is not obtained by subtracting two separately rounded values near one.

For a defect polynomial D=sum_j a_j, the sampling and optimization score is

    D / sum_j |a_j|.

The terms are evaluated with a common logarithmic scaling. This normalization measures cancellation within this specific polynomial representation; it is not a uniform lower bound, probability, or scale-independent gap theorem. A negative normalized value would have the same sign as the cover defect. The numerical candidate threshold was -10^-10 for this normalized quantity, with a separate target flag based on the centered target polynomial.

## Completed fixed sample

There were **224 actual root instances**, including 112 exact boundary roots. Each received twelve ordered target tuples, for **2,688 host/tuple evaluations and 18,816 nontrivial two-cover comparisons**. Every generated input and all seven cover values are retained in the compressed full result file.

The tuple convention is (k,u,r,l,h); the six A-exponents are (k,r+h,u,r,u,l). The tuple list was:

```text
(1,1,1,1,1)   (2,1,2,1,1)   (2,2,1,1,1)   (3,2,3,2,1)
(1,1,3,3,1)   (4,4,1,1,8)   (8,4,1,1,8)   (16,4,1,1,8)
(3,1,2,1,3)   (3,2,5,3,7)   (1,1,1,1,16)  (4,4,2,2,1)
```

All 18,816 computed cover defects were strictly positive in the direct polynomial evaluation. The smallest normalized defect in the fixed sample was approximately **0.999986029267169**, on the supplied half-star law with the near-equal boundary spectrum, tuple (1,1,1,1,1), and crossing bits 5. Its ordinary cover/base ratio was approximately 0.9996364976458315.

The smallest reported F was 1.0000000000002163. Ordinary cover/base ratios ranged from approximately 0.5002514871354128 to the floating point value 1.0. The latter occurs when a positive direct polynomial gap is too small to affect the rounded ratio; no ratio above one was reported. Neither numerical candidate flag was triggered.

## Twelve capped optimizations

One boundary start per law was selected first, followed by five remaining starts with the smallest normalized cover defects. All twelve starts were frozen before optimization in `continuation2_optimizer_starts.json`. Each optimization kept the original law, tuple, switching pattern, signs, and zero spectral support fixed, varying the nonzero root amplitudes in logarithmic coordinates and projecting to the actual root boundary at every objective evaluation.

The declared limits were log-coordinate bounds [-50,2], at most 80 iterations per start, `ftol=1e-13`, `gtol=1e-10`, and `maxls=30`, using L-BFGS-B. All twelve runs completed with reported convergence: seven on projected-gradient convergence and five on relative reduction. There were **233 iterations and 656 objective calls**, with a largest iteration count of 27.

The smallest normalized cover defect after optimization was approximately **0.999943111823316**, still positive. It occurred for the supplied half-star law, tuple (1,1,1,1,1), bits 5, at a nearly equal boundary spectrum:

```text
lambda ≈ (0.2499260124, 0.2499218223, 0.2501532777,
          0.2499328375, 0.2499878725, 0.2499218223).
```

At that endpoint, F≈1.003221224912957 and Z/F²≈0.9996089613019284. Complete floating point directions and endpoint values are retained. Local convergence does not establish global optimization, and the score does not identify the host with the largest ordinary ratio.

An exact audit of all twelve dyadic directions followed by rational boundary projection found minimum p equal to 27914925100926095/69782948102995432, approximately 0.400025018428934. Every endpoint is therefore within the prior target density criterion. Full endpoint p values and rounding diagnostics are retained in `continuation2_optimize_provenance_audit.json`.

The complete cover sums showed little cancellation in this family, despite the known failures of individual modewise expressions. This is an observed limitation of the tested family and objectives, not an affirmative argument for all actual hosts.

## Exact arithmetic and verification

The engine contains a rational certificate routine for any candidate in this host family. If t_v have common denominator d, the root coefficients have common denominator L, and N is the sum of the six A-exponents, a base monomial contraction has denominator dividing

    D = d^4 L^(2N).

A two-cover has the common denominator D². The routine evaluates the sparse polynomials using Python integers and returns B-D for the target and B²-B_cover for the cover comparison, with separate exact violation flags. The certificate also lists all positive-mass states and their original rational masses, the rational root coefficients, the exact root minimum, p, and the formula defining W. No candidate appeared in this batch, so no violation certificate was generated.

The fixed verification gate passed 18 checks. It checked the original-measure orthonormality and all cubic tensor entries exactly on the supplied 32-state host. It compared all seven two-cover values against an independently arranged ordinary-state contraction on a weighted eight-state host retaining a nonzero cubic star. Grouping those verification states summed their original masses and only identified states on which every tested kernel was identical. One base density and one nontrivial cover were also matched exactly against the earlier independent ordinary-Markov-power integer certificate engine. The analytic boundary derivative agreed with finite differences with relative error approximately 3.49e-11.

These are implementation checks and finite computations. They do not turn the numerical sample into a universal proof.

## Frozen provenance and reproduction

Before sampling, the configuration fixed the complete rational inputs, tuple order, candidate definitions, limits, seed, and SHA256 identities of the three new source files. The configuration SHA256 is

    1a0351d89cf03e50e1d4cb29c69ba3c251973462d8de7df94adff562d1b8f1a7.

The engine SHA256 is

    07e655e6a2fd1eae054f879f2b12f116e96d38acb5f94829445939d011938d15.

The complete sample output is stored as `continuation2_samples.json.gz`; its uncompressed identity is in `continuation2_summary.json`. No cell maxima or optimizer starts were reconstructed from a changing checkpoint. The full result contains every sampled host/tuple record and all seven cover comparisons, rather than only improvement events.

Use a fresh working directory with the allowlisted files. The recorded runtime was Python 3.12.14, NumPy 2.3.5, and SciPy 1.17.0. The independent check script additionally uses the included earlier `continuation_cover_engine.py`. Set `OPENBLAS_NUM_THREADS=1` and `OMP_NUM_THREADS=1`. The configuration is already frozen, so the reproduction commands are:

```sh
python continuation2_engine_checks.py
python continuation2_search.py sample
python continuation2_search.py optimize
```

These commands write output files to the working directory. The exact completed counts above refer to the bounded run reported here, not to additional coverage from any future replay. No GitHub writes were performed by this numerical agent.
