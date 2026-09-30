import Erdos593.TripleSystem.CanonicalAtomRankInterpretation
import Erdos593.Graph.TwoConnectedBipartiteSpectrum

/-! # Canonical core ranks and local minimum order

Proposition/API scaffold only: three disclosed proof holes.
All ranks and core orders refer to the existing actual canonical objects.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem cycleBlock_atom_cycleRank_eq_core
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (C : BridgeBlock.HyperedgeComponent F)
    (hC : BridgeBlock.HasIncidence F C)
    (B : Erdos593.SimpleGraph.EdgeCycleBlock
      (BridgeBlock.contractedGraph F C)) :
    _root_.SimpleGraph.FiniteCycleRank.cycleRank
      (atomRestriction F hlinear hbridge (Index.cycleBlock C hC B)).levi =
    _root_.SimpleGraph.FiniteCycleRank.cycleRank (cycleBlockCore F C B) := by
  classical
  let W := finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
    (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B)
  let J := cycleBlockCore F C B
  obtain ⟨i⟩ := atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
    F hlinear hbridge (Index.cycleBlock C hC B)
  have he := Nat.card_congr i.edgeEquiv
  change atomEdgeCount F hlinear hbridge (Index.cycleBlock C hC B) =
    Nat.card J.edgeSet at he
  have hlocal := atomLeviEuler_eq F hlinear hbridge (Index.cycleBlock C hC B)
  rw [atomLeviEuler_eq_cycleRank, atomPointCount_eq_edge_add_core, he] at hlocal
  push_cast at hlocal
  have htwo := cycleBlockCore_isTwoVertexConnected F hlinear hbridge C hC B
  have hEuler := _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.connected_cycleRank_euler
    J (_root_.SimpleGraph.TwoConnectedBipartiteSpectrum.two_connected_connected J htwo)
  have hEulerInt : (Nat.card J.edgeSet : ℤ) + 1 =
      (_root_.SimpleGraph.FiniteCycleRank.cycleRank J : ℤ) + (Nat.card W : ℤ) := by
    exact_mod_cast hEuler
  have hrank :
      (_root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge (Index.cycleBlock C hC B)).levi : ℤ) =
      (_root_.SimpleGraph.FiniteCycleRank.cycleRank J : ℤ) := by
    change _ = 2 * (Nat.card J.edgeSet : ℤ) -
      ((Nat.card J.edgeSet : ℤ) + (Nat.card W : ℤ)) + 1 at hlocal
    linarith
  exact_mod_cast hrank

theorem atom_cycleRank_eq_zero_iff_singleton
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (A : Index F) :
    _root_.SimpleGraph.FiniteCycleRank.cycleRank
      (atomRestriction F hlinear hbridge A).levi = 0 ↔
    ∃ e : E, ∃ hzero :
      (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0,
      A = Index.singleton e hzero := by
  classical
  cases A with
  | singleton e hzero =>
    constructor
    · intro _
      exact ⟨e, hzero, rfl⟩
    · intro _
      obtain ⟨i⟩ := atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
        F hlinear hbridge (Index.singleton e hzero)
      have he : atomEdgeCount F hlinear hbridge (Index.singleton e hzero) = 1 := by
        calc
          _ = Nat.card (SingleEdgeIndex : Type u) := Nat.card_congr i.edgeEquiv
          _ = 1 := by simp [SingleEdgeIndex]
      have hv : atomPointCount F hlinear hbridge (Index.singleton e hzero) = 3 := by
        calc
          _ = Nat.card (F.edgeSet e) := Nat.card_congr i.vertexEquiv
          _ = 3 := F.edge_ncard e
      have h := atomLeviEuler_eq F hlinear hbridge (Index.singleton e hzero)
      rw [atomLeviEuler_eq_cycleRank, he, hv] at h
      norm_num at h
      exact_mod_cast h
  | cycleBlock C hC B =>
    let W := finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
      (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B)
    let J := cycleBlockCore F C B
    have htwo := cycleBlockCore_isTwoVertexConnected F hlinear hbridge C hC B
    have hdegree : ∀ x : W, 2 ≤ J.degree x := by
      intro x
      have h := _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.two_connected_min_degree
        J htwo x
      simpa only [Nat.card_eq_fintype_card, J.card_neighborSet_eq_degree] using h
    have htwice : 2 * Nat.card W ≤ 2 * Nat.card J.edgeSet := by
      calc
        _ = ∑ _x : W, (2 : ℕ) := by simp [Nat.card_eq_fintype_card, mul_comm]
        _ ≤ ∑ x : W, J.degree x := Finset.sum_le_sum (fun x _ => hdegree x)
        _ = 2 * Nat.card J.edgeSet := by
          simpa only [J.edgeFinset_card, ← Nat.card_eq_fintype_card] using
            J.sum_degrees_eq_twice_card_edges
    have hEuler := _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.connected_cycleRank_euler
      J (_root_.SimpleGraph.TwoConnectedBipartiteSpectrum.two_connected_connected J htwo)
    change Nat.card J.edgeSet + 1 =
      _root_.SimpleGraph.FiniteCycleRank.cycleRank J + Nat.card W at hEuler
    have hpositive : 1 ≤ _root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge (Index.cycleBlock C hC B)).levi := by
      rw [cycleBlock_atom_cycleRank_eq_core F hlinear hbridge C hC B]
      change 1 ≤ _root_.SimpleGraph.FiniteCycleRank.cycleRank J
      omega
    constructor
    · intro hzero
      omega
    · rintro ⟨e, hzero, hEq⟩
      cases hEq

theorem atom_coreOrder_lower_bound
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (hberge : F.EvenBergeCycles) (A : Index F) :
    2 + Erdos593.Spectrum.q
      (_root_.SimpleGraph.FiniteCycleRank.cycleRank
        (atomRestriction F hlinear hbridge A).levi) ≤ coreOrder F A := by
  classical
  cases A with
  | singleton e hzero =>
    have hzRank := (atom_cycleRank_eq_zero_iff_singleton
      F hlinear hbridge (Index.singleton e hzero)).mpr ⟨e, hzero, rfl⟩
    rw [hzRank]
    norm_num [coreOrder, Erdos593.Spectrum.q]
  | cycleBlock C hC B =>
    let J := cycleBlockCore F C B
    have hr : 1 ≤ _root_.SimpleGraph.FiniteCycleRank.cycleRank J := by
      by_contra h
      have hzRank : _root_.SimpleGraph.FiniteCycleRank.cycleRank
          (atomRestriction F hlinear hbridge (Index.cycleBlock C hC B)).levi = 0 := by
        rw [cycleBlock_atom_cycleRank_eq_core F hlinear hbridge C hC B]
        change _root_.SimpleGraph.FiniteCycleRank.cycleRank J = 0
        omega
      obtain ⟨e, hzero, hEq⟩ := (atom_cycleRank_eq_zero_iff_singleton
        F hlinear hbridge (Index.cycleBlock C hC B)).mp hzRank
      cases hEq
    rw [cycleBlock_atom_cycleRank_eq_core F hlinear hbridge C hC B]
    exact _root_.SimpleGraph.TwoConnectedBipartiteSpectrum.minimum_order J
      (cycleBlockCore_isTwoVertexConnected F hlinear hbridge C hC B)
      (cycleBlockCore_isBipartite F hlinear hbridge hberge C hC B) hr

end Erdos593.TripleSystem.CanonicalAtom
