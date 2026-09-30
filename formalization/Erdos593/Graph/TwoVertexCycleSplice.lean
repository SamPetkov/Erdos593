import Erdos593.Graph.EdgeCycleBlocks

namespace Erdos593
namespace SimpleGraph

set_option autoImplicit false

/-!
# Publication refinement: two-vertex cycle splicing

This module isolates the first missing kernel for the cycle-block intersection
theorem.  It does not define quotient incidence, prove the singleton chord
case, construct the block-cut forest, or specialize to a contracted graph.
-/

/-- If two simple cycles contain the same two distinct vertices, then any
chosen edge of the first and any chosen edge of the second lie on a common
simple cycle. -/
theorem edgesOnCommonCycle_of_cycles_share_two_vertices
    {V : Type*} (G : _root_.SimpleGraph V)
    {e g : G.edgeSet} {x y v₁ v₂ : V}
    {c₁ : G.Walk v₁ v₁} {c₂ : G.Walk v₂ v₂}
    (hc₁ : c₁.IsCycle) (hc₂ : c₂.IsCycle)
    (hxy : x ≠ y)
    (hx₁ : x ∈ c₁.support) (hy₁ : y ∈ c₁.support)
    (hx₂ : x ∈ c₂.support) (hy₂ : y ∈ c₂.support)
    (he : e.1 ∈ c₁.edges) (hg : g.1 ∈ c₂.edges) :
    EdgesOnCommonCycle G e g := by
  open _root_.SimpleGraph in
  classical
  by_cases he2 : e.1 ∈ c₂.edges
  · exact ⟨v₂, c₂, hc₂, he2, hg⟩
  -- A walk of length one consists of exactly one edge, joining its endpoints.
  have hlen1 : ∀ {a b : V} (w : G.Walk a b), w.length = 1 → w.edges = [s(a, b)] := by
    intro a b w hw
    cases w with
    | nil => simp at hw
    | cons hadj w' =>
      have hw' : w'.length = 0 := by simpa using hw
      cases w' with
      | nil => simp
      | cons _ _ => simp at hw'
  -- Two internally disjoint paths with the same endpoints glue to a cycle.
  have glue : ∀ {a b : V} (q : G.Walk a b) (R : G.Walk b a), q.IsPath → R.IsPath → a ≠ b →
      (∀ z ∈ q.support, z ∈ R.support → z = a ∨ z = b) → 3 ≤ q.length + R.length →
      (q.append R).IsCycle := by
    intro a b q R hq hR hab hdisj h3
    cases q with
    | nil => exact absurd rfl hab
    | cons hadj q' =>
      rw [Walk.cons_append, Walk.isCycle_iff_isPath_tail_and_le_length]
      have hq' := (Walk.cons_isPath_iff _ _).mp hq
      constructor
      · have key : (q'.append R).IsPath := by
          rw [Walk.isPath_def, Walk.support_append, List.nodup_append]
          refine ⟨hq'.1.support_nodup, hR.support_nodup.tail, ?_⟩
          intro z hz w hw
          rintro rfl
          have hzR : z ∈ R.support := by
            rw [← R.cons_tail_support]
            exact List.mem_cons_of_mem _ hw
          have hzq : z ∈ (Walk.cons hadj q').support := by
            rw [Walk.support_cons]
            exact List.mem_cons_of_mem _ hz
          rcases hdisj z hzq hzR with rfl | rfl
          · exact hq'.2 hz
          · have hnotin : z ∉ R.support.tail := by
              have hnd := hR.support_nodup
              rw [← R.cons_tail_support, List.nodup_cons] at hnd
              exact hnd.1
            exact hnotin hw
        simpa using key
      · simp only [Walk.length_cons, Walk.length_append] at h3 ⊢
        omega
  -- Extraction of a segment meeting the support of `c₂` only at its endpoints.
  have extract : ∀ (n : ℕ) {a b : V} (p : G.Walk a b), p.length ≤ n → p.IsPath →
      a ∈ c₂.support → b ∈ c₂.support → e.1 ∈ p.edges →
      ∃ (a' b' : V) (q : G.Walk a' b'), q.IsPath ∧ a' ∈ c₂.support ∧ b' ∈ c₂.support ∧
        e.1 ∈ q.edges ∧ ∀ z ∈ q.support, z ∈ c₂.support → z = a' ∨ z = b' := by
    intro n
    induction n using Nat.strong_induction_on with
    | _ n ih =>
      intro a b p hpn hp ha hb hep
      by_cases hall : ∀ z ∈ p.support, z ∈ c₂.support → z = a ∨ z = b
      · exact ⟨a, b, p, hp, ha, hb, hep, hall⟩
      · replace hall : ∃ m, m ∈ p.support ∧ m ∈ c₂.support ∧ m ≠ a ∧ m ≠ b := by
          by_contra hcon
          refine hall (fun z hz hzS => ?_)
          by_contra hz2
          exact hcon ⟨z, hz, hzS, fun h => hz2 (Or.inl h), fun h => hz2 (Or.inr h)⟩
        obtain ⟨m, hmp, hmS, hma, hmb⟩ := hall
        have hspec := p.take_spec hmp
        have hlen : (p.takeUntil m hmp).length + (p.dropUntil m hmp).length = p.length := by
          rw [← Walk.length_append, hspec]
        have ht1 : 1 ≤ (p.takeUntil m hmp).length := by
          rcases Nat.eq_zero_or_pos (p.takeUntil m hmp).length with h0 | h0
          · exact absurd (Walk.eq_of_length_eq_zero h0).symm hma
          · exact h0
        have hd1 : 1 ≤ (p.dropUntil m hmp).length := by
          rcases Nat.eq_zero_or_pos (p.dropUntil m hmp).length with h0 | h0
          · exact absurd (Walk.eq_of_length_eq_zero h0) hmb
          · exact h0
        have hedge : e.1 ∈ (p.takeUntil m hmp).edges ∨ e.1 ∈ (p.dropUntil m hmp).edges := by
          rw [← hspec, Walk.edges_append, List.mem_append] at hep
          exact hep
        rcases hedge with h | h
        · exact ih (p.takeUntil m hmp).length (by omega) _ le_rfl (hp.takeUntil hmp) ha hmS h
        · exact ih (p.dropUntil m hmp).length (by omega) _ le_rfl (hp.dropUntil hmp) hmS hb h
  -- A path containing `e` whose endpoints lie on `c₂`.
  obtain ⟨α, β, P, hP, hα, hβ, heP⟩ :
      ∃ (α β : V) (P : G.Walk α β), P.IsPath ∧ α ∈ c₂.support ∧ β ∈ c₂.support ∧
        e.1 ∈ P.edges := by
    have hcr : (c₁.rotate x hx₁).IsCycle := hc₁.rotate hx₁
    have her : e.1 ∈ (c₁.rotate x hx₁).edges := ((c₁.rotate_edges x hx₁).mem_iff).mpr he
    have hyr : y ∈ (c₁.rotate x hx₁).support := (Walk.mem_support_rotate_iff _ _ _).mpr hy₁
    have hspec := (c₁.rotate x hx₁).take_spec hyr
    have hedge : e.1 ∈ ((c₁.rotate x hx₁).takeUntil y hyr).edges ∨
        e.1 ∈ ((c₁.rotate x hx₁).dropUntil y hyr).edges := by
      rw [← hspec, Walk.edges_append, List.mem_append] at her
      exact her
    rcases hedge with h | h
    · exact ⟨x, y, _, hcr.isPath_takeUntil hyr, hx₂, hy₂, h⟩
    · refine ⟨y, x, _, ?_, hy₂, hx₂, h⟩
      have hcr' : (((c₁.rotate x hx₁).takeUntil y hyr).append
          ((c₁.rotate x hx₁).dropUntil y hyr)).IsCycle := by rw [hspec]; exact hcr
      exact hcr'.isPath_of_append_right (Walk.not_nil_of_ne hxy)
  obtain ⟨a, b, q, hq, ha, hb, heq, hqS⟩ := extract P.length P le_rfl hP hα hβ heP
  have hqlen : 1 ≤ q.length := by
    have h1 : q.edges ≠ [] := List.ne_nil_of_mem heq
    have h2 : q.edges.length = q.length := q.length_edges
    have h3 : q.edges.length ≠ 0 := fun h => h1 (List.eq_nil_of_length_eq_zero h)
    omega
  have hab : a ≠ b := by
    rintro rfl
    have h0 : q.length = 0 := (Walk.length_eq_zero_iff).mpr (Walk.isPath_iff_nil.mp hq)
    omega
  -- Gluing an arc of `c₂` through `g` onto the extracted segment.
  have final : ∀ (R : G.Walk b a), R.IsPath → g.1 ∈ R.edges →
      (∀ z ∈ R.support, z ∈ c₂.support) → (∀ z ∈ R.edges, z ∈ c₂.edges) →
      ∃ v : V, ∃ c : G.Walk v v, c.IsCycle ∧ e.1 ∈ c.edges ∧ g.1 ∈ c.edges := by
    intro R hR hgR hRS hRE
    have hRlen : 1 ≤ R.length := by
      rcases Nat.eq_zero_or_pos R.length with h0 | h0
      · exact absurd (Walk.eq_of_length_eq_zero h0) (Ne.symm hab)
      · exact h0
    refine ⟨a, q.append R, glue q R hq hR hab (fun z hz hz2 => hqS z hz (hRS z hz2)) ?_, ?_, ?_⟩
    · by_contra hcon
      have hq1 : q.length = 1 := by omega
      have hR1 : R.length = 1 := by omega
      have hqe : q.edges = [s(a, b)] := hlen1 q hq1
      have hRe : R.edges = [s(b, a)] := hlen1 R hR1
      rw [hqe, List.mem_singleton] at heq
      have : e.1 ∈ R.edges := by rw [hRe, heq, Sym2.eq_swap]; exact List.mem_singleton_self _
      exact he2 (hRE _ this)
    · rw [Walk.edges_append, List.mem_append]; exact Or.inl heq
    · rw [Walk.edges_append, List.mem_append]; exact Or.inr hgR
  have hcr : (c₂.rotate a ha).IsCycle := hc₂.rotate ha
  have hgr : g.1 ∈ (c₂.rotate a ha).edges := ((c₂.rotate_edges a ha).mem_iff).mpr hg
  have hbr : b ∈ (c₂.rotate a ha).support := (Walk.mem_support_rotate_iff _ _ _).mpr hb
  have hsuppr : ∀ z ∈ (c₂.rotate a ha).support, z ∈ c₂.support :=
    fun z hz => (Walk.mem_support_rotate_iff _ _ _).mp hz
  have hedgesr : ∀ z ∈ (c₂.rotate a ha).edges, z ∈ c₂.edges :=
    fun z hz => ((c₂.rotate_edges a ha).mem_iff).mp hz
  have hspec := (c₂.rotate a ha).take_spec hbr
  have hedge : g.1 ∈ ((c₂.rotate a ha).takeUntil b hbr).edges ∨
      g.1 ∈ ((c₂.rotate a ha).dropUntil b hbr).edges := by
    rw [← hspec, Walk.edges_append, List.mem_append] at hgr
    exact hgr
  rcases hedge with h | h
  · refine final ((c₂.rotate a ha).takeUntil b hbr).reverse ?_ ?_ ?_ ?_
    · exact (Walk.isPath_reverse_iff _).mpr (hcr.isPath_takeUntil hbr)
    · rw [Walk.edges_reverse, List.mem_reverse]; exact h
    · intro z hz
      rw [Walk.support_reverse, List.mem_reverse] at hz
      exact hsuppr z (Walk.support_takeUntil_subset_support _ _ hz)
    · intro z hz
      rw [Walk.edges_reverse, List.mem_reverse] at hz
      exact hedgesr z (Walk.edges_takeUntil_subset_edges _ _ hz)
  · refine final ((c₂.rotate a ha).dropUntil b hbr) ?_ ?_ ?_ ?_
    · have hcr' : (((c₂.rotate a ha).takeUntil b hbr).append
          ((c₂.rotate a ha).dropUntil b hbr)).IsCycle := by rw [hspec]; exact hcr
      exact hcr'.isPath_of_append_right (Walk.not_nil_of_ne hab)
    · exact h
    · intro z hz
      exact hsuppr z (Walk.support_dropUntil_subset_support _ _ hz)
    · intro z hz
      exact hedgesr z (Walk.edges_dropUntil_subset_edges _ _ hz)

end SimpleGraph
end Erdos593
