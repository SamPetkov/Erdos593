# Self-Contained Lean Build and Verification

## Status

`Erdos593SelfContained.lean` is the deterministic, self-contained source
closure of the Lean formalization of Erdős Problem 593.  The development is no
longer a partial checkpoint: all proof obligations needed for the finite
classification theorem are closed, and the two final classification endpoints
are part of the public `Erdos593` API.

For every finite triple system `F`, Lean proves

```lean
Erdos593.TripleSystem.isObligatory_iff_isolatedReduction_intrinsic
  (F : TripleSystem V E) :
  F.IsObligatory ↔ F.isolatedReduction.Intrinsic

Erdos593.TripleSystem.isObligatory_iff_constructible_isolatedReduction
  (F : TripleSystem V E) :
  F.IsObligatory ↔ Constructible F.isolatedReduction
```

Thus the formalization checks both the intrinsic and constructive forms of the
classification, including the exact treatment of isolated vertices.  Here
“finite” refers to the triple system being classified; the host triple systems
quantified over by `IsObligatory` remain unrestricted.

## What is proved

The imported closure contains the complete positive and negative directions.
In particular, it formalizes:

- the probabilistic rainbow lemma and the obligatory private-vertex expansion
  atoms;
- closure of obligatoriness under finite disjoint unions and one-point
  amalgamation, including the rooted-abundance argument;
- the Levi-graph bridge-block decomposition, the quotient forest and
  running-intersection assembly, and the equivalence between the intrinsic and
  constructive descriptions;
- the exact isolated-reduction equivalence for obligatoriness;
- the Erdős--Rado linear host excluding every finite nonlinear triple system;
- the one-apex sequence lift, including its uncountable chromatic obstruction;
- the finite linear-trace theorem: canonical base fibres are expansion pieces,
  their overlap incidence graph is acyclic, and the pieces assemble along cut
  points;
- the missing-bridge avoidance theorem derived from the finite trace
  decomposition;
- the shift-graph host with uncountable chromatic number and the required
  odd-girth bound, together with the localization and parity transfer for
  Berge cycles; and
- the final assembly of these three avoidance cases into the two classification
  theorems displayed above.

The finite-trace layer is global, not merely fibre-local.  The completed
support-incidence and forest-order modules provide the running-intersection
order, the `FiniteLiftGenerated` decomposition and its constructibility and
obligatoriness consequences.  The earlier local base-node, base-letter, apex,
cardinality and factor interfaces are retained as the lemmas from which this
global theorem is built; they should not be read as remaining gaps.

## Meaning of “self-contained”

The generated file has no project-local imports.  It consists of the exact
transitive closure of the local modules imported by `Erdos593.lean`, placed in
dependency order, with the external Mathlib imports retained at the top.  Each
source boundary records the repository-relative source path and a SHA-256 hash
of the normalized UTF-8 source.

“Self-contained” therefore means self-contained relative to the pinned Lean
and Mathlib environment.  It does not mean that Mathlib has been copied into
the repository or that foundational principles supplied by Mathlib have been
reproved.

## Reproduction

From the `formalization` directory, run

```text
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
lake env lean Erdos593.lean
lake env lean Erdos593SelfContained.lean
```

The first command is the only supported way to regenerate the combined file.
The `--check` command fails if the checked-in artifact differs by even one byte
from deterministic regeneration.  The two Lean commands check, respectively,
the ordinary module entry point and the generated source closure against the
versions pinned by `lean-toolchain` and `lake-manifest.json`.

The current toolchain is Lean `v4.32.0`.  GitHub Actions performs the aggregate
self-contained build together with focused module checks and treats build
warnings as errors.

## Source and axiom audits

The local source closure and generated artifact are audited for `sorry`,
`admit`, project-defined `axiom`, `unsafe` declarations and `sorryAx`.  The
completed development contains none of these proof placeholders or
project-specific axioms.

A compact audit of the final public endpoints can be run with a temporary file:

```lean
import Erdos593

#print axioms Erdos593.TripleSystem.isObligatory_iff_isolatedReduction_intrinsic
#print axioms Erdos593.TripleSystem.isObligatory_iff_constructible_isolatedReduction
#print axioms Erdos593.TripleSystem.BridgeBlock.isolatedReduction_constructible_iff_intrinsic
#print axioms Erdos593.TripleSystem.Constructible.isObligatory
#print axioms Erdos593.TripleSystem.not_isObligatory_of_not_linear
#print axioms Erdos593.TripleSystem.not_isObligatory_of_linear_of_not_isolatedReduction_bridgeAtEveryEdge
#print axioms Erdos593.SequenceLift.not_isObligatory_of_linear_of_not_isolatedReduction_evenBergeCycles_shiftHost
```

The audited declarations report only the standard foundations used through
Mathlib, namely propositional extensionality, classical choice and quotient
soundness (`propext`, `Classical.choice` and `Quot.sound`).

## Recorded verification

As of 20 July 2026:

- deterministic regeneration of `Erdos593SelfContained.lean` passes;
- the ordinary `Erdos593.lean` entry point and the self-contained artifact both
  compile under the pinned toolchain;
- the focused checks for the positive atoms, bridge-block decomposition,
  Erdős--Rado host, sequence-lift trace decomposition, missing-bridge host,
  shift-graph odd-cycle host and final classification pass;
- the source-placeholder and repository secret scans are clear; and
- the final intrinsic and constructive classification theorems are included in
  the generated closure and in the public module entry point.

The authoritative status is therefore **complete machine-checked finite
classification**, rather than “partial formalization”, “checkpoint”, or a list
of unresolved local interfaces.
