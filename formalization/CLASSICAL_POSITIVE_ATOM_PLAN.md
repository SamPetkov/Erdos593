# Classical positive-atom route: execution brief

## Purpose and scope

This is a bounded handoff plan for independently auditing or maintaining the
already formalized classical positive-atom result. It is not a claim of a new
theorem and does not broaden the repository's verified scope.

## Exact target and acceptance criteria

The exact target is:

~~~lean
Erdos593.TripleSystem.completeBipartiteExpansionAtom_positive_isObligatory
  (n : Nat) (hn : 0 < n) :
  (completeBipartiteExpansionAtom.{u} n).IsObligatory
~~~

The declaration is in `Erdos593/TripleSystem/PositiveAtomClassical.lean`.

Accept an audit result or repair only if it:

1. preserves that exact statement;
2. compiles under the pinned Lean/mathlib toolchain;
3. passes the strict source check and focused build below;
4. reports only `propext`, `Classical.choice`, and `Quot.sound` in its axiom
   audit;
5. introduces no `sorry`, `admit`, project `axiom`, `unsafe`,
   `native_decide`, `implemented_by`, resource-limit workaround, or new
   global assumption; and
6. makes no claim about a global trace decomposition, unrestricted
   reconstruction, or a full obligatoriness classification.

## Fixed setting

- `n : Nat` and `hn : 0 < n`.
- The atom is `completeBipartiteExpansionAtom n`.
- The argument is classical: it uses cardinal minimality and a `ULift`
  conversion from a natural-valued proper colouring to `CountableColor`.
- The low-pair closure threshold is exactly `2 * n + n * n`.
- The local theorem is closed. An external audit is corroborating evidence,
  not a missing local proof obligation.

## Current checkpoint (2026-07-18)

The positive-atom theorem, its zero/positive wrapper, and the constructible
positive-obligatory endpoint are locally closed. The N14--N17 sequence-lift
finite-linear and embedded-source endpoint layers are also present as checked
Lean modules. Do not spend new work on re-proving these layers unless a
regression appears in CI.

The active remaining mathematical gap for the global classical route is the
countably-coloured Erdos--Rado pair-partition theorem for
`ErdosRadoCarrier`. Locally, `ErdosRado/EndhomogeneousLift.lean` now exposes
the exact sufficient trace-construction interface:

~~~lean
Erdos593.TripleSystem.TriangleHost.ErdosRado.FullEndhomogeneousTraceForEveryColoring
~~~

and proves that this interface implies:

~~~lean
Erdos593.TripleSystem.TriangleHost.ErdosRado.erdosRadoUncountableHomogeneousPairSet_of_fullEndhomogeneousTrace
~~~

The next proof campaign should therefore target the full-height
endhomogeneous trace construction, not the positive atom or finite
sequence-lift wrappers. Aristotle request O40
`a38acccf-92a5-41c1-ae37-c4cd1e90afed` has been submitted for this exact
N24 endpoint. Any Aristotle patch must still be validated locally under Lean
4.32 before committing.

## Proof dependency graph

~~~text
atom-free uncountably chromatic host H
  -> AtomFreeUncountablyChromaticCard
  -> exists_minimalAtomFreeUncountablyChromaticCard
  -> minimal bad host H0, with aleph0 < chi(H0)
  -> locallyCountablyChromaticBelow_of_minimalBad
  -> H0.LocallyCountablyChromaticBelow
  -> aleph0 < Cardinal.mk W0
  -> exists_lowPairClosureLayering_of_uncountable
       at threshold 2 * n + n * n
  -> FiniteClosureLayering L
  -> exists_natProperColoring_of_atomFree_of_lowPairClosureLayering
  -> c : W0 -> Nat with H0.IsProperColoring c
  -> ULift.up o c : W0 -> CountableColor
  -> chi(H0) <= aleph0
  -> contradiction
~~~

The colouring assembly uses the exact edge partition theorem
`highPairEdge_or_sameRankEdge_or_lowCrossingEdge`. Its three components are
the high-pair, same-rank, and low-crossing colourings.

## Audit checklist

1. Check packaging of an atom-free uncountably chromatic host as
   `AtomFreeUncountablyChromaticCard`.
2. Check the universe-local least-cardinal choice from
   `exists_minimalAtomFreeUncountablyChromaticCard`.
3. Check that minimality supplies `LocallyCountablyChromaticBelow`.
4. Check the carrier inequality
   `Cardinal.aleph0 < Cardinal.mk W0`.
5. Check the exact threshold `2 * n + n * n` and its positive arithmetic.
6. Check that the assembly gives an actual global `Nat` proper colouring.
7. Check the `ULift.up` / `ULift.down` equality conversion in the final
   chromatic-cardinal contradiction.
8. Check the final use of `not_lt_of_ge hcount hunc0`.

If an issue is found, isolate it to the smallest owner module:

| Issue | Owner |
| --- | --- |
| Cardinal minimality or local restriction | `MinimalBadCore.lean` |
| Uncountability or closure layering | `LowCodegreeLayering.lean` |
| Edge partition or colouring assembly | `PositiveAtomColoringAssembly.lean` and direct imports |
| Final universe/coercion conversion | `PositiveAtomClassical.lean` |

Do not turn a repair into a global trace, reconstruction, or classification
project.

## Downstream closed wrappers

The positive theorem feeds the following existing declarations:

1. `completeBipartiteExpansionAtom_zero_isObligatory` handles `n = 0`.
2. `completeBipartiteExpansionAtom_isObligatory (n : Nat)` case-splits on
   `n` in `Erdos593/TripleSystem/CompleteBipartiteAtomObligatory.lean`.
3. `Constructible.isObligatory` discharges the balanced-atom premise in
   `Erdos593/TripleSystem/ConstructiblePositiveObligatory.lean`.
4. `intrinsic_isolatedReduction_isObligatory` combines the finite
   isolated-reduction bridge, the constructible result, and
   `IsObligatory.of_isolatedReduction`.

An agent should audit those exact statements and imports, not re-prove or
weaken them.

## Verification gates

Run from `formalization/`:

~~~text
lake env lean -DwarningAsError=true Erdos593/TripleSystem/PositiveAtomClassical.lean
lake build Erdos593.TripleSystem.PositiveAtomClassical

lake env lean -DwarningAsError=true Erdos593/TripleSystem/CompleteBipartiteAtomObligatory.lean
lake build Erdos593.TripleSystem.CompleteBipartiteAtomObligatory

lake env lean -DwarningAsError=true Erdos593/TripleSystem/ConstructiblePositiveObligatory.lean
lake build Erdos593.TripleSystem.ConstructiblePositiveObligatory
~~~

Then audit the exact public declarations:

~~~lean
import Erdos593.TripleSystem.ConstructiblePositiveObligatory

#print axioms Erdos593.TripleSystem.completeBipartiteExpansionAtom_positive_isObligatory
#print axioms Erdos593.TripleSystem.completeBipartiteExpansionAtom_isObligatory
#print axioms Erdos593.TripleSystem.Constructible.isObligatory
#print axioms Erdos593.TripleSystem.intrinsic_isolatedReduction_isObligatory
~~~

Finally check source integrity and deterministic generation:

~~~text
rg -n --glob '*.lean' "\b(sorry|admit|axiom|unsafe|native_decide|sorryAx)\b" Erdos593 Erdos593SelfContained.lean
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
~~~

A source/import-closure change is integrated only once its focused GitHub
Actions workflow is green.

## Explicit non-goals and staged follow-up

This route does not prove an untagged global finite-trace decomposition,
reconstruction across isolated vertices for
`Constructible F <-> F.Intrinsic`, the remaining infinitary avoidance
direction, or a complete obligatoriness classification.

The next honest sequence-lift package is local fibre geometry, not a
constructibility theorem: prove that one finite linear base fibre is
isomorphic to the private-vertex expansion of an exact finite non-induced
graph factor of `G`.

### Historical candidate (now completed)

**Status update.** The local expansion package below is now compiled in
`SequenceLiftBaseFiberExpansion.lean` as
`baseFiber_privateVertexExpansionIso_of_linear` and
`exists_fintype_baseFiberLetterSubgraphFactorExpansionIso_of_linear`.
The retained sketch records the original target shape only; it is not an open
proof obligation. The next global sequence-lift bridge is instead the explicit
support-tail-overlap coherence theorem in
`SequenceLiftBaseFiberSupportRunningOrder.lean`. It deliberately assumes that
coherence rather than deriving it from linearity.

~~~lean
theorem exists_baseFiberExpansionIso_of_finite_linear
    {S : Set (Edge G)} (hS : S.Finite)
    (hlin : ((system G).edgeRestriction S).Linear)
    (q : Node G) :
    ∃ (X : Type u) (J : _root_.SimpleGraph X),
      Finite X ∧
      ∃ φ : Erdos593.SimpleGraph.NonInducedFactor J G,
        TripleSystem.Isomorphic (TripleSystem.privateVertexExpansion J)
          ((system G).edgeRestriction (baseFiber S q)) := by
  ...
~~~

This is a target specification only. It should be developed in a new
`SequenceLiftBaseFiberExpansion.lean` module after a direct API check.
The proof should define the finite endpoint subtype of
`baseLetter '' baseFiber S q`, use exactly those base-letter edges for `J`,
map cores to `(q, v)`, map private expansion vertices to `baseApex`, and
prove the incidence/bijection facts via the normal-form and apex-local
lemmas. `NonInducedFactor` is essential because `G` can have extra edges
among the selected endpoints.

Expected scope is a medium local formalization task: first establish the
canonical objects and their APIs, then the isomorphism. Its stop condition
is the focused strict check, focused build, axiom audit, and an explicit
review that it did not compare distinct fibres. It must not infer
bipartiteness or constructibility. This paragraph is now historical:
subsequent modules completed the cross-fibre and running-assembly stages.
The current execution handoff is recorded below.

## Next execution section: Terra Max incidence-forest trace campaign

### Executor contract

This section is written as an execution brief for Terra Max. It intentionally
uses small ordered tasks, exact declarations, and hard stop/go gates so that a
less context-sensitive model can carry out the Lean work without silently
strengthening the mathematics. Aristotle is a parallel lemma prover and
adversarial auditor. It is not the owner of the campaign, and its output is
never merged without local review.

Work from the public baseline commit
`f77f2e3e5cce3eb94708b9388574d62725061f02`. At that checkpoint:

1. the classical positive-atom theorem and the constructible-to-obligatory
   closure are complete;
2. local base-fibre expansion, running assembly, support-overlap forest
   ordering, `FiniteLiftGenerated`, and the host-colourable endpoints compile;
3. `SequenceLiftBaseFiberSupportIncidenceForestOrderBridge.lean` turns
   explicit acyclicity of the dynamic fibre--support incidence graph into a
   noduplicated coherent and compatible base-fibre order; and
4. incidence acyclicity itself is still an explicit hypothesis. It is not a
   consequence of linearity in the checked repository.

**Current checked status (2026-07-18).** The checkpoint above is historical.
The repository now contains the later incidence-cycle decision and endpoint
closure:

1. N14 conditional endpoint wrappers are implemented in
   `SequenceLiftBaseFiberSupportIncidenceForestOrderEndpoints.lean`.
2. N15's candidate theorem
   `baseFiberSupportIncidenceGraph_isAcyclic_of_finite_linear` is implemented
   in `SequenceLiftBaseFiberSupportIncidenceAcyclic.lean`.
3. N16's unconditional finite-generation, constructible, and obligatory
   wrappers are implemented in
   `SequenceLiftBaseFiberSupportIncidenceAcyclicEndpoints.lean`.
4. N17's arbitrary finite embedded-source transport is implemented in
   `SequenceLiftEmbeddedSourceEndpoints.lean`, with bridge and intrinsic
   corollaries in `SequenceLiftEmbeddedSourceBridge.lean` and
   `SequenceLiftEmbeddedSourceIntrinsic.lean`.

The 2026-07-18 audit compiled these modules with warnings as errors and
reported only `propext`, `Classical.choice`, and `Quot.sound` for their public
theorems.  Do not send N14--N17 back to Aristotle as open proof goals unless a
future edit breaks this audit.

Aristotle request `bc362149-d9ba-4378-a0d0-022ef752bdb7` completed on
2026-07-16. It independently proved the dynamic incidence leaf package and
reported the recursive-deletion obstruction, but deliberately did not claim
the full order. The current `main` bridge is stronger and was checked
independently. Do not apply Aristotle's whole-file patch over it; retain only
genuinely new lemmas after a diff and dependency audit.

### Campaign deliverable and acceptance criteria

The immediate deliverable is a checked finite-trace package with two layers:

1. unconditional endpoint wrappers under the already verified explicit
   incidence-acyclic hypothesis; and
2. a theorem-validity decision for the candidate implication from finite
   restricted linearity to incidence acyclicity.

The second layer has two acceptable outcomes:

- a Lean proof of the exact candidate theorem, followed by unconditional
  finite-generation, constructible, and obligatory endpoints; or
- a smallest precise counterexample or an exact missing hypothesis, followed
  by an honestly conditional endpoint and a revised decomposition route.

Do not call this phase complete merely because the wrappers compile. Accept
the phase only when every public theorem passes focused strict compilation,
the banned-construct scan, `#print axioms`, deterministic self-contained
generation, and the corresponding focused GitHub Actions checks.

### Explicit non-goals

This campaign must not:

- reprove or modify the classical positive-atom theorem;
- assert `Linear -> IsAcyclic` from abstract pairwise support-intersection
  subsingletonness;
- confuse a common-apex star with a forbidden incidence cycle;
- hide incidence acyclicity inside a renamed definition or assumption;
- claim the arbitrary embedded-source trace theorem before source-image
  transport is proved; or
- combine the missing-bridge, odd-Berge-cycle, and Erdos--Rado nonlinearity
  arguments into one Aristotle request.

### N14 -- package the verified incidence bridge

Create exactly one focused module:

`Erdos593/TripleSystem/SequenceLiftBaseFiberSupportIncidenceForestOrderEndpoints.lean`

Start with only these imports:

~~~lean
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceForestOrderBridge
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportRunningOrderEndpoints
import Erdos593.TripleSystem.SequenceLiftFiniteLiftGenerated
~~~

In namespace `Erdos593.SequenceLift`, with
`variable {V : Type u} {G : _root_.SimpleGraph V}`, prove these exact public
declarations:

~~~lean
theorem edgeRestriction_finiteLiftGenerated_of_linear_of_incidenceAcyclic
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hacyclic : (baseFiberSupportIncidenceGraph S).IsAcyclic) :
    TripleSystem.FiniteLiftGenerated G ((system G).edgeRestriction S)

theorem edgeRestriction_constructible_of_linear_of_hostColorable_of_incidenceAcyclic
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2)
    (hacyclic : (baseFiberSupportIncidenceGraph S).IsAcyclic) :
    TripleSystem.Constructible ((system G).edgeRestriction S)

theorem edgeRestriction_isObligatory_of_linear_of_hostColorable_of_incidenceAcyclic
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2)
    (hacyclic : (baseFiberSupportIncidenceGraph S).IsAcyclic) :
    ((system G).edgeRestriction S).IsObligatory
~~~

Use the following proof recipe rather than proof search across the repository:

1. For `FiniteLiftGenerated`, obtain `nodes`, noduplication, base-node cover,
   and compatibility from
   `exists_baseFiberAssemblyCompatible_order_of_linear_of_incidenceAcyclic`.
2. Convert the pointwise base-node cover to the exact edge-set equality with
   `edgePieceUnion_baseFiber_eq_of_baseNode_mem`.
3. Apply
   `edgeRestriction_finiteLiftGenerated_of_linear_of_baseFiberAssembly`.
4. For the constructible and obligatory wrappers, obtain the coherent order
   from
   `exists_baseFiberSupportTailOverlapCoherent_order_of_incidenceAcyclic` and
   feed it respectively to the existing coherent-base-node-cover endpoints.

Do not unfold the incidence graph or reprove the leaf-order theorem in this
module. If one of the named declarations is unavailable because of an import,
add the smallest owner import; do not import an aggregate root as a shortcut.

**N14 go gate:** all three declarations compile with warnings as errors and
their axiom reports contain only ordinary Mathlib foundations. Only then add
the module to the focused root imports and CI list.

### N15 -- decide the incidence-cycle theorem before relying on it

The candidate structural theorem is:

~~~lean
theorem baseFiberSupportIncidenceGraph_isAcyclic_of_finite_linear
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear) :
    (baseFiberSupportIncidenceGraph S).IsAcyclic
~~~

This statement is a target to prove or refute, not a fact. Begin with a
theorem-validity audit outside the endpoint module. Test at least:

- `S = empty` and singleton `S`;
- several fibres meeting at one common apex, which should give a star and must
  remain allowed;
- the smallest alternating cycle with three fibre vertices and three distinct
  support-point vertices;
- equal-length distinct base nodes sharing a point;
- restricted linearity versus global linearity of `system G`;
- repeated point witnesses and distinct base fibres; and
- any step that assumes the desired running order while trying to construct
  it.

Preserve two genuinely different routes until this audit decides between
them.

#### Route A -- minimum-length branch argument

If the candidate survives the counterexample audit, create
`SequenceLiftBaseFiberSupportBranchGeometry.lean` and prove only the branch
lemmas needed by the following argument:

1. Assume a simple cycle in the bipartite incidence graph.
2. Choose a base-node vertex on the cycle of minimum `Node.length`.
3. Show that its two neighbouring fibre vertices are distinct proper
   descendants and that the two intervening support points are distinct.
4. Show that these two points are distinct apices in the minimum fibre and
   therefore determine distinct first extension letters.
5. Along the remainder of the cycle, show that consecutive base nodes sharing
   a point are comparable and remain in one immediate branch below the
   minimum node.
6. Conclude that the remainder cannot connect the two distinct first branches.

Candidate helper obligations, each in the smallest owner module, are:

- shared support makes two active base nodes comparable;
- equal lengths plus shared support force equal base nodes;
- strict length inequality makes the common point an apex of the shorter
  fibre;
- the longer node extends through the shorter fibre's apex base letter;
- two distinct shared points at the shorter fibre give distinct outgoing
  letters, using restricted linearity; and
- comparable proper descendants preserve their first branch below a fixed
  ancestor.

It is permitted to delete point-side vertices of incidence degree zero or one
if that simplifies the cycle API, but first prove that this deletion preserves
acyclicity. Pairwise support-intersection subsingletonness alone is not an
acceptable replacement for any branch lemma: an abstract linear set family
can still contain a six-cycle.

**Route A stop gate:** if any helper requires an unproved statement such as
"distinct point neighbours give distinct letters", isolate that exact lemma
and stop. Do not add it as a hypothesis to the advertised theorem without
renaming and restating the endpoint.

#### Route B -- counterexample or cyclic-block decomposition

If the candidate fails, preserve the finite counterexample as a regression
artifact or document its exact Lean representation. Then choose the weakest
truthful replacement:

1. retain the explicit incidence-acyclic sufficient condition from N14; or
2. decompose the incidence graph into articulation points and cyclic blocks,
   proving the assembly theorem block by block; or
3. prove that a cyclic incidence block reflects a specific host or Berge-cycle
   obstruction and route that obstruction to the later negative-host phase.

Do not replace Route B by a statement equivalent to the original theorem
under a new name. Record the exact obstruction and which downstream endpoint
remains conditional.

### N16 -- close the finite trace only after N15

If and only if Route A proves the candidate theorem, add the unconditional
structural endpoint:

~~~lean
theorem edgeRestriction_finiteLiftGenerated_of_linear
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear) :
    TripleSystem.FiniteLiftGenerated G ((system G).edgeRestriction S)
~~~

It should be a short composition of
`baseFiberSupportIncidenceGraph_isAcyclic_of_finite_linear` and the N14
finite-generation wrapper. No colourability assumption belongs in this
theorem.

In a separate positive endpoint module, and only for `hG : G.Colorable 2`,
prove:

~~~lean
theorem edgeRestriction_constructible_of_linear_of_hostColorable
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2) :
    TripleSystem.Constructible ((system G).edgeRestriction S)

theorem edgeRestriction_isObligatory_of_linear_of_hostColorable
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2) :
    ((system G).edgeRestriction S).IsObligatory
~~~

The intended dependency chain is exactly:

~~~text
finite linear restriction
  -> FiniteLiftGenerated G
  -> Constructible                    [G is 2-colourable]
  -> IsObligatory                     [completed classical positive atom]
~~~

Use `TripleSystem.FiniteLiftGenerated.constructible_of_hostColorable` and
`TripleSystem.FiniteLiftGenerated.isObligatory_of_hostColorable`. Do not add a
new atom premise and do not reopen `PositiveAtomClassical.lean`.

If Route B was selected, do not create these unconditional names. Keep the
N14 conditional theorems and name any strengthened hypothesis explicitly.

### N17 -- source-image transport, then negative hosts

Treat transport from an arbitrary finite embedded source as a separate module
after N16. First inspect, rather than duplicate, the APIs in
`EmbeddingEdgeRestriction.lean` and `FiniteLinearImageTrace.lean`. The intended
objects are the isolated-reduction embedding, its `edgeImage`, the finiteness
and linearity of the exact image restriction, and
`imageEdgeRestrictionIso`. Freeze the exact theorem signature only after this
API check.

The transport stage must distinguish:

- the source from its isolated reduction;
- an embedded copy from the exact host-edge restriction on the image; and
- preservation of `Constructible` or `FiniteLiftGenerated` under the exact
  isomorphism used.

After source transport is checked, connect it to the two negative-host
campaigns in separate modules: the missing-bridge host and the odd
Berge-cycle/shift-graph host. Keep the Erdos--Rado nonlinearity route separate.
No negative-host task may be marked complete merely because the conditional
incidence endpoint exists.

**N17 status (2026-07-18).** Implemented and strict-clean.  The public
source-transport endpoints are:

~~~lean
SequenceLift.isolatedReduction_finiteLiftGenerated_of_linear_of_embedding
SequenceLift.isolatedReduction_constructible_of_linear_of_embedding
SequenceLift.isolatedReduction_isObligatory_of_linear_of_embedding
SequenceLift.isObligatory_of_linear_of_embedding
SequenceLift.isolatedReduction_bridgeAtEveryEdge_of_linear_of_embedding
SequenceLift.not_nonempty_embedding_of_not_isolatedReduction_bridgeAtEveryEdge
SequenceLift.isolatedReduction_intrinsic_of_linear_of_embedding
~~~

Their current axiom audit reports only ordinary Mathlib foundations:
`propext`, `Classical.choice`, and `Quot.sound`.

### N18 -- generic nonlinearity endpoint before the Erdős--Rado host campaign

Keep the Erdos--Rado nonlinearity route separate from the sequence-lift
missing-bridge and odd-Berge routes.  The local reusable package is now:

~~~lean
Embedding.source_linear_of_target_linear
    (f : F.Embedding H) (hlinear : H.Linear) : F.Linear

Embedding.source_linear_of_imageEdgeRestriction_linear
    (f : F.Embedding H) (hF : F.HasNoIsolatedPoints)
    (hlinear : (H.edgeRestriction f.edgeImage).Linear) : F.Linear

theorem not_isObligatory_of_not_linear_of_linear_highChromatic
    [DecidableEq W]
    (hnotlinear : ¬ F.Linear) (hHlinear : H.Linear)
    (hchi : Cardinal.aleph0 < H.chromaticCardinal) : ¬ F.IsObligatory
~~~

The first two declarations live in `EmbeddingLinearity.lean`; the third lives
in `NonlinearObstruction.lean`.  The proof of the endpoint must use only the
obligatory appearance in the supplied host and reflection of linearity through
that embedding.

**Hard boundary.** This endpoint is conditional.  It does not claim that the
sequence lift is linear, and it does not construct an uncountably chromatic
linear host.  Formalizing that Erdős--Rado host is the next separate campaign;
only after its exact host theorem is checked may it instantiate this endpoint.
### N19 -- concrete `TriangleHost κ` campaign (Terra Max handoff)

The intended nonlinearity witness is the documented Erdős--Rado triangle host:
vertices are 2-subsets of `κ`, edges are 3-subsets of `κ`, and a vertex is
incident to an edge exactly when it is contained in it.  Terra Max must keep
this campaign in three separately checked layers.

1. **Host definition and universes.** Define `TriangleHost κ` with an explicit
   same-universe representation of 2-subsets and 3-subsets (for example,
   `Finset κ` with the indicated cardinality predicates). Do not silently use
   a host whose edge type lives in the wrong universe for `IsObligatory`; add a
   deliberate lifting layer only if it is proved necessary.
2. **Finite linearity layer.** Prove `triangleHost_linear`. The core finite
   obligation is: two 3-element finite sets that contain two distinct common
   2-element finite subsets are equal. This layer also owns the cardinality-3
   incidence proof and simple-edge injectivity facts.
3. **Ramsey/chromatic layer.** State the exact Erdős--Rado partition statement
   needed to turn every countable proper coloring of 2-subsets into a
   monochromatic triangle, then prove
   `Cardinal.aleph0 < (TriangleHost κ).chromaticCardinal` using the existing
   chromatic-cardinal pattern in `SequenceLiftChromatic.lean`. The external
   partition theorem is a named proof obligation, not an axiom or a claimed
   consequence of the host definition.

Only after all three layers are checked may the result instantiate
`not_isObligatory_of_not_linear_of_linear_highChromatic`. No tracked Lean
Erdős--Rado or partition-calculus theorem currently supplies layer 3; this is
the principal remaining nonlinearity branch.

**N19 status (2026-07-16).** Layers 1--2 are now implemented independently in
`Erdos593/TripleSystem/TriangleHostLinearity.lean`.  The module defines the
same-universe finite-pair/finite-triangle host and proves its exact
triple-system structure and `TriangleHost.linear`.

It passes the strict source command and focused Lake build for that module.
Its `#print axioms` audit reports only `propext`, `Classical.choice`, and
`Quot.sound`.

This discharges only the finite host and linearity layer.  The Ramsey/high
chromaticity layer is still open, and an explicit universe-lifting or
reindexing bridge is still required before an arbitrary source can use this
same-universe host in the generic nonlinearity endpoint.

### N20 -- natural-colour Ramsey interface

Keep this layer separate from the external partition-calculus theorem.
In `Erdos593/TripleSystem/TriangleHostRamsey.lean`, define only the exact
natural-colour consequence required of a future Erdos--Rado theorem.
`PairRamseyTriangle kappa` says that every map `Pair kappa -> Nat` is
constant on the three pair-faces of some `Triangle kappa`.

Use it to prove that `TriangleHost.system kappa` has no proper
natural-number colouring. This is the local combinatorial contradiction
needed by the existing chromatic-cardinal pattern; it is not a proof that
the host has chromatic cardinal strictly above aleph-zero.

**N20 status (2026-07-16).** The interface and its two direct anti-colouring
lemmas are implemented and strict-clean in
`Erdos593/TripleSystem/TriangleHostRamsey.lean`. The module does not prove
`PairRamseyTriangle`, a Ramsey partition relation, a cardinal lower bound,
or a cross-universe host bridge. Those remain separate proof obligations.

### N21 -- conditional chromatic-cardinal bridge

In `Erdos593/TripleSystem/TriangleHostRamseyChromatic.lean`, convert the
natural-colour interface to the precise cardinal conclusion needed later:
under `PairRamseyTriangle kappa`, the triangle host has chromatic cardinal
strictly above `aleph-zero`. The proof uses the existing
`chromaticCardinal_le_mk_iff` characterization, pulls a hypothetical
countable colouring back through `ULift`, and invokes the N20 contradiction.

This is still conditional on the Ramsey interface. It does not prove an
Erdos--Rado relation, provide a witness `kappa`, or transport the result to
a host in arbitrary vertex and edge universes.

**N21 status (2026-07-16).** The conditional cardinal bridge is implemented
and strict-clean in
`Erdos593/TripleSystem/TriangleHostRamseyChromatic.lean`. The outstanding
work is the explicit Ramsey witness and the separately scoped reindexing
bridge for the generic nonlinearity obstruction.

### N22 -- exact lifted-host obstruction bridge

`TriangleHostRamseyTransport.lean` defines a two-sided `reindex` and uses it
to lift the base-universe triangle host into the exact vertex and edge
universes of an arbitrary source. Under `PairRamseyTriangle kappa`, the
module proves that the lifted host is linear and has chromatic cardinal
strictly above aleph-zero. It then applies the generic nonlinearity obstruction
to show that every non-linear source is not obligatory.

**N22 status (2026-07-16).** Implemented and strict-clean in
`Erdos593/TripleSystem/TriangleHostRamseyTransport.lean`. This remains a
conditional negative route: it does not construct `kappa`, prove the
Erdos--Rado input, or settle the full classical positive-atom theorem.

### N23 -- explicit Erdos--Rado witness (Terra handoff)

This is the remaining theorem-level combinatorial input currently identified
for the unconditional N22 route, subject to separately checked carrier and
transport integration. It is a real partition-calculus formalization, not a
library import or a permissible axiom. The pinned Mathlib snapshot has no
usable theorem that supplies the required countably-coloured pair relation.

**Exact target.** Use the existing base-universe carrier
`ErdosRadoCarrier`, its supplied noncomputable `DecidableEq`, and its
stronger cardinal-form target:

~~~lean
ErdosRadoUncountableHomogeneousPairSet
~~~

Equivalently, every `c : TriangleHost.Pair ErdosRadoCarrier -> Nat` must
have a set `H : Set ErdosRadoCarrier` with
`Cardinal.aleph0 < Cardinal.mk H` satisfying `TriangleHost.PairHomogeneous c
H`. The checked carrier reduction then derives
`TriangleHost.PairRamseyTriangle ErdosRadoCarrier`. The theorem must be
obtained from an actual special case of the Erdos--Rado theorem, with
countably many colours; replacing it by a finite-colour theorem is not
sufficient.

**Implemented finite bridge (2026-07-16).**
`CardinalPairPartition.lean` is now strict-clean and imported by the
aggregate root. It defines `PairHomogeneous c H` using the project's finite
`TriangleHost.Pair` faces, and
`HomogeneousThreePointPairColoring kappa Nat`. It proves exactly:

1. `pairRamseyTriangle_of_infinite_pair_homogeneous`;
2. `pairRamseyTriangle_of_homogeneousThreePoint`;
3. `homogeneousThreePoint_of_pairRamseyTriangle`; and
4. `homogeneousThreePointPairColoring_iff_pairRamseyTriangle`.

The module has no new axiom and only reduces an infinite homogeneous set to
a three-point finite witness. It does not establish the existence of that
homogeneous set.

**Exact remaining external obligation.** For the selected base-universe
carrier `ErdosRadoCarrier` with cardinality the successor of the continuum,
every `c : TriangleHost.Pair ErdosRadoCarrier -> Nat` must have a set
`H : Set ErdosRadoCarrier` with
`Cardinal.aleph0 < Cardinal.mk H` satisfying
`TriangleHost.PairHomogeneous c H`. The checked carrier interface reduces
this stronger uncountable conclusion to the required infinite homogeneous
set; it does not prove the stronger conclusion.

This is the countably-coloured special case customarily written
`(2^aleph0)^+ -> (aleph1)^2_{aleph0}`. It is the remaining non-finite
combinatorial theorem in this route. Its separate proof obligations are
specified in N24; a proof must be formalized rather than hidden behind an
interface or an assumed witness.

**Module split.** Keep the external combinatorics separate from the current
host and transport code.

1. `CardinalPairPartition.lean` defines a small cardinal pair-colouring
   interface over the existing finite `TriangleHost.Pair` and
   `TriangleHost.Triangle` representations. It is implemented; it contains
   only the finite extraction and equivalence bridge above.
2. `ErdosRadoCarrier.lean` fixes the base-universe carrier
   `Order.succ Cardinal.continuum`, proves its exact cardinality, and
   packages both the required infinite-homogeneous-set premise and the
   stronger uncountable target
   `ErdosRadoUncountableHomogeneousPairSet`, with a checked reduction from
   the latter to the former. It deliberately makes no partition-calculus
   assertion.
3. The five N24 owner modules formalize the stronger target in bounded
   layers. `CountingAndMain.lean` owns the final theorem; an optional
   `ErdosRado.lean` may be an import-only umbrella and must contain no
   proof. The proof must not replace countably many colours with a
   finite-colour result.
4. `TriangleHostRamseyUnconditional.lean` applies N22's existing
   `not_isObligatory_of_not_linear_of_exactTriangleHost` to that witness. It
   must not duplicate `reindex`, the ULift argument, or the finite-linearity
   proof.

**Non-goals and hard stop.** Do not claim an Erdos--Rado witness, the full
classical positive-atom theorem, or any positive classification result until
the special-case partition theorem itself is strict-clean. No `axiom`,
`sorry`, `admit`, `unsafe`, `native_decide`, `implemented_by`, finite-colour
reduction, or hidden classical witness is acceptable. If the theorem cannot
be built in the pinned environment, deliver the smallest exact missing lemma
and stop there; that is a valid result for Terra Ultra review.

**Acceptance checks.** For each module, run focused warnings-as-errors
elaboration and `lake build`, scan the changed Lean files for prohibited
constructs, inspect `#print axioms` for the Ramsey witness and final endpoint,
run `git diff --check`, regenerate/check the self-contained file, and monitor
the targeted GitHub Action after the isolated commit is pushed to `main`.

### N24 -- direct countably-coloured Erdos--Rado formalization

**Status and hard boundary.** This is an execution plan, not a claim that
the partition theorem is present. The checked repository contains the finite
extraction bridge, successor-of-continuum carrier interface, and
same-universe pair-transport layer, but it does not prove:

~~~lean
ErdosRadoUncountableHomogeneousPairSet
PairRamseyTriangle ErdosRadoCarrier
~~~

or the unconditional N22 negative endpoint. No stage below may assume any
of those statements.

**Fixed theorem target.** In namespace
`Erdos593.TripleSystem.TriangleHost`, the final module must prove:

~~~lean
theorem erdosRadoUncountableHomogeneousPairSet :
    ErdosRadoUncountableHomogeneousPairSet
~~~

That is, for every `c : Pair ErdosRadoCarrier -> Nat`, it must construct
`H : Set ErdosRadoCarrier` with

~~~lean
Cardinal.aleph0 < Cardinal.mk H /\ PairHomogeneous c H
~~~

The only permitted final conversion is the existing checked theorem
`pairRamseyTriangle_erdosRadoCarrier_of_uncountable`. Do not assume CH,
replace natural-number colours by finitely many colours, introduce a project
axiom, or use an unproved library partition theorem.

The intended mathematics is the countably-coloured special case
`(2^aleph0)^+ -> (aleph1)^2_{aleph0}`. Every cardinal lift, successor
comparison, countability claim, and use of classical choice must be explicit.
Classical.choice is ordinary Lean foundation, but it must not conceal the
partition theorem or an arbitrary non-canonical trace later counted as
canonical.

**Source-backed trace specification (unblocked 2026-07-16).** The required
construction is the ramification proof in J. A. Larson and A. Hajnal,
[“Partition Relations,” Theorem 2.5](https://people.clas.ufl.edu/jal/files/haj-lar.pdf),
specialized to `kappa = aleph1`, `gamma = omega`, and
`lambda = 2^(<aleph1) = 2^aleph0`. Hence the native carrier has cardinality
`lambda^+ = (2^aleph0)^+`; this identity is a ZFC cardinal-arithmetic fact
and does not use CH.

For each ordinal endpoint `alpha < lambda^+` and stage `eta < kappa`, the
formal trace must define `B^alpha_eta = {beta^alpha_zeta | zeta < eta}` for
every `eta <= phi(alpha)`, including the terminal range. The lower bound at a
live stage is `hatBeta^alpha_eta = sup_{zeta < eta}(beta^alpha_zeta + 1)`.
For a pair colouring `c`, the exact eligible-candidate predicate at each
live stage `eta < phi(alpha)` is:

~~~text
beta < alpha /\\ hatBeta^alpha_eta <= beta /\\
forall zeta < eta,
  c({beta^alpha_zeta, beta}) = c({beta^alpha_zeta, alpha}).
~~~

When eligible candidates exist, `beta^alpha_eta` is their ordinal minimum.
At a limit stage the preceding supremum is part of that predicate; do not
replace it by arbitrary colour-class choices or an unconstrained
`Classical.choose`. Truncate the trace at `kappa`, writing `phi(alpha) <=`
`kappa` for its height. `phi(alpha) < kappa` means its next eligible set is
empty; `phi(alpha) = kappa` is the success case, not a failure code. In that
success case the terminal prefix is explicitly
`B^alpha_kappa = {beta^alpha_zeta | zeta < kappa}`; more generally the
terminal prefix is `B^alpha_(phi alpha)` by the same range definition.
Every displayed brace passed to the pair colouring must carry strict endpoint
proofs, so `beta^alpha_zeta < beta < alpha` (or the corresponding trace
inequality) certifies an actual two-element `Pair` rather than silently
treating a repeated endpoint as a face.

The following source invariants are mandatory Lean obligations:

1. Indexed strictness: `zeta < eta < phi(alpha)` implies
   `beta^alpha_zeta < beta^alpha_eta < alpha`.
2. `B^alpha_(phi alpha) union {alpha}` is endhomogeneous, with the terminal
   `B^alpha_kappa` available when `phi(alpha) = kappa`.
3. Indexed trace coherence: if `beta = beta^alpha_eta`, then
   `phi(beta) = eta` and for every `zeta < eta`,
   `beta^beta_zeta = beta^alpha_zeta`.
4. For the canonical predecessor relation `beta prec alpha` iff `beta`
   occurs in the trace of `alpha`, its tree rank equals `phi(alpha)`; the
   rank proof consumes the cutoff equality from indexed coherence.

At each fixed height `varphi < kappa`, the source's reduced-colour code is
the function `C_alpha : varphi -> gamma` whose `zeta` coordinate is
`c({beta^alpha_zeta, alpha})`. The central theorem to formalize explicitly is
`alpha, beta in T_varphi /\\ C_alpha = C_beta -> alpha = beta`, proved by
transfinite induction from trace coherence and ordinal-minimal selection.
It is not an immediate definitional fact. The counting layer must name the
ZFC facts `omega < cf(kappa)`, `kappa <= lambda`,
`varphi < kappa -> omega^|varphi| <= 2^aleph0 = lambda`, and
`kappa * lambda = lambda`; none is a use of CH. It then proves
`|T_varphi| <= |gamma|^|varphi| <= lambda` and the union bound for all
heights below `kappa`. Since the carrier has cardinality `lambda^+`, a
height-`kappa` trace exists. For a successful trace define the induced unary
end-colour `d(beta^alpha_zeta) = c({beta^alpha_zeta, alpha})` on its index
domain `kappa`. Regularity and `omega < cf(kappa)` yield a `kappa`-sized
index fibre `I : Set kappa` on which this induced colour is constant. Let
`H = {beta^alpha_zeta | zeta in I}`. Indexed strictness makes this node set
have cardinality `kappa`; for `zeta < eta` both in `I`, endhomogeneity gives
`c({beta^alpha_zeta, beta^alpha_eta}) = d(beta^alpha_zeta)`. This direct
`r = 2` argument proves pair homogeneity of `H` and replaces an informal
countable unary-colour pigeonhole sentence.

**Six owner modules.** Each module exports only its local interface; later
modules must not reopen or duplicate earlier arguments.

1. `Erdos593/TripleSystem/ErdosRado/PairTransport.lean`

   This implemented layer defines generic same-universe transport of finite
   pairs, colourings, pair homogeneity, and subset cardinality along an
   equivalence. It proves that reindexing a homogeneous set preserves both
   homogeneity and cardinality, and it must not mention, assume, or prove an
   Erdos--Rado conclusion.

2. `Erdos593/TripleSystem/ErdosRado/CanonicalTrace.lean`

   Work on the native ordinal carrier. Define the exact eligible predicate,
   ordinal-minimum successor, limit lower bound, cutoff height, terminal
   ranges `B_(phi alpha)` and `B_kappa`, and local trace invariants
   (indexed strictness, endpoint bounds, genuine-pair face proofs,
   endhomogeneity, and indexed coherence). A generic least-selector is only
   support infrastructure; this module must connect it to the displayed
   predicate.

3. `Erdos593/TripleSystem/ErdosRado/CanonicalTree.lean`

   Define the canonical predecessor relation induced by traces, prove its
   well-foundedness, and prove that its rank is the trace height. This avoids
   hiding rank arguments inside a later cardinality proof.

4. `Erdos593/TripleSystem/ErdosRado/CanonicalLevelCode.lean`

   Define the source-native reduced-colour code on each fixed rank, and prove
   the exact fixed-rank injectivity theorem by transfinite induction. This
   replaces the provisional `FailureCode` plan; there is no ad hoc
   first-failure encoding.

5. `Erdos593/TripleSystem/ErdosRado/CanonicalCounting.lean`

   Prove the level-code cardinal bound, the union bound below `aleph1`, and
   existence of a height-`aleph1` trace on the successor-continuum carrier,
   keeping all universe lifts and `2^(<aleph1) = 2^aleph0` explicit. Name
   the cofinality, exponent, comparison, and product cardinal lemmas used
   by the bound rather than hiding them in a combined estimate.

6. `Erdos593/TripleSystem/ErdosRado/EndhomogeneousLift.lean`

   Convert a height trace to its endhomogeneous set, define the induced
   unary end-colour, obtain a `kappa`-sized regularity fibre, and prove
   directly that its pairs are homogeneous. Then transport from the native
   carrier to `ErdosRadoCarrier`, and prove
   `erdosRadoUncountableHomogeneousPairSet`. It must reuse the existing N22
   endpoint instead of duplicating finite three-point extraction.

The dependency graph is:

~~~text
CanonicalTrace -> CanonicalTree -> CanonicalLevelCode -> CanonicalCounting
                                                               -> EndhomogeneousLift
PairTransport --------------------------------------------------^
EndhomogeneousLift -> checked carrier reduction
                    -> existing TriangleHostRamseyUnconditional endpoint
~~~

**Per-module gates.** Before beginning the next module, the owner module
must pass focused warnings-as-errors elaboration, focused `lake build`, a
prohibited-construct scan, targeted `#print axioms`, `git diff --check`, and
deterministic self-contained generation/check. Do not use aggregate-root Lean
checks.

**Aristotle schedule.** Submit exactly one narrow Aristotle request after
each owner module is committed to a public `main` SHA:

- N24-A: audit pair equivalence, image homogeneity, and cardinal transport;
- N24-B: audit the source-native canonical trace: eligible predicate,
  ordinal minimum, limit lower bound, terminal range, strict pair faces,
  cutoff, and indexed coherence;
- N24-C: audit canonical-tree rank and fixed-level reduced-colour-code
  injectivity by transfinite induction;
- N24-D: audit level and union cardinal bounds, the named
  cofinality/exponent/comparison/product facts, universe lifts, and
  the height-`aleph1` existence argument without CH; and
- N24-E: audit the induced unary end-colour, regularity fibre, direct
  pair-homogeneity lift, carrier transport, final dichotomy, and absence of
  a hidden partition assumption.

Each request uses only the exact public commit and its owner module, requests
either a compile-checked patch or the smallest precise blocker, and forbids
theorem weakening, hidden hypotheses, aggregate imports, `sorry`, `admit`,
axioms, unsafe declarations, and resource-limit workarounds. N24-A through
N24-E supersede the former monolithic A8 request; the implemented A6 finite
bridge is rerun only if that bridge changes.

### N24 Sol-ultra → Terra-ultra execution handoff (2026-07-17)

**Authority, accepted baseline, and theorem boundary.** This dated subsection
is the current execution contract for N24; it refines the older six-module and
N24-A--E schedules above without erasing their history. The classical
positive-atom theorem developed earlier in this plan is already closed. That
result is logically separate from N24's unconditional nonlinear/negative
direction and does not supply the partition theorem below. The accepted N24
baseline is public `main` commit `9b3e2e2` (`Expose source eligibility and
prefix restriction`). It contains checked local source-eligibility and prefix-
restriction interfaces, not a global trace construction and not an
Erdos--Rado theorem.

The sole global N24 target remains the following theorem in namespace
`Erdos593.TripleSystem.TriangleHost`:

~~~lean
theorem erdosRadoUncountableHomogeneousPairSet :
    ErdosRadoUncountableHomogeneousPairSet
~~~

After unfolding the target, its exact quantifiers and conclusion are:

~~~lean
∀ c : Pair ErdosRadoCarrier → ℕ, ∃ H : Set ErdosRadoCarrier,
  Cardinal.aleph0 < Cardinal.mk H ∧ PairHomogeneous c H
~~~

No intermediate structure, conditional trace lemma, cardinal estimate, or
Aristotle result is a proof of this statement. The theorem is complete only
when this declaration kernel-checks locally with the audited dependency and
axiom footprint.

**External-live eligibility contract.** For a prefix `p : TracePrefix α`,
`TraceCandidate.Eligible c p β` contains only the source's order, lower-bound,
and colour-agreement conditions: `β < α`,
`p.lowerBound ≤ β.toOrd`, and agreement with the anchor along every node
of `p`. Liveness is deliberately not a field of `Eligible`; it is the external
recursion guard. The accepted bridge has the exact shape

~~~lean
p.length < TraceHeight ∧ TraceCandidate.Eligible c p β ↔
  ∃ q : TraceCandidate c p, q.value = β

Nonempty (TraceCandidate c p) ↔
  p.length < TraceHeight ∧
    ∃ β : TraceCarrier, TraceCandidate.Eligible c p β
~~~

Consequently, reaching `p.length = TraceHeight` is the success cutoff: the
candidate type is empty because the external live guard is false, not because
source eligibility has failed. A terminal non-eligibility conclusion is valid
only under the short-cutoff hypothesis `p.length < TraceHeight`. Terra must
preserve this distinction in every stopped-recursion and terminal theorem.

**Revised owner dependency chain.** Keep the abstract `CanonicalTree` and
`CanonicalLevelCode` APIs generic, but do not ask those abstractions alone to
prove source injectivity. The concrete canonical system and its coherence are
the extra data needed by the fixed-level argument. The intended owner graph is:

~~~text
CanonicalTrace
  -> TraceExtension
  -> TraceRestriction / TraceLimit
  -> CanonicalTraceRecursion
  -> CanonicalTraceCoherence ----+
                                  +-> CanonicalLevelInjectivity
CanonicalTree -------------------+
CanonicalLevelCode --------------+
  -> ErdosRadoCardinalArithmetic
  -> CanonicalCounting
  -> EndhomogeneousLift
  -> final N24 theorem

PairTransport ----------------------> EndhomogeneousLift
~~~

`TraceRestriction` denotes the accepted restriction API currently exported
from `TraceExtension.lean`; `TraceLimit.lean` should own coherent limit-prefix
assembly. New proof owners should be separate focused modules rather than a
large expansion of `CanonicalTrace.lean`. An import-only umbrella is allowed,
but it must contain no proof.

**Stopped raw-history recursion.** Use Mathlib's pinned
`transfiniteIterate` API rather than hiding a coherent family inside an
unproved choice. Take

~~~lean
StageIndex := (Order.succ TraceHeight).ToType
RawHistory := Set (Ordinal × TraceCarrier)
run j := transfiniteIterate step j ∅
~~~

where `step` first decodes a valid functional raw graph as a trace prefix. If
that prefix is live and has a candidate, insert exactly
`(p.length, leastCandidate.value)`; if it is stopped or invalid, return the
history unchanged. Prove the empty, successor, limit, and monotonicity laws
from `transfiniteIterate_bot`, `transfiniteIterate_succ`,
`transfiniteIterate_limit`, and `monotone_transfiniteIterate`, together with
the graph/function decoding lemmas and `graph (p.snoc q) = insert ...`.

The exact limit invariant is not merely that a limit prefix exists. For every
limit `λ ≤ TraceHeight`,

~~~text
run λ = ⋃ (j < λ), run j,
~~~

and precisely one of the following compatible cases must be proved:

1. no stage below `λ` has stopped, the union decodes to a prefix `pλ` of
   length exactly `λ`, and for every `j < λ` the restriction of `pλ` to
   `j` is the prefix decoded from `run j`; or
2. there is a least stopped stage `μ < λ`, `run j = run μ` for every
   `μ ≤ j ≤ λ`, and the limit union is exactly `run μ`.

The coherent `TraceLimit` diagonal supplies case 1. Inflationarity and the
fixed-point propagation lemma supply case 2. Every later terminal/coherence
claim must consume this disjunction rather than assume that all stages have
their index as their length.

**Ten remaining obligation groups.** Track completion by discharged theorem
obligations, never by an informal percentage. The accepted baseline closes
the fixed-point eligibility bridge and the restriction half of the first two
groups, but the end-to-end campaign still has these ten auditable groups:

1. Source eligibility: preserve the external-live equivalences through the
   minimum selector and prove the short-stage candidate/non-eligibility laws.
2. Restriction and limits: finish initial-segment algebra and the coherent
   limit-prefix construction, including node, lower-bound, and
   endhomogeneity preservation.
3. Stopped recursion: build and decode the raw-history
   `transfiniteIterate`, prove validity, inflationarity, successor insertion,
   limit union, least stop, and fixed-point propagation.
4. Terminal and local coherence: define cutoff and terminal prefixes and
   prove minimum selection, indexed strictness, short terminal failure, and
   full-height success without conflating those last two cases.
5. Actual coherent system: package the prefixes constructed by recursion and
   prove source indexed coherence and the canonical predecessor/rank laws for
   that concrete system.
6. Fixed-level canonical injectivity: prove reduced-colour-code injectivity
   for the concrete canonical system by transfinite induction. The abstract
   `CoherentTraceSystem` interface alone is insufficient.
7. Cardinal arithmetic and counting kernel: isolate the cofinality,
   exponent, comparison, multiplication, level bound, union bound, and all
   universe-lift equalities without CH.
8. Full-height endpoint: use the successor-continuum carrier size and the
   counting bound to obtain an endpoint whose cutoff is exactly
   `TraceHeight`, then expose its terminal endhomogeneous trace.
9. Unary fibre and pair lift: define the induced end-colour, obtain an
   `aleph1`-sized constant fibre by regularity, prove node-map injectivity, and
   prove pair homogeneity directly from indexed endhomogeneity.
10. Final transport and theorem: reuse `PairTransport`, transport cardinality
    and homogeneity to `ErdosRadoCarrier`, prove the exact target above, and
    invoke the existing finite extraction/downstream endpoint separately.

**Aristotle call schedule for this handoff.** Each request is a narrow audit
or lemma formalization against an exact public `main` SHA. Reconcile the live
dashboard/CLI queue before submission, never duplicate an active request, and
ask for either a compile-checked patch or the smallest exact blocker with all
quantifiers visible. Terra continues local work while Aristotle runs.

- **B0 -- accepted eligibility/restriction audit.** Audit commit `9b3e2e2`,
  especially the external-live equivalences, dependent pair proofs, prefix
  restriction, and preservation lemmas. Do not ask B0 to invent recursion or
  claim the global theorem.
- **B1 -- coherent limit-prefix package.** Give Aristotle the frozen
  `TraceLimit` signatures and require only the coherent exact-stage
  (live/cofinal) limit-prefix construction, restriction equations, and
  endhomogeneity preservation; the live-versus-frozen limit disjunction is a
  B2 stopped-recursion obligation.
- **B2 -- raw-history stopped recursion.** Submit only the graph decoder,
  inflationary `step`, `transfiniteIterate` laws, validity invariant, and
  fixed-point propagation. Reject an oracle, a chosen coherent family, or an
  `Option TracePrefix` that omits the required history.
- **B3 -- terminal/coherence package.** Audit cutoff, minimum successor,
  strictness, short terminal failure, full-height success, and concrete
  indexed trace coherence.
- **C -- rank and concrete level injectivity.** Audit the canonical-tree rank
  theorem and the transfinite-induction proof that equal reduced-colour codes
  at one fixed level force equal endpoints. Keep the concrete-system
  hypotheses explicit.
- **D1 -- cardinal arithmetic kernel.** Locate or prove the exact pinned
  Mathlib cofinality, power, comparison, product, and lift lemmas. Request
  signatures and tiny compiling examples before a combined estimate.
- **D2 -- counting and full-height endpoint.** Audit fixed-level bounds, the
  union below `aleph1`, the successor-continuum contradiction, and extraction
  of an endpoint with full trace height.
- **E1 -- unary fibre and direct pair lift.** Audit regularity/pigeonhole,
  index-fibre cardinality, node-map injectivity, induced colour constancy, and
  the direct two-node homogeneity calculation.
- **E2 -- final transport and adversarial endpoint audit.** Audit
  same-universe transport, the exact `erdosRadoUncountableHomogeneousPairSet`
  declaration, its downstream conditional use, and the complete absence of a
  hidden partition assumption.

**Focused acceptance gates.** Before one owner unlocks the next, require all
of the following on the exact changed files and declarations:

1. direct warnings-as-errors elaboration with
   `lake env lean -DwarningAsError=true <owner-file>` and focused
   `lake build Erdos593.<owner>`; do not use an aggregate root build as the
   proof check;
2. GitHub Actions coverage naming every new or modified N24 owner, monitored
   to completion on the exact pushed SHA;
3. deterministic `Erdos593SelfContained.lean` regeneration and `--check`,
   plus `git diff --check`;
4. targeted kernel `#print axioms` on every exported bridge and endpoint. The
   expected foundational footprint is exactly `propext`,
   `Classical.choice`, and `Quot.sound`; any additional project axiom or
   theorem-shaped assumption is a failure; and
5. a production-source scan forbidding `sorry`, `sorryAx`, `admit`, `axiom`,
   `unsafe`, `native_decide`, `implemented_by`, and `run_tac`, as well as
   `maxHeartbeats` or `maxRecDepth` overrides and equivalent resource-limit
   workarounds.

**Failure and overclaim checks.** A review must actively reject all of the
following: treating full height as candidate failure; assuming a coherent
history in order to construct that history; deriving concrete level
injectivity from the abstract interfaces (the height-zero model is an
immediate warning counterexample); using arbitrary choice where ordinal
minimum is required; omitting strict endpoint inequalities from a `Pair`;
using CH, a finite-colour reduction, or an unproved library partition theorem;
hiding universe lifts or cardinal equalities in coercion automation; importing
the target theorem circularly; or accepting an Aristotle success badge without
local focused compilation and an axiom audit. If a checkpoint fails, record
the smallest exact missing lemma, its hypotheses, quantifiers, owner, and
downstream consumers. Such a blocker is valid progress, but it is not N24.

### Aristotle call schedule for Terra Max

Terra Max should keep local proof search moving while Aristotle runs. It must
not wait idly for a request and must not submit duplicate jobs.

#### A0 -- retrieve the completed incidence-order audit

- Request ID: `bc362149-d9ba-4378-a0d0-022ef752bdb7`.
- Disposition: completed bounded fallback; advisory because `main` now has the
  stronger bridge.
- Action: save its report and patch for comparison, record accepted/rejected
  lemmas in `ARISTOTLE_LOG.md`, and do not overwrite current files.

#### A1 -- N14 endpoint package

Submit the three tightly related N14 declarations as one bounded request from
the exact public commit SHA. Permit one new endpoint file and at most three
small local helper lemmas. Require Aristotle to use the named bridge and
existing endpoint APIs, not unfold the graph construction.

#### A2 -- branch-geometry leaves

After Terra freezes each exact helper signature, submit at most two to five
closely related branch lemmas per request. Ask for either a compile-checked
patch or the smallest exact obstruction. Do not submit the whole
classification theorem.

#### A3 -- forest theorem or counterexample

Give Aristotle the exact N15 candidate and the minimum-length route. State
that exactly two outcomes are acceptable: a checked proof with all hypotheses
visible, or a checked finite counterexample with the failed step identified.
Specifically request audits of cycle alternation, minimum selection,
equal-length fibres, distinct points versus distinct letters, and branch
constancy.

#### A4 -- independent adversarial audit

Once Terra has a candidate proof, use a fresh Aristotle request to search for
circular imports, an unused or hidden hypothesis, and a counterexample. The
auditor may minimize assumptions but may not silently change the public
statement.

#### A5 -- source-image transport

Submit source transport only after its exact statement and permitted imports
are frozen locally. It is a separate request from A3 and A4.

#### A6 -- pair-interface and three-point extraction audit

Submit only the N23 bridge from a homogeneous three-point set to
`PairRamseyTriangle`, together with the infinite-homogeneous-set extraction,
using the existing `TriangleHost.Pair` and `TriangleHost.Triangle` finite
representations and exact universe parameters. Ask for a checked patch or
the smallest API obstruction; do not submit the Erdos--Rado theorem in this
call.

#### A7 -- pinned-Mathlib Erdos--Rado feasibility audit

Ask Aristotle to locate an existing usable theorem in the exact pinned
Mathlib version, or report precise missing declarations/files. It may not add
an axiom, replace countably many colours by finitely many, or claim a witness.
This feasibility result gates any full formalization request.

**A7 status (2026-07-16).** The completed feasibility audit found no usable
generic Erdos--Rado or cardinal partition-calculus API in the pinned
Mathlib snapshot. Treat `ErdosRado.lean` as a genuine new formalization task;
do not reopen the finite bridge or search for a nonexistent import.

#### A8 -- bounded special-case Erdos--Rado proof

Only after A6 and A7 freeze viable signatures, request the concrete
countably-coloured pair theorem for the chosen successor-of-continuum carrier.
Require either a strict-clean proof of the exact statement or a checked
minimal blocker. Keep the final N22 instantiation in a separate local commit.

Every Aristotle prompt must contain this package:

~~~text
Repository/commit: <exact public main SHA>
Target module: <exact new file>
Permitted imports: <explicit list>
Namespace and universes: <verbatim>
Target theorem statement: <verbatim Lean>
Permitted helper lemmas: at most 2--5, named or tightly scoped
Forbidden: sorry, admit, axiom, unsafe, native_decide, implemented_by,
  theorem weakening, unexplained hypotheses, resource-limit overrides,
  aggregate imports, and unrelated refactoring
Deliverables:
1. compilable Lean patch or source;
2. dependency and assumption summary;
3. exact explanation of any changed statement or obstruction;
4. focused verification command and #print axioms output.
~~~

For every return, Terra must compare quantifiers and conclusions, inspect new
assumptions and imports, scan for prohibited constructs, check for circular
dependencies, and compile under the repository's pinned Lean/mathlib toolchain.
An Aristotle success badge is not a local proof. Log the request ID, timestamp,
base SHA, returned files, local repairs, verification output, axiom result, and
accepted/rejected disposition in `ARISTOTLE_LOG.md`.

### Verification and delivery protocol

Run from `formalization/`. For each new module `<Module>`:

~~~text
lake env lean -DwarningAsError=true Erdos593/TripleSystem/<Module>.lean
lake build Erdos593.TripleSystem.<Module>
git diff --check
~~~

Also run the repository banned-construct scan on every changed Lean file,
generate a temporary audit module with `#print axioms` for each new public
theorem, and run:

~~~text
python scripts/generate_self_contained.py
python scripts/generate_self_contained.py --check
~~~

Never run the repository-wide forbidden `lake build`, `lake build Erdos593`,
or aggregate Lean checks on `Erdos593.lean` or
`Erdos593SelfContained.lean`.

Each stage is one reviewable commit. Update root imports and the focused CI
matrix only after its owner module is strict-clean. Push the audited commit to
`main`, monitor the resulting GitHub Actions run, and repair the exact failing
focused command before starting the next stage. Preserve unrelated worktree
changes.

### Cost and handoff point

- N14 wrappers: about 30--60 minutes, including audit.
- N15 branch API: about 1--3 hours.
- N15 cycle theorem or counterexample: about 4--12 hours and likely several
  Aristotle iterations.
- N16 endpoints: under one hour after N15 succeeds.
- N17 source transport: medium, statement to be frozen after the API audit.

Terra Max may execute N14 immediately and open A1 in parallel. It must pause
the unconditional N16 route at the N15 theorem-validity gate. That pause is
the next point for a human/Terra Ultra review if neither a proof nor a concrete
counterexample has emerged.

## External audit record

Aristotle request O29 independently audits this exact endpoint at public
commit `805d18c2bee543fdb00f1452559df42e890f3f5f`. Its status and result are
recorded in `ARISTOTLE_LOG.md`; a queued or completed external audit does not
alter the local proof or its stated scope.
