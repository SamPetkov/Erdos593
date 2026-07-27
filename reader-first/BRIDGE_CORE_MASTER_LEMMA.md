# The bridge-core master lemma

## Purpose

This note isolates the finite graph theorem at the centre of the Problem 593
classification.  It packages the intrinsic-to-constructive implication as one
reusable statement and gives a certificate-producing recognition algorithm.
The result is already implicit in the manuscript proof; the contribution here
is mathematical compression and an executable audit, not a new priority claim.

## Incidence-graph form

Let \(F\) be a finite triple system without isolated points, and let \(L=I(F)\)
be its Levi graph.  The point-nodes and hyperedge-nodes form the two parts of
\(L\), and every hyperedge-node has degree three.

### Bridge-core master lemma

Assume:

1. \(F\) is linear;
2. every hyperedge-node of \(L\) is incident with a bridge;
3. every Berge cycle of \(F\) has even length.

Delete all bridges of \(L\).  Then:

1. every hyperedge-node has residual degree \(0\) or \(2\);
2. every component containing a nonbridge incidence suppresses to a finite
   simple bipartite graph \(J_C\);
3. the hyperedges represented in that component form the private-vertex
   expansion \(J_C^+\);
4. every residual-degree-zero hyperedge is the expansion of a one-edge
   bipartite graph;
5. contracting the bridge-deleted components turns the deleted bridges into a
   forest;
6. after rooting that forest, the expansion pieces admit an order in which each
   new piece meets the preceding union in at most one point.

Consequently \(F\) is obtained from private-vertex expansions of finite
bipartite graphs by finite disjoint unions and one-point amalgamations.

## Proof

Let \(B\) be the set of bridges of \(L\), and consider a hyperedge-node \(e\).
By assumption \(e\) is incident with at least one member of \(B\), so its degree
in \(L-B\) is at most two.  It cannot have residual degree one.  Indeed, a
nonbridge incidence lies on a cycle, and that cycle must enter and leave \(e\)
through two distinct nonbridge incidences.  Thus the residual degree is zero or
two.

### Active components

Let \(C\) be a component of \(L-B\) containing a nonbridge incidence.  Every
hyperedge-node in \(C\) has exactly two point-neighbours in \(C\).  Suppress each
such hyperedge-node to an ordinary graph edge between those two points.  This
produces a finite graph \(J_C\).

The graph is simple.  Two parallel suppressed edges would correspond to two
hyperedges of \(F\) containing the same two points, contradicting linearity.
Every cycle of length \(\ell\) in \(J_C\) lifts to a Berge cycle of length
\(\ell\) in \(F\).  By assumption that length is even, so \(J_C\) is bipartite.

Each hyperedge-node \(e\in C\) has one remaining point-neighbour \(p_e\) across
a bridge.  This point is not a point-node of \(C\): otherwise a path inside
\(C\) from \(p_e\) to \(e\), together with the incidence \(ep_e\), would place
that incidence on a cycle.  The points \(p_e\) are pairwise distinct.  If
\(p_e=p_f\) for two different hyperedge-nodes in \(C\), a path inside \(C\)
from \(e\) to \(f\), completed by the two incidences through their common point,
would place both bridge incidences on a cycle.

Therefore the subsystem represented by \(C\) is exactly \(J_C^+\): the points
inside \(C\) are the graph vertices, the hyperedge-nodes are the graph edges,
and the distinct points \(p_e\) are their private vertices.

### All-bridge hyperedges

If a hyperedge-node has residual degree zero, it is an isolated component of
\(L-B\).  Its one triple is the expansion of a one-edge bipartite graph.  The
choice of which two points are called the graph endpoints is immaterial to
membership in the constructive class.

Thus the hyperedge set of \(F\) is partitioned into expansion pieces.

### Quotient forest

Contract every component of \(L-B\).  Each deleted bridge becomes an edge of a
quotient graph \(T\).  Two different bridges cannot join the same pair of
components, because paths inside the two components together with those
bridges would create a cycle containing them.  Hence \(T\) is simple.

The graph \(T\) is acyclic.  A cycle in \(T\) could be expanded, using paths
inside its contracted components, to a closed walk in \(L\) that crosses each
of the corresponding bridge cuts exactly once.  A closed walk crosses every
cut an even number of times, a contradiction.  Therefore \(T\) is a forest.

### Running intersection

For a point \(p\in V(F)\), let \(X(p)\) be the component of \(L-B\) containing
its point-node.  The expansion pieces containing \(p\) are indexed by active
vertices in the closed star of \(X(p)\) in \(T\): possibly \(X(p)\) itself and
the active neighbours whose bridge incidence ends at \(p\).

Root every component of \(T\) at an active vertex and order active vertices by
nondecreasing depth.  When an active component \(C\) is added, every point it
shares with an earlier piece must be the point associated with the unique
parent edge of \(C\).  Hence all shared points coincide.  The new piece is
therefore attached either by disjoint union or by one-point amalgamation.
Iterating reconstructs all of \(F\).  \(\square\)

## Recognition and certificates

The proof is algorithmic.

1. Verify 3-uniformity and linearity.
2. Construct the Levi graph.
3. Find all bridges by Tarjan's algorithm.
4. Check that every hyperedge-node meets a bridge.
5. Delete the bridges and verify residual degree \(0/2\).
6. Suppress active components and test their core graphs for simplicity and
   bipartiteness.
7. Build the quotient forest and output a rooted active-component order.
8. Record, for each piece, its core edges, private points, and unique attachment
   point to the previous union.

Once the incidence representation is available, every graph operation after
the linearity check is linear in the incidence size.  Linearity itself can also
be checked in expected linear time by hashing point pairs occurring in
hyperedges.

The resulting object is not merely a yes/no answer.  It is a constructive
certificate of membership in the class generated by bipartite expansions,
disjoint unions, and one-point amalgamations.

## Executable audit

`experiments/verify_bridge_core_certificate.py` implements the certificate with
only the Python standard library.  Its deterministic checks include:

- every nonempty graph expansion on at most five labelled core vertices:
  1,094 graphs in total;
- acceptance of all 422 bipartite expansions;
- rejection of all 672 nonbipartite expansions through the odd-Berge-cycle
  diagnosis;
- a private-point-to-core one-point amalgamation of two \(C_4^+\) pieces;
- a disjoint union containing tree-expansion atoms;
- the one-edge all-bridge case;
- separate negative controls for nonlinearity, a missing bridge, and an odd
  Berge cycle.

The script checks the residual-degree dichotomy, simplicity and bipartiteness of
every suppressed core, distinctness of private points, acyclicity of the
quotient, hyperedge partition, point coverage, and running intersection.

## Manuscript use

The main paper can state this lemma before the infinitary arguments.  The reader
then knows the exact finite objects being classified before learning why they
are obligatory or how the avoiding hosts are constructed.

A concise transition is:

> The constructive and intrinsic descriptions are equivalent for a purely
> finite reason: deleting every Levi bridge leaves bipartite graph cores, and
> the deleted bridges record a forest of one-point attachments.

The later one-apex trace theorem has a parallel shape—expansion fibres attached
along a forest—but remains logically distinct.  Stating both in this common
language improves the paper without conflating their proofs.