import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceGraph
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportBranchGeometry

namespace Erdos593

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}

/-- Propagation of a fixed branch along an alternating incidence walk.  This
scratch statement is deliberately cycle-free, so it can be reused after the
cycle has been cut at its two boundary points. -/
private theorem extendsBy_along_incidence_walk
    {S : Set (Edge G)} {q : Node G} {a : Alphabet G}
    {u v : activeBaseNodeIndex S}
    (hqu : q.ExtendsBy a u.1)
    (r : (baseFiberSupportIncidenceGraph S).Walk (Sum.inl u) (Sum.inl v))
    (hmin : ∀ z : activeBaseNodeIndex S, Sum.inl z ∈ r.support →
      q.length ≤ z.1.length)
    (hneq : ∀ z : activeBaseNodeIndex S, Sum.inl z ∈ r.support →
      q ≠ z.1) :
    q.ExtendsBy a v.1 := by
  let rec go (n : ℕ) {u v : activeBaseNodeIndex S}
      (r : (baseFiberSupportIncidenceGraph S).Walk (Sum.inl u) (Sum.inl v))
      (hqu : q.ExtendsBy a u.1)
      (hlen : r.length ≤ n)
      (hmin : ∀ z : activeBaseNodeIndex S, Sum.inl z ∈ r.support →
        q.length ≤ z.1.length)
      (hneq : ∀ z : activeBaseNodeIndex S, Sum.inl z ∈ r.support →
        q ≠ z.1) : q.ExtendsBy a v.1 := by
    cases r with
    | nil =>
        simpa using hqu
    | @cons _ w _ h₁ r =>
        cases hmid : w with
        | inl w =>
            rw [hmid] at h₁
            exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl h₁).elim
        | inr p =>
            subst w
            cases r with
            | @cons _ w₂ _ h₂ r₂ =>
                cases hnext : w₂ with
                | inr p₂ =>
                    rw [hnext] at h₂
                    exact (not_baseFiberSupportIncidenceGraph_adj_inr_inr h₂).elim
                | inl y =>
                    subst w₂
                    have hpu : p.1 ∈ (system G).edgeSupportSet (baseFiber S u.1) :=
                      (baseFiberSupportIncidenceGraph_adj_inl_inr_iff).mp h₁
                    have hpy : p.1 ∈ (system G).edgeSupportSet (baseFiber S y.1) :=
                      (baseFiberSupportIncidenceGraph_adj_inr_inl_iff).mp h₂
                    have hqy : q.ExtendsBy a y.1 :=
                      Node.extendsBy_of_common_support_of_le hqu
                        (hmin y (by simp)) (hneq y (by simp)) hpu hpy
                    cases n with
                    | zero =>
                        simp only [SimpleGraph.Walk.length_cons] at hlen
                        omega
                    | succ n =>
                        exact go n r₂ hqy (by
                          simp only [SimpleGraph.Walk.length_cons] at hlen
                          omega)
                          (fun z hz => hmin z (by simp [hz]))
                          (fun z hz => hneq z (by simp [hz]))
  termination_by n
  exact go r.length r hqu (by rfl) hmin hneq

end SequenceLift

end Erdos593
