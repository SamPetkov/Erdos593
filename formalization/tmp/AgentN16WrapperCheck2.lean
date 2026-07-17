import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceAcyclic
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceForestOrderEndpoints
import Erdos593.TripleSystem.FiniteLiftGeneratedConstructible

namespace Erdos593

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}

namespace AgentN16WrapperCheck2

theorem finiteLiftGenerated_of_linear
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear) :
    TripleSystem.FiniteLiftGenerated G ((system G).edgeRestriction S) := by
  exact edgeRestriction_finiteLiftGenerated_of_linear_of_incidenceAcyclic
    hS hlinear
    (baseFiberSupportIncidenceGraph_isAcyclic_of_finite_linear hS hlinear)

theorem constructible_of_linear_of_hostColorable
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2) :
    TripleSystem.Constructible ((system G).edgeRestriction S) := by
  exact TripleSystem.FiniteLiftGenerated.constructible_of_hostColorable hG
    (finiteLiftGenerated_of_linear hS hlinear)

theorem isObligatory_of_linear_of_hostColorable
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2) :
    ((system G).edgeRestriction S).IsObligatory := by
  exact TripleSystem.FiniteLiftGenerated.isObligatory_of_hostColorable hG
    (finiteLiftGenerated_of_linear hS hlinear)

end AgentN16WrapperCheck2

end SequenceLift

end Erdos593
