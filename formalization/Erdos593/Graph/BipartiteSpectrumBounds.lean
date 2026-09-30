import Erdos593.Graph.FiniteForestCounting
import Mathlib.Combinatorics.SimpleGraph.Bipartite
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Algebra.Order.Floor.Ring

/-!
# Exact finite bipartite spectrum bounds

The ceiling is the literal real-square-root ceiling. The lower bound is
proved by integer capacity concentration over the actual component family.
-/

namespace Erdos593.Spectrum

/-- The exact rounding term in the order-size spectrum. -/
noncomputable def q (r : ℕ) : ℕ := ⌈2 * Real.sqrt (r : ℝ)⌉₊

theorem q_le_iff (r t : ℕ) : q r ≤ t ↔ 4 * r ≤ t ^ 2 := by
  rw [q, Nat.ceil_le]
  have hs : (Real.sqrt (r : ℝ)) ^ 2 = r := Real.sq_sqrt (by positivity)
  have hnonneg : 0 ≤ 2 * Real.sqrt (r : ℝ) := by positivity
  have ht : (0 : ℝ) ≤ t := by positivity
  constructor
  · intro h
    have hh := (sq_le_sq₀ hnonneg ht).mpr h
    have hreal : (4 : ℝ) * r ≤ (t : ℝ) ^ 2 := by nlinarith
    exact_mod_cast hreal
  · intro h
    have hreal : (4 : ℝ) * r ≤ (t : ℝ) ^ 2 := by exact_mod_cast h
    apply (sq_le_sq₀ hnonneg ht).mp
    nlinarith

/-- Concentration of nonnegative integer excess, including an empty index set. -/
theorem capacity_sum {ι : Type*} (s : Finset ι) (a d : ι → ℕ)
    (h : ∀ i ∈ s, 4 * a i ≤ (d i) ^ 2 + 4 * d i) :
    4 * (∑ i ∈ s, a i) ≤ (∑ i ∈ s, d i) ^ 2 + 4 * (∑ i ∈ s, d i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
    have hi' := h i (Finset.mem_insert_self i s)
    have ih' := ih (fun j hj => h j (Finset.mem_insert_of_mem hj))
    simp only [Finset.sum_insert hi]
    nlinarith [Nat.zero_le (d i * ∑ j ∈ s, d j)]

end Erdos593.Spectrum

namespace SimpleGraph.BipartiteSpectrumBounds

universe u

open scoped Sym2

private def componentEdgeMap {V : Type u} (G : SimpleGraph V) :
    (Σ C : G.ConnectedComponent, C.toSimpleGraph.edgeSet) → G.edgeSet :=
  fun e => e.1.toSimpleGraph_hom.mapEdgeSet e.2

private theorem componentEdgeMap_bijective {V : Type u} (G : SimpleGraph V) :
    Function.Bijective (componentEdgeMap G) := by
  constructor
  · rintro ⟨C, e⟩ ⟨D, f⟩ h
    have hCD : C = D := by
      rcases e with ⟨e, he⟩
      rcases f with ⟨f, hf⟩
      induction e using Sym2.inductionOn with
      | _ a b =>
        induction f using Sym2.inductionOn with
        | _ x y =>
          have hh := congrArg Subtype.val h
          change s((a : V), (b : V)) = s((x : V), (y : V)) at hh
          rcases Sym2.eq_iff.mp hh with hh | hh
          · exact a.property.symm.trans
              ((congrArg G.connectedComponentMk hh.1).trans x.property)
          · exact a.property.symm.trans
              ((congrArg G.connectedComponentMk hh.1).trans y.property)
    subst D
    have hef : e = f :=
      Hom.mapEdgeSet.injective C.toSimpleGraph_hom Subtype.val_injective h
    exact congrArg (Sigma.mk C) hef
  · rintro ⟨e, he⟩
    induction e using Sym2.inductionOn with
    | _ x y =>
      let C := G.connectedComponentMk x
      have hx : x ∈ C.supp := rfl
      have hy : y ∈ C.supp := C.mem_supp_of_adj_mem_supp hx he
      exact ⟨⟨C, ⟨s((⟨x, hx⟩ : C), ⟨y, hy⟩), he⟩⟩, rfl⟩

theorem edge_count_components {V : Type u} [Finite V] (G : SimpleGraph V)
    [Fintype G.ConnectedComponent] :
    Nat.card G.edgeSet = ∑ C : G.ConnectedComponent, Nat.card C.toSimpleGraph.edgeSet := by
  rw [← Nat.card_sigma]
  exact (Nat.card_congr
    (Equiv.ofBijective (componentEdgeMap G) (componentEdgeMap_bijective G))).symm

theorem vertex_count_components {V : Type u} [Finite V] (G : SimpleGraph V)
    [Fintype G.ConnectedComponent] :
    Nat.card V = ∑ C : G.ConnectedComponent, Nat.card C := by
  rw [← Nat.card_sigma]
  exact (Nat.card_congr (Equiv.sigmaFiberEquiv G.connectedComponentMk)).symm

theorem bipartite_capacity {V : Type u} [Finite V] (G : SimpleGraph V)
    (hb : G.Colorable 2) : 4 * Nat.card G.edgeSet ≤ (Nat.card V) ^ 2 := by
  have h := SimpleGraph.IsBipartite.four_mul_encard_edgeSet_le hb
  rw [← G.edgeSet.toFinite.cast_ncard_eq, ENat.card_eq_coe_natCard] at h
  rw [Nat.card_coe_set_eq]
  exact_mod_cast h

/-- Bounds on an actual finite simple bipartite graph with no isolated vertices.
The component count is derived from its quotient, not supplied as a parameter. -/
theorem parameter_bounds {V : Type u} [Finite V] (G : SimpleGraph V)
    (hb : G.Colorable 2) (hnoiso : ∀ x, ∃ y, G.Adj x y)
    (hne : Nonempty G.edgeSet) :
    1 ≤ Nat.card G.ConnectedComponent ∧
    Nat.card G.ConnectedComponent ≤ Nat.card G.edgeSet ∧
    2 * (Nat.card G.ConnectedComponent - 1) +
        Erdos593.Spectrum.q (Nat.card G.edgeSet - Nat.card G.ConnectedComponent + 1)
      ≤ Nat.card V ∧
    Nat.card V ≤ Nat.card G.edgeSet + Nat.card G.ConnectedComponent := by
  classical
  letI := Fintype.ofFinite V
  letI := Fintype.ofFinite G.ConnectedComponent
  let r (C : G.ConnectedComponent) := Nat.card C.toSimpleGraph.edgeSet
  let t (C : G.ConnectedComponent) := Nat.card C
  have hr : ∀ C, 1 ≤ r C := by
    intro C
    obtain ⟨y, hy⟩ := hnoiso C.out
    have hx : C.out ∈ C.supp := C.out_eq
    have hyC := C.mem_supp_of_adj_mem_supp hx hy
    haveI : Nonempty C.toSimpleGraph.edgeSet :=
      ⟨⟨s((⟨C.out, hx⟩ : C), ⟨y, hyC⟩), hy⟩⟩
    exact Nat.card_pos
  have ht : ∀ C, 2 ≤ t C := by
    intro C
    obtain ⟨y, hy⟩ := hnoiso C.out
    have hx : C.out ∈ C.supp := C.out_eq
    have hyC := C.mem_supp_of_adj_mem_supp hx hy
    have hxy : (⟨C.out, hx⟩ : C) ≠ ⟨y, hyC⟩ := by
      intro h
      exact hy.ne (congrArg Subtype.val h)
    haveI : Nontrivial C := ⟨⟨_, _, hxy⟩⟩
    letI := Fintype.ofFinite C
    change 2 ≤ Nat.card C
    rw [Nat.card_eq_fintype_card]
    exact Fintype.one_lt_card
  have hcap : ∀ C, 4 * r C ≤ (t C) ^ 2 := by
    intro C
    obtain ⟨col⟩ := hb
    exact bipartite_capacity C.toSimpleGraph ⟨col.comp C.toSimpleGraph_hom⟩
  have hup : ∀ C, t C ≤ r C + 1 :=
    fun C => C.connected_toSimpleGraph.card_vert_le_card_edgeSet_add_one
  have he := edge_count_components G
  have hv := vertex_count_components G
  change Nat.card G.edgeSet = ∑ C, r C at he
  change Nat.card V = ∑ C, t C at hv
  have hcpos : 1 ≤ Nat.card G.ConnectedComponent := by
    obtain ⟨e, he'⟩ := hne
    induction e using Sym2.inductionOn with
    | _ x y =>
      haveI : Nonempty G.ConnectedComponent := ⟨G.connectedComponentMk x⟩
      exact Nat.card_pos
  have hclt : Nat.card G.ConnectedComponent ≤ Nat.card G.edgeSet := by
    rw [he, Nat.card_eq_fintype_card]
    simpa using Finset.sum_le_sum (fun C (_ : C ∈ Finset.univ) => hr C)
  let a (C : G.ConnectedComponent) := r C - 1
  let d (C : G.ConnectedComponent) := t C - 2
  have hra : ∀ C, r C = a C + 1 := fun C => by dsimp [a]; have := hr C; omega
  have htd : ∀ C, t C = d C + 2 := fun C => by dsimp [d]; have := ht C; omega
  have ha : Nat.card G.edgeSet = (∑ C, a C) + Nat.card G.ConnectedComponent := by
    rw [he]
    simp_rw [hra]
    simp [Finset.sum_add_distrib, Nat.card_eq_fintype_card]
  have hd : Nat.card V = (∑ C, d C) + 2 * Nat.card G.ConnectedComponent := by
    rw [hv]
    simp_rw [htd]
    simp [Finset.sum_add_distrib, Nat.card_eq_fintype_card, mul_comm]
  have hsum := Erdos593.Spectrum.capacity_sum Finset.univ a d (fun C _ => by
    have hh := hcap C
    rw [hra C, htd C] at hh
    nlinarith)
  have hql : Erdos593.Spectrum.q
      (Nat.card G.edgeSet - Nat.card G.ConnectedComponent + 1) ≤ (∑ C, d C) + 2 := by
    apply (Erdos593.Spectrum.q_le_iff _ _).mpr
    have hsub : Nat.card G.edgeSet - Nat.card G.ConnectedComponent = ∑ C, a C := by omega
    rw [hsub]
    nlinarith
  refine ⟨hcpos, hclt, ?_, ?_⟩
  · omega
  · have hh := Finset.sum_le_sum (fun C (_ : C ∈ Finset.univ) => hup C)
    simpa [Finset.sum_add_distrib, ← he, ← hv, Nat.card_eq_fintype_card] using hh

end SimpleGraph.BipartiteSpectrumBounds
