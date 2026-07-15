import Erdos593.TripleSystem.HighPairObligatory

/-!
# Scratch: a high-pair grid forces the positive atom

This isolates the local (non-obligatory) contrapositive of the existing
quadratic high-pair extraction.  There is no separate `AtomFree` predicate in
the current API: atom-freeness for this source is expressed as
`¬ F.Appears H`.
-/

namespace Erdos593

universe u

namespace TripleSystem

/-- Arbitrarily large complete bipartite grids of quadratic high pairs force
the positive balanced complete-bipartite expansion to appear in the host. -/
theorem completeBipartiteExpansionAtom_appears_of_quadratic_highPairGrids
    {W D : Type u} [DecidableEq W]
    (H : TripleSystem W D) (n : Nat) (hn : 0 < n)
    (hgrid : ∀ q : Nat, ∃ left right : Fin q ↪ W,
      ∀ i j, HighPair H (2 * q + q * q) (left i) (right j)) :
    (completeBipartiteExpansionAtom.{u} n).Appears H := by
  refine completeBipartiteExpansionAtom_appears_of_witnessedMatrices H n 2 hn
    (by decide) ?_
  intro q
  obtain ⟨left, right, hhigh⟩ := hgrid q
  obtain ⟨M, -, -⟩ :=
    exists_witnessedBipartiteMatrix_of_quadratic_highPair left right hhigh
  exact ⟨M⟩

/-- Contrapositive form: a host avoiding the positive atom cannot contain
quadratic high-pair grids of every finite size. -/
theorem not_all_quadratic_highPairGrids_of_atomFree
    {W D : Type u} [DecidableEq W]
    (H : TripleSystem W D) (n : Nat) (hn : 0 < n)
    (hatomFree : ¬ (completeBipartiteExpansionAtom.{u} n).Appears H) :
    ¬ (∀ q : Nat, ∃ left right : Fin q ↪ W,
      ∀ i j, HighPair H (2 * q + q * q) (left i) (right j)) := by
  intro hgrid
  exact hatomFree
    (completeBipartiteExpansionAtom_appears_of_quadratic_highPairGrids H n hn hgrid)

/-- The matrix constructor in the production API deliberately keeps only the
local bound on its apex map.  The underlying Hall proof in fact gives this
stronger globally injective version. -/
theorem exists_injectiveWitnessedBipartiteMatrix_of_quadratic_highPair
    {W D : Type u} [DecidableEq W]
    {H : TripleSystem W D} {n : Nat}
    (left right : Fin n ↪ W)
    (hhigh : ∀ i j,
      HighPair H (2 * n + n * n) (left i) (right j)) :
    ∃ M : WitnessedBipartiteMatrix H n 2,
      M.left = left ∧ M.right = right ∧
        Function.Injective (fun ij : Fin n × Fin n => M.apex ij.1 ij.2) := by
  classical
  let core : Finset W := Finset.univ.map left ∪ Finset.univ.map right
  have hcap : core.card + Fintype.card (Fin n × Fin n) ≤ 2 * n + n * n := by
    have hcore : core.card ≤ 2 * n := by
      calc
        core.card ≤ (Finset.univ.map left).card + (Finset.univ.map right).card :=
          Finset.card_union_le _ _
        _ = 2 * n := by simp [two_mul]
    simpa using Nat.add_le_add_right hcore (n * n)
  let completion : ∀ ij : Fin n × Fin n,
      PairCodegreeWitness H (left ij.1) (right ij.2) (2 * n + n * n) :=
    fun ij => Classical.choice (hhigh ij.1 ij.2).2
  obtain ⟨choose, hchoose_inj, hchoose_avoid⟩ :=
    exists_injective_choice_of_fintype_card_add_le
      (C := core) (fun ij => (completion ij).third) hcap
  let apex : Fin n → Fin n → W :=
    fun i j => (completion (i, j)).third (choose (i, j))
  have hapex_inj : Function.Injective
      (fun ij : Fin n × Fin n => apex ij.1 ij.2) := by
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
    edge := fun i j => (completion (i, j)).edge (choose (i, j))
    core_disjoint := fun i j => (hhigh i j).1
    apex_ne_left := fun i j k h =>
      hapex_avoid i j (h.symm ▸ Finset.mem_union_left _
        (Finset.mem_map.mpr ⟨k, Finset.mem_univ _, rfl⟩))
    apex_ne_right := fun i j k h =>
      hapex_avoid i j (h.symm ▸ Finset.mem_union_right _
        (Finset.mem_map.mpr ⟨k, Finset.mem_univ _, rfl⟩))
    edgeSet_eq := fun i j => by
      simpa [apex] using (completion (i, j)).edgeSet_eq (choose (i, j))
    locallyBounded := locallyBounded_two_of_injective apex hapex_inj
  }, rfl, rfl, hapex_inj⟩

/-- A *single* `n × n` quadratic high-pair grid already forces the atom:
the Hall choice makes every apex globally distinct, so the identity submatrix
is rainbow.  This is sharper than the public arbitrary-size-grid interface. -/
theorem completeBipartiteExpansionAtom_appears_of_one_quadratic_highPairGrid
    {W D : Type u} [DecidableEq W]
    (H : TripleSystem W D) (n : Nat)
    (left right : Fin n ↪ W)
    (hhigh : ∀ i j,
      HighPair H (2 * n + n * n) (left i) (right j)) :
    (completeBipartiteExpansionAtom.{u} n).Appears H := by
  obtain ⟨M, -, -, hapex_inj⟩ :=
    exists_injectiveWitnessedBipartiteMatrix_of_quadratic_highPair left right hhigh
  let row : Fin n ↪ Fin n := Function.Embedding.refl _
  let column : Fin n ↪ Fin n := Function.Embedding.refl _
  have hrainbow : RainbowBipartite.IsRainbow M.apex row column := by
    intro ij kl h
    apply hapex_inj
    simpa [row, column] using h
  exact ⟨M.rainbowEmbedding row column hrainbow⟩

/-- Atom-freeness rules out even one complete `n × n` high-pair grid at the
quadratic Hall threshold. -/
theorem not_one_quadratic_highPairGrid_of_atomFree
    {W D : Type u} [DecidableEq W]
    (H : TripleSystem W D) (n : Nat)
    (hatomFree : ¬ (completeBipartiteExpansionAtom.{u} n).Appears H) :
    ¬ (∃ left right : Fin n ↪ W,
      ∀ i j, HighPair H (2 * n + n * n) (left i) (right j)) := by
  rintro ⟨left, right, hhigh⟩
  exact hatomFree
    (completeBipartiteExpansionAtom_appears_of_one_quadratic_highPairGrid
      H n left right hhigh)

end TripleSystem
end Erdos593
