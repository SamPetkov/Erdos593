import Erdos593.TripleSystem.EdgeRestriction
import Mathlib.Data.Set.Finite.Lemmas

/-!
# Exact restriction inclusions and finite maximal extension

Candidate only. These helpers address literal support/edge transport and finite
maximal extension; they do not prove generic block splitting or running order.
-/

namespace Erdos593.TripleSystem

universe u v

variable {V : Type u} {E : Type v} (F : TripleSystem V E)

/-- Inclusion of original edge indices gives inclusion of actual point supports. -/
theorem edgeSupportSet_mono {S T : Set E} (hST : S ⊆ T) :
    F.edgeSupportSet S ⊆ F.edgeSupportSet T := by
  rintro x ⟨e, he, hxe⟩
  exact ⟨e, hST he, hxe⟩

/-- Literal subtype inclusions embed a smaller supported restriction into a
larger one; no isolated, finite, linear or obligatory premise is required. -/
def edgeRestrictionEmbeddingOfSubset {S T : Set E} (hST : S ⊆ T) :
    (F.edgeRestriction S).Embedding (F.edgeRestriction T) where
  vertex :=
    { toFun := fun x => ⟨x.1, F.edgeSupportSet_mono hST x.2⟩
      inj' := by
        intro x y h
        exact Subtype.ext (congrArg (fun z : F.EdgeSupport T => (z : V)) h) }
  edge := fun e => ⟨e.1, hST e.2⟩
  map_edge := by
    intro e
    ext x
    constructor
    · rintro ⟨y, hy, hxy⟩
      change F.Inc x.1 e.1
      have hval : y.1 = x.1 := congrArg Subtype.val hxy
      exact hval ▸ hy
    · intro hx
      change F.Inc x.1 e.1 at hx
      exact ⟨⟨x.1, e.1, e.2, hx⟩, hx, Subtype.ext rfl⟩

@[simp]
theorem edgeRestrictionEmbeddingOfSubset_vertex_coe {S T : Set E}
    (hST : S ⊆ T) (x : F.EdgeSupport S) :
    ((F.edgeRestrictionEmbeddingOfSubset hST).vertex x : V) = x.1 :=
  rfl

@[simp]
theorem edgeRestrictionEmbeddingOfSubset_edge_coe {S T : Set E}
    (hST : S ⊆ T) (e : S) :
    ((F.edgeRestrictionEmbeddingOfSubset hST).edge e : E) = e.1 :=
  rfl

namespace SupportedBlocks

/-- Any predicate on edge subsets of a finite ORIGINAL carrier has a maximal
superset of each satisfying set. Monotonicity of the predicate is NOT assumed. -/
theorem exists_maximal_set_superset [Finite E] (P : Set E → Prop)
    (S : Set E) (hS : P S) :
    ∃ T : Set E, S ⊆ T ∧ P T ∧
      ∀ U : Set E, T ⊆ U → P U → U ⊆ T := by
  classical
  let C : Set (Set E) := {T | S ⊆ T ∧ P T}
  have hC : C.Nonempty := ⟨S, Set.Subset.refl S, hS⟩
  obtain ⟨T, hT, hmax⟩ := Set.exists_max_image C Set.ncard (Set.toFinite C) hC
  refine ⟨T, hT.1, hT.2, ?_⟩
  intro U hTU hPU
  have hcard : U.ncard ≤ T.ncard := hmax U ⟨hT.1.trans hTU, hPU⟩
  exact (Set.eq_of_subset_of_ncard_le hTU hcard (Set.toFinite U)).symm.subset

end SupportedBlocks

end Erdos593.TripleSystem
