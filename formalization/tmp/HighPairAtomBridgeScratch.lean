import Erdos593.TripleSystem.HighPairMatrix
import Erdos593.TripleSystem.ObligatoryAtoms

/-!
# Scratch: a single quadratic high-pair grid already embeds its expansion

This deliberately duplicates the Hall selection used by `HighPairMatrix` so
that the resulting global injectivity of the chosen third vertices remains
available for the final direct rainbow embedding.
-/

namespace Erdos593

universe u

namespace TripleSystem

theorem completeBipartiteExpansionAtom_appears_of_one_quadratic_highPairGrid_scratch
    {W D : Type u} [DecidableEq W]
    {H : TripleSystem W D} {n : Nat}
    (left right : Fin n ↪ W)
    (hhigh : ∀ i j,
      HighPair H (2 * n + n * n) (left i) (right j)) :
    (completeBipartiteExpansionAtom.{u} n).Appears H := by
  classical
  let core : Finset W := Finset.univ.map left ∪ Finset.univ.map right
  let completion : ∀ ij : Fin n × Fin n,
      PairCodegreeWitness H (left ij.1) (right ij.2) (2 * n + n * n) :=
    fun ij => Classical.choice (hhigh ij.1 ij.2).2
  have hcap : core.card + Fintype.card (Fin n × Fin n) ≤ 2 * n + n * n := by
    have hcore : core.card ≤ 2 * n := by
      dsimp only [core]
      calc
        (Finset.univ.map left ∪ Finset.univ.map right).card ≤
            (Finset.univ.map left).card + (Finset.univ.map right).card :=
          Finset.card_union_le _ _
        _ = 2 * n := by simp [two_mul]
    simpa using Nat.add_le_add_right hcore (n * n)
  obtain ⟨choose, hchoose_inj, hchoose_avoid⟩ :=
    exists_injective_choice_of_fintype_card_add_le
      (ι := Fin n × Fin n) core (fun ij => (completion ij).third) hcap
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
  have hleft : ∀ i, left i ∈ core := by
    intro i
    exact Finset.mem_union_left _ (Finset.mem_map.mpr ⟨i, Finset.mem_univ _, rfl⟩)
  have hright : ∀ j, right j ∈ core := by
    intro j
    exact Finset.mem_union_right _ (Finset.mem_map.mpr ⟨j, Finset.mem_univ _, rfl⟩)
  let M : WitnessedBipartiteMatrix H n 2 := {
    left := left
    right := right
    apex := apex
    edge := fun i j => (completion (i, j)).edge (choose (i, j))
    core_disjoint := fun i j => (hhigh i j).1
    apex_ne_left := fun i j k h => hapex_avoid i j (h.symm ▸ hleft k)
    apex_ne_right := fun i j k h => hapex_avoid i j (h.symm ▸ hright k)
    edgeSet_eq := fun i j => by
      simpa [apex] using (completion (i, j)).edgeSet_eq (choose (i, j))
    locallyBounded := locallyBounded_two_of_injective apex hapex_inj
  }
  let ident : Fin n ↪ Fin n := Function.Embedding.refl _
  have hrainbow : RainbowBipartite.IsRainbow M.apex ident ident := by
    intro ij kl h
    apply hapex_inj
    simpa [M, ident] using h
  change Nonempty ((privateVertexExpansion (completeBipartiteNN.{u} n)).Embedding H)
  exact ⟨M.rainbowEmbedding ident ident hrainbow⟩

end TripleSystem
end Erdos593
