import Erdos593.TripleSystem.CanonicalAtomContainment
import Erdos593.TripleSystem.CanonicalAtomCounting
import Erdos593.TripleSystem.EmbeddingRestrictionTransport
import Erdos593.TripleSystem.OnePointAmalgamationIntrinsic

/-!
# Canonical atom labels under one-point amalgamation

The actual tagged edges from opposite factors have distinct atom labels.
Within the left factor, amalgamation preserves and reflects label equality.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem atomOf_amalgam_inl_ne_inr
    {V E W D : Type u}
    [Fintype V] [Fintype E] [Fintype W] [Fintype D]
    (F : TripleSystem V E) (T : TripleSystem W D)
    (hF : F.Intrinsic) (hT : T.Intrinsic)
    (r : V) (q : W) (e : E) (d : D) :
    let U := OnePointAmalgamation.amalgam F T r q
    letI : Fintype (OnePointAmalgamation.Vertex r q) :=
      OnePointAmalgamation.vertexFintype r q
    letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
    letI : DecidableEq (E ⊕ D) := Classical.decEq _
    letI : DecidableRel U.levi.Adj := Classical.decRel _
    let hU : U.Intrinsic :=
      OnePointAmalgamation.amalgam_intrinsic F T r q hF hT
    atomOf U hU.1 hU.2.1 (Sum.inl e) ≠
      atomOf U hU.1 hU.2.1 (Sum.inr d) :=
by
  let U := OnePointAmalgamation.amalgam F T r q
  letI : Fintype (OnePointAmalgamation.Vertex r q) :=
    OnePointAmalgamation.vertexFintype r q
  letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
  letI : DecidableEq (E ⊕ D) := Classical.decEq _
  letI : DecidableRel U.levi.Adj := Classical.decRel _
  let hU : U.Intrinsic :=
    OnePointAmalgamation.amalgam_intrinsic F T r q hF hT
  change atomOf U hU.1 hU.2.1 (Sum.inl e) ≠
    atomOf U hU.1 hU.2.1 (Sum.inr d)
  intro heq
  let A : Index U := atomOf U hU.1 hU.2.1 (Sum.inl e)
  let S : Set (E ⊕ D) := edges U hU.1 hU.2.1 A
  let L : Set (E ⊕ D) := Set.range (Sum.inl : E → E ⊕ D)
  let R : Set (E ⊕ D) := Set.range (Sum.inr : D → E ⊕ D)
  have heS : (Sum.inl e : E ⊕ D) ∈ S := rfl
  have hdS : (Sum.inr d : E ⊕ D) ∈ S := heq.symm
  have hcover : S ⊆ L ∪ R := by
    intro z _
    cases z with
    | inl x => exact Or.inl ⟨x, rfl⟩
    | inr y => exact Or.inr ⟨y, rfl⟩
  have hdisjoint : Disjoint L R := by
    apply Set.disjoint_left.mpr
    rintro z ⟨x, rfl⟩ ⟨y, h⟩
    cases h
  have hleftSupport :=
    Embedding.edgeSupportSet_image
      (OnePointAmalgamation.leftFactorEmbedding F T r q)
      (Set.univ : Set E)
  rw [Set.image_univ] at hleftSupport
  change U.edgeSupportSet L =
    OnePointAmalgamation.left r q '' F.edgeSupportSet Set.univ
    at hleftSupport
  have hrightSupport :=
    Embedding.edgeSupportSet_image
      (OnePointAmalgamation.rightFactorEmbedding F T r q)
      (Set.univ : Set D)
  rw [Set.image_univ] at hrightSupport
  change U.edgeSupportSet R =
    OnePointAmalgamation.right r q '' T.edgeSupportSet Set.univ
    at hrightSupport
  have hinter :
      (U.edgeSupportSet L ∩ U.edgeSupportSet R).Subsingleton := by
    rw [hleftSupport, hrightSupport]
    exact OnePointAmalgamation.cross_image_inter_subsingleton r q
      (F.edgeSupportSet Set.univ) (T.edgeSupportSet Set.univ)
  have hconnected : (U.edgeRestriction S).levi.Connected :=
    atomRestriction_connected U hU.1 hU.2.1 A
  have hindec : OnePointIndecomposable (U.edgeRestriction S) :=
    atomRestriction_onePointIndecomposable U hU A
  rcases edgeRestriction_subset_or_subset_of_support_inter_subsingleton
      U S L R hcover hdisjoint hinter hconnected hindec with hleft | hright
  · obtain ⟨x, hx⟩ := hleft hdS
    cases hx
  · obtain ⟨y, hy⟩ := hright heS
    cases hy

theorem atomOf_amalgam_inl_eq_iff
    {V E W D : Type u}
    [Fintype V] [Fintype E] [Fintype W] [Fintype D]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) (T : TripleSystem W D)
    [DecidableRel F.levi.Adj]
    (hF : F.Intrinsic) (hT : T.Intrinsic)
    (r : V) (q : W) (e f : E) :
    let U := OnePointAmalgamation.amalgam F T r q
    letI : Fintype (OnePointAmalgamation.Vertex r q) :=
      OnePointAmalgamation.vertexFintype r q
    letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
    letI : DecidableEq (E ⊕ D) := Classical.decEq _
    letI : DecidableRel U.levi.Adj := Classical.decRel _
    let hU : U.Intrinsic :=
      OnePointAmalgamation.amalgam_intrinsic F T r q hF hT
    (atomOf U hU.1 hU.2.1 (Sum.inl e) =
        atomOf U hU.1 hU.2.1 (Sum.inl f)) ↔
      atomOf F hF.1 hF.2.1 e = atomOf F hF.1 hF.2.1 f :=
by
  let U := OnePointAmalgamation.amalgam F T r q
  letI : Fintype (OnePointAmalgamation.Vertex r q) :=
    OnePointAmalgamation.vertexFintype r q
  letI : DecidableEq (OnePointAmalgamation.Vertex r q) := Classical.decEq _
  letI : DecidableEq (E ⊕ D) := Classical.decEq _
  letI : DecidableRel U.levi.Adj := Classical.decRel _
  let hU : U.Intrinsic :=
    OnePointAmalgamation.amalgam_intrinsic F T r q hF hT
  change (atomOf U hU.1 hU.2.1 (Sum.inl e) =
    atomOf U hU.1 hU.2.1 (Sum.inl f)) ↔
    atomOf F hF.1 hF.2.1 e = atomOf F hF.1 hF.2.1 f
  let j : F.Embedding U :=
    OnePointAmalgamation.leftFactorEmbedding F T r q
  constructor
  · intro heq
    let Q := edges U hU.1 hU.2.1 (atomOf U hU.1 hU.2.1 (Sum.inl e))
    let S : Set E := (Sum.inl : E → E ⊕ D) ⁻¹' Q
    have himage : j.edge '' S = Q := by
      ext z
      constructor
      · rintro ⟨g, hg, rfl⟩
        exact hg
      · intro hz
        cases z with
        | inl g => exact ⟨g, hz, rfl⟩
        | inr d =>
            have hd : atomOf U hU.1 hU.2.1 (Sum.inr d) =
                atomOf U hU.1 hU.2.1 (Sum.inl e) := hz
            exact False.elim ((atomOf_amalgam_inl_ne_inr F T hF hT r q e d) hd.symm)
    have hiso : Isomorphic (F.edgeRestriction S) (U.edgeRestriction Q) :=
      (congrArg (fun R : Set (E ⊕ D) =>
        Isomorphic (F.edgeRestriction S) (U.edgeRestriction R)) himage).mp
          (j.edgeRestriction_image_isomorphic S)
    obtain ⟨i⟩ := hiso
    have hc : (U.edgeRestriction Q).levi.Connected :=
      atomRestriction_connected U hU.1 hU.2.1 (atomOf U hU.1 hU.2.1 (Sum.inl e))
    have hi : OnePointIndecomposable (U.edgeRestriction Q) :=
      atomRestriction_onePointIndecomposable U hU (atomOf U hU.1 hU.2.1 (Sum.inl e))
    obtain ⟨A, hA⟩ := indecomposable_edgeRestriction_subset_atom F hF S
      (i.leviIso.connected_iff.mpr hc)
      ((onePointIndecomposable_iff_of_iso i).mpr hi)
    have heA : atomOf F hF.1 hF.2.1 e = A := hA (show e ∈ S from rfl)
    have hfA : atomOf F hF.1 hF.2.1 f = A := hA (show f ∈ S from heq.symm)
    exact heA.trans hfA.symm
  · intro heq
    let S := edges F hF.1 hF.2.1 (atomOf F hF.1 hF.2.1 e)
    obtain ⟨i⟩ := j.edgeRestriction_image_isomorphic S
    have hc : (F.edgeRestriction S).levi.Connected :=
      atomRestriction_connected F hF.1 hF.2.1 (atomOf F hF.1 hF.2.1 e)
    have hi : OnePointIndecomposable (F.edgeRestriction S) :=
      atomRestriction_onePointIndecomposable F hF (atomOf F hF.1 hF.2.1 e)
    obtain ⟨A, hA⟩ := indecomposable_edgeRestriction_subset_atom U hU (j.edge '' S)
      (i.leviIso.connected_iff.mp hc)
      ((onePointIndecomposable_iff_of_iso i).mp hi)
    have heA : atomOf U hU.1 hU.2.1 (Sum.inl e) = A :=
      hA ⟨e, rfl, rfl⟩
    have hfA : atomOf U hU.1 hU.2.1 (Sum.inl f) = A :=
      hA ⟨f, heq.symm, rfl⟩
    exact heA.trans hfA.symm

end Erdos593.TripleSystem.CanonicalAtom

