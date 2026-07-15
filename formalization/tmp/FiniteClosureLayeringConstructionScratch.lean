import Erdos593.Graph.FiniteClosureLayering
import Mathlib.Data.Finset.Max
import Mathlib.Order.WellFounded
import Mathlib.SetTheory.Cardinal.Basic
import Mathlib.SetTheory.Cardinal.Arithmetic

/-!
# Scratch: constructing finite closure layerings from a closed small cover

The main point of this file is deliberately local: a monotone cover by
small, `Φ`-closed sets gives a `FiniteClosureLayering` by ranking a point at
the first set in which it appears.  This avoids any hidden regular-cardinal
argument.  A later wrapper may produce the cover by countable finite closure
iterations.
-/

open Set
open scoped Ordinal

namespace Erdos593
namespace FiniteClosureLayeringConstructionScratch

universe u

variable {V I : Type u}

/-- The least index of a member of a well-founded cover containing `x`. -/
noncomputable def firstRank [LinearOrder I] [WellFoundedLT I]
    (C : I → Set V) (hcover : ∀ x : V, ∃ i : I, x ∈ C i) (x : V) : I :=
  wellFounded_lt.min {i | x ∈ C i} (by
    rcases hcover x with ⟨i, hi⟩
    exact ⟨i, hi⟩)

theorem firstRank_mem [LinearOrder I] [WellFoundedLT I]
    (C : I → Set V) (hcover : ∀ x : V, ∃ i : I, x ∈ C i) (x : V) :
    x ∈ C (firstRank C hcover x) := by
  unfold firstRank
  exact wellFounded_lt.min_mem {i : I | x ∈ C i} _

theorem firstRank_le_of_mem [LinearOrder I] [WellFoundedLT I]
    (C : I → Set V) (hcover : ∀ x : V, ∃ i : I, x ∈ C i)
    {x : V} {i : I} (hx : x ∈ C i) :
    firstRank C hcover x ≤ i := by
  apply le_of_not_gt
  unfold firstRank
  exact wellFounded_lt.not_lt_min {j : I | x ∈ C j} hx

/--
A monotone, small, `Φ`-closed cover produces a finite closure layering.

The condition `0 < r` is essential: when `r = 0`, the defining closure
condition would impose a constraint on the output on the empty input below
every rank, which generally cannot hold for an ordinal-style rank order.
-/
theorem exists_finiteClosureLayering_of_closed_cover
    [LinearOrder I] [WellFoundedLT I]
    {r : ℕ} (Φ : {s : Finset V // s.card = r} → Finset V)
    (C : I → Set V)
    (hcover : ∀ x : V, ∃ i : I, x ∈ C i)
    (hmono : Monotone C)
    (hsmall : ∀ i : I, Cardinal.mk (C i) < Cardinal.mk V)
    (hclosed : ∀ (i : I) (s : Finset V) (hs : s.card = r),
      (∀ x ∈ s, x ∈ C i) → ∀ y ∈ Φ ⟨s, hs⟩, y ∈ C i)
    (hr : 0 < r) :
    ∃ L : FiniteClosureLayering r Φ I, L.rank = firstRank C hcover := by
  classical
  refine ⟨{ rank := firstRank C hcover
            fiber_lt := ?_
            earlier_closed := ?_ }, rfl⟩
  · intro i
    apply (Cardinal.mk_subtype_le_of_subset ?_).trans_lt (hsmall i)
    intro x hx
    change firstRank C hcover x = i at hx
    rw [← hx]
    exact firstRank_mem C hcover x
  · intro v s hs hlt
    have hspos : 0 < s.card := by
      simpa only [hs] using hr
    obtain ⟨m, hm, hmax⟩ :=
      Finset.exists_max_image s (firstRank C hcover) (Finset.card_pos.mp hspos)
    intro y hy
    have hsC : ∀ x ∈ s, x ∈ C (firstRank C hcover m) := by
      intro x hx
      exact hmono (hmax x hx) (firstRank_mem C hcover x)
    have hyC : y ∈ C (firstRank C hcover m) :=
      hclosed _ s hs hsC y hy
    exact (firstRank_le_of_mem C hcover hyC).trans_lt (hlt m hm)

/--
An ordinal-indexed version of `exists_finiteClosureLayering_of_closed_cover`.

`Hull` may be any monotone hull operation.  It is enough to know that it maps
each `< κ` seed to a `< κ` set and is closed under `Φ`; this is precisely the
form in which the finite/countable closure calculation should be supplied.
The proof uses only smallness of individual initial segments of `κ.ord`, so it
is valid at singular cardinals as well.
-/
theorem exists_finiteClosureLayering_of_small_hull
    {κ : Cardinal.{u}}
    {r : ℕ} (Φ : {s : Finset V // s.card = r} → Finset V)
    (hκ : Cardinal.aleph0 ≤ κ) (hV : Cardinal.mk V = κ)
    (Hull : Set V → Set V)
    (hHull_mono : Monotone Hull)
    (hHull_contains : ∀ S : Set V, S ⊆ Hull S)
    (hHull_small : ∀ S : Set V, Cardinal.mk S < κ → Cardinal.mk (Hull S) < κ)
    (hHull_closed : ∀ (S : Set V) (s : Finset V) (hs : s.card = r),
      (∀ x ∈ s, x ∈ Hull S) → ∀ y ∈ Φ ⟨s, hs⟩, y ∈ Hull S)
    (hr : 0 < r) :
    Nonempty (FiniteClosureLayering r Φ κ.ord.ToType) := by
  classical
  have hκtype : Cardinal.mk κ.ord.ToType = κ := by
    simp
  let e : V ≃ κ.ord.ToType :=
    Classical.choice (Cardinal.eq.mp (hV.trans hκtype.symm))
  refine ⟨(exists_finiteClosureLayering_of_closed_cover Φ
      (fun i : κ.ord.ToType => Hull (e.symm '' Set.Iic i)) ?_ ?_ ?_ ?_ hr).choose⟩
  · intro x
    refine ⟨e x, hHull_contains _ ?_⟩
    refine ⟨e x, ?_, e.symm_apply_apply x⟩
    change e x ≤ e x
    exact le_rfl
  · intro i j hij
    apply hHull_mono
    rintro x ⟨a, ha, rfl⟩
    exact ⟨a, ha.trans hij, rfl⟩
  · intro i
    rw [hV]
    apply hHull_small
    rw [Cardinal.mk_image_eq e.symm.injective]
    have horder : Cardinal.ord (Cardinal.mk κ.ord.ToType) = typeLT κ.ord.ToType := by
      rw [hκtype]
      exact (Ordinal.type_toType κ.ord).symm
    have htype : Cardinal.aleph0 ≤ Cardinal.mk κ.ord.ToType := by
      rwa [hκtype]
    exact (Cardinal.mk_Iic_lt i horder htype).trans_eq hκtype
  · intro i s hs hsC y hy
    exact hHull_closed _ s hs hsC y hy

end FiniteClosureLayeringConstructionScratch
end Erdos593
