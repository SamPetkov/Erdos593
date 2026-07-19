# Problem 593 classification audit

This record reconciles the independently checked Aristotle audit with the
current Problem 593 source tree.  It is a dependency guide, not a replacement
for the Lean proofs.

## Public endpoints

The finite classification is stated in
`TripleSystem/ObligatoryClassification.lean`.

- `TripleSystem.isObligatory_iff_isolatedReduction_intrinsic` proves
  `F.IsObligatory ↔ F.isolatedReduction.Intrinsic`.
- `TripleSystem.isObligatory_iff_constructible_isolatedReduction` proves
  `F.IsObligatory ↔ TripleSystem.Constructible F.isolatedReduction`.

Both statements require finite vertex and edge types.  The reduction to
`F.isolatedReduction` is deliberate: isolated vertices are reattached only by
the separately proved obligatory-preservation theorem.

## Negative direction

For a finite linear source, the formal argument follows this order.

1. `Embedding.finiteLinear_isolatedReduction_imageTrace` identifies the
   isolated reduction of an embedded source with the appropriate finite,
   linear host trace.
2. `FiniteLiftGenerated.bridgeAtEveryEdge`, transported through
   `SequenceLiftEmbeddedSourceBridge.lean`, gives the missing-bridge
   obstruction.  Its unconditional conclusion is
   `TripleSystem.not_isObligatory_of_linear_of_not_isolatedReduction_bridgeAtEveryEdge`.
3. `FiniteLiftGeneratedBergeCycleTrace.lean` maps a Levi cycle to a *closed
   host walk* with the exact doubled-length relation.  It does not silently
   strengthen that walk to a simple cycle.  The shift-graph host has no short
   odd closed walks, yielding
   `SequenceLift.not_isObligatory_of_linear_of_not_isolatedReduction_evenBergeCycles_shiftHost`.
4. `TriangleHostRamseyUnconditional.lean` supplies
   `TripleSystem.not_isObligatory_of_not_linear` for the non-linear case.

Thus the public classification first rules out non-linearity, then a missing
bridge, and finally an odd Berge cycle.

## Positive direction

`BridgeBlock.isolatedReduction_constructible_iff_intrinsic` identifies the
bridge-block running-intersection condition with constructibility of the
isolated reduction.  `intrinsic_isolatedReduction_isObligatory` then restores
the isolated vertices and proves obligatoriness.

## Checks performed

The reconciled Aristotle run checked that the public endpoints depend only on
`propext`, `Classical.choice`, and `Quot.sound`, and that the internal import
graph is acyclic.  The current tree was additionally scanned for proof
placeholders and is exercised by the repository's Lean CI workflow.

The conditional files proposed by an earlier Aristotle run were not imported:
the current unconditional shift-graph obstruction and classification strictly
subsume their conclusions.
