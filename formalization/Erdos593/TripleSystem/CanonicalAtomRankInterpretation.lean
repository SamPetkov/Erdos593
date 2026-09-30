import Erdos593.Graph.FiniteCycleRank
import Erdos593.TripleSystem.CanonicalAtomCounting

/-! # Actual cycle ranks of canonical atoms

The existing finite Euler identities supply the rank interpretation and
additivity. This module does not assert the full canonical atom-count spectrum.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem atomLeviEuler_eq_cycleRank
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (A : Index F) :
    atomLeviEuler F hlinear hbridge A =
      (_root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge A).levi : ℤ) := by
  exact (_root_.SimpleGraph.FiniteCycleRank.cycleRank_int
    (atomRestriction F hlinear hbridge A).levi).symm

theorem sum_atom_cycleRank
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    (∑ A ∈ atomFinset F hlinear hbridge,
      _root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge A).levi) =
      _root_.SimpleGraph.FiniteCycleRank.cycleRank F.levi := by
  classical
  have h := levi_euler_eq_sum_atomLeviEuler F hlinear hbridge
  rw [← _root_.SimpleGraph.FiniteCycleRank.cycleRank_int F.levi] at h
  simp_rw [atomLeviEuler_eq_cycleRank F hlinear hbridge] at h
  exact_mod_cast h.symm

end Erdos593.TripleSystem.CanonicalAtom
