import Erdos593.TripleSystem.CanonicalAtomMinimalGenerators

/-!
# Canonical atom transport

Supported edge restrictions have no isolated points. Literal one-point
indecomposability is invariant under isomorphism, and each actual canonical
atom restriction has this property.
-/

namespace Erdos593
namespace TripleSystem

universe u v

theorem edgeRestriction_hasNoIsolatedPoints
    {V : Type u} {E : Type v} (F : TripleSystem V E) (S : Set E) :
    (F.edgeRestriction S).HasNoIsolatedPoints := by
  intro x
  rcases x.property with ⟨e, he, hxe⟩
  exact (F.edgeRestriction S).not_isolated_of_inc (e := ⟨e, he⟩) hxe

namespace CanonicalAtom

theorem onePointIndecomposable_iff_of_iso
    {V E W D : Type u}
    {F : TripleSystem V E} {G : TripleSystem W D}
    (f : TripleSystem.Iso F G) :
    OnePointIndecomposable F ↔ OnePointIndecomposable G := by
  constructor
  · intro hF hG
    rcases hG with ⟨V₀, E₀, V₁, E₁, F₀, F₁, r₀, r₁, h₀, h₁, ⟨g⟩⟩
    exact hF ⟨V₀, E₀, V₁, E₁, F₀, F₁, r₀, r₁, h₀, h₁, ⟨f.trans g⟩⟩
  · intro hG hF
    rcases hF with ⟨V₀, E₀, V₁, E₁, F₀, F₁, r₀, r₁, h₀, h₁, ⟨g⟩⟩
    exact hG ⟨V₀, E₀, V₁, E₁, F₀, F₁, r₀, r₁, h₀, h₁, ⟨f.symm.trans g⟩⟩

theorem atomRestriction_onePointIndecomposable
    {V E : Type u} (F : TripleSystem V E)
    [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    [DecidableRel F.levi.Adj]
    (hF : F.Intrinsic) (A : CanonicalAtom.Index F) :
    OnePointIndecomposable
      (CanonicalAtom.atomRestriction F hF.1 hF.2.1 A) := by
  classical
  cases A with
  | singleton e hzero =>
      rcases atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
        F hF.1 hF.2.1 (CanonicalAtom.Index.singleton e hzero) with ⟨hiso⟩
      exact (onePointIndecomposable_iff_of_iso
        (hiso.trans (oneEdgeExpansionSingleEdgePieceIso F e).symm)).mpr
          oneTriple_onePointIndecomposable
  | cycleBlock C hC B =>
      rcases atomRestriction_is_singleEdge_or_cycleBlockExpansion.{u, u, u}
        F hF.1 hF.2.1 (CanonicalAtom.Index.cycleBlock C hC B) with ⟨hiso⟩
      let core : TwoConnectedBipartiteCore.{u} :=
        { Vertex := _
          vertexFintype := inferInstance
          graph := CanonicalAtom.cycleBlockCore F C B
          twoVertexConnected :=
            cycleBlockCore_isTwoVertexConnected F hF.1 hF.2.1 C hC B
          bipartite :=
            cycleBlockCore_isBipartite F hF.1 hF.2.1 hF.2.2 C hC B }
      exact (onePointIndecomposable_iff_of_iso hiso).mpr
        (coreExpansion_onePointIndecomposable core)

end CanonicalAtom
end TripleSystem
end Erdos593
