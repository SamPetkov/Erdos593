# Self-Contained Lean Checkpoint

`Erdos593SelfContained.lean` is generated from the exact transitive closure of
the local modules imported by `Erdos593.lean`. It has no project-local imports:
the local source bodies appear in dependency order, while the external Mathlib
imports remain at the top. Every source boundary records a repository-relative
path and the SHA-256 of the normalized UTF-8 source.

The generated file is the current verified **partial formalization**, not a
full formal proof of Erdős Problem 593. It covers the finite incidence and
Levi-graph interfaces, bridge-block contraction and cycle lifting, the exact
bridge-component quotient forest and closed-star/rooted-depth graph kernels,
active-component private-point expansion data, complete disjoint-union
preservation, and one-point-amalgamation infrastructure. Still missing are the
even-cycle theorem
for bipartite expansion generators, preservation under one-point amalgamation,
packaging and final reconstruction, and the obligatoriness, infinite, and
avoidance parts of the manuscript.

## Reproduction and exactness check

From the `formalization` directory:

```text
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
lake env lean Erdos593SelfContained.lean
```

The first command is the only supported way to update the generated file. The
second command exits unsuccessfully if the checked-in artifact differs by even
one byte from deterministic regeneration. The third checks the combined source
against the Lean and Mathlib versions pinned by `lean-toolchain` and
`lake-manifest.json`.

## Recorded verification (15 July 2026)

- Deterministic regeneration check: passed for 22 source modules, five external
  Mathlib imports, 2,898 physical lines, 2,495 nonblank lines, 110,716 UTF-8
  bytes, and SHA-256
  `72a9a3d84e1955b5164a84460a23493a2d407e08d382c6501cc16ce88025bb90`.
- Canonical modular build: `lake build Erdos593` passed all 1,223 jobs under
  the pinned Lean/mathlib `v4.32.0` toolchain in 58.539 seconds.
- One-file build: `lake env lean Erdos593SelfContained.lean` passed with one
  Lean thread in 21.006 seconds and emitted no diagnostics.
- Source audit: all 23 Lean files (the 22 modular files and the generated
  artifact) are clear of `sorry`, `admit`, project `axiom`, `unsafe`, and
  `sorryAx`; the repository secret scan is also clear.
- Axiom audit: every new or touched public declaration, together with the
  representative central declarations below, reports only `propext`,
  `Classical.choice`, and `Quot.sound`.

## Separate axiom audit

No `#print axioms` commands are embedded in the generated artifact. This keeps
packaging separate from audit output and avoids changing the compiled program
merely to select a reporting set. After compiling the generated file, create a
temporary Lean file that imports `Erdos593` and run `#print axioms` for the
central declarations, for example:

```lean
import Erdos593

#print axioms Erdos593.SimpleGraph.two_colorable_iff_every_cycle_even
#print axioms Erdos593.TripleSystem.privateVertexExpansion_linear
#print axioms Erdos593.TripleSystem.OnePointAmalgamation.amalgam
#print axioms Erdos593.TripleSystem.OnePointAmalgamation.isoOfMaps
#print axioms Erdos593.TripleSystem.BridgeBlock.contractedGraph_colorable_two
#print axioms Erdos593.SimpleGraph.bridgeQuotient_isAcyclic
#print axioms Erdos593.TripleSystem.BridgeBlock.activeComponent_privateVertexExpansionData
#print axioms Erdos593.TripleSystem.disjointUnion_intrinsic
#print axioms Erdos593.SimpleGraph.closedStar_earlier_direction
```

In addition to this declaration-level check, scan every source in the local
closure for proof placeholders such as `sorry`, `admit`, `axiom`, `unsafe`, and
`sorryAx`. Standard Mathlib foundations such as propositional extensionality,
classical choice, and quotient soundness are not project-specific axioms.
