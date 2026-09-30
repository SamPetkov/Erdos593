import Erdos593.TripleSystem.BridgeBlockCycleLift
import Erdos593.TripleSystem.CanonicalAtomTypeDichotomy

/-!
# Canonical cycle-block core structure

This module isolates the graph-theoretic structure carried by the literal
finite endpoint graph of a canonical cycle-block atom.  Vertex
two-connectivity is stated explicitly as nondegeneracy together with
connectivity after deletion of any one vertex; it is not replaced by ordinary
connectivity, absence of bridges, or edge-biconnectivity.

The selected core is finite by construction, and simplicity is built into its
`SimpleGraph` type.  The substantive downstream obligations are genuine
vertex two-connectivity and bipartiteness.
-/

namespace Erdos593

universe u v w

namespace TripleSystem
namespace CanonicalAtom

open BridgeBlock

noncomputable section

variable {V : Type u} {E : Type v} (F : TripleSystem V E)
variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
  [DecidableRel F.levi.Adj]

/-- A finite simple graph is vertex two-connected when it has at least three
vertices and remains connected after deletion of any one vertex. -/
def IsTwoVertexConnected {W : Type w} [Fintype W]
    (G : _root_.SimpleGraph W) : Prop :=
  3 ≤ Fintype.card W ∧
    ∀ x : W, (G.induce {y | y ≠ x}).Connected

/-- The endpoint type of a canonical cycle-block core is finite. -/
theorem cycleBlockCore_vertex_finite
    (C : BridgeBlock.HyperedgeComponent F)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :
    Finite
      (finiteEdgeEndpointType
        (BridgeBlock.contractedGraph F C)
        (CanonicalAtom.cycleBlockEdgeSet F C B)
        (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) := by
  infer_instance

/-- Every canonical cycle-block core is genuinely vertex two-connected. -/
theorem cycleBlockCore_isTwoVertexConnected
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (C : BridgeBlock.HyperedgeComponent F)
    (hC : BridgeBlock.HasIncidence F C)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :
    IsTwoVertexConnected (CanonicalAtom.cycleBlockCore F C B) := by
  classical
  have hle : Erdos593.SimpleGraph.bridgeFree F.levi ≤ F.levi := by
    dsimp only [Erdos593.SimpleGraph.bridgeFree]
    exact F.levi.deleteEdges_le _
  -- The bridge-free Levi graph has no bridges of its own.
  have hLnb : ∀ a b : V ⊕ E,
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj a b →
      ((Erdos593.SimpleGraph.bridgeFree F.levi).deleteEdges
        {s(a, b)}).Reachable a b := by
    intro a b hab
    have habl : F.levi.Adj a b := hle hab
    have hnotmem :
        s(a, b) ∉ (Erdos593.SimpleGraph.bridgeFinset F.levi : Set (Sym2 (V ⊕ E))) := by
      have h := hab
      rw [Erdos593.SimpleGraph.bridgeFree, _root_.SimpleGraph.deleteEdges_adj] at h
      exact h.2
    have hnb : ¬F.levi.IsBridge s(a, b) := by
      intro hb
      exact hnotmem (by
        simp only [Finset.mem_coe, Erdos593.SimpleGraph.mem_bridgeFinset]
        exact ⟨habl, hb⟩)
    have hreach : (F.levi.deleteEdges {s(a, b)}).Reachable a b := by
      rw [_root_.SimpleGraph.isBridge_iff] at hnb
      exact not_not.mp hnb
    obtain ⟨z, c, hc, hmem⟩ :=
      _root_.SimpleGraph.adj_and_reachable_delete_edges_iff_exists_cycle.mp ⟨habl, hreach⟩
    have havoid : ∀ e ∈ c.edges,
        e ∉ (Erdos593.SimpleGraph.bridgeFinset F.levi : Set (Sym2 (V ⊕ E))) := by
      intro e he hbe
      have hbe' : e ∈ Erdos593.SimpleGraph.bridgeFinset F.levi := by simpa using hbe
      exact (Erdos593.SimpleGraph.mem_bridgeFinset.mp hbe').2.notMem_edges_of_isCycle hc he
    have hcH :
        (c.toDeleteEdges
          (Erdos593.SimpleGraph.bridgeFinset F.levi : Set (Sym2 (V ⊕ E)))
          havoid).IsCycle :=
      _root_.SimpleGraph.Walk.IsCycle.toDeleteEdges (G := F.levi)
        (s := (Erdos593.SimpleGraph.bridgeFinset F.levi : Set (Sym2 (V ⊕ E))))
        hc havoid
    have hedges :
        (c.toDeleteEdges
          (Erdos593.SimpleGraph.bridgeFinset F.levi : Set (Sym2 (V ⊕ E)))
          havoid).edges = c.edges :=
      _root_.SimpleGraph.Walk.edges_transfer _ _
    exact (_root_.SimpleGraph.adj_and_reachable_delete_edges_iff_exists_cycle.mpr
      ⟨z, c.toDeleteEdges
        (Erdos593.SimpleGraph.bridgeFinset F.levi : Set (Sym2 (V ⊕ E))) havoid,
        hcH, by rw [hedges]; exact hmem⟩).2

  -- Hence no edge of the contracted graph is a bridge either.
  have hGnb : ∀ pu pv : BridgeBlock.Point F C,
      (BridgeBlock.contractedGraph F C).Adj pu pv →
      ((BridgeBlock.contractedGraph F C).deleteEdges
        {s(pu, pv)}).Reachable pu pv := by
    intro pu pv huv
    obtain ⟨hne, ee, hue, hve⟩ := (BridgeBlock.contractedGraph_adj F C pu pv).mp huv
    have hsumne : (Sum.inl pu.1 : V ⊕ E) ≠ Sum.inl pv.1 := by
      intro h
      exact hne (Subtype.ext (Sum.inl.inj h))
    -- the bridge-free Levi neighbours of the witness node are the two endpoints
    have hnbhd : ∀ z : V ⊕ E,
        (Erdos593.SimpleGraph.bridgeFree F.levi).Adj z (Sum.inr ee.1) →
          z = Sum.inl pu.1 ∨ z = Sum.inl pv.1 := by
      intro z hz
      have hpairSubset :
          ({Sum.inl pu.1, Sum.inl pv.1} : Finset (V ⊕ E)) ⊆
            (Erdos593.SimpleGraph.bridgeFree F.levi).neighborFinset (Sum.inr ee.1) := by
        intro t ht
        simp only [Finset.mem_insert, Finset.mem_singleton] at ht
        rcases ht with rfl | rfl
        · exact ((Erdos593.SimpleGraph.bridgeFree F.levi).mem_neighborFinset _ _).2 hue.symm
        · exact ((Erdos593.SimpleGraph.bridgeFree F.levi).mem_neighborFinset _ _).2 hve.symm
      have hcard :
          ((Erdos593.SimpleGraph.bridgeFree F.levi).neighborFinset
            (Sum.inr ee.1)).card = 2 := by
        rw [_root_.SimpleGraph.card_neighborFinset_eq_degree]
        exact ee.property.2
      have hpairCard : ({Sum.inl pu.1, Sum.inl pv.1} : Finset (V ⊕ E)).card = 2 := by
        simp [hsumne]
      have hpairEq :
          ({Sum.inl pu.1, Sum.inl pv.1} : Finset (V ⊕ E)) =
            (Erdos593.SimpleGraph.bridgeFree F.levi).neighborFinset (Sum.inr ee.1) :=
        Finset.eq_of_subset_of_card_le hpairSubset (by omega)
      have hzmem : z ∈ ({Sum.inl pu.1, Sum.inl pv.1} : Finset (V ⊕ E)) := by
        rw [hpairEq]
        exact ((Erdos593.SimpleGraph.bridgeFree F.levi).mem_neighborFinset _ _).2 hz.symm
      simpa using hzmem
    -- project bridge-free Levi walks avoiding the witness node
    have hproj : ∀ (z t : V ⊕ E)
        (w : (Erdos593.SimpleGraph.bridgeFree F.levi).Walk z t),
        t = Sum.inl pu.1 → Sum.inr ee.1 ∉ w.support →
        (∀ (a : V) (ha : Sum.inl a ∈ (C : BridgeBlock.Component F).supp), z = Sum.inl a →
            ((BridgeBlock.contractedGraph F C).deleteEdges
              {s(pu, pv)}).Reachable ⟨a, ha⟩ pu) ∧
        (∀ (f : E) (a : V) (ha : Sum.inl a ∈ (C : BridgeBlock.Component F).supp), z = Sum.inr f →
            (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl a) (Sum.inr f) →
            ((BridgeBlock.contractedGraph F C).deleteEdges
              {s(pu, pv)}).Reachable ⟨a, ha⟩ pu) := by
      intro z t w
      induction w with
      | nil =>
          intro ht _
          subst ht
          refine ⟨?_, ?_⟩
          · intro a ha hza
            have : a = pu.1 := (Sum.inl.inj hza).symm
            subst this
            exact _root_.SimpleGraph.Reachable.refl _
          · intro f a ha hzf _
            exact absurd hzf (by simp)
      | @cons z z' _ hadj w' ih =>
          intro ht hsupp
          subst ht
          have hsupp' : Sum.inr ee.1 ∉ w'.support := by
            intro h
            exact hsupp (by simp [h])
          have hzsupp : Sum.inr ee.1 ≠ z := by
            intro h
            exact hsupp (by simp [h])
          refine ⟨?_, ?_⟩
          · intro a ha hza
            subst hza
            match z', hadj, w', ih, hsupp' with
            | Sum.inl y, hadj, w', ih, hsupp' =>
                exact absurd (hle hadj) (F.not_levi_adj_point_point)
            | Sum.inr f, hadj, w', ih, hsupp' =>
                exact (ih rfl hsupp').2 f a ha rfl hadj
          · intro f a ha hzf hadj2
            subst hzf
            match z', hadj, w', ih, hsupp' with
            | Sum.inr g, hadj, w', ih, hsupp' =>
                exact absurd (hle hadj) (F.not_levi_adj_edge_edge)
            | Sum.inl a2, hadj, w', ih, hsupp' =>
                have hfne : f ≠ ee.1 := by
                  intro h
                  exact hzsupp (by rw [h])
                have hfsupp : (Sum.inr f : V ⊕ E) ∈ (C : BridgeBlock.Component F).supp := by
                  rw [_root_.SimpleGraph.ConnectedComponent.mem_supp_iff] at ha ⊢
                  rw [← ha]
                  exact _root_.SimpleGraph.ConnectedComponent.sound hadj2.reachable.symm
                have ha2 : (Sum.inl a2 : V ⊕ E) ∈ (C : BridgeBlock.Component F).supp := by
                  rw [_root_.SimpleGraph.ConnectedComponent.mem_supp_iff] at ha ⊢
                  rw [← ha]
                  exact _root_.SimpleGraph.ConnectedComponent.sound
                    (hadj2.reachable.trans hadj.reachable).symm
                by_cases haa : a = a2
                · subst haa
                  exact (ih rfl hsupp').1 a ha rfl
                · have hdeg :
                      (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) = 2 :=
                      BridgeBlock.edge_degree_eq_two_of_hasIncidence F hbridge hC hfsupp
                  have hadjG : (BridgeBlock.contractedGraph F C).Adj ⟨a, ha⟩ ⟨a2, ha2⟩ := by
                    refine (BridgeBlock.contractedGraph_adj F C _ _).mpr
                      ⟨?_, ⟨f, hfsupp, hdeg⟩, hadj2, hadj.symm⟩
                    intro h
                    exact haa (congrArg Subtype.val h)
                  have hedgeNe :
                      s((⟨a, ha⟩ : BridgeBlock.Point F C), ⟨a2, ha2⟩) ≠ s(pu, pv) := by
                    intro h
                    rcases Sym2.eq_iff.mp h with ⟨h1, h2⟩ | ⟨h1, h2⟩
                    · have hEq := BridgeBlock.contractibleEdge_unique F hlinear hne
                        (e := ⟨f, hfsupp, hdeg⟩) (f := ee)
                        (by rw [← h1]; exact hadj2)
                        (by rw [← h2]; exact hadj.symm) hue hve
                      exact hfne (congrArg Subtype.val hEq)
                    · have hEq := BridgeBlock.contractibleEdge_unique F hlinear hne
                        (e := ⟨f, hfsupp, hdeg⟩) (f := ee)
                        (by rw [← h2]; exact hadj.symm)
                        (by rw [← h1]; exact hadj2) hue hve
                      exact hfne (congrArg Subtype.val hEq)
                  have hadjD :
                      ((BridgeBlock.contractedGraph F C).deleteEdges
                        {s(pu, pv)}).Adj ⟨a, ha⟩ ⟨a2, ha2⟩ := by
                    rw [_root_.SimpleGraph.deleteEdges_adj]
                    exact ⟨hadjG, by simpa using hedgeNe⟩
                  exact hadjD.reachable.trans ((ih rfl hsupp').1 a2 ha2 rfl)
    -- a bridge-free Levi walk from the second endpoint avoiding the witness node
    have h1 := hLnb _ _ hue
    rw [_root_.SimpleGraph.reachable_deleteEdges_iff_exists_walk] at h1
    obtain ⟨p, hp⟩ := h1
    obtain ⟨r0, hr0path, hr0edges⟩ :
        ∃ r : (Erdos593.SimpleGraph.bridgeFree F.levi).Walk
          (Sum.inr ee.1) (Sum.inl pu.1),
          r.IsPath ∧ ∀ e ∈ r.edges, e ∈ p.edges := by
      refine ⟨(p.toPath : (Erdos593.SimpleGraph.bridgeFree F.levi).Walk
        (Sum.inl pu.1) (Sum.inr ee.1)).reverse, p.toPath.2.reverse, ?_⟩
      intro e he
      rw [_root_.SimpleGraph.Walk.edges_reverse, List.mem_reverse] at he
      exact _root_.SimpleGraph.Walk.edges_toPath_subset_edges p he
    cases r0 with
    | cons hadj' rest =>
        rename_i z'
        match z', hadj', rest, hr0path, hr0edges with
        | Sum.inr g, hadj', rest, hr0path, hr0edges =>
            exact absurd (hle hadj') (F.not_levi_adj_edge_edge)
        | Sum.inl y, hadj', rest, hr0path, hr0edges =>
            have hyne : y ≠ pu.1 := by
              intro h
              subst h
              exact hp (hr0edges _ (by simp [Sym2.eq_swap]))
            have hy : y = pv.1 := by
              rcases hnbhd (Sum.inl y) hadj'.symm with h | h
              · exact absurd (Sum.inl.inj h) hyne
              · exact Sum.inl.inj h
            subst hy
            have hnotin : Sum.inr ee.1 ∉ rest.support := by
              have := hr0path.support_nodup
              simp only [_root_.SimpleGraph.Walk.support_cons, List.nodup_cons] at this
              exact this.1
            exact ((hproj _ _ rest rfl hnotin).1 pv.1 pv.2 rfl).symm

  -- membership in the selected finite endpoint support
  have hmemXf : ∀ v : BridgeBlock.Point F C,
      v ∈ finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
            (CanonicalAtom.cycleBlockEdgeSet F C B)
            (CanonicalAtom.cycleBlockEdgeSet_finite F C B) ↔
        ∃ g : (BridgeBlock.contractedGraph F C).edgeSet,
          g ∈ CanonicalAtom.cycleBlockEdgeSet F C B ∧
            v ∈ (g.1 : Sym2 (BridgeBlock.Point F C)) := by
    intro v
    constructor
    · intro hv
      simpa [finiteEdgeEndpointFinset, Sym2.mem_toFinset,
        Set.Finite.mem_toFinset] using hv
    · rintro ⟨g, hg, hv⟩
      exact mem_finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C) _ hg hv
  -- every edge of a cycle through a selected edge is itself selected
  have hcycA : ∀ g : (BridgeBlock.contractedGraph F C).edgeSet,
      g ∈ CanonicalAtom.cycleBlockEdgeSet F C B →
      ∀ (z : BridgeBlock.Point F C)
        (c : (BridgeBlock.contractedGraph F C).Walk z z),
        c.IsCycle → (g.1 : Sym2 (BridgeBlock.Point F C)) ∈ c.edges →
        ∀ e ∈ c.edges, ∃ g' : (BridgeBlock.contractedGraph F C).edgeSet,
          g' ∈ CanonicalAtom.cycleBlockEdgeSet F C B ∧ g'.1 = e := by
    intro g hg z c hc hgc e he
    refine ⟨⟨e, c.edges_subset_edgeSet he⟩, ?_, rfl⟩
    have hgB : Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
        (BridgeBlock.contractedGraph F C) g = B := hg
    show Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
      (BridgeBlock.contractedGraph F C) _ = B
    rw [← hgB]
    exact (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge_eq_iff
      (BridgeBlock.contractedGraph F C)).mpr (Or.inr ⟨z, c, hc, he, hgc⟩)
  -- selected adjacency in the core graph
  have hKadj : ∀ (a b : BridgeBlock.Point F C)
      (ha : a ∈ finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
        (CanonicalAtom.cycleBlockEdgeSet F C B)
        (CanonicalAtom.cycleBlockEdgeSet_finite F C B))
      (hb : b ∈ finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
        (CanonicalAtom.cycleBlockEdgeSet F C B)
        (CanonicalAtom.cycleBlockEdgeSet_finite F C B)),
      a ≠ b →
      (∃ g : (BridgeBlock.contractedGraph F C).edgeSet,
        g ∈ CanonicalAtom.cycleBlockEdgeSet F C B ∧ g.1 = s(a, b)) →
      (CanonicalAtom.cycleBlockCore F C B).Adj ⟨a, ha⟩ ⟨b, hb⟩ := by
    intro a b ha hb hab hg
    obtain ⟨g, hgA, hgab⟩ := hg
    rw [CanonicalAtom.cycleBlockCore, finiteEdgeFactorGraph,
      _root_.SimpleGraph.fromEdgeSet_adj]
    refine ⟨⟨g, hgA, ?_⟩, ?_⟩
    · rw [hgab]
      rfl
    · simpa [Subtype.ext_iff] using hab
  -- every vertex of a nontrivial walk lies on one of its edges
  have hsuppEdge : ∀ (a b : BridgeBlock.Point F C)
      (p : (BridgeBlock.contractedGraph F C).Walk a b), ¬p.Nil →
      ∀ w ∈ p.support, ∃ e ∈ p.edges, w ∈ e := by
    intro a b p
    induction p with
    | nil => intro h; exact absurd _root_.SimpleGraph.Walk.nil_nil h
    | @cons a y b hadj q ih =>
        intro _ w hw
        rw [_root_.SimpleGraph.Walk.support_cons, List.mem_cons] at hw
        rcases hw with rfl | hw
        · exact ⟨s(w, y), by simp, by simp⟩
        · by_cases hq : q.Nil
          · have hwy : w = y := by
              cases q with
              | nil => simpa using hw
              | cons _ _ => simp at hq
            subst hwy
            exact ⟨s(a, w), by simp, by simp⟩
          · obtain ⟨e, he, hwe⟩ := ih hq w hw
            exact ⟨e, by simp [he], hwe⟩
  have hcard3 : 3 ≤ Fintype.card
      (finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
        (CanonicalAtom.cycleBlockEdgeSet F C B)
        (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) := by
    obtain ⟨g0, hg0⟩ :=
      Erdos593.SimpleGraph.EdgeCycleBlock.edges_nonempty
        (BridgeBlock.contractedGraph F C) B
    obtain ⟨a0, b0, hab0⟩ :
        ∃ a b : BridgeBlock.Point F C,
          (g0.1 : Sym2 (BridgeBlock.Point F C)) = s(a, b) := by
      generalize (g0.1 : Sym2 (BridgeBlock.Point F C)) = zz
      induction zz using Sym2.ind with
      | _ a b => exact ⟨a, b, rfl⟩
    have hadj0 : (BridgeBlock.contractedGraph F C).Adj a0 b0 := by
      have h := g0.2
      rw [hab0] at h
      exact h
    obtain ⟨z, c, hc, hmemc⟩ :=
      _root_.SimpleGraph.adj_and_reachable_delete_edges_iff_exists_cycle.mp
        ⟨hadj0, hGnb a0 b0 hadj0⟩
    have hg0c : (g0.1 : Sym2 (BridgeBlock.Point F C)) ∈ c.edges := by
      rw [hab0]; exact hmemc
    have hAll : ∀ e ∈ c.edges, ∃ g' : (BridgeBlock.contractedGraph F C).edgeSet,
        g' ∈ CanonicalAtom.cycleBlockEdgeSet F C B ∧ g'.1 = e :=
      hcycA g0 hg0 z c hc hg0c
    have hsub : c.support.tail.toFinset ⊆
        finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
          (CanonicalAtom.cycleBlockEdgeSet F C B)
          (CanonicalAtom.cycleBlockEdgeSet_finite F C B) := by
      intro w hw
      rw [List.mem_toFinset] at hw
      have hws : w ∈ c.support := List.tail_subset _ hw
      obtain ⟨e, he, hwe⟩ := hsuppEdge z z c hc.not_nil w hws
      obtain ⟨g', hg', hg'e⟩ := hAll e he
      exact (hmemXf w).mpr ⟨g', hg', by rw [hg'e]; exact hwe⟩
    have hnodup : c.support.tail.Nodup := hc.support_nodup
    have hlen : c.support.tail.length = c.length := by
      rw [List.length_tail, _root_.SimpleGraph.Walk.length_support]
      omega
    have hcard : c.support.tail.toFinset.card = c.length := by
      rw [List.toFinset_card_of_nodup hnodup, hlen]
    have h3 : 3 ≤ c.length := hc.three_le_length
    have hle3 : 3 ≤ (finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
        (CanonicalAtom.cycleBlockEdgeSet F C B)
        (CanonicalAtom.cycleBlockEdgeSet_finite F C B)).card := by
      have := Finset.card_le_card hsub
      omega
    simpa [Fintype.card_coe] using hle3
  refine ⟨hcard3, ?_⟩
  intro x
  -- transport selected walks avoiding the deleted vertex into the core
  have htrans : ∀ (a b : BridgeBlock.Point F C)
      (p : (BridgeBlock.contractedGraph F C).Walk a b),
      (∀ e ∈ p.edges, ∃ g : (BridgeBlock.contractedGraph F C).edgeSet,
        g ∈ CanonicalAtom.cycleBlockEdgeSet F C B ∧ g.1 = e) →
      (∀ w ∈ p.support, w ≠ x.1) →
      ∀ (ha : a ∈ finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
            (CanonicalAtom.cycleBlockEdgeSet F C B)
            (CanonicalAtom.cycleBlockEdgeSet_finite F C B))
        (hb : b ∈ finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
            (CanonicalAtom.cycleBlockEdgeSet F C B)
            (CanonicalAtom.cycleBlockEdgeSet_finite F C B))
        (hax : (⟨a, ha⟩ : finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
            (CanonicalAtom.cycleBlockEdgeSet F C B)
            (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) ≠ x)
        (hbx : (⟨b, hb⟩ : finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
            (CanonicalAtom.cycleBlockEdgeSet F C B)
            (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) ≠ x),
        ((CanonicalAtom.cycleBlockCore F C B).induce {y | y ≠ x}).Reachable
          ⟨⟨a, ha⟩, hax⟩ ⟨⟨b, hb⟩, hbx⟩ := by
    intro a b p
    induction p with
    | nil =>
        intro _ _ ha hb hax hbx
        exact _root_.SimpleGraph.Reachable.refl _
    | @cons a y b hadj q ih =>
        intro hedges hsupp ha hb hax hbx
        obtain ⟨g, hgA, hgay⟩ := hedges s(a, y) (by simp)
        have hy : y ∈ finiteEdgeEndpointFinset (BridgeBlock.contractedGraph F C)
            (CanonicalAtom.cycleBlockEdgeSet F C B)
            (CanonicalAtom.cycleBlockEdgeSet_finite F C B) :=
          (hmemXf y).mpr ⟨g, hgA, by rw [hgay]; simp⟩
        have hyx : (⟨y, hy⟩ : finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
            (CanonicalAtom.cycleBlockEdgeSet F C B)
            (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) ≠ x := by
          intro h
          exact hsupp y (by simp) (congrArg Subtype.val h)
        have hstep : ((CanonicalAtom.cycleBlockCore F C B).induce
            {y | y ≠ x}).Adj ⟨⟨a, ha⟩, hax⟩ ⟨⟨y, hy⟩, hyx⟩ :=
          hKadj a y ha hy hadj.ne ⟨g, hgA, hgay⟩
        exact hstep.reachable.trans
          (ih (fun e he => hedges e (by simp [he]))
            (fun w hw => hsupp w (by simp [hw])) hy hb hyx hbx)
  rw [_root_.SimpleGraph.connected_iff]
  constructor
  · intro U W
    obtain ⟨gU, hgU, haU⟩ := (hmemXf U.1.1).mp U.1.2
    obtain ⟨gW, hgW, hbW⟩ := (hmemXf W.1.1).mp W.1.2
    have hUx : U.1.1 ≠ x.1 := by
      intro h
      exact U.2 (Subtype.ext h)
    have hWx : W.1.1 ≠ x.1 := by
      intro h
      exact W.2 (Subtype.ext h)
    by_cases hUW : U.1.1 = W.1.1
    · have hUW' : U = W := Subtype.ext (Subtype.ext hUW)
      rw [hUW']
    · by_cases hgg : gU = gW
      · subst hgg
        have hedge : (gU.1 : Sym2 (BridgeBlock.Point F C)) = s(U.1.1, W.1.1) :=
          (Sym2.mem_and_mem_iff hUW).mp ⟨haU, hbW⟩
        have hadjUW : (BridgeBlock.contractedGraph F C).Adj U.1.1 W.1.1 := by
          have h := gU.2
          rw [hedge] at h
          exact h
        exact htrans U.1.1 W.1.1
          (_root_.SimpleGraph.Walk.cons hadjUW _root_.SimpleGraph.Walk.nil)
          (by
            intro e he
            simp only [_root_.SimpleGraph.Walk.edges_cons,
              _root_.SimpleGraph.Walk.edges_nil, List.mem_singleton] at he
            exact ⟨gU, hgU, by rw [hedge, he]⟩)
          (by
            intro w hw
            simp only [_root_.SimpleGraph.Walk.support_cons,
              _root_.SimpleGraph.Walk.support_nil, List.mem_cons,
              List.not_mem_nil, or_false] at hw
            rcases hw with rfl | rfl
            · exact hUx
            · exact hWx)
          U.1.2 W.1.2 U.2 W.2
      · have hlink : Erdos593.SimpleGraph.EdgeCycleLinked
            (BridgeBlock.contractedGraph F C) gU gW :=
          (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge_eq_iff
            (BridgeBlock.contractedGraph F C)).mp
            ((hgU : Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
                (BridgeBlock.contractedGraph F C) gU = B).trans
              (hgW : Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
                (BridgeBlock.contractedGraph F C) gW = B).symm)
        rcases hlink with heq | hcyc
        · exact absurd heq hgg
        obtain ⟨z, c, hc, hUc, hWc⟩ := hcyc
        have hAllc : ∀ e ∈ c.edges, ∃ g' :
            (BridgeBlock.contractedGraph F C).edgeSet,
            g' ∈ CanonicalAtom.cycleBlockEdgeSet F C B ∧ g'.1 = e :=
          hcycA gU hgU z c hc hUc
        have hUsupp : U.1.1 ∈ c.support :=
          _root_.SimpleGraph.Walk.mem_support_of_mem_edges hUc haU
        have hWsupp : W.1.1 ∈ c.support :=
          _root_.SimpleGraph.Walk.mem_support_of_mem_edges hWc hbW
        have hc1 : (c.rotate U.1.1 hUsupp).IsCycle := hc.rotate hUsupp
        have hc1edges : ∀ e ∈ (c.rotate U.1.1 hUsupp).edges, e ∈ c.edges :=
          fun e he => ((c.rotate_edges U.1.1 hUsupp).perm.mem_iff).mp he
        have hWc1 : W.1.1 ∈ (c.rotate U.1.1 hUsupp).support :=
          (_root_.SimpleGraph.Walk.mem_support_rotate_iff c U.1.1 hUsupp).mpr hWsupp
        have hspec := (c.rotate U.1.1 hUsupp).take_spec hWc1
        have hpedges : ∀ e ∈ ((c.rotate U.1.1 hUsupp).takeUntil W.1.1 hWc1).edges,
            e ∈ c.edges := by
          intro e he
          refine hc1edges e ?_
          rw [← hspec, _root_.SimpleGraph.Walk.edges_append]
          exact List.mem_append_left _ he
        have hqedges : ∀ e ∈ ((c.rotate U.1.1 hUsupp).dropUntil W.1.1 hWc1).edges,
            e ∈ c.edges := by
          intro e he
          refine hc1edges e ?_
          rw [← hspec, _root_.SimpleGraph.Walk.edges_append]
          exact List.mem_append_right _ he
        by_cases hxp : x.1 ∈ ((c.rotate U.1.1 hUsupp).takeUntil W.1.1 hWc1).support
        · have hxq : x.1 ∉ ((c.rotate U.1.1 hUsupp).dropUntil W.1.1 hWc1).support := by
            intro hxq
            have hpt : x.1 ∈
                ((c.rotate U.1.1 hUsupp).takeUntil W.1.1 hWc1).support.tail := by
              rw [← _root_.SimpleGraph.Walk.cons_tail_support, List.mem_cons] at hxp
              rcases hxp with h | h
              · exact absurd h.symm hUx
              · exact h
            have hqt : x.1 ∈
                ((c.rotate U.1.1 hUsupp).dropUntil W.1.1 hWc1).support.tail := by
              rw [← _root_.SimpleGraph.Walk.cons_tail_support, List.mem_cons] at hxq
              rcases hxq with h | h
              · exact absurd h.symm hWx
              · exact h
            have hnd : (c.rotate U.1.1 hUsupp).support.tail.Nodup := hc1.support_nodup
            rw [← hspec, _root_.SimpleGraph.Walk.tail_support_append] at hnd
            exact List.disjoint_of_nodup_append hnd hpt hqt
          exact htrans U.1.1 W.1.1
            ((c.rotate U.1.1 hUsupp).dropUntil W.1.1 hWc1).reverse
            (by
              intro e he
              rw [_root_.SimpleGraph.Walk.edges_reverse, List.mem_reverse] at he
              exact hAllc e (hqedges e he))
            (by
              intro w hw
              rw [_root_.SimpleGraph.Walk.support_reverse, List.mem_reverse] at hw
              intro hwx
              exact hxq (hwx ▸ hw))
            U.1.2 W.1.2 U.2 W.2
        · exact htrans U.1.1 W.1.1
            ((c.rotate U.1.1 hUsupp).takeUntil W.1.1 hWc1)
            (by
              intro e he
              exact hAllc e (hpedges e he))
            (by
              intro w hw hwx
              exact hxp (hwx ▸ hw))
            U.1.2 W.1.2 U.2 W.2
  · have hex : ∃ y : finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
        (CanonicalAtom.cycleBlockEdgeSet F C B)
        (CanonicalAtom.cycleBlockEdgeSet_finite F C B), y ≠ x := by
      by_contra hno
      have hno' : ∀ y, y = x := by
        intro y
        by_contra hy
        exact hno ⟨y, hy⟩
      have hle1 : Fintype.card (finiteEdgeEndpointType
          (BridgeBlock.contractedGraph F C)
          (CanonicalAtom.cycleBlockEdgeSet F C B)
          (CanonicalAtom.cycleBlockEdgeSet_finite F C B)) ≤ 1 :=
        Fintype.card_le_one_iff.mpr fun a b => (hno' a).trans (hno' b).symm
      omega
    obtain ⟨y, hy⟩ := hex
    exact ⟨⟨y, hy⟩⟩

/-- Under even Berge-cycle parity, every canonical cycle-block core is
bipartite. -/
theorem cycleBlockCore_isBipartite
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles)
    (C : BridgeBlock.HyperedgeComponent F)
    (hC : BridgeBlock.HasIncidence F C)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :
    (CanonicalAtom.cycleBlockCore F C B).IsBipartite := by
  classical
  by_cases hcontext : F.BridgeAtEveryEdge ∧ BridgeBlock.HasIncidence F C
  · -- Two-colour the ambient contracted graph and pull the colouring back along
    -- the incidence-preserving factor map of the selected finite endpoint graph.
    have hcol : (BridgeBlock.contractedGraph F C).Colorable 2 :=
      BridgeBlock.contractedGraph_colorable_two F hlinear hberge C
    have hhom :
        CanonicalAtom.cycleBlockCore F C B →g BridgeBlock.contractedGraph F C :=
      Erdos593.SimpleGraph.NonInducedFactor.toHom
        (finiteEdgeFactor (BridgeBlock.contractedGraph F C)
          (CanonicalAtom.cycleBlockEdgeSet F C B)
          (CanonicalAtom.cycleBlockEdgeSet_finite F C B))
    exact _root_.SimpleGraph.Colorable.of_hom hhom hcol
  · exact False.elim (hcontext ⟨hbridge, hC⟩)

/-- Combined manuscript-facing structure of a canonical cycle-block core. -/
theorem cycleBlockCore_structure
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles)
    (C : BridgeBlock.HyperedgeComponent F)
    (hC : BridgeBlock.HasIncidence F C)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :
    IsTwoVertexConnected (CanonicalAtom.cycleBlockCore F C B) ∧
      (CanonicalAtom.cycleBlockCore F C B).IsBipartite :=
  ⟨cycleBlockCore_isTwoVertexConnected F hlinear hbridge C hC B,
    cycleBlockCore_isBipartite F hlinear hbridge hberge C hC B⟩

end
end CanonicalAtom
end TripleSystem
end Erdos593
