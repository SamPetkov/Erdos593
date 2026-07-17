import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportBranchGeometry
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceGraph

namespace Erdos593.SequenceLift

#check Function.argminOn
#check Function.argminOn_mem
#check Function.argminOn_le
#check SimpleGraph.Walk.rotate
#check SimpleGraph.Walk.mem_support_rotate_iff
#check SimpleGraph.Walk.IsCycle.getVert_endpoint_iff
#check SimpleGraph.Walk.getVert_mem_support
#check SimpleGraph.Walk.mem_support_iff_exists_getVert
#check SimpleGraph.Walk.IsCycle.getVert_injOn
#check Nat.even_or_odd
#check Nat.even_or_odd'
#check baseLetter_injOn_baseFiber_of_linear
#check eq_of_same_baseNode_baseLetter_of_mem_of_linear
#check Node.letter_eq_of_extendsBy_same_target
#check SimpleGraph.Walk.getVert_zero
#check SimpleGraph.Walk.getVert_length
#check SimpleGraph.Walk.getVert_one

private theorem incidence_getVert_even_is_node
    {S : Set (Edge G)} {q : activeBaseNodeIndex S}
    (r : (baseFiberSupportIncidenceGraph S).Walk (.inl q) (.inl q)) :
    ∀ k : ℕ, 2 * k ≤ r.length →
      ∃ u : activeBaseNodeIndex S, r.getVert (2 * k) = .inl u := by
  intro k
  induction k with
  | zero =>
      intro _
      exact ⟨q, by simp⟩
  | succ k ih =>
      intro hk
      have hbound : 2 * k + 2 ≤ r.length := by
        convert hk using 1
        all_goals omega
      rcases ih (by omega) with ⟨u, hu⟩
      have hmid : (baseFiberSupportIncidenceGraph S).Adj
          (.inl u) (r.getVert (2 * k + 1)) := by
        have hadj := r.adj_getVert_succ (i := 2 * k) (by omega)
        simpa [hu] using hadj
      cases hm : r.getVert (2 * k + 1) with
      | inl w =>
          rw [hm] at hmid
          exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hmid).elim
      | inr p =>
          have hnext : (baseFiberSupportIncidenceGraph S).Adj
              (.inr p) (r.getVert (2 * (k + 1))) := by
            rw [← hm]
            have hsuc : 2 * k + 1 < r.length := by omega
            have hadj := r.adj_getVert_succ (i := 2 * k + 1) hsuc
            have hindex : 2 * k + 1 + 1 = 2 * (k + 1) := by omega
            rw [hindex] at hadj
            exact hadj
          cases hn : r.getVert (2 * (k + 1)) with
          | inl w => exact ⟨w, rfl⟩
          | inr p' =>
              rw [hn] at hnext
              exact (not_baseFiberSupportIncidenceGraph_adj_inr_inr hnext).elim

private theorem incidence_cycle_length_even
    {S : Set (Edge G)} {q : activeBaseNodeIndex S}
    (r : (baseFiberSupportIncidenceGraph S).Walk (.inl q) (.inl q))
    (hr : r.IsCycle) :
    ∃ n : ℕ, r.length = 2 * n := by
  rcases Nat.even_or_odd' r.length with ⟨n, hn | hn⟩
  · exact ⟨n, hn⟩
  · have hle : 2 * n ≤ r.length := by omega
    rcases incidence_getVert_even_is_node r n hle with ⟨u, hu⟩
    have hadj := r.adj_getVert_succ (i := 2 * n) (by omega)
    have hend : r.getVert (2 * n + 1) = (.inl q :
        activeBaseNodeIndex S ⊕ activeBaseFiberSupportPointIndex S) := by
      rw [← hn]
      exact r.getVert_length
    rw [hu, hend] at hadj
    exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hadj).elim

end Erdos593.SequenceLift
