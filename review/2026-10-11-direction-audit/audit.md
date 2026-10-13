# Source-bound mathematical audit

## Confirmed prompt-design checkpoint

The author confirmed this bounded pass: audit PRs #58–63 and the two authorized
Pro consultations, develop one tightly connected result if the audit supports
it, and update manuscript claims/research notes. No broad research campaign or
expensive Lean run.

- **Deliverable:** exact restricted verdicts, visible missing obligations, one
  complete analytical deduction if justified, and the matching review PDF.
- **Conventions:** a finite positive original probability law; relative kernels
  compose and integrate with that law. A root is entrywise nonnegative,
  self-adjoint and Markov. Its square is PSD. Edge kernels are common positive
  powers of the square. An arbitrary PSD matrix is not an admissible root.
- **Targets:** finite-alphabet exact-edge entropy on bipartite subdivisions of
  `K4`, and the ordered common-power density inequality. The new structured
  transfer is quantified over all six positive edge exponents, but only over
  its explicitly defined root class.
- **Non-goals:** unrestricted success by assumption, a novelty/B-level verdict,
  replacing original weights, hiding an equally hard reduction, or promoting
  manuscript proofs to Lean acceptance.
- **Methods:** conclusion-first dependency reconstruction, original-law tensor
  and spectral calculations, distinct Schur-form/Jordan/cover routes, and
  short exact certificate spot checks. Numerical optimization is not proof.
- **Validation:** root admissibility, weighted normalizations, zero/additional
  stationary modes, strictness at a zero channel, signed-tail directions,
  exhaustive stated cover scope, and coarse versus fine conclusions.
- **Cost:** source audit and short read-only rational checks; no fresh full
  cover-polynomial packet or compiler/service dispatch. Any larger campaign
  requires a new checkpoint rather than an automatic continuation.

## Frozen source map

| Public PR | Audited head | Principal material |
| --- | --- | --- |
| 58 | `707ce09c971083e9ee533f898aa7a88f075c81ea` | Block refinements; radial boundary reduction |
| 59 | `0e2bdbb74868c1412325afd0a5bf9a4689bf7025` | Signed-channel/coarse-domination obstructions |
| 60 | `06d17d7ce4d6a1d09891f79ec6feb59cdf68819b` | Paired-star surplus; projection-channel cover tools |
| 61 | `c7a93e01e29143fd998ee0053b338b575446c3f2` | All-exponent common-cone transfer |
| 62 | `bb919054eab3248e45ce1cd0c9a8cf1f39329025` | Jordan, zero-cubic sources and one-edge covers |
| 63 | `be6f7637147e0a02e8f03fa4f0ad770370b2327a` | Weighted flat complements; degree-two/three covers; modal obstruction |

All six heads' research files are retained in the PR63 stack under
[`2026-10-10-common-power-density`](../2026-10-10-common-power-density/README.md).
The audit does not certify every statement in that directory indiscriminately.

## Dependency verdicts

The statuses below are analytical/source-review findings, not kernel validation.
“Follows” is confined to the exact advertised restricted statement.

| Conclusion | Necessary obligations | Verdict and limitation |
| --- | --- | --- |
| Quantitative block refinement | Exact coarse/fibre powers; original-law four-vertex/six-edge masses; proper-subgraph densities; full-`K4` defect coefficient | **Follows.** Coarse block structure and the stated strength budget are essential; no arbitrary-root decomposition follows. |
| Boundary reduction | Centered expansion, positive proper coefficients, normalized radial defect, nonnegative-root endpoint | **Follows.** A strict violating root could be moved to a zero entry at the same size/law/tuple; no violating root is produced. |
| Common-cone signed transfer | Actual binary channel, seven-cycle expansion, averaged projection-star bound, two-PSD quadrilateral comparisons, coarse cone density | **Follows.** The cone uses one common nonnegative PSD Markov kernel, not different commuting kernels. |
| Paired-star comparison | Reflection-covered tuple and projection-star surplus | **Follows.** It gives a quantitative improvement on a class already covered by reflection, not new unrestricted coverage. |
| Jordan/source bounds | Actual multiplier fields; interval centering; spectral ordering; source cap or visible balance | **Follows.** The cap `4+4 sqrt(2)` and balanced rank at most ten are sufficient, not asserted optimal. Rank zero/one are handled separately. |
| Zero-cubic refinement | Mean-identity PSD fields; vanishing centered cubic trace; actual weighted realization | **Follows.** Zero fields are allowed. This remains a specified source class, not general modal positivity. |
| Weighted flat complement | Exact two-/three-multiplier tensors; PSD Schur form; completed-square error absorption; spectral remainder | **Follows.** Original-law criterion and codimension-one flat projection are explicit; coarse spectra need not have few bands. |
| One-edge all-sheet cover comparison | Correct transfer orientation; real spectrum on the specific host; second moment/negative-mode compensation; rational host certificate | **Follows conditional on the supplied exact certificate.** General transfer matrices need not have real spectrum. No fresh full arithmetic replay in this pass. |
| Simultaneous covers of degree at most three per component | Original-law gauge; component factorization; seven double/41 triple types; complete signed flow recursion; rational interval budgets | **Follows within the code-assisted scope.** Arbitrarily many components/sheets do not mean arbitrarily large connected degree. |

### Two decisive obligation graphs

```text
Weighted lift comparison
  AND actual root + original-law power transport
      AND seven-cycle sign expansion
          AND triangle = averaged compressed-multiplier trace
              AND exact weighted tensor identities
                  AND PSD Schur-form completion + spectral error budget
          AND quadrilateral >= rank by two PSD pairings
      AND unchanged coarse-density contribution

Universal common-power density
  NOT discharged by weighted lift comparison:
      arbitrary roots need not admit its channel/projection/weight structure.
```

```text
All-sheet comparison for the certified host, components of degree <=3
  AND actual variable-permutation gauge under the original product law
      AND exhaustive connected type list (7 + 41)
          AND exact signed character-flow polynomial
              AND all negative tails retained, uniformly for k>=4
      AND independent-component product

Universal simultaneous-cover comparison
  OPEN: connected degree >=4 and, separately, arbitrary-host comparison.
```

## Obstruction boundaries

1. The actual signed-channel examples can have `1 < F(fine) < F(coarse)`.
   They refute general coarse domination, including a commuting variant;
   they do not refute the density bound `F>=1`.
2. The ten-state original-law example has a negative active centered modal
   average in `(-1/10000,-1/20000)`, while its complete density exceeds four
   (a certified lower bound is approximately `4.0593047427`). It defeats an
   individual-mode positivity shortcut, not collective compensation or `F>=1`.
3. The general sign-lift comparison must qualify strictness by `beta>0`.
   For `beta=0`, self-adjointness forces the channel to vanish and coarse/fine
   densities agree. The final manuscript includes this branch explicitly.
4. Two positive centered spectral values plus zero are three values; zero
   cannot be silently omitted to invoke a two-value theorem.
5. The source condition `J>=rank(Q)` is not asserted for every projection.
   Proving it generally would still not supply an arbitrary-root reduction.

## Actual supplementary checks and limits

Four actual supplementary agent reviews were received: refinement/cone,
Jordan/story, weighted density, and cover/modal obstruction. The weighted
reviewer additionally checked the proposed transfer and the final inserted
proposition/proof, including weighted triangle/quadrilateral normalization.
This is genuine separate-agent review, not a fabricated external audit.

Short exact checks ran with verifier output writes suppressed:

- weighted-source/example identities, 13/26-state root/density checks,
  6,084 TP2 minors, and retained zero/disconnected/equality branches;
- all 48 saved rational cover interval budgets, all 343 original cubic
  moments, representative lists and the 235-term base polynomial;
- the ten-state modal certificate and a distinct rational inverse-filter
  implementation;
- the small rational compressed-power obstruction seed.

No optimizer or full packet was run. In particular, all 41 three-sheet flow
polynomials were **not** independently regenerated during this pass. The
exhaustive generator was inspected and all saved budgets checked. The earlier
packet's independent partial regenerations are not relabeled as fresh work.

## Authorized Pro reply readback

The density conversation visibly contained source-linked continuations and
the latest publishing attempt ended with a delivery-timeout alert. PR63's
existence/head was independently verified through GitHub; no missing final
assistant text was invented and no retry was triggered. The exact authorized
entropy conversation could not load, including from its visible project link.
Its unseen response supplies no new proof evidence. No new consultation was
submitted, and no unrelated chats were inspected or exported.

## Result

No fatal flaw was found in the restricted statements actually audited.
The complete new connected deduction is recorded separately in
[transfer-and-directions.md](transfer-and-directions.md) and the manuscript.
The two unrestricted targets, new Lean coverage and research-impact/novelty
assessment remain open. A successful restricted audit cannot close them.
