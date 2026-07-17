import Erdos593.TripleSystem.ErdosRado.CanonicalTree

namespace Erdos593.TripleSystem.TriangleHost.ErdosRado

open scoped Cardinal Ordinal

noncomputable def TracePrefix.snocNode {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    (Order.succ p.length).ToType → TraceCarrier := fun ξ ↦
  if hξ : (ξ.toOrd : Ordinal) < p.length then
    p.node (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩)
  else
    q.value

noncomputable def TracePrefix.snoc {c : TraceColoring} {α : TraceCarrier}
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

theorem TracePrefix.snoc_node_of_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (ξ : (Order.succ p.length).ToType)
    (hξ : (ξ.toOrd : Ordinal) < p.length) :
    (p.snoc q).node ξ =
      p.node (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩) := by
  simp [TracePrefix.snoc, TracePrefix.snocNode, hξ]

theorem TracePrefix.snoc_node_of_not_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (ξ : (Order.succ p.length).ToType)
    (hξ : ¬ (ξ.toOrd : Ordinal) < p.length) :
    (p.snoc q).node ξ = q.value := by
  simp [TracePrefix.snoc, TracePrefix.snocNode, hξ]

theorem TraceCandidate.exists_agrees_snoc_old {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) (ξ : p.length.ToType) :
    ∃ h : p.node ξ < r.value,
      c (tracePair (p.node ξ) r.value (ne_of_lt h)) =
        c (tracePair (p.node ξ) α (ne_of_lt (p.node_lt_anchor ξ))) := by
  have hξsucc : (ξ.toOrd : Ordinal) < Order.succ p.length :=
    Order.lt_succ_iff.mpr (le_of_lt ξ.toOrd.2)
  have hξold : (ξ.toOrd : Ordinal) < p.length := ξ.toOrd.2
  let ξ' : (Order.succ p.length).ToType :=
    Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξsucc⟩
  have hnode : (p.snoc q).node ξ' = p.node ξ := by
    have hξold' : (ξ'.toOrd : Ordinal) < p.length := by
      change (ξ.toOrd : Ordinal) < p.length
      exact hξold
    rw [TracePrefix.snoc_node_of_lt p q ξ' hξold']
    apply congrArg p.node
    simpa [ξ'] using
      (Ordinal.ToType.mk (o := p.length)).apply_symm_apply ξ
  have hlt : p.node ξ < r.value := by
    rw [← hnode]
    exact r.above_prefix ξ'
  refine ⟨hlt, ?_⟩
  simpa [hnode] using r.agrees ξ'

end Erdos593.TripleSystem.TriangleHost.ErdosRado
