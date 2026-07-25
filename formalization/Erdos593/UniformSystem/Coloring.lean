import Erdos593.UniformSystem.Basic

/-!
# Weak colourings of uniform systems
-/

namespace Erdos593

universe u v w

namespace UniformSystem

variable {r : ℕ} {V : Type u} {E : Type v} (F : UniformSystem r V E)

/-- A vertex colouring is proper when every hyperedge contains two points of
different colours. -/
def IsProperColoring {C : Type w} (c : V → C) : Prop :=
  ∀ e : E, ∃ x : V, F.Inc x e ∧ ∃ y : V, F.Inc y e ∧ c x ≠ c y

end UniformSystem

end Erdos593
