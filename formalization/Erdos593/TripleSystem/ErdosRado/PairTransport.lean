import Erdos593.TripleSystem.CardinalPairPartition

/-!
# Pair-colouring transport for the Erdos--Rado plan

This module isolates the same-universe reindexing facts used to transport
pair colourings and homogeneous vertex sets across an equivalence. It makes
no Erdos--Rado assertion.
-/

namespace Erdos593
namespace TripleSystem
namespace TriangleHost

universe u

/-- Equivalences transport the project's two-element pair faces. -/
def pairEquiv {α β : Type u} (e : α ≃ β) : Pair α ≃ Pair β :=
  e.finsetCongr.subtypeEquiv (by
    intro s
    simp [Equiv.finsetCongr_apply])

@[simp] theorem coe_pairEquiv {α β : Type u} (e : α ≃ β) (p : Pair α) :
    ((pairEquiv e p).1 : Set β) = e '' (p.1 : Set α) := by
  change ((Set.powersetCard.map 2 e.toEmbedding p).1 : Set β) = _
  exact Set.powersetCard.coe_map 2 e.toEmbedding p

/-- Pull a pair colouring forward along an equivalence. -/
def transportedColor {α β : Type u} (e : α ≃ β) (c : Pair α → ℕ) : Pair β → ℕ :=
  fun q => c ((pairEquiv e).symm q)

/-- Pair homogeneity is preserved when its vertex set is mapped along an
equivalence. -/
theorem pairHomogeneous_image {α β : Type u} (e : α ≃ β) (c : Pair α → ℕ)
    (H : Set α) (h : PairHomogeneous c H) :
    PairHomogeneous (transportedColor e c) (e '' H) := by
  intro p q hp hq
  change c ((pairEquiv e).symm p) = c ((pairEquiv e).symm q)
  apply h
  · change ((pairEquiv e.symm p).1 : Set α) ⊆ H
    rw [coe_pairEquiv]
    rintro x ⟨y, hpy, rfl⟩
    rcases hp hpy with ⟨z, hz, hzy⟩
    rw [← hzy]
    simpa using hz
  · change ((pairEquiv e.symm q).1 : Set α) ⊆ H
    rw [coe_pairEquiv]
    rintro x ⟨y, hqy, rfl⟩
    rcases hq hqy with ⟨z, hz, hzy⟩
    rw [← hzy]
    simpa using hz

/-- The image of a set under a same-universe equivalence has the same
cardinality. Cross-universe uses require explicit cardinal lifts. -/
theorem mk_image_eq_of_equiv {α β : Type u} (e : α ≃ β) (H : Set α) :
    Cardinal.mk (e '' H) = Cardinal.mk H :=
  Cardinal.mk_image_eq e.injective

end TriangleHost
end TripleSystem
end Erdos593
