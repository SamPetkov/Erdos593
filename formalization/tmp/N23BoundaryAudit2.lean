import Erdos593.TripleSystem.TriangleHostRamseyTransport

namespace Erdos593.TripleSystem.TriangleHostTransport

open scoped Cardinal

/-- Surface tests for the universe-exact TriangleHost transport. -/
example (κ : Type) [DecidableEq κ]
    (p : TriangleHost.Pair κ) (t : TriangleHost.Triangle κ) :
    (exactSystem.{2, 3} κ).Inc (ULift.up p) (ULift.up t) ↔
      (TriangleHost.system κ).Inc p t := by
  exact exactSystem_inc_iff.{2, 3} κ p t

example (κ : Type) [DecidableEq κ] :
    (exactSystem.{2, 3} κ).Linear := by
  exact exactSystem_linear.{2, 3} κ

example {V : Type 2} {E : Type 3}
    (F : TripleSystem V E) (hnotlinear : ¬ F.Linear)
    (κ : Type) [DecidableEq κ]
    (hRamsey : TriangleHost.PairRamseyTriangle κ) :
    ¬ F.IsObligatory :=
  not_isObligatory_of_not_linear_of_exactTriangleHost F hnotlinear κ hRamsey

end Erdos593.TripleSystem.TriangleHostTransport
