# Distinct mechanisms, exact scope, and two remaining obligations

**Verdict:** no unrestricted proof and no admissible `F<1` certificate.
The following results are complete for their stated hypotheses. A
theorem-strength missing lemma blocks the corresponding unrestricted
route; it is not counted as progress merely to formulate it.

## Completed mechanisms in this bounded continuation

| Mechanism | Proved advance | Precise limit |
|---|---|---|
| Center the full Jordan multiplication interval | The actual cap `M_x<=L I`, `L<=4+4sqrt2`, controls the entire cubic contribution and retains a square plus explicit variance surplus. | Arbitrary actual sources can have unbounded norm. This is a sufficient source condition, not a new density assumption on the target. |
| Compress the Jordan interval to traceless fields | Visible balance `B diag(Q)=rank Q` proves all positive triples in ranks through ten, without a spectral-band restriction. | General sources have surviving trace variation; the displayed coefficient does not settle ranks above ten. |
| Annihilate cubic traces algebraically | A fixed centered source subspace with `tr(XYZ)=0` gives the exact full-pair identity. Rank two and fixed block grading are explicit mechanisms; original-law refinement is proved. | The condition is not automatic. Graded cap-two coverage overlaps the Jordan theorem and is not counted as an independent extension for the same host. |
| Expand a uniform flat rank-one complement | `Q=I-f tensor f`, `f_i=+-1`, yields an exact star identity in all ranks; a Schur pairing bounds its scalar term. | The cancellation uses the uniform original law and flat complement. The theorem is not stated for arbitrary codimension-one projections. |
| Use a whole-transfer second moment | A real-spectrum budget with a negative eigenvalue controls every power trace, hence every sheet count for one-edge covers. The supplied actual 32-state host is certified for all six edge choices and every `(k,4,1,1,8)`, `k>=4`. | Arbitrary actual transfers are not assumed to have real spectrum or the required budget. Multiple nontrivial edge permutations do not factor through this single matrix. |
| Search actual source geometries adversarially | Three archived bounded stages, 54 configured starts, original roots and exact refinement parametrizations, no strict averaged-star candidate. | Floating-point results are diagnostics. No universal sign, full-target optimization, or exact counterexample follows. |

The rank-ten and rank-twelve examples explicitly test many interacting
coarse bands, an additional channel value, zero modes, and failure of
stronger sufficient criteria. The weighted examples retain their original
normalization. Exact controls include repeated exponent boundaries,
`k=u`, `r=l`, `h=1`, refresh equality, zero channel, and disconnected
squares. No tensor-product or component normalization shortcut is used.

## Obligation 1: unrestricted actual averaged-star contraction (U)

For every actual nonnegative self-adjoint Markov root `S` on finite
positive original `pi`, let `B=S^2` and let `Q=Q*=Q^2` be an arbitrary
original-law projection of rank `d`. Keep the actual field

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_{\operatorname{ran}Q}.
\]

The unresolved statement is

\[
\boxed{\mathbb E_{i\sim\pi}\operatorname{tr}
 [(B^xR)_i(B^yR)_i(B^zR)_i]\ge d
 \quad\text{for every }x,y,z\ge1.}\tag{U}
\]

This continuation proves (U) under the explicit Jordan cap, under
visible balance through rank ten, under vanishing cubic-source structure,
and for the uniform flat-complement family in all ranks. The earlier
common-cone proof remains available. None eliminates all possible
surviving trace variation and unbounded source geometry. This route is
blocked outside its proved classes unless a further actual-source
mechanism is found.

The actual pointwise positivity claim and universal fixed-fraction pair
surplus were already refuted in continuation5. They are not recycled as
lemmas. A failed sufficient bound is not a failure of (U). Even a proof
of (U) would only complete the general binary projection-channel
comparison when combined with the established quadrilateral lemma. It
would not prove every coarse density or give a structural reduction of
every target root to that channel form.

## Obligation 2: arbitrary simultaneous finite covers (C)

For an actual target root `T` on original `mu`, let its edge exponents
be `n=(k,r+h,u,r,u,l)`. For `M>=1` and six permutations
`sigma_e in Sym(M)`, define

\[
Z_\sigma=\mathbb E_{\mu^{4M}}
 \prod_{e=vw\in E(K_4)}\prod_{a=1}^M
 K_{n_e}(x_{v,a},x_{w,\sigma_e(a)}).
\]

The remaining sufficient statement is

\[
\boxed{Z_\sigma\le F(T;n)^M
\quad\text{for every }M\text{ and every six permutations}.}\tag{C}
\]

The earlier [original-law type/entropy argument](../route-registry.md)
proves `limsup_M (E_sigma Z_sigma)^(1/M)>=1`. Therefore (C) would imply
the exact target. It compares partition functions of different finite
graphs and is stronger than the target; it is not the supplied Dirichlet
reformulation.

The new second-moment mechanism handles arbitrary cycle lengths in a
single edge permutation on the specified actual host. When several edge
permutations are nontrivial, the remaining integrations couple different
sheet cycles, so formula `Z=product tr(R^m)` does not apply. The earlier
negative coefficient and barbell examples also rule out naive termwise
positivity; they do not disprove complete cover domination. This route
remains blocked for arbitrary covers. A violation of (C) alone would
still not be an admissible counterexample with `F<1`.

These are distinct obligations: (U) is a multiplication-field contraction
for a structural transfer; (C) is a global finite-cover comparison
sufficient for the target. No further theorem-strength requirement is
hidden as a routine final step.

## Primary literature and dependency scope

The new Jordan, zero-cubic, uniform-complement, and real-spectrum
second-moment arguments are proved by finite algebra in this packet.
They are not imported from an unverified theorem. The facts about
original-law self-adjoint squares, Schur products, and finite power sums
are applied with their full hypotheses displayed.

The example-specific coarse input is the repository's previously proved
[common-order convex-TP2 theorem](../tp2-class.md). Its underlying primary
source is Nicholas Ruozzi, *The Bethe Partition Function of Log-supermodular
Graphical Models*, [arXiv:1202.6035v2](https://arxiv.org/abs/1202.6035v2),
Theorems 3.8 and 4.1. Those hypotheses concern nonnegative Boolean
log-supermodular functions and their graph covers. The repository proof
spells out the order-threshold encoding, zero extension, original-law
weights and type/entropy lower bound before using them. The numerical
labels of the theorems and the PDF hypotheses were checked in the primary
paper during this continuation. No direct application to arbitrary
common-power kernels is claimed.

For the exhibited coarse roots, all ordered two-by-two minors of `S0`
are checked. Weighted Cauchy--Binet preserves the common TP2 order under
composition. The refreshed powers lie in the finite convex hull of
`S0^m` and `Pi`, and multilinearity preserves the density lower bound.
Refresh or convex mixing is not asserted to preserve TP2 itself, and
density closure is not promoted to arbitrary mixed cover domination.

The prior packets preserve the precise limitations of subdivision and
reverse-Sidorenko citations. No literature absence is used to infer
novelty, and no external citation replaces either obligation above.
