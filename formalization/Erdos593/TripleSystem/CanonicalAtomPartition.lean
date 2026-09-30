import Erdos593.Graph.EdgeCycleBlockIncidenceForest
import Erdos593.TripleSystem.BridgeBlockRunningIntersection

/-!
# Canonical atom partition: first layer

This module defines the first, hyperedge-partition layer of the publication's
canonical atom normal form.  Residual-degree-zero hyperedges are singleton
labels.  Every other hyperedge is transported canonically to an edge of its
active bridge-block contracted graph and then to the corresponding quotient
edge-cycle block.

The atom-type dichotomy, two-connectivity, bipartiteness, atom-point forest,
reconstruction, and uniqueness are deliberately downstream obligations.
-/

namespace Erdos593

universe u v

namespace TripleSystem
namespace CanonicalAtom

open BridgeBlock

noncomputable section

variable {V : Type u} {E : Type v} (F : TripleSystem V E)
variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
  [DecidableRel F.levi.Adj]

/-- Canonical labels for the first, hyperedge-partition layer of the atom
normal form. -/
inductive Index where
  | singleton (e : E)
      (hzero :
        (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0)
  | cycleBlock (C : BridgeBlock.HyperedgeComponent F)
      (hC : BridgeBlock.HasIncidence F C)
      (B : Erdos593.SimpleGraph.EdgeCycleBlock
        (BridgeBlock.contractedGraph F C))

/-- A nonzero residual degree makes the hyperedge component active. -/
theorem hyperedgeComponent_hasIncidence_of_degree_ne_zero
    {e : E}
    (hzero :
      (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) ≠ 0) :
    BridgeBlock.HasIncidence F (BridgeBlock.hyperedgeComponentOf F e) := by
  let C := BridgeBlock.hyperedgeComponentOf F e
  have heC : Sum.inr e ∈ (C : BridgeBlock.Component F).supp :=
    BridgeBlock.mem_hyperedgeComponentOf_set F e
  have hpositive :
      0 < (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) :=
    Nat.pos_of_ne_zero hzero
  rcases ((Erdos593.SimpleGraph.bridgeFree F.levi).degree_pos_iff_exists_adj
      (Sum.inr e)).mp hpositive with ⟨z, hez⟩
  rcases z with x | f
  · refine ⟨x, e, ?_, heC, hez.symm⟩
    exact (C : BridgeBlock.Component F).mem_supp_of_adj_mem_supp heC hez
  · have hle : Erdos593.SimpleGraph.bridgeFree F.levi ≤ F.levi := by
      dsimp only [Erdos593.SimpleGraph.bridgeFree]
      exact F.levi.deleteEdges_le _
    exact (F.not_levi_adj_edge_edge (hle hez)).elim

/-- Canonical atom label of an original hyperedge. -/
noncomputable def atomOf
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (e : E) :
    Index F := by
  classical
  by_cases hzero :
      (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0
  · exact .singleton e hzero
  · let C := BridgeBlock.hyperedgeComponentOf F e
    let hC : BridgeBlock.HasIncidence F C :=
      hyperedgeComponent_hasIncidence_of_degree_ne_zero F hzero
    let eC : BridgeBlock.Hyperedge F C :=
      ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩
    let a : (BridgeBlock.contractedGraph F C).edgeSet :=
      (BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm eC
    exact .cycleBlock C hC
      (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
        (BridgeBlock.contractedGraph F C) a)

/-- Original hyperedges carrying a fixed canonical atom label. -/
def edges
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : Index F) : Set E :=
  {e | atomOf F hlinear hbridge e = A}

/-- Every canonical atom label is represented by an original hyperedge. -/
theorem atomOf_surjective
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    Function.Surjective (atomOf F hlinear hbridge) := by
  intro A
  cases A with
  | singleton e hzero =>
      refine ⟨e, ?_⟩
      unfold atomOf
      rw [dif_pos hzero]
  | cycleBlock C hC B =>
      obtain ⟨a, ha⟩ := Erdos593.SimpleGraph.EdgeCycleBlock.exists_rep
        (BridgeBlock.contractedGraph F (C : BridgeBlock.Component F)) B
      set eC : BridgeBlock.Hyperedge F (C : BridgeBlock.Component F) :=
        BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC a with heCdef
      refine ⟨eC.1, ?_⟩
      have hdeg : (Erdos593.SimpleGraph.bridgeFree F.levi).degree
          (Sum.inr eC.1) = 2 :=
        BridgeBlock.edge_degree_eq_two_of_hasIncidence F hbridge hC eC.2
      have hzero : ¬ (Erdos593.SimpleGraph.bridgeFree F.levi).degree
          (Sum.inr eC.1) = 0 := by omega
      have key : ∀ (D : BridgeBlock.HyperedgeComponent F)
          (hD : BridgeBlock.HasIncidence F (D : BridgeBlock.Component F))
          (hmem : Sum.inr eC.1 ∈ (D : BridgeBlock.Component F).supp),
          D = C →
          Index.cycleBlock D hD
              (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
                (BridgeBlock.contractedGraph F (D : BridgeBlock.Component F))
                ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hD).symm
                  ⟨eC.1, hmem⟩))
            = Index.cycleBlock C hC B := by
        rintro D hD hmem rfl
        congr 1
        rw [show (⟨eC.1, hmem⟩ :
              BridgeBlock.Hyperedge F (D : BridgeBlock.Component F)) = eC from rfl,
          heCdef, Equiv.symm_apply_apply]
        exact ha
      unfold atomOf
      rw [dif_neg hzero]
      exact key _ _ _ (Subtype.ext eC.2)

end
end CanonicalAtom
end TripleSystem
end Erdos593
