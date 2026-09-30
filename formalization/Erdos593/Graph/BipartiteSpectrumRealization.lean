import Erdos593.Graph.BipartiteSpectrumBounds
import Mathlib.Combinatorics.SimpleGraph.Sum

/-!
# Exact finite bipartite spectrum realization

Construct actual graphs, retaining a spanning tree while selecting edges.
The component count is the cardinality of the actual reachability quotient.
-/

namespace SimpleGraph.BipartiteSpectrumRealization

open scoped Sym2

private theorem connected_intermediate {V : Type} [Fintype V]
    (K : SimpleGraph V) (hK : K.Connected) (m : ℕ)
    (hlo : Nat.card V ≤ m + 1) (hhi : m ≤ Nat.card K.edgeSet) :
    ∃ G : SimpleGraph V, G ≤ K ∧ G.Connected ∧ Nat.card G.edgeSet = m := by
  classical
  obtain ⟨T, hTK, hT⟩ := hK.exists_isTree_le
  have ht := (isTree_iff_connected_and_card.mp hT).2
  have htc : T.edgeFinset.card ≤ m := by
    rw [edgeFinset_card, ← Nat.card_eq_fintype_card]
    omega
  have hkc : m ≤ K.edgeFinset.card := by
    simpa only [edgeFinset_card, Nat.card_eq_fintype_card] using hhi
  obtain ⟨s, hTs, hsK, hsm⟩ :=
    Finset.exists_subsuperset_card_eq (edgeFinset_mono hTK) htc hkc
  let G := fromEdgeSet (s : Set (Sym2 V))
  have hTG : T ≤ G := by
    rw [le_fromEdgeSet_iff]
    intro e he
    exact hTs (mem_edgeFinset.mpr he)
  have hGK : G ≤ K := by
    intro x y hxy
    exact mem_edgeFinset.mp (hsK hxy.1)
  have hges : G.edgeSet = (s : Set (Sym2 V)) := by
    ext e
    rw [edgeSet_fromEdgeSet]
    constructor
    · exact fun h => h.1
    · intro he
      exact ⟨he, K.not_isDiag_of_mem_edgeFinset (hsK he)⟩
  refine ⟨G, hGK, hT.connected.mono hTG, ?_⟩
  rw [hges]
  simpa using hsm

private theorem sum_component_card {V W : Type} [Finite V] [Finite W]
    (G : SimpleGraph V) (H : SimpleGraph W) :
    Nat.card (G.sum H).ConnectedComponent =
      Nat.card G.ConnectedComponent + Nat.card H.ConnectedComponent := by
  classical
  let label : V ⊕ W → G.ConnectedComponent ⊕ H.ConnectedComponent :=
    Sum.map G.connectedComponentMk H.connectedComponentMk
  have hstep : ∀ x y, (G.sum H).Adj x y → label x = label y := by
    rintro (x | x) (y | y) h
    · have hxy : G.Adj x y := by simpa using h
      exact congrArg Sum.inl (ConnectedComponent.sound hxy.reachable)
    · simp at h
    · simp at h
    · have hxy : H.Adj x y := by simpa using h
      exact congrArg Sum.inr (ConnectedComponent.sound hxy.reachable)
  have hreach : ∀ x y, (G.sum H).Reachable x y → label x = label y := by
    rintro x y ⟨p⟩
    induction p with
    | nil => rfl
    | cons h _ ih => exact (hstep _ _ h).trans ih
  let e : (G.sum H).ConnectedComponent ≃
      G.ConnectedComponent ⊕ H.ConnectedComponent :=
    { toFun := Quot.lift label (fun x y h => hreach x y h)
      invFun := Sum.elim
        (ConnectedComponent.map (Embedding.sumInl (G := G) (H := H)).toHom)
        (ConnectedComponent.map (Embedding.sumInr (G := G) (H := H)).toHom)
      left_inv := by
        intro C
        refine C.ind ?_
        rintro (x | x) <;> rfl
      right_inv := by
        rintro (C | C)
        · exact C.ind (fun _ => rfl)
        · exact C.ind (fun _ => rfl) }
  rw [Nat.card_congr e, Nat.card_sum]

private theorem relabel_graph {V : Type} [Finite V] (G : SimpleGraph V)
    (hb : G.Colorable 2) (hno : ∀ x, ∃ y, G.Adj x y) (s m c : ℕ)
    (hv : Nat.card V = s) (he : Nat.card G.edgeSet = m)
    (hc : Nat.card G.ConnectedComponent = c) :
    ∃ J : SimpleGraph (Fin s), J.Colorable 2 ∧
      (∀ x, ∃ y, J.Adj x y) ∧ Nat.card J.edgeSet = m ∧
      Nat.card J.ConnectedComponent = c := by
  classical
  let e : V ≃ Fin s := (Finite.equivFin V).trans (finCongr hv)
  let i := Iso.map e G
  refine ⟨SimpleGraph.map e G, ?_, ?_, ?_, ?_⟩
  · obtain ⟨b⟩ := hb
    exact ⟨b.comp i.symm.toHom⟩
  · intro x
    obtain ⟨y, hy⟩ := hno (e.symm x)
    refine ⟨e y, ?_⟩
    have hh := i.map_adj_iff.mpr hy
    change (SimpleGraph.map e G).Adj (e (e.symm x)) (e y) at hh
    simpa only [e.apply_symm_apply] using hh
  · exact (Nat.card_congr i.mapEdgeSet).symm.trans he
  · exact (Nat.card_congr i.connectedComponentEquiv).symm.trans hc

theorem exists_connected (m t : ℕ) (hm : 1 ≤ m)
    (hlower : Erdos593.Spectrum.q m ≤ t) (hupper : t ≤ m + 1) :
    ∃ G : SimpleGraph (Fin t), G.Colorable 2 ∧ G.Connected ∧
      (∀ x, ∃ y, G.Adj x y) ∧ Nat.card G.edgeSet = m := by
  classical
  have hcap := (Erdos593.Spectrum.q_le_iff m t).mp hlower
  have ht : 2 ≤ t := by
    by_contra h
    have : t = 0 ∨ t = 1 := by omega
    rcases this with rfl | rfl <;> norm_num at hcap <;> omega
  let a := t / 2
  let b := t - a
  have ha : 0 < a := by dsimp [a]; omega
  have hb : 0 < b := by dsimp [a, b]; omega
  have hab : a + b = t := by dsimp [a, b]; omega
  have hbal : b = a ∨ b = a + 1 := by dsimp [a, b]; omega
  have hcapacity : m ≤ a * b := by
    rw [← hab] at hcap
    rcases hbal with h | h <;> rw [h] at hcap ⊢ <;> nlinarith
  letI : Nonempty (Fin a) := ⟨⟨0, ha⟩⟩
  letI : Nonempty (Fin b) := ⟨⟨0, hb⟩⟩
  let K := completeBipartiteGraph (Fin a) (Fin b)
  have hconn : K.Connected := by
    apply (connected_iff_exists_forall_reachable K).mpr
    refine ⟨Sum.inl ⟨0, ha⟩, ?_⟩
    rintro (x | y)
    · exact (show K.Adj (Sum.inl ⟨0, ha⟩) (Sum.inr ⟨0, hb⟩) by simp [K]).reachable.trans
        (show K.Adj (Sum.inr ⟨0, hb⟩) (Sum.inl x) by simp [K]).reachable
    · exact (show K.Adj (Sum.inl ⟨0, ha⟩) (Sum.inr y) by simp [K]).reachable
  have hcolor : K.Colorable 2 := by
    simpa using (CompleteBipartiteGraph.bicoloring (Fin a) (Fin b)).colorable
  have hkedges : Nat.card K.edgeSet = a * b := by
    have h := encard_edgeSet_completeBipartiteGraph (W₁ := Fin a) (W₂ := Fin b)
    rw [← K.edgeSet.toFinite.cast_ncard_eq, ENat.card_eq_coe_natCard,
      ENat.card_eq_coe_natCard] at h
    rw [Nat.card_coe_set_eq]
    simp only [Nat.card_fin] at h
    exact_mod_cast h
  have hv : Nat.card (Fin a ⊕ Fin b) = t := by simp [hab]
  obtain ⟨G, hGK, hG, hGe⟩ := connected_intermediate K hconn m
    (by omega) (by omega)
  have hbG : G.Colorable 2 := by
    obtain ⟨col⟩ := hcolor
    exact ⟨col.comp (Hom.ofLE hGK)⟩
  let e : (Fin a ⊕ Fin b) ≃ Fin t :=
    (Finite.equivFin (Fin a ⊕ Fin b)).trans (finCongr hv)
  let i := Iso.map e G
  have hJ : (SimpleGraph.map e G).Connected := i.connected_iff.mp hG
  haveI : Nontrivial (Fin t) := Fin.nontrivial_iff_two_le.mpr ht
  refine ⟨SimpleGraph.map e G, ?_, hJ, hJ.preconnected.exists_adj_of_nontrivial, ?_⟩
  · obtain ⟨col⟩ := hbG
    exact ⟨col.comp i.symm.toHom⟩
  · exact (Nat.card_congr i.mapEdgeSet).symm.trans hGe

theorem exists_shadow (m s c : ℕ) (hc : 1 ≤ c) (hcm : c ≤ m)
    (hlower : 2 * (c - 1) + Erdos593.Spectrum.q (m - c + 1) ≤ s)
    (hupper : s ≤ m + c) :
    ∃ G : SimpleGraph (Fin s), G.Colorable 2 ∧
      (∀ x, ∃ y, G.Adj x y) ∧ Nat.card G.edgeSet = m ∧
      Nat.card G.ConnectedComponent = c := by
  classical
  have hM : 1 ≤ m - c + 1 := by omega
  let M := m - c + 1
  let t := s - 2 * (c - 1)
  have htlow : Erdos593.Spectrum.q M ≤ t := by dsimp [t, M]; omega
  have hthigh : t ≤ M + 1 := by dsimp [t, M]; omega
  obtain ⟨J, hJb, hJc, hJno, hJe⟩ := exists_connected M t hM htlow hthigh
  haveI : Nonempty (Fin t) := hJc.nonempty
  haveI : Subsingleton J.ConnectedComponent := hJc.preconnected.subsingleton_connectedComponent
  have hJcc : Nat.card J.ConnectedComponent = 1 := Nat.card_unique
  obtain ⟨K, hKb, hKc, hKno, hKe⟩ := exists_connected 1 2 (by omega)
    ((Erdos593.Spectrum.q_le_iff 1 2).mpr (by norm_num)) (by omega)
  haveI : Subsingleton K.ConnectedComponent := hKc.preconnected.subsingleton_connectedComponent
  have hKcc : Nat.card K.ConnectedComponent = 1 := Nat.card_unique
  have assemble : ∀ d : ℕ, ∃ G : SimpleGraph (Fin (t + 2 * d)), G.Colorable 2 ∧
      (∀ x, ∃ y, G.Adj x y) ∧ Nat.card G.edgeSet = M + d ∧
      Nat.card G.ConnectedComponent = 1 + d := by
    intro d
    induction d with
    | zero =>
      simp only [Nat.mul_zero, Nat.add_zero]
      exact ⟨J, hJb, hJno, hJe, hJcc⟩
    | succ d ih =>
      obtain ⟨G, hbG, hnoG, heG, hcG⟩ := ih
      refine relabel_graph (G.sum K) (colorable_sum.mpr ⟨hbG, hKb⟩) ?_
        (t + 2 * (d + 1)) (M + (d + 1)) (1 + (d + 1)) ?_ ?_ ?_
      · rintro (x | x)
        · obtain ⟨y, hy⟩ := hnoG x
          exact ⟨Sum.inl y, by simpa using hy⟩
        · obtain ⟨y, hy⟩ := hKno x
          exact ⟨Sum.inr y, by simpa using hy⟩
      · simp; omega
      · rw [Nat.card_congr (edgeSetSumEquiv (G := G) (H := K)), Nat.card_sum, heG, hKe]
        omega
      · rw [sum_component_card, hcG, hKcc]; omega
  have hs : t + 2 * (c - 1) = s := by dsimp [t]; omega
  have he : M + (c - 1) = m := by dsimp [M]; omega
  have hcc : 1 + (c - 1) = c := by omega
  obtain ⟨G, hGb, hGno, hGe, hGc⟩ := assemble (c - 1)
  exact relabel_graph G hGb hGno s m c (by simpa only [Nat.card_fin] using hs)
    (hGe.trans he) (hGc.trans hcc)

end SimpleGraph.BipartiteSpectrumRealization
