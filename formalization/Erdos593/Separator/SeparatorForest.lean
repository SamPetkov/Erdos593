import Mathlib.Combinatorics.SimpleGraph.Acyclic
import Erdos593.Separator.SeparatorNoReturn

/-!
# The ordinary Mathlib forest gives the separator certificate

The graph hypothesis is Mathlib's unchanged `SimpleGraph.IsAcyclic`.
The proof uses its existing bridge characterization. No certificate,
NoReturn condition or local/global conclusion is added as a hypothesis.
This file is candidate source; it has not passed Lean in this environment.
-/

namespace E593Separator

universe u v w
variable {A : Type u} {P : Type v}

/-- The ordinary bipartite graph of an incidence relation. -/
def incidenceGraph (Inc : A → P → Prop) : SimpleGraph (A ⊕ P) :=
  SimpleGraph.fromRel fun x y =>
    match x, y with
    | .inl a, .inr p => Inc a p
    | _, _ => False

/-- Deleting one incidence at p leaves all incidences at q != p intact. -/
theorem away_incidence_survives (Inc : A → P → Prop)
    (a : A) (p q : P) (hqp : q ≠ p) {x : A} (hx : Inc x q) :
    ((incidenceGraph Inc).deleteEdges {s(Sum.inl a, Sum.inr p)}).Adj
      (Sum.inl x) (Sum.inr q) := by
  simpa [SimpleGraph.deleteEdges_adj, incidenceGraph, Sym2.eq_iff,
    hqp, Ne.symm hqp] using hx

/-- Lift a path avoiding p to a graph walk avoiding any selected incidence at p. -/
theorem away_closure_reachable (Inc : A → P → Prop) (a : A) (p : P)
    {x y : A} (h : Closure (AwayStep Inc p) x y) :
    ((incidenceGraph Inc).deleteEdges {s(Sum.inl a, Sum.inr p)}).Reachable
      (Sum.inl x) (Sum.inl y) := by
  induction h with
  | refl x => exact SimpleGraph.Reachable.refl _
  | step h =>
      rcases h with ⟨q, hqp, hx, hy⟩
      exact (away_incidence_survives Inc a p q hqp hx).reachable.trans
        (away_incidence_survives Inc a p q hqp hy).symm.reachable
  | symm h ih => exact ih.symm
  | trans h1 h2 ih1 ih2 => exact ih1.trans ih2

/-- An alternate deletion path between two distinct neighbours would bypass
an edge which acyclicity says is a bridge. -/
theorem noReturn_of_isAcyclic (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic) : NoReturn Inc := by
  intro p a b ha hb hab
  by_contra hne
  have hadj : (incidenceGraph Inc).Adj (Sum.inl a) (Sum.inr p) := by
    simpa [incidenceGraph] using ha
  have hbridge := SimpleGraph.isAcyclic_iff_forall_adj_isBridge.mp hF hadj
  have hlast :
      ((incidenceGraph Inc).deleteEdges {s(Sum.inl a, Sum.inr p)}).Adj
        (Sum.inl b) (Sum.inr p) := by
    simpa [SimpleGraph.deleteEdges_adj, incidenceGraph, Sym2.eq_iff,
      hne, Ne.symm hne] using hb
  exact hbridge
    ((away_closure_reachable Inc a p hab).trans hlast.reachable)

/-- The requested certificate is constructed from an actual acyclic graph. -/
noncomputable def certificateOfForest (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic) : Certificate Inc :=
  certificateOfNoReturn Inc (noReturn_of_isAcyclic Inc hF)

/-- Refinement is a partial order on the existing partition structures. -/
instance partitionPartialOrder {B : Type w} : PartialOrder (Partition B) where
  le := Refines
  le_refl R a b h := h
  le_trans R S T hRS hST a b h := hST a b (hRS a b h)
  le_antisymm R S hRS hSR :=
    Partition.ext (funext fun a => funext fun b =>
      propext ⟨hRS a b, hSR a b⟩)

/-- An actual standard-library OrderIso, not only informal inverse maps. -/
noncomputable def forestPartitionOrderIso (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic) :
    Local Inc ≃o {R : Partition A // ConnectedPartition Inc R} where
  toFun L := ⟨extend Inc L, extend_connected Inc L⟩
  invFun R := restrict Inc R.val
  left_inv L := restrict_extend Inc (certificateOfForest Inc hF) L
  right_inv R := Subtype.ext (extend_restrict Inc R.val R.property)
  map_rel_iff' := by
    intro L M
    change Refines (extend Inc L) (extend Inc M) ↔
      ∀ p, Refines (L p) (M p)
    exact extend_refines_iff Inc (certificateOfForest Inc hF) L M

/-- Existence and uniqueness of local data for every connected global partition. -/
theorem forest_exists_unique_local (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic) (R : Partition A)
    (hR : ConnectedPartition Inc R) :
    ∃! L : Local Inc, extend Inc L = R := by
  refine ⟨restrict Inc R, extend_restrict Inc R hR, ?_⟩
  intro L hL
  apply extend_injective Inc (certificateOfForest Inc hF)
  exact hL.trans (extend_restrict Inc R hR).symm

/-- No finiteness, connectedness or lower degree assumption is necessary. -/
theorem forest_local_recovery (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic)
    (L : Local Inc) (p : P) (a b : Star Inc p) :
    (extend Inc L).rel a.val b.val ↔ (L p).rel a b :=
  local_recovery Inc (certificateOfForest Inc hF) L p a b

end E593Separator
