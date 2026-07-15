# Self-Contained Lean Checkpoint

`Erdos593SelfContained.lean` is generated from the exact transitive closure of
the local modules imported by `Erdos593.lean`. It has no project-local imports:
the local source bodies appear in dependency order, while the external Mathlib
imports remain at the top. Every source boundary records a repository-relative
path and the SHA-256 of the normalized UTF-8 source.

The generated file is the current verified **partial formalization**, not yet a
full formal proof of Erdős Problem 593. Its finite structural endpoint is
exactly
`Constructible F.isolatedReduction ↔ F.isolatedReduction.Intrinsic`: generator
and intrinsic-operation preservation, exact active and degree-zero bridge
blocks, the rooted quotient-forest running intersection, and reverse
reconstruction after isolated vertices are removed. It does not yet prove
`Constructible F ↔ F.Intrinsic` for arbitrary `F`, nor a full
obligatoriness classification. It also contains the chromatic-cardinal
interface, finite-deletion and obligatory closure facts, the exact
isolated-vertex reduction for obligatoriness, the all-parameter theorem that
every balanced complete-bipartite expansion atom is obligatory, the resulting
theorem that every constructible triple system is obligatory, the finite
intrinsic-isolated-reduction obligatoriness corollary, exact `Kₙ,ₙ` edge
coordinates, a finite rainbow-bipartite lemma, a non-induced graph-factor
interface, rooted abundance and obligatory one-point-amalgamation closure, and
the one-apex sequence lift with its countable-colouring obstruction and local
linear-trace rigidity package: extension-letter determinacy, apex-to-edge-letter
collision, and lifted-edge uniqueness up to base-edge orientation. It also
contains the canonical base-node interface: `BasedAt q e` records that `q`
carries two distinct points of `e`, `basedAt_unique` proves uniqueness, the
noncomputable `baseNode e` selects the witness, and `baseNode_mkEdge` recovers
the displayed base of every lift edge. The normal-form bridge additionally
normalizes an arbitrary lift edge at that selector, identifies its exact
two-point graph-base fibre, and proves every non-base fibre is
singleton-or-empty. The canonical base-letter bridge now selects the unique
unordered graph-edge letter at that base and packages `(baseNode, baseLetter)`
as a key injective on every linear edge restriction. This is a local
finite-trace interface only: a global finite-trace decomposition is still
missing, alongside reconstruction across isolated vertices and the remaining
infinitary avoidance direction.

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
`lake-manifest.json`; run that aggregate command only in a sufficiently
provisioned pinned environment. Routine release validation uses the focused
module checks recorded below.

## Recorded verification (15 July 2026)

- Deterministic regeneration check: passed for 85 source modules, 43 external
  Mathlib imports, 13,330 physical lines, 11,716 nonblank lines, 541,169 UTF-8
  bytes, and SHA-256
  `b3751f0658b56a423abfa63e3d5587044d4c5b455bbb066d1b6dacd771605e48`.
- Canonical focused checks: strict source checks and targeted builds for
  `Erdos593.TripleSystem.CompleteBipartiteAtomObligatory` (1,512 Lake jobs)
  and `Erdos593.TripleSystem.ConstructiblePositiveObligatory` (1,566 Lake
  jobs), plus `Erdos593.TripleSystem.SequenceLiftTrace` (976 Lake jobs),
  `Erdos593.TripleSystem.SequenceLiftBaseNode` (975 Lake jobs),
  `Erdos593.TripleSystem.SequenceLiftBaseNormalForm` (976 Lake jobs), and
  `Erdos593.TripleSystem.SequenceLiftBaseLetter` (979 Lake jobs), passed under
  the pinned Lean/mathlib `v4.32.0` toolchain.
- Source audit: the complete imported closure, including
  `SequenceLiftBaseNode`, `SequenceLiftBaseNormalForm`, and
  `SequenceLiftBaseLetter`, and the generated artifact are clear of `sorry`,
  `admit`, project `axiom`, `unsafe`, and `sorryAx`; the repository secret scan
  is also clear.
- Axiom audit: the representative central declarations and the new public
  endpoint declarations listed below report only `propext`, `Classical.choice`,
  and `Quot.sound`.

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
#print axioms Erdos593.SimpleGraph.NonInducedFactor.trans
#print axioms Erdos593.CompleteBipartiteEdges.coords_edge
#print axioms Erdos593.TripleSystem.Constructible.isObligatory_of_completeBipartiteNN
#print axioms Erdos593.TripleSystem.completeBipartiteExpansionAtom_positive_isObligatory
#print axioms Erdos593.TripleSystem.completeBipartiteExpansionAtom_isObligatory
#print axioms Erdos593.TripleSystem.Constructible.isObligatory
#print axioms Erdos593.TripleSystem.intrinsic_isolatedReduction_isObligatory
#print axioms Erdos593.SequenceLift.Node.letter_eq_of_extendsBy_same_target
#print axioms Erdos593.SequenceLift.edgeLetter_eq_of_apex_eq
#print axioms Erdos593.SequenceLift.mkEdge_eq_of_same_basePair_of_linearTrace
#print axioms Erdos593.SequenceLift.mkEdge_eq_of_same_edgeLetter_of_linearTrace
#print axioms Erdos593.SequenceLift.basedAt_unique
#print axioms Erdos593.SequenceLift.baseNode_eq_of_mkEdge_eq
#print axioms Erdos593.SequenceLift.baseNode
#print axioms Erdos593.SequenceLift.baseNode_basedAt
#print axioms Erdos593.SequenceLift.baseNode_mkEdge
#print axioms Erdos593.SequenceLift.exists_mkEdge_at_baseNode
#print axioms Erdos593.SequenceLift.eq_baseNode_iff_exists_distinct_incident
#print axioms Erdos593.SequenceLift.point_eq_of_inc_of_ne_baseNode
#print axioms Erdos593.SequenceLift.exists_basePair_at_baseNode
#print axioms Erdos593.SequenceLift.isBaseLetter_unique
#print axioms Erdos593.SequenceLift.baseLetter_mkEdge
#print axioms Erdos593.SequenceLift.eq_of_traceKey_eq_of_mem_of_linear
#print axioms Erdos593.SequenceLift.traceKey_injOn_of_linear
```

In addition to this declaration-level check, scan every source in the local
closure for proof placeholders such as `sorry`, `admit`, `axiom`, `unsafe`, and
`sorryAx`. Standard Mathlib foundations such as propositional extensionality,
classical choice, and quotient soundness are not project-specific axioms.
