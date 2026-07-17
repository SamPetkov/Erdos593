import Erdos593.TripleSystem.ErdosRado.TraceExtension

namespace Erdos593.TripleSystem.TriangleHost.ErdosRado

open scoped Cardinal Ordinal

namespace Scout
namespace TracePrefix

/-- The canonical embedding of old prefix indices into a `snoc` prefix. -/
noncomputable def snocLift {alpha : TraceCarrier} (p : TracePrefix alpha)
    (xi : p.length.ToType) : (Order.succ p.length).ToType :=
  Ordinal.ToType.mk (show (xi.toOrd : Ordinal) < Order.succ p.length from
    Order.lt_succ_iff.mpr (le_of_lt xi.toOrd.2))

theorem snocLift_toOrd {alpha : TraceCarrier} (p : TracePrefix alpha)
    (xi : p.length.ToType) : ((snocLift p xi).toOrd : Ordinal) = xi.toOrd := by
  simp [snocLift]

theorem snoc_node_lift {c : TraceColoring} {alpha : TraceCarrier}
    (p : TracePrefix alpha) (q : TraceCandidate c p) (xi : p.length.ToType) :
    (p.snoc q).node (snocLift p xi) = p.node xi := by
  simp [snocLift, TracePrefix.snoc, TracePrefix.snocNode]
  intro hle
  exact (not_lt_of_ge hle xi.toOrd.2).elim

theorem snocLift_lt_last {alpha : TraceCarrier} (p : TracePrefix alpha)
    (xi : p.length.ToType) : snocLift p xi < p.snocLast := by
  apply (Ordinal.ToType.mk (o := Order.succ p.length)).lt_iff_lt.mpr
  simpa [snocLift, TracePrefix.snocLast_toOrd] using xi.toOrd.2

theorem snoc_index_lt_or_eq_last {alpha : TraceCarrier} (p : TracePrefix alpha)
    (xi : (Order.succ p.length).ToType) :
    (xi.toOrd : Ordinal) < p.length \/ xi = p.snocLast := by
  by_cases h : (xi.toOrd : Ordinal) < p.length
  · exact Or.inl h
  · right
    apply (Ordinal.ToType.mk (o := Order.succ p.length)).symm.injective
    apply le_antisymm
    · exact Order.lt_succ_iff.mp xi.toOrd.2
    · exact le_of_not_gt h

theorem range_snoc_node {c : TraceColoring} {alpha : TraceCarrier}
    (p : TracePrefix alpha) (q : TraceCandidate c p) :
    Set.range (p.snoc q).node = Set.range p.node ∪ {q.value} := by
  ext x
  constructor
  · rintro ⟨xi, rfl⟩
    rcases snoc_index_lt_or_eq_last p xi with hxi | rfl
    · left
      refine ⟨Ordinal.ToType.mk hxi, ?_⟩
      exact (TracePrefix.snoc_node_of_lt p q xi hxi).symm
    · right
      simpa only [Set.mem_singleton_iff] using TracePrefix.snoc_node_last p q
  · intro hx
    rcases hx with hx | hx
    · rcases hx with ⟨xi, rfl⟩
      exact ⟨snocLift p xi, snoc_node_lift p q xi⟩
    · rw [Set.mem_singleton_iff] at hx
      subst x
      exact ⟨p.snocLast, TracePrefix.snoc_node_last p q⟩

end TracePrefix
end Scout
end Erdos593.TripleSystem.TriangleHost.ErdosRado
