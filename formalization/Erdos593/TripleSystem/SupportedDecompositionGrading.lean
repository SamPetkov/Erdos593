import Erdos593.Order.FiniteSetoidCover
import Erdos593.TripleSystem.SupportedDecompositionCovers
import Erdos593.TripleSystem.SupportedPieceDeficitAccounting

/-!
# Actual-piece grading of supported decompositions

This adapter retains the actual original-edge quotient cardinality. Finite
local partition covers are transported through the accepted order isomorphism;
the accepted piece-count equation then identifies a supported cover with the
loss of exactly one actual piece. No ambient-cover assertion, reducedness,
connected-parent hypothesis, or nonempty-edge premise is used.

Candidate only. In particular no maximal-chain-length or height endpoint is
claimed by this source without its own subsequent exact statement and review.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

open E593Separator

universe u

private theorem partition_block_card_antitone {A : Type u} [Finite A]
    {R S : Partition A} (h : R ≤ S) : Nat.card S.Block ≤ Nat.card R.Block :=
  E593FiniteSetoid.quotient_card_antitone
    ((E593Standard.partitionSetoidOrderIso A).monotone h)

private theorem partition_block_card_strict_antitone {A : Type u} [Finite A]
    {R S : Partition A} (h : R < S) : Nat.card S.Block < Nat.card R.Block :=
  E593FiniteSetoid.quotient_card_strict_antitone
    ((E593Standard.partitionSetoidOrderIso A).strictMono h)

private theorem partition_block_card_of_covBy {A : Type u} [Finite A]
    {R S : Partition A} (h : R ⋖ S) : Nat.card R.Block = Nat.card S.Block + 1 :=
  E593FiniteSetoid.quotient_card_of_covBy
    ((apply_covBy_apply_iff (E593Standard.partitionSetoidOrderIso A)).mpr h)

variable {V E : Type u} [Fintype V] [Fintype E]
  [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- Strict supported coarsening strictly decreases the actual original-edge piece count. -/
theorem supportedPartitions_block_card_strict_antitone (hF : F.Intrinsic)
    {D D' : SupportedPartitions F} (h : D < D') :
    Nat.card D'.val.Block < Nat.card D.val.Block := by
  classical
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hF.1 hF.2.1)
  have hprod := (supportedDecompositionProduct F hF).strictMono h
  obtain ⟨hle, p, hp⟩ := Pi.lt_def.mp hprod
  have hsum :
      (∑ q : ↥(sharedAtomPoints F hF.1 hF.2.1),
        Nat.card ((supportedDecompositionProduct F hF D' q).Block)) <
      ∑ q : ↥(sharedAtomPoints F hF.1 hF.2.1),
        Nat.card ((supportedDecompositionProduct F hF D q).Block) := by
    apply Finset.sum_lt_sum
    · intro q _
      exact partition_block_card_antitone (hle q)
    · exact ⟨p, Finset.mem_univ p, partition_block_card_strict_antitone hp⟩
  have hD := supportedPartitions_block_card_accounting F hF D
  have hD' := supportedPartitions_block_card_accounting F hF D'
  omega

/-- Each supported cover merges exactly two actual original-edge pieces. -/
theorem supportedPartitions_block_card_of_covBy (hF : F.Intrinsic)
    {D D' : SupportedPartitions F} (h : D ⋖ D') :
    Nat.card D.val.Block = Nat.card D'.val.Block + 1 := by
  classical
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hF.1 hF.2.1)
  obtain ⟨p, hp, hfixed⟩ := (supportedPartitions_covBy_iff F hF D D').mp h
  let I := ↥(sharedAtomPoints F hF.1 hF.2.1)
  let a : I → ℕ := fun q => Nat.card ((supportedDecompositionProduct F hF D q).Block)
  let b : I → ℕ := fun q => Nat.card ((supportedDecompositionProduct F hF D' q).Block)
  have hpcount : a p = b p + 1 := partition_block_card_of_covBy hp
  have herase :
      (∑ q ∈ (Finset.univ : Finset I).erase p, a q) =
        ∑ q ∈ (Finset.univ : Finset I).erase p, b q := by
    apply Finset.sum_congr rfl
    intro q hq
    exact congrArg (fun R : Partition (Star (atomIncident F hF.1 hF.2.1) q.val) =>
      Nat.card R.Block)
      (hfixed q (Finset.mem_erase.mp hq).1)
  have ha := Finset.add_sum_erase (Finset.univ : Finset I) a (Finset.mem_univ p)
  have hb := Finset.add_sum_erase (Finset.univ : Finset I) b (Finset.mem_univ p)
  have hsum : (∑ q : I, a q) = (∑ q : I, b q) + 1 := by omega
  have hD := supportedPartitions_block_card_accounting F hF D
  have hD' := supportedPartitions_block_card_accounting F hF D'
  change Nat.card D.val.Block + _ = Nat.card (Index F) + ∑ q : I, a q at hD
  change Nat.card D'.val.Block + _ = Nat.card (Index F) + ∑ q : I, b q at hD'
  omega

/-- Cover recognition in the supported subtype by actual piece count, in refinement order. -/
theorem supportedPartitions_covBy_iff_block_card (hF : F.Intrinsic)
    (D D' : SupportedPartitions F) :
    D ⋖ D' ↔ D < D' ∧ Nat.card D.val.Block = Nat.card D'.val.Block + 1 := by
  constructor
  · intro h
    exact ⟨h.lt, supportedPartitions_block_card_of_covBy F hF h⟩
  · rintro ⟨h, hcard⟩
    refine ⟨h, ?_⟩
    intro T hDT hTD'
    have h1 := supportedPartitions_block_card_strict_antitone F hF hDT
    have h2 := supportedPartitions_block_card_strict_antitone F hF hTD'
    omega

/-- The actual atom-relative deficit increases by one precisely at supported covers. -/
theorem supportedPartitions_covBy_iff_piece_deficit (hF : F.Intrinsic)
    (D D' : SupportedPartitions F) :
    D ⋖ D' ↔ D < D' ∧ supportedPieceDeficit F D' = supportedPieceDeficit F D + 1 := by
  have hD := supportedPieces_add_deficit F hF D
  have hD' := supportedPieces_add_deficit F hF D'
  rw [supportedPartitions_covBy_iff_block_card F hF D D']
  constructor
  · rintro ⟨h, hcard⟩
    exact ⟨h, by omega⟩
  · rintro ⟨h, hdeficit⟩
    exact ⟨h, by omega⟩

end Erdos593.TripleSystem.CanonicalAtom
