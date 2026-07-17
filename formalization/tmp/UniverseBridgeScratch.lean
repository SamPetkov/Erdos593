import Erdos593.TripleSystem.TriangleHostLinearity
import Erdos593.TripleSystem.Isomorph

#check Set.ncard_image_of_injective
#check Equiv.ulift
#check Equiv.ulift.{1, 0}
#check ULift.up
#check ULift.down

namespace Erdos593
namespace TripleSystem

universe u v u' v' w

variable {V : Type u} {E : Type v} {V' : Type u'} {E' : Type v'}

def reindex (F : TripleSystem V E) (vertexEquiv : V ≃ V')
    (edgeEquiv : E ≃ E') : TripleSystem V' E' where
  Inc x e := F.Inc (vertexEquiv.symm x) (edgeEquiv.symm e)
  edge_ncard := by
    intro e
    let s : Set V' := {x | F.Inc (vertexEquiv.symm x) (edgeEquiv.symm e)}
    have hs : s = vertexEquiv '' F.edgeSet (edgeEquiv.symm e) := by
      ext x
      constructor
      · intro hx
        exact ⟨vertexEquiv.symm x, hx, vertexEquiv.apply_symm_apply x⟩
      · rintro ⟨y, hy, rfl⟩
        simpa using hy
    change s.ncard = 3
    rw [hs, Set.ncard_image_of_injective _ vertexEquiv.injective]
    exact F.edgeSet_ncard _
  simple := by
    intro e₁ e₂ h
    apply edgeEquiv.injective
    apply F.edgeSet_injective
    ext x
    have hx := Set.ext_iff.mp h (vertexEquiv x)
    simpa [TripleSystem.edgeSet] using hx

theorem reindex_inc_iff (F : TripleSystem V E) (vertexEquiv : V ≃ V')
    (edgeEquiv : E ≃ E') (x : V) (e : E) :
    (reindex F vertexEquiv edgeEquiv).Inc (vertexEquiv x) (edgeEquiv e) ↔ F.Inc x e := by
  simp [reindex]

end TripleSystem
end Erdos593
