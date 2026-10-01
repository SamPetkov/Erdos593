import Erdos593.TripleSystem.AtomicBoundaryCore
import Erdos593.Graph.ThetaRecognition

/-!
# The original-system cycle/theta boundary, with no auxiliary rank parameters

The cycle and theta proofs share one canonical-core extraction. The public
statement mentions only obligatoriness, reducedness, connectivity, literal
indecomposability, and the original vertex/edge counts. No beta, atom count,
phase predicate, supplied core, or assumed presentation is an input.
Candidate source; compilation and axiom review are not yet claimed.
-/

namespace E593AtomicBoundary

open _root_.SimpleGraph Erdos593 Erdos593.TripleSystem
open Erdos593.TripleSystem.CanonicalAtom

universe u

variable {V E : Type u} [Fintype V] [Fintype E]
variable [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

omit [DecidableEq V] [DecidableEq E] [DecidableRel F.levi.Adj] in
/-- At m=s, the actual core has rank one and is an even cycle. -/
theorem cycle_boundary
    (hI : F.Intrinsic) (hconn : F.levi.Connected)
    (hred : F.HasNoIsolatedPoints) (hi : OnePointIndecomposable F)
    {s : ℕ} (hs : 4 ≤ s) (hsize : Nat.card V = Nat.card E + s)
    (he : Nat.card E = s) :
    Even s ∧ Isomorphic F (privateVertexExpansion (cycleGraph s)) := by
  classical
  obtain ⟨J, ht, hb, hE, ⟨i⟩⟩ := core_on_fin F hI hconn hred hi hs hsize
  have hEuler := TwoConnectedBipartiteSpectrum.connected_cycleRank_euler
    J (TwoConnectedBipartiteSpectrum.two_connected_connected J ht)
  have hr : FiniteCycleRank.cycleRank J = 1 := by
    rw [hE, he, Nat.card_fin] at hEuler
    omega
  have hev := TwoConnectedBipartiteSpectrum.even_order_of_rank_one J ht hb hr
  obtain ⟨j⟩ := TwoConnectedBipartiteSpectrum.rank_one_iso_cycleGraph J ht hr
  refine ⟨by simpa only [Nat.card_fin] using hev, ?_⟩
  exact Eq.mp
    (congrArg (fun n : ℕ => Isomorphic F (privateVertexExpansion (cycleGraph n)))
      (Nat.card_fin s))
    ⟨i.trans (expansionIso j)⟩

omit [DecidableEq V] [DecidableEq E] [DecidableRel F.levi.Adj] in
/-- At odd surplus and m=s+1, the actual core is an even theta graph. -/
theorem theta_boundary
    (hI : F.Intrinsic) (hconn : F.levi.Connected)
    (hred : F.HasNoIsolatedPoints) (hi : OnePointIndecomposable F)
    {s : ℕ} (hs : 4 ≤ s) (hsize : Nat.card V = Nat.card E + s)
    (hodd : Odd s) (he : Nat.card E = s + 1) :
    ∃ r : Fin 3 → ℕ, (∀ i, 0 < r i) ∧ (∀ i, Even (r i)) ∧
      (∑ i : Fin 3, r i) = s + 1 ∧
      Isomorphic F (privateVertexExpansion (E593Theta.thetaGraph r)) := by
  classical
  obtain ⟨J, ht, hb, hE, ⟨i⟩⟩ := core_on_fin F hI hconn hred hi hs hsize
  have hEuler := TwoConnectedBipartiteSpectrum.connected_cycleRank_euler
    J (TwoConnectedBipartiteSpectrum.two_connected_connected J ht)
  have hr : FiniteCycleRank.cycleRank J = 2 := by
    rw [hE, he, Nat.card_fin] at hEuler
    omega
  obtain ⟨r, hpos, heven, hsum, ⟨j⟩⟩ :=
    E593Theta.rank_two_odd_bipartite_iso_theta J ht hr hb
      (by simpa only [Nat.card_fin] using hodd)
  exact ⟨r, hpos, heven, by simpa only [Nat.card_fin] using hsum,
    ⟨i.trans (expansionIso j)⟩⟩

omit [DecidableEq V] [DecidableEq E] [DecidableRel F.levi.Adj] in
/-- Direct manuscript endpoint at alpha(s)=s+(s mod 2). Both the core and the
incidence-preserving normal form are conclusions; no phase theorem is assumed. -/
theorem obligatory_atomic_alpha_boundary
    (hobl : F.IsObligatory) (hred : F.HasNoIsolatedPoints)
    (hconn : F.levi.Connected) (hi : OnePointIndecomposable F)
    {s : ℕ} (hs : 4 ≤ s) (hsize : Nat.card V = Nat.card E + s)
    (he : Nat.card E = s + s % 2) :
    (Even s ∧ Isomorphic F (privateVertexExpansion (cycleGraph s))) ∨
    (Odd s ∧ ∃ r : Fin 3 → ℕ, (∀ i, 0 < r i) ∧ (∀ i, Even (r i)) ∧
      (∑ i : Fin 3, r i) = s + 1 ∧
      Isomorphic F (privateVertexExpansion (E593Theta.thetaGraph r))) := by
  have hI := intrinsic_of_reduced_obligatory F hred hobl
  rcases Nat.even_or_odd s with hev | hod
  · left
    apply cycle_boundary F hI hconn hred hi hs hsize
    simpa only [Nat.even_iff.mp hev, Nat.add_zero] using he
  · right
    refine ⟨hod, theta_boundary F hI hconn hred hi hs hsize hod ?_⟩
    simpa only [Nat.odd_iff.mp hod] using he

end E593AtomicBoundary
