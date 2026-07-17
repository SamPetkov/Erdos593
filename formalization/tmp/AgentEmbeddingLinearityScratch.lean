import Erdos593.TripleSystem.Obligatory

namespace Erdos593

open scoped Cardinal

universe u v w x

namespace TripleSystem

namespace Embedding

variable {V : Type u} {E : Type v} {W : Type w} {D : Type x}
variable {F : TripleSystem V E} {H : TripleSystem W D}

/-- A non-induced embedding into a linear target has a linear source. -/
theorem source_linear_of_target_linear
    (f : F.Embedding H) (hlinear : H.Linear) : F.Linear := by
  intro e d x y hed hxe hxd hye hyd
  apply f.vertex.injective
  apply hlinear (f.edge_injective.ne hed)
  · have hset := Set.ext_iff.mp (f.map_edge e) (f.vertex x)
    exact hset.mp ⟨x, hxe, rfl⟩
  · have hset := Set.ext_iff.mp (f.map_edge d) (f.vertex x)
    exact hset.mp ⟨x, hxd, rfl⟩
  · have hset := Set.ext_iff.mp (f.map_edge e) (f.vertex y)
    exact hset.mp ⟨y, hye, rfl⟩
  · have hset := Set.ext_iff.mp (f.map_edge d) (f.vertex y)
    exact hset.mp ⟨y, hyd, rfl⟩

end Embedding

variable {V : Type u} {E : Type v} {W : Type u} {D : Type v}
variable {F : TripleSystem V E} {H : TripleSystem W D}

/-- A non-linear finite source is not obligatory whenever a linear
uncountably chromatic host is available in the ambient universes. -/
theorem not_isObligatory_of_not_linear_of_linear_highChromatic
    [DecidableEq W]
    (hnotlinear : ¬ F.Linear) (hHlinear : H.Linear)
    (hchi : Cardinal.aleph0 < H.chromaticCardinal) : ¬ F.IsObligatory := by
  intro hF
  rcases hF W D H hchi with ⟨f⟩
  exact hnotlinear (f.source_linear_of_target_linear hHlinear)

end TripleSystem

end Erdos593
