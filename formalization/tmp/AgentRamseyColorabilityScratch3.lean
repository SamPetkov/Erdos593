import Erdos593.TripleSystem.TriangleHostLinearity
import Erdos593.TripleSystem.Obligatory

namespace Erdos593

universe u

namespace TripleSystem
namespace TriangleHost

/-- A minimal Ramsey hypothesis: every natural colouring of the pair-vertices
has a triangle whose three pair-faces receive one common colour. -/
def RamseyNat (K : Type u) [DecidableEq K] : Prop :=
  forall c : Pair K -> Nat, exists t : Triangle K,
    forall p q : Pair K,
      p.1 ⊆ t.1 -> q.1 ⊆ t.1 -> c p = c q

/-- Under `RamseyNat`, the triangle host has no proper natural colouring. -/
theorem not_isProperColoring_nat_of_ramseyNat
    (K : Type u) [DecidableEq K]
    (hRamsey : RamseyNat K) (c : Pair K -> Nat) :
    ¬ (system K).IsProperColoring c := by
  intro hc
  obtain ⟨t, ht⟩ := hRamsey c
  rcases hc t with ⟨x, hx, y, hy, hxy⟩
  apply hxy
  exact ht x y hx hy

/-- The host has no natural proper colouring under `RamseyNat`. -/
theorem no_natProperColoring_of_ramseyNat
    (K : Type u) [DecidableEq K]
    (hRamsey : RamseyNat K) :
    ¬ ∃ c : Pair K -> Nat, (system K).IsProperColoring c := by
  rintro ⟨c, hc⟩
  exact not_isProperColoring_nat_of_ramseyNat K hRamsey c hc

end TriangleHost
end TripleSystem
end Erdos593
