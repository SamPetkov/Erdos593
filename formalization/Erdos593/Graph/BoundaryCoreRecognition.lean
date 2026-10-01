import Erdos593.Graph.FiniteCycleRecognition
import Erdos593.Graph.BoundaryCoreDegreePatterns
import Mathlib.Combinatorics.SimpleGraph.DeleteEdges

/-!
# Cycle recognition and the branch vertices of rank-two canonical cores

Deleting a vertex from a two-vertex-connected graph remains connected.
Counting the remaining edges gives `degree v ≤ cycleRank G + 1`, ruling out
the degree-four alternative in the previously supplied rank-two dichotomy.
No path representation or graph isomorphism is put into a hypothesis.

Candidate source: no kernel acceptance is asserted.
-/

namespace SimpleGraph.TwoConnectedBipartiteSpectrum

open scoped Classical

universe u

/-- Exact Euler balance for the actual vertex-deleted graph.  Both graphs
are connected by two-vertex-connectivity, and no subtraction is treated as
integer subtraction without first proving the required cardinal bounds. -/
theorem delete_vertex_cycleRank_add_degree
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (x : V) :
    SimpleGraph.FiniteCycleRank.cycleRank (G.induce {y : V | y ≠ x}) +
      G.degree x = SimpleGraph.FiniteCycleRank.cycleRank G + 1 := by
  classical
  let D := G.induce {y : V | y ≠ x}
  have hcD : D.Connected := htwo.2 x
  have hcard0 : Nat.card {y : V // y ≠ x} = Nat.card V - 1 := by
    simpa only [Nat.card_eq_fintype_card, Fintype.card_subtype_eq]
      using Fintype.card_subtype_compl (fun y : V => y = x)
  have hn : 3 ≤ Nat.card V := by
    simpa only [Nat.card_eq_fintype_card] using htwo.1
  have hcard : Nat.card {y : V // y ≠ x} + 1 = Nat.card V := by omega
  have hset : ({y : V | y ≠ x} : Set V) = {x}ᶜ := by ext y; simp
  have hedge : Nat.card D.edgeSet = Nat.card G.edgeSet - G.degree x := by
    have hcomp : Nat.card (G.induce ({x}ᶜ : Set V)).edgeSet =
        Nat.card G.edgeSet - G.degree x := by
      have h := (G.card_edgeFinset_induce_compl_singleton x).trans
        (G.card_edgeFinset_deleteIncidenceSet x)
      simpa only [SimpleGraph.edgeFinset_card, ← Nat.card_eq_fintype_card] using h
    exact (congrArg (fun s : Set V => Nat.card (G.induce s).edgeSet) hset).trans hcomp
  have hdeg : G.degree x ≤ Nat.card G.edgeSet := by
    simpa only [SimpleGraph.edgeFinset_card, ← Nat.card_eq_fintype_card]
      using G.degree_le_card_edgeFinset x
  have hED := connected_cycleRank_euler D hcD
  have hEG := connected_cycleRank_euler G (two_connected_connected G htwo)
  change Nat.card D.edgeSet + 1 =
    SimpleGraph.FiniteCycleRank.cycleRank D + Nat.card {y : V // y ≠ x} at hED
  change SimpleGraph.FiniteCycleRank.cycleRank D + G.degree x =
    SimpleGraph.FiniteCycleRank.cycleRank G + 1
  omega

/-- Nonnegativity of the actual deleted-graph rank gives the local degree bound. -/
theorem degree_le_cycleRank_add_one
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (x : V) : G.degree x ≤ SimpleGraph.FiniteCycleRank.cycleRank G + 1 := by
  have h := delete_vertex_cycleRank_add_degree G htwo x
  omega

/-- Equality in the same balance makes the vertex-deleted graph a tree. -/
theorem delete_vertex_isTree_of_degree_eq_cycleRank_add_one
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (x : V) (hd : G.degree x = SimpleGraph.FiniteCycleRank.cycleRank G + 1) :
    (G.induce {y : V | y ≠ x}).IsTree := by
  have h := delete_vertex_cycleRank_add_degree G htwo x
  have hzero : SimpleGraph.FiniteCycleRank.cycleRank
      (G.induce {y : V | y ≠ x}) = 0 := by omega
  exact ⟨htwo.2 x,
    (SimpleGraph.FiniteCycleRank.cycleRank_eq_zero_iff _).mp hzero⟩

/-- The degree-four alternative is impossible in a two-vertex-connected graph
of rank two: exactly two actual vertices have degree three. -/
theorem rank_two_exact_branch_vertices
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 2) :
    ∃ x y : V, x ≠ y ∧ G.degree x = 3 ∧ G.degree y = 3 ∧
      (∀ z : V, z ≠ x → z ≠ y → G.degree z = 2) ∧
      (G.induce {z : V | z ≠ x}).IsTree ∧
      (G.induce {z : V | z ≠ y}).IsTree := by
  classical
  rcases rank_two_degree_pattern G htwo hr with ⟨x, hx, _⟩ | ⟨x, y, hxy, hx, hy, hrest⟩
  · have h := degree_le_cycleRank_add_one G htwo x
    omega
  · refine ⟨x, y, hxy, hx, hy, hrest, ?_, ?_⟩
    · exact delete_vertex_isTree_of_degree_eq_cycleRank_add_one G htwo x (by omega)
    · exact delete_vertex_isTree_of_degree_eq_cycleRank_add_one G htwo y (by omega)

/-- A rank-one two-connected graph is actually isomorphic to the cycle on its
whole carrier, not just known to have a 2-regular degree sequence. -/
theorem rank_one_iso_cycleGraph
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 1) :
    Nonempty (G ≃g SimpleGraph.cycleGraph (Nat.card V)) := by
  classical
  have h := E593Boundary.connected_two_regular_iso_cycleGraph G
    (two_connected_connected G htwo) (rank_one_degree_eq_two G htwo hr)
  have hc : Fintype.card V = Nat.card V := (Nat.card_eq_fintype_card).symm
  exact (congrArg (fun n : ℕ => Nonempty (G ≃g SimpleGraph.cycleGraph n)) hc).mp h

/-- Bipartiteness turns the actual cycle isomorphism into an explicit even-cycle
normal form, with at least four vertices. -/
theorem bipartite_rank_one_even_cycle
    {V : Type u} [Fintype V] (G : SimpleGraph V)
    (htwo : Erdos593.TripleSystem.CanonicalAtom.IsTwoVertexConnected G)
    (hb : G.Colorable 2) (hr : SimpleGraph.FiniteCycleRank.cycleRank G = 1) :
    ∃ t : ℕ, 2 ≤ t ∧ Nat.card V = 2 * t ∧
      Nonempty (G ≃g SimpleGraph.cycleGraph (2 * t)) := by
  obtain ⟨t, ht⟩ := even_order_of_rank_one G htwo hb hr
  have hcard : Nat.card V = 2 * t := by omega
  have hn : 3 ≤ Nat.card V := by simpa only [Nat.card_eq_fintype_card] using htwo.1
  refine ⟨t, by omega, hcard, ?_⟩
  exact (congrArg (fun n : ℕ => Nonempty (G ≃g SimpleGraph.cycleGraph n)) hcard).mp
    (rank_one_iso_cycleGraph G htwo hr)

end SimpleGraph.TwoConnectedBipartiteSpectrum
