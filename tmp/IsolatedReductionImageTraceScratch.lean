import Erdos593.TripleSystem.EmbeddingEdgeRestriction
import Erdos593.TripleSystem.ObligatoryIsolatedReduction
import Erdos593.TripleSystem.SequenceLift

namespace Erdos593

open scoped Cardinal Ordinal

universe u v

namespace TripleSystem

namespace Embedding

variable {V : Type u} {E : Type v}
variable {G : _root_.SimpleGraph V}
variable {F : TripleSystem V E}

/-- Removing isolated source vertices is enough to obtain an exact finite
linear host-edge trace from any finite linear embedding into a sequence lift. -/
theorem finiteLinear_isolatedReduction_imageTrace [Fintype E]
    (f : F.Embedding (SequenceLift.system G)) (hlinear : F.Linear) :
    let f' := (isolatedReductionEmbedding F).trans f
    f'.edgeImage.Finite ∧
      ((SequenceLift.system G).edgeRestriction f'.edgeImage).Linear ∧
      Nonempty (Iso F.isolatedReduction
        ((SequenceLift.system G).edgeRestriction f'.edgeImage)) := by
  dsimp
  have hlinear' : F.isolatedReduction.Linear := by
    intro e e' x y hee' hxe hxe' hye hye'
    apply Subtype.ext
    exact hlinear hee' hxe hxe' hye hye'
  refine ⟨Set.finite_range _, ?_, ?_⟩
  · exact ((isolatedReductionEmbedding F).trans f).imageEdgeRestriction_linear
      F.isolatedReduction_hasNoIsolatedPoints hlinear'
  · exact ⟨((isolatedReductionEmbedding F).trans f).imageEdgeRestrictionIso
      F.isolatedReduction_hasNoIsolatedPoints⟩

end Embedding
end TripleSystem
end Erdos593
