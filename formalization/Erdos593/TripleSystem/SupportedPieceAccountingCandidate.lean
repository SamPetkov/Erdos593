import Erdos593.TripleSystem.SupportedStandardPartitions

/-!
# Actual supported-piece accounting — quarantined direct candidate

Source base: 5a927551fca3ec71565098d6491752f948763b46.
This file has not been elaborated, compiled, or accepted. It is intended for
source review before a separately authorized pinned-toolchain check.
The final statement retains the original edge-partition quotient cardinality.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

open E593Separator

universe u

variable {V E : Type u}

/-- Every original point is retained, including isolated ambient points.
Only the connectedness field of the supported decomposition is used here. -/
noncomputable def supportedPart_componentEquiv
    (F : TripleSystem V E) (R : Partition E)
    (hD : IsSupportedDecomposition F R) :
    F.levi.ConnectedComponent ≃
      (incidenceGraph (partIncident F R)).ConnectedComponent := by
  classical
  let H := incidenceGraph (partIncident F R)
  let rep (b : R.Block) : E :=
    Classical.choose (partEdges_nonempty R b)
  have rep_spec (b : R.Block) : R.block (rep b) = b :=
    Classical.choose_spec (partEdges_nonempty R b)
  let includePart (b : R.Block) :
      (F.edgeRestriction (partEdges R b)).levi →g F.levi :=
    ⟨Sum.map Subtype.val Subtype.val, by
      rintro (x | e) (y | f) h
      · exact False.elim
          ((F.edgeRestriction (partEdges R b)).not_levi_adj_point_point h)
      · exact F.levi_adj_point_edge.mpr
          ((F.edgeRestriction (partEdges R b)).levi_adj_point_edge.mp h)
      · exact F.levi_adj_edge_point.mpr
          ((F.edgeRestriction (partEdges R b)).levi_adj_edge_point.mp h)
      · exact False.elim
          ((F.edgeRestriction (partEdges R b)).not_levi_adj_edge_edge h)⟩
  have edge_path (b : R.Block) (e : E) (he : R.block e = b) :
      F.levi.Reachable (.inr (rep b)) (.inr e) :=
    ((hD.connected b).preconnected
      (.inr ⟨rep b, rep_spec b⟩)
      (.inr ⟨e, he⟩)).map (includePart b)
  have point_path (b : R.Block) (x : V) (hx : partIncident F R b x) :
      F.levi.Reachable (.inr (rep b)) (.inl x) :=
    ((hD.connected b).preconnected
      (.inr ⟨rep b, rep_spec b⟩)
      (.inl ⟨x, hx⟩)).map (includePart b)
  let f : V ⊕ E → R.Block ⊕ V
    | .inl x => .inr x
    | .inr e => .inl (R.block e)
  let g : R.Block ⊕ V → V ⊕ E
    | .inl b => .inr (rep b)
    | .inr x => .inl x
  refine _root_.SimpleGraph.FiniteForestCounting.componentEquivOfReachable
    F.levi H f g ?_ ?_ ?_ ?_
  · rintro (x | e) (y | d) h
    · exact False.elim (F.not_levi_adj_point_point h)
    · have hx : partIncident F R (R.block d) x :=
        ⟨d, rfl, F.levi_adj_point_edge.mp h⟩
      exact (show H.Adj (.inr x) (.inl (R.block d)) by
        simpa [H, incidenceGraph] using hx).reachable
    · have hy : partIncident F R (R.block e) y :=
        ⟨e, rfl, F.levi_adj_edge_point.mp h⟩
      exact (show H.Adj (.inl (R.block e)) (.inr y) by
        simpa [H, incidenceGraph] using hy).reachable
    · exact False.elim (F.not_levi_adj_edge_edge h)
  · rintro (b | x) (c | y) h
    · simp [H, incidenceGraph] at h
    · exact point_path b y (by simpa [H, incidenceGraph] using h)
    · exact (point_path c x (by simpa [H, incidenceGraph] using h)).symm
    · simp [H, incidenceGraph] at h
  · rintro (x | e)
    · exact .rfl
    · exact edge_path (R.block e) e rfl
  · rintro (b | x)
    · change H.Reachable (.inl (R.block (rep b))) (.inl b)
      rw [rep_spec b]
    · exact .rfl

variable [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- The accepted product's local relation before omitting nonshared points. -/
noncomputable def supportedLocalPartitionAll (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : V) :
    Partition (Star (atomIncident F hF.1 hF.2.1) p) :=
  restrict (atomIncident F hF.1 hF.2.1)
    (inducedAtomPartition F hF.1 hF.2.1 D.val) p

theorem supportedDecompositionProduct_apply_eq (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : ↥(sharedAtomPoints F hF.1 hF.2.1)) :
    supportedDecompositionProduct F hF D p =
      supportedLocalPartitionAll F hF D p.val := rfl

/-- Map a canonical atom incident at p to its actual original-edge piece. -/
private noncomputable def supportedStarToPart (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : V)
    (a : Star (atomIncident F hF.1 hF.2.1) p) :
    Star (partIncident F D.val) p := by
  refine ⟨D.val.block (decompositionAtomRep F hF.1 hF.2.1 a.val), ?_⟩
  obtain ⟨e, he, hp⟩ := a.property
  refine ⟨e, ?_, hp⟩
  apply (D.val.block_eq_iff _ _).mpr
  apply canonical_refines_supported_decomposition F hF D.val D.property
  exact he.trans (decompositionAtomRep_spec F hF.1 hF.2.1 a.val).symm

private noncomputable def supportedLocalBlockMap (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : V) :
    (supportedLocalPartitionAll F hF D p).Block →
      Star (partIncident F D.val) p :=
  Quotient.lift (supportedStarToPart F hF D p) (by
    intro a b hab
    apply Subtype.ext
    exact (D.val.block_eq_iff _ _).mpr hab)

private theorem supportedLocalBlockMap_injective (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : V) :
    Function.Injective (supportedLocalBlockMap F hF D p) := by
  intro x y
  refine Quotient.inductionOn₂ x y ?_
  intro a b h
  have hab :
      D.val.block (decompositionAtomRep F hF.1 hF.2.1 a.val) =
        D.val.block (decompositionAtomRep F hF.1 hF.2.1 b.val) :=
    congrArg Subtype.val h
  apply ((supportedLocalPartitionAll F hF D p).block_eq_iff a b).mpr
  exact (D.val.block_eq_iff _ _).mp hab

private theorem supportedLocalBlockMap_surjective (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : V) :
    Function.Surjective (supportedLocalBlockMap F hF D p) := by
  intro b
  obtain ⟨e, he, hp⟩ := b.property
  let a : Star (atomIncident F hF.1 hF.2.1) p :=
    ⟨atomOf F hF.1 hF.2.1 e, e, rfl, hp⟩
  refine ⟨(supportedLocalPartitionAll F hF D p).block a, ?_⟩
  apply Subtype.ext
  change D.val.block
    (decompositionAtomRep F hF.1 hF.2.1 (atomOf F hF.1 hF.2.1 e)) = b.val
  calc
    _ = D.val.block e := (D.val.block_eq_iff _ _).mpr
      (canonical_refines_supported_decomposition F hF D.val D.property _ _
        (decompositionAtomRep_spec F hF.1 hF.2.1 (atomOf F hF.1 hF.2.1 e)))
    _ = b.val := he

/-- The local quotient blocks are precisely the actual pieces incident at p.
No extra global connectedness or reducedness hypothesis is imposed. -/
noncomputable def supportedLocalBlockEquiv (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : V) :
    (supportedLocalPartitionAll F hF D p).Block ≃
      Star (partIncident F D.val) p :=
  Equiv.ofBijective (supportedLocalBlockMap F hF D p)
    ⟨supportedLocalBlockMap_injective F hF D p,
      supportedLocalBlockMap_surjective F hF D p⟩

/-- The equivalence uses the accepted product coordinate itself. -/
noncomputable def supportedProductBlockEquiv (hF : F.Intrinsic)
    (D : SupportedPartitions F)
    (p : ↥(sharedAtomPoints F hF.1 hF.2.1)) :
    (supportedDecompositionProduct F hF D p).Block ≃
      Star (partIncident F D.val) p.val :=
  supportedLocalBlockEquiv F hF D p.val

/-- Both full incidence forests have the same original Levi components. -/
theorem supportedPartitions_full_block_card_accounting
    (hF : F.Intrinsic) (D : SupportedPartitions F) :
    Nat.card D.val.Block +
        (∑ p : V, pointMultiplicity F hF.1 hF.2.1 p) =
      Nat.card (Index F) +
        (∑ p : V, Nat.card (Star (partIncident F D.val) p)) := by
  classical
  haveI : Finite (Index F) :=
    Finite.of_surjective _ (atomOf_surjective F hF.1 hF.2.1)
  letI : Fintype (Index F) := Fintype.ofFinite _
  haveI : Finite D.val.Block := Finite.of_surjective _ D.val.block_surjective
  letI : Fintype D.val.Block := Fintype.ofFinite _
  have hcA := Nat.card_congr (atomPoint_componentEquiv F hF.1 hF.2.1)
  have hcD := Nat.card_congr (supportedPart_componentEquiv F D.val D.property)
  have heA := _root_.SimpleGraph.FiniteForestCounting.card_incidence_edges
    (atomIncident F hF.1 hF.2.1)
  rw [_root_.SimpleGraph.FiniteForestCounting.sum_card_incidence_comm] at heA
  have hmu :
      (∑ p : V, Nat.card (Star (atomIncident F hF.1 hF.2.1) p)) =
        ∑ p : V, pointMultiplicity F hF.1 hF.2.1 p :=
    Finset.sum_congr rfl (fun p _ => canonicalStar_card F hF.1 hF.2.1 p)
  rw [hmu] at heA
  have heD := _root_.SimpleGraph.FiniteForestCounting.card_incidence_edges
    (partIncident F D.val)
  rw [_root_.SimpleGraph.FiniteForestCounting.sum_card_incidence_comm] at heD
  have hA := _root_.SimpleGraph.FiniteForestCounting.card_edges_add_components
    (atomPointIncidenceGraph F hF.1 hF.2.1)
    (atomPointIncidenceGraph_isAcyclic F hF.1 hF.2.1)
  change Nat.card (_root_.SimpleGraph.bipartiteIncidenceGraph
    (atomIncident F hF.1 hF.2.1)).edgeSet + _ = _ at hA
  rw [heA, ← hcA, Nat.card_sum] at hA
  have hD := _root_.SimpleGraph.FiniteForestCounting.card_edges_add_components
    (incidenceGraph (partIncident F D.val)) D.property.forest
  change Nat.card (_root_.SimpleGraph.bipartiteIncidenceGraph
    (partIncident F D.val)).edgeSet + _ = _ at hD
  rw [heD, ← hcD, Nat.card_sum] at hD
  change (∑ p : V, Nat.card (Star (partIncident F D.val) p)) +
    Nat.card F.levi.ConnectedComponent = Nat.card D.val.Block + Nat.card V at hD
  omega

/-- At an unshared point, the empty or singleton star loses no quotient blocks. -/
theorem nonshared_piece_incidence_card (hF : F.Intrinsic)
    (D : SupportedPartitions F) (p : V)
    (hp : p ∉ sharedAtomPoints F hF.1 hF.2.1) :
    pointMultiplicity F hF.1 hF.2.1 p =
      Nat.card (Star (partIncident F D.val) p) := by
  letI := nonshared_star_subsingleton F hF.1 hF.2.1 p hp
  let Q := supportedLocalPartitionAll F hF D p
  have hq : Nat.card (Star (atomIncident F hF.1 hF.2.1) p) = Nat.card Q.Block :=
    Nat.card_congr (Equiv.ofBijective Q.block
      ⟨fun _ _ _ => Subsingleton.elim _ _, Q.block_surjective⟩)
  calc
    pointMultiplicity F hF.1 hF.2.1 p =
        Nat.card (Star (atomIncident F hF.1 hF.2.1) p) :=
      (canonicalStar_card F hF.1 hF.2.1 p).symm
    _ = Nat.card Q.Block := hq
    _ = Nat.card (Star (partIncident F D.val) p) :=
      Nat.card_congr (supportedLocalBlockEquiv F hF D p)

/-- Exact frozen actual-piece identity, with no reducedness or nonemptiness gate. -/
theorem supportedPartitions_block_card_accounting
    (hF : F.Intrinsic) (D : SupportedPartitions F) :
    Nat.card D.val.Block +
        (∑ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
          pointMultiplicity F hF.1 hF.2.1 p.val) =
      Nat.card (Index F) +
        (∑ p : ↥(sharedAtomPoints F hF.1 hF.2.1),
          Nat.card ((supportedDecompositionProduct F hF D p).Block)) := by
  classical
  let S := sharedAtomPoints F hF.1 hF.2.1
  let mu : V → ℕ := pointMultiplicity F hF.1 hF.2.1
  let nu : V → ℕ := fun p => Nat.card (Star (partIncident F D.val) p)
  have hfull := supportedPartitions_full_block_card_accounting F hF D
  change Nat.card D.val.Block + (∑ p : V, mu p) =
    Nat.card (Index F) + (∑ p : V, nu p) at hfull
  have hmu := Finset.sum_add_sum_compl S mu
  have hnu := Finset.sum_add_sum_compl S nu
  have houtside : (∑ p ∈ Sᶜ, mu p) = ∑ p ∈ Sᶜ, nu p := by
    apply Finset.sum_congr rfl
    intro p hp
    exact nonshared_piece_incidence_card F hF D p (Finset.mem_compl.mp hp)
  have hshared : Nat.card D.val.Block + (∑ p ∈ S, mu p) =
      Nat.card (Index F) + (∑ p ∈ S, nu p) := by
    omega
  have hleft : (∑ p : ↥S, mu p.val) = ∑ p ∈ S, mu p :=
    Finset.sum_coe_sort S mu
  have hright :
      (∑ p : ↥S, Nat.card ((supportedDecompositionProduct F hF D p).Block)) =
        ∑ p ∈ S, nu p := by
    calc
      _ = ∑ p : ↥S, nu p.val := Finset.sum_congr rfl
        (fun p _ => Nat.card_congr (supportedProductBlockEquiv F hF D p))
      _ = _ := Finset.sum_coe_sort S nu
  change Nat.card D.val.Block + (∑ p : ↥S, mu p.val) =
    Nat.card (Index F) +
      (∑ p : ↥S, Nat.card ((supportedDecompositionProduct F hF D p).Block))
  rw [hleft, hright]
  exact hshared

end Erdos593.TripleSystem.CanonicalAtom
