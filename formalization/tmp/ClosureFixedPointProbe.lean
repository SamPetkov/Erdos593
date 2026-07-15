import Mathlib.SetTheory.Cardinal.Ordinal
import Mathlib.SetTheory.Cardinal.Arithmetic
import Mathlib.Data.Finset.Image
import Mathlib.Data.Set.Finite.Lattice

open Set

namespace ClosureFixedPointProbe

universe u

variable {V : Type u}

def iterUnion (f : Set V -> Set V) (S : Set V) : Set V :=
  ⋃ n : Nat, (f^[n]) S

def admissible (r : Nat) (S : Set V) : Type u :=
  {s : Finset V // s.card = r ∧ ∀ x ∈ s, x ∈ S}

def output (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    {S : Set V} (s : admissible r S) : Set V :=
  ((Phi ⟨s.1, s.2.1⟩ : Finset V) : Set V)

def closureStep (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    (S : Set V) : Set V :=
  S ∪ ⋃ s : admissible r S, output r Phi s

def closure (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    (S : Set V) : Set V :=
  iterUnion (closureStep r Phi) S

theorem mem_closureStep_iff
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    (S : Set V) (x : V) :
    x ∈ closureStep r Phi S ↔ x ∈ S ∨
      ∃ s : {s : Finset V // s.card = r},
        (∀ z ∈ s.1, z ∈ S) ∧ x ∈ Phi s := by
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

theorem extensive_closureStep
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V) (S : Set V) :
    S ⊆ closureStep r Phi S := fun _ hx => Or.inl hx

theorem closureStep_mono
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V) :
    Monotone (closureStep r Phi) := by
  intro S T hST x hx
  rw [mem_closureStep_iff] at hx
  rw [mem_closureStep_iff]
  rcases hx with hx | ⟨s, hinside, hxout⟩
  · exact Or.inl (hST hx)
  · exact Or.inr ⟨s, fun z hz => hST (hinside z hz), hxout⟩

theorem iterUnion_mem_iff
    (f : Set V -> Set V) (S : Set V) (x : V) :
    x ∈ iterUnion f S ↔ ∃ n : Nat, x ∈ (f^[n]) S := by
  simp [iterUnion]

theorem iterate_stage_succ_subset
    (f : Set V -> Set V) (hExt : ∀ T : Set V, T ⊆ f T)
    (S : Set V) (n : Nat) :
    (f^[n]) S ⊆ (f^[n + 1]) S := by
  simpa [Function.iterate_succ_apply'] using hExt ((f^[n]) S)

theorem iterate_stage_mono
    (f : Set V -> Set V) (hExt : ∀ T : Set V, T ⊆ f T)
    (S : Set V) {n m : Nat} (hnm : n ≤ m) :
    (f^[n]) S ⊆ (f^[m]) S := by
  obtain ⟨d, rfl⟩ := Nat.le.dest hnm
  induction d with
  | zero => simp
  | succ d ih =>
      exact (ih (Nat.le_add_right _ _)).trans (by
        simpa [Nat.add_assoc] using iterate_stage_succ_subset f hExt S (n + d))

theorem finset_subset_iterate_stage
    (f : Set V -> Set V) (hExt : ∀ T : Set V, T ⊆ f T)
    (S : Set V) (s : Finset V) :
    (∀ x ∈ s, x ∈ iterUnion f S) ->
      ∃ n : Nat, ∀ x ∈ s, x ∈ (f^[n]) S := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      intro _
      exact ⟨0, by simp⟩
  | @insert a s ha ih =>
      intro hs
      have haUnion : a ∈ iterUnion f S := hs a (by simp)
      rcases (iterUnion_mem_iff f S a).mp haUnion with ⟨na, hna⟩
      have hsUnion : ∀ x ∈ s, x ∈ iterUnion f S := by
        intro x hx
        exact hs x (by simp [hx])
      rcases ih hsUnion with ⟨ns, hns⟩
      refine ⟨max na ns, ?_⟩
      intro x hx
      rcases Finset.mem_insert.mp hx with rfl | hx
      · exact iterate_stage_mono f hExt S (Nat.le_max_left _ _) hna
      · exact iterate_stage_mono f hExt S (Nat.le_max_right _ _) (hns x hx)

theorem finset_subset_iterate_stage_directed
    (f : Set V -> Set V) (hExt : ∀ T : Set V, T ⊆ f T)
    (S : Set V) (s : Finset V) :
    (∀ x ∈ s, x ∈ iterUnion f S) ->
      ∃ n : Nat, ∀ x ∈ s, x ∈ (f^[n]) S := by
  intro hs
  have hmono : Monotone (fun n : Nat => (f^[n]) S) :=
    monotone_nat_of_le_succ (fun n => iterate_stage_succ_subset f hExt S n)
  have hdirected : Directed (· ⊆ ·) (fun n : Nat => (f^[n]) S) :=
    hmono.directed_le
  have hs' : (s : Set V) ⊆ ⋃ n : Nat, (f^[n]) S := by
    intro x hx
    rcases (iterUnion_mem_iff f S x).mp (hs x hx) with ⟨n, hn⟩
    exact Set.mem_iUnion.2 ⟨n, hn⟩
  rcases hdirected.exists_mem_subset_of_finset_subset_biUnion hs' with ⟨n, hn⟩
  exact ⟨n, fun x hx => hn hx⟩

theorem subset_closure
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    (S : Set V) :
    S ⊆ closure r Phi S := by
  intro x hx
  apply (iterUnion_mem_iff (closureStep r Phi) S x).mpr
  exact ⟨0, by simpa using hx⟩

theorem closure_mono
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V) :
    Monotone (closure r Phi) := by
  intro S T hST x hx
  rcases (iterUnion_mem_iff (closureStep r Phi) S x).mp hx with ⟨n, hx⟩
  apply (iterUnion_mem_iff (closureStep r Phi) T x).mpr
  refine ⟨n, ?_⟩
  exact ((closureStep_mono r Phi).iterate n) hST hx

theorem closureStep_closure_subset
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    (S : Set V) :
    closureStep r Phi (closure r Phi S) ⊆ closure r Phi S := by
  intro x hx
  rw [mem_closureStep_iff] at hx
  rcases hx with hx | ⟨s, hinside, hxout⟩
  · exact hx
  · have hExt : ∀ T : Set V, T ⊆ closureStep r Phi T :=
      extensive_closureStep r Phi
    obtain ⟨n, hn⟩ := finset_subset_iterate_stage (closureStep r Phi) hExt S s.1 hinside
    apply (iterUnion_mem_iff (closureStep r Phi) S x).mpr
    refine ⟨n + 1, ?_⟩
    have hnext : x ∈ closureStep r Phi ((closureStep r Phi)^[n] S) := by
      rw [mem_closureStep_iff]
      exact Or.inr ⟨s, hn, hxout⟩
    simpa [Function.iterate_succ_apply'] using hnext

theorem closureStep_closure_eq
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    (S : Set V) :
    closureStep r Phi (closure r Phi S) = closure r Phi S := by
  apply Set.Subset.antisymm (closureStep_closure_subset r Phi S)
  exact extensive_closureStep r Phi _

theorem output_subset_closure
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    (S : Set V) (s : {s : Finset V // s.card = r})
    (hinside : ∀ z ∈ s.1, z ∈ closure r Phi S) :
    (Phi s : Set V) ⊆ closure r Phi S := by
  intro x hx
  apply closureStep_closure_subset r Phi S
  rw [mem_closureStep_iff]
  exact Or.inr ⟨s, hinside, hx⟩

theorem closure_min
    (r : Nat) (Phi : {s : Finset V // s.card = r} -> Finset V)
    {S T : Set V} (hST : S ⊆ T)
    (hTclosed : closureStep r Phi T ⊆ T) :
    closure r Phi S ⊆ T := by
  intro x hx
  rcases (iterUnion_mem_iff (closureStep r Phi) S x).mp hx with ⟨n, hx⟩
  have hstage : ∀ n : Nat, (closureStep r Phi)^[n] S ⊆ T := by
    intro n
    induction n with
    | zero => simpa using hST
    | succ n ih =>
        have hnext : closureStep r Phi ((closureStep r Phi)^[n] S) ⊆
            closureStep r Phi T :=
          (closureStep_mono r Phi) ih
        simpa [Function.iterate_succ_apply'] using hnext.trans hTclosed
  exact hstage n hx

end ClosureFixedPointProbe
