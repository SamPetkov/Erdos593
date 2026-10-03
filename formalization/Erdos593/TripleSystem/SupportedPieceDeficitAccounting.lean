import Erdos593.TripleSystem.SupportedPieceAccountingCandidate

/-!
# Actual supported-piece deficit, derived from the accepted counting identity

The deficit counts mergers of actual original-edge pieces. The local formula is
proved, not assumed. This source alone makes no maximal-chain or grading claim.
Candidate: pinned warning-fatal compilation and actual full-type/axiom review
are required before any acceptance.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

open E593Separator

universe u
variable {V E : Type u} [Fintype V] [Fintype E]
  [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- Deficit relative to the actual canonical atom carrier, not an assembly list. -/
noncomputable def supportedPieceDeficit (D : SupportedPartitions F) : ℕ :=
  Nat.card (Index F) - Nat.card D.val.Block

/-- A local quotient cannot have more classes than the original incident atoms. -/
theorem supportedProduct_block_card_le (hF : F.Intrinsic)
    (D : SupportedPartitions F)
    (p : ↥(sharedAtomPoints F hF.1 hF.2.1)) :
    Nat.card ((supportedDecompositionProduct F hF D p).Block) ≤
      pointMultiplicity F hF.1 hF.2.1 p.val := by
  classical
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hF.1 hF.2.1)
  have h := Nat.card_le_card_of_surjective
    (supportedDecompositionProduct F hF D p).block
    (supportedDecompositionProduct F hF D p).block_surjective
  simpa only [canonicalStar_card F hF.1 hF.2.1 p.val] using h

/-- Exact local additive formula on the original shared-point carrier. -/
theorem supportedPieceDeficit_eq_sum (hF : F.Intrinsic)
    (D : SupportedPartitions F) :
    supportedPieceDeficit F D =
      ∑ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
        (pointMultiplicity F hF.1 hF.2.1 p.val -
          Nat.card ((supportedDecompositionProduct F hF D p).Block)) := by
  classical
  have hsum := Finset.sum_tsub_distrib
    (Finset.univ : Finset ↥(sharedAtomPoints F hF.1 hF.2.1))
    (fun p _ => supportedProduct_block_card_le F hF D p)
  rw [hsum]
  have hcount := supportedPartitions_block_card_accounting F hF D
  unfold supportedPieceDeficit
  omega

/-- Subtraction is justified: every original supported piece contains an atom. -/
theorem supportedPieces_add_deficit (hF : F.Intrinsic)
    (D : SupportedPartitions F) :
    Nat.card D.val.Block + supportedPieceDeficit F D = Nat.card (Index F) := by
  classical
  have hle :
      (∑ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
        Nat.card ((supportedDecompositionProduct F hF D p).Block)) ≤
      ∑ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
        pointMultiplicity F hF.1 hF.2.1 p.val :=
    Finset.sum_le_sum (fun p _ => supportedProduct_block_card_le F hF D p)
  have hcount := supportedPartitions_block_card_accounting F hF D
  unfold supportedPieceDeficit
  omega

end Erdos593.TripleSystem.CanonicalAtom
