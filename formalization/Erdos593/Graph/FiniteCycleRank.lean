import Erdos593.Graph.FiniteForestCounting
import Mathlib.Data.Set.Card

/-! # Cycle rank of a finite simple graph

The edge set consists of unordered edges. The component type is the actual
reachability quotient, including isolated vertices. The spanning-forest theorem
below supplies the combinatorial interpretation of the Euler excess.
-/

namespace SimpleGraph.FiniteCycleRank

universe u

noncomputable def cycleRank {V : Type u} (G : SimpleGraph V) : ℕ :=
  Nat.card G.edgeSet + Nat.card G.ConnectedComponent - Nat.card V

theorem card_components_eq_of_reachable_eq {V : Type u}
    (G T : SimpleGraph V) (h : T.Reachable = G.Reachable) :
    Nat.card T.ConnectedComponent = Nat.card G.ConnectedComponent := by
  refine Nat.card_congr (FiniteForestCounting.componentEquivOfReachable
    T G id id ?_ ?_ (fun _ => .rfl) (fun _ => .rfl))
  · intro x y hxy
    change G.Reachable x y
    rw [← h]
    exact hxy.reachable
  · intro x y hxy
    change T.Reachable x y
    rw [h]
    exact hxy.reachable

theorem card_vertices_le_edges_add_components {V : Type u} [Finite V]
    (G : SimpleGraph V) :
    Nat.card V ≤ Nat.card G.edgeSet + Nat.card G.ConnectedComponent := by
  obtain ⟨T, hle, hforest, hreach⟩ := G.exists_isAcyclic_reachable_eq_le
  have ht := FiniteForestCounting.card_edges_add_components T hforest
  rw [card_components_eq_of_reachable_eq G T hreach] at ht
  have he : Nat.card T.edgeSet ≤ Nat.card G.edgeSet :=
    Set.ncard_le_ncard (edgeSet_mono hle)
  omega

theorem cycleRank_int {V : Type u} [Finite V] (G : SimpleGraph V) :
    (cycleRank G : ℤ) = (Nat.card G.edgeSet : ℤ) - (Nat.card V : ℤ) +
      (Nat.card G.ConnectedComponent : ℤ) := by
  rw [cycleRank, Nat.cast_sub (card_vertices_le_edges_add_components G), Nat.cast_add]
  omega

theorem cycleRank_eq_chords {V : Type u} [Finite V]
    (G T : SimpleGraph V) (hle : T ≤ G) (hforest : T.IsAcyclic)
    (hreach : T.Reachable = G.Reachable) :
    cycleRank G = Nat.card ↥(G.edgeSet \ T.edgeSet) := by
  have ht := FiniteForestCounting.card_edges_add_components T hforest
  rw [card_components_eq_of_reachable_eq G T hreach] at ht
  have he := Set.ncard_sdiff_add_ncard_of_subset (edgeSet_mono hle)
  change Nat.card ↥(G.edgeSet \ T.edgeSet) + Nat.card T.edgeSet = Nat.card G.edgeSet at he
  change Nat.card G.edgeSet + Nat.card G.ConnectedComponent - Nat.card V =
    Nat.card ↥(G.edgeSet \ T.edgeSet)
  omega

theorem cycleRank_eq_zero_iff {V : Type u} [Finite V] (G : SimpleGraph V) :
    cycleRank G = 0 ↔ G.IsAcyclic := by
  constructor
  · intro hz
    obtain ⟨T, hle, hforest, hreach⟩ := G.exists_isAcyclic_reachable_eq_le
    have ht := FiniteForestCounting.card_edges_add_components T hforest
    rw [card_components_eq_of_reachable_eq G T hreach] at ht
    have he : Nat.card G.edgeSet ≤ Nat.card T.edgeSet := by
      change Nat.card G.edgeSet + Nat.card G.ConnectedComponent - Nat.card V = 0 at hz
      omega
    have hsets : T.edgeSet = G.edgeSet :=
      Set.eq_of_subset_of_ncard_le (edgeSet_mono hle) he
    have hTG : T = G := edgeSet_injective hsets
    rw [← hTG]
    exact hforest
  · intro hforest
    have ht := FiniteForestCounting.card_edges_add_components G hforest
    change Nat.card G.edgeSet + Nat.card G.ConnectedComponent - Nat.card V = 0
    omega

end SimpleGraph.FiniteCycleRank
