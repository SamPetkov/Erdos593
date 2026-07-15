import Mathlib.SetTheory.Cardinal.Ordinal
import Mathlib.SetTheory.Cardinal.Arithmetic
import Mathlib.Data.Finset.Image

open Set

namespace ClosureCardinalityScratch

universe u

variable {V : Type u}

def iterUnion (f : Set V → Set V) (S : Set V) : Set V :=
  ⋃ n : Nat, (f^[n]) S

def admissible (r : Nat) (S : Set V) : Type u :=
  {s : Finset V // s.card = r ∧ ∀ x ∈ s, x ∈ S}

def output (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V)
    {S : Set V} (s : admissible r S) : Set V :=
  ((Φ ⟨s.1, s.2.1⟩ : Finset V) : Set V)

def closureStep (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) : Set V :=
  S ∪ ⋃ s : admissible r S, output r Φ s

theorem mem_closureStep_iff
    (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) (x : V) :
    x ∈ closureStep r Φ S ↔ x ∈ S ∨
      ∃ s : {s : Finset V // s.card = r},
        (∀ z ∈ s.1, z ∈ S) ∧ x ∈ Φ s := by
  simp only [closureStep, Set.mem_union, Set.mem_iUnion]
  constructor
  · rintro (hx | ⟨⟨a, ha, hinside⟩, hx⟩)
    · exact Or.inl hx
    · refine Or.inr ⟨⟨a, ha⟩, hinside, ?_⟩
      simpa [output] using hx
  · rintro (hx | ⟨s, hinside, hx⟩)
    · exact Or.inl hx
    · refine Or.inr ⟨⟨s.1, s.2, hinside⟩, ?_⟩
      simpa [output] using hx

theorem closureStep_mono
    (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V) :
    Monotone (closureStep r Φ) := by
  intro S T hST x hx
  rw [mem_closureStep_iff] at hx
  rw [mem_closureStep_iff]
  rcases hx with hx | ⟨s, hinside, hx⟩
  · exact Or.inl (hST hx)
  · exact Or.inr ⟨s, fun z hz => hST (hinside z hz), hx⟩

theorem mk_admissible_le_finset (r : Nat) (S : Set V) :
    Cardinal.mk (admissible r S) ≤ Cardinal.mk (Finset S) := by
  classical
  calc
    Cardinal.mk (admissible r S) ≤
        Cardinal.mk {s : Finset V // ∀ x ∈ s, x ∈ S} :=
      Cardinal.mk_subtype_le_of_subset fun _ hs => hs.2
    _ = Cardinal.mk (Finset S) :=
      (Cardinal.mk_congr (Equiv.finsetSubtypeComm fun x : V => x ∈ S)).symm

theorem mk_admissible_le
    (r : Nat) (S : Set V) (c : Cardinal.{u})
    (hc : Cardinal.aleph0 ≤ c) (hS : Cardinal.mk S ≤ c) :
    Cardinal.mk (admissible r S) ≤ c := by
  classical
  calc
    Cardinal.mk (admissible r S) ≤ Cardinal.mk (Finset S) :=
      mk_admissible_le_finset r S
    _ ≤ Cardinal.mk (List S) :=
      Cardinal.mk_le_of_surjective List.toFinset_surjective
    _ ≤ max Cardinal.aleph0 (Cardinal.mk S) := Cardinal.mk_list_le_max S
    _ ≤ c := max_le hc hS

theorem mk_closureStep_le
    (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) (c : Cardinal.{u})
    (hc : Cardinal.aleph0 ≤ c) (hS : Cardinal.mk S ≤ c) :
    Cardinal.mk (closureStep r Φ S) ≤ c := by
  classical
  have houtputOne (s : admissible r S) : Cardinal.mk (output r Φ s) ≤ c := by
    change Cardinal.mk ((Φ ⟨s.1, s.2.1⟩ : Finset V) : Set V) ≤ c
    exact (Cardinal.finset_card_lt_aleph0 (Φ ⟨s.1, s.2.1⟩)).le.trans hc
  have houtput :
      Cardinal.mk (⋃ s : admissible r S, output r Φ s) ≤ c := by
    calc
      Cardinal.mk (⋃ s : admissible r S, output r Φ s) ≤
          Cardinal.mk (admissible r S) *
            ⨆ s : admissible r S,
              Cardinal.mk (output r Φ s) := by
        exact Cardinal.mk_iUnion_le (output r Φ)
      _ ≤ c * c := by
        exact mul_le_mul' (mk_admissible_le r S c hc hS) (ciSup_le' houtputOne)
      _ = c := Cardinal.mul_eq_self hc
  calc
    Cardinal.mk (closureStep r Φ S) ≤
        Cardinal.mk S + Cardinal.mk (⋃ s : admissible r S, output r Φ s) :=
      Cardinal.mk_union_le _ _
    _ ≤ c + c := add_le_add hS houtput
    _ = c := Cardinal.add_eq_self hc

def closure (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) : Set V :=
  iterUnion (closureStep r Φ) S

theorem mk_iterUnion_le
    (f : Set V → Set V) (S : Set V) (c : Cardinal.{u})
    (hc : Cardinal.aleph0 ≤ c)
    (hstep : ∀ T : Set V, Cardinal.mk T ≤ c → Cardinal.mk (f T) ≤ c)
    (hS : Cardinal.mk S ≤ c) :
    Cardinal.mk (iterUnion f S) ≤ c := by
  have hiter : ∀ n : Nat, Cardinal.mk ((f^[n]) S) ≤ c := by
    intro n
    induction n with
    | zero => simpa using hS
    | succ n ih =>
        simpa [Function.iterate_succ_apply'] using hstep ((f^[n]) S) ih
  calc
    Cardinal.mk (iterUnion f S) ≤
        Cardinal.lift.{u} (Cardinal.mk Nat) *
          ⨆ n : Nat, Cardinal.lift.{0} (Cardinal.mk ((f^[n]) S)) := by
      simpa [iterUnion] using
        (Cardinal.mk_iUnion_le_lift (fun n : Nat => (f^[n]) S))
    _ ≤ c * c := by
      exact mul_le_mul' (by simpa using hc) (ciSup_le fun n => by simpa using hiter n)
    _ = c := Cardinal.mul_eq_self hc

theorem mk_iterUnion_lt_of_bound
    (f : Set V → Set V) (S : Set V) (c κ : Cardinal.{u})
    (hc : Cardinal.aleph0 ≤ c)
    (hcκ : c < κ)
    (hstep : ∀ T : Set V, Cardinal.mk T ≤ c → Cardinal.mk (f T) ≤ c)
    (hS : Cardinal.mk S ≤ c) :
    Cardinal.mk (iterUnion f S) < κ :=
  (mk_iterUnion_le f S c hc hstep hS).trans_lt hcκ

theorem mk_closure_le
    (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) (c : Cardinal.{u})
    (hc : Cardinal.aleph0 ≤ c) (hS : Cardinal.mk S ≤ c) :
    Cardinal.mk (closure r Φ S) ≤ c := by
  apply mk_iterUnion_le (closureStep r Φ) S c hc
  · intro T hT
    exact mk_closureStep_le r Φ T c hc hT
  · exact hS

theorem mk_closure_lt
    (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) (κ : Cardinal.{u})
    (hκ : Cardinal.aleph0 < κ) (hS : Cardinal.mk S < κ) :
    Cardinal.mk (closure r Φ S) < κ := by
  let c : Cardinal.{u} := max Cardinal.aleph0 (Cardinal.mk S)
  have hc : Cardinal.aleph0 ≤ c := le_max_left _ _
  have hSc : Cardinal.mk S ≤ c := le_max_right _ _
  have hcκ : c < κ := max_lt hκ hS
  exact (mk_closure_le r Φ S c hc hSc).trans_lt hcκ

theorem closure_mono
    (r : Nat) (Φ : {s : Finset V // s.card = r} → Finset V) :
    Monotone (closure r Φ) := by
  intro S T hST x hx
  simp only [closure, iterUnion, Set.mem_iUnion] at hx ⊢
  rcases hx with ⟨n, hx⟩
  have hiter : Monotone ((closureStep r Φ)^[n]) :=
    (closureStep_mono r Φ).iterate n
  exact ⟨n, hiter hST hx⟩

theorem mk_ordInitialImage_lt
    (κ : Cardinal.{u}) (e : κ.ord.ToType → V) (i : κ.ord.ToType) :
    Cardinal.mk (e '' Set.Iio i) < κ := by
  have hIio : Cardinal.mk (Set.Iio i) < Cardinal.mk κ.ord.ToType := by
    simpa using Cardinal.mk_Iio_lt i
  exact ((Cardinal.mk_image_le (f := e) (s := Set.Iio i)).trans_lt hIio).trans_eq
    (Cardinal.mk_ord_toType κ)

theorem mk_ordClosedInitialImage_lt
    (κ : Cardinal.{u}) (e : κ.ord.ToType → V) (i : κ.ord.ToType)
    (hκ : Cardinal.aleph0 < κ) :
    Cardinal.mk (e '' Set.Iic i) < κ := by
  have hIic : Cardinal.mk (Set.Iic i) < Cardinal.mk κ.ord.ToType := by
    simpa using Cardinal.mk_Iic_lt i (by simp) (by simpa using hκ.le)
  exact ((Cardinal.mk_image_le (f := e) (s := Set.Iic i)).trans_lt hIic).trans_eq
    (Cardinal.mk_ord_toType κ)

end ClosureCardinalityScratch
