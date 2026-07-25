import Mathlib.Tactic.Ring

/-!
# Uniform parameter arithmetic

The finite bridge-block theorem reduces the numerical statements to bipartite
shadows.  These identities isolate the uniformity-dependent shift from the
uniformity-independent cycle rank.
-/

namespace Erdos593

namespace UniformSystem

/-- The Levi cycle-rank identity for an `r`-uniform incidence system. -/
theorem leviCycleRank_identity (r m n c : ℤ) :
    r * m - (n + m) + c = (r - 1) * m - n + c := by
  ring

/-- Substituting `n = (r-2)m + s` removes the uniformity from the cycle rank. -/
theorem shiftedCycleRank_identity (r m s c : ℤ) :
    (r - 1) * m - ((r - 2) * m + s) + c = m - s + c := by
  ring

/-- The upper order endpoint is exactly the zero-cycle-rank endpoint. -/
theorem forestEndpoint_identity (r m c : ℤ) :
    (r - 1) * m - ((r - 1) * m + c) + c = 0 := by
  ring

end UniformSystem

end Erdos593
