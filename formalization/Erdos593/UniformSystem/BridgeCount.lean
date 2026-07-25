import Erdos593.Graph.Bridge
import Erdos593.Graph.BridgeFree
import Erdos593.UniformSystem.Levi

/-!
# Bridge-count interface for uniform systems

This module isolates the local arithmetic behind the uniform bridge-block
proof. The graph-theoretic no-singleton fact is inherited from the existing
general bridge-free graph kernel.
-/

namespace Erdos593

universe u v

namespace UniformSystem

variable {r : ℕ} {V : Type u} {E : Type v} (F : UniformSystem r V E)

/-- Points of `e` whose Levi incidence is an actual bridge. -/
def bridgeIncidences (e : E) : Set V :=
  {x | F.Inc x e ∧
    s(Sum.inl x, Sum.inr e) ∈ SimpleGraph.bridgeEdges F.levi}

/-- Every bridge incidence of `e` is, in particular, an incidence of `e`. -/
theorem bridgeIncidences_subset_edgeSet (e : E) :
    F.bridgeIncidences e ⊆ F.edgeSet e := by
  intro x hx
  exact hx.1

/-- Number of bridge incidences at a hyperedge-node. -/
noncomputable def bridgeCount (e : E) : ℕ :=
  (F.bridgeIncidences e).ncard

/-- Arithmetic residual degree after removing the bridge incidences. -/
noncomputable def residualCount (e : E) : ℕ :=
  r - F.bridgeCount e

/-- The uniform bridge lower bound appearing in the proposed intrinsic
criterion. -/
def BridgeLowerBound : Prop :=
  ∀ e : E, r - 2 ≤ F.bridgeCount e

/-- Graph theory supplies this property: after all bridges are removed, a
hyperedge-node cannot have residual degree exactly one. -/
def NoSingletonResidual : Prop :=
  ∀ e : E, F.residualCount e ≠ 1

/-- The number of bridge incidences cannot exceed the uniformity. -/
theorem bridgeCount_le_uniformity (hr : r ≠ 0) (e : E) :
    F.bridgeCount e ≤ r := by
  calc
    F.bridgeCount e = (F.bridgeIncidences e).ncard := rfl
    _ ≤ (F.edgeSet e).ncard :=
      Set.ncard_le_ncard
        (F.bridgeIncidences_subset_edgeSet e) (F.edgeSet_finite hr e)
    _ = r := F.edgeSet_ncard e

/-- Under the bridge lower bound, at most two incidences remain. -/
theorem residualCount_le_two (hr : 2 ≤ r)
    (hbridge : F.BridgeLowerBound) (e : E) :
    F.residualCount e ≤ 2 := by
  have hr0 : r ≠ 0 := by omega
  have hupper := F.bridgeCount_le_uniformity hr0 e
  have hlower := hbridge e
  unfold residualCount
  omega

/-- Combining the arithmetic upper bound with the no-singleton graph lemma
produces the decisive `0/2` residual-count dichotomy. -/
theorem residualCount_eq_zero_or_two (hr : 2 ≤ r)
    (hbridge : F.BridgeLowerBound) (hno : F.NoSingletonResidual) (e : E) :
    F.residualCount e = 0 ∨ F.residualCount e = 2 := by
  have hle := F.residualCount_le_two hr hbridge e
  have hne := hno e
  omega

/-- The existing graph kernel proves directly that the actual bridge-free
Levi degree of a hyperedge-node is never one. -/
theorem bridgeFree_degree_ne_one [Fintype (V ⊕ E)] [DecidableEq (V ⊕ E)]
    [DecidableRel F.levi.Adj] (e : E) :
    (SimpleGraph.bridgeFree F.levi).degree (.inr e) ≠ 1 :=
  SimpleGraph.bridgeFree_degree_ne_one F.levi (.inr e)

/-- Once the actual bridge-free degree is known to be at most two, the generic
finite-graph kernel closes the decisive zero-or-two alternative. -/
theorem bridgeFree_degree_eq_zero_or_two_of_le_two
    [Fintype (V ⊕ E)] [DecidableEq (V ⊕ E)] [DecidableRel F.levi.Adj]
    (e : E)
    (hle : (SimpleGraph.bridgeFree F.levi).degree (.inr e) ≤ 2) :
    (SimpleGraph.bridgeFree F.levi).degree (.inr e) = 0 ∨
      (SimpleGraph.bridgeFree F.levi).degree (.inr e) = 2 := by
  have hne := F.bridgeFree_degree_ne_one e
  omega

/-- Every Berge cycle has even length, represented by divisibility of its Levi
cycle length by four. -/
def EvenBergeCycles : Prop :=
  ∀ ⦃z : V ⊕ E⦄ (c : F.levi.Walk z z), c.IsCycle → 4 ∣ c.length

/-- Uniformity-parametric intrinsic interface. -/
def Intrinsic : Prop :=
  F.Linear ∧ F.BridgeLowerBound ∧ F.EvenBergeCycles

end UniformSystem

end Erdos593
