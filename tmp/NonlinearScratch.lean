import Erdos593.TripleSystem.Obligatory

namespace Erdos593

open scoped Cardinal

universe u v

namespace TripleSystem

namespace Embedding

variable {V : Type u} {E : Type v} {W : Type u} {D : Type v}
variable {F : TripleSystem V E} {H : TripleSystem W D}

theorem linear_scratch (f : F.Embedding H) (hH : H.Linear) : F.Linear := by
  intro e e' x y hee hxe hxe' hye hye'
  apply f.vertex.injective
  apply hH (fun h => hee (f.edge_injective h))
  · exact (Set.ext_iff.mp (f.map_edge e) (f.vertex x)).mp ⟨x, hxe, rfl⟩
  · exact (Set.ext_iff.mp (f.map_edge e') (f.vertex x)).mp ⟨x, hxe', rfl⟩
  · exact (Set.ext_iff.mp (f.map_edge e) (f.vertex y)).mp ⟨y, hye, rfl⟩
  · exact (Set.ext_iff.mp (f.map_edge e') (f.vertex y)).mp ⟨y, hye', rfl⟩

end Embedding

variable {V : Type u} {E : Type v} {W : Type u} {D : Type v}
variable {F : TripleSystem V E} {H : TripleSystem W D}

theorem not_isObligatory_of_not_linear_scratch [DecidableEq W]
    (hHchrom : ℵ₀ < H.chromaticCardinal)
    (hHlinear : H.Linear)
    (hFnonlinear : ¬ F.Linear) :
    ¬ F.IsObligatory := by
  intro hF
  rcases hF W D H hHchrom with ⟨f⟩
  exact hFnonlinear (f.linear_scratch hHlinear)

end TripleSystem

end Erdos593
