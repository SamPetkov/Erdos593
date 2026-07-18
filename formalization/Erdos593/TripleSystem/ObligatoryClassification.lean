import Erdos593.TripleSystem.TriangleHostRamseyUnconditional
import Erdos593.TripleSystem.SequenceLiftMissingBridgeUnconditional
import Erdos593.TripleSystem.ShiftGraphBergeObstruction
import Erdos593.TripleSystem.ConstructiblePositiveObligatory

/-!
# Finite obligatory triple-system classification

The theorem is deliberately stated through the isolated reduction.
-/

namespace Erdos593

universe u

namespace TripleSystem

/-- A finite triple system is obligatory exactly when its isolated reduction
satisfies the intrinsic structural conditions. -/
theorem isObligatory_iff_isolatedReduction_intrinsic
    {V E : Type u} (F : TripleSystem V E) [Fintype V] [Fintype E] :
    F.IsObligatory ↔ F.isolatedReduction.Intrinsic := by
  constructor
  · intro hF
    have hlinear : F.Linear := by
      by_contra hn
      exact (not_isObligatory_of_not_linear F hn) hF
    refine ⟨F.isolatedReduction_linear hlinear, ?_, ?_⟩
    · by_contra hbridge
      exact (not_isObligatory_of_linear_of_not_isolatedReduction_bridgeAtEveryEdge
        F hlinear hbridge) hF
    · by_contra hberge
      exact (SequenceLift.not_isObligatory_of_linear_of_not_isolatedReduction_evenBergeCycles_shiftHost
        F hlinear hberge) hF
  · exact intrinsic_isolatedReduction_isObligatory F

/-- Equivalent constructive form, still correctly phrased on the isolated
reduction. -/
theorem isObligatory_iff_constructible_isolatedReduction
    {V E : Type u} (F : TripleSystem V E) [Fintype V] [Fintype E] :
    F.IsObligatory ↔ Constructible F.isolatedReduction := by
  rw [isObligatory_iff_isolatedReduction_intrinsic]
  classical
  letI : DecidableEq V := Classical.decEq V
  letI : DecidableEq E := Classical.decEq E
  exact (BridgeBlock.isolatedReduction_constructible_iff_intrinsic F).symm

end TripleSystem

end Erdos593
