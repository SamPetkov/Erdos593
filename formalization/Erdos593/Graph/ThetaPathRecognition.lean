import Erdos593.Graph.ThetaPathData
import Erdos593.Graph.BoundaryCoreRecognition
import Mathlib.Data.Fintype.EquivFin

/-!
# Actual three-path recognition at cycle rank two

The paths are chosen in a vertex-deleted graph; internal disjointness and
coverage are derived using saturation. No ear-decomposition theorem or
assumed theta certificate occurs among the input hypotheses.
-/

namespace E593Theta

open SimpleGraph

universe u

variable {V : Type u} [Fintype V] [DecidableEq V]
variable {G : SimpleGraph V} [DecidableRel G.Adj]

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- Starting with one prescribed neighbour of a, deletion connectivity gives
a simple a-b path with precisely that first neighbour, including x=b. -/
theorem path_with_first_neighbour {a b x : V} (hab : a ≠ b)
    (hax : G.Adj a x) (hc : (G.induce {z : V | z ≠ a}).Connected) :
    ∃ p : G.Walk a b, p.IsPath ∧ p.snd = x := by
  classical
  let D := G.induce {z : V | z ≠ a}
  let X : {z : V // z ≠ a} := ⟨x, hax.ne.symm⟩
  let B : {z : V // z ≠ a} := ⟨b, hab.symm⟩
  obtain ⟨w⟩ := hc.preconnected X B
  let q : D.Path X B := w.toPath
  let f : D →g G := ⟨Subtype.val, fun h => h⟩
  let r : G.Walk x b := q.val.map f
  have hr : r.IsPath := q.property.map (show Function.Injective f from Subtype.val_injective)
  have ha : a ∉ r.support := by
    intro ha
    change a ∈ (q.val.map f).support at ha
    rw [Walk.support_map, List.mem_map] at ha
    obtain ⟨y, _, hy⟩ := ha
    exact y.property hy
  refine ⟨Walk.cons hax r, (Walk.cons_isPath_iff hax r).mpr ⟨hr, ha⟩, ?_⟩
  simp

omit [DecidableEq V] [DecidableRel G.Adj] in
/-- Full graph recognition: two-vertex-connectivity and actual cycle rank two
produce exactly three internally disjoint paths that exhaust vertices and edges. -/
theorem rank_two_three_paths (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 2) :
    ∃ a b : V, Nonempty (ThreePaths G a b) := by
  classical
  obtain ⟨a, b, hab, ha, _, hdeg, _, _⟩ :=
    SimpleGraph.TwoConnectedBipartiteSpectrum.rank_two_exact_branch_vertices G htwo hr
  have hcard : Fintype.card (G.neighborSet a) = 3 := by
    rw [G.card_neighborSet_eq_degree, ha]
  let e : Fin 3 ≃ G.neighborSet a := (Fintype.equivFinOfCardEq hcard).symm
  have hpaths : ∀ i : Fin 3, ∃ p : G.Walk a b, p.IsPath ∧ p.snd = (e i).val := by
    intro i
    exact path_with_first_neighbour hab (e i).property (htwo.2 a)
  choose p hp hfirst using hpaths
  have hinj : Function.Injective (fun i => (p i).snd) := by
    intro i j h
    apply e.injective
    apply Subtype.ext
    simpa only [hfirst] using h
  have hsat : ∀ i x, x ∈ interior (p i) → G.degree x ≤ 2 := by
    intro i x hx
    exact (hdeg x hx.2.1 hx.2.2).le
  have hcover := saturated_paths_cover p hp hab hsat (fun y hy => by
    obtain ⟨i, hi⟩ := e.surjective ⟨y, hy⟩
    exact ⟨i, (hfirst i).trans (congrArg Subtype.val hi)⟩) (htwo.2 b)
  refine ⟨a, b, ⟨{
    ends_ne := hab
    path := p
    simple := hp
    first_injective := hinj
    disjoint := ?_
    covers_vertices := hcover.1
    covers_adjacency := hcover.2 }⟩⟩
  intro i j hij
  exact interiors_disjoint_of_snd_ne (p i) (p j) (hp i) (hp j) hab
    (hsat i) (fun h => hij (hinj h))

end E593Theta
