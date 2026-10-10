# Common-power density continuation — 10 October 2026

**The unrestricted target remains unresolved; no admissible counterexample is certified.** This review packet proves an unconditional quantitative refinement inequality and an actual-root boundary reduction, then derives a uniform sufficient family with arbitrary internal Markov dynamics. It also preserves the earlier literature-based convex-TP2 class and the completed bounded search record.

The packet is based on [PR 57](https://github.com/SamPetkov/Erdos593/pull/57), commit `2f8731673a4ad49952c2eb203ed4f00fe4ba85ec`, which is stacked on [PR 56](https://github.com/SamPetkov/Erdos593/pull/56). It adds review material in this dated directory. It does not change the accepted theorem classification or claim formal verification of a new universal result.

## Read the mathematics

| File | Contents |
| --- | --- |
| [research-note.md](research-note.md) | Exact target; full proofs of independent edge resampling, radial reduction, block refinement, and arbitrary-inner surplus; weighted examples and precise limitations. |
| [tp2-class.md](tp2-class.md) | Fully spelled-out application of Ruozzi's cover inequality, preserving the original measure and zeros; finite convex mixtures and composition closure. |
| [route-registry.md](route-registry.md) | Distinct collective, probabilistic, cover, and optimization routes; checked primary-literature hypotheses; one exact outstanding sufficient obligation. |
| [final-review.json](final-review.json) | Independent analytical review and hashes of the mathematical files actually reviewed. |
| [numerical-report.md](numerical-report.md) | Completed search counts, parametrization, fixed bounds, reproduction instructions, and limitations. |

The main new inequality is the following. For original refined measure $\mu(i,a)=\pi_i\nu_i(a)$ and actual root

$$
T((i,a),(j,b))=S(i,j)+\mathbf1_{i=j}\frac{\gamma_i}{\pi_i}(R_i(a,b)-1),
\qquad0\le\gamma_i\le\pi_iS(i,i),
$$

write $N=\sum_e n_e$. Then, without assuming the target for any constituent,

$$
F(T;n)\ge F(S;n)+\sum_i\pi_i^{-2}\gamma_i^{2N}(F(R_i;n)-1).
$$

Its arbitrary-inner consequence retains a quantitative part of the known coarse density surplus. The four-state star construction with a trivial center and arbitrary leaf roots at strengths at most $1/2$ satisfies

$$
F(T;n)\ge1+15\cdot4^{-N}.
$$

Internal cardinality, positive weights, eigenvalues, and dynamics are unrestricted within that construction. This is a structural sufficient theorem, not the unrestricted target.

## Reproduce the finite exact checks

From this directory, with Python 3.10 or later:

```bash
python verify_exact.py --output exact-results.json
```

The script requires only the standard library. It uses `fractions.Fraction` for original-measure matrix powers and full finite sums. It checks the exact weighted witnesses, centered-zero spectrum, proper-core expansion, radial identity, refinement powers and inequality, all five-state stochastic orders, and disconnected transport. Its deterministic expected output is [exact-results.json](exact-results.json).

These finite checks audit the displayed examples and identities; the general theorems are established by the written proofs. Floating-point searches have a separate scope and a separate reproduction procedure in the numerical report. A numeric equality, optimizer termination, or absence of sampled violations is not a proof of the unrestricted inequality.

## Review and provenance

The consultation used actual separate tensor, Markov, and optimization agents. The final proof files were read adversarially, and the original-measure correction found in the TP2 path example was fixed before the hash-bound review. The final finite verifier was run and its output checked against the committed result. This is transparent analytical and computational provenance; it is not an external referee report, a novelty finding, or new Lean evidence.

The earlier common-cone theorem and centered-core expansion are credited at their point of use. Primary sources and the limits of their hypotheses are linked in the route registry. The user-provided negative actual mode remains only a counterexample to modewise positivity. The supplied Dirichlet reformulation is not counted as progress.
