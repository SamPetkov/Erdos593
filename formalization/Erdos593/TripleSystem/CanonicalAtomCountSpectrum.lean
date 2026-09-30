import Erdos593.TripleSystem.CanonicalAtomFiniteAttachment
import Erdos593.TripleSystem.CanonicalAtomBaseCount
import Erdos593.TripleSystem.CanonicalAtomExtremalCount

/-!
# Exact connected canonical atom-count spectrum

Statement/API scaffold with three disclosed proof holes.
No proof acceptance or full K2 completion is asserted.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

noncomputable def canonicalAtomCount {V E : Type u} [Fintype V] [Fintype E]
    (F : TripleSystem V E) : ℕ := by
  classical
  exact Nat.card (Index F)

def AllowedConnectedAtomCount (s b k : ℕ) : Prop :=
  (b = 0 ∧ 2 ≤ s ∧ k + 1 = s) ∨
  (b = 1 ∧ 1 ≤ k ∧ k + 3 ≤ s ∧ k % 2 = (s + 1) % 2) ∨
  (2 ≤ b ∧ 1 ≤ k ∧ k + 1 + Erdos593.Spectrum.q b ≤ s)

def ConnectedAtomParameters {V E : Type u} [Fintype V] [Fintype E]
    (F : TripleSystem V E) (s b k : ℕ) : Prop :=
  F.IsObligatory ∧ F.HasNoIsolatedPoints ∧ F.levi.Connected ∧
  Nonempty E ∧ Nat.card V = s + Nat.card E ∧
  _root_.SimpleGraph.FiniteCycleRank.cycleRank F.levi = b ∧
  canonicalAtomCount F = k

theorem connected_atom_count_necessity {V E : Type u}
    [Fintype V] [Fintype E] (F : TripleSystem V E) (s b k : ℕ)
    (hF : ConnectedAtomParameters F s b k) :
    AllowedConnectedAtomCount s b k :=
by
  classical
  obtain ⟨hobl, hred, hconn, hne, hcard, hrank, hkcount⟩ := hF
  -- the classification turns obligatoriness into the intrinsic conditions
  have hisoRed : TripleSystem.Iso F.isolatedReduction F :=
    { vertexEquiv := Equiv.subtypeUnivEquiv (fun x => hred x)
      edgeEquiv := Equiv.refl E
      map_inc_iff := fun _ _ => Iff.rfl }
  have hintrinsic : F.Intrinsic :=
    (TripleSystem.Iso.intrinsic_iff hisoRed).mp
      ((isObligatory_iff_isolatedReduction_intrinsic F).mp hobl)
  obtain ⟨hlinear, hbridge, hberge⟩ := hintrinsic
  letI : DecidableEq V := Classical.decEq V
  letI : DecidableEq E := Classical.decEq E
  letI : DecidableRel F.levi.Adj := Classical.decRel _
  have hidx : ∀ (dV : DecidableEq V) (dE : DecidableEq E)
      (dR : DecidableRel F.levi.Adj),
      canonicalAtomCount F = Nat.card (@Index V E F _ _ dV dE dR) := by
    intro dV dE dR
    have key : ∀ (d1 d2 : DecidableEq V) (e1 e2 : DecidableEq E)
        (r1 r2 : DecidableRel F.levi.Adj),
        Nat.card (@Index V E F _ _ d1 e1 r1) =
          Nat.card (@Index V E F _ _ d2 e2 r2) := by
      intro d1 d2 e1 e2 r1 r2
      rw [Subsingleton.elim d1 d2, Subsingleton.elim e1 e2,
        Subsingleton.elim r1 r2]
    unfold canonicalAtomCount
    exact key _ _ _ _ _ _
  have hkIdx : Nat.card (Index F) = k := by
    rw [← hkcount, hidx]
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hlinear hbridge)
  letI : Fintype (Index F) := Fintype.ofFinite _
  obtain ⟨e0⟩ := hne
  haveI : Nonempty (Index F) := ⟨atomOf F hlinear hbridge e0⟩
  have hkpos : 1 ≤ k := by
    rw [← hkIdx]
    exact Nat.card_pos
  have hsuniv : atomFinset F hlinear hbridge = Finset.univ := by
    ext A
    simp
  have hcardFinset : (atomFinset F hlinear hbridge).card = k := by
    rw [hsuniv, Finset.card_univ, ← Nat.card_eq_fintype_card, hkIdx]
  have hsumr :
      (∑ A ∈ atomFinset F hlinear hbridge,
        _root_.SimpleGraph.FiniteCycleRank.cycleRank
          (atomRestriction F hlinear hbridge A).levi) = b :=
    (sum_atom_cycleRank F hlinear hbridge).trans hrank
  have hbudget := connected_atom_q_budget F hlinear hbridge hberge hconn
  have hcomp : Nat.card F.levi.ConnectedComponent = 1 := by
    haveI := hconn.nonempty
    haveI := hconn.preconnected.subsingleton_connectedComponent
    exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
  have hcardInt : (Nat.card V : ℤ) = (s : ℤ) + (Nat.card E : ℤ) := by
    exact_mod_cast hcard
  have hsurp := surplus_eq_core_sum F hlinear hbridge
  rw [hcomp] at hsurp
  set r : Index F → ℕ := fun A =>
    _root_.SimpleGraph.FiniteCycleRank.cycleRank
      (atomRestriction F hlinear hbridge A).levi with hrdef
  have hsInt :
      (s : ℤ) = 1 + ∑ A ∈ atomFinset F hlinear hbridge,
        ((coreOrder F A : ℤ) - 1) := by
    push_cast at hsurp
    linarith
  have hsingle_core : ∀ A : Index F, r A = 0 → coreOrder F A = 2 := by
    intro A hA
    obtain ⟨e, hzero, rfl⟩ :=
      (atom_cycleRank_eq_zero_iff_singleton F hlinear hbridge A).mp hA
    rfl
  rcases Nat.eq_zero_or_pos b with hb0 | hbpos
  · -- rank zero: every atom is a single triple
    have hallzero : ∀ A ∈ atomFinset F hlinear hbridge, r A = 0 := by
      intro A hA
      have hzero := hsumr.trans hb0
      exact (Finset.sum_eq_zero_iff.mp hzero) A hA
    have hstep : ∀ A ∈ atomFinset F hlinear hbridge,
        ((coreOrder F A : ℤ) - 1) = 1 := by
      intro A hA
      rw [hsingle_core A (hallzero A hA)]
      norm_num
    have hsum1 :
        (∑ A ∈ atomFinset F hlinear hbridge, ((coreOrder F A : ℤ) - 1)) =
          (k : ℤ) := by
      rw [Finset.sum_congr rfl hstep, Finset.sum_const, hcardFinset]
      simp
    rw [hsum1] at hsInt
    have hsk : s = 1 + k := by exact_mod_cast hsInt
    exact Or.inl ⟨hb0, by omega, by omega⟩
  · -- positive rank: the concentration budget
    have hq1 : Erdos593.Spectrum.q 1 = 2 := by
      have hlo : 2 ≤ Erdos593.Spectrum.q 1 := by
        by_contra hcon
        have hle : Erdos593.Spectrum.q 1 ≤ 1 := by omega
        have hcap := (Erdos593.Spectrum.q_le_iff 1 1).mp hle
        omega
      have hhi := (Erdos593.Spectrum.q_le_iff 1 2).mpr (by norm_num)
      omega
    have hq0 : Erdos593.Spectrum.q 0 = 0 := by
      norm_num [Erdos593.Spectrum.q]
    set p : Finset (Index F) :=
      (atomFinset F hlinear hbridge).filter (fun A => 0 < r A) with hpdef
    have hsumrP : (∑ A ∈ p, r A) = b := by
      calc
        _ = ∑ A ∈ atomFinset F hlinear hbridge, r A := by
          simp only [hpdef, Finset.sum_filter]
          apply Finset.sum_congr rfl
          intro A _
          by_cases hA : 0 < r A
          · simp only [hA, if_true]
          · have hz : r A = 0 := by omega
            rw [if_neg hA, hz]
        _ = b := hsumr
    have hsumqP :
        (∑ A ∈ p, Erdos593.Spectrum.q (r A)) =
          ∑ A ∈ atomFinset F hlinear hbridge, Erdos593.Spectrum.q (r A) := by
      simp only [hpdef, Finset.sum_filter]
      apply Finset.sum_congr rfl
      intro A _
      by_cases hA : 0 < r A
      · simp only [hA, if_true]
      · have hz : r A = 0 := by omega
        rw [if_neg hA, hz, hq0]
    have hpne : p.Nonempty := by
      by_contra hcon
      have hempty : p = ∅ := Finset.not_nonempty_iff_eq_empty.mp hcon
      have hb0 : b = 0 := by
        simpa only [hempty, Finset.sum_empty] using hsumrP.symm
      omega
    have hpRank : ∀ A ∈ p, 1 ≤ r A := by
      intro A hA
      exact Nat.succ_le_of_lt (Finset.mem_filter.mp hA).2
    have hconc := Erdos593.Spectrum.q_sum_add_card_le p r hpne hpRank
    rw [hsumrP] at hconc
    have hpcpos : 0 < p.card := Finset.card_pos.mpr hpne
    have hqb :
        Erdos593.Spectrum.q b ≤
          ∑ A ∈ atomFinset F hlinear hbridge,
            Erdos593.Spectrum.q
              (_root_.SimpleGraph.FiniteCycleRank.cycleRank
                (atomRestriction F hlinear hbridge A).levi) := by
      have hstep : Erdos593.Spectrum.q b ≤
          ∑ A ∈ atomFinset F hlinear hbridge, Erdos593.Spectrum.q (r A) := by
        rw [← hsumqP]
        omega
      simpa only [hrdef] using hstep
    have hkey : k + 1 + Erdos593.Spectrum.q b ≤ s := by
      rw [hkIdx] at hbudget
      omega
    by_cases hb1 : b = 1
    · -- rank one: the core of the unique nontrivial atom has even order
      have hpcard : p.card = 1 := by
        have hle := Finset.card_nsmul_le_sum p r 1 hpRank
        simp only [smul_eq_mul, mul_one, hsumrP] at hle
        omega
      obtain ⟨A, hpsingle⟩ := Finset.card_eq_one.mp hpcard
      have hAr : r A = 1 := by
        rw [hpsingle, Finset.sum_singleton] at hsumrP
        omega
      have hother : ∀ B : Index F, B ≠ A → r B = 0 := by
        intro B hBA
        by_contra hB
        have hBp : B ∈ p :=
          Finset.mem_filter.mpr
            ⟨mem_atomFinset F hlinear hbridge B, Nat.pos_of_ne_zero hB⟩
        have heq : B = A := by
          simpa only [hpsingle, Finset.mem_singleton] using hBp
        exact hBA heq
      have hArExp :
          _root_.SimpleGraph.FiniteCycleRank.cycleRank
            (atomRestriction F hlinear hbridge A).levi = 1 := by
        simpa only [hrdef] using hAr
      have hAeven : Even (coreOrder F A) :=
        atom_coreOrder_even_of_cycleRank_eq_one F hlinear hbridge hberge A hArExp
      have hAlb := atom_coreOrder_lower_bound F hlinear hbridge hberge A
      rw [hArExp, hq1] at hAlb
      have hsumDelta :
          (∑ B ∈ atomFinset F hlinear hbridge, ((coreOrder F B : ℤ) - 2)) =
            (coreOrder F A : ℤ) - 2 := by
        apply Finset.sum_eq_single A
        · intro B _ hBA
          rw [hsingle_core B (hother B hBA)]
          norm_num
        · intro hnot
          exact False.elim (hnot (mem_atomFinset F hlinear hbridge A))
      have hsumCore :
          (∑ B ∈ atomFinset F hlinear hbridge, ((coreOrder F B : ℤ) - 1)) =
            (k : ℤ) + ((coreOrder F A : ℤ) - 2) := by
        calc
          _ = ∑ B ∈ atomFinset F hlinear hbridge,
              ((1 : ℤ) + ((coreOrder F B : ℤ) - 2)) := by
            apply Finset.sum_congr rfl
            intro B _
            ring
          _ = (k : ℤ) + ((coreOrder F A : ℤ) - 2) := by
            rw [Finset.sum_add_distrib, hsumDelta]
            simp [hcardFinset]
      rw [hsumCore] at hsInt
      have hsNat : s + 1 = k + coreOrder F A := by
        have hInt : (s : ℤ) + 1 = (k : ℤ) + (coreOrder F A : ℤ) := by
          linarith
        exact_mod_cast hInt
      have hmod : coreOrder F A % 2 = 0 := Nat.even_iff.mp hAeven
      exact Or.inr (Or.inl ⟨hb1, hkpos, by omega, by omega⟩)
    · exact Or.inr (Or.inr ⟨by omega, hkpos, hkey⟩)

theorem exists_connected_atom_count_iff (s b k : ℕ) :
    (∃ n m : ℕ, ∃ F : TripleSystem (Fin n) (Fin m),
      ConnectedAtomParameters F s b k) ↔ AllowedConnectedAtomCount s b k :=
by
  classical
  constructor
  · rintro ⟨n, m, F, hF⟩
    exact connected_atom_count_necessity F s b k hF
  · intro h
    have core_witness : ∀ (W : Type) (instW : Fintype W)
        (G : _root_.SimpleGraph W), G.Colorable 2 →
        (∀ x : W, ∃ y, G.Adj x y) → G.Connected →
        OnePointIndecomposable (privateVertexExpansion G) →
        ∀ v r t : ℕ, Nat.card W = v →
        _root_.SimpleGraph.FiniteCycleRank.cycleRank G = r →
        ∃ n m : ℕ, ∃ F : TripleSystem (Fin n) (Fin m),
          ConnectedAtomParameters F (v + t) r (1 + t) := by
      intro W instW G hb hno hconn hindec v r t hv hr
      letI := instW
      classical
      have hconn_of_card : ∀ {Z : Type} (H : _root_.SimpleGraph Z),
          Nat.card H.ConnectedComponent = 1 → H.Connected := by
        intro Z H h
        obtain ⟨hsub, hne⟩ := Nat.card_eq_one_iff_unique.mp h
        obtain ⟨C⟩ := hne
        exact { preconnected := fun x y =>
                  _root_.SimpleGraph.ConnectedComponent.exact (Subsingleton.elim _ _)
                nonempty := ⟨C.out⟩ }
      have hcomp1 : ∀ {Z : Type} (H : _root_.SimpleGraph Z), H.Connected →
          Nat.card H.ConnectedComponent = 1 := by
        intro Z H hH
        haveI := hH.nonempty
        haveI := hH.preconnected.subsingleton_connectedComponent
        exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
      have hidx : ∀ (a c : ℕ) (Z : TripleSystem (Fin a) (Fin c))
          (dV : DecidableEq (Fin a)) (dE : DecidableEq (Fin c))
          (dR : DecidableRel Z.levi.Adj),
          canonicalAtomCount Z = Nat.card (@Index (Fin a) (Fin c) Z _ _ dV dE dR) := by
        intro a c Z dV dE dR
        have key : ∀ (d1 d2 : DecidableEq (Fin a)) (e1 e2 : DecidableEq (Fin c))
            (r1 r2 : DecidableRel Z.levi.Adj),
            Nat.card (@Index (Fin a) (Fin c) Z _ _ d1 e1 r1) =
              Nat.card (@Index (Fin a) (Fin c) Z _ _ d2 e2 r2) := by
          intro d1 d2 e1 e2 r1 r2
          rw [Subsingleton.elim d1 d2, Subsingleton.elim e1 e2, Subsingleton.elim r1 r2]
        unfold canonicalAtomCount
        exact key _ _ _ _ _ _
      -- the private-vertex expansion of the core
      obtain ⟨hXobl, hXred, hXedge, hXpoint, hXcomp⟩ :=
        privateVertexExpansion_shadow_parameters G hb hno
      have hXint : (privateVertexExpansion G).Intrinsic :=
        privateVertexExpansion_intrinsic G hb
      have hXconn : (privateVertexExpansion G).levi.Connected := by
        apply hconn_of_card
        rw [hXcomp]
        exact hcomp1 G hconn
      set e := Nat.card G.edgeSet with hedef
      have hepos : 1 ≤ e := by
        obtain ⟨x⟩ := hconn.nonempty
        obtain ⟨y, hxy⟩ := hno x
        haveI : Nonempty G.edgeSet := ⟨⟨s(x, y), hxy⟩⟩
        exact Nat.card_pos
      have hEuler :=
        _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.connected_cycleRank_euler G hconn
      rw [hr] at hEuler
      -- reindex onto `Fin` carriers
      have hPcard : Nat.card (PrivateVertexExpansion.Point G) = v + e := by
        rw [hXpoint, ← Nat.card_eq_fintype_card, hv]
      have hEcard : Nat.card (PrivateVertexExpansion.Edge G) = e := hXedge
      let ev : PrivateVertexExpansion.Point G ≃ Fin (v + e) :=
        (Finite.equivFin _).trans (finCongr hPcard)
      let ee : PrivateVertexExpansion.Edge G ≃ Fin e :=
        (Finite.equivFin _).trans (finCongr hEcard)
      let Y : TripleSystem (Fin (v + e)) (Fin e) :=
        TriangleHostTransport.reindex (privateVertexExpansion G) ev ee
      let i : TripleSystem.Iso (privateVertexExpansion G) Y :=
        { vertexEquiv := ev
          edgeEquiv := ee
          map_inc_iff := fun x d =>
            (TriangleHostTransport.reindex_inc_iff _ ev ee x d).symm }
      letI : DecidableRel Y.levi.Adj := Classical.decRel _
      have hYint : Y.Intrinsic := (TripleSystem.Iso.intrinsic_iff i).mp hXint
      have hYred : Y.HasNoIsolatedPoints := by
        intro x
        apply (not_isolated_iff_exists_inc Y).mpr
        obtain ⟨d, hd⟩ := (not_isolated_iff_exists_inc _).mp (hXred (ev.symm x))
        refine ⟨ee d, ?_⟩
        simpa [i] using (i.map_inc_iff (ev.symm x) d).mp hd
      have hYconn : Y.levi.Connected :=
        (TripleSystem.Iso.leviIso i).connected_iff.mp hXconn
      have hYindec : OnePointIndecomposable Y :=
        (onePointIndecomposable_iff_of_iso i).mp hindec
      have hYcount : Nat.card (Index Y) = 1 :=
        card_index_eq_one_of_onePointIndecomposable Y hYint hYconn hYred hYindec
      have hYrank : _root_.SimpleGraph.FiniteCycleRank.cycleRank Y.levi = r := by
        have h1 := levi_cycleRank Y
        rw [hcomp1 _ hYconn] at h1
        simp only [Nat.card_eq_fintype_card, Fintype.card_fin] at h1
        omega
      -- attach `t` further triples
      obtain ⟨H, hH1, hH2, hH3, hH4, hH5⟩ :=
        exists_finite_attachment_parameters (v + e) e t Y hYint hYconn hYred
      refine ⟨v + e + 2 * t, e + t, H, ?_, hH2, hH3, ⟨⟨0, by omega⟩⟩, ?_, ?_, ?_⟩
      · -- obligatory
        refine (isObligatory_iff_isolatedReduction_intrinsic H).mpr ?_
        have iso : TripleSystem.Iso H.isolatedReduction H :=
          { vertexEquiv := Equiv.subtypeUnivEquiv (fun x => hH2 x)
            edgeEquiv := Equiv.refl _
            map_inc_iff := fun x d => Iff.rfl }
        exact (TripleSystem.Iso.intrinsic_iff iso).mpr hH1
      · simp only [Nat.card_eq_fintype_card, Fintype.card_fin]
        omega
      · rw [hH4, hYrank]
      · rw [hidx _ _ H _ _ (Classical.decRel _), hH5, hYcount]
    have core_expansion_case : ∀ (v : ℕ) (G : _root_.SimpleGraph (Fin v)),
        IsTwoVertexConnected G → G.Colorable 2 → ∀ r s k : ℕ,
        _root_.SimpleGraph.FiniteCycleRank.cycleRank G = r → 1 ≤ k →
        v + (k - 1) = s →
        ∃ n m : ℕ, ∃ F : TripleSystem (Fin n) (Fin m),
          ConnectedAtomParameters F s r k := by
      intro v G htwo hbip r s k hr hk hs
      classical
      have hconn := _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.two_connected_connected G htwo
      have hno : ∀ x : Fin v, ∃ y, G.Adj x y := by
        intro x
        have h2 :=
          _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.two_connected_min_degree G htwo x
        have hpos : 0 < Nat.card (G.neighborSet x) := by omega
        obtain ⟨y, hy⟩ := (Nat.card_pos_iff.mp hpos).1
        exact ⟨y, hy⟩
      let C : TwoConnectedBipartiteCore.{0} :=
        { Vertex := Fin v
          vertexFintype := inferInstance
          graph := G
          twoVertexConnected := htwo
          bipartite := hbip }
      have hindec : OnePointIndecomposable (privateVertexExpansion G) :=
        coreExpansion_onePointIndecomposable C
      obtain ⟨n, m, F, hFp⟩ :=
        core_witness (Fin v) inferInstance G hbip hno hconn hindec v r (k - 1)
          (by simp) hr
      refine ⟨n, m, F, ?_⟩
      have h2 : 1 + (k - 1) = k := by omega
      rwa [hs, h2] at hFp
    rcases h with ⟨hb0, hs2, hks⟩ | ⟨hb1, hk1, hks, hpar⟩ | ⟨hb2, hk1, hq⟩
    · -- rank zero: a single triple with `k - 1` further triples attached
      subst hb0
      have hkpos : 1 ≤ k := by omega
      haveI : Unique (PrivateVertexExpansion.Edge oneEdgeGraph.{0}) :=
        { default := oneEdgeGraphEdge.{0}, uniq := oneEdgeGraph_edge_eq }
      have hcard : Nat.card (oneEdgeGraph.{0}).edgeSet = 1 := Nat.card_unique
      have hconn : (oneEdgeGraph.{0}).Connected := by
        haveI : Nonempty OneEdgeVertex.{0} := ⟨ULift.up 0⟩
        refine { preconnected := ?_, nonempty := inferInstance }
        intro x y
        by_cases hxy : x = y
        · exact hxy ▸ _root_.SimpleGraph.Reachable.refl x
        · exact _root_.SimpleGraph.Adj.reachable hxy
      have hno : ∀ x : OneEdgeVertex.{0}, ∃ y, (oneEdgeGraph.{0}).Adj x y := by
        intro x
        rcases x with ⟨x⟩
        refine ⟨ULift.up (if x = 0 then 1 else 0), ?_⟩
        fin_cases x <;> decide
      have hv : Nat.card OneEdgeVertex.{0} = 2 := by simp
      have hr : _root_.SimpleGraph.FiniteCycleRank.cycleRank oneEdgeGraph.{0} = 0 := by
        have heuler :=
          _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.connected_cycleRank_euler
            oneEdgeGraph.{0} hconn
        rw [hcard, hv] at heuler
        omega
      obtain ⟨n, m, F, hFp⟩ := core_witness OneEdgeVertex.{0} inferInstance
        oneEdgeGraph.{0} oneEdgeGraph_colorable_two hno hconn
        oneTriple_onePointIndecomposable 2 0 (k - 1) hv hr
      refine ⟨n, m, F, ?_⟩
      have h1 : 2 + (k - 1) = s := by omega
      have h2 : 1 + (k - 1) = k := by omega
      rwa [h1, h2] at hFp
    · -- rank one: an even cycle core with `k - 1` further triples attached
      subst hb1
      obtain ⟨G, htwo, hbip, hGr⟩ :=
        (_root_.SimpleGraph.TwoConnectedBipartiteSpectrum.exists_rank_one_iff
          (s - k + 1)).mpr ⟨by omega, by rw [Nat.even_iff]; omega⟩
      exact core_expansion_case (s - k + 1) G htwo hbip 1 s k hGr
        (by omega) (by omega)
    · -- rank at least two: a core of rank `b` with `k - 1` further triples
      obtain ⟨G, htwo, hbip, hGr⟩ :=
        _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.exists_of_rank_ge_two
          b (s - k + 1) hb2 (by omega)
      exact core_expansion_case (s - k + 1) G htwo hbip b s k hGr
        (by omega) (by omega)

theorem exists_maximum_atom_count (s b : ℕ) (hb : 1 ≤ b)
    (hs : 2 + Erdos593.Spectrum.q b ≤ s) :
    ∃ n m : ℕ, ∃ F : TripleSystem (Fin n) (Fin m),
      ConnectedAtomParameters F s b (s - 1 - Erdos593.Spectrum.q b) :=
by
  refine (exists_connected_atom_count_iff s b (s - 1 - Erdos593.Spectrum.q b)).mpr ?_
  by_cases hb1 : b = 1
  · have hq1 : Erdos593.Spectrum.q 1 = 2 := by
      have hlo : 2 ≤ Erdos593.Spectrum.q 1 := by
        by_contra hcon
        have hle : Erdos593.Spectrum.q 1 ≤ 1 := by omega
        have hcap := (Erdos593.Spectrum.q_le_iff 1 1).mp hle
        omega
      have hhi := (Erdos593.Spectrum.q_le_iff 1 2).mpr (by norm_num)
      omega
    rw [hb1, hq1] at hs ⊢
    exact Or.inr (Or.inl ⟨rfl, by omega, by omega, by omega⟩)
  · exact Or.inr (Or.inr ⟨by omega, by omega, by omega⟩)

end Erdos593.TripleSystem.CanonicalAtom
