import Erdos593.TripleSystem.ErdosRado.CanonicalLevelCode
import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Pigeonhole

/-!
Scratch-only cardinal interface audit for the concrete `TraceHeight` used by the
Erdos--Rado development.  It deliberately makes no production declarations.
-/

namespace Erdos593.TripleSystem.TriangleHost.ErdosRado.CardinalAudit

open Cardinal

theorem mk_traceHeight_eq_aleph_one :
    Cardinal.mk TraceHeight.ToType = Cardinal.aleph 1 := by
  rw [mk_traceHeight, Cardinal.succ_aleph0]

theorem card_lt_aleph_one_of_lt_traceHeight {rho : Ordinal.{0}}
    (hrho : rho < TraceHeight) : rho.card < Cardinal.aleph 1 := by
  change rho < (Order.succ (Cardinal.aleph0 : Cardinal)).ord at hrho
  rw [Cardinal.lt_ord] at hrho
  simpa only [Cardinal.succ_aleph0] using hrho

theorem card_le_aleph0_of_lt_traceHeight {rho : Ordinal.{0}}
    (hrho : rho < TraceHeight) : rho.card <= Cardinal.aleph0 :=
  Cardinal.lt_aleph_one_iff.mp (card_lt_aleph_one_of_lt_traceHeight hrho)

theorem mk_short_nat_code_le_continuum {rho : Ordinal.{0}}
    (hrho : rho < TraceHeight) :
    Cardinal.mk (rho.ToType -> Nat) <= Cardinal.continuum := by
  rw [Cardinal.mk_arrow, Cardinal.mk_nat, Cardinal.lift_id, Cardinal.lift_id,
    Cardinal.mk_toType]
  calc
    Cardinal.aleph0 ^ rho.card <= Cardinal.aleph0 ^ Cardinal.aleph0 :=
      Cardinal.power_le_power_left Cardinal.aleph0_ne_zero
        (card_le_aleph0_of_lt_traceHeight hrho)
    _ = Cardinal.continuum := Cardinal.aleph0_power_aleph0

theorem mk_level_le_continuum {c : TraceColoring}
    (T : CoherentTraceSystem c) (rho : Ordinal)
    (hrho : rho < TraceHeight) (hcode : T.LevelCodeInjective rho) :
    Cardinal.mk (T.level rho) <= Cardinal.continuum :=
  (Cardinal.mk_le_of_injective hcode).trans
    (mk_short_nat_code_le_continuum hrho)

theorem iUnion_card_bound {alpha iota : Type} (f : iota -> Set alpha) :
    Cardinal.mk (⋃ i, f i) <=
      Cardinal.mk iota * ⨆ i, Cardinal.mk (f i) :=
  Cardinal.mk_iUnion_le f

theorem mk_iUnion_le_continuum {alpha iota : Type} (f : iota -> Set alpha)
    (hiota : Cardinal.mk iota <= Cardinal.aleph 1)
    (hpiece : ∀ i, Cardinal.mk (f i) <= Cardinal.continuum) :
    Cardinal.mk (⋃ i, f i) <= Cardinal.continuum := by
  have hsup : (⨆ i, Cardinal.mk (f i)) <= Cardinal.continuum := by
    exact ciSup_le' hpiece
  calc
    Cardinal.mk (⋃ i, f i) <= Cardinal.mk iota * ⨆ i, Cardinal.mk (f i) :=
      Cardinal.mk_iUnion_le f
    _ <= Cardinal.mk iota * Cardinal.continuum :=
      mul_le_mul_right hsup (Cardinal.mk iota)
    _ <= Cardinal.aleph 1 * Cardinal.continuum :=
      mul_le_mul_left hiota _
    _ = Cardinal.continuum := Cardinal.mul_eq_right Cardinal.aleph0_le_continuum
      Cardinal.aleph_one_le_continuum
      (Cardinal.aleph0_pos.trans Cardinal.aleph0_lt_aleph_one).ne'

theorem aleph_one_mul_continuum :
    Cardinal.aleph 1 * Cardinal.continuum = Cardinal.continuum := by
  exact Cardinal.mul_eq_right Cardinal.aleph0_le_continuum
    Cardinal.aleph_one_le_continuum
    (Cardinal.aleph0_pos.trans Cardinal.aleph0_lt_aleph_one).ne'

theorem exists_aleph_one_fiber {beta alpha : Type}
    (f : beta -> alpha) (hbeta : Cardinal.aleph 1 <= Cardinal.mk beta)
    (halpha : Cardinal.mk alpha < Cardinal.aleph 1) :
    ∃ a : alpha, Cardinal.aleph 1 <= Cardinal.mk (f ⁻¹' ({a} : Set alpha)) := by
  refine Cardinal.infinite_pigeonhole_card f (Cardinal.aleph 1) hbeta
    Cardinal.aleph0_lt_aleph_one.le ?_
  rw [Cardinal.isRegular_aleph_one.cof_ord]
  exact halpha

theorem traceCarrier_nat_fiber (f : TraceCarrier -> Nat) :
    ∃ n : Nat, Cardinal.aleph 1 <= Cardinal.mk (f ⁻¹' ({n} : Set Nat)) := by
  refine Cardinal.infinite_pigeonhole_card f (Cardinal.aleph 1) ?_
    Cardinal.aleph0_lt_aleph_one.le ?_
  · calc
      Cardinal.aleph 1 <= Cardinal.continuum := Cardinal.aleph_one_le_continuum
      _ <= Order.succ Cardinal.continuum := Order.le_succ _
      _ = Cardinal.mk TraceCarrier := mk_traceCarrier.symm
  · rw [Cardinal.isRegular_aleph_one.cof_ord, Cardinal.mk_nat]
    exact Cardinal.aleph0_lt_aleph_one

end Erdos593.TripleSystem.TriangleHost.ErdosRado.CardinalAudit
