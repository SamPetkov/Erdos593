# Bounded actual-host cover search — continuation, 10 October 2026

## Verdict and scope

No admissible counterexample to the original density inequality or to the stronger graph-cover comparison was found. The results below are finite numerical evidence, not a proof of either inequality. No Lean acceptance is claimed.

The continuation used an exact finite parametrization of actual reversible Markov roots, a complete registry of connected three-/four-sheet switching classes, controlled tensor contraction, capped local optimization, and an integer-arithmetic certificate procedure. Neither the target nor the cover comparison crossed the numerical candidate threshold. The sample maximum slightly above one in floating point was separately checked on the identical host with exact integer arithmetic; both inequalities hold strictly there.

The execution environment was Python 3.12.14, NumPy 2.3.5 and SciPy 1.17.0, with `OPENBLAS_NUM_THREADS=1` and `OMP_NUM_THREADS=1`.

## Actual-host parametrization and conventions

For a nonnegative symmetric matrix H with strictly positive row sums, put

    s_i = sum_j H_ij,  C = sum_i s_i,
    mu_i = s_i/C,      T_ij = C H_ij/(s_i s_j).

Then T is a nonnegative symmetric Markov kernel relative to the original mu. Setting p=1/max(T) and W=pT gives W in [0,1] with every mu-weighted row sum equal to p. Conversely, every admissible root is obtained by taking H_ij=mu_i mu_j T_ij. The parametrization itself is complete; a finite collection of sampled H is not an exhaustive host search.

Every tuple is stored as **(k,u,r,l,h)**. The A-exponents on (ab,ac,ad,bc,bd,cd) are (k,r+h,u,r,u,l), and the corresponding root powers are twice these values. The numerical spectral calculation fixes the stationary mode exactly before taking high powers.

The boundary projection used in part of the search is

    T_boundary = (T - m)/(1-m),  m=min(T)<1.

It preserves the original stationary law and gives an actual zero entry. The separately proved radial reduction for the original target justifies looking for target violations on this boundary. That reduction does not automatically apply to cover/base ratios: the cover search therefore retained interior as well as boundary hosts.

## Connected cover registry and contraction

Sheet labels are chosen so that ab, ac and ad have identity matchings. The remaining matchings on bc, bd and cd are three permutations of the sheets. Simultaneous conjugation is the remaining sheet-label gauge. The generated subgroup must act transitively for the cover to be connected.

Exhaustive enumeration of these finite permutation triples gives:

| Sheets | Connected switching classes | Largest chosen elimination width |
|---|---:|---:|
| 3 | 41 | 4 |
| 4 | 604 | 5 |

Variable elimination acts on the actual 4M lifted vertices. It retains their original mu factors and the prescribed common-power kernel on every lifted edge. The implementation chooses among deterministic minimum-fill/minimum-degree orders. This removes the large intermediate tensors encountered in the earlier unrestricted greedy contraction.

Every listed cover class was tested at each state count n=3,4,5,6, on one generated host and one prescribed tuple. A distinct boundary projection was additionally tested when appropriate. This is coverage of finite cover classes, not coverage of all hosts or all exponent tuples.

## Completed finite batch

The seed was **26101011**. There were 2,580 generated hosts and **4,268 actual-host cover evaluations**.

| Sheets | States | Cover classes | Evaluations | Maximum cover/base ratio |
|---|---:|---:|---:|---:|
| 3 | 3 | 41 | 68 | 1.0000000000000000 |
| 3 | 4 | 41 | 66 | 0.9999999999999976 |
| 3 | 5 | 41 | 68 | 0.9999999999030017 |
| 3 | 6 | 41 | 68 | 0.9999999999972407 |
| 4 | 3 | 604 | 992 | 1.0000000000000007 |
| 4 | 4 | 604 | 1001 | 1.0000000000000000 |
| 4 | 5 | 604 | 998 | 0.9999999999999999 |
| 4 | 6 | 604 | 1007 | 0.9999999999998614 |

Here the ratio is Z_cover/F^M. A numerical target candidate means F<1-10^-8; a numerical cover candidate means Z_cover/F^M>1+10^-8. Neither flag was triggered. The smallest reported base densities were within floating point resolution of one. The largest apparent cover excess, 1.0000000000000007, was resolved exactly as described below; a floating point sign alone is not a certificate.

The six generated families were positive integer H, sparse integer H with exact zeros, integer Gram H of rank at most n-1, integer roots with strong blocks, sparse star roots, and logarithmically spread positive weights. Boundary projection preserves centered spectral multiplicities while rescaling the centered eigenvalues. Generic n>=4 cases have at least three interacting centered bands; the Gram families also include additional zero eigenvalues.

The tuple list was:

```text
(1,1,1,1,1)   (2,2,1,1,1)   (2,1,2,1,1)   (3,2,3,2,1)
(1,1,3,3,1)   (4,4,1,1,8)   (8,4,1,1,8)   (2,1,3,1,2)
(3,2,5,3,7)   (1,1,1,1,16)  (4,1,2,1,6)   (2,2,3,2,2)
```

## Capped optimizations

All local optimizations used upper-triangular log coordinates for positive entries of the starting H, reflected symmetrically. Zero entries in the starting support stayed zero. Coordinate bounds were [-24,4]; the iteration cap was 100, with `ftol=1e-12`, `gtol=1e-8` and `maxls=25`.

**Cover comparison:** 32 starts, all with a reported convergence status; 687 iterations and 1,053 objective calls. Twenty-seven stopped on projected-gradient convergence and five on relative objective reduction. The largest observed ratio was

    Z_cover/F^M = 0.999999849041978.

The objective was the regularized amplification

    log(Z_cover) / [M (log(F)+10^-8)].

This avoids one flat direction near F=1, but does not prevent stationary-mass concentration. For example, the largest-ratio endpoint had F approximately 2.21e7 and a smallest stationary mass approximately 1.54e-4. This is a limitation of the search, not evidence of optimality or a positive gap.

**Original target:** 12 boundary starts, with 708 iterations and 1,184 objective calls. Nine reported convergence and three reached the 100-iteration cap. Writing F=1+S+Q, where S is the sum of the seven nonnegative cycle contributions and six nonnegative diamond contributions, the objective was -Q/(S+10^-12). The smallest observed Q/S was

    -0.0031934828768898768,

at F approximately 10.3661. This remains far from the condition Q/S<-1 required for a target violation. Negative Q by itself is a known stronger-lemma obstruction, not a failure of the target.

The exact starts are frozen in two JSON files. The optimizer initially read a sampler checkpoint containing 27 cover starts. Those starts and all 12 target starts were reconstructed from seed and cell identifiers, with zero discrepancy in the recorded starting metrics. Five remaining cover starts completed the stated cap of 32. Reproduction should use the frozen start files, rather than selecting starts from a checkpoint while it is changing.

## Exact integer certificate procedure

For nonnegative symmetric integer H with positive row sums, let C=sum(s_i), L=lcm(s_i), and

    R_ij = (L/s_i) H_ij.

Thus the ordinary transition matrix is R/L. For an A-exponent e, define the integer matrix

    N_e,ij = C (L/s_j) (R^(2e))_ij.

Then, relative to the original mu,

    K_e(i,j) = N_e,ij / L^(2e+1).

Let N be the sum of the six A-exponents and D=C^4 L^(2N+6). The base density is B/D, where B is an integer contraction with vertex weights s_i and edge matrices N_e. Every M-cover has density B_cover/D^M. Consequently:

    target violation          iff B < D;
    cover-domination violation iff B_cover > B^M.

No floating point matching is needed for either comparison. The engine uses object-integer matrix powers and elimination contractions. It returns the distinct fields `comparison_integer=B_cover-B^M`, `cover_violation`, `target_defect_integer=B-D`, and `target_violation`. The actual mu,T,W are recovered from H by the formulas above. A positive cover comparison integer alone would refute a sufficient graph-cover comparison, not the original target.

The following exact checks completed:

* For H=v v^T, v=(1,2,3), F=1 and the tested connected three-cover has density exactly one. The cleared integer difference is zero.
* For H=diag(1,2,3), mu=(1,2,3)/6. The base density is exactly 49; the connected three-cover density is exactly 6^6+3^6+2^6=47,449, below 49^3=117,649. The cleared integer difference is strictly negative.

These verify the implementation on known cases. They do not certify any universal comparison.

### Exact resolution of the sample maximum

The recorded floating point maximum came from the same actual integer host

```text
H = [[41,5,23],[5,1,3],[23,3,13]],
(k,u,r,l,h) = (4,4,1,1,8),
(sigma_bc,sigma_bd,sigma_cd)
  = ((1,2,3,0),(0,1,3,2),(3,0,1,2)).
```

The stored H entries were exactly integral binary floats, so converting them to integers did not change the host. Its original stationary law is mu=(23/39,1/13,1/3), and an admissible realization has p=9/13 and

```text
W = [[369/529, 15/23, 9/13],
     [15/23,       1, 9/13],
     [9/13,     9/13, 9/13]].
```

The raw floating point values were F=Z_cover=0.9999999999999998 and Z_cover/F^4=1.0000000000000007. The integer certificate instead gives **B-D>0** and **B_cover-B^4<0**. Decimal summaries of these exact rational comparisons are

```text
F-1             =  1.1102881340644395692441451595096...e-17,
Z_cover/F^4 - 1  = -2.2205762681178275485056876901587...e-17.
```

The full cleared integers, original measure, W, tuple, and cover permutations are stored in `numerical/continuation_roundoff_certificate.json`. The engine check script recomputes the integers and verifies the rational weighted row sums and W bounds. This certifies this finite instance only.

## Numerical checks and provenance correction

The controlled contraction agrees with an independently arranged contraction that first sums all a-copies. Cover gradients and the pullback through the selected boundary minimum were checked against finite differences on weighted three-/four-state examples. The recorded relative errors are below 7e-9. Boundary projection is piecewise smooth; no global optimization guarantee is inferred from these checks.

Both numerical host construction and the exact certificate require exactly five integer tuple entries and enforce k>=u>=1, r>=l>=1, h>=1. Floats, including integer-valued floats, are rejected rather than truncated. Every cover contraction requires three genuine permutations of the same nonempty sheet set. The exact engine also rejects noninteger, negative, asymmetric, nonsquare, or zero-row hosts. The final compact gate passed 53 rejected-input calls, accepted Python/NumPy integer inputs, reproduced both exact baseline examples, and reproduced the sample maximum certificate.

The earlier higher-cover run has a durable checkpoint containing **18,000 completed checks**: M=3 at n=3,4,5,6, then M=4 at n=3,4, with 3,000 checks per cell. The earlier report of 2,496 referred to the index of the last best-improvement log line, not the completed-work count. The six recorded cells, their maxima and the entire best record have now been reproduced exactly, excluding elapsed time. The planned 24,000-check batch was not completed.

The five other retained old batches were also replayed solely for provenance: every non-timing JSON field matches exactly, including all 144 old optimization endpoints and statuses. Those replays add no search coverage. The original raw-eigensolve scans require the explicit legacy eigensolve option. The prior completed-work inventory is:

| Prior batch | Seed | Completed work | State counts |
|---|---:|---:|---|
| Raw base-density sample | 20261010 | 134,400 tuples on 8,400 hosts | 3,4,5,6,8,10,12 |
| Raw base-density optimization | 20261010 | 144 starts, 4,702 iterations | 4,6,8 |
| Centered expansion sample | 101010 | 60,000 host/tuple pairs | 4,5,6,8,10,12 |
| Two-sheet cover sample | 610100 | 40,000 host/tuple pairs, 280,000 nontrivial covers | 3,4,5,6 |
| Integer/disconnected/bipartite sample | 12361010 | 32,000 host/tuple pairs, 224,000 nontrivial covers | 3,4,5,6 |
| Higher-cover stopped checkpoint | 26101010 | 18,000 covers in six completed cells | M=3: 3,4,5,6; M=4: 3,4 |

The first, second, third, fourth, and sixth batches cycled through six families: dense positive, logarithmically spread, sparse, near identity, near bipartite, and rank deficient. The fifth used four integer families: exact zeros, Gram, disconnected, and bipartite. The old optimizer used 48 starts per state count, bounds [-30,10], `maxiter=180`, `ftol=1e-14`, `gtol=1e-11`, and `maxls=30`; 141 reported convergence and three exited abnormally. Its largest iteration count was 91. These statuses are preserved, not relabeled as successful proof checks.

The raw sample minimum was 0.9999999999998076 at n=10, tuple (15,1,14,7,12). A separate 80-digit ordinary-Markov-power calculation of that stored decimal-rational host gave F-1 approximately +2.2140640775482291e-19. The old optimizer minimum was 0.9999999999999846 at n=4, tuple (4,4,2,2,1); its analogous 80-digit result was approximately +5.9816591274548343e-33. These two older calculations are high-precision point evaluations, not interval bounds or exact certificates. The old maximum cover ratios were 1.0000000000000007 for the two-sheet sample, 1.0000000000000009 for the integer sample, and 1.0000000000000107 for the higher-cover checkpoint; none is asserted to be an exact violation.

The prior twelve fixed raw-sample tuples were

```text
(1,1,1,1,1) (2,1,1,1,1) (1,1,2,1,1) (2,2,1,1,1)
(2,1,2,2,1) (4,4,1,1,8) (8,4,1,1,8) (2,1,3,1,2)
(3,2,5,3,7) (1,1,1,1,16) (1,1,8,8,1) (8,8,1,1,1).
```

Each raw-sample host additionally received four tuples with u,l drawn from 1,...,8, k from u,...,16, r from l,...,16, and h from 1,...,16 using the recorded seed. The old optimization and expansion used

```text
(1,1,1,1,1) (2,2,1,1,1) (4,4,1,1,8) (8,4,1,1,8)
(3,1,2,1,3) (3,2,5,3,7) (1,1,1,1,16) (4,4,2,2,1).
```

The old two-sheet, integer, and higher-cover batches used those eight plus (1,1,2,2,1), (2,1,3,1,1), (4,1,2,1,6), and (2,2,3,2,2). Source filenames and SHA256 identities, canonical non-timing result hashes, and the replay equality results are recorded in the concise provenance JSON. The duplicated old result payloads are deliberately excluded from this package; the new experiment is self-contained.

## Minimal reproduction

Copy the `numerical/` directory to a fresh working directory before reproducing, because the scripts write result JSON to the current directory. The core experiment requires the four Python sources and supporting data listed in `numerical/continuation_allowlist.json`, NumPy and SciPy. Run from that copied directory:

```sh
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 python continuation_engine_checks.py
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 python continuation_search_covers.py sample --seed 26101011
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 python continuation_search_covers.py optimize --maxiter 100 --starts continuation_cover_optimizer_fixed_starts.json
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 python continuation_search_covers.py target_optimize --maxiter 100 --starts continuation_target_optimizer_fixed_starts.json
```

No further searches were started after completion of the stated caps. The mathematical status remains unchanged by this numerical appendix: the unrestricted common-power inequality and the unequal-kernel graph-cover comparison are not proved here.
