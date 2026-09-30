import Erdos593.TripleSystem.CanonicalAtomCoreStructure
import Erdos593.TripleSystem.EdgeRestrictionFull
import Erdos593.TripleSystem.EdgeRestrictionReconstruction
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceForestOrder
import Erdos593.TripleSystem.SingleEdgePieceConstructible

/-!
# Canonical atom incidence forest and exact reconstruction

This module packages the second layer of the canonical atom normal form.  It
keeps the literal fibres of `CanonicalAtom.atomOf`, records their exact point
supports, prunes the point side of the incidence graph to points belonging to
at least two atoms, and exposes a newest-first running edge assembly whose
total edge union is `Set.univ`.

Pairwise one-point intersection and global incidence acyclicity are separate
obligations: the former is not used as a substitute for the latter.  The
final reconstruction uses `edgeRestrictionUnivIso`, so the no-isolated-points
hypothesis occurs only at the boundary where the supported restriction is
identified with the original vertex type.
-/

namespace Erdos593

universe w

namespace TripleSystem
namespace CanonicalAtom

noncomputable section

variable {V E : Type w} (F : TripleSystem V E)
variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
  [DecidableRel F.levi.Adj]

noncomputable local instance atomIndexDecidableEq :
    DecidableEq (CanonicalAtom.Index F) :=
  Classical.decEq _

/-- The original points incident with at least one hyperedge of a canonical
atom fibre. -/
def atomSupport
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : CanonicalAtom.Index F) : Set V :=
  F.edgeSupportSet (CanonicalAtom.edges F hlinear hbridge A)

/-- The finite carrier of represented canonical labels, constructed as the
image of the finite original hyperedge type. -/
noncomputable def atomFinset
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    Finset (CanonicalAtom.Index F) := by
  classical
  exact Finset.univ.image (CanonicalAtom.atomOf F hlinear hbridge)

/-- Surjectivity of `atomOf` says that the finite carrier contains every
canonical label; there are no ghost atom indices. -/
@[simp]
theorem mem_atomFinset
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : CanonicalAtom.Index F) :
    A ∈ CanonicalAtom.atomFinset F hlinear hbridge := by
  classical
  rw [CanonicalAtom.atomFinset, Finset.mem_image]
  obtain ⟨e, he⟩ := CanonicalAtom.atomOf_surjective F hlinear hbridge A
  exact ⟨e, Finset.mem_univ e, he⟩

/-- Incidence of a canonical atom label with an original point. -/
def atomIncident
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : CanonicalAtom.Index F) (x : V) : Prop :=
  x ∈ CanonicalAtom.atomSupport F hlinear hbridge A

noncomputable local instance atomIncidentDecidableRel
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    DecidableRel (CanonicalAtom.atomIncident F hlinear hbridge) :=
  fun A x => Classical.propDecidable
    (CanonicalAtom.atomIncident F hlinear hbridge A x)

/-- The full bipartite atom--point incidence graph.  Degree-zero and
degree-one point vertices are harmless leaves/isolates; the exact manuscript
carrier is obtained by the pruning below. -/
def atomPointIncidenceGraph
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :=
  SimpleGraph.bipartiteIncidenceGraph
    (CanonicalAtom.atomIncident F hlinear hbridge)

/-- Original points incident with at least two represented canonical atoms. -/
noncomputable def sharedAtomPoints
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) : Finset V := by
  classical
  exact SimpleGraph.sharedRightPoints
    (CanonicalAtom.atomIncident F hlinear hbridge)
    (CanonicalAtom.atomFinset F hlinear hbridge)

/-- The exact manuscript incidence graph: all represented atom labels and
only original points incident with at least two of them.  A point shared by
three or more atoms remains one right-side vertex. -/
noncomputable def atomSharedPointIncidenceGraph
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) := by
  classical
  exact (CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).induce
    (↑(SimpleGraph.bipartitePruneVertices
      (CanonicalAtom.atomIncident F hlinear hbridge)
      (CanonicalAtom.atomFinset F hlinear hbridge)) :
        Set (CanonicalAtom.Index F ⊕ V))

/-- Membership in the pruned point carrier is literally incidence with at
least two represented atoms. -/
@[simp]
theorem mem_sharedAtomPoints
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) (x : V) :
    x ∈ CanonicalAtom.sharedAtomPoints F hlinear hbridge ↔
      2 ≤ ((CanonicalAtom.atomFinset F hlinear hbridge).filter
        (fun A => CanonicalAtom.atomIncident F hlinear hbridge A x)).card := by
  simpa only [CanonicalAtom.sharedAtomPoints] using
    (SimpleGraph.mem_sharedRightPoints
      (CanonicalAtom.atomIncident F hlinear hbridge)
      (CanonicalAtom.atomFinset F hlinear hbridge) x)

/-- Distinct canonical atom fibres have disjoint hyperedge-index sets. -/
theorem atomEdges_disjoint
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    {A B : CanonicalAtom.Index F} (hAB : A ≠ B) :
    Disjoint (CanonicalAtom.edges F hlinear hbridge A)
      (CanonicalAtom.edges F hlinear hbridge B) := by
  rw [Set.disjoint_left]
  intro e heA heB
  change CanonicalAtom.atomOf F hlinear hbridge e = A at heA
  change CanonicalAtom.atomOf F hlinear hbridge e = B at heB
  exact hAB (heA.symm.trans heB)

/-- Distinct canonical atom supports meet in at most one original point. -/
theorem atomSupport_inter_subsingleton
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    {A B : CanonicalAtom.Index F} (hAB : A ≠ B) :
    (CanonicalAtom.atomSupport F hlinear hbridge A ∩
      CanonicalAtom.atomSupport F hlinear hbridge B).Subsingleton := by
  classical
  -- The two literal shapes of the welded label map.
  have atomOf_singleton : ∀ (e : E)
      (hzero : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      CanonicalAtom.atomOf F hlinear hbridge e = Index.singleton e hzero := by
    intro e hzero
    unfold CanonicalAtom.atomOf
    rw [dif_pos hzero]
  have atomOf_cycle : ∀ (e : E)
      (hne : ¬ (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      CanonicalAtom.atomOf F hlinear hbridge e =
        Index.cycleBlock (BridgeBlock.hyperedgeComponentOf F e)
          (CanonicalAtom.hyperedgeComponent_hasIncidence_of_degree_ne_zero F hne)
          (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
            (BridgeBlock.contractedGraph F (BridgeBlock.hyperedgeComponentOf F e))
            ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge
                (CanonicalAtom.hyperedgeComponent_hasIncidence_of_degree_ne_zero
                  F hne)).symm
              ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩)) := by
    intro e hne
    unfold CanonicalAtom.atomOf
    rw [dif_neg hne]
  -- Hyperedges with a common canonical label lie in one bridge-free block.
  have samecomp : ∀ e f : E, CanonicalAtom.atomOf F hlinear hbridge e =
        CanonicalAtom.atomOf F hlinear hbridge f →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable (Sum.inr e) (Sum.inr f) := by
    intro e f h
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
  -- A residual-degree-zero label has exactly one hyperedge in its fibre.
  have singleton_fibre : ∀ (e f : E)
      (hzero : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      CanonicalAtom.atomOf F hlinear hbridge f = Index.singleton e hzero → f = e := by
    intro e f hzero h
    by_cases hf : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) = 0
    · rw [atomOf_singleton f hf] at h
      injection h
    · rw [atomOf_cycle f hf] at h
      exact absurd h (by simp)
  -- A surviving incidence with a cycle-block label is an incidence of the block.
  have core_atom_data : ∀ (C : BridgeBlock.HyperedgeComponent F)
      (hC : BridgeBlock.HasIncidence F C)
      (B : Erdos593.SimpleGraph.EdgeCycleBlock (BridgeBlock.contractedGraph F C))
      (x : V) (e : E),
      CanonicalAtom.atomOf F hlinear hbridge e = Index.cycleBlock C hC B →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl x) (Sum.inr e) →
      ∃ hx : Sum.inl x ∈ (C : BridgeBlock.Component F).supp,
        Erdos593.SimpleGraph.EdgeCycleBlock.Incident
          (BridgeBlock.contractedGraph F C) ⟨x, hx⟩ B := by
    intro C hC B x e hA hadj
    have hdeg : ¬ (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0 := by
      have hpos : 0 < (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) :=
        ((Erdos593.SimpleGraph.bridgeFree F.levi).degree_pos_iff_exists_adj
          (Sum.inr e)).mpr ⟨Sum.inl x, hadj.symm⟩
      omega
    rw [atomOf_cycle e hdeg] at hA
    injection hA with h1 h3
    subst h1
    have hB : B = Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
        (BridgeBlock.contractedGraph F (BridgeBlock.hyperedgeComponentOf F e))
        ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm
          ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩) := (eq_of_heq h3).symm
    have hx : Sum.inl x ∈
        ((BridgeBlock.hyperedgeComponentOf F e : BridgeBlock.Component F)).supp :=
      (BridgeBlock.hyperedgeComponentOf F e :
        BridgeBlock.Component F).mem_supp_of_adj_mem_supp
          (BridgeBlock.mem_hyperedgeComponentOf_set F e) hadj.symm
    refine ⟨hx, ?_⟩
    subst hB
    set a : (BridgeBlock.contractedGraph F
        (BridgeBlock.hyperedgeComponentOf F e)).edgeSet :=
      (BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm
        ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩
    have hwit : (BridgeBlock.graphEdgeWitness F hlinear
        (C := (BridgeBlock.hyperedgeComponentOf F e :
          BridgeBlock.Component F)) a).1 = e :=
      congrArg Subtype.val
        ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).apply_symm_apply
          ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩)
    have hmem : (⟨x, hx⟩ : BridgeBlock.Point F
        (BridgeBlock.hyperedgeComponentOf F e)) ∈ (a.1 : Sym2 _) := by
      rw [BridgeBlock.mem_graphEdge_iff_bridgeFree_adj_graphEdgeWitness
        F hlinear a ⟨x, hx⟩, hwit]
      exact hadj
    exact Erdos593.SimpleGraph.EdgeCycleBlock.incident_of_mem_endpoint _ rfl hmem
  -- A nonbridge incidence survives bridge deletion.
  have adj_of_not_bridge : ∀ (u : V) (w : E), F.Inc u w →
      ¬ F.levi.IsBridge s(Sum.inl u, Sum.inr w) →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl u) (Sum.inr w) := by
    intro u w hinc hnb
    rw [Erdos593.SimpleGraph.bridgeFree, _root_.SimpleGraph.deleteEdges_adj]
    exact ⟨F.levi_adj_point_edge.mpr hinc,
      fun hmem => hnb (Erdos593.SimpleGraph.mem_bridgeFinset.mp hmem).2⟩
  have bridgeFree_adj_deleteEdges : ∀ (b : Sym2 (V ⊕ E)), F.levi.IsBridge b →
      b ∈ F.levi.edgeSet → ∀ u v : V ⊕ E,
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj u v →
      (F.levi.deleteEdges {b}).Adj u v := by
    intro b hb hbmem u v h
    rw [Erdos593.SimpleGraph.bridgeFree, _root_.SimpleGraph.deleteEdges_adj] at h
    rw [_root_.SimpleGraph.deleteEdges_adj]
    refine ⟨h.1, ?_⟩
    intro hmem
    apply h.2
    rw [Set.mem_singleton_iff.mp hmem]
    exact Erdos593.SimpleGraph.mem_bridgeFinset.mpr ⟨hbmem, hb⟩
  -- Two block-connected hyperedge pairs meeting two points exclude a bridge.
  have nobridge : ∀ (x y : V) (p q r t : E), x ≠ y → p ≠ r →
      F.Inc x p → F.Inc y q → F.Inc x r → F.Inc y t →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable (Sum.inr p) (Sum.inr q) →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable (Sum.inr r) (Sum.inr t) →
      ¬ F.levi.IsBridge s(Sum.inl x, Sum.inr p) := by
    intro x y p q r t hxy hpr hxp hyq hxr hyt hpq hrt hb
    have hbmem : s(Sum.inl x, Sum.inr p) ∈ F.levi.edgeSet :=
      F.levi_adj_point_edge.mpr hxp
    have hmono : (Erdos593.SimpleGraph.bridgeFree F.levi) ≤
        F.levi.deleteEdges {s(Sum.inl x, Sum.inr p)} := by
      intro a b h
      exact bridgeFree_adj_deleteEdges _ hb hbmem a b h
    have hstep : ∀ (u : V) (w : E), F.Inc u w → (u ≠ x ∨ w ≠ p) →
        (F.levi.deleteEdges {s(Sum.inl x, Sum.inr p)}).Adj
          (Sum.inl u) (Sum.inr w) := by
      intro u w hinc hne
      rw [_root_.SimpleGraph.deleteEdges_adj]
      refine ⟨F.levi_adj_point_edge.mpr hinc, ?_⟩
      intro hmem
      have heq : s((Sum.inl u : V ⊕ E), Sum.inr w) = s(Sum.inl x, Sum.inr p) :=
        Set.mem_singleton_iff.mp hmem
      rcases Sym2.eq_iff.mp heq with ⟨h1, h2⟩ | ⟨h1, _⟩
      · rcases hne with hne | hne
        · exact hne (Sum.inl.inj h1)
        · exact hne (Sum.inr.inj h2)
      · exact Sum.inl_ne_inr h1
    have hR : (F.levi.deleteEdges {s(Sum.inl x, Sum.inr p)}).Reachable
        (Sum.inl x) (Sum.inr p) := by
      refine ((hstep x r hxr (Or.inr hpr.symm)).reachable.trans ?_)
      refine ((hrt.mono hmono).trans ?_)
      refine (((hstep y t hyt (Or.inl hxy.symm)).symm).reachable.trans ?_)
      exact ((hstep y q hyq (Or.inl hxy.symm)).reachable.trans (hpq.symm.mono hmono))
    exact (_root_.SimpleGraph.isBridge_iff.mp hb) hR
  -- The exact support claim.
  intro x hx y hy
  by_contra hxy
  obtain ⟨⟨p, hpA, hxp⟩, ⟨r, hrB, hxr⟩⟩ := hx
  obtain ⟨⟨q, hqA, hyq⟩, ⟨t, htB, hyt⟩⟩ := hy
  change CanonicalAtom.atomOf F hlinear hbridge p = A at hpA
  change CanonicalAtom.atomOf F hlinear hbridge q = A at hqA
  change CanonicalAtom.atomOf F hlinear hbridge r = B at hrB
  change CanonicalAtom.atomOf F hlinear hbridge t = B at htB
  have hpr : p ≠ r := fun h => hAB (hpA.symm.trans (h ▸ hrB))
  have hqt : q ≠ t := fun h => hAB (hqA.symm.trans (h ▸ htB))
  have hpq : (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable
      (Sum.inr p) (Sum.inr q) := samecomp p q (hpA.trans hqA.symm)
  have hrt : (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable
      (Sum.inr r) (Sum.inr t) := samecomp r t (hrB.trans htB.symm)
  have hax : (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl x) (Sum.inr p) :=
    adj_of_not_bridge x p hxp (nobridge x y p q r t hxy hpr hxp hyq hxr hyt hpq hrt)
  have hay : (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl y) (Sum.inr q) :=
    adj_of_not_bridge y q hyq (nobridge y x q p t r (Ne.symm hxy) hqt hyq hxp hyt hxr
      hpq.symm hrt.symm)
  have hbx : (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl x) (Sum.inr r) :=
    adj_of_not_bridge x r hxr (nobridge x y r t p q hxy (Ne.symm hpr) hxr hyt hxp hyq
      hrt hpq)
  have hby : (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl y) (Sum.inr t) :=
    adj_of_not_bridge y t hyt (nobridge y x t r q p (Ne.symm hxy) (Ne.symm hqt) hyt hxr
      hyq hxp hrt.symm hpq.symm)
  clear hpq hrt
  cases A with
  | singleton e hzero =>
      have hpe : p = e := singleton_fibre e p hzero hpA
      subst hpe
      have hpos : 0 < (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr p) :=
        ((Erdos593.SimpleGraph.bridgeFree F.levi).degree_pos_iff_exists_adj
          (Sum.inr p)).mpr ⟨Sum.inl x, hax.symm⟩
      omega
  | cycleBlock C hC BA =>
      cases B with
      | singleton e hzero =>
          have hre : r = e := singleton_fibre e r hzero hrB
          subst hre
          have hpos : 0 < (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr r) :=
            ((Erdos593.SimpleGraph.bridgeFree F.levi).degree_pos_iff_exists_adj
              (Sum.inr r)).mpr ⟨Sum.inl x, hbx.symm⟩
          omega
      | cycleBlock C' hC' BB =>
          obtain ⟨hxC, hxBA⟩ := core_atom_data C hC BA x p hpA hax
          obtain ⟨hyC, hyBA⟩ := core_atom_data C hC BA y q hqA hay
          obtain ⟨hxC', hxBB⟩ := core_atom_data C' hC' BB x r hrB hbx
          obtain ⟨hyC', hyBB⟩ := core_atom_data C' hC' BB y t htB hby
          have hCC' : C = C' := by
            apply Subtype.ext
            have h1 := (_root_.SimpleGraph.ConnectedComponent.mem_supp_iff
              (C : BridgeBlock.Component F) (Sum.inl x)).mp hxC
            have h2 := (_root_.SimpleGraph.ConnectedComponent.mem_supp_iff
              (C' : BridgeBlock.Component F) (Sum.inl x)).mp hxC'
            exact h1.symm.trans h2
          subst hCC'
          have hne : (⟨x, hxC⟩ : BridgeBlock.Point F (C : BridgeBlock.Component F)) ≠
              ⟨y, hyC⟩ := fun h => hxy (congrArg Subtype.val h)
          have hblocks : BA = BB :=
            Erdos593.SimpleGraph.EdgeCycleBlock.eq_of_incident_two_vertices
              (BridgeBlock.contractedGraph F (C : BridgeBlock.Component F))
              hne hxBA hyBA hxBB hyBB
          subst hblocks
          exact hAB rfl

/-- The full canonical atom--point incidence graph is acyclic.  This is the
global alternating-cycle exclusion and is strictly stronger than the
pairwise support-intersection theorem. -/
theorem atomPointIncidenceGraph_isAcyclic
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    (CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).IsAcyclic := by
  classical
  -- The two literal shapes of the welded label map.
  have atomOf_singleton : ∀ (e : E)
      (hzero : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      CanonicalAtom.atomOf F hlinear hbridge e = Index.singleton e hzero := by
    intro e hzero
    unfold CanonicalAtom.atomOf
    rw [dif_pos hzero]
  have atomOf_cycle : ∀ (e : E)
      (hne : ¬ (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      CanonicalAtom.atomOf F hlinear hbridge e =
        Index.cycleBlock (BridgeBlock.hyperedgeComponentOf F e)
          (CanonicalAtom.hyperedgeComponent_hasIncidence_of_degree_ne_zero F hne)
          (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
            (BridgeBlock.contractedGraph F (BridgeBlock.hyperedgeComponentOf F e))
            ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge
                (CanonicalAtom.hyperedgeComponent_hasIncidence_of_degree_ne_zero
                  F hne)).symm
              ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩)) := by
    intro e hne
    unfold CanonicalAtom.atomOf
    rw [dif_neg hne]
  -- Hyperedges with a common canonical label lie in one bridge-free block.
  have samecomp : ∀ e f : E, CanonicalAtom.atomOf F hlinear hbridge e =
        CanonicalAtom.atomOf F hlinear hbridge f →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable (Sum.inr e) (Sum.inr f) := by
    intro e f h
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
  -- A residual-degree-zero label has exactly one hyperedge in its fibre, so it
  -- carries no surviving incidence at all.
  have singleton_fibre : ∀ (e f : E)
      (hzero : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      CanonicalAtom.atomOf F hlinear hbridge f = Index.singleton e hzero → f = e := by
    intro e f hzero h
    by_cases hf : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) = 0
    · rw [atomOf_singleton f hf] at h
      injection h
    · rw [atomOf_cycle f hf] at h
      exact absurd h (by simp)
  have singleton_no_core : ∀ (e f : E) (x : V)
      (hzero : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0),
      CanonicalAtom.atomOf F hlinear hbridge f = Index.singleton e hzero →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl x) (Sum.inr f) →
      False := by
    intro e f x hzero h hadj
    have hfe : f = e := singleton_fibre e f hzero h
    subst hfe
    have hpos : 0 < (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) :=
      ((Erdos593.SimpleGraph.bridgeFree F.levi).degree_pos_iff_exists_adj
        (Sum.inr f)).mpr ⟨Sum.inl x, hadj.symm⟩
    omega
  -- A surviving incidence with a cycle-block label is an incidence of the block.
  have core_atom_data : ∀ (C : BridgeBlock.HyperedgeComponent F)
      (hC : BridgeBlock.HasIncidence F C)
      (B : Erdos593.SimpleGraph.EdgeCycleBlock (BridgeBlock.contractedGraph F C))
      (x : V) (e : E),
      CanonicalAtom.atomOf F hlinear hbridge e = Index.cycleBlock C hC B →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl x) (Sum.inr e) →
      ∃ hx : Sum.inl x ∈ (C : BridgeBlock.Component F).supp,
        Erdos593.SimpleGraph.EdgeCycleBlock.Incident
          (BridgeBlock.contractedGraph F C) ⟨x, hx⟩ B := by
    intro C hC B x e hA hadj
    have hdeg : ¬ (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0 := by
      have hpos : 0 < (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) :=
        ((Erdos593.SimpleGraph.bridgeFree F.levi).degree_pos_iff_exists_adj
          (Sum.inr e)).mpr ⟨Sum.inl x, hadj.symm⟩
      omega
    rw [atomOf_cycle e hdeg] at hA
    injection hA with h1 h3
    subst h1
    have hB : B = Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
        (BridgeBlock.contractedGraph F (BridgeBlock.hyperedgeComponentOf F e))
        ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm
          ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩) := (eq_of_heq h3).symm
    have hx : Sum.inl x ∈
        ((BridgeBlock.hyperedgeComponentOf F e : BridgeBlock.Component F)).supp :=
      (BridgeBlock.hyperedgeComponentOf F e :
        BridgeBlock.Component F).mem_supp_of_adj_mem_supp
          (BridgeBlock.mem_hyperedgeComponentOf_set F e) hadj.symm
    refine ⟨hx, ?_⟩
    subst hB
    set a : (BridgeBlock.contractedGraph F
        (BridgeBlock.hyperedgeComponentOf F e)).edgeSet :=
      (BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm
        ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩
    have hwit : (BridgeBlock.graphEdgeWitness F hlinear
        (C := (BridgeBlock.hyperedgeComponentOf F e :
          BridgeBlock.Component F)) a).1 = e :=
      congrArg Subtype.val
        ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).apply_symm_apply
          ⟨e, BridgeBlock.mem_hyperedgeComponentOf_set F e⟩)
    have hmem : (⟨x, hx⟩ : BridgeBlock.Point F
        (BridgeBlock.hyperedgeComponentOf F e)) ∈ (a.1 : Sym2 _) := by
      rw [BridgeBlock.mem_graphEdge_iff_bridgeFree_adj_graphEdgeWitness
        F hlinear a ⟨x, hx⟩, hwit]
      exact hadj
    exact Erdos593.SimpleGraph.EdgeCycleBlock.incident_of_mem_endpoint _ rfl hmem
  -- A nonbridge incidence survives bridge deletion.
  have adj_of_not_bridge : ∀ (u : V) (w : E), F.Inc u w →
      ¬ F.levi.IsBridge s(Sum.inl u, Sum.inr w) →
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl u) (Sum.inr w) := by
    intro u w hinc hnb
    rw [Erdos593.SimpleGraph.bridgeFree, _root_.SimpleGraph.deleteEdges_adj]
    exact ⟨F.levi_adj_point_edge.mpr hinc,
      fun hmem => hnb (Erdos593.SimpleGraph.mem_bridgeFinset.mp hmem).2⟩
  have bridgeFree_adj_deleteEdges : ∀ (b : Sym2 (V ⊕ E)), F.levi.IsBridge b →
      b ∈ F.levi.edgeSet → ∀ u v : V ⊕ E,
      (Erdos593.SimpleGraph.bridgeFree F.levi).Adj u v →
      (F.levi.deleteEdges {b}).Adj u v := by
    intro b hb hbmem u v h
    rw [Erdos593.SimpleGraph.bridgeFree, _root_.SimpleGraph.deleteEdges_adj] at h
    rw [_root_.SimpleGraph.deleteEdges_adj]
    refine ⟨h.1, ?_⟩
    intro hmem
    apply h.2
    rw [Set.mem_singleton_iff.mp hmem]
    exact Erdos593.SimpleGraph.mem_bridgeFinset.mpr ⟨hbmem, hb⟩
  -- The incidence graph is bipartite between labels and points.
  have incidence_adj_cases : ∀ u v : CanonicalAtom.Index F ⊕ V,
      (CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).Adj u v →
      (∃ A y, u = Sum.inl A ∧ v = Sum.inr y ∧
          CanonicalAtom.atomIncident F hlinear hbridge A y) ∨
        (∃ A y, u = Sum.inr y ∧ v = Sum.inl A ∧
          CanonicalAtom.atomIncident F hlinear hbridge A y) := by
    intro u v h
    rcases u with A | y <;> rcases v with A' | y'
    · exact absurd h (by
        simp [CanonicalAtom.atomPointIncidenceGraph,
          _root_.SimpleGraph.bipartiteIncidenceGraph, _root_.SimpleGraph.fromRel_adj])
    · exact Or.inl ⟨A, y', rfl, rfl, by
        simpa [CanonicalAtom.atomPointIncidenceGraph] using h⟩
    · exact Or.inr ⟨A', y, rfl, rfl, by
        simpa [CanonicalAtom.atomPointIncidenceGraph] using h⟩
    · exact absurd h (by
        simp [CanonicalAtom.atomPointIncidenceGraph,
          _root_.SimpleGraph.bipartiteIncidenceGraph, _root_.SimpleGraph.fromRel_adj])
  -- Welded bridge-block structure: an incidence carried by an actual Levi
  -- bridge cannot be reached back around inside the incidence graph.
  have bridge_edge_not_reachable : ∀ (A₀ : CanonicalAtom.Index F) (x₀ : V) (e₀ : E),
      CanonicalAtom.atomOf F hlinear hbridge e₀ = A₀ → F.Inc x₀ e₀ →
      F.levi.IsBridge s(Sum.inl x₀, Sum.inr e₀) →
      ¬ ((CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).deleteEdges
          {s(Sum.inl A₀, Sum.inr x₀)}).Reachable (Sum.inl A₀) (Sum.inr x₀) := by
    intro A₀ x₀ e₀ he₀ hinc hb hreach
    have hbmem : s(Sum.inl x₀, Sum.inr e₀) ∈ F.levi.edgeSet :=
      F.levi_adj_point_edge.mpr hinc
    have hmono : (Erdos593.SimpleGraph.bridgeFree F.levi) ≤
        F.levi.deleteEdges {s(Sum.inl x₀, Sum.inr e₀)} := by
      intro a b h
      exact bridgeFree_adj_deleteEdges _ hb hbmem a b h
    obtain ⟨rep, hrep⟩ : ∃ rep : CanonicalAtom.Index F → E,
        ∀ A, CanonicalAtom.atomOf F hlinear hbridge (rep A) = A :=
      ⟨fun A => Classical.choose (CanonicalAtom.atomOf_surjective F hlinear hbridge A),
        fun A => Classical.choose_spec
          (CanonicalAtom.atomOf_surjective F hlinear hbridge A)⟩
    obtain ⟨lev, hlevl, hlevr⟩ : ∃ lev : (CanonicalAtom.Index F ⊕ V) → (V ⊕ E),
        (∀ A, lev (Sum.inl A) = Sum.inr (rep A)) ∧
          (∀ y, lev (Sum.inr y) = Sum.inl y) :=
      ⟨fun u => match u with
        | Sum.inl A => Sum.inr (rep A)
        | Sum.inr y => Sum.inl y, fun _ => rfl, fun _ => rfl⟩
    have hstep : ∀ u v : CanonicalAtom.Index F ⊕ V,
        ((CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).deleteEdges
          {s(Sum.inl A₀, Sum.inr x₀)}).Adj u v →
        (F.levi.deleteEdges {s(Sum.inl x₀, Sum.inr e₀)}).Reachable (lev u) (lev v) := by
      have hbase : ∀ (A : CanonicalAtom.Index F) (y : V),
          CanonicalAtom.atomIncident F hlinear hbridge A y →
          ¬ (s((Sum.inl A : CanonicalAtom.Index F ⊕ V), Sum.inr y) =
            s(Sum.inl A₀, Sum.inr x₀)) →
          (F.levi.deleteEdges {s(Sum.inl x₀, Sum.inr e₀)}).Reachable
            (Sum.inr (rep A)) (Sum.inl y) := by
        intro A y hAy hne
        obtain ⟨f, hf, hyf⟩ := hAy
        change CanonicalAtom.atomOf F hlinear hbridge f = A at hf
        have h1 : (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable
            (Sum.inr (rep A)) (Sum.inr f) := samecomp _ _ ((hrep A).trans hf.symm)
        have h2 : (F.levi.deleteEdges {s(Sum.inl x₀, Sum.inr e₀)}).Adj
            (Sum.inl y) (Sum.inr f) := by
          rw [_root_.SimpleGraph.deleteEdges_adj]
          refine ⟨F.levi_adj_point_edge.mpr hyf, ?_⟩
          intro hmem
          have heq : s((Sum.inl y : V ⊕ E), Sum.inr f) = s(Sum.inl x₀, Sum.inr e₀) :=
            Set.mem_singleton_iff.mp hmem
          rcases Sym2.eq_iff.mp heq with ⟨hy1, hf1⟩ | ⟨hy1, _⟩
          · apply hne
            have hyx : y = x₀ := Sum.inl.inj hy1
            have hfe : f = e₀ := Sum.inr.inj hf1
            subst hyx
            subst hfe
            rw [← hf, he₀]
          · exact Sum.inl_ne_inr hy1
        exact (h1.mono hmono).trans h2.symm.reachable
      intro u v huv
      rw [_root_.SimpleGraph.deleteEdges_adj] at huv
      obtain ⟨hadj, hnotmem⟩ := huv
      have hne : ¬ (s(u, v) =
          s((Sum.inl A₀ : CanonicalAtom.Index F ⊕ V), Sum.inr x₀)) :=
        fun h => hnotmem (Set.mem_singleton_iff.mpr h)
      rcases incidence_adj_cases u v hadj with
        ⟨A, y, rfl, rfl, hAy⟩ | ⟨A, y, rfl, rfl, hAy⟩
      · rw [hlevl, hlevr]
        exact hbase A y hAy hne
      · rw [hlevl, hlevr]
        refine (hbase A y hAy ?_).symm
        intro h
        apply hne
        rw [Sym2.eq_swap]
        exact h
    obtain ⟨p⟩ := hreach
    have hmain : ∀ (u v : CanonicalAtom.Index F ⊕ V)
        (wlk : ((CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).deleteEdges
          {s(Sum.inl A₀, Sum.inr x₀)}).Walk u v),
        (F.levi.deleteEdges {s(Sum.inl x₀, Sum.inr e₀)}).Reachable (lev u) (lev v) := by
      intro u v wlk
      induction wlk with
      | nil => exact _root_.SimpleGraph.Reachable.refl _
      | cons h _ ih => exact (hstep _ _ h).trans ih
    have hfinal := hmain _ _ p
    rw [hlevl, hlevr] at hfinal
    have hrepA₀ : (Erdos593.SimpleGraph.bridgeFree F.levi).Reachable
        (Sum.inr e₀) (Sum.inr (rep A₀)) := samecomp _ _ (he₀.trans (hrep A₀).symm)
    exact (_root_.SimpleGraph.isBridge_iff.mp hb)
      (hfinal.symm.trans (hrepA₀.mono hmono).symm)
  -- Rooted depth in an arbitrary forest, computed componentwise.
  have forest_unique_parent : ∀ (W : Type w) (G : _root_.SimpleGraph W), G.IsAcyclic →
      ∀ (root C D X : W), G.Adj C X → G.Adj D X →
      G.Reachable root C → G.Reachable root D →
      G.dist root C + 1 = G.dist root X → G.dist root D + 1 = G.dist root X →
      C = D := by
    intro W G hG root C D X hCX hDX hrootC hrootD hCdepth hDdepth
    obtain ⟨pC, hpC, hpCdist⟩ := hrootC.exists_path_of_dist
    obtain ⟨pD, hpD, hpDdist⟩ := hrootD.exists_path_of_dist
    have hXnotC : X ∉ pC.support := by
      intro hX
      have hdist := G.dist_le (pC.takeUntil X hX)
      have htake := pC.length_takeUntil_le_length hX
      omega
    have hXnotD : X ∉ pD.support := by
      intro hX
      have hdist := G.dist_le (pD.takeUntil X hX)
      have htake := pD.length_takeUntil_le_length hX
      omega
    have hpCX : (pC.concat hCX).IsPath := hpC.concat hXnotC hCX
    have hpDX : (pD.concat hDX).IsPath := hpD.concat hXnotD hDX
    have hpaths : pC.concat hCX = pD.concat hDX :=
      Subtype.mk.inj (hG.path_unique ⟨_, hpCX⟩ ⟨_, hpDX⟩)
    have hpenultimate := congrArg (fun p => p.penultimate) hpaths
    simpa using hpenultimate
  have acyclic_depth : ∀ (W : Type w) (G : _root_.SimpleGraph W), G.IsAcyclic →
      ∃ f : W → ℕ, (∀ u v, G.Adj u v → f u ≠ f v) ∧
        (∀ u v v', G.Adj u v → G.Adj u v' → f v < f u → f v' < f u → v = v') := by
    intro W G hG
    obtain ⟨rt, hrt⟩ : ∃ rt : G.ConnectedComponent → W,
        ∀ K, G.connectedComponentMk (rt K) = K :=
      ⟨fun K => Classical.choose K.nonempty_supp,
        fun K => Classical.choose_spec K.nonempty_supp⟩
    have hreach : ∀ u : W, G.Reachable (rt (G.connectedComponentMk u)) u := fun u =>
      _root_.SimpleGraph.ConnectedComponent.exact (hrt _)
    refine ⟨fun u => G.dist (rt (G.connectedComponentMk u)) u, ?_, ?_⟩
    · intro u v huv
      have hroot : G.connectedComponentMk u = G.connectedComponentMk v :=
        _root_.SimpleGraph.ConnectedComponent.connectedComponentMk_eq_of_adj huv
      show G.dist (rt (G.connectedComponentMk u)) u ≠
        G.dist (rt (G.connectedComponentMk v)) v
      rw [← hroot]
      rcases hG.dist_eq_dist_add_one_of_adj_of_reachable
        (rt (G.connectedComponentMk u)) huv (hreach u) with h | h <;> omega
    · intro u v v' huv huv' hlt hlt'
      have hrootv : G.connectedComponentMk u = G.connectedComponentMk v :=
        _root_.SimpleGraph.ConnectedComponent.connectedComponentMk_eq_of_adj huv
      have hrootv' : G.connectedComponentMk u = G.connectedComponentMk v' :=
        _root_.SimpleGraph.ConnectedComponent.connectedComponentMk_eq_of_adj huv'
      have hlt2 : G.dist (rt (G.connectedComponentMk u)) v <
          G.dist (rt (G.connectedComponentMk u)) u := by
        have h : G.dist (rt (G.connectedComponentMk v)) v <
          G.dist (rt (G.connectedComponentMk u)) u := hlt
        rwa [← hrootv] at h
      have hlt2' : G.dist (rt (G.connectedComponentMk u)) v' <
          G.dist (rt (G.connectedComponentMk u)) u := by
        have h : G.dist (rt (G.connectedComponentMk v')) v' <
          G.dist (rt (G.connectedComponentMk u)) u := hlt'
        rwa [← hrootv'] at h
      have hv := hG.dist_eq_dist_add_one_of_adj_of_reachable
        (rt (G.connectedComponentMk u)) huv (hreach u)
      have hv' := hG.dist_eq_dist_add_one_of_adj_of_reachable
        (rt (G.connectedComponentMk u)) huv' (hreach u)
      refine forest_unique_parent W G hG (rt (G.connectedComponentMk u)) v v' u
        huv.symm huv'.symm ((hreach u).trans huv.reachable)
        ((hreach u).trans huv'.reachable) ?_ ?_ <;> omega
  -- Representative-independent quotient cycle-block incidence forests supply a
  -- depth for every bridge-free block, including the disconnected ones.
  obtain ⟨dep, hdep1, hdep2⟩ : ∃ dep : ∀ C : BridgeBlock.Component F,
      (Erdos593.SimpleGraph.EdgeCycleBlock (BridgeBlock.contractedGraph F C) ⊕
        BridgeBlock.Point F C) → ℕ,
      (∀ (C : BridgeBlock.Component F) u v,
        (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
          (BridgeBlock.contractedGraph F C)).Adj u v → dep C u ≠ dep C v) ∧
      (∀ (C : BridgeBlock.Component F) u v v',
        (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
          (BridgeBlock.contractedGraph F C)).Adj u v →
        (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
          (BridgeBlock.contractedGraph F C)).Adj u v' →
        dep C v < dep C u → dep C v' < dep C u → v = v') := by
    choose dep h1 h2 using fun C : BridgeBlock.Component F =>
      acyclic_depth _
        (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
          (BridgeBlock.contractedGraph F C))
        (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph_isAcyclic _)
    exact ⟨dep, h1, h2⟩
  -- The induced rank on the canonical incidence graph.  A residual
  -- degree-zero singleton label is isolated in the surviving structure and
  -- gets the trivial rank.
  obtain ⟨rk, hrkatom, hrkpoint⟩ : ∃ rk : (CanonicalAtom.Index F ⊕ V) → ℕ,
      (∀ (C : BridgeBlock.HyperedgeComponent F) (hC : BridgeBlock.HasIncidence F C)
          (B : Erdos593.SimpleGraph.EdgeCycleBlock (BridgeBlock.contractedGraph F C)),
        rk (Sum.inl (Index.cycleBlock C hC B)) =
          dep (C : BridgeBlock.Component F) (Sum.inl B)) ∧
      (∀ (C : BridgeBlock.Component F) (x : V) (hx : Sum.inl x ∈ C.supp),
        rk (Sum.inr x) = dep C (Sum.inr ⟨x, hx⟩)) := by
    refine ⟨fun u => match u with
      | Sum.inl (Index.singleton _ _) => 0
      | Sum.inl (Index.cycleBlock C _ B) =>
          dep (C : BridgeBlock.Component F) (Sum.inl B)
      | Sum.inr x => dep ((Erdos593.SimpleGraph.bridgeFree F.levi).connectedComponentMk
          (Sum.inl x)) (Sum.inr ⟨x, rfl⟩), ?_, ?_⟩
    · intro C hC B
      rfl
    · intro C x hx
      have hmk : (Erdos593.SimpleGraph.bridgeFree F.levi).connectedComponentMk
          (Sum.inl x) = C :=
        (_root_.SimpleGraph.ConnectedComponent.mem_supp_iff C (Sum.inl x)).mp hx
      subst hmk
      rfl
  intro v c hc
  -- No alternating cycle can use a bridge incidence.
  have hcore : ∀ (A : CanonicalAtom.Index F) (y : V),
      s((Sum.inl A : CanonicalAtom.Index F ⊕ V), Sum.inr y) ∈ c.edges →
      ∃ e, CanonicalAtom.atomOf F hlinear hbridge e = A ∧
        (Erdos593.SimpleGraph.bridgeFree F.levi).Adj (Sum.inl y) (Sum.inr e) := by
    intro A y hmem
    have hcyc := _root_.SimpleGraph.adj_and_reachable_delete_edges_iff_exists_cycle.mpr
      ⟨v, c, hc, hmem⟩
    obtain ⟨e, he, hye⟩ :
        ∃ e, CanonicalAtom.atomOf F hlinear hbridge e = A ∧ F.Inc y e := by
      have hadj := hcyc.1
      simpa [CanonicalAtom.atomPointIncidenceGraph, CanonicalAtom.atomIncident,
        CanonicalAtom.atomSupport, TripleSystem.edgeSupportSet,
        CanonicalAtom.edges] using hadj
    refine ⟨e, he, ?_⟩
    by_contra hnadj
    have hbr : F.levi.IsBridge s(Sum.inl y, Sum.inr e) := by
      by_contra hnb
      exact hnadj (adj_of_not_bridge y e hye hnb)
    subst he
    exact bridge_edge_not_reachable _ y e rfl hye hbr hcyc.2
  -- A rank-maximal vertex of the cycle has two distinct smaller neighbours.
  obtain ⟨m, hmmem, hmmax⟩ :=
    Finset.exists_max_image c.support.toFinset rk ⟨v, by simp⟩
  have hm : m ∈ c.support := List.mem_toFinset.mp hmmem
  have hc' : (c.rotate m hm).IsCycle := hc.rotate hm
  have hedges : (c.rotate m hm).edges ~r c.edges := c.rotate_edges m hm
  have hnotnil : ¬ (c.rotate m hm).Nil := hc'.not_nil
  have hnotnilr : ¬ (c.rotate m hm).reverse.Nil := hc'.reverse.not_nil
  have hey : s(m, (c.rotate m hm).snd) ∈ c.edges :=
    hedges.mem_iff.mp (_root_.SimpleGraph.Walk.mk_start_snd_mem_edges hnotnil)
  have hez : s(m, (c.rotate m hm).penultimate) ∈ c.edges := by
    have h := _root_.SimpleGraph.Walk.mk_start_snd_mem_edges hnotnilr
    rw [_root_.SimpleGraph.Walk.snd_reverse,
      _root_.SimpleGraph.Walk.edges_reverse, List.mem_reverse] at h
    exact hedges.mem_iff.mp h
  have hyz : (c.rotate m hm).snd ≠ (c.rotate m hm).penultimate := hc'.snd_ne_penultimate
  have hadjy : (CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).Adj
      m (c.rotate m hm).snd := _root_.SimpleGraph.Walk.adj_snd hnotnil
  have hadjz : (CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge).Adj
      m (c.rotate m hm).penultimate :=
    (_root_.SimpleGraph.Walk.adj_penultimate hnotnil).symm
  have hley : rk (c.rotate m hm).snd ≤ rk m :=
    hmmax _ (List.mem_toFinset.mpr (c.snd_mem_support_of_mem_edges hey))
  have hlez : rk (c.rotate m hm).penultimate ≤ rk m :=
    hmmax _ (List.mem_toFinset.mpr (c.snd_mem_support_of_mem_edges hez))
  revert hey hez hadjy hadjz hley hlez hyz
  generalize (c.rotate m hm).snd = y
  generalize (c.rotate m hm).penultimate = z
  intro hey hez hyz hadjy hadjz hley hlez
  rcases incidence_adj_cases m y hadjy with
    ⟨A, x1, hm1, hy1, _⟩ | ⟨A1, x, hm1, hy1, _⟩
  · subst hm1
    subst hy1
    rcases incidence_adj_cases (Sum.inl A) z hadjz with
      ⟨A', x2, hm2, hz2, _⟩ | ⟨A2, x', hm2, _, _⟩
    · have hAA' : A' = A := (Sum.inl.inj hm2).symm
      subst hAA'
      subst hz2
      obtain ⟨e1, he1, hadj1⟩ := hcore A' x1 hey
      obtain ⟨e2, he2, hadj2⟩ := hcore A' x2 hez
      cases A' with
      | singleton e hzero => exact singleton_no_core e e1 x1 hzero he1 hadj1
      | cycleBlock C hC B =>
          obtain ⟨hx1, hinc1⟩ := core_atom_data C hC B x1 e1 he1 hadj1
          obtain ⟨hx2, hinc2⟩ := core_atom_data C hC B x2 e2 he2 hadj2
          have hJ1 : (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
              (BridgeBlock.contractedGraph F (C : BridgeBlock.Component F))).Adj
              (Sum.inl B) (Sum.inr ⟨x1, hx1⟩) :=
            (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph_adj_inl_inr_iff
              _ B ⟨x1, hx1⟩).mpr hinc1
          have hJ2 : (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
              (BridgeBlock.contractedGraph F (C : BridgeBlock.Component F))).Adj
              (Sum.inl B) (Sum.inr ⟨x2, hx2⟩) :=
            (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph_adj_inl_inr_iff
              _ B ⟨x2, hx2⟩).mpr hinc2
          rw [hrkpoint (C : BridgeBlock.Component F) x1 hx1, hrkatom C hC B] at hley
          rw [hrkpoint (C : BridgeBlock.Component F) x2 hx2, hrkatom C hC B] at hlez
          have hlt1 : dep (C : BridgeBlock.Component F) (Sum.inr ⟨x1, hx1⟩) <
              dep (C : BridgeBlock.Component F) (Sum.inl B) :=
            lt_of_le_of_ne hley (hdep1 _ _ _ hJ1.symm)
          have hlt2 : dep (C : BridgeBlock.Component F) (Sum.inr ⟨x2, hx2⟩) <
              dep (C : BridgeBlock.Component F) (Sum.inl B) :=
            lt_of_le_of_ne hlez (hdep1 _ _ _ hJ2.symm)
          have hxx : (Sum.inr ⟨x1, hx1⟩ :
              Erdos593.SimpleGraph.EdgeCycleBlock
                (BridgeBlock.contractedGraph F (C : BridgeBlock.Component F)) ⊕
              BridgeBlock.Point F (C : BridgeBlock.Component F)) = Sum.inr ⟨x2, hx2⟩ :=
            hdep2 _ _ _ _ hJ1 hJ2 hlt1 hlt2
          apply hyz
          have hx12 : x1 = x2 := congrArg Subtype.val (Sum.inr.inj hxx)
          rw [hx12]
    · exact absurd hm2 (by simp)
  · subst hm1
    subst hy1
    rcases incidence_adj_cases (Sum.inr x) z hadjz with
      ⟨A', x2, hm2, _, _⟩ | ⟨A2, x'', hm2, hz2, _⟩
    · exact absurd hm2.symm (by simp)
    · have hxx' : x'' = x := (Sum.inr.inj hm2).symm
      subst hxx'
      subst hz2
      obtain ⟨e1, he1, hadj1⟩ := hcore A1 x'' (by rwa [Sym2.eq_swap] at hey)
      obtain ⟨e2, he2, hadj2⟩ := hcore A2 x'' (by rwa [Sym2.eq_swap] at hez)
      cases A1 with
      | singleton e hzero => exact singleton_no_core e e1 x'' hzero he1 hadj1
      | cycleBlock C1 hC1 B1 =>
        cases A2 with
        | singleton e hzero => exact singleton_no_core e e2 x'' hzero he2 hadj2
        | cycleBlock C2 hC2 B2 =>
            obtain ⟨hx1, hinc1⟩ := core_atom_data C1 hC1 B1 x'' e1 he1 hadj1
            obtain ⟨hx2, hinc2⟩ := core_atom_data C2 hC2 B2 x'' e2 he2 hadj2
            have hCC : C1 = C2 := by
              apply Subtype.ext
              have h1 := (_root_.SimpleGraph.ConnectedComponent.mem_supp_iff
                (C1 : BridgeBlock.Component F) (Sum.inl x'')).mp hx1
              have h2 := (_root_.SimpleGraph.ConnectedComponent.mem_supp_iff
                (C2 : BridgeBlock.Component F) (Sum.inl x'')).mp hx2
              exact h1.symm.trans h2
            subst hCC
            have hJ1 : (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
                (BridgeBlock.contractedGraph F (C1 : BridgeBlock.Component F))).Adj
                (Sum.inr ⟨x'', hx1⟩) (Sum.inl B1) :=
              ((Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph_adj_inl_inr_iff
                _ B1 ⟨x'', hx1⟩).mpr hinc1).symm
            have hJ2 : (Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph
                (BridgeBlock.contractedGraph F (C1 : BridgeBlock.Component F))).Adj
                (Sum.inr ⟨x'', hx1⟩) (Sum.inl B2) :=
              ((Erdos593.SimpleGraph.EdgeCycleBlock.incidenceGraph_adj_inl_inr_iff
                _ B2 ⟨x'', hx2⟩).mpr hinc2).symm
            rw [hrkpoint (C1 : BridgeBlock.Component F) x'' hx1,
              hrkatom C1 hC1 B1] at hley
            rw [hrkpoint (C1 : BridgeBlock.Component F) x'' hx1,
              hrkatom C1 hC2 B2] at hlez
            have hlt1 : dep (C1 : BridgeBlock.Component F) (Sum.inl B1) <
                dep (C1 : BridgeBlock.Component F) (Sum.inr ⟨x'', hx1⟩) :=
              lt_of_le_of_ne hley (hdep1 _ _ _ hJ1.symm)
            have hlt2 : dep (C1 : BridgeBlock.Component F) (Sum.inl B2) <
                dep (C1 : BridgeBlock.Component F) (Sum.inr ⟨x'', hx1⟩) :=
              lt_of_le_of_ne hlez (hdep1 _ _ _ hJ2.symm)
            have hBB : (Sum.inl B1 :
                Erdos593.SimpleGraph.EdgeCycleBlock
                  (BridgeBlock.contractedGraph F (C1 : BridgeBlock.Component F)) ⊕
                BridgeBlock.Point F (C1 : BridgeBlock.Component F)) = Sum.inl B2 :=
              hdep2 _ _ _ _ hJ1 hJ2 hlt1 hlt2
            apply hyz
            have hB12 : B1 = B2 := Sum.inl.inj hBB
            rw [hB12]

/-- The exactly pruned atom--shared-point graph from the manuscript is a
forest as an induced subgraph of the full incidence forest. -/
theorem atomSharedPointIncidenceGraph_isAcyclic
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    (CanonicalAtom.atomSharedPointIncidenceGraph F hlinear hbridge).IsAcyclic := by
  classical
  exact (CanonicalAtom.atomPointIncidenceGraph_isAcyclic
    F hlinear hbridge).induce _

/-- The exact atom edge sets associated with a newest-first label list. -/
def atomEdgeSets
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (atoms : List (CanonicalAtom.Index F)) : List (Set E) :=
  atoms.map (CanonicalAtom.edges F hlinear hbridge)

/-- Membership in the exact union of listed atom fibres is membership of the
edge's canonical label in the list. -/
@[simp]
theorem mem_edgePieceUnion_atomEdgeSets
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (atoms : List (CanonicalAtom.Index F)) (e : E) :
    e ∈ edgePieceUnion
        (CanonicalAtom.atomEdgeSets F hlinear hbridge atoms) ↔
      CanonicalAtom.atomOf F hlinear hbridge e ∈ atoms := by
  induction atoms with
  | nil =>
      simp [CanonicalAtom.atomEdgeSets, edgePieceUnion]
  | cons A atoms ih =>
      have ih' : e ∈ edgePieceUnion
            (atoms.map (CanonicalAtom.edges F hlinear hbridge)) ↔
          CanonicalAtom.atomOf F hlinear hbridge e ∈ atoms := by
        simpa only [CanonicalAtom.atomEdgeSets] using ih
      simp only [CanonicalAtom.atomEdgeSets, List.map_cons, edgePieceUnion,
        Set.mem_union, List.mem_cons, ih']
      change (CanonicalAtom.atomOf F hlinear hbridge e ∈ atoms ∨
          CanonicalAtom.atomOf F hlinear hbridge e = A) ↔ _
      exact or_comm

/-- Any list containing every represented atom label has total edge union
exactly `Set.univ`. -/
theorem edgePieceUnion_atomEdgeSets_eq_univ
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (atoms : List (CanonicalAtom.Index F))
    (hlabels : atoms.toFinset =
      CanonicalAtom.atomFinset F hlinear hbridge) :
    edgePieceUnion (CanonicalAtom.atomEdgeSets F hlinear hbridge atoms) =
      Set.univ := by
  ext e
  constructor
  · intro _
    exact Set.mem_univ e
  · intro _
    rw [CanonicalAtom.mem_edgePieceUnion_atomEdgeSets]
    have hmem : CanonicalAtom.atomOf F hlinear hbridge e ∈
        CanonicalAtom.atomFinset F hlinear hbridge :=
      CanonicalAtom.mem_atomFinset F hlinear hbridge _
    rw [← hlabels] at hmem
    exact List.mem_toFinset.mp hmem

/-- Each exact canonical atom restriction belongs to the constructive class
under the intrinsic hypotheses. -/
theorem atomRestriction_constructible
    (hintrinsic : F.Intrinsic) (A : CanonicalAtom.Index F) :
    Constructible
      (CanonicalAtom.atomRestriction F hintrinsic.1 hintrinsic.2.1 A) := by
  rcases hintrinsic with ⟨hlinear, hbridge, hberge⟩
  cases A with
  | singleton e hzero =>
      let S : TripleSystem (F.edgeSet e) SingleEdgeIndex.{w} :=
        F.singleEdgePiece.{w, w, w} e
      have hsingle : Constructible S := by
        dsimp [S]
        exact singleEdgePiece_constructible F e
      have htype : TripleSystem.Isomorphic
          (CanonicalAtom.atomRestriction F hlinear hbridge
            (CanonicalAtom.Index.singleton e hzero))
          S := by
        dsimp [S]
        exact CanonicalAtom.atomRestriction_is_singleEdge_or_cycleBlockExpansion.{w, w, w}
          (V := V) (E := E) F hlinear hbridge
          (CanonicalAtom.Index.singleton e hzero)
      rcases htype with ⟨hiso⟩
      exact Constructible.ofIso hsingle hiso.symm
  | cycleBlock C hC B =>
      rcases CanonicalAtom.atomRestriction_is_singleEdge_or_cycleBlockExpansion.{w, w, w}
        (V := V) (E := E) F hlinear hbridge
          (CanonicalAtom.Index.cycleBlock C hC B) with ⟨hiso⟩
      have hcore : Constructible
          (privateVertexExpansion (CanonicalAtom.cycleBlockCore F C B)) :=
        Constructible.ofExpansion (CanonicalAtom.cycleBlockCore F C B)
          (CanonicalAtom.cycleBlockCore_isBipartite
            F hlinear hbridge hberge C hC B)
      exact Constructible.ofIso hcore hiso.symm

/-- Complete auditable data for the canonical newest-first atom assembly.
The tail-point condition records the dynamic leaf order; `running` retains
the literal edge restrictions and one-point/disjoint-union geometry; `total`
records exact hyperedge coverage. -/
structure AtomRunningAssembly
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) where
  atoms : List (CanonicalAtom.Index F)
  nodup : atoms.Nodup
  labels : atoms.toFinset = CanonicalAtom.atomFinset F hlinear hbridge
  tailPointSubsingleton :
    SimpleGraph.bipartiteTailPointSubsingleton
      (CanonicalAtom.atomIncident F hlinear hbridge) atoms
  running : F.RunningEdgeAssembly
    (CanonicalAtom.atomEdgeSets F hlinear hbridge atoms)
  total : edgePieceUnion
    (CanonicalAtom.atomEdgeSets F hlinear hbridge atoms) = Set.univ

/-- The canonical incidence forest supplies a finite newest-first running
assembly of every exact atom fibre. -/
theorem exists_atomRunningAssembly
    (hintrinsic : F.Intrinsic) :
    Nonempty (CanonicalAtom.AtomRunningAssembly
      F hintrinsic.1 hintrinsic.2.1) := by
  classical
  have hlinear : F.Linear := hintrinsic.1
  have hbridge : F.BridgeAtEveryEdge := hintrinsic.2.1
  -- The canonical incidence forest gives a dynamic newest-first leaf order.
  have hacyclic : (_root_.SimpleGraph.bipartiteIncidenceGraph
      (CanonicalAtom.atomIncident F hlinear hbridge)).IsAcyclic :=
    CanonicalAtom.atomPointIncidenceGraph_isAcyclic F hlinear hbridge
  obtain ⟨l, hnd, hlt, hcoh⟩ :=
    _root_.SimpleGraph.IsAcyclic.exists_finset_bipartiteTailPointSubsingletonOrder
      (CanonicalAtom.atomIncident F hlinear hbridge) hacyclic
      (CanonicalAtom.atomFinset F hlinear hbridge)
  -- Every initial segment of such an order is a running edge assembly.
  have hrun : ∀ m : List (CanonicalAtom.Index F), m.Nodup →
      _root_.SimpleGraph.bipartiteTailPointSubsingleton
        (CanonicalAtom.atomIncident F hlinear hbridge) m →
      F.RunningEdgeAssembly (CanonicalAtom.atomEdgeSets F hlinear hbridge m) := by
    intro m
    induction m with
    | nil =>
        intro _ _
        trivial
    | cons A m ih =>
        intro hndm hcohm
        have hcohm' : _root_.SimpleGraph.bipartiteTailPointSubsingleton
              (CanonicalAtom.atomIncident F hlinear hbridge) m ∧
            ∀ p p', CanonicalAtom.atomIncident F hlinear hbridge A p →
              CanonicalAtom.atomIncident F hlinear hbridge A p' →
              (∃ b ∈ m, CanonicalAtom.atomIncident F hlinear hbridge b p) →
              (∃ c ∈ m, CanonicalAtom.atomIncident F hlinear hbridge c p') → p = p' :=
          hcohm
        have hAm : A ∉ m := (List.nodup_cons.mp hndm).1
        refine ⟨ih (List.nodup_cons.mp hndm).2 hcohm'.1, ?_, ?_, ?_⟩
        · exact CanonicalAtom.atomRestriction_constructible F hintrinsic A
        · rw [Set.disjoint_left]
          intro e he heA
          apply hAm
          have h1 : CanonicalAtom.atomOf F hlinear hbridge e ∈ m :=
            (CanonicalAtom.mem_edgePieceUnion_atomEdgeSets F hlinear hbridge m e).mp he
          change CanonicalAtom.atomOf F hlinear hbridge e = A at heA
          rwa [heA] at h1
        · have hsub : (F.edgeSupportSet
                (edgePieceUnion (CanonicalAtom.atomEdgeSets F hlinear hbridge m)) ∩
              F.edgeSupportSet
                (CanonicalAtom.edges F hlinear hbridge A)).Subsingleton := by
            intro x hx y hy
            obtain ⟨e1, he1, hxe1⟩ := hx.1
            obtain ⟨e2, he2, hye2⟩ := hy.1
            refine hcohm'.2 x y hx.2 hy.2 ?_ ?_
            · exact ⟨CanonicalAtom.atomOf F hlinear hbridge e1,
                (CanonicalAtom.mem_edgePieceUnion_atomEdgeSets
                  F hlinear hbridge m e1).mp he1, e1, rfl, hxe1⟩
            · exact ⟨CanonicalAtom.atomOf F hlinear hbridge e2,
                (CanonicalAtom.mem_edgePieceUnion_atomEdgeSets
                  F hlinear hbridge m e2).mp he2, e2, rfl, hye2⟩
          rcases hsub.eq_empty_or_singleton with hemp | ⟨r, hr⟩
          · exact Or.inl (Set.disjoint_iff_inter_eq_empty.mpr hemp)
          · exact Or.inr ⟨r, hr⟩
  exact ⟨{ atoms := l
           nodup := hnd
           labels := hlt
           tailPointSubsingleton := hcoh
           running := hrun l hnd hcoh
           total := CanonicalAtom.edgePieceUnion_atomEdgeSets_eq_univ
             F hlinear hbridge l hlt }⟩

/-- The exact total restriction associated with an atom running assembly is
isomorphic to the original system once isolated points are excluded. -/
theorem AtomRunningAssembly.reconstructs
    {hlinear : F.Linear} {hbridge : F.BridgeAtEveryEdge}
    (assembly : CanonicalAtom.AtomRunningAssembly F hlinear hbridge)
    (hnoisolated : F.HasNoIsolatedPoints) :
    TripleSystem.Isomorphic
      (F.edgeRestriction
        (edgePieceUnion
          (CanonicalAtom.atomEdgeSets F hlinear hbridge assembly.atoms))) F := by
  rw [assembly.total]
  exact ⟨F.edgeRestrictionUnivIso hnoisolated⟩

/-- Manuscript-facing exact reconstruction from the canonical atom forest. -/
theorem canonicalAtom_reconstruction
    (hintrinsic : F.Intrinsic) (hnoisolated : F.HasNoIsolatedPoints) :
    ∃ assembly : CanonicalAtom.AtomRunningAssembly
        F hintrinsic.1 hintrinsic.2.1,
      TripleSystem.Isomorphic
        (F.edgeRestriction
          (edgePieceUnion
            (CanonicalAtom.atomEdgeSets F hintrinsic.1 hintrinsic.2.1
              assembly.atoms))) F := by
  rcases CanonicalAtom.exists_atomRunningAssembly F hintrinsic with ⟨assembly⟩
  exact ⟨assembly, assembly.reconstructs F hnoisolated⟩

end
end CanonicalAtom
end TripleSystem
end Erdos593
