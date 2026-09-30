import Erdos593.TripleSystem.CanonicalAtomForestReconstruction
import Erdos593.TripleSystem.IsomorphIntrinsic

/-!
# Canonicity of the canonical atom data

This module makes the manuscript phrase "determined by the triple system"
precise as equivariance under simultaneous vertex-and-edge relabelling.  It
retains the literal canonical fibres from `CanonicalAtomPartition`, the full
and shared-point incidence graphs from `CanonicalAtomForestReconstruction`,
and graph isomorphism rather than equality for the selected nontrivial cores.

It does not assert uniqueness among arbitrary forest presentations lacking a
maximal-cycle-block condition.
-/

namespace Erdos593

universe w

namespace TripleSystem
namespace CanonicalAtom

noncomputable section

variable {V E V' E' : Type w}
variable (F : TripleSystem V E) (F' : TripleSystem V' E')

/-- The transported linearity proof used by the target canonical atom data. -/
theorem transportedLinear (f : TripleSystem.Iso F F') (hlinear : F.Linear) :
    F'.Linear :=
  (TripleSystem.Iso.linear_iff f).mp hlinear

/-- The transported bridge-at-every-edge proof used by the target canonical
atom data. -/
theorem transportedBridgeAtEveryEdge
    (f : TripleSystem.Iso F F') (hbridge : F.BridgeAtEveryEdge) :
    F'.BridgeAtEveryEdge :=
  (TripleSystem.Iso.bridgeAtEveryEdge_iff f).mp hbridge

variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
  [DecidableRel F.levi.Adj]
variable [Fintype V'] [Fintype E'] [DecidableEq V'] [DecidableEq E']
  [DecidableRel F'.levi.Adj]

noncomputable local instance canonicalAtomIndexDecidableEq :
    DecidableEq (CanonicalAtom.Index F) :=
  Classical.decEq _

noncomputable local instance canonicalAtomIncidentDecidableRel
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    DecidableRel (CanonicalAtom.atomIncident F hlinear hbridge) :=
  fun A x => Classical.propDecidable
    (CanonicalAtom.atomIncident F hlinear hbridge A x)

/-- The canonical vertex of the pruned incidence forest represented by an
atom label. -/
noncomputable def sharedAtomVertex
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : CanonicalAtom.Index F) :
    ↑(SimpleGraph.bipartitePruneVertices
      (CanonicalAtom.atomIncident F hlinear hbridge)
      (CanonicalAtom.atomFinset F hlinear hbridge)) := by
  classical
  exact ⟨Sum.inl A,
    (SimpleGraph.mem_bipartitePruneVertices_inl _ _ _).mpr
      (CanonicalAtom.mem_atomFinset F hlinear hbridge A)⟩

/-- The canonical vertex of the pruned incidence forest represented by a
shared original point. -/
noncomputable def sharedPointVertex
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (x : V) (hx : x ∈ CanonicalAtom.sharedAtomPoints F hlinear hbridge) :
    ↑(SimpleGraph.bipartitePruneVertices
      (CanonicalAtom.atomIncident F hlinear hbridge)
      (CanonicalAtom.atomFinset F hlinear hbridge)) := by
  classical
  exact ⟨Sum.inr x,
    (SimpleGraph.mem_bipartitePruneVertices_inr _ _ _).mpr hx⟩

/-- Complete equivariance data for the canonical atom construction under one
triple-system isomorphism.  The graph-isomorphism coherence fields ensure that
the incidence forests use the transported atoms and points, rather than an
unrelated abstract graph isomorphism. -/
structure CanonicityTransport
    (f : TripleSystem.Iso F F')
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) where
  /-- Bijection of the literal canonical atom labels. -/
  atomEquiv : CanonicalAtom.Index F ≃ CanonicalAtom.Index F'
  /-- The label of every transported hyperedge is the transported label. -/
  atomOf_map : ∀ e : E,
    atomEquiv (CanonicalAtom.atomOf F hlinear hbridge e) =
      CanonicalAtom.atomOf F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
        (f.edgeEquiv e)
  /-- Exact canonical edge fibres are preserved and reflected. -/
  edges_map_iff : ∀ (A : CanonicalAtom.Index F) (e : E),
    e ∈ CanonicalAtom.edges F hlinear hbridge A ↔
      f.edgeEquiv e ∈ CanonicalAtom.edges F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
        (atomEquiv A)
  /-- Exact atom supports are preserved and reflected by the vertex map. -/
  support_map_iff : ∀ (A : CanonicalAtom.Index F) (x : V),
    x ∈ CanonicalAtom.atomSupport F hlinear hbridge A ↔
      f.vertexEquiv x ∈ CanonicalAtom.atomSupport F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
        (atomEquiv A)
  /-- The atom--point incidence predicate itself is preserved and reflected. -/
  atomIncident_map_iff : ∀ (A : CanonicalAtom.Index F) (x : V),
    CanonicalAtom.atomIncident F hlinear hbridge A x ↔
      CanonicalAtom.atomIncident F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
        (atomEquiv A) (f.vertexEquiv x)
  /-- Full atom--point incidence graphs are canonically isomorphic. -/
  atomPointGraphIso :
    CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge ≃g
      CanonicalAtom.atomPointIncidenceGraph F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
  /-- The full graph isomorphism is the sum of the atom and point maps. -/
  atomPointGraphIso_apply : ∀ z : CanonicalAtom.Index F ⊕ V,
    atomPointGraphIso z = Equiv.sumCongr atomEquiv f.vertexEquiv z
  /-- Shared-point membership is preserved and reflected, including points
  incident with three or more atoms. -/
  sharedPoint_map_iff : ∀ x : V,
    x ∈ CanonicalAtom.sharedAtomPoints F hlinear hbridge ↔
      f.vertexEquiv x ∈ CanonicalAtom.sharedAtomPoints F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
  /-- The exact shared-point-pruned manuscript incidence forests are
  isomorphic. -/
  sharedPointGraphIso :
    CanonicalAtom.atomSharedPointIncidenceGraph F hlinear hbridge ≃g
      CanonicalAtom.atomSharedPointIncidenceGraph F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
  /-- On atom vertices, the pruned-forest isomorphism is the canonical atom
  transport. -/
  sharedPointGraphIso_atom : ∀ A : CanonicalAtom.Index F,
    sharedPointGraphIso (sharedAtomVertex F hlinear hbridge A) =
      sharedAtomVertex F'
        (transportedLinear F F' f hlinear)
        (transportedBridgeAtEveryEdge F F' f hbridge)
        (atomEquiv A)
  /-- On retained point vertices, the pruned-forest isomorphism is the original
  vertex transport, with only the subtype membership proof changing. -/
  sharedPointGraphIso_point :
    ∀ (x : V) (hx : x ∈ CanonicalAtom.sharedAtomPoints F hlinear hbridge),
      sharedPointGraphIso (sharedPointVertex F hlinear hbridge x hx) =
        sharedPointVertex F'
          (transportedLinear F F' f hlinear)
          (transportedBridgeAtEveryEdge F F' f hbridge)
          (f.vertexEquiv x) ((sharedPoint_map_iff x).mp hx)
  /-- Every source cycle-block atom transports to a cycle-block atom whose
  selected suppressed core is isomorphic as a finite simple graph. -/
  cycleBlockCore_transport :
    ∀ (C : BridgeBlock.HyperedgeComponent F)
      (hC : BridgeBlock.HasIncidence F C)
      (B : Erdos593.SimpleGraph.EdgeCycleBlock
        (BridgeBlock.contractedGraph F C)),
      ∃ (C' : BridgeBlock.HyperedgeComponent F')
        (hC' : BridgeBlock.HasIncidence F' C')
        (B' : Erdos593.SimpleGraph.EdgeCycleBlock
          (BridgeBlock.contractedGraph F' C')),
        atomEquiv (.cycleBlock C hC B) = .cycleBlock C' hC' B' ∧
          Nonempty
            (CanonicalAtom.cycleBlockCore F C B ≃g
              CanonicalAtom.cycleBlockCore F' C' B')

/-- Manuscript-facing canonicity theorem: every incidence-preserving
relabeling transports the literal atom partition, its incidence forests, and
its nontrivial cores up to graph isomorphism. -/
theorem exists_canonicityTransport
    (f : TripleSystem.Iso F F')
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    Nonempty (CanonicalAtom.CanonicityTransport F F' f hlinear hbridge) := by
  classical
  -- Transported hypotheses.
  have hlin' : F'.Linear := transportedLinear F F' f hlinear
  have hbri' : F'.BridgeAtEveryEdge := transportedBridgeAtEveryEdge F F' f hbridge
  -- ## Generic graph-isomorphism transport
  -- Edge sets.
  let esE : ∀ {A B : Type w} {P : _root_.SimpleGraph A} {Q : _root_.SimpleGraph B},
      (P ≃g Q) → (P.edgeSet ≃ Q.edgeSet) := fun {_ _ _ _} g =>
    { toFun := _root_.SimpleGraph.Hom.mapEdgeSet g.toHom
      invFun := _root_.SimpleGraph.Hom.mapEdgeSet g.symm.toHom
      left_inv := by
        intro a
        apply Subtype.ext
        simp [_root_.SimpleGraph.Hom.mapEdgeSet, Sym2.map_map]
      right_inv := by
        intro a
        apply Subtype.ext
        simp [_root_.SimpleGraph.Hom.mapEdgeSet, Sym2.map_map] }
  have hesE_val : ∀ {A B : Type w} {P : _root_.SimpleGraph A} {Q : _root_.SimpleGraph B}
      (g : P ≃g Q) (a : P.edgeSet), ((esE g) a : Sym2 B) = Sym2.map g a.1 :=
    fun _ _ => rfl
  have hesE_symm : ∀ {A B : Type w} {P : _root_.SimpleGraph A} {Q : _root_.SimpleGraph B}
      (g : P ≃g Q) (a : P.edgeSet), esE g.symm (esE g a) = a := by
    intro A B P Q g a
    apply Subtype.ext
    rw [hesE_val, hesE_val, Sym2.map_map]
    simp
  have hesE_symm' : ∀ {A B : Type w} {P : _root_.SimpleGraph A} {Q : _root_.SimpleGraph B}
      (g : P ≃g Q) (b : Q.edgeSet), esE g (esE g.symm b) = b := by
    intro A B P Q g b
    apply Subtype.ext
    rw [hesE_val, hesE_val, Sym2.map_map]
    simp
  -- Cycle-block equivalence classes.
  have hlinkmap : ∀ {A B : Type w} {P : _root_.SimpleGraph A} {Q : _root_.SimpleGraph B}
      (g : P ≃g Q) (a b : P.edgeSet),
      Erdos593.SimpleGraph.EdgeCycleLinked P a b →
        Erdos593.SimpleGraph.EdgeCycleLinked Q (esE g a) (esE g b) := by
    intro A B P Q g a b h
    rcases h with rfl | ⟨v, c, hc, hea, heb⟩
    · exact Or.inl rfl
    · refine Or.inr ⟨g v, c.map g.toHom, hc.map g.injective, ?_, ?_⟩
      · rw [_root_.SimpleGraph.Walk.edges_map]
        exact List.mem_map_of_mem hea
      · rw [_root_.SimpleGraph.Walk.edges_map]
        exact List.mem_map_of_mem heb
  let bmap : ∀ {A B : Type w} {P : _root_.SimpleGraph A} {Q : _root_.SimpleGraph B},
      (P ≃g Q) → (Erdos593.SimpleGraph.EdgeCycleBlock P ≃
        Erdos593.SimpleGraph.EdgeCycleBlock Q) := fun {_ _ _ _} g =>
    Quotient.congr (esE g) (by
      intro a b
      constructor
      · exact hlinkmap g a b
      · intro h
        have h2 := hlinkmap g.symm _ _ h
        rwa [hesE_symm g a, hesE_symm g b] at h2)
  have hbmap_ofEdge : ∀ {A B : Type w} {P : _root_.SimpleGraph A}
      {Q : _root_.SimpleGraph B} (g : P ≃g Q) (a : P.edgeSet),
      bmap g (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge P a) =
        Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge Q (esE g a) := fun _ _ => rfl
  have hblkedges : ∀ {A B : Type w} {P : _root_.SimpleGraph A}
      {Q : _root_.SimpleGraph B} (g : P ≃g Q)
      (Bl : Erdos593.SimpleGraph.EdgeCycleBlock P) (a : P.edgeSet),
      a ∈ Erdos593.SimpleGraph.EdgeCycleBlock.edges P Bl ↔
        esE g a ∈ Erdos593.SimpleGraph.EdgeCycleBlock.edges Q (bmap g Bl) := by
    intro A B P Q g Bl a
    show Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge P a = Bl ↔
      Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge Q (esE g a) = bmap g Bl
    rw [← hbmap_ofEdge]
    exact (Equiv.apply_eq_iff_eq _).symm
  -- Finite endpoint factor graphs.
  have hendmem : ∀ {A : Type w} (P : _root_.SimpleGraph A) (S : Set P.edgeSet)
      (hS : S.Finite) (v : A),
      v ∈ finiteEdgeEndpointFinset P S hS ↔ ∃ e ∈ S, v ∈ (e.1 : Sym2 A) := by
    intro A P S hS v
    classical
    simp [finiteEdgeEndpointFinset, Finset.mem_biUnion, Set.Finite.mem_toFinset,
      Sym2.mem_toFinset]
  have hendmap : ∀ {A B : Type w} {P : _root_.SimpleGraph A}
      {Q : _root_.SimpleGraph B} (g : P ≃g Q) (S : Set P.edgeSet) (hS : S.Finite)
      (T : Set Q.edgeSet) (hT : T.Finite)
      (hST : ∀ a : P.edgeSet, a ∈ S ↔ esE g a ∈ T) (v : A),
      v ∈ finiteEdgeEndpointFinset P S hS ↔
        g v ∈ finiteEdgeEndpointFinset Q T hT := by
    intro A B P Q g S hS T hT hST v
    rw [hendmem, hendmem]
    constructor
    · rintro ⟨e, heS, hve⟩
      refine ⟨esE g e, (hST e).mp heS, ?_⟩
      rw [hesE_val]
      exact Sym2.mem_map.mpr ⟨v, hve, rfl⟩
    · rintro ⟨e', he'T, hve'⟩
      refine ⟨esE g.symm e', ?_, ?_⟩
      · rw [hST, hesE_symm' g e']
        exact he'T
      · rw [hesE_val]
        refine Sym2.mem_map.mpr ⟨g v, hve', ?_⟩
        simp
  let ffi : ∀ {A B : Type w} {P : _root_.SimpleGraph A} {Q : _root_.SimpleGraph B}
      (g : P ≃g Q) (S : Set P.edgeSet) (hS : S.Finite) (T : Set Q.edgeSet)
      (hT : T.Finite) (_ : ∀ a : P.edgeSet, a ∈ S ↔ esE g a ∈ T),
      finiteEdgeFactorGraph P S hS ≃g finiteEdgeFactorGraph Q T hT :=
    fun {_ _ P Q} g S hS T hT hST =>
    { toEquiv :=
        { toFun := fun v => ⟨g v.1, (hendmap g S hS T hT hST v.1).mp v.2⟩
          invFun := fun v => ⟨g.symm v.1, by
            rw [hendmap g S hS T hT hST, RelIso.apply_symm_apply]
            exact v.2⟩
          left_inv := by intro v; apply Subtype.ext; simp
          right_inv := by intro v; apply Subtype.ext; simp }
      map_rel_iff' := by
        intro x y
        show (finiteEdgeFactorGraph Q T hT).Adj ⟨g x.1, _⟩ ⟨g y.1, _⟩ ↔
          (finiteEdgeFactorGraph P S hS).Adj x y
        simp only [finiteEdgeFactorGraph, _root_.SimpleGraph.fromEdgeSet_adj,
          Set.mem_setOf_eq, Sym2.map_mk, ne_eq, Subtype.ext_iff]
        constructor
        · rintro ⟨⟨e', he'T, he'⟩, hne⟩
          refine ⟨⟨esE g.symm e', ?_, ?_⟩, ?_⟩
          · rw [hST, hesE_symm' g e']
            exact he'T
          · rw [hesE_val, he', Sym2.map_mk]
            simp
          · intro h
            exact hne (congrArg g h)
        · rintro ⟨⟨e, heS, he⟩, hne⟩
          refine ⟨⟨esE g e, (hST e).mp heS, ?_⟩, ?_⟩
          · rw [hesE_val, he]
            simp
          · intro h
            exact hne (g.injective h) }
  -- ## Transport of the bridge-free Levi graph
  have hIsBridge : ∀ (a b : V ⊕ E),
      F.levi.IsBridge s(a, b) ↔
        F'.levi.IsBridge s(TripleSystem.Iso.leviIso f a, TripleSystem.Iso.leviIso f b) := by
    intro a b
    let g := TripleSystem.Iso.leviIso f
    let gd : F.levi.deleteEdges {s(a, b)} ≃g
        F'.levi.deleteEdges {s(g a, g b)} :=
      { toEquiv := g.toEquiv
        map_rel_iff' := by
          intro x y
          simp [g.map_adj_iff] }
    change (¬(F.levi.deleteEdges {s(a, b)}).Reachable a b) ↔
      ¬(F'.levi.deleteEdges {s(g a, g b)}).Reachable (g a) (g b)
    exact not_congr gd.reachable_iff.symm
  let bfi : Erdos593.SimpleGraph.bridgeFree F.levi ≃g
      Erdos593.SimpleGraph.bridgeFree F'.levi :=
    { toEquiv := (TripleSystem.Iso.leviIso f).toEquiv
      map_rel_iff' := by
        intro a b
        show (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj
            (TripleSystem.Iso.leviIso f a) (TripleSystem.Iso.leviIso f b) ↔
          (Erdos593.SimpleGraph.bridgeFree F.levi).Adj a b
        simp only [Erdos593.SimpleGraph.bridgeFree,
          _root_.SimpleGraph.deleteEdges_adj, Finset.mem_coe,
          Erdos593.SimpleGraph.mem_bridgeFinset,
          (TripleSystem.Iso.leviIso f).map_adj_iff,
          _root_.SimpleGraph.mem_edgeSet]
        rw [hIsBridge a b] }
  have hbfi_inl : ∀ x : V, bfi (Sum.inl x) = Sum.inl (f.vertexEquiv x) := fun _ => rfl
  have hbfi_inr : ∀ e : E, bfi (Sum.inr e) = Sum.inr (f.edgeEquiv e) := fun _ => rfl
  have hbfi_adj : ∀ a b : V ⊕ E,
      (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj (bfi a) (bfi b) ↔
        (Erdos593.SimpleGraph.bridgeFree F.levi).Adj a b :=
    fun _ _ => bfi.map_adj_iff
  have hbfi_degree : ∀ z : V ⊕ E,
      (Erdos593.SimpleGraph.bridgeFree F'.levi).degree (bfi z) =
        (Erdos593.SimpleGraph.bridgeFree F.levi).degree z :=
    fun z => _root_.SimpleGraph.Iso.degree_eq bfi z
  -- ## Transport of components, points and contracted graphs
  let cc : BridgeBlock.Component F ≃ BridgeBlock.Component F' :=
    bfi.connectedComponentEquiv
  have hcc_mk : ∀ z : V ⊕ E,
      cc ((Erdos593.SimpleGraph.bridgeFree F.levi).connectedComponentMk z) =
        (Erdos593.SimpleGraph.bridgeFree F'.levi).connectedComponentMk (bfi z) :=
    fun _ => rfl
  have hsupp : ∀ (C : BridgeBlock.Component F) (z : V ⊕ E),
      z ∈ C.supp ↔ bfi z ∈ (cc C).supp := by
    intro C z
    constructor
    · intro h
      have h2 := congrArg cc h
      rwa [hcc_mk] at h2
    · intro h
      have h' : cc ((Erdos593.SimpleGraph.bridgeFree F.levi).connectedComponentMk z) =
          cc C := by
        rw [hcc_mk]
        exact h
      exact cc.injective h'
  let pt : ∀ C : BridgeBlock.Component F,
      BridgeBlock.Point F C ≃ BridgeBlock.Point F' (cc C) := fun C =>
    { toFun := fun x => ⟨f.vertexEquiv x.1, (hsupp C (Sum.inl x.1)).mp x.2⟩
      invFun := fun y => ⟨f.vertexEquiv.symm y.1, by
        refine (hsupp C (Sum.inl (f.vertexEquiv.symm y.1))).mpr ?_
        rw [hbfi_inl, Equiv.apply_symm_apply]
        exact y.2⟩
      left_inv := by intro x; apply Subtype.ext; simp
      right_inv := by intro y; apply Subtype.ext; simp }
  have hpt_val : ∀ (C : BridgeBlock.Component F) (x : BridgeBlock.Point F C),
      (pt C x).1 = f.vertexEquiv x.1 := fun _ _ => rfl
  let ce : ∀ C : BridgeBlock.Component F,
      BridgeBlock.ContractibleEdge F C ≃
        BridgeBlock.ContractibleEdge F' (cc C) := fun C =>
    { toFun := fun e => ⟨f.edgeEquiv e.1, (hsupp C (Sum.inr e.1)).mp e.2.1, by
        rw [show (Sum.inr (f.edgeEquiv e.1) : V' ⊕ E') = bfi (Sum.inr e.1) from rfl,
          hbfi_degree]
        exact e.2.2⟩
      invFun := fun e' => ⟨f.edgeEquiv.symm e'.1, by
        refine (hsupp C (Sum.inr (f.edgeEquiv.symm e'.1))).mpr ?_
        rw [hbfi_inr, Equiv.apply_symm_apply]
        exact e'.2.1, by
        rw [← hbfi_degree (Sum.inr (f.edgeEquiv.symm e'.1)), hbfi_inr,
          Equiv.apply_symm_apply]
        exact e'.2.2⟩
      left_inv := by intro e; apply Subtype.ext; simp
      right_inv := by intro e'; apply Subtype.ext; simp }
  have hce_val : ∀ (C : BridgeBlock.Component F)
      (e : BridgeBlock.ContractibleEdge F C), (ce C e).1 = f.edgeEquiv e.1 :=
    fun _ _ => rfl
  let psi : ∀ C : BridgeBlock.Component F,
      BridgeBlock.contractedGraph F C ≃g
        BridgeBlock.contractedGraph F' (cc C) := fun C =>
    { toEquiv := pt C
      map_rel_iff' := by
        intro x y
        show (BridgeBlock.contractedGraph F' (cc C)).Adj (pt C x) (pt C y) ↔
          (BridgeBlock.contractedGraph F C).Adj x y
        rw [BridgeBlock.contractedGraph_adj, BridgeBlock.contractedGraph_adj]
        constructor
        · rintro ⟨hne, e', he'x, he'y⟩
          refine ⟨?_, (ce C).symm e', ?_, ?_⟩
          · intro h
            exact hne (congrArg (pt C) h)
          · refine (hbfi_adj (Sum.inl x.1) (Sum.inr ((ce C).symm e').1)).mp ?_
            rw [hbfi_inl, hbfi_inr]
            show (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj
              (Sum.inl (pt C x).1)
              (Sum.inr (f.edgeEquiv (f.edgeEquiv.symm e'.1)))
            rw [Equiv.apply_symm_apply]
            exact he'x
          · refine (hbfi_adj (Sum.inl y.1) (Sum.inr ((ce C).symm e').1)).mp ?_
            rw [hbfi_inl, hbfi_inr]
            show (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj
              (Sum.inl (pt C y).1)
              (Sum.inr (f.edgeEquiv (f.edgeEquiv.symm e'.1)))
            rw [Equiv.apply_symm_apply]
            exact he'y
        · rintro ⟨hne, e, hex, hey⟩
          refine ⟨?_, ce C e, ?_, ?_⟩
          · intro h
            exact hne ((pt C).injective h)
          · exact (hbfi_adj (Sum.inl x.1) (Sum.inr e.1)).mpr hex
          · exact (hbfi_adj (Sum.inl y.1) (Sum.inr e.1)).mpr hey }
  have hpsi_val : ∀ (C : BridgeBlock.Component F) (x : BridgeBlock.Point F C),
      (psi C x).1 = f.vertexEquiv x.1 := fun _ _ => rfl
  -- ## Naturality of the canonical hyperedge witness
  have hwitness : ∀ (C : BridgeBlock.Component F)
      (a : (BridgeBlock.contractedGraph F C).edgeSet),
      (BridgeBlock.graphEdgeWitness F' hlin' (C := cc C) (esE (psi C) a)).1 =
        f.edgeEquiv (BridgeBlock.graphEdgeWitness F hlinear (C := C) a).1 := by
    intro C a
    set b := esE (psi C) a with hbdef
    have haAdj : (BridgeBlock.contractedGraph F C).Adj a.1.out.1 a.1.out.2 := by
      change Quot.mk (Sym2.Rel (BridgeBlock.Point F C)) a.1.out ∈
        (BridgeBlock.contractedGraph F C).edgeSet
      simpa only [Quot.out_eq] using a.2
    have hne : a.1.out.1 ≠ a.1.out.2 :=
      ((BridgeBlock.contractedGraph_adj F C _ _).mp haAdj).1
    have hspec := BridgeBlock.graphEdgeWitness_spec F hlinear a
    have hspec' := BridgeBlock.graphEdgeWitness_spec F' hlin' b
    have hb1 : b.1 = s(psi C a.1.out.1, psi C a.1.out.2) := by
      rw [hbdef, hesE_val]
      conv_lhs => rw [← a.1.out_eq]
      rfl
    have hpair : (b.1.out.1 = psi C a.1.out.1 ∧ b.1.out.2 = psi C a.1.out.2) ∨
        (b.1.out.1 = psi C a.1.out.2 ∧ b.1.out.2 = psi C a.1.out.1) := by
      have hout : s(b.1.out.1, b.1.out.2) =
          s(psi C a.1.out.1, psi C a.1.out.2) := by
        rw [← hb1]
        exact b.1.out_eq
      simpa using Sym2.eq_iff.mp hout
    have htrans1 : (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj
        (Sum.inl (psi C a.1.out.1).1)
        (Sum.inr (ce C (BridgeBlock.graphEdgeWitness F hlinear a)).1) :=
      (hbfi_adj (Sum.inl a.1.out.1.1)
        (Sum.inr (BridgeBlock.graphEdgeWitness F hlinear a).1)).mpr hspec.1
    have htrans2 : (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj
        (Sum.inl (psi C a.1.out.2).1)
        (Sum.inr (ce C (BridgeBlock.graphEdgeWitness F hlinear a)).1) :=
      (hbfi_adj (Sum.inl a.1.out.2.1)
        (Sum.inr (BridgeBlock.graphEdgeWitness F hlinear a).1)).mpr hspec.2
    have hw1 : (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj
        (Sum.inl (psi C a.1.out.1).1)
        (Sum.inr (BridgeBlock.graphEdgeWitness F' hlin' b).1) := by
      rcases hpair with ⟨h1, _⟩ | ⟨_, h2⟩
      · rw [← h1]; exact hspec'.1
      · rw [← h2]; exact hspec'.2
    have hw2 : (Erdos593.SimpleGraph.bridgeFree F'.levi).Adj
        (Sum.inl (psi C a.1.out.2).1)
        (Sum.inr (BridgeBlock.graphEdgeWitness F' hlin' b).1) := by
      rcases hpair with ⟨_, h2⟩ | ⟨h1, _⟩
      · rw [← h2]; exact hspec'.2
      · rw [← h1]; exact hspec'.1
    have hne' : psi C a.1.out.1 ≠ psi C a.1.out.2 := fun h => hne ((psi C).injective h)
    exact congrArg Subtype.val (BridgeBlock.contractibleEdge_unique F' hlin' hne'
      (e := BridgeBlock.graphEdgeWitness F' hlin' b)
      (f := ce C (BridgeBlock.graphEdgeWitness F hlinear a))
      hw1 hw2 htrans1 htrans2)
  -- ## Transport of hyperedge components
  let cch : BridgeBlock.HyperedgeComponent F ≃ BridgeBlock.HyperedgeComponent F' :=
    Equiv.subtypeEquiv cc (by
      intro C
      constructor
      · rintro ⟨e, he⟩
        exact ⟨f.edgeEquiv e, (hsupp C (Sum.inr e)).mp he⟩
      · rintro ⟨e', he'⟩
        refine ⟨f.edgeEquiv.symm e',
          (hsupp C (Sum.inr (f.edgeEquiv.symm e'))).mpr ?_⟩
        rw [hbfi_inr, Equiv.apply_symm_apply]
        exact he')
  have hcch_coe : ∀ C : BridgeBlock.HyperedgeComponent F,
      (cch C : BridgeBlock.Component F') = cc (C : BridgeBlock.Component F) :=
    fun _ => rfl
  have hhasinc : ∀ (C : BridgeBlock.Component F), BridgeBlock.HasIncidence F C →
      BridgeBlock.HasIncidence F' (cc C) := by
    intro C hC
    obtain ⟨x, e, hx, he, hadj⟩ := hC
    exact ⟨f.vertexEquiv x, f.edgeEquiv e, (hsupp C (Sum.inl x)).mp hx,
      (hsupp C (Sum.inr e)).mp he, (hbfi_adj (Sum.inl x) (Sum.inr e)).mpr hadj⟩
  have hgeeh : ∀ (C : BridgeBlock.Component F) (hC : BridgeBlock.HasIncidence F C)
      (hC' : BridgeBlock.HasIncidence F' (cc C)) (e : E) (he : Sum.inr e ∈ C.supp)
      (he' : Sum.inr (f.edgeEquiv e) ∈ (cc C).supp),
      esE (psi C) ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm
          ⟨e, he⟩) =
        (BridgeBlock.graphEdgeEquivHyperedge F' hlin' hbri' hC').symm
          ⟨f.edgeEquiv e, he'⟩ := by
    intro C hC hC' e he he'
    set a := (BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm ⟨e, he⟩
      with hadef
    refine (Equiv.eq_symm_apply _).mpr ?_
    apply Subtype.ext
    show (BridgeBlock.graphEdgeWitness F' hlin' (esE (psi C) a)).1 = f.edgeEquiv e
    rw [hwitness C a]
    have hwa : (BridgeBlock.graphEdgeWitness F hlinear a).1 = e := by
      have hval : ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC) a).1 =
          (BridgeBlock.graphEdgeWitness F hlinear a).1 := rfl
      rw [← hval, hadef, Equiv.apply_symm_apply]
    rw [hwa]
  -- ## The canonical atom label transport
  let amap : CanonicalAtom.Index F → CanonicalAtom.Index F' := fun A =>
    match A with
    | .singleton e hz => .singleton (f.edgeEquiv e) (by
        rw [show (Sum.inr (f.edgeEquiv e) : V' ⊕ E') = bfi (Sum.inr e) from rfl,
          hbfi_degree]
        exact hz)
    | .cycleBlock C hC B =>
        .cycleBlock (cch C) (hhasinc (C : BridgeBlock.Component F) hC)
          (bmap (psi (C : BridgeBlock.Component F)) B)
  have hamap_cycle : ∀ (C : BridgeBlock.HyperedgeComponent F)
      (hC : BridgeBlock.HasIncidence F C)
      (B : Erdos593.SimpleGraph.EdgeCycleBlock (BridgeBlock.contractedGraph F C)),
      amap (.cycleBlock C hC B) =
        .cycleBlock (cch C) (hhasinc (C : BridgeBlock.Component F) hC)
          (bmap (psi (C : BridgeBlock.Component F)) B) := fun _ _ _ => rfl
  have hamap_atomOf : ∀ e : E,
      amap (CanonicalAtom.atomOf F hlinear hbridge e) =
        CanonicalAtom.atomOf F' hlin' hbri' (f.edgeEquiv e) := by
    intro e
    have hdeg : (Erdos593.SimpleGraph.bridgeFree F'.levi).degree
        (Sum.inr (f.edgeEquiv e)) =
        (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) := by
      rw [show (Sum.inr (f.edgeEquiv e) : V' ⊕ E') = bfi (Sum.inr e) from rfl,
        hbfi_degree]
    by_cases hz : (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0
    · have hz' : (Erdos593.SimpleGraph.bridgeFree F'.levi).degree
          (Sum.inr (f.edgeEquiv e)) = 0 := by rw [hdeg]; exact hz
      unfold CanonicalAtom.atomOf
      rw [dif_pos hz, dif_pos hz']
    · have hz' : ¬ (Erdos593.SimpleGraph.bridgeFree F'.levi).degree
          (Sum.inr (f.edgeEquiv e)) = 0 := by rw [hdeg]; exact hz
      unfold CanonicalAtom.atomOf
      rw [dif_neg hz, dif_neg hz']
      have hC : BridgeBlock.HasIncidence F
          (BridgeBlock.hyperedgeComponentOf F e : BridgeBlock.Component F) :=
        CanonicalAtom.hyperedgeComponent_hasIncidence_of_degree_ne_zero F hz
      have he : Sum.inr e ∈
          (BridgeBlock.hyperedgeComponentOf F e : BridgeBlock.Component F).supp :=
        BridgeBlock.mem_hyperedgeComponentOf_set F e
      have key := hgeeh (BridgeBlock.hyperedgeComponentOf F e : BridgeBlock.Component F)
        hC (hhasinc _ hC) e he ((hsupp _ (Sum.inr e)).mp he)
      refine Eq.trans (hamap_cycle (BridgeBlock.hyperedgeComponentOf F e) hC
        (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge _
          ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC).symm
            ⟨e, he⟩))) ?_
      rw [hbmap_ofEdge, key]
      rfl
  have hamap_inj : Function.Injective amap := by
    intro A A' h
    cases A with
    | singleton e hz =>
        cases A' with
        | singleton d hd =>
            have hval : f.edgeEquiv e = f.edgeEquiv d := by injection h
            have hed : e = d := f.edgeEquiv.injective hval
            subst hed
            rfl
        | cycleBlock D hD B' => injection h
    | cycleBlock C hC B =>
        cases A' with
        | singleton d hd => injection h
        | cycleBlock D hD B' =>
            rw [hamap_cycle C hC B, hamap_cycle D hD B'] at h
            simp only [CanonicalAtom.Index.cycleBlock.injEq] at h
            have h1 := h.1
            have h3 := h.2
            have hCD : C = D := cch.injective h1
            subst hCD
            have h3' : bmap (psi (C : BridgeBlock.Component F)) B =
                bmap (psi (C : BridgeBlock.Component F)) B' := eq_of_heq h3
            have hBB : B = B' :=
              (bmap (psi (C : BridgeBlock.Component F))).injective h3'
            subst hBB
            rfl
  have hamap_surj : Function.Surjective amap := by
    intro A'
    obtain ⟨e', he'⟩ := CanonicalAtom.atomOf_surjective F' hlin' hbri' A'
    refine ⟨CanonicalAtom.atomOf F hlinear hbridge (f.edgeEquiv.symm e'), ?_⟩
    rw [hamap_atomOf, Equiv.apply_symm_apply]
    exact he'
  let aeq : CanonicalAtom.Index F ≃ CanonicalAtom.Index F' :=
    Equiv.ofBijective amap ⟨hamap_inj, hamap_surj⟩
  have haeq_apply : ∀ A : CanonicalAtom.Index F, aeq A = amap A := fun _ => rfl
  have haeq_atomOf : ∀ e : E,
      aeq (CanonicalAtom.atomOf F hlinear hbridge e) =
        CanonicalAtom.atomOf F' hlin' hbri' (f.edgeEquiv e) := hamap_atomOf
  -- ## Fibres, supports and incidence
  have hedges : ∀ (A : CanonicalAtom.Index F) (e : E),
      e ∈ CanonicalAtom.edges F hlinear hbridge A ↔
        f.edgeEquiv e ∈ CanonicalAtom.edges F' hlin' hbri' (aeq A) := by
    intro A e
    show CanonicalAtom.atomOf F hlinear hbridge e = A ↔
      CanonicalAtom.atomOf F' hlin' hbri' (f.edgeEquiv e) = aeq A
    rw [← haeq_atomOf e]
    exact (Equiv.apply_eq_iff_eq _).symm
  have hsupport : ∀ (A : CanonicalAtom.Index F) (x : V),
      x ∈ CanonicalAtom.atomSupport F hlinear hbridge A ↔
        f.vertexEquiv x ∈ CanonicalAtom.atomSupport F' hlin' hbri' (aeq A) := by
    intro A x
    constructor
    · rintro ⟨e, heA, hxe⟩
      exact ⟨f.edgeEquiv e, (hedges A e).mp heA, (f.map_inc_iff x e).mp hxe⟩
    · rintro ⟨e', he'A, hxe'⟩
      refine ⟨f.edgeEquiv.symm e', ?_, ?_⟩
      · rw [hedges A, Equiv.apply_symm_apply]
        exact he'A
      · refine (f.map_inc_iff x (f.edgeEquiv.symm e')).mpr ?_
        rw [Equiv.apply_symm_apply]
        exact hxe'
  have hincident : ∀ (A : CanonicalAtom.Index F) (x : V),
      CanonicalAtom.atomIncident F hlinear hbridge A x ↔
        CanonicalAtom.atomIncident F' hlin' hbri' (aeq A) (f.vertexEquiv x) :=
    hsupport
  -- ## The two incidence graphs
  let apiso : CanonicalAtom.atomPointIncidenceGraph F hlinear hbridge ≃g
      CanonicalAtom.atomPointIncidenceGraph F' hlin' hbri' :=
    { toEquiv := Equiv.sumCongr aeq f.vertexEquiv
      map_rel_iff' := by
        intro z v
        rcases z with A | x <;> rcases v with B | y <;>
          simp [CanonicalAtom.atomPointIncidenceGraph,
            SimpleGraph.bipartiteIncidenceGraph, hincident] }
  have hapiso_apply : ∀ z : CanonicalAtom.Index F ⊕ V,
      apiso z = Equiv.sumCongr aeq f.vertexEquiv z := fun _ => rfl
  have hshared : ∀ x : V,
      x ∈ CanonicalAtom.sharedAtomPoints F hlinear hbridge ↔
        f.vertexEquiv x ∈ CanonicalAtom.sharedAtomPoints F' hlin' hbri' := by
    intro x
    rw [CanonicalAtom.mem_sharedAtomPoints, CanonicalAtom.mem_sharedAtomPoints]
    refine Iff.of_eq (congrArg (fun n => 2 ≤ n) ?_)
    refine Finset.card_equiv aeq ?_
    intro A
    simp only [Finset.mem_filter, CanonicalAtom.mem_atomFinset, true_and]
    exact hincident A x
  have hprune : ∀ z : CanonicalAtom.Index F ⊕ V,
      z ∈ SimpleGraph.bipartitePruneVertices
          (CanonicalAtom.atomIncident F hlinear hbridge)
          (CanonicalAtom.atomFinset F hlinear hbridge) ↔
        Equiv.sumCongr aeq f.vertexEquiv z ∈
          SimpleGraph.bipartitePruneVertices
            (CanonicalAtom.atomIncident F' hlin' hbri')
            (CanonicalAtom.atomFinset F' hlin' hbri') := by
    intro z
    rcases z with A | x
    · simp only [Equiv.sumCongr_apply, Sum.map_inl,
        SimpleGraph.mem_bipartitePruneVertices_inl, CanonicalAtom.mem_atomFinset]
    · simp only [Equiv.sumCongr_apply, Sum.map_inr,
        SimpleGraph.mem_bipartitePruneVertices_inr]
      exact hshared x
  let spiso : CanonicalAtom.atomSharedPointIncidenceGraph F hlinear hbridge ≃g
      CanonicalAtom.atomSharedPointIncidenceGraph F' hlin' hbri' :=
    { toEquiv := Equiv.subtypeEquiv (Equiv.sumCongr aeq f.vertexEquiv) (by
        intro z
        simpa using hprune z)
      map_rel_iff' := by
        intro z v
        exact apiso.map_rel_iff }
  -- ## Assembling the transport
  exact ⟨{
    atomEquiv := aeq
    atomOf_map := haeq_atomOf
    edges_map_iff := hedges
    support_map_iff := hsupport
    atomIncident_map_iff := hincident
    atomPointGraphIso := apiso
    atomPointGraphIso_apply := hapiso_apply
    sharedPoint_map_iff := hshared
    sharedPointGraphIso := spiso
    sharedPointGraphIso_atom := fun A => Subtype.ext rfl
    sharedPointGraphIso_point := fun x hx => Subtype.ext rfl
    cycleBlockCore_transport := by
      intro C hC B
      refine ⟨cch C, hhasinc (C : BridgeBlock.Component F) hC,
        bmap (psi (C : BridgeBlock.Component F)) B,
        hamap_cycle C hC B, ⟨?_⟩⟩
      exact ffi (psi (C : BridgeBlock.Component F))
        (CanonicalAtom.cycleBlockEdgeSet F C B)
        (CanonicalAtom.cycleBlockEdgeSet_finite F C B)
        (CanonicalAtom.cycleBlockEdgeSet F' (cch C)
          (bmap (psi (C : BridgeBlock.Component F)) B))
        (CanonicalAtom.cycleBlockEdgeSet_finite F' (cch C)
          (bmap (psi (C : BridgeBlock.Component F)) B))
        (hblkedges (psi (C : BridgeBlock.Component F)) B) }⟩

end
end CanonicalAtom
end TripleSystem
end Erdos593
