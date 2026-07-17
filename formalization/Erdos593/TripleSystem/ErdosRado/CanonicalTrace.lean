import Erdos593.TripleSystem.ErdosRadoCarrier

/-!
# Canonical ordinal carrier for the Erdos--Rado trace

This module provides a canonical carrier plus local data interfaces needed by
a later trace construction. It proves no partition relation, candidate
existence, coherent recursion, or global trace.
-/

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

/-- The initial ordinal whose cardinality is the successor of the continuum. -/
noncomputable abbrev TraceCarrier : Type :=
  (Order.succ (Cardinal.continuum : Cardinal)).ord.ToType

/-- The trace carrier has the desired successor-of-continuum cardinality. -/
theorem mk_traceCarrier :
    Cardinal.mk TraceCarrier = Order.succ (Cardinal.continuum : Cardinal) := by
  exact Cardinal.mk_ord_toType _

/-- Reindex the existing carrier onto the canonical ordinal carrier.
Choice is used only to obtain an equivalence from their proven equal cardinalities. -/
noncomputable def erdosRadoCarrierEquivTraceCarrier :
    Equiv ErdosRadoCarrier TraceCarrier :=
  Classical.choice <|
    Cardinal.eq.mp (mk_erdosRadoCarrier.trans mk_traceCarrier.symm)

/-- The canonical initial ordinal of cardinality `aleph1`, the trace-height cutoff. -/
noncomputable abbrev TraceHeight : Ordinal :=
  (Order.succ (Cardinal.aleph0 : Cardinal)).ord

/-- The trace-height carrier has the desired first-uncountable cardinality. -/
theorem mk_traceHeight :
    Cardinal.mk TraceHeight.ToType = Order.succ (Cardinal.aleph0 : Cardinal) := by
  exact Cardinal.mk_ord_toType _

/-- The first-uncountable trace cutoff is closed under ordinal successor. -/
theorem succ_lt_traceHeight {o : Ordinal} (ho : o < TraceHeight) :
    Order.succ o < TraceHeight := by
  exact (Cardinal.isSuccLimit_ord
    (Order.le_succ (Cardinal.aleph0))).succ_lt ho

/-- Classical decidable equality for the canonical trace carrier. -/
noncomputable instance traceCarrierDecidableEq : DecidableEq TraceCarrier :=
  Classical.decEq _

/-- The genuine two-element face determined by distinct carrier points. -/
noncomputable def tracePair (x y : TraceCarrier) (hxy : x ≠ y) :
    Pair TraceCarrier :=
  ⟨{x, y}, by simp [hxy]⟩

/-- Reversing distinct endpoints leaves their two-element face unchanged. -/
theorem tracePair_comm (x y : TraceCarrier) (hxy : x ≠ y) :
    tracePair x y hxy = tracePair y x hxy.symm := by
  apply Subtype.ext
  ext z
  simp [tracePair, eq_comm, or_comm]

/-- A colouring of two-element faces of the canonical trace carrier. -/
abbrev TraceColoring := Pair TraceCarrier → ℕ

/-- A strictly increasing ordinal-indexed prefix below an endpoint, whose
length is at most the source trace-height cutoff. -/
structure TracePrefix (α : TraceCarrier) where
  length : Ordinal
  length_le : length ≤ TraceHeight
  node : length.ToType → TraceCarrier
  node_lt_anchor : ∀ ξ, node ξ < α
  strictMono_node : StrictMono node

namespace TracePrefix

/-- A prefix node is strictly below its endpoint. -/
theorem node_ne_anchor {α : TraceCarrier} (p : TracePrefix α)
    (ξ : p.length.ToType) : p.node ξ ≠ α :=
  ne_of_lt (p.node_lt_anchor ξ)

/-- Strict monotonicity makes the ordinal-indexed prefix injective. -/
theorem node_injective {α : TraceCarrier} (p : TracePrefix α) :
    Function.Injective p.node :=
  p.strictMono_node.injective

/-- Earlier indices map to strictly earlier trace nodes. -/
theorem node_lt_node {α : TraceCarrier} (p : TracePrefix α)
    {ξ ζ : p.length.ToType} (h : ξ < ζ) : p.node ξ < p.node ζ :=
  p.strictMono_node h

/-- Distinct indices name distinct trace nodes. -/
theorem node_ne_node {α : TraceCarrier} (p : TracePrefix α)
    {ξ ζ : p.length.ToType} (h : ξ ≠ ζ) : p.node ξ ≠ p.node ζ :=
  fun hnode => h (p.strictMono_node.injective hnode)

/-- Every earlier trace node sees every later node in the same colour as it
sees the distinguished endpoint. -/
def EndhomogeneousTo {α : TraceCarrier} (p : TracePrefix α)
    (c : TraceColoring) : Prop :=
  ∀ ⦃ξ ζ : p.length.ToType⦄ (h : ξ < ζ),
    c (tracePair (p.node ξ) (p.node ζ)
      (ne_of_lt (p.node_lt_node h))) =
      c (tracePair (p.node ξ) α (ne_of_lt (p.node_lt_anchor ξ)))

end TracePrefix

/-- A candidate extending a live prefix below its endpoint with the prescribed
pair-colour agreements. This data alone asserts no candidate existence. -/
structure TraceCandidate (c : TraceColoring) {α : TraceCarrier}
    (p : TracePrefix α) where
  live : p.length < TraceHeight
  value : TraceCarrier
  lt_anchor : value < α
  above_prefix : ∀ ξ, p.node ξ < value
  agrees : ∀ ξ,
    c (tracePair (p.node ξ) value (ne_of_lt (above_prefix ξ))) =
      c (tracePair (p.node ξ) α (ne_of_lt (p.node_lt_anchor ξ)))

namespace TraceCandidate

/-- Each prefix node is strictly below a candidate extending that prefix. -/
theorem node_lt_value {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (q : TraceCandidate c p) (ξ : p.length.ToType) :
    p.node ξ < q.value :=
  q.above_prefix ξ

/-- A candidate value is distinct from every prefix node. -/
theorem node_ne_value {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (q : TraceCandidate c p) (ξ : p.length.ToType) :
    p.node ξ ≠ q.value :=
  ne_of_lt (q.above_prefix ξ)

/-- A candidate value is distinct from its endpoint. -/
theorem value_ne_anchor {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (q : TraceCandidate c p) : q.value ≠ α :=
  ne_of_lt q.lt_anchor

/-- The values realized by candidates extending a fixed trace prefix. -/
def valueSet (c : TraceColoring) {α : TraceCarrier} (p : TracePrefix α) :
    Set TraceCarrier :=
  {x | ∃ q : TraceCandidate c p, q.value = x}

theorem valueSet_nonempty {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (h : Nonempty (TraceCandidate c p)) :
    (valueSet c p).Nonempty := by
  rcases h with ⟨q⟩
  exact ⟨q.value, q, rfl⟩

/-- The least ordinal value among candidates for a nonempty prefix extension problem. -/
noncomputable def leastValue {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (h : Nonempty (TraceCandidate c p)) : TraceCarrier :=
  WellFounded.min wellFounded_lt (valueSet c p) (valueSet_nonempty h)

theorem leastValue_mem {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (h : Nonempty (TraceCandidate c p)) :
    leastValue h ∈ valueSet c p := by
  exact WellFounded.min_mem wellFounded_lt (valueSet c p) (valueSet_nonempty h)

/-- The least candidate in the canonical ordinal order, conditional on existence. -/
noncomputable def least {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (h : Nonempty (TraceCandidate c p)) : TraceCandidate c p :=
  Classical.choose (leastValue_mem h)

theorem least_value {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (h : Nonempty (TraceCandidate c p)) :
    (least h).value = leastValue h :=
  Classical.choose_spec (leastValue_mem h)

theorem not_lt_least_value {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (h : Nonempty (TraceCandidate c p))
    (q : TraceCandidate c p) : ¬ q.value < (least h).value := by
  rw [least_value]
  exact WellFounded.not_lt_min wellFounded_lt (valueSet c p) ⟨q, rfl⟩

theorem least_value_le {c : TraceColoring} {α : TraceCarrier}
    {p : TracePrefix α} (h : Nonempty (TraceCandidate c p))
    (q : TraceCandidate c p) : (least h).value ≤ q.value := by
  exact le_of_not_gt (not_lt_least_value h q)

/-- A terminal prefix admits no live candidate. -/
theorem not_nonempty_of_length_eq_traceHeight
    {c : TraceColoring} {α : TraceCarrier} (p : TracePrefix α)
    (hp : p.length = TraceHeight) : ¬ Nonempty (TraceCandidate c p) := by
  rintro ⟨q⟩
  have h := q.live
  rw [hp] at h
  exact lt_irrefl _ h

end TraceCandidate

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
