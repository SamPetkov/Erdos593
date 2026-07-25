import Erdos593.UniformSystem.Basic
import Mathlib.Combinatorics.SimpleGraph.Acyclic

/-!
# Levi graphs of uniform systems
-/

namespace Erdos593

universe u v

namespace UniformSystem

variable {r : ℕ} {V : Type u} {E : Type v} (F : UniformSystem r V E)

/-- Directed point-to-edge incidence before `SimpleGraph.fromRel` symmetrizes
it. -/
def incidenceRel : V ⊕ E → V ⊕ E → Prop
  | .inl x, .inr e => F.Inc x e
  | _, _ => False

/-- The bipartite point-edge incidence graph. -/
def levi : _root_.SimpleGraph (V ⊕ E) :=
  _root_.SimpleGraph.fromRel F.incidenceRel

@[simp]
theorem levi_adj_point_edge {x : V} {e : E} :
    F.levi.Adj (.inl x) (.inr e) ↔ F.Inc x e := by
  simp [levi, incidenceRel]

@[simp]
theorem levi_adj_edge_point {x : V} {e : E} :
    F.levi.Adj (.inr e) (.inl x) ↔ F.Inc x e := by
  simp [levi, incidenceRel]

@[simp]
theorem not_levi_adj_point_point {x y : V} :
    ¬F.levi.Adj (.inl x) (.inl y) := by
  simp [levi, incidenceRel]

@[simp]
theorem not_levi_adj_edge_edge {e f : E} :
    ¬F.levi.Adj (.inr e) (.inr f) := by
  simp [levi, incidenceRel]

/-- A Levi hyperedge-node has exactly the `r` point-neighbours incident with
its corresponding hyperedge. -/
theorem levi_edge_neighbor_ncard (e : E) :
    (F.levi.neighborSet (.inr e)).ncard = r := by
  rw [show F.levi.neighborSet (.inr e) =
    Set.image (fun x : V => Sum.inl x) {x : V | F.Inc x e} by
      ext x
      cases x <;> simp +decide]
  rw [Set.ncard_image_of_injective _ Sum.inl_injective]
  exact F.edgeSet_ncard e

/-- In a finite uniform system, the Levi degree of a hyperedge-node is the
uniformity. -/
theorem levi_edge_degree [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E] [DecidableRel F.levi.Adj] (e : E) :
    F.levi.degree (.inr e) = r := by
  rw [(_root_.SimpleGraph.card_neighborFinset_eq_degree
        F.levi (.inr e)).symm,
    _root_.SimpleGraph.neighborFinset_def,
    (Set.ncard_eq_toFinset_card'
      (F.levi.neighborSet (.inr e))).symm]
  exact F.levi_edge_neighbor_ncard e

end UniformSystem

end Erdos593
