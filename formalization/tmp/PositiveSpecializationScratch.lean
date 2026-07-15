import Erdos593.Graph.FiniteClosureCardinality
import Erdos593.Graph.FiniteClosureLayeringConstruction
import Erdos593.Graph.MinimalBadCore

/-!
# Scratch: the positive finite-closure specialization

This is scratch-only.  It tests the complete bridge from an uncountable
carrier through a finite-output closure layering, and then specializes that
layering to common-neighbour closures.
-/

namespace Erdos593

namespace PositiveSpecializationScratch

open Set

universe u

variable {V : Type u}

open FiniteClosureCardinality

theorem closureStep_extensive
    (r : Nat) (Phi : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) :
    S ⊆ FiniteClosureCardinality.closureStep r Phi S := fun _ hx => Or.inl hx

theorem mem_iterUnion_iff
    (f : Set V → Set V) (S : Set V) (x : V) :
    x ∈ FiniteClosureCardinality.iterUnion f S ↔ ∃ n : Nat, x ∈ (f^[n]) S := by
  simp [FiniteClosureCardinality.iterUnion]

theorem iterate_stage_succ_subset
    (f : Set V → Set V) (hExt : ∀ T : Set V, T ⊆ f T)
    (S : Set V) (n : Nat) :
    (f^[n]) S ⊆ (f^[n + 1]) S := by
  simpa [Function.iterate_succ_apply'] using hExt ((f^[n]) S)

theorem iterate_stage_mono
    (f : Set V → Set V) (hExt : ∀ T : Set V, T ⊆ f T)
    (S : Set V) {n m : Nat} (hnm : n ≤ m) :
    (f^[n]) S ⊆ (f^[m]) S := by
  obtain ⟨d, rfl⟩ := Nat.le.dest hnm
  induction d with
  | zero => simp
  | succ d ih =>
      exact (ih (Nat.le_add_right _ _)).trans (by
        simpa [Nat.add_assoc] using iterate_stage_succ_subset f hExt S (n + d))

theorem finset_subset_iterate_stage
    (f : Set V → Set V) (hExt : ∀ T : Set V, T ⊆ f T)
    (S : Set V) (s : Finset V) :
    (∀ x ∈ s, x ∈ FiniteClosureCardinality.iterUnion f S) →
      ∃ n : Nat, ∀ x ∈ s, x ∈ (f^[n]) S := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      intro _
      exact ⟨0, by simp⟩
  | @insert a s ha ih =>
      intro hs
      have haUnion : a ∈ FiniteClosureCardinality.iterUnion f S := hs a (by simp)
      rcases (mem_iterUnion_iff f S a).mp haUnion with ⟨na, hna⟩
      have hsUnion : ∀ x ∈ s, x ∈ FiniteClosureCardinality.iterUnion f S := by
        intro x hx
        exact hs x (by simp [hx])
      rcases ih hsUnion with ⟨ns, hns⟩
      refine ⟨max na ns, ?_⟩
      intro x hx
      rcases Finset.mem_insert.mp hx with rfl | hx
      · exact iterate_stage_mono f hExt S (Nat.le_max_left _ _) hna
      · exact iterate_stage_mono f hExt S (Nat.le_max_right _ _) (hns x hx)

theorem closureStep_closure_subset
    (r : Nat) (Phi : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) :
    FiniteClosureCardinality.closureStep r Phi
        (FiniteClosureCardinality.closure r Phi S) ⊆
      FiniteClosureCardinality.closure r Phi S := by
  intro x hx
  rw [FiniteClosureCardinality.mem_closureStep_iff] at hx
  rcases hx with hx | ⟨s, hinside, hxout⟩
  · exact hx
  · have hExt : ∀ T : Set V, T ⊆ FiniteClosureCardinality.closureStep r Phi T :=
      closureStep_extensive r Phi
    obtain ⟨n, hn⟩ :=
      finset_subset_iterate_stage (FiniteClosureCardinality.closureStep r Phi) hExt S s.1 hinside
    apply (mem_iterUnion_iff (FiniteClosureCardinality.closureStep r Phi) S x).mpr
    refine ⟨n + 1, ?_⟩
    have hnext : x ∈ FiniteClosureCardinality.closureStep r Phi
        ((FiniteClosureCardinality.closureStep r Phi)^[n] S) := by
      rw [FiniteClosureCardinality.mem_closureStep_iff]
      exact Or.inr ⟨s, hn, hxout⟩
    simpa [Function.iterate_succ_apply'] using hnext

theorem subset_closure
    (r : Nat) (Phi : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) :
    S ⊆ FiniteClosureCardinality.closure r Phi S := by
  intro x hx
  apply (mem_iterUnion_iff (FiniteClosureCardinality.closureStep r Phi) S x).mpr
  exact ⟨0, by simpa using hx⟩

theorem output_subset_closure
    (r : Nat) (Phi : {s : Finset V // s.card = r} → Finset V)
    (S : Set V) (s : {s : Finset V // s.card = r})
    (hinside : ∀ z ∈ s.1, z ∈ FiniteClosureCardinality.closure r Phi S) :
    ((Phi s : Finset V) : Set V) ⊆ FiniteClosureCardinality.closure r Phi S := by
  intro x hx
  apply closureStep_closure_subset r Phi S
  rw [FiniteClosureCardinality.mem_closureStep_iff]
  exact Or.inr ⟨s, hinside, hx⟩

theorem exists_finiteClosureLayering_of_uncountable
    {r : Nat} (Phi : {s : Finset V // s.card = r} → Finset V)
    (hV : Cardinal.aleph0 < Cardinal.mk V) (hr : 0 < r) :
    Nonempty (FiniteClosureLayering r Phi (Cardinal.mk V).ord.ToType) := by
  classical
  let κ : Cardinal.{u} := Cardinal.mk V
  have hκ : Cardinal.aleph0 < κ := hV
  have hκtype : Cardinal.mk κ.ord.ToType = κ := by simp
  let e : V ≃ κ.ord.ToType :=
    Classical.choice (Cardinal.eq.mp (show Cardinal.mk V = Cardinal.mk κ.ord.ToType by
      change κ = Cardinal.mk κ.ord.ToType
      exact hκtype.symm))
  let C : κ.ord.ToType → Set V := fun i =>
    FiniteClosureCardinality.closure r Phi (e.symm '' Set.Iic i)
  obtain ⟨L, -⟩ :=
    FiniteClosureLayeringConstruction.exists_finiteClosureLayering_of_closed_cover Phi C
      (by
        intro x
        refine ⟨e x, ?_⟩
        apply subset_closure r Phi (e.symm '' Set.Iic (e x))
        exact ⟨e x, by simp, e.symm_apply_apply x⟩)
      (by
        intro i j hij
        apply FiniteClosureCardinality.closure_mono r Phi
        rintro x ⟨a, ha, rfl⟩
        exact ⟨a, ha.trans hij, rfl⟩)
      (by
        intro i
        change Cardinal.mk (FiniteClosureCardinality.closure r Phi (e.symm '' Set.Iic i)) < Cardinal.mk V
        rw [show Cardinal.mk V = κ by rfl]
        apply FiniteClosureCardinality.mk_closure_lt r Phi _ κ hκ
        exact FiniteClosureCardinality.mk_ordClosedInitialImage_lt κ e.symm i hκ)
      (by
        intro i s hs hinside y hy
        exact output_subset_closure r Phi (e.symm '' Set.Iic i) ⟨s, hs⟩ hinside hy)
      hr
  exact ⟨L⟩

theorem exists_commonNeighborLayering_of_uncountable
    (G : _root_.SimpleGraph V) {n : Nat}
    (hfree : IsEmpty (_root_.SimpleGraph.Copy (completeBipartiteNN.{u} n) G))
    (hV : Cardinal.aleph0 < Cardinal.mk V) (hn : 0 < n) :
    Nonempty (FiniteClosureLayering n
      (SimpleGraph.commonNeighborClosure G hfree) (Cardinal.mk V).ord.ToType) :=
  exists_finiteClosureLayering_of_uncountable
    (SimpleGraph.commonNeighborClosure G hfree) hV hn

theorem false_of_minimalBad_positive
    {n : Nat} {kappa : Cardinal.{u}} (G : _root_.SimpleGraph V)
    (hcard : Cardinal.mk V = kappa)
    (hfree : IsEmpty (_root_.SimpleGraph.Copy (completeBipartiteNN.{u} n) G))
    (hbad : ¬ SimpleGraph.CountablyColorable G)
    (hmin : (kappa' : Cardinal.{u}) → kappa' < kappa →
      ¬ SimpleGraph.KNNBadCard n kappa')
    (hn : 0 < n) : False := by
  have hV : Cardinal.aleph0 < Cardinal.mk V :=
    SimpleGraph.aleph0_lt_mk_of_not_countablyColorable G hbad
  obtain ⟨L⟩ := exists_commonNeighborLayering_of_uncountable G hfree hV hn
  exact SimpleGraph.false_of_commonNeighborLayering_of_minimalBad
    G hcard hfree hbad hmin L

theorem countablyColorable_of_KNNFree_positive
    {n : Nat} (G : _root_.SimpleGraph V)
    (hfree : IsEmpty (_root_.SimpleGraph.Copy (completeBipartiteNN.{u} n) G))
    (hn : 0 < n) : SimpleGraph.CountablyColorable G := by
  classical
  by_contra hbad
  obtain ⟨kappa, ⟨W, H, hcard, hbadH, hfreeH⟩, hmin⟩ :=
    SimpleGraph.exists_minimalKNNBadCard (n := n)
      ⟨Cardinal.mk V, V, G, rfl, hbad, hfree⟩
  exact false_of_minimalBad_positive H hcard hfreeH hbadH hmin hn

end PositiveSpecializationScratch

end Erdos593
