import Erdos593.TripleSystem.SupportedClassicalBlockForward
import Erdos593.TripleSystem.SupportedRestrictionTransport
import Erdos593.TripleSystem.SupportedDisconnectedSplit
import Erdos593.TripleSystem.EdgeRestrictionFull
import Erdos593.TripleSystem.EdgeRestrictionReconstruction

/-!
# Unrestricted classical-block converse by finite edge splitting

Candidate: no project acceptance is claimed by this file. The induction is on
literal subsets of the original edge carrier. In particular, the converse does
not assume Intrinsic, obligatoriness, connectedness, or a block running order.
-/

namespace Erdos593.TripleSystem.SupportedBlocks

universe u

/-- Transport a point-separation of a supported restriction to the original
edge carrier, retaining the actual ambient cut point. -/
theorem exists_original_partition_of_pointSeparation
    {V E : Type u} (F : TripleSystem V E) (S : Set E)
    (h : HasPointSeparation (F.edgeRestriction S)) :
    ∃ L R : Set E, L.Nonempty ∧ R.Nonempty ∧ Disjoint L R ∧
      L ∪ R = S ∧ ∃ r : V,
        F.edgeSupportSet L ∩ F.edgeSupportSet R = {r} := by
  rcases h with ⟨A, B, r, hA, hB, hdisjoint, htotal, hsupports⟩
  let L : Set E := Subtype.val '' A
  let R : Set E := Subtype.val '' B
  refine ⟨L, R, hA.image _, hB.image _, ?_, ?_, r.1, ?_⟩
  · apply Set.disjoint_left.mpr
    rintro e ⟨a, ha, hae⟩ ⟨b, hb, hbe⟩
    have hab : a = b := Subtype.ext (hae.trans hbe.symm)
    exact Set.disjoint_left.mp hdisjoint (hab ▸ ha) hb
  · apply Set.Subset.antisymm
    · rintro e (⟨a, _, rfl⟩ | ⟨b, _, rfl⟩)
      · exact a.property
      · exact b.property
    · intro e he
      let a : S := ⟨e, he⟩
      rcases (htotal ▸ Set.mem_univ a : a ∈ A ∪ B) with ha | hb
      · exact Or.inl ⟨a, ha, rfl⟩
      · exact Or.inr ⟨a, hb, rfl⟩
  · ext x
    constructor
    · rintro ⟨⟨e, ⟨a, ha, rfl⟩, hxe⟩, ⟨g, ⟨b, hb, rfl⟩, hxg⟩⟩
      let xS : F.EdgeSupport S := ⟨x, a.1, a.2, hxe⟩
      have hx : xS ∈ (F.edgeRestriction S).edgeSupportSet A ∩
          (F.edgeRestriction S).edgeSupportSet B :=
        ⟨⟨a, ha, hxe⟩, ⟨b, hb, hxg⟩⟩
      have hxr : xS = r := Set.mem_singleton_iff.mp (hsupports ▸ hx)
      exact Set.mem_singleton_iff.mpr (congrArg Subtype.val hxr)
    · intro hx
      have hxr : x = r.1 := Set.mem_singleton_iff.mp hx
      subst x
      have hr : r ∈ (F.edgeRestriction S).edgeSupportSet A ∩
          (F.edgeRestriction S).edgeSupportSet B := by
        rw [hsupports]
        exact Set.mem_singleton r
      obtain ⟨a, ha, hra⟩ := hr.1
      obtain ⟨b, hb, hrb⟩ := hr.2
      exact ⟨⟨a.1, ⟨a, ha, rfl⟩, hra⟩, ⟨b.1, ⟨b, hb, rfl⟩, hrb⟩⟩

/-- Every finite original edge set is obtained from point-nonseparable pieces
by disjoint-support unions and singleton-support unions. This is a predicate
induction principle, not an assumption that a block ordering already exists. -/
theorem edgeRestriction_induction
    {V E : Type u} (F : TripleSystem V E) [Finite E]
    (P : Set E → Prop) (hempty : P ∅)
    (hterminal : ∀ S : Set E, S.Nonempty →
      PointNonseparable (F.edgeRestriction S) → P S)
    (hglue : ∀ L R : Set E, L.Nonempty → R.Nonempty → Disjoint L R →
      (Disjoint (F.edgeSupportSet L) (F.edgeSupportSet R) ∨
        ∃ r : V, F.edgeSupportSet L ∩ F.edgeSupportSet R = {r}) →
      P L → P R → P (L ∪ R)) : ∀ S : Set E, P S := by
  classical
  have h : ∀ n : ℕ, ∀ S : Set E, S.ncard = n → P S := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
      intro S hcard
      by_cases hS : S.Nonempty
      · by_cases hp : PointNonseparable (F.edgeRestriction S)
        · exact hterminal S hS hp
        · have hsplit : ∃ L R : Set E, L.Nonempty ∧ R.Nonempty ∧
              Disjoint L R ∧ L ∪ R = S ∧
              (Disjoint (F.edgeSupportSet L) (F.edgeSupportSet R) ∨
                ∃ r : V, F.edgeSupportSet L ∩ F.edgeSupportSet R = {r}) := by
            by_cases hc : (F.edgeRestriction S).levi.Connected
            · have hr : (F.edgeRestriction S).HasNoIsolatedPoints := by
                intro x hx
                obtain ⟨e, he, hxe⟩ := x.property
                exact hx ⟨e, he⟩ hxe
              have hn : Nonempty S := ⟨⟨hS.choose, hS.choose_spec⟩⟩
              have hsep : HasPointSeparation (F.edgeRestriction S) := by
                by_contra hnot
                exact hp ((pointNonseparable_iff_no_pointSeparation
                  (F.edgeRestriction S) hc hr hn).mpr hnot)
              obtain ⟨L, R, hL, hR, hd, hu, r, hs⟩ :=
                exists_original_partition_of_pointSeparation F S hsep
              exact ⟨L, R, hL, hR, hd, hu, Or.inr ⟨r, hs⟩⟩
            · obtain ⟨L, R, hL, hR, hd, hu, hs⟩ :=
                exists_original_partition_of_disconnected_restriction F S hS hc
              exact ⟨L, R, hL, hR, hd, hu, Or.inl hs⟩
          obtain ⟨L, R, hL, hR, hd, hu, hs⟩ := hsplit
          have hLS : L ⊆ S := fun _ he => hu ▸ Or.inl he
          have hRS : R ⊆ S := fun _ he => hu ▸ Or.inr he
          have hLt : L ⊂ S := by
            refine ⟨hLS, ?_⟩
            intro hSL
            obtain ⟨e, he⟩ := hR
            exact Set.disjoint_left.mp hd (hSL (hRS he)) he
          have hRt : R ⊂ S := by
            refine ⟨hRS, ?_⟩
            intro hSR
            obtain ⟨e, he⟩ := hL
            exact Set.disjoint_left.mp hd he (hSR (hLS he))
          have hPL : P L := ih L.ncard (hcard ▸ Set.ncard_lt_ncard hLt) L rfl
          have hPR : P R := ih R.ncard (hcard ▸ Set.ncard_lt_ncard hRt) R rfl
          exact hu ▸ hglue L R hL hR hd hs hPL hPR
      · have he : S = ∅ := Set.not_nonempty_iff_eq_empty.mp hS
        exact he ▸ hempty
  intro S
  exact h S.ncard S rfl

/-- A nonempty point-nonseparable restriction extends to a maximal such
restriction. No monotonicity of point-nonseparability is needed. -/
theorem exists_supportedBlock_superset
    {V E : Type u} (F : TripleSystem V E) [Finite E]
    (S : Set E) (hS : S.Nonempty)
    (hp : PointNonseparable (F.edgeRestriction S)) :
    ∃ T : Set E, S ⊆ T ∧ IsSupportedBlock F T := by
  obtain ⟨T, hST, hT, hmax⟩ := exists_maximal_set_superset
    (fun U : Set E => PointNonseparable (F.edgeRestriction U)) S hp
  exact ⟨T, hST, hS.mono hST, hT, hmax⟩

/-- Both allowed literal incidence-isomorphism types are obligatory. -/
theorem AllowedBlockType.isObligatory
    {V E : Type u} {F : TripleSystem V E} (h : AllowedBlockType F) :
    F.IsObligatory := by
  rcases h with h | ⟨C, h⟩
  · obtain ⟨f⟩ := h
    exact CanonicalAtom.AtomGenerated.ofOneTriple.constructible.isObligatory.ofIso f.symm
  · obtain ⟨f⟩ := h
    exact (CanonicalAtom.AtomGenerated.ofCore C).constructible.isObligatory.ofIso f.symm

/-- If all maximal point-nonseparable restrictions are allowed, every exact
restriction is obligatory. The induction handles disconnected systems too. -/
theorem restriction_isObligatory_of_forall_supportedBlock_allowed
    {V E : Type u} (F : TripleSystem V E) [Fintype V] [Fintype E]
    (hall : ∀ S : Set E, IsSupportedBlock F S → AllowedBlockType (F.edgeRestriction S)) :
    ∀ S : Set E, (F.edgeRestriction S).IsObligatory := by
  classical
  apply edgeRestriction_induction F (fun S => (F.edgeRestriction S).IsObligatory)
  · letI : Fintype (F.EdgeSupport ∅) := Fintype.ofFinite _
    exact isObligatory_of_isEmptyEdgeIndices (F.edgeRestriction ∅)
  · intro S hS hp
    obtain ⟨T, hST, hT⟩ := exists_supportedBlock_superset F S hS hp
    exact (hall T hT).isObligatory.of_sourceEmbedding
      (F.edgeRestrictionEmbeddingOfSubset hST)
  · intro L R _ _ hd hs hL hR
    letI : Fintype (F.EdgeSupport L) := Fintype.ofFinite _
    letI : Fintype (F.EdgeSupport R) := Fintype.ofFinite _
    letI : Fintype L := Fintype.ofFinite _
    letI : Fintype R := Fintype.ofFinite _
    rcases hs with hs | ⟨r, hs⟩
    · exact (IsObligatory.disjointUnion _ _ hL hR).ofIso
        (F.edgeRestrictionUnionIsoDisjointUnion hd hs)
    · exact (IsObligatory.onePointAmalgamation hL hR
        (F.edgeSupportLeftRoot hs) (F.edgeSupportRightRoot hs)).ofIso
        (F.edgeRestrictionUnionIsoOnePointAmalgamation hd hs)

/-- The unrestricted classical-block characterization, including empty edge
sets, disconnected systems and isolated points, with no Intrinsic premise. -/
theorem isObligatory_iff_forall_supportedBlock_allowed
    {V E : Type u} (F : TripleSystem V E) [Fintype V] [Fintype E] :
    F.IsObligatory ↔
      ∀ S : Set E, IsSupportedBlock F.isolatedReduction S →
        AllowedBlockType (F.isolatedReduction.edgeRestriction S) := by
  classical
  constructor
  · exact isObligatory_implies_forall_supportedBlock_allowed F
  · intro hall
    letI : Fintype F.NonIsolatedPoint := Fintype.ofFinite _
    have h := restriction_isObligatory_of_forall_supportedBlock_allowed
      F.isolatedReduction hall Set.univ
    exact (h.ofIso (F.isolatedReduction.edgeRestrictionUnivIso
      F.isolatedReduction_hasNoIsolatedPoints)).of_isolatedReduction

end Erdos593.TripleSystem.SupportedBlocks
