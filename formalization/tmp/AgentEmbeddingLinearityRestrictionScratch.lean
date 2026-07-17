import Erdos593.TripleSystem.EmbeddingEdgeRestriction

namespace Erdos593

universe u v w x

namespace TripleSystem

namespace Embedding

variable {V : Type u} {E : Type v} {W : Type w} {D : Type x}
variable {F : TripleSystem V E} {H : TripleSystem W D}

/-- If the exact host-edge restriction selected by an embedding is linear,
then its non-isolated source is linear. -/
theorem source_linear_of_imageEdgeRestriction_linear
    (f : F.Embedding H) (hF : F.HasNoIsolatedPoints)
    (hlinear : (H.edgeRestriction f.edgeImage).Linear) : F.Linear :=
  (f.imageEdgeRestrictionIso hF).linear_iff.mpr hlinear

end Embedding

end TripleSystem

end Erdos593
