import Erdos593.TripleSystem.DisjointUnion
import Erdos593.TripleSystem.Embedding

/-!
# Forward properties of disjoint unions

The tagged summands embed canonically in a disjoint union, and linearity is
inherited componentwise.
-/

namespace Erdos593

universe u v w z

namespace TripleSystem

variable {V : Type u} {E : Type v} {W : Type w} {D : Type z}

/-- The canonical embedding of the left factor into a disjoint union. -/
def Embedding.disjointUnionInl (F : TripleSystem V E) (G : TripleSystem W D) :
    F.Embedding (F.disjointUnion G) where
  vertex := ⟨Sum.inl, Sum.inl_injective⟩
  edge := Sum.inl
  map_edge e := (disjointUnion_edgeSet_inl F G e).symm

/-- The canonical embedding of the right factor into a disjoint union. -/
def Embedding.disjointUnionInr (F : TripleSystem V E) (G : TripleSystem W D) :
    G.Embedding (F.disjointUnion G) where
  vertex := ⟨Sum.inr, Sum.inr_injective⟩
  edge := Sum.inr
  map_edge d := (disjointUnion_edgeSet_inr F G d).symm

/-- A disjoint union of linear triple systems is linear. -/
theorem disjointUnion_linear (F : TripleSystem V E) (G : TripleSystem W D)
    (hF : F.Linear) (hG : G.Linear) :
    (F.disjointUnion G).Linear := by
  intro e f x y hef hxe hxf hye hyf
  rcases e with e | d <;> rcases f with f | c <;>
    rcases x with x | x <;> rcases y with y | y <;>
    simp only [disjointUnion_inc_inl_inl, disjointUnion_inc_inr_inr,
      disjointUnion_not_inc_inl_inr, disjointUnion_not_inc_inr_inl] at *
  · exact congrArg Sum.inl (hF (Sum.inl_injective.ne_iff.mp hef) hxe hxf hye hyf)
  · exact congrArg Sum.inr (hG (Sum.inr_injective.ne_iff.mp hef) hxe hxf hye hyf)

end TripleSystem

end Erdos593
