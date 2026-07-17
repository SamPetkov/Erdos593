import Erdos593.TripleSystem.CardinalPairPartition

/-!
# Scratch verification: transport of pair-colourings across an equivalence

This file is intentionally untracked.  It validates the API needed by the
Erdos--Rado carrier transport layer without changing production sources.
-/

namespace Erdos593

universe u

namespace TripleSystem
namespace TriangleHost

/-- Equivalences transport two-element finite subsets. -/
def pairEquiv {α β : Type u} (e : α ≃ β) : Pair α ≃ Pair β :=
  e.finsetCongr.subtypeEquiv (by
    intro s
    simp [Equiv.finsetCongr_apply])

@[simp] theorem coe_pairEquiv {α β : Type u} (e : α ≃ β) (p : Pair α) :
    ((pairEquiv e p).1 : Set β) = e '' (p.1 : Set α) := by
  change ((Set.powersetCard.map 2 e.toEmbedding p).1 : Set β) = _
  exact Set.powersetCard.coe_map 2 e.toEmbedding p

/-- Pull a colouring on `Pair α` forward to `Pair β` along `e`. -/
def transportedColor {α β : Type u} (e : α ≃ β) (c : Pair α → ℕ) : Pair β → ℕ :=
  fun q => c ((pairEquiv e).symm q)

/-- Homogeneity is preserved when the homogeneous vertex set is mapped along
an equivalence. -/
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

end TriangleHost
end TripleSystem
end Erdos593
