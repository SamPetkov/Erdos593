import Erdos593.TripleSystem.SequenceLiftEmbeddedSourceEndpoints
import Erdos593.TripleSystem.ConstructiveForward

namespace Erdos593

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}
variable {X I : Type u} {F : TripleSystem X I}

/-- A finite linear source embedded in a two-colourable sequence lift has an
intrinsic isolated reduction. -/
theorem isolatedReduction_intrinsic_of_linear_of_embedding
    [Fintype I]
    (f : F.Embedding (system G)) (hlinear : F.Linear)
    (hG : G.Colorable 2) :
    F.isolatedReduction.Intrinsic := by
  exact TripleSystem.Constructible.intrinsic
    (isolatedReduction_constructible_of_linear_of_embedding f hlinear hG)

end SequenceLift
end Erdos593
