# Other global directions

These questions are deliberately separated from the main manuscript and from the three principal programmes.

## 1. Certificate-producing recognition

The intrinsic theorem already suggests a deterministic recognizer:

1. remove isolated vertices;
2. check linearity;
3. build the Levi graph and compute bridges;
4. reject if an edge-node has no incident bridge;
5. test bipartiteness of each cycle shadow / equivalently even Berge cycles;
6. on acceptance, output the canonical atoms and atom--shared-point forest.

A polished algorithmic theorem should state the computational model carefully. Hashing unordered point pairs gives expected linear-time linearity checking on a word RAM; sorting gives a deterministic comparison-model bound. All subsequent graph operations are linear in Levi-incidence size.

Negative certificates can be made explicit:

- two hyperedges sharing two points;
- one edge-node together with paths certifying that none of its incidences is a bridge;
- an odd Berge cycle.

## 2. Obstruction formulations

The intrinsic criterion is an obstruction theorem, but not yet a conventional finite forbidden-minor theorem. The correct minor operation is unclear: arbitrary vertex/edge deletion and contraction need not preserve the notion of obligatoriness in the desired way.

A safer programme is to classify **minimal non-obligatory systems under subhypergraph containment** in restricted regimes such as fixed edge count, linear systems, or bounded cycle rank. The three failure mechanisms strongly constrain such minimal systems, but there are infinitely many odd-cycle obstructions.

Do not claim a Robertson--Seymour-style finite obstruction set without a precise minor relation and a proof of closure.

## 3. Random obligatory systems

The canonical atom forest suggests several random models:

- fixed atom catalogue + random labelled attachment tree;
- random 2-connected bipartite atom cores + random forest assembly;
- Gibbs-weighted assemblies by total cycle rank, atom count, or shared-point multiplicity.

The repository's occupancy formulas describe one conditional attachment model. The next mathematically interesting questions are global limits after randomizing the atom types themselves: component sizes, cycle-rank density, automorphism probability, and typical inference width.

## 4. Uniformity-wide classification

The `r`-uniform research branches propose the finite intrinsic criterion

`linear + at least r-2 incident Levi bridges per hyperedge-node + even Berge cycles`

and an iterated one-apex avoidance mechanism. This is potentially the largest combinatorial extension, but it should remain a separate programme until the uniform cycle-collapse/trace argument receives independent review and further Lean formalization.

## 5. Formalization targets

Highest-value Lean additions after the existing classification endpoint:

1. canonical atom partition;
2. atom--shared-point forest;
3. functoriality under isomorphism;
4. reconstruction from the forest diagram;
5. exact finite atom-count spectra;
6. only then the uniform one-step trace theorem.

This order gives formal support first to results closest to the published 593 paper.
