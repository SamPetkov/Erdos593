# Classical block theory: attribution and novelty boundary

## Why this note exists

The canonical atom programme naturally meets language and theorems that already exist in hypergraph connectivity theory and, more specifically, in the obligatory-triple-system literature.  Before integrating any separator/factorization statement into the Erdős 593 manuscript, this boundary must be explicit.

The main conclusion is:

> **Do not claim priority for hypergraph block decomposition, its tree structure, or block-locality of obligatoriness.**

What remains specific to the present Erdős 593 project is the exact classification of the blocks that can occur and the sharp quantitative spectra of their internal ranks and attachment geometry.

Access checked 5 September 2026.

---

## 1. Komjáth 2001 already proves block-locality of obligatoriness

Péter Komjáth, *Some Remarks on Obligatory Subsytems of Uncountably Chromatic Triple Systems*, Combinatorica 21(2) (2001), 233--238, DOI 10.1007/s004930100021.

The publicly indexed abstract states explicitly:

```text
A triple system is obligatory iff every 2-connected component of it is.
```

Komjáth's later Erdős-centenary slides repeat the same result as

```text
(K) A finite triple system is obligatory iff all its 2-connected components are.
```

Thus the observation that obligatoriness is local to 2-connected components is **prior work**, not a new consequence of the current atom theorem.

The full article was not openly retrievable in this audit, so final manuscript terminology should be checked against Komjáth's exact definition of `2-connected component`; the theorem statement itself is explicit in the indexed abstract and later author slides.

This earlier result should be moved closer to the canonical-atom discussion in the manuscript, because it gives the natural historical framing: the new classification determines exactly which 2-connected obligatory components occur.

---

## 2. Bahmanian--Šajna general hypergraph block theory

M. Amin Bahmanian and Mateja Šajna, *Connection and separation in hypergraphs*, Theory and Applications of Graphs 2(2) (2015), Article 5, DOI 10.20429/tag.2015.020205; arXiv:1504.04274.

Relevant established results in their terminology include:

- a connected hypergraph with no separating vertices is **non-separable**;
- a **block** is a maximal non-separable hypersubgraph;
- distinct blocks share no hyperedge and at most one vertex;
- the blocks edge-decompose the hypergraph;
- a vertex is separating iff it lies in more than one block;
- the bipartite incidence graph between separating vertices and blocks is a tree for a connected hypergraph; and
- blocks of a hypergraph are related explicitly to maximal clusters of blocks in its incidence graph.

Their Theorems 3.36 and 3.38 contain the general hypergraph analogues of the basic block-partition and shared-cut-vertex statements, while their block-graph construction gives the tree structure.

Therefore the point-separator statements in this branch are best viewed as an independently proved interface between the repository's Levi-block extractor and standard hypergraph block language, rather than as a new general block theorem.

---

## 3. More recent block literature

The 2024 paper *On the Cut-Vertex and the Interval Transit Functions of Hypergraphs* (Graphs and Combinatorics) develops blocks of reduced and linear hypergraphs further, including graph-like behavior of blocks in linear hypergraphs.

This reinforces the same boundary: block/cut decomposition itself is established hypergraph theory.

---

## 4. Exact block characterization supplied by Erdős 593

Let `F` be a finite triple system and delete isolated points.  Combining the present classification with the classical block decomposition gives the clean formulation

```text
F is obligatory
  iff
 every block of F is either
   (i) one triple, or
   (ii) J^+ for a finite 2-connected simple bipartite graph J.
```

### Forward direction

A block of an obligatory system is obligatory by Komjáth's theorem (or simply by downward closure once the block is viewed as a subsystem).  It is one-point indecomposable.  The canonical-atom theorem therefore identifies it as one triple or `J^+` with `J` finite, 2-connected, simple and bipartite.

### Reverse direction

Every displayed block type is obligatory.  Komjáth's block-locality theorem then gives obligatoriness of the whole finite system.  Equivalently, the classical block tree assembles the blocks by one-point amalgamations, and the closure theorem gives the same conclusion.

This is a useful **reformulation and synthesis**, not a priority claim over Komjáth's reduction.

It also shows that no separate linearity hypothesis is needed in this block formulation: an impermissible nonlinear 2-connected configuration would itself form or lie inside a block that is not one of the classified types.

---

## 5. What remains 593-specific and potentially novel

The research contribution should be framed around the following statements, subject to the existing Li/Komjáth/Reiher priority boundaries already recorded in the manuscript.

### A. Exact classification of allowable blocks

General hypergraph block theory and Komjáth's reduction do **not** identify the complete list of obligatory 2-connected components.  The Erdős 593 classification does:

```text
one triple,
or J^+ with J finite, 2-connected, simple and bipartite.
```

This is the meaningful structural payoff.

### B. Exact quantitative spectra of the block collection

The repository derives sharp spectra for:

- atom/block counts;
- positive block cycle-rank partitions;
- indecomposable parameter regions;
- boundary rigidity; and
- disconnected componentwise extensions.

These are not consequences of generic block existence.

### C. Exact attachment multiplicity spectrum

For `k` canonical blocks and `c` components, every partition of `k-c` occurs as the shared-point excess profile.  This is an exact realization theorem for the allowable obligatory block types.

### D. Exact decomposition-lattice spectrum

The full lattice of supported one-point decompositions satisfies

```text
D(F) ~= product_p Pi_{mu(p)}.
```

The partition-lattice algebra is classical.  The 593-specific content is that the exact atom and attachment spectra tell us **which products occur at every feasible global parameter tuple**, and every allowed product is realizable.

---

## 6. Recommended manuscript language

Do not add a theorem whose headline is merely uniqueness of the block tree or block-locality of obligatoriness.

A stronger and historically accurate paragraph is:

> Komjáth proved that a finite triple system is obligatory if and only if each of its 2-connected components is obligatory.  In the terminology of hypergraph connectivity, the canonical atoms below are precisely the blocks of the reduced system.  The new content of the classification is therefore an exact identification of the allowable obligatory blocks: besides one triple, they are exactly the private-vertex expansions `J^+` of finite 2-connected simple bipartite graphs `J`.  The canonical block tree then provides the interface for the sharp atom and attachment spectra derived below.

Cite both Komjáth and a general hypergraph block reference such as Bahmanian--Šajna.

This makes the relationship to prior work stronger rather than weaker: Komjáth supplied the reduction, while the completed Erdős 593 result supplies the missing classification of the irreducible pieces and their exact quantitative geometry.

---

## 7. Research implication

Direction 1 should now be understood as

```text
not: invent a block tree or prove block-locality;

but: classify the obligatory blocks completely and determine the exact
     spectra of every quantitative gluing invariant made possible by
     that classification.
```

That is the credible path to strengthening the 593 paper without rediscovering classical connectivity theory.
