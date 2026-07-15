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

## One-file checkpoint

[`Erdos593SelfContained.lean`](Erdos593SelfContained.lean) is generated from
the exact transitive closure of the local modules imported by `Erdos593.lean`.
It contains 2,223 physical lines, 20 source modules, and only four external
Mathlib imports. It is a portable checkpoint of the current partial
formalization; it does not enlarge the verified mathematical scope described
above.

Regenerate or byte-check it with:

```bash
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
```

The generation format, source provenance, and separate axiom-audit procedure
are documented in [`SELF_CONTAINED_BUILD.md`](SELF_CONTAINED_BUILD.md).

## Verification policy

- `lake build` must succeed.
- No `sorry`, `admit`, `axiom`, `unsafe`, or `sorryAx` is accepted in a
  completed milestone.
- Generated proofs are compiled locally and their axioms are audited.
- Aristotle is used through the CLI as a proxy for bounded, fixed-statement
  theorem or lemma jobs. If a job does not close, its obligation is decomposed
  into smaller lemmas and resubmitted; independent obligations may run in
  parallel.
- Aristotle receives only a minimal sanitized project directory, not manuscript
  metadata or personal information. A returned proof is accepted only after it
  builds in the canonical pinned Lean/mathlib project and passes the source-gap,
  secret, and axiom audits.
- Each remote task and its disposition is recorded in `ARISTOTLE_LOG.md`.

## Citation and license

The original repository material is licensed under
[CC BY 4.0](../LICENSE). When the license requires attribution, credit
**Samuil Petkov** and follow the repository-level
[scope and attribution notice](../LICENSE_SCOPE.md). Scholarly citation
metadata are provided in [`CITATION.cff`](../CITATION.cff).
