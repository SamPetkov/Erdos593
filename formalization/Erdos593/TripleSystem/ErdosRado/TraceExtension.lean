import Erdos593.TripleSystem.ErdosRado.CanonicalTrace

/-!
# Conditional successor extension for canonical traces

This module supplies only local, source-backed trace infrastructure: an empty
prefix seed below a non-minimal endpoint and an operation that appends an
already supplied candidate. It does not assert that arbitrary live prefixes
have candidates, and it does not construct a global trace.
-/

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

open scoped Cardinal Ordinal

/-- The canonical successor-cardinal trace carrier is nonempty. -/
noncomputable instance traceCarrierNonempty : Nonempty TraceCarrier :=
  Cardinal.nonempty_ord_toType (Cardinal.succ_ne_zero _)

/-- The canonical ordinal carrier has a least element. -/
noncomputable instance traceCarrierOrderBot : OrderBot TraceCarrier :=
  WellFoundedLT.toOrderBot TraceCarrier

local instance : IsEmpty (0 : Ordinal).ToType :=
  Ordinal.isEmpty_toType_iff.mpr rfl

namespace TracePrefix

/-- The empty trace prefix below a fixed endpoint. -/
noncomputable def empty (a : TraceCarrier) : TracePrefix a where
  length := 0
  length_le := bot_le
  node := fun i => isEmptyElim i
  node_lt_anchor := fun i => isEmptyElim i
  strictMono_node := by
    intro i
    exact isEmptyElim i

end TracePrefix

namespace TraceCandidate

/-- A non-minimal endpoint has a candidate for its empty prefix, namely the
least carrier point. This is an initial seed only, not a successor-existence
theorem for arbitrary prefixes. -/
theorem nonempty_empty_of_bot_lt (c : TraceColoring)
    {a : TraceCarrier} (ha : ⊥ < a) :
    Nonempty (TraceCandidate c (TracePrefix.empty a)) := by
  refine ⟨{
    live := by
      change (0 : Ordinal) < TraceHeight
      exact Cardinal.ord_pos.mpr (Cardinal.succ_pos _)
    value := ⊥
    lt_anchor := ha
    above_prefix := by
      intro i
      have hi : (i.toOrd : Ordinal) < 0 := by
        simpa [TracePrefix.empty] using i.toOrd.2
      exact (not_lt_of_ge bot_le hi).elim
    agrees := by
      intro i
      have hi : (i.toOrd : Ordinal) < 0 := by
        simpa [TracePrefix.empty] using i.toOrd.2
      exact (not_lt_of_ge bot_le hi).elim
  }⟩

end TraceCandidate

namespace TracePrefix

/-- The node map obtained by appending a supplied candidate value to a prefix. -/
noncomputable def snocNode {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    (Order.succ p.length).ToType → TraceCarrier := fun ξ ↦
  if hξ : (ξ.toOrd : Ordinal) < p.length then
    p.node (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩)
  else
    q.value

/-- Append a supplied live candidate to a trace prefix. This is conditional on
the candidate `q`; it does not establish a candidate for the new prefix. -/
noncomputable def snoc {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) : TracePrefix α where
  length := Order.succ p.length
  length_le := Order.succ_le_iff.mpr q.live
  node := p.snocNode q
  node_lt_anchor := by
    intro ξ
    by_cases hξ : (ξ.toOrd : Ordinal) < p.length
    · simpa [TracePrefix.snocNode, hξ] using
        p.node_lt_anchor (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩)
    · simpa [TracePrefix.snocNode, hξ] using q.lt_anchor
  strictMono_node := by
    intro ξ ζ hξζ
    have hOrd : (ξ.toOrd : Ordinal) < (ζ.toOrd : Ordinal) :=
      ((Ordinal.ToType.mk (o := Order.succ p.length)).symm.lt_iff_lt).mpr hξζ
    by_cases hx : (ξ.toOrd : Ordinal) < p.length
    · by_cases hy : (ζ.toOrd : Ordinal) < p.length
      · have hOld :
          (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hx⟩ : p.length.ToType) <
            Ordinal.ToType.mk ⟨(ζ.toOrd : Ordinal), hy⟩ :=
          (Ordinal.ToType.mk (o := p.length)).lt_iff_lt.mpr hOrd
        simpa [TracePrefix.snocNode, hx, hy] using p.strictMono_node hOld
      · simpa [TracePrefix.snocNode, hx, hy] using
          q.above_prefix (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hx⟩)
    · have hxle : (ξ.toOrd : Ordinal) ≤ p.length :=
        Order.lt_succ_iff.mp ξ.toOrd.2
      have hxEq : (ξ.toOrd : Ordinal) = p.length :=
        le_antisymm hxle (le_of_not_gt hx)
      have hyle : (ζ.toOrd : Ordinal) ≤ p.length :=
        Order.lt_succ_iff.mp ζ.toOrd.2
      have hcontra : p.length < (ζ.toOrd : Ordinal) := by
        simpa [hxEq] using hOrd
      exact (not_lt_of_ge hyle hcontra).elim

/-- At an index inherited from the old prefix, `snoc` keeps the old node. -/
theorem snoc_node_of_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (ξ : (Order.succ p.length).ToType)
    (hξ : (ξ.toOrd : Ordinal) < p.length) :
    (p.snoc q).node ξ =
      p.node (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩) := by
  simp [TracePrefix.snoc, TracePrefix.snocNode, hξ]

/-- At the newly added index, `snoc` has the supplied candidate value. -/
theorem snoc_node_of_not_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (ξ : (Order.succ p.length).ToType)
    (hξ : ¬ (ξ.toOrd : Ordinal) < p.length) :
    (p.snoc q).node ξ = q.value := by
  simp [TracePrefix.snoc, TracePrefix.snocNode, hξ]

end TracePrefix

namespace TraceCandidate

/-- Any candidate for an appended prefix retains the required colour agreement
against every node of the original prefix. This theorem remains conditional on
the appended-prefix candidate `r`. -/
theorem exists_agrees_snoc_old {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) (ξ : p.length.ToType) :
    ∃ h : p.node ξ < r.value,
      c (tracePair (p.node ξ) r.value (ne_of_lt h)) =
        c (tracePair (p.node ξ) α (ne_of_lt (p.node_lt_anchor ξ))) := by
  have hξsucc : (ξ.toOrd : Ordinal) < Order.succ p.length :=
    Order.lt_succ_iff.mpr (le_of_lt ξ.toOrd.2)
  let ξ' : (Order.succ p.length).ToType :=
    Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξsucc⟩
  have hnode : (p.snoc q).node ξ' = p.node ξ := by
    simp [ξ', TracePrefix.snoc, TracePrefix.snocNode]
    intro hle
    exact (not_lt_of_ge hle ξ.toOrd.2).elim
  have hlt : p.node ξ < r.value := by
    rw [← hnode]
    exact r.above_prefix ξ'
  refine ⟨hlt, ?_⟩
  simpa [hnode] using r.agrees ξ'

end TraceCandidate

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
