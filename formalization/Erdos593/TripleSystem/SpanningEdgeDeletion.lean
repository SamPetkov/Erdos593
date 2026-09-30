import Erdos593.TripleSystem.Intrinsic

/-!
# Spanning hyperedge deletion and the bridge condition

Deletion removes an edge index, not the points that become isolated. A closed
reachability class gives the local bridge criterion without choosing paths.
-/

namespace Erdos593

universe u v

namespace TripleSystem

variable {V : Type u} {E : Type v}

/-- Restrict edge indices while retaining the entire original point type. -/
def spanningEdgeRestriction (F : TripleSystem V E) (S : Set E) :
    TripleSystem V S where
  Inc x d := F.Inc x d.1
  edge_ncard d := F.edge_ncard d.1
  simple := by
    intro a b hab
    apply Subtype.ext
    exact F.simple hab

/-- Delete one hyperedge, retaining even the newly isolated points. -/
abbrev deleteHyperedge (F : TripleSystem V E) (e : E) :
    TripleSystem V {d : E // d ≠ e} :=
  F.spanningEdgeRestriction {d : E | d ≠ e}

@[simp]
theorem deleteHyperedge_inc (F : TripleSystem V E) (e : E)
    (x : V) (d : {d : E // d ≠ e}) :
    (F.deleteHyperedge e).Inc x d ↔ F.Inc x d.1 := Iff.rfl

/-- The spanning-deletion Levi graph maps into the graph with any one of the
deleted hyperedge's incidences removed. -/
private def deleteHyperedgeToDeleteIncidence (F : TripleSystem V E)
    (e : E) (x : V) :
    (F.deleteHyperedge e).levi →g
      F.levi.deleteEdges {s(Sum.inl x, Sum.inr e)} where
  toFun := Sum.map id Subtype.val
  map_rel' := by
    rintro (a | ⟨d, hd⟩) (b | ⟨f, hf⟩) hab <;>
      simp_all [SimpleGraph.deleteEdges_adj]

/-- A non-bridge incidence is exactly a connection to another endpoint after
spanning deletion of the hyperedge. -/
theorem levi_incidence_not_bridge_iff_reachable_deleteHyperedge
    (F : TripleSystem V E) [Fintype V] [Fintype E]
    (e : E) (x : V) (hxe : F.Inc x e) :
    s(Sum.inl x, Sum.inr e) ∉
        Erdos593.SimpleGraph.bridgeEdges F.levi ↔
      ∃ y : V, F.Inc y e ∧ y ≠ x ∧
        (F.deleteHyperedge e).levi.Reachable (Sum.inl x) (Sum.inl y) := by
  classical
  let H := (F.deleteHyperedge e).levi
  let G := F.levi.deleteEdges {s(Sum.inl x, Sum.inr e)}
  have hadj : F.levi.Adj (Sum.inl x) (Sum.inr e) :=
    F.levi_adj_point_edge.mpr hxe
  have hmem : s(Sum.inl x, Sum.inr e) ∈ F.levi.edgeSet := hadj
  change ¬(s(Sum.inl x, Sum.inr e) ∈ F.levi.edgeSet ∧
    F.levi.IsBridge s(Sum.inl x, Sum.inr e)) ↔ _
  simp only [hmem, true_and, _root_.SimpleGraph.isBridge_iff, not_not]
  constructor
  · intro hreach
    by_contra hnone
    -- This class cannot escape through e unless it contains a second endpoint.
    let P : V ⊕ E → Prop
      | .inl y => H.Reachable (.inl x) (.inl y)
      | .inr d => ∃ h : d ≠ e, H.Reachable (.inl x) (.inr ⟨d, h⟩)
    have hclosed : ∀ a b, G.Adj a b → P a → P b := by
      intro a b hab ha
      have hab' := (_root_.SimpleGraph.deleteEdges_adj).mp hab
      cases a with
      | inl a =>
        cases b with
        | inl b => exact (F.not_levi_adj_point_point hab'.1).elim
        | inr d =>
          have had : F.Inc a d := F.levi_adj_point_edge.mp hab'.1
          by_cases hde : d = e
          · subst d
            have hax : a = x := by
              by_contra hax
              exact hnone ⟨a, had, hax, ha⟩
            subst a
            exact (hab'.2 (by simp)).elim
          · refine ⟨hde, ha.trans ?_⟩
            have hstep : H.Adj (.inl a) (.inr ⟨d, hde⟩) :=
              (F.deleteHyperedge e).levi_adj_point_edge.mpr had
            exact hstep.reachable
      | inr d =>
        cases b with
        | inl b =>
          obtain ⟨hde, hd⟩ := ha
          exact hd.trans
            (((F.deleteHyperedge e).levi_adj_edge_point.mpr
              (F.levi_adj_edge_point.mp hab'.1)).reachable)
        | inr b => exact (F.not_levi_adj_edge_edge hab'.1).elim
    have hP : P (Sum.inr e) := by
      change G.Reachable (Sum.inl x) (Sum.inr e) at hreach
      rw [_root_.SimpleGraph.reachable_eq_reflTransGen] at hreach
      have hstart : P (Sum.inl x) := _root_.SimpleGraph.Reachable.rfl
      have preserve : ∀ {z}, Relation.ReflTransGen G.Adj (Sum.inl x) z → P z := by
        intro z hr
        induction hr with
        | refl => exact hstart
        | tail _ hab ih => exact hclosed _ _ hab ih
      exact preserve hreach
    obtain ⟨hne, _⟩ := hP
    exact hne rfl
  · rintro ⟨y, hye, hyx, hxy⟩
    have hxy' : G.Reachable (Sum.inl x) (Sum.inl y) :=
      hxy.map (deleteHyperedgeToDeleteIncidence F e x)
    apply hxy'.trans
    apply _root_.SimpleGraph.Adj.reachable
    simp [G, _root_.SimpleGraph.deleteEdges_adj, hye, hyx]

/-- The three endpoints lie in one component after spanning edge deletion
exactly when no incidence at that edge-node is a bridge. -/
theorem no_incident_bridge_iff_deleteHyperedge_connected_on_edge
    (F : TripleSystem V E) [Fintype V] [Fintype E] (e : E) :
    (∀ x : V, F.Inc x e →
      s(Sum.inl x, Sum.inr e) ∉
        Erdos593.SimpleGraph.bridgeEdges F.levi) ↔
    (∀ x y : V, F.Inc x e → F.Inc y e →
      (F.deleteHyperedge e).levi.Reachable (Sum.inl x) (Sum.inl y)) := by
  classical
  obtain ⟨a, b, c, hab, hac, hbc, hedge⟩ :=
    Set.ncard_eq_three.mp (F.edgeSet_ncard e)
  have hinc : ∀ w, F.Inc w e ↔ w = a ∨ w = b ∨ w = c := by
    intro w
    change w ∈ F.edgeSet e ↔ _
    rw [hedge]
    simp
  have ha := (hinc a).mpr (Or.inl rfl)
  have hb := (hinc b).mpr (Or.inr (Or.inl rfl))
  have hc := (hinc c).mpr (Or.inr (Or.inr rfl))
  constructor
  · intro hn
    have partner : ∀ x, F.Inc x e → ∃ y, F.Inc y e ∧ y ≠ x ∧
        (F.deleteHyperedge e).levi.Reachable (.inl x) (.inl y) := by
      intro x hx
      exact (levi_incidence_not_bridge_iff_reachable_deleteHyperedge F e x hx).mp
        (hn x hx)
    have hR_ab : (F.deleteHyperedge e).levi.Reachable (.inl a) (.inl b) := by
      by_contra hnab
      obtain ⟨d, hd, hda, had⟩ := partner a ha
      rcases (hinc d).mp hd with rfl | rfl | rfl
      · exact hda rfl
      · exact hnab had
      obtain ⟨d, hd, hdb, hbd⟩ := partner b hb
      rcases (hinc d).mp hd with rfl | rfl | rfl
      · exact hnab hbd.symm
      · exact hdb rfl
      · exact hnab (had.trans hbd.symm)
    have hR_ac : (F.deleteHyperedge e).levi.Reachable (.inl a) (.inl c) := by
      obtain ⟨d, hd, hdc, hcd⟩ := partner c hc
      rcases (hinc d).mp hd with rfl | rfl | rfl
      · exact hcd.symm
      · exact hR_ab.trans hcd.symm
      · exact (hdc rfl).elim
    intro x y hx hy
    rcases (hinc x).mp hx with rfl | rfl | rfl <;>
      rcases (hinc y).mp hy with rfl | rfl | rfl <;>
      first | exact .rfl | exact hR_ab | exact hR_ab.symm |
        exact hR_ac | exact hR_ac.symm |
        exact hR_ab.symm.trans hR_ac | exact hR_ac.symm.trans hR_ab
  · intro hr x hx
    apply (levi_incidence_not_bridge_iff_reachable_deleteHyperedge F e x hx).mpr
    by_cases hxa : x = a
    · subst x
      exact ⟨b, hb, hab.symm, hr a b ha hb⟩
    · exact ⟨a, ha, Ne.symm hxa, hr x a hx ha⟩

/-- The hypergraph-native edge-deletion form of the bridge condition. -/
theorem bridgeAtEveryEdge_iff_deleteHyperedge_separates
    (F : TripleSystem V E) [Fintype V] [Fintype E] :
    F.BridgeAtEveryEdge ↔
      ∀ e : E, ∃ x y : V, F.Inc x e ∧ F.Inc y e ∧
        ¬(F.deleteHyperedge e).levi.Reachable (Sum.inl x) (Sum.inl y) := by
  classical
  constructor
  · intro hF e
    by_contra hsep
    push Not at hsep
    have hn := (no_incident_bridge_iff_deleteHyperedge_connected_on_edge F e).mpr hsep
    obtain ⟨x, hx⟩ := hF e
    have hxe : F.Inc x e := by
      have hmem : s(Sum.inl x, Sum.inr e) ∈ F.levi.edgeSet := hx.1
      exact F.levi_adj_point_edge.mp hmem
    exact hn x hxe hx
  · intro hF e
    by_contra hn
    have hnone : ∀ x : V, F.Inc x e →
        s(Sum.inl x, Sum.inr e) ∉
          Erdos593.SimpleGraph.bridgeEdges F.levi := by
      intro x _ hx
      exact hn ⟨x, hx⟩
    obtain ⟨x, y, hx, hy, hxy⟩ := hF e
    exact hxy ((no_incident_bridge_iff_deleteHyperedge_connected_on_edge F e).mp
      hnone x y hx hy)

end TripleSystem
end Erdos593
