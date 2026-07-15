# Erdős Problem 593: Lean formalization

This Lean 4/mathlib project formalizes the finite structural kernel of the
classification of obligatory triple systems.

The first milestone is the equivalence between the constructive class generated
by finite edgeless triple systems, private-vertex expansions of finite bipartite
graphs, finite disjoint unions, and one-point amalgamations, and the intrinsic
Levi-graph conditions:

1. linearity;
2. a bridge incident with every hyperedge-node;
3. even length of every Berge cycle.

The infinitary colouring and avoidance arguments are deliberately outside this
first milestone.

## Current status

The current scaffold builds under Lean/mathlib `v4.32.0` and contains no
`sorry`, `admit`, `axiom`, `unsafe`, or `sorryAx`. It includes the triple-system
representation, isolated-point reduction, embeddings and isomorphisms, Levi
graphs, private-vertex expansions, binary disjoint unions, one-point
amalgamations, bridge deletion, cycle parity, and the first bridge-block
contraction and quotient-edge lemmas.  Contracted cycles lift to Levi cycles
with doubled Levi length, so the even-Berge-cycle condition makes each
contracted block two-colourable.  The project also proves that the canonical
summands embed in a disjoint union and that disjoint unions preserve linearity.

This is not yet a machine-checked proof of the classification theorem. The
preservation of all intrinsic conditions by the two operations, the
quotient-forest theorem, running-intersection argument, and final reconstruction
induction remain open formalization layers. Their dependency order is recorded
in `FORMALIZATION_MAP.md`.

## Build

```bash
lake build
```

## Verification policy

- `lake build` must succeed.
- No `sorry`, `admit`, `axiom`, `unsafe`, or `sorryAx` is accepted in a
  completed milestone.
- Generated proofs are compiled locally and their axioms are audited.
- Aristotle receives only this sanitized project directory, not manuscript
  metadata or personal information.
- Each remote task and its disposition is recorded in `ARISTOTLE_LOG.md`.
