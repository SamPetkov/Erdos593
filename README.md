# Obligatory Triple Systems: Lean-Checked Finite Kernel for Erdős Problem 593

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

**Obligatory Triple Systems: Lean-Checked Finite Kernel for Erdős Problem 593**

**Author:** Samuil Petkov

**Manuscript date:** 11 July 2026

This repository contains the manuscript source package and a Lean development of
the finite structural kernel.  It does not claim a complete machine-checked
proof of the full obligatoriness/avoidance classification.  The checked
structural endpoint is
`Constructible F.isolatedReduction ↔ F.isolatedReduction.Intrinsic`.  The
development also proves that every balanced complete-bipartite
private-vertex-expansion atom is obligatory, hence that every constructible
triple system is obligatory; for finite `F`, it proves the corollary
`F.isolatedReduction.Intrinsic → F.IsObligatory`.

The typesetting is monochrome and Annals-inspired, using `amsart` with New TX text and mathematics. It is an original presentation and is not the official *Annals of Mathematics* class or submission template.

The author reports developing the proof independently, without consulting Eric Li's contemporaneous preprint, and learning of it afterward. Li also proves the same classification and uses the same one-apex sequence lift in greater cardinal generality, together with related bridge-decomposition ideas. The manuscript now cites those overlaps substantively while using no theorem of Li as a logical premise.

## Files

- `erdos593_obligatory_triple_systems.tex` — principal LaTeX source.
- `references.bib` — bibliography in first-citation order.
- `erdos593_obligatory_triple_systems.pdf` — reproducibly compiled paper.
- `erdos593_obligatory_triple_systems.md` — Markdown source of the manuscript.
- `build.sh` — reproducible LuaLaTeX/Biber build.
- `CITATION.cff` — citation metadata.
- `SOURCE_LEDGER.md` — source and proof-dependency record.
- `REVISION_NOTES.md` — record of the final editorial revision.
- `MANIFEST.txt` and `SHA256SUMS` — package inventory and checksums.
- `formalization/` — gap-free Lean 4 development of the finite structural
  kernel: the isolated-reduction constructive/intrinsic theorem, obligatory
  closure lemmas (including one-point amalgamation), the all-parameter
  balanced complete-bipartite atom theorem and its constructible-to-obligatory
  consequence, exact `K_{n,n}` edge coordinates, a finite rainbow lemma, a
  non-induced graph-factor interface, a one-apex sequence lift with a
  chromatic obstruction, local linear-trace rigidity, canonical base-node
  normal forms, and a canonical trace key: every lift edge is displayed at its
  selected two-point source, its base fibre is exactly one graph pair, every
  other fibre has at most one point, and its `(baseNode, baseLetter)` key is
  injective on every linear edge restriction. On each specified such
  restriction its key image preserves `encard`, is finite exactly when the
  restriction is finite, and has the same `Set.ncard` there; a finite linear
  no-isolated embedded source therefore has exactly one key per edge. A
  further local base-fibre API proves that within any selected canonical-base
  fibre the base letter is injective and has the same `encard` under linearity,
  and identifies an embedded source fibre with its exact source-edge index
  subtype. This is only a local bridge, not a global finite-trace
  decomposition; a dependency map records its place.
  Reconstruction across isolated vertices,
  the remaining finite-trace decomposition, and the infinitary avoidance
  direction remain open.
- `formalization/Erdos593SelfContained.lean` — deterministic one-file copy of
  the current Lean source closure, with no project-local imports.

## Build

A TeX Live installation containing LuaLaTeX, Biber, `amsart`, `newtx`, `biblatex`, `microtype`, and the AMS packages is required.

```bash
./build.sh
```

The build fixes the PDF creation and modification timestamp at 11 July 2026, 12:00 UTC through `SOURCE_DATE_EPOCH`.

The Lean scaffold is built separately:

```bash
cd formalization
lake build
```

## Lean checkpoint size and scope

The exact imported Lean closure currently contains 87 source modules. The
generated one-file checkpoint contains 13,541 physical lines, 43 external
Mathlib imports, and 422 `theorem`/`lemma` declarations; its additional lines
record generation status, module boundaries, and source hashes. See
[`formalization/SELF_CONTAINED_BUILD.md`](formalization/SELF_CONTAINED_BUILD.md)
for exact reproduction and verification instructions.

The finite structural endpoint is complete on isolated-point reductions:
private-vertex expansion generators, disjoint union, one-point amalgamation,
and isomorphism preserve the intrinsic conditions; every intrinsic bridge block
is reconstructed exactly as an active or degree-zero constructible restriction;
and the rooted quotient forest gives the full running-intersection induction.
The checked headline is
`Constructible F.isolatedReduction ↔ F.isolatedReduction.Intrinsic`. This is
not yet a theorem that `Constructible F` and `F.Intrinsic` are equivalent for
arbitrary `F`, nor a full obligatoriness classification.  It does now include
`completeBipartiteExpansionAtom_isObligatory`, `Constructible.isObligatory`,
and the finite corollary `intrinsic_isolatedReduction_isObligatory`.

The development also proves the chromatic-cardinal characterization, finite
vertex-deletion lemma, obligatory disjoint-union closure, exact isolated-vertex
reduction, the finite rainbow-bipartite lemma, rooted abundance and obligatory
one-point-amalgamation closure, the countable-colouring obstruction for the
one-apex sequence lift, its local linear-trace rigidity package, and a
canonical base-node API. For every lift edge, `BasedAt q e` identifies the
unique node containing two distinct edge points; `basedAt_unique` and the
classically selected `baseNode e` make that index canonical, while
`baseNode_mkEdge` recovers the displayed source node of an explicit lift edge.
The normal-form API then gives `exists_mkEdge_at_baseNode`, identifies the
exact graph-endpoint pair in the base fibre, and proves every non-base fibre
is singleton-or-empty. `SequenceLiftBaseLetter` selects the unique unordered
base letter and packages `(baseNode, baseLetter)` as a key injective on each
linear edge restriction. On every specified linear restriction its image
preserves `encard`; it is finite exactly when the restriction is finite and
then has the same `Set.ncard`, so a finite linear no-isolated embedded source
has exactly one key per edge. The base-fibre API additionally gives local
base-letter injectivity and `encard` transfer within a selected canonical base
node, together with an exact source-edge indexing statement for embedded
fibres. This does not yet supply a global finite-trace decomposition.
The balanced complete-bipartite expansion atom is now obligatory for every
natural parameter, which yields obligatoriness of all constructible systems
and the finite intrinsic-isolated-reduction corollary. Reconstruction across
isolated vertices, the remaining finite-trace decomposition, and the
infinitary avoidance direction are still in progress.

## AI-use disclosure

The manuscript was completed with assistance from OpenAI’s ChatGPT-5.6 Pro. It contains a full ethics and AI-assistance statement. Samuil Petkov is the sole named author and accepts responsibility for the mathematical content, citations, and conclusions.

## GitHub repository

The maintained repository is public at
[github.com/SamPetkov/Erdos593](https://github.com/SamPetkov/Erdos593).

For a fresh conservative bootstrap, with GitHub CLI authenticated:

```bash
./create-private-repo.sh
```

The script initially creates a private repository named `Erdos593`, sets
`origin`, and pushes the current branch. It refuses to overwrite an existing
remote repository; changing that new repository to public is a separate,
deliberate action.

## Citation and license

Original repository material is licensed under
[Creative Commons Attribution 4.0 International](LICENSE). When the license
requires attribution, credit **Samuil Petkov**, link to this repository when
reasonably practicable, identify CC BY 4.0, and state whether changes were
made. Scholarly users are also asked to cite the project using
[`CITATION.cff`](CITATION.cff).

See [`LICENSE_SCOPE.md`](LICENSE_SCOPE.md) for a ready-to-use attribution and
the exclusions for third-party literature, source scans, dependencies, and
files carrying their own notices.
