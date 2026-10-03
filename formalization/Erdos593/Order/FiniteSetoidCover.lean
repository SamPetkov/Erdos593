import Mathlib.Data.Setoid.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Order.Cover
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Tactic

/-!
# Covers of finite equivalence relations — source-only candidate

Pinned dependency source: Mathlib 81a5d257c8e410db227a6665ed08f64fea08e997.
This isolated module has not been compiled or accepted. No accepted project
source, root, audit, package or evidence is changed by this candidate.

The order is relation inclusion: `R < S` means that `S` is strictly coarser
than `R`. Consequently quotient cardinality decreases along this order.
The carrier need only be finite; it may be empty.
-/

namespace E593FiniteSetoid

universe u

variable {A : Type u}

/-- The map induced by refinement is onto, including for empty carriers. -/
theorem map_of_le_surjective {R S : Setoid A} (h : R ≤ S) :
    Function.Surjective (Setoid.map_of_le h) := by
  intro q
  refine Quotient.inductionOn q ?_
  intro a
  exact ⟨Quotient.mk R a, rfl⟩

/-- Quotient cardinality is antitone under relation inclusion. -/
theorem quotient_card_antitone [Finite A] {R S : Setoid A} (h : R ≤ S) :
    Nat.card (Quotient S) ≤ Nat.card (Quotient R) :=
  Nat.card_le_card_of_surjective (Setoid.map_of_le h) (map_of_le_surjective h)

/-- A strict coarsening of a finite equivalence relation strictly decreases
the actual quotient cardinality. -/
theorem quotient_card_strict_antitone [Finite A] {R S : Setoid A} (h : R < S) :
    Nat.card (Quotient S) < Nat.card (Quotient R) := by
  by_contra hc
  have hinj : Function.Injective (Setoid.map_of_le h.le) :=
    ((map_of_le_surjective h.le).bijective_of_nat_card_le (by omega)).1
  have hSR : S ≤ R := by
    intro a b hab
    apply Quotient.exact
    apply hinj
    exact Quotient.sound hab
  exact h.not_ge hSR

/-- Collapse the selected point `q` onto a distinct point `p`, with codomain
the actual complement of `q`. It removes exactly one point, not an abstract
or assembly-list count. -/
private noncomputable def collapsePoint {B : Type u} (p q : B) (hpq : p ≠ q)
    (x : B) : {y : B // y ≠ q} := by
  classical
  exact if hx : x = q then ⟨p, hpq⟩ else ⟨x, hx⟩

private theorem collapsePoint_surjective {B : Type u} (p q : B) (hpq : p ≠ q) :
    Function.Surjective (collapsePoint p q hpq) := by
  classical
  intro x
  refine ⟨x.val, ?_⟩
  apply Subtype.ext
  simp [collapsePoint, x.property]

/-- Removing a specified point decreases the cardinality by one. A point
is supplied only locally here; the cover theorem imposes no Nonempty premise. -/
private theorem card_complement_point [Finite A] (a : A) :
    Nat.card {x : A // x ≠ a} + 1 = Nat.card A := by
  classical
  letI : Fintype A := Fintype.ofFinite A
  have hc : Fintype.card {x : A // x ≠ a} = Fintype.card A - 1 := by
    simpa only [Fintype.card_subtype_eq] using
      Fintype.card_subtype_compl (fun x : A => x = a)
  have hp : 0 < Fintype.card A := Fintype.card_pos_iff.mpr ⟨a⟩
  simp only [Nat.card_eq_fintype_card]
  omega

/-- Every strict finite coarsening contains a coarsening which merges exactly
two of the original quotient classes. This is the constructive missing bridge,
not a hypothesis that finite partition lattices are already graded. -/
theorem exists_one_class_coarsening [Finite A] {R S : Setoid A} (hRS : R < S) :
    ∃ T : Setoid A, R < T ∧ T ≤ S ∧
      Nat.card (Quotient R) = Nat.card (Quotient T) + 1 := by
  classical
  obtain ⟨a, b, habS, habR⟩ : ∃ a b : A, S a b ∧ ¬R a b := by
    by_contra! h
    exact hRS.not_ge (fun x y hxy => h x y hxy)
  let p : Quotient R := Quotient.mk R a
  let q : Quotient R := Quotient.mk R b
  have hpq : p ≠ q := fun h => habR (Quotient.exact h)
  let f : A → {z : Quotient R // z ≠ q} :=
    fun x => collapsePoint p q hpq (Quotient.mk R x)
  let T : Setoid A := Setoid.ker f
  have hRT : R ≤ T := by
    intro x y hxy
    change f x = f y
    exact congrArg (collapsePoint p q hpq) (Quotient.sound hxy)
  have habT : T a b := by
    change collapsePoint p q hpq p = collapsePoint p q hpq q
    apply Subtype.ext
    simp [collapsePoint, hpq]
  have hRTstrict : R < T :=
    lt_iff_le_not_ge.mpr ⟨hRT, fun hTR => habR (hTR habT)⟩
  let m : Quotient R → Quotient S := Setoid.map_of_le hRS.le
  have hmpq : m p = m q := Quotient.sound habS
  have hcollapse (z : Quotient R) : m (collapsePoint p q hpq z).val = m z := by
    by_cases hz : z = q
    · subst z
      simpa [collapsePoint] using hmpq
    · simp [collapsePoint, hz]
  have hTS : T ≤ S := by
    intro x y hxy
    change f x = f y at hxy
    have hmxy : m (f x).val = m (f y).val :=
      congrArg (fun z : {z : Quotient R // z ≠ q} => m z.val) hxy
    apply Quotient.exact
    change m (Quotient.mk R x) = m (Quotient.mk R y)
    exact (hcollapse (Quotient.mk R x)).symm.trans
      (hmxy.trans (hcollapse (Quotient.mk R y)))
  have hf : Function.Surjective f := by
    intro z
    obtain ⟨w, hw⟩ := collapsePoint_surjective p q hpq z
    obtain ⟨x, hx⟩ : ∃ x : A, Quotient.mk R x = w := Quotient.mk_surjective w
    exact ⟨x, by simpa [f, hx] using hw⟩
  have hcard : Nat.card (Quotient T) = Nat.card {z : Quotient R // z ≠ q} :=
    Nat.card_congr (Setoid.quotientKerEquivOfSurjective f hf)
  refine ⟨T, hRTstrict, hTS, ?_⟩
  rw [hcard]
  exact (card_complement_point q).symm

/-- A finite cover merges exactly two quotient classes. -/
theorem quotient_card_of_covBy [Finite A] {R S : Setoid A} (hRS : R ⋖ S) :
    Nat.card (Quotient R) = Nat.card (Quotient S) + 1 := by
  obtain ⟨T, hRT, hTS, hcard⟩ := exists_one_class_coarsening hRS.lt
  rcases hRS.eq_or_eq hRT.le hTS with hTR | hTS
  · exact False.elim (hRT.ne hTR.symm)
  · simpa only [hTS] using hcard

/-- Conversely, the cardinality drop of one leaves no strict intermediate
equivalence relation. -/
theorem covBy_of_quotient_card [Finite A] {R S : Setoid A} (hRS : R < S)
    (hcard : Nat.card (Quotient R) = Nat.card (Quotient S) + 1) : R ⋖ S := by
  refine ⟨hRS, ?_⟩
  intro T hRT hTS
  have h1 := quotient_card_strict_antitone hRT
  have h2 := quotient_card_strict_antitone hTS
  omega

/-- Exact finite cover criterion in relation-inclusion orientation. -/
theorem covBy_iff_quotient_card [Finite A] {R S : Setoid A} :
    R ⋖ S ↔ R < S ∧
      Nat.card (Quotient R) = Nat.card (Quotient S) + 1 :=
  ⟨fun h => ⟨h.lt, quotient_card_of_covBy h⟩,
    fun h => covBy_of_quotient_card h.1 h.2⟩

end E593FiniteSetoid
