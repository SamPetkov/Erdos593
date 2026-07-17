import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceGraph
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportBranchGeometry

namespace Erdos593

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}

private theorem rotated_cycle_boundary_points
    {S : Set (Edge G)}
    {v : activeBaseNodeIndex S ⊕ activeBaseFiberSupportPointIndex S}
    {q : activeBaseNodeIndex S}
    (c : (baseFiberSupportIncidenceGraph S).Walk v v)
    (hc : c.IsCycle)
    (hq : Sum.inl q ∈ c.support) :
    ∃ r : (baseFiberSupportIncidenceGraph S).Walk (Sum.inl q) (Sum.inl q),
      r.IsCycle ∧
      ∃ pL pR : activeBaseFiberSupportPointIndex S,
        r.snd = Sum.inr pL ∧
        r.penultimate = Sum.inr pR ∧
        (baseFiberSupportIncidenceGraph S).Adj (Sum.inl q) (Sum.inr pL) ∧
        (baseFiberSupportIncidenceGraph S).Adj (Sum.inr pR) (Sum.inl q) ∧
        pL ≠ pR := by
  classical
  let r := c.rotate (Sum.inl q) hq
  have hr : r.IsCycle := hc.rotate hq
  have hrne : ¬ r.Nil := hr.not_nil
  have hsnd : (baseFiberSupportIncidenceGraph S).Adj (Sum.inl q) r.snd :=
    r.adj_snd hrne
  have hpen : (baseFiberSupportIncidenceGraph S).Adj r.penultimate (Sum.inl q) :=
    r.adj_penultimate hrne
  have hne : r.snd ≠ r.penultimate := hr.snd_ne_penultimate
  refine ⟨r, hr, ?_⟩
  cases hs : r.snd with
  | inl q' =>
      rw [hs] at hsnd
      exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hsnd).elim
  | inr pL =>
      cases hp : r.penultimate with
      | inl q' =>
          rw [hp] at hpen
          exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hpen).elim
      | inr pR =>
          refine ⟨pL, pR, rfl, rfl, ?_, ?_, ?_⟩
          · simpa [hs] using hsnd
          · simpa [hp] using hpen
          · intro hpLR
            apply hne
            calc
              r.snd = Sum.inr pL := hs
              _ = Sum.inr pR := congrArg Sum.inr hpLR
              _ = r.penultimate := hp.symm

/-- A rotated incidence cycle based at a fibre vertex has point-side immediate
neighbors and fibre-side vertices one step further along each orientation. -/
private theorem rotated_cycle_boundary_nodes
    {S : Set (Edge G)}
    {v : activeBaseNodeIndex S ⊕ activeBaseFiberSupportPointIndex S}
    {q : activeBaseNodeIndex S}
    (c : (baseFiberSupportIncidenceGraph S).Walk v v)
    (hc : c.IsCycle)
    (hq : Sum.inl q ∈ c.support) :
    ∃ r : (baseFiberSupportIncidenceGraph S).Walk (Sum.inl q) (Sum.inl q),
      r.IsCycle ∧
      ∃ pL pR : activeBaseFiberSupportPointIndex S,
      ∃ uL uR : activeBaseNodeIndex S,
        r.snd = Sum.inr pL ∧
        r.getVert 2 = Sum.inl uL ∧
        r.getVert (r.length - 2) = Sum.inl uR ∧
        r.penultimate = Sum.inr pR ∧
        (baseFiberSupportIncidenceGraph S).Adj (Sum.inl q) (Sum.inr pL) ∧
        (baseFiberSupportIncidenceGraph S).Adj (Sum.inr pL) (Sum.inl uL) ∧
        (baseFiberSupportIncidenceGraph S).Adj (Sum.inl uR) (Sum.inr pR) ∧
        (baseFiberSupportIncidenceGraph S).Adj (Sum.inr pR) (Sum.inl q) ∧
        pL ≠ pR ∧ uL ≠ q ∧ uR ≠ q := by
  classical
  rcases rotated_cycle_boundary_points c hc hq with
    ⟨r, hr, pL, pR, hs, hp, hqL, hpRq, hpLR⟩
  have hlen : 3 ≤ r.length := hr.three_le_length
  have hLadj : (baseFiberSupportIncidenceGraph S).Adj (Sum.inr pL) (r.getVert 2) := by
    rw [← hs]
    exact r.adj_getVert_succ (i := 1) (by omega)
  have hRadj : (baseFiberSupportIncidenceGraph S).Adj
      (r.getVert (r.length - 2)) (Sum.inr pR) := by
    rw [← hp]
    have hindex : r.length - 2 + 1 = r.length - 1 := by omega
    change (baseFiberSupportIncidenceGraph S).Adj
      (r.getVert (r.length - 2)) (r.getVert (r.length - 1))
    rw [← hindex]
    exact r.adj_getVert_succ (i := r.length - 2) (by omega)
  cases hL : r.getVert 2 with
  | inr p =>
      rw [hL] at hLadj
      exact (not_baseFiberSupportIncidenceGraph_adj_inr_inr hLadj).elim
  | inl uL =>
      cases hR : r.getVert (r.length - 2) with
      | inr p =>
          rw [hR] at hRadj
          exact (not_baseFiberSupportIncidenceGraph_adj_inr_inr hRadj).elim
      | inl uR =>
          refine ⟨r, hr, pL, pR, uL, uR, hs, hL, hR, hp,
            hqL, ?_, ?_, hpRq, hpLR, ?_, ?_⟩
          · simpa [hL] using hLadj
          · simpa [hR] using hRadj
          · intro huL
            have hEq : r.getVert 2 = Sum.inl q := by
              calc
                r.getVert 2 = Sum.inl uL := hL
                _ = Sum.inl q := congrArg Sum.inl huL
            have hEnds := (hr.getVert_endpoint_iff (i := 2) (by omega)).mp hEq
            omega

          · intro huR
            have hEq : r.getVert (r.length - 2) = Sum.inl q := by
              calc
                r.getVert (r.length - 2) = Sum.inl uR := hR
                _ = Sum.inl q := congrArg Sum.inl huR
            have hEnds :=
              (hr.getVert_endpoint_iff (i := r.length - 2) (by omega)).mp hEq
            omega

end SequenceLift

end Erdos593
