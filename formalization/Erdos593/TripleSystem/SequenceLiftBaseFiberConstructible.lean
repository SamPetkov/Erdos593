import Erdos593.TripleSystem.SequenceLiftBaseFiberExpansion
import Erdos593.TripleSystem.Constructive

/-!
# Constructible linear sequence-lift base fibres

This module records the exact conditional bridge from the local graph-side
description of a linear sequence-lift base fibre to constructibility.  The
extra two-colourability hypothesis is explicit: linearity alone does not make
the canonical base-letter subgraph bipartite.
-/

namespace Erdos593

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}

/-- A finite linear base fibre is constructible when the graph selected by its
canonical base letters is two-colourable. -/
theorem baseFiber_constructible_of_linear_of_colorable
    {S : Set (Edge G)} (hS : S.Finite) (q : Node G)
    (hlinear : ((system G).edgeRestriction S).Linear)
    (hcolor : (baseLetterSubgraph G (baseLetter '' baseFiber S q)).coe.Colorable 2) :
    TripleSystem.Constructible ((system G).edgeRestriction (baseFiber S q)) := by
  classical
  letI : Finite (baseLetterSubgraph G (baseLetter '' baseFiber S q)).verts :=
    Set.finite_coe_iff.mpr <|
      baseLetterSubgraph_finite_verts G <|
        (hS.subset (baseFiber_subset S q)).image baseLetter
  letI : Fintype (baseLetterSubgraph G (baseLetter '' baseFiber S q)).verts :=
    Fintype.ofFinite _
  exact TripleSystem.Constructible.ofIso
    (TripleSystem.Constructible.ofExpansion
      (baseLetterSubgraph G (baseLetter '' baseFiber S q)).coe hcolor)
    (baseFiber_privateVertexExpansionIso_of_linear q hlinear)

end SequenceLift

end Erdos593
