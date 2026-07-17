import Mathlib.SetTheory.Cardinal.Continuum
import Erdos593.TripleSystem.CardinalPairPartition

namespace Erdos593

namespace TripleSystem
namespace TriangleHost

noncomputable section

#check Cardinal.continuum
#check Order.succ
#check Cardinal.mk_out

abbrev ErdosRadoCarrier : Type :=
  (Order.succ (Cardinal.continuum : Cardinal)).out

local instance : DecidableEq ErdosRadoCarrier := Classical.decEq _

#check ErdosRadoCarrier
#check (inferInstance : DecidableEq ErdosRadoCarrier)
#check Cardinal.mk_out (Order.succ (Cardinal.continuum : Cardinal))

def ErdosRadoHomogeneousPairSet : Prop :=
  ∀ c : Pair ErdosRadoCarrier → ℕ,
    ∃ H : Set ErdosRadoCarrier,
      H.Infinite ∧ PairHomogeneous c H

theorem pairRamseyTriangle_erdosRadoCarrier_of
    (h : ErdosRadoHomogeneousPairSet) :
    PairRamseyTriangle ErdosRadoCarrier :=
  pairRamseyTriangle_of_infinite_pair_homogeneous h

end TriangleHost
end TripleSystem
end Erdos593
