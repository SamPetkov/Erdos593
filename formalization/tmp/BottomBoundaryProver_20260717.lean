import Erdos593.TripleSystem.ErdosRado.TraceExtension

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

namespace TraceCandidate

/-- A candidate cannot lie strictly below the bottom endpoint. -/
theorem scratch_not_nonempty_empty_bot (c : TraceColoring) :
    ¬ Nonempty (TraceCandidate c (TracePrefix.empty (⊥ : TraceCarrier))) := by
  rintro ⟨q⟩
  exact (not_lt_of_ge (show (⊥ : TraceCarrier) ≤ q.value from bot_le) q.lt_anchor).elim

/-- The empty prefix below the bottom endpoint has no candidate. -/
theorem scratch_isEmpty_empty_bot (c : TraceColoring) :
    IsEmpty (TraceCandidate c (TracePrefix.empty (⊥ : TraceCarrier))) :=
  ⟨fun q =>
    (not_lt_of_ge (show (⊥ : TraceCarrier) ≤ q.value from bot_le) q.lt_anchor).elim⟩

/-- The empty-prefix candidate problem is solvable exactly above the bottom endpoint. -/
theorem scratch_nonempty_empty_iff_bot_lt (c : TraceColoring) {a : TraceCarrier} :
    Nonempty (TraceCandidate c (TracePrefix.empty a)) ↔ (⊥ : TraceCarrier) < a := by
  constructor
  · rintro ⟨q⟩
    exact lt_of_le_of_lt (show (⊥ : TraceCarrier) ≤ q.value from bot_le) q.lt_anchor
  · exact nonempty_empty_of_bot_lt c

#print axioms scratch_not_nonempty_empty_bot
#print axioms scratch_isEmpty_empty_bot
#print axioms scratch_nonempty_empty_iff_bot_lt

end TraceCandidate

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
