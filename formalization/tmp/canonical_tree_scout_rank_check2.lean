import Erdos593.TripleSystem.ErdosRado.CanonicalTrace
import Mathlib.SetTheory.Ordinal.Rank

namespace Erdos593.TripleSystem.TriangleHost.ErdosRado.TmpRankCheck2

structure MiniTrace (c : TraceColoring) where
  height : TraceCarrier → Ordinal
  node : ∀ (α : TraceCarrier) {η : Ordinal}, η < height α → TraceCarrier
  node_lt_anchor : ∀ (α : TraceCarrier) {η : Ordinal} (hη : η < height α),
    node α hη < α
  coherent_height : ∀ (α : TraceCarrier) {η : Ordinal} (hη : η < height α),
    height (node α hη) = η

namespace MiniTrace

variable {c : TraceColoring} (T : MiniTrace c)

def Predecessor (β α : TraceCarrier) : Prop :=
  ∃ (η : Ordinal) (hη : η < T.height α), T.node α hη = β

theorem predecessor_lt {β α : TraceCarrier} (h : T.Predecessor β α) : β < α := by
  rcases h with ⟨η, hη, rfl⟩
  exact T.node_lt_anchor _ hη

theorem predecessor_wellFounded : WellFounded T.Predecessor := by
  refine wellFounded_lt.mono ?_
  intro a b hab
  exact T.predecessor_lt hab

noncomputable def treeRank (α : TraceCarrier) : Ordinal :=
  @IsWellFounded.rank TraceCarrier T.Predecessor
    { wf := T.predecessor_wellFounded } α

theorem treeRank_lt_of_predecessor {β α : TraceCarrier}
    (h : T.Predecessor β α) : T.treeRank β < T.treeRank α := by
  letI : IsWellFounded TraceCarrier T.Predecessor :=
    { wf := T.predecessor_wellFounded }
  exact IsWellFounded.rank_lt_of_rel h

theorem treeRank_eq_iSup (α : TraceCarrier) :
    T.treeRank α =
      ⨆ β : {β : TraceCarrier // T.Predecessor β α},
        Order.succ (T.treeRank β) := by
  unfold treeRank
  letI : IsWellFounded TraceCarrier T.Predecessor :=
    { wf := T.predecessor_wellFounded }
  exact IsWellFounded.rank_eq _ _

theorem treeRank_eq_height (α : TraceCarrier) :
    T.treeRank α = T.height α := by
  refine (wellFounded_lt : WellFounded (fun x y : TraceCarrier => x < y)).induction α ?_
  intro α ih
  apply le_antisymm
  · rw [T.treeRank_eq_iSup α]
    apply Ordinal.iSup_le
    rintro ⟨β, hβ⟩
    rcases hβ with ⟨η, hη, rfl⟩
    rw [ih _ (T.node_lt_anchor α hη), T.coherent_height α hη]
    exact Order.succ_le_iff.mpr hη
  · by_contra hnot
    have hrank_lt_height : T.treeRank α < T.height α :=
      lt_of_not_ge hnot
    have hnode_lt : T.node α hrank_lt_height < α :=
      T.node_lt_anchor α hrank_lt_height
    have hpred : T.Predecessor (T.node α hrank_lt_height) α :=
      ⟨T.treeRank α, hrank_lt_height, rfl⟩
    have hdown := T.treeRank_lt_of_predecessor hpred
    rw [ih _ hnode_lt, T.coherent_height α hrank_lt_height] at hdown
    exact (lt_irrefl _ hdown)

end MiniTrace

end Erdos593.TripleSystem.TriangleHost.ErdosRado.TmpRankCheck2
