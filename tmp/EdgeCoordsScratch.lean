import Erdos593.Graph.CompleteBipartite
import Mathlib.Combinatorics.SimpleGraph.Bipartite

namespace Erdos593

universe u

namespace Scratch

abbrev P (n : Nat) := FiniteBipartitePart.{u} n
abbrev K (n : Nat) := completeBipartiteNN.{u} n

#check SimpleGraph.edgeSet_completeBipartiteGraph
#check Sym2.inductionOn
#check Sym2.ind

def edge (n : Nat) (a b : P n) : (K n).edgeSet :=
  ⟨s(Sum.inl a, Sum.inr b), by simp [K, completeBipartiteNN]⟩

noncomputable def coords (n : Nat) (e : (K n).edgeSet) : P n × P n := by
  classical
  let eVal : Sym2 (P n ⊕ P n) := e.1
  have he : eVal ∈ (_root_.completeBipartiteGraph (P n) (P n)).edgeSet := by
    exact e.2
  rw [SimpleGraph.edgeSet_completeBipartiteGraph] at he
  exact Classical.choose he

theorem coords_spec (n : Nat) (e : (K n).edgeSet) :
    s(Sum.inl (coords n e).1, Sum.inr (coords n e).2) = e.1 := by
  classical
  let eVal : Sym2 (P n ⊕ P n) := e.1
  have he : eVal ∈ Set.range
    (fun x : P n × P n => s(Sum.inl x.1, Sum.inr x.2)) := by
      have he' : eVal ∈ (_root_.completeBipartiteGraph (P n) (P n)).edgeSet := by
        exact e.2
      rw [SimpleGraph.edgeSet_completeBipartiteGraph] at he'
      exact he'
  change s(Sum.inl (coords n e).1, Sum.inr (coords n e).2) = eVal
  unfold coords
  exact Classical.choose_spec he

theorem edge_coords (n : Nat) (e : (K n).edgeSet) :
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
    Function.Injective (fun ab : P n × P n => edge n ab.1 ab.2) := by
  rintro ⟨a, b⟩ ⟨c, d⟩ h
  have h' := congrArg Subtype.val h
  rcases Sym2.eq_iff.mp h' with h' | h'
  · exact Prod.ext (Sum.inl.inj h'.1) (Sum.inr.inj h'.2)
  · simp at h'

theorem coords_edge (n : Nat) (a b : P n) :
    coords n (edge n a b) = (a, b) := by
  apply edge_injective n
  change edge n (coords n (edge n a b)).1 (coords n (edge n a b)).2 =
    edge n a b
  exact edge_coords n (edge n a b)

end Scratch
end Erdos593
