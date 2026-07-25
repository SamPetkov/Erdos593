import Erdos593.UniformSystem.Coloring
import Erdos593.UniformSystem.SequenceLift

/-!
# Countable-colouring obstruction for the uniform one-apex lift

The proof is the uniform analogue of the graph-to-triple branch argument.  It
is stated at `ℵ₁`, which is sufficient for the non-obligatoriness witnesses.
-/

namespace Erdos593

open scoped Cardinal Ordinal

universe u

namespace UniformSequenceLift

variable {s : ℕ} {V E : Type u} {H : UniformSystem s V E}

/-- One base edge monochromatic in the fibre over a sequence node. -/
structure MonoEdgeAt (c : Point H → ℕ) (q : Node E) where
  edge : E
  point : V
  point_inc : H.Inc point edge
  color_eq : ∀ x : V, H.Inc x edge → c (q, x) = c (q, point)

/-- Every slice contains a monochromatic base edge when the base has no proper
natural-number colouring. -/
theorem nonempty_monoEdgeAt (hs : s ≠ 0)
    (hH : ∀ d : V → ℕ, ¬ H.IsProperColoring d)
    (c : Point H → ℕ) (q : Node E) :
    Nonempty (MonoEdgeAt c q) := by
  have hnot := hH (fun x : V => c (q, x))
  obtain ⟨e, he⟩ := Classical.not_forall.mp hnot
  have hmono : ∀ x : V, H.Inc x e → ∀ y : V, H.Inc y e →
      c (q, x) = c (q, y) := by
    intro x hx y hy
    by_contra hxy
    exact he ⟨x, hx, y, hy, hxy⟩
  have hne : H.edgeSet e ≠ ∅ := by
    intro hempty
    have hcard := H.edgeSet_ncard e
    rw [hempty, Set.ncard_empty] at hcard
    exact hs hcard.symm
  obtain ⟨x, hx⟩ := Set.nonempty_iff_ne_empty.mpr hne
  exact ⟨⟨e, x, hx, fun y hy => hmono y hy x hx⟩⟩

noncomputable def chosenMonoEdge (hs : s ≠ 0)
    (hH : ∀ d : V → ℕ, ¬ H.IsProperColoring d)
    (c : Point H → ℕ) (q : Node E) : MonoEdgeAt c q :=
  Classical.choice (nonempty_monoEdgeAt hs hH c q)

/-- If the base has no proper natural-number colouring, neither does its
uniform one-apex lift. -/
theorem not_isProperColoring_nat (hs : s ≠ 0)
    (hH : ∀ d : V → ℕ, ¬ H.IsProperColoring d)
    (c : Point H → ℕ) :
    ¬ (H.system hs).IsProperColoring c := by
  intro hc
  let M : (q : Node E) → MonoEdgeAt c q :=
    fun q => chosenMonoEdge hs hH c q
  let pick : Node E → E := fun q => (M q).edge
  let a : Index → E := branchLetter pick
  let q : Index → Node E := branchNode a
  let k : Index → ℕ := fun α => c (q α, (M (q α)).point)
  have hk_lt : ∀ {α β : Index}, α < β → k α ≠ k β := by
    intro α β hαβ hk
    have ha : a α = (M (q α)).edge := by
      simpa [a, q, pick] using branchLetter_eq pick α
    have hext : (q α).ExtendsBy (M (q α)).edge (q β) := by
      rw [← ha]
      exact branchNode_extendsBy a hαβ
    let e : Edge H :=
      H.mkEdge (q α) (q β) (M (q α)).edge (M (q β)).point hext
    rcases hc e with ⟨p, hp, p', hp', hne⟩
    have hmono : ∀ {w : Point H}, (H.system hs).Inc w e → c w = k α := by
      intro w hw
      change (H.system hs).Inc w
        (H.mkEdge (q α) (q β) (M (q α)).edge (M (q β)).point hext) at hw
      rcases (H.inc_mkEdge_iff hs).mp hw with hapex | ⟨x, hx, hbase⟩
      · subst w
        simpa [k] using hk.symm
      · subst w
        simpa [k] using (M (q α)).color_eq x hx
    exact hne ((hmono hp).trans (hmono hp').symm)
  have hk_injective : Function.Injective k := by
    intro α β hab
    rcases lt_trichotomy α β with hlt | heq | hgt
    · exact (hk_lt hlt hab).elim
    · exact heq
    · exact (hk_lt hgt hab.symm).elim
  let ku : Index → ULift.{u} ℕ := fun α => ULift.up (k α)
  have hku_injective : Function.Injective ku :=
    fun α β h => hk_injective (congrArg ULift.down h)
  have hcard : #(Index : Type u) ≤ #(ULift.{u} ℕ) :=
    Cardinal.mk_le_of_injective hku_injective
  have haleph : (ℵ₁ : Cardinal.{u}) ≤ (ℵ₀ : Cardinal.{u}) := by
    simp [Index] at hcard
  exact Cardinal.aleph0_lt_aleph_one.2 haleph

end UniformSequenceLift

end Erdos593
