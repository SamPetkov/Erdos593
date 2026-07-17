import Erdos593.TripleSystem.ErdosRado.TraceExtension

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

open scoped Cardinal Ordinal

namespace TracePrefix

noncomputable def snocLast {α : TraceCarrier} (p : TracePrefix α) :
    (Order.succ p.length).ToType :=
  Ordinal.ToType.mk ⟨p.length,
    Set.mem_Iio.mpr (Order.lt_succ_iff.mpr (le_refl _))⟩

theorem snocLast_toOrd {α : TraceCarrier} (p : TracePrefix α) :
    ((p.snocLast).toOrd : Ordinal) = p.length := by
  simp [TracePrefix.snocLast]

theorem snoc_node_last {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    (p.snoc q).node p.snocLast = q.value := by
  apply TracePrefix.snoc_node_of_not_lt
  simp [TracePrefix.snocLast_toOrd]

end TracePrefix

namespace TraceCandidate

theorem snoc_value_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) : q.value < r.value := by
  have h := r.above_prefix p.snocLast
  simpa [TracePrefix.snoc_node_last] using h

theorem agrees_snoc_last {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) :
    c (tracePair q.value r.value (ne_of_lt (snoc_value_lt p q r))) =
      c (tracePair q.value α (ne_of_lt q.lt_anchor)) := by
  have h := r.agrees p.snocLast
  simpa [TracePrefix.snoc_node_last] using h

end TraceCandidate

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
