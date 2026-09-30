import Erdos593.TripleSystem.CanonicalAtomMinimalGenerators

/-! # Indecomposable edge restrictions and separator containment

All restrictions and canonical labels are the existing literal objects.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem edgeRestriction_subset_or_subset_of_support_inter_subsingleton
    {V E : Type u} (F : TripleSystem V E)
    (S L R : Set E)
    (hcover : S ⊆ L ∪ R)
    (hdisjoint : Disjoint L R)
    (hinter :
      (F.edgeSupportSet L ∩ F.edgeSupportSet R).Subsingleton)
    (hconnected : (F.edgeRestriction S).levi.Connected)
    (hindec : OnePointIndecomposable (F.edgeRestriction S)) :
    S ⊆ L ∨ S ⊆ R := by
  classical
  by_cases hL : S ⊆ L
  · exact Or.inl hL
  by_cases hR : S ⊆ R
  · exact Or.inr hR
  obtain ⟨eR, heRS, heRL⟩ := Set.not_subset.mp hL
  obtain ⟨eL, heLS, heLR⟩ := Set.not_subset.mp hR
  have heLL : eL ∈ L := (hcover heLS).resolve_right heLR
  have heRR : eR ∈ R := (hcover heRS).resolve_left heRL
  let L' : Set E := S ∩ L
  let R' : Set E := S ∩ R
  have hparts : L' ∪ R' = S := by
    ext e
    constructor
    · rintro (he | he)
      · exact he.1
      · exact he.1
    · intro he
      rcases hcover he with hleft | hright
      · exact Or.inl ⟨he, hleft⟩
      · exact Or.inr ⟨he, hright⟩
  have hdisjoint' : Disjoint L' R' := by
    apply Set.disjoint_left.mpr
    intro e heL heR
    exact Set.disjoint_left.mp hdisjoint heL.2 heR.2
  have hsub :
      (F.edgeSupportSet L' ∩ F.edgeSupportSet R').Subsingleton := by
    intro x hx y hy
    apply hinter
    · rcases hx with ⟨⟨e, he, hxe⟩, ⟨g, hg, hxg⟩⟩
      exact ⟨⟨e, he.2, hxe⟩, ⟨g, hg.2, hxg⟩⟩
    · rcases hy with ⟨⟨e, he, hye⟩, ⟨g, hg, hyg⟩⟩
      exact ⟨⟨e, he.2, hye⟩, ⟨g, hg.2, hyg⟩⟩
  have hmeet : (F.edgeSupportSet L' ∩ F.edgeSupportSet R').Nonempty := by
    by_contra hempty
    let X : Set (F.EdgeSupport S ⊕ S) :=
      {z | Sum.elim (fun x => x.1 ∈ F.edgeSupportSet L')
        (fun e => e.1 ∈ L') z}
    have hstep : ∀ z w : F.EdgeSupport S ⊕ S,
        z ∈ X → (F.edgeRestriction S).levi.Adj z w → w ∈ X := by
      rintro (x | e) (y | g) hz hadj
      · exact absurd hadj (F.edgeRestriction S).not_levi_adj_point_point
      · have hxg : F.Inc x.1 g.1 :=
          (F.edgeRestriction S).levi_adj_point_edge.mp hadj
        have hxL : x.1 ∈ F.edgeSupportSet L' := hz
        rcases hcover g.2 with hgL | hgR
        · exact ⟨g.2, hgL⟩
        · exact (hempty ⟨x.1, hxL, ⟨g.1, ⟨g.2, hgR⟩, hxg⟩⟩).elim
      · exact ⟨e.1, hz, (F.edgeRestriction S).levi_adj_edge_point.mp hadj⟩
      · exact absurd hadj (F.edgeRestriction S).not_levi_adj_edge_edge
    have hwalk : ∀ z w : F.EdgeSupport S ⊕ S,
        (F.edgeRestriction S).levi.Walk z w → z ∈ X → w ∈ X := by
      intro z w p
      induction p with
      | nil => exact id
      | cons hadj _ ih => exact fun hz => ih (hstep _ _ hz hadj)
    obtain ⟨p⟩ := hconnected.preconnected
      (Sum.inr ⟨eL, heLS⟩) (Sum.inr ⟨eR, heRS⟩)
    have heRleft : eR ∈ L' := hwalk _ _ p ⟨heLS, heLL⟩
    exact heRL heRleft.2
  obtain ⟨r, hr⟩ := hmeet
  have hroot : F.edgeSupportSet L' ∩ F.edgeSupportSet R' = {r} := by
    apply Set.Subset.antisymm
    · intro x hx
      exact Set.mem_singleton_iff.mpr (hsub hx hr)
    · intro x hx
      have hxr : x = r := Set.mem_singleton_iff.mp hx
      exact hxr.symm ▸ hr
  exfalso
  apply hindec
  refine ⟨F.EdgeSupport L', L', F.EdgeSupport R', R',
    F.edgeRestriction L', F.edgeRestriction R',
    F.edgeSupportLeftRoot hroot, F.edgeSupportRightRoot hroot,
    ⟨⟨eL, heLS, heLL⟩⟩, ⟨⟨eR, heRS, heRR⟩⟩, ?_⟩
  have hi := (F.edgeRestrictionUnionIsoOnePointAmalgamation hdisjoint' hroot).symm
  rw [hparts] at hi
  exact ⟨hi⟩

theorem edgeRestriction_subset_piece_of_runningEdgeAssembly
    {V E : Type u} (F : TripleSystem V E)
    (pieces : List (Set E))
    (hrunning : F.RunningEdgeAssembly pieces)
    (S : Set E)
    (hcover : S ⊆ edgePieceUnion pieces)
    (hconnected : (F.edgeRestriction S).levi.Connected)
    (hindec : OnePointIndecomposable (F.edgeRestriction S)) :
    ∃ T ∈ pieces, S ⊆ T := by
  classical
  revert hrunning hcover
  induction pieces with
  | nil =>
      intro _ hcover
      exfalso
      obtain ⟨z⟩ := hconnected.nonempty
      rcases z with x | e
      · obtain ⟨e, he, _⟩ := x.property
        exact hcover he
      · exact hcover e.property
  | cons T pieces ih =>
      intro hrunning hcover
      obtain ⟨hprevious, _, hEdges, hSupports⟩ := hrunning
      have hinter :
          (F.edgeSupportSet (edgePieceUnion pieces) ∩
            F.edgeSupportSet T).Subsingleton := by
        rcases hSupports with hdisj | ⟨root, hroot⟩
        · intro _ hx _ _
          exact False.elim (Set.disjoint_left.mp hdisj hx.1 hx.2)
        · intro x hx y hy
          have hxroot : x = root :=
            Set.mem_singleton_iff.mp (hroot ▸ hx)
          have hyroot : y = root :=
            Set.mem_singleton_iff.mp (hroot ▸ hy)
          exact hxroot.trans hyroot.symm
      change S ⊆ edgePieceUnion pieces ∪ T at hcover
      rcases edgeRestriction_subset_or_subset_of_support_inter_subsingleton
          F S (edgePieceUnion pieces) T hcover hEdges hinter
          hconnected hindec with hprevS | hnewS
      · obtain ⟨P, hP, hSP⟩ := ih hprevious hprevS
        exact ⟨P, by simp [hP], hSP⟩
      · exact ⟨T, by simp, hnewS⟩

theorem indecomposable_edgeRestriction_subset_atom
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hF : F.Intrinsic) (S : Set E)
    (hconnected : (F.edgeRestriction S).levi.Connected)
    (hindec : OnePointIndecomposable (F.edgeRestriction S)) :
    ∃ A : Index F, S ⊆ edges F hF.1 hF.2.1 A := by
  classical
  obtain ⟨assembly⟩ := exists_atomRunningAssembly F hF
  have hcover :
      S ⊆ edgePieceUnion
        (atomEdgeSets F hF.1 hF.2.1 assembly.atoms) := by
    rw [assembly.total]
    exact Set.subset_univ S
  obtain ⟨T, hT, hST⟩ :=
    edgeRestriction_subset_piece_of_runningEdgeAssembly
      F (atomEdgeSets F hF.1 hF.2.1 assembly.atoms)
      assembly.running S hcover hconnected hindec
  rw [atomEdgeSets, List.mem_map] at hT
  obtain ⟨A, _, rfl⟩ := hT
  exact ⟨A, hST⟩

end Erdos593.TripleSystem.CanonicalAtom
