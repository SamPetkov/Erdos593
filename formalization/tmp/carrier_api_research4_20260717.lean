import Mathlib.SetTheory.Cardinal.Continuum
import Erdos593.TripleSystem.CardinalPairPartition

namespace Erdos593

namespace TripleSystem
namespace TriangleHost

noncomputable section

abbrev ErdosRadoCarrier : Type :=
  (Order.succ (Cardinal.continuum : Cardinal)).out

instance erdosRadoCarrierDecidableEq : DecidableEq ErdosRadoCarrier :=
  Classical.decEq _

def ErdosRadoHomogeneousPairSet : Prop :=
  ∀ c : Pair ErdosRadoCarrier → ℕ,
    ∃ H : Set ErdosRadoCarrier,
      H.Infinite ∧ PairHomogeneous c H

theorem pairRamseyTriangle_erdosRadoCarrier_of
    (h : ErdosRadoHomogeneousPairSet) :
    PairRamseyTriangle ErdosRadoCarrier :=
  pairRamseyTriangle_of_infinite_pair_homogeneous h

theorem no_natProperColoring_erdosRadoCarrier_of
    (h : ErdosRadoHomogeneousPairSet) :
    ¬ ∃ c : Pair ErdosRadoCarrier → ℕ, (system ErdosRadoCarrier).IsProperColoring c :=
  no_natProperColoring_of_pairRamseyTriangle ErdosRadoCarrier
    (pairRamseyTriangle_erdosRadoCarrier_of h)

end
end TriangleHost
end TripleSystem
end Erdos593
