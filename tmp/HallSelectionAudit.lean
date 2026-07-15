import Mathlib.Combinatorics.Hall.Basic
import Mathlib.Data.Fin.Tuple.Embedding
import Erdos593.TripleSystem.PairCodegree
import Erdos593.TripleSystem.RainbowExpansionEmbedding

namespace HallSelectionAudit

theorem exists_injective_choice_of_card_add_le
    {ι W : Type*} [Fintype ι] [DecidableEq W] {T : Nat}
    (C : Finset W) (reservoir : ι → Fin T ↪ W)
    (hcap : C.card + Fintype.card ι ≤ T) :
    ∃ choose : ι → Fin T,
      Function.Injective (fun i => reservoir i (choose i)) ∧
      ∀ i, reservoir i (choose i) ∉ C := by
  classical
  let A : ι → Finset W := fun i => Finset.univ.map (reservoir i) \ C
  have hlarge : ∀ i : ι, Fintype.card ι ≤ (A i).card := by
    intro i
    have hsub : T - C.card ≤ (A i).card := by
      simpa [A, Finset.card_map] using
        (Finset.le_card_sdiff C (Finset.univ.map (reservoir i)))
    exact (Nat.le_sub_of_add_le' hcap).trans hsub
  have hhall : ∀ s : Finset ι, s.card ≤ (s.biUnion A).card := by
    intro s
    rcases s.eq_empty_or_nonempty with rfl | hs
    · simp
    · obtain ⟨i, hi⟩ := hs
      calc
        s.card ≤ Fintype.card ι := Finset.card_le_univ s
        _ ≤ (A i).card := hlarge i
        _ ≤ (s.biUnion A).card := Finset.card_le_card (by
          intro x hx
          exact Finset.mem_biUnion.mpr ⟨i, hi, hx⟩)
  obtain ⟨f, hf_inj, hf_mem⟩ :=
    (Finset.all_card_le_biUnion_card_iff_exists_injective A).mp hhall
  choose choose hchoose using fun i => (Finset.mem_map.mp (Finset.mem_sdiff.mp (hf_mem i)).1)
  refine ⟨choose, ?_, ?_⟩
  · intro i j hij
    apply hf_inj
    calc
      f i = reservoir i (choose i) := (hchoose i).2.symm
      _ = reservoir j (choose j) := hij
      _ = f j := (hchoose j).2
  · intro i
    rw [(hchoose i).2]
    exact (Finset.mem_sdiff.mp (hf_mem i)).2

theorem exists_injective_thirds_avoiding
    {W D ι : Type*} [Fintype ι] [DecidableEq W]
    {H : Erdos593.TripleSystem W D} {T : Nat}
    (x y : ι → W) (C : Finset W)
    (p : ∀ i, Erdos593.TripleSystem.PairCodegreeWitness H (x i) (y i) T)
    (hcap : C.card + Fintype.card ι ≤ T) :
    ∃ choose : ι → Fin T,
      Function.Injective (fun i => (p i).third (choose i)) ∧
      ∀ i, (p i).third (choose i) ∉ C :=
  exists_injective_choice_of_card_add_le C (fun i => (p i).third) hcap

theorem locallyBounded_two_of_injective
    {W : Type*} {q : Nat} (apex : Fin q → Fin q → W)
    (hinj : Function.Injective (fun ij : Prod (Fin q) (Fin q) => apex ij.1 ij.2)) :
    Erdos593.RainbowBipartite.LocallyBounded 2 apex := by
  constructor
  · intro x a
    apply Nat.lt_succ_iff.mpr
    apply Finite.card_le_one_iff_subsingleton.mpr
    constructor
    intro y z
    apply Subtype.ext
    have hp : (x, y.1) = (x, z.1) := hinj (by
      change apex x y.1 = apex x z.1
      exact y.2.trans z.2.symm)
    exact congrArg Prod.snd hp
  · intro y a
    apply Nat.lt_succ_iff.mpr
    apply Finite.card_le_one_iff_subsingleton.mpr
    constructor
    intro x z
    apply Subtype.ext
    have hp : (x.1, y) = (z.1, y) := hinj (by
      change apex x.1 y = apex z.1 y
      exact x.2.trans z.2.symm)
    exact congrArg Prod.fst hp

theorem exists_witnessedBipartiteMatrix_of_pairCodegree
    {W D : Type*} [DecidableEq W]
    {H : Erdos593.TripleSystem W D} {n T : Nat}
    (left right : Fin n ↪ W) (core : Finset W)
    (hleft : ∀ i, left i ∈ core)
    (hright : ∀ j, right j ∈ core)
    (hcore_disjoint : ∀ i j, left i ≠ right j)
    (p : ∀ ij : Prod (Fin n) (Fin n),
      Erdos593.TripleSystem.PairCodegreeWitness H (left ij.1) (right ij.2) T)
    (hcap : core.card + Fintype.card (Prod (Fin n) (Fin n)) ≤ T) :
    ∃ M : Erdos593.TripleSystem.WitnessedBipartiteMatrix H n 2,
      M.left = left ∧ M.right = right := by
  classical
  obtain ⟨choose, hchoose_inj, hchoose_avoid⟩ :=
    exists_injective_choice_of_card_add_le core (fun ij => (p ij).third) hcap
  let apex : Fin n → Fin n → W :=
    fun i j => (p (i, j)).third (choose (i, j))
  have hapex_inj : Function.Injective
      (fun ij : Prod (Fin n) (Fin n) => apex ij.1 ij.2) := by
    intro ij kl h
    apply hchoose_inj
    simpa [apex] using h
  have hapex_avoid : ∀ i j, apex i j ∉ core := by
    intro i j
    simpa [apex] using hchoose_avoid (i, j)
  refine ⟨{
    left := left
    right := right
    apex := apex
    edge := fun i j => (p (i, j)).edge (choose (i, j))
    core_disjoint := hcore_disjoint
    apex_ne_left := fun i j k h => hapex_avoid i j (h.symm ▸ hleft k)
    apex_ne_right := fun i j k h => hapex_avoid i j (h.symm ▸ hright k)
    edgeSet_eq := fun i j => by
      simpa [apex] using (p (i, j)).edgeSet_eq (choose (i, j))
    locallyBounded := locallyBounded_two_of_injective apex hapex_inj
  }, rfl, rfl⟩

theorem exists_witnessedBipartiteMatrix_of_pairCodegree_core_union
    {W D : Type*} [DecidableEq W]
    {H : Erdos593.TripleSystem W D} {n T : Nat}
    (left right : Fin n ↪ W)
    (hcore_disjoint : ∀ i j, left i ≠ right j)
    (p : ∀ ij : Prod (Fin n) (Fin n),
      Erdos593.TripleSystem.PairCodegreeWitness H (left ij.1) (right ij.2) T)
    (hcap : (Finset.univ.map left ∪ Finset.univ.map right).card +
        Fintype.card (Prod (Fin n) (Fin n)) ≤ T) :
    ∃ M : Erdos593.TripleSystem.WitnessedBipartiteMatrix H n 2,
      M.left = left ∧ M.right = right := by
  apply exists_witnessedBipartiteMatrix_of_pairCodegree left right
    (Finset.univ.map left ∪ Finset.univ.map right)
  · intro i
    exact Finset.mem_union_left _ (Finset.mem_map.mpr ⟨i, Finset.mem_univ _, rfl⟩)
  · intro j
    exact Finset.mem_union_right _ (Finset.mem_map.mpr ⟨j, Finset.mem_univ _, rfl⟩)
  · exact hcore_disjoint
  · exact p
  · exact hcap

theorem exists_witnessedBipartiteMatrix_of_quadratic_pairCodegree
    {W D : Type*} [DecidableEq W]
    {H : Erdos593.TripleSystem W D} {n : Nat}
    (left right : Fin n ↪ W)
    (hcore_disjoint : ∀ i j, left i ≠ right j)
    (p : ∀ ij : Prod (Fin n) (Fin n),
      Erdos593.TripleSystem.PairCodegreeWitness H (left ij.1) (right ij.2)
        (2 * n + n * n)) :
    ∃ M : Erdos593.TripleSystem.WitnessedBipartiteMatrix H n 2,
      M.left = left ∧ M.right = right := by
  apply exists_witnessedBipartiteMatrix_of_pairCodegree_core_union left right
    hcore_disjoint p
  have hcore : (Finset.univ.map left ∪ Finset.univ.map right).card ≤ 2 * n := by
    calc
      (Finset.univ.map left ∪ Finset.univ.map right).card ≤
          (Finset.univ.map left).card + (Finset.univ.map right).card :=
        Finset.card_union_le _ _
      _ = 2 * n := by simp [two_mul]
  simpa using Nat.add_le_add_right hcore (n * n)

end HallSelectionAudit
