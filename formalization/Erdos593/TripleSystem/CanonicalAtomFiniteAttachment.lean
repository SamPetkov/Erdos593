import Erdos593.TripleSystem.CanonicalAtomAmalgamOption
import Erdos593.TripleSystem.CanonicalAtomCanonicity
import Erdos593.TripleSystem.OnePointAmalgamationGeometry
import Erdos593.TripleSystem.SingleEdgePieceConstructible
import Erdos593.TripleSystem.ForwardExpansion
import Erdos593.TripleSystem.TriangleHostRamseyTransport
import Erdos593.TripleSystem.CycleRankSpectrum

namespace Erdos593.TripleSystem.CanonicalAtom

theorem exists_finite_attachment_parameters
    (n m t : ℕ)
    (F : TripleSystem (Fin n) (Fin m))
    [DecidableRel F.levi.Adj]
    (hF : F.Intrinsic)
    (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints) :
    ∃ H : TripleSystem (Fin (n + 2 * t)) (Fin (m + t)),
      letI : DecidableRel H.levi.Adj := Classical.decRel _
      H.Intrinsic ∧
      H.HasNoIsolatedPoints ∧
      H.levi.Connected ∧
      _root_.SimpleGraph.FiniteCycleRank.cycleRank H.levi =
        _root_.SimpleGraph.FiniteCycleRank.cycleRank F.levi ∧
      Nat.card (Index H) = Nat.card (Index F) + t :=
by
  classical
  -- The canonical single-triple piece: the private-vertex expansion of `K₂`.
  letI : Unique (PrivateVertexExpansion.Edge oneEdgeGraph.{0}) :=
    { default := oneEdgeGraphEdge.{0}, uniq := oneEdgeGraph_edge_eq }
  let T : TripleSystem (PrivateVertexExpansion.Point oneEdgeGraph.{0})
      (PrivateVertexExpansion.Edge oneEdgeGraph.{0}) :=
    privateVertexExpansion oneEdgeGraph.{0}
  have hfin : ∀ j : ℕ, Nat.card (Fin j) = j := fun j => by simp
  have hD : Nat.card (PrivateVertexExpansion.Edge oneEdgeGraph.{0}) = 1 :=
    Nat.card_unique
  have hP : Nat.card (PrivateVertexExpansion.Point oneEdgeGraph.{0}) = 3 := by
    show Nat.card (PrivateVertexExpansion.CoreVertex oneEdgeGraph.{0} ⊕
      PrivateVertexExpansion.PrivateVertex oneEdgeGraph.{0}) = 3
    rw [Nat.card_sum, hD]
    show Nat.card (ULift.{0} (Fin 2)) + 1 = 3
    simp
  have hTint : T.Intrinsic :=
    privateVertexExpansion_intrinsic oneEdgeGraph.{0} oneEdgeGraph_colorable_two
  have hTiso : T.HasNoIsolatedPoints :=
    fun p hp => hp default (oneEdgeExpansion_inc p default)
  have hTpre : T.levi.Preconnected := by
    have hhub : ∀ z : PrivateVertexExpansion.Point oneEdgeGraph.{0} ⊕
        PrivateVertexExpansion.Edge oneEdgeGraph.{0},
        T.levi.Reachable z (Sum.inr default) := by
      rintro (p | d)
      · exact (T.levi_adj_point_edge.mpr (oneEdgeExpansion_inc p default)).reachable
      · rw [Subsingleton.elim d (default : PrivateVertexExpansion.Edge oneEdgeGraph.{0})]
    intro a b
    exact (hhub a).trans (hhub b).symm
  -- A connected graph has exactly one component.
  have hcomp1 : ∀ {W : Type} (G : _root_.SimpleGraph W), G.Connected →
      Nat.card G.ConnectedComponent = 1 := by
    intro W G hG
    haveI := hG.nonempty
    haveI := hG.preconnected.subsingleton_connectedComponent
    exact Nat.card_eq_one_iff_unique.mpr ⟨inferInstance, inferInstance⟩
  -- The source system has at least one point.
  have hn : 0 < n := by
    rcases Nat.eq_zero_or_pos n with rfl | h
    · exfalso
      rcases hconnected.nonempty with ⟨z⟩
      rcases z with x | e
      · exact x.elim0
      · have h3 := F.edge_ncard e
        rw [Set.eq_empty_of_isEmpty {x : Fin 0 | F.Inc x e}, Set.ncard_empty] at h3
        exact absurd h3 (by norm_num)
    · exact h
  -- Relabelling a finite system onto `Fin` carriers preserves all the data.
  have transport : ∀ (k l : ℕ) (W D : Type) (X : TripleSystem W D)
      (iW : Fintype W) (iD : Fintype D) (dW : DecidableEq W) (dD : DecidableEq D)
      (iR : DecidableRel X.levi.Adj) (eV : W ≃ Fin k) (eE : D ≃ Fin l),
      X.Intrinsic → X.HasNoIsolatedPoints → X.levi.Connected →
      ∃ Y : TripleSystem (Fin k) (Fin l),
        letI : DecidableRel Y.levi.Adj := Classical.decRel _
        Y.Intrinsic ∧ Y.HasNoIsolatedPoints ∧ Y.levi.Connected ∧
        Nat.card (Index Y) = Nat.card (@Index W D X iW iD dW dD iR) := by
    intro k l W D X iW iD dW dD iR eV eE hint hiso hconn
    letI := iW
    letI := iD
    letI := dW
    letI := dD
    letI := iR
    let Y : TripleSystem (Fin k) (Fin l) := TriangleHostTransport.reindex X eV eE
    have f : TripleSystem.Iso X Y :=
      { vertexEquiv := eV
        edgeEquiv := eE
        map_inc_iff := fun x e =>
          (TriangleHostTransport.reindex_inc_iff X eV eE x e).symm }
    letI : DecidableRel Y.levi.Adj := Classical.decRel _
    refine ⟨Y, (TripleSystem.Iso.intrinsic_iff f).mp hint, ?_, ?_, ?_⟩
    · intro y hy
      obtain ⟨e, he⟩ := X.not_isolated_iff_exists_inc.mp (hiso (eV.symm y))
      refine hy (eE e) ?_
      have h2 : Y.Inc (eV (eV.symm y)) (eE e) :=
        (TriangleHostTransport.reindex_inc_iff X eV eE (eV.symm y) e).mpr he
      rwa [Equiv.apply_symm_apply] at h2
    · exact (TripleSystem.Iso.leviIso f).connected_iff.mp hconn
    · obtain ⟨tr⟩ := exists_canonicityTransport X Y f hint.1 hint.2.1
      exact (Nat.card_congr tr.atomEquiv).symm
  -- One attachment step: amalgamate a single new triple at an existing point.
  have step : ∀ (k l : ℕ) (X : TripleSystem (Fin k) (Fin l))
      (iR : DecidableRel X.levi.Adj), 0 < k →
      X.Intrinsic → X.HasNoIsolatedPoints → X.levi.Connected →
      ∃ Y : TripleSystem (Fin (k + 2)) (Fin (l + 1)),
        letI : DecidableRel Y.levi.Adj := Classical.decRel _
        Y.Intrinsic ∧ Y.HasNoIsolatedPoints ∧ Y.levi.Connected ∧
        Nat.card (Index Y) = Nat.card (@Index (Fin k) (Fin l) X _ _ _ _ iR) + 1 := by
    intro k l X iR hk hint hiso hconn
    letI := iR
    let r : Fin k := ⟨0, hk⟩
    let q : PrivateVertexExpansion.Point oneEdgeGraph.{0} := Sum.inl (ULift.up 0)
    let U := OnePointAmalgamation.amalgam X T r q
    have hUint : U.Intrinsic :=
      OnePointAmalgamation.amalgam_intrinsic X T r q hint hTint
    have hUiso : U.HasNoIsolatedPoints :=
      OnePointAmalgamation.amalgam_hasNoIsolatedPoints X T r q hiso hTiso
    have hUconn : U.levi.Connected :=
      OnePointAmalgamation.amalgam_levi_connected X T r q hconn.preconnected hTpre
    have hUV : Nat.card (OnePointAmalgamation.Vertex r q) = k + 2 := by
      have h := OnePointAmalgamation.card_vertex_add_one (V := Fin k)
        (W := PrivateVertexExpansion.Point oneEdgeGraph.{0}) r q
      rw [hP, hfin k] at h
      omega
    have hUE : Nat.card (OnePointAmalgamation.Edge (Fin l)
        (PrivateVertexExpansion.Edge oneEdgeGraph.{0})) = l + 1 := by
      show Nat.card (Fin l ⊕ PrivateVertexExpansion.Edge oneEdgeGraph.{0}) = l + 1
      rw [Nat.card_sum, hD, hfin l]
    have hcard : Nat.card (@Index _ _ U (OnePointAmalgamation.vertexFintype r q)
        inferInstance (Classical.decEq _) (Classical.decEq _) (Classical.decRel _)) =
        Nat.card (@Index (Fin k) (Fin l) X _ _ _ _ iR) + 1 :=
      card_index_amalgam_of_unique_edges X T hint hTint r q
    obtain ⟨Y, hY1, hY2, hY3, hY4⟩ :=
      transport (k + 2) (l + 1) _ _ U (OnePointAmalgamation.vertexFintype r q)
        inferInstance (Classical.decEq _) (Classical.decEq _) (Classical.decRel _)
        (Finite.equivFinOfCardEq hUV) (Finite.equivFinOfCardEq hUE)
        hUint hUiso hUconn
    exact ⟨Y, hY1, hY2, hY3, by omega⟩
  -- The finite induction on the number of attached triples.
  have key : ∀ s : ℕ, ∃ H : TripleSystem (Fin (n + 2 * s)) (Fin (m + s)),
      letI : DecidableRel H.levi.Adj := Classical.decRel _
      H.Intrinsic ∧ H.HasNoIsolatedPoints ∧ H.levi.Connected ∧
      Nat.card (Index H) =
        Nat.card (@Index (Fin n) (Fin m) F _ _ _ _ (Classical.decRel _)) + s := by
    intro s
    induction s with
    | zero => exact ⟨F, hF, hreduced, hconnected, by omega⟩
    | succ s ih =>
        obtain ⟨H, hH1, hH2, hH3, hH4⟩ := ih
        obtain ⟨Y, hY1, hY2, hY3, hY4⟩ :=
          step (n + 2 * s) (m + s) H (Classical.decRel _) (by omega) hH1 hH2 hH3
        exact ⟨Y, hY1, hY2, hY3, by omega⟩
  obtain ⟨H, hH1, hH2, hH3, hH4⟩ := key t
  have hFidx : Nat.card (@Index (Fin n) (Fin m) F _ _ _ _ (Classical.decRel _)) =
      Nat.card (Index F) :=
    congrArg (fun i => Nat.card (@Index (Fin n) (Fin m) F _ _ _ _ i))
      (Subsingleton.elim _ _)
  refine ⟨H, hH1, hH2, hH3, ?_, by omega⟩
  have hrH := levi_cycleRank_int H
  have hrF := levi_cycleRank_int F
  rw [hcomp1 _ hH3] at hrH
  rw [hcomp1 _ hconnected] at hrF
  have : ((_root_.SimpleGraph.FiniteCycleRank.cycleRank H.levi : ℤ)) =
      ((_root_.SimpleGraph.FiniteCycleRank.cycleRank F.levi : ℤ)) := by
    rw [hrH, hrF]
    simp only [hfin]
    push_cast
    ring
  exact_mod_cast this

end Erdos593.TripleSystem.CanonicalAtom
