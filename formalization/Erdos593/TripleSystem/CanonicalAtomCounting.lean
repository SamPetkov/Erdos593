import Erdos593.Graph.FiniteForestCounting
import Erdos593.TripleSystem.CanonicalAtomForestReconstruction
import Erdos593.TripleSystem.BipartiteShadow

/-!
# Exact accounting for the canonical atom forest

The counts use the original edge fibres and original-point supports. No
component count is supplied as a hypothesis. Internal atom connectivity,
literal core orders and the bipartite shadow give the local and global
integer accounting identities.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe w

noncomputable section

variable {V E : Type w} (F : TripleSystem V E)
variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
  [DecidableRel F.levi.Adj]

noncomputable local instance : DecidableEq (Index F) := Classical.decEq _

/-- Number of original hyperedges in a canonical fibre. -/
def atomEdgeCount (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : Index F) : ℕ := Nat.card (edges F hlinear hbridge A)

/-- Number of original points in the support of a canonical fibre. -/
def atomPointCount (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : Index F) : ℕ := Nat.card (atomSupport F hlinear hbridge A)

/-- Number of distinct represented atoms containing the original point. -/
def pointMultiplicity (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (x : V) : ℕ := by
  classical
  exact ((atomFinset F hlinear hbridge).filter
    (fun A => atomIncident F hlinear hbridge A x)).card

private abbrev indexFintype (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    Fintype (Index F) := by
  haveI : Finite (Index F) := Finite.of_surjective _ (atomOf_surjective F hlinear hbridge)
  exact Fintype.ofFinite _

private theorem atomFinset_eq_univ
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) [Fintype (Index F)] :
    atomFinset F hlinear hbridge = Finset.univ := by
  ext A
  simp

/-- The exact, disjoint edge fibres account for every original hyperedge. -/
theorem sum_atomEdgeCount (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    ∑ A ∈ atomFinset F hlinear hbridge, atomEdgeCount F hlinear hbridge A =
      Nat.card E := by
  classical
  letI := indexFintype F hlinear hbridge
  rw [atomFinset_eq_univ]
  change (∑ A : Index F, Nat.card {e : E // atomOf F hlinear hbridge e = A}) = _
  rw [← Nat.card_sigma]
  exact Nat.card_congr (Equiv.sigmaFiberEquiv (atomOf F hlinear hbridge))

/-- Sharing means at least two atoms, before any truncated subtraction occurs. -/
theorem two_le_pointMultiplicity_of_shared
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    {x : V} (hx : x ∈ sharedAtomPoints F hlinear hbridge) :
    2 ≤ pointMultiplicity F hlinear hbridge x :=
  (mem_sharedAtomPoints F hlinear hbridge x).mp hx

/-- Hyperedges with the same label are connected in the original Levi graph.
The cycle-block case uses the literal bridge-free component in the label;
the residual-degree-zero case forces equality of hyperedge indices. -/
theorem levi_reachable_of_atomOf_eq
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (e f : E) (h : atomOf F hlinear hbridge e = atomOf F hlinear hbridge f) :
    F.levi.Reachable (.inr e) (.inr f) := by
  classical
  have atomOf_singleton : ∀ (e : E)
      (hzero : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      atomOf F hlinear hbridge e = Index.singleton e hzero := by
    intro e hzero
    unfold atomOf
    rw [dif_pos hzero]
  have atomOf_cycle : ∀ (e : E)
      (hne : ¬ (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      atomOf F hlinear hbridge e =
        Index.cycleBlock (BridgeBlock.hyperedgeComponentOf F e)
          (hyperedgeComponent_hasIncidence_of_degree_ne_zero F hne)
          (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
            (BridgeBlock.contractedGraph F (BridgeBlock.hyperedgeComponentOf F e))
            ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge
                (hyperedgeComponent_hasIncidence_of_degree_ne_zero F hne)).symm
              ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩)) := by
    intro e hne
    unfold atomOf
    rw [dif_neg hne]
  have hfree : (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable
      (Sum.inr e) (Sum.inr f) := by
    by_cases he : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0
    · rw [atomOf_singleton e he] at h
      by_cases hf : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) = 0
      · rw [atomOf_singleton f hf] at h
        injection h with h1
        subst h1
        rfl
      · rw [atomOf_cycle f hf] at h
        exact absurd h (by simp)
    · rw [atomOf_cycle e he] at h
      by_cases hf : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) = 0
      · rw [atomOf_singleton f hf] at h
        exact absurd h (by simp)
      · rw [atomOf_cycle f hf] at h
        injection h with h1 _
        exact _root_.SimpleGraph.ConnectedComponent.exact (congrArg Subtype.val h1)
  exact hfree.mono (by
    dsimp only [Erdos593.SimpleGraph.bridgeFree]
    intro x y hxy
    exact hxy.1)

private def representative (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : Index F) : E := Classical.choose (atomOf_surjective F hlinear hbridge A)

private theorem representative_spec
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (A : Index F) :
    atomOf F hlinear hbridge (representative F hlinear hbridge A) = A :=
  Classical.choose_spec (atomOf_surjective F hlinear hbridge A)

private def leviToAtomNode (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    V ⊕ E → Index F ⊕ V
  | .inl x => .inr x
  | .inr e => .inl (atomOf F hlinear hbridge e)

private def atomNodeToLevi (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    Index F ⊕ V → V ⊕ E
  | .inl A => .inr (representative F hlinear hbridge A)
  | .inr x => .inl x

private theorem leviToAtomNode_adj
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    {a b : V ⊕ E} (h : F.levi.Adj a b) :
    (atomPointIncidenceGraph F hlinear hbridge).Reachable
      (leviToAtomNode F hlinear hbridge a) (leviToAtomNode F hlinear hbridge b) := by
  rcases a with x | e <;> rcases b with y | f
  · exact False.elim (F.not_levi_adj_point_point h)
  · apply _root_.SimpleGraph.Adj.reachable
    change (atomPointIncidenceGraph F hlinear hbridge).Adj
      (.inr x) (.inl (atomOf F hlinear hbridge f))
    rw [atomPointIncidenceGraph, _root_.SimpleGraph.bipartiteIncidenceGraph_adj_inr_inl_iff]
    exact ⟨f, rfl, F.levi_adj_point_edge.mp h⟩
  · apply _root_.SimpleGraph.Adj.reachable
    change (atomPointIncidenceGraph F hlinear hbridge).Adj
      (.inl (atomOf F hlinear hbridge e)) (.inr y)
    rw [atomPointIncidenceGraph, _root_.SimpleGraph.bipartiteIncidenceGraph_adj_inl_inr_iff]
    exact ⟨e, rfl, F.levi_adj_edge_point.mp h⟩
  · exact False.elim (F.not_levi_adj_edge_edge h)

private theorem representative_reaches_point
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : Index F) (x : V) (h : atomIncident F hlinear hbridge A x) :
    F.levi.Reachable (.inr (representative F hlinear hbridge A)) (.inl x) := by
  obtain ⟨e, he, hx⟩ := h
  have hh : atomOf F hlinear hbridge (representative F hlinear hbridge A) =
      atomOf F hlinear hbridge e := (representative_spec F hlinear hbridge A).trans he.symm
  exact (levi_reachable_of_atomOf_eq F hlinear hbridge _ _ hh).trans
    (F.levi_adj_edge_point.mpr hx).reachable

private theorem atomNodeToLevi_adj
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    {a b : Index F ⊕ V} (h : (atomPointIncidenceGraph F hlinear hbridge).Adj a b) :
    F.levi.Reachable (atomNodeToLevi F hlinear hbridge a)
      (atomNodeToLevi F hlinear hbridge b) := by
  rcases a with A | x <;> rcases b with B | y
  · simp [atomPointIncidenceGraph, _root_.SimpleGraph.bipartiteIncidenceGraph] at h
  · exact representative_reaches_point F hlinear hbridge A y
      ((_root_.SimpleGraph.bipartiteIncidenceGraph_adj_inl_inr_iff _ A y).mp h)
  · exact (representative_reaches_point F hlinear hbridge B x
      ((_root_.SimpleGraph.bipartiteIncidenceGraph_adj_inr_inl_iff _ B x).mp h)).symm
  · simp [atomPointIncidenceGraph, _root_.SimpleGraph.bipartiteIncidenceGraph] at h

/-- Full atom incidence and original Levi components correspond, also when
original points are isolated. Pruning will require a separate reducedness gate. -/
def atomPoint_componentEquiv (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    F.levi.ConnectedComponent ≃
      (atomPointIncidenceGraph F hlinear hbridge).ConnectedComponent := by
  refine _root_.SimpleGraph.FiniteForestCounting.componentEquivOfReachable
    F.levi (atomPointIncidenceGraph F hlinear hbridge)
    (leviToAtomNode F hlinear hbridge) (atomNodeToLevi F hlinear hbridge)
    (fun _ _ h => leviToAtomNode_adj F hlinear hbridge h)
    (fun _ _ h => atomNodeToLevi_adj F hlinear hbridge h) ?_ ?_
  · intro a
    rcases a with x | e
    · exact .rfl
    · exact levi_reachable_of_atomOf_eq F hlinear hbridge _ _
        (representative_spec F hlinear hbridge (atomOf F hlinear hbridge e))
  · intro a
    rcases a with A | x
    · change (atomPointIncidenceGraph F hlinear hbridge).Reachable
        (.inl (atomOf F hlinear hbridge (representative F hlinear hbridge A))) (.inl A)
      rw [representative_spec]
    · exact .rfl

/-- Euler accounting on the actual full canonical incidence forest. -/
theorem point_add_atom_count (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    Nat.card V + (atomFinset F hlinear hbridge).card =
      (∑ A ∈ atomFinset F hlinear hbridge, atomPointCount F hlinear hbridge A) +
        Nat.card F.levi.ConnectedComponent := by
  classical
  letI := indexFintype F hlinear hbridge
  have hc := Nat.card_congr (atomPoint_componentEquiv F hlinear hbridge)
  have he := _root_.SimpleGraph.FiniteForestCounting.card_incidence_edges
    (atomIncident F hlinear hbridge)
  have hf := _root_.SimpleGraph.FiniteForestCounting.card_edges_add_components
    (atomPointIncidenceGraph F hlinear hbridge)
    (atomPointIncidenceGraph_isAcyclic F hlinear hbridge)
  change Nat.card (_root_.SimpleGraph.bipartiteIncidenceGraph
    (atomIncident F hlinear hbridge)).edgeSet + _ = _ at hf
  rw [he, ← hc, Nat.card_sum] at hf
  rw [atomFinset_eq_univ]
  simpa only [Finset.card_univ, atomPointCount, atomIncident,
    Nat.card_eq_fintype_card, add_comm] using hf.symm

/-- Reducedness supplies an actual incident atom at every original point. -/
theorem exists_atomIncident (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hreduced : F.HasNoIsolatedPoints) (x : V) :
    ∃ A : Index F, atomIncident F hlinear hbridge A x := by
  classical
  have hx : ∃ e, F.Inc x e := by
    simpa only [IsIsolated, not_forall, not_not] using hreduced x
  obtain ⟨e, he⟩ := hx
  exact ⟨atomOf F hlinear hbridge e, e, rfl, he⟩

theorem one_le_pointMultiplicity
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hreduced : F.HasNoIsolatedPoints) (x : V) :
    1 ≤ pointMultiplicity F hlinear hbridge x := by
  classical
  obtain ⟨A, hA⟩ := exists_atomIncident F hlinear hbridge hreduced x
  exact Finset.card_pos.mpr ⟨A, Finset.mem_filter.mpr
    ⟨mem_atomFinset F hlinear hbridge A, hA⟩⟩

private theorem card_incidentAtoms
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) [Fintype (Index F)]
    (x : V) : Nat.card {A : Index F // atomIncident F hlinear hbridge A x} =
      pointMultiplicity F hlinear hbridge x := by
  classical
  unfold pointMultiplicity
  rw [atomFinset_eq_univ]
  have hs : {A : Index F | atomIncident F hlinear hbridge A x} =
      (↑(Finset.univ.filter (fun A => atomIncident F hlinear hbridge A x)) : Set (Index F)) := by
    ext A
    simp
  change Nat.card {A : Index F | atomIncident F hlinear hbridge A x} = _
  rw [hs]
  simp

/-- Double-count atom--point incidences; each shared point contributes mu-1. -/
theorem sum_atomPointCount
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hreduced : F.HasNoIsolatedPoints) :
    (∑ A ∈ atomFinset F hlinear hbridge, atomPointCount F hlinear hbridge A) =
      Nat.card V + ∑ x ∈ sharedAtomPoints F hlinear hbridge,
        (pointMultiplicity F hlinear hbridge x - 1) := by
  classical
  letI := indexFintype F hlinear hbridge
  have hd : (∑ A ∈ atomFinset F hlinear hbridge, atomPointCount F hlinear hbridge A) =
      ∑ x : V, pointMultiplicity F hlinear hbridge x := by
    rw [atomFinset_eq_univ]
    change (∑ A : Index F, Nat.card {x : V // atomIncident F hlinear hbridge A x}) = _
    rw [_root_.SimpleGraph.FiniteForestCounting.sum_card_incidence_comm]
    exact Finset.sum_congr rfl (fun x _ => card_incidentAtoms F hlinear hbridge x)
  have hp : ∀ x : V, pointMultiplicity F hlinear hbridge x =
      1 + if x ∈ sharedAtomPoints F hlinear hbridge then
        pointMultiplicity F hlinear hbridge x - 1 else 0 := by
    intro x
    have hpos := one_le_pointMultiplicity F hlinear hbridge hreduced x
    by_cases hx : x ∈ sharedAtomPoints F hlinear hbridge
    · rw [if_pos hx]
      omega
    · have hlt : ¬ 2 ≤ pointMultiplicity F hlinear hbridge x :=
        fun h => hx ((mem_sharedAtomPoints F hlinear hbridge x).mpr h)
      rw [if_neg hx]
      omega
  rw [hd]
  calc
    _ = ∑ x : V, (1 + if x ∈ sharedAtomPoints F hlinear hbridge then
        pointMultiplicity F hlinear hbridge x - 1 else 0) :=
      Finset.sum_congr rfl (fun x _ => hp x)
    _ = _ := ?_
  rw [Finset.sum_add_distrib]
  have hs : (∑ x : V, if x ∈ sharedAtomPoints F hlinear hbridge then
      pointMultiplicity F hlinear hbridge x - 1 else 0) =
      ∑ x ∈ sharedAtomPoints F hlinear hbridge, (pointMultiplicity F hlinear hbridge x - 1) := by
    rw [← Finset.sum_filter]
    have ht : Finset.univ.filter (fun x => x ∈ sharedAtomPoints F hlinear hbridge) =
        sharedAtomPoints F hlinear hbridge := by
      ext x
      simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    rw [ht]
  rw [hs]
  simp

/-- The identification excess is derived from forest Euler accounting. -/
theorem excess_add_components
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hreduced : F.HasNoIsolatedPoints) :
    (∑ x ∈ sharedAtomPoints F hlinear hbridge,
      (pointMultiplicity F hlinear hbridge x - 1)) +
      Nat.card F.levi.ConnectedComponent = (atomFinset F hlinear hbridge).card := by
  have he := point_add_atom_count F hlinear hbridge
  rw [sum_atomPointCount F hlinear hbridge hreduced] at he
  omega

omit [DecidableEq V] [DecidableEq E] [DecidableRel F.levi.Adj] in
/-- Levi edges are incidences, with exactly three per original hyperedge. -/
theorem levi_card_edges : Nat.card F.levi.edgeSet = 3 * Nat.card E := by
  classical
  have he := _root_.SimpleGraph.FiniteForestCounting.card_incidence_edges F.Inc
  change Nat.card F.levi.edgeSet = _ at he
  rw [_root_.SimpleGraph.FiniteForestCounting.sum_card_incidence_comm] at he
  have hthree : ∀ e : E, Nat.card {x : V // F.Inc x e} = 3 :=
    fun e => F.edge_ncard e
  simp_rw [hthree] at he
  simpa only [Finset.sum_const, Finset.card_univ, smul_eq_mul,
    Nat.card_eq_fintype_card, mul_comm] using he

/-- Reducedness permits the manuscript's exact pruning, retaining isolated
atom nodes and thus preserving the number of components. -/
def atomSharedPoint_componentEquiv
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hreduced : F.HasNoIsolatedPoints) :
    F.levi.ConnectedComponent ≃
      (atomSharedPointIncidenceGraph F hlinear hbridge).ConnectedComponent := by
  classical
  exact (atomPoint_componentEquiv F hlinear hbridge).trans
    (_root_.SimpleGraph.FiniteForestCounting.pruneComponentEquiv
      (atomIncident F hlinear hbridge) (atomFinset F hlinear hbridge)
      (mem_atomFinset F hlinear hbridge)
      (exists_atomIncident F hlinear hbridge hreduced))

/-- Integer subtraction identity; no truncated subtraction is used. -/
theorem atom_surplus_identity
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    (Nat.card V : ℤ) - (Nat.card E : ℤ) =
      (Nat.card F.levi.ConnectedComponent : ℤ) +
        ∑ A ∈ atomFinset F hlinear hbridge,
          ((atomPointCount F hlinear hbridge A : ℤ) -
            (atomEdgeCount F hlinear hbridge A : ℤ) - 1) := by
  classical
  have he : (∑ A ∈ atomFinset F hlinear hbridge,
      (atomEdgeCount F hlinear hbridge A : ℤ)) = (Nat.card E : ℤ) := by
    exact_mod_cast sum_atomEdgeCount F hlinear hbridge
  have hv : (Nat.card V : ℤ) + ((atomFinset F hlinear hbridge).card : ℤ) =
      (∑ A ∈ atomFinset F hlinear hbridge, (atomPointCount F hlinear hbridge A : ℤ)) +
        (Nat.card F.levi.ConnectedComponent : ℤ) := by
    exact_mod_cast point_add_atom_count F hlinear hbridge
  simp only [Finset.sum_sub_distrib, Finset.sum_const, nsmul_eq_mul, mul_one]
  rw [he]
  omega

/-- Additive Euler expression. Identifying its summands as local connected
cycle ranks additionally requires the separate atom-connectivity theorem. -/
theorem atom_euler_identity
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    2 * (Nat.card E : ℤ) - (Nat.card V : ℤ) + (Nat.card F.levi.ConnectedComponent : ℤ) =
      ∑ A ∈ atomFinset F hlinear hbridge,
        (2 * (atomEdgeCount F hlinear hbridge A : ℤ) -
          (atomPointCount F hlinear hbridge A : ℤ) + 1) := by
  classical
  have he : (∑ A ∈ atomFinset F hlinear hbridge,
      (atomEdgeCount F hlinear hbridge A : ℤ)) = (Nat.card E : ℤ) := by
    exact_mod_cast sum_atomEdgeCount F hlinear hbridge
  have hv : (Nat.card V : ℤ) + ((atomFinset F hlinear hbridge).card : ℤ) =
      (∑ A ∈ atomFinset F hlinear hbridge, (atomPointCount F hlinear hbridge A : ℤ)) +
        (Nat.card F.levi.ConnectedComponent : ℤ) := by
    exact_mod_cast point_add_atom_count F hlinear hbridge
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib,
    ← Finset.mul_sum, Finset.sum_const, nsmul_eq_mul, mul_one]
  rw [he]
  omega

omit [DecidableEq V] [DecidableEq E] [DecidableRel F.levi.Adj] in
/-- This is the actual finite Levi Euler expression, not an assertion about
a separately defined cycle space. -/
theorem levi_euler_expression :
    (Nat.card F.levi.edgeSet : ℤ) - (Nat.card (V ⊕ E) : ℤ) +
        (Nat.card F.levi.ConnectedComponent : ℤ) =
      2 * (Nat.card E : ℤ) - (Nat.card V : ℤ) +
        (Nat.card F.levi.ConnectedComponent : ℤ) := by
  rw [levi_card_edges F, Nat.card_sum]
  push_cast
  ring

/-- Direct Euler accounting on the manuscript's pruned incidence forest.
This independently uses its actual edge set and component equivalence. -/
theorem shared_forest_excess_add_components
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hreduced : F.HasNoIsolatedPoints) :
    (∑ x ∈ sharedAtomPoints F hlinear hbridge,
      (pointMultiplicity F hlinear hbridge x - 1)) +
      Nat.card F.levi.ConnectedComponent = (atomFinset F hlinear hbridge).card := by
  classical
  letI := indexFintype F hlinear hbridge
  let S := sharedAtomPoints F hlinear hbridge
  let r := atomIncident F hlinear hbridge
  let iso := _root_.SimpleGraph.FiniteForestCounting.pruneGraphIso r
    (atomFinset F hlinear hbridge) (mem_atomFinset F hlinear hbridge)
  have hc := Nat.card_congr (atomSharedPoint_componentEquiv F hlinear hbridge hreduced)
  have hf := _root_.SimpleGraph.FiniteForestCounting.card_edges_add_components
    (atomSharedPointIncidenceGraph F hlinear hbridge)
    (atomSharedPointIncidenceGraph_isAcyclic F hlinear hbridge)
  have hv : Nat.card (Index F ⊕ ↥S) =
      Nat.card ↥(↑(_root_.SimpleGraph.bipartitePruneVertices r
        (atomFinset F hlinear hbridge)) : Set (Index F ⊕ V)) :=
    Nat.card_congr iso.toEquiv
  have he : Nat.card (atomSharedPointIncidenceGraph F hlinear hbridge).edgeSet =
      ∑ x ∈ S, pointMultiplicity F hlinear hbridge x := by
    change Nat.card ((_root_.SimpleGraph.bipartiteIncidenceGraph r).induce
      (↑(_root_.SimpleGraph.bipartitePruneVertices r (atomFinset F hlinear hbridge)) :
        Set (Index F ⊕ V))).edgeSet = _
    rw [← Nat.card_congr iso.mapEdgeSet,
      _root_.SimpleGraph.FiniteForestCounting.card_incidence_edges,
      _root_.SimpleGraph.FiniteForestCounting.sum_card_incidence_comm]
    calc
      _ = ∑ x : ↥S, pointMultiplicity F hlinear hbridge x.val :=
        Finset.sum_congr rfl (fun x _ => card_incidentAtoms F hlinear hbridge x.val)
      _ = _ := Finset.sum_coe_sort S _
  rw [he, ← hc, ← hv, Nat.card_sum] at hf
  have hs : (∑ x ∈ S, pointMultiplicity F hlinear hbridge x) =
      S.card + ∑ x ∈ S, (pointMultiplicity F hlinear hbridge x - 1) := by
    calc
      _ = ∑ x ∈ S, (1 + (pointMultiplicity F hlinear hbridge x - 1)) := by
        apply Finset.sum_congr rfl
        intro x hx
        have hh := two_le_pointMultiplicity_of_shared F hlinear hbridge hx
        omega
      _ = _ := by simp only [Finset.sum_add_distrib, Finset.sum_const, smul_eq_mul, mul_one]
  rw [hs] at hf
  have hS : Nat.card ↥S = S.card := by simp
  have hI : Nat.card (Index F) = (atomFinset F hlinear hbridge).card := by
    rw [atomFinset_eq_univ]
    simp
  rw [hS, hI] at hf
  change (∑ x ∈ S, (pointMultiplicity F hlinear hbridge x - 1)) + _ = _
  omega

/-- The global incidence-counting sublayer of S1. This does not assert the
remaining local connected-atom/core-order statements. -/
structure IncidenceCounts (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) : Prop where
  edge_partition :
    (∑ A ∈ atomFinset F hlinear hbridge, atomEdgeCount F hlinear hbridge A) = Nat.card E
  point_overlap :
    (∑ A ∈ atomFinset F hlinear hbridge, atomPointCount F hlinear hbridge A) =
      Nat.card V + ∑ x ∈ sharedAtomPoints F hlinear hbridge,
        (pointMultiplicity F hlinear hbridge x - 1)
  forest_excess :
    (∑ x ∈ sharedAtomPoints F hlinear hbridge,
      (pointMultiplicity F hlinear hbridge x - 1)) +
      Nat.card F.levi.ConnectedComponent = (atomFinset F hlinear hbridge).card
  forest_balance :
    Nat.card V + (atomFinset F hlinear hbridge).card =
      (∑ A ∈ atomFinset F hlinear hbridge, atomPointCount F hlinear hbridge A) +
        Nat.card F.levi.ConnectedComponent

/-- At the manuscript boundary, linearity and the bridge condition are
derived from obligatoriness; neither is an additional hypothesis. -/
theorem obligatory_incidenceCounts
    (hobligatory : F.IsObligatory) (hreduced : F.HasNoIsolatedPoints)
    (_hnonempty : Nonempty E) :
    ∃ (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge),
      IncidenceCounts F hlinear hbridge := by
  have hi : F.Intrinsic :=
    ((atomGenerated_iff_constructible F).mp
      ((isObligatory_iff_atomGenerated F).mp hobligatory)).intrinsic
  exact ⟨hi.1, hi.2.1, sum_atomEdgeCount F hi.1 hi.2.1,
    sum_atomPointCount F hi.1 hi.2.1 hreduced,
    shared_forest_excess_add_components F hi.1 hi.2.1 hreduced,
    point_add_atom_count F hi.1 hi.2.1⟩

/-! ## Internal atom connectivity and literal core counts -/

private theorem connected_of_twoVertexConnected {W : Type w} [Fintype W]
    (G : _root_.SimpleGraph W) (hG : IsTwoVertexConnected G) : G.Connected := by
  classical
  haveI : Nonempty W := Fintype.card_pos_iff.mp (by have := hG.1; omega)
  refine { preconnected := ?_, nonempty := inferInstance }
  intro x y
  have hsmall : ({x, y} : Finset W).card < (Finset.univ : Finset W).card := by
    have hp : ({x, y} : Finset W).card ≤ 2 := by
      by_cases hxy : x = y <;> simp [hxy]
    rw [Finset.card_univ]
    have := hG.1
    omega
  obtain ⟨z, _, hz⟩ := Finset.exists_mem_notMem_of_card_lt_card hsmall
  have hx : x ≠ z := by intro h; exact hz (by simp [h])
  have hy : y ≠ z := by intro h; exact hz (by simp [h])
  let inc : G.induce {p : W | p ≠ z} →g G :=
    ⟨Subtype.val, fun h => h⟩
  exact ((hG.2 z).preconnected ⟨x, hx⟩ ⟨y, hy⟩).map inc

private theorem component_card_of_connected {W : Type w}
    (G : _root_.SimpleGraph W) (hG : G.Connected) :
    Nat.card G.ConnectedComponent = 1 := by
  haveI := hG.nonempty
  haveI := hG.preconnected.subsingleton_connectedComponent
  exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩

private theorem expansion_connected_of_core_connected {W : Type w}
    (G : _root_.SimpleGraph W) (hG : G.Connected) :
    (privateVertexExpansion G).levi.Connected := by
  haveI := hG.nonempty
  haveI := hG.preconnected.subsingleton_connectedComponent
  refine { preconnected := ?_, nonempty := inferInstance }
  intro x y
  apply _root_.SimpleGraph.ConnectedComponent.exact
  apply (privateVertexExpansion_componentEquiv G).injective
  exact Subsingleton.elim _ _

omit [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E] [DecidableRel F.levi.Adj] in
private theorem singleEdgePiece_connected (e : E) : (F.singleEdgePiece e).levi.Connected := by
  apply (_root_.SimpleGraph.connected_iff_exists_forall_reachable _).mpr
  refine ⟨.inr (⟨()⟩ : SingleEdgeIndex), ?_⟩
  rintro (x | d)
  · exact ((levi_adj_edge_point (F.singleEdgePiece e)).mpr trivial).reachable
  · have hd : d = (⟨()⟩ : SingleEdgeIndex) := Subsingleton.elim _ _
    subst d
    exact .rfl

/-- Connectivity is inside the atom's own supported restriction, not merely
ambient connectivity in F. The exact A2 isomorphism transports the paths. -/
theorem atomRestriction_connected
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (A : Index F) :
    (atomRestriction F hlinear hbridge A).levi.Connected := by
  classical
  cases A with
  | singleton e hzero =>
    have hshape : Isomorphic (atomRestriction F hlinear hbridge (.singleton e hzero))
        (F.singleEdgePiece e : TripleSystem (F.edgeSet e) (SingleEdgeIndex : Type w)) :=
      atomRestriction_is_singleEdge_or_cycleBlockExpansion F hlinear hbridge (.singleton e hzero)
    obtain ⟨i⟩ := hshape
    exact i.leviIso.connected_iff.mpr (singleEdgePiece_connected F e)
  | cycleBlock C hC B =>
    have hshape : Isomorphic (atomRestriction F hlinear hbridge (.cycleBlock C hC B))
        (privateVertexExpansion (cycleBlockCore F C B)) :=
      atomRestriction_is_singleEdge_or_cycleBlockExpansion.{w, w, w}
        F hlinear hbridge (.cycleBlock C hC B)
    obtain ⟨i⟩ := hshape
    exact i.leviIso.connected_iff.mpr
      (expansion_connected_of_core_connected _
        (connected_of_twoVertexConnected _
          (cycleBlockCore_isTwoVertexConnected F hlinear hbridge C hC B)))

/-- The local component term is genuinely one, by internal connectivity. -/
theorem atomRestriction_component_card
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (A : Index F) :
    Nat.card (atomRestriction F hlinear hbridge A).levi.ConnectedComponent = 1 :=
  component_card_of_connected _ (atomRestriction_connected F hlinear hbridge A)

/-- The literal core order: two endpoints for a single edge, and the
existing finite cycle-block endpoint carrier in the nontrivial case. -/
def coreOrder : Index F → ℕ
  | .singleton _ _ => 2
  | .cycleBlock C _ B =>
    Nat.card (finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
      (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B))

/-- Exact A2 vertex and edge equivalences give n_A=m_A+|V(J_A)|. -/
theorem atomPointCount_eq_edge_add_core
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (A : Index F) :
    atomPointCount F hlinear hbridge A = atomEdgeCount F hlinear hbridge A + coreOrder F A := by
  classical
  have hshape := atomRestriction_is_singleEdge_or_cycleBlockExpansion F hlinear hbridge A
  cases A with
  | singleton e hzero =>
    obtain ⟨i⟩ := hshape
    have hv : atomPointCount F hlinear hbridge (.singleton e hzero) = 3 := by
      calc
        _ = Nat.card (F.edgeSet e) := Nat.card_congr i.vertexEquiv
        _ = 3 := F.edge_ncard e
    have he : atomEdgeCount F hlinear hbridge (.singleton e hzero) = 1 := by
      calc
        _ = Nat.card (SingleEdgeIndex : Type w) := Nat.card_congr i.edgeEquiv
        _ = 1 := by simp [SingleEdgeIndex]
    rw [hv, he]
    rfl
  | cycleBlock C hC B =>
    obtain ⟨i⟩ := hshape
    let W := finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
      (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B)
    let J := cycleBlockCore F C B
    have hv := Nat.card_congr i.vertexEquiv
    have he := Nat.card_congr i.edgeEquiv
    change atomPointCount F hlinear hbridge (.cycleBlock C hC B) =
      Nat.card (W ⊕ J.edgeSet) at hv
    change atomEdgeCount F hlinear hbridge (.cycleBlock C hC B) =
      Nat.card J.edgeSet at he
    rw [Nat.card_sum] at hv
    change atomPointCount F hlinear hbridge (.cycleBlock C hC B) =
      atomEdgeCount F hlinear hbridge (.cycleBlock C hC B) + Nat.card W
    omega

/-- The actual finite Levi Euler expression of one supported atom. This
definition does not assert any independent cycle-space dimension theorem. -/
def atomLeviEuler (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (A : Index F) : ℤ :=
  (Nat.card (atomRestriction F hlinear hbridge A).levi.edgeSet : ℤ) -
    (Nat.card (atomSupport F hlinear hbridge A ⊕ edges F hlinear hbridge A) : ℤ) +
      (Nat.card (atomRestriction F hlinear hbridge A).levi.ConnectedComponent : ℤ)

/-- Three incidences per hyperedge and one internal component justify the
local connected Euler summand 2*m_A-n_A+1. -/
theorem atomLeviEuler_eq
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (A : Index F) :
    atomLeviEuler F hlinear hbridge A =
      2 * (atomEdgeCount F hlinear hbridge A : ℤ) -
        (atomPointCount F hlinear hbridge A : ℤ) + 1 := by
  classical
  unfold atomLeviEuler
  rw [levi_card_edges (atomRestriction F hlinear hbridge A), Nat.card_sum,
    atomRestriction_component_card F hlinear hbridge A]
  change ((3 * atomEdgeCount F hlinear hbridge A : ℕ) : ℤ) -
      ((atomPointCount F hlinear hbridge A + atomEdgeCount F hlinear hbridge A : ℕ) : ℤ) + 1 = _
  push_cast
  ring

/-- The global Levi Euler expression splits over internally connected atoms. -/
theorem levi_euler_eq_sum_atomLeviEuler
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    (Nat.card F.levi.edgeSet : ℤ) - (Nat.card (V ⊕ E) : ℤ) +
        (Nat.card F.levi.ConnectedComponent : ℤ) =
      ∑ A ∈ atomFinset F hlinear hbridge, atomLeviEuler F hlinear hbridge A := by
  rw [levi_euler_expression F]
  simp_rw [atomLeviEuler_eq F hlinear hbridge]
  exact atom_euler_identity F hlinear hbridge

/-- The manuscript's core-order surplus formula uses the literal core of
each canonical atom, including the one-edge core of a single triple. -/
theorem surplus_eq_core_sum
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    (Nat.card V : ℤ) - (Nat.card E : ℤ) =
      (Nat.card F.levi.ConnectedComponent : ℤ) +
        ∑ A ∈ atomFinset F hlinear hbridge, ((coreOrder F A : ℤ) - 1) := by
  classical
  rw [atom_surplus_identity F hlinear hbridge]
  congr 1
  apply Finset.sum_congr rfl
  intro A _
  rw [atomPointCount_eq_edge_add_core F hlinear hbridge A]
  push_cast
  ring

/-- Complete canonical-forest accounting, with genuine internal atom
connectivity and both actual global and local Levi Euler interpretations. -/
structure CountingIdentities (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) : Prop
    extends IncidenceCounts F hlinear hbridge where
  atom_connected : ∀ A : Index F, (atomRestriction F hlinear hbridge A).levi.Connected
  core_order : ∀ A : Index F,
    atomPointCount F hlinear hbridge A = atomEdgeCount F hlinear hbridge A + coreOrder F A
  shared_components : Nonempty (F.levi.ConnectedComponent ≃
    (atomSharedPointIncidenceGraph F hlinear hbridge).ConnectedComponent)
  local_euler : ∀ A : Index F, atomLeviEuler F hlinear hbridge A =
    2 * (atomEdgeCount F hlinear hbridge A : ℤ) - (atomPointCount F hlinear hbridge A : ℤ) + 1
  levi_edges : Nat.card F.levi.edgeSet = 3 * Nat.card E
  levi_vertices : Nat.card (V ⊕ E) = Nat.card V + Nat.card E
  surplus : (Nat.card V : ℤ) - (Nat.card E : ℤ) =
    (Nat.card F.levi.ConnectedComponent : ℤ) +
      ∑ A ∈ atomFinset F hlinear hbridge,
        ((atomPointCount F hlinear hbridge A : ℤ) - (atomEdgeCount F hlinear hbridge A : ℤ) - 1)
  core_surplus : (Nat.card V : ℤ) - (Nat.card E : ℤ) =
    (Nat.card F.levi.ConnectedComponent : ℤ) +
      ∑ A ∈ atomFinset F hlinear hbridge, ((coreOrder F A : ℤ) - 1)
  euler_additive : (Nat.card F.levi.edgeSet : ℤ) - (Nat.card (V ⊕ E) : ℤ) +
    (Nat.card F.levi.ConnectedComponent : ℤ) =
      ∑ A ∈ atomFinset F hlinear hbridge, atomLeviEuler F hlinear hbridge A

/-- Full S1 boundary, including an actual N2 shadow whose order is the
integer surplus and hence the sum of the literal atom core contributions. -/
theorem obligatory_canonical_counting
    (hobligatory : F.IsObligatory) (hreduced : F.HasNoIsolatedPoints)
    (hnonempty : Nonempty E) :
    ∃ (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge),
      CountingIdentities F hlinear hbridge ∧
        ∃ (s : ℕ) (J : _root_.SimpleGraph (Fin s)),
          J.Colorable 2 ∧ (∀ x, ∃ y, J.Adj x y) ∧
          Nat.card J.edgeSet = Nat.card E ∧
          (s : ℤ) = (Nat.card V : ℤ) - (Nat.card E : ℤ) ∧
          Nat.card J.ConnectedComponent = Nat.card F.levi.ConnectedComponent ∧
          (s : ℤ) = (Nat.card F.levi.ConnectedComponent : ℤ) +
            ∑ A ∈ atomFinset F hlinear hbridge, ((coreOrder F A : ℤ) - 1) := by
  classical
  have hi : F.Intrinsic :=
    ((atomGenerated_iff_constructible F).mp
      ((isObligatory_iff_atomGenerated F).mp hobligatory)).intrinsic
  refine ⟨hi.1, hi.2.1, ?_, ?_⟩
  · exact
      { toIncidenceCounts :=
          ⟨sum_atomEdgeCount F hi.1 hi.2.1,
            sum_atomPointCount F hi.1 hi.2.1 hreduced,
            shared_forest_excess_add_components F hi.1 hi.2.1 hreduced,
            point_add_atom_count F hi.1 hi.2.1⟩
        atom_connected := atomRestriction_connected F hi.1 hi.2.1
        core_order := atomPointCount_eq_edge_add_core F hi.1 hi.2.1
        shared_components := ⟨atomSharedPoint_componentEquiv F hi.1 hi.2.1 hreduced⟩
        local_euler := atomLeviEuler_eq F hi.1 hi.2.1
        levi_edges := levi_card_edges F
        levi_vertices := Nat.card_sum
        surplus := atom_surplus_identity F hi.1 hi.2.1
        core_surplus := surplus_eq_core_sum F hi.1 hi.2.1
        euler_additive := levi_euler_eq_sum_atomLeviEuler F hi.1 hi.2.1 }
  · obtain ⟨s, J, hcol, hnoisolated, he, hv, hc⟩ :=
      exists_bipartite_shadow F hobligatory hreduced hnonempty
    have hs : (s : ℤ) = (Nat.card V : ℤ) - (Nat.card E : ℤ) := by
      have hvNat : s + Nat.card E = Nat.card V := by
        simpa only [Nat.card_eq_fintype_card] using hv
      have hv' : (s : ℤ) + (Nat.card E : ℤ) = (Nat.card V : ℤ) := by
        exact_mod_cast hvNat
      omega
    refine ⟨s, J, hcol, hnoisolated, ?_, hs, hc, ?_⟩
    · simpa only [Nat.card_eq_fintype_card] using he
    · exact hs.trans (surplus_eq_core_sum F hi.1 hi.2.1)

end

end Erdos593.TripleSystem.CanonicalAtom
