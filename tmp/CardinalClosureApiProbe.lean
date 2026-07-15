import Mathlib.SetTheory.Cardinal.Ordinal
import Mathlib.SetTheory.Ordinal.Basic

namespace CardinalClosureApiProbe

open Cardinal Set

universe u

#check Cardinal.mk_list_le_max
#check Cardinal.mk_iUnion_le
#check Cardinal.mk_iUnion_le_lift
#check Cardinal.mk_Iio_toType_ord_lt
#check Cardinal.mk_image_le
#check Cardinal.mul_eq_self
#check Cardinal.lift_aleph0
#check Cardinal.aleph0_le_mk
#check Function.iterate_succ_apply
#check Function.iterate_succ_apply'
#check List.toFinset_surjective
#check Cardinal.mk_le_of_surjective
#check Cardinal.mk_Iio_lt
#check Cardinal.mk_ord_toType
#check Cardinal.ord_cardinalMk
#check Cardinal.mk_uLift

def iterUnion {V : Type u} (f : Set V → Set V) (S : Set V) : Set V :=
  ⋃ n : ULift.{u} Nat, (f^[n.down]) S

theorem mk_iterUnion_le {V : Type u} (f : Set V → Set V) (S : Set V)
    (l : Cardinal.{u}) (hl : ℵ₀ ≤ l)
    (hstep : ∀ T : Set V, #(T) ≤ l → #(f T) ≤ l)
    (hS : #(S) ≤ l) :
    #(iterUnion f S) ≤ l := by
  have hiter : ∀ n : Nat, #((f^[n]) S) ≤ l := by
    intro n
    induction n with
    | zero => simpa using hS
    | succ n ih =>
        simpa [Function.iterate_succ_apply'] using hstep ((f^[n]) S) ih
  calc
    #(iterUnion f S) ≤ #(ULift.{u} Nat) * ⨆ n : ULift.{u} Nat, #((f^[n.down]) S) := by
      simpa [iterUnion] using
        Cardinal.mk_iUnion_le (fun n : ULift.{u} Nat => (f^[n.down]) S)
    _ ≤ l * l := by
      gcongr
      · simpa using hl
      · exact ciSup_le' fun n => hiter n.down
    _ = l := Cardinal.mul_eq_self hl

theorem mk_finset_le_max {A : Type u} :
    #(Finset A) ≤ max ℵ₀ #(A) := by
  classical
  calc
    #(Finset A) ≤ #(List A) := Cardinal.mk_le_of_surjective List.toFinset_surjective
    _ ≤ max ℵ₀ #(A) := Cardinal.mk_list_le_max A

def FinsetsInside {V : Type u} (S : Set V) :=
  {t : Finset V // (↑t : Set V) ⊆ S}

noncomputable def FinsetsInside.restrict {V : Type u} (S : Set V) :
    FinsetsInside S → Finset S := by
  classical
  exact fun t => t.1.subtype (fun x => x ∈ S)

theorem FinsetsInside.restrict_injective {V : Type u} (S : Set V) :
    Function.Injective (FinsetsInside.restrict S) := by
  classical
  intro x y hxy
  apply Subtype.ext
  have hx : ((FinsetsInside.restrict S x).map (Function.Embedding.subtype S)) = x.1 := by
    apply Finset.subtype_map_of_mem
    intro a ha
    exact x.2 (by simpa using ha)
  have hy : ((FinsetsInside.restrict S y).map (Function.Embedding.subtype S)) = y.1 := by
    apply Finset.subtype_map_of_mem
    intro a ha
    exact y.2 (by simpa using ha)
  calc
    x.1 = (FinsetsInside.restrict S x).map (Function.Embedding.subtype S) := hx.symm
    _ = (FinsetsInside.restrict S y).map (Function.Embedding.subtype S) := congrArg _ hxy
    _ = y.1 := hy

theorem mk_finsetsInside_le_max {V : Type u} (S : Set V) :
    #(FinsetsInside S) ≤ max ℵ₀ #(S) := by
  calc
    #(FinsetsInside S) ≤ #(Finset S) :=
      Cardinal.mk_le_of_injective (FinsetsInside.restrict_injective S)
    _ ≤ max ℵ₀ #(S) := mk_finset_le_max

def finiteStep {V : Type u}
    (F : ∀ S : Set V, FinsetsInside S → Finset V) (S : Set V) : Set V :=
  S ∪ ⋃ t : FinsetsInside S, (↑(F S t) : Set V)

theorem mk_finiteStep_le {V : Type u}
    (F : ∀ S : Set V, FinsetsInside S → Finset V) (S : Set V)
    (l : Cardinal.{u}) (hl : ℵ₀ ≤ l) (hS : #(S) ≤ l) :
    #(finiteStep F S) ≤ l := by
  have hindex : #(FinsetsInside S) ≤ l :=
    (mk_finsetsInside_le_max S).trans (max_le hl hS)
  have hout : ∀ t : FinsetsInside S, #((↑(F S t) : Set V)) ≤ l := by
    intro t
    calc
      #((↑(F S t) : Set V)) = (F S t).card := Cardinal.mk_coe_finset
      _ ≤ ℵ₀ := Cardinal.natCast_le_aleph0
      _ ≤ l := hl
  have houtputs : #(⋃ t : FinsetsInside S, (↑(F S t) : Set V)) ≤ l := by
    calc
      #(⋃ t : FinsetsInside S, (↑(F S t) : Set V)) ≤
          #(FinsetsInside S) * ⨆ t : FinsetsInside S, #((↑(F S t) : Set V)) :=
        Cardinal.mk_iUnion_le _
      _ ≤ l * l := by
        exact mul_le_mul' hindex (ciSup_le' hout)
      _ = l := Cardinal.mul_eq_self hl
  calc
    #(finiteStep F S) ≤ #(S) + #(⋃ t : FinsetsInside S, (↑(F S t) : Set V)) :=
      Cardinal.mk_union_le _ _
    _ ≤ l + l := add_le_add hS houtputs
    _ = l := Cardinal.add_eq_self hl

theorem mk_iteratedFiniteStep_le {V : Type u}
    (F : ∀ S : Set V, FinsetsInside S → Finset V) (S : Set V)
    (l : Cardinal.{u}) (hl : ℵ₀ ≤ l) (hS : #(S) ≤ l) :
    #(iterUnion (finiteStep F) S) ≤ l :=
  mk_iterUnion_le _ _ _ hl (fun T hT => mk_finiteStep_le F T l hl hT) hS

theorem mk_iteratedFiniteStep_lt {V : Type u}
    (F : ∀ S : Set V, FinsetsInside S → Finset V) (S : Set V)
    (k : Cardinal.{u}) (hk : ℵ₀ < k) (hS : #(S) < k) :
    #(iterUnion (finiteStep F) S) < k := by
  let l : Cardinal.{u} := max ℵ₀ #(S)
  have hl : ℵ₀ ≤ l := le_max_left _ _
  have hSl : #(S) ≤ l := le_max_right _ _
  exact (mk_iteratedFiniteStep_le F S l hl hSl).trans_lt (max_lt hk hS)

theorem mk_image_Iio_ord_lt {k : Cardinal.{u}} {V : Type u}
    (e : k.ord.ToType → V) (a : k.ord.ToType) :
    #(e '' Set.Iio a) < k := by
  apply Cardinal.mk_image_le.trans_lt
  refine (Cardinal.mk_Iio_lt a ?_).trans_eq (Cardinal.mk_ord_toType k)
  simp

theorem mk_image_Iic_ord_lt {k : Cardinal.{u}} {V : Type u}
    (e : k.ord.ToType → V) (a : k.ord.ToType) (hk : ℵ₀ ≤ k) :
    #(e '' Set.Iic a) < k := by
  apply Cardinal.mk_image_le.trans_lt
  refine (Cardinal.mk_Iic_lt a ?_ ?_).trans_eq (Cardinal.mk_ord_toType k)
  · simp
  · simpa using hk

end CardinalClosureApiProbe
