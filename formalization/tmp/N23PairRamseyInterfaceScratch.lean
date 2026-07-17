import Erdos593.TripleSystem.TriangleHostRamsey

/-!
# N23 scratch: a three-point homogeneous-pair interface

This untracked prototype isolates the small finite conversion that an
Erdos--Rado implementation must supply.  It intentionally proves no
partition-calculus result and introduces no axioms.
-/

namespace Erdos593

universe u v

namespace TripleSystem
namespace TriangleHost

/-- Every `C`-colouring of two-element subsets admits three distinct points
whose contained pair-faces have a common colour. -/
def HomogeneousThreePointPairColoring
    (κ : Type u) [DecidableEq κ] (C : Type v) : Prop :=
  ∀ c : Pair κ → C, ∃ a b d : κ,
    a ≠ b ∧ a ≠ d ∧ b ≠ d ∧
      ∀ p q : Pair κ,
        p.1 ⊆ ({a, b, d} : Finset κ) →
        q.1 ⊆ ({a, b, d} : Finset κ) →
        c p = c q

/-- The homogeneous-three-point interface, specialized to natural colours,
is exactly the existing triangle-host Ramsey interface. -/
theorem pairRamseyTriangle_of_homogeneousThreePoint
    (κ : Type u) [DecidableEq κ]
    (h : HomogeneousThreePointPairColoring κ ℕ) :
    PairRamseyTriangle κ := by
  intro c
  obtain ⟨a, b, d, hab, had, hbd, hc⟩ := h c
  refine ⟨⟨{a, b, d}, by simp [hab, had, hbd]⟩, ?_⟩
  intro p q hp hq
  exact hc p q hp hq

end TriangleHost
end TripleSystem
end Erdos593
