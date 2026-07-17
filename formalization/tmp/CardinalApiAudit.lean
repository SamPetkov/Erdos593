import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Pigeonhole

/-!
Scratch API audit for the N24 cardinal-counting layer.  This file is deliberately
outside the production library and may be discarded after the audit.
-/

open Set

namespace CardinalApiAudit

open Cardinal

#check Cardinal.lt_aleph_one_iff
#check Cardinal.aleph_one_le_continuum
#check Cardinal.two_power_aleph0
#check Cardinal.mk_arrow
#check Cardinal.mk_iUnion_le
#check Cardinal.mk_iUnion_le_lift
#check Cardinal.isRegular_aleph_one
#check Cardinal.infinite_pigeonhole_card
#check Cardinal.mul_eq_right
#check Cardinal.power_le_power_left
#check Cardinal.power_le_power_right
#check Cardinal.lift_power
#check Cardinal.lift_aleph0
#check Cardinal.lift_continuum
#check Cardinal.lift_le
#check Cardinal.lift_lt
#check Cardinal.lift_le_aleph0
#check Cardinal.aleph0_lt_lift
#check Cardinal.lift_mk_le'
#check Cardinal.lift_id
#check Cardinal.lift_id'
#check Cardinal.mk_subtype_le
#check Cardinal.mk_subtype_mono

/-! The base-universe code-space estimate used at each countable level. -/
theorem mk_fun_nat_le_continuum {ρ : Ordinal.{0}}
    (hρ : ρ.card < Cardinal.aleph 1) :
    Cardinal.mk (ρ.ToType → Nat) ≤ Cardinal.continuum := by
  rw [Cardinal.mk_arrow, Cardinal.mk_nat, Cardinal.lift_id, Cardinal.lift_id]
  rw [Cardinal.mk_toType]
  calc
    Cardinal.aleph0 ^ ρ.card ≤ Cardinal.aleph0 ^ Cardinal.aleph0 :=
      Cardinal.power_le_power_left Cardinal.aleph0_ne_zero
        (Cardinal.lt_aleph_one_iff.mp hρ)
    _ = Cardinal.continuum := Cardinal.aleph0_power_aleph0

/-! A universe-polymorphic version: `mk_arrow` itself introduces the needed lifts. -/
theorem mk_fun_nat_le_continuum_universe {α : Type u}
    (hα : Cardinal.mk α ≤ Cardinal.aleph0) :
    Cardinal.mk (α → Nat) ≤ Cardinal.continuum := by
  rw [Cardinal.mk_arrow, Cardinal.mk_nat, Cardinal.lift_aleph0]
  calc
    Cardinal.aleph0 ^ Cardinal.lift.{0} (Cardinal.mk α) ≤
        Cardinal.aleph0 ^ Cardinal.aleph0 :=
      Cardinal.power_le_power_left Cardinal.aleph0_ne_zero
        (Cardinal.lift_le_aleph0.mpr hα)
    _ = Cardinal.continuum := Cardinal.aleph0_power_aleph0

/-! A product estimate for a union indexed by at most `aleph1` many code classes. -/
theorem aleph_one_mul_continuum :
    Cardinal.aleph 1 * Cardinal.continuum = Cardinal.continuum := by
  exact Cardinal.mul_eq_right Cardinal.aleph0_le_continuum
    Cardinal.aleph_one_le_continuum
    (Cardinal.aleph0_pos.trans Cardinal.aleph0_lt_aleph_one).ne'

/-! Pigeonhole statement at the exact `aleph1` threshold. -/
theorem exists_aleph_one_fiber {β α : Type}
    (f : β → α) (hβ : Cardinal.aleph 1 ≤ Cardinal.mk β)
    (hα : Cardinal.mk α < Cardinal.aleph 1) :
    ∃ a : α, Cardinal.aleph 1 ≤ Cardinal.mk (f ⁻¹' ({a} : Set α)) := by
  refine Cardinal.infinite_pigeonhole_card f (Cardinal.aleph 1) hβ
    Cardinal.aleph0_lt_aleph_one.le ?_
  rw [Cardinal.isRegular_aleph_one.cof_ord]
  exact hα

/-! The raw union inequality has a same-universe indexing restriction. -/
theorem iUnion_card_bound {α ι : Type} (f : ι → Set α) :
    Cardinal.mk (⋃ i, f i) ≤ Cardinal.mk ι * ⨆ i, Cardinal.mk (f i) :=
  Cardinal.mk_iUnion_le f

end CardinalApiAudit
