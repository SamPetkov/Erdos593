import Mathlib.Order.WellFounded

/-!
# Scratch prototype: a generic well-founded least-candidate selector

This file is deliberately non-production infrastructure.  It only exposes a
generic least-element API for an inhabited predicate over a well-founded
linear order.  In particular, it makes no Erdős--Rado or partition assertion.
-/

namespace Erdos593
namespace Prototype

universe u v

variable {A : Type u} {I : Type v}

/-- Choose the least `i` satisfying `R a i`, using the supplied existence
witness and the well-founded strict order on `I`. -/
noncomputable def leastCandidate [LinearOrder I] [WellFoundedLT I]
    (R : A → I → Prop) (hexists : ∀ a, ∃ i, R a i) (a : A) : I :=
  wellFounded_lt.min {i | R a i} (by
    rcases hexists a with ⟨i, hi⟩
    exact ⟨i, hi⟩)

/-- The selected candidate satisfies the eligibility predicate. -/
theorem leastCandidate_mem [LinearOrder I] [WellFoundedLT I]
    (R : A → I → Prop) (hexists : ∀ a, ∃ i, R a i) (a : A) :
    R a (leastCandidate R hexists a) := by
  unfold leastCandidate
  exact wellFounded_lt.min_mem {i : I | R a i} _

/-- The selected candidate is no greater than every eligible candidate. -/
theorem leastCandidate_le_of_mem [LinearOrder I] [WellFoundedLT I]
    (R : A → I → Prop) (hexists : ∀ a, ∃ i, R a i)
    {a : A} {i : I} (hi : R a i) :
    leastCandidate R hexists a ≤ i := by
  apply le_of_not_gt
  unfold leastCandidate
  exact wellFounded_lt.not_lt_min {j : I | R a j} hi

/-- An eligible lower bound for all eligible candidates is the selected one. -/
theorem eq_leastCandidate_of_mem_of_le [LinearOrder I] [WellFoundedLT I]
    (R : A → I → Prop) (hexists : ∀ a, ∃ i, R a i)
    {a : A} {i : I} (hi : R a i) (hmin : ∀ j, R a j → i ≤ j) :
    i = leastCandidate R hexists a := by
  apply le_antisymm
  · exact hmin _ (leastCandidate_mem R hexists a)
  · exact leastCandidate_le_of_mem R hexists hi

/-- Characterization of the selected candidate by eligibility and leastness. -/
theorem eq_leastCandidate_iff [LinearOrder I] [WellFoundedLT I]
    (R : A → I → Prop) (hexists : ∀ a, ∃ i, R a i)
    {a : A} {i : I} :
    i = leastCandidate R hexists a ↔
      R a i ∧ ∀ j, R a j → i ≤ j := by
  constructor
  · intro h
    subst i
    exact ⟨leastCandidate_mem R hexists a,
      fun j hj => leastCandidate_le_of_mem R hexists hj⟩
  · rintro ⟨hi, hmin⟩
    exact eq_leastCandidate_of_mem_of_le R hexists hi hmin

end Prototype
end Erdos593
