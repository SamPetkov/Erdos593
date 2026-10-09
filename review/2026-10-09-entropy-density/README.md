# Entropy and common power density review

The rank-three graph cores of the obligatory-system classification motivate two
quantitative questions: sharp exact-edge entropy witnesses on bipartite K4
subdivisions, and homomorphism-density comparisons for powers of one weighted
regular host. Both unrestricted questions remain open. The statements proved
here cover explicit families rather than the whole requested domains.

The updated [manuscript](../2026-10-02/erdos593_obligatory_triple_systems.tex)
states these results in its quantitative section and gives their full technical
proofs in Appendix B. The classification and original finite-result proofs
remain unchanged. The quantitative comparisons are not consequences of
obligatoriness and are not accepted Lean exports.

## Proved restricted results

- Uniform-q Potts exact-edge entropy on graphs where each edge has an endpoint
  of degree at most three; the antiferromagnetic case also requires bipartiteness.
- Arbitrary compatible pair tables in an explicit graph-dependent neighbourhood
  of independence, and open full-table families around cyclic interior Potts inputs.
- Conditional alphabet-block mixtures with cycle-rank entropy surplus, IID
  buffering and explicit centered corrections that preserve every actual marginal.
- Common-power density for complete centered spectra with at most two levels,
  and fixed-host, fixed-tuple stability around strict comparison points.

The explicit positive three-colour example has a constructed witness with
KL-budget slack greater than 229/540 nats. Its graph, K3,3 minus one edge,
already has universal entropy existence by Conlon–Fox–Sudakov and Szegedy.
The example illustrates how to spend entropy surplus, not a newly solved graph family.

## Proof sources and detailed reviews

[The first-round sources](universal-round1-20261009/) retain the complete Potts,
local-table, openness and common-cone arguments, their actual source audits and
failed-route distinctions. [The second-round sources](public-review-round2-20261009/)
contain the new budget-transfer and stability arguments, the exact example,
literature qualification, static checks and editorial comparison.

Read [review one](public-review-round2-20261009/review-one.json) and
[review two](public-review-round2-20261009/review-two.json) for the two detailed
separate-agent adversarial reconstructions. They check the precise restricted
contracts and manuscript transcriptions; they are not full external referee
reports, novelty clearance, breakthrough certification or Lean acceptance.
Their findings include repaired forest wording, the distinction between negative
individual contributions and unproved collective prefixes, and known-case attribution.

## Exact remaining obligations

The alphabet problem still needs a global sharp KL budget outside the proved
families, including arbitrary zero-support boundaries. Exact marginal feasibility
alone does not provide this budget. The common-power problem still needs collective
compensation for general interacting spectra of an actual nonnegative Markov
square root, with the original weighted measure and the prescribed exponents.
Negative individual summands are not counterexamples to the full density.

Neither these comparisons nor all retained manuscript extensions are completely
formalized. The accepted Lean baseline, its pins, workflows and evidence remain
unchanged. No new paid proof request, Lean run, private development or recurring
monitor was started in this pass. Novelty and journal significance remain to be assessed.
