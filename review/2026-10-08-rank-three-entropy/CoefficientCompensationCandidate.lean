import Mathlib.Data.Real.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Defs

/-!
# Candidate finite two-diamond coefficient compensation

Returned by Aristotle on 8 October 2026; original proof checked on 9 October
by pinned Lean4.32.0, warning-fatal job66955, with full types and ordered axioms.
Canonical acceptance and full dependency-artifact lineage remain pending.
Do not import this research candidate into the accepted Lean root.

Mathematical source: review/2026-10-08-rank-three-entropy/research-note.tex,
"A compensation bound with arbitrary arm mismatch". This is the coefficient
comparison only, not the graph-density or unrestricted entropy theorem.

Target pins: Lean leanprover/lean4:v4.32.0; Mathlib
81a5d257c8e410db227a6665ed08f64fea08e997. The earlier statement-only API
passed; separate job66955 subsequently checked the complete returned proof.

All sums use the same arbitrary finite type, including an empty type.
Powers are natural powers, including 0^0=1; r-l is natural subtraction,
with l<=r explicitly assumed. Only first-third symmetry of the signed tensor
is assumed. Numerical quantities are dimensionless real scalars.

Only documentary comments differ from the preserved original return.
All executable source, imports, definitions and statements remain unchanged.
-/

set_option autoImplicit false

open scoped BigOperators

namespace E593DensityDevelopment.CoefficientCompensationRequest

universe v

/-- The exact error energy from the research note: one quarter times the full
finite triple sum, with no normalization by the size of the index type. -/
noncomputable def energy0 {I : Type v} [Fintype I]
    (theta : I → ℝ) (M : I → I → I → ℝ) (k r u h : ℕ) : ℝ := by
  classical
  exact (1 / 4 : ℝ) *
    (∑ i : I, ∑ s : I, ∑ t : I,
      theta i ^ k * theta s ^ (2 * r) * (1 - theta s ^ h) ^ 2 *
        theta t ^ (2 * u) * (M i s t) ^ 2)

/-- The exact total of the two available diamonds, `D_ac + D_bc`, from the
research note. This is the unsymmetrized sum whose symmetry must be used in
the proof; no comparison with `energy0` is built into this definition. -/
noncomputable def diamondTotal {I : Type v} [Fintype I]
    (theta : I → ℝ) (M : I → I → I → ℝ) (k r u l h : ℕ) : ℝ := by
  classical
  exact ∑ i : I, ∑ s : I, ∑ t : I,
    theta i ^ u * theta s ^ (r + l) * (1 + theta s ^ h) *
      theta t ^ (k + u) * (M i s t) ^ 2

/-- The full quantified target as a transparent proposition, so a separate
statement-only API check can inspect it without introducing a proof placeholder.
The explicit `inst` witness is exactly the finite-type instance used by both
sums. No nonempty or decidable-equality instance is required. -/
def compensationStatement : Prop :=
  ∀ (I : Type v) (inst : Fintype I)
    (theta : I → ℝ) (M : I → I → I → ℝ)
    (k r u l h : ℕ) (c : ℝ),
    (∀ i : I, 0 ≤ theta i ∧ theta i ≤ 1) →
    (∀ i s t : I, M i s t = M t s i) →
    u ≤ k → 1 ≤ u → l ≤ r → 1 ≤ l → 1 ≤ h → 0 ≤ c →
    (∀ x : ℝ, 0 ≤ x → x ≤ 1 →
      (1 / 4 : ℝ) * x ^ (r - l) * (1 - x ^ h) ^ 2 ≤
        c * (1 + x ^ h)) →
    @energy0 I inst theta M k r u h ≤
      c * @diamondTotal I inst theta M k r u l h

/-- Multiset sums are monotone under pointwise comparison. -/
theorem msum_map_le {α : Type*} (m : Multiset α) (f g : α → ℝ)
    (hfg : ∀ a, f a ≤ g a) : (m.map f).sum ≤ (m.map g).sum := by
  induction m using Multiset.induction_on with
  | empty => simp
  | cons a m ih =>
    simp only [Multiset.map_cons, Multiset.sum_cons]
    exact add_le_add (hfg a) ih

/-- Constants pull out of multiset sums. -/
theorem msum_map_mul_left {α : Type*} (m : Multiset α) (c : ℝ) (f : α → ℝ) :
    (m.map (fun a => c * f a)).sum = c * (m.map f).sum := by
  induction m using Multiset.induction_on with
  | empty => simp
  | cons a m ih =>
    simp only [Multiset.map_cons, Multiset.sum_cons, ih]
    grind

theorem fsum_le {α : Type*} (s : Finset α) (f g : α → ℝ)
    (hfg : ∀ a, f a ≤ g a) : ∑ a ∈ s, f a ≤ ∑ a ∈ s, g a := by
  rw [Finset.sum_eq_multiset_sum, Finset.sum_eq_multiset_sum]
  exact msum_map_le _ f g hfg

theorem fsum_mul_left {α : Type*} (s : Finset α) (c : ℝ) (f : α → ℝ) :
    ∑ a ∈ s, c * f a = c * ∑ a ∈ s, f a := by
  rw [Finset.sum_eq_multiset_sum, Finset.sum_eq_multiset_sum]
  exact msum_map_mul_left _ c f

theorem fsum_add {α : Type*} (s : Finset α) (f g : α → ℝ) :
    ∑ a ∈ s, (f a + g a) = ∑ a ∈ s, f a + ∑ a ∈ s, g a := by
  rw [Finset.sum_eq_multiset_sum, Finset.sum_eq_multiset_sum,
    Finset.sum_eq_multiset_sum]
  exact Multiset.sum_map_add

theorem fsum_comm {α β : Type*} (s : Finset α) (t : Finset β) (f : α → β → ℝ) :
    ∑ a ∈ s, ∑ b ∈ t, f a b = ∑ b ∈ t, ∑ a ∈ s, f a b := by
  simp only [Finset.sum_eq_multiset_sum]
  exact Multiset.sum_map_sum_map _ _

/-- Exchanging the first and third indices of a full triple sum. -/
theorem triple_sum_swap {I : Type v} [Fintype I] (f : I → I → I → ℝ) :
    ∑ i : I, ∑ s : I, ∑ t : I, f i s t = ∑ i : I, ∑ s : I, ∑ t : I, f t s i := by
  calc ∑ i : I, ∑ s : I, ∑ t : I, f i s t
      = ∑ i : I, ∑ t : I, ∑ s : I, f i s t := by
        congr 1; funext i; exact fsum_comm _ _ _
    _ = ∑ t : I, ∑ i : I, ∑ s : I, f i s t := fsum_comm _ _ _
    _ = ∑ t : I, ∑ s : I, ∑ i : I, f i s t := by
        congr 1; funext t; exact fsum_comm _ _ _

/-- The scalar rearrangement comparison `A ≤ B`. -/
theorem scalar_rearrangement (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y) (k u : ℕ)
    (huk : u ≤ k) :
    x ^ k * y ^ (2 * u) + y ^ k * x ^ (2 * u) ≤
      x ^ u * y ^ (k + u) + y ^ u * x ^ (k + u) := by
  obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le huk
  have hp : 0 ≤ x ^ u := pow_nonneg hx u
  have hq : 0 ≤ y ^ u := pow_nonneg hy u
  have key : 0 ≤ (x ^ u - y ^ u) * (x ^ d - y ^ d) := by
    rcases le_total x y with hxy | hxy
    · have h1 : x ^ u ≤ y ^ u := pow_le_pow_left₀ hx hxy u
      have h2 : x ^ d ≤ y ^ d := pow_le_pow_left₀ hx hxy d
      exact mul_nonneg_of_nonpos_of_nonpos (sub_nonpos.mpr h1) (sub_nonpos.mpr h2)
    · have h1 : y ^ u ≤ x ^ u := pow_le_pow_left₀ hy hxy u
      have h2 : y ^ d ≤ x ^ d := pow_le_pow_left₀ hy hxy d
      exact mul_nonneg (sub_nonneg.mpr h1) (sub_nonneg.mpr h2)
  have hpq : 0 ≤ x ^ u * y ^ u * ((x ^ u - y ^ u) * (x ^ d - y ^ d)) :=
    mul_nonneg (mul_nonneg hp hq) key
  have e1 : x ^ (u + d) = x ^ u * x ^ d := pow_add _ _ _
  have e2 : y ^ (u + d) = y ^ u * y ^ d := pow_add _ _ _
  have e3 : x ^ (2 * u) = x ^ u * x ^ u := by rw [two_mul, pow_add]
  have e4 : y ^ (2 * u) = y ^ u * y ^ u := by rw [two_mul, pow_add]
  have e5 : x ^ (u + d + u) = x ^ u * x ^ d * x ^ u := by rw [pow_add, pow_add]
  have e6 : y ^ (u + d + u) = y ^ u * y ^ d * y ^ u := by rw [pow_add, pow_add]
  rw [e1, e2, e3, e4, e5, e6]
  grind

/-- ARISTOTLE TARGET: the complete finite coefficient compensation inequality.

Analytical proof route in the source (guidance, not extra hypotheses):
1. Derive for nonnegative `x,y` and `u ≤ k` the scalar comparison
   `x^k*y^(2*u) + y^k*x^(2*u) ≤
    x^u*y^(k+u) + y^u*x^(k+u)`.
   The right side minus the left side equals
   `x^u*y^u*(x^u-y^u)*(x^(k-u)-y^(k-u))`, which is nonnegative.
   Prove that sign by splitting `x ≤ y` and `y ≤ x`; do not divide by
   eigenvalues. In particular, zero entries and `k = u` are allowed.
2. Reindex the full sums by exchanging `i,t`; use `M i s t = M t s i`
   to average each sum with its exchanged expression.
3. Use `2*r = (r+l) + (r-l)` from `l ≤ r`, then apply `scalar_bound`
   at `theta s`, multiply only by verified nonnegative factors, and sum.

The original request placeholder was replaced by the returned proof. It must
elaborate under the exact target pins and pass separate full-type
and standard-axiom validation before it can be accepted. -/
theorem finite_coefficient_compensation : compensationStatement.{v} := by
  intro I inst theta M k r u l h c htheta hM huk _hu hlr _hl _hh hc hscalar
  unfold energy0 diamondTotal
  set F : I → I → I → ℝ := fun i s t =>
    theta i ^ k * theta s ^ (2 * r) * (1 - theta s ^ h) ^ 2 *
      theta t ^ (2 * u) * (M i s t) ^ 2 with hF
  set G : I → I → I → ℝ := fun i s t =>
    theta i ^ u * theta s ^ (r + l) * (1 + theta s ^ h) *
      theta t ^ (k + u) * (M i s t) ^ 2 with hG
  change (1 / 4 : ℝ) * (∑ i : I, ∑ s : I, ∑ t : I, F i s t) ≤
    c * (∑ i : I, ∑ s : I, ∑ t : I, G i s t)
  have hterm : ∀ i s t : I,
      (1 / 4 : ℝ) * (F i s t + F t s i) ≤ c * (G i s t + G t s i) := by
    intro i s t
    obtain ⟨ha0, ha1⟩ := htheta i
    obtain ⟨hb0, hb1⟩ := htheta s
    obtain ⟨he0, he1⟩ := htheta t
    have hMs : M t s i = M i s t := hM t s i
    simp only [hF, hG, hMs]
    set a := theta i
    set b := theta s
    set e := theta t
    set m2 := (M i s t) ^ 2
    have hm2 : 0 ≤ m2 := sq_nonneg _
    have hg : 0 ≤ (1 - b ^ h) ^ 2 := sq_nonneg _
    have hA := scalar_rearrangement a e ha0 he0 k u huk
    have hB : 0 ≤ a ^ u * e ^ (k + u) + e ^ u * a ^ (k + u) :=
      add_nonneg (mul_nonneg (pow_nonneg ha0 _) (pow_nonneg he0 _))
        (mul_nonneg (pow_nonneg he0 _) (pow_nonneg ha0 _))
    have hR : 0 ≤ b ^ (2 * r) * (1 - b ^ h) ^ 2 * m2 :=
      mul_nonneg (mul_nonneg (pow_nonneg hb0 _) hg) hm2
    have hS : 0 ≤ (a ^ u * e ^ (k + u) + e ^ u * a ^ (k + u)) * b ^ (r + l) * m2 :=
      mul_nonneg (mul_nonneg hB (pow_nonneg hb0 _)) hm2
    have h2r : b ^ (2 * r) = b ^ (r + l) * b ^ (r - l) := by
      rw [← pow_add]; congr 1; omega
    have step1 := mul_le_mul_of_nonneg_right hA hR
    have step2 := mul_le_mul_of_nonneg_left (hscalar b hb0 hb1) hS
    calc (1 / 4 : ℝ) * (a ^ k * b ^ (2 * r) * (1 - b ^ h) ^ 2 * e ^ (2 * u) * m2 +
          e ^ k * b ^ (2 * r) * (1 - b ^ h) ^ 2 * a ^ (2 * u) * m2)
        = (1 / 4 : ℝ) * ((a ^ k * e ^ (2 * u) + e ^ k * a ^ (2 * u)) *
            (b ^ (2 * r) * (1 - b ^ h) ^ 2 * m2)) := by grind
      _ ≤ (1 / 4 : ℝ) * ((a ^ u * e ^ (k + u) + e ^ u * a ^ (k + u)) *
            (b ^ (2 * r) * (1 - b ^ h) ^ 2 * m2)) :=
          mul_le_mul_of_nonneg_left step1 (by norm_num)
      _ = (a ^ u * e ^ (k + u) + e ^ u * a ^ (k + u)) * b ^ (r + l) * m2 *
            ((1 / 4 : ℝ) * b ^ (r - l) * (1 - b ^ h) ^ 2) := by
          rw [h2r]; grind
      _ ≤ (a ^ u * e ^ (k + u) + e ^ u * a ^ (k + u)) * b ^ (r + l) * m2 *
            (c * (1 + b ^ h)) := step2
      _ = c * (a ^ u * b ^ (r + l) * (1 + b ^ h) * e ^ (k + u) * m2 +
            e ^ u * b ^ (r + l) * (1 + b ^ h) * a ^ (k + u) * m2) := by grind
  have hFs := triple_sum_swap F
  have hGs := triple_sum_swap G
  have hsum : ∑ i : I, ∑ s : I, ∑ t : I, (1 / 4 : ℝ) * (F i s t + F t s i) ≤
      ∑ i : I, ∑ s : I, ∑ t : I, c * (G i s t + G t s i) :=
    fsum_le _ _ _ fun i => fsum_le _ _ _ fun s => fsum_le _ _ _ fun t => hterm i s t
  simp only [fsum_mul_left, fsum_add] at hsum
  rw [← hFs, ← hGs] at hsum
  grind

end E593DensityDevelopment.CoefficientCompensationRequest
