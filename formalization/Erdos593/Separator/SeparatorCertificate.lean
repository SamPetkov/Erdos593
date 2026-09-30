import Init

/-!
# A reusable certificate interface for local-to-global partitions

Unvalidated Lean 4.32 candidate. No project-local or Mathlib imports are used.
`Certificate` is explicit separation data; existence of these certificates
from an acyclic incidence graph is NOT assumed proved by this file.

The intended mathematical application is the product decomposition of the
connected-partition lattice of a forest of cliques. That lattice machinery is
classical; this is a small proof interface, not a novelty claim for it.
-/

namespace E593Separator

universe u v w

structure Partition (A : Type u) where
  rel : A → A → Prop
  refl : ∀ a, rel a a
  symm : ∀ {a b}, rel a b → rel b a
  trans : ∀ {a b c}, rel a b → rel b c → rel a c

theorem Partition.ext {A : Type u} {R S : Partition A}
    (h : R.rel = S.rel) : R = S := by
  cases R
  cases S
  cases h
  rfl

inductive Closure {A : Type u} (R : A → A → Prop) : A → A → Prop
  | refl (a : A) : Closure R a a
  | step {a b : A} : R a b → Closure R a b
  | symm {a b : A} : Closure R a b → Closure R b a
  | trans {a b c : A} : Closure R a b → Closure R b c → Closure R a c

theorem Closure.map {A : Type u} {R S : A → A → Prop}
    (f : ∀ {a b}, R a b → S a b) {a b : A}
    (h : Closure R a b) : Closure S a b := by
  induction h with
  | refl a => exact Closure.refl a
  | step h => exact Closure.step (f h)
  | symm h ih => exact Closure.symm ih
  | trans h1 h2 ih1 ih2 => exact Closure.trans ih1 ih2

theorem Closure.respects {A : Type u} {B : Type w}
    {R : A → A → Prop} (S : Partition B) (f : A → B)
    (hstep : ∀ {a b}, R a b → S.rel (f a) (f b))
    {a b : A} (h : Closure R a b) : S.rel (f a) (f b) := by
  induction h with
  | refl a => exact S.refl (f a)
  | step h => exact hstep h
  | symm h ih => exact S.symm ih
  | trans h1 h2 ih1 ih2 => exact S.trans ih1 ih2

def optionPartition {A : Type u} (R : Partition A) : Partition (Option A) where
  rel a b := match a, b with
    | none, none => True
    | some a, some b => R.rel a b
    | _, _ => False
  refl := by
    intro a
    cases a with
    | none => exact True.intro
    | some a => exact R.refl a
  symm := by
    intro a b h
    cases a with
    | none =>
      cases b with
      | none => exact True.intro
      | some b => exact False.elim h
    | some a =>
      cases b with
      | none => exact False.elim h
      | some b => exact R.symm h
  trans := by
    intro a b c hab hbc
    cases a with
    | none =>
      cases b with
      | none =>
        cases c with
        | none => exact True.intro
        | some c => exact False.elim hbc
      | some b => exact False.elim hab
    | some a =>
      cases b with
      | none => exact False.elim hab
      | some b =>
        cases c with
        | none => exact False.elim hbc
        | some c => exact R.trans hab hbc

variable {A : Type u} {P : Type v}

abbrev Star (Inc : A → P → Prop) (p : P) := {a : A // Inc a p}
abbrev Local (Inc : A → P → Prop) := (p : P) → Partition (Star Inc p)

/-- A forest supplies these maps by deleting p and recording which neighbor
of p lies in the remaining component; other components are sent to none. -/
structure Certificate (Inc : A → P → Prop) where
  root : (p : P) → A → Option (Star Inc p)
  at_star : ∀ (p : P) (a : A) (ha : Inc a p), root p a = some ⟨a, ha⟩
  away : ∀ (p q : P), q ≠ p → ∀ (a b : A),
    Inc a q → Inc b q → root p a = root p b

def Step (Inc : A → P → Prop) (L : Local Inc) (a b : A) : Prop :=
  ∃ p, ∃ ha : Inc a p, ∃ hb : Inc b p, (L p).rel ⟨a, ha⟩ ⟨b, hb⟩

def extend (Inc : A → P → Prop) (L : Local Inc) : Partition A where
  rel := Closure (Step Inc L)
  refl := Closure.refl
  symm := Closure.symm
  trans := Closure.trans

def restrict (Inc : A → P → Prop) (R : Partition A) : Local Inc := fun _ =>
  { rel := fun a b => R.rel a.val b.val
    refl := fun a => R.refl a.val
    symm := fun h => R.symm h
    trans := fun h1 h2 => R.trans h1 h2 }

def InternalStep (Inc : A → P → Prop) (R : Partition A) (a b : A) : Prop :=
  R.rel a b ∧ ∃ p, Inc a p ∧ Inc b p

/-- Every equivalence class is connected in the graph joining pieces that
share a separator. This is the literal path condition, not a reconstruction
identity inserted as an assumption. -/
def ConnectedPartition (Inc : A → P → Prop) (R : Partition A) : Prop :=
  ∀ a b, R.rel a b → Closure (InternalStep Inc R) a b

def Refines {B : Type w} (R S : Partition B) : Prop :=
  ∀ a b, R.rel a b → S.rel a b

theorem step_incidence (Inc : A → P → Prop) (L : Local Inc)
    {a b : A} (h : Step Inc L a b) : ∃ p, Inc a p ∧ Inc b p := by
  cases h with
  | intro p h =>
    cases h with
    | intro ha h =>
      cases h with
      | intro hb hab => exact ⟨p, ha, hb⟩

theorem step_projected (Inc : A → P → Prop) (C : Certificate Inc)
    (L : Local Inc) (p : P) {a b : A} (h : Step Inc L a b) :
    (optionPartition (L p)).rel (C.root p a) (C.root p b) := by
  cases h with
  | intro q h =>
    cases h with
    | intro ha h =>
      cases h with
      | intro hb hab =>
        cases Classical.em (q = p) with
        | inl heq =>
          subst q
          rw [C.at_star p a ha, C.at_star p b hb]
          exact hab
        | inr hne =>
          rw [C.away p q hne a b ha hb]
          exact (optionPartition (L p)).refl _

/-- No global chain can create a relation missing at a single separator. -/
theorem local_recovery (Inc : A → P → Prop) (C : Certificate Inc)
    (L : Local Inc) (p : P) (a b : Star Inc p) :
    (extend Inc L).rel a.val b.val ↔ (L p).rel a b := by
  constructor
  · intro h
    have hp := Closure.respects (optionPartition (L p)) (C.root p)
      (fun hs => step_projected Inc C L p hs) h
    rw [C.at_star p a.val a.property, C.at_star p b.val b.property] at hp
    exact hp
  · intro h
    exact Closure.step ⟨p, a.property, b.property, h⟩

theorem restrict_extend (Inc : A → P → Prop) (C : Certificate Inc)
    (L : Local Inc) : restrict Inc (extend Inc L) = L := by
  funext p
  apply Partition.ext
  funext a b
  exact propext (local_recovery Inc C L p a b)

theorem extend_connected (Inc : A → P → Prop) (L : Local Inc) :
    ConnectedPartition Inc (extend Inc L) := by
  intro a b h
  exact Closure.map
    (fun hs => And.intro (Closure.step hs) (step_incidence Inc L hs)) h

theorem extend_restrict (Inc : A → P → Prop) (R : Partition A)
    (hR : ConnectedPartition Inc R) : extend Inc (restrict Inc R) = R := by
  apply Partition.ext
  funext a b
  apply propext
  constructor
  · intro h
    apply Closure.respects R (fun x => x) ?_ h
    intro x y hxy
    cases hxy with
    | intro p h =>
      cases h with
      | intro hx h =>
        cases h with
        | intro hy hr => exact hr
  · intro h
    apply Closure.map (R := InternalStep Inc R) ?_ (hR a b h)
    intro x y hxy
    cases hxy with
    | intro hr hi =>
      cases hi with
      | intro p hp => exact ⟨p, hp.left, hp.right, hr⟩

theorem extend_injective (Inc : A → P → Prop) (C : Certificate Inc)
    {L M : Local Inc} (h : extend Inc L = extend Inc M) : L = M := by
  have hh := congrArg (restrict Inc) h
  rw [restrict_extend Inc C L, restrict_extend Inc C M] at hh
  exact hh

/-- The local/global bijection preserves and reflects the refinement order. -/
theorem extend_refines_iff (Inc : A → P → Prop) (C : Certificate Inc)
    (L M : Local Inc) :
    Refines (extend Inc L) (extend Inc M) ↔ ∀ p, Refines (L p) (M p) := by
  constructor
  · intro h p a b hab
    exact (local_recovery Inc C M p a b).mp
      (h a.val b.val ((local_recovery Inc C L p a b).mpr hab))
  · intro h a b hab
    apply Closure.map ?_ hab
    intro x y hxy
    cases hxy with
    | intro p hp =>
      cases hp with
      | intro hx hp =>
        cases hp with
        | intro hy hr => exact ⟨p, hx, hy, h p ⟨x, hx⟩ ⟨y, hy⟩ hr⟩

/-- Surjectivity onto precisely the connected global partitions. -/
theorem exists_local_iff_connected (Inc : A → P → Prop) (R : Partition A) :
    (∃ L : Local Inc, extend Inc L = R) ↔ ConnectedPartition Inc R := by
  constructor
  · intro h
    cases h with
    | intro L heq =>
      rw [← heq]
      exact extend_connected Inc L
  · intro h
    exact ⟨restrict Inc R, extend_restrict Inc R h⟩

end E593Separator
