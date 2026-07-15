import Erdos593.TripleSystem.SequenceLift
import Erdos593.TripleSystem.EdgeRestriction

/-!
# Linear trace uniqueness for sequence lifts

In a linear edge restriction, two sequence-lifted edges with the same
base trace and base pair must coincide.  This is the local rigidity fact
needed for the finite-trace decomposition.
-/

namespace Erdos593

open scoped Cardinal Ordinal

universe u

namespace SequenceLift

variable {V : Type u} {G : _root_.SimpleGraph V}

/-- In a linear restriction, two lifted edges extending the same trace by the
same base edge cannot differ. -/
theorem mkEdge_eq_of_same_basePair_of_linearTrace
    {S : Set (Edge G)}
    (hlin : ((system G).edgeRestriction S).Linear)
    {q t₁ t₂ : Node G} {x y z₁ z₂ : V}
    {hxy : G.Adj x y}
    {hext₁ : q.ExtendsBy (edgeLetter hxy) t₁}
    {hext₂ : q.ExtendsBy (edgeLetter hxy) t₂}
    (hmem₁ : mkEdge q t₁ x y z₁ hxy hext₁ ∈ S)
    (hmem₂ : mkEdge q t₂ x y z₂ hxy hext₂ ∈ S) :
    mkEdge q t₁ x y z₁ hxy hext₁ =
      mkEdge q t₂ x y z₂ hxy hext₂ := by
  let e₁ : S := ⟨mkEdge q t₁ x y z₁ hxy hext₁, hmem₁⟩
  let e₂ : S := ⟨mkEdge q t₂ x y z₂ hxy hext₂, hmem₂⟩
  let pₓ : (system G).EdgeSupport S :=
    ⟨(q, x), ⟨mkEdge q t₁ x y z₁ hxy hext₁, hmem₁,
      (inc_mkEdge_iff.mpr (Or.inl rfl))⟩⟩
  let pᵧ : (system G).EdgeSupport S :=
    ⟨(q, y), ⟨mkEdge q t₁ x y z₁ hxy hext₁, hmem₁,
      (inc_mkEdge_iff.mpr (Or.inr (Or.inl rfl)))⟩⟩
  have hpx₁ : ((system G).edgeRestriction S).Inc pₓ e₁ := by
    change (system G).Inc (q, x) (mkEdge q t₁ x y z₁ hxy hext₁)
    exact inc_mkEdge_iff.mpr (Or.inl rfl)
  have hpx₂ : ((system G).edgeRestriction S).Inc pₓ e₂ := by
    change (system G).Inc (q, x) (mkEdge q t₂ x y z₂ hxy hext₂)
    exact inc_mkEdge_iff.mpr (Or.inl rfl)
  have hpy₁ : ((system G).edgeRestriction S).Inc pᵧ e₁ := by
    change (system G).Inc (q, y) (mkEdge q t₁ x y z₁ hxy hext₁)
    exact inc_mkEdge_iff.mpr (Or.inr (Or.inl rfl))
  have hpy₂ : ((system G).edgeRestriction S).Inc pᵧ e₂ := by
    change (system G).Inc (q, y) (mkEdge q t₂ x y z₂ hxy hext₂)
    exact inc_mkEdge_iff.mpr (Or.inr (Or.inl rfl))
  have heq : e₁ = e₂ := by
    by_contra hne
    have hp : pₓ = pᵧ := hlin hne hpx₁ hpx₂ hpy₁ hpy₂
    apply hxy.ne
    exact congrArg Prod.snd (congrArg Subtype.val hp)
  simpa only [e₁, e₂] using congrArg Subtype.val heq

end SequenceLift

end Erdos593
