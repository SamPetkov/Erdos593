import Erdos593.TripleSystem.SupportedPointSeparation
import Erdos593.TripleSystem.CanonicalAtomMinimalGenerators

/-! # Literal amalgam adapter for the independent point-deletion criterion

Candidate only; the light kernel and this adapter are not integrated or accepted.
-/

namespace Erdos593.TripleSystem.SupportedBlocks

universe u

/-- The light separation predicate is exactly the existing literal certificate,
not a weakened or strengthened substitute. -/
theorem hasPointSeparation_iff_edgeOnePointDecomposition
    {V E : Type u} (F : TripleSystem V E) :
    HasPointSeparation F ↔ Nonempty (CanonicalAtom.EdgeOnePointDecomposition F) := by
  constructor
  · rintro ⟨L, R, r, hL, hR, hdisjoint, htotal, hinter⟩
    exact ⟨⟨L, R, hL, hR, hdisjoint, htotal, r, hinter⟩⟩
  · rintro ⟨D⟩
    exact ⟨D.left, D.right, D.root, D.left_nonempty, D.right_nonempty,
      D.disjoint, D.total, D.support_intersection⟩

/-- Manuscript-facing point-separator/indecomposable bridge. The hypotheses and
literal amalgam definition are the existing finite API; Intrinsic is not assumed. -/
theorem pointNonseparable_iff_onePointIndecomposable
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E]
    (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints)
    (hnonempty : Nonempty E) :
    PointNonseparable F ↔ CanonicalAtom.OnePointIndecomposable F := by
  rw [pointNonseparable_iff_no_pointSeparation F hconnected hreduced hnonempty,
    hasPointSeparation_iff_edgeOnePointDecomposition,
    ← CanonicalAtom.onePointDecomposable_iff_edgeOnePointDecomposition
      F hconnected hreduced]
  rfl

end Erdos593.TripleSystem.SupportedBlocks
