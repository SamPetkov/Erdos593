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

## Relationship to Eric Li's proof

Eric Li's preprint arXiv:2606.24882, posted on 23 June 2026, contains the first
publicly posted complete proof of the classification and introduces the
complete-rank one-apex lift and exact bridge-trace framework. The Lean project
makes no priority or independent-discovery claim for those ingredients.

The code formalises the implementation developed in this repository: the
selected-incidence and bridge-block structure, explicit base-fibre and
support-incidence trace decomposition, positive closure theory, and three
avoidance cases. It is not a line-by-line encoding of Li's manuscript. See
`PROVENANCE.md` for the detailed attribution boundary.

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
this repository; it does not establish historical priority or informational
independence.
