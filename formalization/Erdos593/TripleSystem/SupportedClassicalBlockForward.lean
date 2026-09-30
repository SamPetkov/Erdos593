import Erdos593.TripleSystem.SupportedPointIndecomposable

/-!
# Forward classical-block interface

Candidate only. Neither this module nor its point-separator adapter has pinned
project acceptance. No canonical import or existing proof is changed.

The converse for arbitrary finite systems still needs generic block assembly;
it is not obtained by assuming the classification hypotheses.
-/

namespace Erdos593.TripleSystem.SupportedBlocks

universe u

/-- Nonempty maximal point-nonseparable restrictions of original edge indices.
This definition contains no obligatoriness or Intrinsic premise. -/
def IsSupportedBlock {V E : Type u} (F : TripleSystem V E) (S : Set E) : Prop :=
  S.Nonempty ∧ PointNonseparable (F.edgeRestriction S) ∧
    ∀ T : Set E, S ⊆ T → PointNonseparable (F.edgeRestriction T) → T ⊆ S

/-- The literal incidence-isomorphism types in the classical-block statement. -/
def AllowedBlockType {V E : Type u} (F : TripleSystem V E) : Prop :=
  TripleSystem.Isomorphic F (privateVertexExpansion oneEdgeGraph.{u}) ∨
    ∃ C : CanonicalAtom.TwoConnectedBipartiteCore.{u},
      TripleSystem.Isomorphic F (privateVertexExpansion C.graph)

/-- The independent point-deletion test identifies the allowed types for a
connected reduced obligatory system. All original hypotheses are retained. -/
theorem connected_reduced_obligatory_pointNonseparable_iff
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E]
    (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints)
    (hobligatory : F.IsObligatory)
    (hnonempty : Nonempty E) :
    PointNonseparable F ↔ AllowedBlockType F := by
  exact (pointNonseparable_iff_onePointIndecomposable
    F hconnected hreduced hnonempty).trans
      (CanonicalAtom.connected_reduced_obligatory_onePointIndecomposable_iff
        F hconnected hreduced hobligatory hnonempty)

/-- In the forward direction, maximality is unnecessary: every nonempty
point-nonseparable supported restriction of an obligatory system is allowed. -/
theorem obligatory_restriction_allowed_of_pointNonseparable
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E]
    (hobligatory : F.IsObligatory) (S : Set E)
    (hS : S.Nonempty) (hpoint : PointNonseparable (F.edgeRestriction S)) :
    AllowedBlockType (F.edgeRestriction S) := by
  classical
  letI : Fintype (F.EdgeSupport S) := Fintype.ofFinite _
  letI : Fintype S := Fintype.ofFinite _
  have hnonempty : Nonempty S := ⟨⟨hS.choose, hS.choose_spec⟩⟩
  have hreduced : (F.edgeRestriction S).HasNoIsolatedPoints := by
    intro x hx
    obtain ⟨e, he, hxe⟩ := x.property
    exact hx ⟨e, he⟩ hxe
  have hobligatoryRestriction : (F.edgeRestriction S).IsObligatory :=
    hobligatory.of_sourceEmbedding (F.edgeRestrictionEmbedding S)
  exact (connected_reduced_obligatory_pointNonseparable_iff
    (F.edgeRestriction S) hpoint.1 hreduced hobligatoryRestriction hnonempty).mp hpoint

/-- The forward half of the unrestricted manuscript block formulation,
including isolated vertices, disconnected systems and the empty-edge case. -/
theorem isObligatory_implies_forall_supportedBlock_allowed
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E] (hobligatory : F.IsObligatory) :
    ∀ S : Set E, IsSupportedBlock F.isolatedReduction S →
      AllowedBlockType (F.isolatedReduction.edgeRestriction S) := by
  classical
  letI : Fintype F.NonIsolatedPoint := Fintype.ofFinite _
  intro S hS
  exact obligatory_restriction_allowed_of_pointNonseparable
    F.isolatedReduction hobligatory.isolatedReduction S hS.1 hS.2.1

end Erdos593.TripleSystem.SupportedBlocks
