import Erdos593.TripleSystem.SupportedStandardPartitions
import Mathlib.Order.Cover

/-!
# Covers of actual supported decompositions

The source order is the existing supported-partition subtype on original edge
indices, not the full partition lattice. Its accepted order isomorphisms give
the exact covering relation: one actual shared-point factor covers, while every
other factor is fixed. No assertion that a subtype cover is an ambient cover is
used. Empty shared-point carriers are permitted.

Candidate source only: pinned compilation, full-type and axiom review, canonical
integration, and standalone/final reconciliation remain separate gates.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

open E593Separator

universe u
variable {V E : Type u} [Fintype V] [Fintype E]
  [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- A supported cover changes exactly one actual shared-point factor by a cover. -/
theorem supportedPartitions_covBy_iff (hF : F.Intrinsic)
    (D D' : SupportedPartitions F) :
    D ⋖ D' ↔
      ∃ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
        (supportedDecompositionProduct F hF D p) ⋖
          (supportedDecompositionProduct F hF D' p) ∧
        ∀ q ≠ p,
          supportedDecompositionProduct F hF D q =
            supportedDecompositionProduct F hF D' q := by
  calc
    D ⋖ D' ↔
        (supportedDecompositionProduct F hF D) ⋖
          (supportedDecompositionProduct F hF D') :=
      (apply_covBy_apply_iff (supportedDecompositionProduct F hF)).symm
    _ ↔ _ := Pi.covBy_iff

/-- The changed coordinate of a supported cover is unique on the actual carrier. -/
theorem supportedPartitions_covBy_iff_exists_unique (hF : F.Intrinsic)
    (D D' : SupportedPartitions F) :
    D ⋖ D' ↔
      ∃! p : ↥(sharedAtomPoints F hF.1 hF.2.1),
        (supportedDecompositionProduct F hF D p) ⋖
          (supportedDecompositionProduct F hF D' p) ∧
        ∀ q ≠ p,
          supportedDecompositionProduct F hF D q =
            supportedDecompositionProduct F hF D' q := by
  constructor
  · intro h
    obtain ⟨p, hp, hfixed⟩ := (supportedPartitions_covBy_iff F hF D D').mp h
    refine ⟨p, ⟨hp, hfixed⟩, ?_⟩
    rintro q ⟨hq, _⟩
    by_contra hqp
    exact hq.ne (hfixed q hqp)
  · rintro ⟨p, hp, _⟩
    exact (supportedPartitions_covBy_iff F hF D D').mpr ⟨p, hp⟩

/-- The same cover criterion after standardizing each original star, not its index. -/
theorem supportedPartitions_standard_covBy_iff (hF : F.Intrinsic)
    (D D' : SupportedPartitions F) :
    D ⋖ D' ↔
      ∃ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
        (supportedStandardProduct F hF D p) ⋖
          (supportedStandardProduct F hF D' p) ∧
        ∀ q ≠ p,
          supportedStandardProduct F hF D q =
            supportedStandardProduct F hF D' q := by
  calc
    D ⋖ D' ↔
        (supportedStandardProduct F hF D) ⋖
          (supportedStandardProduct F hF D') :=
      (apply_covBy_apply_iff (supportedStandardProduct F hF)).symm
    _ ↔ _ := Pi.covBy_iff

/-- The original obligatoriness hypothesis supplies the structural proof internally. -/
theorem obligatory_supportedPartitions_covBy_iff
    (hobl : F.IsObligatory) (D D' : SupportedPartitions F) :
    let hF : F.Intrinsic :=
      ((isObligatory_iff_atomGenerated F).mp hobl).constructible.intrinsic
    D ⋖ D' ↔
      ∃ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
        (supportedDecompositionProduct F hF D p) ⋖
          (supportedDecompositionProduct F hF D' p) ∧
        ∀ q ≠ p,
          supportedDecompositionProduct F hF D q =
            supportedDecompositionProduct F hF D' q := by
  dsimp only
  exact supportedPartitions_covBy_iff F
    (((isObligatory_iff_atomGenerated F).mp hobl).constructible.intrinsic) D D'

end Erdos593.TripleSystem.CanonicalAtom
