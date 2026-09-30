import Erdos593.Graph.EdgeCycleSplice

namespace Erdos593
namespace SimpleGraph

set_option autoImplicit false

/-!
# Publication refinement: cycle blocks of graph edges

The relation is the reflexive closure of “the two actual graph edges occur on
one common simple cycle”. Thus every bridge survives as a singleton class,
while the welded cycle-splicing kernel supplies the only nontrivial
transitivity branch.
-/

/-- Two actual graph edges occur on one common simple cycle. -/
def EdgesOnCommonCycle {V : Type*} (G : _root_.SimpleGraph V)
    (e f : G.edgeSet) : Prop :=
  ∃ v : V, ∃ c : G.Walk v v,
    c.IsCycle ∧ e.1 ∈ c.edges ∧ f.1 ∈ c.edges

/-- Reflexive closure of common-cycle containment on all actual graph edges. -/
def EdgeCycleLinked {V : Type*} (G : _root_.SimpleGraph V)
    (e f : G.edgeSet) : Prop :=
  e = f ∨ EdgesOnCommonCycle G e f

theorem edgesOnCommonCycle_symm {V : Type*} (G : _root_.SimpleGraph V)
    {e f : G.edgeSet} (h : EdgesOnCommonCycle G e f) :
    EdgesOnCommonCycle G f e := by
  rcases h with ⟨v, c, hc, he, hf⟩
  exact ⟨v, c, hc, hf, he⟩

theorem edgesOnCommonCycle_trans {V : Type*} (G : _root_.SimpleGraph V)
    {e f g : G.edgeSet} (hef : EdgesOnCommonCycle G e f)
    (hfg : EdgesOnCommonCycle G f g) : EdgesOnCommonCycle G e g := by
  rcases hef with ⟨v₁, c₁, hc₁, he, hf₁⟩
  rcases hfg with ⟨v₂, c₂, hc₂, hf₂, hg⟩
  exact edgeCycle_splice G hc₁ hc₂ he hf₁ hf₂ hg

theorem edgeCycleLinked_refl {V : Type*} (G : _root_.SimpleGraph V) :
    ∀ e : G.edgeSet, EdgeCycleLinked G e e := by
  intro e
  exact Or.inl rfl

theorem edgeCycleLinked_symm {V : Type*} (G : _root_.SimpleGraph V) :
    ∀ ⦃e f : G.edgeSet⦄, EdgeCycleLinked G e f → EdgeCycleLinked G f e := by
  intro e f h
  rcases h with hEq | hCycle
  · exact Or.inl hEq.symm
  · exact Or.inr (edgesOnCommonCycle_symm G hCycle)

theorem edgeCycleLinked_trans {V : Type*} (G : _root_.SimpleGraph V) :
    ∀ ⦃e f g : G.edgeSet⦄,
      EdgeCycleLinked G e f → EdgeCycleLinked G f g → EdgeCycleLinked G e g := by
  intro e f g hef hfg
  rcases hef with hEq | hef
  · subst f
    exact hfg
  rcases hfg with hEq | hfg
  · subst g
    exact Or.inr hef
  · exact Or.inr (edgesOnCommonCycle_trans G hef hfg)

/-- Equality or common-simple-cycle containment is an equivalence relation on
all actual graph edges. -/
theorem edgeCycleLinked_equivalence {V : Type*} (G : _root_.SimpleGraph V) :
    Equivalence (EdgeCycleLinked G) := by
  refine ⟨?_, ?_, ?_⟩
  · intro e
    exact edgeCycleLinked_refl G e
  · intro e f h
    exact edgeCycleLinked_symm G h
  · intro e f g hef hfg
    exact edgeCycleLinked_trans G hef hfg

/-- Setoid of graph edges belonging to the same cycle block. -/
def edgeCycleLinkedSetoid {V : Type*} (G : _root_.SimpleGraph V) :
    Setoid G.edgeSet where
  r := EdgeCycleLinked G
  iseqv := edgeCycleLinked_equivalence G

end SimpleGraph
end Erdos593
