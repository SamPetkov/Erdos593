# Fourth continuation: complete two-covers on three interacting character channels

## Verdict and scope

This bounded experiment found no admissible counterexample to the requested density inequality and no counterexample to the stronger complete-cover comparison. Neither universal statement is proved here. The actual-input family has three interacting signed character channels, and the test evaluates every nontrivial two-sheet cover. This differs from the preceding binary-channel experiment, which evaluated seven channel-cycle terms and coarse domination instead of complete covers.

The completed sample consists of **144 exact rational host–tuple pairs** on **12, 16, or 20 fine states**, hence **1,008 complete two-cover evaluations**. All 144 hosts have at least four distinct values on their entire centered square spectrum; 32 include a zero band. All have noncommuting character channels, and 142 have an entrywise negative entry in at least one channel square. A further **21 capped optimization starts** used 788 iterations and 879 selected-objective evaluations. No additional samples or restarts were run after these caps.

Three sampled binary64 ratios exceeded one by at most `4.440892098500626e-16`. Exact integer arithmetic resolves all three strictly below the corresponding `F^2`. Seven selected cover comparisons at the exact uniform-measure optimizer endpoints are also certified strictly below `F^2`, with `F>1`. These are finite certificates, not evidence of a universal positive gap.

## 1. Actual hosts and their original measure

Let the fine state space be

\[
X=\{1,\ldots,m\}\times (\mathbb Z/2\mathbb Z)^2.
\]

Identify the four group elements with integers `0,1,2,3`, with addition given by bitwise xor. Choose four nonnegative coarse-pair flows

\[
L_{ij}(g)=L_{ji}(g)\ge0,
\qquad s_i=\sum_{j,g}L_{ij}(g)>0,
\qquad C=\sum_i s_i.
\]

The **original** probabilities and relative-measure root are

\[
\mu(i,a)=\frac{s_i}{4C},\qquad
T((i,a),(j,b))=\frac{4C L_{ij}(a\mathbin\oplus b)}{s_i s_j}.
\]

Symmetry and entrywise nonnegativity are immediate. For each fixed `(i,a)`,

\[
\sum_{j,b}\mu(j,b)T((i,a),(j,b))
=\frac1{s_i}\sum_{j,b}L_{ij}(a\mathbin\oplus b)=1.
\]

Thus `T` is an actual nonnegative self-adjoint Markov root. Setting `p=1/max T` and `W=pT` gives `0<=W<=1` and every original-`mu` weighted row sum equal to `p`. All powers in the experiment are even powers of this same actual root.

Equivalently, define the symmetric fine flow

\[
G_{(i,a),(j,b)}=L_{ij}(a\mathbin\oplus b).
\]

Its row sum is `s_i`, and its total sum is `4C`. Applying the ordinary symmetric-flow parametrization directly to `G` therefore produces exactly the displayed original `mu,T`. The numerical code does not insert a new measure during powers or contractions.

### The three interacting character channels

Write `pi_i=s_i/C` and let `chi_alpha`, for `alpha=0,1,2,3`, be the four real group characters, with `chi_0=1`. Define

\[
\widehat L_\alpha(i,j)=\sum_g\chi_\alpha(g)L_{ij}(g),\qquad
B_\alpha(i,j)=\frac{C\widehat L_\alpha(i,j)}{s_i s_j}.
\]

Fourier inversion gives

\[
T((i,a),(j,b))=\sum_{\alpha=0}^3
B_\alpha(i,j)\chi_\alpha(a)\chi_\alpha(b).
\]

The characters are orthonormal for the original uniform fiber law, so every composition obeys

\[
T^q((i,a),(j,b))=\sum_{\alpha=0}^3
B_\alpha^q(i,j)\chi_\alpha(a)\chi_\alpha(b),
\]

where every coarse composition uses the same original `pi`. The ordinary matrix for `B_alpha` is `P_alpha(i,j)=widehat L_alpha(i,j)/s_i`.

The actual cubic moments satisfy

\[
\frac14\sum_a\chi_\alpha(a)\chi_\beta(a)\chi_\gamma(a)
=\mathbf 1_{\alpha\oplus\beta\oplus\gamma=0}.
\]

In particular the three nonconstant channels have a genuine nonzero mixed cubic moment. Their coefficient matrices need not commute, and their squares need not be entrywise nonnegative. The 142 cases with a negative channel square are outside that specific sufficient hypothesis in the earlier nonnegative-cubic channel theorem. No claim is made that every earlier restricted theorem fails on every sample.

## 2. Frozen finite design

The seed is **20261014**. All integer flows, assigned tuples, and generator coefficients are recorded in `continuation4_search_config.json` before sampling. The configuration binds the exact search source and unchanged general cover engine by SHA256.

For each coarse size `m=3,4,5`, the sample contains eight hosts from each of six families:

| Family | Concrete construction |
|---|---|
| Shift dominated | Individual coarse pairs concentrate on selected group shifts, with variable holding weights. |
| Positive tetrahedral | All four group-shift flows are positive, with one dominant shift per pair. |
| Bipartite transport | Coarse cross-part flows dominate; half the cases have exact bipartite support. |
| Zero character | `L_0+L_3=L_1+L_2`, so one whole character block is exactly zero. |
| Interacting blocks | Strong coarse blocks joined by a sparse group-shift bridge. |
| Uniform matchings | Positive integer sums of twelve involutive permutation generators. |

These are 144 host–tuple pairs, not a Cartesian product of 144 hosts with all tuples. The twelve tuples below each occur on twelve hosts. Tuple order is always `(k,u,r,l,h)`:

```text
(1,1,1,1,1)   (2,2,1,1,1)   (6,1,1,1,1)   (8,2,3,1,1)
(3,1,2,1,3)   (1,1,3,3,1)   (4,4,1,1,8)   (8,4,1,1,8)
(3,2,5,3,7)   (1,1,1,1,16)  (4,1,2,1,6)   (4,4,2,2,1)
```

The edge powers on `(ab,ac,ad,bc,bd,cd)` are `(k,r+h,u,r,u,l)`. All tuples satisfy the exact inequalities, including cases with `k=u`, `r=l`, and `h=1`.

After the tree matchings `ab,ac,ad` are made identity by sheet relabelling, each of `bc,bd,cd` has one switching bit. All seven nonzero bit vectors are tested on every sample. The six cases other than `111` are gauge-equivalent to switching one base edge; `111` is the bipartite double cover. Every lifted vertex retains its original `mu` factor. All seven chosen elimination orders have width three.

## 3. Exact scope audit

The audit uses rational arithmetic for probabilities, root nonnegativity, normalization, channel-square signs, commutators, and full centered band counts. For the latter it computes the characteristic polynomial of each ordinary `P_alpha^2`, removes exactly one stationary factor from `alpha=0`, and counts the union of the four squarefree root sets. Zero is counted whenever present. The calculation uses rational characteristic polynomials and polynomial gcds, with exact degree-preserving reductions modulo verified primes only as coprimality certificates.

| Exact audited property | Sample count |
|---|---:|
| Fine states 12 / 16 / 20 | 48 / 48 / 48 |
| Nonuniform original measure | 120 |
| Maximal normalization `p<1/4` | 108 |
| Both `p<1/4` and `max A>4` | 86 |
| Some entrywise negative channel square | 142 |
| Some noncommuting pair of character channels | 144 |
| At least four values on the entire centered square spectrum | 144 |
| A centered zero band | 32 |
| A root zero entry | 96 |
| Connected root with disconnected square | 12 |

All sampled roots are connected. Genuinely disconnected roots are tested separately as exact implementation controls below. The complete centered band-count distribution is: 4 values in one sample, 5 in three, 8 in four, 9 in twelve, 11 in thirty-six, 12 in eight, 14 in one, 15 in forty-three, and 19 in thirty-six.

These scope statistics show what the finite search tested. They impose no new hypothesis on the unrestricted mathematical target.

## 4. Capped optimization and its limitations

For each size and each of the seven covers, the frozen start selection chooses the largest regularized log amplification among eligible samples. Eligibility requires `F>1+1e-5`, `p<1/4`, `max A>4`, at least three numerically distinct centered values, and a channel-square entry below `-1e-12`. The subsequent rational audit confirms the relevant exact scope conditions.

The fourteen starts on 12 and 16 fine states optimize the positive entries of `L` on fixed support, using log coordinates in `[-16,4]`. The seven starts on 20 states optimize the positive weights of the fixed twelve-generator uniform family, using log coordinates in `[-12,4]`. The generator matrices are symmetric permutations, so their exact positive mixture preserves the uniform measure.

For selected cover density `Z`, the minimized objective is

\[
-\frac{\log Z}{2(\log F+10^{-8})}.
\]

It is a numerical search objective, not an inequality. L-BFGS-B uses analytic pullbacks through the actual flow, with `maxiter=80`, `ftol=1e-12`, `gtol=1e-8`, and `maxls=25`.

| Completed work | Count |
|---|---:|
| Starts | 21 |
| Iterations | 788 |
| Selected-objective calls | 879 |
| Projected-gradient termination | 17 |
| Relative-function-reduction termination | 2 |
| 80-iteration cap | 2 |
| Retained-point complete two-cover evaluations | 147 |

Each objective call evaluates the full base density and its selected cover. All seven covers are evaluated at every retained best point. Complete objective-value traces and best-call indices are archived. They are not represented as 879 evaluations of all seven covers.

There are **five distinct starting hosts**, with IDs `39,82,93,140,142`; the 21 starts differ by cover and size as specified. Most free-measure optimizations concentrate stationary mass and produce very large base densities, reaching about `2.33e7`. This is a limitation of this objective and these free-flow starts. The fixed-generator uniform runs address that particular direction, but explore only their fixed finite generator spans.

The smallest retained numerical base density is approximately `1.0002954045524417`; the largest retained ratio over all seven covers is `0.9999999995752197`. All 879 recorded objective-call ratios are below one numerically, and their smallest base density is approximately `1.0002465913395884`. No local termination is an optimality certificate.

### Exact uniform hosts versus rounded summed matrices

The seven uniform runs store positive binary64 generator weights. Interpreting these weights as exact dyadic rationals and summing the integer generator matrices exactly gives an actual host with **original measure exactly `1/20`**.

The separately archived binary64 summed `L` matrices have row-total differences of order `1e-14` because sums are rounded. Interpreting those matrices literally as dyadic flows gives admissible, slightly nonuniform hosts. The audit records both descriptions and their exact entry discrepancy; it does not label the rounded matrices exactly uniform.

For each authoritative uniform host, `continuation4_search_uniform_certificates.json` stores the positive dyadic weights, all generator matrices, an integer-scaled exact flow, the tuple, original measure, normalization, and a cleared-integer certificate. Every one has nineteen distinct centered square values, three entrywise-negative character squares, and three noncommuting character pairs. All seven selected comparisons satisfy **`F>1` and `Z<F^2` exactly**. Four uniform endpoints have `max A<=4`; no claim is made that they all stay outside that older sufficient test.

The following decimal values only indicate scale; the archived integers determine each sign:

| Run | Cover bits as integer | `F-1` | `1-Z/F^2` |
|---:|---:|---:|---:|
| 14 | 1 | `2.95424e-4` | `7.86224e-6` |
| 15 | 2 | `25.65576` | `0.1169357` |
| 16 | 3 | `0.01001962` | `7.70556e-4` |
| 17 | 4 | `2.95405e-4` | `7.86212e-6` |
| 18 | 5 | `0.00141695` | `1.53552e-8` |
| 19 | 6 | `0.00976921` | `7.52907e-4` |
| 20 | 7 | `25.65576` | `0.1169364` |

## 5. Exact resolution of all sampled roundoff excesses

The maximum sampled binary64 ratio is `1.0000000000000004`, occurring at host 79. The same host has three ratios slightly above one, for bits 3, 5, and 6. It has 16 fine states, belongs to the zero-character family, and uses tuple

\[
(k,u,r,l,h)=(8,4,1,1,8).
\]

Its original probability is constant within each four-state fiber, with the four per-state values

\[
\frac{59}{934},\quad\frac{23}{467},\quad\frac{30}{467},\quad\frac{137}{1868},
\]

each repeated four times. Its maximal normalization is `p=230/467`. The exact flow, full `W`, and original probabilities are in `continuation4_search_roundoff.json`.

All three exact certificates give `F>1`, with

\[
F-1\approx6.0374908328707419\times10^{-8}.
\]

Their exact signs, with decimal scale shown for readability, are

| Bits | Exact sign | Decimal scale of `Z/F^2-1` |
|---:|---|---:|
| 3 | Strictly negative | `-9.5837868017324103e-18` |
| 5 | Strictly negative | `-9.5538539925198273e-18` |
| 6 | Strictly negative | `-1.9137450212029526e-17` |

No inference is made from matching floating-point values. These are integer-arithmetic comparisons on the identical frozen integer host.

## 6. Independent computational checks

The main gate constructs a weighted eight-state host from a separate two-coarse-state integer flow. Python `Fraction` arithmetic verifies its original probabilities, `W` bounds, weighted row sums, and the character decomposition of the actual second, fourth, and sixth root powers.

For each omitted base edge `e=(v,w)`, let `H_e(x,y)` be the actual product of the remaining five kernels, integrated over the other two original vertices. The gate directly evaluates `H_e` and independently checks

\[
F=\operatorname{tr}(K_eH_e^*),\qquad
Z_{\mathrm{switch}(e)}=\operatorname{tr}((K_eH_e^*)^2).
\]

These are identities on the original weighted space. The gate does not assert positivity of a product of several PSD matrices. The bipartite double cover is checked by independently integrating all four vertices of one bipartition first, then directly summing the four remaining original variables. These seven exact values agree with both generic variable elimination and the independent integer denominator-clearing engine.

Three additional controls use tuple `(2,2,3,3,1)`, simultaneously testing `k=u`, `r=l`, and `h=1`. Each checks all seven connected two-covers exactly:

| Control | Original-measure density `F` | Every connected two-cover density |
|---|---:|---:|
| Constant root with weighted original law | `1` | `1` |
| Two disconnected rank-one components, masses `1/3,2/3` | `45/4` | `1377/16` |
| Connected bipartite root with two square components | `8` | `32` |

They confirm the expected original-measure powers of component masses. They are implementation controls and are not counted as new search samples or newly proved density classes.

For completeness, the component factors follow directly from the original measure. Suppose a positive-power kernel is the conditional rank-one projection on each component `C_j` of original mass `m_j`. Its relative-measure value is `1/m_j` within `C_j` and zero between components. On a connected graph with `v` vertices and `e` edges, a nonzero assignment places every vertex in one component. Its original probability contributes `m_j^v`, and its edge kernels contribute `m_j^(-e)`. Summing the original integral therefore gives `sum_j m_j^(v-e)`. For `K4`, this is `sum_j m_j^(-2)`; for a connected two-cover, it is `sum_j m_j^(-4)`, since the cover has eight vertices and twelve edges. With masses `1/3,2/3` these are `45/4` and `1377/16`; with square-component masses `1/2,1/2` they are `8` and `32`. The connected bipartite control uses its two components of `A=T^2` in this calculation; it does not condition the original root or change `mu`.

Six directional finite-difference checks test the analytic gradient, covering both coordinate systems and six selected cover cases. The largest scaled error is below `5.5e-10`. Seven malformed flow inputs are rejected. The detached audit replays every sample and every retained endpoint identically in the recorded binary64 environment, reconstructs all selected starts and initial vectors, verifies every objective-call count and best-call index, and performs the rational scope checks.

The exact integer engine uses, for fine integer flow `G`, row sums `s_i`, total `C`, and `ell=lcm(s_i)`, the integer ordinary-transition numerator

\[
R_{ij}=\frac{\ell}{s_i}G_{ij},\qquad
N_{e,ij}=C\frac{\ell}{s_j}(R^{2e})_{ij}.
\]

Then `K_e=N_e/ell^(2e+1)`. If `N` is the sum of the six exponents, the base denominator is `D=C^4 ell^(2N+6)`, and a two-cover denominator is `D^2`. The inequalities reduce to exact integer signs `B-D` and `B_cover-B^2`. The two sign questions remain distinct.

## 7. Reproduction and mathematical status

Use the files in `continuation4_search_allowlist.json`. The runtime was Python 3.12.14, NumPy 2.3.5, and SciPy 1.17.0, with `OPENBLAS_NUM_THREADS=1` and `OMP_NUM_THREADS=1`. SymPy is not required.

For exact checks and deterministic audit, run:

```sh
python continuation4_search_checks.py
python continuation4_search_roundoff.py
python continuation4_search_uniform_certify.py
python continuation4_search_audit.py
```

To reproduce the same bounded numerical experiment from frozen inputs, use:

```sh
python continuation4_search_engine.py sample
python continuation4_search_engine.py optimize
```

Run in a copied directory because these scripts write result files. The existing configuration and explicit optimizer starts are authoritative; running `freeze` or `freeze_starts` is unnecessary for replay. Numerical optimizer trajectories can depend on the library environment. The archived inputs, best vectors, termination records, and exact certificates define this completed experiment.

This appendix supplies new finite search coverage, independently checked actual-host transport, and exact nonviolation certificates. It supplies no proof of complete-cover domination, no counterexample to that comparison, and no resolution of the unrestricted common-power density inequality. The separate exact failure of coarse domination in the preceding work remains a constraint on proposed sufficient arguments.
