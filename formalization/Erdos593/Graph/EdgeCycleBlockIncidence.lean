import Erdos593.Graph.EdgeCycleBlocks

namespace Erdos593
namespace SimpleGraph

set_option autoImplicit false

/-!
# Representative-independent cycle-block incidence

Cycle blocks are quotient classes of actual graph edges. A vertex is incident
to a block exactly when it is an endpoint of some edge in that class. The
definition makes no representative choice and includes bridge singleton
blocks automatically.
-/

/-- Quotient of actual graph edges by cycle-block equivalence. -/
abbrev EdgeCycleBlock {V : Type*} (G : _root_.SimpleGraph V) :=
  Quotient (edgeCycleLinkedSetoid G)

namespace EdgeCycleBlock

/-- The cycle block containing an actual graph edge. -/
def ofEdge {V : Type*} (G : _root_.SimpleGraph V) (e : G.edgeSet) :
    EdgeCycleBlock G :=
  Quotient.mk (edgeCycleLinkedSetoid G) e

/-- The literal set of graph edges belonging to a cycle block. -/
def edges {V : Type*} (G : _root_.SimpleGraph V) (B : EdgeCycleBlock G) :
    Set G.edgeSet :=
  {e | ofEdge G e = B}

/-- A vertex is incident to a block when it is an endpoint of some edge in it. -/
def Incident {V : Type*} (G : _root_.SimpleGraph V) (v : V)
    (B : EdgeCycleBlock G) : Prop :=
  ∃ e : G.edgeSet, e ∈ edges G B ∧ (e : Sym2 V) ∈ G.incidenceSet v

@[simp]
theorem ofEdge_eq_iff {V : Type*} (G : _root_.SimpleGraph V)
    {e f : G.edgeSet} :
    ofEdge G e = ofEdge G f ↔ EdgeCycleLinked G e f := by
  change Quotient.mk (edgeCycleLinkedSetoid G) e =
      Quotient.mk (edgeCycleLinkedSetoid G) f ↔ EdgeCycleLinked G e f
  exact Quotient.eq

@[simp]
theorem mem_edges_ofEdge {V : Type*} (G : _root_.SimpleGraph V)
    {e f : G.edgeSet} :
    f ∈ edges G (ofEdge G e) ↔ EdgeCycleLinked G f e := by
  change ofEdge G f = ofEdge G e ↔ EdgeCycleLinked G f e
  exact ofEdge_eq_iff G

@[simp]
theorem incident_ofEdge_iff {V : Type*} (G : _root_.SimpleGraph V)
    {v : V} {e : G.edgeSet} :
    Incident G v (ofEdge G e) ↔
      ∃ f : G.edgeSet,
        EdgeCycleLinked G f e ∧ (f : Sym2 V) ∈ G.incidenceSet v := by
  constructor
  · rintro ⟨f, hfB, hfv⟩
    exact ⟨f, (mem_edges_ofEdge G).1 hfB, hfv⟩
  · rintro ⟨f, hfe, hfv⟩
    exact ⟨f, (mem_edges_ofEdge G).2 hfe, hfv⟩

theorem incident_iff_exists_endpoint {V : Type*} (G : _root_.SimpleGraph V)
    {v : V} {B : EdgeCycleBlock G} :
    Incident G v B ↔
      ∃ e : G.edgeSet, e ∈ edges G B ∧ v ∈ (e : Sym2 V) := by
  constructor
  · rintro ⟨e, heB, hev⟩
    exact ⟨e, heB,
      (_root_.SimpleGraph.edge_mem_incidenceSet_iff
        (G := G) (a := v) (e := e)).1 hev⟩
  · rintro ⟨e, heB, hve⟩
    exact ⟨e, heB,
      (_root_.SimpleGraph.edge_mem_incidenceSet_iff
        (G := G) (a := v) (e := e)).2 hve⟩

theorem exists_rep {V : Type*} (G : _root_.SimpleGraph V)
    (B : EdgeCycleBlock G) : ∃ e : G.edgeSet, ofEdge G e = B := by
  refine Quotient.inductionOn B ?_
  intro e
  exact ⟨e, rfl⟩

theorem edges_nonempty {V : Type*} (G : _root_.SimpleGraph V)
    (B : EdgeCycleBlock G) : (edges G B).Nonempty := by
  obtain ⟨e, rfl⟩ := exists_rep G B
  exact ⟨e, rfl⟩

theorem incident_of_mem_endpoint {V : Type*} (G : _root_.SimpleGraph V)
    {B : EdgeCycleBlock G} {e : G.edgeSet} (heB : e ∈ edges G B)
    {v : V} (hve : v ∈ (e : Sym2 V)) : Incident G v B := by
  refine ⟨e, heB, ?_⟩
  exact (_root_.SimpleGraph.edge_mem_incidenceSet_iff
    (G := G) (a := v) (e := e)).2 hve

theorem eq_of_common_edge {V : Type*} (G : _root_.SimpleGraph V)
    {B C : EdgeCycleBlock G} {e : G.edgeSet}
    (heB : e ∈ edges G B) (heC : e ∈ edges G C) : B = C := by
  change ofEdge G e = B at heB
  change ofEdge G e = C at heC
  exact heB.symm.trans heC

/-- The vertex support of a cycle block. -/
def vertices {V : Type*} (G : _root_.SimpleGraph V) (B : EdgeCycleBlock G) :
    Set V :=
  {v | Incident G v B}

@[simp]
theorem mem_vertices {V : Type*} (G : _root_.SimpleGraph V)
    {B : EdgeCycleBlock G} {v : V} :
    v ∈ vertices G B ↔ Incident G v B :=
  Iff.rfl

end EdgeCycleBlock

end SimpleGraph
end Erdos593
