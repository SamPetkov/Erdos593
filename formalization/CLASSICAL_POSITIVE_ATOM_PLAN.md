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
bipartiteness or constructibility. Cross-fibre intersection geometry and a
running assembly are later, separately scoped stages; the concise status
row is recorded in `FORMALIZATION_MAP.md`.

## External audit record

Aristotle request O29 independently audits this exact endpoint at public
commit `805d18c2bee543fdb00f1452559df42e890f3f5f`. Its status and result are
recorded in `ARISTOTLE_LOG.md`; a queued or completed external audit does not
alter the local proof or its stated scope.
