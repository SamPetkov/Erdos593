import Erdos593.TripleSystem.ObligatoryBipartiteReduction
import Erdos593.Graph.RainbowBipartite

/-!
# Rainbow witness matrices for the complete-bipartite expansion atom

This isolated target formalizes the final finite bridge in Proposition 3.2.
The remaining infinitary work is exactly the production of the witness
matrices from an uncountably chromatic host; this file does not assume that
step as proved.
-/

namespace Erdos593

open scoped Cardinal

universe u v

namespace TripleSystem

/-- A complete bipartite array of host triples.  `apex i j` is the third
vertex of the host edge through `left i` and `right j`.  The global separation
conditions are the layer separation used in the manuscript: selected apices
are never core vertices. -/
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

/-- **Complete-bipartite expansion atom interface (Proposition 3.2, final
bridge).**  Suppose every uncountably chromatic host contains witness matrices
of every finite size whose apex colouring is locally `t`-bounded.  Then the
private-vertex expansion of `K_{n,n}` is obligatory.

The hypothesis is precisely the output that remains to be supplied by the
codegree/closure-chain and uncountable-chromatic graph arguments.  The proof
of this theorem must use the verified finite rainbow-bipartite lemma to select
a rainbow submatrix, and then package its triples as a non-induced
triple-system embedding. -/
theorem IsObligatory.completeBipartiteExpansion_of_witnessedMatrices
    (n t : Nat) (hn : 0 < n) (ht : 0 < t)
    (hmat : ∀ (W : Type u) (D : Type v) [DecidableEq W]
      (H : TripleSystem W D),
      ℵ₀ < H.chromaticCardinal →
        ∀ q : Nat, Nonempty (WitnessedBipartiteMatrix H q t)) :
    (privateVertexExpansion (completeBipartiteNN.{u} n)).IsObligatory := by
  sorry

end TripleSystem
end Erdos593
