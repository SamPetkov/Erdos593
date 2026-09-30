import Erdos593.TripleSystem.CanonicalAtomCoreRank
import Erdos593.Graph.AtomRankConcentration

/-! # Canonical atom budget, rank-one parity and extremal concentration

API-only scaffold: three disclosed proof holes, not proof evidence.
Counts and ranks refer to the existing actual canonical finite objects.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem connected_atom_q_budget
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles) (hconnected : F.levi.Connected) :
    Nat.card E + Nat.card (Index F) + 1 +
      (∑ A ∈ atomFinset F hlinear hbridge,
        Erdos593.Spectrum.q
          (_root_.SimpleGraph.FiniteCycleRank.cycleRank
            (atomRestriction F hlinear hbridge A).levi)) ≤
      Nat.card V := by
  classical
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hlinear hbridge)
  letI : Fintype (Index F) := Fintype.ofFinite _
  have hs : atomFinset F hlinear hbridge = Finset.univ := by
    ext A
    simp
  have hc : Nat.card F.levi.ConnectedComponent = 1 := by
    haveI := hconnected.nonempty
    haveI := hconnected.preconnected.subsingleton_connectedComponent
    exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
  let r (A : Index F) := _root_.SimpleGraph.FiniteCycleRank.cycleRank
    (atomRestriction F hlinear hbridge A).levi
  have hsum :
      (Nat.card (Index F) : ℤ) +
        ((∑ A ∈ atomFinset F hlinear hbridge, Erdos593.Spectrum.q (r A) : ℕ) : ℤ) ≤
      ∑ A ∈ atomFinset F hlinear hbridge, ((coreOrder F A : ℤ) - 1) := by
    calc
      _ = ∑ A ∈ atomFinset F hlinear hbridge,
          (1 + (Erdos593.Spectrum.q (r A) : ℤ)) := by
        simp [Finset.sum_add_distrib, hs, Nat.card_eq_fintype_card]
      _ ≤ _ := by
        apply Finset.sum_le_sum
        intro A _
        have hbound := atom_coreOrder_lower_bound F hlinear hbridge hberge A
        have hboundInt : (2 : ℤ) + Erdos593.Spectrum.q (r A) ≤ coreOrder F A := by
          exact_mod_cast hbound
        linarith
  have hsurplus := surplus_eq_core_sum F hlinear hbridge
  rw [hc] at hsurplus
  norm_num only [Nat.cast_one] at hsurplus
  have hresult :
      (Nat.card E : ℤ) + (Nat.card (Index F) : ℤ) + 1 +
        ((∑ A ∈ atomFinset F hlinear hbridge, Erdos593.Spectrum.q (r A) : ℕ) : ℤ) ≤
      Nat.card V := by
    linarith only [hsum, hsurplus]
  exact_mod_cast hresult

theorem atom_coreOrder_even_of_cycleRank_eq_one
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles) (A : Index F)
    (hrank :
      _root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge A).levi = 1) :
    Even (coreOrder F A) := by
  classical
  cases A with
  | singleton e hzero =>
    have hzeroRank := (atom_cycleRank_eq_zero_iff_singleton
      F hlinear hbridge (Index.singleton e hzero)).mpr ⟨e, hzero, rfl⟩
    omega
  | cycleBlock C hC B =>
    rw [cycleBlock_atom_cycleRank_eq_core F hlinear hbridge C hC B] at hrank
    exact _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.even_order_of_rank_one
      (cycleBlockCore F C B)
      (cycleBlockCore_isTwoVertexConnected F hlinear hbridge C hC B)
      (cycleBlockCore_isBipartite F hlinear hbridge hberge C hC B) hrank

theorem exists_concentrated_atom_of_extremal_count
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles) (hconnected : F.levi.Connected)
    (b : ℕ) (hb : 1 ≤ b)
    (hrank :
      _root_.SimpleGraph.FiniteCycleRank.cycleRank F.levi = b)
    (hcount :
      Nat.card V =
        Nat.card E + Nat.card (Index F) + 1 + Erdos593.Spectrum.q b) :
    ∃ A : Index F,
      _root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge A).levi = b ∧
      coreOrder F A = 2 + Erdos593.Spectrum.q b ∧
      ∀ B : Index F, B ≠ A →
        ∃ e : E, ∃ hzero :
          (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0,
          B = Index.singleton e hzero := by
  classical
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hlinear hbridge)
  letI : Fintype (Index F) := Fintype.ofFinite _
  let s : Finset (Index F) := atomFinset F hlinear hbridge
  let r : Index F → ℕ := fun A =>
    _root_.SimpleGraph.FiniteCycleRank.cycleRank
      (atomRestriction F hlinear hbridge A).levi
  let p : Finset (Index F) := s.filter (fun A => 0 < r A)
  have hall : ∀ A : Index F, A ∈ s :=
    fun A => mem_atomFinset F hlinear hbridge A
  have hsuniv : s = Finset.univ := by
    ext A
    simp [s]
  have hcard : s.card = Nat.card (Index F) := by
    simp [hsuniv, Nat.card_eq_fintype_card]
  have hsumr : (∑ A ∈ s, r A) = b := by
    exact (sum_atom_cycleRank F hlinear hbridge).trans hrank
  have hsumrP : (∑ A ∈ p, r A) = b := by
    calc
      _ = ∑ A ∈ s, r A := by
        simp only [p, Finset.sum_filter]
        apply Finset.sum_congr rfl
        intro A _
        by_cases hA : 0 < r A
        · simp only [hA, if_true]
        · have hz : r A = 0 := by omega
          rw [if_neg hA, hz]
      _ = b := hsumr
  have hq0 : Erdos593.Spectrum.q 0 = 0 := by
    norm_num [Erdos593.Spectrum.q]
  have hsumqP :
      (∑ A ∈ p, Erdos593.Spectrum.q (r A)) =
        ∑ A ∈ s, Erdos593.Spectrum.q (r A) := by
    simp only [p, Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro A _
    by_cases hA : 0 < r A
    · simp only [hA, if_true]
    · have hz : r A = 0 := by omega
      rw [if_neg hA, hz, hq0]
  have hpne : p.Nonempty := by
    by_contra h
    have hempty : p = ∅ := Finset.not_nonempty_iff_eq_empty.mp h
    have hb0 : b = 0 := by
      simpa only [hempty, Finset.sum_empty] using hsumrP.symm
    omega
  have hpRank : ∀ A ∈ p, 1 ≤ r A := by
    intro A hA
    exact Nat.succ_le_of_lt (Finset.mem_filter.mp hA).2
  have hbudget :=
    connected_atom_q_budget F hlinear hbridge hberge hconnected
  change Nat.card E + Nat.card (Index F) + 1 +
    (∑ A ∈ s, Erdos593.Spectrum.q (r A)) ≤ Nat.card V at hbudget
  have hqle :
      (∑ A ∈ p, Erdos593.Spectrum.q (r A)) ≤ Erdos593.Spectrum.q b := by
    rw [hsumqP]
    omega
  have hconc :=
    Erdos593.Spectrum.q_sum_add_card_le p r hpne hpRank
  rw [hsumrP] at hconc
  have hpcpos : 0 < p.card := Finset.card_pos.mpr hpne
  have hqeq :
      (∑ A ∈ p, Erdos593.Spectrum.q (r A)) = Erdos593.Spectrum.q b := by
    omega
  have hpone : p.card = 1 :=
    (Erdos593.Spectrum.sum_q_eq_q_sum_iff_card_eq_one p r hpne hpRank).mp (by
      rw [hsumrP]
      exact hqeq)
  obtain ⟨A, hpsingle⟩ := Finset.card_eq_one.mp hpone
  have hAr : r A = b := by
    simpa only [hpsingle, Finset.sum_singleton] using hsumrP
  have hzeroRank : ∀ B : Index F, B ≠ A → r B = 0 := by
    intro B hBA
    by_contra hB
    have hBp : B ∈ p :=
      Finset.mem_filter.mpr ⟨hall B, Nat.pos_of_ne_zero hB⟩
    have heq : B = A := by
      simpa only [hpsingle, Finset.mem_singleton] using hBp
    exact hBA heq
  have hsingle :
      ∀ B : Index F, B ≠ A →
        ∃ e : E, ∃ hzero :
          (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0,
          B = Index.singleton e hzero := by
    intro B hBA
    exact (atom_cycleRank_eq_zero_iff_singleton F hlinear hbridge B).mp
      (hzeroRank B hBA)
  have hsumDelta :
      (∑ B ∈ s, ((coreOrder F B : ℤ) - 2)) =
        (coreOrder F A : ℤ) - 2 := by
    apply Finset.sum_eq_single A
    · intro B _ hBA
      obtain ⟨e, hzero, heq⟩ := hsingle B hBA
      rw [heq]
      norm_num [coreOrder]
    · intro hnot
      exact False.elim (hnot (hall A))
  have hsumCore :
      (∑ B ∈ s, ((coreOrder F B : ℤ) - 1)) =
        (s.card : ℤ) + ((coreOrder F A : ℤ) - 2) := by
    calc
      _ = ∑ B ∈ s, ((1 : ℤ) + ((coreOrder F B : ℤ) - 2)) := by
        apply Finset.sum_congr rfl
        intro B _
        ring
      _ = (s.card : ℤ) + ((coreOrder F A : ℤ) - 2) := by
        rw [Finset.sum_add_distrib, hsumDelta]
        simp
  have hcomp : Nat.card F.levi.ConnectedComponent = 1 := by
    haveI := hconnected.nonempty
    haveI := hconnected.preconnected.subsingleton_connectedComponent
    exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
  have hsurp := surplus_eq_core_sum F hlinear hbridge
  rw [hcomp] at hsurp
  change (Nat.card V : ℤ) - (Nat.card E : ℤ) =
    1 + ∑ B ∈ s, ((coreOrder F B : ℤ) - 1) at hsurp
  rw [hsumCore, hcard] at hsurp
  have hcountInt :
      (Nat.card V : ℤ) =
        (Nat.card E : ℤ) + (Nat.card (Index F) : ℤ) + 1 +
          (Erdos593.Spectrum.q b : ℤ) := by
    exact_mod_cast hcount
  have hcoreInt :
      (coreOrder F A : ℤ) = 2 + (Erdos593.Spectrum.q b : ℤ) := by
    linarith only [hsurp, hcountInt]
  have hcore : coreOrder F A = 2 + Erdos593.Spectrum.q b := by
    exact_mod_cast hcoreInt
  exact ⟨A, hAr, hcore, hsingle⟩

end Erdos593.TripleSystem.CanonicalAtom
