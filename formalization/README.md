# Erdős Problem 593: Lean Formalization

This Lean 4/mathlib project formalizes the finite structural kernel of the
classification of obligatory triple systems.

The completed structural endpoint is equivalence between constructibility of
an isolated-point reduction and these intrinsic conditions:

1. linearity;
2. a bridge incident with every hyperedge-node;
3. even length of every Berge cycle.

In Lean this endpoint is
`Constructible F.isolatedReduction ↔ F.isolatedReduction.Intrinsic`. It does
not yet assert `Constructible F ↔ F.Intrinsic` for arbitrary `F`, nor a full
obligatoriness classification. The all-parameter balanced complete-bipartite
expansion atom is now obligatory, yielding obligatoriness of every
constructible triple system and the finite intrinsic-isolated-reduction
corollary. The sequence-lift layer also has its local linear-trace rigidity
package: extension-letter determinacy, apex-to-edge-letter collision, and
lifted-edge uniqueness up to base-edge orientation. The finite-trace theorem
beyond that step, isolated-vertex
reconstruction bridge, and remaining avoidance arguments form the next
milestone.

## Current status

The imported source closure contains no `sorry`, `admit`, project `axiom`,
`unsafe`, or `sorryAx`; the relevant focused builds pass under Lean/mathlib
`v4.32.0`. It includes the triple-system
representation, isolated-point reduction, embeddings and isomorphisms, Levi
graphs, private-vertex expansions, binary disjoint unions, one-point
amalgamations, bridge deletion, cycle parity, and the complete bridge-block
reconstruction. All generators and operations preserve the intrinsic
conditions. Active and degree-zero bridge-free components are exact
constructible edge restrictions; the quotient forest and rooted-depth ordering
give the literal running-intersection assembly. The checked finite headline is
`Constructible F.isolatedReduction ↔ F.isolatedReduction.Intrinsic`.

The project also contains the exact chromatic-cardinal characterization,
finite-deletion lemma, obligatory disjoint-union closure, isolated-vertex
reduction for obligatoriness, the finite reduction from arbitrary bipartite
expansions to the `Kₙ,ₙ⁺` atoms, the reusable conditional API
`Constructible.isObligatory_of_completeBipartiteNN`, its discharged
all-parameter premise `completeBipartiteExpansionAtom_isObligatory`, the
unconditional theorem `Constructible.isObligatory`, and the finite
intrinsic-isolated-reduction obligatoriness corollary. It also includes a
finite union-bound rainbow-bipartite lemma, rooted abundance and obligatory
one-point-amalgamation closure, a non-induced graph-factor interface, exact
complete-bipartite edge coordinates, and a one-apex sequence lift with a
formal proof that it has no proper countable colouring and a local
linear-trace rigidity package. The `SequenceLiftBaseNode` module supplies the
canonical grouping index needed for the next trace step: `BasedAt q e` means
that `q` contains two distinct points of `e`, `basedAt_unique` proves that
such a node is unique, `baseNode e` selects it classically, and
`baseNode_mkEdge` identifies the selector on every displayed lift edge. The
following `SequenceLiftBaseNormalForm` module normalizes every arbitrary edge
at that selector, identifies its exact two-point graph-base fibre, and shows
that every other fibre is singleton-or-empty. `SequenceLiftBaseLetter` then
selects the unique unordered graph-edge letter at that base and proves that the
canonical `(baseNode, baseLetter)` trace key is injective on every linear edge
restriction. On every specified linear restriction its key image preserves
`encard`; it is finite exactly when the restriction is finite and then has the
same `Set.ncard`, so a finite linear no-isolated embedded source has exactly
one key per edge. `SequenceLiftBaseFiber` further restricts this statement to
one selected canonical base node: its base letter is injective within that
fibre, the fibre's `encard` is preserved, and an embedded source fibre is
identified with its precise source-edge index subtype.
`SequenceLiftBaseFiberIndex` turns that range-level identification into a
cardinality interface: the fibre and, under linearity, its base-letter image
have the full `ENat.card` of exactly that source-edge subtype, with matching
`Nat.card` statements; for a finite source, the explicitly chosen finite
subtype cardinal gives the same count. `SequenceLiftBaseFiberPartition` then
records the separate set-theoretic fact that the base fibres are pairwise
disjoint and recover a selected family over its active base support, which is
finite whenever the selected family is finite. It gives no cardinality sum or
finite-trace decomposition. `SequenceLiftBaseApex` adds the complementary
local geometry: every lifted edge has one unique point away from its canonical
base, and under linearity this apex is private and injective inside a fixed
base fibre. It remains factor-local and makes no global cardinality or
trace-decomposition claim. `SequenceLiftBaseFiberSupportIndex` reindexes the
partition by the active-base subtype and, for finite embedded sources, gives a
source-edge surjection and cardinal bound for that index. It still proves no
fibre-cardinality sum or global trace decomposition. `SequenceLiftBaseFiberCardinality`
now proves the exact finite selected-edge fibre sum and the corresponding
source-index sigma/cardinality identities. It deliberately does not sum global
base-letter images or traces. `SequenceLiftBaseFiberTraceSum` expresses that
same finite sum using the distinct base-letter image within each separate
active fibre, and therefore also counts the trace-key image. It neither
identifies base letters across fibres nor supplies a global base-letter union
or trace decomposition. `SequenceLiftBaseFiberEquiv` packages the same
within-fibre injectivity as an explicit equivalence with that fibre's own
base-letter image; it still neither joins different fibres nor supplies a
global trace equivalence. `SequenceLiftTaggedBaseLetterEquiv` combines the
selected-edge/base-fibre sigma equivalence with these local maps, retaining
the active base-node tag and therefore never identifying letters from
different fibres. `SequenceLiftTaggedBaseLetterSourceEquiv` composes that
tagged selected-edge equivalence with an embedded source's edge-index/image
equivalence, so source-edge indices are identified with the same tagged local
base-letter sigma under a linear image. It introduces no global untagged
base-letter union or trace decomposition. The project is not yet a
complete machine-checked
proof of Erdős Problem 593: the full
finite-trace theorem, isolated-vertex reconstruction bridge, and the remaining
infinitary avoidance direction are open. Their dependency order is recorded in
`FORMALIZATION_MAP.md`.

## Build

```bash
lake build
```

## Continuous integration

GitHub Actions runs strict source checks and targeted builds for the current
public obligatory endpoints, sequence-trace rigidity lemmas, and the
`SequenceLiftBaseNode` / `SequenceLiftBaseNormalForm` /
`SequenceLiftBaseLetter` / `SequenceLiftFiniteTrace` /
`SequenceLiftBaseFiber` / `SequenceLiftBaseFiberIndex` /
`SequenceLiftBaseFiberPartition` / `SequenceLiftBaseApex` /
`SequenceLiftBaseFiberSupportIndex` / `SequenceLiftBaseFiberCardinality` /
`SequenceLiftBaseFiberTraceSum` / `SequenceLiftBaseFiberEquiv` /
`SequenceLiftTaggedBaseLetterEquiv` /
`SequenceLiftTaggedBaseLetterSourceEquiv`
canonical trace-key and fibre modules on
every pull request and
push to `main`. The workflow deliberately
avoids the aggregate default target;
the focused checks are recorded in
[`SELF_CONTAINED_BUILD.md`](SELF_CONTAINED_BUILD.md).

## One-file checkpoint

[`Erdos593SelfContained.lean`](Erdos593SelfContained.lean) is generated from
the exact transitive closure of the local modules imported by `Erdos593.lean`.
It contains 14,453 physical lines, 96 source modules, and 44 external Mathlib
imports. It is a portable checkpoint of the exact source closure and does not
enlarge the verified mathematical scope described above. Exact generated byte
and checksum metrics are recorded in
[`SELF_CONTAINED_BUILD.md`](SELF_CONTAINED_BUILD.md).

Regenerate or byte-check it with:

```bash
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
```

The generation format, source provenance, and separate axiom-audit procedure
are documented in [`SELF_CONTAINED_BUILD.md`](SELF_CONTAINED_BUILD.md).

## Verification policy

- The source module appropriate to a change must build under the pinned
  Lean/mathlib toolchain; the generated aggregate is checked separately in a
  sufficiently provisioned pinned environment.
- No `sorry`, `admit`, `axiom`, `unsafe`, or `sorryAx` is accepted in a
  completed milestone.
- Generated source is deterministically byte-checked and its axioms are
  audited separately.
- Aristotle is used through the CLI first on a complete, fixed theorem or lemma
  statement. An obligation is decomposed only after a concrete failure or an
  adversarial audit shows that the proposed statement is unsound; independent
  obligations may run in parallel.
- Aristotle receives only a minimal sanitized project directory, not manuscript
  metadata or personal information. A returned proof is accepted only after it
  builds in the canonical pinned Lean/mathlib project and passes the source-gap,
  secret, and axiom audits.
- Each remote task and its disposition is recorded in `ARISTOTLE_LOG.md`.

## Citation and license

The original repository material is licensed under
[CC BY 4.0](../LICENSE). When the license requires attribution, credit
**Samuil Petkov** and follow the repository-level
[scope and attribution notice](../LICENSE_SCOPE.md). Scholarly citation
metadata are provided in [`CITATION.cff`](../CITATION.cff).
