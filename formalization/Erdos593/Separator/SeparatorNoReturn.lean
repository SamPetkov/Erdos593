import Erdos593.Separator.SeparatorCertificate

/-!
# Constructing separator certificates from deletion connectivity

Proof-source continuation of PR48. Kernel replay is still required.
`NoReturn` is a deletion-path uniqueness condition, not a supplied certificate
or an assumed order isomorphism. The Mathlib forest implication is in
`SeparatorForest.lean`.
-/

namespace E593Separator

universe u v
variable {A : Type u} {P : Type v}

/-- A step between pieces using a separator other than the deleted one. -/
def AwayStep (Inc : A → P → Prop) (p : P) (a b : A) : Prop :=
  ∃ q, q ≠ p ∧ Inc a q ∧ Inc b q

/-- Two neighbours of p cannot be connected without using p unless equal. -/
def NoReturn (Inc : A → P → Prop) : Prop :=
  ∀ (p : P) (a b : A), Inc a p → Inc b p →
    Closure (AwayStep Inc p) a b → a = b

/-- A reachable anchor in the star of the deleted separator. -/
def HasStarRoot (Inc : A → P → Prop) (p : P) (a : A) : Prop :=
  ∃ b : Star Inc p, Closure (AwayStep Inc p) a b.val

/-- This choice is defined for every incidence relation, with no nonemptiness
assumption. `NoReturn` is used to prove that it has the certificate properties. -/
noncomputable def componentRoot (Inc : A → P → Prop) (p : P) (a : A) :
    Option (Star Inc p) := by
  classical
  exact if h : HasStarRoot Inc p a then some (Classical.choose h) else none

/-- The existing certificate implies the concrete deletion uniqueness condition. -/
theorem Certificate.noReturn (Inc : A → P → Prop) (C : Certificate Inc) :
    NoReturn Inc := by
  intro p a b ha hb hab
  have same : ∀ {x y : A}, Closure (AwayStep Inc p) x y →
      C.root p x = C.root p y := by
    intro x y h
    induction h with
    | refl x => rfl
    | step h =>
        rcases h with ⟨q, hqp, hx, hy⟩
        exact C.away p q hqp _ _ hx hy
    | symm h ih => exact ih.symm
    | trans h1 h2 ih1 ih2 => exact ih1.trans ih2
  have he := same hab
  rw [C.at_star p a ha, C.at_star p b hb] at he
  exact congrArg Subtype.val (Option.some.inj he)

/-- Being in the component of a star does not change along a deletion path. -/
theorem hasStarRoot_iff_of_related (Inc : A → P → Prop) (p : P)
    {a b : A} (hab : Closure (AwayStep Inc p) a b) :
    HasStarRoot Inc p a ↔ HasStarRoot Inc p b := by
  constructor
  · rintro ⟨x, hx⟩
    exact ⟨x, Closure.trans (Closure.symm hab) hx⟩
  · rintro ⟨x, hx⟩
    exact ⟨x, Closure.trans hab hx⟩

/-- At a neighbour, the chosen root is that very neighbour. -/
theorem componentRoot_at_star (Inc : A → P → Prop) (hN : NoReturn Inc)
    (p : P) (a : A) (ha : Inc a p) :
    componentRoot Inc p a = some ⟨a, ha⟩ := by
  classical
  have hex : HasStarRoot Inc p a := ⟨⟨a, ha⟩, Closure.refl a⟩
  have heq : Classical.choose hex = (⟨a, ha⟩ : Star Inc p) := by
    apply Subtype.ext
    exact (hN p a (Classical.choose hex).val ha
      (Classical.choose hex).property (Classical.choose_spec hex)).symm
  unfold componentRoot
  rw [dif_pos hex]
  exact congrArg Option.some heq

/-- Equal deletion components have equal chosen roots, including the none case. -/
theorem componentRoot_eq_of_related (Inc : A → P → Prop) (hN : NoReturn Inc)
    (p : P) {a b : A} (hab : Closure (AwayStep Inc p) a b) :
    componentRoot Inc p a = componentRoot Inc p b := by
  classical
  by_cases ha : HasStarRoot Inc p a
  · have hb : HasStarRoot Inc p b :=
      (hasStarRoot_iff_of_related Inc p hab).mp ha
    have hp : Closure (AwayStep Inc p)
        (Classical.choose ha).val (Classical.choose hb).val :=
      Closure.trans (Closure.symm (Classical.choose_spec ha))
        (Closure.trans hab (Classical.choose_spec hb))
    have heq : Classical.choose ha = Classical.choose hb := by
      apply Subtype.ext
      exact hN p _ _ (Classical.choose ha).property
        (Classical.choose hb).property hp
    unfold componentRoot
    rw [dif_pos ha, dif_pos hb, heq]
  · have hb : ¬ HasStarRoot Inc p b :=
      fun h => ha ((hasStarRoot_iff_of_related Inc p hab).mpr h)
    unfold componentRoot
    rw [dif_neg ha, dif_neg hb]

/-- No certificate is postulated: its fields are constructed from path uniqueness. -/
noncomputable def certificateOfNoReturn (Inc : A → P → Prop)
    (hN : NoReturn Inc) : Certificate Inc where
  root := componentRoot Inc
  at_star := componentRoot_at_star Inc hN
  away := by
    intro p q hqp a b ha hb
    exact componentRoot_eq_of_related Inc hN p
      (Closure.step ⟨q, hqp, ha, hb⟩)

theorem nonempty_certificate_iff_noReturn (Inc : A → P → Prop) :
    Nonempty (Certificate Inc) ↔ NoReturn Inc := by
  constructor
  · rintro ⟨C⟩
    exact Certificate.noReturn Inc C
  · intro hN
    exact ⟨certificateOfNoReturn Inc hN⟩

/-- Local recovery now has a deletion-connectivity hypothesis rather than
unproved certificate data. -/
theorem local_recovery_of_noReturn (Inc : A → P → Prop) (hN : NoReturn Inc)
    (L : Local Inc) (p : P) (a b : Star Inc p) :
    (extend Inc L).rel a.val b.val ↔ (L p).rel a b :=
  local_recovery Inc (certificateOfNoReturn Inc hN) L p a b

end E593Separator
