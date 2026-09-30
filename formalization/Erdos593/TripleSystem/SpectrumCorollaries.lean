import Erdos593.TripleSystem.SpectrumRealization
import Erdos593.Graph.SpectrumCorollaryArithmetic
import Erdos593.TripleSystem.IsolatedPointExtension

/-! # Connected, unrestricted and fixed-order spectra -/

namespace Erdos593.TripleSystem

private theorem reduced_order_bounds {V E : Type} (F : TripleSystem V E)
    [Fintype V] [Fintype E] (hF : F.IsObligatory) (hr : F.HasNoIsolatedPoints)
    (he : Nonempty E) :
    Nat.card E + Spectrum.q (Nat.card E) ≤ Nat.card V ∧ Nat.card V ≤ 3 * Nat.card E := by
  obtain ⟨hc, hcm, hlo, hhi⟩ := obligatory_spectrum_necessity F hF hr he
  have hM : 1 ≤ Nat.card E - Nat.card F.levi.ConnectedComponent + 1 := by omega
  have hsum : Nat.card E - Nat.card F.levi.ConnectedComponent + 1 +
      (Nat.card F.levi.ConnectedComponent - 1) = Nat.card E := by omega
  have hq := Spectrum.q_shift_le _ (Nat.card F.levi.ConnectedComponent - 1) hM
  rw [hsum] at hq
  constructor <;> omega

private theorem edge_nonempty_of_reduced {m n : ℕ} (F : TripleSystem (Fin n) (Fin m))
    (hr : F.HasNoIsolatedPoints) (hn : 1 ≤ n) : 1 ≤ m := by
  obtain ⟨e, _⟩ := (not_isolated_iff_exists_inc F).mp (hr ⟨0, hn⟩)
  have he := e.isLt
  omega

theorem exists_connected_obligatory_iff (m n : ℕ) (hm : 1 ≤ m) :
    (∃ F : TripleSystem (Fin n) (Fin m),
      F.IsObligatory ∧ F.HasNoIsolatedPoints ∧ F.levi.Connected) ↔
      m + Spectrum.q m ≤ n ∧ n ≤ 2 * m + 1 := by
  classical
  constructor
  · rintro ⟨F, hF, hr, hconn⟩
    have hcard : Nat.card F.levi.ConnectedComponent = 1 :=
      Nat.card_eq_one_iff_unique.mpr
        ⟨hconn.preconnected.subsingleton_connectedComponent,
          ⟨F.levi.connectedComponentMk (Sum.inr ⟨0, hm⟩)⟩⟩
    obtain ⟨_, _, hlo, hhi⟩ := obligatory_spectrum_necessity F hF hr ⟨⟨0, hm⟩⟩
    simpa only [Nat.card_fin, hcard, Nat.sub_self, Nat.mul_zero, Nat.add_zero,
      Nat.sub_add_cancel hm] using And.intro hlo hhi
  · rintro ⟨hlo, hhi⟩
    obtain ⟨F, hF, hr, hcard⟩ := exists_obligatory_spectrum m n 1 hm le_rfl hm
      (by simpa only [Nat.sub_self, Nat.mul_zero, Nat.add_zero, Nat.sub_add_cancel hm] using hlo) hhi
    haveI : Subsingleton F.levi.ConnectedComponent := (Nat.card_eq_one_iff_unique.mp hcard).1
    haveI : Nonempty (Fin n ⊕ Fin m) := ⟨Sum.inr ⟨0, hm⟩⟩
    refine ⟨F, hF, hr, ⟨?_⟩⟩
    intro x y
    exact _root_.SimpleGraph.ConnectedComponent.exact (Subsingleton.elim _ _)

theorem exists_reduced_obligatory_iff (m n : ℕ) (hm : 1 ≤ m) :
    (∃ F : TripleSystem (Fin n) (Fin m), F.IsObligatory ∧ F.HasNoIsolatedPoints) ↔
      m + Spectrum.q m ≤ n ∧ n ≤ 3 * m := by
  classical
  constructor
  · rintro ⟨F, hF, hr⟩
    simpa only [Nat.card_fin] using reduced_order_bounds F hF hr ⟨⟨0, hm⟩⟩
  · rintro ⟨hlo, hhi⟩
    by_cases hconn : n ≤ 2 * m + 1
    · obtain ⟨F, hF, hr, _⟩ := (exists_connected_obligatory_iff m n hm).mpr ⟨hlo, hconn⟩
      exact ⟨F, hF, hr⟩
    let c := n - 2 * m
    have hc : 1 ≤ c := by dsimp [c]; omega
    have hcm : c ≤ m := by dsimp [c]; omega
    have hq := Spectrum.q_le_succ (m - c + 1) (by omega)
    obtain ⟨F, hF, hr, _⟩ := exists_obligatory_spectrum m n c hm hc hcm
      (by dsimp [c] at *; omega) (by dsimp [c]; omega)
    exact ⟨F, hF, hr⟩

theorem exists_obligatory_iff (m n : ℕ) (hm : 1 ≤ m) :
    (∃ F : TripleSystem (Fin n) (Fin m), F.IsObligatory) ↔
      m + Spectrum.q m ≤ n := by
  classical
  constructor
  · rintro ⟨F, hF⟩
    have hlo := (reduced_order_bounds F.isolatedReduction hF.isolatedReduction
      F.isolatedReduction_hasNoIsolatedPoints ⟨⟨0, hm⟩⟩).1
    have hcard : Nat.card F.NonIsolatedPoint ≤ Nat.card (Fin n) :=
      Nat.card_le_card_of_injective Subtype.val Subtype.val_injective
    simp only [Nat.card_fin] at hlo hcard
    omega
  · intro hlo
    have hq := Spectrum.q_le_succ m hm
    obtain ⟨F, hF, hr, _⟩ := (exists_connected_obligatory_iff m (m + Spectrum.q m) hm).mpr
      ⟨le_rfl, by omega⟩
    let f : Fin (m + Spectrum.q m) ↪ Fin n :=
      ⟨fun x => ⟨x.val, lt_of_lt_of_le x.isLt hlo⟩,
        fun _ _ h => Fin.ext (congrArg (fun y : Fin n => y.val) h)⟩
    exact ⟨F.withIsolatedPoints f, IsObligatory.withIsolatedPoints F f hF hr⟩

theorem exists_obligatory_fixed_order_iff (m n c : ℕ) (hc : 1 ≤ c) (hn : 3 * c ≤ n) :
    (∃ F : TripleSystem (Fin n) (Fin m), F.IsObligatory ∧ F.HasNoIsolatedPoints ∧
      Nat.card F.levi.ConnectedComponent = c) ↔
      (n - c + 1) / 2 ≤ m ∧ m ≤ n - 2 * c + 4 - Spectrum.q (n - 3 * c + 4) := by
  classical
  constructor
  · rintro ⟨F, hF, hr, hcard⟩
    have hm := edge_nonempty_of_reduced F hr (by omega)
    obtain ⟨_, hcm, hlo, hhi⟩ := obligatory_spectrum_necessity F hF hr ⟨⟨0, hm⟩⟩
    simp only [Nat.card_fin, hcard] at hcm hlo hhi
    exact (Spectrum.fixed_order_bounds_iff m n c hc hn hcm).mp ⟨hlo, hhi⟩
  · intro h
    have hcm : c ≤ m := by omega
    have hm : 1 ≤ m := by omega
    obtain ⟨hlo, hhi⟩ := (Spectrum.fixed_order_bounds_iff m n c hc hn hcm).mpr h
    exact exists_obligatory_spectrum m n c hm hc hcm hlo hhi

theorem exists_obligatory_order_components_iff (n c : ℕ) (hc : 1 ≤ c) (hn : 3 * c ≤ n) :
    (∃ (m : ℕ) (F : TripleSystem (Fin n) (Fin m)),
      F.IsObligatory ∧ F.HasNoIsolatedPoints ∧ Nat.card F.levi.ConnectedComponent = c) ↔
      n = 3 * c ∨ n = 3 * c + 2 ∨ 3 * c + 4 ≤ n := by
  classical
  rw [← Spectrum.exists_order_bounds_iff n c hc hn]
  constructor
  · rintro ⟨m, F, hF, hr, hcard⟩
    have hm := edge_nonempty_of_reduced F hr (by omega)
    obtain ⟨_, hcm, hlo, hhi⟩ := obligatory_spectrum_necessity F hF hr ⟨⟨0, hm⟩⟩
    simp only [Nat.card_fin, hcard] at hcm hlo hhi
    exact ⟨m, hcm, hlo, hhi⟩
  · rintro ⟨m, hcm, hlo, hhi⟩
    obtain ⟨F, hF, hr, hcard⟩ := exists_obligatory_spectrum m n c (by omega) hc hcm hlo hhi
    exact ⟨m, F, hF, hr, hcard⟩

end Erdos593.TripleSystem
