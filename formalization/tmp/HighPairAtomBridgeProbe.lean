import Erdos593.TripleSystem.HighPairObligatory
import Mathlib.Combinatorics.SimpleGraph.Copy

namespace Erdos593

universe u v

namespace TripleSystem

open _root_.SimpleGraph

/-- Scratch probe: a graph copy yields the concrete two-sided high-pair grid
needed by the matrix construction. -/
theorem highPairGrid_of_copy_probe
    {W : Type u} {D : Type v} {H : TripleSystem W D} {n t : Nat}
    (f : Copy (completeBipartiteNN.{u} n) (highPairGraph H t)) :
    ∃ left right : Fin n ↪ W,
      (∀ i j, left i ≠ right j) ∧
      ∀ i j, HighPair H t (left i) (right j) := by
  let left : Fin n ↪ W :=
    { toFun := fun i => f (Sum.inl (ULift.up i))
      inj' := by
        intro i j hij
        have h := f.injective hij
        simpa using h }
  let right : Fin n ↪ W :=
    { toFun := fun j => f (Sum.inr (ULift.up j))
      inj' := by
        intro i j hij
        have h := f.injective hij
        simpa using h }
  refine ⟨left, right, ?_, ?_⟩
  · intro i j h
    have hsrc : (completeBipartiteNN.{u} n).Adj
        (Sum.inl (ULift.up i)) (Sum.inr (ULift.up j)) := by
      simp [completeBipartiteNN]
    have htgt : (highPairGraph H t).Adj (left i) (right j) := by
      simpa [left, right] using f.toHom.map_adj hsrc
    exact (highPairGraph_adj H t (left i) (right j)).mp htgt |>.1 h
  · intro i j
    have hsrc : (completeBipartiteNN.{u} n).Adj
        (Sum.inl (ULift.up i)) (Sum.inr (ULift.up j)) := by
      simp [completeBipartiteNN]
    have htgt : (highPairGraph H t).Adj (left i) (right j) := by
      simpa [left, right] using f.toHom.map_adj hsrc
    exact (highPairGraph_adj H t (left i) (right j)).mp htgt

/-- Scratch probe of the missing finite bridge: a single quadratic high-pair
grid already has a rainbow private-vertex-expansion embedding of the same
size.  This retains the global injectivity that the current public matrix
API deliberately forgets. -/
theorem nonempty_expansionEmbedding_of_quadratic_highPair_probe
    {W : Type u} {D : Type v} [DecidableEq W]
    {H : TripleSystem W D} {n : Nat}
    (left right : Fin n ↪ W)
    (hhigh : ∀ i j,
      HighPair H (2 * n + n * n) (left i) (right j)) :
    Nonempty ((privateVertexExpansion (completeBipartiteNN.{u} n)).Embedding H) := by
  classical
  let completion : ∀ ij : Fin n × Fin n,
      PairCodegreeWitness H (left ij.1) (right ij.2) (2 * n + n * n) :=
    fun ij => (hhigh ij.1 ij.2).2.some
  let core : Finset W := Finset.univ.map left ∪ Finset.univ.map right
  have hcore : core.card ≤ 2 * n := by
    calc
      core.card ≤ (Finset.univ.map left).card + (Finset.univ.map right).card :=
        Finset.card_union_le _ _
      _ = 2 * n := by simp [two_mul]
  have hcap : core.card + Fintype.card (Fin n × Fin n) ≤ 2 * n + n * n := by
    simpa using Nat.add_le_add_right hcore (n * n)
  obtain ⟨choose, hchoose_inj, hchoose_avoid⟩ :=
    exists_injective_choice_of_fintype_card_add_le core
      (fun ij => (completion ij).third) hcap
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
  have hleft_core : ∀ i, left i ∈ core := by
    intro i
    exact Finset.mem_union_left _ (Finset.mem_map.mpr ⟨i, Finset.mem_univ _, rfl⟩)
  have hright_core : ∀ j, right j ∈ core := by
    intro j
    exact Finset.mem_union_right _ (Finset.mem_map.mpr ⟨j, Finset.mem_univ _, rfl⟩)
  let M : WitnessedBipartiteMatrix H n 2 :=
    { left := left
      right := right
      apex := apex
      edge := fun i j => (completion (i, j)).edge (choose (i, j))
      core_disjoint := fun i j => (hhigh i j).1
      apex_ne_left := fun i j k h => hapex_avoid i j (h.symm ▸ hleft_core k)
      apex_ne_right := fun i j k h => hapex_avoid i j (h.symm ▸ hright_core k)
      edgeSet_eq := fun i j => by
        simpa [apex] using (completion (i, j)).edgeSet_eq (choose (i, j))
      locallyBounded := locallyBounded_two_of_injective apex hapex_inj }
  let row : Fin n ↪ Fin n := Function.Embedding.refl _
  let column : Fin n ↪ Fin n := Function.Embedding.refl _
  have hrainbow : RainbowBipartite.IsRainbow M.apex row column := by
    intro ij kl h
    apply hapex_inj
    simpa [M, row, column] using h
  exact ⟨M.rainbowEmbedding row column hrainbow⟩

theorem isEmpty_copy_highPairGraph_of_isEmpty_atom_probe
    {W : Type u} {D : Type v} [DecidableEq W]
    {H : TripleSystem W D} {n : Nat}
    (hatom : IsEmpty
      ((completeBipartiteExpansionAtom.{u} n).Embedding H)) :
    IsEmpty (Copy (completeBipartiteNN.{u} n)
      (highPairGraph H (2 * n + n * n))) := by
  refine ⟨?_⟩
  intro f
  obtain ⟨left, right, -, hhigh⟩ := highPairGrid_of_copy_probe f
  exact hatom.false
    (nonempty_expansionEmbedding_of_quadratic_highPair_probe left right hhigh).some

end TripleSystem

end Erdos593
