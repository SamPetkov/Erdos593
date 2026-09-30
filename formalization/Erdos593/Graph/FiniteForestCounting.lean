import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceForestOrder
import Mathlib.Combinatorics.SimpleGraph.Acyclic
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Finite
import Mathlib.Logic.Equiv.Sum
import Mathlib.SetTheory.Cardinal.Finite

/-!
# Finite forest and incidence accounting

Edges are unordered graph edges. Component equivalences below are obtained
from explicit vertex maps and paths, not from a cardinality hypothesis.
-/

namespace SimpleGraph.FiniteForestCounting

universe u v

open scoped Sym2

theorem map_reachable {V : Type u} {W : Type v}
    {G : SimpleGraph V} {H : SimpleGraph W} (f : V → W)
    (hf : ∀ ⦃x y⦄, G.Adj x y → H.Reachable (f x) (f y))
    {x y : V} (h : G.Reachable x y) : H.Reachable (f x) (f y) := by
  obtain ⟨p⟩ := h
  induction p with
  | nil => exact .rfl
  | cons h _ ih => exact (hf h).trans ih

/-- Maps inverse up to paths induce inverse maps on actual component types. -/
noncomputable def componentEquivOfReachable {V : Type u} {W : Type v}
    (G : SimpleGraph V) (H : SimpleGraph W) (f : V → W) (g : W → V)
    (hf : ∀ ⦃x y⦄, G.Adj x y → H.Reachable (f x) (f y))
    (hg : ∀ ⦃x y⦄, H.Adj x y → G.Reachable (g x) (g y))
    (hgf : ∀ x, G.Reachable (g (f x)) x)
    (hfg : ∀ y, H.Reachable (f (g y)) y) :
    G.ConnectedComponent ≃ H.ConnectedComponent where
  toFun := Quot.lift (fun x => H.connectedComponentMk (f x))
    (fun _ _ h => ConnectedComponent.sound (map_reachable f hf h))
  invFun := Quot.lift (fun y => G.connectedComponentMk (g y))
    (fun _ _ h => ConnectedComponent.sound (map_reachable g hg h))
  left_inv C := C.ind (fun x => ConnectedComponent.sound (hgf x))
  right_inv C := C.ind (fun y => ConnectedComponent.sound (hfg y))

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

/-- Finite forest Euler identity, including empty graphs and isolated vertices. -/
theorem card_edges_add_components {V : Type u} [Finite V]
    (G : SimpleGraph V) (hG : G.IsAcyclic) :
    Nat.card G.edgeSet + Nat.card G.ConnectedComponent = Nat.card V := by
  classical
  letI := Fintype.ofFinite V
  letI := Fintype.ofFinite G.ConnectedComponent
  have he : Nat.card G.edgeSet =
      ∑ C : G.ConnectedComponent, Nat.card C.toSimpleGraph.edgeSet := by
    rw [← Nat.card_sigma]
    exact (Nat.card_congr
      (Equiv.ofBijective (componentEdgeMap G) (componentEdgeMap_bijective G))).symm
  have hv : Nat.card V = ∑ C : G.ConnectedComponent, Nat.card C := by
    rw [← Nat.card_sigma]
    exact (Nat.card_congr (Equiv.sigmaFiberEquiv G.connectedComponentMk)).symm
  have hc : ∀ C : G.ConnectedComponent,
      Nat.card C.toSimpleGraph.edgeSet + 1 = Nat.card C :=
    fun C => (isTree_iff_connected_and_card.mp (hG.isTree_connectedComponent C)).2
  rw [he, hv, Nat.card_eq_fintype_card]
  simpa only [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ,
    smul_eq_mul, mul_one] using
    (Finset.sum_congr rfl (fun C (_ : C ∈ Finset.univ) => hc C))

private def incidenceEdgeMap {A : Type u} {P : Type v} (r : A → P → Prop) :
    (Σ a : A, {p : P // r a p}) → (bipartiteIncidenceGraph r).edgeSet :=
  fun z => ⟨s(Sum.inl z.1, Sum.inr z.2.val),
    (bipartiteIncidenceGraph_adj_inl_inr_iff r z.1 z.2.val).mpr z.2.property⟩

private theorem incidenceEdgeMap_bijective {A : Type u} {P : Type v}
    (r : A → P → Prop) : Function.Bijective (incidenceEdgeMap r) := by
  constructor
  · rintro ⟨a, p, hp⟩ ⟨b, q, hq⟩ h
    have hh := congrArg Subtype.val h
    change s(Sum.inl a, Sum.inr p) = s(Sum.inl b, Sum.inr q) at hh
    rcases Sym2.eq_iff.mp hh with hh | hh
    · have hab := Sum.inl.inj hh.1
      have hpq := Sum.inr.inj hh.2
      subst b
      subst q
      rfl
    · cases hh.1
  · rintro ⟨e, he⟩
    induction e using Sym2.inductionOn with
    | _ x y =>
      rcases x with a | p <;> rcases y with b | q
      · simp [bipartiteIncidenceGraph] at he
      · exact ⟨⟨a, q, (bipartiteIncidenceGraph_adj_inl_inr_iff r a q).mp he⟩, rfl⟩
      · refine ⟨⟨b, p, (bipartiteIncidenceGraph_adj_inr_inl_iff r b p).mp he⟩, ?_⟩
        exact Subtype.ext Sym2.eq_swap
      · simp [bipartiteIncidenceGraph] at he

/-- Count each incidence once, rather than counting the two oriented darts. -/
theorem card_incidence_edges {A : Type u} {P : Type v} [Fintype A] [Finite P]
    (r : A → P → Prop) :
    Nat.card (bipartiteIncidenceGraph r).edgeSet =
      ∑ a : A, Nat.card {p : P // r a p} := by
  rw [← Nat.card_sigma]
  exact (Nat.card_congr
    (Equiv.ofBijective (incidenceEdgeMap r) (incidenceEdgeMap_bijective r))).symm

/-- The two ways of summing a finite incidence relation agree. -/
theorem sum_card_incidence_comm {A : Type u} {P : Type v}
    [Fintype A] [Fintype P] (r : A → P → Prop) :
    (∑ a : A, Nat.card {p : P // r a p}) =
      ∑ p : P, Nat.card {a : A // r a p} := by
  rw [← Nat.card_sigma, ← Nat.card_sigma]
  exact Nat.card_congr
    { toFun := fun z => ⟨z.2.val, z.1, z.2.property⟩
      invFun := fun z => ⟨z.2.val, z.1, z.2.property⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }

/-- Removing right-side leaves preserves components when every right vertex
has an incident left vertex and every left vertex is retained. In particular,
isolated left vertices remain as components of the pruned graph. -/
noncomputable def pruneComponentEquiv {A : Type u} {P : Type v}
    [Fintype P] [DecidableEq A] [DecidableEq P]
    (r : A → P → Prop) [DecidableRel r] (t : Finset A)
    (hcover : ∀ a, a ∈ t) (hpoint : ∀ p, ∃ a, r a p) :
    (bipartiteIncidenceGraph r).ConnectedComponent ≃
      ((bipartiteIncidenceGraph r).induce
        (↑(bipartitePruneVertices r t) : Set (A ⊕ P))).ConnectedComponent := by
  classical
  let S := sharedRightPoints r t
  let X := (↑(bipartitePruneVertices r t) : Set (A ⊕ P))
  let H := bipartiteIncidenceGraph r
  let K := H.induce X
  let root : P → A := fun p => Classical.choose (hpoint p)
  have hroot : ∀ p, r (root p) p := fun p => Classical.choose_spec (hpoint p)
  let liftA : A → X := fun a => ⟨.inl a, by
    change Sum.inl a ∈ bipartitePruneVertices r t
    simpa only [mem_bipartitePruneVertices_inl] using hcover a⟩
  let liftP : (p : P) → p ∈ S → X := fun p hp => ⟨.inr p, by
    change Sum.inr p ∈ bipartitePruneVertices r t
    simpa only [mem_bipartitePruneVertices_inr] using hp⟩
  let f : A ⊕ P → X
    | .inl a => liftA a
    | .inr p => if hp : p ∈ S then liftP p hp else liftA (root p)
  have hunique : ∀ p, p ∉ S → ∀ a, r a p → a = root p := by
    intro p hp a ha
    have hsmall : (t.filter (fun a => r a p)).card ≤ 1 := by
      have hnot : ¬ 2 ≤ (t.filter (fun a => r a p)).card := by
        simpa only [S, mem_sharedRightPoints] using hp
      omega
    exact Finset.card_le_one.mp hsmall a
      (Finset.mem_filter.mpr ⟨hcover a, ha⟩) (root p)
      (Finset.mem_filter.mpr ⟨hcover (root p), hroot p⟩)
  have hforward : ∀ a p, r a p → K.Reachable (f (.inl a)) (f (.inr p)) := by
    intro a p ha
    by_cases hp : p ∈ S
    · simp only [f, dif_pos hp]
      apply Adj.reachable
      exact (bipartiteIncidenceGraph_adj_inl_inr_iff r a p).mpr ha
    · simp only [f, dif_neg hp]
      rw [hunique p hp a ha]
  refine componentEquivOfReachable H K f Subtype.val ?_ ?_ ?_ ?_
  · intro x y h
    rcases x with a | p <;> rcases y with b | q
    · simp [H, bipartiteIncidenceGraph] at h
    · exact hforward a q ((bipartiteIncidenceGraph_adj_inl_inr_iff r a q).mp h)
    · exact (hforward b p ((bipartiteIncidenceGraph_adj_inr_inl_iff r b p).mp h)).symm
    · simp [H, bipartiteIncidenceGraph] at h
  · intro x y h
    exact (show H.Adj (x : A ⊕ P) (y : A ⊕ P) from h).reachable
  · intro x
    rcases x with a | p
    · exact .rfl
    · by_cases hp : p ∈ S
      · simp only [f, dif_pos hp]
        exact .rfl
      · simp only [f, dif_neg hp]
        exact ((bipartiteIncidenceGraph_adj_inl_inr_iff r (root p) p).mpr (hroot p)).reachable
  · rintro ⟨x, hx⟩
    rcases x with a | p
    · exact .rfl
    · have hp : p ∈ S := by
        simpa only [X, Finset.mem_coe, mem_bipartitePruneVertices_inr] using hx
      simp only [f, dif_pos hp]
      exact .rfl

/-- The pruned graph has precisely all left vertices and the shared right
vertices. This is an isomorphism of the existing induced graph, not a change
of the pruning definition. -/
noncomputable def pruneGraphIso {A : Type u} {P : Type v}
    [Fintype P] [DecidableEq A] [DecidableEq P]
    (r : A → P → Prop) [DecidableRel r] (t : Finset A)
    (hcover : ∀ a, a ∈ t) :
    bipartiteIncidenceGraph (fun a (p : ↥(sharedRightPoints r t)) => r a p.val) ≃g
      (bipartiteIncidenceGraph r).induce
        (↑(bipartitePruneVertices r t) : Set (A ⊕ P)) := by
  let e : (A ⊕ ↥(sharedRightPoints r t)) ≃
      ↥(↑(bipartitePruneVertices r t) : Set (A ⊕ P)) :=
    { toFun := fun z => match z with
        | .inl a => ⟨.inl a, (mem_bipartitePruneVertices_inl r t a).mpr (hcover a)⟩
        | .inr p => ⟨.inr p.val, (mem_bipartitePruneVertices_inr r t p.val).mpr p.property⟩
      invFun := fun z => match z with
        | ⟨.inl a, _⟩ => .inl a
        | ⟨.inr p, hp⟩ => .inr ⟨p, (mem_bipartitePruneVertices_inr r t p).mp hp⟩
      left_inv := by
        rintro (a | ⟨p, hp⟩) <;> rfl
      right_inv := by
        rintro ⟨a | p, h⟩ <;> rfl }
  exact
    { toEquiv := e
      map_rel_iff' := by
        rintro (a | p) (b | q) <;> simp [e, bipartiteIncidenceGraph] }

end SimpleGraph.FiniteForestCounting
