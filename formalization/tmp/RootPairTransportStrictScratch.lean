import Erdos593.TripleSystem.CardinalPairPartition

namespace Erdos593.TripleSystem.TriangleHost.PairTransportScratch

universe u

def pairEquiv {A B : Type u} (e : Equiv A B) : Pair A ≃ Pair B :=
  e.finsetCongr.subtypeEquiv (by
    intro s
    simp [Equiv.finsetCongr_apply])

@[simp] theorem coe_pairEquiv {A B : Type u} (e : Equiv A B) (p : Pair A) :
    ((pairEquiv e p).1 : Set B) = e '' (p.1 : Set A) := by
  change ((Set.powersetCard.map 2 e.toEmbedding p).1 : Set B) = _
  simp

def transportedColor {A B : Type u} (e : Equiv A B) (c : Pair A -> Nat) : Pair B -> Nat :=
  fun q => c ((pairEquiv e).symm q)

theorem pairHomogeneous_image {A B : Type u} (e : Equiv A B) (c : Pair A -> Nat)
    (H : Set A) (h : PairHomogeneous c H) :
    PairHomogeneous (transportedColor e c) (e '' H) := by
  intro p q hp hq
  change c ((pairEquiv e).symm p) = c ((pairEquiv e).symm q)
  apply h
  · change ((pairEquiv e.symm p).1 : Set A) ⊆ H
    rw [coe_pairEquiv]
    rintro x ⟨y, hpy, rfl⟩
    rcases hp hpy with ⟨z, hz, hzy⟩
    rw [← hzy]
    simpa using hz
  · change ((pairEquiv e.symm q).1 : Set A) ⊆ H
    rw [coe_pairEquiv]
    rintro x ⟨y, hqy, rfl⟩
    rcases hq hqy with ⟨z, hz, hzy⟩
    rw [← hzy]
    simpa using hz

end Erdos593.TripleSystem.TriangleHost.PairTransportScratch
