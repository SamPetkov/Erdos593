import Erdos593.TripleSystem.Intrinsic
import Erdos593.TripleSystem.OnePointAmalgamation

/-!
# Intrinsic conditions under one-point amalgamation

The canonical one-point amalgamation identifies exactly the two selected roots.
This file proves that the intrinsic structural conditions are preserved by that
operation.
-/

namespace Erdos593

universe u₀ v₀ u₁ v₁

namespace TripleSystem.OnePointAmalgamation

variable {V₀ : Type u₀} {E₀ : Type v₀}
variable {V₁ : Type u₁} {E₁ : Type v₁}

private theorem walk_support_in_side_of_start
    {X : Type*} (G : SimpleGraph X) (A B : Set X) (root : X)
    (hinter : A ∩ B ⊆ {root})
    (hadj : ∀ ⦃x y⦄, G.Adj x y →
      (x ∈ A ∧ y ∈ A) ∨ (x ∈ B ∧ y ∈ B))
    {u v : X} (p : G.Walk u v) (hroot : root ∉ p.support)
    (hu : u ∈ A) : ∀ x ∈ p.support, x ∈ A := by
  induction p <;> simp_all +decide [Set.subset_def]
  grind

private theorem rooted_cycle_support_in_one_of_two_sets
    {X : Type*} (G : SimpleGraph X) (A B : Set X) (root : X)
    (hrootA : root ∈ A) (hrootB : root ∈ B)
    (hinter : A ∩ B ⊆ {root})
    (hadj : ∀ ⦃x y⦄, G.Adj x y →
      (x ∈ A ∧ y ∈ A) ∨ (x ∈ B ∧ y ∈ B))
    (c : G.Walk root root) (hc : c.IsCycle) :
    (∀ x ∈ c.support, x ∈ A) ∨ (∀ x ∈ c.support, x ∈ B) := by
  cases c with
  | nil => exact (hc.not_nil (by simp)).elim
  | cons h p =>
      have hpPath : p.IsPath := (SimpleGraph.Walk.cons_isCycle_iff p h).mp hc |>.1
      have hpNonNil : ¬ p.Nil := by
        intro hp
        exact h.ne hp.eq.symm
      have hdecomp : p.dropLast.support ++ [root] = p.support :=
        p.support_dropLast_concat hpNonNil
      have hrootNot : root ∉ p.dropLast.support := by
        intro hr
        have hn := hpPath.support_nodup
        rw [← hdecomp, List.nodup_append] at hn
        exact (hn.2.2 root hr root (by simp)) rfl
      rcases hadj h with hA | hB
      · left
        intro x hx
        simp only [SimpleGraph.Walk.support_cons, List.mem_cons] at hx
        rcases hx with rfl | hx
        · exact hrootA
        · rw [← hdecomp] at hx
          simp only [List.mem_append, List.mem_singleton] at hx
          rcases hx with hx | rfl
          · exact walk_support_in_side_of_start G A B root hinter hadj
              p.dropLast hrootNot hA.2 x hx
          · exact hrootA
      · right
        intro x hx
        simp only [SimpleGraph.Walk.support_cons, List.mem_cons] at hx
        rcases hx with rfl | hx
        · exact hrootB
        · rw [← hdecomp] at hx
          simp only [List.mem_append, List.mem_singleton] at hx
          rcases hx with hx | rfl
          · exact walk_support_in_side_of_start G B A root
              (by intro x hx; exact hinter ⟨hx.2, hx.1⟩)
              (by intro x y hxy; exact (hadj hxy).symm)
              p.dropLast hrootNot hB.2 x hx
          · exact hrootB

/-- A cycle in a graph obtained by gluing two vertex sets at one root lies
entirely in one of the two sets. -/
theorem cycle_support_in_one_of_two_sets
    {X : Type*} (G : SimpleGraph X) (A B : Set X) (root : X)
    (hrootA : root ∈ A) (hrootB : root ∈ B)
    (hinter : A ∩ B ⊆ {root})
    (hadj : ∀ ⦃x y⦄, G.Adj x y →
      (x ∈ A ∧ y ∈ A) ∨ (x ∈ B ∧ y ∈ B))
    {z : X} (c : G.Walk z z) (hc : c.IsCycle) :
    (∀ x ∈ c.support, x ∈ A) ∨ (∀ x ∈ c.support, x ∈ B) := by
  classical
  by_cases hr : root ∈ c.support
  · let d := c.rotate root hr
    have hd : d.IsCycle := hc.rotate hr
    rcases rooted_cycle_support_in_one_of_two_sets G A B root
        hrootA hrootB hinter hadj d hd with hA | hB
    · left
      intro x hx
      exact hA x ((c.mem_support_rotate_iff root hr).2 hx)
    · right
      intro x hx
      exact hB x ((c.mem_support_rotate_iff root hr).2 hx)
  · cases c with
    | nil => exact (hc.not_nil (by simp)).elim
    | cons h p =>
        rcases hadj h with hA | hB
        · exact Or.inl
            (walk_support_in_side_of_start G A B root hinter hadj
              (.cons h p) hr hA.1)
        · exact Or.inr
            (walk_support_in_side_of_start G B A root
              (by intro x hx; exact hinter ⟨hx.2, hx.1⟩)
              (by intro x y hxy; exact (hadj hxy).symm)
              (.cons h p) hr hB.1)

/-- A cycle supported on the range of a graph embedding lifts to a source
cycle of the same length. -/
theorem cycle_lifts_through_embedding
    {X Y : Type*} {G : SimpleGraph X} {H : SimpleGraph Y}
    (f : G ↪g H) {z : Y} (c : H.Walk z z) (hc : c.IsCycle)
    (hsupp : ∀ y ∈ c.support, y ∈ Set.range f) :
    ∃ (x : X) (d : G.Walk x x), d.IsCycle ∧ c.length = d.length := by
  classical
  let ci := c.induce (Set.range f) hsupp
  let g := f.isoInduceRange
  let d := ci.map g.symm.toHom
  refine ⟨g.symm ⟨z, hsupp z c.start_mem_support⟩, d, ?_, ?_⟩
  · have hmap_ci :
        ci.map (SimpleGraph.Embedding.induce
          (G := H) (Set.range f)).toHom = c := by
      simp [ci]
    have hci : ci.IsCycle := by
      apply SimpleGraph.Walk.IsCycle.of_map
      rw [hmap_ci]
      exact hc
    exact hci.map g.symm.injective
  · have hmap_ci :
        ci.map (SimpleGraph.Embedding.induce
          (G := H) (Set.range f)).toHom = c := by
      simp [ci]
    have hci_len : ci.length = c.length := by
      calc
        ci.length =
            (ci.map (SimpleGraph.Embedding.induce
              (G := H) (Set.range f)).toHom).length := by
          symm
          apply SimpleGraph.Walk.length_map
        _ = c.length := congrArg
          (fun w : H.Walk z z => w.length) hmap_ci
    have hd_len : d.length = ci.length := by simp [d]
    exact hci_len.symm.trans hd_len.symm

/-- The canonical embedding of the left factor's Levi graph into the
amalgamated Levi graph. -/
def leftLeviEmbedding
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁) :
    F₀.levi ↪g (amalgam F₀ F₁ r₀ r₁).levi where
  toFun
    | .inl x => .inl (left r₀ r₁ x)
    | .inr e => .inr (.inl e)
  inj' := by
    rintro (x | e) (y | f) h <;> simp_all
  map_rel_iff' := by
    rintro (x | e) (y | f) <;> simp [amalgam]

/-- The canonical embedding of the right factor's Levi graph into the
amalgamated Levi graph. -/
def rightLeviEmbedding
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁) :
    F₁.levi ↪g (amalgam F₀ F₁ r₀ r₁).levi where
  toFun
    | .inl y => .inl (right r₀ r₁ y)
    | .inr e => .inr (.inr e)
  inj' := by
    rintro (x | e) (y | f) h <;> simp_all
  map_rel_iff' := by
    rintro (x | e) (y | f) <;> simp [amalgam]

/-- One-point amalgamation preserves linearity. -/
theorem amalgam_linear
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁) (h₀ : F₀.Linear) (h₁ : F₁.Linear) :
    (amalgam F₀ F₁ r₀ r₁).Linear := by
  rw [TripleSystem.linear_iff_pairwise_inter_subsingleton]
  intro e f hef
  cases e with
  | inl e =>
      cases f with
      | inl f =>
          intro q hq q' hq'
          rcases hq.1 with ⟨x, hxe, hxq⟩
          rcases hq.2 with ⟨y, hyf, hyq⟩
          rcases hq'.1 with ⟨x', hx'e, hx'q⟩
          rcases hq'.2 with ⟨y', hy'f, hy'q⟩
          have hxy : x = y :=
            left_injective r₀ r₁ (hxq.trans hyq.symm)
          have hxy' : x' = y' :=
            left_injective r₀ r₁ (hx'q.trans hy'q.symm)
          subst y
          subst y'
          have he_ne_f : e ≠ f := by
            intro h
            exact hef (congrArg Sum.inl h)
          have hxx' : x = x' := h₀ he_ne_f hxe hyf hx'e hy'f
          exact hxq.symm.trans ((congrArg (left r₀ r₁) hxx').trans hx'q)
      | inr f =>
          exact cross_image_inter_subsingleton r₀ r₁
            (F₀.edgeSet e) (F₁.edgeSet f)
  | inr e =>
      cases f with
      | inl f =>
          intro q hq q' hq'
          exact cross_image_inter_subsingleton r₀ r₁
            (F₀.edgeSet f) (F₁.edgeSet e) ⟨hq.2, hq.1⟩ ⟨hq'.2, hq'.1⟩
      | inr f =>
          intro q hq q' hq'
          rcases hq.1 with ⟨x, hxe, hxq⟩
          rcases hq.2 with ⟨y, hyf, hyq⟩
          rcases hq'.1 with ⟨x', hx'e, hx'q⟩
          rcases hq'.2 with ⟨y', hy'f, hy'q⟩
          have hxy : x = y :=
            right_injective r₀ r₁ (hxq.trans hyq.symm)
          have hxy' : x' = y' :=
            right_injective r₀ r₁ (hx'q.trans hy'q.symm)
          subst y
          subst y'
          have he_ne_f : e ≠ f := by
            intro h
            exact hef (congrArg Sum.inr h)
          have hxx' : x = x' := h₁ he_ne_f hxe hyf hx'e hy'f
          exact hxq.symm.trans ((congrArg (right r₀ r₁) hxx').trans hx'q)

/-- An actual bridge from the left Levi factor remains an actual bridge after
attaching the right factor at one point. -/
theorem left_bridge_mem_amalgam
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁) {x : V₀} {e : E₀}
    (h : s(Sum.inl x, Sum.inr e) ∈ SimpleGraph.bridgeEdges F₀.levi) :
    s(Sum.inl (left r₀ r₁ x), Sum.inr (Sum.inl e)) ∈
      SimpleGraph.bridgeEdges (amalgam F₀ F₁ r₀ r₁).levi := by
  let pp : Vertex r₀ r₁ → V₀ := lift r₀ r₁ id (fun _ => r₀) rfl
  let p : (Vertex r₀ r₁ ⊕ Edge E₀ E₁) → (V₀ ⊕ E₀)
    | .inl q => .inl (pp q)
    | .inr (.inl f) => .inr f
    | .inr (.inr _) => .inl r₀
  have hp_left (y : V₀) : p (.inl (left r₀ r₁ y)) = .inl y := by
    rfl
  have hp_right (y : V₁) : p (.inl (right r₀ r₁ y)) = .inl r₀ := by
    rfl
  have hpoint_left (q : Vertex r₀ r₁) (f : E₀)
      (hqf : ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
        {s(Sum.inl (left r₀ r₁ x), Sum.inr (Sum.inl e))}).Adj
          (.inl q) (.inr (.inl f))) :
      (F₀.levi.deleteEdges {s(Sum.inl x, Sum.inr e)}).Adj
          (p (.inl q)) (p (.inr (.inl f))) := by
    rw [_root_.SimpleGraph.deleteEdges_adj] at hqf ⊢
    rw [TripleSystem.levi_adj_point_edge] at hqf ⊢
    have hi := hqf.1
    change q ∈ left r₀ r₁ '' F₀.edgeSet f at hi
    rcases hi with ⟨y, hy, rfl⟩
    refine ⟨hy, ?_⟩
    intro heq
    apply hqf.2
    simpa [p, pp, Sym2.eq_iff] using heq
  have hpoint_right (q : Vertex r₀ r₁) (f : E₁)
      (hqf : ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
        {s(Sum.inl (left r₀ r₁ x), Sum.inr (Sum.inl e))}).Adj
          (.inl q) (.inr (.inr f))) :
      p (.inl q) = p (.inr (.inr f)) := by
    rw [_root_.SimpleGraph.deleteEdges_adj,
      TripleSystem.levi_adj_point_edge] at hqf
    have hi := hqf.1
    change q ∈ right r₀ r₁ '' F₁.edgeSet f at hi
    rcases hi with ⟨y, hy, rfl⟩
    rfl
  have hstep : ∀ {a b},
      ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
        {s(Sum.inl (left r₀ r₁ x), Sum.inr (Sum.inl e))}).Adj a b →
      (F₀.levi.deleteEdges {s(Sum.inl x, Sum.inr e)}).Adj (p a) (p b) ∨
        p a = p b := by
    intro a b hab
    rcases a with q | (f | f) <;> rcases b with q' | (g | g)
    · exact False.elim (TripleSystem.not_levi_adj_point_point
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · exact Or.inl (hpoint_left q g hab)
    · exact Or.inr (hpoint_right q g hab)
    · have hr := hpoint_left q' f
          (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges _).adj_comm _ _ |>.mp hab)
      exact Or.inl ((F₀.levi.deleteEdges _).adj_comm _ _ |>.mp hr)
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · exact Or.inr (hpoint_right q' f
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges _).adj_comm _ _ |>.mp hab)).symm
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
  change F₀.levi.Adj (.inl x) (.inr e) ∧
    F₀.levi.IsBridge s(Sum.inl x, Sum.inr e) at h
  change (amalgam F₀ F₁ r₀ r₁).levi.Adj
      (.inl (left r₀ r₁ x)) (.inr (.inl e)) ∧
    (amalgam F₀ F₁ r₀ r₁).levi.IsBridge
      s(Sum.inl (left r₀ r₁ x), Sum.inr (Sum.inl e))
  constructor
  · rw [TripleSystem.levi_adj_point_edge] at h ⊢
    exact (inc_left_left_iff F₀ F₁ r₀ r₁ x e).mpr h.1
  · rw [_root_.SimpleGraph.isBridge_iff] at h ⊢
    intro hab
    apply h.2
    rw [_root_.SimpleGraph.reachable_eq_reflTransGen] at hab ⊢
    have hmap : ∀ {a b}, Relation.ReflTransGen
        ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
          {s(Sum.inl (left r₀ r₁ x), Sum.inr (Sum.inl e))}).Adj a b →
        Relation.ReflTransGen (F₀.levi.deleteEdges
          {s(Sum.inl x, Sum.inr e)}).Adj (p a) (p b) := by
      intro a b hr
      induction hr with
      | refl => exact .refl
      | tail hr hadj ih =>
          rcases hstep hadj with hs | heq
          · exact ih.tail hs
          · simpa [heq] using ih
    simpa [hp_left, p] using hmap hab

/-- An actual bridge from the right Levi factor remains an actual bridge after
attaching the left factor at one point. -/
theorem right_bridge_mem_amalgam
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁) {y : V₁} {e : E₁}
    (h : s(Sum.inl y, Sum.inr e) ∈ SimpleGraph.bridgeEdges F₁.levi) :
    s(Sum.inl (right r₀ r₁ y), Sum.inr (Sum.inr e)) ∈
      SimpleGraph.bridgeEdges (amalgam F₀ F₁ r₀ r₁).levi := by
  let pp : Vertex r₀ r₁ → V₁ := lift r₀ r₁ (fun _ => r₁) id rfl
  let p : (Vertex r₀ r₁ ⊕ Edge E₀ E₁) → (V₁ ⊕ E₁)
    | .inl q => .inl (pp q)
    | .inr (.inl _) => .inl r₁
    | .inr (.inr f) => .inr f
  have hp_left (x : V₀) : p (.inl (left r₀ r₁ x)) = .inl r₁ := by
    rfl
  have hp_right (x : V₁) : p (.inl (right r₀ r₁ x)) = .inl x := by
    rfl
  have hpoint_right (q : Vertex r₀ r₁) (f : E₁)
      (hqf : ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
        {s(Sum.inl (right r₀ r₁ y), Sum.inr (Sum.inr e))}).Adj
          (.inl q) (.inr (.inr f))) :
      (F₁.levi.deleteEdges {s(Sum.inl y, Sum.inr e)}).Adj
          (p (.inl q)) (p (.inr (.inr f))) := by
    rw [_root_.SimpleGraph.deleteEdges_adj] at hqf ⊢
    rw [TripleSystem.levi_adj_point_edge] at hqf ⊢
    have hi := hqf.1
    change q ∈ right r₀ r₁ '' F₁.edgeSet f at hi
    rcases hi with ⟨x, hx, rfl⟩
    refine ⟨hx, ?_⟩
    intro heq
    apply hqf.2
    simpa [p, pp, Sym2.eq_iff] using heq
  have hpoint_left (q : Vertex r₀ r₁) (f : E₀)
      (hqf : ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
        {s(Sum.inl (right r₀ r₁ y), Sum.inr (Sum.inr e))}).Adj
          (.inl q) (.inr (.inl f))) :
      p (.inl q) = p (.inr (.inl f)) := by
    rw [_root_.SimpleGraph.deleteEdges_adj,
      TripleSystem.levi_adj_point_edge] at hqf
    have hi := hqf.1
    change q ∈ left r₀ r₁ '' F₀.edgeSet f at hi
    rcases hi with ⟨x, hx, rfl⟩
    rfl
  have hstep : ∀ {a b},
      ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
        {s(Sum.inl (right r₀ r₁ y), Sum.inr (Sum.inr e))}).Adj a b →
      (F₁.levi.deleteEdges {s(Sum.inl y, Sum.inr e)}).Adj (p a) (p b) ∨
        p a = p b := by
    intro a b hab
    rcases a with q | (f | f) <;> rcases b with q' | (g | g)
    · exact False.elim (TripleSystem.not_levi_adj_point_point
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · exact Or.inr (hpoint_left q g hab)
    · exact Or.inl (hpoint_right q g hab)
    · exact Or.inr (hpoint_left q' f
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges _).adj_comm _ _ |>.mp hab)).symm
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · have hr := hpoint_right q' f
          (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges _).adj_comm _ _ |>.mp hab)
      exact Or.inl ((F₁.levi.deleteEdges _).adj_comm _ _ |>.mp hr)
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
    · exact False.elim (TripleSystem.not_levi_adj_edge_edge
        (F := amalgam F₀ F₁ r₀ r₁)
        (((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges_le _) hab))
  change F₁.levi.Adj (.inl y) (.inr e) ∧
    F₁.levi.IsBridge s(Sum.inl y, Sum.inr e) at h
  change (amalgam F₀ F₁ r₀ r₁).levi.Adj
      (.inl (right r₀ r₁ y)) (.inr (.inr e)) ∧
    (amalgam F₀ F₁ r₀ r₁).levi.IsBridge
      s(Sum.inl (right r₀ r₁ y), Sum.inr (Sum.inr e))
  constructor
  · rw [TripleSystem.levi_adj_point_edge] at h ⊢
    exact (inc_right_right_iff F₀ F₁ r₀ r₁ y e).mpr h.1
  · rw [_root_.SimpleGraph.isBridge_iff] at h ⊢
    intro hab
    apply h.2
    rw [_root_.SimpleGraph.reachable_eq_reflTransGen] at hab ⊢
    have hmap : ∀ {a b}, Relation.ReflTransGen
        ((amalgam F₀ F₁ r₀ r₁).levi.deleteEdges
          {s(Sum.inl (right r₀ r₁ y), Sum.inr (Sum.inr e))}).Adj a b →
        Relation.ReflTransGen (F₁.levi.deleteEdges
          {s(Sum.inl y, Sum.inr e)}).Adj (p a) (p b) := by
      intro a b hr
      induction hr with
      | refl => exact .refl
      | tail hr hadj ih =>
          rcases hstep hadj with hs | heq
          · exact ih.tail hs
          · simpa [heq] using ih
    simpa [hp_right, p] using hmap hab

/-- The intrinsic bridge condition is preserved by one-point amalgamation. -/
theorem amalgam_bridgeAtEveryEdge
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁)
    (h₀ : F₀.BridgeAtEveryEdge) (h₁ : F₁.BridgeAtEveryEdge) :
    (amalgam F₀ F₁ r₀ r₁).BridgeAtEveryEdge := by
  intro e
  cases e with
  | inl e =>
      rcases h₀ e with ⟨x, hx⟩
      exact ⟨left r₀ r₁ x, left_bridge_mem_amalgam F₀ F₁ r₀ r₁ hx⟩
  | inr e =>
      rcases h₁ e with ⟨y, hy⟩
      exact ⟨right r₀ r₁ y, right_bridge_mem_amalgam F₀ F₁ r₀ r₁ hy⟩

/-- Divisibility by four of every Levi-cycle length is preserved by one-point
amalgamation. -/
theorem amalgam_evenBergeCycles
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁)
    (h₀ : F₀.EvenBergeCycles) (h₁ : F₁.EvenBergeCycles) :
    (amalgam F₀ F₁ r₀ r₁).EvenBergeCycles := by
  intro z c hc
  let f₀ := leftLeviEmbedding F₀ F₁ r₀ r₁
  let f₁ := rightLeviEmbedding F₀ F₁ r₀ r₁
  let A : Set (Vertex r₀ r₁ ⊕ Edge E₀ E₁) := Set.range f₀
  let B : Set (Vertex r₀ r₁ ⊕ Edge E₀ E₁) := Set.range f₁
  let root : Vertex r₀ r₁ ⊕ Edge E₀ E₁ := .inl (left r₀ r₁ r₀)
  have hrootA : root ∈ A := by
    exact ⟨.inl r₀, rfl⟩
  have hrootB : root ∈ B := by
    refine ⟨.inl r₁, ?_⟩
    exact congrArg Sum.inl (root_eq r₀ r₁).symm
  have hinter : A ∩ B ⊆ {root} := by
    rintro w ⟨⟨a, rfl⟩, ⟨b, hb⟩⟩
    rcases a with x | e <;> rcases b with y | f
    all_goals
      simp [f₀, f₁, root, leftLeviEmbedding,
        rightLeviEmbedding] at hb ⊢ <;> aesop
  have hadj : ∀ ⦃a b⦄, (amalgam F₀ F₁ r₀ r₁).levi.Adj a b →
      (a ∈ A ∧ b ∈ A) ∨ (a ∈ B ∧ b ∈ B) := by
    intro a b hab
    rcases a with q | (e | e)
    · rcases b with q' | (f | f)
      · exact ((amalgam F₀ F₁ r₀ r₁).not_levi_adj_point_point hab).elim
      · have hi := (amalgam F₀ F₁ r₀ r₁).levi_adj_point_edge.mp hab
        change q ∈ left r₀ r₁ '' F₀.edgeSet f at hi
        rcases hi with ⟨x, hx, rfl⟩
        exact Or.inl ⟨⟨.inl x, rfl⟩, ⟨.inr f, rfl⟩⟩
      · have hi := (amalgam F₀ F₁ r₀ r₁).levi_adj_point_edge.mp hab
        change q ∈ right r₀ r₁ '' F₁.edgeSet f at hi
        rcases hi with ⟨y, hy, rfl⟩
        exact Or.inr ⟨⟨.inl y, rfl⟩, ⟨.inr f, rfl⟩⟩
    · rcases b with q' | (f | f)
      · have hi := (amalgam F₀ F₁ r₀ r₁).levi_adj_edge_point.mp hab
        change q' ∈ left r₀ r₁ '' F₀.edgeSet e at hi
        rcases hi with ⟨x, hx, rfl⟩
        exact Or.inl ⟨⟨.inr e, rfl⟩, ⟨.inl x, rfl⟩⟩
      · exact ((amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge hab).elim
      · exact ((amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge hab).elim
    · rcases b with q' | (f | f)
      · have hi := (amalgam F₀ F₁ r₀ r₁).levi_adj_edge_point.mp hab
        change q' ∈ right r₀ r₁ '' F₁.edgeSet e at hi
        rcases hi with ⟨y, hy, rfl⟩
        exact Or.inr ⟨⟨.inr e, rfl⟩, ⟨.inl y, rfl⟩⟩
      · exact ((amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge hab).elim
      · exact ((amalgam F₀ F₁ r₀ r₁).not_levi_adj_edge_edge hab).elim
  rcases cycle_support_in_one_of_two_sets
      (amalgam F₀ F₁ r₀ r₁).levi A B root
      hrootA hrootB hinter hadj c hc with hsupp | hsupp
  · rcases cycle_lifts_through_embedding f₀ c hc hsupp with ⟨x, d, hd, hlen⟩
    rw [hlen]
    exact h₀ d hd
  · rcases cycle_lifts_through_embedding f₁ c hc hsupp with ⟨y, d, hd, hlen⟩
    rw [hlen]
    exact h₁ d hd

/-- All three intrinsic conditions are preserved by one-point amalgamation. -/
theorem amalgam_intrinsic
    (F₀ : TripleSystem V₀ E₀) (F₁ : TripleSystem V₁ E₁)
    (r₀ : V₀) (r₁ : V₁) (h₀ : F₀.Intrinsic) (h₁ : F₁.Intrinsic) :
    (amalgam F₀ F₁ r₀ r₁).Intrinsic := by
  exact ⟨amalgam_linear F₀ F₁ r₀ r₁ h₀.1 h₁.1,
    amalgam_bridgeAtEveryEdge F₀ F₁ r₀ r₁ h₀.2.1 h₁.2.1,
    amalgam_evenBergeCycles F₀ F₁ r₀ r₁ h₀.2.2 h₁.2.2⟩

end TripleSystem.OnePointAmalgamation
end Erdos593
