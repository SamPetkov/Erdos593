# Canonical atom normal form for obligatory triple systems

## Purpose

The constructive formulation of Erdős Problem 593 uses private-vertex
expansions of arbitrary finite bipartite graphs, finite disjoint unions, and
one-point amalgamations. The arbitrary bipartite generators are redundant.
The intrinsic Levi-graph characterization gives a canonical and minimal family
of edge-bearing generators:

- one triple, equivalently \(K_2^+\); and
- \(J^+\) for a finite 2-connected bipartite graph \(J\).

Every reduced obligatory triple system has a canonical forest decomposition
into these atoms. This sharpens the bridge-core discussion, identifies the
one-point-indecomposable obligatory systems, and provides one common interface
for the finite bridge decomposition and the finite traces of the one-apex lift.

The result is a structural corollary of the classification and standard
block-cut theory. Komjáth had already reduced obligatoriness to 2-connected
components, and Li explicitly compares his selected-incidence decomposition
with that block reduction. No priority claim is made for the block-theoretic
principle. The useful point here is the exact atom statement, its canonicity,
and its direct integration into the present proof.

## Definitions

Let \(F\) be a finite triple system and let \(L=I(F)\) be its Levi graph. A
**cyclic block** of \(L\) is a maximal 2-connected subgraph containing a cycle.
As usual, bridges form the remaining one-edge blocks.

An edge-bearing triple system is **one-point indecomposable** if it is connected
and cannot be expressed as a one-point amalgamation of two triple systems that
both contain a hyperedge.

An **atomic expansion** is either a single triple or a private-vertex expansion
\(J^+\), where \(J\) is a finite 2-connected bipartite graph.

## The canonical atom theorem

### Theorem

Let \(F\) be a finite triple system without isolated points. Assume that

1. \(F\) is linear;
2. every hyperedge-node of \(I(F)\) is incident with a bridge; and
3. every Berge cycle of \(F\) has even length.

Then the hyperedges of \(F\) admit a canonical partition into atomic
expansions with the following properties.

1. For every cyclic block \(C\) of \(I(F)\), each hyperedge-node in \(C\) has
   degree two in \(C\). Suppressing these hyperedge-nodes gives a finite
   2-connected simple bipartite graph \(J_C\).
2. The source hyperedges represented in \(C\), together with their third
   points, form a subsystem isomorphic to \(J_C^+\).
3. Every hyperedge-node lying in no cyclic block has all three incidences as
   bridges and contributes one single-triple atom.
4. Two distinct atoms meet in at most one point. The bipartite incidence graph
   between atoms and points lying in at least two atoms is a forest.
5. The atom partition, each nontrivial core \(J_C\) up to graph isomorphism,
   and the atom-point incidence forest are determined by \(F\). The only
   harmless choice is the presentation of a single triple as \(K_2^+\).

Conversely, every forest assembly of atomic expansions by disjoint unions and
one-point amalgamations is linear, has an incident Levi bridge at every
hyperedge-node, and has only even Berge cycles.

### Proof

Let \(B\) be the set of bridges of \(L=I(F)\). A hyperedge-node has degree
three in \(L\) and is incident with at least one member of \(B\). Its degree in
\(L-B\) is therefore at most two. Residual degree one is impossible: every
nonbridge edge lies on a cycle, and a cycle enters and leaves a hyperedge-node
through two distinct nonbridge incidences. Hence every hyperedge-node has
residual degree zero or two.

Let \(C\) be a cyclic block of \(L\). Every hyperedge-node in \(C\) has degree
two in \(C\). Suppress every such node. The resulting graph \(J_C\) has the
point-nodes of \(C\) as vertices. It has no loops because the three points of a
hyperedge are distinct, and it has no parallel edges because \(F\) is linear.
Subdivision and suppression preserve 2-connectivity, so \(J_C\) is
2-connected. Cycles of \(J_C\) correspond exactly to Berge cycles of \(F\)
contained in \(C\). Every such cycle has even length; hence \(J_C\) is
bipartite.

For a hyperedge-node \(e\in C\), the third incidence is a bridge. If its point
\(p_e\) lay in \(C\), a path in \(C\) from \(p_e\) to \(e\), together with
that incidence, would form a cycle. Thus \(p_e\notin C\). The points \(p_e\)
are distinct as \(e\) varies in \(C\): if \(p_e=p_f\), a path in \(C\) from
\(e\) to \(f\), completed through the common point, would put both bridge
incidences on a cycle. The hyperedges represented in \(C\) therefore form
exactly the private-vertex expansion \(J_C^+\).

A hyperedge-node outside every cyclic block cannot have residual degree two,
for its two nonbridge incidences would lie on a cycle and hence in a cyclic
block. It therefore has residual degree zero and forms a single-triple atom.
This proves that the atoms partition the hyperedges.

Distinct atoms cannot meet in two points. Otherwise, Levi paths inside the two
atoms between the shared points would contain a Levi cycle using hyperedges
from both atoms. Every Levi cycle belongs to one cyclic block, contradicting
the construction of the atoms. The same argument proves that the atom-point
incidence graph is acyclic: a cycle in that graph expands to a closed Levi walk
using at least two atoms, and after deleting spurs this walk contains a Levi
cycle crossing atom boundaries. Thus the incidence graph is a forest.

Cyclic blocks, their hyperedge-node sets, and the block-cut forest of a graph
are canonical. Suppressing the degree-two hyperedge-nodes determines each
core \(J_C\) up to isomorphism. The singleton hyperedges are also canonical;
only the choice of two core points in their representation as \(K_2^+\) is not.
This proves the forward statement.

Conversely, each atomic expansion is linear. Its private incidence at every
hyperedge-node is a bridge, and its Berge cycles are the cycles of a bipartite
core. In a forest assembly, every Berge cycle lies in one atom and every
bridge of an atom remains a bridge. Linearity is also preserved because two
pieces meet in at most one point. The three intrinsic conditions follow.
\(\square\)

## Minimal generating family

### Corollary

Let \(\mathcal B\) be the isomorphism-closed class from the Problem 593
classification. Then \(\mathcal B\) is the smallest class containing

- every finite edgeless triple system;
- one triple; and
- \(J^+\) for every finite 2-connected bipartite graph \(J\),

and closed under finite disjoint unions and one-point amalgamations.

### Proof

Every listed atom is one of the original bipartite-expansion generators, so the
new closure is contained in \(\mathcal B\). Conversely, the canonical atom
theorem decomposes every reduced member of \(\mathcal B\) into the listed
atoms. Isolated points are restored by adjoining an edgeless system.
\(\square\)

This formulation is strictly smaller than the original generating family:
expansions of disconnected graphs split as disjoint unions, expansions of
graphs with a cut vertex split as one-point amalgamations, and bridge edges
produce single-triple atoms.

## One-point-indecomposable obligatory systems

### Corollary

A finite reduced connected obligatory triple system with at least one
hyperedge is one-point indecomposable if and only if it is isomorphic to

- one triple; or
- \(J^+\) for a finite 2-connected bipartite graph \(J\).

### Proof

If the canonical atom forest has at least two atom nodes, a leaf atom separates
from the remaining atoms at its unique shared point, giving a nontrivial
one-point amalgamation. An indecomposable system therefore consists of one
atom.

It remains to check that the listed atoms are indecomposable. A single triple
is immediate. Let \(J\) be 2-connected and suppose that \(J^+\) decomposes at
a point \(p\). In the Levi graph, deleting \(p\) would separate the
hyperedge-nodes into two nonempty sets. If \(p\) is private, its deletion only
removes a leaf. If \(p\) is a core vertex, the graph \(J-p\) is connected;
every edge-node formerly incident with \(p\) remains joined through its other
endpoint to the subdivision of \(J-p\). Thus all hyperedge-nodes remain in one
component, a contradiction.
\(\square\)

## A local rooted-theta reformulation

The bridge condition also has a useful local form. Let a hyperedge-node \(e\)
have point-neighbours \(x,y,z\). The following are equivalent.

1. None of \(ex,ey,ez\) is a bridge.
2. The vertices \(x,y,z\) lie in one component of \(I(F)-e\).
3. The Levi graph contains a theta subgraph with branch vertex \(e\), whose
   three internally disjoint branches begin with \(ex,ey,ez\).

For \((1)\Rightarrow(2)\), a component of \(I(F)-e\) containing exactly one of
\(x,y,z\) would make the corresponding incidence a bridge. A partition of
three objects with no singleton block has one block. For
\((2)\Rightarrow(3)\), take a minimal tree in \(I(F)-e\) connecting
\(x,y,z\) and add the three incidences at \(e\). The converse is immediate
because every branch edge of a theta lies on a cycle.

Consequently, the intrinsic bridge condition can be read as exclusion of a
rooted theta using all three incidences of a hyperedge-node. This is a useful
figure-level explanation of the missing-bridge obstruction.

## Manuscript simplification

The theorem can replace rather than supplement the current structural
machinery.

1. State the canonical atom theorem immediately after the finite bridge-core
   argument.
2. Define the constructive class using the minimal atomic generators in a
   corollary, while retaining the original formulation in Theorem A for
   comparison with the literature.
3. Use the atom-point forest as the single assembly interface in both the
   bridge decomposition and the finite-trace theorem.
4. Delete the duplicated running-intersection claims after the forest-assembly
   lemma is integrated.
5. Add one diagram showing a cyclic Levi block, its suppressed bipartite core,
   the third private incidences, and the atom-point forest.

The result should not be added as a long independent section. In the final
paper it should occupy one theorem, two short corollaries, and one figure.

## Exact finite audit

`experiments/verify_canonical_atom_normal_form.py` uses only the Python standard
library. It checks:

- every nonempty simple labelled graph on at most six vertices: 33,861 graphs;
- all 5,598 bipartite graphs in that range;
- all 28,263 nonbipartite controls;
- all 4,935 connected bipartite graphs;
- the exact indecomposability criterion in all 523 irreducible cases; and
- 2,000 deterministic forest assemblies using single triples, \(C_4^+\),
  \(C_6^+\), and \(K_{2,3}^+\), with attachments allowed at core and private
  points.

For every graph expansion, the recovered hyperedge partition agrees exactly
with the biconnected edge-block partition of the source graph. For every
forest assembly, the verifier recovers the original irreducible atom partition.

## Literature boundary

Komjáth proved that obligatoriness reduces to 2-connected components in
*Some remarks on obligatory subsystems of uncountably chromatic triple
systems*, Combinatorica 21 (2001), 233--238. Li records that result and
explains that his selected-incidence decomposition is finer because it
identifies the expansion pieces and quotient forest; see Section 1.2 of
arXiv:2606.24882. The normal form above is presented as a transparent
corollary of those structural ideas and the intrinsic classification, not as an
absolute novelty claim.
