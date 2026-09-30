import Erdos593.Graph.BipartiteSpectrumBounds

/-! # Exact arithmetic for the finite spectrum corollaries -/

namespace Erdos593.Spectrum

theorem q_mono {a b : ℕ} (h : a ≤ b) : q a ≤ q b := by
  apply (q_le_iff a (q b)).mpr
  have hb := (q_le_iff b (q b)).mp le_rfl
  omega

theorem two_le_q (m : ℕ) (hm : 1 ≤ m) : 2 ≤ q m := by
  have h := (q_le_iff m (q m)).mp le_rfl
  by_contra hn
  have : q m = 0 ∨ q m = 1 := by omega
  rcases this with hq | hq <;> rw [hq] at h <;> norm_num at h <;> omega

theorem q_le_succ (m : ℕ) (hm : 1 ≤ m) : q m ≤ m + 1 := by
  apply (q_le_iff m (m + 1)).mpr
  have h : m - 1 + 1 = m := by omega
  nlinarith [Nat.zero_le ((m - 1) ^ 2)]

theorem q_le_self (m : ℕ) (hm : 4 ≤ m) : q m ≤ m := by
  apply (q_le_iff m m).mpr
  nlinarith [Nat.mul_le_mul_left m hm]

theorem q_shift_le (m d : ℕ) (hm : 1 ≤ m) : q (m + d) ≤ q m + 2 * d := by
  apply (q_le_iff (m + d) (q m + 2 * d)).mpr
  have h := (q_le_iff m (q m)).mp le_rfl
  have hq := two_le_q m hm
  nlinarith [Nat.mul_le_mul_left d hq, Nat.zero_le (d ^ 2)]

theorem inverse_q_bound (M N : ℕ) (hM : 1 ≤ M) (hN : 3 ≤ N) :
    M + q M ≤ N ↔ M ≤ N + 2 - q (N + 1) := by
  have _hM : 0 < M := hM
  let k := q (N + 1)
  let U := N + 2 - k
  have hklo : 4 ≤ k := by
    have hcap := (q_le_iff (N + 1) k).mp le_rfl
    by_contra h
    have hk : k ≤ 3 := by omega
    nlinarith [Nat.mul_le_mul hk hk]
  have hkhi : k ≤ N + 1 := q_le_self (N + 1) (by omega)
  have hU : U + k = N + 2 := by dsimp [U]; omega
  have _hUpos : 1 ≤ U := by omega
  have hkcap : 4 * (N + 1) ≤ k ^ 2 := (q_le_iff (N + 1) k).mp le_rfl
  have hkmin : (k - 1) ^ 2 < 4 * (N + 1) := by
    by_contra h
    have hq := (q_le_iff (N + 1) (k - 1)).mpr (by omega)
    change k ≤ k - 1 at hq
    omega
  have hk1 : k - 1 + 1 = k := by omega
  have hk2 : k - 2 + 2 = k := by omega
  have hk3 : k - 3 + 3 = k := by omega
  have hUcap : 4 * U ≤ (k - 2) ^ 2 := by nlinarith
  have hUq := (q_le_iff U (k - 2)).mpr hUcap
  have hUgood : U + q U ≤ N := by omega
  have hnextcap : (k - 3) ^ 2 < 4 * (U + 1) := by nlinarith
  have hnextq : k - 2 ≤ q (U + 1) := by
    by_contra h
    have hh := (q_le_iff (U + 1) (k - 3)).mp (by omega)
    omega
  have hnext : N < U + 1 + q (U + 1) := by omega
  change M + q M ≤ N ↔ M ≤ U
  constructor
  · intro h
    by_contra hbad
    have hq := q_mono (show U + 1 ≤ M by omega)
    omega
  · intro h
    have hq := q_mono h
    omega

theorem half_ceiling (n c : ℕ) (hcn : c ≤ n) :
    (n - c + 1) / 2 = ⌈((n : ℝ) - c) / 2⌉₊ := by
  let t := (n - c + 1) / 2
  let x : ℝ := ((n : ℝ) - c) / 2
  have hn : n - c ≤ 2 * t := by dsimp [t]; omega
  have hnreal : ((n - c : ℕ) : ℝ) ≤ 2 * (t : ℝ) := by exact_mod_cast hn
  rw [Nat.cast_sub hcn] at hnreal
  have hceil : ⌈x⌉₊ ≤ t := (Nat.ceil_le).mpr (by dsimp [x]; linarith)
  have hx : x ≤ (⌈x⌉₊ : ℝ) := Nat.le_ceil x
  have hnreal' : ((n - c : ℕ) : ℝ) ≤ (2 * ⌈x⌉₊ : ℕ) := by
    rw [Nat.cast_sub hcn]
    push_cast
    dsimp [x] at hx
    linarith
  have hn' : n - c ≤ 2 * ⌈x⌉₊ := by exact_mod_cast hnreal'
  have hother : t ≤ ⌈x⌉₊ := by dsimp [t]; omega
  exact Nat.le_antisymm hother hceil

theorem fixed_order_bounds_iff (m n c : ℕ)
    (hc : 1 ≤ c) (hn : 3 * c ≤ n) (hcm : c ≤ m) :
    (m + 2 * (c - 1) + q (m - c + 1) ≤ n ∧ n ≤ 2 * m + c) ↔
      ((n - c + 1) / 2 ≤ m ∧ m ≤ n - 2 * c + 4 - q (n - 3 * c + 4)) := by
  let M := m - c + 1
  let N := n - 3 * c + 3
  have hM : 1 ≤ M := by dsimp [M]; omega
  have hN : 3 ≤ N := by dsimp [N]; omega
  have hN1 : N + 1 = n - 3 * c + 4 := rfl
  have hq := q_le_self (N + 1) (by omega)
  have hi := inverse_q_bound M N hM hN
  rw [hN1] at hq hi
  dsimp [M, N] at hi ⊢
  omega

private theorem connected_order_bounds (n : ℕ) :
    (∃ m : ℕ, 1 ≤ m ∧ m + q m ≤ n ∧ n ≤ 2 * m + 1) ↔
      n = 3 ∨ n = 5 ∨ 7 ≤ n := by
  have hq1 : q 1 = 2 := by
    have hlo := two_le_q 1 (by omega)
    have hhi := q_le_succ 1 (by omega)
    omega
  have hq2 : q 2 = 3 := by
    have hhi := (q_le_iff 2 3).mpr (by norm_num)
    have hn : ¬q 2 ≤ 2 := by rw [q_le_iff]; norm_num
    omega
  have hq3 : q 3 = 4 := by
    have hhi := (q_le_iff 3 4).mpr (by norm_num)
    have hn : ¬q 3 ≤ 3 := by rw [q_le_iff]; norm_num
    omega
  constructor
  · rintro ⟨m, hm, hlo, hhi⟩
    have hq := two_le_q m hm
    by_cases h : 7 ≤ n
    · exact Or.inr (Or.inr h)
    by_cases hm1 : m = 1
    · subst m
      rw [hq1] at hlo
      omega
    by_cases hm2 : m = 2
    · subst m
      rw [hq2] at hlo
      omega
    have hq3m := q_mono (show 3 ≤ m by omega)
    omega
  · rintro (rfl | rfl | h)
    · exact ⟨1, by omega, by omega, by omega⟩
    · exact ⟨2, by omega, by omega, by omega⟩
    · by_cases h7 : n = 7
      · exact ⟨3, by omega, by omega, by omega⟩
      have hm : 4 ≤ n / 2 := by omega
      have hq := q_le_self (n / 2) hm
      exact ⟨n / 2, by omega, by omega, by omega⟩

theorem exists_order_bounds_iff (n c : ℕ) (hc : 1 ≤ c) (hn : 3 * c ≤ n) :
    (∃ m : ℕ, c ≤ m ∧
      m + 2 * (c - 1) + q (m - c + 1) ≤ n ∧ n ≤ 2 * m + c) ↔
      n = 3 * c ∨ n = 3 * c + 2 ∨ 3 * c + 4 ≤ n := by
  let N := n - 3 * c + 3
  constructor
  · rintro ⟨m, hcm, hlo, hhi⟩
    have h : ∃ M : ℕ, 1 ≤ M ∧ M + q M ≤ N ∧ N ≤ 2 * M + 1 := by
      refine ⟨m - c + 1, by omega, ?_, ?_⟩ <;> dsimp [N] <;> omega
    have hh := (connected_order_bounds N).mp h
    dsimp [N] at hh
    omega
  · intro h
    have hN : N = 3 ∨ N = 5 ∨ 7 ≤ N := by dsimp [N]; omega
    obtain ⟨M, hM, hlo, hhi⟩ := (connected_order_bounds N).mpr hN
    have hmc : M + c - 1 - c + 1 = M := by omega
    refine ⟨M + c - 1, by omega, ?_, ?_⟩
    · rw [hmc]
      dsimp [N] at hlo
      omega
    · dsimp [N] at hhi
      omega

end Erdos593.Spectrum
