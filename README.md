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
  subtype. Its index layer turns that identification into exact extended
  fibre and base-letter-image cardinality statements for the selected subtype,
  with a finite-source cardinal corollary. A support layer additionally shows
  that canonical base fibres are pairwise disjoint and recover any selected
  edge family when indexed by its active base nodes; finite selected families
  have finite active support. A complementary apex layer gives every lifted
  edge a unique point away from its canonical base and shows that, within a
  linear canonical-base fibre, this apex is private to its own edge and hence
  apex-injective. A finite-support index reindexes the partition over the
  subtype of active base nodes; a source-edge map is surjective onto this
  index, yielding its finite-cardinality bound. The finite fibre-cardinality
  layer proves the exact selected-edge sum, while the local-letter-sum layer
  rewrites it as a sum of distinct base-letter images in separate fibres and,
  for a finite linear no-isolated embedded source, as the trace-key image
  cardinality. Separately, the local factor spine identifies a chosen linear
  base fibre exactly with the private-vertex expansion of its canonical
  base-letter subgraph; for a finite selected family it packages that
  subgraph's finite carrier and canonical non-induced factor into the host.
  It deliberately retains multiplicity across base fibres and proves no
  global base-letter union or finite-trace decomposition; it makes no
  cross-fibre, bipartite, constructibility, or atom claim. A dependency map
  records the scope. At the selected-family level, the finite linear case is
  now packaged as a finite active-base-fibre partition with that local
  factor/isomorphism data at each index; it does not glue those factors or
  identify the selected system with a disjoint union.
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

The exact imported Lean closure currently contains 109 source modules. The
generated one-file checkpoint contains 15,512 physical lines, 44 external
Mathlib imports, and 474 `theorem`/`lemma` declarations; its additional lines
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
fibres. The support API proves only that these fibres form a disjoint
set-theoretic partition over their active base nodes, with finite active
support for a finite selected family. The complementary apex API identifies
the unique non-base point of every lift edge; inside a linear canonical base
fibre, it is private to that edge and yields an apex-injective map. These
factor-local interfaces are now reindexed by the finite subtype of active base
nodes, with a source-edge surjection and cardinal bound. They do not yet
supply a fibre-cardinality sum or a global finite-trace decomposition. The
finite `SequenceLiftBaseFiberCardinality` layer now supplies that exact
selected-edge fibre sum and the matching source-index sigma/cardinality
identities, but it does not sum global base-letter images or traces.
`SequenceLiftBaseFiberTraceSum` now expresses the same sum through the
separate local base-letter images and the trace-key image, without identifying
base letters across distinct fibres or asserting a global trace decomposition.
`SequenceLiftBaseFiberEquiv` packages the within-fibre correspondence as an
explicit equivalence with that fibre's own base-letter image; it neither joins
images from distinct fibres nor produces a global trace equivalence.
`SequenceLiftTaggedBaseLetterEquiv` then identifies the selected edges with
the sigma of those separate fibre images while retaining the active base-node
tag.  It does not form an untagged global base-letter image or a trace
decomposition.
`SequenceLiftTaggedBaseLetterSourceEquiv` carries that same tagged
identification back to the original source-edge type for an embedding with a
linear selected image; it likewise makes no untagged union, cross-fibre
identification, finite-cardinality, or trace claim.
`SequenceLiftBaseApexEquiv` separately identifies one linear canonical base
fibre with its own canonical-apex image; it makes no cross-fibre
identification, global union, cardinality, or trace claim.
`SequenceLiftTaggedBaseApexEquiv` composes the tagged selected-edge/base-fibre
equivalence with those local apex-image maps, retaining the active base-node
tag; it makes no untagged apex union, cross-fibre identification,
cardinality, trace, or atom claim.
`SequenceLiftTaggedBaseApexSourceEquiv` transports that same tagged
apex-image equivalence through an embedding back to the source-edge type
under a linear image; it likewise asserts no untagged union, cross-fibre
identification, cardinality, trace, or atom claim.
`SequenceLiftBaseFiberExpansion` then proves the exact local
private-vertex-expansion isomorphism for a linear base fibre and supplies the
finite carrier/factor packaging. It does not compare separate fibres or prove
a global trace decomposition, bipartiteness, constructibility, or an atom
classification.
`SequenceLiftBaseFiberGlobalSpine` packages the finite active-base-index
partition of a finite linear selected family and N1's local package at every
index. It does not glue graph factors or private-vertex expansions, identify
the selected system with a disjoint union, or assert a global trace, bipartite,
constructibility, or atom result.
`SequenceLiftBaseFiberConstructible` gives the exact conditional local bridge:
a finite linear base fibre is constructible when its canonical base-letter
subgraph is two-colourable; the canonical non-induced factor also pulls any
two-colouring of the ambient host graph back to that subgraph.
`SequenceLiftBaseFiberObligatory` then applies the completed classical
constructible-to-obligatory theorem to the same fibre, including this ambient
two-colourability corollary. The two-colourability premise is explicit and
essential; these local results do not make a global sequence-lift
constructibility or atom claim.
`SequenceLiftBaseFiberAssembly` supplies the next conditional global bridge:
an explicitly ordered finite family of base fibres assembles to a
constructible, hence obligatory, exact restriction when it covers the selected
edge set and every new fibre is edge-disjoint from the accumulated tail and
has either disjoint or singleton-intersecting total vertex support. This
running-intersection hypothesis is retained explicitly; the current fibre
partition API does not prove it.
`SequenceLiftBaseFiberSupport` proves the sharp pairwise consequence of
linearity: distinct canonical base fibres have singleton-or-empty supported
point intersection. The canonical finite active-base enumeration inherits that
pairwise property. This still does not yield the stronger accumulated
running-intersection condition or a global assembly order.
`SequenceLiftBaseFiberSupportRunningOrder` makes one sufficient extra condition
fully explicit: a noduplicated list is recursively coherent when all of a new
fibre's nonempty pairwise support intersections with its assembled tail agree.
Together with linearity, that condition yields the literal N5 running-assembly
geometry. It permits several fibres to share one common apex, but it is not
derived from finite linearity or from the canonical enumeration alone.
The coherent-order endpoint module feeds that same explicit premise into the
exact-cover, base-node-cover, and canonical-active-list constructible and
obligatory theorems; it does not make the premise automatic.
An even stronger tail-degree condition -- each new fibre has at most one
overlapping tail neighbour -- now implies coherence directly.  It is likewise
an explicit ordering hypothesis, not a consequence of linearity alone.
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
