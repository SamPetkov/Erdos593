import Erdos593.Graph.TwoVertexCycleSplice

namespace Erdos593
namespace SimpleGraph

set_option autoImplicit false

/-!
# Publication refinement: a literal edge as a cycle chord

This module isolates the singleton-incidence case needed by the later
quotient cycle-block intersection theorem.  It does not mention quotient
blocks or construct the block-cut incidence forest.
-/

/-- If an actual edge is exactly the unordered pair of two distinct vertices
on a simple cycle, then that edge and every selected cycle edge lie together
on a simple cycle. -/
theorem edgesOnCommonCycle_of_edge_endpoints_and_cycle
    {V : Type*} (G : _root_.SimpleGraph V)
    {e g : G.edgeSet} {x y v : V} {c : G.Walk v v}
    (hc : c.IsCycle) (hxy : x ≠ y)
    (hexy : e.1 = s(x, y))
    (hx : x ∈ c.support) (hy : y ∈ c.support)
    (hg : g.1 ∈ c.edges) :
    EdgesOnCommonCycle G e g := by
  open _root_.SimpleGraph in
  classical
  by_cases hec : e.1 ∈ c.edges
  · exact ⟨v, c, hc, hec, hg⟩
  have hadj : G.Adj x y := by
    have he := e.2
    rw [hexy] at he
    exact he
  obtain ⟨s, t, hst, hrot⟩ :
      ∃ (s : G.Walk x v) (t : G.Walk v x), t.append s = c ∧ (s.append t).IsCycle :=
    ⟨c.dropUntil x hx, c.takeUntil x hx, c.take_spec hx, hc.rotate hx⟩
  have hedges : ∀ z : Sym2 V, z ∈ (s.append t).edges ↔ z ∈ c.edges := by
    intro z
    rw [← hst, Walk.edges_append, Walk.edges_append, List.mem_append, List.mem_append]
    tauto
  have hy' : y ∈ (s.append t).support := by
    rw [← hst, Walk.mem_support_append_iff] at hy
    rw [Walk.mem_support_append_iff]
    tauto
  have hec' : e.1 ∉ (s.append t).edges := fun h => hec ((hedges _).mp h)
  have hgc' : g.1 ∈ (s.append t).edges := (hedges _).mpr hg
  obtain ⟨p, q, hpq, hp⟩ :
      ∃ (p : G.Walk x y) (q : G.Walk y x), p.append q = s.append t ∧ p.IsPath :=
    ⟨(s.append t).takeUntil y hy', (s.append t).dropUntil y hy',
      (s.append t).take_spec hy', hrot.isPath_takeUntil hy'⟩
  have hcyc : (p.append q).IsCycle := by rw [hpq]; exact hrot
  have hq : q.IsPath := hcyc.isPath_of_append_right (Walk.not_nil_of_ne hxy)
  have hmem : ∀ z : Sym2 V, z ∈ (s.append t).edges ↔ z ∈ p.edges ∨ z ∈ q.edges := by
    intro z
    rw [← hpq, Walk.edges_append, List.mem_append]
  rcases (hmem _).mp hgc' with hgp | hgq
  · have hnot : s(y, x) ∉ p.edges := fun h =>
      hec' ((hmem _).mpr (Or.inl (by rwa [hexy, Sym2.eq_swap])))
    refine ⟨y, Walk.cons hadj.symm p, (Walk.cons_isCycle_iff _ _).mpr ⟨hp, hnot⟩, ?_, ?_⟩
    · simp [Walk.edges_cons, hexy, Sym2.eq_swap]
    · simp [Walk.edges_cons, hgp]
  · have hnot : s(x, y) ∉ q.edges := fun h =>
      hec' ((hmem _).mpr (Or.inr (by rwa [hexy])))
    refine ⟨x, Walk.cons hadj q, (Walk.cons_isCycle_iff _ _).mpr ⟨hq, hnot⟩, ?_, ?_⟩
    · simp [Walk.edges_cons, hexy]
    · simp [Walk.edges_cons, hgq]

end SimpleGraph
end Erdos593
