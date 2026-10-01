import Erdos593.Graph.ThetaGraphModel
import Erdos593.Graph.ThetaPathRecognition

/-! # Unconditional rank-two graph recognition endpoints. Candidate source. -/

namespace E593Theta

open SimpleGraph

universe u

variable {V : Type u} [Fintype V] [DecidableEq V]
variable {G : SimpleGraph V} [DecidableRel G.Adj]

omit [DecidableEq V] [DecidableRel G.Adj] in
/-- Literal rank-two recognition with positive lengths, the no-duplicate-direct-
edge restriction, exact vertex count, and a genuine graph isomorphism. -/
theorem rank_two_iso_theta (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 2) :
    ∃ r : Fin 3 → ℕ, (∀ i, 0 < r i) ∧
      (∀ i j, r i = 1 → r j = 1 → i = j) ∧
      (∑ i : Fin 3, r i) = Nat.card V + 1 ∧
      Nonempty (G ≃g thetaGraph r) := by
  obtain ⟨a, b, ⟨P⟩⟩ := rank_two_three_paths G htwo hr
  exact ⟨P.lengths, P.length_pos, P.at_most_one_direct, P.sum_lengths, ⟨P.modelIso.symm⟩⟩

omit [DecidableEq V] [DecidableRel G.Adj] in
/-- The even-theta model at odd order. Its three even path lengths are conclusions. -/
theorem rank_two_odd_bipartite_iso_theta (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 2)
    (hb : G.Colorable 2) (hodd : Odd (Nat.card V)) :
    ∃ r : Fin 3 → ℕ, (∀ i, 0 < r i) ∧ (∀ i, Even (r i)) ∧
      (∑ i : Fin 3, r i) = Nat.card V + 1 ∧
      Nonempty (G ≃g thetaGraph r) := by
  obtain ⟨a, b, ⟨P⟩⟩ := rank_two_three_paths G htwo hr
  exact ⟨P.lengths, P.length_pos, P.even_lengths_of_odd_card hb hodd,
    P.sum_lengths, ⟨P.modelIso.symm⟩⟩

end E593Theta
