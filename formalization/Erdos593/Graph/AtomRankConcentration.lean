import Erdos593.Graph.SpectrumCorollaryArithmetic

/-! # Strict concentration for positive canonical-atom ranks

This arithmetic support does not assert a canonical-atom spectrum or supply
the missing construction/transport interfaces of K2.
-/

namespace Erdos593.Spectrum

theorem q_add_strict (a b : ℕ) (ha : 1 ≤ a) (hb : 1 ≤ b) :
    q (a + b) + 1 ≤ q a + q b := by
  have hqa := two_le_q a ha
  have hqb := two_le_q b hb
  have hca := (q_le_iff a (q a)).mp le_rfl
  have hcb := (q_le_iff b (q b)).mp le_rfl
  obtain ⟨x, hx⟩ := Nat.exists_eq_add_of_le hqa
  obtain ⟨y, hy⟩ := Nat.exists_eq_add_of_le hqb
  have hcap : 4 * (a + b) ≤ (q a + q b - 1) ^ 2 := by
    rw [hx] at hca ⊢
    rw [hy] at hcb ⊢
    have hsub : 2 + x + (2 + y) - 1 = x + y + 3 := by omega
    rw [hsub]
    nlinarith [Nat.zero_le x, Nat.zero_le y, Nat.zero_le (x * y)]
  have hq := (q_le_iff (a + b) (q a + q b - 1)).mpr hcap
  omega

theorem q_sum_add_card_le {ι : Type*}
    (s : Finset ι) (r : ι → ℕ)
    (hs : s.Nonempty) (hr : ∀ i ∈ s, 1 ≤ r i) :
    q (∑ i ∈ s, r i) + s.card ≤
      (∑ i ∈ s, q (r i)) + 1 := by
  classical
  revert hs hr
  induction s using Finset.induction_on with
  | empty =>
      intro hs _
      simp at hs
  | @insert i s hi ih =>
      intro _ hr
      by_cases hnonempty : s.Nonempty
      · have hir : 1 ≤ r i := hr i (Finset.mem_insert_self i s)
        have hrest : ∀ j ∈ s, 1 ≤ r j :=
          fun j hj => hr j (Finset.mem_insert_of_mem hj)
        have hbound := ih hnonempty hrest
        obtain ⟨j, hj⟩ := hnonempty
        have hsumpos : 1 ≤ ∑ j ∈ s, r j :=
          (hrest j hj).trans
            (Finset.single_le_sum (f := r) (fun j _ => Nat.zero_le (r j)) hj)
        have hpair := q_add_strict (r i) (∑ j ∈ s, r j) hir hsumpos
        simp only [Finset.sum_insert hi, Finset.card_insert_of_notMem hi]
        omega
      · have hempty : s = ∅ := Finset.not_nonempty_iff_eq_empty.mp hnonempty
        subst s
        simp

theorem sum_q_eq_q_sum_iff_card_eq_one {ι : Type*}
    (s : Finset ι) (r : ι → ℕ)
    (hs : s.Nonempty) (hr : ∀ i ∈ s, 1 ≤ r i) :
    (∑ i ∈ s, q (r i)) = q (∑ i ∈ s, r i) ↔
      s.card = 1 := by
  classical
  constructor
  · intro h
    have hbound := q_sum_add_card_le s r hs hr
    rw [h] at hbound
    have hpos := Finset.card_pos.mpr hs
    omega
  · intro hcard
    obtain ⟨i, hi⟩ := Finset.card_eq_one.mp hcard
    rw [hi]
    simp

end Erdos593.Spectrum
