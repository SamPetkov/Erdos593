import Erdos593.TripleSystem.ErdosRado.Theorem
import Erdos593.TripleSystem.TriangleHostRamseyTransport

namespace Erdos593.TripleSystem

universe u v

/-- Every non-linear triple system fails obligatoriness. -/
theorem not_isObligatory_of_not_linear
    {V : Type u} {E : Type v}
    (F : TripleSystem V E) (hnotlinear : ¬ F.Linear) :
    ¬ F.IsObligatory :=
  TriangleHostTransport.not_isObligatory_of_not_linear_of_exactTriangleHost
    F hnotlinear TriangleHost.ErdosRadoCarrier
      TriangleHost.ErdosRado.pairRamseyTriangle_erdosRadoCarrier

end Erdos593.TripleSystem
