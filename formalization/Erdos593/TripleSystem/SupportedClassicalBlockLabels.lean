import Erdos593.TripleSystem.SupportedClassicalBlockForward
import Erdos593.TripleSystem.CanonicalAtomContainment
import Erdos593.TripleSystem.CanonicalAtomTransport
import Erdos593.TripleSystem.CanonicalAtomCounting

/-! # Classical supported blocks and unique original canonical labels

The conditional identification uses the existing Intrinsic hypothesis only in
this remark, not in the unrestricted classical-block equivalence.
-/

namespace Erdos593.TripleSystem.SupportedBlocks

universe u

variable {V E : Type u} (F : TripleSystem V E)
variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
  [DecidableRel F.levi.Adj]

theorem canonicalAtom_pointNonseparable (hF : F.Intrinsic)
    (A : CanonicalAtom.Index F) :
    PointNonseparable (F.edgeRestriction (CanonicalAtom.edges F hF.1 hF.2.1 A)) := by
  classical
  let S := CanonicalAtom.edges F hF.1 hF.2.1 A
  letI : Fintype (F.EdgeSupport S) := Fintype.ofFinite _
  letI : Fintype S := Fintype.ofFinite _
  obtain ⟨e, he⟩ := CanonicalAtom.atomOf_surjective F hF.1 hF.2.1 A
  have hnonempty : Nonempty S := ⟨⟨e, he⟩⟩
  exact (pointNonseparable_iff_onePointIndecomposable (F.edgeRestriction S)
    (CanonicalAtom.atomRestriction_connected F hF.1 hF.2.1 A)
    (F.edgeRestriction_hasNoIsolatedPoints S) hnonempty).mpr
      (CanonicalAtom.atomRestriction_onePointIndecomposable F hF A)

theorem pointNonseparable_subset_canonicalAtom (hF : F.Intrinsic)
    (S : Set E) (hS : S.Nonempty)
    (hpoint : PointNonseparable (F.edgeRestriction S)) :
    ∃ A : CanonicalAtom.Index F, S ⊆ CanonicalAtom.edges F hF.1 hF.2.1 A := by
  classical
  letI : Fintype (F.EdgeSupport S) := Fintype.ofFinite _
  letI : Fintype S := Fintype.ofFinite _
  have hnonempty : Nonempty S := ⟨⟨hS.choose, hS.choose_spec⟩⟩
  exact CanonicalAtom.indecomposable_edgeRestriction_subset_atom F hF S hpoint.1
    ((pointNonseparable_iff_onePointIndecomposable (F.edgeRestriction S)
      hpoint.1 (F.edgeRestriction_hasNoIsolatedPoints S) hnonempty).mp hpoint)

theorem canonicalAtom_isSupportedBlock (hF : F.Intrinsic)
    (A : CanonicalAtom.Index F) :
    IsSupportedBlock F (CanonicalAtom.edges F hF.1 hF.2.1 A) := by
  classical
  obtain ⟨e, he⟩ := CanonicalAtom.atomOf_surjective F hF.1 hF.2.1 A
  refine ⟨⟨e, he⟩, canonicalAtom_pointNonseparable F hF A, ?_⟩
  intro T hAT hpoint
  obtain ⟨B, hTB⟩ := pointNonseparable_subset_canonicalAtom F hF T
    ⟨e, hAT he⟩ hpoint
  have heB : CanonicalAtom.atomOf F hF.1 hF.2.1 e = B := hTB (hAT he)
  have hAB : A = B := he.symm.trans heB
  simpa only [← hAB] using hTB

theorem supportedBlock_iff_canonicalAtom (hF : F.Intrinsic) (S : Set E) :
    IsSupportedBlock F S ↔
      ∃! A : CanonicalAtom.Index F, S = CanonicalAtom.edges F hF.1 hF.2.1 A := by
  classical
  constructor
  · intro hS
    obtain ⟨A, hSA⟩ := pointNonseparable_subset_canonicalAtom F hF S hS.1 hS.2.1
    have hAS := hS.2.2 _ hSA (canonicalAtom_pointNonseparable F hF A)
    have hEq : S = CanonicalAtom.edges F hF.1 hF.2.1 A := Set.Subset.antisymm hSA hAS
    refine ⟨A, hEq, ?_⟩
    intro B hSB
    obtain ⟨e, he⟩ := hS.1
    have heA : CanonicalAtom.atomOf F hF.1 hF.2.1 e = A := hSA he
    have heB : CanonicalAtom.atomOf F hF.1 hF.2.1 e = B := by
      rw [hSB] at he
      exact he
    exact heB.symm.trans heA
  · rintro ⟨A, rfl, _⟩
    exact canonicalAtom_isSupportedBlock F hF A

end Erdos593.TripleSystem.SupportedBlocks
