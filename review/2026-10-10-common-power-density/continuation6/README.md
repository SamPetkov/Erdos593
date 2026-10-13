# Actual unequal stars: Jordan bounds and collective cover moments

**Exact verdict: the unrestricted common-power density inequality remains
unresolved. No admissible finite counterexample is certified.** This
bounded continuation proves further restricted cases of the actual
averaged projection-star contraction, gives all-exponent density bounds
for explicit actual hosts with many interacting spectral bands, and proves
an all-sheet comparison for a restricted cover family on the supplied
negative-mode host. None is substituted for the unrestricted target.

The packet is stacked on [PR 61](https://github.com/SamPetkov/Erdos593/pull/61),
commit `c7a93e01e29143fd998ee0053b338b575446c3f2`. Earlier packets, including
their adverse examples and scope restrictions, are preserved. The work
adds mathematical notes and reproducible checks; it makes no change to
the accepted theorem classification or Lean interface. No novelty claim
is made.

## 1. Target and the actual auxiliary object

The target retains a finite positive ORIGINAL probability `mu`, a symmetric
`W in [0,1]` with every original-weighted row sum `p>0`, its actual
nonnegative Markov root `T=W/p`, and `K_j=(T^2)^j`. It asks whether

\[
\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
 K_r(b,c)K_u(b,d)K_l(c,d)\ge1
\]

for `k>=u>=1`, `r>=l>=1`, `h>=1`. The tuple order in every certificate is
`(k,u,r,l,h)` and the edge order is `ab,ac,ad,bc,bd,cd`.

For the projection-channel route, let `S` be another actual root on its
explicit original probability `pi`, put `B=S^2`, and let `Q=Q*=Q^2` have
rank `d`. On `E=ran Q`, the source is fixed by that projection:

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_E,\qquad
M_s=B^sR,\qquad X_s=M_s-I_E.
\]

The averaged star is `J_xyz=E_pi tr(M_x M_y M_z)`. It is not an arbitrary
choice of three PSD matrices. All averaging and composition keep the
original law. The complete spectral expansion, including additional
stationary modes and zero modes, gives

\[
g_{st}:=\mathbb E\operatorname{tr}(X_sX_t)
=\sum_{j>0}\lambda_j^{s+t}\|QD_{\phi_j}Q\|_{HS}^2\ge0,
\qquad v_s=g_{ss}.
\]

These centered quantities have different definitions from the uncentered
`g` in continuation5's quadratic estimate.

## 2. Main derivation: the full Jordan interval

The [complete Jordan proof](continuation6_jordan_contraction.md) bounds the
entire self-adjoint operator `L_A(Y)=(AY+YA)/2`. If its quadratic forms lie
in `[a,b]`, centering the interval gives

\[
\langle Y,L_A Z\rangle\ge
\frac{a+b}{2}\langle Y,Z\rangle
-\frac{b-a}{2}\|Y\|\|Z\|.
\]

This is a bound on the collective cubic contribution. It permits a
negative cubic term and uses its correlation with the quadratic terms.
It does not assert modewise positivity or a sign for three PSD factors.

Sort `x<=y<=z`, using symmetry of the real trilinear trace. The common
nonnegative spectrum gives `g_xy>=v_y` and `g_xz>=g_yz>=v_z`.
If the actual shortest-time field satisfies `0<=M_x(i)<=L I_E`, the
Jordan interval is `[-1,L-1]`. Consequently

\[
\begin{aligned}
J_{xyz}-d
&\ge g_{xy}+g_{xz}+\frac L2 g_{yz}
                         -\frac L2\sqrt{v_yv_z}\\
&\ge\left(\sqrt{v_y}-\frac L4\sqrt{v_z}\right)^2
       +\left(1+\frac L2-\frac{L^2}{16}\right)v_z.
\end{aligned}
\]

Thus an actual source cap `L<=4+4sqrt(2)` proves `J_xyz>=d`, in any
dimension and with any number of spectral bands. A first-step cap on
`BR` propagates to every positive exponent by Markov averaging. The
convenient rational cap `L=9` leaves `7v_z/16` after the square.

If instead the **visible trace is balanced**, `B[Q(i,i)]=d`, every
positive-time `X_s` is traceless. For traceless symmetric `Y`,
`||Y||op^2<=(d-1)||Y||HS^2/d`. Compressing the Jordan operator to this
subspace gives the sharper interval `[-1,d-2]`, without assuming that the
uncompressed operator preserves the subspace. Hence

\[
J_{xyz}-d\ge
\left(\sqrt{v_y}-\frac{d-1}{4}\sqrt{v_z}\right)^2
 +\frac{-d^2+10d+7}{16}v_z.
\]

It follows that **every balanced-visible projection of rank at most ten**
satisfies the averaged star inequality for all positive triples. For
positive rank, equality holds exactly when `BR=I_E`. Balance is an
additional source condition; rank at most ten alone is not the theorem.
The thresholds describe this argument and are not claimed optimal.

## 3. Two further exact source calculations

The [vanishing-cubic note](continuation6_cubic_subspace.md) gives a stronger
identity when the span of the actual centered first-step fields obeys
`tr(XYZ)=0` for every three members:

\[
J_{xyz}=d+g_{xy}+g_{xz}+g_{yz}.
\]

It proves exact original-law projection realization of PSD fields with
mean identity. This transport is used only together with the explicit
zero-cubic condition. Fixed off-diagonal block grading and real traceless
rank-two fields supply examples. The independent
[rank-two note](continuation6_unequal_balanced_rank2.md) also handles
balance that appears only after smoothing. The graded fields have cap at
most two and are covered by the Jordan theorem as well; their additional
conclusion is the exact full-pair surplus, and their density coverage is
not counted twice. A variable-trace diagonal line shows that the general
zero-cubic mechanism is not restricted to the Jordan cap.

The [uniform-complement note](continuation6_search_codimension_one.md)
proves an arbitrary-rank family outside the general rank-ten criterion.
On `n` original uniform states, choose any flat sign vector `f_i=+-1` and
put `Q=I-f tensor f`, of rank `n-1`. The vector need not be centered or
commute with the actual root. With

\[
L_{xyz}=\mathbb E_{a,t}K_x(a,t)K_y(a,t)K_z(a,t),\qquad
\tau_{st}=\operatorname{tr}B^{s+t},
\]

the exact weighted expansion is

\[
J_{xyz}=(n-3)L_{xyz}+\tau_{xy}+\tau_{xz}+\tau_{yz}-1.
\]

The Schur product is PSD, so pairing `K_x-Pi` with `K_y circ K_z`
gives `L_xyz>=max(tau_xy,tau_xz,tau_yz)>=1`. For `n>=3`,

\[
J_{xyz}\ge n-1+(n-3)\max_{s<t}(\tau_{st}-1)
                      +\sum_{s<t}(\tau_{st}-1)\ge n-1.
\]

Only the three labeled exponent pairs are summed. The cases `n=1,2`
are proved separately. This uses a pairing of two PSD operators, not a
purported positivity rule for three operator factors.

## 4. Transport to complete actual density examples

For a binary projection channel on original `mu(i,sigma)=pi_i/2`,

\[
T((i,\sigma),(j,\tau))=S(i,j)+\sigma\tau H(i,j),\quad
H=H^*,\quad |H|\le S,\quad H^2=\beta Q,
\]

averaging the original intermediate sign gives
`T^(2s)=S^(2s)+sigma tau beta^s Q`. The six-edge sign expansion leaves
the empty subset and exactly the seven cycles of `K4`. The new triangle
bounds and the previously proved arbitrary-projection quadrilateral
lemma yield

\[
F(T;n)\ge F(S;n)+d\sum_{D\in\mathcal C(K_4)}
                         \beta^{\sum_{e\in D}n_e}.
\]

The coarse term is retained. Each host below has its own checked coarse
input from the prior [convex-TP2 theorem](../tp2-class.md), so its complete
target density is at least one for **every** six positive edge exponents.
The refreshed coarse kernel itself is not asserted TP2. Its powers are
convex combinations of powers of a common-order TP2 Markov root and `Pi`.
For a pullback refinement, integrating each original conditional fiber
weight gives one, so its coarse density equals the unrefined density.

| Actual fine host | Projection rank | Distinct values on the entire centered square spectrum, including zero | What the example checks |
|---|---:|---:|---|
| Weighted 12-state host | 2 | 7 | Five interacting positive coarse bands; signed noncentral projection; noncommutation; all-exponent exact full-pair transfer. |
| Weighted 16-state graded host | 4 | 5 | Three interacting positive coarse bands; condition only after smoothing; zero modes; two nonreflection tuples and an equality-boundary tuple. |
| Uniform 24-state host | 10 | 13 | Eleven interacting coarse bands; nonzero actual cubic; actual first-step Rayleigh quotient exceeds `97/10`, so the general source cap fails. |
| Uniform 26-state flat-complement host | 12 | 14 | Twelve coarse bands; rank above ten; source norm above ten and nonzero actual cubic; the complement identity supplies the bound. |
| Reused weighted 8-state host from continuation5 | 2 | 5 | Nonconstant visible trace; actual scalar first-step cap `9929/1280<9`, upgrading the old fixed-tuple certificate to all exponents. |

The exact roots, positive original weights, normalizing `p`, and rational
certificates are in the linked example notes and JSON. In particular,
none of these is presented as a host with `F<1`. The whole-centered band
counts include the additional zero value; the old two-value theorem is
not invoked by miscounting two positive values plus zero.

The [Jordan examples](continuation6_jordan_examples.md) specify the
24-state and reused 8-state hosts; the
[graded example](continuation6_graded_example.md) specifies the 16-state
host. The rank-two and uniform-complement notes linked above include
their own 12-state and 26-state constructions.

## 5. Collective covers with every sheet count

The [cover-moment proof](continuation6_cover_moments.md) is a distinct
mechanism. For a single permuted edge `e`, integrate the other two
vertices of its sheet into `D_e`, and use the original-law transfer
`R_e=K_(n_e) D_e*`. If the sheet permutation has cycle lengths `m_j`,

\[
Z_{e,\sigma}=\prod_j\operatorname{tr}(R_e^{m_j}),\qquad
\operatorname{tr}R_e=F.
\]

When this actual nonnegative transfer has real spectrum and
`tr(R_e^2)<=F^2`, the power-sum inequality gives

\[
0\le\operatorname{tr}(R_e^m)
\le\left(\operatorname{tr}(R_e^2)\right)^{m/2}\le F^m
\quad(m\ge2).
\]

Negative eigenvalues are permitted. An exact character calculation on
the user-supplied actual 32-state sign host proves the required budget
for all six choices of edge and every tuple `(k,4,1,1,8)`, `k>=4`.
If `L_sigma` sheets lie in nontrivial permutation cycles, the result is

\[
Z_{e,\sigma}\le F^M
\left(1-\frac{\delta_e}{F^2}\right)^{L_\sigma/2},\qquad
\delta_{ab}=2^{-(4k+25)},\quad\delta_e=2^{-60}\ (e\ne ab).
\]

The comparison is strict for a nonidentity permutation. The known
negative `ab` mode is retained for every `k`, rather than replaced by a
false positivity assertion. This controls one permuted edge with all
other matchings equal to the identity. Multiple independently permuted
edges do not admit the same one-transfer factorization.

## 6. Verification and bounded numerical evidence

The finite exact checks use the standard library's integers and
`Fraction`. The written arguments prove the general statements; finite
matching is a separate audit of examples, normalizations, and identities.
Independent reviews reconstruct key hosts and full densities using
different ordinary transition-matrix arithmetic. The cover audit
reconstructs all original third moments and all 294 transfer coefficients.
The root audit independently checks the uniform-complement field identity
and the variable-trace diagonal line.

From this directory, run:

```bash
python continuation6_packet_audit.py
```

This verifies hashes and runs the five author exact checkers and the
additional independent review programs inside a temporary copy. It
preserves the frozen files. With NumPy and SciPy installed, the optional
`--include-numerical` flag also replays the saved optimization records;
it starts no optimizer. Each individual verifier remains runnable from
this directory. The rank-two verifier explicitly imports only frozen
arithmetic from continuation4; independent reviewers do not import it.

The [numerical report](continuation6_search_report.md) records three
configured stages with 54 completed starts: scalar and complement
projections, exactly refinable PSD fields, and rare-state completion
costs. None yielded a strict numerical `J<rank Q` candidate. No complete
target `F` optimization or counterexample certificate is claimed. The
audit separately discloses rare-state conditioning errors, the failed
provisional tolerance, and its diagnostic tolerance. Other exploratory
probes are excluded from these counts and this publication packet.

## 7. What remains open

The [route registry](continuation6_route_registry.md) retains exactly two
theorem-strength obligations: the actual averaged-star inequality (U)
outside the proved source classes, and the all-sheet comparison (C)
with arbitrary simultaneous edge permutations. The former would extend
a projection-channel comparison but would not alone solve the full
target. The latter, together with the already proved original-law cover
entropy lower bound, would imply the target. Neither is labeled a
routine compatibility check or assumed true.

The new proofs do not depend on the supplied Dirichlet identity, a
modewise sign, a positive trace of three PSD matrices, or a nonrealizable
root. The initial PR was rechecked before publication and had no new
comments or reviews. This packet documents the completed bounded pass;
it does not schedule further continuations.
