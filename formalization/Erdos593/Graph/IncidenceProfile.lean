import Mathlib.Combinatorics.SimpleGraph.Acyclic
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Finite
import Mathlib.Data.Fintype.Card
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace E593Profile

/-- Actual bipartite incidence graph. Same formula as the accepted project's
SimpleGraph.bipartiteIncidenceGraph; no projected overlap graph is used. -/
def incidenceGraph {k t : ℕ} (R : Fin k → Fin t → Prop) :
    SimpleGraph (Fin k ⊕ Fin t) :=
  SimpleGraph.fromRel fun x y =>
    match x, y with
    | .inl a, .inr p => R a p
    | _, _ => False

/-- Exact forest, component count, attachment-capacity bound and profile. -/
def Realizes {k t : ℕ} (c : ℕ) (weights : Fin t → ℕ)
    (R : Fin k → Fin t → Prop) : Prop :=
  (incidenceGraph R).IsAcyclic ∧
  Nat.card (incidenceGraph R).ConnectedComponent = c ∧
  (∀ a : Fin k, Nat.card {p : Fin t // R a p} ≤ 2) ∧
  (∀ p : Fin t, Nat.card {a : Fin k // R a p} = weights p + 1)

/-- Proposition for statement elaboration only; this definition proves nothing. -/
def RequestedTheorem : Prop :=
  ∀ (k c t : ℕ) (weights : Fin t → ℕ),
    1 ≤ c → c ≤ k → (∀ p, 0 < weights p) →
    (∑ p, weights p) = k - c →
    ∃ R : Fin k → Fin t → Prop, Realizes c weights R

section ParentForest

variable {V : Type*}

/-- A set closed under adjacency is closed under reachability. -/
lemma mem_of_reachable_of_closed {G : SimpleGraph V} {S : Set V}
    (hS : ∀ a b, G.Adj a b → a ∈ S → b ∈ S) {u v : V} (hr : G.Reachable u v) (hu : u ∈ S) :
    v ∈ S := by
  obtain ⟨p⟩ := hr
  induction p with
  | nil => exact hu
  | cons hadj _ ih => exact ih (hS _ _ hadj hu)

lemma height_le_of_reflTransGen {par : V → Option V} {h : V → ℕ}
    (hh : ∀ x y, par x = some y → h y < h x) {x y : V}
    (hd : Relation.ReflTransGen (fun a b => par a = some b) x y) : h y ≤ h x := by
  induction hd with
  | refl => exact le_rfl
  | tail _ hst ih => have := hh _ _ hst; omega

/-- A graph whose edges are exactly the parent links of a height-decreasing parent
function is acyclic. -/
theorem isAcyclic_of_parent {G : SimpleGraph V} (par : V → Option V) (h : V → ℕ)
    (hadj : ∀ x y, G.Adj x y ↔ par x = some y ∨ par y = some x)
    (hh : ∀ x y, par x = some y → h y < h x) : G.IsAcyclic := by
  rw [SimpleGraph.isAcyclic_iff_forall_adj_isBridge]
  have key : ∀ v w, par v = some w → G.IsBridge s(v, w) := by
    intro v w hvw
    rw [SimpleGraph.isBridge_iff]
    intro hr
    let S : Set V := {y | Relation.ReflTransGen (fun a b => par a = some b) y v}
    have hS : ∀ a b, (G.deleteEdges {s(v, w)}).Adj a b → a ∈ S → b ∈ S := by
      intro a b hab ha
      rw [SimpleGraph.deleteEdges_adj] at hab
      obtain ⟨hab, hne⟩ := hab
      rcases (hadj a b).1 hab with hp | hp
      · rcases Relation.ReflTransGen.cases_head ha with rfl | ⟨c, hc, hcv⟩
        · rw [hvw] at hp
          cases hp
          exact absurd rfl hne
        · rw [hc] at hp
          cases hp
          exact hcv
      · exact Relation.ReflTransGen.head hp ha
    have hw : w ∈ S := mem_of_reachable_of_closed hS hr Relation.ReflTransGen.refl
    have h1 := height_le_of_reflTransGen hh hw
    have h2 := hh _ _ hvw
    omega
  intro v w hvw
  rcases (hadj v w).1 hvw with hp | hp
  · exact key v w hp
  · rw [Sym2.eq_swap]; exact key w v hp

/-- In such a parent forest, connected components correspond to roots. -/
theorem card_connectedComponent_of_parent {G : SimpleGraph V} (par : V → Option V) (h : V → ℕ)
    (hadj : ∀ x y, G.Adj x y ↔ par x = some y ∨ par y = some x)
    (hh : ∀ x y, par x = some y → h y < h x) :
    Nat.card G.ConnectedComponent = Nat.card {v : V // par v = none} := by
  symm
  apply Nat.card_eq_of_bijective (fun r => G.connectedComponentMk r.1)
  constructor
  · rintro ⟨r1, hr1⟩ ⟨r2, hr2⟩ heq
    simp only [SimpleGraph.ConnectedComponent.eq] at heq
    let S : Set V := {y | Relation.ReflTransGen (fun a b => par a = some b) y r1}
    have hS : ∀ a b, G.Adj a b → a ∈ S → b ∈ S := by
      intro a b hab ha
      rcases (hadj a b).1 hab with hp | hp
      · rcases Relation.ReflTransGen.cases_head ha with rfl | ⟨c, hc, hcv⟩
        · rw [hr1] at hp; cases hp
        · rw [hc] at hp
          cases hp
          exact hcv
      · exact Relation.ReflTransGen.head hp ha
    have h2 : r2 ∈ S := mem_of_reachable_of_closed hS heq Relation.ReflTransGen.refl
    rcases Relation.ReflTransGen.cases_head h2 with h3 | ⟨c, hc, _⟩
    · exact Subtype.ext h3.symm
    · rw [hr2] at hc; cases hc
  · intro C
    induction C using SimpleGraph.ConnectedComponent.ind with
    | h v =>
    induction hn : h v using Nat.strong_induction_on generalizing v with
    | _ n ih =>
    cases hv : par v with
    | none => exact ⟨⟨v, hv⟩, rfl⟩
    | some u =>
      obtain ⟨r, hr⟩ := ih (h u) (hn ▸ hh v u hv) u rfl
      refine ⟨r, ?_⟩
      rw [hr, SimpleGraph.ConnectedComponent.eq]
      exact ((hadj v u).2 (Or.inl hv)).reachable.symm

end ParentForest

section Construction

variable {t : ℕ} (weights : Fin t → ℕ) (c : ℕ)

/-- Child left vertices, as a sigma type. -/
def childEquivSigma : {x : Fin t × ℕ // x.2 < weights x.1} ≃ Σ p, Fin (weights p) where
  toFun x := ⟨x.1.1, ⟨x.1.2, x.2⟩⟩
  invFun s := ⟨(s.1, s.2.val), s.2.isLt⟩
  left_inv _ := rfl
  right_inv _ := rfl

instance : Fintype {x : Fin t × ℕ // x.2 < weights x.1} :=
  Fintype.ofEquiv _ (childEquivSigma weights).symm

/-- Left carrier: the children of the right vertices plus `c` extra left vertices. -/
abbrev LeftCarrier := {x : Fin t × ℕ // x.2 < weights x.1} ⊕ Fin c

lemma card_leftCarrier : Fintype.card (LeftCarrier weights c) = (∑ p, weights p) + c := by
  rw [Fintype.card_sum, Fintype.card_congr (childEquivSigma weights), Fintype.card_sigma]
  simp

/-- Parent (a right vertex) of a left vertex. -/
def leftPar : LeftCarrier weights c → Option (Fin t)
  | .inl x => some x.1.1
  | .inr i => if h : i.val = 0 ∧ 0 < t then some ⟨0, h.2⟩ else none

/-- Parent (a left vertex) of a right vertex. -/
def rightPar (hpositive : ∀ p, 0 < weights p) (q : Fin t) : Option (LeftCarrier weights c) :=
  if hq : q.val = 0 then none else some (.inl ⟨(⟨q.val - 1, by omega⟩, 0), hpositive _⟩)

/-- Incidence relation on the left carrier. -/
def relL (hpositive : ∀ p, 0 < weights p) (l : LeftCarrier weights c) (q : Fin t) : Prop :=
  leftPar weights c l = some q ∨ rightPar weights c hpositive q = some l

end Construction

section Construction2

variable {t : ℕ} (weights : Fin t → ℕ) (c : ℕ) (hpositive : ∀ p, 0 < weights p)

/-- The base index of a left vertex: its attachment right vertex. -/
def leftBase : LeftCarrier weights c → ℕ
  | .inl x => x.1.1.val
  | .inr _ => 0

lemma relL_val {l : LeftCarrier weights c} {q : Fin t} (hl : relL weights c hpositive l q) :
    q.val = leftBase weights c l ∨ q.val = leftBase weights c l + 1 := by
  rcases l with x | i <;> simp only [relL, leftPar, rightPar, leftBase] at hl ⊢
  · rcases hl with hl | hl
    · left
      rw [Option.some.injEq] at hl
      rw [hl]
    · split_ifs at hl with hq
      rw [Option.some.injEq, Sum.inl.injEq] at hl
      right
      rw [← hl]
      dsimp only
      omega
  · rcases hl with hl | hl
    · split_ifs at hl with h
      rw [Option.some.injEq] at hl
      left
      rw [← hl]
    · split_ifs at hl; simp at hl

lemma card_relL_left_le (l : LeftCarrier weights c) :
    Nat.card {q : Fin t // relL weights c hpositive l q} ≤ 2 := by
  have hinj : Function.Injective
      (fun q : {q : Fin t // relL weights c hpositive l q} =>
        decide (q.1.val ≤ leftBase weights c l)) := by
    rintro ⟨q1, h1⟩ ⟨q2, h2⟩ heq
    dsimp only at heq
    have v1 := relL_val weights c hpositive h1
    have v2 := relL_val weights c hpositive h2
    simp only [decide_eq_decide] at heq
    apply Subtype.ext
    apply Fin.ext
    dsimp only
    omega
  have := Nat.card_le_card_of_injective _ hinj
  simpa using this

lemma card_relL_right (hc : 0 < c) (q : Fin t) :
    Nat.card {l : LeftCarrier weights c // relL weights c hpositive l q} = weights q + 1 := by
  let f : Option (Fin (weights q)) → {l : LeftCarrier weights c // relL weights c hpositive l q} :=
    fun o => match o with
    | some j => ⟨.inl ⟨(q, j.val), j.isLt⟩, Or.inl rfl⟩
    | none =>
      if hq : q.val = 0 then
        ⟨.inr ⟨0, hc⟩, Or.inl (by simp [leftPar, q.pos, Fin.ext_iff, hq])⟩
      else
        ⟨.inl ⟨(⟨q.val - 1, by omega⟩, 0), hpositive _⟩, Or.inr (by simp [rightPar, hq])⟩
  have hf : Function.Bijective f := by
    constructor
    · intro o1 o2 h
      rcases o1 with _ | j1 <;> rcases o2 with _ | j2 <;> simp only [f] at h ⊢ <;>
        (try split_ifs at h) <;> simp_all [Fin.ext_iff] <;> omega
    · rintro ⟨l, hl⟩
      rcases l with ⟨⟨p, j⟩, hj⟩ | i
      · simp only [relL, leftPar, rightPar] at hl
        rcases hl with hl | hl
        · rw [Option.some.injEq] at hl
          subst hl
          exact ⟨some ⟨j, hj⟩, rfl⟩
        · split_ifs at hl with hq
          simp only [Option.some.injEq, Sum.inl.injEq, Subtype.mk.injEq, Prod.mk.injEq] at hl
          obtain ⟨rfl, rfl⟩ := hl
          refine ⟨none, ?_⟩
          simp [f, hq]
      · simp only [relL, leftPar, rightPar] at hl
        rcases hl with hl | hl
        · split_ifs at hl with hi
          rw [Option.some.injEq] at hl
          have hq : q.val = 0 := by rw [← hl]
          refine ⟨none, ?_⟩
          simp [f, hq, Fin.ext_iff, hi.1]
        · split_ifs at hl
          simp at hl
  rw [← Nat.card_eq_of_bijective f hf]
  simp

end Construction2

section Transport

variable {k t : ℕ} (weights : Fin t → ℕ) (c : ℕ) (hpositive : ∀ p, 0 < weights p)
  (e : Fin k ≃ LeftCarrier weights c)

/-- Parent function on the actual vertex type `Fin k ⊕ Fin t`. -/
def parK : Fin k ⊕ Fin t → Option (Fin k ⊕ Fin t)
  | .inl a => (leftPar weights c (e a)).map Sum.inr
  | .inr q => (rightPar weights c hpositive q).map (Sum.inl ∘ e.symm)

/-- Height function on the actual vertex type. -/
def heightK : Fin k ⊕ Fin t → ℕ
  | .inl a => match e a with
    | .inl x => 2 * x.1.1.val + 1
    | .inr _ => 1
  | .inr q => 2 * q.val

lemma incidenceGraph_adj_iff_parK (x y : Fin k ⊕ Fin t) :
    (incidenceGraph (fun a q => relL weights c hpositive (e a) q)).Adj x y ↔
      parK weights c hpositive e x = some y ∨ parK weights c hpositive e y = some x := by
  rcases x with a | q <;> rcases y with b | r <;>
    simp [incidenceGraph, parK, relL, Equiv.symm_apply_eq]
  exact or_comm

lemma heightK_lt (x y : Fin k ⊕ Fin t) (h : parK weights c hpositive e x = some y) :
    heightK weights c e y < heightK weights c e x := by
  rcases x with a | q
  · simp only [parK] at h
    cases hea : e a with
    | inl x' =>
      rw [hea] at h
      simp only [leftPar, Option.map_some, Option.some.injEq] at h
      subst h
      simp [heightK, hea]
    | inr i =>
      rw [hea] at h
      simp only [leftPar] at h
      split_ifs at h
      · simp only [Option.map_some, Option.some.injEq] at h
        subst h
        simp [heightK, hea]
      · simp at h
  · simp only [parK, rightPar] at h
    split_ifs at h with hq
    · simp at h
    · simp only [Option.map_some, Option.some.injEq] at h
      subst h
      simp [heightK]
      omega

lemma card_roots (hc : 0 < c) :
    Nat.card {v : Fin k ⊕ Fin t // parK weights c hpositive e v = none} = c := by
  let g : Fin c → {v : Fin k ⊕ Fin t // parK weights c hpositive e v = none} := fun i =>
    if h : i.val = 0 ∧ 0 < t then ⟨.inr ⟨0, h.2⟩, by simp [parK, rightPar]⟩
    else ⟨.inl (e.symm (.inr i)), by simp [parK, leftPar, h]⟩
  have hg : Function.Bijective g := by
    constructor
    · intro i j hij
      by_cases hi : i.val = 0 ∧ 0 < t <;> by_cases hj : j.val = 0 ∧ 0 < t
      · exact Fin.ext (by omega)
      · simp only [g, dif_pos hi, dif_neg hj] at hij
        simp at hij
      · simp only [g, dif_neg hi, dif_pos hj] at hij
        simp at hij
      · simp only [g, dif_neg hi, dif_neg hj] at hij
        simpa using hij
    · rintro ⟨v, hv⟩
      rcases v with a | q
      · cases hea : e a with
        | inl x => simp [parK, hea, leftPar] at hv
        | inr i =>
          have hi : ¬(i.val = 0 ∧ 0 < t) := by
            intro h
            simp [parK, hea, leftPar, h] at hv
          refine ⟨i, ?_⟩
          simp [g, hi, ← hea]
      · have hq : q.val = 0 := by
          by_contra hq
          simp [parK, rightPar, hq] at hv
        refine ⟨⟨0, hc⟩, ?_⟩
        simp [g, q.pos, Fin.ext_iff, hq]
  rw [← Nat.card_eq_of_bijective g hg]
  simp

end Transport

theorem exists_incidence_forest
    (k c t : ℕ) (weights : Fin t → ℕ)
    (hc : 1 ≤ c) (hck : c ≤ k)
    (hpositive : ∀ p, 0 < weights p)
    (hsum : (∑ p, weights p) = k - c) :
    ∃ R : Fin k → Fin t → Prop, Realizes c weights R := by
  have hcard : Fintype.card (Fin k) = Fintype.card (LeftCarrier weights c) := by
    rw [Fintype.card_fin, card_leftCarrier, hsum]
    omega
  let e : Fin k ≃ LeftCarrier weights c := Fintype.equivOfCardEq hcard
  have hadj := incidenceGraph_adj_iff_parK weights c hpositive e
  have hh := heightK_lt weights c hpositive e
  refine ⟨fun a q => relL weights c hpositive (e a) q, ?_, ?_, ?_, ?_⟩
  · exact isAcyclic_of_parent _ _ hadj hh
  · rw [card_connectedComponent_of_parent _ _ hadj hh]
    exact card_roots weights c hpositive e hc
  · intro a
    exact card_relL_left_le weights c hpositive (e a)
  · intro p
    rw [← card_relL_right weights c hpositive hc p]
    exact Nat.card_congr (e.subtypeEquiv fun _ => Iff.rfl)

end E593Profile
