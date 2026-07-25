import Erdos593.UniformSystem.Basic
import Mathlib.SetTheory.Cardinal.Aleph

/-!
# Uniform one-apex sequence lifts

This is the uniformity-parametric analogue of the graph-to-triple sequence
lift.  The base and edge-index types are kept in one universe in this first
kernel so that the transfinite node type and the lift point type stay simple.
-/

namespace Erdos593

open scoped Cardinal Ordinal

universe u

namespace UniformSequenceLift

/-- A concrete well-ordered index type of cardinality `ℵ₁`. -/
abbrev Index : Type u := (ω₁ : Ordinal.{u}).ToType

noncomputable instance indexNonempty : Nonempty (Index : Type u) :=
  Ordinal.nonempty_toType_iff.mpr (Cardinal.isSuccLimit_omega 1).ne_bot

noncomputable instance indexOrderBot : OrderBot (Index : Type u) :=
  WellFoundedLT.toOrderBot (Index : Type u)

/-- A transfinite sequence of base-edge indices. -/
structure Node (E : Type u) where
  length : Index
  entry : Set.Iio length → E

namespace Node

variable {E : Type u}

/-- `t` extends `q` by the prescribed next base-edge index and may then
continue further. -/
def ExtendsBy (q : Node E) (e : E) (t : Node E) : Prop :=
  ∃ h : q.length < t.length,
    (∀ i : Set.Iio q.length,
      q.entry i = t.entry ⟨i.1, i.2.trans h⟩) ∧
    t.entry ⟨q.length, h⟩ = e

theorem ne_of_extendsBy {q t : Node E} {e : E}
    (h : q.ExtendsBy e t) : q ≠ t := by
  intro hqt
  rcases h with ⟨hlen, _⟩
  exact hlen.ne (congrArg Node.length hqt)

end Node

variable {s : ℕ} {V E : Type u} (H : UniformSystem s V E)

/-- Vertices of the one-apex lift. -/
abbrev Point : Type u := Node E × V

/-- The base copy of one indexed edge at a sequence node. -/
def baseSet (q : Node E) (e : E) : Set (Point H) :=
  (fun x : V => (q, x)) '' H.edgeSet e

/-- Extensional edge sets admitted by the uniform one-apex construction. -/
def IsEdgeSet (S : Set (Point H)) : Prop :=
  ∃ (q t : Node E) (e : E) (z : V),
    q.ExtendsBy e t ∧ S = insert (t, z) (H.baseSet q e)

/-- Lift edge indices are their extensional point sets. -/
abbrev Edge : Type u :=
  {S : Set (Point H) // H.IsEdgeSet S}

/-- The lift edge determined by explicit base and apex data. -/
def mkEdge (q t : Node E) (e : E) (z : V)
    (hext : q.ExtendsBy e t) : Edge H :=
  ⟨insert (t, z) (H.baseSet q e), ⟨q, t, e, z, hext, rfl⟩⟩

private theorem baseMap_injective (q : Node E) :
    Function.Injective (fun x : V => (q, x)) := by
  intro x y h
  exact congrArg Prod.snd h

/-- The apex is not one of the base points. -/
theorem apex_not_mem_base {q t : Node E} {e : E} {z : V}
    (hext : q.ExtendsBy e t) :
    (t, z) ∉ H.baseSet q e := by
  rintro ⟨x, -, hxt⟩
  exact Node.ne_of_extendsBy hext (congrArg Prod.fst hxt)

/-- The uniform one-apex lift of `H`. -/
noncomputable def system (hs : s ≠ 0) :
    UniformSystem (s + 1) (Point H) (Edge H) where
  Inc p e := p ∈ e.1
  edge_ncard e := by
    rcases e.2 with ⟨q, t, a, z, hext, hset⟩
    simp only [Set.setOf_mem_eq]
    rw [hset]
    have hnot : (t, z) ∉ H.baseSet q a := H.apex_not_mem_base hext
    have hfinite : (H.baseSet q a).Finite :=
      (H.edgeSet_finite hs a).image (fun x : V => (q, x))
    rw [Set.ncard_insert_of_notMem hnot hfinite]
    rw [baseSet, Set.ncard_image_of_injective _ (baseMap_injective q)]
    exact congrArg (fun n : ℕ => n + 1) (H.edgeSet_ncard a)
  simple := by
    intro e f h
    apply Subtype.ext
    simpa only [Set.setOf_mem_eq] using h

@[simp]
theorem inc_mkEdge_iff {q t : Node E} {e : E} {z : V}
    {hext : q.ExtendsBy e t} {p : Point H} (hs : s ≠ 0) :
    (H.system hs).Inc p (H.mkEdge q t e z hext) ↔
      p = (t, z) ∨ ∃ x : V, H.Inc x e ∧ p = (q, x) := by
  simp [system, mkEdge, baseSet, eq_comm]

/-- Restrict a global edge-index branch to one initial segment. -/
def branchNode (a : Index → E) (α : Index) : Node E where
  length := α
  entry i := a i.1

/-- Two restrictions of one branch have the extension relation required by a
lift edge. -/
theorem branchNode_extendsBy (a : Index → E) {α β : Index} (hαβ : α < β) :
    (branchNode a α).ExtendsBy (a α) (branchNode a β) := by
  refine ⟨hαβ, ?_, rfl⟩
  intro i
  rfl

/-- Choose the next branch edge from the node formed by all earlier choices. -/
noncomputable def branchLetter (pick : Node E → E) : Index → E :=
  WellFounded.fix (wellFounded_lt : WellFounded ((· < ·) : Index → Index → Prop))
    fun α earlier => pick ⟨α, fun i => earlier i.1 i.2⟩

theorem branchLetter_eq (pick : Node E → E) (α : Index) :
    branchLetter pick α = pick (branchNode (branchLetter pick) α) := by
  rw [branchLetter, WellFounded.fix_eq]
  rfl

end UniformSequenceLift

end Erdos593
