import Mathlib.Data.Finset.Max
import Mathlib.Data.Finset.Union
import Mathlib.Algebra.BigOperators.Group.Finset.Sigma
import Mathlib.Algebra.BigOperators.Group.Finset.Piecewise
import Lean.Elab.Tactic.Omega

/-!
Source-only candidate, 7 October 2026. No compiler run or acceptance is claimed.

The hypotheses are a directly checkable exposure certificate, not a sparsity
assumption: every face has three vertices, and its distinguished vertex is absent
from all earlier faces. The conclusions quantify over arbitrary retained faces
and arbitrary retained point vertices. Incidences are actual finite sigma pairs.
-/

namespace E593DensityDevelopment.ExposureSparsity

open Finset
open scoped BigOperators

variable {ι V : Type*} [DecidableEq V]

/-- Restricting an exposure certificate to any nonempty collection retains
at least two more point vertices than faces. -/
theorem exposed_subset_bound [LinearOrder ι]
    (I : Finset ι) (face : ι → Finset V) (fresh : ι → V)
    (hcard : ∀ i ∈ I, 3 ≤ (face i).card)
    (hmem : ∀ i ∈ I, fresh i ∈ face i)
    (hnew : ∀ i ∈ I, ∀ j ∈ I, j < i → fresh i ∉ face j)
    (T : Finset ι) (hTI : T ⊆ I) (hT : T.Nonempty) :
    T.card + 2 ≤ (T.biUnion face).card := by
  classical
  revert hTI hT
  induction T using Finset.induction_on_max with
  | empty =>
      intro _hTI hT
      simp at hT
  | insert i T hlt ih =>
      intro hTI _hT
      have hiI : i ∈ I := hTI (mem_insert_self i T)
      have hTI' : T ⊆ I := fun j hj => hTI (mem_insert_of_mem hj)
      have hiT : i ∉ T := by
        intro hi
        exact (lt_irrefl i) (hlt i hi)
      by_cases hne : T.Nonempty
      · have hprior := ih hTI' hne
        have hnot : fresh i ∉ T.biUnion face := by
          intro hf
          obtain ⟨j, hj, hfj⟩ := mem_biUnion.mp hf
          exact hnew i hiI j (hTI' hj) (hlt j hj) hfj
        have hsub : insert (fresh i) (T.biUnion face) ⊆
            (insert i T).biUnion face := by
          intro v hv
          rcases mem_insert.mp hv with rfl | hv
          · exact mem_biUnion.mpr ⟨i, mem_insert_self i T, hmem i hiI⟩
          · obtain ⟨j, hj, hvj⟩ := mem_biUnion.mp hv
            exact mem_biUnion.mpr ⟨j, mem_insert_of_mem hj, hvj⟩
        have hstep := card_le_card hsub
        rw [card_insert_of_notMem hnot] at hstep
        rw [card_insert_of_notMem hiT]
        omega
      · have hempty : T = ∅ := not_nonempty_iff_eq_empty.mp hne
        subst T
        simpa using hcard i hiI

/-- Every point set contains at most `card S - 2` complete faces from one
certified class. The empty retained-face case is included. -/
theorem contained_faces_bound [LinearOrder ι]
    (I : Finset ι) (face : ι → Finset V) (fresh : ι → V)
    (hcard : ∀ i ∈ I, 3 ≤ (face i).card)
    (hmem : ∀ i ∈ I, fresh i ∈ face i)
    (hnew : ∀ i ∈ I, ∀ j ∈ I, j < i → fresh i ∉ face j)
    (S : Finset V) (T : Finset ι) (hTI : T ⊆ I) :
    (T.filter fun i => face i ⊆ S).card ≤ S.card - 2 := by
  classical
  let C := T.filter fun i => face i ⊆ S
  have hCI : C ⊆ I := fun i hi => hTI (mem_filter.mp hi).1
  by_cases hC : C.Nonempty
  · have hex := exposed_subset_bound I face fresh hcard hmem hnew C hCI hC
    have hCS : C.biUnion face ⊆ S := by
      intro v hv
      obtain ⟨i, hi, hvi⟩ := mem_biUnion.mp hv
      exact (mem_filter.mp hi).2 hvi
    have hle := card_le_card hCS
    change C.card ≤ S.card - 2
    omega
  · have hempty : C = ∅ := not_nonempty_iff_eq_empty.mp hC
    change C.card ≤ S.card - 2
    simp [hempty]

/-- The selected incidence carrier: one pair for each selected face and each
selected point contained in that face. This is not an assembly-list count. -/
def selectedIncidences (face : ι → Finset V) (S : Finset V) (T : Finset ι) :
    Finset (Σ _ : ι, V) :=
  T.sigma fun i => face i ∩ S

theorem card_selectedIncidences
    (face : ι → Finset V) (S : Finset V) (T : Finset ι) :
    (selectedIncidences face S T).card = ∑ i ∈ T, (face i ∩ S).card := by
  exact Finset.card_sigma T (fun i => face i ∩ S)

theorem intersect_triangle_bound
    (A S : Finset V) (hA : A.card = 3) :
    (A ∩ S).card ≤ 2 + if A ⊆ S then 1 else 0 := by
  classical
  by_cases hAS : A ⊆ S
  · rw [if_pos hAS, inter_eq_left.mpr hAS, hA]
  · rw [if_neg hAS]
    have hne : A ∩ S ≠ A := by
      intro heq
      exact hAS (inter_eq_left.mp heq)
    have hlt : (A ∩ S).card < A.card :=
      card_lt_card (ssubset_iff_subset_ne.mpr ⟨inter_subset_left, hne⟩)
    omega

/-- A triangular face has at most two incidences unless all three of its point
vertices are retained. -/
theorem triangle_incidence_bound
    (face : ι → Finset V) (S : Finset V) (T : Finset ι)
    (hcard : ∀ i ∈ T, (face i).card = 3) :
    (selectedIncidences face S T).card ≤
      2 * T.card + (T.filter fun i => face i ⊆ S).card := by
  classical
  rw [card_selectedIncidences]
  calc
    (∑ i ∈ T, (face i ∩ S).card) ≤
        ∑ i ∈ T, (2 + if face i ⊆ S then 1 else 0) := by
      exact sum_le_sum fun i hi => intersect_triangle_bound (face i) S (hcard i hi)
    _ = 2 * T.card + (T.filter fun i => face i ⊆ S).card := by
      rw [sum_add_distrib, ← Finset.card_filter]
      simp [Nat.mul_comm]

theorem selected_incidence_point_bound
    (face : ι → Finset V) (S : Finset V) (T : Finset ι) :
    (selectedIncidences face S T).card ≤ T.card * S.card := by
  classical
  rw [card_selectedIncidences]
  calc
    (∑ i ∈ T, (face i ∩ S).card) ≤ ∑ _i ∈ T, S.card :=
      sum_le_sum fun _i _hi => card_le_card inter_subset_right
    _ = T.card * S.card := by simp

/-- Two certified triangular classes force the universal Levi-incidence
inequality. Face selections and point selections are completely arbitrary;
the only size condition is that at least three vertex-nodes are retained. -/
theorem two_exposure_incidence_sparsity [LinearOrder ι]
    (I₀ I₁ : Finset ι) (face₀ face₁ : ι → Finset V)
    (fresh₀ fresh₁ : ι → V)
    (hcard₀ : ∀ i ∈ I₀, (face₀ i).card = 3)
    (hcard₁ : ∀ i ∈ I₁, (face₁ i).card = 3)
    (hmem₀ : ∀ i ∈ I₀, fresh₀ i ∈ face₀ i)
    (hmem₁ : ∀ i ∈ I₁, fresh₁ i ∈ face₁ i)
    (hnew₀ : ∀ i ∈ I₀, ∀ j ∈ I₀, j < i → fresh₀ i ∉ face₀ j)
    (hnew₁ : ∀ i ∈ I₁, ∀ j ∈ I₁, j < i → fresh₁ i ∉ face₁ j)
    (S : Finset V) (T₀ T₁ : Finset ι)
    (hT₀ : T₀ ⊆ I₀) (hT₁ : T₁ ⊆ I₁)
    (horder : 3 ≤ S.card + T₀.card + T₁.card) :
    (selectedIncidences face₀ S T₀).card +
      (selectedIncidences face₁ S T₁).card + 4 ≤
      2 * (S.card + T₀.card + T₁.card) := by
  classical
  by_cases hS : 2 ≤ S.card
  · have hc₀ := contained_faces_bound I₀ face₀ fresh₀
      (fun i hi => by rw [hcard₀ i hi]) hmem₀ hnew₀ S T₀ hT₀
    have hc₁ := contained_faces_bound I₁ face₁ fresh₁
      (fun i hi => by rw [hcard₁ i hi]) hmem₁ hnew₁ S T₁ hT₁
    have he₀ := triangle_incidence_bound face₀ S T₀ (fun i hi => hcard₀ i (hT₀ hi))
    have he₁ := triangle_incidence_bound face₁ S T₁ (fun i hi => hcard₁ i (hT₁ hi))
    omega
  · have he₀ := selected_incidence_point_bound face₀ S T₀
    have he₁ := selected_incidence_point_bound face₁ S T₁
    have hsmall : S.card = 0 ∨ S.card = 1 := by omega
    rcases hsmall with hzero | hone
    · rw [hzero] at he₀ he₁ horder ⊢
      omega
    · rw [hone] at he₀ he₁ horder ⊢
      omega

/-- Retaining fewer incidence edges cannot invalidate the bound. This
explicitly includes non-induced subgraphs, not just induced selections. -/
theorem two_exposure_subgraph_sparsity [LinearOrder ι]
    (I₀ I₁ : Finset ι) (face₀ face₁ : ι → Finset V)
    (fresh₀ fresh₁ : ι → V)
    (hcard₀ : ∀ i ∈ I₀, (face₀ i).card = 3)
    (hcard₁ : ∀ i ∈ I₁, (face₁ i).card = 3)
    (hmem₀ : ∀ i ∈ I₀, fresh₀ i ∈ face₀ i)
    (hmem₁ : ∀ i ∈ I₁, fresh₁ i ∈ face₁ i)
    (hnew₀ : ∀ i ∈ I₀, ∀ j ∈ I₀, j < i → fresh₀ i ∉ face₀ j)
    (hnew₁ : ∀ i ∈ I₁, ∀ j ∈ I₁, j < i → fresh₁ i ∉ face₁ j)
    (S : Finset V) (T₀ T₁ : Finset ι)
    (hT₀ : T₀ ⊆ I₀) (hT₁ : T₁ ⊆ I₁)
    (E₀ E₁ : Finset (Σ _ : ι, V))
    (hE₀ : E₀ ⊆ selectedIncidences face₀ S T₀)
    (hE₁ : E₁ ⊆ selectedIncidences face₁ S T₁)
    (horder : 3 ≤ S.card + T₀.card + T₁.card) :
    E₀.card + E₁.card + 4 ≤ 2 * (S.card + T₀.card + T₁.card) := by
  have hbound := two_exposure_incidence_sparsity I₀ I₁ face₀ face₁ fresh₀ fresh₁
    hcard₀ hcard₁ hmem₀ hmem₁ hnew₀ hnew₁ S T₀ T₁ hT₀ hT₁ horder
  have he₀ := card_le_card hE₀
  have he₁ := card_le_card hE₁
  omega

end E593DensityDevelopment.ExposureSparsity
