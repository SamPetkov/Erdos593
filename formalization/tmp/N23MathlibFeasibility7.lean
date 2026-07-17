import Erdos593.TripleSystem.TriangleHostRamsey

namespace Erdos593.TripleSystem.TriangleHost

def PairHomogeneous {κ : Type u} (c : Pair κ → ℕ) (H : Set κ) : Prop :=
  ∀ p q : Pair κ, (p.1 : Set κ) ⊆ H → (q.1 : Set κ) ⊆ H → c p = c q

theorem pairRamseyTriangle_of_infinite_pair_homogeneous
    {κ : Type u} [DecidableEq κ]
    (h : ∀ c : Pair κ → ℕ, ∃ H : Set κ, H.Infinite ∧ PairHomogeneous c H) :
    PairRamseyTriangle κ := by
  intro c
  obtain ⟨H, hHinf, hHmono⟩ := h c
  obtain ⟨t, htH, htcard⟩ := hHinf.exists_subset_card_eq 3
  refine ⟨⟨t, htcard⟩, ?_⟩
  intro p q hp hq
  have hp' : (p.1 : Set κ) ⊆ (t : Set κ) := by simpa using hp
  have hq' : (q.1 : Set κ) ⊆ (t : Set κ) := by simpa using hq
  exact hHmono p q (hp'.trans htH) (hq'.trans htH)

end Erdos593.TripleSystem.TriangleHost
