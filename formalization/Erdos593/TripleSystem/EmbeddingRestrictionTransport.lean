import Erdos593.TripleSystem.CanonicalAtomTransport
import Erdos593.TripleSystem.EmbeddingEdgeRestriction

/-!
# Supported edge restrictions along embeddings

An embedding identifies every supported source edge restriction with the
exact selected host edge restriction, including its full incident support.
-/

namespace Erdos593.TripleSystem.Embedding

universe u v w x

theorem edgeRestriction_image_isomorphic
    {V : Type u} {E : Type v} {W : Type w} {D : Type x}
    {F : TripleSystem V E} {H : TripleSystem W D}
    (f : F.Embedding H) (S : Set E) :
    Isomorphic (F.edgeRestriction S)
      (H.edgeRestriction (f.edge '' S)) :=
by
  let g : (F.edgeRestriction S).Embedding H :=
    (F.edgeRestrictionEmbedding S).trans f
  have hedge : g.edgeImage = f.edge '' S := by
    ext d
    constructor
    · rintro ⟨e, rfl⟩
      exact ⟨e.1, e.2, rfl⟩
    · rintro ⟨e, he, rfl⟩
      exact ⟨⟨e, he⟩, rfl⟩
  exact (congrArg (fun T : Set D =>
    Isomorphic (F.edgeRestriction S) (H.edgeRestriction T)) hedge).mp
      ⟨g.imageEdgeRestrictionIso (F.edgeRestriction_hasNoIsolatedPoints S)⟩

theorem edgeSupportSet_image
    {V : Type u} {E : Type v} {W : Type w} {D : Type x}
    {F : TripleSystem V E} {H : TripleSystem W D}
    (f : F.Embedding H) (S : Set E) :
    H.edgeSupportSet (f.edge '' S) =
      f.vertex '' F.edgeSupportSet S :=
by
  ext y
  constructor
  · rintro ⟨d, ⟨e, he, rfl⟩, hye⟩
    rcases (Set.ext_iff.mp (f.map_edge e) y).mpr hye with ⟨x, hxe, rfl⟩
    exact ⟨x, ⟨e, he, hxe⟩, rfl⟩
  · rintro ⟨x, ⟨e, he, hxe⟩, rfl⟩
    refine ⟨f.edge e, ⟨e, he, rfl⟩, ?_⟩
    exact (Set.ext_iff.mp (f.map_edge e) (f.vertex x)).mp ⟨x, hxe, rfl⟩

end Erdos593.TripleSystem.Embedding
