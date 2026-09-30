import Erdos593.TripleSystem.ObligatoryIsolatedReduction

/-! # Adjoining isolated points along a prescribed vertex embedding -/

namespace Erdos593.TripleSystem

variable {V W E : Type}

def isolatedExtensionInc (F : TripleSystem V E) (f : V ↪ W) (x : W) (e : E) : Prop :=
  x ∈ f '' F.edgeSet e

def withIsolatedPoints (F : TripleSystem V E) (f : V ↪ W) : TripleSystem W E where
  Inc := isolatedExtensionInc F f
  edge_ncard := by
    intro e
    change (f '' F.edgeSet e).ncard = 3
    rw [Set.ncard_image_of_injective _ f.injective, F.edgeSet_ncard]
  simple := by
    intro e d h
    apply F.simple
    ext x
    have hx := Set.ext_iff.mp h (f x)
    simpa [isolatedExtensionInc, Set.mem_image, f.injective.eq_iff, edgeSet] using hx

theorem withIsolatedPoints_inc_iff (F : TripleSystem V E) (f : V ↪ W) (x : V) (e : E) :
    (F.withIsolatedPoints f).Inc (f x) e ↔ F.Inc x e := by
  simp [withIsolatedPoints, isolatedExtensionInc, Set.mem_image, f.injective.eq_iff, edgeSet]

theorem IsObligatory.withIsolatedPoints (F : TripleSystem V E) (f : V ↪ W)
    [Fintype V] [Fintype W] (hF : F.IsObligatory) (hred : F.HasNoIsolatedPoints) :
    (F.withIsolatedPoints f).IsObligatory := by
  classical
  let H := F.withIsolatedPoints f
  let g : V → H.NonIsolatedPoint := fun x =>
    ⟨f x, by
      obtain ⟨e, he⟩ := (not_isolated_iff_exists_inc F).mp (hred x)
      exact H.not_isolated_of_inc ((withIsolatedPoints_inc_iff F f x e).mpr he)⟩
  have hg : Function.Bijective g := by
    constructor
    · intro x y h
      exact f.injective (congrArg Subtype.val h)
    · intro x
      obtain ⟨e, he⟩ := (not_isolated_iff_exists_inc H).mp x.property
      change x.val ∈ f '' F.edgeSet e at he
      obtain ⟨v, hv, hfx⟩ := he
      exact ⟨v, Subtype.ext hfx⟩
  let v := Equiv.ofBijective g hg
  have hinc (x : V) (e : E) : H.isolatedReduction.Inc (v x) e ↔ F.Inc x e :=
    withIsolatedPoints_inc_iff F f x e
  let i : H.isolatedReduction.Embedding F :=
    { vertex := v.symm.toEmbedding
      edge := id
      map_edge := by
        intro e
        ext x
        constructor
        · rintro ⟨y, hy, rfl⟩
          apply (hinc (v.symm y) e).mp
          simpa using hy
        · intro hx
          exact ⟨v x, (hinc x e).mpr hx, v.symm_apply_apply x⟩ }
  exact IsObligatory.of_isolatedReduction (hF.of_sourceEmbedding i)

end Erdos593.TripleSystem
