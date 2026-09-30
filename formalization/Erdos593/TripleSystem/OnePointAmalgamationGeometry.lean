import Erdos593.TripleSystem.OnePointAmalgamationIntrinsic
import Erdos593.TripleSystem.Isolated
import Mathlib.SetTheory.Cardinal.Finite

/-!
# Geometry of one-point amalgamation

Counts and structural properties of the actual quotient construction.
-/

namespace Erdos593.TripleSystem.OnePointAmalgamation

universe u

theorem card_vertex_add_one
    {V W : Type u} [Finite V] [Finite W]
    (r : V) (q : W) :
    Nat.card (Vertex r q) + 1 = Nat.card V + Nat.card W := by
  classical
  let e : (V ⊕ {y : W // y ≠ q}) ≃ Vertex r q :=
    Equiv.ofBijective (Sum.elim (left r q) (fun y => right r q y.1)) (by
      constructor
      · rintro (x | ⟨y, hy⟩) (x' | ⟨y', hy'⟩) h <;>
          simp only [Sum.elim_inl, Sum.elim_inr] at h
        · exact congrArg Sum.inl (left_injective r q h)
        · exact absurd ((left_eq_right_iff r q x y').mp h).2 hy'
        · exact absurd ((left_eq_right_iff r q x' y).mp h.symm).2 hy
        · exact congrArg Sum.inr (Subtype.ext (right_injective r q h))
      · intro z
        rcases exists_left_or_right r q z with ⟨x, rfl⟩ | ⟨y, rfl⟩
        · exact ⟨Sum.inl x, rfl⟩
        · by_cases hy : y = q
          · exact ⟨Sum.inl r, by simpa only [Sum.elim_inl, hy] using root_eq r q⟩
          · exact ⟨Sum.inr ⟨y, hy⟩, rfl⟩)
  have hrest : Nat.card {y : W // y ≠ q} + 1 = Nat.card W := by
    have hcard : Nat.card ({y : W // y ≠ q} ⊕ PUnit.{u + 1}) = Nat.card W := by
      refine Nat.card_congr (Equiv.ofBijective
        (Sum.elim (fun y => y.1) (fun _ => q)) ⟨?_, ?_⟩)
      · rintro (⟨x, hx⟩ | a) (⟨y, hy⟩ | b) h <;>
          simp only [Sum.elim_inl, Sum.elim_inr] at h
        · exact congrArg Sum.inl (Subtype.ext h)
        · exact absurd h hx
        · exact absurd h.symm hy
        · rfl
      · intro y
        by_cases hy : y = q
        · exact ⟨Sum.inr PUnit.unit, hy.symm⟩
        · exact ⟨Sum.inl ⟨y, hy⟩, rfl⟩
    rw [← hcard, Nat.card_sum]
    simp
  calc
    Nat.card (Vertex r q) + 1 =
        (Nat.card V + Nat.card {y : W // y ≠ q}) + 1 := by
      rw [← Nat.card_congr e, Nat.card_sum]
    _ = Nat.card V + Nat.card W := by rw [Nat.add_assoc, hrest]

theorem amalgam_levi_connected
    {V E W D : Type u}
    (F : TripleSystem V E) (T : TripleSystem W D)
    (r : V) (q : W)
    (hF : F.levi.Preconnected)
    (hT : T.levi.Preconnected) :
    (amalgam F T r q).levi.Connected := by
  have hreach : ∀ z : Vertex r q ⊕ Edge E D,
      (amalgam F T r q).levi.Reachable z (.inl (left r q r)) := by
    intro z
    rcases z with z | (e | d)
    · rcases exists_left_or_right r q z with ⟨x, rfl⟩ | ⟨y, rfl⟩
      · exact (hF (.inl x) (.inl r)).map (leftLeviEmbedding F T r q).toHom
      · have h := (hT (.inl y) (.inl q)).map (rightLeviEmbedding F T r q).toHom
        change (amalgam F T r q).levi.Reachable
          (.inl (right r q y)) (.inl (right r q q)) at h
        rw [← root_eq r q] at h
        exact h
    · exact (hF (.inr e) (.inl r)).map (leftLeviEmbedding F T r q).toHom
    · have h := (hT (.inr d) (.inl q)).map (rightLeviEmbedding F T r q).toHom
      change (amalgam F T r q).levi.Reachable
        (.inr (.inr d)) (.inl (right r q q)) at h
      rw [← root_eq r q] at h
      exact h
  exact {
    preconnected := fun a b => (hreach a).trans (hreach b).symm
    nonempty := ⟨.inl (left r q r)⟩ }

theorem amalgam_hasNoIsolatedPoints
    {V E W D : Type u}
    (F : TripleSystem V E) (T : TripleSystem W D)
    (r : V) (q : W)
    (hF : F.HasNoIsolatedPoints)
    (hT : T.HasNoIsolatedPoints) :
    (amalgam F T r q).HasNoIsolatedPoints := by
  intro z
  rcases exists_left_or_right r q z with ⟨x, rfl⟩ | ⟨y, rfl⟩
  · obtain ⟨e, he⟩ := F.not_isolated_iff_exists_inc.mp (hF x)
    exact (amalgam F T r q).not_isolated_of_inc (e := Sum.inl e)
      ((inc_left_left_iff F T r q x e).mpr he)
  · obtain ⟨d, hd⟩ := T.not_isolated_iff_exists_inc.mp (hT y)
    exact (amalgam F T r q).not_isolated_of_inc (e := Sum.inr d)
      ((inc_right_right_iff F T r q y d).mpr hd)

end Erdos593.TripleSystem.OnePointAmalgamation
