import Erdos593.Graph.FiniteCycleRank
import Erdos593.Graph.SpectrumCorollaryArithmetic
import Erdos593.TripleSystem.CanonicalAtomCounting
import Erdos593.TripleSystem.SpectrumRealization

/-! # Exact Levi cycle-rank spectrum

The counting identities apply also to systems with isolated points. Reducedness
and nonemptiness are needed only for the obligatory spectrum interval.
-/

namespace Erdos593.TripleSystem

universe u

open _root_.SimpleGraph.FiniteCycleRank

theorem levi_cycleRank {V E : Type u} [Finite V] [Finite E]
    (F : TripleSystem V E) :
    cycleRank F.levi = 2 * Nat.card E + Nat.card F.levi.ConnectedComponent -
      Nat.card V := by
  letI := Fintype.ofFinite V
  letI := Fintype.ofFinite E
  rw [cycleRank, CanonicalAtom.levi_card_edges F, Nat.card_sum]
  omega

theorem levi_cycleRank_int {V E : Type u} [Finite V] [Finite E]
    (F : TripleSystem V E) :
    (cycleRank F.levi : ℤ) = 2 * (Nat.card E : ℤ) - (Nat.card V : ℤ) +
      (Nat.card F.levi.ConnectedComponent : ℤ) := by
  letI := Fintype.ofFinite V
  letI := Fintype.ofFinite E
  rw [cycleRank_int]
  exact CanonicalAtom.levi_euler_expression F

theorem obligatory_cycleRank_le {V E : Type u} [Finite V] [Finite E]
    (F : TripleSystem V E) (hobligatory : F.IsObligatory)
    (hreduced : F.HasNoIsolatedPoints) (hnonempty : Nonempty E) :
    cycleRank F.levi ≤ Nat.card E - Nat.card F.levi.ConnectedComponent + 2 -
      Erdos593.Spectrum.q (Nat.card E - Nat.card F.levi.ConnectedComponent + 1) := by
  letI := Fintype.ofFinite V
  letI := Fintype.ofFinite E
  obtain ⟨hc, hcm, hlower, hupper⟩ :=
    obligatory_spectrum_necessity F hobligatory hreduced hnonempty
  rw [levi_cycleRank]
  omega

theorem exists_obligatory_cycleRank_iff (m c b : ℕ)
    (hm : 1 ≤ m) (hc : 1 ≤ c) (hcm : c ≤ m) :
    (∃ n : ℕ, ∃ F : TripleSystem (Fin n) (Fin m),
      F.IsObligatory ∧ F.HasNoIsolatedPoints ∧
      Nat.card F.levi.ConnectedComponent = c ∧ cycleRank F.levi = b) ↔
      b ≤ m - c + 2 - Erdos593.Spectrum.q (m - c + 1) := by
  constructor
  · rintro ⟨n, F, hF, hred, hcomp, hrank⟩
    have hnonempty : Nonempty (Fin m) := ⟨⟨0, by omega⟩⟩
    have h := obligatory_cycleRank_le F hF hred hnonempty
    simpa only [hrank, hcomp, Nat.card_eq_fintype_card, Fintype.card_fin] using h
  · intro hb
    have hq := Erdos593.Spectrum.q_le_succ (m - c + 1) (by omega)
    let n := 2 * m + c - b
    have hlower : m + 2 * (c - 1) + Erdos593.Spectrum.q (m - c + 1) ≤ n := by
      dsimp [n]
      omega
    have hupper : n ≤ 2 * m + c := Nat.sub_le _ _
    obtain ⟨F, hF, hred, hcomp⟩ :=
      exists_obligatory_spectrum m n c hm hc hcm hlower hupper
    refine ⟨n, F, hF, hred, hcomp, ?_⟩
    rw [levi_cycleRank, hcomp]
    simp only [Nat.card_eq_fintype_card, Fintype.card_fin]
    dsimp [n]
    omega

theorem order_eq_iff_levi_isAcyclic {V E : Type u} [Finite V] [Finite E]
    (F : TripleSystem V E) :
    Nat.card V = 2 * Nat.card E + Nat.card F.levi.ConnectedComponent ↔
      F.levi.IsAcyclic := by
  have hv := card_vertices_le_edges_add_components F.levi
  letI := Fintype.ofFinite V
  letI := Fintype.ofFinite E
  rw [CanonicalAtom.levi_card_edges F, Nat.card_sum] at hv
  rw [← cycleRank_eq_zero_iff, levi_cycleRank]
  omega

end Erdos593.TripleSystem
