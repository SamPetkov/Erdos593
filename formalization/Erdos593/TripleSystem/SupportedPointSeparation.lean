import Erdos593.TripleSystem.EdgeRestriction
import Erdos593.TripleSystem.Isolated
import Erdos593.TripleSystem.Levi
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected

/-!
# Point deletion and literal edge separations

Candidate only: no canonical imports or accepted proof bodies are changed.
Only point nodes may be deleted. Every original hyperedge node is retained.
-/

namespace Erdos593.TripleSystem.SupportedBlocks

universe u v

variable {V : Type u} {E : Type v}

/-- Point-nonseparability, independently of obligatoriness or canonical atoms. -/
def PointNonseparable (F : TripleSystem V E) : Prop :=
  F.levi.Connected ∧
    ∀ r : V, (F.levi.induce {z : V ⊕ E | z ≠ Sum.inl r}).Connected

/-- A literal original-edge partition meeting in exactly one point. -/
def IsPointSeparation (F : TripleSystem V E) (L R : Set E) (r : V) : Prop :=
  L.Nonempty ∧ R.Nonempty ∧ Disjoint L R ∧ L ∪ R = Set.univ ∧
    F.edgeSupportSet L ∩ F.edgeSupportSet R = {r}

/-- Existence of a literal nontrivial point separation. -/
def HasPointSeparation (F : TripleSystem V E) : Prop :=
  ∃ L R : Set E, ∃ r : V, IsPointSeparation F L R r

private abbrev RemainingNode (r : V) :=
  {z : V ⊕ E // z ≠ Sum.inl r}

private def retainedEdge (r : V) (e : E) : RemainingNode (E := E) r :=
  ⟨Sum.inr e, Sum.inr_ne_inl⟩

/-- In a connected Levi graph, two nonempty complementary edge parts cannot
have disjoint point supports. No finiteness or linearity is needed. -/
theorem support_inter_nonempty_of_partition
    (F : TripleSystem V E) (hconnected : F.levi.Connected)
    (L R : Set E) (hL : L.Nonempty) (hR : R.Nonempty)
    (hdisjoint : Disjoint L R) (htotal : L ∪ R = Set.univ) :
    (F.edgeSupportSet L ∩ F.edgeSupportSet R).Nonempty := by
  classical
  obtain ⟨e₀, he₀⟩ := hL
  obtain ⟨e₁, he₁⟩ := hR
  by_contra hmeet
  let X : V ⊕ E → Prop :=
    Sum.elim (fun x => x ∈ F.edgeSupportSet L) (fun e => e ∈ L)
  have hstep : ∀ z w : V ⊕ E, X z → F.levi.Adj z w → X w := by
    rintro (x | e) (y | g) hz hadj
    · exact (F.not_levi_adj_point_point hadj).elim
    · have hxg : F.Inc x g := F.levi_adj_point_edge.mp hadj
      rcases (htotal ▸ Set.mem_univ g : g ∈ L ∪ R) with hgL | hgR
      · exact hgL
      · exact (hmeet ⟨x, hz, ⟨g, hgR, hxg⟩⟩).elim
    · exact ⟨e, hz, F.levi_adj_edge_point.mp hadj⟩
    · exact (F.not_levi_adj_edge_edge hadj).elim
  have hwalk : ∀ z w : V ⊕ E, F.levi.Walk z w → X z → X w := by
    intro z w p
    induction p with
    | nil => exact id
    | cons hadj _ ih => exact fun hz => ih (hstep _ _ hz hadj)
  obtain ⟨p⟩ := hconnected.preconnected (Sum.inr e₀) (Sum.inr e₁)
  exact Set.disjoint_left.mp hdisjoint (hwalk _ _ p he₀) he₁

/-- A one-point edge separation disconnects the Levi graph after its shared
POINT is deleted; the hyperedge nodes on both sides survive. -/
theorem pointDeletion_not_connected_of_separation
    (F : TripleSystem V E) (L R : Set E) (r : V)
    (hsep : IsPointSeparation F L R r) :
    ¬(F.levi.induce {z : V ⊕ E | z ≠ Sum.inl r}).Connected := by
  classical
  obtain ⟨hL, hR, hdisjoint, htotal, hinter⟩ := hsep
  obtain ⟨e₀, he₀⟩ := hL
  obtain ⟨e₁, he₁⟩ := hR
  let G := F.levi.induce {z : V ⊕ E | z ≠ Sum.inl r}
  let X : RemainingNode (E := E) r → Prop :=
    fun z => Sum.elim (fun x => x ∈ F.edgeSupportSet L) (fun e => e ∈ L) z.1
  have hstep : ∀ z w : RemainingNode (E := E) r,
      X z → G.Adj z w → X w := by
    rintro ⟨z, hz⟩ ⟨w, hw⟩ hX hadj
    rcases z with x | e <;> rcases w with y | g
    · exact (F.not_levi_adj_point_point hadj).elim
    · have hxg : F.Inc x g := F.levi_adj_point_edge.mp hadj
      rcases (htotal ▸ Set.mem_univ g : g ∈ L ∪ R) with hgL | hgR
      · exact hgL
      · have hxroot : x = r := Set.mem_singleton_iff.mp
          (hinter ▸ (show x ∈ F.edgeSupportSet L ∩ F.edgeSupportSet R from
            ⟨hX, ⟨g, hgR, hxg⟩⟩))
        exact (hz (congrArg Sum.inl hxroot)).elim
    · exact ⟨e, hX, F.levi_adj_edge_point.mp hadj⟩
    · exact (F.not_levi_adj_edge_edge hadj).elim
  have hwalk : ∀ z w : RemainingNode (E := E) r,
      G.Walk z w → X z → X w := by
    intro z w p
    induction p with
    | nil => exact id
    | cons hadj _ ih => exact fun hz => ih (hstep _ _ hz hadj)
  intro hconnected
  obtain ⟨p⟩ := hconnected.preconnected (retainedEdge r e₀) (retainedEdge r e₁)
  exact Set.disjoint_left.mp hdisjoint (hwalk _ _ p he₀) he₁

/-- Every disconnected point deletion of a connected reduced system determines
a literal edge partition. In particular, this does not assume Intrinsic. -/
theorem exists_separation_of_pointDeletion_not_connected
    (F : TripleSystem V E) (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints) (hnonempty : Nonempty E)
    (r : V)
    (hdeleted : ¬(F.levi.induce {z : V ⊕ E | z ≠ Sum.inl r}).Connected) :
    ∃ L R : Set E, IsPointSeparation F L R r := by
  classical
  let G := F.levi.induce {z : V ⊕ E | z ≠ Sum.inl r}
  have hnotpre : ¬G.Preconnected := by
    intro hpre
    obtain ⟨e⟩ := hnonempty
    exact hdeleted (@SimpleGraph.Connected.mk _ _ hpre
      ⟨⟨Sum.inr e, Sum.inr_ne_inl⟩⟩)
  obtain ⟨a, b, hab⟩ : ∃ a b : RemainingNode (E := E) r, ¬G.Reachable a b := by
    obtain ⟨a, ha⟩ := not_forall.mp hnotpre
    obtain ⟨b, hb⟩ := not_forall.mp ha
    exact ⟨a, b, hb⟩
  have htoEdge : ∀ z : RemainingNode (E := E) r,
      ∃ e : E, G.Reachable z (retainedEdge r e) := by
    rintro ⟨x | e, hz⟩
    · obtain ⟨e, hxe⟩ := F.not_isolated_iff_exists_inc.mp (hreduced x)
      refine ⟨e, SimpleGraph.Adj.reachable ?_⟩
      exact F.levi_adj_point_edge.mpr hxe
    · exact ⟨e, SimpleGraph.Reachable.rfl⟩
  obtain ⟨e₀, ha⟩ := htoEdge a
  obtain ⟨e₁, hb⟩ := htoEdge b
  have hseparate : ¬G.Reachable (retainedEdge r e₀) (retainedEdge r e₁) := by
    intro h
    exact hab (ha.trans (h.trans hb.symm))
  let L : Set E := {e | G.Reachable (retainedEdge r e₀) (retainedEdge r e)}
  let R : Set E := Lᶜ
  have hL : L.Nonempty := ⟨e₀, SimpleGraph.Reachable.rfl⟩
  have hR : R.Nonempty := ⟨e₁, hseparate⟩
  have hdisjoint : Disjoint L R :=
    Set.disjoint_left.mpr (fun _ he hg => hg he)
  have htotal : L ∪ R = Set.univ := Set.union_compl_self L
  have hsub : ∀ x : V,
      x ∈ F.edgeSupportSet L ∩ F.edgeSupportSet R → x = r := by
    rintro x ⟨⟨e, he, hxe⟩, ⟨g, hg, hxg⟩⟩
    by_contra hxr
    let z : RemainingNode (E := E) r :=
      ⟨Sum.inl x, fun h => hxr (Sum.inl.inj h)⟩
    have hez : G.Adj (retainedEdge r e) z := F.levi_adj_edge_point.mpr hxe
    have hzg : G.Adj z (retainedEdge r g) := F.levi_adj_point_edge.mpr hxg
    exact hg (he.trans (hez.reachable.trans hzg.reachable))
  obtain ⟨x, hx⟩ := support_inter_nonempty_of_partition
    F hconnected L R hL hR hdisjoint htotal
  have hxr : x = r := hsub x hx
  have hroot : r ∈ F.edgeSupportSet L ∩ F.edgeSupportSet R := hxr ▸ hx
  refine ⟨L, R, hL, hR, hdisjoint, htotal, Set.Subset.antisymm ?_ ?_⟩
  · exact fun y hy => Set.mem_singleton_iff.mpr (hsub y hy)
  · intro y hy
    have hyr : y = r := Set.mem_singleton_iff.mp hy
    exact hyr.symm ▸ hroot

/-- The independent point-deletion test agrees with absence of a literal
edge separation. This light kernel does not require finite carriers. -/
theorem pointNonseparable_iff_no_pointSeparation
    (F : TripleSystem V E) (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints) (hnonempty : Nonempty E) :
    PointNonseparable F ↔ ¬HasPointSeparation F := by
  classical
  constructor
  · rintro ⟨_, hpoint⟩ ⟨L, R, r, hsep⟩
    exact pointDeletion_not_connected_of_separation F L R r hsep (hpoint r)
  · intro hnosep
    refine ⟨hconnected, fun r => ?_⟩
    by_contra hdeleted
    obtain ⟨L, R, hsep⟩ := exists_separation_of_pointDeletion_not_connected
      F hconnected hreduced hnonempty r hdeleted
    exact hnosep ⟨L, R, r, hsep⟩

end Erdos593.TripleSystem.SupportedBlocks
