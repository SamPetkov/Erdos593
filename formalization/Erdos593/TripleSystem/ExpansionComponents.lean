import Erdos593.TripleSystem.Expansion
import Erdos593.TripleSystem.Levi
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.SetTheory.Cardinal.Finite

/-!
# Components of a private-vertex expansion

Subdividing graph edges and attaching their private leaves does not change
connected components. The explicit equivalence below includes isolated core
vertices and the empty graph, and needs no bipartiteness assumption.
-/

namespace Erdos593.TripleSystem

universe u

namespace ExpansionComponents

variable {W : Type u} (J : _root_.SimpleGraph W)

private theorem edge_has_endpoint (e : J.edgeSet) :
    ∃ x : W, x ∈ (e : Sym2 W) := by
  rcases e with ⟨e, he⟩
  induction e using Sym2.inductionOn with
  | _ x y => exact ⟨x, by simp⟩

private noncomputable def edgeRoot (e : J.edgeSet) : W :=
  Classical.choose (edge_has_endpoint J e)

private theorem edgeRoot_mem (e : J.edgeSet) :
    edgeRoot J e ∈ (e : Sym2 W) :=
  Classical.choose_spec (edge_has_endpoint J e)

private theorem endpoint_reaches_root (e : J.edgeSet) (x : W)
    (hx : x ∈ (e : Sym2 W)) : J.Reachable x (edgeRoot J e) := by
  have hr := edgeRoot_mem J e
  rcases e with ⟨e, he⟩
  induction e using Sym2.inductionOn with
  | _ a b =>
    simp only [Sym2.mem_iff] at hx hr
    have hab : J.Reachable a b := (show J.Adj a b from he).reachable
    rcases hx with hx | hx <;> rcases hr with hr | hr
    · exact (hx.trans hr.symm) ▸ _root_.SimpleGraph.Reachable.rfl
    · simpa only [hx, hr] using hab
    · simpa only [hx, hr] using hab.symm
    · exact (hx.trans hr.symm) ▸ _root_.SimpleGraph.Reachable.rfl

private noncomputable def nodeRoot :
    (PrivateVertexExpansion.Point J ⊕ PrivateVertexExpansion.Edge J) → W
  | .inl (.inl x) => x
  | .inl (.inr e) => edgeRoot J e
  | .inr e => edgeRoot J e

private theorem roots_reachable_of_adj
    {a b : PrivateVertexExpansion.Point J ⊕ PrivateVertexExpansion.Edge J}
    (h : (privateVertexExpansion J).levi.Adj a b) :
    J.Reachable (nodeRoot J a) (nodeRoot J b) := by
  rcases a with (x | e) | e <;> rcases b with (y | f) | f
  all_goals simp only [levi_adj_point_edge, levi_adj_edge_point,
    not_levi_adj_point_point, not_levi_adj_edge_edge,
    privateVertexExpansion, PrivateVertexExpansion.Inc] at h
  · exact endpoint_reaches_root J f x h
  · subst f; exact .rfl
  · exact (endpoint_reaches_root J e y h).symm
  · subst f; exact .rfl

private theorem roots_reachable_of_reachable
    {a b : PrivateVertexExpansion.Point J ⊕ PrivateVertexExpansion.Edge J}
    (h : (privateVertexExpansion J).levi.Reachable a b) :
    J.Reachable (nodeRoot J a) (nodeRoot J b) := by
  obtain ⟨p⟩ := h
  induction p with
  | nil => exact .rfl
  | cons h _ ih => exact (roots_reachable_of_adj J h).trans ih

private theorem core_reachable_of_reachable {x y : W}
    (h : J.Reachable x y) :
    (privateVertexExpansion J).levi.Reachable
      (.inl (.inl x)) (.inl (.inl y)) := by
  obtain ⟨p⟩ := h
  induction p with
  | nil => exact .rfl
  | @cons x z y hxz p ih =>
    let e : J.edgeSet := ⟨s(x, z), hxz⟩
    have hxe : (privateVertexExpansion J).levi.Adj (.inl (.inl x)) (.inr e) := by
      simp [e, privateVertexExpansion, PrivateVertexExpansion.Inc]
    have hze : (privateVertexExpansion J).levi.Adj (.inr e) (.inl (.inl z)) := by
      simp [e, privateVertexExpansion, PrivateVertexExpansion.Inc]
    exact hxe.reachable.trans (hze.reachable.trans ih)

private theorem core_root_reaches_node
    (a : PrivateVertexExpansion.Point J ⊕ PrivateVertexExpansion.Edge J) :
    (privateVertexExpansion J).levi.Reachable (.inl (.inl (nodeRoot J a))) a := by
  rcases a with (x | e) | e
  · exact .rfl
  · have hcore : (privateVertexExpansion J).levi.Adj
        (.inl (.inl (edgeRoot J e))) (.inr e) := by
      exact (levi_adj_point_edge _).mpr (edgeRoot_mem J e)
    have hprivate : (privateVertexExpansion J).levi.Adj
        (.inr e) (.inl (.inr e)) := by
      simp [privateVertexExpansion, PrivateVertexExpansion.Inc]
    exact hcore.reachable.trans hprivate.reachable
  · exact ((levi_adj_point_edge _).mpr (edgeRoot_mem J e)).reachable

end ExpansionComponents

/-- Core reachability is exactly preserved by private-vertex expansion. -/
theorem privateVertexExpansion_core_reachable_iff
    {W : Type u} (J : _root_.SimpleGraph W) (x y : W) :
    (privateVertexExpansion J).levi.Reachable
      (.inl (.inl x)) (.inl (.inl y)) ↔ J.Reachable x y :=
  ⟨ExpansionComponents.roots_reachable_of_reachable J,
    ExpansionComponents.core_reachable_of_reachable J⟩

/-- Expansion induces a genuine equivalence of component types. -/
noncomputable def privateVertexExpansion_componentEquiv
    {W : Type u} (J : _root_.SimpleGraph W) :
    (privateVertexExpansion J).levi.ConnectedComponent ≃ J.ConnectedComponent where
  toFun := Quot.lift (fun a => J.connectedComponentMk (ExpansionComponents.nodeRoot J a))
    (fun _ _ h => _root_.SimpleGraph.ConnectedComponent.sound
      (ExpansionComponents.roots_reachable_of_reachable J h))
  invFun := Quot.lift (fun x => (privateVertexExpansion J).levi.connectedComponentMk
      (.inl (.inl x)))
    (fun _ _ h => _root_.SimpleGraph.ConnectedComponent.sound
      (ExpansionComponents.core_reachable_of_reachable J h))
  left_inv := by
    intro C
    refine C.ind (fun a => ?_)
    exact _root_.SimpleGraph.ConnectedComponent.sound
      (ExpansionComponents.core_root_reaches_node J a)
  right_inv := by
    intro C
    exact C.ind (fun _ => rfl)

/-- The equality holds even for graphs with isolated vertices or no vertices. -/
theorem privateVertexExpansion_component_card
    {W : Type u} (J : _root_.SimpleGraph W) :
    Nat.card (privateVertexExpansion J).levi.ConnectedComponent =
      Nat.card J.ConnectedComponent :=
  Nat.card_congr (privateVertexExpansion_componentEquiv J)

end Erdos593.TripleSystem
