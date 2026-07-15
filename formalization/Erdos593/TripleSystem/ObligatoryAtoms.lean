import Erdos593.Graph.CompleteBipartite
import Erdos593.TripleSystem.Expansion
import Erdos593.TripleSystem.Obligatory

/-!
# Obligatory private-vertex-expansion atoms

This module is the foundational home for the balanced complete-bipartite
private-vertex-expansion atoms.  It intentionally contains no constructive
closure or bipartite-reduction imports, so the positive atom theorem can be
used by those downstream results without a dependency cycle.
-/

namespace Erdos593

universe u

namespace TripleSystem

/-- The private-vertex expansion of the balanced complete bipartite graph
`K_{n,n}` in the ambient universe. -/
abbrev completeBipartiteExpansionAtom (n : ℕ) :=
  privateVertexExpansion (completeBipartiteNN.{u} n)

/-- The `K_{0,0}` expansion atom is obligatory because both its points and
edge indices are empty. -/
theorem completeBipartiteExpansionAtom_zero_isObligatory :
    (completeBipartiteExpansionAtom.{u} 0).IsObligatory := by
  intro W D _ H _
  apply Nonempty.intro
  exact
    { vertex :=
        { toFun := fun x => isEmptyElim x
          inj' := fun x => isEmptyElim x }
      edge := fun e => isEmptyElim e
      map_edge := fun e => isEmptyElim e }

end TripleSystem

end Erdos593
