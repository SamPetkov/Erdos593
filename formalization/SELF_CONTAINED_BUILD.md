# Self-Contained Lean Build and Verification

## Authoritative status

`Erdos593SelfContained.lean` is the deterministic one-file source closure of
the complete Lean formalisation of the finite classification in Erdős Problem
593. It is not a partial checkpoint. For every finite triple system `F`, the
public endpoints are

```lean
F.IsObligatory ↔ F.isolatedReduction.Intrinsic
F.IsObligatory ↔ Constructible F.isolatedReduction
```

The host triple systems quantified over by `IsObligatory` remain unrestricted;
only the classified system `F` is finite.

## Relationship to prior work

Eric Li's preprint arXiv:2606.24882, posted on 23 June 2026, contains the first
publicly posted complete proof and introduces the complete-rank one-apex lift
and exact bridge-trace framework. This Lean artifact carries no priority or
independent-discovery claim. It verifies the alternative implementation in this
repository, including its base-fibre/support-incidence organisation; it is not
a line-by-line formalisation of Li's manuscript.

The written paper uses the classical Erdős--Hajnal high-odd-girth theorem as an
external mathematical input. The Lean project instead gives an explicit
shift-graph construction of a host with the required chromatic and odd-girth
properties, thereby avoiding a project axiom for that input.

## What “self-contained” means

The generated file has no project-local imports. It places the exact transitive
closure of the modules imported by `Erdos593.lean` in dependency order and
retains only the external Mathlib imports at the top. Each source boundary
records the repository-relative path and the SHA-256 of the normalized UTF-8
source.

Self-contained is therefore relative to the Lean and Mathlib versions pinned by
`lean-toolchain` and `lake-manifest.json`; Mathlib itself is not copied into the
repository.

## Reproduction

From `formalization/`:

```text
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
lake env lean Erdos593.lean
lake env lean Erdos593SelfContained.lean
```

The generator is the only supported way to update the combined file. The
`--check` command fails on any byte difference from deterministic regeneration.
The two Lean commands check the ordinary module entry point and the generated
source closure under the pinned Lean/mathlib `v4.32.0` toolchain.

## Proof coverage

The closure checks the constructive positive direction, the intrinsic
bridge-block equivalence, isolated reduction, and all three avoidance cases:
nonlinearity, failure of the edge-bridge condition, and odd Berge cycles. Its
sequence-lift layer proves the global finite-linear trace theorem, not merely
fibre-local interfaces: finite traces decompose into private-vertex expansion
pieces whose support-incidence graph is a forest and which assemble by disjoint
unions and one-point amalgamations.

## Source and axiom audits

The source closure and generated artifact are scanned for `sorry`, `admit`,
project-defined `axiom`, `unsafe`, and `sorryAx`; none occurs. Representative
central declarations, including both final classification endpoints, report
only `propext`, `Classical.choice`, and `Quot.sound`.

A compact endpoint audit is:

```lean
import Erdos593

#print axioms Erdos593.TripleSystem.isObligatory_iff_isolatedReduction_intrinsic
#print axioms Erdos593.TripleSystem.isObligatory_iff_constructible_isolatedReduction
#print axioms Erdos593.TripleSystem.BridgeBlock.isolatedReduction_constructible_iff_intrinsic
#print axioms Erdos593.TripleSystem.not_isObligatory_of_not_linear
#print axioms Erdos593.TripleSystem.not_isObligatory_of_linear_of_not_isolatedReduction_bridgeAtEveryEdge
#print axioms Erdos593.SequenceLift.not_isObligatory_of_linear_of_not_isolatedReduction_evenBergeCycles_shiftHost
```

## Recorded build

The checked-in closure contains 171 local source modules, 54 external Mathlib
imports, and 24,641 physical lines. Deterministic regeneration, the aggregate
entry point, the one-file build, focused module checks, the placeholder scan,
and the repository secret scan passed under the pinned toolchain before this
documentation revision.

The authoritative description is **complete machine-checked finite
classification**. “Self-contained” and “machine-checked” describe the formal
artifact; they do not imply independent discovery, historical priority, or
external peer review.
