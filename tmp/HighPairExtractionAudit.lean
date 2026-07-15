import Erdos593.TripleSystem.HighPairGraph

namespace Erdos593

universe u v

namespace TripleSystem

/-- Scratch API audit: a complete high-pair grid noncomputably supplies the
pair-codegree reservoirs needed by the matrix assembly theorem. -/
noncomputable def pairCodegreeWitnesses_of_highPairs
    {W : Type u} {D : Type v} {H : TripleSystem W D}
    {n T : Nat} (left right : Fin n ↪ W)
    (hhigh : ∀ i j, HighPair H T (left i) (right j)) :
    ∀ i j, PairCodegreeWitness H (left i) (right j) T :=
  fun i j => Classical.choice (hhigh i j).2

/-- Proposition-valued version of the same extraction, for use when the
chosen family need not be named. -/
theorem nonempty_pairCodegreeWitnesses_of_highPairs
    {W : Type u} {D : Type v} {H : TripleSystem W D}
    {n T : Nat} (left right : Fin n ↪ W)
    (hhigh : ∀ i j, HighPair H T (left i) (right j)) :
    Nonempty (∀ i j, PairCodegreeWitness H (left i) (right j) T) := by
  exact ⟨pairCodegreeWitnesses_of_highPairs left right hhigh⟩

/-- Scratch API audit: the distinctness component of the high-pair grid is
exactly the left/right core-disjointness required by matrix assembly. -/
theorem core_disjoint_of_highPairs
    {W : Type u} {D : Type v} {H : TripleSystem W D}
    {n T : Nat} (left right : Fin n ↪ W)
    (hhigh : ∀ i j, HighPair H T (left i) (right j)) :
    ∀ i j, left i ≠ right j := by
  intro i j
  exact (hhigh i j).1

end TripleSystem

end Erdos593
