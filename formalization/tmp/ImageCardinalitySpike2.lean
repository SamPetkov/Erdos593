import Erdos593.TripleSystem.CardinalPairPartition

/-! Scratch verification: cardinality is preserved by the image of a set under
an equivalence between carriers in one universe.  This file is untracked. -/

universe u

private def imageSubtypeEquiv {A B : Type u}
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

theorem mk_image_eq {A B : Type u}
    (e : A ≃ B) (H : Set A) :
    Cardinal.mk (e '' H) = Cardinal.mk H := by
  exact (Cardinal.mk_congr (imageSubtypeEquiv e H)).symm
