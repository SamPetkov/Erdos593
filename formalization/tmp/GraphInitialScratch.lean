import Erdos593.TripleSystem.ErdosRado.TraceGraph

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

open scoped Cardinal Ordinal

namespace TracePrefix

theorem isInitialSegment_of_graph_subset {a : TraceCarrier}
    {p q : TracePrefix a} (hgraph : p.graph ⊆ q.graph) :
    p.IsInitialSegment q := by
  have hlength : p.length ≤ q.length := by
    refine le_of_forall_lt fun β hβ ↦ ?_
    let ξ : p.length.ToType := Ordinal.ToType.mk ⟨β, hβ⟩
    have hz : ((β : Ordinal), p.node ξ) ∈ p.graph := by
      refine ⟨ξ, ?_⟩
      apply Prod.ext
      · simp [ξ, Ordinal.ToType.toOrd]
      · rfl
    rcases hgraph hz with ⟨ζ, hζ⟩
    have hβζ : β = (ζ.toOrd : Ordinal) := congrArg Prod.fst hζ
    rw [hβζ]
    exact Set.mem_Iio.mp ζ.toOrd.2
  refine ⟨hlength, fun ξ ↦ ?_⟩
  have hz : (((ξ.toOrd : Ordinal), p.node ξ)) ∈ p.graph := ⟨ξ, rfl⟩
  rcases hgraph hz with ⟨ζ, hζ⟩
  have hindex : liftIndex hlength ξ = ζ := by
    apply (Ordinal.ToType.mk (o := q.length)).symm.injective
    apply Subtype.ext
    rw [liftIndex_toOrd]
    exact congrArg Prod.fst hζ
  rw [hindex]
  exact (congrArg Prod.snd hζ).symm

theorem graph_subset_of_isInitialSegment {a : TraceCarrier}
    {p q : TracePrefix a} (hpq : p.IsInitialSegment q) :
    p.graph ⊆ q.graph := by
  rcases hpq with ⟨hlength, hnode⟩
  rintro z ⟨ξ, rfl⟩
  refine ⟨liftIndex hlength ξ, ?_⟩
  apply Prod.ext
  · exact (liftIndex_toOrd hlength ξ).symm
  · exact (hnode ξ).symm

theorem graph_subset_iff_isInitialSegment {a : TraceCarrier}
    {p q : TracePrefix a} :
    p.graph ⊆ q.graph ↔ p.IsInitialSegment q :=
  ⟨isInitialSegment_of_graph_subset, graph_subset_of_isInitialSegment⟩

end TracePrefix

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
