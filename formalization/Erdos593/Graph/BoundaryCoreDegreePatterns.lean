import Erdos593.Graph.TwoConnectedBipartiteSpectrum

/-!
# Low-rank degree patterns for two-vertex-connected cores

These lemmas expose the finite degree bookkeeping used at the atomic lower
boundary.  They are statements about the actual graph and its actual degree
function; no cycle/theta representation is inserted as a premise.

Candidate source for local pinned Lean replay.
-/

namespace SimpleGraph.TwoConnectedBipartiteSpectrum

open scoped Classical

universe u

/-- A finite two-vertex-connected graph of cycle rank one is literally
2-regular.  Bipartiteness is not needed for this degree conclusion. -/
theorem rank_one_degree_eq_two {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 1) :
    ∀ x : V, G.degree x = 2 := by
  classical
  have hEuler := connected_cycleRank_euler G (two_connected_connected G htwo)
  have hedge : Nat.card G.edgeSet = Nat.card V := by omega
  have hdegrees : ∀ x, 2 ≤ G.degree x := by
    intro x
    have h := two_connected_min_degree G htwo x
    simpa only [Nat.card_eq_fintype_card, G.card_neighborSet_eq_degree] using h
  have hsum : (∑ x : V, G.degree x) = ∑ _x : V, (2 : ℕ) := by
    calc
      (∑ x : V, G.degree x) = 2 * G.edgeFinset.card :=
        G.sum_degrees_eq_twice_card_edges
      _ = 2 * Nat.card V := by
        rw [G.edgeFinset_card, ← Nat.card_eq_fintype_card, hedge]
      _ = ∑ _x : V, (2 : ℕ) := by
        simp [Nat.card_eq_fintype_card, mul_comm]
  intro x
  by_contra hx
  have hlt : 2 < G.degree x := by have := hdegrees x; omega
  have hstrict : (∑ _y : V, (2 : ℕ)) < ∑ y : V, G.degree y :=
    Finset.sum_lt_sum (fun y _ => hdegrees y) ⟨x, Finset.mem_univ x, hlt⟩
  omega

/-- At cycle rank two the total excess above minimum degree two is exactly two. -/
theorem rank_two_degree_excess_sum {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 2) :
    ∑ x : V, (G.degree x - 2) = 2 := by
  classical
  have hEuler := connected_cycleRank_euler G (two_connected_connected G htwo)
  have hedge : Nat.card G.edgeSet = Nat.card V + 1 := by omega
  have hdegrees : ∀ x, 2 ≤ G.degree x := by
    intro x
    have h := two_connected_min_degree G htwo x
    simpa only [Nat.card_eq_fintype_card, G.card_neighborSet_eq_degree] using h
  have hsumdeg : (∑ x : V, G.degree x) = 2 * (Nat.card V + 1) := by
    calc
      _ = 2 * G.edgeFinset.card := G.sum_degrees_eq_twice_card_edges
      _ = 2 * Nat.card G.edgeSet := by rw [G.edgeFinset_card, Nat.card_eq_fintype_card]
      _ = 2 * (Nat.card V + 1) := by rw [hedge]
  have hsplit :
      (∑ x : V, (G.degree x - 2)) + (∑ _x : V, (2 : ℕ)) =
        ∑ x : V, G.degree x := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro x _
    have := hdegrees x
    omega
  have htwoSum : (∑ _x : V, (2 : ℕ)) = 2 * Nat.card V := by
    simp [Nat.card_eq_fintype_card, mul_comm]
  rw [htwoSum, hsumdeg] at hsplit
  omega

/-- The rank-two degree excess has only the two elementary possibilities:
one degree-four vertex, or two degree-three vertices.  The later
2-connectivity argument rules out the first alternative at the odd atomic
lower boundary. -/
theorem rank_two_degree_pattern {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 2) :
    (∃ x : V, G.degree x = 4 ∧ ∀ y : V, y ≠ x → G.degree y = 2) ∨
    (∃ x y : V, x ≠ y ∧ G.degree x = 3 ∧ G.degree y = 3 ∧
      ∀ z : V, z ≠ x → z ≠ y → G.degree z = 2) := by
  classical
  have hdegrees : ∀ x, 2 ≤ G.degree x := by
    intro x
    have h := two_connected_min_degree G htwo x
    simpa only [Nat.card_eq_fintype_card, G.card_neighborSet_eq_degree] using h
  have hsum := rank_two_degree_excess_sum G htwo hr
  have hupper : ∀ x, G.degree x ≤ 4 := by
    intro x
    have hx : G.degree x - 2 ≤ ∑ y : V, (G.degree y - 2) :=
      Finset.single_le_sum (f := fun y : V => G.degree y - 2)
        (fun _ _ => Nat.zero_le _) (Finset.mem_univ x)
    rw [hsum] at hx
    have := hdegrees x
    omega
  by_cases hfour : ∃ x : V, G.degree x = 4
  · obtain ⟨x, hx⟩ := hfour
    left
    refine ⟨x, hx, ?_⟩
    have hxex : G.degree x - 2 = 2 := by omega
    have herase := Finset.sum_erase_add (Finset.univ : Finset V)
      (fun y => G.degree y - 2) (Finset.mem_univ x)
    have hrest : ∑ y ∈ (Finset.univ.erase x), (G.degree y - 2) = 0 := by
      rw [hxex] at herase
      omega
    intro y hy
    have hymem : y ∈ (Finset.univ.erase x) := Finset.mem_erase.mpr ⟨hy, Finset.mem_univ y⟩
    have hyzero := (Finset.sum_eq_zero_iff.mp hrest) y hymem
    have := hdegrees y
    omega
  · right
    let D : Finset V := Finset.univ.filter (fun x => G.degree x = 3)
    have h23 : ∀ x : V, G.degree x = 2 ∨ G.degree x = 3 := by
      intro x
      have hlo := hdegrees x
      have hhi := hupper x
      have hn4 : G.degree x ≠ 4 := fun hx => hfour ⟨x, hx⟩
      omega
    have hcard : D.card = 2 := by
      have hrewrite : (∑ x : V, (G.degree x - 2)) = D.card := by
        calc
          _ = ∑ x : V, if G.degree x = 3 then 1 else 0 := by
            apply Finset.sum_congr rfl
            intro x _
            rcases h23 x with hx | hx
            · simp [hx]
            · simp [hx]
          _ = D.card := by simp [D]
      rw [hrewrite] at hsum
      exact hsum
    obtain ⟨x, y, hxy, hD⟩ := Finset.card_eq_two.mp hcard
    have hxD : x ∈ D := by rw [hD]; simp
    have hyD : y ∈ D := by rw [hD]; simp
    have hx3 : G.degree x = 3 := (Finset.mem_filter.mp hxD).2
    have hy3 : G.degree y = 3 := (Finset.mem_filter.mp hyD).2
    refine ⟨x, y, hxy, hx3, hy3, ?_⟩
    intro z hzx hzy
    rcases h23 z with hz | hz
    · exact hz
    · have hzD : z ∈ D := Finset.mem_filter.mpr ⟨Finset.mem_univ z, hz⟩
      rw [hD] at hzD
      simp only [Finset.mem_insert, Finset.mem_singleton] at hzD
      exact (hzD.elim hzx hzy).elim

end SimpleGraph.TwoConnectedBipartiteSpectrum
