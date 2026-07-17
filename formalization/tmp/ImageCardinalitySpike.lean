import Erdos593.TripleSystem.CardinalPairPartition

/-! Scratch verification: cardinality is preserved by the image of a set under
an equivalence.  This file is intentionally untracked. -/

universe u v

private def imageSubtypeEquiv {A : Type u} {B : Type v}
    (e : A ≃ B) (H : Set A) : H ≃ e '' H where
  toFun x := ⟨e x, ⟨x, x.property, rfl⟩⟩
  invFun y :=
    ⟨e.symm y, by
      rcases y.property with ⟨x, hx, hxy⟩
      rw [← hxy, e.symm_apply_apply]
      exact hx⟩
  left_inv x := by
    apply Subtype.ext
    simp
  right_inv y := by
    apply Subtype.ext
    simp

theorem mk_image_eq {A : Type u} {B : Type v}
    (e : A ≃ B) (H : Set A) :
    Cardinal.mk (e '' H) = Cardinal.mk H := by
  exact (Cardinal.mk_congr (imageSubtypeEquiv e H)).symm
