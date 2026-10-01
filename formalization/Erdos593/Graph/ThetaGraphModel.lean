import Erdos593.Graph.ThetaPathData
import Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic

/-!
# The length-parametrized theta graph and its actual isomorphism

The model below depends only on three natural lengths. Its vertices are two
endpoints and tagged internal positions; adjacency is consecutive-position
adjacency. It does not depend on an ambient graph or its degree pattern.
-/

namespace E593Theta

open SimpleGraph

universe u

/-- Two branch vertices and the interior positions on each of three paths. -/
abbrev Vertex (r : Fin 3 → ℕ) := Bool ⊕ ((i : Fin 3) × Fin (r i - 1))

/-- Position t on branch i. Values zero and r_i are the common endpoints. -/
def point (r : Fin 3 → ℕ) (i : Fin 3) (t : Fin (r i + 1)) : Vertex r :=
  if h0 : t.val = 0 then .inl false
  else if he : t.val = r i then .inl true
  else .inr ⟨i, ⟨t.val - 1, by have := t.isLt; omega⟩⟩

/-- The ordinary simple graph consisting of three chains with common endpoints.
The explicit inequality enforces looplessness even for degenerate input lengths;
the recognition theorem supplies strictly positive lengths. -/
def thetaGraph (r : Fin 3 → ℕ) : SimpleGraph (Vertex r) where
  Adj x y := x ≠ y ∧ ∃ (i : Fin 3) (j : Fin (r i)),
    s(point r i j.castSucc, point r i j.succ) = s(x, y)
  symm.symm x y h := by
    obtain ⟨hxy, i, j, hj⟩ := h
    exact ⟨hxy.symm, i, j, hj.trans Sym2.eq_swap⟩
  loopless.irrefl x h := h.1 rfl

namespace ThreePaths

variable {V : Type u} [Fintype V] [DecidableEq V]
variable {G : SimpleGraph V} [DecidableRel G.Adj] {a b : V}
variable (P : ThreePaths G a b)

/-- Actual edge lengths of the three constructed paths. -/
def lengths (i : Fin 3) : ℕ := (P.path i).length

/-- Evaluate theta coordinates at the actual vertices on the paths. -/
def realize : Vertex P.lengths → V
  | .inl false => a
  | .inl true => b
  | .inr ⟨i, j⟩ => (P.path i).getVert (j.val + 1)

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- Internal positions are genuinely internal; they cannot collapse to an end. -/
theorem internal_position (i : Fin 3) (j : Fin (P.lengths i - 1)) :
    (P.path i).getVert (j.val + 1) ∈ interior (P.path i) := by
  have hj : j.val + 1 < (P.path i).length := by
    have := j.isLt
    change j.val < (P.path i).length - 1 at this
    omega
  refine ⟨(P.path i).getVert_mem_support _, ?_, ?_⟩
  · intro h
    have heq : (P.path i).getVert (j.val + 1) = (P.path i).getVert 0 := by
      simpa using h
    have he := (P.simple i).getVert_injOn
      (by change j.val + 1 ≤ (P.path i).length; omega)
      (by change 0 ≤ (P.path i).length; omega) heq
    omega
  · intro h
    have heq : (P.path i).getVert (j.val + 1) =
        (P.path i).getVert (P.path i).length := by simpa using h
    have he := (P.simple i).getVert_injOn
      (by change j.val + 1 ≤ (P.path i).length; omega)
      (by change (P.path i).length ≤ (P.path i).length; rfl) heq
    omega

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- Coordinate evaluation is injective, using path simplicity and the proved
pairwise disjointness of interiors. -/
theorem realize_injective : Function.Injective P.realize := by
  rintro (c | ⟨i, j⟩) (d | ⟨i', j'⟩) h
  · cases c <;> cases d
    · rfl
    · exact (P.ends_ne h).elim
    · exact (P.ends_ne h.symm).elim
    · rfl
  · cases c
    · exact ((P.internal_position i' j').2.1 h.symm).elim
    · exact ((P.internal_position i' j').2.2 h.symm).elim
  · cases d
    · exact ((P.internal_position i j).2.1 h).elim
    · exact ((P.internal_position i j).2.2 h).elim
  · have hii : i = i' := by
      by_contra hne
      have hi := P.internal_position i j
      have hj := P.internal_position i' j'
      change (P.path i).getVert (j.val + 1) =
        (P.path i').getVert (j'.val + 1) at h
      exact Set.disjoint_left.mp (P.disjoint i i' hne) hi (h.symm ▸ hj)
    subst i'
    have heq : (P.path i).getVert (j.val + 1) =
        (P.path i).getVert (j'.val + 1) := h
    have hj := j.isLt
    have hj' := j'.isLt
    change j.val < (P.path i).length - 1 at hj
    change j'.val < (P.path i).length - 1 at hj'
    have hval := (P.simple i).getVert_injOn
      (by change j.val + 1 ≤ (P.path i).length; omega)
      (by change j'.val + 1 ≤ (P.path i).length; omega) heq
    have he : j = j' := Fin.ext (by omega)
    subst j'
    rfl

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- Exact vertex coverage supplies surjectivity onto the original carrier. -/
theorem realize_surjective : Function.Surjective P.realize := by
  intro x
  by_cases hxa : x = a
  · exact ⟨.inl false, hxa.symm⟩
  by_cases hxb : x = b
  · exact ⟨.inl true, hxb.symm⟩
  obtain ⟨i, hix⟩ := P.covers_vertices x
  obtain ⟨j, hj, hjl⟩ := Walk.mem_support_iff_exists_getVert.mp hix
  have hj0 : j ≠ 0 := by
    intro h
    subst j
    exact hxa (by simpa using hj.symm)
  have hjlt : j < (P.path i).length := by
    by_contra h
    have he : j = (P.path i).length := by omega
    subst j
    exact hxb (by simpa using hj.symm)
  refine ⟨.inr ⟨i, ⟨j - 1, by change j - 1 < (P.path i).length - 1; omega⟩⟩, ?_⟩
  change (P.path i).getVert (j - 1 + 1) = x
  simpa only [Nat.sub_add_cancel (by omega : 1 ≤ j)] using hj

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- All endpoint and internal positions evaluate to the corresponding walk vertex. -/
theorem realize_point (i : Fin 3) (t : Fin (P.lengths i + 1)) :
    P.realize (point P.lengths i t) = (P.path i).getVert t.val := by
  unfold point
  split_ifs with h0 he
  · simp [realize, h0]
  · simp [realize, he, lengths]
  · change (P.path i).getVert (t.val - 1 + 1) = (P.path i).getVert t.val
    rw [Nat.sub_add_cancel (by omega : 1 ≤ t.val)]

/-- A genuine graph isomorphism: the original graph and the fixed length model
have exactly the same edges, not just the same degree sequence or counts. -/
noncomputable def modelIso : thetaGraph P.lengths ≃g G where
  toEquiv := Equiv.ofBijective P.realize ⟨P.realize_injective, P.realize_surjective⟩
  map_rel_iff' := by
    intro x y
    change G.Adj (P.realize x) (P.realize y) ↔
      x ≠ y ∧ ∃ (i : Fin 3) (j : Fin (P.lengths i)),
        s(point P.lengths i j.castSucc, point P.lengths i j.succ) = s(x, y)
    constructor
    · intro hxy
      obtain ⟨i, hi⟩ := (P.covers_adjacency _ _).mp hxy
      obtain ⟨j, hj, hlt⟩ := (P.path i).toSubgraph_adj_iff.mp hi
      refine ⟨fun h => hxy.ne (congrArg P.realize h), i, ⟨j, hlt⟩, ?_⟩
      apply Sym2.map.injective P.realize_injective
      simp only [Sym2.map_mk, P.realize_point]
      exact hj
    · rintro ⟨_, i, j, hj⟩
      have hmap := congrArg (Sym2.map P.realize) hj
      simp only [Sym2.map_mk, P.realize_point] at hmap
      change s((P.path i).getVert j.val, (P.path i).getVert (j.val + 1)) =
        s(P.realize x, P.realize y) at hmap
      have hadj : G.Adj ((P.path i).getVert j.val) ((P.path i).getVert (j.val + 1)) :=
        (P.path i).toSubgraph.adj_sub ((P.path i).toSubgraph_adj_getVert j.isLt)
      change s(P.realize x, P.realize y) ∈ G.edgeSet
      rw [← hmap]
      exact hadj

omit [DecidableEq V] [DecidableRel G.Adj] in
/-- The sum of the three edge lengths is exactly one more than the number
of original vertices. This uses the actual coordinate bijection. -/
theorem sum_lengths : (∑ i : Fin 3, P.lengths i) = Nat.card V + 1 := by
  classical
  have hcard : Nat.card V = 2 + ∑ i : Fin 3, (P.lengths i - 1) := by
    calc
      Nat.card V = Fintype.card V := Nat.card_eq_fintype_card
      _ = Fintype.card (Vertex P.lengths) := (Fintype.card_congr P.modelIso.toEquiv).symm
      _ = 2 + ∑ i : Fin 3, (P.lengths i - 1) := by simp [Vertex]
  have hsum : (∑ i : Fin 3, P.lengths i) =
      (∑ i : Fin 3, (P.lengths i - 1)) + 3 := by
    calc
      _ = ∑ i : Fin 3, ((P.lengths i - 1) + 1) := by
        apply Finset.sum_congr rfl
        intro i _
        have := P.length_pos i
        change (P.path i).length = (P.path i).length - 1 + 1
        omega
      _ = _ := by simp only [Finset.sum_add_distrib]; simp
  omega

end ThreePaths

variable {V : Type u} [Fintype V] [DecidableEq V]
variable {G : SimpleGraph V} [DecidableRel G.Adj]

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- Two-colouring determines the parity of every actual walk. -/
theorem two_colour_walk_parity (c : G.Coloring (Fin 2))
    {x y : V} (p : G.Walk x y) : Even p.length ↔ c x = c y := by
  induction p with
  | nil => simp
  | @cons x z y hxz p ih =>
      have hne : c x ≠ c z := c.valid hxz
      have htwo : ∀ x z y : Fin 2, x ≠ z → (x = y ↔ z ≠ y) := by decide
      simpa only [Walk.length_cons, Nat.even_add_one, ih] using (htwo _ _ _ hne).symm

omit [DecidableEq V] [DecidableRel G.Adj] in
/-- Odd order in the bipartite rank-two case forces every branch length even. -/
theorem ThreePaths.even_lengths_of_odd_card {a b : V} (P : ThreePaths G a b)
    (hb : G.Colorable 2) (hodd : Odd (Nat.card V)) :
    ∀ i : Fin 3, Even (P.lengths i) := by
  obtain ⟨c⟩ := hb
  have hpar : ∀ i j : Fin 3, Even (P.lengths i) ↔ Even (P.lengths j) := by
    intro i j
    exact (two_colour_walk_parity c (P.path i)).trans
      (two_colour_walk_parity c (P.path j)).symm
  have hsum := P.sum_lengths
  have hsum3 : P.lengths 0 + (P.lengths 1 + (P.lengths 2 + 0)) = Nat.card V + 1 := by
    simpa [Fin.sum_univ_succ] using hsum
  have hzero : Even (P.lengths 0) := by
    by_contra h0
    have h1 : ¬Even (P.lengths 1) := fun h => h0 ((hpar 0 1).mpr h)
    have h2 : ¬Even (P.lengths 2) := fun h => h0 ((hpar 0 2).mpr h)
    rw [Nat.even_iff] at h0 h1 h2
    rw [Nat.odd_iff] at hodd
    omega
  exact fun i => (hpar 0 i).mp hzero

end E593Theta
