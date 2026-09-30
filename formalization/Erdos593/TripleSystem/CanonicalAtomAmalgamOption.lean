import Erdos593.TripleSystem.CanonicalAtomAmalgamLabels

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem exists_atomEquiv_option_of_unique_edges
    {V E W D : Type u}
    [Fintype V] [Fintype E] [Fintype W] [Fintype D]
    [DecidableEq V] [DecidableEq E] [Unique D]
    (F : TripleSystem V E) (T : TripleSystem W D)
    [DecidableRel F.levi.Adj]
    (hF : F.Intrinsic) (hT : T.Intrinsic)
    (r : V) (q : W) :
    let U := OnePointAmalgamation.amalgam F T r q
    letI : Fintype (OnePointAmalgamation.Vertex r q) :=
      OnePointAmalgamation.vertexFintype r q
    letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
    letI : DecidableEq (E ⊕ D) := Classical.decEq _
    letI : DecidableRel U.levi.Adj := Classical.decRel _
    let hU : U.Intrinsic :=
      OnePointAmalgamation.amalgam_intrinsic F T r q hF hT
    ∃ φ : Index U ≃ Option (Index F),
      (∀ e : E,
        φ (atomOf U hU.1 hU.2.1 (Sum.inl e)) =
          some (atomOf F hF.1 hF.2.1 e)) ∧
      (∀ d : D,
        φ (atomOf U hU.1 hU.2.1 (Sum.inr d)) = none) :=
by
  let U := OnePointAmalgamation.amalgam F T r q
  letI : Fintype (OnePointAmalgamation.Vertex r q) :=
    OnePointAmalgamation.vertexFintype r q
  letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
  letI : DecidableEq (E ⊕ D) := Classical.decEq _
  letI : DecidableRel U.levi.Adj := Classical.decRel _
  let hU : U.Intrinsic :=
    OnePointAmalgamation.amalgam_intrinsic F T r q hF hT
  change ∃ φ : Index U ≃ Option (Index F),
    (∀ e : E,
      φ (atomOf U hU.1 hU.2.1 (Sum.inl e)) =
        some (atomOf F hF.1 hF.2.1 e)) ∧
    (∀ d : D, φ (atomOf U hU.1 hU.2.1 (Sum.inr d)) = none)
  have hne : ∀ (e : E) (d : D),
      atomOf U hU.1 hU.2.1 (Sum.inl e) ≠ atomOf U hU.1 hU.2.1 (Sum.inr d) :=
    fun e d => atomOf_amalgam_inl_ne_inr F T hF hT r q e d
  have hiff : ∀ e f : E,
      (atomOf U hU.1 hU.2.1 (Sum.inl e) = atomOf U hU.1 hU.2.1 (Sum.inl f)) ↔
        atomOf F hF.1 hF.2.1 e = atomOf F hF.1 hF.2.1 f :=
    fun e f => atomOf_amalgam_inl_eq_iff F T hF hT r q e f
  let rep : Index F → E :=
    fun B => Classical.choose (atomOf_surjective F hF.1 hF.2.1 B)
  have hrep : ∀ B : Index F, atomOf F hF.1 hF.2.1 (rep B) = B :=
    fun B => Classical.choose_spec (atomOf_surjective F hF.1 hF.2.1 B)
  let g : Option (Index F) → Index U := fun o =>
    match o with
    | some B => atomOf U hU.1 hU.2.1 (Sum.inl (rep B))
    | none => atomOf U hU.1 hU.2.1 (Sum.inr default)
  have hg_some : ∀ B : Index F,
      g (some B) = atomOf U hU.1 hU.2.1 (Sum.inl (rep B)) := fun _ => rfl
  have hg_none : g none = atomOf U hU.1 hU.2.1 (Sum.inr default) := rfl
  have hginj : Function.Injective g := by
    intro a b hab
    cases a with
    | none =>
        cases b with
        | none => rfl
        | some B =>
            rw [hg_none, hg_some] at hab
            exact absurd hab.symm (hne (rep B) default)
    | some A =>
        cases b with
        | none =>
            rw [hg_none, hg_some] at hab
            exact absurd hab (hne (rep A) default)
        | some B =>
            rw [hg_some, hg_some] at hab
            have h := (hiff (rep A) (rep B)).mp hab
            rw [hrep, hrep] at h
            exact congrArg some h
  have hgsurj : Function.Surjective g := by
    intro A
    obtain ⟨z, hz⟩ := atomOf_surjective U hU.1 hU.2.1 A
    cases z with
    | inl e =>
        refine ⟨some (atomOf F hF.1 hF.2.1 e), ?_⟩
        rw [hg_some]
        refine Eq.trans ?_ hz
        exact (hiff (rep (atomOf F hF.1 hF.2.1 e)) e).mpr (hrep _)
    | inr d =>
        refine ⟨none, ?_⟩
        rw [hg_none, Subsingleton.elim (default : D) d]
        exact hz
  refine ⟨(Equiv.ofBijective g ⟨hginj, hgsurj⟩).symm, ?_, ?_⟩
  · intro e
    rw [Equiv.symm_apply_eq]
    show atomOf U hU.1 hU.2.1 (Sum.inl e) = g (some (atomOf F hF.1 hF.2.1 e))
    rw [hg_some]
    exact (hiff e (rep (atomOf F hF.1 hF.2.1 e))).mpr (hrep _).symm
  · intro d
    rw [Equiv.symm_apply_eq]
    show atomOf U hU.1 hU.2.1 (Sum.inr d) = g none
    rw [hg_none, Subsingleton.elim (default : D) d]

theorem card_index_amalgam_of_unique_edges
    {V E W D : Type u}
    [Fintype V] [Fintype E] [Fintype W] [Fintype D]
    [DecidableEq V] [DecidableEq E] [Unique D]
    (F : TripleSystem V E) (T : TripleSystem W D)
    [DecidableRel F.levi.Adj]
    (hF : F.Intrinsic) (hT : T.Intrinsic)
    (r : V) (q : W) :
    let U := OnePointAmalgamation.amalgam F T r q
    letI : Fintype (OnePointAmalgamation.Vertex r q) :=
      OnePointAmalgamation.vertexFintype r q
    letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
    letI : DecidableEq (E ⊕ D) := Classical.decEq _
    letI : DecidableRel U.levi.Adj := Classical.decRel _
    Nat.card (Index U) = Nat.card (Index F) + 1 :=
by
  let U := OnePointAmalgamation.amalgam F T r q
  letI : Fintype (OnePointAmalgamation.Vertex r q) :=
    OnePointAmalgamation.vertexFintype r q
  letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
  letI : DecidableEq (E ⊕ D) := Classical.decEq _
  letI : DecidableRel U.levi.Adj := Classical.decRel _
  change Nat.card (Index U) = Nat.card (Index F) + 1
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hF.1 hF.2.1)
  obtain ⟨φ, -, -⟩ :=
    exists_atomEquiv_option_of_unique_edges F T hF hT r q
  have hcard : Nat.card (Index U) = Nat.card (Option (Index F)) :=
    Nat.card_congr φ
  rw [hcard, _root_.Finite.card_option]

end Erdos593.TripleSystem.CanonicalAtom
