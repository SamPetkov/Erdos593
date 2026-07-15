import Erdos593.TripleSystem.Constructive
import Erdos593.TripleSystem.ObligatoryBipartiteReduction
import Erdos593.TripleSystem.ObligatoryDisjointUnion
import Erdos593.TripleSystem.ObligatoryOnePointAmalgamation

/-!
# Obligatory closure of the constructive class

This file packages the positive closure argument.  The infinitary content is
isolated in the hypothesis that the finite two-colourable expansion atoms are
obligatory; all remaining steps are the verified finite constructors.
-/

namespace Erdos593

open scoped Cardinal

universe w

namespace TripleSystem

namespace Iso

variable {V E V' E' : Type w}
variable {F : TripleSystem V E} {F' : TripleSystem V' E'}

/-- An incidence isomorphism gives a non-induced embedding in its forward
direction. -/
def toEmbedding (f : Iso F F') : F.Embedding F' where
  vertex := f.vertexEquiv.toEmbedding
  edge := f.edgeEquiv
  map_edge := by
    intro e
    ext y
    constructor
    · rintro ⟨x, hx, rfl⟩
      exact (f.map_inc_iff x e).mp hx
    · intro hy
      refine ⟨f.vertexEquiv.symm y, ?_, f.vertexEquiv.apply_symm_apply y⟩
      exact (f.map_inc_iff _ e).mpr (by simpa using hy)

end Iso

/-- Obligatory status is invariant under simultaneous relabelling of vertices
and edge indices. -/
theorem IsObligatory.ofIso {V E V' E' : Type w}
    {F : TripleSystem V E} {F' : TripleSystem V' E'}
    (hF : F.IsObligatory) (f : Iso F F') : F'.IsObligatory :=
  hF.of_sourceEmbedding f.symm.toEmbedding

/-- Every construction term carries finite vertex and edge-index types, even
though closure constructors do not expose those instances as parameters. -/
theorem Constructible.finiteTypes {V E : Type w} {F : TripleSystem V E}
    (hF : Constructible F) : Finite V ∧ Finite E := by
  induction hF with
  | ofEdgeless V =>
      exact ⟨inferInstance, inferInstance⟩
  | ofExpansion G hG =>
      classical
      letI : Finite G.edgeSet :=
        Finite.of_injective Subtype.val Subtype.val_injective
      letI : Fintype G.edgeSet := Fintype.ofFinite G.edgeSet
      exact ⟨inferInstance, inferInstance⟩
  | @disjointUnion V E W D F G hF hG ihF ihG =>
      classical
      letI : Finite V := ihF.1
      letI : Finite E := ihF.2
      letI : Finite W := ihG.1
      letI : Finite D := ihG.2
      letI : Fintype V := Fintype.ofFinite V
      letI : Fintype E := Fintype.ofFinite E
      letI : Fintype W := Fintype.ofFinite W
      letI : Fintype D := Fintype.ofFinite D
      exact ⟨inferInstance, inferInstance⟩
  | @amalgam V₀ E₀ V₁ E₁ F₀ F₁ h₀ h₁ r₀ r₁ ih₀ ih₁ =>
      classical
      letI : Finite V₀ := ih₀.1
      letI : Finite E₀ := ih₀.2
      letI : Finite V₁ := ih₁.1
      letI : Finite E₁ := ih₁.2
      letI : Fintype V₀ := Fintype.ofFinite V₀
      letI : Fintype E₀ := Fintype.ofFinite E₀
      letI : Fintype V₁ := Fintype.ofFinite V₁
      letI : Fintype E₁ := Fintype.ofFinite E₁
      letI : Fintype (OnePointAmalgamation.Vertex r₀ r₁) :=
        OnePointAmalgamation.vertexFintype r₀ r₁
      exact ⟨inferInstance, inferInstance⟩
  | @ofIso V E V' E' F F' hF f ihF =>
      letI : Finite V := ihF.1
      letI : Finite E := ihF.2
      exact ⟨Finite.of_equiv V f.vertexEquiv,
        Finite.of_equiv E f.edgeEquiv⟩

/-- Every finite edgeless triple system is obligatory. -/
theorem edgeless_isObligatory (V : Type w) [Fintype V] :
    (edgeless V).IsObligatory := by
  classical
  intro W D _ H hH
  have hvertices : ℵ₀ ≤ #W :=
    hH.le.trans H.chromaticCardinal_le_mk_vertices
  letI : Infinite W := Cardinal.aleph0_le_mk_iff.mp hvertices
  let vertexEmbedding : V ↪ W :=
    (Fintype.equivFin V).toEmbedding.trans
      (Fin.valEmbedding.trans (Infinite.natEmbedding W))
  refine ⟨{ vertex := vertexEmbedding, edge := ?_, map_edge := ?_ }⟩
  · intro e
    exact Empty.elim e.down
  · intro e
    exact Empty.elim e.down

/-- If every private-vertex expansion of a finite two-colourable graph is
obligatory, then every member of the finite constructive class is obligatory.
-/
theorem Constructible.isObligatory_of_expansions
    (hExpansion : ∀ {X : Type w} [Fintype X] (G : _root_.SimpleGraph X),
      G.Colorable 2 → (privateVertexExpansion G).IsObligatory)
    {V E : Type w} {F : TripleSystem V E} (hF : Constructible F) :
    F.IsObligatory := by
  induction hF with
  | ofEdgeless V =>
      exact edgeless_isObligatory V
  | ofExpansion G hG =>
      exact hExpansion G hG
  | @disjointUnion V E W D F G hF hG ihF ihG =>
      classical
      letI : Finite V := hF.finiteTypes.1
      letI : Finite E := hF.finiteTypes.2
      letI : Finite W := hG.finiteTypes.1
      letI : Finite D := hG.finiteTypes.2
      letI : Fintype V := Fintype.ofFinite V
      letI : Fintype E := Fintype.ofFinite E
      letI : Fintype W := Fintype.ofFinite W
      letI : Fintype D := Fintype.ofFinite D
      exact IsObligatory.disjointUnion F G ihF ihG
  | @amalgam V₀ E₀ V₁ E₁ F₀ F₁ h₀ h₁ r₀ r₁ ih₀ ih₁ =>
      classical
      letI : Finite V₀ := h₀.finiteTypes.1
      letI : Finite E₀ := h₀.finiteTypes.2
      letI : Finite V₁ := h₁.finiteTypes.1
      letI : Finite E₁ := h₁.finiteTypes.2
      letI : Fintype V₀ := Fintype.ofFinite V₀
      letI : Fintype E₀ := Fintype.ofFinite E₀
      letI : Fintype V₁ := Fintype.ofFinite V₁
      letI : Fintype E₁ := Fintype.ofFinite E₁
      exact IsObligatory.onePointAmalgamation ih₀ ih₁ r₀ r₁
  | ofIso hF f ihF =>
      exact ihF.ofIso f

/-- It is enough to establish obligatoriness for every balanced atom
`K_{n,n}⁺`: the finite bipartite reduction supplies the expansion hypothesis
needed by `Constructible.isObligatory_of_expansions`. -/
theorem Constructible.isObligatory_of_completeBipartiteNN
    (hAtoms : ∀ n : ℕ,
      (privateVertexExpansion (completeBipartiteNN.{w} n)).IsObligatory)
    {V E : Type w} {F : TripleSystem V E} (hF : Constructible F) :
    F.IsObligatory := by
  apply hF.isObligatory_of_expansions
  intro X _ G hG
  exact privateVertexExpansion_isObligatory_of_completeBipartiteNN hG hAtoms

end TripleSystem

end Erdos593
