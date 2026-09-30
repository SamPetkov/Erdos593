import Erdos593.TripleSystem.EdgeRestriction
import Erdos593.TripleSystem.Isolated
import Erdos593.TripleSystem.Levi
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected

/-!
# Disconnected supported restrictions

Candidate only. Partitions use the original edge carrier, not an assembly list.
No canonical import or previously accepted source is changed.
-/

namespace Erdos593.TripleSystem.SupportedBlocks

universe u v

/-- A disconnected reduced Levi graph has a nontrivial edge partition with
disjoint point supports. No finite-carrier assumption is needed. -/
theorem exists_disjoint_support_partition_of_not_connected
    {V : Type u} {E : Type v} (F : TripleSystem V E)
    (hreduced : F.HasNoIsolatedPoints) (hnonempty : Nonempty E)
    (hnotconnected : ¬F.levi.Connected) :
    ∃ L R : Set E, L.Nonempty ∧ R.Nonempty ∧ Disjoint L R ∧
      L ∪ R = Set.univ ∧ Disjoint (F.edgeSupportSet L) (F.edgeSupportSet R) := by
  classical
  have hnotpre : ¬F.levi.Preconnected := by
    intro hpre
    obtain ⟨e⟩ := hnonempty
    exact hnotconnected (@SimpleGraph.Connected.mk _ _ hpre ⟨Sum.inr e⟩)
  obtain ⟨a, b, hab⟩ : ∃ a b : V ⊕ E, ¬F.levi.Reachable a b := by
    obtain ⟨a, ha⟩ := not_forall.mp hnotpre
    obtain ⟨b, hb⟩ := not_forall.mp ha
    exact ⟨a, b, hb⟩
  have htoEdge : ∀ z : V ⊕ E, ∃ e : E, F.levi.Reachable z (Sum.inr e) := by
    rintro (x | e)
    · obtain ⟨e, hxe⟩ := F.not_isolated_iff_exists_inc.mp (hreduced x)
      exact ⟨e, (F.levi_adj_point_edge.mpr hxe).reachable⟩
    · exact ⟨e, SimpleGraph.Reachable.rfl⟩
  obtain ⟨e₀, ha⟩ := htoEdge a
  obtain ⟨e₁, hb⟩ := htoEdge b
  have hseparate : ¬F.levi.Reachable (Sum.inr e₀) (Sum.inr e₁) := by
    intro h
    exact hab (ha.trans (h.trans hb.symm))
  let L : Set E := {e | F.levi.Reachable (Sum.inr e₀) (Sum.inr e)}
  let R : Set E := Lᶜ
  refine ⟨L, R, ⟨e₀, SimpleGraph.Reachable.rfl⟩, ⟨e₁, hseparate⟩,
    Set.disjoint_left.mpr (fun _ he hg => hg he), Set.union_compl_self L, ?_⟩
  apply Set.disjoint_left.mpr
  rintro x ⟨e, he, hxe⟩ ⟨g, hg, hxg⟩
  exact hg (he.trans ((F.levi_adj_edge_point.mpr hxe).reachable.trans
    (F.levi_adj_point_edge.mpr hxg).reachable))

/-- Push the partition of a supported restriction back to literal ambient
edge subsets. Isolated points of the ambient system are unrestricted. -/
theorem exists_original_partition_of_disconnected_restriction
    {V : Type u} {E : Type v} (F : TripleSystem V E)
    (S : Set E) (hS : S.Nonempty)
    (hnotconnected : ¬(F.edgeRestriction S).levi.Connected) :
    ∃ L R : Set E, L.Nonempty ∧ R.Nonempty ∧ Disjoint L R ∧
      L ∪ R = S ∧ Disjoint (F.edgeSupportSet L) (F.edgeSupportSet R) := by
  classical
  have hnonempty : Nonempty S := ⟨⟨hS.choose, hS.choose_spec⟩⟩
  have hreduced : (F.edgeRestriction S).HasNoIsolatedPoints := by
    intro x hx
    obtain ⟨e, he, hxe⟩ := x.property
    exact hx ⟨e, he⟩ hxe
  obtain ⟨A, B, hA, hB, hdisjoint, htotal, hsupports⟩ :=
    exists_disjoint_support_partition_of_not_connected
      (F.edgeRestriction S) hreduced hnonempty hnotconnected
  let L : Set E := Subtype.val '' A
  let R : Set E := Subtype.val '' B
  refine ⟨L, R, hA.image _, hB.image _, ?_, ?_, ?_⟩
  · apply Set.disjoint_left.mpr
    rintro e ⟨a, ha, hae⟩ ⟨b, hb, hbe⟩
    have hab : a = b := Subtype.ext (hae.trans hbe.symm)
    exact Set.disjoint_left.mp hdisjoint (hab ▸ ha) hb
  · apply Set.Subset.antisymm
    · rintro e (⟨a, _, rfl⟩ | ⟨b, _, rfl⟩)
      · exact a.property
      · exact b.property
    · intro e he
      let a : S := ⟨e, he⟩
      rcases (htotal ▸ Set.mem_univ a : a ∈ A ∪ B) with ha | hb
      · exact Or.inl ⟨a, ha, rfl⟩
      · exact Or.inr ⟨a, hb, rfl⟩
  · apply Set.disjoint_left.mpr
    rintro x ⟨e, ⟨a, ha, rfl⟩, hxe⟩ ⟨g, ⟨b, hb, rfl⟩, hxg⟩
    let xS : F.EdgeSupport S := ⟨x, a.1, a.2, hxe⟩
    exact Set.disjoint_left.mp hsupports
      (show xS ∈ (F.edgeRestriction S).edgeSupportSet A from ⟨a, ha, hxe⟩)
      (show xS ∈ (F.edgeRestriction S).edgeSupportSet B from ⟨b, hb, hxg⟩)

end Erdos593.TripleSystem.SupportedBlocks
