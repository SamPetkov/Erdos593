import Mathlib.Combinatorics.SimpleGraph.Matching
import Mathlib.Combinatorics.SimpleGraph.Hamiltonian
import Mathlib.Combinatorics.SimpleGraph.CycleGraph
import Mathlib.Data.Fintype.EquivFin
import Mathlib.Tactic

/-!
# Recognizing a finite connected 2-regular graph

A cycle is first obtained on the whole connected component. A spanning copy of
`cycleGraph` is then upgraded to an isomorphism by surjectivity on each actual
neighbor set. Thus a Hamiltonian cycle alone is NOT used to exclude chords.

Candidate source: pinned compilation and the transitive axiom audit are required.
-/

namespace E593Boundary

open SimpleGraph

universe u v

/-- Equal finite vertex counts and equal local degrees upgrade a graph copy to
an isomorphism. The neighbor-set argument supplies reflection of adjacency. -/
theorem copy_isomorphism_of_card_and_degrees
    {V : Type u} {W : Type v} [Fintype V] [Fintype W]
    (G : SimpleGraph V) (H : SimpleGraph W)
    [DecidableRel G.Adj] [DecidableRel H.Adj]
    (f : G.Copy H) (hcard : Fintype.card V = Fintype.card W)
    (hdeg : ∀ x, G.degree x = H.degree (f x)) :
    Nonempty (G ≃g H) := by
  classical
  have hbij : Function.Bijective f :=
    (Fintype.bijective_iff_injective_and_card f).mpr ⟨f.injective, hcard⟩
  have hreflect : ∀ x y, H.Adj (f x) (f y) → G.Adj x y := by
    intro x y hxy
    have hlocal : Function.Surjective (f.mapNeighborSet x) := by
      apply Function.Bijective.surjective
      apply (Fintype.bijective_iff_injective_and_card _).mpr
      refine ⟨(f.mapNeighborSet x).injective, ?_⟩
      simpa only [G.card_neighborSet_eq_degree, H.card_neighborSet_eq_degree]
        using hdeg x
    obtain ⟨z, hz⟩ := hlocal ⟨f y, hxy⟩
    have hzy : (z : V) = y := f.injective (congrArg Subtype.val hz)
    exact hzy ▸ z.property
  refine ⟨{ toEquiv := Equiv.ofBijective f hbij, map_rel_iff' := ?_ }⟩
  intro x y
  exact ⟨hreflect x y, fun h => f.toHom.map_adj h⟩

/-- The 2-regular degree hypothesis implies Mathlib's graph-of-cycles predicate. -/
theorem isCycles_of_degree_eq_two
    {V : Type u} [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj]
    (hd : ∀ x, G.degree x = 2) : G.IsCycles := by
  intro x _
  change Nat.card (G.neighborSet x) = 2
  rw [Nat.card_eq_fintype_card, G.card_neighborSet_eq_degree]
  exact hd x

/-- A finite connected 2-regular graph contains a Hamiltonian cycle based at
any specified vertex. Its support is proved to cover the original carrier. -/
theorem two_regular_hamiltonian_cycle
    {V : Type u} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj]
    (hc : G.Connected) (hd : ∀ x, G.degree x = 2) (v : V) :
    ∃ p : G.Walk v v, p.IsHamiltonianCycle := by
  have hcyc := isCycles_of_degree_eq_two G hd
  have hn : (G.neighborSet v).Nonempty := by
    obtain ⟨w, hw⟩ := (G.degree_pos_iff_exists_adj v).mp (by rw [hd]; decide)
    exact ⟨w, hw⟩
  obtain ⟨p, hp, hverts⟩ :=
    hcyc.exists_cycle_toSubgraph_verts_eq_connectedComponentSupp
      (c := G.connectedComponentMk v) (v := v) rfl hn
  have hall : ∀ x : V, x ∈ p.support := by
    intro x
    rw [← p.mem_verts_toSubgraph, hverts]
    exact SimpleGraph.ConnectedComponent.sound (hc.preconnected x v)
  have htail : p.tail.IsHamiltonian := by
    apply hp.isPath_tail.isHamiltonian_of_mem
    intro x
    have hx := hall x
    rw [← SimpleGraph.Walk.cons_support_tail hp.not_nil, List.mem_cons] at hx
    rcases hx with rfl | hx
    · exact p.tail.end_mem_support
    · exact hx
  exact ⟨p, ⟨hp, htail⟩⟩

/-- Actual isomorphism, not just containment, with the cycle on all vertices. -/
theorem connected_two_regular_iso_cycleGraph
    {V : Type u} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj]
    (hc : G.Connected) (hd : ∀ x, G.degree x = 2) :
    Nonempty (G ≃g SimpleGraph.cycleGraph (Fintype.card V)) := by
  obtain ⟨v⟩ := hc.nonempty
  obtain ⟨p, hp⟩ := two_regular_hamiltonian_cycle G hc hd v
  have hn : 3 ≤ Fintype.card V := by
    have hh := hp.isCycle.three_le_length
    rw [hp.length_eq] at hh
    exact hh
  obtain ⟨f⟩ := (SimpleGraph.cycleGraph_isContained_iff (by omega :
    2 < Fintype.card V)).mpr ⟨v, p, hp.isCycle, hp.length_eq⟩
  have hcd : ∀ x : Fin (Fintype.card V),
      (SimpleGraph.cycleGraph (Fintype.card V)).degree x = 2 := by
    intro x
    generalize hN : Fintype.card V = n at hn x ⊢
    obtain ⟨r, hr⟩ := Nat.exists_eq_add_of_le hn
    have hnr : n = r + 3 := by omega
    subst hnr
    exact SimpleGraph.cycleGraph_degree_three_le
  obtain ⟨i⟩ := copy_isomorphism_of_card_and_degrees
    (SimpleGraph.cycleGraph (Fintype.card V)) G f (by simp)
    (fun x => (hcd x).trans (hd (f x)).symm)
  exact ⟨i.symm⟩

end E593Boundary
