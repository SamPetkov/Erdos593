import Erdos593.TripleSystem.CanonicalAtomExtremalCount

/-! # Deficit accounting for actual canonical atoms

The additive count equation records the deficit from the positive-rank atom
bound. The exact identity separates concentration loss from excess core order.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem connected_atom_deficit_accounting
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles) (hconnected : F.levi.Connected)
    (b d : ℕ) (hb : 1 ≤ b)
    (hrank :
      _root_.SimpleGraph.FiniteCycleRank.cycleRank F.levi = b)
    (hcount : Nat.card V =
      Nat.card E + Nat.card (Index F) + 1 + Erdos593.Spectrum.q b + d) :
    let r : Index F → ℕ := fun A =>
      _root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge A).levi
    let p : Finset (Index F) :=
      (atomFinset F hlinear hbridge).filter (fun A => 0 < r A)
    let slack : Index F → ℕ := fun A =>
      coreOrder F A - (2 + Erdos593.Spectrum.q (r A))
    Erdos593.Spectrum.q b + d =
        (∑ A ∈ p, Erdos593.Spectrum.q (r A)) + (∑ A ∈ p, slack A) ∧
      p.card + (∑ A ∈ p, slack A) ≤ d + 1 ∧
      1 ≤ p.card := by
  classical
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hlinear hbridge)
  letI : Fintype (Index F) := Fintype.ofFinite _
  let a : Finset (Index F) := atomFinset F hlinear hbridge
  let r : Index F → ℕ := fun A =>
    _root_.SimpleGraph.FiniteCycleRank.cycleRank
      (atomRestriction F hlinear hbridge A).levi
  let p : Finset (Index F) := a.filter (fun A => 0 < r A)
  let slack : Index F → ℕ := fun A =>
    coreOrder F A - (2 + Erdos593.Spectrum.q (r A))
  change Erdos593.Spectrum.q b + d =
      (∑ A ∈ p, Erdos593.Spectrum.q (r A)) + (∑ A ∈ p, slack A) ∧
    p.card + (∑ A ∈ p, slack A) ≤ d + 1 ∧ 1 ≤ p.card
  have hauniv : a = Finset.univ := by
    ext A
    simp [a]
  have hacard : a.card = Nat.card (Index F) := by
    simp [hauniv, Nat.card_eq_fintype_card]
  have hsumr : (∑ A ∈ a, r A) = b :=
    (sum_atom_cycleRank F hlinear hbridge).trans hrank
  have hsumrP : (∑ A ∈ p, r A) = b := by
    calc
      _ = ∑ A ∈ a, r A := by
        simp only [p, Finset.sum_filter]
        apply Finset.sum_congr rfl
        intro A _
        by_cases hA : 0 < r A
        · simp only [hA, if_true]
        · have hz : r A = 0 := by omega
          rw [if_neg hA, hz]
      _ = b := hsumr
  have hqzero : Erdos593.Spectrum.q 0 = 0 := by
    norm_num [Erdos593.Spectrum.q]
  have hcorezero : ∀ A : Index F, r A = 0 → coreOrder F A = 2 := by
    intro A hA
    obtain ⟨e, hzero, rfl⟩ :=
      (atom_cycleRank_eq_zero_iff_singleton F hlinear hbridge A).mp hA
    rfl
  have hsumqP :
      (∑ A ∈ p, Erdos593.Spectrum.q (r A)) =
        ∑ A ∈ a, Erdos593.Spectrum.q (r A) := by
    simp only [p, Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro A _
    by_cases hA : 0 < r A
    · simp only [hA, if_true]
    · have hz : r A = 0 := by omega
      rw [if_neg hA, hz, hqzero]
  have hsumslackP : (∑ A ∈ p, slack A) = ∑ A ∈ a, slack A := by
    simp only [p, Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro A _
    by_cases hA : 0 < r A
    · simp only [hA, if_true]
    · have hz : r A = 0 := by omega
      have hs : slack A = 0 := by
        dsimp only [slack]
        rw [hcorezero A hz, hz, hqzero]
      rw [if_neg hA, hs]
  have hlocal : ∀ A : Index F,
      ((coreOrder F A : ℤ) - 1) =
        1 + (Erdos593.Spectrum.q (r A) : ℤ) + (slack A : ℤ) := by
    intro A
    have hbound : 2 + Erdos593.Spectrum.q (r A) ≤ coreOrder F A :=
      atom_coreOrder_lower_bound F hlinear hbridge hberge A
    have hnat : 2 + Erdos593.Spectrum.q (r A) + slack A = coreOrder F A := by
      dsimp only [slack]
      omega
    have hint : (2 : ℤ) + (Erdos593.Spectrum.q (r A) : ℤ) +
        (slack A : ℤ) = (coreOrder F A : ℤ) := by
      exact_mod_cast hnat
    omega
  have hsumcore :
      (∑ A ∈ a, ((coreOrder F A : ℤ) - 1)) =
        (Nat.card (Index F) : ℤ) +
          ((∑ A ∈ p, Erdos593.Spectrum.q (r A) : ℕ) : ℤ) +
          ((∑ A ∈ p, slack A : ℕ) : ℤ) := by
    calc
      _ = ∑ A ∈ a,
          ((1 : ℤ) + (Erdos593.Spectrum.q (r A) : ℤ) + (slack A : ℤ)) :=
        Finset.sum_congr rfl (fun A _ => hlocal A)
      _ = (a.card : ℤ) +
          ((∑ A ∈ a, Erdos593.Spectrum.q (r A) : ℕ) : ℤ) +
          ((∑ A ∈ a, slack A : ℕ) : ℤ) := by
        simp only [Finset.sum_add_distrib, Finset.sum_const,
          nsmul_eq_mul, mul_one, Nat.cast_sum]
      _ = _ := by rw [hacard, ← hsumqP, ← hsumslackP]
  have hcomponents : Nat.card F.levi.ConnectedComponent = 1 := by
    haveI := hconnected.nonempty
    haveI := hconnected.preconnected.subsingleton_connectedComponent
    exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
  have hsurplus := surplus_eq_core_sum F hlinear hbridge
  rw [hcomponents] at hsurplus
  change (Nat.card V : ℤ) - (Nat.card E : ℤ) =
    1 + ∑ A ∈ a, ((coreOrder F A : ℤ) - 1) at hsurplus
  rw [hsumcore] at hsurplus
  have hcountInt : (Nat.card V : ℤ) =
      (Nat.card E : ℤ) + (Nat.card (Index F) : ℤ) + 1 +
        (Erdos593.Spectrum.q b : ℤ) + (d : ℤ) := by
    exact_mod_cast hcount
  have haccountInt : (Erdos593.Spectrum.q b : ℤ) + (d : ℤ) =
      ((∑ A ∈ p, Erdos593.Spectrum.q (r A) : ℕ) : ℤ) +
        ((∑ A ∈ p, slack A : ℕ) : ℤ) := by
    linarith only [hsurplus, hcountInt]
  have haccount : Erdos593.Spectrum.q b + d =
      (∑ A ∈ p, Erdos593.Spectrum.q (r A)) + (∑ A ∈ p, slack A) := by
    exact_mod_cast haccountInt
  have hpnonempty : p.Nonempty := by
    by_contra h
    have hpempty : p = ∅ := Finset.not_nonempty_iff_eq_empty.mp h
    have hbzero : b = 0 := by
      simpa only [hpempty, Finset.sum_empty] using hsumrP.symm
    omega
  have hprank : ∀ A ∈ p, 1 ≤ r A := by
    intro A hA
    exact Nat.succ_le_of_lt (Finset.mem_filter.mp hA).2
  have hconcentration :=
    Erdos593.Spectrum.q_sum_add_card_le p r hpnonempty hprank
  rw [hsumrP] at hconcentration
  have hpcard : 0 < p.card := Finset.card_pos.mpr hpnonempty
  exact ⟨haccount, by omega, by omega⟩

end Erdos593.TripleSystem.CanonicalAtom
