import Erdos593.TripleSystem.ErdosRado.CanonicalTrace
import Mathlib.SetTheory.Ordinal.Rank

/-!
# Conditional canonical trace tree

This is a source-facing interface for a *supplied* coherent trace system.  It
does not construct a trace system from a coloring, assert a global choice
principle, or state the eventual partition relation.  The construction of an
inhabitant belongs upstream; reduced-color coding and its injectivity belong
downstream.
-/

namespace Erdos593.TripleSystem.TriangleHost.ErdosRado

/-- An ordinal-indexed coherent trace family supplied for a fixed coloring.

`node a h` is the trace entry at index `eta`, where `h : eta < height a`.
The terminal case `height a = TraceHeight` is allowed. -/
structure CoherentTraceSystem (c : TraceColoring) where
  height : TraceCarrier → Ordinal
  height_le : ∀ a, height a ≤ TraceHeight
  node : ∀ (a : TraceCarrier) {eta : Ordinal}, eta < height a → TraceCarrier
  node_lt_anchor : ∀ (a : TraceCarrier) {eta : Ordinal} (heta : eta < height a),
    node a heta < a
  node_strict : ∀ (a : TraceCarrier) {eta zeta : Ordinal}
    (heta : eta < height a) (hzeta : zeta < height a), eta < zeta →
    node a heta < node a hzeta
  coherent_height : ∀ (a : TraceCarrier) {eta : Ordinal} (heta : eta < height a),
    height (node a heta) = eta
  coherent_prefix : ∀ (a : TraceCarrier) {eta zeta : Ordinal}
    (heta : eta < height a) (hzetaChild : zeta < height (node a heta))
    (hzetaParent : zeta < height a),
    node (node a heta) hzetaChild = node a hzetaParent

namespace CoherentTraceSystem

variable {c : TraceColoring} (T : CoherentTraceSystem c)

/-- A trace entry is a predecessor of the endpoint containing it. -/
def predecessor (b a : TraceCarrier) : Prop :=
  ∃ (eta : Ordinal) (heta : eta < T.height a), T.node a heta = b

theorem predecessor_lt {b a : TraceCarrier} (h : T.predecessor b a) : b < a := by
  rcases h with ⟨eta, heta, rfl⟩
  exact T.node_lt_anchor _ heta

theorem predecessor_height {b a : TraceCarrier} (h : T.predecessor b a) :
    ∃ eta : Ordinal, eta < T.height a ∧ T.height b = eta := by
  rcases h with ⟨eta, heta, rfl⟩
  exact ⟨eta, heta, T.coherent_height _ heta⟩

theorem predecessor_height_lt {b a : TraceCarrier} (h : T.predecessor b a) :
    T.height b < T.height a := by
  rcases T.predecessor_height h with ⟨eta, heta, hb⟩
  simpa [hb] using heta

/-- Coherence makes the trace predecessor relation transitive. -/
theorem predecessor_trans {d b a : TraceCarrier}
    (hdb : T.predecessor d b) (hba : T.predecessor b a) :
    T.predecessor d a := by
  rcases hba with ⟨eta, heta, rfl⟩
  rcases hdb with ⟨zeta, hzeta, hd⟩
  have hzeta_eta : zeta < eta := by
    simpa [T.coherent_height _ heta] using hzeta
  have hzeta_a : zeta < T.height a := hzeta_eta.trans heta
  refine ⟨zeta, hzeta_a, ?_⟩
  rw [← T.coherent_prefix _ heta hzeta hzeta_a]
  exact hd

theorem predecessor_subrelation :
    Subrelation T.predecessor (fun b a : TraceCarrier => b < a) :=
  fun h => T.predecessor_lt h

theorem predecessor_wellFounded : WellFounded T.predecessor := by
  refine wellFounded_lt.mono ?_
  intro b a h
  exact T.predecessor_lt h

theorem predecessor_isWellFounded : IsWellFounded TraceCarrier T.predecessor :=
  { wf := T.predecessor_wellFounded }

/-- The well-founded rank of a trace node for the predecessor relation. -/
noncomputable def treeRank (a : TraceCarrier) : Ordinal :=
  @IsWellFounded.rank TraceCarrier T.predecessor
    { wf := T.predecessor_wellFounded } a

theorem treeRank_lt_of_predecessor {b a : TraceCarrier}
    (h : T.predecessor b a) : T.treeRank b < T.treeRank a := by
  letI : IsWellFounded TraceCarrier T.predecessor :=
    { wf := T.predecessor_wellFounded }
  exact IsWellFounded.rank_lt_of_rel h

theorem treeRank_eq_iSup (a : TraceCarrier) :
    T.treeRank a =
      ⨆ b : {b : TraceCarrier // T.predecessor b a},
        Order.succ (T.treeRank b) := by
  unfold treeRank
  letI : IsWellFounded TraceCarrier T.predecessor :=
    { wf := T.predecessor_wellFounded }
  exact IsWellFounded.rank_eq _ _

/-- The trace height is exactly the well-founded rank of its endpoint.

This is a theorem of the supplied interface, not an additional coherence field. -/
theorem treeRank_eq_height (a : TraceCarrier) : T.treeRank a = T.height a := by
  refine (wellFounded_lt : WellFounded (fun x y : TraceCarrier => x < y)).induction
    (C := fun x => T.treeRank x = T.height x) a ?_
  intro a ih
  apply le_antisymm
  · rw [T.treeRank_eq_iSup a]
    apply Ordinal.iSup_le
    rintro ⟨b, hb⟩
    rcases hb with ⟨eta, heta, rfl⟩
    rw [ih _ (T.node_lt_anchor a heta), T.coherent_height a heta]
    exact Order.succ_le_iff.mpr heta
  · by_contra hnot
    have hrank_lt_height : T.treeRank a < T.height a :=
      lt_of_not_ge hnot
    have hnode_lt : T.node a hrank_lt_height < a :=
      T.node_lt_anchor a hrank_lt_height
    have hpred : T.predecessor (T.node a hrank_lt_height) a :=
      ⟨T.treeRank a, hrank_lt_height, rfl⟩
    have hdown := T.treeRank_lt_of_predecessor hpred
    rw [ih _ hnode_lt, T.coherent_height a hrank_lt_height] at hdown
    exact (lt_irrefl _ hdown)

/-- The nodes whose supplied trace height is `rho`. -/
def level (rho : Ordinal) : Set TraceCarrier := {a | T.height a = rho}

end CoherentTraceSystem

end Erdos593.TripleSystem.TriangleHost.ErdosRado
