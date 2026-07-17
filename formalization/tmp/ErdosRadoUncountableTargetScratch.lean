import Erdos593.TripleSystem.ErdosRadoCarrier
import Mathlib.SetTheory.Cardinal.Basic

namespace Erdos593
namespace TripleSystem
namespace TriangleHost

def ErdosRadoUncountableHomogeneousPairSet : Prop :=
  ∀ c : Pair ErdosRadoCarrier → ℕ, ∃ H : Set ErdosRadoCarrier,
    Cardinal.aleph0 < Cardinal.mk H ∧ PairHomogeneous c H

theorem erdosRadoHomogeneousPairSet_of_uncountable
    (h : ErdosRadoUncountableHomogeneousPairSet) :
    ErdosRadoHomogeneousPairSet := by
  intro c
  obtain ⟨H, hH, hmono⟩ := h c
  refine ⟨H, ?_, hmono⟩
  exact Set.infinite_coe_iff.mp (Cardinal.aleph0_le_mk_iff.mp hH.le)

end TriangleHost
end TripleSystem
end Erdos593
