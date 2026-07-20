import Erdos593.TripleSystem.ErdosRado.SourceRecursion
import Erdos593.TripleSystem.ErdosRado.SourceCanonical

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

open scoped Cardinal Ordinal

namespace TraceIteration

/-- The prefix-level specification expected of a source run at a stage. -/
def SourceRunSpecAt (c : TraceColoring) (a : TraceCarrier)
    (η : Ordinal) : Prop :=
  ∃ p : TracePrefix a,
    sourceRun c a η = p.graph ∧
    p.IsSourceCanonicalFor c ∧
    p.length ≤ η ∧
    (p.length = η ∨
      (p.length < η ∧ ¬ Nonempty (TraceCandidate c p)))

/-- A stopped witness supplies the source-run specification at every later
stage strictly above the prefix length. -/
theorem sourceRunSpecAt_of_stopped_later (c : TraceColoring)
    {a : TraceCarrier} {p : TracePrefix a}
    (hcanonical : p.IsSourceCanonicalFor c)
    (hp : ¬ Nonempty (TraceCandidate c p))
    {η θ : Ordinal} (hrun : sourceRun c a η = p.graph)
    (hηθ : η ≤ θ) (hlength : p.length < θ) :
    SourceRunSpecAt c a θ := by
  refine ⟨p, sourceRun_eq_graph_of_stopped c p hp hrun hηθ,
    hcanonical, le_of_lt hlength, Or.inr ⟨hlength, hp⟩⟩

/-- The source-run specification is preserved at successor stages. -/
theorem sourceRunSpecAt_succ (c : TraceColoring) (a : TraceCarrier)
    {η : Ordinal} (hη : SourceRunSpecAt c a η) :
    SourceRunSpecAt c a (Order.succ η) := by
  rcases hη with ⟨p, hrun, hcanonical, hlength, hstatus⟩
  by_cases hp : Nonempty (TraceCandidate c p)
  · rcases hstatus with heq | ⟨hlt, hstopped⟩
    · let q : TraceCandidate c p := TraceCandidate.least hp
      refine ⟨p.snoc q, ?_, ?_, ?_, Or.inl ?_⟩
      · rw [sourceRun_succ, hrun,
          sourceStep_graph_of_extendable c p hp]
      · exact hcanonical.snoc q (TraceCandidate.least_isLeast hp)
      · change Order.succ p.length ≤ Order.succ η
        exact Order.succ_le_succ hlength
      · change Order.succ p.length = Order.succ η
        exact congrArg Order.succ heq
    · exact (hstopped hp).elim
  · exact sourceRunSpecAt_of_stopped_later c hcanonical hp hrun
      (Order.le_succ η) (hlength.trans_lt (Order.lt_succ η))

end TraceIteration
end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
