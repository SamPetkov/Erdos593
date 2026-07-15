# Self-contained Lean checkpoint

`Erdos593SelfContained.lean` is generated from the exact transitive closure of
the local modules imported by `Erdos593.lean`. It has no project-local imports:
the local source bodies appear in dependency order, while the external Mathlib
imports remain at the top. Every source boundary records a repository-relative
path and the SHA-256 of the normalized UTF-8 source.

The generated file is the current verified **partial formalization**, not a
full formal proof of Erdős Problem 593. It covers the finite structural kernel,
including the incidence and Levi-graph interfaces, bridge-block/cycle-lifting
results, forward construction lemmas, and one-point amalgamation machinery.
Still missing are preservation under all classification operations; the
quotient-forest, running-intersection, and reconstruction layers; and the
obligatoriness, infinite, and avoidance parts of the manuscript.

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

- Deterministic regeneration check: passed for 20 source modules, four external
  Mathlib imports, 2,223 physical lines, and SHA-256
  `06bbdb9bbcbe8cbcb198e5a3899eb20b20bb6dd6441515839241d3f9d33274be`.
- Canonical modular build: `lake build` passed all 1,221 jobs under the pinned
  Lean/mathlib `v4.32.0` toolchain in 128.066 seconds.
- One-file build: `lake env lean Erdos593SelfContained.lean` passed with one
  Lean thread in 19.298 seconds and emitted no diagnostics.
- Source audit: all 21 Lean files (the 20 modular files and the generated
  artifact) are clear of `sorry`, `admit`, project `axiom`, `unsafe`, and
  `sorryAx`; the repository secret scan is also clear.
- Representative axiom audit: seven central declarations report only
  `propext`, `Classical.choice`, and `Quot.sound`.

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
```

In addition to this declaration-level check, scan every source in the local
closure for proof placeholders such as `sorry`, `admit`, `axiom`, `unsafe`, and
`sorryAx`. Standard Mathlib foundations such as propositional extensionality,
classical choice, and quotient soundness are not project-specific axioms.
