import Erdos593.TripleSystem.CanonicalAtomBaseCount
import Erdos593.TripleSystem.CanonicalAtomCounting
import Erdos593.Separator.SeparatorCoarsening

/-!
# Actual supported partitions of the original hyperedge indices

The competitor is a partition of E. Its definition does not assume that any
canonical atom lies in a single part, that its parts are obligatory, or that
it is obtained by grouping canonical atoms. Those are conclusions.
This proof source has not yet been replayed by Lean.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

open E593Separator
universe u
variable {V E : Type u}

/-- The exact original edge-index set of a partition class. -/
def partEdges (R : Partition E) (b : R.Block) : Set E := {e | R.block e = b}

/-- All original points supported by this exact edge set. -/
def partIncident (F : TripleSystem V E) (R : Partition E) (b : R.Block) (x : V) : Prop :=
  x ∈ F.edgeSupportSet (partEdges R b)

/-- Nonempty parts are built into the quotient carrier. Connectivity and the
ordinary incidence forest are imposed on their actual supported restrictions. -/
structure IsSupportedDecomposition (F : TripleSystem V E) (R : Partition E) : Prop where
  connected : ∀ b : R.Block, (F.edgeRestriction (partEdges R b)).levi.Connected
  forest : (incidenceGraph (partIncident F R)).IsAcyclic

theorem partEdges_nonempty (R : Partition E) (b : R.Block) : (partEdges R b).Nonempty := by
  obtain ⟨e, he⟩ := R.block_surjective b
  exact ⟨e, he⟩

theorem partEdges_disjoint (R : Partition E) {b c : R.Block} (hbc : b ≠ c) :
    Disjoint (partEdges R b) (partEdges R c) := by
  apply Set.disjoint_left.mpr
  intro e he hf
  exact hbc (he.symm.trans hf)

/-- The separate one-point-intersection condition in the manuscript follows
from the incidence forest; it is not omitted by redefining decomposition. -/
theorem IsSupportedDecomposition.support_inter_subsingleton
    (F : TripleSystem V E) (R : Partition E) (hD : IsSupportedDecomposition F R)
    {b c : R.Block} (hbc : b ≠ c) :
    (F.edgeSupportSet (partEdges R b) ∩ F.edgeSupportSet (partEdges R c)).Subsingleton := by
  intro p hp q hq
  by_contra hpq
  have hN := noReturn_of_isAcyclic _ hD.forest
  exact hbc (hN p b c hp.1 hp.2 (Closure.step ⟨q, Ne.symm hpq, hq.1, hq.2⟩))

/-- The definition is equivalent to the three literal conditions in the
manuscript: connected pieces, at most one shared point, and a pruned forest. -/
theorem supportedDecomposition_iff_manuscript (F : TripleSystem V E) (R : Partition E) :
    IsSupportedDecomposition F R ↔
      (∀ b, (F.edgeRestriction (partEdges R b)).levi.Connected) ∧
      (∀ b c, b ≠ c →
        (F.edgeSupportSet (partEdges R b) ∩ F.edgeSupportSet (partEdges R c)).Subsingleton) ∧
      (incidenceGraph (fun b (p : {p // SharedSeparator (partIncident F R) p}) =>
        partIncident F R b p.val)).IsAcyclic := by
  constructor
  · intro hD
    exact ⟨hD.connected, fun _ _ h => IsSupportedDecomposition.support_inter_subsingleton F R hD h,
      (isAcyclic_iff_shared_pruning _).mp hD.forest⟩
  · rintro ⟨hc, _, hf⟩
    exact ⟨hc, (isAcyclic_iff_shared_pruning _).mpr hf⟩

/-- A running support family needs no constructibility assumption on competitors. -/
def RunningSupportFamily (F : TripleSystem V E) : List (Set E) → Prop
  | [] => True
  | S :: tail => RunningSupportFamily F tail ∧
      Disjoint (edgePieceUnion tail) S ∧
      (F.edgeSupportSet (edgePieceUnion tail) ∩ F.edgeSupportSet S).Subsingleton

theorem mem_union_mapped_parts {I : Type u} (pieces : I → Set E) (l : List I) (e : E) :
    e ∈ edgePieceUnion (l.map pieces) ↔ ∃ i ∈ l, e ∈ pieces i := by
  induction l with
  | nil => simp [edgePieceUnion]
  | cons a tail ih =>
      simp [edgePieceUnion, ih, or_comm]

/-- The usual splitting lemma works for arbitrary supported pieces. -/
theorem indecomposable_subset_running_part
    (F : TripleSystem V E) (l : List (Set E)) (hL : RunningSupportFamily F l)
    (S : Set E) (hcover : S ⊆ edgePieceUnion l)
    (hc : (F.edgeRestriction S).levi.Connected)
    (hi : OnePointIndecomposable (F.edgeRestriction S)) :
    ∃ T ∈ l, S ⊆ T := by
  revert hL hcover
  induction l with
  | nil =>
      intro _ hcover
      obtain ⟨z⟩ := hc.nonempty
      rcases z with x | e
      · obtain ⟨e, he, _⟩ := x.property
        exact False.elim (hcover he)
      · exact False.elim (hcover e.property)
  | cons T tail ih =>
      intro hL hcover
      rcases hL with ⟨hprev, hdisj, hmeet⟩
      rcases edgeRestriction_subset_or_subset_of_support_inter_subsingleton
          F S (edgePieceUnion tail) T hcover hdisj hmeet hc hi with hS | hS
      · obtain ⟨U, hU, hSU⟩ := ih hprev hS
        exact ⟨U, List.mem_cons_of_mem T hU, hSU⟩
      · exact ⟨T, by simp, hS⟩

/-- A leaf ordering of the actual piece incidence forest gives a running family. -/
theorem parts_running_of_tail_order (F : TripleSystem V E) (R : Partition E)
    (l : List R.Block) (hnd : l.Nodup)
    (horder : SimpleGraph.bipartiteTailPointSubsingleton (partIncident F R) l) :
    RunningSupportFamily F (l.map (partEdges R)) := by
  revert hnd horder
  induction l with
  | nil =>
      intro _ _
      trivial
  | cons b tail ih =>
      intro hnd horder
      obtain ⟨hb, hnd⟩ := List.nodup_cons.mp hnd
      obtain ⟨hprev, hleaf⟩ := horder
      refine ⟨ih hnd hprev, ?_, ?_⟩
      · apply Set.disjoint_left.mpr
        intro e he heb
        obtain ⟨c, hc, hec⟩ := (mem_union_mapped_parts (partEdges R) tail e).mp he
        have hcb : c = b := hec.symm.trans heb
        exact hb (hcb ▸ hc)
      · intro x hx y hy
        obtain ⟨e, he, hxe⟩ := hx.1
        obtain ⟨c, hc, hec⟩ := (mem_union_mapped_parts (partEdges R) tail e).mp he
        obtain ⟨f, hf, hyf⟩ := hy.1
        obtain ⟨d, hd, hfd⟩ := (mem_union_mapped_parts (partEdges R) tail f).mp hf
        exact hleaf x y hx.2 hy.2 ⟨c, hc, e, hec, hxe⟩ ⟨d, hd, f, hfd, hyf⟩

/-- Every actual finite decomposition has a running support presentation. -/
theorem decomposition_running_parts [Fintype V] [Fintype E]
    (F : TripleSystem V E) (R : Partition E) (hD : IsSupportedDecomposition F R) :
    ∃ l : List R.Block, (∀ b, b ∈ l) ∧
      RunningSupportFamily F (l.map (partEdges R)) := by
  classical
  haveI : Finite R.Block := Finite.of_surjective _ R.block_surjective
  letI : Fintype R.Block := Fintype.ofFinite _
  have hf : (SimpleGraph.bipartiteIncidenceGraph (partIncident F R)).IsAcyclic :=
    hD.forest
  obtain ⟨l, hnd, htotal, horder⟩ :=
    hf.exists_finset_bipartiteTailPointSubsingletonOrder (partIncident F R) Finset.univ
  refine ⟨l, ?_, parts_running_of_tail_order F R l hnd horder⟩
  intro b
  apply List.mem_toFinset.mp
  rw [htotal]
  exact Finset.mem_univ b

variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- Literal indecomposability of each atom, using the previously proved two shapes. -/
theorem atomRestriction_indivisible_for_decomposition (hF : F.Intrinsic) (A : Index F) :
    OnePointIndecomposable (atomRestriction F hF.1 hF.2.1 A) := by
  classical
  cases A with
  | singleton e hz =>
      obtain ⟨i⟩ := atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u,u,u}
        F hF.1 hF.2.1 (Index.singleton e hz)
      apply (onePointIndecomposable_iff_of_iso i).mpr
      exact (onePointIndecomposable_iff_of_iso (oneEdgeExpansionSingleEdgePieceIso F e)).mp
        oneTriple_onePointIndecomposable
  | cycleBlock C hC B =>
      obtain ⟨i⟩ := atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u,u,u}
        F hF.1 hF.2.1 (Index.cycleBlock C hC B)
      let K : TwoConnectedBipartiteCore.{u} :=
        { Vertex := _
          vertexFintype := inferInstance
          graph := cycleBlockCore F C B
          twoVertexConnected := cycleBlockCore_isTwoVertexConnected F hF.1 hF.2.1 C hC B
          bipartite := cycleBlockCore_isBipartite F hF.1 hF.2.1 hF.2.2 C hC B }
      exact (onePointIndecomposable_iff_of_iso i).mpr (coreExpansion_onePointIndecomposable K)

/-- Every canonical atom belongs to exactly one competing piece. No
obligatoriness or indecomposability assumption is made on those pieces. -/
theorem canonical_atom_in_unique_part (hF : F.Intrinsic)
    (R : Partition E) (hD : IsSupportedDecomposition F R) (A : Index F) :
    ∃! b : R.Block, edges F hF.1 hF.2.1 A ⊆ partEdges R b := by
  obtain ⟨l, htotal, hrun⟩ := decomposition_running_parts F R hD
  have hcover : edges F hF.1 hF.2.1 A ⊆ edgePieceUnion (l.map (partEdges R)) := by
    intro e _
    exact (mem_union_mapped_parts (partEdges R) l e).mpr ⟨R.block e, htotal _, rfl⟩
  obtain ⟨T, hT, hAT⟩ := indecomposable_subset_running_part F _ hrun _ hcover
    (atomRestriction_connected F hF.1 hF.2.1 A)
    (atomRestriction_indivisible_for_decomposition F hF A)
  obtain ⟨b, _, rfl⟩ := List.mem_map.mp hT
  refine ⟨b, hAT, ?_⟩
  intro c hAC
  obtain ⟨e, he⟩ := atomOf_surjective F hF.1 hF.2.1 A
  exact (hAC he).symm.trans (hAT he)

/-- The canonical edge equivalence refines every literal supported forest decomposition. -/
theorem canonical_refines_supported_decomposition (hF : F.Intrinsic)
    (R : Partition E) (hD : IsSupportedDecomposition F R) (e f : E)
    (hef : atomOf F hF.1 hF.2.1 e = atomOf F hF.1 hF.2.1 f) : R.rel e f := by
  obtain ⟨b, hb, _⟩ := canonical_atom_in_unique_part F hF R hD (atomOf F hF.1 hF.2.1 e)
  exact (R.block_eq_iff e f).mp ((hb rfl).trans (hb hef.symm).symm)

end Erdos593.TripleSystem.CanonicalAtom
