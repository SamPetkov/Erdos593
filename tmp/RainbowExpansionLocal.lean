import Erdos593.TripleSystem.ObligatoryBipartiteReduction
import Erdos593.Graph.RainbowBipartite
import Mathlib.Combinatorics.SimpleGraph.Bipartite

namespace Erdos593

open scoped Cardinal

universe u v

namespace TripleSystem

structure WitnessedBipartiteMatrix {W : Type u} {D : Type v}
    (H : TripleSystem W D) (q t : Nat) where
  left : Fin q ↪ W
  right : Fin q ↪ W
  apex : Fin q → Fin q → W
  edge : Fin q → Fin q → D
  core_disjoint : ∀ i j, left i ≠ right j
  apex_ne_left : ∀ i j k, apex i j ≠ left k
  apex_ne_right : ∀ i j k, apex i j ≠ right k
  edgeSet_eq : ∀ i j,
    H.edgeSet (edge i j) = {left i, right j, apex i j}
  locallyBounded : RainbowBipartite.LocallyBounded t apex

namespace CompleteBipartiteEdges

abbrev Part (n : Nat) := FiniteBipartitePart.{u} n
abbrev Graph (n : Nat) := completeBipartiteNN.{u} n

def edge (n : Nat) (a b : Part n) : (Graph n).edgeSet :=
  ⟨s(Sum.inl a, Sum.inr b), by simp [Graph, completeBipartiteNN]⟩

noncomputable def coords (n : Nat) (e : (Graph n).edgeSet) : Part n × Part n := by
  classical
  let eVal : Sym2 (Part n ⊕ Part n) := e.1
  have he : eVal ∈ (_root_.completeBipartiteGraph (Part n) (Part n)).edgeSet := by
    exact e.2
  rw [SimpleGraph.edgeSet_completeBipartiteGraph] at he
  exact Classical.choose he

theorem coords_spec (n : Nat) (e : (Graph n).edgeSet) :
    s(Sum.inl (coords n e).1, Sum.inr (coords n e).2) = e.1 := by
  classical
  let eVal : Sym2 (Part n ⊕ Part n) := e.1
  have he : eVal ∈ Set.range
    (fun x : Part n × Part n => s(Sum.inl x.1, Sum.inr x.2)) := by
      have he' : eVal ∈ (_root_.completeBipartiteGraph (Part n) (Part n)).edgeSet := by
        exact e.2
      rw [SimpleGraph.edgeSet_completeBipartiteGraph] at he'
      exact he'
  change s(Sum.inl (coords n e).1, Sum.inr (coords n e).2) = eVal
  unfold coords
  exact Classical.choose_spec he

theorem edge_coords (n : Nat) (e : (Graph n).edgeSet) :
    edge n (coords n e).1 (coords n e).2 = e := by
  apply Subtype.ext
  exact coords_spec n e

theorem coords_injective (n : Nat) : Function.Injective (coords n) := by
  intro e f hef
  apply Subtype.ext
  calc
    e.1 = s(Sum.inl (coords n e).1, Sum.inr (coords n e).2) :=
      (coords_spec n e).symm
    _ = s(Sum.inl (coords n f).1, Sum.inr (coords n f).2) := by rw [hef]
    _ = f.1 := coords_spec n f

theorem edge_injective (n : Nat) :
    Function.Injective (fun ab : Part n × Part n => edge n ab.1 ab.2) := by
  rintro ⟨a, b⟩ ⟨c, d⟩ h
  have h' := congrArg Subtype.val h
  rcases Sym2.eq_iff.mp h' with h' | h'
  · exact Prod.ext (Sum.inl.inj h'.1) (Sum.inr.inj h'.2)
  · simp at h'

theorem coords_edge (n : Nat) (a b : Part n) :
    coords n (edge n a b) = (a, b) := by
  apply edge_injective n
  change edge n (coords n (edge n a b)).1 (coords n (edge n a b)).2 =
    edge n a b
  exact edge_coords n (edge n a b)

end CompleteBipartiteEdges

/-- Universe-generic finite bridge: witness matrices of every finite size
produce a non-induced copy of the complete-bipartite private expansion. -/
theorem local_appears_completeBipartiteExpansion_of_witnessedMatrices
    {W : Type u} {D : Type u} (H : TripleSystem W D)
    (n t : Nat) (hn : 0 < n) (ht : 0 < t)
    (hmat : ∀ q : Nat, Nonempty (WitnessedBipartiteMatrix H q t)) :
    (privateVertexExpansion (completeBipartiteNN.{u} n)).Appears H := by
  sorry

/-- Universe-correct contradiction wrapper.  The edge universe of a host in
`IsObligatory` must equal the edge universe of the source atom, which here is
`u`.  The atom-free premise matches the minimal-counterexample route in the
manuscript: only an atom-free host is required to yield the witness matrices. -/
theorem local_isObligatory_completeBipartiteExpansion_of_witnessedMatrices
    (n t : Nat) (hn : 0 < n) (ht : 0 < t)
    (hmat : ∀ (W : Type u) (D : Type u) [DecidableEq W]
      (H : TripleSystem W D),
      ℵ₀ < H.chromaticCardinal →
      ¬(privateVertexExpansion (completeBipartiteNN.{u} n)).Appears H →
        ∀ q : Nat, Nonempty (WitnessedBipartiteMatrix H q t)) :
    (privateVertexExpansion (completeBipartiteNN.{u} n)).IsObligatory := by
  classical
  intro W D _ H hH
  by_contra hfree
  exact hfree
    (local_appears_completeBipartiteExpansion_of_witnessedMatrices
      (H := H) n t hn ht (hmat W D H hH hfree))

end TripleSystem
end Erdos593
