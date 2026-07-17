import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportBranchGeometry
import Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceGraph

namespace Erdos593.SequenceLift

universe u

variable {V : Type u} {G : _root_.SimpleGraph V}

example {S : Set (Edge G)} {q : activeBaseNodeIndex S}
    (d : (baseFiberSupportIncidenceGraph S).Walk (.inl q) (.inl q))
    (hd : d.IsCycle) :
    ∃ pL pR : activeBaseFiberSupportPointIndex S,
      (baseFiberSupportIncidenceGraph S).Adj (.inl q) (.inr pL) ∧
      (baseFiberSupportIncidenceGraph S).Adj (.inr pR) (.inl q) ∧
      pL ≠ pR := by
  have hstart := d.adj_snd hd.not_nil
  have hend := d.adj_penultimate hd.not_nil
  cases hsnd : d.snd with
  | inl r =>
      rw [hsnd] at hstart
      exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hstart).elim
  | inr pL =>
      cases hpen : d.penultimate with
      | inl r =>
          rw [hpen] at hend
          exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hend).elim
      | inr pR =>
          refine ⟨pL, pR, ?_, ?_, ?_⟩
          · simpa [hsnd] using hstart
          · simpa [hpen] using hend
          · intro hp
            apply hd.snd_ne_penultimate
            simp [hsnd, hpen, hp]

example {S : Set (Edge G)} {q : activeBaseNodeIndex S}
    (d : (baseFiberSupportIncidenceGraph S).Walk (.inl q) (.inl q))
    (hd : d.IsCycle) :
    ∃ p : activeBaseFiberSupportPointIndex S,
      ∃ u : activeBaseNodeIndex S,
        (baseFiberSupportIncidenceGraph S).Adj (.inl q) (.inr p) ∧
        (baseFiberSupportIncidenceGraph S).Adj (.inr p) (.inl u) ∧
        q ≠ u := by
  have hstart := d.adj_snd hd.not_nil
  cases hsnd : d.snd with
  | inl r =>
      rw [hsnd] at hstart
      exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hstart).elim
  | inr p =>
      have hlength : 3 ≤ d.length := hd.three_le_length
      have hnext := d.adj_getVert_succ (i := 1) (by omega)
      have hnext' :
          (baseFiberSupportIncidenceGraph S).Adj (.inr p) (d.getVert 2) := by
        simpa [hsnd] using hnext
      cases htwo : d.getVert 2 with
      | inr r =>
          rw [htwo] at hnext'
          exact (not_baseFiberSupportIncidenceGraph_adj_inr_inr hnext').elim
      | inl u =>
          refine ⟨p, u, ?_, ?_, ?_⟩
          · simpa [hsnd] using hstart
          · simpa [htwo] using hnext'
          · intro hqu
            have hendpoint : d.getVert 2 = (.inl q :
                activeBaseNodeIndex S ⊕ activeBaseFiberSupportPointIndex S) := by
              simp [htwo, hqu]
            have := (hd.getVert_endpoint_iff (i := 2) (by omega)).mp hendpoint
            omega

/-- A nontrivial `inl`-to-`inl` walk in the incidence graph begins with an
`inl`--`inr`--`inl` segment.  This is the decomposition used by the cycle
propagation induction. -/
example {S : Set (Edge G)} {q u : activeBaseNodeIndex S}
    (r : (baseFiberSupportIncidenceGraph S).Walk (.inl u) (.inl q))
    (huq : u ≠ q) :
    Σ p : activeBaseFiberSupportPointIndex S,
      Σ v : activeBaseNodeIndex S,
        {t : (baseFiberSupportIncidenceGraph S).Walk (.inl v) (.inl q) //
          (baseFiberSupportIncidenceGraph S).Adj (.inl u) (.inr p) ∧
          (baseFiberSupportIncidenceGraph S).Adj (.inr p) (.inl v) ∧ t = t} := by
  have hnon : ¬ r.Nil := by
    apply SimpleGraph.Walk.not_nil_of_ne
    simpa using huq
  have hfirst := r.adj_snd hnon
  cases hsnd : r.snd with
  | inl w =>
      rw [hsnd] at hfirst
      exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hfirst).elim
  | inr p =>
      have htailnon : ¬ r.tail.Nil := by
        apply SimpleGraph.Walk.not_nil_of_ne
        simp [hsnd]
      have hsecond := r.tail.adj_snd htailnon
      have hsecond' :
          (baseFiberSupportIncidenceGraph S).Adj (.inr p) r.tail.snd := by
        simpa only [hsnd] using hsecond
      cases htailSnd : r.tail.snd with
      | inr w =>
          have : (baseFiberSupportIncidenceGraph S).Adj (.inr p) (.inr w) := by
            simpa only [htailSnd] using hsecond'
          exact (not_baseFiberSupportIncidenceGraph_adj_inr_inr this).elim
      | inl v =>
          refine ⟨p, v, ?_, ?_⟩
          · simpa only [htailSnd] using r.tail.tail
          · constructor
            · simpa [hsnd] using hfirst
            · constructor
              · simpa only [htailSnd] using hsecond'
              · rfl

/-- Walk-recursion core for the alternating-cycle argument.  If a fixed
extension of the minimum fibre is propagated over every two-edge segment of an
`inl`-to-`inl` simple path, it reaches the final edge into the distinguished
fibre. -/
example {S : Set (Edge G)} {q : activeBaseNodeIndex S} {a : Alphabet G}
    (d : (baseFiberSupportIncidenceGraph S).Walk (.inl q) (.inl q))
    (hmin : ∀ v : activeBaseNodeIndex S,
      (.inl v : activeBaseNodeIndex S ⊕ activeBaseFiberSupportPointIndex S) ∈ d.support →
      q.1.length ≤ v.1.length)
    {u : activeBaseNodeIndex S}
    (r : (baseFiberSupportIncidenceGraph S).Walk (.inl u) (.inl q))
    (hr : r.IsPath)
    (hqu : q.1.ExtendsBy a u.1)
    (hmem : ∀ x ∈ r.support, x ∈ d.support) :
    ∃ (p : activeBaseFiberSupportPointIndex S) (w : activeBaseNodeIndex S),
      q.1.ExtendsBy a w.1 ∧
      (baseFiberSupportIncidenceGraph S).Adj (.inl w) (.inr p) ∧
      (baseFiberSupportIncidenceGraph S).Adj (.inr p) (.inl q) := by
  let rec aux {u : activeBaseNodeIndex S}
      (r : (baseFiberSupportIncidenceGraph S).Walk (.inl u) (.inl q))
      (hr : r.IsPath)
      (hqu : q.1.ExtendsBy a u.1)
      (hmem : ∀ x ∈ r.support, x ∈ d.support) :
      ∃ (p : activeBaseFiberSupportPointIndex S) (w : activeBaseNodeIndex S),
        q.1.ExtendsBy a w.1 ∧
        (baseFiberSupportIncidenceGraph S).Adj (.inl w) (.inr p) ∧
        (baseFiberSupportIncidenceGraph S).Adj (.inr p) (.inl q) := by
    have huq : u ≠ q := by
      intro huq
      have : q.1 = u.1 := congrArg Subtype.val huq.symm
      have hlt : q.1.length < u.1.length := hqu.choose
      have hne : q.1.length ≠ u.1.length := ne_of_lt hlt
      exact hne (congrArg Node.length this)
    have hnon : ¬ r.Nil := by
      apply SimpleGraph.Walk.not_nil_of_ne
      simpa using huq
    have hfirst := r.adj_snd hnon
    cases hsnd : r.snd with
    | inl w =>
        rw [hsnd] at hfirst
        exact (not_baseFiberSupportIncidenceGraph_adj_inl_inl hfirst).elim
    | inr p =>
        have htailnon : ¬ r.tail.Nil := by
          apply SimpleGraph.Walk.not_nil_of_ne
          simp [hsnd]
        have hsecond := r.tail.adj_snd htailnon
        have hsecond' :
            (baseFiberSupportIncidenceGraph S).Adj (.inr p) r.tail.snd := by
          simpa only [hsnd] using hsecond
        cases htailSnd : r.tail.snd with
        | inr w =>
            have : (baseFiberSupportIncidenceGraph S).Adj (.inr p) (.inr w) := by
              simpa only [htailSnd] using hsecond'
            exact (not_baseFiberSupportIncidenceGraph_adj_inr_inr this).elim
        | inl v =>
            have hup :
                (baseFiberSupportIncidenceGraph S).Adj (.inl u) (.inr p) := by
              simpa only [hsnd] using hfirst
            have hpv :
                (baseFiberSupportIncidenceGraph S).Adj (.inr p) (.inl v) := by
              simpa only [htailSnd] using hsecond'
            by_cases hvq : v = q
            · subst v
              exact ⟨p, u, hqu, hup, hpv⟩
            · have hvinr :
                  (.inl v : activeBaseNodeIndex S ⊕ activeBaseFiberSupportPointIndex S) ∈
                    r.support := by
                have hget := r.getVert_mem_support 2
                have hget' : r.getVert 2 = (.inl v :
                    activeBaseNodeIndex S ⊕ activeBaseFiberSupportPointIndex S) := by
                  rw [← r.getVert_tail]
                  exact htailSnd
                simpa [hget'] using hget
              have hqvle : q.1.length ≤ v.1.length := hmin v (hmem _ hvinr)
              have hqvne : q.1 ≠ v.1 := by
                intro hqv
                apply hvq
                exact Subtype.ext hqv.symm
              have hpu : p.1 ∈ (system G).edgeSupportSet (baseFiber S u.1) := by
                simpa using hup
              have hpv' : p.1 ∈ (system G).edgeSupportSet (baseFiber S v.1) := by
                simpa using hpv
              have hqv : q.1.ExtendsBy a v.1 :=
                Node.extendsBy_of_common_support_of_le hqu hqvle hqvne hpu hpv'
              let r' :
                  (baseFiberSupportIncidenceGraph S).Walk (.inl v) (.inl q) :=
                r.tail.tail.copy htailSnd rfl
              have hr' : r'.IsPath := by
                simpa only [r', SimpleGraph.Walk.isPath_copy] using hr.tail.tail
              have hr'length : r'.length = r.tail.tail.length := by
                simp only [r', SimpleGraph.Walk.length_copy]
              apply aux r'
              · exact hr'
              · exact hqv
              · intro x hx
                apply hmem x
                have hx0 : x ∈ r.tail.tail.support := by
                  simpa only [r', SimpleGraph.Walk.support_copy] using hx
                have hx' : x ∈ r.tail.support := by
                  rw [← r.tail.cons_support_tail htailnon]
                  exact List.mem_cons_of_mem _ hx0
                rw [← r.cons_support_tail hnon]
                exact List.mem_cons_of_mem _ hx'
  termination_by r.length
  decreasing_by
    have h1 := r.length_tail_add_one hnon
    have h2 := r.tail.length_tail_add_one htailnon
    rw [hr'length]
    omega
  exact aux r hr hqu hmem

/-- The endpoint collision that closes the propagated-branch argument: once
the same base letter reaches both boundary fibres, their boundary support
points must coincide in a linear selected restriction. -/
example {S : Set (Edge G)}
    (hlin : ((system G).edgeRestriction S).Linear)
    {q uL uR : Node G} {a : Alphabet G}
    {pL pR : Point G}
    (hLq : pL ∈ (system G).edgeSupportSet (baseFiber S q))
    (hLuL : pL ∈ (system G).edgeSupportSet (baseFiber S uL))
    (hRq : pR ∈ (system G).edgeSupportSet (baseFiber S q))
    (hRuR : pR ∈ (system G).edgeSupportSet (baseFiber S uR))
    (hquL : q.ExtendsBy a uL)
    (hquR : q.ExtendsBy a uR) :
    pL = pR := by
  rcases exists_baseFiber_edge_of_common_support_of_lt hquL.choose hLq hLuL with
    ⟨eL, heL, hpL, hLe⟩
  rcases exists_baseFiber_edge_of_common_support_of_lt hquR.choose hRq hRuR with
    ⟨eR, heR, hpR, hRe⟩
  have hletterL : a = baseLetter eL :=
    Node.letter_eq_of_extendsBy_same_target hquL hLe
  have hletterR : a = baseLetter eR :=
    Node.letter_eq_of_extendsBy_same_target hquR hRe
  have hletter : baseLetter eL = baseLetter eR := hletterL.symm.trans hletterR
  have heq : eL = eR :=
    eq_of_same_baseNode_baseLetter_of_mem_of_linear hlin heL.1 heR.1
      (heL.2.trans heR.2.symm) hletter
  calc
    pL = baseApex eL := hpL
    _ = baseApex eR := congrArg baseApex heq
    _ = pR := hpR.symm

/-- Check the explicit `argminOn_le` invocation used to select the
least-length fibre-side vertex of a cycle. -/
example {α : Type} [LinearOrder α] [WellFoundedLT α]
    {β : Type} (f : β → α) (Q : Set β) (hQ : Q.Nonempty) {u : β}
    (hu : u ∈ Q) :
    f (Function.argminOn f Q hQ) ≤ f u := by
  exact Function.argminOn_le f Q hu

end Erdos593.SequenceLift
