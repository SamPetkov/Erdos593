import Mathlib.SetTheory.Cardinal.Continuum
import Erdos593.TripleSystem.CardinalPairPartition

namespace Erdos593

namespace TripleSystem
namespace TriangleHost

abbrev ErdosRadoCarrier : Type :=
  (Order.succ (Cardinal.continuum : Cardinal)).out

noncomputable instance erdosRadoCarrierDecidableEq : DecidableEq ErdosRadoCarrier :=
  Classical.decEq _

theorem mk_erdosRadoCarrier :
    Cardinal.mk ErdosRadoCarrier = Order.succ (Cardinal.continuum : Cardinal) :=
  Cardinal.mk_out _

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
