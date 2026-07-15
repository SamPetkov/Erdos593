import Erdos593.TripleSystem.Expansion

/-!
# Forward properties of private-vertex expansions

The generator side of the finite structural theorem starts with the elementary
intrinsic properties of the private-vertex expansion of a simple graph.
-/

namespace Erdos593

universe u

namespace TripleSystem

/-- Distinct expanded graph edges meet in at most one point. -/
-- ARISTOTLE_TARGET F1
theorem privateVertexExpansion_linear {V : Type u}
    (G : _root_.SimpleGraph V) :
    (privateVertexExpansion G).Linear := by
  unfold TripleSystem.Linear
  intro e f x y
  simp [privateVertexExpansion] at *
  cases x <;> cases y <;>
    simp_all +decide [PrivateVertexExpansion.Inc]
  all_goals grind +suggestions

end TripleSystem

end Erdos593
