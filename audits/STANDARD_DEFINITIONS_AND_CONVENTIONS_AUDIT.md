# Erdős 593: standard definitions and conventions audit

## Scope

This audit checks the manuscript's terminology against standard usage in
hypergraph theory, infinite graph colouring, and the literature on obligatory
triple systems.  It is separate from the theorem-by-theorem proof audit: a proof
can be logically correct while still using a term ambiguously or in a
nonstandard way.

The comparison baseline is:

- Eric Li, *A Resolution of Erdős Problems 593 and 1177*, especially the
  conventions and Levi-graph sections of arXiv:2606.24882v2;
- Christian Reiher, *Obligatory hypergraphs*, arXiv:2403.11223;
- the standard weak/strong hypergraph-colouring distinction used in the modern
  hypergraph-colouring literature;
- the classical Berge-cycle convention: an alternating sequence of distinct
  vertices and distinct hyperedges, equivalently a simple cycle in the
  incidence graph.

## Overall conclusion

The manuscript's mathematical definitions are compatible with standard usage.
No theorem changes meaning under the standard conventions of the field.

Five points should nevertheless be made explicit in the canonical text:

1. `chromatic number` means the **weak vertex chromatic number**;
2. `proper colouring` means **no monochromatic hyperedge**, not strong/rainbow
   colouring;
3. the length of a Berge cycle is the number of hyperedges, hence half the
   length of the corresponding Levi-graph cycle;
4. `connected`, `component`, `order`, and `size` in Section 10 are taken in the
   standard incidence-graph sense and mean Levi-connected, number of vertices,
   and number of hyperedges;
5. `private-vertex expansion` and `one-point amalgamation` are specialised names
   but are defined exactly, so no ambiguity remains once the definitions are
   stated.

## Definition ledger

### Triple system

**Manuscript convention.**  A triple system is a simple \(3\)-uniform
hypergraph \(H=(V(H),E(H))\), with \(E(H)\subseteq [V(H)]^3\).

**Standard status.**  Standard.  In design theory `triple system` can sometimes
be used in more specialised senses, but in the obligatory-system literature it
means a \(3\)-uniform set system.  Writing `simple` and using a set of triples
correctly excludes repeated hyperedges.

**Action.**  None.

### Hypergraph colouring

**Manuscript convention.**  A colouring is proper when no hyperedge is
monochromatic; \(\chi(H)\) is the least cardinal admitting such a colouring.

**Standard status.**  This is the standard **weak** vertex colouring of a
hypergraph.  Hypergraph literature also uses the distinct notion of a strong
colouring, where every hyperedge is rainbow.  The current definition is correct,
but the adjective `weak` should appear once to remove any possible ambiguity.

**Required wording.**

> Throughout, chromatic number means weak vertex chromatic number.  A colouring
> is proper (equivalently, weakly proper) when no hyperedge is monochromatic.

No proof changes.

### Uncountably chromatic

**Manuscript convention.**  \(\chi(H)>\aleph_0\).

**Standard status.**  Standard in infinite graph and hypergraph colouring.

**Action.**  None.

### Embedding and containment

**Manuscript convention.**  An embedding is injective and sends each source
hyperedge to a host hyperedge.  Containment is not required to be induced.

**Standard status.**  Standard for the obligatory-system problem and consistent
with Li's and Reiher's formulations.  This point is load-bearing for restoring
isolated vertices and for downward closure under containment.

**Action.**  Retain the explicit sentence `embeddings are injective and
non-induced`.  Do not replace `embedding` by `induced embedding` or `copy`
without preserving this convention.

### Obligatory finite triple system

**Manuscript convention.**  A finite triple system \(F\) is obligatory when it
embeds in every triple system of uncountable weak chromatic number.

**Standard status.**  Exact standard definition in this literature.

**Action.**  None.

### Linear hypergraph

**Manuscript convention.**  Distinct hyperedges meet in at most one point.

**Standard status.**  Standard.

**Action.**  None.

### Levi graph / incidence graph

**Manuscript convention.**  The bipartite graph with point-nodes on one side,
hyperedge-nodes on the other, and incidence edges \(ve\) exactly when
\(v\in e\).

**Standard status.**  Standard.  `Levi graph` and `incidence graph` are standard
synonyms in this context.

**Recommended wording.**  On first use write `Levi (incidence) graph`; use
`Levi graph` thereafter.

### Bridge

**Manuscript convention.**  An ordinary graph edge whose deletion increases the
number of connected components, applied to incidences of the Levi graph.

**Standard status.**  Standard graph-theoretic definition.

**Action.**  None.  Continue to say `Levi bridge` or `incident bridge` when the
ambient graph might otherwise be unclear.

### Berge cycle

**Manuscript convention.**  Distinct points
\(p_0,\ldots,p_{\ell-1}\) and distinct hyperedges
\(e_0,\ldots,e_{\ell-1}\), with consecutive points contained in the
corresponding hyperedge; equivalently, a simple cycle of length \(2\ell\) in
the Levi graph.

**Standard status.**  Standard classical Berge-cycle definition.  Some sources
start the general definition at length two and some state length at least three.
There is no mathematical conflict here: a Berge 2-cycle consists of two
hyperedges sharing two points, and therefore cannot occur in a linear simple
hypergraph.

**Required clarification.**

> The length of a Berge cycle is \(\ell\), the number of its hyperedges (and of
> its connector points); the corresponding Levi cycle has length \(2\ell\).
> In a linear triple system, necessarily \(\ell\ge3\).

This matters because `every Berge cycle is even` refers to \(\ell\), not to the
Levi-cycle length, which is always even.

### Private-vertex expansion

**Manuscript convention.**  For a graph \(J\), every graph edge \(uv\) becomes
\(\{u,v,p_{uv}\}\), with the vertices \(p_{uv}\) new, pairwise distinct, and
used in no other expanded edge.

**Standard status.**  The construction is standard in this literature.  The
name `private-vertex expansion` is specialised rather than universal, but it is
also used in the current Problem 593 literature and is defined unambiguously.

**Action.**  Retain the full definition on first use.  Do not use the shorter
word `expansion` before that definition.

### One-point amalgamation

**Manuscript convention.**  Take otherwise vertex-disjoint copies of two
hypergraphs, choose one vertex in each, identify those two vertices, and make no
other identification and add no new hyperedge.

**Standard status.**  Standard one-point union / one-vertex sum construction.
The manuscript's definition is exact.

**Recommended wording.**  On first use one may write `one-point amalgamation
(one-vertex sum)`; retain `one-point amalgamation` thereafter.

### Isolated reduction

**Manuscript convention.**  \(F^\circ\) is obtained by deleting all isolated
vertices and retaining every hyperedge.

**Standard status.**  Standard operation; the notation is local but explicitly
defined.

**Action.**  None.

### Subhypergraph and finite trace

**Manuscript convention.**  A finite trace selects host vertices and
hyperedges through an injective non-induced embedding.

**Standard status.**  Compatible with ordinary subhypergraph containment.  It
must not be read as an induced subhypergraph.

**Recommended wording.**  In Theorem 6.3 retain `not necessarily induced` in the
statement.

### Connectedness and components

**Manuscript convention.**  A triple system is connected when its Levi graph is
connected; component counts are Levi-graph component counts.

**Standard status.**  Standard incidence connectivity for hypergraphs.

**Required clarification.**  State this convention before the first parameter
spectrum theorem and use it consistently in `connected component` statements.

### Order and size

**Manuscript convention.**  `order` is \(|V(F)|\), and `size` is
\(|E(F)|\).

**Standard status.**  Standard graph/hypergraph terminology.

**Required clarification.**  Add one sentence at the start of Section 10:

> The order and size of a finite triple system are respectively its numbers of
> vertices and hyperedges.

### Cycle rank / cyclomatic number

**Manuscript convention.**  For a finite graph \(G\),
\(eta(G)=|E(G)|-|V(G)|+c(G)\).

**Standard status.**  Standard cycle rank, also called cyclomatic number or
nullity.

**Recommended wording.**  Write `cycle rank (cyclomatic number)` at first use.

### Proper versus strong colouring in later follow-up work

The Problem 593 manuscript uses only weak colouring.  Separate follow-up work
on strong/rainbow colourings must not retroactively alter the notation here.
If both notions appear in a future combined introduction, reserve:

- `weak/proper`: no monochromatic hyperedge;
- `strong/rainbow`: all vertices of every hyperedge receive distinct colours.

## Copy-ready standardisation edits

The exact replacement text is recorded in
`audits/STANDARD_DEFINITION_LINE_PATCHES.md`.

The edits are terminological only.  They do not alter a hypothesis, conclusion,
proof dependency, theorem number, or Lean endpoint.

## Source comparison summary

The manuscript agrees with the current specialist literature on every
load-bearing convention:

- simple set systems;
- injective non-induced embeddings;
- weak chromatic number;
- linearity;
- Levi graphs;
- Berge cycles;
- private-vertex expansions;
- one-point amalgamations;
- isolated-vertex reduction;
- the definition of obligatoriness.

The strongest source of possible reader confusion is not a mathematical error
but the overloaded word `proper` in hypergraph colouring.  Adding `weak` once
and clarifying Berge-cycle length eliminates that ambiguity.

## Final verdict

**STANDARD-COMPATIBLE.**  No theorem is being proved with a nonstandard hidden
definition.  Apply the five explicit wording edits before the next publication
build.