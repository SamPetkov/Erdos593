# Classical block theory: attribution and novelty boundary

## Why this note exists

The canonical atom programme naturally rediscovers language that already exists in general hypergraph connectivity theory.  Before integrating any separator/factorization statement into the Erdős 593 manuscript, the classical boundary must be explicit.

The main conclusion is:

> **Do not claim priority for the existence, uniqueness, or tree structure of a hypergraph block decomposition.**

What is special to Erdős 593 is the classification of the blocks that can occur in an obligatory triple system and the sharp quantitative consequences of that classification.

Access checked 5 September 2026.

---

## 1. Bahmanian--Šajna block theory

M. Amin Bahmanian and Mateja Šajna, *Connection and separation in hypergraphs*, Theory and Applications of Graphs 2(2) (2015), Article 5, DOI 10.20429/tag.2015.020205; arXiv:1504.04274.

Relevant established results in their terminology include:

- a connected hypergraph with no separating vertices is **non-separable**;
- a **block** is a maximal non-separable hypersubgraph;
- distinct blocks share no hyperedge and at most one vertex;
- the blocks edge-decompose the hypergraph;
- a vertex is separating iff it lies in more than one block;
- the bipartite incidence graph between separating vertices and blocks is a tree for a connected hypergraph; and
- blocks of a hypergraph are related explicitly to maximal clusters of blocks in its incidence graph.

In particular their Theorems 3.36 and 3.38 already contain the general hypergraph analogues of the basic block-partition and shared-cut-vertex statements, while their subsequent block-graph construction gives the tree structure.

Therefore the statements in `POINT_SEPARATOR_UNIVERSALITY.md` should be viewed as a formulation in the present **edge-support / obligatory-system language**, and as an independently proved interface to the repository's canonical Levi-block extractor, not as a new general theory of hypergraph blocks.

---

## 2. More recent block literature

The 2024 paper *On the Cut-Vertex and the Interval Transit Functions of Hypergraphs* (Graphs and Combinatorics) also develops blocks of reduced and linear hypergraphs, including the fact that linear hypergraphs are block-linear and that block sequences behave graph-like.

This reinforces the same boundary: block/cut decomposition itself is established hypergraph theory.

---

## 3. How the canonical atoms relate to classical blocks

For a finite reduced obligatory triple system `F`, the canonical atoms are precisely the classical one-point blocks in the following concrete sense.

The canonical atom theorem gives atoms that are either

```text
one triple,
or J^+ with J finite, 2-connected, simple and bipartite.
```

Each such atom is non-separable under one-point decomposition.  Distinct atoms meet only at shared separator points and their incidence graph is a forest.  Conversely, a classical block cannot contain hyperedges from two canonical atoms, because their unique connecting shared point is a separating vertex; and a canonical atom cannot be contained properly in a larger non-separable subsystem for the same reason.

Thus the canonical atoms can be described as the blocks of `F`.

This gives a cleaner literature-aware formulation of the main structural result:

```text
F reduced and obligatory
  => every block of F is either
       one triple,
       or J^+ for a finite 2-connected simple bipartite J.
```

Conversely, for a **linear** reduced triple system, if every block has one of these forms, the classical block tree assembles them by one-point sums and the intrinsic conditions follow.  Linearity cannot simply be omitted: nonlinear hypergraphs may have distinct blocks meeting in more than one vertex under other block conventions or may have one-edge blocks without being obligatory.

---

## 4. What remains specific and potentially novel here

The research contribution should be framed around the following 593-specific statements, subject to the existing Li/Komjáth/Reiher priority boundaries already recorded in the manuscript.

### A. Exact classification of allowable blocks

General hypergraph block theory does **not** say that the blocks of an obligatory triple system must be private-vertex expansions of 2-connected bipartite graphs.  That conclusion comes from the Erdős 593 classification plus the canonical Levi-cycle analysis.

### B. Exact quantitative spectra of the block collection

The repository derives sharp spectra for:

- atom/block counts;
- atom cycle-rank partitions;
- indecomposable parameter regions;
- boundary rigidity; and
- disconnected componentwise extensions.

These are not consequences of generic block existence alone.

### C. Exact attachment multiplicity spectrum

For `k` atoms and `c` components, every partition of `k-c` occurs as the shared-point excess profile.  This is a theorem about the allowable obligatory atoms and their capacity-safe assembly.

### D. Decomposition-lattice spectrum

Combining the classical block tree with the exact attachment-profile theorem gives

```text
D(F) ~= product_p Pi_{mu(p)},
```

and hence an exact spectrum of decomposition-lattice isomorphism types indexed by integer partitions of `k-c`.

The **partition-lattice algebra is classical**.  The 593-specific content is the realization theorem and the exact admissible spectrum inside obligatory triple systems.

---

## 5. Recommended manuscript language

Do not insert a theorem saying merely that the atom decomposition is unique or that shared points are cut vertices; that would look like a rediscovery of standard block theory.

A stronger and safer insertion would be a short remark/corollary of the form:

> In the terminology of hypergraph connectivity, the canonical atoms are precisely the blocks of the reduced obligatory system.  Thus Theorem X specializes the classical block decomposition by identifying exactly which block types can occur: one triple and the expansions `J^+` of finite 2-connected simple bipartite graphs.  The resulting block tree then underlies the exact atom-count and attachment spectra below.

Cite Bahmanian--Šajna at this point.

If the universal one-point factorization proposition is retained, describe its block-theoretic part as a reformulation and reserve new-result language for the exact obligatory block types and quantitative spectra.

---

## 6. Research implication

Direction 1 remains valuable, but the goal is now sharper:

```text
not: invent a block tree for obligatory hypergraphs;

but: exploit the Erdős 593 classification to obtain an exact
     theory of which hypergraph blocks occur and how their
     quantitative invariants and gluing lattices can vary.
```

That distinction materially improves the credibility of the final paper.
