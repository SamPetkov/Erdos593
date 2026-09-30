import Erdos593.Graph.EdgeCycleBlockIncidence
import Erdos593.Graph.EdgeCycleChord

namespace Erdos593
namespace SimpleGraph

set_option autoImplicit false

/-!
# Publication refinement: two cycle blocks meet in at most one vertex

This module isolates only the quotient block-intersection theorem.  It does
not exclude alternating block-incidence cycles, construct an incidence
forest, specialize to a contracted graph, or package canonical atoms.
-/

namespace EdgeCycleBlock

/-- Two edge-cycle blocks incident to the same two distinct vertices are
equal. -/
theorem eq_of_incident_two_vertices
    {V : Type*} (G : _root_.SimpleGraph V)
    {B C : EdgeCycleBlock G} {x y : V}
    (hxy : x ≠ y)
    (hxB : Incident G x B) (hyB : Incident G y B)
    (hxC : Incident G x C) (hyC : Incident G y C) :
    B = C := by
  rcases (incident_iff_exists_endpoint G).1 hxB with ⟨eBx, heBxB, hxeBx⟩
  rcases (incident_iff_exists_endpoint G).1 hyB with ⟨eBy, heByB, hyeBy⟩
  rcases (incident_iff_exists_endpoint G).1 hxC with ⟨eCx, heCxC, hxeCx⟩
  rcases (incident_iff_exists_endpoint G).1 hyC with ⟨eCy, heCyC, hyeCy⟩
  change ofEdge G eBx = B at heBxB
  change ofEdge G eBy = B at heByB
  change ofEdge G eCx = C at heCxC
  change ofEdge G eCy = C at heCyC
  have hB : EdgeCycleLinked G eBx eBy :=
    (ofEdge_eq_iff G).1 (heBxB.trans heByB.symm)
  have hC : EdgeCycleLinked G eCx eCy :=
    (ofEdge_eq_iff G).1 (heCxC.trans heCyC.symm)
  have hCross : EdgeCycleLinked G eBx eCx := by
    rcases hB with hBeq | ⟨vB, cB, hcB, heBx, heBy⟩
    · subst eBy
      have heBxy : eBx.1 = s(x, y) :=
        (Sym2.mem_and_mem_iff hxy).1 ⟨hxeBx, hyeBy⟩
      rcases hC with hCeq | ⟨vC, cC, hcC, heCx, heCy⟩
      · subst eCy
        have heCxy : eCx.1 = s(x, y) :=
          (Sym2.mem_and_mem_iff hxy).1 ⟨hxeCx, hyeCy⟩
        exact Or.inl (Subtype.ext (heBxy.trans heCxy.symm))
      · have hxC' : x ∈ cC.support :=
          cC.mem_support_of_mem_edges heCx hxeCx
        have hyC' : y ∈ cC.support :=
          cC.mem_support_of_mem_edges heCy hyeCy
        exact Or.inr
          (edgesOnCommonCycle_of_edge_endpoints_and_cycle G hcC hxy heBxy
            hxC' hyC' heCx)
    · have hxB' : x ∈ cB.support :=
        cB.mem_support_of_mem_edges heBx hxeBx
      have hyB' : y ∈ cB.support :=
        cB.mem_support_of_mem_edges heBy hyeBy
      rcases hC with hCeq | ⟨vC, cC, hcC, heCx, heCy⟩
      · subst eCy
        have heCxy : eCx.1 = s(x, y) :=
          (Sym2.mem_and_mem_iff hxy).1 ⟨hxeCx, hyeCy⟩
        exact Or.inr (edgesOnCommonCycle_symm G
          (edgesOnCommonCycle_of_edge_endpoints_and_cycle G hcB hxy heCxy
            hxB' hyB' heBx))
      · have hxC' : x ∈ cC.support :=
          cC.mem_support_of_mem_edges heCx hxeCx
        have hyC' : y ∈ cC.support :=
          cC.mem_support_of_mem_edges heCy hyeCy
        exact Or.inr
          (edgesOnCommonCycle_of_cycles_share_two_vertices G hcB hcC hxy
            hxB' hyB' hxC' hyC' heBx heCx)
  exact heBxB.symm.trans (((ofEdge_eq_iff G).2 hCross).trans heCxC)

end EdgeCycleBlock

end SimpleGraph
end Erdos593
