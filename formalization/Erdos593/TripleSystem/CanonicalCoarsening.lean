import Erdos593.TripleSystem.SupportedDecomposition

/-!
# Connected canonical-atom groups give actual supported edge decompositions

Every part below is a subset of the original edge carrier. Connectivity is
proved inside its own supported restriction. The output forest and pairwise
one-point intersections are conclusions, not fields postulated for a grouping.
This remains uncompiled candidate source.
-/

namespace Erdos593.TripleSystem.CanonicalAtom
open E593Separator
universe u
variable {V E : Type u}

/-- Include one exact edge restriction into a larger one on both point and edge nodes. -/
def restrictionLeviHom (F : TripleSystem V E) {S T : Set E} (hST : S ⊆ T) :
    (F.edgeRestriction S).levi →g (F.edgeRestriction T).levi :=
  ⟨Sum.map
    (fun x => ⟨x.val, by obtain ⟨e, he, hx⟩ := x.property; exact ⟨e, hST he, hx⟩⟩)
    (fun e => ⟨e.val, hST e.property⟩), by
      rintro (x | e) (y | f) h
      · exact False.elim ((F.edgeRestriction S).not_levi_adj_point_point h)
      · exact (F.edgeRestriction T).levi_adj_point_edge.mpr
          ((F.edgeRestriction S).levi_adj_point_edge.mp h)
      · exact (F.edgeRestriction T).levi_adj_edge_point.mpr
          ((F.edgeRestriction S).levi_adj_edge_point.mp h)
      · exact False.elim ((F.edgeRestriction S).not_levi_adj_edge_edge h)⟩

variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- The original edge partition induced by a partition of the actual atom labels. -/
noncomputable def coarsenedEdges (hL : F.Linear) (hB : F.BridgeAtEveryEdge) (R : Partition (Index F)) :
    Partition E := pullbackPartition R (atomOf F hL hB)

/-- The quotient incidences have their literal original-point support meaning. -/
theorem coarsened_incidence_iff (hL : F.Linear) (hB : F.BridgeAtEveryEdge)
    (R : Partition (Index F)) (b : (coarsenedEdges F hL hB R).Block) (p : V) :
    partIncident F (coarsenedEdges F hL hB R) b p ↔
      imageIncidence (atomIncident F hL hB) R.block
        (pullbackBlockMap R (atomOf F hL hB) b) p := by
  constructor
  · rintro ⟨e, he, hp⟩
    refine ⟨atomOf F hL hB e, ?_, e, rfl, hp⟩
    exact congrArg (pullbackBlockMap R (atomOf F hL hB)) he
  · rintro ⟨A, hA, e, heA, hp⟩
    refine ⟨e, ?_, hp⟩
    apply pullbackBlockMap_injective R (atomOf F hL hB)
    change R.block (atomOf F hL hB e) = _
    rw [heA]
    exact hA

/-- Connectivity of a union of whole canonical fibres is internal, not merely ambient. -/
theorem coarsened_part_connected (hL : F.Linear) (hB : F.BridgeAtEveryEdge)
    (R : Partition (Index F)) (hR : ConnectedPartition (atomIncident F hL hB) R)
    (b : (coarsenedEdges F hL hB R).Block) :
    (F.edgeRestriction (partEdges (coarsenedEdges F hL hB R) b)).levi.Connected := by
  classical
  let f := atomOf F hL hB
  let T := coarsenedEdges F hL hB R
  let S := partEdges T b
  let K := (F.edgeRestriction S).levi
  obtain ⟨e0, he0⟩ := partEdges_nonempty T b
  let same (a : Index F) : Prop := R.rel (f e0) a
  let rep (a : Index F) : E := Classical.choose (atomOf_surjective F hL hB a)
  have rep_spec (a : Index F) : f (rep a) = a :=
    Classical.choose_spec (atomOf_surjective F hL hB a)
  have within (a : Index F) (ha : same a) : edges F hL hB a ⊆ S := by
    intro e he
    change T.block e = b
    have hr : T.rel e0 e := by
      change R.rel (f e0) (f e)
      rw [show f e = a from he]
      exact ha
    exact ((T.block_eq_iff e0 e).mpr hr).symm.trans he0
  have rep_mem (a : Index F) (ha : same a) : rep a ∈ S := within a ha (rep_spec a)
  let node (a : Index F) : F.EdgeSupport S ⊕ S :=
    if ha : same a then .inr ⟨rep a, rep_mem a ha⟩ else .inr ⟨e0, he0⟩
  let reachablePartition : Partition (F.EdgeSupport S ⊕ S) :=
    { rel := K.Reachable
      refl _ := .rfl
      symm h := h.symm
      trans h1 h2 := h1.trans h2 }
  have liftstep : ∀ {a c : Index F},
      InternalStep (atomIncident F hL hB) R a c → K.Reachable (node a) (node c) := by
    intro a c h
    rcases h with ⟨hac, p, hap, hcp⟩
    have heq : same a ↔ same c :=
      ⟨fun ha => R.trans ha hac, fun hc => R.trans hc (R.symm hac)⟩
    by_cases ha : same a
    · have hc := heq.mp ha
      dsimp only [node]
      rw [dif_pos ha, dif_pos hc]
      have pa := ((atomRestriction_connected F hL hB a).preconnected
        (.inr ⟨rep a, rep_spec a⟩) (.inl ⟨p, hap⟩)).map (restrictionLeviHom F (within a ha))
      have pc := ((atomRestriction_connected F hL hB c).preconnected
        (.inr ⟨rep c, rep_spec c⟩) (.inl ⟨p, hcp⟩)).map (restrictionLeviHom F (within c hc))
      exact pa.trans pc.symm
    · have hc : ¬ same c := fun h => ha (heq.mpr h)
      dsimp only [node]
      rw [dif_neg ha, dif_neg hc]
  have label_path {a c : Index F} (hac : R.rel a c) : K.Reachable (node a) (node c) :=
    Closure.respects reachablePartition node liftstep (hR a c hac)
  have same_of_member (e : E) (he : e ∈ S) : same (f e) := by
    apply (T.block_eq_iff e0 e).mp
    exact he0.trans he.symm
  have edge_to_node (e : E) (he : e ∈ S) : K.Reachable (.inr ⟨e, he⟩) (node (f e)) := by
    have ha := same_of_member e he
    dsimp only [node]
    rw [dif_pos ha]
    exact ((atomRestriction_connected F hL hB (f e)).preconnected
      (.inr ⟨e, rfl⟩) (.inr ⟨rep (f e), rep_spec (f e)⟩)).map
        (restrictionLeviHom F (within (f e) ha))
  have edges_reachable (e : E) (he : e ∈ S) :
      K.Reachable (.inr ⟨e0, he0⟩) (.inr ⟨e, he⟩) :=
    (edge_to_node e0 he0).trans
      ((label_path (same_of_member e he)).trans (edge_to_node e he).symm)
  apply (SimpleGraph.connected_iff_exists_forall_reachable K).mpr
  refine ⟨.inr ⟨e0, he0⟩, ?_⟩
  rintro (x | e)
  · obtain ⟨e, he, hx⟩ := x.property
    exact (edges_reachable e he).trans
      (((F.edgeRestriction S).levi_adj_edge_point (x := x) (e := ⟨e, he⟩)).mpr hx).reachable
  · exact edges_reachable e.val e.property

/-- A connected partition of canonical atoms satisfies the actual supported-decomposition
conditions on original edge indices. No output forest is assumed. -/
theorem coarsenedEdges_supported (hL : F.Linear) (hB : F.BridgeAtEveryEdge)
    (R : Partition (Index F)) (hR : ConnectedPartition (atomIncident F hL hB) R) :
    IsSupportedDecomposition F (coarsenedEdges F hL hB R) := by
  refine ⟨coarsened_part_connected F hL hB R hR, ?_⟩
  apply incidence_isAcyclic_of_embedding _ _ (pullbackBlockMap R (atomOf F hL hB))
    (pullbackBlockMap_injective R (atomOf F hL hB))
    (fun b p h => (coarsened_incidence_iff F hL hB R b p).mp h)
  exact connectedPartition_quotient_isAcyclic (atomIncident F hL hB)
    (atomPointIncidenceGraph_isAcyclic F hL hB) R hR

end Erdos593.TripleSystem.CanonicalAtom
