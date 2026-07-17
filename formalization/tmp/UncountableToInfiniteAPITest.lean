import Erdos593.TripleSystem.CardinalPairPartition

namespace Erdos593

universe u

/-- Scratch validation of the cardinal-to-set-infinitude bridge. -/
theorem scratch_set_infinite_of_aleph0_lt_mk {α : Type u} {H : Set α}
    (hH : Cardinal.aleph0 < Cardinal.mk H) : H.Infinite := by
  intro hHfin
  exact hH.2 (Cardinal.lt_aleph0_iff_set_finite.mpr hHfin).le

end Erdos593
