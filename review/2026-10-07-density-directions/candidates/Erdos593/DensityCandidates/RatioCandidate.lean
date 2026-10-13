import Mathlib.Tactic.Linarith

/-!
# Conditional arithmetic bridge for the selected incidence complex

This is an UNCOMPILED candidate, not a theorem about any graph by itself.
The inputs `e` and `v` stand for the actual edge and vertex counts of a selected
subgraph.  The selected-face argument must separately establish
`e ≤ 2 * v - 4`, `3 ≤ v`, and `v ≤ 35`.  Properness must separately imply
`v < 35 ∨ e < 66`.

Counts are represented in `ℤ`, so `e - 1` remains negative when `e = 0`.
There is no truncated natural-number subtraction hidden in the ratio bound.
The cross-products below encode the denominator-positive ratio comparisons
without requiring division or a supremum over subgraphs.

For an `r`-uniform private expansion with `f` selected core edges and `v`
core vertices, the minimal vertex count is `(r - 2) * f + v`.  Identifying
this number with an actual selected expanded subgraph remains a separate
geometric obligation.  Additional isolated vertices only enlarge that count,
but that transport is not asserted here.
-/

namespace Erdos593.DensityDevelopment

/-- The selected incidence sparsity bound gives the weak `65 / 33` ratio bound. -/
theorem incidence_core_balance_cross
    (e v : ℤ) (h_vertices : 3 ≤ v) (h_total : v ≤ 35)
    (h_sparse : e ≤ 2 * v - 4) :
    0 < v - 2 ∧ 33 * (e - 1) ≤ 65 * (v - 2) := by
  constructor <;> linarith

/-- Every proper selection has a strictly smaller ratio, once properness is supplied. -/
theorem incidence_core_strict_balance_cross
    (e v : ℤ) (h_vertices : 3 ≤ v) (h_total : v ≤ 35)
    (h_sparse : e ≤ 2 * v - 4) (h_proper : v < 35 ∨ e < 66) :
    0 < v - 2 ∧ 33 * (e - 1) < 65 * (v - 2) := by
  constructor
  · linarith
  · rcases h_proper with h_less_vertices | h_less_edges
    · linarith
    · linarith

/-- Equality of the cross-products forces the full `35`-vertex, `66`-edge counts. -/
theorem incidence_core_balance_equality_iff
    (e v : ℤ) (h_total : v ≤ 35) (h_sparse : e ≤ 2 * v - 4) :
    33 * (e - 1) = 65 * (v - 2) ↔ e = 66 ∧ v = 35 := by
  constructor
  · intro h_equal
    constructor <;> linarith
  · rintro ⟨rfl, rfl⟩
    norm_num

/-- The private-expansion comparison has exactly the same slack as the core comparison. -/
theorem private_expansion_balance_slack (r f v : ℤ) :
    65 * ((r - 2) * f + v - r) - (65 * r - 97) * (f - 1) =
      65 * (v - 2) - 33 * (f - 1) := by
  ring

/-- Substituting the full core counts gives the total and denominator constants. -/
theorem full_incidence_private_expansion_counts (r : ℤ) :
    (r - 2) * 66 + 35 = 66 * r - 97 ∧
      (r - 2) * 66 + 35 - r = 65 * r - 97 := by
  constructor <;> ring

/-- The expanded denominator is positive for at least two edges and three core vertices. -/
theorem private_expansion_denominator_pos
    (r f v : ℤ) (h_uniformity : 2 ≤ r) (h_edges : 2 ≤ f)
    (h_vertices : 3 ≤ v) :
    0 < (r - 2) * f + v - r := by
  have h_product : 0 ≤ (r - 2) * (f - 1) :=
    mul_nonneg (by linarith) (by linarith)
  nlinarith

/-- Weak balance transports algebraically through the private expansion formula. -/
theorem private_expansion_balance_cross
    (r f v : ℤ) (h_core : 33 * (f - 1) ≤ 65 * (v - 2)) :
    (65 * r - 97) * (f - 1) ≤ 65 * ((r - 2) * f + v - r) := by
  have h_slack := private_expansion_balance_slack r f v
  nlinarith

/-- Strict balance transports algebraically through the same formula. -/
theorem private_expansion_strict_balance_cross
    (r f v : ℤ) (h_core : 33 * (f - 1) < 65 * (v - 2)) :
    (65 * r - 97) * (f - 1) < 65 * ((r - 2) * f + v - r) := by
  have h_slack := private_expansion_balance_slack r f v
  nlinarith

/-- The complete weak ratio certificate, conditional on actual selected-count inputs. -/
theorem selected_incidence_expansion_balance
    (r f v : ℤ) (h_uniformity : 2 ≤ r) (h_edges : 2 ≤ f)
    (h_vertices : 3 ≤ v) (h_total : v ≤ 35)
    (h_sparse : f ≤ 2 * v - 4) :
    0 < 65 * r - 97 ∧
      0 < (r - 2) * f + v - r ∧
      (65 * r - 97) * (f - 1) ≤ 65 * ((r - 2) * f + v - r) := by
  refine ⟨by linarith,
    private_expansion_denominator_pos r f v h_uniformity h_edges h_vertices, ?_⟩
  exact private_expansion_balance_cross r f v
    (incidence_core_balance_cross f v h_vertices h_total h_sparse).2

/-- The complete strict certificate also needs genuine properness of the selection. -/
theorem selected_incidence_expansion_strict_balance
    (r f v : ℤ) (h_uniformity : 2 ≤ r) (h_edges : 2 ≤ f)
    (h_vertices : 3 ≤ v) (h_total : v ≤ 35)
    (h_sparse : f ≤ 2 * v - 4) (h_proper : v < 35 ∨ f < 66) :
    0 < 65 * r - 97 ∧
      0 < (r - 2) * f + v - r ∧
      (65 * r - 97) * (f - 1) < 65 * ((r - 2) * f + v - r) := by
  refine ⟨by linarith,
    private_expansion_denominator_pos r f v h_uniformity h_edges h_vertices, ?_⟩
  exact private_expansion_strict_balance_cross r f v
    (incidence_core_strict_balance_cross f v h_vertices h_total h_sparse h_proper).2

end Erdos593.DensityDevelopment
