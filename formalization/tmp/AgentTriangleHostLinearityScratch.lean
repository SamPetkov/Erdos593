import Erdos593.TripleSystem.Basic

/-!
# Scratch prototype: the finite triangle host

Vertices are two-element subsets of `V`; hyperedges are three-element subsets
of `V`; incidence is inclusion.  This file is intentionally untracked and
contains only the finite local layer needed before any chromatic/Ramsey work.
-/

namespace Erdos593
namespace TriangleHostScratch

universe u

variable (V : Type u) [DecidableEq V]

abbrev Pair := Set.powersetCard V 2
abbrev Triangle := Set.powersetCard V 3

/-- The three two-element faces of a triangle. -/
private def faces (t : Triangle V) : Finset (Pair V) :=
  (t.1.powersetCard 2).attach.map
    { toFun := fun s =>
        ⟨s.1, (Finset.mem_powersetCard.mp s.2).2⟩
      inj' := by
        intro a b hab
        apply Subtype.ext
        exact congrArg Subtype.val hab }

private theorem mem_faces_iff (t : Triangle V) (p : Pair V) :
    p ∈ faces t ↔ p.1 ⊆ t.1 := by
  constructor
  · intro hp
    rcases Finset.mem_map.mp hp with ⟨s, hs, hsp⟩
    rw [← hsp]
    exact (Finset.mem_powersetCard.mp s.2).1
  · intro hp
    let s : {s : Finset V // s ∈ t.1.powersetCard 2} :=
      ⟨p.1, Finset.mem_powersetCard.mpr ⟨hp, p.2⟩⟩
    have hs : s ∈ (t.1.powersetCard 2).attach := Finset.mem_attach _ _
    apply Finset.mem_map.mpr
    refine ⟨s, hs, ?_⟩
    apply Subtype.ext
    rfl

private theorem card_faces (t : Triangle V) : (faces t).card = 3 := by
  simp [faces, Finset.card_powersetCard, t.2]

private theorem pair_containing_of_mem (t : Triangle V) {v : V} (hv : v ∈ t.1) :
    ∃ p : Pair V, v ∈ p.1 ∧ p.1 ⊆ t.1 := by
  rcases Finset.card_eq_three.mp t.2 with ⟨a, b, c, hab, hac, hbc, ht⟩
  rw [ht] at hv ⊢
  simp only [Finset.mem_insert, Finset.mem_singleton] at hv
  rcases hv with rfl | rfl | rfl
  · refine ⟨⟨{a, b}, by simp [hab]⟩, ?_, ?_⟩ <;> simp
  · refine ⟨⟨{a, b}, by simp [hab]⟩, ?_, ?_⟩ <;> simp
  · refine ⟨⟨{a, c}, by simp [hac]⟩, ?_, ?_⟩ <;> simp

/-- The 3-uniform hypergraph of triangles in `V`, with pair-vertices. -/
def triangleHost : TripleSystem (Pair V) (Triangle V) where
  Inc p t := p.1 ⊆ t.1
  edge_ncard := by
    intro t
    change Set.ncard {p : Pair V | p.1 ⊆ t.1} = 3
    rw [show {p : Pair V | p.1 ⊆ t.1} = (faces t : Set (Pair V)) by
      ext p
      exact mem_faces_iff t p |>.symm]
    simpa using card_faces t
  simple := by
    intro t u htu
    apply Subtype.ext
    apply Finset.eq_of_subset_of_card_le
    · intro v hv
      obtain ⟨p, hvp, hpt⟩ := pair_containing_of_mem t hv
      have hpu : p.1 ⊆ u.1 := by
        have hp : p ∈ {p : Pair V | p.1 ⊆ u.1} := by
          rw [← htu]
          exact hpt
        exact hp
      exact hpu hvp
    · omega

/-- Distinct triangle edges share at most one pair-vertex. -/
theorem triangleHost_linear : (triangleHost V).Linear := by
  intro e f x y hef hxe hxf hye hyf
  change x.1 ⊆ e.1 at hxe hxf
  change y.1 ⊆ e.1 at hye hyf
  by_contra hxy
  apply hef
  apply Subtype.ext
  let u := x.1 ∪ y.1
  have hue : u ⊆ e.1 := Finset.union_subset hxe hye
  have huf : u ⊆ f.1 := Finset.union_subset hxf hyf
  have hu_le_three : u.card ≤ 3 := by
    have := Finset.card_le_card hue
    omega
  have hx_le_u : x.1.card ≤ u.card := Finset.card_le_card Finset.subset_union_left
  have hu_eq_three : u.card = 3 := by
    by_contra hu_ne
    have hu_le_two : u.card ≤ 2 := by omega
    have hx_eq_u : x.1 = u := by
      apply Finset.eq_of_subset_of_card_le Finset.subset_union_left
      omega
    have hy_eq_u : y.1 = u := by
      apply Finset.eq_of_subset_of_card_le Finset.subset_union_right
      omega
    apply hxy
    apply Subtype.ext
    exact hx_eq_u.trans hy_eq_u.symm
  have hu_eq_e : u = e.1 := by
    apply Finset.eq_of_subset_of_card_le hue
    omega
  have hu_eq_f : u = f.1 := by
    apply Finset.eq_of_subset_of_card_le huf
    omega
  exact hu_eq_e.symm.trans hu_eq_f

end TriangleHostScratch
end Erdos593
