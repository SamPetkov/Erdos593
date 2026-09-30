import Erdos593.Separator.SeparatorForest
import Mathlib.Data.Setoid.Basic
import Mathlib.Data.Fintype.EquivFin

/-!
# The project's partition type is the standard partition lattice

This module uses PR50's accepted partition structure and its existing refinement
order. It does not introduce another order instance or redefine that structure.
The explicit equivalences below identify it with Mathlib's `Setoid`, including
empty carriers and transport to the standard finite carrier.

New source candidate, not a claim of kernel verification.
-/

namespace E593Standard

universe u v w

/-- Retain exactly the original equivalence relation. -/
def toSetoid {A : Type u} (R : E593Separator.Partition A) : Setoid A where
  r := R.rel
  iseqv := ⟨R.refl, R.symm, R.trans⟩

/-- Retain exactly the standard equivalence relation. -/
def ofSetoid {A : Type u} (R : Setoid A) : E593Separator.Partition A where
  rel := R.r
  refl := R.iseqv.refl
  symm := R.iseqv.symm
  trans := R.iseqv.trans

/-- The original refinement order, not only cardinality, is preserved. -/
def partitionSetoidOrderIso (A : Type u) : E593Separator.Partition A ≃o Setoid A where
  toFun := toSetoid
  invFun := ofSetoid
  left_inv R := E593Separator.Partition.ext rfl
  right_inv R := Setoid.ext (fun _ _ => Iff.rfl)
  map_rel_iff' := by
    intro R S
    constructor
    · intro h a b hab
      exact h hab
    · intro h a b hab
      exact h a b hab

@[simp]
theorem partitionSetoidOrderIso_rel {A : Type u}
    (R : E593Separator.Partition A) (a b : A) :
    (partitionSetoidOrderIso A R).r a b ↔ R.rel a b := Iff.rfl

/-- Relabel a standard partition by an actual carrier equivalence. -/
def setoidReindex {A : Type u} {B : Type v} (e : A ≃ B) (R : Setoid A) : Setoid B where
  r x y := R.r (e.symm x) (e.symm y)
  iseqv := ⟨fun x => R.iseqv.refl (e.symm x),
    fun h => R.iseqv.symm h, fun h₁ h₂ => R.iseqv.trans h₁ h₂⟩

/-- The inverse map is relabelling by the inverse carrier equivalence. -/
def setoidReindexOrderIso {A : Type u} {B : Type v} (e : A ≃ B) : Setoid A ≃o Setoid B where
  toFun := setoidReindex e
  invFun := setoidReindex e.symm
  left_inv R := by
    apply Setoid.ext
    intro a b
    change R.r (e.symm (e a)) (e.symm (e b)) ↔ R.r a b
    rw [e.symm_apply_apply, e.symm_apply_apply]
  right_inv R := by
    apply Setoid.ext
    intro a b
    change R.r (e (e.symm a)) (e (e.symm b)) ↔ R.r a b
    rw [e.apply_symm_apply, e.apply_symm_apply]
  map_rel_iff' := by
    intro R S
    constructor
    · intro h a b hab
      have hab' : (setoidReindex e R).r (e a) (e b) := by
        change R.r (e.symm (e a)) (e.symm (e b))
        rwa [e.symm_apply_apply, e.symm_apply_apply]
      have hS := h hab'
      change S.r (e.symm (e a)) (e.symm (e b)) at hS
      rwa [e.symm_apply_apply, e.symm_apply_apply] at hS
    · intro h a b hab
      exact h hab

@[simp]
theorem setoidReindexOrderIso_rel {A : Type u} {B : Type v}
    (e : A ≃ B) (R : Setoid A) (a b : B) :
    (setoidReindexOrderIso e R).r a b ↔ R.r (e.symm a) (e.symm b) := Iff.rfl

/-- A real enumeration of the finite carrier; finiteness is not inferred
from a natural cardinality whose value could otherwise be zero. -/
noncomputable def finiteCarrierEquiv (A : Type u) [Finite A] : A ≃ Fin (Nat.card A) := by
  classical
  letI : Fintype A := Fintype.ofFinite A
  simpa only [Nat.card_eq_fintype_card] using Fintype.equivFin A

/-- The standard finite partition lattice, with no positivity restriction. -/
noncomputable def finitePartitionOrderIso (A : Type u) [Finite A] :
    E593Separator.Partition A ≃o Setoid (Fin (Nat.card A)) :=
  (partitionSetoidOrderIso A).trans (setoidReindexOrderIso (finiteCarrierEquiv A))

/-- Pointwise order transport: no permutation of the separator index is used. -/
def pointwiseOrderIso {I : Type u} {A : I → Type v} {B : I → Type w}
    [∀ i, PartialOrder (A i)] [∀ i, PartialOrder (B i)]
    (e : ∀ i, A i ≃o B i) : (∀ i, A i) ≃o (∀ i, B i) where
  toFun R i := e i (R i)
  invFun R i := (e i).symm (R i)
  left_inv R := funext (fun i => (e i).symm_apply_apply (R i))
  right_inv R := funext (fun i => (e i).apply_symm_apply (R i))
  map_rel_iff' := by
    intro R S
    constructor
    · intro h i
      exact (e i).le_iff_le.mp (h i)
    · intro h i
      exact (e i).le_iff_le.mpr (h i)

@[simp]
theorem pointwiseOrderIso_apply {I : Type u} {A : I → Type v} {B : I → Type w}
    [∀ i, PartialOrder (A i)] [∀ i, PartialOrder (B i)]
    (e : ∀ i, A i ≃o B i) (R : ∀ i, A i) (i : I) :
    pointwiseOrderIso e R i = e i (R i) := rfl

end E593Standard
