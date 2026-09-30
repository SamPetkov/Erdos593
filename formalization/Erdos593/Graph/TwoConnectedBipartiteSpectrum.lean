import Erdos593.Graph.BipartiteSpectrumBounds
import Erdos593.Graph.FiniteCycleRank
import Erdos593.TripleSystem.CanonicalAtomCoreStructure

/-!
# Minimum order at fixed positive cycle rank

Unintegrated proposition/API surface only: twelve intentional proof holes.
The graph, vertex-deletion two-connectivity, coloring and cycle rank are
literal objects, not numerical substitutes or target-equivalent assumptions.
-/

namespace SimpleGraph.TwoConnectedBipartiteSpectrum

universe u w

theorem two_connected_connected {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G) :
    G.Connected := by
  classical
  haveI : Nonempty V := Fintype.card_pos_iff.mp (by have := htwo.1; omega)
  refine { preconnected := ?_, nonempty := inferInstance }
  intro x y
  have hsmall : ({x, y} : Finset V).card < (Finset.univ : Finset V).card := by
    have hp : ({x, y} : Finset V).card ≤ 2 := by
      by_cases hxy : x = y <;> simp [hxy]
    rw [Finset.card_univ]
    have := htwo.1
    omega
  obtain ⟨z, _, hz⟩ := Finset.exists_mem_notMem_of_card_lt_card hsmall
  have hx : x ≠ z := by intro h; exact hz (by simp [h])
  have hy : y ≠ z := by intro h; exact hz (by simp [h])
  let inc : G.induce {p : V | p ≠ z} →g G :=
    ⟨Subtype.val, fun h => h⟩
  exact ((htwo.2 z).preconnected ⟨x, hx⟩ ⟨y, hy⟩).map inc

theorem two_connected_min_degree {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G) (x : V) :
    2 ≤ Nat.card (G.neighborSet x) := by
  classical
  haveI : Nontrivial V := Fintype.one_lt_card_iff_nontrivial.mp (by
    have := htwo.1
    omega)
  obtain ⟨y, hxy⟩ :=
    (two_connected_connected G htwo).preconnected.exists_adj_of_nontrivial x
  have hsmall : ({x, y} : Finset V).card < (Finset.univ : Finset V).card := by
    have hp : ({x, y} : Finset V).card ≤ 2 := by
      by_cases h : x = y <;> simp [h]
    rw [Finset.card_univ]
    have := htwo.1
    omega
  obtain ⟨z, _, hz⟩ := Finset.exists_mem_notMem_of_card_lt_card hsmall
  have hxz : x ≠ z := by intro h; exact hz (by simp [h])
  have hzy : z ≠ y := by intro h; exact hz (by simp [h])
  let X : {p : V | p ≠ y} := ⟨x, hxy.ne⟩
  let Z : {p : V | p ≠ y} := ⟨z, hzy⟩
  haveI : Nontrivial {p : V | p ≠ y} :=
    ⟨⟨X, Z, fun h => hxz (congrArg Subtype.val h)⟩⟩
  obtain ⟨w, hw⟩ := (htwo.2 y).preconnected.exists_adj_of_nontrivial X
  have hxw : G.Adj x w.val := hw
  rw [Nat.card_coe_set_eq]
  exact (Set.one_lt_ncard_iff (s := G.neighborSet x)).mpr
    ⟨y, w.val, hxy, hxw, Ne.symm w.property⟩

theorem two_connected_mono {V : Type u} [Fintype V] (G H : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hle : G ≤ H) :
    Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected H := by
  refine ⟨htwo.1, fun x => (htwo.2 x).mono ?_⟩
  intro a b hab
  exact hle hab

theorem two_connected_of_iso {V : Type u} {W : Type w} [Fintype V] [Fintype W]
    (G : SimpleGraph V) (H : SimpleGraph W) (i : G ≃g H)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G) :
    Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected H := by
  refine ⟨?_, ?_⟩
  · have hcard := Fintype.card_congr i.toEquiv
    have := htwo.1
    omega
  · intro x
    have hj : Set.BijOn i {v : V | v ≠ i.symm x} {w : W | w ≠ x} := by
      refine ⟨?_, i.injective.injOn, ?_⟩
      · intro v hv
        change i v ≠ x
        intro h
        apply hv
        apply i.injective
        simpa only [RelIso.apply_symm_apply] using h
      · intro w hw
        refine ⟨i.symm w, ?_, by simp⟩
        intro h
        exact hw (i.symm.injective h)
    exact (i.induce hj).connected_iff.mp (htwo.2 (i.symm x))

theorem connected_cycleRank_euler {V : Type u} [Fintype V] (G : SimpleGraph V)
    (hc : G.Connected) :
    Nat.card G.edgeSet + 1 = SimpleGraph.FiniteCycleRank.cycleRank G + Nat.card V := by
  haveI : Nonempty V := hc.nonempty
  haveI : Subsingleton G.ConnectedComponent := hc.preconnected.subsingleton_connectedComponent
  have hcc : Nat.card G.ConnectedComponent = 1 := Nat.card_unique
  have hle := SimpleGraph.FiniteCycleRank.card_vertices_le_edges_add_components G
  rw [hcc] at hle
  simp only [SimpleGraph.FiniteCycleRank.cycleRank, hcc]
  omega

theorem minimum_order {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hb : G.Colorable 2)
    (hr : 1 ≤ SimpleGraph.FiniteCycleRank.cycleRank G) :
    2 + Erdos593.Spectrum.q (SimpleGraph.FiniteCycleRank.cycleRank G)
      ≤ Nat.card V := by
  obtain ⟨k, hk⟩ := Nat.exists_eq_add_of_le hr
  have hv : 3 ≤ Nat.card V := by
    simpa only [Nat.card_eq_fintype_card] using htwo.1
  have he := connected_cycleRank_euler G (two_connected_connected G htwo)
  rw [hk] at he ⊢
  have hcap := SimpleGraph.BipartiteSpectrumBounds.bipartite_capacity G hb
  have hvsub : Nat.card V - 2 + 2 = Nat.card V := by omega
  have hsq : 4 * (1 + k) ≤ (Nat.card V - 2) ^ 2 := by
    nlinarith
  have hq := (Erdos593.Spectrum.q_le_iff (1 + k) (Nat.card V - 2)).mpr hsq
  omega

theorem even_order_of_rank_one {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hb : G.Colorable 2) (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 1) :
    Even (Nat.card V) := by
  classical
  have hEuler := connected_cycleRank_euler G (two_connected_connected G htwo)
  have hedge : Nat.card G.edgeSet = Nat.card V := by omega
  have hdegrees : ∀ x, 2 ≤ G.degree x := by
    intro x
    have h := two_connected_min_degree G htwo x
    simpa only [Nat.card_eq_fintype_card, G.card_neighborSet_eq_degree] using h
  have hsum : (∑ x : V, G.degree x) = ∑ _x : V, (2 : ℕ) := by
    calc
      (∑ x : V, G.degree x) = 2 * G.edgeFinset.card :=
        G.sum_degrees_eq_twice_card_edges
      _ = 2 * Nat.card V := by
        rw [G.edgeFinset_card, ← Nat.card_eq_fintype_card, hedge]
      _ = ∑ _x : V, (2 : ℕ) := by
        simp [Nat.card_eq_fintype_card, mul_comm]
  have hdegree : ∀ x, G.degree x = 2 := by
    intro x
    by_contra hx
    have hlt : 2 < G.degree x := by have := hdegrees x; omega
    have hstrict : (∑ _y : V, (2 : ℕ)) < ∑ y : V, G.degree y :=
      Finset.sum_lt_sum (fun y _ => hdegrees y) ⟨x, Finset.mem_univ x, hlt⟩
    omega
  obtain ⟨A, B, hAB⟩ := _root_.SimpleGraph.IsBipartite.exists_isBipartiteWith hb
  have hABf : G.IsBipartiteWith (A.toFinset : Set V) (B.toFinset : Set V) := by
    simpa only [Set.coe_toFinset] using hAB
  have hAcount : (∑ x ∈ A.toFinset, G.degree x) = G.edgeFinset.card :=
    _root_.SimpleGraph.isBipartiteWith_sum_degrees_eq_card_edges hABf
  have hAeven : 2 * A.toFinset.card = Nat.card V := by
    calc
      2 * A.toFinset.card = ∑ x ∈ A.toFinset, G.degree x := by
        simp [hdegree, mul_comm]
      _ = G.edgeFinset.card := hAcount
      _ = Nat.card V := by
        rw [G.edgeFinset_card, ← Nat.card_eq_fintype_card, hedge]
  exact ⟨A.toFinset.card, by omega⟩

theorem exists_even_seed (n : ℕ) (hn : 2 ≤ n) :
    ∃ G : SimpleGraph (Fin n ⊕ Fin n),
      G ≤ completeBipartiteGraph (Fin n) (Fin n) ∧
      Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G ∧
      Nat.card G.edgeSet = 2 * n := by
  classical
  letI : NeZero n := ⟨by omega⟩
  let rel : Fin n → Fin n → Prop := fun i j =>
    i = j ∨ i.val + 1 = j.val ∨ (i.val + 1 = n ∧ j.val = 0)
  let G : SimpleGraph (Fin n ⊕ Fin n) := fromRel (fun x y =>
    match x, y with
    | .inl i, .inr j => rel i j
    | _, _ => False)
  have hLR (i j : Fin n) : G.Adj (.inl i) (.inr j) ↔ rel i j := by
    simp [G, fromRel]
  let s : Fin n → Fin n := fun i =>
    if h : i.val + 1 < n then ⟨i.val + 1, h⟩ else ⟨0, by omega⟩
  have hrel (i j : Fin n) : rel i j ↔ j = i ∨ j = s i := by
    dsimp only [rel, s]
    split_ifs with hi
    · simp only [Fin.ext_iff]
      omega
    · simp only [Fin.ext_iff]
      omega
  have hsne (i : Fin n) : s i ≠ i := by
    intro hi
    have hv := congrArg Fin.val hi
    dsimp only [s] at hv
    split_ifs at hv <;> dsimp only at hv <;> omega
  let f : (Fin n ⊕ Fin n) → G.edgeSet := Sum.elim
    (fun i => ⟨Sym2.mk (.inl i) (.inr i), (hLR i i).mpr (Or.inl rfl)⟩)
    (fun i => ⟨Sym2.mk (.inl i) (.inr (s i)),
      (hLR i (s i)).mpr ((hrel i (s i)).mpr (Or.inr rfl))⟩)
  have hfi : Function.Injective f := by
    rintro (i | i) (j | j) h
    · have hv := congrArg Subtype.val h
      have hij : i = j := by simpa [f, Sym2.eq_iff] using hv
      exact congrArg Sum.inl hij
    · have hv := congrArg Subtype.val h
      have hij : i = j ∧ i = s j := by simpa [f, Sym2.eq_iff] using hv
      exact (hsne j (hij.2.symm.trans hij.1)).elim
    · have hv := congrArg Subtype.val h
      have hij : i = j ∧ s i = j := by simpa [f, Sym2.eq_iff] using hv
      exact (hsne i (hij.2.trans hij.1.symm)).elim
    · have hv := congrArg Subtype.val h
      have hij : i = j ∧ s i = s j := by simpa [f, Sym2.eq_iff] using hv
      exact congrArg Sum.inr hij.1
  have hfs : ∀ e : Sym2 (Fin n ⊕ Fin n),
      e ∈ G.edgeSet → ∃ x, (f x).val = e := by
    intro e
    refine Sym2.inductionOn e ?_
    rintro (i | i) (j | j) he
    · simp [G, fromRel] at he
    · have hij := (hrel i j).mp ((hLR i j).mp he)
      rcases hij with hij | hij
      · subst j
        exact ⟨.inl i, rfl⟩
      · subst j
        exact ⟨.inr i, rfl⟩
    · have he' : G.Adj (.inr i) (.inl j) := he
      have hij := (hrel j i).mp ((hLR j i).mp he'.symm)
      rcases hij with hij | hij
      · subst i
        exact ⟨.inl j, Sym2.eq_swap⟩
      · subst i
        exact ⟨.inr j, Sym2.eq_swap⟩
    · simp [G, fromRel] at he
  have hfc : Nat.card G.edgeSet = 2 * n := by
    have hfb : Function.Bijective f := by
      refine ⟨hfi, ?_⟩
      rintro ⟨e, he⟩
      obtain ⟨x, hx⟩ := hfs e he
      exact ⟨x, Subtype.ext hx⟩
    have hc := Nat.card_congr (Equiv.ofBijective f hfb)
    simpa only [Nat.card_eq_fintype_card, Fintype.card_sum, Fintype.card_fin,
      ← two_mul] using hc.symm
  have hGtwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G := by
    have hleft (k : Fin n) :
        (G.induce {x | x ≠ Sum.inl k}).Connected := by
      let D := G.induce {x | x ≠ Sum.inl k}
      let R (j : Fin n) : {x : Fin n ⊕ Fin n // x ≠ Sum.inl k} :=
        ⟨Sum.inr j, by simp⟩
      let L (i : Fin n) (hi : i ≠ k) :
          {x : Fin n ⊕ Fin n // x ≠ Sum.inl k} :=
        ⟨Sum.inl i, by simpa using hi⟩
      have hstep (i j : Fin n) (hi : i ≠ k)
          (hij : i.val + 1 = j.val ∨ (i.val + 1 = n ∧ j.val = 0)) :
          D.Reachable (R i) (R j) := by
        have h₁ : D.Adj (R i) (L i hi) :=
          ((hLR i i).mpr (Or.inl rfl)).symm
        have h₂ : D.Adj (L i hi) (R j) :=
          (hLR i j).mpr (Or.inr hij)
        exact h₁.reachable.trans h₂.reachable
      have hforward : ∀ j : ℕ, ∀ hj : j < n, j ≤ k.val →
          D.Reachable (R 0) (R ⟨j, hj⟩) := by
        intro j
        induction j with
        | zero =>
          intro hj _
          exact .rfl
        | succ j ih =>
          intro hj hjk
          have hjn : j < n := by omega
          have hneq : (⟨j, hjn⟩ : Fin n) ≠ k := by
            intro h
            have hv := congrArg Fin.val h
            change j = k.val at hv
            omega
          exact (ih hjn (by omega)).trans
            (hstep ⟨j, hjn⟩ ⟨j + 1, hj⟩ hneq (Or.inl rfl))
      have hbackward : ∀ d : ℕ, ∀ j : Fin n,
          n - 1 - j.val = d → k.val < j.val →
          D.Reachable (R j) (R 0) := by
        intro d
        induction d with
        | zero =>
          intro j hd hj
          have hlast : j.val + 1 = n := by have := j.isLt; omega
          have hneq : j ≠ k := by
            intro h
            have hv := congrArg Fin.val h
            omega
          exact hstep j 0 hneq (Or.inr ⟨hlast, rfl⟩)
        | succ d ih =>
          intro j hd hj
          have hjn : j.val + 1 < n := by have := j.isLt; omega
          let j' : Fin n := ⟨j.val + 1, hjn⟩
          have hj'd : n - 1 - j'.val = d := by dsimp [j']; omega
          have hj'k : k.val < j'.val := by dsimp [j']; omega
          have hneq : j ≠ k := by
            intro h
            have hv := congrArg Fin.val h
            omega
          exact (hstep j j' hneq (Or.inl rfl)).trans (ih j' hj'd hj'k)
      have hall (j : Fin n) : D.Reachable (R 0) (R j) := by
        by_cases hj : j.val ≤ k.val
        · exact hforward j.val j.isLt hj
        · exact (hbackward (n - 1 - j.val) j rfl (by omega)).symm
      apply (connected_iff_exists_forall_reachable D).mpr
      refine ⟨R 0, ?_⟩
      rintro ⟨x, hx⟩
      cases x with
      | inl i =>
        have hi : i ≠ k := by simpa using hx
        have hstep : D.Adj (R i) (L i hi) :=
          ((hLR i i).mpr (Or.inl rfl)).symm
        exact (hall i).trans hstep.reachable
      | inr j => exact hall j
    have hreflect (i j : Fin n) : rel i j ↔ rel j.rev i.rev := by
      dsimp only [rel]
      simp only [Fin.ext_iff, Fin.val_rev]
      have hi := i.isLt
      have hj := j.isLt
      omega
    let swap : (Fin n ⊕ Fin n) → (Fin n ⊕ Fin n)
      | .inl i => .inr i.rev
      | .inr j => .inl j.rev
    have hswap_inv (x : Fin n ⊕ Fin n) : swap (swap x) = x := by
      cases x <;> simp [swap]
    have hswap_adj (x y : Fin n ⊕ Fin n) (h : G.Adj x y) :
        G.Adj (swap x) (swap y) := by
      rcases x with i | i <;> rcases y with j | j
      · simp [G, fromRel] at h
      · exact ((hLR j.rev i.rev).mpr ((hreflect i j).mp ((hLR i j).mp h))).symm
      · exact (hLR i.rev j.rev).mpr ((hreflect j i).mp ((hLR j i).mp h.symm))
      · simp [G, fromRel] at h
    refine ⟨?_, ?_⟩
    · simp only [Fintype.card_sum, Fintype.card_fin]
      omega
    · rintro (k | k)
      · exact hleft k
      · let DL := G.induce {x | x ≠ Sum.inl k.rev}
        let DR := G.induce {x | x ≠ Sum.inr k}
        let f : DL →g DR :=
          { toFun := fun x => ⟨swap x.val, by
              intro h
              apply x.property
              have h' := congrArg swap h
              simpa only [hswap_inv, swap] using h'⟩
            map_rel' := by
              intro x y h
              exact hswap_adj x.val y.val h }
        have hf : Function.Surjective f := by
          rintro ⟨x, hx⟩
          refine ⟨⟨swap x, ?_⟩, ?_⟩
          · intro h
            apply hx
            have h' := congrArg swap h
            simpa only [hswap_inv, swap, Fin.rev_rev] using h'
          · exact Subtype.ext (hswap_inv x)
        exact (hleft k.rev).map f hf
  refine ⟨G, ?_, hGtwo, hfc⟩
  rintro (i | i) (j | j) h
  · simp [G, fromRel] at h
  · simp [completeBipartiteGraph]
  · simp [completeBipartiteGraph]
  · simp [G, fromRel] at h

theorem exists_odd_seed (n : ℕ) (hn : 2 ≤ n) :
    ∃ G : SimpleGraph (Fin n ⊕ Fin (n + 1)),
      G ≤ completeBipartiteGraph (Fin n) (Fin (n + 1)) ∧
      Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G ∧
      Nat.card G.edgeSet = 2 * n + 2 := by
  classical
  letI : NeZero n := ⟨by omega⟩
  obtain ⟨G, hGK, hGtwo, hGc⟩ := exists_even_seed n hn
  let V := Fin n ⊕ Fin n
  let W := V ⊕ Fin 1
  let inc : V ↪ W := ⟨Sum.inl, fun _ _ h => Sum.inl.inj h⟩
  let a : V := .inl ⟨0, by omega⟩
  let b : V := .inl ⟨1, by omega⟩
  let z : W := .inr 0
  have hab : a ≠ b := by
    intro h
    have h01 : (⟨0, by omega⟩ : Fin n) = ⟨1, by omega⟩ := Sum.inl.inj h
    have hv := congrArg Fin.val h01
    change (0 : ℕ) = 1 at hv
    omega
  let T : Set (Sym2 W) := {Sym2.mk (inc a) z, Sym2.mk (inc b) z}
  let H : SimpleGraph W := G.map inc ⊔ fromEdgeSet T
  have hold (x y : V) : H.Adj (.inl x) (.inl y) ↔ G.Adj x y := by
    change (G.map inc).Adj (inc x) (inc y) ∨
      (fromEdgeSet T).Adj (inc x) (inc y) ↔ G.Adj x y
    rw [map_adj inc G (inc x) (inc y)]
    simp [T, inc, z, Sum.inl_injective.eq_iff]
  have hnew (x : V) : H.Adj (.inl x) z ↔ x = a ∨ x = b := by
    change (G.map inc).Adj (inc x) z ∨
      (fromEdgeSet T).Adj (inc x) z ↔ x = a ∨ x = b
    rw [map_adj inc G (inc x) z]
    simp [T, inc, z, Sum.inl_injective.eq_iff]
  have hHtwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected H := by
    refine ⟨?_, ?_⟩
    · change 3 ≤ Fintype.card (V ⊕ Fin 1)
      simp only [V, Fintype.card_sum, Fintype.card_fin]
      omega
    · rintro (x | j)
      · obtain ⟨v, hv, hvx⟩ : ∃ v : V, (v = a ∨ v = b) ∧ v ≠ x := by
          by_cases hx : x = a
          · refine ⟨b, Or.inr rfl, ?_⟩
            simpa [hx] using hab.symm
          · exact ⟨a, Or.inl rfl, fun h => hx h.symm⟩
        let D := H.induce {y : W | y ≠ Sum.inl x}
        let r : {y : W // y ≠ Sum.inl x} :=
          ⟨Sum.inl v, fun h => hvx (Sum.inl.inj h)⟩
        let f : (G.induce {y : V | y ≠ x}) →g D :=
          { toFun := fun (y : {y : V // y ≠ x}) =>
              ⟨Sum.inl y.val, fun h => y.property (Sum.inl.inj h)⟩
            map_rel' := by
              intro y y' h
              exact (hold y.val y'.val).mpr h }
        apply (connected_iff_exists_forall_reachable _).mpr
        refine ⟨r, ?_⟩
        rintro ⟨y, hy⟩
        cases y with
        | inl y =>
          have hyx : y ≠ x := fun h =>
            hy (congrArg (fun t : V => (Sum.inl t : W)) h)
          exact ((hGtwo.2 x).preconnected ⟨v, hvx⟩ ⟨y, hyx⟩).map f
        | inr k =>
          have hk : k = 0 := Subsingleton.elim _ _
          subst k
          apply Adj.reachable
          exact (hnew v).mpr hv
      · have hj : j = 0 := Subsingleton.elim _ _
        subst j
        let D := H.induce {y : W | y ≠ z}
        let f : G →g D :=
          { toFun := fun y => ⟨Sum.inl y, by simp [z]⟩
            map_rel' := by
              intro y y' h
              exact (hold y y').mpr h }
        have hf : Function.Surjective f := by
          rintro ⟨y, hy⟩
          cases y with
          | inl y => exact ⟨y, Subtype.ext rfl⟩
          | inr k =>
            have hk : k = 0 := Subsingleton.elim _ _
            exact (hy (by simp [z, hk])).elim
        exact (two_connected_connected G hGtwo).map f hf
  have hT : (fromEdgeSet T).edgeSet = T := by
    ext e
    simp only [edgeSet_fromEdgeSet, Set.mem_sdiff]
    constructor
    · exact And.left
    · intro he
      refine ⟨he, ?_⟩
      rcases he with rfl | rfl <;> simp [inc, z]
  have hdisj : Disjoint (G.map inc).edgeSet T := by
    apply Set.disjoint_left.mpr
    intro e he ht
    rw [edgeSet_map] at he
    obtain ⟨d, _, hde⟩ := he
    have hz : z ∈ e := by
      rcases ht with rfl | rfl <;> exact Sym2.mem_mk_right _ _
    rw [← hde] at hz
    change z ∈ Sym2.map inc d at hz
    obtain ⟨x, _, hx⟩ := Sym2.mem_map.mp hz
    exact Sum.inl_ne_inr hx
  have hTc : T.ncard = 2 := by
    apply Set.ncard_pair
    intro h
    have h' : a = b := by simpa [inc, z, Sym2.eq_iff, Sum.inl_injective.eq_iff] using h
    exact hab h'
  have hHc : Nat.card H.edgeSet = 2 * n + 2 := by
    change H.edgeSet.ncard = _
    rw [show H.edgeSet = (G.map inc).edgeSet ∪ (fromEdgeSet T).edgeSet from
      edgeSet_sup (G.map inc) (fromEdgeSet T),
      hT, Set.ncard_union_eq hdisj, edgeSet_map,
      Set.ncard_image_of_injective _ inc.sym2Map.injective, hTc]
    exact congrArg (fun k => k + 2) hGc
  let e : W ≃ (Fin n ⊕ Fin (n + 1)) :=
    (Equiv.sumAssoc (Fin n) (Fin n) (Fin 1)).trans
      (Equiv.sumCongr (Equiv.refl (Fin n)) finSumFinEquiv)
  have eleft (x : Fin n) : e (.inl (.inl x)) = .inl x := rfl
  have eright (x : Fin n) :
      e (.inl (.inr x)) = .inr (finSumFinEquiv (.inl x : Fin n ⊕ Fin 1)) := rfl
  have enew (i : Fin 1) :
      e (.inr i) = .inr (finSumFinEquiv (.inr i : Fin n ⊕ Fin 1)) := rfl
  have hcolor : ∀ u v : W, H.Adj u v →
      (completeBipartiteGraph (Fin n) (Fin (n + 1))).Adj (e u) (e v) := by
    rintro ((x | x) | i) ((y | y) | j) h
    · have h' := hGK ((hold _ _).mp h)
      simp [completeBipartiteGraph] at h'
    · rw [eleft, eright]
      simp [completeBipartiteGraph]
    · rw [eleft, enew]
      simp [completeBipartiteGraph]
    · rw [eright, eleft]
      simp [completeBipartiteGraph]
    · have h' := hGK ((hold _ _).mp h)
      simp [completeBipartiteGraph] at h'
    · have hj : j = 0 := Subsingleton.elim _ _
      subst j
      have h' := (hnew (Sum.inr x)).mp h
      simp [a, b] at h'
    · rw [enew, eleft]
      simp [completeBipartiteGraph]
    · have hi : i = 0 := Subsingleton.elim _ _
      subst i
      have h' := (hnew (Sum.inr y)).mp h.symm
      simp [a, b] at h'
    · have hij : i = j := Subsingleton.elim _ _
      subst j
      exact (H.irrefl h).elim
  let iso := Iso.map e H
  refine ⟨H.map e, ?_, two_connected_of_iso H (H.map e) iso hHtwo, ?_⟩
  · intro x y hxy
    obtain ⟨u, v, huv, rfl, rfl⟩ := (map_adj e.toEmbedding H x y).mp hxy
    exact hcolor u v huv
  · exact (Nat.card_congr iso.mapEdgeSet).symm.trans hHc

theorem two_connected_intermediate {V : Type u} [Fintype V]
    (S K : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected S)
    (hle : S ≤ K) (m : ℕ)
    (hlo : Nat.card S.edgeSet ≤ m) (hhi : m ≤ Nat.card K.edgeSet) :
    ∃ G : SimpleGraph V, S ≤ G ∧ G ≤ K ∧
      Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G ∧
      Nat.card G.edgeSet = m := by
  classical
  have hsc : S.edgeFinset.card ≤ m := by
    simpa only [edgeFinset_card, Nat.card_eq_fintype_card] using hlo
  have hkc : m ≤ K.edgeFinset.card := by
    simpa only [edgeFinset_card, Nat.card_eq_fintype_card] using hhi
  obtain ⟨s, hSs, hsK, hsm⟩ :=
    Finset.exists_subsuperset_card_eq (edgeFinset_mono hle) hsc hkc
  let G := fromEdgeSet (s : Set (Sym2 V))
  have hSG : S ≤ G := by
    rw [le_fromEdgeSet_iff]
    intro e he
    exact hSs (mem_edgeFinset.mpr he)
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
  refine ⟨G, hSG, hGK, two_connected_mono S G htwo hSG, ?_⟩
  rw [hges]
  simpa using hsm

theorem exists_of_rank_ge_two (r v : ℕ) (hr : 2 ≤ r)
    (hv : 2 + Erdos593.Spectrum.q r ≤ v) :
    ∃ G : SimpleGraph (Fin v),
      Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G ∧
      G.Colorable 2 ∧ SimpleGraph.FiniteCycleRank.cycleRank G = r := by
  classical
  have hv2 : 2 ≤ v := by omega
  have hq : Erdos593.Spectrum.q r ≤ v - 2 := by omega
  have hcap := (Erdos593.Spectrum.q_le_iff r (v - 2)).mp hq
  have hv5 : 5 ≤ v := by
    by_contra h
    have : v - 2 ≤ 2 := by omega
    nlinarith
  let a := v / 2
  let b := v - a
  have ha : 2 ≤ a := by dsimp [a]; omega
  have hab : a + b = v := by dsimp [a, b]; omega
  have hbal : b = a ∨ b = a + 1 := by dsimp [a, b]; omega
  have hsub : v - 2 + 2 = v := by omega
  have hsize : (r + v - 1) + 1 = r + v := by omega
  have hcapacity : r + v - 1 ≤ a * b := by
    rcases hbal with h | h <;> rw [h] at hab ⊢ <;> nlinarith
  let K := completeBipartiteGraph (Fin a) (Fin b)
  have hseed : ∃ S : SimpleGraph (Fin a ⊕ Fin b), S ≤ K ∧
      Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected S ∧
      Nat.card S.edgeSet ≤ r + v - 1 := by
    rcases hbal with h | h
    · dsimp only [K]
      rw [h]
      obtain ⟨S, hSK, hS, he⟩ := exists_even_seed a ha
      exact ⟨S, hSK, hS, by omega⟩
    · dsimp only [K]
      rw [h]
      obtain ⟨S, hSK, hS, he⟩ := exists_odd_seed a ha
      exact ⟨S, hSK, hS, by omega⟩
  have hkedges : Nat.card K.edgeSet = a * b := by
    have h := encard_edgeSet_completeBipartiteGraph (W₁ := Fin a) (W₂ := Fin b)
    rw [← K.edgeSet.toFinite.cast_ncard_eq, ENat.card_eq_coe_natCard,
      ENat.card_eq_coe_natCard] at h
    rw [Nat.card_coe_set_eq]
    simp only [Nat.card_fin] at h
    exact_mod_cast h
  obtain ⟨S, hSK, hS, heS⟩ := hseed
  obtain ⟨G, _, hGK, hG, hGe⟩ := two_connected_intermediate S K hS hSK
    (r + v - 1) heS (by omega)
  have hcolor : K.Colorable 2 := by
    simpa using (CompleteBipartiteGraph.bicoloring (Fin a) (Fin b)).colorable
  have hGcolor : G.Colorable 2 := by
    obtain ⟨col⟩ := hcolor
    exact ⟨col.comp (Hom.ofLE hGK)⟩
  have hcard : Nat.card (Fin a ⊕ Fin b) = v := by simp [hab]
  let e : (Fin a ⊕ Fin b) ≃ Fin v :=
    (Finite.equivFin (Fin a ⊕ Fin b)).trans (finCongr hcard)
  let i := Iso.map e G
  have hJtwo := two_connected_of_iso G (SimpleGraph.map e G) i hG
  have hJedges : Nat.card (SimpleGraph.map e G).edgeSet = r + v - 1 :=
    (Nat.card_congr i.mapEdgeSet).symm.trans hGe
  refine ⟨SimpleGraph.map e G, hJtwo, ?_, ?_⟩
  · obtain ⟨col⟩ := hGcolor
    exact ⟨col.comp i.symm.toHom⟩
  · have he := connected_cycleRank_euler (SimpleGraph.map e G)
      (two_connected_connected _ hJtwo)
    simp only [Nat.card_fin] at he
    omega

theorem exists_rank_one_iff (v : ℕ) :
    (∃ G : SimpleGraph (Fin v),
      Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G ∧
      G.Colorable 2 ∧ SimpleGraph.FiniteCycleRank.cycleRank G = 1) ↔
      4 ≤ v ∧ Even v := by
  classical
  constructor
  · rintro ⟨G, htwo, hb, hr⟩
    have hmin := minimum_order G htwo hb (by omega)
    have hq : Erdos593.Spectrum.q 1 = 2 := by
      have hlo : 2 ≤ Erdos593.Spectrum.q 1 := by
        by_contra h
        have hle : Erdos593.Spectrum.q 1 ≤ 1 := by omega
        have := (Erdos593.Spectrum.q_le_iff 1 1).mp hle
        omega
      have hhi := (Erdos593.Spectrum.q_le_iff 1 2).mpr (by norm_num)
      omega
    rw [hr, hq, Nat.card_fin] at hmin
    exact ⟨hmin, by simpa only [Nat.card_fin] using even_order_of_rank_one G htwo hb hr⟩
  · rintro ⟨hv, n, hn⟩
    have hn2 : 2 ≤ n := by omega
    obtain ⟨G, hGK, hG, hGe⟩ := exists_even_seed n hn2
    have hcard : Nat.card (Fin n ⊕ Fin n) = v := by simp; omega
    let e : (Fin n ⊕ Fin n) ≃ Fin v :=
      (Finite.equivFin (Fin n ⊕ Fin n)).trans (finCongr hcard)
    let i := Iso.map e G
    have hJtwo := two_connected_of_iso G (SimpleGraph.map e G) i hG
    have hJedges : Nat.card (SimpleGraph.map e G).edgeSet = 2 * n :=
      (Nat.card_congr i.mapEdgeSet).symm.trans hGe
    have hcolor : (completeBipartiteGraph (Fin n) (Fin n)).Colorable 2 := by
      simpa using (CompleteBipartiteGraph.bicoloring (Fin n) (Fin n)).colorable
    refine ⟨SimpleGraph.map e G, hJtwo, ?_, ?_⟩
    · obtain ⟨col⟩ := hcolor
      exact ⟨(col.comp (Hom.ofLE hGK)).comp i.symm.toHom⟩
    · have he := connected_cycleRank_euler (SimpleGraph.map e G)
        (two_connected_connected _ hJtwo)
      simp only [Nat.card_fin] at he
      omega

end SimpleGraph.TwoConnectedBipartiteSpectrum
