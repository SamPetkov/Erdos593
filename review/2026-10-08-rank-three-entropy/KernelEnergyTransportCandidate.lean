import CoefficientCompensationCandidate
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Ring

/-!
Direct source-only candidate for the finite kernel-to-coefficient energy identity.
UNCOMPILED: finite-sum elaboration and warning-fatal full types still require a
separately reviewed pinned check. This source imports the research coefficient
candidate only, not an accepted root. No spectral extraction is asserted.
-/

set_option autoImplicit false

open scoped BigOperators

namespace E593DensityDevelopment.KernelEnergyTransportCandidate

universe v w

/-- The Kronecker scalar hides only a classical equality decision, not a
mathematical assumption or an instance required of the caller. -/
noncomputable def spectralKronecker {I : Type w} (i j : I) : ℝ := by
  classical
  exact if i = j then 1 else 0

noncomputable def spectralKernel {X : Type v} {I : Type w} [Fintype I]
    (theta : I → ℝ) (phi : I → X → ℝ) (j : ℕ) (x y : X) : ℝ := by
  classical
  exact ∑ i : I, theta i ^ j * phi i x * phi i y

noncomputable def cubicMoment {X : Type v} {I : Type w} [Fintype X]
    (mu : X → ℝ) (phi : I → X → ℝ) (i s t : I) : ℝ := by
  classical
  exact ∑ x : X, mu x * phi i x * phi s x * phi t x

noncomputable def kernelDelta {X : Type v} {I : Type w} [Fintype I]
    (theta : I → ℝ) (phi : I → X → ℝ) (r u h : ℕ) (x z q : X) : ℝ :=
  (spectralKernel theta phi (r + h) x z - spectralKernel theta phi r x z) *
    spectralKernel theta phi u x q / 2

noncomputable def kernelEnergy {X : Type v} {I : Type w}
    [Fintype X] [Fintype I] (mu : X → ℝ) (theta : I → ℝ)
    (phi : I → X → ℝ) (k r u h : ℕ) : ℝ := by
  classical
  exact ∑ z : X, ∑ q : X, mu z * mu q *
    (∑ x : X, ∑ y : X, mu x * mu y *
      kernelDelta theta phi r u h x z q * spectralKernel theta phi k x y *
        kernelDelta theta phi r u h y z q)

/-- Finite weighted Parseval requires orthonormality, not completeness. -/
theorem weighted_parseval {X : Type v} {I : Type w}
    [Fintype X] [Fintype I] (mu : X → ℝ) (phi : I → X → ℝ)
    (orth : ∀ i j : I, (∑ x : X, mu x * phi i x * phi j x) =
      spectralKronecker i j) (a : I → ℝ) :
    (∑ x : X, mu x * (∑ i : I, a i * phi i x) ^ 2) =
      ∑ i : I, a i ^ 2 := by
  classical
  have expand (x : X) :
      mu x * (∑ i : I, a i * phi i x) ^ 2 =
        ∑ i : I, ∑ j : I, (a i * a j) * (mu x * phi i x * phi j x) := by
    simp only [pow_two, Finset.sum_mul, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    ring
  calc
    (∑ x : X, mu x * (∑ i : I, a i * phi i x) ^ 2) =
        ∑ x : X, ∑ i : I, ∑ j : I,
          (a i * a j) * (mu x * phi i x * phi j x) := by
      apply Finset.sum_congr rfl
      intro x _
      exact expand x
    _ = ∑ i : I, ∑ j : I, (a i * a j) *
          (∑ x : X, mu x * phi i x * phi j x) := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.mul_sum]
    _ = ∑ i : I, a i ^ 2 := by
      simp [orth, spectralKronecker, pow_two]

/-- The finite quadratic kernel form is diagonal in the supplied expansion.
No orthonormality is needed for this identity. -/
theorem kernel_quadratic_form {X : Type v} {I : Type w}
    [Fintype X] [Fintype I] (mu : X → ℝ) (theta : I → ℝ)
    (phi : I → X → ℝ) (k : ℕ) (f : X → ℝ) :
    (∑ x : X, ∑ y : X, mu x * mu y * f x *
      spectralKernel theta phi k x y * f y) =
        ∑ i : I, theta i ^ k * (∑ x : X, mu x * f x * phi i x) ^ 2 := by
  classical
  have expand (x y : X) :
      mu x * mu y * f x * spectralKernel theta phi k x y * f y =
        ∑ i : I, theta i ^ k * (mu x * f x * phi i x) *
          (mu y * f y * phi i y) := by
    unfold spectralKernel
    simp only [Finset.mul_sum, Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro i _
    ring
  calc
    (∑ x : X, ∑ y : X, mu x * mu y * f x *
        spectralKernel theta phi k x y * f y) =
        ∑ x : X, ∑ y : X, ∑ i : I, theta i ^ k *
          (mu x * f x * phi i x) * (mu y * f y * phi i y) := by
      apply Finset.sum_congr rfl
      intro x _
      apply Finset.sum_congr rfl
      intro y _
      exact expand x y
    _ = ∑ i : I, ∑ x : X, ∑ y : X, theta i ^ k *
          (mu x * f x * phi i x) * (mu y * f y * phi i y) := by
      apply Eq.trans _ (Finset.sum_comm)
      apply Finset.sum_congr rfl
      intro x _
      exact Finset.sum_comm
    _ = ∑ i : I, theta i ^ k *
          (∑ x : X, mu x * f x * phi i x) ^ 2 := by
      apply Finset.sum_congr rfl
      intro i _
      rw [pow_two]
      simp only [Finset.mul_sum, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro x _
      apply Finset.sum_congr rfl
      intro y _
      ring

theorem delta_expansion {X : Type v} {I : Type w} [Fintype I]
    (theta : I → ℝ) (phi : I → X → ℝ) (r u h : ℕ) (x z q : X) :
    kernelDelta theta phi r u h x z q =
      ∑ s : I, ∑ t : I,
        ((1 / 2 : ℝ) * theta s ^ r * (theta s ^ h - 1) * theta t ^ u) *
          phi s x * phi t x * phi s z * phi t q := by
  classical
  have difference :
      spectralKernel theta phi (r + h) x z - spectralKernel theta phi r x z =
        ∑ s : I, theta s ^ r * (theta s ^ h - 1) * phi s x * phi s z := by
    unfold spectralKernel
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro s _
    rw [pow_add]
    ring
  unfold kernelDelta
  rw [difference]
  unfold spectralKernel
  simp only [div_eq_mul_inv, Finset.sum_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro s _
  apply Finset.sum_congr rfl
  intro t _
  ring

theorem delta_projection {X : Type v} {I : Type w}
    [Fintype X] [Fintype I] (mu : X → ℝ) (theta : I → ℝ)
    (phi : I → X → ℝ) (r u h : ℕ) (i : I) (z q : X) :
    (∑ x : X, mu x * kernelDelta theta phi r u h x z q * phi i x) =
      ∑ s : I, ∑ t : I,
        ((1 / 2 : ℝ) * theta s ^ r * (theta s ^ h - 1) * theta t ^ u *
          cubicMoment mu phi i s t) * phi s z * phi t q := by
  classical
  simp_rw [delta_expansion]
  simp only [Finset.mul_sum, Finset.sum_mul]
  calc
    (∑ x : X, ∑ s : I, ∑ t : I,
        mu x * (((1 / 2 : ℝ) * theta s ^ r * (theta s ^ h - 1) *
          theta t ^ u) * phi s x * phi t x * phi s z * phi t q) * phi i x) =
        ∑ s : I, ∑ t : I, ∑ x : X,
          mu x * (((1 / 2 : ℝ) * theta s ^ r * (theta s ^ h - 1) *
            theta t ^ u) * phi s x * phi t x * phi s z * phi t q) * phi i x := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro s _
      rw [Finset.sum_comm]
    _ = _ := by
      apply Finset.sum_congr rfl
      intro s _
      apply Finset.sum_congr rfl
      intro t _
      unfold cubicMoment
      simp only [Finset.mul_sum, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro x _
      ring

/-- Tensor Parseval, proved by two independent finite Parseval steps. -/
theorem tensor_parseval {X : Type v} {I : Type w}
    [Fintype X] [Fintype I] (mu : X → ℝ) (phi : I → X → ℝ)
    (orth : ∀ i j : I, (∑ x : X, mu x * phi i x * phi j x) =
      spectralKronecker i j) (c : I → I → ℝ) :
    (∑ z : X, ∑ q : X, mu z * mu q *
      (∑ s : I, ∑ t : I, c s t * phi s z * phi t q) ^ 2) =
        ∑ s : I, ∑ t : I, (c s t) ^ 2 := by
  classical
  have swap (z q : X) :
      (∑ s : I, ∑ t : I, c s t * phi s z * phi t q) =
        ∑ t : I, (∑ s : I, c s t * phi s z) * phi t q := by
    rw [Finset.sum_comm]
    simp only [Finset.sum_mul]
  have inner (z : X) :
      (∑ q : X, mu q *
        (∑ s : I, ∑ t : I, c s t * phi s z * phi t q) ^ 2) =
          ∑ t : I, (∑ s : I, c s t * phi s z) ^ 2 := by
    simp_rw [swap z]
    exact weighted_parseval mu phi orth (fun t => ∑ s : I, c s t * phi s z)
  calc
    (∑ z : X, ∑ q : X, mu z * mu q *
        (∑ s : I, ∑ t : I, c s t * phi s z * phi t q) ^ 2) =
        ∑ z : X, mu z *
          (∑ q : X, mu q *
            (∑ s : I, ∑ t : I, c s t * phi s z * phi t q) ^ 2) := by
      simp only [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro z _
      apply Finset.sum_congr rfl
      intro q _
      ring
    _ = ∑ z : X, mu z * (∑ t : I, (∑ s : I, c s t * phi s z) ^ 2) := by
      simp_rw [inner]
    _ = ∑ t : I, ∑ z : X, mu z * (∑ s : I, c s t * phi s z) ^ 2 := by
      simp only [Finset.mul_sum]
      exact Finset.sum_comm
    _ = ∑ t : I, ∑ s : I, (c s t) ^ 2 := by
      apply Finset.sum_congr rfl
      intro t _
      exact weighted_parseval mu phi orth (fun s => c s t)
    _ = ∑ s : I, ∑ t : I, (c s t) ^ 2 := Finset.sum_comm

/-- Exact finite weighted kernel energy, transported to the protected coefficient
definition. The only structural premise is actual weighted orthonormality;
there is no premise equivalent to the target identity. -/
theorem kernel_energy_eq_coefficient_energy {X : Type v} {I : Type w}
    [Fintype X] [Fintype I] (mu : X → ℝ) (theta : I → ℝ)
    (phi : I → X → ℝ)
    (orth : ∀ i j : I, (∑ x : X, mu x * phi i x * phi j x) =
      spectralKronecker i j) (k r u h : ℕ) :
    kernelEnergy mu theta phi k r u h =
      CoefficientCompensationRequest.energy0 theta (cubicMoment mu phi) k r u h := by
  classical
  unfold kernelEnergy
  simp_rw [kernel_quadratic_form, delta_projection]
  let c : I → I → I → ℝ := fun i s t =>
    (1 / 2 : ℝ) * theta s ^ r * (theta s ^ h - 1) * theta t ^ u *
      cubicMoment mu phi i s t
  change (∑ z : X, ∑ q : X, mu z * mu q *
    (∑ i : I, theta i ^ k * (∑ s : I, ∑ t : I,
      c i s t * phi s z * phi t q) ^ 2)) = _
  have swap :
      (∑ z : X, ∑ q : X, mu z * mu q *
        (∑ i : I, theta i ^ k * (∑ s : I, ∑ t : I,
          c i s t * phi s z * phi t q) ^ 2)) =
        ∑ i : I, theta i ^ k * (∑ z : X, ∑ q : X,
          mu z * mu q * (∑ s : I, ∑ t : I,
            c i s t * phi s z * phi t q) ^ 2) := by
    simp only [Finset.mul_sum]
    calc
      (∑ z : X, ∑ q : X, ∑ i : I, mu z * mu q *
          (theta i ^ k * (∑ s : I, ∑ t : I,
            c i s t * phi s z * phi t q) ^ 2)) =
          ∑ i : I, ∑ z : X, ∑ q : X, mu z * mu q *
            (theta i ^ k * (∑ s : I, ∑ t : I,
              c i s t * phi s z * phi t q) ^ 2) := by
        apply Eq.trans _ (Finset.sum_comm)
        apply Finset.sum_congr rfl
        intro z _
        exact Finset.sum_comm
      _ = _ := by
        apply Finset.sum_congr rfl
        intro i _
        apply Finset.sum_congr rfl
        intro z _
        apply Finset.sum_congr rfl
        intro q _
        ring
  rw [swap]
  simp_rw [tensor_parseval mu phi orth]
  unfold CoefficientCompensationRequest.energy0
  simp only [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro s _
  apply Finset.sum_congr rfl
  intro t _
  dsimp [c]
  rw [show theta s ^ (2 * r) = (theta s ^ r) ^ 2 by
    rw [two_mul, pow_add, pow_two]]
  rw [show theta t ^ (2 * u) = (theta t ^ u) ^ 2 by
    rw [two_mul, pow_add, pow_two]]
  ring

theorem cubic_moment_first_third_symmetry {X : Type v} {I : Type w}
    [Fintype X] (mu : X → ℝ) (phi : I → X → ℝ) (i s t : I) :
    cubicMoment mu phi i s t = cubicMoment mu phi t s i := by
  classical
  unfold cubicMoment
  apply Finset.sum_congr rfl
  intro x _
  ring

/-- The already focused-checked coefficient inequality now applies to the
actual finite kernel energy, conditional on the same scalar majorant. -/
theorem kernel_energy_compensation {X : Type v} {I : Type w}
    [Fintype X] [Fintype I] (mu : X → ℝ) (theta : I → ℝ)
    (phi : I → X → ℝ)
    (orth : ∀ i j : I, (∑ x : X, mu x * phi i x * phi j x) =
      spectralKronecker i j) (k r u l h : ℕ) (c : ℝ)
    (htheta : ∀ i : I, 0 ≤ theta i ∧ theta i ≤ 1)
    (huk : u ≤ k) (hu : 1 ≤ u) (hlr : l ≤ r) (hl : 1 ≤ l)
    (hh : 1 ≤ h) (hc : 0 ≤ c)
    (hscalar : ∀ x : ℝ, 0 ≤ x → x ≤ 1 →
      (1 / 4 : ℝ) * x ^ (r - l) * (1 - x ^ h) ^ 2 ≤ c * (1 + x ^ h)) :
    kernelEnergy mu theta phi k r u h ≤
      c * CoefficientCompensationRequest.diamondTotal theta
        (cubicMoment mu phi) k r u l h := by
  rw [kernel_energy_eq_coefficient_energy mu theta phi orth]
  exact CoefficientCompensationRequest.finite_coefficient_compensation
    I inferInstance theta (cubicMoment mu phi) k r u l h c htheta
    (cubic_moment_first_third_symmetry mu phi) huk hu hlr hl hh hc hscalar

end E593DensityDevelopment.KernelEnergyTransportCandidate
