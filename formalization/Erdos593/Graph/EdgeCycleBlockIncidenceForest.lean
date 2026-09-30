import Erdos593.Graph.EdgeCycleBlockIntersection
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceForestOrder

namespace Erdos593
namespace SimpleGraph

set_option autoImplicit false

namespace EdgeCycleBlock

/-!
# The quotient cycle-block incidence forest

This module exposes the bipartite graph whose left vertices are quotient
cycle blocks and whose right vertices are graph vertices.  Its acyclicity is
the next graph-theoretic seam after the welded two-vertex block-intersection
theorem.  Contracted-graph specialization and canonical atom packaging remain
separate downstream obligations.
-/

/-- The representative-independent block/point incidence graph. -/
def incidenceGraph {V : Type*} (G : _root_.SimpleGraph V) :
    _root_.SimpleGraph (EdgeCycleBlock G ⊕ V) :=
  _root_.SimpleGraph.bipartiteIncidenceGraph
    (fun B v => Incident G v B)

@[simp]
theorem incidenceGraph_adj_inl_inr_iff {V : Type*}
    (G : _root_.SimpleGraph V) (B : EdgeCycleBlock G) (v : V) :
    (incidenceGraph G).Adj (.inl B) (.inr v) ↔ Incident G v B := by
  simp [incidenceGraph]

@[simp]
theorem incidenceGraph_adj_inr_inl_iff {V : Type*}
    (G : _root_.SimpleGraph V) (B : EdgeCycleBlock G) (v : V) :
    (incidenceGraph G).Adj (.inr v) (.inl B) ↔ Incident G v B := by
  simp [incidenceGraph]

/-- Quotient cycle blocks and their incident vertices form a forest. -/
theorem incidenceGraph_isAcyclic {V : Type*}
    (G : _root_.SimpleGraph V) :
    (incidenceGraph G).IsAcyclic := by
  open _root_.SimpleGraph in
  classical
  have mem_edge_of_mem_support {a b : V} (p : G.Walk a b) {w : V} (hw : w ∈ p.support) :
      w = b ∨ ∃ e ∈ p.edges, w ∈ e := by
    induction p with
    | nil => left; simpa using hw
    | @cons a' m b' h q ih =>
        rw [Walk.support_cons, List.mem_cons] at hw
        rcases hw with rfl | hw'
        · exact Or.inr ⟨s(w, m), by simp, by simp⟩
        · rcases ih hw' with h1 | ⟨e, he, hwe⟩
          · exact Or.inl h1
          · exact Or.inr ⟨e, by simp [he], hwe⟩

  have exists_mem_edges_of_mem_support {a b : V} (p : G.Walk a b) (hne : p.length ≠ 0) {u : V}
      (hu : u ∈ p.support) : ∃ e ∈ p.edges, u ∈ e := by
    induction p with
    | nil => simp at hne
    | @cons a' m b' h q ih =>
      rw [Walk.support_cons, List.mem_cons] at hu
      rcases hu with rfl | hu
      · exact ⟨s(u, m), by simp, by simp⟩
      · rcases mem_edge_of_mem_support q hu with rfl | ⟨e, he, hue⟩
        · rcases Nat.eq_zero_or_pos q.length with h0 | h0
          · have hm : m = u := Walk.eq_of_length_eq_zero h0
            subst hm
            exact ⟨s(a', m), by simp, by simp⟩
          · obtain ⟨e, he, hue⟩ := ih (by omega) hu
            exact ⟨e, by simp [he], hue⟩
        · exact ⟨e, by simp [he], hue⟩

  have exists_block_path {B : EdgeCycleBlock G} {x y : V} (hxy : x ≠ y)
      (hx : Incident G x B) (hy : Incident G y B) :
      ∃ p : G.Walk x y, p.IsPath ∧ (∀ e : G.edgeSet, e.1 ∈ p.edges → ofEdge G e = B) ∧
        (∀ w ∈ p.support, Incident G w B) := by
    classical
    obtain ⟨e, heB, hxe⟩ := (incident_iff_exists_endpoint G).1 hx
    obtain ⟨f, hfB, hyf⟩ := (incident_iff_exists_endpoint G).1 hy
    change ofEdge G e = B at heB
    change ofEdge G f = B at hfB
    have hef : EdgeCycleLinked G e f := (ofEdge_eq_iff G).1 (heB.trans hfB.symm)
    rcases hef with rfl | ⟨w, c, hc, hec, hfc⟩
    · have hexy : (e : Sym2 V) = s(x, y) := (Sym2.mem_and_mem_iff hxy).1 ⟨hxe, hyf⟩
      have hadj : G.Adj x y := by
        have he2 := e.2
        rw [hexy] at he2
        exact he2
      refine ⟨Walk.cons hadj Walk.nil, ?_, ?_, ?_⟩
      · simp [Walk.isPath_def, hxy]
      · intro g hg
        simp only [Walk.edges_cons, Walk.edges_nil, List.mem_singleton] at hg
        have : g = e := Subtype.ext (hg.trans hexy.symm)
        rw [this]; exact heB
      · intro u hu
        simp only [Walk.support_cons, Walk.support_nil, List.mem_cons] at hu
        rcases hu with rfl | hu
        · exact hx
        · rcases hu with rfl | hu
          · exact hy
          · exact absurd hu (List.not_mem_nil)
    · have hxc : x ∈ c.support := c.mem_support_of_mem_edges hec hxe
      have hyc : y ∈ c.support := c.mem_support_of_mem_edges hfc hyf
      have hc' : (c.rotate x hxc).IsCycle := hc.rotate hxc
      have hyc' : y ∈ (c.rotate x hxc).support := (Walk.mem_support_rotate_iff _ _ _).mpr hyc
      have hedges : ∀ z : Sym2 V, z ∈ (c.rotate x hxc).edges → z ∈ c.edges :=
        fun z hz => ((c.rotate_edges x hxc).mem_iff).mp hz
      have hsupp : ∀ z : V, z ∈ (c.rotate x hxc).support → z ∈ c.support :=
        fun z hz => (Walk.mem_support_rotate_iff _ _ _).mp hz
      refine ⟨(c.rotate x hxc).takeUntil y hyc', hc'.isPath_takeUntil hyc', ?_, ?_⟩
      · intro g hg
        have hgc : (g : Sym2 V) ∈ c.edges :=
          hedges _ (Walk.edges_takeUntil_subset_edges _ _ hg)
        have : EdgeCycleLinked G g e := Or.inr ⟨w, c, hc, hgc, hec⟩
        exact ((ofEdge_eq_iff G).2 this).trans heB
      · intro u hu
        have huc : u ∈ c.support :=
          hsupp _ (Walk.support_takeUntil_subset_support _ _ hu)
        have hcne : c.length ≠ 0 := by
          intro h0
          exact hc.ne_nil (Walk.eq_nil_iff_nil.mpr (Walk.length_eq_zero_iff.mp h0))
        obtain ⟨g, hgc, hug⟩ := exists_mem_edges_of_mem_support c hcne huc
        have hgE : g ∈ G.edgeSet := c.edges_subset_edgeSet hgc
        have : EdgeCycleLinked G ⟨g, hgE⟩ e := Or.inr ⟨w, c, hc, hgc, hec⟩
        refine incident_of_mem_endpoint G (e := ⟨g, hgE⟩) ?_ hug
        change ofEdge G ⟨g, hgE⟩ = B
        exact ((ofEdge_eq_iff G).2 this).trans heB

  have exists_last_mem {P : V → Prop} {a b : V} (p : G.Walk a b)
      (h : ∃ u ∈ p.support, P u) :
      ∃ (z : V) (q : G.Walk z b), P z ∧ (∀ u ∈ q.support, u ≠ z → ¬ P u) ∧
        (∀ u ∈ q.support, u ∈ p.support) := by
    classical
    induction p with
    | @nil a' =>
        obtain ⟨u, hu, hPu⟩ := h
        simp only [Walk.support_nil, List.mem_singleton] at hu
        subst hu
        exact ⟨u, Walk.nil, hPu, by simp, by simp⟩
    | @cons a' m b' hadj q ih =>
        by_cases hq : ∃ u ∈ q.support, P u
        · obtain ⟨z, r, hz, hr, hsub⟩ := ih hq
          exact ⟨z, r, hz, hr, fun u hu => by
            rw [Walk.support_cons, List.mem_cons]
            exact Or.inr (hsub u hu)⟩
        · push Not at hq
          obtain ⟨u, hu, hPu⟩ := h
          rw [Walk.support_cons, List.mem_cons] at hu
          have hPa : P a' := by
            rcases hu with rfl | hu
            · exact hPu
            · exact absurd hPu (hq u hu)
          refine ⟨a', Walk.cons hadj q, hPa, ?_, fun u hu => hu⟩
          intro u hu hune
          rw [Walk.support_cons, List.mem_cons] at hu
          rcases hu with rfl | hu
          · exact absurd rfl hune
          · exact hq u hu

  have no_external_link {B C : EdgeCycleBlock G} {v x y : V} (W : G.Walk x y)
      (hBC : B ≠ C) (hvB : Incident G v B) (hvC : Incident G v C)
      (hxB : Incident G x B) (hyC : Incident G y C)
      (hvW : v ∉ W.support) : False := by
    classical
    have hshare : ∀ w : V, Incident G w B → Incident G w C → w = v := by
      intro w hwB hwC
      by_contra hwv
      exact hBC (eq_of_incident_two_vertices G hwv hwB hvB hwC hvC)
    obtain ⟨z, W₂, hzB, hW₂B, hW₂sub⟩ :=
      exists_last_mem (P := fun u => Incident G u B) W ⟨x, W.start_mem_support, hxB⟩
    obtain ⟨u, R, huC, hRC, hRsub⟩ :=
      exists_last_mem (P := fun w => Incident G w C) W₂.reverse
        ⟨y, by rw [Walk.support_reverse, List.mem_reverse]; exact W₂.end_mem_support, hyC⟩
    set W₃ : G.Walk z u := R.reverse with hW₃
    have hW₃sub : ∀ w ∈ W₃.support, w ∈ W₂.support := by
      intro w hw
      rw [hW₃, Walk.support_reverse, List.mem_reverse] at hw
      have := hRsub w hw
      rwa [Walk.support_reverse, List.mem_reverse] at this
    have hW₃C : ∀ w ∈ W₃.support, w ≠ u → ¬ Incident G w C := by
      intro w hw hwu
      refine hRC w ?_ hwu
      rw [hW₃, Walk.support_reverse, List.mem_reverse] at hw
      exact hw
    have hW₃W : ∀ w ∈ W₃.support, w ∈ W.support := fun w hw => hW₂sub w (hW₃sub w hw)
    have hzv : z ≠ v := by
      intro h
      exact hvW (h ▸ hW₂sub z W₂.start_mem_support)
    have huv : u ≠ v := by
      intro h
      exact hvW (h ▸ hW₃W u W₃.end_mem_support)
    have hzu : z ≠ u := by
      intro h
      subst h
      exact hzv (hshare z hzB huC)
    -- the two block paths
    obtain ⟨P₁, hP₁path, hP₁edge, hP₁supp⟩ :=
      exists_block_path (B := B) (Ne.symm hzv) hvB hzB
    obtain ⟨P₂, hP₂path, hP₂edge, hP₂supp⟩ :=
      exists_block_path (B := C) huv huC hvC
    set W₄ : G.Walk z u := W₃.bypass with hW₄
    have hW₄path : W₄.IsPath := W₃.bypass_isPath
    have hW₄sub : ∀ w ∈ W₄.support, w ∈ W₃.support := fun w hw =>
      Walk.support_bypass_subset_support _ hw
    have hW₄B : ∀ w ∈ W₄.support, w ≠ z → ¬ Incident G w B := fun w hw hwz =>
      hW₂B w (hW₃sub w (hW₄sub w hw)) hwz
    have hW₄C : ∀ w ∈ W₄.support, w ≠ u → ¬ Incident G w C := fun w hw hwu =>
      hW₃C w (hW₄sub w hw) hwu
    have hP₁len : P₁.length ≠ 0 := fun h => hzv (Walk.eq_of_length_eq_zero h).symm
    have hP₂len : P₂.length ≠ 0 := fun h => huv (Walk.eq_of_length_eq_zero h)
    have hW₄len : W₄.length ≠ 0 := fun h => hzu (Walk.eq_of_length_eq_zero h)
    -- `P₁` and `W₄` meet only at `z`
    have hmeet₁ : ∀ w ∈ P₁.support, w ∈ W₄.support → w = z := by
      intro w hw hw'
      by_contra hwz
      exact hW₄B w hw' hwz (hP₁supp w hw)
    have hq : (P₁.append W₄).IsPath := by
      rw [Walk.isPath_def, Walk.support_append, List.nodup_append]
      refine ⟨hP₁path.support_nodup, hW₄path.support_nodup.tail, ?_⟩
      intro w hw w' hw'
      rintro rfl
      have hwW₄ : w ∈ W₄.support := by
        rw [← W₄.cons_tail_support]
        exact List.mem_cons_of_mem _ hw'
      have hwz : w = z := hmeet₁ w hw hwW₄
      subst hwz
      have hnot : w ∉ W₄.support.tail := by
        have hnd := hW₄path.support_nodup
        rw [← W₄.cons_tail_support, List.nodup_cons] at hnd
        exact hnd.1
      exact hnot hw'
    have hdisj : ((P₁.append W₄).support.tail).Disjoint (P₂.support.tail) := by
      intro w hw hw'
      have hwC : Incident G w C := hP₂supp w (List.mem_of_mem_tail hw')
      rw [Walk.tail_support_append, List.mem_append] at hw
      rcases hw with hw | hw
      · have hwB : Incident G w B := hP₁supp w (List.mem_of_mem_tail hw)
        have hwv : w = v := hshare w hwB hwC
        subst hwv
        have hvnot : w ∉ P₁.support.tail := by
          have hnd := hP₁path.support_nodup
          rw [← P₁.cons_tail_support, List.nodup_cons] at hnd
          exact hnd.1
        exact hvnot hw
      · have hwW₄ : w ∈ W₄.support := List.mem_of_mem_tail hw
        have hwu : w = u := by
          by_contra hwu
          exact hW₄C w hwW₄ hwu hwC
        subst hwu
        have hunot : w ∉ P₂.support.tail := by
          have hnd := hP₂path.support_nodup
          rw [← P₂.cons_tail_support, List.nodup_cons] at hnd
          exact hnd.1
        exact hunot hw'
    have hcyc : ((P₁.append W₄).append P₂).IsCycle := by
      refine hq.isCycle_append hP₂path hdisj ?_
      left
      rw [Walk.length_append]
      omega
    obtain ⟨e, heP₁, -⟩ := exists_mem_edges_of_mem_support P₁ hP₁len P₁.start_mem_support
    obtain ⟨f, hfP₂, -⟩ := exists_mem_edges_of_mem_support P₂ hP₂len P₂.start_mem_support
    have heE : e ∈ G.edgeSet := P₁.edges_subset_edgeSet heP₁
    have hfE : f ∈ G.edgeSet := P₂.edges_subset_edgeSet hfP₂
    have heD : e ∈ ((P₁.append W₄).append P₂).edges := by
      rw [Walk.edges_append, Walk.edges_append]
      exact List.mem_append_left _ (List.mem_append_left _ heP₁)
    have hfD : f ∈ ((P₁.append W₄).append P₂).edges := by
      rw [Walk.edges_append]
      exact List.mem_append_right _ hfP₂
    have hlink : EdgeCycleLinked G ⟨e, heE⟩ ⟨f, hfE⟩ :=
      Or.inr ⟨v, (P₁.append W₄).append P₂, hcyc, heD, hfD⟩
    have hB : ofEdge G ⟨e, heE⟩ = B := hP₁edge ⟨e, heE⟩ heP₁
    have hC : ofEdge G ⟨f, hfE⟩ = C := hP₂edge ⟨f, hfE⟩ hfP₂
    exact hBC (hB.symm.trans (((ofEdge_eq_iff G).2 hlink).trans hC))

  have incidence_adj_inr {a : V} {w : EdgeCycleBlock G ⊕ V}
      (h : (incidenceGraph G).Adj (Sum.inr a) w) :
      ∃ B : EdgeCycleBlock G, w = Sum.inl B ∧ Incident G a B := by
    cases w with
    | inl B => exact ⟨B, rfl, (incidenceGraph_adj_inr_inl_iff G B a).1 h⟩
    | inr b => simp [incidenceGraph, _root_.SimpleGraph.bipartiteIncidenceGraph] at h

  have incidence_adj_inl {B : EdgeCycleBlock G} {w : EdgeCycleBlock G ⊕ V}
      (h : (incidenceGraph G).Adj (Sum.inl B) w) :
      ∃ a : V, w = Sum.inr a ∧ Incident G a B := by
    cases w with
    | inl C => simp [incidenceGraph, _root_.SimpleGraph.bipartiteIncidenceGraph] at h
    | inr a => exact ⟨a, rfl, (incidenceGraph_adj_inl_inr_iff G B a).1 h⟩

  have exists_walk_of_incidence_walk (v₀ : V) :
      ∀ (n : ℕ) (a b : V) (w : (incidenceGraph G).Walk (Sum.inr a) (Sum.inr b)),
        w.length ≤ n → a ≠ v₀ →
        (∀ B : EdgeCycleBlock G, (Sum.inl B : EdgeCycleBlock G ⊕ V) ∈ w.support →
          ¬ Incident G v₀ B) →
        ∃ W : G.Walk a b, v₀ ∉ W.support := by
    intro n
    induction n using Nat.strong_induction_on with
    | _ n ih =>
      intro a b w hlen ha hblocks
      by_cases hab : a = b
      · subst hab
        refine ⟨Walk.nil, ?_⟩
        simp only [Walk.support_nil, List.mem_singleton]
        exact fun h => ha h.symm
      · have hne : (Sum.inr a : EdgeCycleBlock G ⊕ V) ≠ Sum.inr b := by
          simpa using hab
        obtain ⟨p₁, h₁, w₁, rfl⟩ := w.exists_eq_cons_of_ne hne
        obtain ⟨B, rfl, haB⟩ := incidence_adj_inr h₁
        have hne₂ : (Sum.inl B : EdgeCycleBlock G ⊕ V) ≠ Sum.inr b := by simp
        obtain ⟨p₂, h₂, w₂, rfl⟩ := w₁.exists_eq_cons_of_ne hne₂
        obtain ⟨a₂, rfl, ha₂B⟩ := incidence_adj_inl h₂
        have hB : ¬ Incident G v₀ B := by
          refine hblocks B ?_
          simp
        have ha₂ : a₂ ≠ v₀ := by
          intro h
          exact hB (h ▸ ha₂B)
        have hlen₂ : w₂.length < n := by
          simp only [Walk.length_cons] at hlen
          omega
        have hblocks₂ : ∀ C : EdgeCycleBlock G,
            (Sum.inl C : EdgeCycleBlock G ⊕ V) ∈ w₂.support → ¬ Incident G v₀ C := by
          intro C hC
          refine hblocks C ?_
          simp only [Walk.support_cons, List.mem_cons]
          exact Or.inr (Or.inr hC)
        obtain ⟨W₂, hW₂⟩ := ih w₂.length hlen₂ a₂ b w₂ le_rfl ha₂ hblocks₂
        by_cases haa : a = a₂
        · subst haa
          exact ⟨W₂, hW₂⟩
        · obtain ⟨P, -, -, hPsupp⟩ := exists_block_path (B := B) haa haB ha₂B
          refine ⟨P.append W₂, ?_⟩
          rw [Walk.support_append, List.mem_append]
          rintro (hv | hv)
          · exact hB (hPsupp v₀ hv)
          · exact hW₂ (List.mem_of_mem_tail hv)


  have hlen1 : ∀ {a b : EdgeCycleBlock G ⊕ V} (w : (incidenceGraph G).Walk a b),
      w.length = 1 → w.edges = [s(a, b)] := by
    intro a b w hw
    cases w with
    | nil => simp at hw
    | cons hadj w' =>
        have hw' : w'.length = 0 := by simpa using hw
        cases w' with
        | nil => simp
        | cons _ _ => simp at hw'
  suffices H : ∀ (n : ℕ) (t : EdgeCycleBlock G ⊕ V) (c : (incidenceGraph G).Walk t t),
      c.length ≤ n → ¬ c.IsCycle by
    intro t c hc
    exact H c.length t c le_rfl hc
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
  intro t c hlen hc
  obtain ⟨v₁, hv₁⟩ : ∃ v : V, (Sum.inr v : EdgeCycleBlock G ⊕ V) ∈ c.support := by
    cases t with
    | inr v => exact ⟨v, c.start_mem_support⟩
    | inl B =>
        obtain ⟨X, hadj, c', hc'⟩ := Walk.not_nil_iff.mp hc.not_nil
        obtain ⟨a, rfl, -⟩ := incidence_adj_inl hadj
        refine ⟨a, ?_⟩
        rw [hc', Walk.support_cons, List.mem_cons]
        exact Or.inr c'.start_mem_support
  obtain ⟨c₁, hc₁cyc, hchord⟩ :
      ∃ c₁ : (incidenceGraph G).Walk (Sum.inr v₁) (Sum.inr v₁),
        c₁.IsCycle ∧
        ∀ B : EdgeCycleBlock G, (Sum.inl B : EdgeCycleBlock G ⊕ V) ∈ c₁.support →
          Incident G v₁ B →
          s((Sum.inr v₁ : EdgeCycleBlock G ⊕ V), Sum.inl B) ∈ c₁.edges := by
    refine ⟨c.rotate (Sum.inr v₁) hv₁, hc.rotate hv₁, ?_⟩
    · intro B hB hinc
      by_contra hcon
      have hadj : (incidenceGraph G).Adj (Sum.inr v₁) (Sum.inl B) :=
        (incidenceGraph_adj_inr_inl_iff G B v₁).2 hinc
      have hne : (Sum.inr v₁ : EdgeCycleBlock G ⊕ V) ≠ Sum.inl B := by simp
      have hcrot : (c.rotate (Sum.inr v₁) hv₁).IsCycle := hc.rotate hv₁
      have hspec := (c.rotate (Sum.inr v₁) hv₁).take_spec hB
      have hcyc' : (((c.rotate (Sum.inr v₁) hv₁).takeUntil _ hB).append
          ((c.rotate (Sum.inr v₁) hv₁).dropUntil _ hB)).IsCycle := by
        rw [hspec]; exact hcrot
      have hqpath : ((c.rotate (Sum.inr v₁) hv₁).dropUntil _ hB).IsPath :=
        hcyc'.isPath_of_append_right (Walk.not_nil_of_ne hne)
      have hqedges : s((Sum.inr v₁ : EdgeCycleBlock G ⊕ V), Sum.inl B) ∉
          ((c.rotate (Sum.inr v₁) hv₁).dropUntil _ hB).edges := fun hmem =>
        hcon (Walk.edges_dropUntil_subset_edges _ _ hmem)
      have hnew : (Walk.cons hadj ((c.rotate (Sum.inr v₁) hv₁).dropUntil _ hB)).IsCycle :=
        (Walk.cons_isCycle_iff _ hadj).2 ⟨hqpath, hqedges⟩
      have hsum : ((c.rotate (Sum.inr v₁) hv₁).takeUntil _ hB).length +
          ((c.rotate (Sum.inr v₁) hv₁).dropUntil _ hB).length = (c.rotate (Sum.inr v₁) hv₁).length := by
        rw [← Walk.length_append, hspec]
      have hrotlen : (c.rotate (Sum.inr v₁) hv₁).length = c.length := by
        have hperm : (c.rotate (Sum.inr v₁) hv₁).edges.length = c.edges.length :=
          ((c.rotate_edges (Sum.inr v₁) hv₁).perm).length_eq
        rw [Walk.length_edges, Walk.length_edges] at hperm
        exact hperm
      have hp2 : 2 ≤ ((c.rotate (Sum.inr v₁) hv₁).takeUntil _ hB).length := by
        by_contra h2
        have hcases : ((c.rotate (Sum.inr v₁) hv₁).takeUntil (Sum.inl B) hB).length = 0 ∨
            ((c.rotate (Sum.inr v₁) hv₁).takeUntil (Sum.inl B) hB).length = 1 := by omega
        rcases hcases with h0 | h0
        · exact hne (Walk.eq_of_length_eq_zero h0)
        · refine hcon (Walk.edges_takeUntil_subset_edges (c.rotate (Sum.inr v₁) hv₁) hB ?_)
          rw [hlen1 _ h0]
          exact List.mem_singleton_self _
      refine ih (Walk.cons hadj ((c.rotate (Sum.inr v₁) hv₁).dropUntil _ hB)).length ?_ _ _ le_rfl hnew
      rw [Walk.length_cons]
      omega
  obtain ⟨X, hA, t₁, hc₁eq⟩ := Walk.not_nil_iff.mp hc₁cyc.not_nil
  obtain ⟨B₂, rfl, hB₂v₁⟩ := incidence_adj_inr hA
  subst hc₁eq
  have hneB₂ : (Sum.inl B₂ : EdgeCycleBlock G ⊕ V) ≠ Sum.inr v₁ := by simp
  obtain ⟨Y, hBadj, t₂, ht₁eq⟩ := t₁.exists_eq_cons_of_ne hneB₂
  obtain ⟨v₂, rfl, hB₂v₂⟩ := incidence_adj_inl hBadj
  subst ht₁eq
  have hpath : (Walk.cons hBadj t₂).IsPath := ((Walk.cons_isCycle_iff _ hA).1 hc₁cyc).1
  obtain ⟨ht₂path, hB₂notin⟩ := (Walk.cons_isPath_iff hBadj t₂).1 hpath
  have hv₁v₂ : v₁ ≠ v₂ := by
    intro h
    subst h
    have hnil : t₂.Nil := Walk.isPath_iff_nil.mp ht₂path
    have h3 := hc₁cyc.three_le_length
    rw [Walk.length_cons, Walk.length_cons] at h3
    have hl0 : t₂.length = 0 := Walk.length_eq_zero_iff.mpr hnil
    omega
  have hrpath : t₂.reverse.IsPath := (Walk.isPath_reverse_iff t₂).mpr ht₂path
  have hner : (Sum.inr v₁ : EdgeCycleBlock G ⊕ V) ≠ Sum.inr v₂ := by
    simp only [ne_eq, Sum.inr.injEq]
    exact hv₁v₂
  obtain ⟨Z, hC, r₁, hreq⟩ := t₂.reverse.exists_eq_cons_of_ne hner
  obtain ⟨B₁, rfl, hB₁v₁⟩ := incidence_adj_inr hC
  have hneB₁ : (Sum.inl B₁ : EdgeCycleBlock G ⊕ V) ≠ Sum.inr v₂ := by simp
  obtain ⟨Z', hD, r₂, hr₁eq⟩ := r₁.exists_eq_cons_of_ne hneB₁
  obtain ⟨vn, rfl, hB₁vn⟩ := incidence_adj_inl hD
  subst hr₁eq
  have hrpath' : (Walk.cons hC (Walk.cons hD r₂)).IsPath := by
    rw [← hreq]; exact hrpath
  obtain ⟨hr₁path, hv₁notin⟩ := (Walk.cons_isPath_iff hC _).1 hrpath'
  obtain ⟨-, hB₁notin⟩ := (Walk.cons_isPath_iff hD r₂).1 hr₁path
  have hmemt₂ : ∀ w : EdgeCycleBlock G ⊕ V, w ∈ r₂.support → w ∈ t₂.support := by
    intro w hw
    have hw' : w ∈ (Walk.cons hC (Walk.cons hD r₂)).support := by
      simp only [Walk.support_cons, List.mem_cons]
      exact Or.inr (Or.inr hw)
    rw [← hreq, Walk.support_reverse, List.mem_reverse] at hw'
    exact hw'
  have hvn : vn ≠ v₁ := by
    intro h
    refine hv₁notin ?_
    simp only [Walk.support_cons, List.mem_cons]
    exact Or.inr (h ▸ r₂.start_mem_support)
  have hB₁B₂ : B₁ ≠ B₂ := by
    intro h
    subst h
    refine hB₂notin ?_
    have hw' : (Sum.inl B₁ : EdgeCycleBlock G ⊕ V) ∈
        (Walk.cons hC (Walk.cons hD r₂)).support := by
      simp
    rw [← hreq, Walk.support_reverse, List.mem_reverse] at hw'
    exact hw'
  have hkey : ∀ B : EdgeCycleBlock G, (Sum.inl B : EdgeCycleBlock G ⊕ V) ∈ r₂.support →
      ¬ Incident G v₁ B := by
    intro B hBmem hinc
    have hBt₂ : (Sum.inl B : EdgeCycleBlock G ⊕ V) ∈ t₂.support := hmemt₂ _ hBmem
    have hBc₁ : (Sum.inl B : EdgeCycleBlock G ⊕ V) ∈
        (Walk.cons hA (Walk.cons hBadj t₂)).support := by
      simp only [Walk.support_cons, List.mem_cons]
      exact Or.inr (Or.inr hBt₂)
    have hedge := hchord B hBc₁ hinc
    rw [Walk.edges_cons, Walk.edges_cons, List.mem_cons, List.mem_cons] at hedge
    rcases hedge with h | h | h
    · have hBB₂ : B = B₂ := by
        rcases Sym2.eq_iff.1 h with ⟨-, h2⟩ | ⟨h1, -⟩
        · exact (Sum.inl.injEq _ _ ▸ h2 : B = B₂)
        · exact absurd h1 (by simp)
      subst hBB₂
      exact hB₂notin hBt₂
    · rcases Sym2.eq_iff.1 h with ⟨h1, -⟩ | ⟨h1, -⟩
      · exact absurd h1 (by simp)
      · exact hv₁v₂ (by simpa using h1)
    · have hr : s((Sum.inr v₁ : EdgeCycleBlock G ⊕ V), Sum.inl B) ∈
          (Walk.cons hC (Walk.cons hD r₂)).edges := by
        rw [← hreq, Walk.edges_reverse, List.mem_reverse]
        exact h
      rw [Walk.edges_cons, Walk.edges_cons, List.mem_cons, List.mem_cons] at hr
      rcases hr with h' | h' | h'
      · have hBB₁ : B = B₁ := by
          rcases Sym2.eq_iff.1 h' with ⟨-, h2⟩ | ⟨h1, -⟩
          · exact (Sum.inl.injEq _ _ ▸ h2 : B = B₁)
          · exact absurd h1 (by simp)
        subst hBB₁
        exact hB₁notin hBmem
      · rcases Sym2.eq_iff.1 h' with ⟨h1, -⟩ | ⟨h1, -⟩
        · exact absurd h1 (by simp)
        · exfalso
          have h1' : v₁ = vn := by simpa using h1
          exact hvn h1'.symm
      · refine hv₁notin ?_
        simp only [Walk.support_cons, List.mem_cons]
        refine Or.inr (Walk.mem_support_of_mem_edges h' ?_)
        simp
  obtain ⟨W, hW⟩ :=
    exists_walk_of_incidence_walk v₁ r₂.length vn v₂ r₂ le_rfl hvn hkey
  exact no_external_link (B := B₁) (C := B₂) (v := v₁) W hB₁B₂ hB₁v₁ hB₂v₁ hB₁vn hB₂v₂ hW

end EdgeCycleBlock

end SimpleGraph
end Erdos593
