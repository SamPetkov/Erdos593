import Erdos593.TripleSystem.ErdosRado.CanonicalTree

/-!
# Conditional canonical level codes

This file records the code supplied by a coherent trace system. It deliberately
does not assert that the code is injective: that needs the source-native trace
selection and coherence hypotheses not present in `CoherentTraceSystem`.
-/

namespace Erdos593.TripleSystem.TriangleHost.ErdosRado
namespace CoherentTraceSystem

variable {c : TraceColoring} (T : CoherentTraceSystem c)

/-- The ordinal represented by a coordinate of `rho.ToType`. -/
noncomputable def levelIndex (rho : Ordinal) (zeta : rho.ToType) : Ordinal :=
  zeta.toOrd.1

/-- A coordinate of `rho.ToType` denotes an ordinal strictly below `rho`. -/
theorem levelIndex_lt (rho : Ordinal) (zeta : rho.ToType) :
    levelIndex rho zeta < rho :=
  zeta.toOrd.2

/-- A level-code coordinate is a valid trace index for its endpoint. -/
theorem levelIndex_lt_height (rho : Ordinal) (a : T.level rho)
    (zeta : rho.ToType) :
    levelIndex rho zeta < T.height a.1 := by
  rw [a.2]
  exact levelIndex_lt rho zeta

/-- The trace node addressed by a code coordinate. -/
noncomputable def levelNode (rho : Ordinal) (a : T.level rho)
    (zeta : rho.ToType) : TraceCarrier :=
  T.node a.1 (T.levelIndex_lt_height rho a zeta)

/-- Every node used by a level code lies below the endpoint. -/
theorem levelNode_lt_anchor (rho : Ordinal) (a : T.level rho)
    (zeta : rho.ToType) :
    T.levelNode rho a zeta < a.1 :=
  T.node_lt_anchor a.1 (T.levelIndex_lt_height rho a zeta)

/-- The coloring code of an endpoint at a fixed supplied trace height. -/
noncomputable def levelCode (rho : Ordinal) (a : T.level rho) :
    rho.ToType -> Nat :=
  fun zeta =>
    c (tracePair (T.levelNode rho a zeta) a.1
      (ne_of_lt (T.levelNode_lt_anchor rho a zeta)))

/-- A coordinate of the level code is the color of the corresponding trace face. -/
@[simp] theorem levelCode_apply (rho : Ordinal) (a : T.level rho)
    (zeta : rho.ToType) :
    T.levelCode rho a zeta =
      c (tracePair (T.levelNode rho a zeta) a.1
        (ne_of_lt (T.levelNode_lt_anchor rho a zeta))) :=
  rfl

/-- The downstream fixed-level separation obligation for source-native traces.

This is only a proposition here. It is not a theorem of `CoherentTraceSystem`.
-/
def LevelCodeInjective (rho : Ordinal) : Prop :=
  Function.Injective (T.levelCode rho)

end CoherentTraceSystem
end Erdos593.TripleSystem.TriangleHost.ErdosRado
