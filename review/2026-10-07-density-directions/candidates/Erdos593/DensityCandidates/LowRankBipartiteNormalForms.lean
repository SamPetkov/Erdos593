import Erdos593.Graph.ThetaRecognition

/-!
# The complete parity boundary at low cyclic rank

For an actual finite two-vertex-connected bipartite graph, cycle rank at most
two gives an even cycle or a theta graph whose three actual paths are all even
or all odd. No model presentation is assumed. In particular, the odd-theta
case is retained; it is not removed by an odd-order hypothesis.

This is a candidate structural bridge for the density argument. It does not
formalize the Sidorenko inequality for either theta parity, the private-
expansion density identity, or the higher-uniformity canonical atom theorem.
No compilation or kernel acceptance is asserted.
-/

namespace Erdos593.DensityCandidates.LowRankBipartiteNormalForms

open SimpleGraph

universe u

/-- Two-connectivity makes the actual cycle rank positive. This is proved from
the actual degree sum and the connected Euler balance, not assumed. -/
theorem cycleRank_pos_of_two_connected
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G) :
    1 ≤ SimpleGraph.FiniteCycleRank.cycleRank G := by
  classical
  have hdegree : ∀ x : V, 2 ≤ G.degree x := by
    intro x
    have h := TwoConnectedBipartiteSpectrum.two_connected_min_degree G htwo x
    simpa only [Nat.card_eq_fintype_card, G.card_neighborSet_eq_degree] using h
  have hcount : 2 * Nat.card V ≤ 2 * Nat.card G.edgeSet := by
    calc
      2 * Nat.card V = ∑ _x : V, (2 : ℕ) := by
        simp [Nat.card_eq_fintype_card, mul_comm]
      _ ≤ ∑ x : V, G.degree x := Finset.sum_le_sum (fun x _ => hdegree x)
      _ = 2 * G.edgeFinset.card := G.sum_degrees_eq_twice_card_edges
      _ = 2 * Nat.card G.edgeSet := by
        rw [G.edgeFinset_card, ← Nat.card_eq_fintype_card]
  have hEuler := TwoConnectedBipartiteSpectrum.connected_cycleRank_euler G
    (TwoConnectedBipartiteSpectrum.two_connected_connected G htwo)
  omega

/-- A two-colouring gives the same parity to all three paths with the same
two endpoints, regardless of the order of the ambient graph. -/
theorem three_paths_uniform_parity
    {V : Type u} (G : SimpleGraph V) {a b : V}
    (P : E593Theta.ThreePaths G a b) (hb : G.Colorable 2) :
    (∀ i : Fin 3, Even (P.path i).length) ∨
      (∀ i : Fin 3, Odd (P.path i).length) := by
  obtain ⟨c⟩ := hb
  have hpar : ∀ i j : Fin 3,
      Even (P.path i).length ↔ Even (P.path j).length := by
    intro i j
    exact (E593Theta.two_colour_walk_parity c (P.path i)).trans
      (E593Theta.two_colour_walk_parity c (P.path j)).symm
  rcases Nat.even_or_odd (P.path 0).length with hzero | hzero
  · exact Or.inl (fun i => (hpar 0 i).mp hzero)
  · right
    intro i
    apply Nat.not_even_iff_odd.mp
    intro hi
    have hz : Even (P.path 0).length := (hpar 0 i).mpr hi
    exact (Nat.not_even_iff_odd.mpr hzero) hz

/-- Actual rank-two recognition together with both parity cases. The positive
lengths, the no-duplicate-direct-edge restriction, the exact original carrier
count, and a genuine graph isomorphism are all conclusions. -/
theorem rank_two_bipartite_iso_theta_parity
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hb : G.Colorable 2) (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 2) :
    ∃ r : Fin 3 → ℕ, (∀ i, 0 < r i) ∧
      (∀ i j, r i = 1 → r j = 1 → i = j) ∧
      ((∀ i, Even (r i)) ∨ (∀ i, Odd (r i))) ∧
      (∑ i : Fin 3, r i) = Nat.card V + 1 ∧
      Nonempty (G ≃g E593Theta.thetaGraph r) := by
  classical
  obtain ⟨a, b, ⟨P⟩⟩ := E593Theta.rank_two_three_paths G htwo hr
  refine ⟨P.lengths, P.length_pos, ?_, ?_, P.sum_lengths,
    ⟨P.modelIso.symm⟩⟩
  · intro i j hi hj
    exact P.at_most_one_direct i j hi hj
  · exact three_paths_uniform_parity G P hb

/-- Complete low-rank normal form for an actual two-connected bipartite core.
Rank zero is excluded by the proved degree/Euler argument. In the rank-one
case the cycle has at least four vertices; in the rank-two case either theta
parity is retained. No Sidorenko conclusion is hidden in this statement. -/
theorem low_rank_bipartite_normal_form
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hb : G.Colorable 2) (hr : SimpleGraph.FiniteCycleRank.cycleRank G ≤ 2) :
    (∃ t : ℕ, 2 ≤ t ∧ Nat.card V = 2 * t ∧
      Nonempty (G ≃g SimpleGraph.cycleGraph (2 * t))) ∨
    (∃ r : Fin 3 → ℕ, (∀ i, 0 < r i) ∧
      (∀ i j, r i = 1 → r j = 1 → i = j) ∧
      ((∀ i, Even (r i)) ∨ (∀ i, Odd (r i))) ∧
      (∑ i : Fin 3, r i) = Nat.card V + 1 ∧
      Nonempty (G ≃g E593Theta.thetaGraph r)) := by
  have hpos := cycleRank_pos_of_two_connected G htwo
  have hcases : SimpleGraph.FiniteCycleRank.cycleRank G = 1 ∨
      SimpleGraph.FiniteCycleRank.cycleRank G = 2 := by omega
  rcases hcases with hone | htwoRank
  · exact Or.inl
      (TwoConnectedBipartiteSpectrum.bipartite_rank_one_even_cycle G htwo hb hone)
  · exact Or.inr (rank_two_bipartite_iso_theta_parity G htwo hb htwoRank)

end Erdos593.DensityCandidates.LowRankBipartiteNormalForms
