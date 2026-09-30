import Erdos593.TripleSystem.ExpansionComponents
import Erdos593.TripleSystem.CanonicalAtomMinimalGenerators

/-!
# Bipartite shadows: exact finite parameters

Finite obligatory reduced triple systems admit simple bipartite parameter
shadows with the same edge and component counts. The expansion converse
and the manuscript-facing subtraction identity are included below.
-/

namespace Erdos593.TripleSystem

universe u

theorem exists_bipartite_shadow
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E]
    (hobligatory : F.IsObligatory)
    (hreduced : F.HasNoIsolatedPoints)
    (hnonempty : Nonempty E) :
    ∃ (s : ℕ) (J : _root_.SimpleGraph (Fin s)),
      J.Colorable 2 ∧
      (∀ x, ∃ y, J.Adj x y) ∧
      Nat.card J.edgeSet = Fintype.card E ∧
      s + Fintype.card E = Fintype.card V ∧
      Nat.card J.ConnectedComponent = Nat.card F.levi.ConnectedComponent := by
  classical
  -- The nonemptiness hypothesis is not needed for the parameter identities below.
  have _hEnonempty : Nonempty E := hnonempty
  have cover_lift {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β}
      {C : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} (hi : Function.Injective i) (hj : Function.Injective j)
      (hcov : ∀ z, (∃ x, i x = z) ∨ (∃ y, j y = z))
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      {X : Type u} (f : α → X) (g : β → X)
      (hcompat : ∀ x y, i x = j y → f x = g y)
      (hfA : ∀ x x', A.Adj x x' → f x = f x')
      (hgB : ∀ y y', B.Adj y y' → g y = g y') :
      ∃ Φ : γ → X, (∀ x, Φ (i x) = f x) ∧ (∀ y, Φ (j y) = g y) ∧
        (∀ z z', C.Reachable z z' → Φ z = Φ z') := by
    classical
    set Φ : γ → X := fun z =>
      if h : ∃ x, i x = z then f h.choose else g ((hcov z).resolve_left h).choose with hΦ
    have hΦi : ∀ x, Φ (i x) = f x := by
      intro x
      have hex : ∃ x', i x' = i x := ⟨x, rfl⟩
      simp only [hΦ, dif_pos hex]
      exact congrArg f (hi hex.choose_spec)
    have hΦj : ∀ y, Φ (j y) = g y := by
      intro y
      by_cases hex : ∃ x, i x = j y
      · simp only [hΦ, dif_pos hex]
        exact hcompat _ y hex.choose_spec
      · simp only [hΦ, dif_neg hex]
        have := ((hcov (j y)).resolve_left hex).choose_spec
        exact congrArg g (hj this)
    have hstep : ∀ z z', C.Adj z z' → Φ z = Φ z' := by
      intro z z' hzz'
      rcases (hadj z z').mp hzz' with ⟨x, x', hxx', rfl, rfl⟩ | ⟨y, y', hyy', rfl, rfl⟩
      · rw [hΦi, hΦi]; exact hfA _ _ hxx'
      · rw [hΦj, hΦj]; exact hgB _ _ hyy'
    refine ⟨Φ, hΦi, hΦj, ?_⟩
    rintro z z' ⟨p⟩
    induction p with
    | nil => rfl
    | cons h _ ih => exact (hstep _ _ h).trans ih

  have adj_i {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β}
      {C : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} (hi : Function.Injective i)
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      (hcross : ∀ x x' y y', i x = j y → i x' = j y' → x = x' ∧ y = y')
      (x x' : α) : C.Adj (i x) (i x') ↔ A.Adj x x' := by
    constructor
    · intro h
      rcases (hadj _ _).mp h with ⟨u, u', huu', hu, hu'⟩ | ⟨v, v', hvv', hv, hv'⟩
      · rw [← hi hu, ← hi hu']; exact huu'
      · have := hcross x x' v v' hv.symm hv'.symm
        exact absurd (this.2 ▸ hvv') (by simp)
    · intro h
      exact (hadj _ _).mpr (Or.inl ⟨x, x', h, rfl, rfl⟩)

  have adj_j {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β}
      {C : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} (hj : Function.Injective j)
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      (hcross : ∀ x x' y y', i x = j y → i x' = j y' → x = x' ∧ y = y')
      (y y' : β) : C.Adj (j y) (j y') ↔ B.Adj y y' := by
    constructor
    · intro h
      rcases (hadj _ _).mp h with ⟨u, u', huu', hu, hu'⟩ | ⟨v, v', hvv', hv, hv'⟩
      · have := hcross u u' y y' hu hu'
        exact absurd (this.1 ▸ huu') (by simp)
      · rw [← hj hv, ← hj hv']; exact hvv'
    · intro h
      exact (hadj _ _).mpr (Or.inr ⟨y, y', h, rfl, rfl⟩)

  have edge_equiv {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β}
      {C : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} (hi : Function.Injective i) (hj : Function.Injective j)
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      (hcross : ∀ x x' y y', i x = j y → i x' = j y' → x = x' ∧ y = y') :
      Nonempty ((A.edgeSet ⊕ B.edgeSet) ≃ C.edgeSet) := by
    classical
    have hmemA : ∀ e : Sym2 α, e ∈ A.edgeSet → Sym2.map i e ∈ C.edgeSet := by
      intro e he
      induction e with
      | _ x x' =>
          simp only [_root_.SimpleGraph.mem_edgeSet] at he ⊢
          exact (adj_i hi hadj hcross x x').mpr he
    have hmemB : ∀ e : Sym2 β, e ∈ B.edgeSet → Sym2.map j e ∈ C.edgeSet := by
      intro e he
      induction e with
      | _ y y' =>
          simp only [_root_.SimpleGraph.mem_edgeSet] at he ⊢
          exact (adj_j hj hadj hcross y y').mpr he
    refine ⟨Equiv.ofBijective
      (fun p => Sum.elim (fun e => (⟨Sym2.map i e.1, hmemA e.1 e.2⟩ : C.edgeSet))
        (fun e => (⟨Sym2.map j e.1, hmemB e.1 e.2⟩ : C.edgeSet)) p) ⟨?_, ?_⟩⟩
    · rintro (⟨e, he⟩ | ⟨e, he⟩) (⟨f, hf⟩ | ⟨f, hf⟩) h <;>
        simp only [Sum.elim_inl, Sum.elim_inr, Subtype.mk.injEq] at h
      · exact congrArg Sum.inl (Subtype.ext (Sym2.map.injective hi h))
      · exfalso
        induction e with
        | _ x x' =>
          induction f with
          | _ y y' =>
            simp only [Sym2.map_mk, Sym2.eq_iff] at h
            simp only [_root_.SimpleGraph.mem_edgeSet] at he
            rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
            · exact absurd ((hcross x x' y y' h1 h2).1 ▸ he) (by simp)
            · exact absurd ((hcross x x' y' y h1 h2).1 ▸ he) (by simp)
      · exfalso
        induction e with
        | _ y y' =>
          induction f with
          | _ x x' =>
            simp only [Sym2.map_mk, Sym2.eq_iff] at h
            simp only [_root_.SimpleGraph.mem_edgeSet] at hf
            rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
            · exact absurd ((hcross x x' y y' h1.symm h2.symm).1 ▸ hf) (by simp)
            · exact absurd ((hcross x x' y' y h2.symm h1.symm).1 ▸ hf) (by simp)
      · exact congrArg Sum.inr (Subtype.ext (Sym2.map.injective hj h))
    · rintro ⟨e, he⟩
      induction e with
      | _ z z' =>
          simp only [_root_.SimpleGraph.mem_edgeSet] at he
          rcases (hadj _ _).mp he with ⟨x, x', hxx', rfl, rfl⟩ | ⟨y, y', hyy', rfl, rfl⟩
          · exact ⟨Sum.inl ⟨s(x, x'), by simpa using hxx'⟩, by simp⟩
          · exact ⟨Sum.inr ⟨s(y, y'), by simpa using hyy'⟩, by simp⟩

  have sum_vertex_equiv {α β γ : Type u} {i : α → γ} {j : β → γ} (hi : Function.Injective i)
      (hj : Function.Injective j)
      (hcov : ∀ z, (∃ x, i x = z) ∨ (∃ y, j y = z))
      (hdisj : ∀ x y, i x ≠ j y) :
      Nonempty ((α ⊕ β) ≃ γ) := by
    refine ⟨Equiv.ofBijective (Sum.elim i j) ⟨?_, ?_⟩⟩
    · rintro (x | y) (x' | y') h <;> simp only [Sum.elim_inl, Sum.elim_inr] at h
      · exact congrArg Sum.inl (hi h)
      · exact absurd h (hdisj x y')
      · exact absurd h.symm (hdisj x' y)
      · exact congrArg Sum.inr (hj h)
    · intro z
      rcases hcov z with ⟨x, rfl⟩ | ⟨y, rfl⟩
      · exact ⟨Sum.inl x, rfl⟩
      · exact ⟨Sum.inr y, rfl⟩

  have sum_component_equiv {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β}
    {C : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} (hi : Function.Injective i) (hj : Function.Injective j)
      (hcov : ∀ z, (∃ x, i x = z) ∨ (∃ y, j y = z))
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      (hdisj : ∀ x y, i x ≠ j y) :
      Nonempty ((A.ConnectedComponent ⊕ B.ConnectedComponent) ≃ C.ConnectedComponent) := by
    classical
    have hcross : ∀ x x' y y', i x = j y → i x' = j y' → x = x' ∧ y = y' := by
      intro x _ y _ h _
      exact absurd h (hdisj x y)
    obtain ⟨Φ, hΦi, hΦj, hΦr⟩ :=
      cover_lift (A := A) (B := B) (C := C) hi hj hcov hadj
        (X := A.ConnectedComponent ⊕ B.ConnectedComponent)
        (fun x => Sum.inl (A.connectedComponentMk x))
        (fun y => Sum.inr (B.connectedComponentMk y))
        (fun x y h => absurd h (hdisj x y))
        (fun x x' h => congrArg Sum.inl (_root_.SimpleGraph.ConnectedComponent.sound h.reachable))
        (fun y y' h => congrArg Sum.inr (_root_.SimpleGraph.ConnectedComponent.sound h.reachable))
    let homA : A →g C := ⟨i, fun {x x'} h => (adj_i hi hadj hcross x x').mpr h⟩
    let homB : B →g C := ⟨j, fun {y y'} h => (adj_j hj hadj hcross y y').mpr h⟩
    refine ⟨{
      toFun := Sum.elim (_root_.SimpleGraph.ConnectedComponent.map homA)
        (_root_.SimpleGraph.ConnectedComponent.map homB)
      invFun := _root_.SimpleGraph.ConnectedComponent.lift Φ (fun v w p _ => hΦr v w p.reachable)
      left_inv := ?_
      right_inv := ?_ }⟩
    · rintro (c | c)
      · induction c using _root_.SimpleGraph.ConnectedComponent.ind with
        | _ x => simpa [homA] using hΦi x
      · induction c using _root_.SimpleGraph.ConnectedComponent.ind with
        | _ y => simpa [homB] using hΦj y
    · intro d
      induction d using _root_.SimpleGraph.ConnectedComponent.ind with
      | _ z =>
          rcases hcov z with ⟨x, rfl⟩ | ⟨y, rfl⟩
          · show Sum.elim _ _ (Φ (i x)) = _
            rw [hΦi]; rfl
          · show Sum.elim _ _ (Φ (j y)) = _
            rw [hΦj]; rfl

  have sum_isolated_equiv {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β} {C
    : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} (hi : Function.Injective i) (hj : Function.Injective j)
      (hcov : ∀ z, (∃ x, i x = z) ∨ (∃ y, j y = z))
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      (hdisj : ∀ x y, i x ≠ j y) :
      Nonempty (({x : α // ∀ w, ¬A.Adj x w} ⊕ {y : β // ∀ w, ¬B.Adj y w}) ≃
        {z : γ // ∀ w, ¬C.Adj z w}) := by
    classical
    have hcross : ∀ x x' y y', i x = j y → i x' = j y' → x = x' ∧ y = y' := by
      intro x _ y _ h _
      exact absurd h (hdisj x y)
    have hisoA : ∀ x : α, (∀ w, ¬C.Adj (i x) w) ↔ (∀ w, ¬A.Adj x w) := by
      intro x
      constructor
      · intro h w hw
        exact h (i w) ((adj_i hi hadj hcross x w).mpr hw)
      · intro h w hw
        rcases (hadj _ _).mp hw with ⟨u, u', huu', hu, _⟩ | ⟨v, v', hvv', hv, _⟩
        · exact h u' (hi hu ▸ huu')
        · exact absurd hv.symm (hdisj x v)
    have hisoB : ∀ y : β, (∀ w, ¬C.Adj (j y) w) ↔ (∀ w, ¬B.Adj y w) := by
      intro y
      constructor
      · intro h w hw
        exact h (j w) ((adj_j hj hadj hcross y w).mpr hw)
      · intro h w hw
        rcases (hadj _ _).mp hw with ⟨u, u', huu', hu, _⟩ | ⟨v, v', hvv', hv, _⟩
        · exact absurd hu (hdisj u y)
        · exact h v' (hj hv ▸ hvv')
    refine ⟨Equiv.ofBijective
      (fun p => Sum.elim (fun x => (⟨i x.1, (hisoA x.1).mpr x.2⟩ : {z : γ // ∀ w, ¬C.Adj z w}))
        (fun y => (⟨j y.1, (hisoB y.1).mpr y.2⟩ : {z : γ // ∀ w, ¬C.Adj z w})) p) ⟨?_, ?_⟩⟩
    · rintro (⟨x, hx⟩ | ⟨y, hy⟩) (⟨x', hx'⟩ | ⟨y', hy'⟩) h <;>
        simp only [Sum.elim_inl, Sum.elim_inr, Subtype.mk.injEq] at h
      · exact congrArg Sum.inl (Subtype.ext (hi h))
      · exact absurd h (hdisj x y')
      · exact absurd h.symm (hdisj x' y)
      · exact congrArg Sum.inr (Subtype.ext (hj h))
    · rintro ⟨z, hz⟩
      rcases hcov z with ⟨x, rfl⟩ | ⟨y, rfl⟩
      · exact ⟨Sum.inl ⟨x, (hisoA x).mp hz⟩, rfl⟩
      · exact ⟨Sum.inr ⟨y, (hisoB y).mp hz⟩, rfl⟩

  have glue_vertex_equiv {α β γ : Type u} {i : α → γ} {j : β → γ} {a : α} {b : β}
      (hi : Function.Injective i) (hj : Function.Injective j)
      (hcov : ∀ z, (∃ x, i x = z) ∨ (∃ y, j y = z))
      (hmeet : ∀ x y, i x = j y ↔ (x = a ∧ y = b)) :
      Nonempty ((α ⊕ {y : β // y ≠ b}) ≃ γ) := by
    refine ⟨Equiv.ofBijective (Sum.elim i (fun y => j y.1)) ⟨?_, ?_⟩⟩
    · rintro (x | ⟨y, hy⟩) (x' | ⟨y', hy'⟩) h <;> simp only [Sum.elim_inl, Sum.elim_inr] at h
      · exact congrArg Sum.inl (hi h)
      · exact absurd ((hmeet x y').mp h).2 hy'
      · exact absurd ((hmeet x' y).mp h.symm).2 hy
      · exact congrArg Sum.inr (Subtype.ext (hj h))
    · intro z
      rcases hcov z with ⟨x, rfl⟩ | ⟨y, rfl⟩
      · exact ⟨Sum.inl x, rfl⟩
      · by_cases hy : y = b
        · exact ⟨Sum.inl a, by simp [hy, (hmeet a b).mpr ⟨rfl, rfl⟩]⟩
        · exact ⟨Sum.inr ⟨y, hy⟩, rfl⟩

  have glue_component_equiv {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β}
    {C : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} {a : α} {b : β}
      (hi : Function.Injective i) (hj : Function.Injective j)
      (hcov : ∀ z, (∃ x, i x = z) ∨ (∃ y, j y = z))
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      (hmeet : ∀ x y, i x = j y ↔ (x = a ∧ y = b)) :
      Nonempty ((A.ConnectedComponent ⊕
          {c : B.ConnectedComponent // c ≠ B.connectedComponentMk b}) ≃
        C.ConnectedComponent) := by
    classical
    have hcross : ∀ x x' y y', i x = j y → i x' = j y' → x = x' ∧ y = y' := by
      intro x x' y y' h h'
      obtain ⟨rfl, rfl⟩ := (hmeet x y).mp h
      obtain ⟨rfl, rfl⟩ := (hmeet x' y').mp h'
      exact ⟨rfl, rfl⟩
    set X := A.ConnectedComponent ⊕ {c : B.ConnectedComponent // c ≠ B.connectedComponentMk b}
      with hX
    set g : β → X := fun y =>
      if h : B.Reachable y b then Sum.inl (A.connectedComponentMk a)
      else Sum.inr ⟨B.connectedComponentMk y, by
        simpa [_root_.SimpleGraph.ConnectedComponent.eq] using h⟩ with hg
    obtain ⟨Φ, hΦi, hΦj, hΦr⟩ :=
      cover_lift (A := A) (B := B) (C := C) hi hj hcov hadj (X := X)
        (fun x => Sum.inl (A.connectedComponentMk x)) g
        (by
          intro x y hxy
          obtain ⟨rfl, rfl⟩ := (hmeet x y).mp hxy
          simp [hg])
        (fun x x' h => congrArg Sum.inl (_root_.SimpleGraph.ConnectedComponent.sound h.reachable))
        (by
          intro y y' hyy'
          by_cases hy : B.Reachable y b
          · have hy' : B.Reachable y' b := (hyy'.symm.reachable).trans hy
            simp [hg, hy, hy']
          · have hy' : ¬ B.Reachable y' b := fun h => hy (hyy'.reachable.trans h)
            simp only [hg, dif_neg hy, dif_neg hy']
            exact congrArg Sum.inr
              (Subtype.ext (_root_.SimpleGraph.ConnectedComponent.sound hyy'.reachable)))
    let homA : A →g C := ⟨i, fun {x x'} h => (adj_i hi hadj hcross x x').mpr h⟩
    let homB : B →g C := ⟨j, fun {y y'} h => (adj_j hj hadj hcross y y').mpr h⟩
    refine ⟨{
      toFun := Sum.elim (_root_.SimpleGraph.ConnectedComponent.map homA)
        (fun c => _root_.SimpleGraph.ConnectedComponent.map homB c.1)
      invFun := _root_.SimpleGraph.ConnectedComponent.lift Φ (fun v w p _ => hΦr v w p.reachable)
      left_inv := ?_
      right_inv := ?_ }⟩
    · rintro (c | ⟨c, hc⟩)
      · induction c using _root_.SimpleGraph.ConnectedComponent.ind with
        | _ x => simpa [homA] using hΦi x
      · revert hc
        induction c using _root_.SimpleGraph.ConnectedComponent.ind with
        | _ y =>
            intro hc
            have hy : ¬ B.Reachable y b := by
              simpa [_root_.SimpleGraph.ConnectedComponent.eq] using hc
            simp only [Sum.elim_inr, homB]
            rw [show _root_.SimpleGraph.ConnectedComponent.map ⟨j, _⟩ (B.connectedComponentMk y) =
              C.connectedComponentMk (j y) from rfl]
            show Φ (j y) = _
            rw [hΦj]
            simp [hg, hy]
    · intro d
      induction d using _root_.SimpleGraph.ConnectedComponent.ind with
      | _ z =>
          rcases hcov z with ⟨x, rfl⟩ | ⟨y, rfl⟩
          · show Sum.elim _ _ (Φ (i x)) = _
            rw [hΦi]; rfl
          · show Sum.elim _ _ (Φ (j y)) = _
            rw [hΦj]
            by_cases hy : B.Reachable y b
            · simp only [hg, dif_pos hy, Sum.elim_inl]
              have h1 : C.connectedComponentMk (i a) = C.connectedComponentMk (j y) := by
                rw [(hmeet a b).mpr ⟨rfl, rfl⟩]
                exact _root_.SimpleGraph.ConnectedComponent.sound
                  ((hy.symm).map homB)
              simpa [homA] using h1
            · simp only [hg, dif_neg hy, Sum.elim_inr]
              rfl

  have glue_isolated_equiv {α β γ : Type u} {A : _root_.SimpleGraph α} {B : _root_.SimpleGraph β}
    {C : _root_.SimpleGraph γ}
      {i : α → γ} {j : β → γ} {a : α} {b : β}
      (hi : Function.Injective i) (hj : Function.Injective j)
      (hcov : ∀ z, (∃ x, i x = z) ∨ (∃ y, j y = z))
      (hadj : ∀ z z', C.Adj z z' ↔
        ((∃ x x', A.Adj x x' ∧ i x = z ∧ i x' = z') ∨
         (∃ y y', B.Adj y y' ∧ j y = z ∧ j y' = z')))
      (hmeet : ∀ x y, i x = j y ↔ (x = a ∧ y = b)) :
      Nonempty (({x : α // (∀ w, ¬A.Adj x w) ∧ (x = a → ∀ w, ¬B.Adj b w)} ⊕
          {y : β // (∀ w, ¬B.Adj y w) ∧ y ≠ b}) ≃
        {z : γ // ∀ w, ¬C.Adj z w}) := by
    classical
    have hcross : ∀ x x' y y', i x = j y → i x' = j y' → x = x' ∧ y = y' := by
      intro x x' y y' h h'
      obtain ⟨rfl, rfl⟩ := (hmeet x y).mp h
      obtain ⟨rfl, rfl⟩ := (hmeet x' y').mp h'
      exact ⟨rfl, rfl⟩
    have hisoA : ∀ x : α, (∀ w, ¬C.Adj (i x) w) ↔
        ((∀ w, ¬A.Adj x w) ∧ (x = a → ∀ w, ¬B.Adj b w)) := by
      intro x
      constructor
      · intro h
        refine ⟨fun w hw => h (i w) ((adj_i hi hadj hcross x w).mpr hw), ?_⟩
        rintro rfl w hw
        have hix : i x = j b := (hmeet x b).mpr ⟨rfl, rfl⟩
        refine h (j w) ?_
        rw [hix]
        exact (adj_j hj hadj hcross b w).mpr hw
      · rintro ⟨h1, h2⟩ w hw
        rcases (hadj _ _).mp hw with ⟨u, u', huu', hu, _⟩ | ⟨v, v', hvv', hv, _⟩
        · exact h1 u' (hi hu ▸ huu')
        · obtain ⟨rfl, rfl⟩ := (hmeet x v).mp hv.symm
          exact h2 rfl v' hvv'
    have hisoB : ∀ y : β, y ≠ b → ((∀ w, ¬C.Adj (j y) w) ↔ (∀ w, ¬B.Adj y w)) := by
      intro y hy
      constructor
      · intro h w hw
        exact h (j w) ((adj_j hj hadj hcross y w).mpr hw)
      · intro h w hw
        rcases (hadj _ _).mp hw with ⟨u, u', huu', hu, _⟩ | ⟨v, v', hvv', hv, _⟩
        · exact absurd ((hmeet u y).mp hu).2 hy
        · exact h v' (hj hv ▸ hvv')
    refine ⟨Equiv.ofBijective
      (fun p => Sum.elim
        (fun x => (⟨i x.1, (hisoA x.1).mpr x.2⟩ : {z : γ // ∀ w, ¬C.Adj z w}))
        (fun y => (⟨j y.1, (hisoB y.1 y.2.2).mpr y.2.1⟩ : {z : γ // ∀ w, ¬C.Adj z w})) p)
      ⟨?_, ?_⟩⟩
    · rintro (⟨x, hx⟩ | ⟨y, hy⟩) (⟨x', hx'⟩ | ⟨y', hy'⟩) h <;>
        simp only [Sum.elim_inl, Sum.elim_inr, Subtype.mk.injEq] at h
      · exact congrArg Sum.inl (Subtype.ext (hi h))
      · exact absurd ((hmeet x y').mp h).2 hy'.2
      · exact absurd ((hmeet x' y).mp h.symm).2 hy.2
      · exact congrArg Sum.inr (Subtype.ext (hj h))
    · rintro ⟨z, hz⟩
      rcases hcov z with ⟨x, rfl⟩ | ⟨y, rfl⟩
      · exact ⟨Sum.inl ⟨x, (hisoA x).mp hz⟩, rfl⟩
      · by_cases hy : y = b
        · subst hy
          refine ⟨Sum.inl ⟨a, (hisoA a).mp ?_⟩, ?_⟩
          · rw [(hmeet a y).mpr ⟨rfl, rfl⟩]; exact hz
          · exact Subtype.ext ((hmeet a y).mpr ⟨rfl, rfl⟩)
        · exact ⟨Sum.inr ⟨y, (hisoB y hy).mp hz, hy⟩, rfl⟩

  have edgeless_component_equiv {γ : Type u} {C : _root_.SimpleGraph γ} (hC : ∀ z z', ¬C.Adj z z') :
      Nonempty (γ ≃ C.ConnectedComponent) := by
    refine ⟨Equiv.ofBijective C.connectedComponentMk ⟨?_, ?_⟩⟩
    · intro z z' h
      obtain ⟨p⟩ := _root_.SimpleGraph.ConnectedComponent.exact h
      cases p with
      | nil => rfl
      | cons hadj _ => exact absurd hadj (hC _ _)
    · intro c
      induction c using _root_.SimpleGraph.ConnectedComponent.ind with
      | _ z => exact ⟨z, rfl⟩

  have iso_transfer {γ γ' : Type u} (C : _root_.SimpleGraph γ) (C' : _root_.SimpleGraph γ') (e : γ
    ≃ γ')
      (he : ∀ z z', C'.Adj (e z) (e z') ↔ C.Adj z z') :
      Nonempty (C.ConnectedComponent ≃ C'.ConnectedComponent) ∧
      Nonempty (C.edgeSet ≃ C'.edgeSet) ∧
      Nonempty ({z : γ // ∀ w, ¬C.Adj z w} ≃ {z' : γ' // ∀ w, ¬C'.Adj z' w}) ∧
      (C.Colorable 2 → C'.Colorable 2) := by
    let φ : C ≃g C' := ⟨e, fun {x y} => he x y⟩
    refine ⟨⟨φ.connectedComponentEquiv⟩, ⟨φ.mapEdgeSet⟩, ⟨?_⟩, ?_⟩
    · refine Equiv.ofBijective (fun z => ⟨e z.1, ?_⟩) ⟨?_, ?_⟩
      · intro w hw
        exact z.2 (e.symm w) ((he z.1 (e.symm w)).mp (by simpa using hw))
      · rintro ⟨z, hz⟩ ⟨z', hz'⟩ h
        exact Subtype.ext (e.injective (by simpa using h))
      · rintro ⟨w, hw⟩
        refine ⟨⟨e.symm w, ?_⟩, Subtype.ext (by simp)⟩
        intro v hv
        have := (he (e.symm w) v).mpr hv
        rw [Equiv.apply_symm_apply] at this
        exact hw (e v) this
    · rintro ⟨c⟩
      exact ⟨c.comp φ.symm.toHom⟩


  have card_subtype_ne_succ {X : Type u} [Finite X] (x₀ : X) :
      Nat.card {x : X // x ≠ x₀} + 1 = Nat.card X := by
    classical
    have : Nat.card ({x : X // x ≠ x₀} ⊕ PUnit.{u+1}) = Nat.card X := by
      refine Nat.card_congr (Equiv.ofBijective
        (Sum.elim (fun x => x.1) (fun _ => x₀)) ⟨?_, ?_⟩)
      · rintro (⟨x, hx⟩ | u) (⟨y, hy⟩ | v) h <;> simp only [Sum.elim_inl, Sum.elim_inr] at h
        · exact congrArg Sum.inl (Subtype.ext h)
        · exact absurd h hx
        · exact absurd h.symm hy
        · rfl
      · intro x
        by_cases hx : x = x₀
        · exact ⟨Sum.inr PUnit.unit, hx.symm⟩
        · exact ⟨Sum.inl ⟨x, hx⟩, rfl⟩
    rw [← this, Nat.card_sum]
    simp

  have card_subtype_and_ne_succ {X : Type u} [Finite X] (P : X → Prop) (x₀ : X)
      (h₀ : P x₀) : Nat.card {x : X // P x ∧ x ≠ x₀} + 1 = Nat.card {x : X // P x} := by
    classical
    have : Nat.card ({x : X // P x ∧ x ≠ x₀} ⊕ PUnit.{u+1}) = Nat.card {x : X // P x} := by
      refine Nat.card_congr (Equiv.ofBijective
        (Sum.elim (fun x => (⟨x.1, x.2.1⟩ : {x : X // P x})) (fun _ => ⟨x₀, h₀⟩)) ⟨?_, ?_⟩)
      · rintro (⟨x, hx⟩ | u) (⟨y, hy⟩ | v) h <;>
          simp only [Sum.elim_inl, Sum.elim_inr, Subtype.mk.injEq] at h
        · exact congrArg Sum.inl (Subtype.ext h)
        · exact absurd h hx.2
        · exact absurd h.symm hy.2
        · rfl
      · rintro ⟨x, hx⟩
        by_cases hxx : x = x₀
        · exact ⟨Sum.inr PUnit.unit, Subtype.ext hxx.symm⟩
        · exact ⟨Sum.inl ⟨x, hx, hxx⟩, rfl⟩
    rw [← this, Nat.card_sum]
    simp

  have card_glue_isolated_pos {X Y : Type u} [Finite X] [Finite Y]
      (P : X → Prop) (Q : Y → Prop) (x₀ : X) (y₀ : Y) (hpos : P x₀ ∨ Q y₀) :
      Nat.card {x : X // P x ∧ (x = x₀ → Q y₀)} + Nat.card {y : Y // Q y ∧ y ≠ y₀} + 1 =
        Nat.card {x : X // P x} + Nat.card {y : Y // Q y} := by
    classical
    by_cases hQ : Q y₀
    · have h1 : Nat.card {x : X // P x ∧ (x = x₀ → Q y₀)} = Nat.card {x : X // P x} :=
        Nat.card_congr (Equiv.subtypeEquivRight (fun x => by simp [hQ]))
      have h2 := card_subtype_and_ne_succ Q y₀ hQ
      omega
    · have hP : P x₀ := hpos.resolve_right hQ
      have h1 : Nat.card {x : X // P x ∧ (x = x₀ → Q y₀)} =
          Nat.card {x : X // P x ∧ x ≠ x₀} :=
        Nat.card_congr (Equiv.subtypeEquivRight (fun x => by
          constructor
          · rintro ⟨hp, hx⟩
            exact ⟨hp, fun hxx => hQ (hx hxx)⟩
          · rintro ⟨hp, hx⟩
            exact ⟨hp, fun hxx => absurd hxx hx⟩))
      have h2 : Nat.card {y : Y // Q y ∧ y ≠ y₀} = Nat.card {y : Y // Q y} :=
        Nat.card_congr (Equiv.subtypeEquivRight (fun y => by
          constructor
          · rintro ⟨hq, -⟩
            exact hq
          · intro hq
            exact ⟨hq, by rintro rfl; exact hQ hq⟩))
      have h3 := card_subtype_and_ne_succ P x₀ hP
      omega

  have card_glue_isolated_neg {X Y : Type u} [Finite X] [Finite Y]
      (P : X → Prop) (Q : Y → Prop) (x₀ : X) (y₀ : Y)
      (hP : ¬P x₀) (hQ : ¬Q y₀) :
      Nat.card {x : X // P x ∧ (x = x₀ → Q y₀)} + Nat.card {y : Y // Q y ∧ y ≠ y₀} =
        Nat.card {x : X // P x} + Nat.card {y : Y // Q y} := by
    classical
    have h1 : Nat.card {x : X // P x ∧ (x = x₀ → Q y₀)} = Nat.card {x : X // P x} :=
      Nat.card_congr (Equiv.subtypeEquivRight (fun x => by
        constructor
        · rintro ⟨hp, -⟩
          exact hp
        · intro hp
          exact ⟨hp, by rintro rfl; exact absurd hp hP⟩))
    have h2 : Nat.card {y : Y // Q y ∧ y ≠ y₀} = Nat.card {y : Y // Q y} :=
      Nat.card_congr (Equiv.subtypeEquivRight (fun y => by
        constructor
        · rintro ⟨hq, -⟩
          exact hq
        · intro hq
          exact ⟨hq, by rintro rfl; exact hQ hq⟩))
    omega

  have root_selection {V' E' W' : Type u} (F' : Erdos593.TripleSystem V' E')
      (J' : _root_.SimpleGraph W') [Finite V'] [Finite E'] [Finite W'] (r : V')
      (hiso : Nat.card {x : W' // ∀ y, ¬J'.Adj x y} =
        Nat.card {z : V' ⊕ E' // ∀ w, ¬F'.levi.Adj z w})
      (hedge : Nat.card J'.edgeSet = Nat.card E') :
      ∃ a : W', ((∀ y, ¬J'.Adj a y) ↔ (∀ w, ¬F'.levi.Adj (Sum.inl r) w)) := by
    classical
    by_cases hr : ∀ w, ¬F'.levi.Adj (Sum.inl r) w
    · have hne : Nonempty {z : V' ⊕ E' // ∀ w, ¬F'.levi.Adj z w} := ⟨⟨Sum.inl r, hr⟩⟩
      have hpos : 0 < Nat.card {x : W' // ∀ y, ¬J'.Adj x y} := by
        rw [hiso]
        exact Nat.card_pos
      have : Nonempty {x : W' // ∀ y, ¬J'.Adj x y} := by
        rw [Nat.card_pos_iff] at hpos
        exact hpos.1
      obtain ⟨a, ha⟩ := this
      exact ⟨a, iff_of_true ha hr⟩
    · have hex : ∃ w, F'.levi.Adj (Sum.inl r) w := by
        by_contra hcon
        exact hr (fun w hw => hcon ⟨w, hw⟩)
      obtain ⟨w, hw⟩ := hex
      have hE : Nonempty E' := by
        rcases w with x | e
        · exact absurd hw (F'.not_levi_adj_point_point)
        · exact ⟨e⟩
      have hpos : 0 < Nat.card J'.edgeSet := by
        rw [hedge]
        exact Nat.card_pos
      have hnee : Nonempty J'.edgeSet := by
        rw [Nat.card_pos_iff] at hpos
        exact hpos.1
      obtain ⟨e, he⟩ := hnee
      induction e with
      | _ x y =>
          refine ⟨x, iff_of_false ?_ ?_⟩
          · intro hcon
            exact hcon y he
          · intro hcon
            exact hcon w hw

  have key : ∀ {V E : Type u} {F : Erdos593.TripleSystem V E}, F.Constructible →
      ∃ (W : Type u) (J : _root_.SimpleGraph W), Finite W ∧ J.Colorable 2 ∧
        Nat.card {x : W // ∀ y, ¬J.Adj x y} =
          Nat.card {z : V ⊕ E // ∀ w, ¬F.levi.Adj z w} ∧
        Nat.card J.edgeSet = Nat.card E ∧
        Nat.card W + Nat.card E = Nat.card V ∧
        Nat.card J.ConnectedComponent = Nat.card F.levi.ConnectedComponent := by
    intro V E F hF
    induction hF with
    | ofEdgeless V =>
        classical
        have hbot : ∀ x y : V, ¬(⊥ : _root_.SimpleGraph V).Adj x y := by simp
        have hlevi : ∀ z w : V ⊕ EdgelessEdge.{u}, ¬(edgeless V).levi.Adj z w := by
          rintro (x | e) (y | f) h
          · exact (edgeless V).not_levi_adj_point_point h
          · exact Empty.elim f.down
          · exact Empty.elim e.down
          · exact Empty.elim e.down
        have hsum : (V ⊕ EdgelessEdge.{u}) ≃ V := Equiv.sumEmpty V _
        refine ⟨V, ⊥, inferInstance, ⟨_root_.SimpleGraph.Coloring.mk (fun _ => (0 : Fin 2))
          (by simp)⟩, ?_, ?_, ?_, ?_⟩
        · refine Nat.card_congr ?_
          exact (Equiv.subtypeUnivEquiv (fun x => hbot x)).trans
            (hsum.symm.trans (Equiv.subtypeUnivEquiv (fun z => hlevi z)).symm)
        · simp
        · simp
        · refine Nat.card_congr ?_
          refine (Classical.choice (edgeless_component_equiv hbot)).symm.trans ?_
          exact hsum.symm.trans (Classical.choice (edgeless_component_equiv hlevi))
    | @ofExpansion V hVfin G hG =>
        classical
        letI : Fintype V := hVfin
        letI : Finite G.edgeSet := Finite.of_injective Subtype.val Subtype.val_injective
        have hmemadj : ∀ (x : V) (e : G.edgeSet), x ∈ (e : Sym2 V) → ∃ y, G.Adj x y := by
          rintro x ⟨e, he⟩ hx
          obtain ⟨y, rfl⟩ := Sym2.mem_iff_exists.mp hx
          exact ⟨y, he⟩
        have hisoCore : ∀ x : V,
            (∀ w, ¬(privateVertexExpansion G).levi.Adj (Sum.inl (Sum.inl x)) w) ↔
              (∀ y, ¬G.Adj x y) := by
          intro x
          constructor
          · intro h y hy
            refine h (Sum.inr ⟨s(x, y), hy⟩) ?_
            rw [levi_adj_point_edge]
            exact Sym2.mem_mk_left x y
          · intro h w hw
            rcases w with p | e
            · exact (privateVertexExpansion G).not_levi_adj_point_point hw
            · obtain ⟨y, hy⟩ := hmemadj x e ((levi_adj_point_edge _).mp hw)
              exact h y hy
        have hnotisoPriv : ∀ f : G.edgeSet,
            ¬(∀ w, ¬(privateVertexExpansion G).levi.Adj (Sum.inl (Sum.inr f)) w) := by
          intro f h
          exact h (Sum.inr f) ((levi_adj_point_edge _).mpr rfl)
        have hnotisoEdge : ∀ e : G.edgeSet,
            ¬(∀ w, ¬(privateVertexExpansion G).levi.Adj (Sum.inr e) w) := by
          intro e h
          exact h (Sum.inl (Sum.inr e)) ((levi_adj_edge_point _).mpr rfl)
        refine ⟨V, G, inferInstance, hG, ?_, rfl, ?_, ?_⟩
        · refine Nat.card_congr (Equiv.ofBijective
            (fun x => (⟨Sum.inl (Sum.inl x.1), (hisoCore x.1).mpr x.2⟩ :
              {z // ∀ w, ¬(privateVertexExpansion G).levi.Adj z w})) ⟨?_, ?_⟩)
          · rintro ⟨x, hx⟩ ⟨x', hx'⟩ h
            simpa using h
          · rintro ⟨z, hz⟩
            rcases z with (x | f) | e
            · exact ⟨⟨x, (hisoCore x).mp hz⟩, rfl⟩
            · exact absurd hz (hnotisoPriv f)
            · exact absurd hz (hnotisoEdge e)
        · exact (Nat.card_sum (α := V) (β := G.edgeSet)).symm
        · exact (privateVertexExpansion_component_card G).symm
    | @disjointUnion V E W D F G hF hG ihF ihG =>
        classical
        obtain ⟨W₀, J₀, hW₀, hcol₀, hiso₀, hedge₀, hvert₀, hcomp₀⟩ := ihF
        obtain ⟨W₁, J₁, hW₁, hcol₁, hiso₁, hedge₁, hvert₁, hcomp₁⟩ := ihG
        letI : Finite V := hF.finiteTypes.1
        letI : Finite E := hF.finiteTypes.2
        letI : Finite W := hG.finiteTypes.1
        letI : Finite D := hG.finiteTypes.2
        letI : Finite W₀ := hW₀
        letI : Finite W₁ := hW₁
        -- the shadow side
        have hSi : Function.Injective (Sum.inl : W₀ → W₀ ⊕ W₁) := Sum.inl_injective
        have hSj : Function.Injective (Sum.inr : W₁ → W₀ ⊕ W₁) := Sum.inr_injective
        have hScov : ∀ z : W₀ ⊕ W₁, (∃ x, Sum.inl x = z) ∨ (∃ y, Sum.inr y = z) := by
          rintro (x | y)
          · exact Or.inl ⟨x, rfl⟩
          · exact Or.inr ⟨y, rfl⟩
        have hSdisj : ∀ (x : W₀) (y : W₁), (Sum.inl x : W₀ ⊕ W₁) ≠ Sum.inr y := by
          rintro x y ⟨⟩
        have hSadj : ∀ z z' : W₀ ⊕ W₁, (_root_.SimpleGraph.sum J₀ J₁).Adj z z' ↔
            ((∃ x x', J₀.Adj x x' ∧ Sum.inl x = z ∧ Sum.inl x' = z') ∨
             (∃ y y', J₁.Adj y y' ∧ Sum.inr y = z ∧ Sum.inr y' = z')) := by
          rintro (x | y) (x' | y') <;> simp [_root_.SimpleGraph.sum]
        -- the Levi side
        set iL : V ⊕ E → (V ⊕ W) ⊕ (E ⊕ D) :=
          Sum.elim (fun x => Sum.inl (Sum.inl x)) (fun e => Sum.inr (Sum.inl e)) with hiLdef
        set jL : W ⊕ D → (V ⊕ W) ⊕ (E ⊕ D) :=
          Sum.elim (fun y => Sum.inl (Sum.inr y)) (fun d => Sum.inr (Sum.inr d)) with hjLdef
        have hLred : ∀ (x : V) (e : E) (y : W) (d : D),
            iL (Sum.inl x) = Sum.inl (Sum.inl x) ∧ iL (Sum.inr e) = Sum.inr (Sum.inl e) ∧
              jL (Sum.inl y) = Sum.inl (Sum.inr y) ∧ jL (Sum.inr d) = Sum.inr (Sum.inr d) :=
          fun x e y d => ⟨rfl, rfl, rfl, rfl⟩
        have hLi : Function.Injective iL := by
          rintro (x | e) (x' | e') h <;>
            simp only [hiLdef, Sum.elim_inl, Sum.elim_inr] at h
          · exact congrArg Sum.inl (by simpa using h)
          · exact absurd h (by simp)
          · exact absurd h (by simp)
          · exact congrArg Sum.inr (by simpa using h)
        have hLj : Function.Injective jL := by
          rintro (y | d) (y' | d') h <;>
            simp only [hjLdef, Sum.elim_inl, Sum.elim_inr] at h
          · exact congrArg Sum.inl (by simpa using h)
          · exact absurd h (by simp)
          · exact absurd h (by simp)
          · exact congrArg Sum.inr (by simpa using h)
        have hLcov : ∀ z, (∃ p, iL p = z) ∨ (∃ q, jL q = z) := by
          rintro ((x | y) | (e | d))
          · exact Or.inl ⟨Sum.inl x, rfl⟩
          · exact Or.inr ⟨Sum.inl y, rfl⟩
          · exact Or.inl ⟨Sum.inr e, rfl⟩
          · exact Or.inr ⟨Sum.inr d, rfl⟩
        have hLdisj : ∀ p q, iL p ≠ jL q := by
          rintro (x | e) (y | d) h <;>
            simp only [hiLdef, hjLdef, Sum.elim_inl, Sum.elim_inr] at h
          · exact absurd h (by simp)
          · exact absurd h (by simp)
          · exact absurd h (by simp)
          · exact absurd h (by simp)
        have hLadj : ∀ z z', (F.disjointUnion G).levi.Adj z z' ↔
            ((∃ p p', F.levi.Adj p p' ∧ iL p = z ∧ iL p' = z') ∨
             (∃ q q', G.levi.Adj q q' ∧ jL q = z ∧ jL q' = z')) := by
          intro z z'
          constructor
          · intro h
            rcases z with (x | y) | (e | d) <;> rcases z' with (x' | y') | (e' | d')
            · exact absurd h ((F.disjointUnion G).not_levi_adj_point_point)
            · exact absurd h ((F.disjointUnion G).not_levi_adj_point_point)
            · exact Or.inl ⟨Sum.inl x, Sum.inr e',
                (levi_adj_point_edge F).mpr
                  ((levi_adj_point_edge (F.disjointUnion G)).mp h), rfl, rfl⟩
            · exact absurd ((levi_adj_point_edge (F.disjointUnion G)).mp h)
                (disjointUnion_not_inc_inl_inr F G x d')
            · exact absurd h ((F.disjointUnion G).not_levi_adj_point_point)
            · exact absurd h ((F.disjointUnion G).not_levi_adj_point_point)
            · exact absurd ((levi_adj_point_edge (F.disjointUnion G)).mp h)
                (disjointUnion_not_inc_inr_inl F G y e')
            · exact Or.inr ⟨Sum.inl y, Sum.inr d',
                (levi_adj_point_edge G).mpr
                  ((levi_adj_point_edge (F.disjointUnion G)).mp h), rfl, rfl⟩
            · exact Or.inl ⟨Sum.inr e, Sum.inl x',
                (levi_adj_edge_point F).mpr
                  ((levi_adj_edge_point (F.disjointUnion G)).mp h), rfl, rfl⟩
            · exact absurd ((levi_adj_edge_point (F.disjointUnion G)).mp h)
                (disjointUnion_not_inc_inr_inl F G y' e)
            · exact absurd h ((F.disjointUnion G).not_levi_adj_edge_edge)
            · exact absurd h ((F.disjointUnion G).not_levi_adj_edge_edge)
            · exact absurd ((levi_adj_edge_point (F.disjointUnion G)).mp h)
                (disjointUnion_not_inc_inl_inr F G x' d)
            · exact Or.inr ⟨Sum.inr d, Sum.inl y',
                (levi_adj_edge_point G).mpr
                  ((levi_adj_edge_point (F.disjointUnion G)).mp h), rfl, rfl⟩
            · exact absurd h ((F.disjointUnion G).not_levi_adj_edge_edge)
            · exact absurd h ((F.disjointUnion G).not_levi_adj_edge_edge)
          · rintro (⟨p, p', hpp', rfl, rfl⟩ | ⟨q, q', hqq', rfl, rfl⟩)
            · rcases p with x | e <;> rcases p' with x' | e'
              · exact absurd hpp' F.not_levi_adj_point_point
              · exact (levi_adj_point_edge (F.disjointUnion G)).mpr
                  ((levi_adj_point_edge F).mp hpp')
              · exact (levi_adj_edge_point (F.disjointUnion G)).mpr
                  ((levi_adj_edge_point F).mp hpp')
              · exact absurd hpp' F.not_levi_adj_edge_edge
            · rcases q with y | d <;> rcases q' with y' | d'
              · exact absurd hqq' G.not_levi_adj_point_point
              · exact (levi_adj_point_edge (F.disjointUnion G)).mpr
                  ((levi_adj_point_edge G).mp hqq')
              · exact (levi_adj_edge_point (F.disjointUnion G)).mpr
                  ((levi_adj_edge_point G).mp hqq')
              · exact absurd hqq' G.not_levi_adj_edge_edge
        refine ⟨W₀ ⊕ W₁, _root_.SimpleGraph.sum J₀ J₁, inferInstance, ?_, ?_, ?_, ?_, ?_⟩
        · obtain ⟨c₀⟩ := hcol₀
          obtain ⟨c₁⟩ := hcol₁
          exact ⟨c₀.sum c₁⟩
        · rw [← Nat.card_congr (Classical.choice (sum_isolated_equiv hSi hSj hScov hSadj hSdisj)),
            ← Nat.card_congr (Classical.choice (sum_isolated_equiv hLi hLj hLcov hLadj hLdisj)),
            Nat.card_sum, Nat.card_sum, hiso₀, hiso₁]
        · rw [← Nat.card_congr (Classical.choice (edge_equiv hSi hSj hSadj
            (fun x _ y _ h _ => absurd h (hSdisj x y)))),
            Nat.card_sum, hedge₀, hedge₁, Nat.card_sum]
        · rw [Nat.card_sum, Nat.card_sum, Nat.card_sum]
          omega
        · rw [← Nat.card_congr (Classical.choice (sum_component_equiv hSi hSj hScov hSadj hSdisj)),
            ← Nat.card_congr (Classical.choice (sum_component_equiv hLi hLj hLcov hLadj hLdisj)),
            Nat.card_sum, Nat.card_sum, hcomp₀, hcomp₁]
    | @amalgam V₀ E₀ V₁ E₁ F₀ F₁ h₀ h₁ r₀ r₁ ih₀ ih₁ =>
        classical
        obtain ⟨W₀, J₀, hW₀, hcol₀, hiso₀, hedge₀, hvert₀, hcomp₀⟩ := ih₀
        obtain ⟨W₁, J₁, hW₁, hcol₁, hiso₁, hedge₁, hvert₁, hcomp₁⟩ := ih₁
        letI : Finite V₀ := h₀.finiteTypes.1
        letI : Finite E₀ := h₀.finiteTypes.2
        letI : Finite V₁ := h₁.finiteTypes.1
        letI : Finite E₁ := h₁.finiteTypes.2
        letI : Finite W₀ := hW₀
        letI : Finite W₁ := hW₁
        obtain ⟨a₀, ha₀⟩ := root_selection F₀ J₀ r₀ hiso₀ hedge₀
        obtain ⟨a₁, ha₁⟩ := root_selection F₁ J₁ r₁ hiso₁ hedge₁
        -- the glued shadow graph
        set iS : W₀ → OnePointAmalgamation.Vertex a₀ a₁ :=
          OnePointAmalgamation.left a₀ a₁ with hiSdef
        set jS : W₁ → OnePointAmalgamation.Vertex a₀ a₁ :=
          OnePointAmalgamation.right a₀ a₁ with hjSdef
        have hSi : Function.Injective iS := OnePointAmalgamation.left_injective a₀ a₁
        have hSj : Function.Injective jS := OnePointAmalgamation.right_injective a₀ a₁
        set JG : _root_.SimpleGraph (OnePointAmalgamation.Vertex a₀ a₁) :=
          _root_.SimpleGraph.map iS J₀ ⊔ _root_.SimpleGraph.map jS J₁ with hJGdef
        have hScov : ∀ z, (∃ x, iS x = z) ∨ (∃ y, jS y = z) :=
          OnePointAmalgamation.exists_left_or_right a₀ a₁
        have hSmeet : ∀ x y, iS x = jS y ↔ (x = a₀ ∧ y = a₁) :=
          OnePointAmalgamation.left_eq_right_iff a₀ a₁
        have hSadj : ∀ z z', JG.Adj z z' ↔
            ((∃ x x', J₀.Adj x x' ∧ iS x = z ∧ iS x' = z') ∨
             (∃ y y', J₁.Adj y y' ∧ jS y = z ∧ jS y' = z')) := by
          intro z z'
          rw [hJGdef]
          simp only [_root_.SimpleGraph.sup_adj, _root_.SimpleGraph.map_adj']
          constructor
          · rintro (⟨-, x, x', hxx', hx, hx'⟩ | ⟨-, y, y', hyy', hy, hy'⟩)
            · exact Or.inl ⟨x, x', hxx', hx, hx'⟩
            · exact Or.inr ⟨y, y', hyy', hy, hy'⟩
          · rintro (⟨x, x', hxx', rfl, rfl⟩ | ⟨y, y', hyy', rfl, rfl⟩)
            · exact Or.inl ⟨fun hcon => hxx'.ne (hSi hcon), x, x', hxx', rfl, rfl⟩
            · exact Or.inr ⟨fun hcon => hyy'.ne (hSj hcon), y, y', hyy', rfl, rfl⟩
        have hScross : ∀ x x' y y', iS x = jS y → iS x' = jS y' → x = x' ∧ y = y' := by
          intro x x' y y' h h'
          obtain ⟨hx, hy⟩ := (hSmeet x y).mp h
          obtain ⟨hx', hy'⟩ := (hSmeet x' y').mp h'
          exact ⟨hx.trans hx'.symm, hy.trans hy'.symm⟩
        -- the Levi side
        set iL : V₀ ⊕ E₀ → OnePointAmalgamation.Vertex r₀ r₁ ⊕ (E₀ ⊕ E₁) :=
          Sum.elim (fun x => Sum.inl (OnePointAmalgamation.left r₀ r₁ x))
            (fun e => Sum.inr (Sum.inl e)) with hiLdef
        set jL : V₁ ⊕ E₁ → OnePointAmalgamation.Vertex r₀ r₁ ⊕ (E₀ ⊕ E₁) :=
          Sum.elim (fun y => Sum.inl (OnePointAmalgamation.right r₀ r₁ y))
            (fun d => Sum.inr (Sum.inr d)) with hjLdef
        have hLi : Function.Injective iL := by
          rintro (x | e) (x' | e') h <;>
            simp only [hiLdef, Sum.elim_inl, Sum.elim_inr] at h
          · exact congrArg Sum.inl
              (OnePointAmalgamation.left_injective r₀ r₁ (by simpa using h))
          · exact absurd h (by simp)
          · exact absurd h (by simp)
          · exact congrArg Sum.inr (by simpa using h)
        have hLj : Function.Injective jL := by
          rintro (y | d) (y' | d') h <;>
            simp only [hjLdef, Sum.elim_inl, Sum.elim_inr] at h
          · exact congrArg Sum.inl
              (OnePointAmalgamation.right_injective r₀ r₁ (by simpa using h))
          · exact absurd h (by simp)
          · exact absurd h (by simp)
          · exact congrArg Sum.inr (by simpa using h)
        have hLcov : ∀ z, (∃ p, iL p = z) ∨ (∃ q, jL q = z) := by
          rintro (q | (e | d))
          · rcases OnePointAmalgamation.exists_left_or_right r₀ r₁ q with ⟨x, rfl⟩ | ⟨y, rfl⟩
            · exact Or.inl ⟨Sum.inl x, rfl⟩
            · exact Or.inr ⟨Sum.inl y, rfl⟩
          · exact Or.inl ⟨Sum.inr e, rfl⟩
          · exact Or.inr ⟨Sum.inr d, rfl⟩
        have hLmeet : ∀ p q, iL p = jL q ↔ (p = Sum.inl r₀ ∧ q = Sum.inl r₁) := by
          rintro (x | e) (y | d)
          · constructor
            · intro h
              have h2 : OnePointAmalgamation.left r₀ r₁ x =
                  OnePointAmalgamation.right r₀ r₁ y := by
                simpa [hiLdef, hjLdef] using h
              obtain ⟨hx, hy⟩ := (OnePointAmalgamation.left_eq_right_iff r₀ r₁ x y).mp h2
              exact ⟨congrArg Sum.inl hx, congrArg Sum.inl hy⟩
            · rintro ⟨hx, hy⟩
              have hx' : x = r₀ := by simpa using hx
              have hy' : y = r₁ := by simpa using hy
              simp only [hiLdef, hjLdef, Sum.elim_inl, hx', hy']
              exact congrArg Sum.inl (OnePointAmalgamation.root_eq r₀ r₁)
          · constructor
            · intro h
              exact absurd h (by simp [hiLdef, hjLdef])
            · rintro ⟨-, hy⟩
              exact absurd hy (by simp)
          · constructor
            · intro h
              exact absurd h (by simp [hiLdef, hjLdef])
            · rintro ⟨hx, -⟩
              exact absurd hx (by simp)
          · constructor
            · intro h
              exact absurd h (by simp [hiLdef, hjLdef])
            · rintro ⟨hx, -⟩
              exact absurd hx (by simp)
        have hLadj : ∀ z z',
            (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).levi.Adj z z' ↔
            ((∃ p p', F₀.levi.Adj p p' ∧ iL p = z ∧ iL p' = z') ∨
             (∃ q q', F₁.levi.Adj q q' ∧ jL q = z ∧ jL q' = z')) := by
          intro z z'
          constructor
          · intro h
            rcases z with q | (e | d)
            · rcases OnePointAmalgamation.exists_left_or_right r₀ r₁ q with ⟨x, rfl⟩ | ⟨y, rfl⟩ <;>
                rcases z' with q' | (e' | d')
              · exact absurd h
                  ((OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).not_levi_adj_point_point)
              · exact Or.inl ⟨Sum.inl x, Sum.inr e',
                  (levi_adj_point_edge F₀).mpr
                    ((OnePointAmalgamation.inc_left_left_iff F₀ F₁ r₀ r₁ x e').mp
                      ((levi_adj_point_edge (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)),
                  rfl, rfl⟩
              · have hpair := (OnePointAmalgamation.inc_left_right_iff F₀ F₁ r₀ r₁ x d').mp
                  ((levi_adj_point_edge (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)
                refine Or.inr ⟨Sum.inl r₁, Sum.inr d',
                  (levi_adj_point_edge F₁).mpr hpair.2, ?_, rfl⟩
                rw [hpair.1]
                exact congrArg Sum.inl (OnePointAmalgamation.root_eq r₀ r₁).symm
              · exact absurd h
                  ((OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).not_levi_adj_point_point)
              · have hpair := (OnePointAmalgamation.inc_right_left_iff F₀ F₁ r₀ r₁ y e').mp
                  ((levi_adj_point_edge (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)
                refine Or.inl ⟨Sum.inl r₀, Sum.inr e',
                  (levi_adj_point_edge F₀).mpr hpair.2, ?_, rfl⟩
                rw [hpair.1]
                exact congrArg Sum.inl (OnePointAmalgamation.root_eq r₀ r₁)
              · exact Or.inr ⟨Sum.inl y, Sum.inr d',
                  (levi_adj_point_edge F₁).mpr
                    ((OnePointAmalgamation.inc_right_right_iff F₀ F₁ r₀ r₁ y d').mp
                      ((levi_adj_point_edge (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)),
                  rfl, rfl⟩
            · rcases z' with q' | (e' | d')
              · rcases OnePointAmalgamation.exists_left_or_right r₀ r₁ q' with ⟨x', rfl⟩ | ⟨y', rfl⟩
                · exact Or.inl ⟨Sum.inr e, Sum.inl x',
                    (levi_adj_edge_point F₀).mpr
                      ((OnePointAmalgamation.inc_left_left_iff F₀ F₁ r₀ r₁ x' e).mp
                        ((levi_adj_edge_point (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)),
                    rfl, rfl⟩
                · have hpair := (OnePointAmalgamation.inc_right_left_iff F₀ F₁ r₀ r₁ y' e).mp
                    ((levi_adj_edge_point (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)
                  refine Or.inl ⟨Sum.inr e, Sum.inl r₀,
                    (levi_adj_edge_point F₀).mpr hpair.2, rfl, ?_⟩
                  rw [hpair.1]
                  exact congrArg Sum.inl (OnePointAmalgamation.root_eq r₀ r₁)
              · exact absurd h
                  ((OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge)
              · exact absurd h
                  ((OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge)
            · rcases z' with q' | (e' | d')
              · rcases OnePointAmalgamation.exists_left_or_right r₀ r₁ q' with ⟨x', rfl⟩ | ⟨y', rfl⟩
                · have hpair := (OnePointAmalgamation.inc_left_right_iff F₀ F₁ r₀ r₁ x' d).mp
                    ((levi_adj_edge_point (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)
                  refine Or.inr ⟨Sum.inr d, Sum.inl r₁,
                    (levi_adj_edge_point F₁).mpr hpair.2, rfl, ?_⟩
                  rw [hpair.1]
                  exact congrArg Sum.inl (OnePointAmalgamation.root_eq r₀ r₁).symm
                · exact Or.inr ⟨Sum.inr d, Sum.inl y',
                    (levi_adj_edge_point F₁).mpr
                      ((OnePointAmalgamation.inc_right_right_iff F₀ F₁ r₀ r₁ y' d).mp
                        ((levi_adj_edge_point (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mp h)),
                    rfl, rfl⟩
              · exact absurd h
                  ((OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge)
              · exact absurd h
                  ((OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge)
          · rintro (⟨p, p', hpp', rfl, rfl⟩ | ⟨q, q', hqq', rfl, rfl⟩)
            · rcases p with x | e <;> rcases p' with x' | e'
              · exact absurd hpp' F₀.not_levi_adj_point_point
              · exact (levi_adj_point_edge (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mpr
                  ((OnePointAmalgamation.inc_left_left_iff F₀ F₁ r₀ r₁ x e').mpr
                    ((levi_adj_point_edge F₀).mp hpp'))
              · exact (levi_adj_edge_point (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mpr
                  ((OnePointAmalgamation.inc_left_left_iff F₀ F₁ r₀ r₁ x' e).mpr
                    ((levi_adj_edge_point F₀).mp hpp'))
              · exact absurd hpp' F₀.not_levi_adj_edge_edge
            · rcases q with y | d <;> rcases q' with y' | d'
              · exact absurd hqq' F₁.not_levi_adj_point_point
              · exact (levi_adj_point_edge (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mpr
                  ((OnePointAmalgamation.inc_right_right_iff F₀ F₁ r₀ r₁ y d').mpr
                    ((levi_adj_point_edge F₁).mp hqq'))
              · exact (levi_adj_edge_point (OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁)).mpr
                  ((OnePointAmalgamation.inc_right_right_iff F₀ F₁ r₀ r₁ y' d).mpr
                    ((levi_adj_edge_point F₁).mp hqq'))
              · exact absurd hqq' F₁.not_levi_adj_edge_edge
        have hLcross : ∀ p p' q q', iL p = jL q → iL p' = jL q' → p = p' ∧ q = q' := by
          intro p p' q q' h h'
          obtain ⟨hp, hq⟩ := (hLmeet p q).mp h
          obtain ⟨hp', hq'⟩ := (hLmeet p' q').mp h'
          exact ⟨hp.trans hp'.symm, hq.trans hq'.symm⟩
        refine ⟨OnePointAmalgamation.Vertex a₀ a₁, JG, inferInstance, ?_, ?_, ?_, ?_, ?_⟩
        · obtain ⟨c₀⟩ := hcol₀
          obtain ⟨c₁⟩ := hcol₁
          set c₁' : W₁ → Fin 2 :=
            fun y => if c₀ a₀ = c₁ a₁ then c₁ y else Equiv.swap 0 1 (c₁ y) with hc₁'def
          have hc₁'ne : ∀ y y', J₁.Adj y y' → c₁' y ≠ c₁' y' := by
            intro y y' hyy'
            have hne := c₁.valid hyy'
            by_cases hcase : c₀ a₀ = c₁ a₁
            · simpa [hc₁'def, hcase] using hne
            · simp only [hc₁'def, if_neg hcase]
              exact fun hh => hne ((Equiv.swap (0 : Fin 2) 1).injective hh)
          have hrooteq : c₀ a₀ = c₁' a₁ := by
            by_cases hcase : c₀ a₀ = c₁ a₁
            · simp [hc₁'def, hcase]
            · simp only [hc₁'def, if_neg hcase]
              revert hcase
              generalize c₀ a₀ = pp
              generalize c₁ a₁ = qq
              revert pp qq
              decide
          refine ⟨_root_.SimpleGraph.Coloring.mk
            (OnePointAmalgamation.lift a₀ a₁ c₀ c₁' hrooteq) ?_⟩
          intro z z' hzz'
          rcases (hSadj z z').mp hzz' with ⟨x, x', hxx', rfl, rfl⟩ | ⟨y, y', hyy', rfl, rfl⟩
          · simpa [hiSdef] using c₀.valid hxx'
          · simpa [hjSdef] using hc₁'ne y y' hyy'
        · have hSiso := Classical.choice (glue_isolated_equiv hSi hSj hScov hSadj hSmeet)
          have hLiso := Classical.choice (glue_isolated_equiv hLi hLj hLcov hLadj hLmeet)
          by_cases hcond : (∀ w, ¬J₀.Adj a₀ w) ∨ (∀ w, ¬J₁.Adj a₁ w)
          · have hcondL : (∀ w, ¬F₀.levi.Adj (Sum.inl r₀) w) ∨
                (∀ w, ¬F₁.levi.Adj (Sum.inl r₁) w) := by
              rcases hcond with h | h
              · exact Or.inl (ha₀.mp h)
              · exact Or.inr (ha₁.mp h)
            have hS : Nat.card {z // ∀ w, ¬JG.Adj z w} + 1 =
                Nat.card {x : W₀ // ∀ w, ¬J₀.Adj x w} +
                  Nat.card {y : W₁ // ∀ w, ¬J₁.Adj y w} := by
              rw [← Nat.card_congr hSiso, Nat.card_sum]
              exact card_glue_isolated_pos (fun x : W₀ => ∀ w, ¬J₀.Adj x w)
                (fun y : W₁ => ∀ w, ¬J₁.Adj y w) a₀ a₁ hcond
            have hL : Nat.card {z // ∀ w,
                  ¬(OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).levi.Adj z w} + 1 =
                Nat.card {p : V₀ ⊕ E₀ // ∀ w, ¬F₀.levi.Adj p w} +
                  Nat.card {q : V₁ ⊕ E₁ // ∀ w, ¬F₁.levi.Adj q w} := by
              rw [← Nat.card_congr hLiso, Nat.card_sum]
              exact card_glue_isolated_pos (fun p : V₀ ⊕ E₀ => ∀ w, ¬F₀.levi.Adj p w)
                (fun q : V₁ ⊕ E₁ => ∀ w, ¬F₁.levi.Adj q w) (Sum.inl r₀) (Sum.inl r₁) hcondL
            omega
          · have hcond0 : ¬(∀ w, ¬J₀.Adj a₀ w) := fun h => hcond (Or.inl h)
            have hcond1 : ¬(∀ w, ¬J₁.Adj a₁ w) := fun h => hcond (Or.inr h)
            have hcondL0 : ¬(∀ w, ¬F₀.levi.Adj (Sum.inl r₀) w) := fun h => hcond0 (ha₀.mpr h)
            have hcondL1 : ¬(∀ w, ¬F₁.levi.Adj (Sum.inl r₁) w) := fun h => hcond1 (ha₁.mpr h)
            have hS : Nat.card {z // ∀ w, ¬JG.Adj z w} =
                Nat.card {x : W₀ // ∀ w, ¬J₀.Adj x w} +
                  Nat.card {y : W₁ // ∀ w, ¬J₁.Adj y w} := by
              rw [← Nat.card_congr hSiso, Nat.card_sum]
              exact card_glue_isolated_neg (fun x : W₀ => ∀ w, ¬J₀.Adj x w)
                (fun y : W₁ => ∀ w, ¬J₁.Adj y w) a₀ a₁ hcond0 hcond1
            have hL : Nat.card {z // ∀ w,
                  ¬(OnePointAmalgamation.amalgam F₀ F₁ r₀ r₁).levi.Adj z w} =
                Nat.card {p : V₀ ⊕ E₀ // ∀ w, ¬F₀.levi.Adj p w} +
                  Nat.card {q : V₁ ⊕ E₁ // ∀ w, ¬F₁.levi.Adj q w} := by
              rw [← Nat.card_congr hLiso, Nat.card_sum]
              exact card_glue_isolated_neg (fun p : V₀ ⊕ E₀ => ∀ w, ¬F₀.levi.Adj p w)
                (fun q : V₁ ⊕ E₁ => ∀ w, ¬F₁.levi.Adj q w) (Sum.inl r₀) (Sum.inl r₁)
                hcondL0 hcondL1
            omega
        · rw [← Nat.card_congr (Classical.choice (edge_equiv hSi hSj hSadj hScross)),
            Nat.card_sum, hedge₀, hedge₁, Nat.card_sum]
        · have hSv := Nat.card_congr (Classical.choice (glue_vertex_equiv hSi hSj hScov hSmeet))
          have hLv := Nat.card_congr (Classical.choice (glue_vertex_equiv hLi hLj hLcov hLmeet))
          have h3 := card_subtype_ne_succ (X := W₁) a₁
          have h4 := card_subtype_ne_succ (X := V₁ ⊕ E₁) (Sum.inl r₁)
          simp only [Nat.card_sum] at hSv hLv h4 ⊢
          omega
        · have hSc := Nat.card_congr (Classical.choice
            (glue_component_equiv hSi hSj hScov hSadj hSmeet))
          have hLc := Nat.card_congr (Classical.choice
            (glue_component_equiv hLi hLj hLcov hLadj hLmeet))
          have h3 := card_subtype_ne_succ (X := J₁.ConnectedComponent)
            (J₁.connectedComponentMk a₁)
          have h4 := card_subtype_ne_succ (X := F₁.levi.ConnectedComponent)
            (F₁.levi.connectedComponentMk (Sum.inl r₁))
          simp only [Nat.card_sum] at hSc hLc
          omega
    | @ofIso V E V' E' F F' hF f ihF =>
        classical
        obtain ⟨W, J, hWfin, hcol, hiso, hedge, hvert, hcomp⟩ := ihF
        have he : ∀ z z' : V ⊕ E,
            F'.levi.Adj (Equiv.sumCongr f.vertexEquiv f.edgeEquiv z)
              (Equiv.sumCongr f.vertexEquiv f.edgeEquiv z') ↔ F.levi.Adj z z' := by
          rintro (x | e) (y | d) <;>
            simp [Equiv.sumCongr, ← f.map_inc_iff]
        obtain ⟨⟨ecomp⟩, -, ⟨eiso⟩, -⟩ :=
          iso_transfer F.levi F'.levi (Equiv.sumCongr f.vertexEquiv f.edgeEquiv) he
        refine ⟨W, J, hWfin, hcol, ?_, ?_, ?_, ?_⟩
        · rw [hiso]; exact Nat.card_congr eiso
        · rw [hedge]; exact Nat.card_congr f.edgeEquiv
        · rw [← Nat.card_congr f.edgeEquiv, ← Nat.card_congr f.vertexEquiv]; exact hvert
        · rw [hcomp]; exact Nat.card_congr ecomp

  have hconstr : F.Constructible :=
    (CanonicalAtom.atomGenerated_iff_constructible F).mp
      ((CanonicalAtom.isObligatory_iff_atomGenerated F).mp hobligatory)
  obtain ⟨W, J, hWfin, hcol, hiso, hedge, hvert, hcomp⟩ := key hconstr
  letI : Finite W := hWfin
  have hlevi_empty : IsEmpty {z : V ⊕ E // ∀ w, ¬F.levi.Adj z w} := by
    constructor
    rintro ⟨z, hz⟩
    rcases z with x | e
    · obtain ⟨e, he⟩ := (F.not_isolated_iff_exists_inc).mp (hreduced x)
      exact hz (Sum.inr e) ((levi_adj_point_edge F).mpr he)
    · have hne : Set.ncard {x : V | F.Inc x e} ≠ 0 := by
        rw [F.edge_ncard e]
        decide
      obtain ⟨x, hx⟩ := Set.nonempty_of_ncard_ne_zero hne
      exact hz (Sum.inl x) ((levi_adj_edge_point F).mpr hx)
  have hzero : Nat.card {z : V ⊕ E // ∀ w, ¬F.levi.Adj z w} = 0 := by
    haveI := hlevi_empty
    exact Nat.card_of_isEmpty
  have hnoiso : ∀ x : W, ∃ y, J.Adj x y := by
    intro x
    by_contra hcon
    have hne : Nonempty {v : W // ∀ y, ¬J.Adj v y} := ⟨⟨x, fun y hy => hcon ⟨y, hy⟩⟩⟩
    have hpos : 0 < Nat.card {v : W // ∀ y, ¬J.Adj v y} := Nat.card_pos
    omega
  refine ⟨Nat.card W, _root_.SimpleGraph.map (Finite.equivFin W) J, ?_, ?_, ?_, ?_, ?_⟩
  · obtain ⟨c⟩ := hcol
    exact ⟨c.comp (_root_.SimpleGraph.Iso.map (Finite.equivFin W) J).symm.toHom⟩
  · intro x
    obtain ⟨y, hy⟩ := hnoiso ((Finite.equivFin W).symm x)
    refine ⟨Finite.equivFin W y, ?_⟩
    have := (_root_.SimpleGraph.Iso.map (Finite.equivFin W) J).map_adj_iff.mpr hy
    simpa using this
  · rw [← Nat.card_congr (_root_.SimpleGraph.Iso.map (Finite.equivFin W) J).mapEdgeSet, hedge,
      Nat.card_eq_fintype_card]
  · rw [← Nat.card_eq_fintype_card, ← Nat.card_eq_fintype_card]
    exact hvert
  · rw [← Nat.card_congr
      (_root_.SimpleGraph.Iso.map (Finite.equivFin W) J).connectedComponentEquiv, hcomp]

theorem privateVertexExpansion_shadow_parameters
    {W : Type u} [Fintype W] (J : _root_.SimpleGraph W)
    (hbipartite : J.Colorable 2)
    (hnoisolated : ∀ x, ∃ y, J.Adj x y) :
    (privateVertexExpansion J).IsObligatory ∧
    (privateVertexExpansion J).HasNoIsolatedPoints ∧
    Nat.card (PrivateVertexExpansion.Edge J) = Nat.card J.edgeSet ∧
    Nat.card (PrivateVertexExpansion.Point J) =
      Fintype.card W + Nat.card J.edgeSet ∧
    Nat.card (privateVertexExpansion J).levi.ConnectedComponent =
      Nat.card J.ConnectedComponent := by
  classical
  refine ⟨(Constructible.ofExpansion J hbipartite).isObligatory, ?_, rfl, ?_,
    privateVertexExpansion_component_card J⟩
  · intro p
    rw [not_isolated_iff_exists_inc]
    rcases p with x | e
    · obtain ⟨y, hxy⟩ := hnoisolated x
      exact ⟨⟨s(x, y), hxy⟩, by simp [privateVertexExpansion, PrivateVertexExpansion.Inc]⟩
    · exact ⟨e, rfl⟩
  · simpa only [PrivateVertexExpansion.Point, PrivateVertexExpansion.CoreVertex,
      PrivateVertexExpansion.PrivateVertex, Nat.card_eq_fintype_card] using
      (Nat.card_sum (α := W) (β := J.edgeSet))

/-- The manuscript's subtraction form of the bipartite-shadow parameters. -/
theorem exists_bipartite_shadow_subtraction
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E]
    (hobligatory : F.IsObligatory)
    (hreduced : F.HasNoIsolatedPoints)
    (hnonempty : Nonempty E) :
    ∃ (J : _root_.SimpleGraph (Fin (Fintype.card V - Fintype.card E))),
      J.Colorable 2 ∧
      (∀ x, ∃ y, J.Adj x y) ∧
      Nat.card J.edgeSet = Fintype.card E ∧
      Nat.card J.ConnectedComponent = Nat.card F.levi.ConnectedComponent := by
  obtain ⟨s, J, hbipartite, hnoisolated, hedges, hvertices, hcomponents⟩ :=
    exists_bipartite_shadow F hobligatory hreduced hnonempty
  have hs : s = Fintype.card V - Fintype.card E := by omega
  subst s
  exact ⟨J, hbipartite, hnoisolated, hedges, hcomponents⟩

end Erdos593.TripleSystem
