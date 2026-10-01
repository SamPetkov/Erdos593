import Mathlib.Combinatorics.SimpleGraph.Connectivity.Subgraph
import Mathlib.Data.Set.Card
import Mathlib.Tactic

/-!
# Separation of simple paths with saturated internal vertices

The conclusions concern actual walks and actual subgraph adjacency. In
particular, a degree pattern is not used as the definition of a theta graph.
Candidate source; pinned elaboration and transitive-axiom replay remain required.
-/

namespace E593Theta

open SimpleGraph

universe u

variable {V : Type u} [Fintype V] [DecidableEq V]
variable {G : SimpleGraph V} [DecidableRel G.Adj]
variable {a b : V}

/-- The interior of an actual walk excludes both named endpoints. -/
def interior (p : G.Walk a b) : Set V :=
  {x | x ∈ p.support ∧ x ≠ a ∧ x ≠ b}

omit [DecidableEq V] in
/-- On an internal vertex of a simple path, ambient degree at most two
forces every ambient edge there to belong to the path. -/
theorem internal_adjacency_saturated (p : G.Walk a b) (hp : p.IsPath)
    {x : V} (hx : x ∈ interior p) (hd : G.degree x ≤ 2) (y : V) :
    p.toSubgraph.Adj x y ↔ G.Adj x y := by
  classical
  obtain ⟨i, hi, hil⟩ := (Walk.mem_support_iff_exists_getVert).mp hx.1
  have hi0 : i ≠ 0 := by
    intro h
    subst i
    exact hx.2.1 (by simpa using hi.symm)
  have hilt : i < p.length := by
    by_contra h
    have he : i = p.length := by omega
    subst i
    exact hx.2.2 (by simpa using hi.symm)
  have hlocal : (p.toSubgraph.neighborSet x).ncard = 2 := by
    rw [← hi]
    exact hp.ncard_neighborSet_toSubgraph_internal_eq_two hi0 hilt
  have hamb : (G.neighborSet x).ncard ≤ 2 := by
    rw [← Nat.card_coe_set_eq, Nat.card_eq_fintype_card,
      G.card_neighborSet_eq_degree]
    exact hd
  have heq : p.toSubgraph.neighborSet x = G.neighborSet x :=
    Set.eq_of_subset_of_ncard_le (p.toSubgraph.neighborSet_subset x)
      (by omega) (Set.toFinite _)
  change y ∈ p.toSubgraph.neighborSet x ↔ y ∈ G.neighborSet x
  rw [heq]

omit [Fintype V] [DecidableRel G.Adj] in
/-- A path ending at b cannot enter a set through a saturated vertex away
from a and b, when it starts outside and never visits a. This is the only
walk induction needed for separation of the theta branches. -/
theorem path_avoids_saturated_interior
    (p : G.Walk a b)
    (hsat : ∀ x, x ∈ interior p → ∀ y, G.Adj x y → y ∈ p.support)
    {u : V} (q : G.Walk u b) (hq : q.IsPath)
    (ha : a ∉ q.support) (hu : u ∉ p.support ∨ u = b) :
    ∀ x, x ∈ q.support → x ∈ p.support → x = b := by
  -- Quantify the comparison path after the walk being inducted on. This
  -- keeps its endpoint dependence explicit in the induction hypothesis.
  have avoid : ∀ {u v : V} (q : G.Walk u v) (p : G.Walk a v),
      (∀ x, x ∈ interior p → ∀ y, G.Adj x y → y ∈ p.support) →
      q.IsPath → a ∉ q.support → (u ∉ p.support ∨ u = v) →
      ∀ x, x ∈ q.support → x ∈ p.support → x = v := by
    intro u v q
    induction q with
    | nil =>
        intro p _ _ _ _ x hx _
        simpa using hx
    | @cons u w v huw q ih =>
        intro p hsat hq ha hu
        have hparts := (Walk.cons_isPath_iff huw q).mp hq
        have huv : u ≠ v := by
          intro h
          exact hparts.2 (h.symm ▸ q.end_mem_support)
        have huout : u ∉ p.support := hu.resolve_right huv
        have haw : a ∉ q.support := by
          intro h
          exact ha (by simp only [Walk.support_cons, List.mem_cons]; exact Or.inr h)
        have hw : w ∉ p.support ∨ w = v := by
          by_cases hwv : w = v
          · exact Or.inr hwv
          · left
            intro hwp
            have hwa : w ≠ a := by
              intro h
              exact haw (h ▸ q.start_mem_support)
            exact huout (hsat w ⟨hwp, hwa, hwv⟩ u huw.symm)
        intro x hx hxp
        rw [Walk.support_cons, List.mem_cons] at hx
        rcases hx with rfl | hx
        · exact (huout hxp).elim
        · exact ih p hsat hparts.1 haw hw x hx hxp
  exact avoid q p hsat hq ha hu

/-- Distinct first neighbours give internally vertex-disjoint simple a-b
paths when the first path's internal vertices have degree at most two. -/
theorem interiors_disjoint_of_snd_ne
    (p q : G.Walk a b) (hp : p.IsPath) (hq : q.IsPath)
    (hab : a ≠ b)
    (hd : ∀ x, x ∈ interior p → G.degree x ≤ 2)
    (hsnd : p.snd ≠ q.snd) :
    Disjoint (interior p) (interior q) := by
  classical
  have hqn : ¬ q.Nil := Walk.not_nil_of_ne hab
  have hsat : ∀ x, x ∈ interior p → ∀ y, G.Adj x y → y ∈ p.support := by
    intro x hx y hxy
    exact Walk.mem_support_of_adj_toSubgraph
      ((internal_adjacency_saturated p hp hx (hd x hx) y).mpr hxy).symm
  have ha : a ∉ q.tail.support := by
    have hnd := hq.support_nodup
    rw [← Walk.cons_support_tail hqn, List.nodup_cons] at hnd
    exact hnd.1
  have hstart : q.snd ∉ p.support ∨ q.snd = b := by
    by_cases hqb : q.snd = b
    · exact Or.inr hqb
    · left
      intro hmem
      have hqa : q.snd ≠ a := (q.adj_snd hqn).ne.symm
      have hqaPath : p.toSubgraph.Adj q.snd a :=
        (internal_adjacency_saturated p hp ⟨hmem, hqa, hqb⟩
          (hd q.snd ⟨hmem, hqa, hqb⟩) a).mpr (q.adj_snd hqn).symm
      exact hsnd (hp.snd_of_toSubgraph_adj hqaPath.symm)
  have havoid := path_avoids_saturated_interior p hsat q.tail hq.tail ha hstart
  apply Set.disjoint_left.mpr
  intro x hxp hxq
  have hxTail : x ∈ q.tail.support := by
    have hx := hxq.1
    rw [← Walk.cons_support_tail hqn, List.mem_cons] at hx
    exact hx.resolve_left hxq.2.1
  exact hxq.2.2 (havoid x hxTail hxp.1)

/-- Vertex and edge coverage for a family of a-b paths. Neighbours at a
are represented by the first steps; all other vertices except b are
saturated. Connectivity after deletion of b rules out a missing component.
This lemma works for any nonempty index family, not only three paths. -/
theorem saturated_paths_cover
    {I : Type*} [Nonempty I]
    (p : I → G.Walk a b) (hp : ∀ i, (p i).IsPath) (hab : a ≠ b)
    (hsat : ∀ i x, x ∈ interior (p i) → G.degree x ≤ 2)
    (hfirst : ∀ y, G.Adj a y → ∃ i, (p i).snd = y)
    (hconn : (G.induce {x : V | x ≠ b}).Connected) :
    (∀ x : V, ∃ i, x ∈ (p i).support) ∧
      (∀ x y : V, G.Adj x y ↔ ∃ i, (p i).toSubgraph.Adj x y) := by
  classical
  let S : Set V := {x | ∃ i, x ∈ (p i).support}
  have haS : a ∈ S := ⟨Classical.choice inferInstance, (p _).start_mem_support⟩
  have hbS : b ∈ S := ⟨Classical.choice inferInstance, (p _).end_mem_support⟩
  have hstep : ∀ x y, x ∈ S → x ≠ b → G.Adj x y →
      ∃ i, (p i).toSubgraph.Adj x y := by
    intro x y hx hxb hxy
    by_cases hxa : x = a
    · subst x
      obtain ⟨i, hi⟩ := hfirst y hxy
      exact ⟨i, hi ▸ (p i).toSubgraph_adj_snd (Walk.not_nil_of_ne hab)⟩
    · obtain ⟨i, hi⟩ := hx
      exact ⟨i, (internal_adjacency_saturated (p i) (hp i)
        ⟨hi, hxa, hxb⟩ (hsat i x ⟨hi, hxa, hxb⟩) y).mpr hxy⟩
  have hclosed : ∀ x y : {z : V // z ≠ b},
      x.val ∈ S → (G.induce {z : V | z ≠ b}).Adj x y → y.val ∈ S := by
    intro x y hx hxy
    obtain ⟨i, hi⟩ := hstep x.val y.val hx x.property hxy
    exact ⟨i, Walk.mem_support_of_adj_toSubgraph hi.symm⟩
  have hwalk : ∀ x y : {z : V // z ≠ b},
      (G.induce {z : V | z ≠ b}).Walk x y → x.val ∈ S → y.val ∈ S := by
    intro x y w
    induction w with
    | nil => exact id
    | cons h _ ih => exact fun hx => ih (hclosed _ _ hx h)
  have hall : ∀ x : V, x ∈ S := by
    intro x
    by_cases hxb : x = b
    · exact hxb.symm ▸ hbS
    · obtain ⟨w⟩ := hconn.preconnected ⟨a, hab⟩ ⟨x, hxb⟩
      exact hwalk _ _ w haS
  refine ⟨hall, ?_⟩
  intro x y
  constructor
  · intro hxy
    by_cases hxb : x = b
    · obtain ⟨i, hi⟩ := hstep y x (hall y) (by
        intro h
        exact hxy.ne (hxb.trans h.symm)) hxy.symm
      exact ⟨i, hi.symm⟩
    · exact hstep x y (hall x) hxb hxy
  · rintro ⟨i, hi⟩
    exact (p i).toSubgraph.adj_sub hi

end E593Theta
