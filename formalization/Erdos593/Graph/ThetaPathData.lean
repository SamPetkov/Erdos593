import Erdos593.Graph.SaturatedPathSeparation

/-! # Literal path data, independent of the rank-two project library. -/

namespace E593Theta

open SimpleGraph

universe u

variable {V : Type u} [Fintype V] [DecidableEq V]
variable {G : SimpleGraph V} [DecidableRel G.Adj]

/-- A literal three-path presentation of the original graph. All paths live
in G, and the last field states equality with its actual adjacency relation. -/
structure ThreePaths (G : SimpleGraph V) (a b : V) where
  ends_ne : a ≠ b
  path : Fin 3 → G.Walk a b
  simple : ∀ i, (path i).IsPath
  first_injective : Function.Injective (fun i => (path i).snd)
  disjoint : ∀ i j, i ≠ j → Disjoint (interior (path i)) (interior (path j))
  covers_vertices : ∀ x : V, ∃ i, x ∈ (path i).support
  covers_adjacency : ∀ x y : V, G.Adj x y ↔ ∃ i, (path i).toSubgraph.Adj x y

namespace ThreePaths

variable {a b : V} (P : ThreePaths G a b)

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- Every branch has positive edge length, since its endpoints are distinct. -/
theorem length_pos (i : Fin 3) : 0 < (P.path i).length :=
  Walk.not_nil_iff_lt_length.mp (Walk.not_nil_of_ne P.ends_ne)

omit [Fintype V] [DecidableEq V] [DecidableRel G.Adj] in
/-- Two length-one branches would repeat the same edge in a simple graph. -/
theorem at_most_one_direct (i j : Fin 3)
    (hi : (P.path i).length = 1) (hj : (P.path j).length = 1) : i = j := by
  apply P.first_injective
  have hsi : (P.path i).snd = b := by
    change (P.path i).getVert 1 = b
    rw [← hi]
    simp
  have hsj : (P.path j).snd = b := by
    change (P.path j).getVert 1 = b
    rw [← hj]
    simp
  exact hsi.trans hsj.symm

end ThreePaths
end E593Theta
