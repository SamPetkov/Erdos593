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
and the finite reduction of bipartite expansions to `Kₙ,ₙ⁺`. It further
contains the finite rainbow-bipartite lemma, rooted abundance and obligatory
one-point-amalgamation closure, and the one-apex sequence lift with its
countable-colouring obstruction. Still missing are the complete-bipartite
expansion atom, the finite-trace structural theorem, and the remaining
infinitary positive and avoidance layers.

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

- Deterministic regeneration check: passed for 48 source modules, 34 external
  Mathlib imports, 8,607 physical lines, 7,622 nonblank lines, 346,099 UTF-8
  bytes, and SHA-256
  `b7f4fb19b49ad0964dff99f517057476200abf721fa01c6b3acfcea31cb4e0d7`.
- Canonical focused builds: `Erdos593.Graph.RainbowBipartite`,
  `Erdos593.TripleSystem.ObligatoryOnePointAmalgamation`, and
  `Erdos593.TripleSystem.SequenceLiftChromatic` all passed under the pinned
  Lean/mathlib `v4.32.0` toolchain. The one-point-amalgamation module passed
  all 1,116 focused Lake jobs after its audited Aristotle proof transplant.
- Source audit: all 48 modules in the imported closure and the generated
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
#print axioms Erdos593.RainbowBipartite.exists_rainbow_bipartite_submatrix
#print axioms Erdos593.TripleSystem.IsObligatory.rootedAbundance
#print axioms Erdos593.TripleSystem.IsObligatory.onePointAmalgamation
#print axioms Erdos593.SequenceLift.not_isProperColoring_nat
#print axioms Erdos593.SequenceLift.aleph0_lt_chromaticCardinal
```

In addition to this declaration-level check, scan every source in the local
closure for proof placeholders such as `sorry`, `admit`, `axiom`, `unsafe`, and
`sorryAx`. Standard Mathlib foundations such as propositional extensionality,
classical choice, and quotient soundness are not project-specific axioms.
