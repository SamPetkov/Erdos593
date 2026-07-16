import Erdos593.TripleSystem.EdgeRestrictionReconstruction
import Erdos593.TripleSystem.SequenceLiftBaseFiberObligatory

/-!
# Running assemblies of linear sequence-lift base fibres

The fibre-local constructibility theorem does not by itself permit a global
conclusion: distinct fibres can have interacting vertex supports.  This module
makes the missing finite gluing condition explicit.  A list is stored newest
first, and each new fibre must be edge-disjoint from the already assembled
tail and meet its total vertex support either in no point or in exactly one
point.  Under that condition, the general exact-restriction reconstruction API
assembles the local constructible pieces.
-/

namespace Erdos593

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}

/-- The geometric part of an auditable running assembly of base fibres.  The
list is newest first: the tail has already been assembled before the head is
attached.  The local constructibility requirement is supplied separately by
the linear, host-two-colourable fibre theorem. -/
def baseFiberAssemblyCompatible (S : Set (Edge G)) : List (Node G) → Prop
  | [] => True
  | q :: nodes =>
      baseFiberAssemblyCompatible S nodes ∧
      Disjoint
        (TripleSystem.edgePieceUnion (nodes.map (baseFiber S)))
        (baseFiber S q) ∧
      (Disjoint
          ((system G).edgeSupportSet
            (TripleSystem.edgePieceUnion (nodes.map (baseFiber S))))
          ((system G).edgeSupportSet (baseFiber S q)) ∨
        ∃ r : Point G,
          (system G).edgeSupportSet
              (TripleSystem.edgePieceUnion (nodes.map (baseFiber S))) ∩
            (system G).edgeSupportSet (baseFiber S q) = {r})

/-- Finite linear base fibres over a two-colourable host form a generic
running edge assembly whenever their supports satisfy
`baseFiberAssemblyCompatible`. -/
theorem baseFiberAssemblyCompatible.runningEdgeAssembly
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2) :
    ∀ nodes : List (Node G),
      baseFiberAssemblyCompatible S nodes →
        (system G).RunningEdgeAssembly (nodes.map (baseFiber S)) := by
  intro nodes hcompatible
  induction nodes with
  | nil =>
      simp [TripleSystem.RunningEdgeAssembly]
  | cons q nodes ih =>
      rcases hcompatible with ⟨htail, hEdges, hSupports⟩
      refine ⟨ih htail,
        baseFiber_constructible_of_linear_of_hostColorable hS q hlinear hG,
        ?_, ?_⟩
      · simpa [TripleSystem.edgePieceUnion] using hEdges
      · simpa [TripleSystem.edgePieceUnion] using hSupports

/-- A compatible finite list of linear base fibres covering an edge set makes
its exact sequence-lift restriction constructible.  The cover equality is
kept explicit so that this theorem does not claim an unsupported global fibre
partition. -/
theorem edgeRestriction_constructible_of_linear_of_hostColorable_of_baseFiberAssembly
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2) (nodes : List (Node G))
    (hcover : TripleSystem.edgePieceUnion (nodes.map (baseFiber S)) = S)
    (hcompatible : baseFiberAssemblyCompatible S nodes) :
    TripleSystem.Constructible ((system G).edgeRestriction S) := by
  have hassembly :
      (system G).RunningEdgeAssembly (nodes.map (baseFiber S)) :=
    hcompatible.runningEdgeAssembly hS hlinear hG nodes
  have hconstructible :
      TripleSystem.Constructible
        ((system G).edgeRestriction
          (TripleSystem.edgePieceUnion (nodes.map (baseFiber S))) ) :=
    (system G).runningEdgeAssembly_constructible _ hassembly
  rw [hcover] at hconstructible
  exact hconstructible

/-- The preceding finite compatible assembly is obligatory, by the completed
classical positive-atom closure theorem for constructible triple systems. -/
theorem edgeRestriction_isObligatory_of_linear_of_hostColorable_of_baseFiberAssembly
    {S : Set (Edge G)} (hS : S.Finite)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hG : G.Colorable 2) (nodes : List (Node G))
    (hcover : TripleSystem.edgePieceUnion (nodes.map (baseFiber S)) = S)
    (hcompatible : baseFiberAssemblyCompatible S nodes) :
    ((system G).edgeRestriction S).IsObligatory :=
  TripleSystem.Constructible.isObligatory
    (edgeRestriction_constructible_of_linear_of_hostColorable_of_baseFiberAssembly
      hS hlinear hG nodes hcover hcompatible)

end SequenceLift

end Erdos593
