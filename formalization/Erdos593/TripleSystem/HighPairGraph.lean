import Erdos593.TripleSystem.PairCodegree
import Mathlib.Combinatorics.SimpleGraph.Basic

namespace Erdos593

universe u v

namespace TripleSystem

/-- A distinct pair equipped with at least `t` explicitly witnessed third
vertex completions. The explicit disequality keeps the high-pair relation
irreflexive even when `t = 0`. -/
def HighPair {W : Type u} {D : Type v}
    (H : TripleSystem W D) (t : Nat) (x y : W) : Prop :=
  x ≠ y ∧ HasPairCodegreeAtLeast H x y t

/-- The graph whose edges are distinct high-codegree pairs in a triple system. -/
def highPairGraph {W : Type u} {D : Type v}
    (H : TripleSystem W D) (t : Nat) : _root_.SimpleGraph W where
  Adj x y := HighPair H t x y
  symm := ⟨by
    rintro x y ⟨hxy, hcodeg⟩
    exact ⟨hxy.symm, (hasPairCodegreeAtLeast_comm H x y t).mp hcodeg⟩⟩
  loopless := ⟨by
    intro x hx
    exact hx.1 rfl⟩

@[simp]
theorem highPairGraph_adj {W : Type u} {D : Type v}
    (H : TripleSystem W D) (t : Nat) (x y : W) :
    (highPairGraph H t).Adj x y ↔ HighPair H t x y :=
  Iff.rfl

/-- A positive-size codegree witness determines a high pair. -/
theorem highPair_of_witness {W : Type u} {D : Type v}
    {H : TripleSystem W D} {x y : W} {t : Nat}
    (p : PairCodegreeWitness H x y t) (ht : 0 < t) : HighPair H t x y :=
  ⟨PairCodegreeWitness.left_ne_right p ht, ⟨p⟩⟩

end TripleSystem

end Erdos593
