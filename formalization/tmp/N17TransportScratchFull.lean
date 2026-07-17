import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceAcyclicEndpoints
import Erdos593.TripleSystem.FiniteLinearImageTrace

namespace Erdos593

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}
variable {X I : Type u} {F : TripleSystem X I}

theorem n17_finiteLiftGenerated_isolatedReduction_of_embedding
    [Fintype I]
    (f : F.Embedding (system G)) (hlinear : F.Linear) :
    TripleSystem.FiniteLiftGenerated G F.isolatedReduction := by
  have htrace :=
    TripleSystem.Embedding.finiteLinear_isolatedReduction_imageTrace f hlinear
  dsimp only at htrace
  rcases htrace with ?hfinite, hlinear', ?hIso??
  exact TripleSystem.FiniteLiftGenerated.ofIso
    (edgeRestriction_finiteLiftGenerated_of_linear hfinite hlinear') hIso.symm

theorem n17_constructible_isolatedReduction_of_embedding
    [Fintype I]
    (f : F.Embedding (system G)) (hlinear : F.Linear)
    (hG : G.Colorable 2) :
    TripleSystem.Constructible F.isolatedReduction := by
  exact TripleSystem.FiniteLiftGenerated.constructible_of_hostColorable hG
    (n17_finiteLiftGenerated_isolatedReduction_of_embedding f hlinear)

theorem n17_isObligatory_isolatedReduction_of_embedding
    [Fintype I]
    (f : F.Embedding (system G)) (hlinear : F.Linear)
    (hG : G.Colorable 2) :
    F.isolatedReduction.IsObligatory := by
  exact TripleSystem.FiniteLiftGenerated.isObligatory_of_hostColorable hG
    (n17_finiteLiftGenerated_isolatedReduction_of_embedding f hlinear)

theorem n17_isObligatory_of_embedding
    [Fintype X] [Fintype I]
    (f : F.Embedding (system G)) (hlinear : F.Linear)
    (hG : G.Colorable 2) :
    F.IsObligatory := by
  exact TripleSystem.IsObligatory.of_isolatedReduction
    (n17_isObligatory_isolatedReduction_of_embedding f hlinear hG)

end SequenceLift

end Erdos593
