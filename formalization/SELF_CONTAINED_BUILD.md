# Self-Contained Lean Checkpoint

`Erdos593SelfContained.lean` is generated from the exact transitive closure of
the local modules imported by `Erdos593.lean`. It has no project-local imports:
the local source bodies appear in dependency order, while the external Mathlib
imports remain at the top. Every source boundary records a repository-relative
path and the SHA-256 of the normalized UTF-8 source.

The generated file is the current verified **partial formalization**, not yet a
full formal proof of Erdős Problem 593. It contains the complete finite
structural classification: generator and operation preservation, exact active
and degree-zero bridge blocks, the rooted quotient-forest running intersection,
the reverse reconstruction, and
`Constructible F.isolatedReduction ↔ F.isolatedReduction.Intrinsic`. It also
contains the chromatic-cardinal interface, finite-deletion and obligatory
disjoint-union closure, the exact isolated-vertex reduction for obligatoriness,
and the finite reduction of bipartite expansions to `Kₙ,ₙ⁺`. Still missing
are the complete-bipartite expansion atom, rooted-abundance/obligatory
one-point-amalgamation theorem, and the remaining infinitary positive and
avoidance layers.

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

- Deterministic regeneration check: passed for 40 source modules, 14 external
  Mathlib imports, 6,737 physical lines, 5,952 nonblank lines, 267,188 UTF-8
  bytes, and SHA-256
  `cbef23c0dafbd18aac36f627ffd72926050bf5eeb09d5285307d1eb81684a15b`.
- Canonical modular build: `lake build Erdos593` passed all 1,244 jobs under
  the pinned Lean/mathlib `v4.32.0` toolchain and emitted no diagnostics.
- One-file build: `lake env lean Erdos593SelfContained.lean` passed and emitted
  no diagnostics.
- Source audit: all 40 modules in the imported closure and the generated
  artifact are clear of `sorry`, `admit`, project `axiom`, `unsafe`, and
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
#print axioms Erdos593.TripleSystem.OnePointAmalgamation.amalgam_intrinsic
#print axioms Erdos593.TripleSystem.Constructible.intrinsic
#print axioms Erdos593.TripleSystem.BridgeBlock.isolatedReduction_constructible_iff_intrinsic
#print axioms Erdos593.TripleSystem.IsObligatory.disjointUnion
#print axioms Erdos593.TripleSystem.isObligatory_iff_isolatedReduction
```

In addition to this declaration-level check, scan every source in the local
closure for proof placeholders such as `sorry`, `admit`, `axiom`, `unsafe`, and
`sorryAx`. Standard Mathlib foundations such as propositional extensionality,
classical choice, and quotient soundness are not project-specific axioms.
