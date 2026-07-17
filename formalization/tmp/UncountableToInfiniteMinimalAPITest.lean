import Mathlib.SetTheory.Cardinal.Basic

universe u

theorem scratch_type_infinite_of_aleph0_lt_mk {H : Type u}
    (hH : Cardinal.aleph0 < Cardinal.mk H) : Infinite H := by
  exact Cardinal.aleph0_le_mk_iff.mp hH.1

theorem scratch_set_infinite_of_aleph0_lt_mk {α : Type u} {H : Set α}
    (hH : Cardinal.aleph0 < Cardinal.mk H) : H.Infinite := by
  intro hHfin
  exact hH.2 (Cardinal.lt_aleph0_iff_set_finite.mpr hHfin).le
