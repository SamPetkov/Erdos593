import Erdos593.TripleSystem.ErdosRado.PairTransport
import Erdos593.TripleSystem.ErdosRadoCarrier

/-!
# Canonical ordinal carrier for the Erdos--Rado trace

This module provides only the carrier reindexing needed by a later trace
construction. It proves no partition relation and selects no trace nodes.
-/

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

/-- The initial ordinal whose cardinality is the successor of the continuum. -/
noncomputable abbrev TraceCarrier : Type :=
  (Order.succ (Cardinal.continuum : Cardinal)).ord.ToType

/-- The trace carrier has the desired successor-of-continuum cardinality. -/
theorem mk_traceCarrier :
    Cardinal.mk TraceCarrier = Order.succ (Cardinal.continuum : Cardinal) := by
  exact Cardinal.mk_ord_toType _

/-- Reindex the existing carrier onto the canonical ordinal carrier.
Choice is used only to obtain an equivalence from their proven equal cardinalities. -/
noncomputable def erdosRadoCarrierEquivTraceCarrier :
    Equiv ErdosRadoCarrier TraceCarrier :=
  Classical.choice <|
    Cardinal.eq.mp (mk_erdosRadoCarrier.trans mk_traceCarrier.symm)

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
