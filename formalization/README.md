# Erdős Problem 593: complete Lean formalisation

This Lean 4/mathlib project machine-checks the complete finite classification
of obligatory triple systems in the alternative proof implementation contained
in this repository.

For every finite triple system `F`, the final public endpoints are

```lean
Erdos593.TripleSystem.isObligatory_iff_isolatedReduction_intrinsic
Erdos593.TripleSystem.isObligatory_iff_constructible_isolatedReduction
```

They state, respectively,

```lean
F.IsObligatory ↔ F.isolatedReduction.Intrinsic
F.IsObligatory ↔ Constructible F.isolatedReduction
```

## Mathematical source and public chronology

Li's 23 June 2026 v1 is the first publicly posted complete mathematical proof
of the classification and is cited for the one-apex lift and bridge-trace
framework. This repository records its Lean scaffold and complete finite
structural classification on 15 July 2026, before the separate repository
accompanying Li's broader v2 formalisation. The two projects use different
representations and theorem interfaces. See `PROVENANCE.md` for commit links and
the precise attribution boundary.

The written manuscript invokes the classical Erdős--Hajnal high-odd-girth
theorem directly. The Lean development retains an explicit shift-graph
realisation of the required high-odd-girth host so that this input is checked
inside the project rather than introduced as a project axiom.

## Verified scope

The imported closure includes:

- exact isolated-vertex reduction;
- obligatory complete-bipartite private-vertex-expansion atoms;
- closure under finite disjoint unions and one-point amalgamation;
- bridge-block decomposition, quotient forest, and running intersection;
- the Erdős--Rado linear host excluding nonlinear systems;
- the one-apex sequence lift and its uncountable chromatic obstruction;
- the global finite-linear trace decomposition into expansion fibres joined at
  cut points;
- the missing-bridge obstruction;
- the high-odd-girth odd-Berge-cycle obstruction; and
- assembly of the final intrinsic and constructive classification theorems.

There are no remaining theorem-level gaps in the finite classification.

## Build

```bash
lake build
python scripts/generate_self_contained.py --check
lake env lean Erdos593.lean
lake env lean Erdos593SelfContained.lean
```

The project is pinned to Lean/mathlib `v4.32.0`. GitHub Actions treats warnings
as errors, checks deterministic regeneration, runs focused modules, and audits
for proof placeholders and project-specific axioms.

## Trust boundary

The local source closure and generated artifact contain no `sorry`, `admit`,
project-defined `axiom`, `unsafe`, or `sorryAx`. Representative endpoint audits
report only the standard Mathlib foundations `propext`, `Classical.choice`, and
`Quot.sound`. The machine check verifies the formal statements and proofs in
this repository. Historical priority for the public formal artefacts is recorded
by the dated commit history; the kernel check itself does not establish provenance.
