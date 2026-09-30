import Erdos593.TripleSystem.SupportedStandardPartitions

/-!
# Suprema and infima in the actual supported-decomposition order

Use the standard complete partition lattices coordinatewise and transport back
to the unchanged original-edge objects. This avoids installing a competing
global order/lattice instance on the earlier custom partition type. Every set,
including the empty set, has the stated least upper and greatest lower bounds.

Candidate proof source; no claim of successful kernel checking is made here.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u
variable {V E : Type u} [Fintype V] [Fintype E]
  [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- Infimum transported from the standard local partition lattices. -/
noncomputable def supportedInfimum (hF : F.Intrinsic) (S : Set (SupportedPartitions F)) :
    SupportedPartitions F :=
  (supportedStandardProduct F hF).symm
    (fun p => sInf ((fun D => supportedStandardProduct F hF D p) '' S))

/-- Supremum transported from the standard local partition lattices. -/
noncomputable def supportedSupremum (hF : F.Intrinsic) (S : Set (SupportedPartitions F)) :
    SupportedPartitions F :=
  (supportedStandardProduct F hF).symm
    (fun p => sSup ((fun D => supportedStandardProduct F hF D p) '' S))

theorem supportedInfimum_le (hF : F.Intrinsic) (S : Set (SupportedPartitions F))
    (D : SupportedPartitions F) (hD : D ∈ S) : supportedInfimum F hF S ≤ D := by
  let e := supportedStandardProduct F hF
  change e.symm (fun p => sInf ((fun R => e R p) '' S)) ≤ D
  calc
    _ ≤ e.symm (e D) := by
      apply e.symm.monotone
      intro p
      have hp : e D p ∈ (fun R => e R p) '' S := ⟨D, hD, rfl⟩
      exact sInf_le hp
    _ = D := e.symm_apply_apply D

theorem le_supportedInfimum (hF : F.Intrinsic) (S : Set (SupportedPartitions F))
    (D : SupportedPartitions F) (hD : ∀ R ∈ S, D ≤ R) : D ≤ supportedInfimum F hF S := by
  let e := supportedStandardProduct F hF
  change D ≤ e.symm (fun p => sInf ((fun R => e R p) '' S))
  calc
    D = e.symm (e D) := (e.symm_apply_apply D).symm
    _ ≤ _ := by
      apply e.symm.monotone
      intro p
      apply le_sInf
      rintro _ ⟨R, hR, rfl⟩
      exact (e.monotone (hD R hR)) p

theorem le_supportedSupremum (hF : F.Intrinsic) (S : Set (SupportedPartitions F))
    (D : SupportedPartitions F) (hD : D ∈ S) : D ≤ supportedSupremum F hF S := by
  let e := supportedStandardProduct F hF
  change D ≤ e.symm (fun p => sSup ((fun R => e R p) '' S))
  calc
    D = e.symm (e D) := (e.symm_apply_apply D).symm
    _ ≤ _ := by
      apply e.symm.monotone
      intro p
      have hp : e D p ∈ (fun R => e R p) '' S := ⟨D, hD, rfl⟩
      exact le_sSup hp

theorem supportedSupremum_le (hF : F.Intrinsic) (S : Set (SupportedPartitions F))
    (D : SupportedPartitions F) (hD : ∀ R ∈ S, R ≤ D) : supportedSupremum F hF S ≤ D := by
  let e := supportedStandardProduct F hF
  change e.symm (fun p => sSup ((fun R => e R p) '' S)) ≤ D
  calc
    _ ≤ e.symm (e D) := by
      apply e.symm.monotone
      intro p
      apply sSup_le
      rintro _ ⟨R, hR, rfl⟩
      exact (e.monotone (hD R hR)) p
    _ = D := e.symm_apply_apply D

/-- Greatest lower bound, in the original order on original edge partitions. -/
theorem supportedInfimum_isGLB (hF : F.Intrinsic) (S : Set (SupportedPartitions F)) :
    IsGLB S (supportedInfimum F hF S) :=
  ⟨fun D hD => supportedInfimum_le F hF S D hD,
    fun D hD => le_supportedInfimum F hF S D hD⟩

/-- Least upper bound, in the original order on original edge partitions. -/
theorem supportedSupremum_isLUB (hF : F.Intrinsic) (S : Set (SupportedPartitions F)) :
    IsLUB S (supportedSupremum F hF S) :=
  ⟨fun D hD => le_supportedSupremum F hF S D hD,
    fun D hD => supportedSupremum_le F hF S D hD⟩

/-- This order has all infima and suprema; the empty-set cases provide its bounds. -/
theorem obligatory_supported_has_bounds (hobl : F.IsObligatory)
    (S : Set (SupportedPartitions F)) :
    (∃ D : SupportedPartitions F, IsGLB S D) ∧
      (∃ D : SupportedPartitions F, IsLUB S D) := by
  have hi : F.Intrinsic :=
    ((isObligatory_iff_atomGenerated F).mp hobl).constructible.intrinsic
  exact ⟨⟨supportedInfimum F hi S, supportedInfimum_isGLB F hi S⟩,
    ⟨supportedSupremum F hi S, supportedSupremum_isLUB F hi S⟩⟩

end Erdos593.TripleSystem.CanonicalAtom
