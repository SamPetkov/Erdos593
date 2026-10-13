import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic

/-!
# Finite port-sensitive density contraction

These are source-only candidates. They have not been compiled or accepted.
The equalities are finite algebra, not a Sidorenko closure theorem.

`Shared` contains actual joint vertices. `Internal i` contains actual vertices
belonging only to atom `i`. A port of atom `i` is mapped to its actual joint by
`port i`. Multiple ports, and atoms having several joints, are retained.
The final theorem includes explicit equivalences of the original vertex and
edge carriers and an endpoint-fidelity hypothesis, rather than assuming the
desired equality of densities.
-/

noncomputable section

namespace E593.DensityPorts

open scoped BigOperators Classical

universe u v w z p

/-- Weighted finite integration. Normalization and nonnegativity are proved
separately when this is interpreted as expectation. -/
def finiteMean {A : Type u} [Fintype A] (weight : A → ℝ) (f : A → ℝ) : ℝ :=
  ∑ a, weight a * f a

/-- Weight of an assignment under independent, identically distributed samples. -/
def vertexWeight {V : Type u} {Ω : Type v} [Fintype V]
    (μ : Ω → ℝ) (x : V → Ω) : ℝ :=
  ∏ v, μ (x v)

/-- All assignments are included: this is homomorphism density, not injective density. -/
def finiteDensity {V : Type u} {Ω : Type v} [Fintype V] [Fintype Ω]
    (μ : Ω → ℝ) (f : (V → Ω) → ℝ) : ℝ :=
  finiteMean (vertexWeight μ) f

theorem vertexWeight_nonnegative {V : Type u} {Ω : Type v} [Fintype V]
    (μ : Ω → ℝ) (hμ : ∀ a, 0 ≤ μ a) (x : V → Ω) :
    0 ≤ vertexWeight μ x := by
  exact Finset.prod_nonneg (fun v _ => hμ (x v))

theorem vertexWeight_mass {V : Type u} {Ω : Type v}
    [Fintype V] [Fintype Ω] (μ : Ω → ℝ) (hμ : ∑ a, μ a = 1) :
    (∑ x : V → Ω, vertexWeight μ x) = 1 := by
  classical
  calc
    (∑ x : V → Ω, vertexWeight μ x) = ∏ _v : V, ∑ a, μ a := by
      exact (Fintype.prod_sum (fun _v : V => μ)).symm
    _ = 1 := by simp only [hμ, Finset.prod_const_one]

/-- Exact product integration over finite dependent sample spaces. No
nonemptiness assumption is hidden; empty products and sums have their usual meanings. -/
theorem dependent_weighted_factorization {I : Type u} [Fintype I]
    {X : I → Type v} [∀ i, Fintype (X i)]
    (weight : ∀ i, X i → ℝ) (factor : ∀ i, X i → ℝ) :
    (∑ x : ∀ i, X i, (∏ i, weight i (x i)) * (∏ i, factor i (x i))) =
      ∏ i, ∑ a, weight i a * factor i a := by
  classical
  simpa only [Finset.prod_mul_distrib] using
    (Fintype.prod_sum (fun i a => weight i a * factor i a)).symm

/-- Keep the shared assignment fixed while integrating independent atom-internal
coordinates, then integrate the shared assignment. -/
theorem shared_weighted_contraction {S : Type u} [Fintype S]
    {I : Type v} [Fintype I] {X : I → Type w} [∀ i, Fintype (X i)]
    (sharedWeight : S → ℝ) (weight : ∀ i, X i → ℝ)
    (factor : S → ∀ i, X i → ℝ) :
    (∑ y : S × (∀ i, X i),
      sharedWeight y.1 * (∏ i, weight i (y.2 i)) *
        (∏ i, factor y.1 i (y.2 i))) =
      ∑ s, sharedWeight s * ∏ i, ∑ a, weight i a * factor s i a := by
  classical
  rw [Fintype.sum_prod_type]
  refine Finset.sum_congr rfl (fun s _ => ?_)
  calc
    (∑ x : ∀ i, X i,
      sharedWeight s * (∏ i, weight i (x i)) * (∏ i, factor s i (x i))) =
        ∑ x : ∀ i, X i,
          sharedWeight s * ((∏ i, weight i (x i)) * (∏ i, factor s i (x i))) := by
      apply Finset.sum_congr rfl
      intro x _
      exact mul_assoc _ _ _
    _ = sharedWeight s *
        (∑ x : ∀ i, X i, (∏ i, weight i (x i)) * (∏ i, factor s i (x i))) :=
      (Finset.mul_sum _ _ _).symm
    _ = sharedWeight s * ∏ i, ∑ a, weight i a * factor s i a := by
      rw [dependent_weighted_factorization]

/-- Splitting assignments uses the disjoint union of actual internal carriers,
not a list count or a replacement abstract atom carrier. -/
def splitAssignments {I : Type u} {Shared : Type v} {Internal : I → Type w}
    {Ω : Type z} :
    ((Shared ⊕ Sigma Internal) → Ω) ≃
      ((Shared → Ω) × (∀ i, Internal i → Ω)) where
  toFun x := (fun s => x (.inl s), fun i v => x (.inr ⟨i, v⟩))
  invFun y := Sum.elim y.1 (fun v => y.2 v.1 v.2)
  left_inv x := by
    funext v
    cases v with
    | inl s => rfl
    | inr v => cases v; rfl
  right_inv y := by
    rcases y with ⟨s, x⟩
    rfl

theorem vertexWeight_split {I : Type u} {Shared : Type v}
    {Internal : I → Type w} {Ω : Type z}
    [Fintype I] [Fintype Shared] [∀ i, Fintype (Internal i)]
    (μ : Ω → ℝ) (x : (Shared ⊕ Sigma Internal) → Ω) :
    vertexWeight μ x =
      vertexWeight μ (fun s : Shared => x (.inl s)) *
        ∏ i, vertexWeight μ (fun v : Internal i => x (.inr ⟨i, v⟩)) := by
  unfold vertexWeight
  rw [Fintype.prod_sum_type, Fintype.prod_sigma]

/-- Integrate all internal vertices of one atom while keeping its complete
multi-port assignment fixed. -/
def portMarginal {I : Type u} {Port : I → Type v} {Internal : I → Type w}
    {Ω : Type z} [∀ i, Fintype (Internal i)] [Fintype Ω]
    (μ : Ω → ℝ)
    (kernel : ∀ i, (Port i → Ω) → (Internal i → Ω) → ℝ)
    (i : I) (s : Port i → Ω) : ℝ :=
  finiteMean (vertexWeight μ) (kernel i s)

theorem represented_port_contraction {I : Type u} {Shared : Type v}
    {Port : I → Type w} {Internal : I → Type p} {Ω : Type z}
    [Fintype I] [Fintype Shared] [∀ i, Fintype (Internal i)] [Fintype Ω]
    (μ : Ω → ℝ) (port : ∀ i, Port i → Shared)
    (kernel : ∀ i, (Port i → Ω) → (Internal i → Ω) → ℝ) :
    finiteDensity μ (fun x : (Shared ⊕ Sigma Internal) → Ω =>
      ∏ i, kernel i (fun p => x (.inl (port i p)))
        (fun v => x (.inr ⟨i, v⟩))) =
      finiteMean (vertexWeight μ) (fun s : Shared → Ω =>
        ∏ i, portMarginal μ kernel i (fun p => s (port i p))) := by
  classical
  unfold finiteDensity finiteMean portMarginal
  calc
    (∑ x : (Shared ⊕ Sigma Internal) → Ω,
      vertexWeight μ x *
        ∏ i, kernel i (fun p => x (.inl (port i p)))
          (fun v => x (.inr ⟨i, v⟩))) =
        ∑ y : (Shared → Ω) × (∀ i, Internal i → Ω),
          vertexWeight μ y.1 * (∏ i, vertexWeight μ (y.2 i)) *
            ∏ i, kernel i (fun p => y.1 (port i p)) (y.2 i) := by
      refine Fintype.sum_equiv splitAssignments _ _ (fun x => ?_)
      rw [vertexWeight_split]
      rfl
    _ = ∑ s : Shared → Ω, vertexWeight μ s *
        ∏ i, ∑ x : Internal i → Ω,
          vertexWeight μ x * kernel i (fun p => s (port i p)) x := by
      exact shared_weighted_contraction (vertexWeight μ)
        (fun _i => vertexWeight μ)
        (fun s i x => kernel i (fun p => s (port i p)) x)

/-- Reindex independent assignments along an actual vertex-carrier equivalence. -/
def reindexAssignments {V : Type u} {W : Type v} {Ω : Type w}
    (d : V ≃ W) : (V → Ω) ≃ (W → Ω) where
  toFun x := fun w => x (d.symm w)
  invFun y := fun v => y (d v)
  left_inv x := by funext v; simp
  right_inv y := by funext w; simp

theorem finiteDensity_reindex {V : Type u} {W : Type v} {Ω : Type w}
    [Fintype V] [Fintype W] [Fintype Ω]
    (d : V ≃ W) (μ : Ω → ℝ) (factor : (W → Ω) → ℝ) :
    finiteDensity μ (fun x => factor (reindexAssignments d x)) =
      finiteDensity μ factor := by
  classical
  unfold finiteDensity finiteMean
  refine Fintype.sum_equiv (reindexAssignments d) _ _ (fun x => ?_)
  have hw := d.symm.prod_comp (fun v => μ (x v))
  change (∏ v, μ (x v)) * factor (reindexAssignments d x) =
    (∏ w, μ (x (d.symm w))) * factor (reindexAssignments d x)
  rw [hw]

/-- The full multi-port contraction on the original vertex carrier. -/
theorem original_carrier_port_contraction {V : Type u} {I : Type v}
    {Shared : Type w} {Port : I → Type w} {Internal : I → Type w} {Ω : Type z}
    [Fintype V] [Fintype I] [Fintype Shared]
    [∀ i, Fintype (Internal i)] [Fintype Ω]
    (d : V ≃ Shared ⊕ Sigma Internal) (μ : Ω → ℝ)
    (port : ∀ i, Port i → Shared)
    (kernel : ∀ i, (Port i → Ω) → (Internal i → Ω) → ℝ) :
    finiteDensity μ (fun x : V → Ω =>
      ∏ i, kernel i (fun p => x (d.symm (.inl (port i p))))
        (fun v => x (d.symm (.inr ⟨i, v⟩)))) =
      finiteMean (vertexWeight μ) (fun s : Shared → Ω =>
        ∏ i, portMarginal μ kernel i (fun p => s (port i p))) := by
  exact (finiteDensity_reindex d μ (fun x =>
    ∏ i, kernel i (fun p => x (.inl (port i p)))
      (fun v => x (.inr ⟨i, v⟩)))).trans
    (represented_port_contraction μ port kernel)

/-- The edge product of one atom retains its ordered edge inputs; symmetry is
not needed for the contraction identity. -/
def atomEdgeKernel {I : Type u} {AtomEdge : I → Type v}
    {Port : I → Type w} {Internal : I → Type w} {Slot : Type z} {Ω : Type z}
    [∀ i, Fintype (AtomEdge i)]
    (U : (Slot → Ω) → ℝ)
    (endpoint : ∀ i, AtomEdge i → Slot → Port i ⊕ Internal i)
    (i : I) (s : Port i → Ω) (x : Internal i → Ω) : ℝ :=
  ∏ e, U (fun k => Sum.elim s x (endpoint i e k))

/-- Exact homomorphism-density contraction for an edge partition and a vertex
decomposition on the original carriers. `endpoint_fidelity` checks every
original edge endpoint. It is not an assumed density identity. -/
theorem edge_partition_port_contraction
    {V : Type u} {Edge : Type u} {I : Type v}
    {Shared : Type w} {Port : I → Type w} {Internal : I → Type w}
    {AtomEdge : I → Type w} {Slot : Type z} {Ω : Type z}
    [Fintype V] [Fintype Edge] [Fintype I] [Fintype Shared]
    [∀ i, Fintype (Internal i)] [∀ i, Fintype (AtomEdge i)] [Fintype Ω]
    (d : V ≃ Shared ⊕ Sigma Internal) (a : Edge ≃ Sigma AtomEdge)
    (μ : Ω → ℝ) (U : (Slot → Ω) → ℝ)
    (port : ∀ i, Port i → Shared) (edge : Edge → Slot → V)
    (endpoint : ∀ i, AtomEdge i → Slot → Port i ⊕ Internal i)
    (endpoint_fidelity : ∀ i e k,
      d (edge (a.symm ⟨i, e⟩) k) =
        Sum.elim (fun p => Sum.inl (port i p))
          (fun v => Sum.inr ⟨i, v⟩) (endpoint i e k)) :
    finiteDensity μ (fun x : V → Ω => ∏ e, U (fun k => x (edge e k))) =
      finiteMean (vertexWeight μ) (fun s : Shared → Ω =>
        ∏ i, portMarginal μ (atomEdgeKernel U endpoint) i
          (fun p => s (port i p))) := by
  classical
  have factorization : ∀ x : V → Ω,
      (∏ e, U (fun k => x (edge e k))) =
        ∏ i, atomEdgeKernel U endpoint i
          (fun p => x (d.symm (.inl (port i p))))
          (fun v => x (d.symm (.inr ⟨i, v⟩))) := by
    intro x
    calc
      (∏ e, U (fun k => x (edge e k))) =
          ∏ q : Sigma AtomEdge, U (fun k => x (edge (a.symm q) k)) :=
        (a.symm.prod_comp (fun e => U (fun k => x (edge e k)))).symm
      _ = ∏ i, ∏ e, U (fun k => x (edge (a.symm ⟨i, e⟩) k)) :=
        Fintype.prod_sigma _
      _ = ∏ i, atomEdgeKernel U endpoint i
          (fun p => x (d.symm (.inl (port i p))))
          (fun v => x (d.symm (.inr ⟨i, v⟩))) := by
        refine Fintype.prod_congr _ _ (fun i => ?_)
        unfold atomEdgeKernel
        refine Fintype.prod_congr _ _ (fun e => ?_)
        apply congrArg U
        funext k
        have he : edge (a.symm ⟨i, e⟩) k =
            d.symm (Sum.elim (fun p => Sum.inl (port i p))
              (fun v => Sum.inr ⟨i, v⟩) (endpoint i e k)) := by
          apply d.injective
          simpa only [Equiv.apply_symm_apply] using endpoint_fidelity i e k
        rw [he]
        cases endpoint i e k <;> rfl
  calc
    finiteDensity μ (fun x : V → Ω => ∏ e, U (fun k => x (edge e k))) =
        finiteDensity μ (fun x : V → Ω =>
          ∏ i, atomEdgeKernel U endpoint i
            (fun p => x (d.symm (.inl (port i p))))
            (fun v => x (d.symm (.inr ⟨i, v⟩)))) := by
      unfold finiteDensity finiteMean
      refine Finset.sum_congr rfl (fun x _ => ?_)
      rw [factorization x]
    _ = _ := original_carrier_port_contraction d μ port (atomEdgeKernel U endpoint)

/-- The pair marginal of a private expansion kernel, with both ordered core
inputs retained. When `Private = Fin (r-2)`, this is the usual r-to-two marginal. -/
def privatePairMarginal {Private : Type u} {Ω : Type v}
    [Fintype Private] [Fintype Ω] (μ : Ω → ℝ)
    (U : ((Fin 2 ⊕ Private) → Ω) → ℝ) (s : Fin 2 → Ω) : ℝ :=
  finiteMean (vertexWeight μ) (fun x : Private → Ω => U (Sum.elim s x))

/-- Exact private-expansion marginal identity on all original core assignments
and every edge's own distinct private-vertex carrier. No Sidorenko inequality
or graph recognition theorem is assumed here. -/
theorem private_expansion_marginal_identity {Core : Type u} {Edge : Type v}
    {Private : Type w} {Ω : Type z}
    [Fintype Core] [Fintype Edge] [Fintype Private] [Fintype Ω]
    (μ : Ω → ℝ) (U : ((Fin 2 ⊕ Private) → Ω) → ℝ)
    (edge : Edge → Fin 2 → Core) :
    finiteDensity μ (fun x : (Core ⊕ (Sigma fun _e : Edge => Private)) → Ω =>
      ∏ e, U (Sum.elim (fun p => x (.inl (edge e p)))
        (fun v => x (.inr ⟨e, v⟩)))) =
      finiteDensity μ (fun x : Core → Ω =>
        ∏ e, privatePairMarginal μ U (fun p => x (edge e p))) := by
  exact represented_port_contraction (I := Edge) (Port := fun _e => Fin 2)
    (Internal := fun _e => Private) μ edge (fun _e s x => U (Sum.elim s x))

end E593.DensityPorts
