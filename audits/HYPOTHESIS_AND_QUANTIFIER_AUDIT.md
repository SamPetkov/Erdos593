# Erdős 593: hypothesis and quantifier propagation audit

## Scope

This audit follows every nontrivial hypothesis through the publication proof.
It asks four questions for each theorem family.

1. Is each stated hypothesis actually used?
2. Is any unstated hypothesis imported from an earlier reduction?
3. Does a conclusion survive when isolated vertices, infinite hosts, or
   non-induced embeddings are restored?
4. Does the Lean endpoint quantify over the same objects as the manuscript,
   subject to its documented universe convention?

## Verdict

**PASS with two explicit publication interfaces.**  No proof step relies on an
unavailable finiteness, regularity, inducedness, or cardinal-arithmetic
assumption.  The two interfaces that must be written rather than left implicit
are:

- membership in the constructive class is understood up to isomorphism;
- the public Lean theorem quantifies arbitrary-cardinality hosts inside fixed
  ambient vertex and edge universes.

The direct proofs handle singular uncountable cardinals and non-induced
containment correctly.

---

## 1. Global theorem

### Statement

Theorem A concerns a **finite** triple system `F` and compares:

- obligatoriness;
- membership in the finite constructive class;
- intrinsic conditions on the isolated reduction `F^circ`.

### Propagation

- Finiteness is used in the structural reconstruction, the finite source
  embeddings, and the finite set of isolated vertices restored at the end.
- Host systems are not finite.
- Non-induced containment is used throughout, particularly when extending an
  embedding over isolated source vertices and when passing from
  `K_{N,N}^+` to an arbitrary finite bipartite expansion.
- The intrinsic conditions are imposed on `F^circ`; the constructive condition
  is moved between `F` and `F^circ` by Lemma 1.1.

### Required interface

The class `B` must be isomorphism-closed.  The reverse bridge-block proof
constructs a system isomorphic to `F`, and the Lean `Constructible` predicate
has an explicit isomorphism constructor.

---

## 2. Isolated-vertex reduction

### Hypotheses

- the source `F` is finite;
- the host has uncountable chromatic number;
- containment is non-induced.

### Use

After embedding `F^circ`, the finitely many isolated source vertices are mapped
injectively to unused host vertices.  No condition is imposed on host edges
among these new image points, so induced containment would make the argument
false without additional work.

For constructibility, isolated vertices are restored by disjoint union with a
finite edgeless system.  The reverse induction checks that isolated reduction
commutes with each construction, including all cases in which an amalgamation
point disappears.

**Status: every hypothesis used; no hidden host finiteness.**

---

## 3. Finite deletion

The deleted set is finite.  Fresh colours for its members preserve countability,
so a countably colourable remainder would make the whole host countably
colourable.

The result would also hold for a countable deleted set, but the manuscript does
not need or claim that strengthening.

**Status: stated version sufficient and conservative.**

---

## 4. Bounded-outdegree colouring and compactness

The orientation has a fixed finite outdegree bound `d`.  Every finite subgraph
has at most `d|V|` edges, hence a vertex of degree at most `2d`; this gives
`(2d+1)`-colourability of every finite subgraph.  The de Bruijn--Erdős theorem
is invoked only after a uniform finite palette has been obtained.

No local-finiteness assumption on the infinite graph is used.

**Status: exact hypothesis propagation.**

---

## 5. Closure-chain lemma

### Hypotheses

- `kappa` is uncountable;
- the arity `r` is a positive finite integer;
- every value of `Phi` is finite, with a uniform finite bound.

### Singular-cardinal check

At a successor stage, closing a set of cardinality `mu<kappa` under a
finite-arity, finite-valued operation for `omega` steps has cardinality at most
`max(mu,aleph_0)<kappa`.  At a limit stage indexed below `cf(kappa)`, the union
still has cardinality below `kappa`.  Finitary closure is preserved under an
increasing union.

No regularity of `kappa` is assumed.  This is essential because the rooted
abundance and expansion proofs are stated uniformly at singular uncountable
cardinals.

**Status: singular case covered.**

---

## 6. The `K_{n,n}` subgraph lemma

### Hypotheses

- `n` is a positive integer;
- the graph has uncountable chromatic number.

### Minimality interface

The counterexample is chosen with minimum vertex cardinal `kappa`.  Each layer
`I_i` has cardinality below `kappa` and remains `K_{n,n}`-free, so minimality
makes its induced graph countably chromatic.  The cross-layer orientation uses
closure to bound outdegree by `n-1`.

The graph may have arbitrary cardinality and need not be locally finite.

**Status: minimality is used with all inherited properties stated.**

---

## 7. Rainbow bipartite submatrix

Both `n` and the local multiplicity threshold `t` are positive finite integers.
The colour set is arbitrary.  Only the number of occurrences of one colour at
one vertex is bounded.

The probabilistic proof counts all same-coloured edge pairs.  It does not assume
properness of the initial edge-colouring or a finite colour set.

**Status: no hidden colour-set finiteness.**

---

## 8. Complete bipartite expansion atom

### Hypotheses

- `n>=1` is finite;
- the source expansion is finite;
- a counterexample host has uncountable chromatic number.

### Cardinal-minimal host

The proof chooses a `K_{n,n}^+`-free host with minimum vertex cardinal.  Every
induced subsystem on a smaller layer is still free of the same finite source,
so minimality applies.

### Codegree threshold

The finite threshold `t=3n^2+1` is used only to choose distinct private points
outside the `2n` core vertices and all previously chosen private points.  The
inequality is deliberately stronger than necessary and is uniform over the
selection order.

### Crossing-layer reduction

The closure map is finite-valued exactly on pairs of codegree below `t`.
Consequently a low-codegree crossing triple has at least two vertices in its
highest layer.  No regularity of the host cardinal is used.

**Status: complete, including singular cardinals.**

---

## 9. Downward closure to arbitrary bipartite expansions

A finite bipartite graph `J` embeds as a not-necessarily-induced subgraph of a
large balanced complete bipartite graph.  Since the hypergraph embedding is
non-induced, the corresponding expansion `J^+` embeds in `K_{N,N}^+` even when
the host core has additional graph edges.

Induced containment would invalidate this one-line reduction.

**Status: non-induced convention used essentially.**

---

## 10. Disjoint-union closure

Both obligatory factors are finite.  After embedding the first, its finite
image is deleted; finite deletion preserves uncountable chromatic number, so a
disjoint second copy exists.

Iteration is finite because the constructive derivation has finitely many
factors.

**Status: exact.**

---

## 11. Rooted abundance

### Hypotheses

- `F` is finite and obligatory;
- `|V(F)|>1`;
- the requested number `m` of rooted copies is positive and finite.

### Use

For a bad root, a maximal family of pairwise disjoint off-root sets has at most
`m-1` members.  Their union is a finite hitting set of uniformly bounded size.
A bounded-outdegree dependency graph then partitions all bad roots into
finitely many classes inducing `F`-free systems.

The argument allows isolated vertices in `F`: they simply appear in the finite
off-root sets of a copy.

**Status: singleton source excluded exactly where needed.**

---

## 12. One-point-amalgamation closure

The proof handles a factor consisting only of its selected point separately.
Otherwise `m=|V(F_2)|` rooted copies of `F_1` are enough because the off-root
part of the selected `F_2` copy has exactly `m-1` vertices.

No assumption that the selected points lie in hyperedges is used.

**Status: all degenerate root cases covered.**

---

## 13. Forward intrinsic preservation

- Bipartiteness of the core graph is used only for Berge-cycle parity.
- Private points give genuine Levi bridges.
- A one-point amalgamation is a vertex sum of Levi graphs at a point-node.
  A simple cycle cannot cross that cut vertex, and adding the second factor
  cannot create an alternate route around an existing bridge.

The factors need not be connected.

**Status: exact.**

---

## 14. Reverse bridge-block decomposition

### Essential hypotheses

- finiteness: used for the finite quotient forest and construction order;
- no isolated vertices: used to cover every point by an expansion piece;
- linearity: used to make each suppressed core simple;
- a bridge at every hyperedge-node: used to force residual degree at most two;
- even Berge cycles: used to make every suppressed core bipartite.

### Residual degree

A nonbridge incidence lies on a cycle, so residual degree one at a hyperedge-node
is impossible.  Residual degree is therefore zero or two.

### Isolated points

The no-isolated-points hypothesis is essential here.  It is supplied by applying
the proposition to `F^circ`; Lemma 1.1 restores isolated points afterward.

### Running intersection

The quotient is a forest because every quotient edge comes from an actual
bridge.  Pieces containing a fixed point lie in the closed star of the
bridge-free component containing that point.  Rooted depth therefore forces all
earlier intersections of a new piece to occur at the same parent point.

**Status: every intrinsic hypothesis has a distinct role.**

---

## 15. One-apex lift chromatic lower bound

### Hypothesis

The base graph has chromatic number greater than `aleph_0`.

### Use

Every countable colouring of one slice fails on a graph edge.  Recursion of
length `omega_1` produces uncountably many selected slice colours, so two agree.
The later branch node extends the earlier selected edge letter and yields a
monochromatic lift hyperedge.

The base graph need not be finite, locally finite, or connected.

**Status: exact.**

---

## 16. Finite linear trace theorem

### Essential hypotheses

- finiteness: gives finitely many active base nodes and a finite assembly;
- linearity: ensures at most one trace edge over a fixed base graph edge and
  makes the apex private inside one fibre;
- non-induced trace: only selected image edges are retained.

The theorem does not claim that each `J_s` is bipartite for an arbitrary base
graph `G`.  Bipartiteness is obtained later by choosing a high-odd-girth base or
is irrelevant for the bridge obstruction.

The manuscript uses only the forward consequence of Li's exact bridge-trace
theorem.

**Status: theorem scope is neither too weak nor overstated.**

---

## 17. Avoidance propositions

### Nonlinearity

No linearity hypothesis is assumed on `F`; failure of linearity itself prevents
embedding into the linear Erdős--Rado host.

### Missing bridge

The source is assumed finite and linear.  Lemma 1.1 first removes isolated
vertices.  The selected host edges form a finite linear trace isomorphic to
`F^circ`, so the finite trace theorem applies.

### Odd Berge cycle

Again isolated vertices are removed first.  A Berge cycle has length at most the
number of source edges.  The chosen base graph has no odd ordinary cycle through
that finite bound, while the trace theorem preserves cycle length.

**Status: the three cases are exhaustive and their hypotheses are disjointly
organised.**

---

## 18. Edge-deletion bridge criterion

The finite hypothesis is not needed for the local equivalence but is harmless.
After deleting a hyperedge and retaining all points, all three incidences are
nonbridges exactly when the three edge points lie in one connected component.
For a partition of three points, absence of a singleton block forces one block.

**Status: exact; statement is conservative.**

---

## 19. Bipartite shadow

### Hypotheses

- `F` is finite, obligatory, reduced, and has at least one edge.

The positive-edge assumption ensures each connected component contains an edge
and each ordinary core piece has a nonempty connected graph component.  The
empty reduced system is a separate trivial case and is not needed in the
parameter theorem, where `m>=1`.

One-point sums of connected bipartite cores preserve bipartiteness after
possibly swapping the two colour classes of each new factor.  They preserve
edge count, subtract one vertex per attachment, and introduce no isolated
vertices.

**Status: exact.**

---

## 20. Exact parameter spectrum

### Domain

- `m>=1`;
- `1<=c<=m`;
- systems are reduced.

The bound `c<=m` follows because every connected component of a reduced system
contains at least one hyperedge.

The connected bipartite graph interval uses simple graphs.  The lower endpoint
comes from the bipartite extremal bound `r<=floor(s^2/4)`; the upper endpoint
comes from connectedness, `r>=s-1`.  Every intermediate edge count is obtained
by adding edges to a spanning tree of the balanced complete bipartite graph.

The component-merging inequality is valid for positive component edge counts.
Sharpness uses `c-1` one-edge components and one remaining component with
`m-c+1` edges.

**Status: hypotheses exactly match the construction.**

---

## 21. Fixed-order and cycle-rank corollaries

- The fixed-order inversion assumes `n>=3c`, the minimum order of `c` reduced
  components.
- The missing-order conclusion correctly excludes increments one and three over
  the baseline `3c`.
- The Levi cycle-rank formula uses `3m` incidence edges and `n+m` Levi vertices.
- Every intermediate cycle rank occurs because every intermediate order occurs.

**Status: exact.**

---

## 22. Endpoint rigidity

The source is connected and reduced.  Equality in the bipartite extremal bound
forces a complete balanced or almost-balanced shadow.  For `t>=2` that shadow
has no cut vertex; a genuine one-point sum of two positive-edge connected pieces
has a cut vertex, so the bridge-block decomposition has one piece.  The cases
`t=1` are checked separately.

**Status: all degenerate cases addressed.**

---

## 23. Lean quantifiers

The public endpoints assume finite source vertex and edge-index types.  Their
hosts are arbitrary in cardinality within fixed ambient vertex and edge
universes.  The `DecidableEq` host-vertex parameter is supplied classically and
is not a finiteness assumption.

The manuscript's exact endpoint display and ambient-universe qualification are
therefore correct.  The Section 10 corollaries remain outside the current Lean
endpoint surface.

## Final conclusion

No theorem loses or acquires a mathematical hypothesis as it passes through the
proof.  The only strict surface repair is to state isomorphism closure of the
constructive class explicitly.  All other recommended changes make already
valid cardinal, containment, or formalisation interfaces visible to the reader.
