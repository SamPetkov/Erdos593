import Erdos593.TripleSystem.SupportedDecompositionProduct
import Erdos593.TripleSystem.StandardPartitionBridge

/-!
# The literal decomposition order and standard finite partition lattices

The imported Product file must be PR50's final repaired candidate, not PR48's
older version. The accepted separator modules retain their canonical names.
Nothing here replaces the original-edge decomposition predicate or assumes a
standard product representation as an input.

New source candidate: Product acceptance and pinned replay remain separate.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

open E593Separator

universe u
variable {V E : Type u} [Fintype V] [Fintype E]
  [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- A choice of labels, not a claim of canonical enumeration of a star. -/
noncomputable def starEquivFin (hL : F.Linear) (hB : F.BridgeAtEveryEdge) (p : V) :
    Star (atomIncident F hL hB) p ≃ Fin (pointMultiplicity F hL hB p) := by
  classical
  haveI : Finite (Index F) := Finite.of_surjective _ (atomOf_surjective F hL hB)
  letI : Fintype (Star (atomIncident F hL hB) p) := Fintype.ofFinite _
  apply Fintype.equivFinOfCardEq
  simpa only [Nat.card_eq_fintype_card] using canonicalStar_card F hL hB p

/-- Each local factor is the standard setoid partition lattice on Fin mu. -/
noncomputable def starStandardOrderIso (hL : F.Linear) (hB : F.BridgeAtEveryEdge) (p : V) :
    Partition (Star (atomIncident F hL hB) p) ≃o
      Setoid (Fin (pointMultiplicity F hL hB p)) :=
  (E593Standard.partitionSetoidOrderIso _).trans
    (E593Standard.setoidReindexOrderIso (starEquivFin F hL hB p))

/-- The index set and multiplicities are the already defined original points. -/
abbrev StandardLocalPartitions (hL : F.Linear) (hB : F.BridgeAtEveryEdge) :=
  (p : ↥(sharedAtomPoints F hL hB)) → Setoid (Fin (pointMultiplicity F hL hB p.val))

/-- Exact order equivalence on supported partitions of original hyperedges. -/
noncomputable def supportedStandardProduct (hF : F.Intrinsic) :
    SupportedPartitions F ≃o StandardLocalPartitions F hF.1 hF.2.1 :=
  (supportedDecompositionProduct F hF).trans
    (E593Standard.pointwiseOrderIso (fun p => starStandardOrderIso F hF.1 hF.2.1 p.val))

/-- The standardization retains the original local relation, up to enumeration. -/
theorem supportedStandardProduct_rel (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : ↥(sharedAtomPoints F hF.1 hF.2.1))
    (a b : Fin (pointMultiplicity F hF.1 hF.2.1 p.val)) :
    (supportedStandardProduct F hF D p).r a b ↔
      (supportedDecompositionProduct F hF D p).rel
        ((starEquivFin F hF.1 hF.2.1 p.val).symm a)
        ((starEquivFin F hF.1 hF.2.1 p.val).symm b) := Iff.rfl

/-- Original-carrier wrapper: no reducedness or connectedness is added. -/
theorem obligatory_supported_standard_product (hobl : F.IsObligatory) :
    ∃ (hL : F.Linear) (hB : F.BridgeAtEveryEdge),
      Nonempty (SupportedPartitions F ≃o StandardLocalPartitions F hL hB) := by
  have hi : F.Intrinsic :=
    ((isObligatory_iff_atomGenerated F).mp hobl).constructible.intrinsic
  exact ⟨hi.1, hi.2.1, ⟨supportedStandardProduct F hi⟩⟩

end Erdos593.TripleSystem.CanonicalAtom
