import Erdos593.DensityCandidates.ExposureSparsityCandidate
import Erdos593.DensityCandidates.ComplexCertificate
import Erdos593.DensityCandidates.RatioCandidate
import Mathlib.Data.Finset.Sum

/-!
Source-only candidate, 7 October 2026: the actual finite certificate is used
to discharge, rather than assume, every selected-subgraph sparsity input.

Face nodes are labelled by the disjoint sum of the two exposure orders. The
closed bijection below identifies these labels with the original 22 face labels.
The two sigma edge carriers distinguish the two face classes. Thus their sum of
cardinalities counts actual distinct oriented point--face edges exactly once.
No compiler or acceptance claim is made.
-/

namespace E593DensityDevelopment.ComplexSparsity

open Finset
open ComplexCertificate
open ExposureSparsity

abbrev Incidence := Sigma (fun _ : Position => Point)

def taggedFaceLabel : Position ⊕ Position → Face := Sum.elim order0 order1

theorem taggedFaceLabel_bijective : Function.Bijective taggedFaceLabel := by
  decide

def face₀ : Position → Finset Point := fun i => faces (order0 i)
def face₁ : Position → Finset Point := fun i => faces (order1 i)

def fullIncidences₀ : Finset Incidence := selectedIncidences face₀ univ univ
def fullIncidences₁ : Finset Incidence := selectedIncidences face₁ univ univ

theorem card_fullIncidences₀ : fullIncidences₀.card = 33 := by
  simp [fullIncidences₀, selectedIncidences, face₀, card_faces]

theorem card_fullIncidences₁ : fullIncidences₁.card = 33 := by
  simp [fullIncidences₁, selectedIncidences, face₁, card_faces]

theorem selected_incidence_subset_full
    (face : Position → Finset Point) (S : Finset Point) (T : Finset Position) :
    selectedIncidences face S T ⊆ selectedIncidences face univ univ := by
  exact sigma_mono (subset_univ _) (fun _ => by simp)

/-- The universal finite-subgraph sparsity theorem for the displayed complex.
No bound on complete faces or edges is assumed: all are derived from the two
explicit exposure certificates. Empty and singleton point selections occur in
the generic proof, and arbitrary non-induced edge selections are included. -/
theorem complex_subgraph_sparsity
    (S : Finset Point) (T₀ T₁ : Finset Position)
    (E₀ E₁ : Finset Incidence)
    (hE₀ : E₀ ⊆ selectedIncidences face₀ S T₀)
    (hE₁ : E₁ ⊆ selectedIncidences face₁ S T₁)
    (horder : 3 ≤ S.card + T₀.card + T₁.card) :
    E₀.card + E₁.card + 4 ≤ 2 * (S.card + T₀.card + T₁.card) := by
  exact two_exposure_subgraph_sparsity univ univ face₀ face₁ fresh0 fresh1
    (fun i _ => card_faces (order0 i)) (fun i _ => card_faces (order1 i))
    (fun i _ => fresh0_mem i) (fun i _ => fresh1_mem i)
    (fun i _ j _ hij => fresh0_not_earlier i j hij)
    (fun i _ j _ hij => fresh1_not_earlier i j hij)
    S T₀ T₁ (subset_univ _) (subset_univ _) E₀ E₁ hE₀ hE₁ horder

theorem selected_vertex_order_le
    (S : Finset Point) (T₀ T₁ : Finset Position) :
    S.card + T₀.card + T₁.card ≤ 35 := by
  have hS : S.card ≤ 13 := by simpa using S.card_le_univ
  have hT₀ : T₀.card ≤ 11 := by simpa using T₀.card_le_univ
  have hT₁ : T₁.card ≤ 11 := by simpa using T₁.card_le_univ
  omega

/-- The full subgraph includes all point nodes, both complete face classes and
both actual incidence carriers. This allows isolated selected nodes in a proper
subgraph and makes strictness a genuine finite-carrier condition. -/
def IsFullSelection (S : Finset Point) (T₀ T₁ : Finset Position)
    (E₀ E₁ : Finset Incidence) : Prop :=
  S = univ ∧ T₀ = univ ∧ T₁ = univ ∧
    E₀ = fullIncidences₀ ∧ E₁ = fullIncidences₁

theorem proper_selection_counts
    (S : Finset Point) (T₀ T₁ : Finset Position)
    (E₀ E₁ : Finset Incidence)
    (hE₀ : E₀ ⊆ selectedIncidences face₀ S T₀)
    (hE₁ : E₁ ⊆ selectedIncidences face₁ S T₁)
    (hproper : ¬ IsFullSelection S T₀ T₁ E₀ E₁) :
    S.card + T₀.card + T₁.card < 35 ∨ E₀.card + E₁.card < 66 := by
  classical
  have hS : S.card ≤ 13 := by simpa using S.card_le_univ
  have hT₀ : T₀.card ≤ 11 := by simpa using T₀.card_le_univ
  have hT₁ : T₁.card ≤ 11 := by simpa using T₁.card_le_univ
  have hfull₀ : E₀ ⊆ fullIncidences₀ :=
    hE₀.trans (selected_incidence_subset_full face₀ S T₀)
  have hfull₁ : E₁ ⊆ fullIncidences₁ :=
    hE₁.trans (selected_incidence_subset_full face₁ S T₁)
  have hc₀ : E₀.card ≤ 33 := by
    simpa only [card_fullIncidences₀] using card_le_card hfull₀
  have hc₁ : E₁.card ≤ 33 := by
    simpa only [card_fullIncidences₁] using card_le_card hfull₁
  by_contra hnot
  have hnot' : ¬ (S.card + T₀.card + T₁.card < 35 ∨ E₀.card + E₁.card < 66) := hnot
  have hScard : S.card = 13 := by omega
  have hT₀card : T₀.card = 11 := by omega
  have hT₁card : T₁.card = 11 := by omega
  have hE₀card : E₀.card = 33 := by omega
  have hE₁card : E₁.card = 33 := by omega
  apply hproper
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact eq_univ_of_card S (by simpa using hScard)
  · exact eq_univ_of_card T₀ (by simpa using hT₀card)
  · exact eq_univ_of_card T₁ (by simpa using hT₁card)
  · exact eq_of_subset_of_card_le hfull₀ (by rw [card_fullIncidences₀, hE₀card])
  · exact eq_of_subset_of_card_le hfull₁ (by rw [card_fullIncidences₁, hE₁card])

/-- Every eligible proper actual finite subgraph has smaller cross-multiplied
2-density than `65/33`. Positivity of its denominator is recorded explicitly. -/
theorem complex_strict_two_balance
    (S : Finset Point) (T₀ T₁ : Finset Position)
    (E₀ E₁ : Finset Incidence)
    (hE₀ : E₀ ⊆ selectedIncidences face₀ S T₀)
    (hE₁ : E₁ ⊆ selectedIncidences face₁ S T₁)
    (horder : 3 ≤ S.card + T₀.card + T₁.card)
    (hproper : ¬ IsFullSelection S T₀ T₁ E₀ E₁) :
    0 < ((S.card + T₀.card + T₁.card : ℕ) : ℤ) - 2 ∧
      33 * (((E₀.card + E₁.card : ℕ) : ℤ) - 1) <
        65 * (((S.card + T₀.card + T₁.card : ℕ) : ℤ) - 2) := by
  have hsparse := complex_subgraph_sparsity S T₀ T₁ E₀ E₁ hE₀ hE₁ horder
  have htotal := selected_vertex_order_le S T₀ T₁
  have hcounts := proper_selection_counts S T₀ T₁ E₀ E₁ hE₀ hE₁ hproper
  exact Erdos593.DensityDevelopment.incidence_core_strict_balance_cross
    (E₀.card + E₁.card : ℕ) (S.card + T₀.card + T₁.card : ℕ)
    (by omega) (by omega) (by omega) (by omega)

/-- The full actual carrier attains the advertised cross-product density. -/
theorem full_complex_density_counts :
    (univ : Finset Point).card +
      (univ : Finset Position).card + (univ : Finset Position).card = 35 ∧
    fullIncidences₀.card + fullIncidences₁.card = 66 ∧
    33 * ((66 : ℤ) - 1) = 65 * ((35 : ℤ) - 2) := by
  simp [card_fullIncidences₀, card_fullIncidences₁]

end E593DensityDevelopment.ComplexSparsity
