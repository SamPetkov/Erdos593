import Erdos593.TripleSystem.CanonicalCoarsening
import Erdos593.TripleSystem.CanonicalSeparatorApplication

/-!
# The local product for actual supported one-point decompositions

The source and target use original edge indices, literal supported restrictions,
and the existing sharedAtomPoints. Atom refinement is proved, not imposed on
competitors. These sources require pinned Lean compilation and semantic review.
-/

namespace Erdos593.TripleSystem.CanonicalAtom
open E593Separator
universe u
variable {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

noncomputable def decompositionAtomRep (hL : F.Linear) (hB : F.BridgeAtEveryEdge)
    (A : Index F) : E := Classical.choose (atomOf_surjective F hL hB A)

theorem decompositionAtomRep_spec (hL : F.Linear) (hB : F.BridgeAtEveryEdge) (A : Index F) :
    atomOf F hL hB (decompositionAtomRep F hL hB A) = A :=
  Classical.choose_spec (atomOf_surjective F hL hB A)

/-- The induced atom equivalence is determined by the original edge partition. -/
noncomputable def inducedAtomPartition (hL : F.Linear) (hB : F.BridgeAtEveryEdge)
    (R : Partition E) : Partition (Index F) :=
  pullbackPartition R (decompositionAtomRep F hL hB)

/-- Representatives can be replaced by every original edge of their atom. -/
theorem induced_relation_on_edges (hF : F.Intrinsic) (R : Partition E)
    (hD : IsSupportedDecomposition F R) (e f : E) :
    (inducedAtomPartition F hF.1 hF.2.1 R).rel
      (atomOf F hF.1 hF.2.1 e) (atomOf F hF.1 hF.2.1 f) ↔ R.rel e f := by
  let a := atomOf F hF.1 hF.2.1 e
  let b := atomOf F hF.1 hF.2.1 f
  have he : R.rel e (decompositionAtomRep F hF.1 hF.2.1 a) :=
    canonical_refines_supported_decomposition F hF R hD _ _
      (decompositionAtomRep_spec F hF.1 hF.2.1 a).symm
  have hf : R.rel f (decompositionAtomRep F hF.1 hF.2.1 b) :=
    canonical_refines_supported_decomposition F hF R hD _ _
      (decompositionAtomRep_spec F hF.1 hF.2.1 b).symm
  exact ⟨fun h => R.trans he (R.trans h (R.symm hf)),
    fun h => R.trans (R.symm he) (R.trans h hf)⟩

/-- Pullback recovers the exact original-edge partition, not merely an isomorphic count. -/
theorem coarsened_induced_eq (hF : F.Intrinsic) (R : Partition E)
    (hD : IsSupportedDecomposition F R) :
    coarsenedEdges F hF.1 hF.2.1 (inducedAtomPartition F hF.1 hF.2.1 R) = R := by
  apply Partition.ext
  funext e f
  exact propext (induced_relation_on_edges F hF R hD e f)

theorem induced_coarsened_eq (hL : F.Linear) (hB : F.BridgeAtEveryEdge)
    (R : Partition (Index F)) :
    inducedAtomPartition F hL hB (coarsenedEdges F hL hB R) = R := by
  apply Partition.ext
  funext A B
  change R.rel (atomOf F hL hB (decompositionAtomRep F hL hB A))
    (atomOf F hL hB (decompositionAtomRep F hL hB B)) = R.rel A B
  rw [decompositionAtomRep_spec, decompositionAtomRep_spec]

/-- Actual connectivity of an edge part projects to connectivity of its atom group. -/
theorem inducedAtomPartition_connected (hF : F.Intrinsic) (R : Partition E)
    (hD : IsSupportedDecomposition F R) :
    ConnectedPartition (atomIncident F hF.1 hF.2.1)
      (inducedAtomPartition F hF.1 hF.2.1 R) := by
  classical
  let f := atomOf F hF.1 hF.2.1
  let rep := decompositionAtomRep F hF.1 hF.2.1
  let Q := inducedAtomPartition F hF.1 hF.2.1 R
  intro A B hAB
  let b := R.block (rep A)
  let S := partEdges R b
  have hA : rep A ∈ S := rfl
  have hB : rep B ∈ S := ((R.block_eq_iff (rep A) (rep B)).mpr hAB).symm
  let pick (x : F.EdgeSupport S) := Classical.choose x.property
  have pick_mem (x : F.EdgeSupport S) : pick x ∈ S := (Classical.choose_spec x.property).1
  have pick_inc (x : F.EdgeSupport S) : F.Inc x.val (pick x) :=
    (Classical.choose_spec x.property).2
  let mapNode : F.EdgeSupport S ⊕ S → Index F
    | .inl x => f (pick x)
    | .inr e => f e.val
  have related_members (e g : E) (he : e ∈ S) (hg : g ∈ S) : Q.rel (f e) (f g) := by
    apply (induced_relation_on_edges F hF R hD e g).mpr
    exact (R.block_eq_iff e g).mp (he.trans hg.symm)
  have step : ∀ {z w : F.EdgeSupport S ⊕ S},
      (F.edgeRestriction S).levi.Adj z w →
      Closure (InternalStep (atomIncident F hF.1 hF.2.1) Q) (mapNode z) (mapNode w) := by
    rintro (x | e) (y | g) h
    · exact False.elim ((F.edgeRestriction S).not_levi_adj_point_point h)
    · refine Closure.step ⟨related_members (pick x) g.val (pick_mem x) g.property, x.val, ?_, ?_⟩
      · exact ⟨pick x, rfl, pick_inc x⟩
      · exact ⟨g.val, rfl, (F.edgeRestriction S).levi_adj_point_edge.mp h⟩
    · refine Closure.step ⟨related_members e.val (pick y) e.property (pick_mem y), y.val, ?_, ?_⟩
      · exact ⟨e.val, rfl, (F.edgeRestriction S).levi_adj_edge_point.mp h⟩
      · exact ⟨pick y, rfl, pick_inc y⟩
    · exact False.elim ((F.edgeRestriction S).not_levi_adj_edge_edge h)
  have along : ∀ {z w : F.EdgeSupport S ⊕ S}, (F.edgeRestriction S).levi.Walk z w →
      Closure (InternalStep (atomIncident F hF.1 hF.2.1) Q) (mapNode z) (mapNode w) := by
    intro z w path
    induction path with
    | nil => exact Closure.refl _
    | cons h _ ih => exact Closure.trans (step h) ih
  obtain ⟨path⟩ := (hD.connected b).preconnected (.inr ⟨rep A, hA⟩) (.inr ⟨rep B, hB⟩)
  have lifted := along path
  change Closure (InternalStep (atomIncident F hF.1 hF.2.1) Q) (f (rep A)) (f (rep B)) at lifted
  simpa only [f, rep, decompositionAtomRep_spec] using lifted

abbrev SupportedPartitions := {R : Partition E // IsSupportedDecomposition F R}

/-- The manuscript's actual supported-decomposition poset, not a definition by atom grouping. -/
noncomputable def connectedAtomsSupportedOrderIso (hF : F.Intrinsic) :
    {R : Partition (Index F) // ConnectedPartition (atomIncident F hF.1 hF.2.1) R} ≃o
      SupportedPartitions F where
  toFun R := ⟨coarsenedEdges F hF.1 hF.2.1 R.val,
    coarsenedEdges_supported F hF.1 hF.2.1 R.val R.property⟩
  invFun D := ⟨inducedAtomPartition F hF.1 hF.2.1 D.val,
    inducedAtomPartition_connected F hF D.val D.property⟩
  left_inv R := Subtype.ext (induced_coarsened_eq F hF.1 hF.2.1 R.val)
  right_inv D := Subtype.ext (coarsened_induced_eq F hF D.val D.property)
  map_rel_iff' := by
    intro R S
    change Refines (coarsenedEdges F hF.1 hF.2.1 R.val)
      (coarsenedEdges F hF.1 hF.2.1 S.val) ↔ Refines R.val S.val
    constructor
    · intro h A B hAB
      obtain ⟨e, he⟩ := atomOf_surjective F hF.1 hF.2.1 A
      obtain ⟨f, hf⟩ := atomOf_surjective F hF.1 hF.2.1 B
      have hEF : (coarsenedEdges F hF.1 hF.2.1 R.val).rel e f := by
        change R.val.rel (atomOf F hF.1 hF.2.1 e) (atomOf F hF.1 hF.2.1 f)
        rwa [he, hf]
      have hh := h e f hEF
      change S.val.rel (atomOf F hF.1 hF.2.1 e) (atomOf F hF.1 hF.2.1 f) at hh
      rwa [he, hf] at hh
    · intro h e f hef
      exact h _ _ hef

/-- There is only one equivalence relation on an empty or singleton type. -/
theorem partition_eq_of_subsingleton {A : Type u} [Subsingleton A] (R S : Partition A) : R = S := by
  apply Partition.ext
  funext a b
  have hab : a = b := Subsingleton.elim a b
  subst b
  exact propext ⟨fun _ => S.refl a, fun _ => R.refl a⟩

/-- Outside the existing shared point carrier the local star is empty or singleton. -/
theorem nonshared_star_subsingleton (hL : F.Linear) (hB : F.BridgeAtEveryEdge)
    (p : V) (hp : p ∉ sharedAtomPoints F hL hB) :
    Subsingleton (Star (atomIncident F hL hB) p) := by
  classical
  refine ⟨?_⟩
  intro a b
  apply Subtype.ext
  by_contra hab
  have hc : 1 < ((atomFinset F hL hB).filter (fun A => atomIncident F hL hB A p)).card :=
    Finset.one_lt_card.mpr ⟨a.val, Finset.mem_filter.mpr ⟨mem_atomFinset F hL hB a.val, a.property⟩,
      b.val, Finset.mem_filter.mpr ⟨mem_atomFinset F hL hB b.val, b.property⟩, hab⟩
  exact hp ((mem_sharedAtomPoints F hL hB p).mpr (by omega))

/-- Remove precisely the trivial factors, using the already defined sharedAtomPoints. -/
noncomputable def sharedStarOrderIso (hL : F.Linear) (hB : F.BridgeAtEveryEdge) :
    Local (atomIncident F hL hB) ≃o
      ((p : ↥(sharedAtomPoints F hL hB)) → Partition (Star (atomIncident F hL hB) p.val)) := by
  classical
  let trivial (p : V) : Partition (Star (atomIncident F hL hB) p) :=
    ⟨Eq, fun _ => rfl, Eq.symm, Eq.trans⟩
  let extendLocal (L : (p : ↥(sharedAtomPoints F hL hB)) →
      Partition (Star (atomIncident F hL hB) p.val)) : Local (atomIncident F hL hB) :=
    fun p => if hp : p ∈ sharedAtomPoints F hL hB then L ⟨p, hp⟩ else trivial p
  refine
    { toFun := fun L p => L p.val
      invFun := extendLocal
      left_inv := ?_
      right_inv := ?_
      map_rel_iff' := ?_ }
  · intro L
    funext p
    dsimp only [extendLocal]
    by_cases hp : p ∈ sharedAtomPoints F hL hB
    · rw [dif_pos hp]
    · rw [dif_neg hp]
      letI := nonshared_star_subsingleton F hL hB p hp
      exact partition_eq_of_subsingleton _ _
  · intro L
    funext p
    dsimp only [extendLocal]
    rw [dif_pos p.property]
  · intro L M
    change (∀ p : ↥(sharedAtomPoints F hL hB), Refines (L p.val) (M p.val)) ↔
      ∀ p : V, Refines (L p) (M p)
    constructor
    · intro h p
      by_cases hp : p ∈ sharedAtomPoints F hL hB
      · exact h ⟨p, hp⟩
      · letI := nonshared_star_subsingleton F hL hB p hp
        have he := partition_eq_of_subsingleton (L p) (M p)
        rw [he]
        exact fun _ _ h => h
    · intro h p
      exact h p.val

/-- Each displayed local factor has the original manuscript multiplicity. -/
theorem canonicalStar_card (hL : F.Linear) (hB : F.BridgeAtEveryEdge) (p : V) :
    Nat.card (Star (atomIncident F hL hB) p) = pointMultiplicity F hL hB p := by
  classical
  have hs : {A : Index F | atomIncident F hL hB A p} =
      (↑((atomFinset F hL hB).filter (fun A => atomIncident F hL hB A p)) : Set (Index F)) := by
    ext A
    simp [mem_atomFinset]
  change Nat.card {A : Index F | atomIncident F hL hB A p} =
    ((atomFinset F hL hB).filter (fun A => atomIncident F hL hB A p)).card
  rw [Nat.card_coe_set_eq, hs, Set.ncard_coe_finset]

/-- Full local product for literal supported decompositions of original edges. -/
noncomputable def supportedDecompositionProduct (hF : F.Intrinsic) :
    SupportedPartitions F ≃o
      ((p : ↥(sharedAtomPoints F hF.1 hF.2.1)) →
        Partition (Star (atomIncident F hF.1 hF.2.1) p.val)) :=
  (connectedAtomsSupportedOrderIso F hF).symm.trans
    ((canonicalAtomConnectedPartitionOrderIso F hF.1 hF.2.1).symm.trans
      (sharedStarOrderIso F hF.1 hF.2.1))

/-- Manuscript-facing form: structural assumptions are obtained from obligatoriness. -/
theorem obligatory_supported_decomposition_product (hobl : F.IsObligatory) :
    ∃ (hL : F.Linear) (hB : F.BridgeAtEveryEdge),
      Nonempty (SupportedPartitions F ≃o
        ((p : ↥(sharedAtomPoints F hL hB)) → Partition (Star (atomIncident F hL hB) p.val))) := by
  have hi : F.Intrinsic := ((isObligatory_iff_atomGenerated F).mp hobl).constructible.intrinsic
  exact ⟨hi.1, hi.2.1, ⟨supportedDecompositionProduct F hi⟩⟩

end Erdos593.TripleSystem.CanonicalAtom
