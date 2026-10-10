# Common-power density: projection surplus and canonical-cover constraints

**The unrestricted common-power inequality remains unresolved. This packet
certifies no admissible host with `F<1`.** It proves quantitative
projection-channel contractions, proves restrictions on the actual sources
of two-cover comparisons, and archives a bounded search of actual hosts
with three interacting character channels. It preserves the constant
surplus and the original measure throughout.

This is a draft follow-up to [PR #59](https://github.com/SamPetkov/Erdos593/pull/59),
whose frozen head is `0e2bdbb74868c1412325afd0a5bf9a4689bf7025`.
Earlier restricted arguments remain in
[PR #56](https://github.com/SamPetkov/Erdos593/pull/56),
[PR #57](https://github.com/SamPetkov/Erdos593/pull/57), and
[PR #58](https://github.com/SamPetkov/Erdos593/pull/58).
No unrestricted result, novelty classification, or new Lean theorem is claimed.

## Exact target and scope correction

On a finite positive original probability space, `T=W/p` is an actual
nonnegative self-adjoint Markov kernel, `A=T^2`, and `K_j=A^j`. The target is

\[
F=\mathbb E_{\mu^4}
K_k(a,b)K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d)\ge1,
\]

for `k>=u>=1`, `r>=l>=1`, and `h>=1`. All six powers come from that single
actual root, and every composition and integral uses its original `mu`.
The code tuple is `(k,u,r,l,h)` and edge order is `(ab,ac,ad,bc,bd,cd)`.

**The simultaneous boundary `k=u, r=l` already has a direct reflection
proof for every actual root.** The actual source
`f_ac(b)=K_u(a,b)K_r(c,b)` gives

\[
F\ge\mathbb E_{a,c}K_{r+h}(a,c)K_{u+r}(a,c)^2
\ge\operatorname{tr}A^{2(u+r)}\ge1.
\]

The first step uses `K_u-Pi` PSD and the nonnegative outside factor; the
second pairs `K_(r+h)-Pi` with a Schur square. The
[scope note](continuation4_boundary_scope.md) proves this, its equality
case, and the other vertex-pair reflection families. Accordingly, the
projection theorem below is a **quantitative improvement retaining the
coarse density**, not new coverage of that boundary density inequality.

## 1. Proved quantitative mechanism: arbitrary projection channels

Let `(I,pi)` be any finite positive original probability space. Let `Q`
be any original-law orthogonal projection, of rank `d`. It may have
negative entries, and need not annihilate or fix constants. For any two
nonnegative PSD Markov kernels `L,M`, even noncommuting ones, the note proves

\[
\mathbb E_{\pi^4}Q_{ab}Q_{bc}Q_{cd}Q_{da}L_{ac}M_{bd}\ge d.
\tag{1}
\]

The proof writes the difference from `d` as two nonnegative pairwise PSD
Hilbert--Schmidt pairings. For an actual common-power kernel `B=S^2`, a
triangle with complementary star lengths `(x,x,z)` satisfies

\[
J_{x,x,z}\ge\frac1d\left[d+\sum_{i>0}\lambda_i^{x+z}
  \|Q D_{\phi_i}Q\|_{\mathrm{HS}}^2\right]^2\ge d
\tag{2}
\]

when `d>0`; the rank-zero case is exact equality. These are the actual
compressed multiplication operators under the original `pi`, not arbitrary
substitutes for actual sources. Cauchy--Schwarz is applied to
`B_t C_t^(1/2)` and `C_t^(1/2)`; no positivity of a trace of three arbitrary
PSD matrices is assumed.

Suppose `S` is an actual coarse root, `H` is self-adjoint, `|H|<=S`, and
`H^2=beta Q`. Then

\[
T((i,a),(j,b))=S(i,j)+H(i,j)ab,\qquad \mu(i,a)=\pi_i/2
\]

is an actual fine root. Original sign averaging gives
`T^(2n)=S^(2n)+ab beta^n Q`. Its four-sign density expansion has seven
nonempty even subgraphs: four triangles and three quadrilaterals. At
`k=u, r=l`, (1)--(2) prove

\[
\boxed{F(T;n)\ge F(S;n)+d\sum_C\beta^{q_C},
\qquad q_C=\sum_{e\in C}n_e.}
\tag{3}
\]

There is a precise quantitative gain over the elementary reflection
estimate. One quadrilateral has `q_C=2(u+r)`, while

`tr((T^2)^(2(u+r)))=tr((S^2)^(2(u+r)))+d beta^(2(u+r))`.

Applying coarse reflection in (3) therefore retains **six further cycle
terms** beyond the direct fine trace bound. They are positive when
`d>0,beta>0`. The lemma also applies on the second paired-star ray
`r=l=u, k=u+h`, which is itself an ordinary reflection case.

The [complete projection proof](continuation4_tensor_projection_lemmas.md)
is accompanied by two fully rational eight-state examples:

| Example | Original-measure facts |
|---|---|
| [Heavy coarse atom](continuation4_projection_example.md) | `max pi=3/5`; rank-two `Q` fixes constants; noncommuting `S,Q`; five entire-centered square values, including zero; `p=512/4499`, `max A=2541919/327680>4`. |
| [Noncentral weighted star](continuation4_tensor_example.md) | `Q1` is neither zero nor one; noncommuting `S,Q`; entire centered values `(105/128)^2`, `(45/64)^2`, `1/4096`, `0`, with multiplicities `2,1,2,2`; `p=76/507`, `min W=3/676`. |

Both contain negative projection triangle products. Their complete `W`,
original weights, powers, spectra and density bounds are checkable with
standard-library rational arithmetic. Neither is new boundary density coverage.

## 2. Proved constraints on canonical two-cover sources

For an actual root `T`, put unordered pairs `i={x,y}` under the pushforward
law `pi_i=2 mu_x mu_y` for `x!=y`, and `pi_{xx}=mu_x^2`. The canonical pair is

\[
S(i,j)=\frac{T_{xz}T_{yw}+T_{xw}T_{yz}}2,\qquad
H(i,j)=\frac{T_{xz}T_{yw}-T_{xw}T_{yz}}2.
\]

The [source-structure proof](continuation4_cover_structure.md) establishes
the original-measure transport for every power. The binary lift is an
actual duplication of `T tensor T`, and its density is exactly `F(T)^2`.
If `r=rank T`, it necessarily has

\[
\operatorname{rank}S=r(r+1)/2,\qquad
\operatorname{rank}H=r(r-1)/2.
\tag{4}
\]

The PR #59 obstruction pairs have ranks `(9,3)` and `(5,3)`, so neither is
a canonical pair, even after pure duplication. This blocks that direct
transfer; it does not exclude a different larger construction.

For **invertible** actual `T`, a further rigidity theorem proves

\[
\boxed{SH=HS\quad\Longleftrightarrow\quad S^2H^2=H^2S^2
       \quad\Longleftrightarrow\quad T^2=I.}
\tag{5}
\]

The channel vanishes on diagonal pairs and is invertible on the distinct-pair
subspace. Commutation forces `T(i,j)T(i,k)=0` whenever `j!=k`. Actual
nonnegativity and the Markov row sums force a measure-preserving involution.
The singular exception `T=Pi` is recorded explicitly.

The permanent/determinant two-lift expansion is attributed to Csikvari's
[primary paper](https://arxiv.org/abs/1612.01295), Section 4, particularly
Theorem 4.2 and Lemmas 4.5--4.6; Section 5 handles positive vertex weights.
Its determinant sign-gauge hypothesis is not automatic for these actual
roots, as a three-state exact diagnostic demonstrates. No novelty is inferred
from this attribution or from the new derivations.

## 3. Bounded actual-host search and exact certificates

The [complete search report](continuation4_search_report.md) uses four-state
fibers with three interacting character channels. Nonnegative symmetric
flows determine the original measure and the single actual root exactly.

| Completed work | Scope |
|---|---|
| 144 rational host--tuple pairs | 12, 16 or 20 states; 4--19 entire-centered square values; 32 with a zero band. |
| 1,008 complete two-cover evaluations | All seven nontrivial two-covers on every sampled pair. |
| 21 bounded starts | 788 iterations; 879 selected-objective calls; 19 reported convergence, two reached their cap. |
| 147 retained cover evaluations | All seven covers at each retained point. |
| Exact candidate resolution | All three sampled floating excesses are strictly below `F^2` by integer arithmetic. |
| Seven exact uniform endpoints | Each has `F>1` and its selected cover `Z<F^2`, certified by cleared integers. |

Every sampled host has noncommuting character matrices; 142 have a negative
entry in a channel square, and 86 have both `p<1/4` and `max A>4`. The report
separates this finite scope from every universal conclusion. Free-measure
optimization often concentrates mass and raises the base density; exact
uniform generator mixtures are distinguished from their rounded summed
matrices. Equality, disconnected roots, connected bipartite roots with
disconnected squares, and tuple boundaries have separate exact controls.

A separate [canonical-cycle diagnostic](continuation4_cover_numerical_report.md)
tested 252 seeds and 12 bounded starts. It found no negative candidate;
**none of those twelve optimization runs reported convergence**. That
diagnostic is not the 1,008-comparison complete-cover search.

## 4. Reproduction and independent review

Run these standard-library exact checkers from this directory:

```sh
python continuation4_projection_verify.py
python continuation4_tensor_example_verify.py
```

The canonical-cover checker uses exact rational/integer arithmetic and
imports NumPy for the contraction engine. The two search certificate
scripts also import SciPy through the search engine. Use the recorded
NumPy/SciPy runtime for these exact computations:

```sh
python continuation4_cover_verify.py
python continuation4_search_roundoff.py
python continuation4_search_uniform_certify.py
```

The independent computational search gate and numerical audits also use
that runtime. Reproduction commands and source hashes are in each report.
The exact projection checker has 60 contraction
checks and 11 host--tuple pairs on seven roots; the complementary example
has three tuples. The canonical checker covers eight rational hosts and
49 complete two-cover comparisons across seven of them. These finite checks
supplement the written proofs rather than proving the universal statements.

Separate analytical reviewers checked the projection proof and the scope
correction. The root independently replayed the frozen exact cover and
search gates and the complementary example in fresh temporary directories.
Reviews bind the actual source hashes. This is internal adversarial review,
not an external referee report or formal verification.

The complete committed payload and SHA256 hashes are listed in
[manifest.json](manifest.json). The numerical experiment's own frozen
allowlist is retained separately and verified without changing its inputs.

## 5. Two exact missing obligations, with different mechanisms

1. **Unequal-star compressed multiplication bound.** For an actual coarse
   square `B=S^2` and `R_t=Q D_(1_(.=t)/pi_t) Q`, establish or refute
   `E_t tr[(B^x R)_t (B^y R)_t (B^z R)_t] >= rank Q` for genuinely unequal
   positive `x,y,z`. This would extend the projection comparison beyond
   paired stars. Positivity of the three factors alone is insufficient.
   Even a proof would concern this projection-channel class and would not
   settle every actual host.
2. **All-sheet canonical cover domination.** Establish, or find an actual
   counterexample to, `Z_sigma(T;n)<=F(T;n)^M` for every finite `M`-cover
   with the prescribed common-power factors and original law. The preceding
   entropy lower bound for averaged covers would then imply `F>=1`.
   The source constraints proved here distinguish actual canonical channels
   from arbitrary signed channels. They do not supply this inequality, and
   seven base two-cover comparisons do not imply the all-sheet assertion.

Both are theorem-strength obligations. The second is a stronger sufficient
route and could fail while the density target remains true. The exact
Dirichlet reformulation, a negative individual mode, and failed arbitrary
coarse domination are not counted as resolutions of the target.
