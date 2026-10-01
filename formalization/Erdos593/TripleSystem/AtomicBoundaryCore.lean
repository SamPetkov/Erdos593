import Erdos593.TripleSystem.CanonicalAtomCountSpectrum
import Mathlib.Combinatorics.SimpleGraph.Maps

/-!
# One extraction of the actual core for both atomic boundary cases

This module uses the accepted canonical-atom base-count theorem directly.
It does not depend on the candidate phase diagram, a supplied atom list,
or a numerical shadow. All conclusions concern actual incidence isomorphisms.
Candidate source; pinned Lean replay remains required.
-/

namespace E593AtomicBoundary

open _root_.SimpleGraph Erdos593 Erdos593.TripleSystem
open Erdos593.TripleSystem.CanonicalAtom

universe u v

/-- Incidence-preserving transport of private-vertex expansions. -/
noncomputable def expansionIso
    {V : Type u} {W : Type v} {G : SimpleGraph V} {H : SimpleGraph W}
    (i : G ≃g H) : Iso (privateVertexExpansion G) (privateVertexExpansion H) where
  vertexEquiv := Equiv.sumCongr i.toEquiv i.mapEdgeSet
  edgeEquiv := i.mapEdgeSet
  map_inc_iff := by
    rintro (x | f) e
    · change x ∈ (e : Sym2 V) ↔ i x ∈ Sym2.map i (e : Sym2 V)
      rw [Sym2.mem_map]
      exact ⟨fun hx => ⟨x, hx, rfl⟩,
        fun ⟨y, hy, hyx⟩ => (i.injective hyx) ▸ hy⟩
    · change f = e ↔ i.mapEdgeSet f = i.mapEdgeSet e
      exact i.mapEdgeSet.injective.eq_iff.symm

/-- Recover intrinsic structure without a candidate phase-diagram dependency. -/
theorem intrinsic_of_reduced_obligatory
    {V E : Type u} [Fintype V] [Fintype E]
    (F : TripleSystem V E) (hred : F.HasNoIsolatedPoints)
    (hobl : F.IsObligatory) : F.Intrinsic := by
  let i : Iso F.isolatedReduction F :=
    { vertexEquiv := Equiv.subtypeUnivEquiv (fun x => hred x)
      edgeEquiv := Equiv.refl E
      map_inc_iff := fun _ _ => Iff.rfl }
  exact (Erdos593.TripleSystem.Iso.intrinsic_iff i).mp
    ((isObligatory_iff_isolatedReduction_intrinsic F).mp hobl)

/-- Every nontrivial reduced connected indecomposable intrinsic system has an
actual two-connected bipartite core on `Fin s`, where n=m+s. The canonical
atom, its full original-edge fibre, and the core graph are all derived. -/
theorem core_on_fin
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hI : F.Intrinsic) (hconn : F.levi.Connected)
    (hred : F.HasNoIsolatedPoints) (hi : OnePointIndecomposable F)
    {s : ℕ} (hs : 4 ≤ s) (hsize : Nat.card V = Nat.card E + s) :
    ∃ J : SimpleGraph (Fin s), IsTwoVertexConnected J ∧ J.Colorable 2 ∧
      Nat.card J.edgeSet = Nat.card E ∧ Isomorphic F (privateVertexExpansion J) := by
  classical
  have hcard : Nat.card (Index F) = 1 :=
    card_index_eq_one_of_onePointIndecomposable F hI hconn hred hi
  obtain ⟨A, hA⟩ := Nat.card_eq_one_iff_exists.mp hcard
  have hfibre : edges F hI.1 hI.2.1 A = Set.univ := by
    ext e
    change (atomOf F hI.1 hI.2.1 e = A) ↔ True
    exact ⟨fun _ => trivial, fun _ => hA _⟩
  have i : Iso (atomRestriction F hI.1 hI.2.1 A) F := by
    change Iso (F.edgeRestriction (edges F hI.1 hI.2.1 A)) F
    rw [hfibre]
    exact F.edgeRestrictionUnivIso hred
  cases A with
  | singleton e hz =>
      obtain ⟨j⟩ := atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
        F hI.1 hI.2.1 (Index.singleton e hz)
      let ij := i.symm.trans j
      have he : Nat.card E = 1 := by
        simpa [SingleEdgeIndex] using Nat.card_congr ij.edgeEquiv
      have hv : Nat.card V = 3 := by
        calc
          Nat.card V = Nat.card (F.edgeSet e) := Nat.card_congr ij.vertexEquiv
          _ = 3 := F.edge_ncard e
      omega
  | cycleBlock C hC B =>
      obtain ⟨j⟩ := atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
        F hI.1 hI.2.1 (Index.cycleBlock C hC B)
      let J := cycleBlockCore F C B
      let W := Erdos593.finiteEdgeEndpointType (BridgeBlock.contractedGraph F C)
        (cycleBlockEdgeSet F C B) (cycleBlockEdgeSet_finite F C B)
      let ij := i.symm.trans j
      have he : Nat.card J.edgeSet = Nat.card E := by
        exact (Nat.card_congr ij.edgeEquiv).symm
      have hv : Nat.card W = s := by
        have h := Nat.card_congr ij.vertexEquiv
        change Nat.card V = Nat.card (W ⊕ J.edgeSet) at h
        rw [Nat.card_sum, he] at h
        omega
      have hvf : Fintype.card W = s := by
        simpa only [Nat.card_eq_fintype_card] using hv
      let J' : SimpleGraph (Fin s) := J.overFin hvf
      let eJ : J ≃g J' := J.overFinIso hvf
      have ht := cycleBlockCore_isTwoVertexConnected F hI.1 hI.2.1 C hC B
      have hb := cycleBlockCore_isBipartite F hI.1 hI.2.1 hI.2.2 C hC B
      refine ⟨J', ?_, ?_, ?_, ⟨ij.trans (expansionIso eJ)⟩⟩
      · exact TwoConnectedBipartiteSpectrum.two_connected_of_iso J J' eJ ht
      · exact Colorable.of_hom eJ.symm.toHom hb
      · exact (Nat.card_congr eJ.mapEdgeSet).symm.trans he

end E593AtomicBoundary
