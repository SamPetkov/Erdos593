import Erdos593.TripleSystem.ErdosRado.CanonicalTree

namespace Erdos593.TripleSystem.TriangleHost.ErdosRado

open scoped Cardinal Ordinal

#check Ordinal.ToType.mk
#check Ordinal.ToType.toOrd
#check Order.succ_le_iff
#check Cardinal.nonempty_ord_toType
#check Cardinal.succ_ne_zero
#check Cardinal.succ_pos
#check Cardinal.ord_pos
#check WellFoundedLT.toOrderBot

noncomputable local instance : Nonempty TraceCarrier :=
  Cardinal.nonempty_ord_toType (Cardinal.succ_ne_zero _)

noncomputable local instance : OrderBot TraceCarrier :=
  WellFoundedLT.toOrderBot TraceCarrier

local instance : IsEmpty (0 : Ordinal).ToType :=
  Ordinal.isEmpty_toType_iff.mpr rfl

noncomputable def emptyPrefix (a : TraceCarrier) : TracePrefix a where
  length := 0
  length_le := bot_le
  node := fun i => isEmptyElim i
  node_lt_anchor := fun i => isEmptyElim i
  strictMono_node := by
    intro i
    exact isEmptyElim i

theorem candidate_empty_of_bot_lt (c : TraceColoring) {a : TraceCarrier}
    (ha : ⊥ < a) : Nonempty (TraceCandidate c (emptyPrefix a)) := by
  refine ⟨{
    live := by
      change (0 : Ordinal) < TraceHeight
      exact Cardinal.ord_pos.mpr (Cardinal.succ_pos _)
    value := ⊥
    lt_anchor := ha
    above_prefix := by
      intro i
      have hi : (i.toOrd : Ordinal) < 0 := by
        simpa [emptyPrefix] using i.toOrd.2
      exact (not_lt_of_ge bot_le hi).elim
    agrees := by
      intro i
      have hi : (i.toOrd : Ordinal) < 0 := by
        simpa [emptyPrefix] using i.toOrd.2
      exact (not_lt_of_ge bot_le hi).elim
  }⟩

end Erdos593.TripleSystem.TriangleHost.ErdosRado
