import Erdos593.TripleSystem.TriangleHostRamseyChromatic
import Erdos593.TripleSystem.NonlinearObstruction

namespace Erdos593

open scoped Cardinal

universe u v u' v'

namespace TripleSystem

variable {V : Type u} {E : Type v} {V' : Type u'} {E' : Type v'}

def auditReindex (F : TripleSystem V E) (vertexEquiv : Equiv V V')
    (edgeEquiv : Equiv E E') : TripleSystem V' E' where
  Inc x e := F.Inc (vertexEquiv.symm x) (edgeEquiv.symm e)
  edge_ncard := by
    intro e
    let s : Set V' := {x | F.Inc (vertexEquiv.symm x) (edgeEquiv.symm e)}
    have hs : s = vertexEquiv '' F.edgeSet (edgeEquiv.symm e) := by
      ext x
      constructor
      · intro hx
        refine ⟨vertexEquiv.symm x, ?_, vertexEquiv.apply_symm_apply x⟩
        simpa [s, TripleSystem.edgeSet] using hx
      · rintro ⟨y, hy, rfl⟩
        simpa [s, TripleSystem.edgeSet] using hy
    change s.ncard = 3
    rw [hs, Set.ncard_image_of_injective _ vertexEquiv.injective]
    exact F.edgeSet_ncard _
  simple := by
    intro e1 e2 h
    apply edgeEquiv.symm.injective
    apply F.edgeSet_injective
    ext x
    have hx := Set.ext_iff.mp h (vertexEquiv x)
    simpa [TripleSystem.edgeSet] using hx

theorem auditReindex_linear (F : TripleSystem V E) (vertexEquiv : Equiv V V')
    (edgeEquiv : Equiv E E') (hF : F.Linear) :
    (auditReindex F vertexEquiv edgeEquiv).Linear := by
  intro e f x y hef hxe hxf hye hyf
  change F.Inc (vertexEquiv.symm x) (edgeEquiv.symm e) at hxe
  change F.Inc (vertexEquiv.symm x) (edgeEquiv.symm f) at hxf
  change F.Inc (vertexEquiv.symm y) (edgeEquiv.symm e) at hye
  change F.Inc (vertexEquiv.symm y) (edgeEquiv.symm f) at hyf
  apply vertexEquiv.symm.injective
  apply hF (by
    intro h
    apply hef
    simpa using congrArg edgeEquiv h) hxe hxf hye hyf

namespace TriangleHost

def auditExactSystem (kappa : Type) [DecidableEq kappa] :
    TripleSystem (ULift.{u} (Pair kappa)) (ULift.{v} (Triangle kappa)) :=
  auditReindex (system kappa)
    (Equiv.ulift.symm : Pair kappa ≃ ULift.{u} (Pair kappa))
    (Equiv.ulift.symm : Triangle kappa ≃ ULift.{v} (Triangle kappa))

theorem auditExactSystem_linear (kappa : Type) [DecidableEq kappa] :
    (auditExactSystem.{u, v} kappa).Linear :=
  auditReindex_linear (system kappa)
    (Equiv.ulift.symm : Pair kappa ≃ ULift.{u} (Pair kappa))
    (Equiv.ulift.symm : Triangle kappa ≃ ULift.{v} (Triangle kappa)) (linear kappa)

theorem audit_baseProper_of_exactProper
    (kappa : Type) [DecidableEq kappa]
    (c : ULift.{u} (Pair kappa) -> ULift.{u} Nat)
    (hc : (auditExactSystem.{u, v} kappa).IsProperColoring c) :
    (system kappa).IsProperColoring (fun p => (c (ULift.up p)).down) := by
  intro e
  rcases hc (ULift.up e) with ⟨x, hx, y, hy, hxy⟩
  refine ⟨x.down, ?_, y.down, ?_, ?_⟩
  · simpa [auditExactSystem, auditReindex] using hx
  · simpa [auditExactSystem, auditReindex] using hy
  · intro hdown
    apply hxy
    exact ULift.ext _ _ hdown

theorem audit_aleph0_lt_exactSystem_chromaticCardinal
    (kappa : Type) [DecidableEq kappa]
    (hRamsey : PairRamseyTriangle kappa) :
    Cardinal.aleph0 < (auditExactSystem.{u, v} kappa).chromaticCardinal := by
  by_contra hnot
  have hle : (auditExactSystem.{u, v} kappa).chromaticCardinal <= Cardinal.aleph0 :=
    le_of_not_gt hnot
  have hle' : (auditExactSystem.{u, v} kappa).chromaticCardinal <= #(ULift.{u} Nat) := by
    simpa using hle
  obtain ⟨c, hc⟩ :=
    ((auditExactSystem.{u, v} kappa).chromaticCardinal_le_mk_iff
      (C := ULift.{u} Nat)).mp hle'
  exact not_isProperColoring_nat_of_pairRamseyTriangle kappa hRamsey _
    (audit_baseProper_of_exactProper kappa c hc)

theorem audit_not_isObligatory_of_not_linear_of_exactTriangleHost
    {V : Type u} {E : Type v} (F : TripleSystem V E)
    (hnotlinear : Not F.Linear) (kappa : Type) [DecidableEq kappa]
    (hRamsey : PairRamseyTriangle kappa) : Not F.IsObligatory := by
  exact not_isObligatory_of_not_linear_of_linear_highChromatic
    (F := F) (H := auditExactSystem.{u, v} kappa)
    hnotlinear
    (auditExactSystem_linear kappa)
    (audit_aleph0_lt_exactSystem_chromaticCardinal kappa hRamsey)

end TriangleHost
end TripleSystem
end Erdos593
