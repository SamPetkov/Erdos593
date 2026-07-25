import Mathlib.Data.Set.Card

/-!
# Finite-uniformity incidence systems

A uniformity-parametric analogue of the existing `TripleSystem` representation.
The incidence relation remains edge-indexed so that Levi graphs use the
transparent sum type `V ⊕ E`.
-/

namespace Erdos593

universe u v

/-- A simple `r`-uniform hypergraph with vertex type `V` and edge-index type
`E`.  The intended structural applications have `2 ≤ r`. -/
structure UniformSystem (r : ℕ) (V : Type u) (E : Type v) where
  /-- Vertex-edge incidence. -/
  Inc : V → E → Prop
  /-- Every indexed edge contains exactly `r` vertices. -/
  edge_ncard : ∀ e, Set.ncard {x | Inc x e} = r
  /-- Distinct edge indices determine distinct vertex sets. -/
  simple : Function.Injective (fun e => {x | Inc x e})

namespace UniformSystem

variable {r : ℕ} {V : Type u} {E : Type v} (F : UniformSystem r V E)

/-- A point is isolated when it belongs to no hyperedge. -/
def IsIsolated (x : V) : Prop :=
  ∀ e, ¬F.Inc x e

/-- Any two distinct hyperedges of a linear system share at most one point. -/
def Linear : Prop :=
  ∀ ⦃e f : E⦄ ⦃x y : V⦄, e ≠ f →
    F.Inc x e → F.Inc x f → F.Inc y e → F.Inc y f → x = y

/-- An indexed edge, represented extensionally by its set of incident points. -/
def edgeSet (e : E) : Set V :=
  {x | F.Inc x e}

@[simp]
theorem mem_edgeSet {x : V} {e : E} : x ∈ F.edgeSet e ↔ F.Inc x e :=
  Iff.rfl

theorem edgeSet_ncard (e : E) : (F.edgeSet e).ncard = r :=
  F.edge_ncard e

theorem edgeSet_injective : Function.Injective F.edgeSet :=
  F.simple

/-- When the uniformity is nonzero, every indexed edge is finite. -/
theorem edgeSet_finite (hr : r ≠ 0) (e : E) : (F.edgeSet e).Finite := by
  apply Set.finite_of_ncard_ne_zero
  rw [F.edgeSet_ncard e]
  exact hr

/-- Linearity is equivalent to every pair of distinct edge sets having
subsingleton intersection. -/
theorem linear_iff_pairwise_inter_subsingleton :
    F.Linear ↔ ∀ ⦃e f : E⦄, e ≠ f →
      (F.edgeSet e ∩ F.edgeSet f).Subsingleton := by
  constructor
  · intro h e f hef x hx y hy
    exact h hef hx.1 hx.2 hy.1 hy.2
  · intro h e f x y hef hxe hxf hye hyf
    exact h hef ⟨hxe, hxf⟩ ⟨hye, hyf⟩

end UniformSystem

end Erdos593
