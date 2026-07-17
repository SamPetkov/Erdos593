import Erdos593.TripleSystem.ErdosRado.CanonicalTrace

/-!
# Conditional successor extension for canonical traces

This module supplies only local, source-backed trace infrastructure: an empty
prefix seed below a non-minimal endpoint and an operation that appends an
already supplied candidate. It does not assert that arbitrary live prefixes
have candidates, and it does not construct a global trace.
-/

namespace Erdos593
namespace TripleSystem
namespace TriangleHost
namespace ErdosRado

open scoped Cardinal Ordinal

/-- The canonical successor-cardinal trace carrier is nonempty. -/
noncomputable instance traceCarrierNonempty : Nonempty TraceCarrier :=
  Cardinal.nonempty_ord_toType (Cardinal.succ_ne_zero _)

/-- The canonical ordinal carrier has a least element. -/
noncomputable instance traceCarrierOrderBot : OrderBot TraceCarrier :=
  WellFoundedLT.toOrderBot TraceCarrier

local instance : IsEmpty (0 : Ordinal).ToType :=
  Ordinal.isEmpty_toType_iff.mpr rfl

namespace TracePrefix

/-- The empty trace prefix below a fixed endpoint. -/
noncomputable def empty (a : TraceCarrier) : TracePrefix a where
  length := 0
  length_le := bot_le
  node := fun i => isEmptyElim i
  node_lt_anchor := fun i => isEmptyElim i
  strictMono_node := by
    intro i
    exact isEmptyElim i

end TracePrefix

namespace TraceCandidate

/-- A non-minimal endpoint has a candidate for its empty prefix, namely the
least carrier point. This is an initial seed only, not a successor-existence
theorem for arbitrary prefixes. -/
theorem nonempty_empty_of_bot_lt (c : TraceColoring)
    {a : TraceCarrier} (ha : ⊥ < a) :
    Nonempty (TraceCandidate c (TracePrefix.empty a)) := by
  refine ⟨{
    live := by
      change (0 : Ordinal) < TraceHeight
      exact Cardinal.ord_pos.mpr (Cardinal.succ_pos _)
    value := ⊥
    lt_anchor := ha
    above_prefix := by
      intro i
      have hi : (i.toOrd : Ordinal) < 0 := by
        simpa [TracePrefix.empty] using i.toOrd.2
      exact (not_lt_of_ge bot_le hi).elim
    agrees := by
      intro i
      have hi : (i.toOrd : Ordinal) < 0 := by
        simpa [TracePrefix.empty] using i.toOrd.2
      exact (not_lt_of_ge bot_le hi).elim
  }⟩

/-- The empty prefix below `a` has a candidate exactly when `a` is non-minimal. -/
theorem nonempty_empty_iff_bot_lt (c : TraceColoring) {a : TraceCarrier} :
    Nonempty (TraceCandidate c (TracePrefix.empty a)) ↔ (⊥ : TraceCarrier) < a := by
  constructor
  · rintro ⟨q⟩
    exact lt_of_le_of_lt (show (⊥ : TraceCarrier) ≤ q.value from bot_le) q.lt_anchor
  · exact nonempty_empty_of_bot_lt c

/-- The bottom endpoint has no candidate for its empty prefix. This is the
explicit boundary complementary to `nonempty_empty_of_bot_lt`. -/
theorem not_nonempty_empty_bot (c : TraceColoring) :
    ¬ Nonempty (TraceCandidate c (TracePrefix.empty (⊥ : TraceCarrier))) := by
  rintro ⟨q⟩
  exact (not_lt_of_ge (show (⊥ : TraceCarrier) ≤ q.value from bot_le) q.lt_anchor).elim

end TraceCandidate

namespace TracePrefix

/-- The node map obtained by appending a supplied candidate value to a prefix. -/
noncomputable def snocNode {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    (Order.succ p.length).ToType → TraceCarrier := fun ξ ↦
  if hξ : (ξ.toOrd : Ordinal) < p.length then
    p.node (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩)
  else
    q.value

/-- Append a supplied live candidate to a trace prefix. This is conditional on
the candidate `q`; it does not establish a candidate for the new prefix. -/
noncomputable def snoc {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) : TracePrefix α where
  length := Order.succ p.length
  length_le := Order.succ_le_iff.mpr q.live
  node := p.snocNode q
  node_lt_anchor := by
    intro ξ
    by_cases hξ : (ξ.toOrd : Ordinal) < p.length
    · simpa [TracePrefix.snocNode, hξ] using
        p.node_lt_anchor (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩)
    · simpa [TracePrefix.snocNode, hξ] using q.lt_anchor
  strictMono_node := by
    intro ξ ζ hξζ
    have hOrd : (ξ.toOrd : Ordinal) < (ζ.toOrd : Ordinal) :=
      ((Ordinal.ToType.mk (o := Order.succ p.length)).symm.lt_iff_lt).mpr hξζ
    by_cases hx : (ξ.toOrd : Ordinal) < p.length
    · by_cases hy : (ζ.toOrd : Ordinal) < p.length
      · have hOld :
          (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hx⟩ : p.length.ToType) <
            Ordinal.ToType.mk ⟨(ζ.toOrd : Ordinal), hy⟩ :=
          (Ordinal.ToType.mk (o := p.length)).lt_iff_lt.mpr hOrd
        simpa [TracePrefix.snocNode, hx, hy] using p.strictMono_node hOld
      · simpa [TracePrefix.snocNode, hx, hy] using
          q.above_prefix (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hx⟩)
    · have hxle : (ξ.toOrd : Ordinal) ≤ p.length :=
        Order.lt_succ_iff.mp ξ.toOrd.2
      have hxEq : (ξ.toOrd : Ordinal) = p.length :=
        le_antisymm hxle (le_of_not_gt hx)
      have hyle : (ζ.toOrd : Ordinal) ≤ p.length :=
        Order.lt_succ_iff.mp ζ.toOrd.2
      have hcontra : p.length < (ζ.toOrd : Ordinal) := by
        simpa [hxEq] using hOrd
      exact (not_lt_of_ge hyle hcontra).elim

/-- At an index inherited from the old prefix, `snoc` keeps the old node. -/
theorem snoc_node_of_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (ξ : (Order.succ p.length).ToType)
    (hξ : (ξ.toOrd : Ordinal) < p.length) :
    (p.snoc q).node ξ =
      p.node (Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩) := by
  simp [TracePrefix.snoc, TracePrefix.snocNode, hξ]

/-- At the newly added index, `snoc` has the supplied candidate value. -/
theorem snoc_node_of_not_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (ξ : (Order.succ p.length).ToType)
    (hξ : ¬ (ξ.toOrd : Ordinal) < p.length) :
    (p.snoc q).node ξ = q.value := by
  simp [TracePrefix.snoc, TracePrefix.snocNode, hξ]

/-- The final index of an appended trace prefix. -/
noncomputable def snocLast {α : TraceCarrier} (p : TracePrefix α) :
    (Order.succ p.length).ToType :=
  Ordinal.ToType.mk ⟨p.length,
    Set.mem_Iio.mpr (Order.lt_succ_iff.mpr (le_refl _))⟩

theorem snocLast_toOrd {α : TraceCarrier} (p : TracePrefix α) :
    ((p.snocLast).toOrd : Ordinal) = p.length := by
  simp [TracePrefix.snocLast]

/-- The final node of an appended prefix is the supplied candidate value. -/
theorem snoc_node_last {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    (p.snoc q).node p.snocLast = q.value := by
  apply TracePrefix.snoc_node_of_not_lt
  simp [TracePrefix.snocLast_toOrd]

/-- Embed an old prefix index into the corresponding index of an appended
prefix. -/
noncomputable def snocLift {α : TraceCarrier} (p : TracePrefix α)
    (ξ : p.length.ToType) : (Order.succ p.length).ToType :=
  Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), Set.mem_Iio.mpr
    (Order.lt_succ_iff.mpr (le_of_lt (Set.mem_Iio.mp ξ.toOrd.2)))⟩

theorem snocLift_toOrd {α : TraceCarrier} (p : TracePrefix α)
    (ξ : p.length.ToType) : ((p.snocLift ξ).toOrd : Ordinal) = ξ.toOrd := by
  simp [TracePrefix.snocLift]

/-- The embedded old index retains its old node after conditional extension. -/
theorem snoc_node_lift {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) (ξ : p.length.ToType) :
    (p.snoc q).node (p.snocLift ξ) = p.node ξ := by
  have hlt : ((p.snocLift ξ).toOrd : Ordinal) < p.length := by
    rw [TracePrefix.snocLift_toOrd]
    exact Set.mem_Iio.mp ξ.toOrd.2
  rw [TracePrefix.snoc_node_of_lt p q (p.snocLift ξ) hlt]
  apply congrArg p.node
  calc
    Ordinal.ToType.mk ⟨((p.snocLift ξ).toOrd : Ordinal), Set.mem_Iio.mpr hlt⟩ =
        Ordinal.ToType.mk ξ.toOrd := by
      congr 1
      apply Subtype.ext
      simpa using p.snocLift_toOrd ξ
    _ = ξ := (Ordinal.ToType.mk (o := p.length)).apply_symm_apply ξ

/-- Every embedded old index precedes the new final index. -/
theorem snocLift_lt_last {α : TraceCarrier} (p : TracePrefix α)
    (ξ : p.length.ToType) : p.snocLift ξ < p.snocLast := by
  apply ((Ordinal.ToType.mk (o := Order.succ p.length)).symm.lt_iff_lt).mp
  change ((p.snocLift ξ).toOrd : Ordinal) < (p.snocLast.toOrd : Ordinal)
  rw [p.snocLift_toOrd, TracePrefix.snocLast_toOrd]
  exact Set.mem_Iio.mp ξ.toOrd.2

/-- Every index of an appended prefix is either inherited from the old prefix
or is the final index. -/
theorem snoc_index_lt_or_eq_last {α : TraceCarrier} (p : TracePrefix α)
    (ξ : (Order.succ p.length).ToType) :
    (ξ.toOrd : Ordinal) < p.length ∨ ξ = p.snocLast := by
  by_cases h : (ξ.toOrd : Ordinal) < p.length
  · exact Or.inl h
  · right
    have hle : (ξ.toOrd : Ordinal) ≤ p.length :=
      Order.lt_succ_iff.mp (Set.mem_Iio.mp ξ.toOrd.2)
    have heq : (ξ.toOrd : Ordinal) = p.length := le_antisymm hle (le_of_not_gt h)
    apply (Ordinal.ToType.mk (o := Order.succ p.length)).symm.injective
    apply Subtype.ext
    simpa only [TracePrefix.snocLast_toOrd] using heq

/-- The node range of a conditional successor extension consists exactly of
the old node range and the supplied candidate value. This is a local
decomposition and does not assert that a successor candidate exists. -/
theorem range_snoc_node {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    Set.range (p.snoc q).node = Set.range p.node ∪ {q.value} := by
  ext x
  constructor
  · rintro ⟨ξ, rfl⟩
    rcases p.snoc_index_lt_or_eq_last ξ with hξ | rfl
    · left
      refine ⟨Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), Set.mem_Iio.mpr hξ⟩, ?_⟩
      exact (TracePrefix.snoc_node_of_lt p q ξ hξ).symm
    · right
      simpa only [Set.mem_singleton_iff] using TracePrefix.snoc_node_last p q
  · intro hx
    rcases hx with hx | hx
    · rcases hx with ⟨ξ, rfl⟩
      exact ⟨p.snocLift ξ, p.snoc_node_lift q ξ⟩
    · rw [Set.mem_singleton_iff] at hx
      subst x
      exact ⟨p.snocLast, TracePrefix.snoc_node_last p q⟩

end TracePrefix

private theorem tracePair_congr {x y x' y' : TraceCarrier}
    (hx : x = x') (hy : y = y') (hxy : x ≠ y) (hx'y' : x' ≠ y') :
    tracePair x y hxy = tracePair x' y' hx'y' := by
  subst x
  subst y
  rfl

namespace TracePrefix

/-- Appending a supplied candidate preserves endhomogeneity to the fixed
endpoint; it asserts neither candidate existence nor a global trace. -/
theorem endhomogeneousTo_snoc {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (hp : p.EndhomogeneousTo c) :
    (p.snoc q).EndhomogeneousTo c := by
  unfold EndhomogeneousTo at hp ⊢
  intro ξ ζ hξζ
  rcases p.snoc_index_lt_or_eq_last ζ with hζ | hζ
  · have hξ : (ξ.toOrd : Ordinal) < p.length :=
      lt_of_lt_of_le
        (((Ordinal.ToType.mk (o := Order.succ p.length)).symm.lt_iff_lt).mpr hξζ)
        (le_of_lt hζ)
    let ξ' : p.length.ToType :=
      Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩
    let ζ' : p.length.ToType :=
      Ordinal.ToType.mk ⟨(ζ.toOrd : Ordinal), hζ⟩
    have hξζ' : ξ' < ζ' := by
      apply ((Ordinal.ToType.mk (o := p.length)).lt_iff_lt).mpr
      change (ξ.toOrd : Ordinal) < (ζ.toOrd : Ordinal)
      exact ((Ordinal.ToType.mk (o := Order.succ p.length)).symm.lt_iff_lt).mpr hξζ
    have hnodeξ : (p.snoc q).node ξ = p.node ξ' :=
      p.snoc_node_of_lt q ξ hξ
    have hnodeζ : (p.snoc q).node ζ = p.node ζ' :=
      p.snoc_node_of_lt q ζ hζ
    calc
      c (tracePair ((p.snoc q).node ξ) ((p.snoc q).node ζ)
          (ne_of_lt ((p.snoc q).node_lt_node hξζ))) =
          c (tracePair (p.node ξ') (p.node ζ')
            (ne_of_lt (p.node_lt_node hξζ'))) := by
              apply congrArg c
              exact tracePair_congr hnodeξ hnodeζ _ _
      _ = c (tracePair (p.node ξ') α (ne_of_lt (p.node_lt_anchor ξ'))) :=
          hp hξζ'
      _ = c (tracePair ((p.snoc q).node ξ) α
            (ne_of_lt ((p.snoc q).node_lt_anchor ξ))) := by
              apply congrArg c
              exact (tracePair_congr hnodeξ rfl _ _).symm
  · subst ζ
    rcases p.snoc_index_lt_or_eq_last ξ with hξ | hξ
    · let ξ' : p.length.ToType :=
        Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξ⟩
      have hnodeξ : (p.snoc q).node ξ = p.node ξ' :=
        p.snoc_node_of_lt q ξ hξ
      have hlast : (p.snoc q).node p.snocLast = q.value :=
        p.snoc_node_last q
      calc
        c (tracePair ((p.snoc q).node ξ) ((p.snoc q).node p.snocLast)
            (ne_of_lt ((p.snoc q).node_lt_node hξζ))) =
            c (tracePair (p.node ξ') q.value
              (ne_of_lt (q.above_prefix ξ'))) := by
                apply congrArg c
                exact tracePair_congr hnodeξ hlast _ _
        _ = c (tracePair (p.node ξ') α (ne_of_lt (p.node_lt_anchor ξ'))) :=
            q.agrees ξ'
        _ = c (tracePair ((p.snoc q).node ξ) α
              (ne_of_lt ((p.snoc q).node_lt_anchor ξ))) := by
                apply congrArg c
                exact (tracePair_congr hnodeξ rfl _ _).symm
    · exact (lt_irrefl _ (hξ ▸ hξζ)).elim

end TracePrefix

namespace TraceCandidate

/-- Any candidate for an appended prefix retains the required colour agreement
against every node of the original prefix. This theorem remains conditional on
the appended-prefix candidate `r`. -/
theorem exists_agrees_snoc_old {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) (ξ : p.length.ToType) :
    ∃ h : p.node ξ < r.value,
      c (tracePair (p.node ξ) r.value (ne_of_lt h)) =
        c (tracePair (p.node ξ) α (ne_of_lt (p.node_lt_anchor ξ))) := by
  have hξsucc : (ξ.toOrd : Ordinal) < Order.succ p.length :=
    Order.lt_succ_iff.mpr (le_of_lt ξ.toOrd.2)
  let ξ' : (Order.succ p.length).ToType :=
    Ordinal.ToType.mk ⟨(ξ.toOrd : Ordinal), hξsucc⟩
  have hnode : (p.snoc q).node ξ' = p.node ξ := by
    simp [ξ', TracePrefix.snoc, TracePrefix.snocNode]
    intro hle
    exact (not_lt_of_ge hle ξ.toOrd.2).elim
  have hlt : p.node ξ < r.value := by
    rw [← hnode]
    exact r.above_prefix ξ'
  refine ⟨hlt, ?_⟩
  simpa [hnode] using r.agrees ξ'

/-- A candidate for an appended prefix lies above every inherited old node.
This remains conditional on the appended-prefix candidate `r`. -/
theorem snoc_old_value_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) (ξ : p.length.ToType) :
    p.node ξ < r.value := by
  rw [← p.snoc_node_lift q ξ]
  exact r.above_prefix (p.snocLift ξ)

/-- A candidate for an appended prefix agrees with the anchor colour at every
inherited old node. This remains conditional on the candidate `r`. -/
theorem agrees_snoc_old {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) (ξ : p.length.ToType) :
    c (tracePair (p.node ξ) r.value
      (ne_of_lt (snoc_old_value_lt p q r ξ))) =
      c (tracePair (p.node ξ) α (ne_of_lt (p.node_lt_anchor ξ))) := by
  have h := r.agrees (p.snocLift ξ)
  simpa only [TracePrefix.snoc_node_lift] using h

/-- A candidate for an appended prefix lies above the appended value. This
remains conditional on the appended-prefix candidate `r`. -/
theorem snoc_value_lt {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) : q.value < r.value := by
  have h := r.above_prefix p.snocLast
  simpa [TracePrefix.snoc_node_last] using h

/-- A conditional successor extension only narrows the values eligible for a
candidate: every candidate for the appended prefix was already a candidate for
the old prefix. -/
theorem valueSet_snoc_subset {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    valueSet c (p.snoc q) ⊆ valueSet c p := by
  intro x hx
  rcases hx with ⟨r, hr⟩
  refine ⟨{
    live := q.live
    value := r.value
    lt_anchor := r.lt_anchor
    above_prefix := fun ξ => snoc_old_value_lt p q r ξ
    agrees := fun ξ => by
      simpa using agrees_snoc_old p q r ξ
  }, hr⟩

/-- Every conditional successor candidate is both an old candidate and above
the appended value. -/
theorem valueSet_snoc_subset_inter_Ioi {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p) :
    valueSet c (p.snoc q) ⊆ valueSet c p ∩ Set.Ioi q.value := by
  intro x hx
  rcases hx with ⟨r, hr⟩
  refine ⟨?_, ?_⟩
  · exact ⟨{
      live := q.live
      value := r.value
      lt_anchor := r.lt_anchor
      above_prefix := fun ξ => snoc_old_value_lt p q r ξ
      agrees := fun ξ => by
        simpa using agrees_snoc_old p q r ξ
    }, hr⟩
  · simpa [← hr] using snoc_value_lt p q r

/-- Conditional localization of the canonical successor minimum. -/
theorem least_snoc_value_mem_inter_Ioi {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (h : Nonempty (TraceCandidate c (p.snoc q))) :
    (least h).value ∈ valueSet c p ∩ Set.Ioi q.value := by
  apply valueSet_snoc_subset_inter_Ioi p q
  exact ⟨least h, rfl⟩

/-- Conditional strict growth of least candidate values across a supplied
successor extension. -/
theorem least_value_lt_least_snoc {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (hp : Nonempty (TraceCandidate c p))
    (hs : Nonempty (TraceCandidate c (p.snoc q))) :
    (least hp).value < (least hs).value := by
  exact lt_of_le_of_lt (least_value_le hp q)
    (Set.mem_Ioi.mp (least_snoc_value_mem_inter_Ioi p q hs).2)

/-- A candidate for an appended prefix agrees with the anchor colour at its
newly appended node. -/
theorem agrees_snoc_last {c : TraceColoring} {α : TraceCarrier}
    (p : TracePrefix α) (q : TraceCandidate c p)
    (r : TraceCandidate c (p.snoc q)) :
    c (tracePair q.value r.value (ne_of_lt (snoc_value_lt p q r))) =
      c (tracePair q.value α (ne_of_lt q.lt_anchor)) := by
  have h := r.agrees p.snocLast
  simpa [TracePrefix.snoc_node_last] using h

end TraceCandidate

end ErdosRado
end TriangleHost
end TripleSystem
end Erdos593
