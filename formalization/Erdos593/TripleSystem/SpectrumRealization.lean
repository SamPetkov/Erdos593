import Erdos593.TripleSystem.SpectrumNecessity
import Erdos593.Graph.BipartiteSpectrumRealization
import Erdos593.TripleSystem.TriangleHostRamseyTransport

/-!
# Realization in the exact order-size-component spectrum

The witness uses literal finite point and edge carriers. No numerical test
or abstract list of component parameters substitutes for a constructed system.
-/

namespace Erdos593.TripleSystem

theorem exists_obligatory_spectrum (m n c : ℕ)
    (hm : 1 ≤ m) (hc : 1 ≤ c) (hcm : c ≤ m)
    (hlower : m + 2 * (c - 1) + Erdos593.Spectrum.q (m - c + 1) ≤ n)
    (hupper : n ≤ 2 * m + c) :
    ∃ F : TripleSystem (Fin n) (Fin m),
      F.IsObligatory ∧ F.HasNoIsolatedPoints ∧
      Nat.card F.levi.ConnectedComponent = c := by
  classical
  have _hm : 0 < m := hm
  obtain ⟨G, hb, hno, he, hcomp⟩ :=
    _root_.SimpleGraph.BipartiteSpectrumRealization.exists_shadow m (n - m) c hc hcm
      (by omega) (by omega)
  obtain ⟨hF, hred, hedge, hvertex, hcF⟩ :=
    privateVertexExpansion_shadow_parameters G hb hno
  have hv : Nat.card (PrivateVertexExpansion.Point G) = n := by
    simp only [Fintype.card_fin, he] at hvertex
    omega
  have he' : Nat.card (PrivateVertexExpansion.Edge G) = m := hedge.trans he
  let ev : PrivateVertexExpansion.Point G ≃ Fin n :=
    (Finite.equivFin _).trans (finCongr hv)
  let ee : PrivateVertexExpansion.Edge G ≃ Fin m :=
    (Finite.equivFin _).trans (finCongr he')
  let F := TriangleHostTransport.reindex (privateVertexExpansion G) ev ee
  let i : Iso (privateVertexExpansion G) F :=
    { vertexEquiv := ev
      edgeEquiv := ee
      map_inc_iff := fun x e => (TriangleHostTransport.reindex_inc_iff _ ev ee x e).symm }
  refine ⟨F, hF.ofIso i, ?_, ?_⟩
  · intro x
    apply (not_isolated_iff_exists_inc F).mpr
    obtain ⟨e, he⟩ := (not_isolated_iff_exists_inc _).mp (hred (ev.symm x))
    refine ⟨ee e, ?_⟩
    simpa [i] using (i.map_inc_iff (ev.symm x) e).mp he
  · exact (Nat.card_congr i.leviIso.connectedComponentEquiv).symm.trans (hcF.trans hcomp)

end Erdos593.TripleSystem
