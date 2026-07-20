import Erdos593.TripleSystem.ErdosRado.SourceRecursion
import Erdos593.TripleSystem.ErdosRado.SourceCanonical

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

open scoped Cardinal Ordinal

namespace TracePrefix

theorem initialSegment_of_graph_subset {a : TraceCarrier}
    (p q : TracePrefix a) (hlen : p.length ≤ q.length)
    (hgraph : p.graph ⊆ q.graph) : p.IsInitialSegment q := by
  refine ⟨hlen, ?_⟩
  intro ξ
  have hz : ((ξ.toOrd : Ordinal), p.node ξ) ∈ p.graph := ⟨ξ, rfl⟩
  rcases hgraph hz with ⟨ζ, hζ⟩
  have hindex : liftIndex hlen ξ = ζ := by
    apply (Ordinal.ToType.mk (o := q.length)).symm.injective
    apply Subtype.ext
    exact (liftIndex_toOrd hlen ξ).trans (congrArg Prod.fst hζ)
  subst ζ
  exact (congrArg Prod.snd hζ).symm

theorem restrict_eq_of_initialSegment {a : TraceCarrier}
    (p q : TracePrefix a) (hseg : p.IsInitialSegment q) :
    q.restrict p.length hseg.choose = p := by
  apply graph_injective
  rw [graph_restrict]
  ext z
  constructor
  · rintro ⟨⟨ζ, rfl⟩, hζ⟩
    let ξ : p.length.ToType :=
      Ordinal.ToType.mk ⟨(ζ.toOrd : Ordinal), hζ⟩
    refine ⟨ξ, ?_⟩
    apply Prod.ext
    · simp [ξ, Ordinal.ToType.toOrd]
    · have hnode := hseg.choose_spec ξ
      simpa [ξ, liftIndex, TracePrefix.restrictIndex] using hnode
  · rintro ⟨ξ, rfl⟩
    refine ⟨?_, Set.mem_setOf.mpr (Set.mem_Iio.mp ξ.toOrd.2)⟩
    refine ⟨liftIndex hseg.choose ξ, ?_⟩
    apply Prod.ext
    · exact (liftIndex_toOrd hseg.choose ξ).symm
    · exact (hseg.choose_spec ξ).symm

theorem IsSourceCanonicalFor.limitPrefix {c : TraceColoring}
    {a : TraceCarrier} {o : Ordinal} (F : LimitChain a o)
    (ho : Order.IsSuccLimit o) (hheight : o ≤ TraceHeight)
    (hcanonical : ∀ η, (F.stage η).IsSourceCanonicalFor c) :
    (F.limitPrefix ho hheight).IsSourceCanonicalFor c := by
  intro ξ
  let η := F.nextStage ho ξ
  let ζ := F.diagonalIndex ho ξ
  rcases hcanonical η ζ with ⟨q, hq, hvalue⟩
  have hseg := F.stage_isInitialSegment_limitPrefix ho hheight η
  have hstage :
      (F.limitPrefix ho hheight).restrict (F.stage η).length hseg.choose =
        F.stage η :=
    restrict_eq_of_initialSegment (F.stage η) (F.limitPrefix ho hheight) hseg
  have hstagegraph := congrArg TracePrefix.graph hstage
  rw [graph_restrict] at hstagegraph
  have hbefore : (F.stage η).before ζ =
      (F.limitPrefix ho hheight).before ξ := by
    apply graph_injective
    unfold before
    rw [graph_restrict, graph_restrict, ← hstagegraph]
    ext z
    simp only [Set.mem_inter_iff, Set.mem_setOf_eq]
    have hord : (ζ.toOrd : Ordinal) = ξ.toOrd := by
      exact F.diagonalIndex_toOrd ho ξ
    constructor
    · rintro ⟨⟨hz, hzη⟩, hzζ⟩
      exact ⟨hz, by simpa [hord] using hzζ⟩
    · rintro ⟨hz, hzξ⟩
      refine ⟨⟨hz, ?_⟩, ?_⟩
      · rw [F.length_eq, F.nextStage_toOrd]
        exact hzξ.trans (Order.lt_succ _)
      · simpa [hord] using hzξ
  rw [← hbefore]
  refine ⟨q, hq, ?_⟩
  change q.value = F.limitNode ho ξ
  simpa [η, ζ, LimitChain.limitNode] using hvalue

end TracePrefix

namespace TraceIteration

theorem sourceRun_limit_spec_of_prior
    (c : TraceColoring) (a : TraceCarrier) (η : Ordinal)
    (hηlim : Order.IsSuccLimit η) (hηheight : η ≤ TraceHeight)
    (hspec : ∀ ξ : Set.Iio η,
      ∃ p : TracePrefix a,
        sourceRun c a ξ.1 = p.graph ∧
        p.IsSourceCanonicalFor c ∧
        p.length ≤ ξ.1 ∧
        (p.length = ξ.1 ∨
          (p.length < ξ.1 ∧ ¬ Nonempty (TraceCandidate c p)))) :
    ∃ p : TracePrefix a,
      sourceRun c a η = p.graph ∧
      p.IsSourceCanonicalFor c ∧
      p.length ≤ η ∧
      (p.length = η ∨
        (p.length < η ∧ ¬ Nonempty (TraceCandidate c p))) := by
  classical
  by_cases hstop : ∃ ξ : Set.Iio η, ∃ p : TracePrefix a,
      sourceRun c a ξ.1 = p.graph ∧
      p.IsSourceCanonicalFor c ∧ p.length < ξ.1 ∧
      ¬ Nonempty (TraceCandidate c p)
  · rcases hstop with ⟨ξ, p, hrun, hcanonical, hlength, hterminal⟩
    refine ⟨p, sourceRun_eq_graph_of_stopped c p hterminal hrun
      (le_of_lt ξ.2), hcanonical, hlength.le.trans (le_of_lt ξ.2), ?_⟩
    exact Or.inr ⟨hlength.trans ξ.2, hterminal⟩
  · let stage : η.ToType → TracePrefix a := fun ξ ↦ Classical.choose (hspec ξ)
    have stage_spec (ξ : η.ToType) :
        sourceRun c a ξ.toOrd = (stage ξ).graph ∧
        (stage ξ).IsSourceCanonicalFor c ∧
        (stage ξ).length ≤ ξ.toOrd ∧
        ((stage ξ).length = ξ.toOrd ∨
          ((stage ξ).length < ξ.toOrd ∧
            ¬ Nonempty (TraceCandidate c (stage ξ)))) :=
      Classical.choose_spec (hspec ξ)
    have stage_length (ξ : η.ToType) : (stage ξ).length = ξ.toOrd := by
      rcases (stage_spec ξ).2.2.2 with heq | hshort
      · exact heq
      · exfalso
        apply hstop
        exact ⟨ξ, stage ξ, (stage_spec ξ).1, (stage_spec ξ).2.1,
          hshort.1, hshort.2⟩
    let F : TracePrefix.LimitChain a η :=
      { stage := stage
        length_eq := stage_length
        coherent := by
          intro ξ θ hξθ
          apply TracePrefix.initialSegment_of_graph_subset (stage ξ) (stage θ)
          · rw [stage_length, stage_length]
            exact (Ordinal.ToType.mk (o := η)).symm.monotone hξθ
          · rw [← (stage_spec ξ).1, ← (stage_spec θ).1]
            apply monotone_sourceRun c a
            exact (Ordinal.ToType.mk (o := η)).symm.monotone hξθ }
    let p := F.limitPrefix hηlim hηheight
    refine ⟨p, ?_, ?_, le_rfl, Or.inl rfl⟩
    · calc
        sourceRun c a η = ⋃ ξ : Set.Iio η, sourceRun c a ξ.1 :=
          sourceRun_limit c a η hηlim
        _ = ⋃ ξ : η.ToType, (F.stage ξ).graph := by
          ext z
          simp only [Set.mem_iUnion]
          constructor
          · rintro ⟨ξ, hz⟩
            let j : η.ToType := Ordinal.ToType.mk ξ
            refine ⟨j, ?_⟩
            rw [← (stage_spec j).1]
            simpa [j, Ordinal.ToType.toOrd] using hz
          · rintro ⟨ξ, hz⟩
            refine ⟨ξ.toOrd, ?_⟩
            rw [(stage_spec ξ).1]
            exact hz
        _ = p.graph := (F.graph_limitPrefix hηlim hηheight).symm
    · apply TracePrefix.IsSourceCanonicalFor.limitPrefix
      intro ξ
      exact (stage_spec ξ).2.1

end TraceIteration

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
