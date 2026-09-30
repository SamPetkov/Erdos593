import Erdos593.Graph.BipartiteSpectrumBounds
import Mathlib.Tactic.Ring

/-! # Balanced bipartite equality and strict atom concentration

These are exact finite statements. The concentration bound excludes the
two-single-edge family with surplus three; the graph statements include
the empty-part boundary cases. Isomorphism means a vertex equivalence
preserving and reflecting adjacency, not merely equality of parameters.
-/

namespace Erdos593.Spectrum

theorem strict_atom_capacity_concentration {ι : Type*}
    (s : Finset ι) (v : ι → ℕ) (hs : 2 ≤ s.card)
    (hv : ∀ i ∈ s, 2 ≤ v i)
    (hsize : 4 ≤ 1 + ∑ i ∈ s, (v i - 1)) :
    (∑ i ∈ s, (v i) ^ 2) + 2 ≤ (1 + ∑ i ∈ s, (v i - 1)) ^ 2 := by
  classical
  have h1 : ∑ i ∈ s, (v i - 1) = (∑ i ∈ s, (v i - 2)) + s.card := by
    rw [Finset.card_eq_sum_ones, ← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun i hi => by have := hv i hi; omega
  have h2 : ∑ i ∈ s, (v i) ^ 2
      = (∑ i ∈ s, (v i - 2) ^ 2) + 4 * (∑ i ∈ s, (v i - 2)) + 4 * s.card := by
    rw [Finset.mul_sum, Finset.card_eq_sum_ones, Finset.mul_sum, ← Finset.sum_add_distrib,
      ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun i hi => ?_
    obtain ⟨c, hc⟩ : ∃ c, v i = c + 2 := ⟨v i - 2, by have := hv i hi; omega⟩
    rw [hc]
    simp only [Nat.add_sub_cancel, mul_one]
    ring
  have hsq : ∑ i ∈ s, (v i - 2) ^ 2 ≤ (∑ i ∈ s, (v i - 2)) ^ 2 := by
    calc ∑ i ∈ s, (v i - 2) ^ 2 ≤ ∑ i ∈ s, (v i - 2) * (∑ j ∈ s, (v j - 2)) := by
          refine Finset.sum_le_sum fun i hi => ?_
          have hle : v i - 2 ≤ ∑ j ∈ s, (v j - 2) :=
            Finset.single_le_sum (f := fun j => v j - 2) (fun j _ => Nat.zero_le _) hi
          nlinarith
      _ = (∑ i ∈ s, (v i - 2)) ^ 2 := by rw [← Finset.sum_mul]; ring
  rw [h1] at hsize ⊢
  rw [h2]
  revert hsize hs hsq
  generalize (∑ i ∈ s, (v i - 2)) = A
  generalize (∑ i ∈ s, (v i - 2) ^ 2) = S
  generalize s.card = B
  intro hs hsize hsq
  rcases Nat.lt_or_ge B 3 with h3 | h3
  · have hB2 : B = 2 := by omega
    subst hB2
    have hA1 : 1 ≤ A := by omega
    nlinarith
  · nlinarith

end Erdos593.Spectrum

namespace SimpleGraph.BalancedBipartiteRigidity

universe u

theorem even_order_isomorphic_complete_bipartite
    {V : Type u} [Finite V] (G : SimpleGraph V) (hb : G.Colorable 2)
    (t : ℕ) (hv : Nat.card V = 2 * t) (he : Nat.card G.edgeSet = t ^ 2) :
    Nonempty (G ≃g completeBipartiteGraph (Fin t) (Fin t)) := by
  classical
  obtain ⟨c⟩ := hb
  set A : Set V := {x | c x = 0} with hA
  have htwo : ∀ (a b : Fin 2), a ≠ b → a ≠ 0 → b = 0 := by decide
  set φ : ↥A × ↥(Aᶜ : Set V) → Sym2 V := fun p => s((p.1 : V), (p.2 : V)) with hφ
  have hφinj : Function.Injective φ := by
    rintro ⟨⟨x, hx⟩, ⟨y, hy⟩⟩ ⟨⟨x', hx'⟩, ⟨y', hy'⟩⟩ h
    have h' : s(x, y) = s(x', y') := h
    rcases Sym2.eq_iff.mp h' with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · subst h1; subst h2; rfl
    · exact absurd (h1 ▸ hx) hy'
  have hsub : G.edgeSet ⊆ Set.range φ := by
    intro e he'
    induction e using Sym2.inductionOn with
    | _ x y =>
      have hxy : G.Adj x y := he'
      have hne : c x ≠ c y := c.valid hxy
      by_cases hx : c x = 0
      · have hy : y ∈ (Aᶜ : Set V) := fun hy => hne (hx.trans hy.symm)
        exact ⟨(⟨x, hx⟩, ⟨y, hy⟩), rfl⟩
      · have hy : c y = 0 := htwo _ _ hne hx
        exact ⟨(⟨y, hy⟩, ⟨x, hx⟩), Sym2.eq_swap⟩
  have hfin : (Set.range φ).Finite := Set.toFinite _
  have hcardrange : (Set.range φ).ncard = A.ncard * (Aᶜ : Set V).ncard := by
    rw [Set.ncard_range_of_injective hφinj, Nat.card_prod, Nat.card_coe_set_eq,
      Nat.card_coe_set_eq]
  have hcards : A.ncard + (Aᶜ : Set V).ncard = 2 * t := by
    rw [Set.ncard_add_ncard_compl A, hv]
  have hecard : G.edgeSet.ncard = t ^ 2 := by rw [← Nat.card_coe_set_eq]; exact he
  have hle : t ^ 2 ≤ A.ncard * (Aᶜ : Set V).ncard := by
    have h1 : G.edgeSet.ncard ≤ (Set.range φ).ncard := Set.ncard_le_ncard hsub hfin
    rw [hcardrange, hecard] at h1
    exact h1
  have hAt : A.ncard = t := by
    have hz : ((A.ncard : ℤ) - t) ^ 2 ≤ 0 := by
      have h1 : (A.ncard : ℤ) + ((Aᶜ : Set V).ncard : ℤ) = 2 * t := by exact_mod_cast hcards
      have h2 : (t : ℤ) ^ 2 ≤ (A.ncard : ℤ) * ((Aᶜ : Set V).ncard : ℤ) := by exact_mod_cast hle
      nlinarith
    have hz0 : ((A.ncard : ℤ) - t) ^ 2 = 0 := le_antisymm hz (sq_nonneg _)
    have hzero := (pow_eq_zero_iff (n := 2) (by norm_num)).mp hz0
    omega
  have hBt : (Aᶜ : Set V).ncard = t := by omega
  have hEq : G.edgeSet = Set.range φ := by
    refine Set.eq_of_subset_of_ncard_le hsub ?_ hfin
    rw [hcardrange, hAt, hBt, hecard, pow_two]
  have hadj : ∀ x y, G.Adj x y ↔ (x ∈ A ↔ y ∉ A) := by
    intro x y
    constructor
    · intro h
      have hne : c x ≠ c y := c.valid h
      exact ⟨fun hxA hyA => hne (hxA.trans hyA.symm), fun hyA => htwo _ _ (Ne.symm hne) hyA⟩
    · intro h
      by_cases hx : x ∈ A
      · have hy : y ∈ (Aᶜ : Set V) := h.mp hx
        have hmem : s(x, y) ∈ Set.range φ := ⟨(⟨x, hx⟩, ⟨y, hy⟩), rfl⟩
        rw [← hEq] at hmem
        exact hmem
      · have hy : y ∈ A := by
          by_contra hy
          exact hx (h.mpr hy)
        have hxc : x ∈ (Aᶜ : Set V) := hx
        have hmem : s(y, x) ∈ Set.range φ := ⟨(⟨y, hy⟩, ⟨x, hxc⟩), rfl⟩
        rw [← hEq] at hmem
        exact (G.mem_edgeSet.mp hmem).symm
  have eA : ↥A ≃ Fin t := Finite.equivFinOfCardEq (by rw [Nat.card_coe_set_eq, hAt])
  have eB : ↥(Aᶜ : Set V) ≃ Fin t := Finite.equivFinOfCardEq (by rw [Nat.card_coe_set_eq, hBt])
  refine ⟨⟨(Equiv.Set.sumCompl A).symm.trans (Equiv.sumCongr eA eB), ?_⟩⟩
  intro x y
  have hxl : ∀ z : V, ((Equiv.Set.sumCompl A).symm.trans (Equiv.sumCongr eA eB) z).isLeft
      = decide (z ∈ A) := by
    intro z
    by_cases hz : z ∈ A
    · simp [Equiv.Set.sumCompl_symm_apply_of_mem hz, hz]
    · simp [Equiv.Set.sumCompl_symm_apply_of_notMem hz, hz]
  have hxr : ∀ z : V, ((Equiv.Set.sumCompl A).symm.trans (Equiv.sumCongr eA eB) z).isRight
      = decide (z ∉ A) := by
    intro z
    by_cases hz : z ∈ A
    · simp [Equiv.Set.sumCompl_symm_apply_of_mem hz, hz]
    · simp [Equiv.Set.sumCompl_symm_apply_of_notMem hz, hz]
  rw [hadj x y]
  simp only [completeBipartiteGraph, hxl, hxr]
  by_cases h1 : x ∈ A <;> by_cases h2 : y ∈ A <;> simp [h1, h2]

theorem odd_order_isomorphic_complete_bipartite
    {V : Type u} [Finite V] (G : SimpleGraph V) (hb : G.Colorable 2)
    (t : ℕ) (hv : Nat.card V = 2 * t + 1)
    (he : Nat.card G.edgeSet = t * (t + 1)) :
    Nonempty (G ≃g completeBipartiteGraph (Fin t) (Fin (t + 1))) := by
  classical
  have build : ∀ B : Set V, B.ncard = t → (Bᶜ : Set V).ncard = t + 1 →
      (∀ x y, G.Adj x y ↔ (x ∈ B ↔ y ∉ B)) →
      Nonempty (G ≃g completeBipartiteGraph (Fin t) (Fin (t + 1))) := by
    intro B hB1 hB2 hadj
    have eA : ↥B ≃ Fin t := Finite.equivFinOfCardEq (by rw [Nat.card_coe_set_eq, hB1])
    have eB : ↥(Bᶜ : Set V) ≃ Fin (t + 1) :=
      Finite.equivFinOfCardEq (by rw [Nat.card_coe_set_eq, hB2])
    refine ⟨⟨(Equiv.Set.sumCompl B).symm.trans (Equiv.sumCongr eA eB), ?_⟩⟩
    intro x y
    have hxl : ∀ z : V, ((Equiv.Set.sumCompl B).symm.trans (Equiv.sumCongr eA eB) z).isLeft
        = decide (z ∈ B) := by
      intro z
      by_cases hz : z ∈ B
      · simp [Equiv.Set.sumCompl_symm_apply_of_mem hz, hz]
      · simp [Equiv.Set.sumCompl_symm_apply_of_notMem hz, hz]
    have hxr : ∀ z : V, ((Equiv.Set.sumCompl B).symm.trans (Equiv.sumCongr eA eB) z).isRight
        = decide (z ∉ B) := by
      intro z
      by_cases hz : z ∈ B
      · simp [Equiv.Set.sumCompl_symm_apply_of_mem hz, hz]
      · simp [Equiv.Set.sumCompl_symm_apply_of_notMem hz, hz]
    rw [hadj x y]
    simp only [completeBipartiteGraph, hxl, hxr]
    by_cases h1 : x ∈ B <;> by_cases h2 : y ∈ B <;> simp [h1, h2]
  obtain ⟨c⟩ := hb
  set A : Set V := {x | c x = 0} with hA
  have htwo : ∀ (a b : Fin 2), a ≠ b → a ≠ 0 → b = 0 := by decide
  set φ : ↥A × ↥(Aᶜ : Set V) → Sym2 V := fun p => s((p.1 : V), (p.2 : V)) with hφ
  have hφinj : Function.Injective φ := by
    rintro ⟨⟨x, hx⟩, ⟨y, hy⟩⟩ ⟨⟨x', hx'⟩, ⟨y', hy'⟩⟩ h
    have h' : s(x, y) = s(x', y') := h
    rcases Sym2.eq_iff.mp h' with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · subst h1; subst h2; rfl
    · exact absurd (h1 ▸ hx) hy'
  have hsub : G.edgeSet ⊆ Set.range φ := by
    intro e he'
    induction e using Sym2.inductionOn with
    | _ x y =>
      have hxy : G.Adj x y := he'
      have hne : c x ≠ c y := c.valid hxy
      by_cases hx : c x = 0
      · have hy : y ∈ (Aᶜ : Set V) := fun hy => hne (hx.trans hy.symm)
        exact ⟨(⟨x, hx⟩, ⟨y, hy⟩), rfl⟩
      · have hy : c y = 0 := htwo _ _ hne hx
        exact ⟨(⟨y, hy⟩, ⟨x, hx⟩), Sym2.eq_swap⟩
  have hfin : (Set.range φ).Finite := Set.toFinite _
  have hcardrange : (Set.range φ).ncard = A.ncard * (Aᶜ : Set V).ncard := by
    rw [Set.ncard_range_of_injective hφinj, Nat.card_prod, Nat.card_coe_set_eq,
      Nat.card_coe_set_eq]
  have hcards : A.ncard + (Aᶜ : Set V).ncard = 2 * t + 1 := by
    rw [Set.ncard_add_ncard_compl A, hv]
  have hecard : G.edgeSet.ncard = t * (t + 1) := by rw [← Nat.card_coe_set_eq]; exact he
  have hle : t * (t + 1) ≤ A.ncard * (Aᶜ : Set V).ncard := by
    have h1 : G.edgeSet.ncard ≤ (Set.range φ).ncard := Set.ncard_le_ncard hsub hfin
    rw [hcardrange, hecard] at h1
    exact h1
  have hzint : ((A.ncard : ℤ) - t) * ((A.ncard : ℤ) - t - 1) ≤ 0 := by
    have h1 : (A.ncard : ℤ) + ((Aᶜ : Set V).ncard : ℤ) = 2 * t + 1 := by exact_mod_cast hcards
    have h2 : (t : ℤ) * (t + 1) ≤ (A.ncard : ℤ) * ((Aᶜ : Set V).ncard : ℤ) := by
      exact_mod_cast hle
    nlinarith
  have hge : t ≤ A.ncard := by
    by_contra hcon
    have hlt : (A.ncard : ℤ) < t := by exact_mod_cast Nat.not_le.mp hcon
    nlinarith
  have hup : A.ncard ≤ t + 1 := by
    by_contra hcon
    have hlt : ((t : ℤ) + 1) < A.ncard := by exact_mod_cast Nat.not_le.mp hcon
    nlinarith
  have hEq : G.edgeSet = Set.range φ := by
    refine Set.eq_of_subset_of_ncard_le hsub ?_ hfin
    rw [hcardrange, hecard]
    rcases (by omega : A.ncard = t ∨ A.ncard = t + 1) with h | h
    · have h2 : (Aᶜ : Set V).ncard = t + 1 := by omega
      rw [h, h2]
    · have h2 : (Aᶜ : Set V).ncard = t := by omega
      rw [h, h2, Nat.mul_comm]
  have hadj : ∀ x y, G.Adj x y ↔ (x ∈ A ↔ y ∉ A) := by
    intro x y
    constructor
    · intro h
      have hne : c x ≠ c y := c.valid h
      exact ⟨fun hxA hyA => hne (hxA.trans hyA.symm), fun hyA => htwo _ _ (Ne.symm hne) hyA⟩
    · intro h
      by_cases hx : x ∈ A
      · have hy : y ∈ (Aᶜ : Set V) := h.mp hx
        have hmem : s(x, y) ∈ Set.range φ := ⟨(⟨x, hx⟩, ⟨y, hy⟩), rfl⟩
        rw [← hEq] at hmem
        exact hmem
      · have hy : y ∈ A := by
          by_contra hy
          exact hx (h.mpr hy)
        have hxc : x ∈ (Aᶜ : Set V) := hx
        have hmem : s(y, x) ∈ Set.range φ := ⟨(⟨y, hy⟩, ⟨x, hxc⟩), rfl⟩
        rw [← hEq] at hmem
        exact (G.mem_edgeSet.mp hmem).symm
  rcases (by omega : A.ncard = t ∨ A.ncard = t + 1) with h | h
  · exact build A h (by omega) hadj
  · refine build (Aᶜ) (by omega) (by rw [compl_compl]; omega) ?_
    intro x y
    rw [hadj x y]
    simp only [Set.mem_compl_iff, not_not]
    tauto

end SimpleGraph.BalancedBipartiteRigidity
