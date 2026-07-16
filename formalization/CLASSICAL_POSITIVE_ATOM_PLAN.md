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

This is the sole missing input to turn the N22 route into an unconditional
nonlinearity obstruction. It is a real partition-calculus formalization, not
a library import or a permissible axiom. The pinned Mathlib snapshot has no
usable theorem that supplies the required countably-coloured pair relation.

**Exact target.** Construct a concrete type `kappa` with a proved cardinal
bound corresponding to the successor of the continuum, equip it with
`DecidableEq kappa`, and prove the existing interface without changing it:

~~~lean
TriangleHost.PairRamseyTriangle kappa
~~~

Equivalently, every `c : TriangleHost.Pair kappa -> Nat` must have a
`t : TriangleHost.Triangle kappa` such that all pair-faces `p q` satisfying
`p.1 ? t.1` and `q.1 ? t.1` have `c p = c q`. The theorem must be obtained
from an actual special case of the Erd?s--Rado theorem, with countably many
colours; replacing it by a finite-colour theorem is not sufficient.

**Module split.** Keep the external combinatorics separate from the current
host and transport code.

1. `CardinalPairPartition.lean` defines a small cardinal pair-colouring
   relation over the existing `Set.powersetCard kappa 2` representation and
   proves only the bridge from its homogeneous-three-point conclusion to
   `PairRamseyTriangle kappa`.
2. `ErdosRado.lean` chooses the concrete cardinal carrier only after a
   pinned-Mathlib feasibility audit confirms the exact constructor APIs. It
   formalizes the needed specialization of
   `(2^aleph0)^+ -> (aleph1)^2_{aleph0}`, then extracts three distinct
   points, packages them as `Set.powersetCard kappa 3`, and proves all three
   pair-faces homogeneous.
3. `TriangleHostRamseyUnconditional.lean` applies N22's existing
   `not_isObligatory_of_not_linear_of_exactTriangleHost` to that witness. It
   must not duplicate `reindex`, the ULift argument, or the finite-linearity
   proof.

**Non-goals and hard stop.** Do not claim an Erd?s--Rado witness, the full
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
`PairRamseyTriangle`, with the existing `Set.powersetCard` pair/triangle
representations and exact universe parameters. Ask for a checked patch or the
smallest API obstruction; do not submit the Erd?s--Rado theorem in this call.

#### A7 -- pinned-Mathlib Erd?s--Rado feasibility audit

Ask Aristotle to locate an existing usable theorem in the exact pinned
Mathlib version, or report precise missing declarations/files. It may not add
an axiom, replace countably many colours by finitely many, or claim a witness.
This feasibility result gates any full formalization request.

#### A8 -- bounded special-case Erd?s--Rado proof

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
