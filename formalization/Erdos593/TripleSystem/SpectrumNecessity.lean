import Erdos593.TripleSystem.BipartiteShadow
import Erdos593.Graph.BipartiteSpectrumBounds

/-!
# Necessity in the exact order-size-component spectrum

This proves only the necessity direction. The realization converse is separate.
-/

namespace Erdos593.TripleSystem

universe u

theorem obligatory_spectrum_necessity
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E]
    (hobligatory : F.IsObligatory)
    (hreduced : F.HasNoIsolatedPoints)
    (hnonempty : Nonempty E) :
    1 ≤ Nat.card F.levi.ConnectedComponent ∧
    Nat.card F.levi.ConnectedComponent ≤ Nat.card E ∧
    Nat.card E + 2 * (Nat.card F.levi.ConnectedComponent - 1) +
        Erdos593.Spectrum.q (Nat.card E - Nat.card F.levi.ConnectedComponent + 1)
      ≤ Nat.card V ∧
    Nat.card V ≤ 2 * Nat.card E + Nat.card F.levi.ConnectedComponent := by
  classical
  obtain ⟨s, G, hb, hnoiso, he, hv, hc⟩ :=
    exists_bipartite_shadow F hobligatory hreduced hnonempty
  haveI : Nonempty E := hnonempty
  have hpos : 0 < Nat.card G.edgeSet := by
    rw [he]
    exact Fintype.card_pos
  have hne : Nonempty G.edgeSet := Nat.card_pos_iff.mp hpos |>.1
  obtain ⟨h1, h2, h3, h4⟩ :=
    _root_.SimpleGraph.BipartiteSpectrumBounds.parameter_bounds G hb hnoiso hne
  simp only [hc, he, Nat.card_eq_fintype_card, Fintype.card_fin] at h1 h2 h3 h4 ⊢
  exact ⟨h1, h2, by omega, by omega⟩

end Erdos593.TripleSystem
