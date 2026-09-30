import Erdos593.Graph.FiniteEdgeFactor
import Erdos593.TripleSystem.BridgeBlockExpansion
import Erdos593.TripleSystem.CanonicalAtomPartition
import Erdos593.TripleSystem.EdgeRestriction
import Erdos593.TripleSystem.Expansion
import Erdos593.TripleSystem.Isomorph
import Erdos593.TripleSystem.SingleEdgePiece

/-!
# Canonical atom type dichotomy

This module packages each fibre of the welded canonical atom-label map as an
exact edge restriction.  A singleton label is compared with the corresponding
one-edge piece, while a cycle-block label is compared with the private-vertex
expansion of the finite graph carried by that literal quotient block.

Two-connectivity, bipartiteness, atom intersections, reconstruction, and
uniqueness are deliberately downstream obligations.
-/

namespace Erdos593

universe u v

namespace TripleSystem
namespace CanonicalAtom

open BridgeBlock

noncomputable section

variable {V : Type u} {E : Type v} (F : TripleSystem V E)
variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
  [DecidableRel F.levi.Adj]

/-- The exact triple-system restriction carried by one canonical atom label. -/
def atomRestriction
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : CanonicalAtom.Index F) :=
  F.edgeRestriction (CanonicalAtom.edges F hlinear hbridge A)

/-- The literal quotient-graph edges belonging to a selected cycle block. -/
def cycleBlockEdgeSet
    (C : BridgeBlock.HyperedgeComponent F)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :
    Set (BridgeBlock.contractedGraph F C).edgeSet :=
  Erdos593.SimpleGraph.EdgeCycleBlock.edges
    (BridgeBlock.contractedGraph F C) B

/-- A selected cycle block is finite because its ambient contracted graph is
finite. -/
theorem cycleBlockEdgeSet_finite
    (C : BridgeBlock.HyperedgeComponent F)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :
    (cycleBlockEdgeSet F C B).Finite :=
  Set.toFinite _

/-- The finite graph on exactly the endpoints of a selected quotient cycle
block. -/
noncomputable def cycleBlockCore
    (C : BridgeBlock.HyperedgeComponent F)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :=
  finiteEdgeFactorGraph
    (BridgeBlock.contractedGraph F C)
    (cycleBlockEdgeSet F C B)
    (cycleBlockEdgeSet_finite F C B)

/-- Every canonical atom restriction is exactly either the selected one-edge
piece or the private-vertex expansion of its selected quotient cycle block. -/
theorem atomRestriction_is_singleEdge_or_cycleBlockExpansion
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : CanonicalAtom.Index F) :
    match A with
    | .singleton e _ =>
        TripleSystem.Isomorphic
          (CanonicalAtom.atomRestriction F hlinear hbridge A)
          (F.singleEdgePiece e)
    | .cycleBlock C _ B =>
        TripleSystem.Isomorphic
          (CanonicalAtom.atomRestriction F hlinear hbridge A)
          (privateVertexExpansion (CanonicalAtom.cycleBlockCore F C B)) := by
  classical
  cases A with
  | singleton e hzero =>
      have hmem : e ∈ CanonicalAtom.edges F hlinear hbridge
          (Index.singleton e hzero) := by
        change CanonicalAtom.atomOf F hlinear hbridge e = Index.singleton e hzero
        unfold CanonicalAtom.atomOf
        rw [dif_pos hzero]
      have hsingle : ∀ f : E,
          f ∈ CanonicalAtom.edges F hlinear hbridge (Index.singleton e hzero) →
            f = e := by
        intro f hf
        change CanonicalAtom.atomOf F hlinear hbridge f = Index.singleton e hzero at hf
        unfold CanonicalAtom.atomOf at hf
        by_cases hfzero :
            (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) = 0
        · rw [dif_pos hfzero] at hf
          injection hf
        · rw [dif_neg hfzero] at hf
          exact absurd hf (by simp)
      have hsupp :
          F.edgeSupportSet
              (CanonicalAtom.edges F hlinear hbridge (Index.singleton e hzero)) =
            F.edgeSet e := by
        ext x
        constructor
        · rintro ⟨f, hfS, hxf⟩
          rw [hsingle f hfS] at hxf
          exact hxf
        · intro hx
          exact ⟨e, hmem, hx⟩
      show TripleSystem.Isomorphic
        (CanonicalAtom.atomRestriction F hlinear hbridge (Index.singleton e hzero))
        (F.singleEdgePiece e)
      refine ⟨{ vertexEquiv := Equiv.setCongr hsupp
                edgeEquiv :=
                  { toFun := fun _ => ULift.up ()
                    invFun := fun _ => ⟨e, hmem⟩
                    left_inv := fun d => Subtype.ext (hsingle d.1 d.2).symm
                    right_inv := fun _ => rfl }
                map_inc_iff := ?_ }⟩
      intro x d
      constructor
      · intro _
        trivial
      · intro _
        show F.Inc x.1 d.1
        rw [hsingle d.1 d.2]
        obtain ⟨f, hfS, hxf⟩ :
            ∃ f : E,
              f ∈ CanonicalAtom.edges F hlinear hbridge (Index.singleton e hzero) ∧
                F.Inc x.1 f := x.2
        rw [hsingle f hfS] at hxf
        exact hxf
  | cycleBlock C hC B =>
      show TripleSystem.Isomorphic
        (CanonicalAtom.atomRestriction F hlinear hbridge
          (Index.cycleBlock C hC B))
        (privateVertexExpansion (CanonicalAtom.cycleBlockCore F C B))
      let G := BridgeBlock.contractedGraph F (C : BridgeBlock.Component F)
      let Aset : Set G.edgeSet := CanonicalAtom.cycleBlockEdgeSet F C B
      let hAfin : Aset.Finite := CanonicalAtom.cycleBlockEdgeSet_finite F C B
      let phi := BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge hC
      let emb :=
        BridgeBlock.componentExpansionEmbedding F hlinear
          (C : BridgeBlock.Component F)
      have hedgeval : ∀ a : G.edgeSet, (phi a).1 = emb.edge a := fun _ => rfl
      have hSdesc : ∀ f : E,
          f ∈ CanonicalAtom.edges F hlinear hbridge (Index.cycleBlock C hC B) ↔
            ∃ a : G.edgeSet, a ∈ Aset ∧ (phi a).1 = f := by
        intro f
        constructor
        · intro hf
          change CanonicalAtom.atomOf F hlinear hbridge f =
            Index.cycleBlock C hC B at hf
          by_cases hfzero :
              (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr f) = 0
          · unfold CanonicalAtom.atomOf at hf
            rw [dif_pos hfzero] at hf
            exact absurd hf (by simp)
          · have keyfwd : ∀ (D : BridgeBlock.HyperedgeComponent F)
                (hD : BridgeBlock.HasIncidence F (D : BridgeBlock.Component F))
                (hmemD : Sum.inr f ∈ (D : BridgeBlock.Component F).supp),
                Index.cycleBlock D hD
                    (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
                      (BridgeBlock.contractedGraph F
                        (D : BridgeBlock.Component F))
                      ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge
                        hD).symm ⟨f, hmemD⟩))
                  = Index.cycleBlock C hC B →
                ∃ a : G.edgeSet, a ∈ Aset ∧ (phi a).1 = f := by
              intro D hD hmemD heq
              injection heq with h1 h2
              subst h1
              refine ⟨phi.symm ⟨f, hmemD⟩, ?_, ?_⟩
              · exact eq_of_heq h2
              · exact congrArg Subtype.val (phi.apply_symm_apply ⟨f, hmemD⟩)
            unfold CanonicalAtom.atomOf at hf
            rw [dif_neg hfzero] at hf
            exact keyfwd _ _ _ hf
        · rintro ⟨a, haA, rfl⟩
          have hmem : Sum.inr (phi a).1 ∈ (C : BridgeBlock.Component F).supp :=
            (phi a).2
          have hdeg :
              (Erdos593.SimpleGraph.bridgeFree F.levi).degree
                (Sum.inr (phi a).1) = 2 :=
            BridgeBlock.edge_degree_eq_two_of_hasIncidence F hbridge hC hmem
          have hfzero :
              ¬ (Erdos593.SimpleGraph.bridgeFree F.levi).degree
                (Sum.inr (phi a).1) = 0 := by omega
          have key : ∀ (D : BridgeBlock.HyperedgeComponent F)
              (hD : BridgeBlock.HasIncidence F (D : BridgeBlock.Component F))
              (hmemD : Sum.inr (phi a).1 ∈ (D : BridgeBlock.Component F).supp),
              D = C →
              Index.cycleBlock D hD
                  (Erdos593.SimpleGraph.EdgeCycleBlock.ofEdge
                    (BridgeBlock.contractedGraph F (D : BridgeBlock.Component F))
                    ((BridgeBlock.graphEdgeEquivHyperedge F hlinear hbridge
                      hD).symm ⟨(phi a).1, hmemD⟩))
                = Index.cycleBlock C hC B := by
            rintro D hD hmemD rfl
            congr 1
            rw [show (⟨(phi a).1, hmemD⟩ :
                  BridgeBlock.Hyperedge F (D : BridgeBlock.Component F)) =
                phi a from rfl, phi.symm_apply_apply]
            exact haA
          change CanonicalAtom.atomOf F hlinear hbridge ((phi a).1) = _
          unfold CanonicalAtom.atomOf
          rw [dif_neg hfzero]
          exact key _ _ _ (Subtype.ext hmem)
      have hexists : ∀ f : (CanonicalAtom.cycleBlockCore F C B).edgeSet,
          ∃ b : G.edgeSet, b ∈ Aset ∧
            (b : Sym2 (BridgeBlock.Point F (C : BridgeBlock.Component F))) =
              Sym2.map Subtype.val f.1 := by
        intro f
        have hf : f.1 ∈
            (_root_.SimpleGraph.fromEdgeSet
              {a | Sym2.map Subtype.val a ∈ Subtype.val '' Aset}).edgeSet := f.2
        rw [_root_.SimpleGraph.edgeSet_fromEdgeSet] at hf
        obtain ⟨b, hbA, hbval⟩ := hf.1
        exact ⟨b, hbA, hbval⟩
      let toGb : (CanonicalAtom.cycleBlockCore F C B).edgeSet → G.edgeSet :=
        fun f => (hexists f).choose
      have htoGA : ∀ f, toGb f ∈ Aset := fun f => (hexists f).choose_spec.1
      have htoGval : ∀ f,
          ((toGb f : G.edgeSet) :
              Sym2 (BridgeBlock.Point F (C : BridgeBlock.Component F))) =
            Sym2.map Subtype.val f.1 := fun f => (hexists f).choose_spec.2
      have htoGinj : Function.Injective toGb := by
        intro f f' h
        apply Subtype.ext
        apply Sym2.map.injective (Subtype.val_injective
          (p := fun x => x ∈ finiteEdgeEndpointFinset G Aset hAfin))
        rw [← htoGval, ← htoGval, h]
      have htoGsurj : ∀ b : G.edgeSet, b ∈ Aset →
          ∃ f : (CanonicalAtom.cycleBlockCore F C B).edgeSet, toGb f = b := by
        intro b hbA
        have hadj : G.Adj b.1.out.1 b.1.out.2 := by
          change Quot.mk (Sym2.Rel
            (BridgeBlock.Point F (C : BridgeBlock.Component F))) b.1.out ∈
              G.edgeSet
          simpa only [Quot.out_eq] using b.2
        have hxX := mem_finiteEdgeEndpointFinset G hAfin hbA (Sym2.out_fst_mem b.1)
        have hyX := mem_finiteEdgeEndpointFinset G hAfin hbA (Sym2.out_snd_mem b.1)
        have hbval : Sym2.map Subtype.val
            s((⟨b.1.out.1, hxX⟩ : finiteEdgeEndpointType G Aset hAfin),
              (⟨b.1.out.2, hyX⟩ : finiteEdgeEndpointType G Aset hAfin)) =
            (b : Sym2 (BridgeBlock.Point F (C : BridgeBlock.Component F))) := by
          rw [Sym2.map_mk]
          exact Quot.out_eq b.1
        have hKadj : (CanonicalAtom.cycleBlockCore F C B).Adj
            ⟨b.1.out.1, hxX⟩ ⟨b.1.out.2, hyX⟩ := by
          have hne : (⟨b.1.out.1, hxX⟩ : finiteEdgeEndpointType G Aset hAfin) ≠
              ⟨b.1.out.2, hyX⟩ := by
            intro h
            exact hadj.ne (congrArg Subtype.val h)
          show (_root_.SimpleGraph.fromEdgeSet
            {a | Sym2.map Subtype.val a ∈ Subtype.val '' Aset}).Adj _ _
          rw [_root_.SimpleGraph.fromEdgeSet_adj]
          exact ⟨⟨b, hbA, hbval.symm⟩, hne⟩
        refine ⟨⟨s(⟨b.1.out.1, hxX⟩, ⟨b.1.out.2, hyX⟩), hKadj⟩, ?_⟩
        apply Subtype.ext
        rw [htoGval]
        exact hbval
      obtain ⟨hpt, hptl, hptr⟩ :
          ∃ hpt : PrivateVertexExpansion.Point
                (CanonicalAtom.cycleBlockCore F C B) →
              PrivateVertexExpansion.Point G,
            (∀ x, hpt (Sum.inl x) = Sum.inl x.1) ∧
              ∀ f, hpt (Sum.inr f) = Sum.inr (toGb f) :=
        ⟨Sum.elim (fun x => Sum.inl x.1) (fun f => Sum.inr (toGb f)),
          fun _ => rfl, fun _ => rfl⟩
      have hptinj : Function.Injective hpt := by
        rintro (x | f) (y | g) h
        · rw [hptl, hptl] at h
          exact congrArg Sum.inl (Subtype.ext (Sum.inl.inj h))
        · rw [hptl, hptr] at h
          exact absurd h (by simp)
        · rw [hptr, hptl] at h
          exact absurd h (by simp)
        · rw [hptr, hptr] at h
          exact congrArg Sum.inr (htoGinj (Sum.inr.inj h))
      have hstep : ∀ (p : PrivateVertexExpansion.Point G) (b : G.edgeSet),
          F.Inc (emb.vertex p) (emb.edge b) ↔
            (privateVertexExpansion G).Inc p b := by
        intro p b
        have hset := Set.ext_iff.mp (emb.map_edge b) (emb.vertex p)
        constructor
        · intro hp
          rcases hset.mpr hp with ⟨q, hq, hqp⟩
          have hqeq : q = p := emb.vertex.injective hqp
          rwa [hqeq] at hq
        · intro hp
          exact hset.mp ⟨p, hp, rfl⟩
      have hptinc : ∀ (p : PrivateVertexExpansion.Point
            (CanonicalAtom.cycleBlockCore F C B))
          (f : (CanonicalAtom.cycleBlockCore F C B).edgeSet),
          (privateVertexExpansion (CanonicalAtom.cycleBlockCore F C B)).Inc p f ↔
            (privateVertexExpansion G).Inc (hpt p) (toGb f) := by
        rintro (x | g) f
        · rw [hptl]
          show x ∈ (f.1 : Sym2 (finiteEdgeEndpointType G Aset hAfin)) ↔
            (x.1 : BridgeBlock.Point F (C : BridgeBlock.Component F)) ∈
              ((toGb f).1 :
                Sym2 (BridgeBlock.Point F (C : BridgeBlock.Component F)))
          rw [htoGval, Sym2.mem_map]
          constructor
          · intro hx
            exact ⟨x, hx, rfl⟩
          · rintro ⟨y, hy, hyx⟩
            have hyeq : y = x := Subtype.ext hyx
            rwa [hyeq] at hy
        · rw [hptr]
          show g = f ↔ toGb g = toGb f
          exact ⟨fun h => by rw [h], fun h => htoGinj h⟩
      have hcover : ∀ p : PrivateVertexExpansion.Point
            (CanonicalAtom.cycleBlockCore F C B),
          ∃ b : G.edgeSet, b ∈ Aset ∧
            (privateVertexExpansion G).Inc (hpt p) b := by
        rintro (x | f)
        · rw [hptl]
          have hx : x.1 ∈ finiteEdgeEndpointFinset G Aset hAfin := x.2
          obtain ⟨b, hbmem, hxb⟩ :=
            (@Finset.mem_biUnion _ _ _ _
              (fun a b => Classical.propDecidable (a = b)) _).mp hx
          exact ⟨b, (Set.Finite.mem_toFinset hAfin).mp hbmem,
            (@Sym2.mem_toFinset _
              (fun a b => Classical.propDecidable (a = b)) _ _).mp hxb⟩
        · rw [hptr]
          exact ⟨toGb f, htoGA f, rfl⟩
      have hvmem : ∀ p : PrivateVertexExpansion.Point
            (CanonicalAtom.cycleBlockCore F C B),
          emb.vertex (hpt p) ∈
            F.edgeSupportSet
              (CanonicalAtom.edges F hlinear hbridge
                (Index.cycleBlock C hC B)) := by
        intro p
        obtain ⟨b, hbA, hinc⟩ := hcover p
        refine ⟨(phi b).1, (hSdesc _).mpr ⟨b, hbA, rfl⟩, ?_⟩
        rw [hedgeval]
        exact (hstep (hpt p) b).mpr hinc
      have hemem : ∀ f : (CanonicalAtom.cycleBlockCore F C B).edgeSet,
          (phi (toGb f)).1 ∈
            CanonicalAtom.edges F hlinear hbridge (Index.cycleBlock C hC B) :=
        fun f => (hSdesc _).mpr ⟨toGb f, htoGA f, rfl⟩
      have hvbij : Function.Bijective
          (fun p : PrivateVertexExpansion.Point
              (CanonicalAtom.cycleBlockCore F C B) =>
            (⟨emb.vertex (hpt p), hvmem p⟩ :
              F.EdgeSupport (CanonicalAtom.edges F hlinear hbridge
                (Index.cycleBlock C hC B)))) := by
        constructor
        · intro p q h
          exact hptinj (emb.vertex.injective (congrArg Subtype.val h))
        · intro z
          obtain ⟨e₀, he₀S, hze₀⟩ :
              ∃ e₀ : E,
                e₀ ∈ CanonicalAtom.edges F hlinear hbridge
                    (Index.cycleBlock C hC B) ∧ F.Inc z.1 e₀ := z.2
          obtain ⟨b, hbA, hbe⟩ := (hSdesc e₀).mp he₀S
          have hzb : F.Inc z.1 (emb.edge b) := by
            rw [← hedgeval, hbe]
            exact hze₀
          obtain ⟨q, hq, hqz⟩ := (Set.ext_iff.mp (emb.map_edge b) z.1).mpr hzb
          rcases q with x | b'
          · have hxX : x ∈ finiteEdgeEndpointFinset G Aset hAfin :=
              mem_finiteEdgeEndpointFinset G hAfin hbA hq
            refine ⟨Sum.inl ⟨x, hxX⟩, ?_⟩
            apply Subtype.ext
            show emb.vertex (hpt (Sum.inl ⟨x, hxX⟩)) = z.1
            rw [hptl]
            exact hqz
          · have hb' : b' = b := hq
            subst hb'
            obtain ⟨f, hf⟩ := htoGsurj b' hbA
            refine ⟨Sum.inr f, ?_⟩
            apply Subtype.ext
            show emb.vertex (hpt (Sum.inr f)) = z.1
            rw [hptr, hf]
            exact hqz
      have hebij : Function.Bijective
          (fun f : (CanonicalAtom.cycleBlockCore F C B).edgeSet =>
            (⟨(phi (toGb f)).1, hemem f⟩ :
              CanonicalAtom.edges F hlinear hbridge
                (Index.cycleBlock C hC B))) := by
        constructor
        · intro f g h
          have h' := congrArg Subtype.val h
          exact htoGinj (phi.injective (Subtype.ext h'))
        · intro d
          obtain ⟨b, hbA, hbd⟩ := (hSdesc d.1).mp d.2
          obtain ⟨f, hf⟩ := htoGsurj b hbA
          refine ⟨f, Subtype.ext ?_⟩
          show (phi (toGb f)).1 = d.1
          rw [hf]
          exact hbd
      have hiso : TripleSystem.Isomorphic
          (privateVertexExpansion (CanonicalAtom.cycleBlockCore F C B))
          (F.edgeRestriction
            (CanonicalAtom.edges F hlinear hbridge
              (Index.cycleBlock C hC B))) := by
        refine ⟨{ vertexEquiv := Equiv.ofBijective _ hvbij
                  edgeEquiv := Equiv.ofBijective _ hebij
                  map_inc_iff := ?_ }⟩
        intro p f
        show (privateVertexExpansion
            (CanonicalAtom.cycleBlockCore F C B)).Inc p f ↔
          F.Inc (emb.vertex (hpt p)) ((phi (toGb f)).1)
        rw [hedgeval, hstep]
        exact hptinc p f
      exact hiso.symm

end
end CanonicalAtom
end TripleSystem
end Erdos593
