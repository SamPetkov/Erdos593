import Erdos593.TripleSystem.HighPairGraph
import Erdos593.TripleSystem.HighPairMatrix

namespace Erdos593

universe u v

namespace TripleSystem

theorem audit_exists_witnessedBipartiteMatrix_of_quadratic_highPair
    {W : Type u} {D : Type v} [DecidableEq W]
    {H : TripleSystem W D} {n : Nat}
    (left right : Fin n ↪ W)
    (hhigh : ∀ i j,
      HighPair H (2 * n + n * n) (left i) (right j)) :
    ∃ M : WitnessedBipartiteMatrix H n 2, M.left = left ∧ M.right = right := by
  apply exists_witnessedBipartiteMatrix_of_quadratic_pairCodegree left right
  · intro i j
    exact (hhigh i j).1
  · intro ij
    exact Classical.choice (hhigh ij.1 ij.2).2

end TripleSystem

end Erdos593
