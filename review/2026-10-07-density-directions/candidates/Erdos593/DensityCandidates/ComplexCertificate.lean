import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Finset.Prod
import Mathlib.Data.Fintype.Fin
import Mathlib.Data.Fintype.Sum

/-!
# The finite 13-point, 22-triangle exposure certificate

SOURCE-ONLY CANDIDATE, 7 October 2026. No Lean compiler, version command,
service, or proof-assistant validation has been run for this file. The closed
finite facts below use Lean's kernel `decide`, not `native_decide`.

The labelled triangles and exposure orders are those in the finite certificate
preserved in `research/e593-pro-openai-audit-20261007/audit-and-directions.json`,
direction D2. Its external provenance is the frozen `openai/math` commit
`adc7f1241b42e322a6451854ab7e4b4c146bf78a`,
`preprints/A-counterexample-to-Sidorenkos-conjecture-September-23-2026/build/sections/complex.tex`.

These declarations certify concrete membership, freshness, and the partition
into two exposure orders. They do not by themselves prove sparsity for every
vertex subset, balancedness, Sidorenko failure, or the random Turan consequence.
The generic exposure-to-sparsity argument is a separate candidate module.
-/

namespace E593DensityDevelopment.ComplexCertificate

/-- The actual point labels in the finite complex. -/
abbrev Point := Fin 13

/-- The actual face labels in the finite complex. -/
abbrev Face := Fin 22

/-- The eleven positions in either exposure order. -/
abbrev Position := Fin 11

/-- The 22 labelled triples, in the external certificate's face order. -/
def faces : Face → Finset Point :=
  ![{0, 1, 3}, {0, 1, 9}, {0, 2, 3}, {0, 2, 9},
    {1, 3, 10}, {1, 7, 10}, {1, 7, 12}, {1, 9, 12},
    {2, 3, 4}, {2, 4, 9}, {3, 4, 11}, {3, 10, 11},
    {4, 8, 9}, {4, 8, 11}, {5, 6, 7}, {5, 6, 11},
    {5, 7, 10}, {5, 10, 11}, {6, 7, 12}, {6, 8, 11},
    {6, 8, 12}, {8, 9, 12}]

/-- The first eleven-face exposure order. -/
def order0 : Position → Face :=
  ![0, 1, 2, 4, 5, 16, 14, 18, 20, 19, 13]

/-- The second eleven-face exposure order. -/
def order1 : Position → Face :=
  ![3, 9, 8, 10, 11, 17, 15, 12, 21, 7, 6]

/-- A point fresh at its position in the first exposure order. At the first
position, any point of the initial triangle is fresh. -/
def fresh0 : Position → Point :=
  ![0, 9, 2, 10, 7, 5, 6, 12, 8, 11, 4]

/-- A point fresh at its position in the second exposure order. -/
def fresh1 : Position → Point :=
  ![0, 4, 3, 11, 10, 5, 6, 8, 12, 1, 7]

/-- Every actual face has exactly three distinct actual points. -/
theorem card_faces : ∀ f : Face, (faces f).card = 3 := by
  decide

/-- No two face labels encode the same triangle. -/
theorem faces_injective : Function.Injective faces := by
  decide

/-- The first exposure order has no repeated face. -/
theorem order0_injective : Function.Injective order0 := by
  decide

/-- The second exposure order has no repeated face. -/
theorem order1_injective : Function.Injective order1 := by
  decide

/-- The certified point belongs to its face in the first exposure order. -/
theorem fresh0_mem : ∀ k : Position, fresh0 k ∈ faces (order0 k) := by
  decide

/-- The certified point belongs to its face in the second exposure order. -/
theorem fresh1_mem : ∀ k : Position, fresh1 k ∈ faces (order1 k) := by
  decide

/-- Each certified point is absent from every earlier face in the first order. -/
theorem fresh0_not_earlier :
    ∀ k j : Position, j < k → fresh0 k ∉ faces (order0 j) := by
  decide

/-- Each certified point is absent from every earlier face in the second order. -/
theorem fresh1_not_earlier :
    ∀ k j : Position, j < k → fresh1 k ∉ faces (order1 j) := by
  decide

/-- The actual first face class, not an abstract eleven-element proxy. -/
def class0 : Finset Face := Finset.univ.image order0

/-- The actual second face class. -/
def class1 : Finset Face := Finset.univ.image order1

/-- Both actual classes have eleven faces. -/
theorem card_classes : class0.card = 11 ∧ class1.card = 11 := by
  decide

/-- The two certified classes share no actual face. -/
theorem classes_disjoint : Disjoint class0 class1 := by
  decide

/-- The two exposure orders account for every actual face of the complex. -/
theorem classes_cover : class0 ∪ class1 = Finset.univ := by
  decide

/-- Either exposure order reaches all thirteen actual point labels. -/
theorem orders_cover_points :
    (Finset.univ.biUnion fun k : Position => faces (order0 k)) = Finset.univ ∧
    (Finset.univ.biUnion fun k : Position => faces (order1 k)) = Finset.univ := by
  decide

/-- Actual point--face incidences. Each pair is one oriented bipartite edge,
so its cardinality is not the doubled adjacency-relation cardinality. -/
def incidences : Finset (Point × Face) :=
  (Finset.univ ×ˢ Finset.univ).filter fun pf => pf.1 ∈ faces pf.2

/-- There are exactly 66 actual point--face incidences. -/
theorem card_incidences : incidences.card = 66 := by
  decide

/-- The bipartite vertex carrier has 13 point nodes and 22 face nodes. -/
theorem card_vertex_carrier : Fintype.card (Point ⊕ Face) = 35 := by
  decide

end E593DensityDevelopment.ComplexCertificate
