import Erdos593.TripleSystem.EmbeddingEdgeRestriction
import Erdos593.TripleSystem.SequenceLift

namespace Erdos593

open scoped Cardinal Ordinal

universe u v

namespace TripleSystem

namespace Embedding

variable {V : Type u} {E : Type v}
variable {G : _root_.SimpleGraph V}
variable {F : TripleSystem V E}

/-- A finite linear source embedding into a sequence lift determines a finite
linear exact host-edge trace, isomorphic to the source. -/
theorem finiteLinear_imageTrace [Fintype E]
    (f : F.Embedding (SequenceLift.system G))
    (hF : F.HasNoIsolatedPoints) (hlinear : F.Linear) :
    f.edgeImage.Finite ∧
      ((SequenceLift.system G).edgeRestriction f.edgeImage).Linear ∧
      Nonempty (Iso F ((SequenceLift.system G).edgeRestriction f.edgeImage)) := by
  refine ⟨?_, f.imageEdgeRestriction_linear hF hlinear,
    ⟨f.imageEdgeRestrictionIso hF⟩⟩
  exact Set.finite_range f.edge

end Embedding

end TripleSystem

end Erdos593
