import Erdos593.Graph.BalancedBipartiteRigidity
import Erdos593.TripleSystem.CanonicalAtomCounting
import Erdos593.TripleSystem.CanonicalAtomMinimalGenerators

/-! # Rigidity at the two balanced lower endpoints

The final conclusions use the existing incidence isomorphism and literal
private-vertex expansion. Structural atom concentration is derived, never
assumed at the manuscript endpoints. The two-edge small case is separate
because its complete bipartite core has a cut vertex.
-/

namespace Erdos593.TripleSystem

universe u v

theorem privateVertexExpansion_isomorphic_of_graphIso
    {V : Type u} {W : Type v} (G : _root_.SimpleGraph V)
    (H : _root_.SimpleGraph W) (i : G ≃g H) :
    Isomorphic (privateVertexExpansion G) (privateVertexExpansion H) := by
  refine ⟨{ vertexEquiv := Equiv.sumCongr i.toEquiv i.mapEdgeSet
            edgeEquiv := i.mapEdgeSet
            map_inc_iff := ?_ }⟩
  rintro (x | f) e
  · show x ∈ (e : Sym2 V) ↔ (i x) ∈ ((i.mapEdgeSet e : H.edgeSet) : Sym2 W)
    have hmap : ((i.mapEdgeSet e : H.edgeSet) : Sym2 W) = Sym2.map i (e : Sym2 V) := rfl
    rw [hmap, Sym2.mem_map]
    refine ⟨fun hx => ⟨x, hx, rfl⟩, ?_⟩
    rintro ⟨a, ha, hae⟩
    exact (i.toEquiv.injective hae) ▸ ha
  · show f = e ↔ i.mapEdgeSet f = i.mapEdgeSet e
    exact ⟨fun h => h ▸ rfl, fun h => i.mapEdgeSet.injective h⟩

namespace CanonicalAtom

section FiniteAtoms

variable {V E : Type u} [Fintype V] [Fintype E]
variable [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

theorem atomCore_capacity (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles) (A : Index F) :
    2 ≤ coreOrder F A ∧
      4 * atomEdgeCount F hlinear hbridge A ≤ (coreOrder F A) ^ 2 := by
  classical
  have hshape := atomRestriction_is_singleEdge_or_cycleBlockExpansion F hlinear hbridge A
  cases A with
  | singleton e hzero =>
    obtain ⟨i⟩ := hshape
    have he : atomEdgeCount F hlinear hbridge (.singleton e hzero) = 1 := by
      calc atomEdgeCount F hlinear hbridge (.singleton e hzero)
          = Nat.card (SingleEdgeIndex : Type u) := Nat.card_congr i.edgeEquiv
        _ = 1 := by simp [SingleEdgeIndex]
    have hcore : coreOrder F (Index.singleton e hzero) = 2 := rfl
    rw [he, hcore]
    norm_num
  | cycleBlock C hC B =>
    obtain ⟨i⟩ := hshape
    have hcore : coreOrder F (Index.cycleBlock C hC B) =
        Nat.card (finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
          (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B)) := rfl
    have he : atomEdgeCount F hlinear hbridge (.cycleBlock C hC B) =
        Nat.card (cycleBlockCore F C B).edgeSet := Nat.card_congr i.edgeEquiv
    have htwo := cycleBlockCore_isTwoVertexConnected F hlinear hbridge C hC B
    have hbip := cycleBlockCore_isBipartite F hlinear hbridge hberge C hC B
    have hcap := _root_.SimpleGraph.BipartiteSpectrumBounds.bipartite_capacity
      (cycleBlockCore F C B) hbip
    have hcard : Nat.card (finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
        (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B))
        = Fintype.card (finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
          (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B)) :=
      Nat.card_eq_fintype_card
    refine ⟨?_, ?_⟩
    · have h3 := htwo.1
      rw [hcore, hcard]
      omega
    · rw [hcore, he]
      exact hcap

theorem isomorphic_atomRestriction_of_all_edges_same_atom
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hreduced : F.HasNoIsolatedPoints) (A : Index F)
    (hall : ∀ e : E, atomOf F hlinear hbridge e = A) :
    Isomorphic F (atomRestriction F hlinear hbridge A) := by
  classical
  have hsetuniv : edges F hlinear hbridge A = (Set.univ : Set E) :=
    Set.eq_univ_of_forall hall
  show Isomorphic F (F.edgeRestriction (edges F hlinear hbridge A))
  rw [hsetuniv]
  exact ⟨(F.edgeRestrictionUnivIso hreduced).symm⟩

theorem card_index_eq_one_of_near_capacity
    (hintrinsic : F.Intrinsic) (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints)
    (hsurplus : 4 ≤ Nat.card V - Nat.card E)
    (hcapacity : (Nat.card V - Nat.card E) ^ 2 ≤ 4 * Nat.card E + 1) :
    Nat.card (Index F) = 1 := by
  classical
  obtain ⟨hlinear, hbridge, hberge⟩ := hintrinsic
  haveI : Finite (Index F) := Finite.of_surjective _ (atomOf_surjective F hlinear hbridge)
  letI : Fintype (Index F) := Fintype.ofFinite _
  set s : Finset (Index F) := atomFinset F hlinear hbridge with hs
  have hsuniv : s = Finset.univ := by
    ext A
    simp [hs]
  have hneE : Nonempty E := by
    by_contra hempty
    haveI : IsEmpty E := not_nonempty_iff.mp hempty
    have hVempty : IsEmpty V := by
      refine ⟨fun x => hreduced x ?_⟩
      intro e
      exact (IsEmpty.false e).elim
    have hV0 : Nat.card V = 0 := by simp
    have hE0 : Nat.card E = 0 := by simp
    rw [hV0, hE0] at hsurplus
    omega
  have hIndexNonempty : Nonempty (Index F) :=
    ⟨atomOf F hlinear hbridge (Classical.arbitrary E)⟩
  have hcomp : Nat.card F.levi.ConnectedComponent = 1 := by
    haveI := hconnected.nonempty
    haveI := hconnected.preconnected.subsingleton_connectedComponent
    exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
  have hv2 : ∀ A ∈ s, 2 ≤ coreOrder F A :=
    fun A _ => (atomCore_capacity F hlinear hbridge hberge A).1
  have hcastsum : ((∑ A ∈ s, (coreOrder F A - 1) : ℕ) : ℤ) =
      ∑ A ∈ s, ((coreOrder F A : ℤ) - 1) := by
    push_cast
    refine Finset.sum_congr rfl fun A hA => ?_
    have := hv2 A hA
    omega
  have hsurp := surplus_eq_core_sum F hlinear hbridge
  rw [hcomp, ← hs, ← hcastsum] at hsurp
  have hSnat : Nat.card V - Nat.card E = 1 + ∑ A ∈ s, (coreOrder F A - 1) := by
    omega
  have hsumsq : 4 * Nat.card E ≤ ∑ A ∈ s, (coreOrder F A) ^ 2 := by
    rw [← sum_atomEdgeCount F hlinear hbridge, ← hs, Finset.mul_sum]
    exact Finset.sum_le_sum
      fun A _ => (atomCore_capacity F hlinear hbridge hberge A).2
  have hcardone : s.card = 1 := by
    rcases Nat.lt_or_ge s.card 2 with hlt | hge
    · have hpos : 0 < s.card := Finset.card_pos.mpr ⟨Classical.arbitrary (Index F),
        by simp [hs]⟩
      omega
    · exfalso
      have hconc := Erdos593.Spectrum.strict_atom_capacity_concentration s
        (coreOrder F) hge hv2 (by omega)
      rw [← hSnat] at hconc
      omega
  rw [hsuniv] at hcardone
  rw [Nat.card_eq_fintype_card, ← Finset.card_univ]
  exact hcardone

end FiniteAtoms

end CanonicalAtom

theorem one_edge_isomorphic_complete_bipartite_expansion
    {V E : Type u} [Finite V] [Finite E] (F : TripleSystem V E)
    (hreduced : F.HasNoIsolatedPoints) (he : Nat.card E = 1) :
    Isomorphic F
      (privateVertexExpansion (_root_.completeBipartiteGraph (Fin 1) (Fin 1))) := by
  classical
  letI : Fintype V := Fintype.ofFinite V
  letI : Fintype E := Fintype.ofFinite E
  set K := _root_.completeBipartiteGraph (Fin 1) (Fin 1) with hK
  have hKadj : K.Adj (Sum.inl 0) (Sum.inr 0) := by
    simp [hK, _root_.completeBipartiteGraph]
  have hedgeK : ∀ c : K.edgeSet, (c : Sym2 (Fin 1 ⊕ Fin 1)) = s(Sum.inl 0, Sum.inr 0) := by
    rintro ⟨c, hc⟩
    induction c using Sym2.inductionOn with
    | _ x y =>
      have hxy : K.Adj x y := hc
      rcases x with x | x <;> rcases y with y | y <;>
        simp_all [_root_.completeBipartiteGraph, Subsingleton.elim x 0, Subsingleton.elim y 0]
  letI : Unique K.edgeSet :=
    { default := ⟨s(Sum.inl 0, Sum.inr 0), hKadj⟩
      uniq := fun c => Subtype.ext (hedgeK c) }
  letI : Fintype K.edgeSet := Fintype.ofFinite _
  have hcardEdgeK : Fintype.card K.edgeSet = 1 := Fintype.card_unique
  have hincK : ∀ (q : PrivateVertexExpansion.Point K) (c : PrivateVertexExpansion.Edge K),
      (privateVertexExpansion K).Inc q c := by
    intro q c
    rcases q with x | d
    · show x ∈ (c : Sym2 (Fin 1 ⊕ Fin 1))
      rw [hedgeK c]
      rcases x with x | x
      · rw [Subsingleton.elim x 0]; simp
      · rw [Subsingleton.elim x 0]; simp
    · show d = c
      exact Subsingleton.elim d c
  obtain ⟨hsubE, hneE⟩ := Nat.card_eq_one_iff_unique.mp he
  obtain ⟨e₀⟩ := hneE
  have hEsub : ∀ f : E, f = e₀ := fun f => hsubE.elim f e₀
  have hallinc : ∀ x : V, F.Inc x e₀ := by
    intro x
    obtain ⟨f, hf⟩ := F.not_isolated_iff_exists_inc.mp (hreduced x)
    rw [hEsub f] at hf
    exact hf
  have hV3 : Fintype.card V = 3 := by
    have huniv : {x : V | F.Inc x e₀} = Set.univ := Set.eq_univ_of_forall hallinc
    have hcard := F.edge_ncard e₀
    rw [huniv, Set.ncard_univ] at hcard
    rw [← Nat.card_eq_fintype_card]
    exact hcard
  have hPoint3 : Fintype.card (PrivateVertexExpansion.Point K) = 3 := by
    simp only [PrivateVertexExpansion.Point, PrivateVertexExpansion.CoreVertex,
      PrivateVertexExpansion.PrivateVertex, Fintype.card_sum, Fintype.card_fin, hcardEdgeK]
  have hE1 : Fintype.card E = 1 := by rw [← Nat.card_eq_fintype_card]; exact he
  refine ⟨{ vertexEquiv := Fintype.equivOfCardEq (hV3.trans hPoint3.symm)
            edgeEquiv := Fintype.equivOfCardEq (hE1.trans hcardEdgeK.symm)
            map_inc_iff := ?_ }⟩
  intro x e
  exact ⟨fun _ => hincK _ _, fun _ => by rw [hEsub e]; exact hallinc x⟩

theorem two_edges_isomorphic_complete_bipartite_expansion
    {V E : Type u} [Finite V] [Finite E] (F : TripleSystem V E)
    (hlinear : F.Linear) (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints) (he : Nat.card E = 2) :
    Isomorphic F
      (privateVertexExpansion (_root_.completeBipartiteGraph (Fin 1) (Fin 2))) := by
  classical
  obtain ⟨e₁, e₂, hne, huniv⟩ := Nat.card_eq_two_iff.mp he
  have htwo : ∀ f : E, f = e₁ ∨ f = e₂ := by
    intro f
    have hf : f ∈ ({e₁, e₂} : Set E) := by rw [huniv]; trivial
    simpa using hf
  have hshared : ∃ q : V, F.Inc q e₁ ∧ F.Inc q e₂ := by
    by_contra hno
    have hno' : ∀ q : V, F.Inc q e₁ → ¬F.Inc q e₂ := fun q h1 h2 => hno ⟨q, h1, h2⟩
    set S : Set (V ⊕ E) := {z | match z with
      | Sum.inl x => F.Inc x e₁
      | Sum.inr e => e = e₁} with hS
    have hclosed : ∀ z w, F.levi.Adj z w → z ∈ S → w ∈ S := by
      rintro (x | e) (y | f) hadj hz
      · exact absurd hadj (F.not_levi_adj_point_point)
      · have hxf : F.Inc x f := (F.levi_adj_point_edge).mp hadj
        have hx1 : F.Inc x e₁ := hz
        rcases htwo f with rfl | rfl
        · rfl
        · exact absurd hxf (hno' x hx1)
      · have hyf : F.Inc y e := (F.levi_adj_edge_point).mp hadj
        have hee : e = e₁ := hz
        subst hee
        exact hyf
      · exact absurd hadj (F.not_levi_adj_edge_edge)
    have hwalk : ∀ (z w : V ⊕ E) (t : F.levi.Walk z w), z ∈ S → w ∈ S := by
      intro z w t
      induction t with
      | nil => exact fun h => h
      | cons hadj q ih => exact fun h => ih (hclosed _ _ hadj h)
    obtain ⟨t⟩ := hconnected.preconnected (Sum.inr e₁) (Sum.inr e₂)
    exact hne (hwalk _ _ t rfl).symm
  obtain ⟨p, hp1, hp2⟩ := hshared
  have hthree : ∀ (S : Set V) (q : V), S.ncard = 3 → q ∈ S →
      ∃ u v, q ≠ u ∧ q ≠ v ∧ u ≠ v ∧ S = {q, u, v} := by
    intro S q hcard hq
    obtain ⟨c1, c2, c3, h12, h13, h23, hSeq⟩ := Set.ncard_eq_three.mp hcard
    subst hSeq
    rcases hq with h | h | h
    · exact ⟨c2, c3, by rw [h]; exact h12, by rw [h]; exact h13, h23, by rw [h]⟩
    · refine ⟨c1, c3, by rw [h]; exact Ne.symm h12, by rw [h]; exact h23, h13, ?_⟩
      rw [show q = c2 from h]
      ext z; simp; tauto
    · refine ⟨c1, c2, by rw [h]; exact Ne.symm h13, by rw [h]; exact Ne.symm h23, h12, ?_⟩
      rw [show q = c3 from h]
      ext z; simp; tauto
  obtain ⟨x1, x2, hpx1, hpx2, hx12, hE1⟩ :=
    hthree (F.edgeSet e₁) p (F.edgeSet_ncard e₁) hp1
  obtain ⟨y1, y2, hpy1, hpy2, hy12, hE2⟩ :=
    hthree (F.edgeSet e₂) p (F.edgeSet_ncard e₂) hp2
  have hcross : ∀ v, F.Inc v e₁ → F.Inc v e₂ → v = p :=
    fun v h1 h2 => hlinear hne h1 h2 hp1 hp2
  have hmem1 : ∀ v, F.Inc v e₁ ↔ (v = p ∨ v = x1 ∨ v = x2) := by
    intro v
    have hv : v ∈ F.edgeSet e₁ ↔ v ∈ ({p, x1, x2} : Set V) := by rw [hE1]
    simpa using hv
  have hmem2 : ∀ v, F.Inc v e₂ ↔ (v = p ∨ v = y1 ∨ v = y2) := by
    intro v
    have hv : v ∈ F.edgeSet e₂ ↔ v ∈ ({p, y1, y2} : Set V) := by rw [hE2]
    simpa using hv
  have hx1e1 : F.Inc x1 e₁ := (hmem1 x1).mpr (by tauto)
  have hx2e1 : F.Inc x2 e₁ := (hmem1 x2).mpr (by tauto)
  have hy1e2 : F.Inc y1 e₂ := (hmem2 y1).mpr (by tauto)
  have hy2e2 : F.Inc y2 e₂ := (hmem2 y2).mpr (by tauto)
  have hx1e2 : ¬F.Inc x1 e₂ := fun h => hpx1 (hcross x1 hx1e1 h).symm
  have hx2e2 : ¬F.Inc x2 e₂ := fun h => hpx2 (hcross x2 hx2e1 h).symm
  have hx1y1 : x1 ≠ y1 := fun h => hx1e2 (by rw [h]; exact hy1e2)
  have hx1y2 : x1 ≠ y2 := fun h => hx1e2 (by rw [h]; exact hy2e2)
  have hx2y1 : x2 ≠ y1 := fun h => hx2e2 (by rw [h]; exact hy1e2)
  have hx2y2 : x2 ≠ y2 := fun h => hx2e2 (by rw [h]; exact hy2e2)
  have hall : ∀ v : V, F.Inc v e₁ ∨ F.Inc v e₂ := by
    intro v
    obtain ⟨f, hf⟩ := F.not_isolated_iff_exists_inc.mp (hreduced v)
    rcases htwo f with rfl | rfl
    · exact Or.inl hf
    · exact Or.inr hf
  have hvsplit : ∀ v : V, v = p ∨ v = x1 ∨ v = x2 ∨ v = y1 ∨ v = y2 := by
    intro v
    rcases hall v with h | h
    · rcases (hmem1 v).mp h with h' | h' | h' <;> tauto
    · rcases (hmem2 v).mp h with h' | h' | h' <;> tauto
  set K := _root_.completeBipartiteGraph (Fin 1) (Fin 2) with hK
  have ha : K.Adj (Sum.inl 0) (Sum.inr 0) := by simp [hK, _root_.completeBipartiteGraph]
  have hb : K.Adj (Sum.inl 0) (Sum.inr 1) := by simp [hK, _root_.completeBipartiteGraph]
  set a : K.edgeSet := ⟨s(Sum.inl 0, Sum.inr 0), ha⟩ with hadef
  set b : K.edgeSet := ⟨s(Sum.inl 0, Sum.inr 1), hb⟩ with hbdef
  have hab : a ≠ b := by
    intro h
    have h' := congrArg Subtype.val h
    simp [hadef, hbdef] at h'
  have hclass : ∀ c : K.edgeSet, c = a ∨ c = b := by
    rintro ⟨c, hc⟩
    induction c using Sym2.inductionOn with
    | _ x y =>
      have hxy : K.Adj x y := hc
      rcases x with x | x <;> rcases y with y | y
      · exact absurd hxy (by simp [hK, _root_.completeBipartiteGraph])
      · fin_cases x
        fin_cases y
        · exact Or.inl (by rw [hadef]; rfl)
        · exact Or.inr (by rw [hbdef]; rfl)
      · fin_cases x <;> fin_cases y
        · exact Or.inl (by apply Subtype.ext; rw [hadef]; exact Sym2.eq_swap)
        · exact Or.inr (by apply Subtype.ext; rw [hbdef]; exact Sym2.eq_swap)
      · exact absurd hxy (by simp [hK, _root_.completeBipartiteGraph])
  refine ⟨Iso.symm (?iso : Iso (privateVertexExpansion K) F)⟩
  refine
    { vertexEquiv :=
        { toFun := fun q =>
            match q with
            | Sum.inl (Sum.inl _) => p
            | Sum.inl (Sum.inr j) => if j = 0 then x1 else y1
            | Sum.inr c => if c = a then x2 else y2
          invFun := fun v =>
            if v = p then Sum.inl (Sum.inl 0)
            else if v = x1 then Sum.inl (Sum.inr 0)
            else if v = x2 then Sum.inr a
            else if v = y1 then Sum.inl (Sum.inr 1)
            else Sum.inr b
          left_inv := ?_
          right_inv := ?_ }
      edgeEquiv :=
        { toFun := fun c => if c = a then e₁ else e₂
          invFun := fun e => if e = e₁ then a else b
          left_inv := ?_
          right_inv := ?_ }
      map_inc_iff := ?_ }
  · rintro ((j | j) | c)
    · fin_cases j
      simp
    · fin_cases j
      · simp [hpx1.symm]
      · simp [hpy1.symm, Ne.symm hx1y1, Ne.symm hx2y1]
    · rcases hclass c with rfl | rfl
      · simp [hpx2.symm, Ne.symm hx12]
      · simp [hab.symm, hpy2.symm, Ne.symm hx1y2, Ne.symm hx2y2, Ne.symm hy12]
  · intro v
    rcases hvsplit v with rfl | rfl | rfl | rfl | rfl
    · simp
    · simp [hpx1.symm]
    · simp [hpx2.symm, Ne.symm hx12]
    · simp [hpy1.symm, Ne.symm hx1y1, Ne.symm hx2y1]
    · simp [hpy2.symm, Ne.symm hx1y2, Ne.symm hx2y2, Ne.symm hy12, hab.symm]
  · intro c
    rcases hclass c with rfl | rfl
    · simp
    · simp [hab.symm, hne.symm]
  · intro e
    rcases htwo e with rfl | rfl
    · simp
    · simp [hne.symm, hab.symm]
  · intro q c
    rcases hclass c with rfl | rfl <;> rcases q with (j | j) | c'
    all_goals try (fin_cases j)
    all_goals try (rcases hclass c' with rfl | rfl)
    all_goals
      simp [privateVertexExpansion, PrivateVertexExpansion.Inc, hadef, hbdef, hmem1, hmem2,
        hpx1, hpx2, hx12, hpy1, hpy2, hy12, hx1y1, hx1y2, hx2y1, hx2y2,
        Ne.symm hpx1, Ne.symm hpx2, Ne.symm hx12, Ne.symm hpy1, Ne.symm hpy2, Ne.symm hy12,
        Ne.symm hx1y1, Ne.symm hx1y2, Ne.symm hx2y1, Ne.symm hx2y2]

theorem balanced_even_endpoint_rigidity
    {V E : Type u} [Finite V] [Finite E] (F : TripleSystem V E)
    (hconnected : F.levi.Connected) (hreduced : F.HasNoIsolatedPoints)
    (hobligatory : F.IsObligatory) (t : ℕ) (ht : 1 ≤ t)
    (he : Nat.card E = t ^ 2) (hv : Nat.card V = t ^ 2 + 2 * t) :
    Isomorphic F
      (privateVertexExpansion (_root_.completeBipartiteGraph (Fin t) (Fin t))) := by
  classical
  letI : Fintype V := Fintype.ofFinite V
  letI : Fintype E := Fintype.ofFinite E
  letI : DecidableEq V := Classical.decEq V
  letI : DecidableEq E := Classical.decEq E
  letI : DecidableRel F.levi.Adj := Classical.decRel _
  rcases Nat.lt_or_ge t 2 with hlt | hge
  · have ht1 : t = 1 := by omega
    subst ht1
    exact one_edge_isomorphic_complete_bipartite_expansion F hreduced (by simpa using he)
  · have hintrinsic : F.Intrinsic :=
      ((CanonicalAtom.atomGenerated_iff_constructible F).mp
        ((CanonicalAtom.isObligatory_iff_atomGenerated F).mp hobligatory)).intrinsic
    have hlin := hintrinsic.1
    have hbr := hintrinsic.2.1
    have hberge := hintrinsic.2.2
    have hsurplus : Nat.card V - Nat.card E = 2 * t := by rw [hv, he]; omega
    have hcapsq : (2 * t) ^ 2 = 4 * t ^ 2 := by ring
    have hone : Nat.card (CanonicalAtom.Index F) = 1 :=
      CanonicalAtom.card_index_eq_one_of_near_capacity F hintrinsic hconnected hreduced
        (by rw [hsurplus]; omega) (by rw [hsurplus, he, hcapsq]; omega)
    obtain ⟨hsubI, hneI⟩ := Nat.card_eq_one_iff_unique.mp hone
    obtain ⟨A⟩ := hneI
    have hcomp : Nat.card F.levi.ConnectedComponent = 1 := by
      haveI := hconnected.nonempty
      haveI := hconnected.preconnected.subsingleton_connectedComponent
      exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
    have hsingleton : CanonicalAtom.atomFinset F hlin hbr = {A} :=
      Finset.eq_singleton_iff_unique_mem.mpr
        ⟨CanonicalAtom.mem_atomFinset F hlin hbr A, fun B _ => hsubI.elim B A⟩
    have hall : ∀ e : E, CanonicalAtom.atomOf F hlin hbr e = A := fun e => hsubI.elim _ _
    have hisoA : Isomorphic F (CanonicalAtom.atomRestriction F hlin hbr A) :=
      CanonicalAtom.isomorphic_atomRestriction_of_all_edges_same_atom F hlin hbr hreduced A hall
    have hsurp := CanonicalAtom.surplus_eq_core_sum F hlin hbr
    rw [hsingleton, hcomp, Finset.sum_singleton] at hsurp
    have hcore : CanonicalAtom.coreOrder F A = 2 * t := by
      rw [hv, he] at hsurp
      push_cast at hsurp
      omega
    have hedgecount : CanonicalAtom.atomEdgeCount F hlin hbr A = Nat.card E := by
      have hsum := CanonicalAtom.sum_atomEdgeCount F hlin hbr
      rwa [hsingleton, Finset.sum_singleton] at hsum
    clear hsurp hsingleton hone hsubI
    cases A with
    | singleton e hzero =>
      exfalso
      have h2 : CanonicalAtom.coreOrder F (CanonicalAtom.Index.singleton e hzero) = 2 := rfl
      omega
    | cycleBlock C hC B =>
      obtain ⟨i⟩ := CanonicalAtom.atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
        F hlin hbr (CanonicalAtom.Index.cycleBlock C hC B)
      have hJedges : Nat.card (CanonicalAtom.cycleBlockCore F C B).edgeSet = t ^ 2 := by
        have hcongr : CanonicalAtom.atomEdgeCount F hlin hbr
            (CanonicalAtom.Index.cycleBlock C hC B) =
            Nat.card (CanonicalAtom.cycleBlockCore F C B).edgeSet := Nat.card_congr i.edgeEquiv
        rw [← hcongr, hedgecount, he]
      have hJverts : Nat.card (finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
          (CanonicalAtom.cycleBlockEdgeSet F C B)
          (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) = 2 * t := hcore
      have hbip : (CanonicalAtom.cycleBlockCore F C B).Colorable 2 :=
        CanonicalAtom.cycleBlockCore_isBipartite F hlin hbr hberge C hC B
      obtain ⟨g⟩ :=
        _root_.SimpleGraph.BalancedBipartiteRigidity.even_order_isomorphic_complete_bipartite
          (CanonicalAtom.cycleBlockCore F C B) hbip t hJverts hJedges
      have hiso2 : Isomorphic
          (CanonicalAtom.atomRestriction F hlin hbr (CanonicalAtom.Index.cycleBlock C hC B))
          (privateVertexExpansion (CanonicalAtom.cycleBlockCore F C B)) := ⟨i⟩
      exact hisoA.trans
        (hiso2.trans (privateVertexExpansion_isomorphic_of_graphIso _ _ g))

theorem balanced_odd_endpoint_rigidity
    {V E : Type u} [Finite V] [Finite E] (F : TripleSystem V E)
    (hconnected : F.levi.Connected) (hreduced : F.HasNoIsolatedPoints)
    (hobligatory : F.IsObligatory) (t : ℕ) (ht : 1 ≤ t)
    (he : Nat.card E = t * (t + 1))
    (hv : Nat.card V = t * (t + 1) + 2 * t + 1) :
    Isomorphic F
      (privateVertexExpansion (_root_.completeBipartiteGraph (Fin t) (Fin (t + 1)))) := by
  classical
  letI : Fintype V := Fintype.ofFinite V
  letI : Fintype E := Fintype.ofFinite E
  letI : DecidableEq V := Classical.decEq V
  letI : DecidableEq E := Classical.decEq E
  letI : DecidableRel F.levi.Adj := Classical.decRel _
  have hintrinsic : F.Intrinsic :=
    ((CanonicalAtom.atomGenerated_iff_constructible F).mp
      ((CanonicalAtom.isObligatory_iff_atomGenerated F).mp hobligatory)).intrinsic
  have hlin := hintrinsic.1
  have hbr := hintrinsic.2.1
  have hberge := hintrinsic.2.2
  rcases Nat.lt_or_ge t 2 with hlt | hge
  · have ht1 : t = 1 := by omega
    subst ht1
    exact two_edges_isomorphic_complete_bipartite_expansion F hlin hconnected hreduced
      (by simpa using he)
  · have hsurplus : Nat.card V - Nat.card E = 2 * t + 1 := by rw [hv, he]; omega
    have hcapsq : (2 * t + 1) ^ 2 = 4 * (t * (t + 1)) + 1 := by ring
    have hone : Nat.card (CanonicalAtom.Index F) = 1 :=
      CanonicalAtom.card_index_eq_one_of_near_capacity F hintrinsic hconnected hreduced
        (by rw [hsurplus]; omega) (by rw [hsurplus, he, hcapsq])
    obtain ⟨hsubI, hneI⟩ := Nat.card_eq_one_iff_unique.mp hone
    obtain ⟨A⟩ := hneI
    have hcomp : Nat.card F.levi.ConnectedComponent = 1 := by
      haveI := hconnected.nonempty
      haveI := hconnected.preconnected.subsingleton_connectedComponent
      exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
    have hsingleton : CanonicalAtom.atomFinset F hlin hbr = {A} :=
      Finset.eq_singleton_iff_unique_mem.mpr
        ⟨CanonicalAtom.mem_atomFinset F hlin hbr A, fun B _ => hsubI.elim B A⟩
    have hall : ∀ e : E, CanonicalAtom.atomOf F hlin hbr e = A := fun e => hsubI.elim _ _
    have hisoA : Isomorphic F (CanonicalAtom.atomRestriction F hlin hbr A) :=
      CanonicalAtom.isomorphic_atomRestriction_of_all_edges_same_atom F hlin hbr hreduced A hall
    have hsurp := CanonicalAtom.surplus_eq_core_sum F hlin hbr
    rw [hsingleton, hcomp, Finset.sum_singleton] at hsurp
    have hcore : CanonicalAtom.coreOrder F A = 2 * t + 1 := by
      rw [hv, he] at hsurp
      push_cast at hsurp
      omega
    have hedgecount : CanonicalAtom.atomEdgeCount F hlin hbr A = Nat.card E := by
      have hsum := CanonicalAtom.sum_atomEdgeCount F hlin hbr
      rwa [hsingleton, Finset.sum_singleton] at hsum
    clear hsurp hsingleton hone hsubI
    cases A with
    | singleton e hzero =>
      exfalso
      have h2 : CanonicalAtom.coreOrder F (CanonicalAtom.Index.singleton e hzero) = 2 := rfl
      omega
    | cycleBlock C hC B =>
      obtain ⟨i⟩ := CanonicalAtom.atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
        F hlin hbr (CanonicalAtom.Index.cycleBlock C hC B)
      have hJedges : Nat.card (CanonicalAtom.cycleBlockCore F C B).edgeSet = t * (t + 1) := by
        have hcongr : CanonicalAtom.atomEdgeCount F hlin hbr
            (CanonicalAtom.Index.cycleBlock C hC B) =
            Nat.card (CanonicalAtom.cycleBlockCore F C B).edgeSet := Nat.card_congr i.edgeEquiv
        rw [← hcongr, hedgecount, he]
      have hJverts : Nat.card (finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
          (CanonicalAtom.cycleBlockEdgeSet F C B)
          (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) = 2 * t + 1 := hcore
      have hbip : (CanonicalAtom.cycleBlockCore F C B).Colorable 2 :=
        CanonicalAtom.cycleBlockCore_isBipartite F hlin hbr hberge C hC B
      obtain ⟨g⟩ :=
        _root_.SimpleGraph.BalancedBipartiteRigidity.odd_order_isomorphic_complete_bipartite
          (CanonicalAtom.cycleBlockCore F C B) hbip t hJverts hJedges
      have hiso2 : Isomorphic
          (CanonicalAtom.atomRestriction F hlin hbr (CanonicalAtom.Index.cycleBlock C hC B))
          (privateVertexExpansion (CanonicalAtom.cycleBlockCore F C B)) := ⟨i⟩
      exact hisoA.trans
        (hiso2.trans (privateVertexExpansion_isomorphic_of_graphIso _ _ g))

end Erdos593.TripleSystem
