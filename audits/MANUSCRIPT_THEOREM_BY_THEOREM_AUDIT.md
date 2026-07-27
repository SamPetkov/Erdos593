# Erdős Problem 593: theorem-by-theorem hostile manuscript audit

## Scope

This audit targets the canonical publication manuscript

```text
erdos593_obligatory_triple_systems.tex
```

at the head of `agent/593-bridge-core-certificate`, i.e. the stack containing:

- the publication branch with the finite parameter spectrum;
- the reader-first exposition proposal;
- the isolated bridge-core master lemma and finite certificate checker.

The audit checks the ordinary mathematical proof, not merely the generated PDF
or the final theorem statement.  Each named theorem, lemma, proposition,
corollary, and definition is checked for:

1. exact hypotheses and quantifiers;
2. validity of every load-bearing implication in its proof;
3. compatibility with later uses;
4. dependence on imported results;
5. relation to the public Lean endpoints or exact finite checkers;
6. wording that could overstate what is formally or computationally verified.

The finite-parameter formulas are additionally checked by exhaustive exact
integer programs.  The bridge-block theorem is cross-checked by the independent
certificate generator introduced in PR #31.

## Status terminology

- **PASS:** no mathematical defect found.
- **PASS — edit recommended:** the proof is correct, but one sentence should be
  added or replaced to make a hidden implication explicit.
- **IMPORTED — interface checked:** the manuscript uses an external theorem;
  its stated interface and parameter substitution were checked, but the
  original external proof is not reproved here.
- **FORMAL:** a public Lean endpoint directly covers the result or its final
  classification consequence.
- **ALTERNATE FORMAL ROUTE:** Lean proves the required conclusion through a
  related but not line-by-line identical argument.
- **NOT YET FORMALISED:** conventional proof and exact finite checks exist, but
  there is no claimed Lean endpoint for the displayed corollary.

## Executive result

### Mathematical status

No theorem-level blocker was found in the finite classification or in the new
finite parameter spectrum.  The proof of Theorem A is logically complete:

```text
constructible -> obligatory,
constructible <-> intrinsic,
not intrinsic -> not obligatory.
```

The finite trace theorem, the bridge-block reconstruction, and all three
avoidance hosts survive a hostile step-by-step check.

### Required editorial corrections

The audit found no false theorem, but it found nine places where the submitted
text should be sharpened before publication.

1. **Abstract:** replace “deletes selected Levi-graph bridges” by “deletes all
   Levi-graph bridges”; Proposition 5.2 uses the all-bridges decomposition.
2. **Theorem A:** state explicitly that item (ii), written for `F`, is converted
   to the reduced system by Lemma 1.1 before Proposition 5.2 is applied.
3. **Closure-chain lemma:** define the successor stage as
   `M_{i+1}=cl_Phi(M_i union A_i)` and mention separately that a finite seed may
   become countable but remains below every uncountable `kappa`.
4. **Lemma 2.1:** say explicitly that every `G[I_i]` remains `K_{n,n}`-free, so
   minimality of `kappa` applies.
5. **Proposition 5.2:** explicitly rule out loops in the suppressed graph
   `J_C`; the two surviving point-neighbours of a triple are distinct.
6. **Corollary 6.4:** add the one-line vertex-sum argument showing that a bridge
   remains a bridge after a one-point amalgamation.
7. **Theorem 10.3:** replace “after squaring ... `(a-1)(b-1)>=0`” by the direct
   calculation
   ```text
   (sqrt(a)+sqrt(b)-1)^2-(a+b-1)
     = 2(sqrt(a)-1)(sqrt(b)-1) >= 0.
   ```
   The existing inequality is true; the proposed line makes the algebra
   literally match the stated single squaring.
8. **Corollary 10.4:** add the missing necessity sentence
   ```text
   q(m-c+1)+2(c-1) >= q(m),
   ```
   so no disconnected reduced system lies below the connected lower endpoint.
9. **Formalisation scope:** state explicitly that the written odd-cycle proof
   invokes the classical Erdős--Hajnal graph, whereas Lean uses an explicit
   shift-graph/high-odd-girth realisation.  The classification is formalised;
   the Section 10 numerical spectrum is not presently advertised as a Lean
   endpoint.

These are precision and exposition corrections, not repairs to a false main
argument.

---

# I. Main classification and reductions

## Theorem A — exact characterisation

**Statement.**  For every finite triple system `F`, obligatoriness,
constructibility in `B`, and the reduced intrinsic condition are equivalent.

**Audit.**

1. Item (i) uses injective non-induced containment, fixed in the preliminaries.
2. Item (ii) is stated for `F`, not `F^circ`; this is legitimate because Lemma
   1.1 proves `F in B <-> F^circ in B`.
3. Item (iii) is correctly stated on `F^circ`, because isolated vertices do not
   affect the Levi bridge or Berge-cycle structure relevant to the theorem.
4. Sections 3--4 prove `(ii)->(i)`.
5. Proposition 5.1 and Proposition 5.2 prove `(ii)<->(iii)`.
6. Propositions 8.1--8.3 prove `not(iii)->not(i)`; contraposition gives
   `(i)->(iii)`, and Proposition 5.2 then gives `(i)->(ii)`.
7. No independence assumption between the three avoidance hosts is used.

**Verdict:** **PASS — edit recommended.**  Add one sentence at the final
assembly explicitly invoking Lemma 1.1 to move between `F` and `F^circ`.

**Formal status:** **FORMAL.**  The public endpoints are

```text
isObligatory_iff_isolatedReduction_intrinsic
isObligatory_iff_constructible_isolatedReduction.
```

## Lemma 1.1 — isolated-vertex reduction

**Audit.**

1. Every uncountably chromatic host is infinite, so finitely many isolated
   source vertices can be mapped to unused host vertices.
2. Non-induced containment makes additional host edges irrelevant.
3. The converse follows by restriction to a subhypergraph.
4. For constructibility, adjoining isolated vertices is a disjoint union with
   an edgeless generator.
5. Structural induction is correct for graph expansions, edgeless systems,
   disjoint unions, and all three cases of a one-point amalgamation:
   both roots nonisolated, exactly one nonisolated, or both isolated.

**Verdict:** **PASS.**

**Formal status:** **FORMAL.**

## Lemma 1.2 — finite deletion

**Audit.**  If `H-S` had a countable proper colouring, assigning finitely many
fresh colours to the finite set `S` would give a countable colouring of `H`.
No regularity assumption on the host cardinal is needed.

**Verdict:** **PASS.**

## Lemma 1.3 — two colouring facts

### Part (1): finite union of countably chromatic edge sets

The product of finitely many countable colourings is countable and is proper on
every edge because that edge belongs to at least one constituent edge set.

### Part (2): bounded-outdegree orientation

1. Every finite subgraph has at most `d|V|` edges when edges are counted by
   their oriented tails.
2. Every nonempty finite subgraph therefore has a vertex of degree at most
   `2d`, so it is `(2d+1)`-colourable by greedy deletion.
3. The de Bruijn--Erdős compactness theorem transfers this uniform finite bound
   to the full graph.

**Verdict:** **PASS.**

**External interface:** de Bruijn--Erdős is used in exactly its standard finite
compactness form.

## Lemma 1.4 — closure-chain lemma

**Audit.**

1. A cofinal family `(A_i)_{i<cf(kappa)}` with each `|A_i|<kappa` exists by the
   definition of cofinality.
2. Closing one set under a finite-arity, finite-valued map requires only omega
   iterations.
3. If the seed has infinite cardinality `mu<kappa`, each closure stage has size
   at most `mu`; a finite seed may grow to countable size, still below the
   uncountable `kappa`.
4. At a limit stage below `cf(kappa)`, the union has size below `kappa`.
5. A finite subset of a continuous increasing union lies in one earlier stage,
   so closure is preserved at limits.

**Verdict:** **PASS — edit recommended.**  The successor-stage definition and
the finite-seed cardinal case should be written explicitly.

---

# II. Positive expansion atoms

## Lemma 2.1 — uncountable chromatic number forces `K_{n,n}`

**Audit.**

1. Choose a counterexample of least vertex cardinal `kappa`.
2. `K_{n,n}`-freeness gives `|N(A)|<n` for every `n`-set `A`.
3. Apply the closure-chain lemma to `A -> N(A)`.
4. Every layer `G[I_i]` is still `K_{n,n}`-free and has cardinality below
   `kappa`, so minimality makes it countably chromatic.
5. Orient cross-layer edges from later to earlier layers.
6. A vertex cannot have `n` earlier neighbours, since closure would place the
   vertex in the earlier model.
7. Lemma 1.3 gives a finite colouring of the cross-layer graph.
8. Combining it with the reused countable layer palette gives a countable
   colouring of all of `G`, contradiction.

**Verdict:** **PASS — edit recommended.**  Step 4 should be stated rather than
left implicit.

## Lemma 3.1 — rainbow bipartite submatrices

**Audit.**

1. For a fixed colour `gamma`, the local multiplicity hypothesis gives
   `m_gamma <= (t-1)q`.
2. The number of same-coloured edge pairs sharing a vertex is at most
   `(t-1)q^2`; this follows by summing
   `binom(d_{v,gamma},2) <= d_{v,gamma}(t-1)/2` over all vertices and colours.
3. The total number of same-coloured pairs is at most
   `(t-1)q^3/2`.
4. The exact selection probability for a pair sharing one endpoint is
   `(n/q)(n)_2/(q)_2`; for disjoint edges it is `((n)_2/(q)_2)^2`.
5. The displayed expectation bound follows, with harmless overcounting because
   the total-pair bound is also used for the disjoint class.
6. For sufficiently large `q`, `E[Z]<1`; since `Z` is nonnegative and
   integer-valued, some choice has `Z=0`.

**Verdict:** **PASS.**

## Proposition 3.2 — `K_{n,n}^+` is obligatory

This is one of the two longest load-bearing proofs.

### Claim that the high-codegree graph is countably chromatic

1. If the graph `R` were uncountably chromatic, Lemma 2.1 would supply a
   `K_{n,n}` core.
2. Each core edge has at least `t=3n^2+1` possible third vertices.
3. At each greedy step fewer than `2n+n^2<t` vertices are forbidden, so the
   private vertices can be chosen outside the core and pairwise distinct.
4. This would create a non-induced copy of `K_{n,n}^+`, contradiction.

### High-/low-codegree decomposition

5. A proper colouring of `R` properly colours every triple in `E_1` because
   such a triple contains an `R`-edge.
6. Lemma 1.3 therefore forces `E_2` to remain uncountably chromatic.
7. The closure map on low-codegree pairs is finite-valued.
8. An `E_2`-edge has at least two points in its highest layer; otherwise its
   unique highest point is pulled into the earlier closed set.
9. Internal highest-layer edges form a countably chromatic subsystem by the
   minimality of `kappa`.
10. The remaining crossing subsystem is uncountably chromatic.

### Auxiliary graph and rainbow extraction

11. If every auxiliary graph `G_i` were countably chromatic, reused layer
    colourings would colour the two top-layer vertices of every crossing triple
    differently, contradiction.
12. A `K_{q,q}` in one uncountably chromatic `G_i` is edge-coloured by the
    earlier witness `beta_{xy}`.
13. This colouring is locally `(t-1)`-bounded; `t` repeats at one endpoint would
    make a pair high-codegree and put the triple in `E_1`.
14. Lemma 3.1 supplies an `n by n` rainbow submatrix.
15. Its labels lie in the earlier set while the core lies in the new layer, so
    the labels are distinct from all core vertices and from one another.
16. The corresponding triples form `K_{n,n}^+`, contradiction.

**Verdict:** **PASS.**

**Formal status:** **FORMAL** at the classification level; the repository also
contains focused positive-atom modules.

## Corollary 3.3 — every finite bipartite expansion is obligatory

Embed the finite bipartite graph in a sufficiently large complete bipartite
graph.  Non-induced containment is downward closed, so Proposition 3.2 applies.

**Verdict:** **PASS.**

**External comparison:** Reiher's Theorem 1.2 independently supplies the same
positive atom.

---

# III. Closure operations

## Lemma 4.1 — disjoint-union closure

Find the first obligatory factor, delete its finite image, apply Lemma 1.2, and
find the second.  Iteration proves the finite case.

**Verdict:** **PASS.**

## Definition 4.2 — rooted abundance

The definition is coherent for a finite rooted system with more than one
vertex.  Off-root sets exclude the root by injectivity, a fact used in Lemma
4.3 to keep the auxiliary graph loopless.

**Verdict:** **PASS.**

## Lemma 4.3 — rooted-abundance lemma

**Audit.**

1. For a bad root `v`, the family of off-root sets has matching number at most
   `m-1`.
2. A maximal disjoint subfamily has at most `m-1` members, and its union `S_v`
   meets every rooted copy.
3. The dependency graph on bad roots has an orientation of outdegree at most
   `D=(m-1)(|V(F)|-1)`.
4. Lemma 1.3 gives finitely many independent colour classes.
5. In one such class `A`, no rooted copy of `F` can occur: its off-root set
   would meet `S_v` inside `A`, contradicting independence in the dependency
   graph.
6. Because `F` is obligatory, each `F`-free class is countably chromatic.
7. The bad-root subsystem is countably chromatic; if the good-root subsystem
   were also countably chromatic, so would be the host.

**Verdict:** **PASS.**

## Proposition 4.4 — one-point amalgamation closure

**Audit.**

1. Trivial one-vertex factors are harmless.
2. Put `m=|V(F_2)|` and apply rooted abundance to `(F_1,r_1)`.
3. A copy of `F_2` is found inside the uncountably chromatic abundance set.
4. Its off-root image contains exactly `m-1` vertices.
5. Among `m` pairwise disjoint off-root copies of `F_1`, one avoids that finite
   set.
6. Their union is exactly the requested one-point amalgamation.

**Verdict:** **PASS.**

**Formal status:** **FORMAL.**

---

# IV. Finite intrinsic decomposition

## Proposition 5.1 — preservation of the intrinsic conditions

**Audit.**

1. In `J^+`, private-point incidences are bridges.
2. A Berge cycle cannot use a degree-one private point and is exactly a graph
   cycle in `J`; bipartiteness gives even length.
3. Disjoint unions preserve all three conditions componentwise.
4. A one-point amalgamation is a vertex-sum of Levi graphs at a point-node.
5. Every simple cycle of a vertex-sum lies in one factor.
6. A bridge in either factor remains a bridge after the vertex-sum.

**Verdict:** **PASS.**

## Proposition 5.2 — bridge-block decomposition

This is the finite structural core of the paper.

### Residual degree

1. Every hyperedge-node has degree three and at least one incident bridge.
2. A nonbridge incidence lies on a cycle, which must leave the hyperedge-node
   through a second nonbridge incidence.
3. The residual degree is therefore `0` or `2`, never `1`.

### Active bridge-free components

4. Suppressing a residual-degree-two hyperedge-node produces an ordinary edge
   between two distinct point-nodes.
5. Loops are impossible because a triple contains three distinct points.
6. Parallel suppressed edges would mean two triples share two points, violating
   linearity.
7. Every graph cycle lifts to a Berge cycle of the same length, so the
   suppressed graph is bipartite.
8. The third point `p_e` of each triple lies outside the bridge-free component;
   otherwise its bridge incidence lies on a cycle.
9. Distinct triples in one active component have distinct third points;
   otherwise a path inside the component plus two bridge incidences gives a
   cycle containing those bridges.
10. Hence the active piece is exactly a private-vertex expansion of the
    suppressed bipartite graph.

### All-bridge atoms and coverage

11. A hyperedge-node of residual degree zero gives a one-edge expansion atom.
12. Piece edge sets partition `E(F)`.
13. Piece vertex sets cover `V(F)` because `F` has no isolated points.

### Quotient forest

14. Contracting the bridge-free components turns the original bridges into a
    simple quotient graph: two parallel quotient edges would place the bridges
    on a cycle.
15. The quotient is acyclic because a quotient cycle would yield a closed walk
    traversing each bridge once, impossible across a bridge cut.

### Running intersection

16. Every point `p` belongs only to pieces indexed in the closed star of its
    bridge-free component `X(p)`.
17. Root each quotient-tree component at an active vertex and order active
    vertices by depth.
18. An active piece can share an earlier point only through its unique parent
    quotient edge.
19. All earlier shared points therefore coincide with the point endpoint of
    that parent edge.
20. Sequential disjoint unions and one-point amalgamations reconstruct `F`
    without unintended identifications.

**Verdict:** **PASS — edit recommended.**  Add the explicit no-loop sentence in
Step 5.

**Formal status:** **FORMAL.**

**Independent finite check:** PR #31 verifies the residual-degree, suppressed
core, private-point, quotient-forest, and running-intersection certificates on
all graph expansions through five labelled core vertices and on separate
negative controls.

---

# V. One-apex lift and finite traces

## Definition 6.1 — one-apex lift

**Audit.**

1. `t` extends `s^frown a`, hence its sequence node differs from `s`.
2. The base endpoints are distinct because `a` is a graph edge.
3. The apex is therefore the unique point with a different sequence node.
4. The repeated sequence node recovers `s`; the next coordinate of `t` recovers
   `a`; hence each lift edge has unique construction data up to swapping the
   two base endpoints.

**Verdict:** **PASS.**

## Lemma 6.2 — chromatic lower bound for the lift

**Audit.**

1. A hypothetical countable colouring restricts on each fibre to a countable
   non-proper colouring of `G`.
2. Choose a monochromatic graph edge at every sequence node.
3. Recursively append those chosen edges along a branch of length `omega_1`;
   limit unions remain countable sequences and therefore belong to `T`.
4. Two stages receive the same natural-number colour.
5. The later sequence extends the earlier sequence followed by its selected
   edge, so the earlier base and later apex form a lift edge.
6. That edge is monochromatic, contradiction.

**Verdict:** **PASS.**

**Formal status:** **FORMAL.**

## Theorem 6.3 — finite linear trace decomposition

This is the principal negative-direction theorem in the written manuscript.

### One fibre is one expansion

1. Every host edge has a unique base node.
2. Linearity permits at most one trace edge for a fixed base graph edge.
3. Distinct base graph edges cannot have the same apex, because the first
   coordinate after the base node would have to equal two different graph
   edges.
4. Core points and apices are disjoint by sequence length.
5. The fibre is therefore isomorphic to `J_s^+` for a finite subgraph `J_s` of
   `G`.

### Fibre intersections

6. If a point belongs to fibres at `s` and `u`, both `s` and `u` are prefixes
   of its sequence and hence comparable.
7. For `s` properly below `u`, every common point is an apex of the unique base
   edge determined by the first coordinate after `s`.
8. Hence two fibres meet in at most one point.

### Support-incidence forest

9. In a hypothetical cycle, choose a base node of minimum ordinal length.
10. Its two neighbouring base nodes are proper descendants in two different
    immediate branches, because the intervening shared points are distinct
    apices of distinct base edges.
11. Along the remaining path, consecutive base nodes are comparable and cannot
    change their first coordinate after the minimum node.
12. The path cannot reach the other immediate branch, contradiction.

### Running intersection and assembly

13. Root each support-incidence tree at a base node.
14. An earlier fibre meeting a nonroot fibre must do so through the unique
    parent point; an apparent later-side shared point would force the other base
    node to lie deeper.
15. Each fibre therefore meets the previous union in at most one point.
16. Disjoint unions and one-point amalgamations assemble all fibres and the
    isolated trace points.

**Verdict:** **PASS.**

**Important scope clarification:** the finite graphs `J_s` need not be
bipartite for arbitrary `G`.  The theorem is used only for the bridge and cycle
restrictions of Corollary 6.4; it does not assert that every trace belongs to
`B` unless the relevant base subgraphs are bipartite.

**Formal status:** **FORMAL** at the global trace-decomposition level.  The Lean
odd-cycle endpoint also contains a closed-walk formulation; this is a related
formal route, not a defect in the ordinary theorem above.

## Corollary 6.4 — restrictions on finite linear traces

1. Each factor `J_s^+` has a private-point bridge at every hyperedge-node.
2. A one-point amalgamation is a vertex-sum, so attaching a new factor at one
   vertex cannot create an alternate path around an existing bridge.
3. A simple Levi cycle cannot cross a one-point cut.
4. A Berge cycle in `J_s^+` is exactly an ordinary cycle of the same length in
   `J_s`, hence in `G`.

**Verdict:** **PASS — edit recommended.**  Step 2 should be written explicitly.

---

# VI. Imported odd-girth input and avoidance hosts

## Theorem 7.1 — Erdős--Hajnal high odd girth

The source theorem excludes `C_{2j+1}` for `0<j<i`.  Choosing `i` with
`2i-1>=m` excludes every odd cycle of length at most `m`.

**Verdict:** **IMPORTED — interface checked.**

The manuscript uses only existence of an uncountably chromatic graph.  The
stronger exact-cardinal formulation is unnecessary here.

## Proposition 8.1 — nonlinear obstruction

1. Vertices of the host are graph edges of `K_kappa`; hyperedges are graph
   triangles.
2. Two different graph triangles cannot share two graph edges, so the triple
   system is linear.
3. A countable colouring of these vertices is a countable edge-colouring of
   `K_kappa`.
4. The Erdős--Rado relation
   `(2^aleph0)^+ -> (aleph1)^2_aleph0` gives a monochromatic uncountable set and
   therefore a monochromatic triangle.
5. A nonlinear finite source cannot inject into a linear host.

**Verdict:** **PASS.**

**External interface:** the displayed partition relation is the `r=1`,
`kappa=aleph0` instance of the Erdős--Rado theorem.

**Formal status:** **FORMAL.**

## Proposition 8.2 — missing-bridge obstruction

1. Isolated vertices are removed by Lemma 1.1.
2. `K_{omega_1}` is uncountably chromatic, so its lift is uncountably chromatic
   by Lemma 6.2.
3. An injective embedding of a linear source selects a finite linear trace
   isomorphic to that source; intersections are preserved exactly by
   injectivity.
4. Corollary 6.4 forces a bridge at every hyperedge-node of that trace.
5. This contradicts the chosen bridge-free hyperedge-node.

**Verdict:** **PASS.**

**Formal status:** **FORMAL.**

## Proposition 8.3 — odd Berge cycle obstruction

1. Remove isolated points and put `m=|E(F)|`.
2. Choose an uncountably chromatic graph with no odd cycle of length at most
   `m`.
3. Its lift is uncountably chromatic.
4. An embedding of the linear source selects a finite linear trace.
5. Corollary 6.4 maps the given Berge cycle to an ordinary graph cycle of the
   same length.
6. A Berge cycle uses distinct hyperedges, so its length is at most `m`.
7. The resulting odd graph cycle contradicts the base graph choice.

**Verdict:** **PASS.**

**Formal status:** **ALTERNATE FORMAL ROUTE.**  The written proof invokes the
classical Erdős--Hajnal graph.  The Lean project uses an explicit shift-graph
high-odd-girth host and a closed-walk transfer sufficient for the same final
classification endpoint.

---

# VII. Finite parameter consequences

## Proposition 10.1 — edge-deletion form of the bridge condition

**Audit.**

1. The incidence `xe` is nonbridging exactly when an alternate path from `e` to
   `x` remains after deleting that incidence.
2. Such a path must leave `e` through `y` or `z`, then lie in the Levi graph of
   `F-e`.
3. Hence `xe` is nonbridging exactly when `x` is connected in `F-e` to at least
   one of the other two points.
4. All three incidences are nonbridging exactly when the connectivity partition
   of `{x,y,z}` has no singleton block.
5. A partition of three points with no singleton has one block.
6. Thus the hyperedge-node has no incident bridge exactly when all three points
   remain in one component after deleting the edge.

**Verdict:** **PASS.**

## Lemma 10.2 — bipartite shadow

**Audit.**

1. Proposition 5.2 decomposes every connected reduced obligatory component into
   connected bipartite expansion pieces attached along a tree-like sequence.
2. If there are `k` pieces, exactly `k-1` one-point identifications occur.
3. Therefore
   ```text
   |E(H)| = sum m_i,
   |V(H)| = sum(m_i+s_i)-(k-1).
   ```
4. One-point-summing the ordinary connected bipartite graphs along any tree,
   flipping bipartition classes as required, produces a connected simple
   bipartite graph.
5. Its edge count is `|E(H)|` and its vertex count is `|V(H)|-|E(H)|`.
6. Each piece has a positive edge count, so the shadow has no isolated vertices.
7. Disjoint union preserves the number of connected components.
8. Conversely, `J^+` is obligatory and has the displayed counts.

**Verdict:** **PASS — edit recommended.**  Step 6 should be stated explicitly.

## Theorem 10.3 — exact order--size--component spectrum

### Connected bipartite graph interval

1. Connectedness gives `r>=s-1`, hence `s<=r+1`.
2. If the bipartition sizes are `a,b`, then
   `r<=ab<=floor(s^2/4)`, equivalent to `s>=ceil(2sqrt r)`.
3. Conversely, the balanced complete bipartite graph on `s` vertices contains
   a spanning tree and enough remaining cross edges to realise every edge count
   from `s-1` to `floor(s^2/4)`.

### Component lower bound

4. Apply the shadow lemma to edge counts `m_i` and orders `s_i`.
5. The merge inequality
   ```text
   q(a)+q(b) >= q(a+b-1)+2
   ```
   follows from
   ```text
   (sqrt(a)+sqrt(b)-1)^2-(a+b-1)
     = 2(sqrt(a)-1)(sqrt(b)-1) >= 0
   ```
   together with `ceil x + ceil y >= ceil(x+y)`.
6. Iterating the merge inequality gives
   `sum q(m_i)>=q(m-c+1)+2(c-1)`.
7. Adding the `m` private expansion vertices yields the lower endpoint.
8. Summing `s_i<=m_i+1` yields the upper endpoint `2m+c`.

### Attainability

9. Use `c-1` copies of `K_2` and one connected bipartite graph with
   `M=m-c+1` edges.
10. The last component attains every order from `q(M)` through `M+1`.
11. Expanding adds exactly `m` private vertices, so every integer in the theorem
    interval occurs.

**Verdict:** **PASS — edit recommended.**  Replace the current compressed
“after squaring” line by the literal calculation in Step 5.

**Exact finite check:** the workflow verifies the connected interval,
component interval, merge inequality, and all attained orders over extensive
finite ranges.

**Formal status:** **NOT YET FORMALISED** as a public Lean corollary.

## Corollary 10.4 — connected and unrestricted spectra

1. The connected range is Theorem 10.3 with `c=1`.
2. For arbitrary `c`, the lower endpoint is never below the connected lower
   endpoint because repeated merging gives
   `q(m-c+1)+2(c-1)>=q(m)`.
3. The connected range covers through `2m+1`.
4. For `2m+1<n<=3m`, choose `c=n-2m`; the upper endpoint `2m+c` equals `n`.
5. The maximum `3m` is attained by `m` disjoint triples.
6. Isolated points may be adjoined arbitrarily, while necessity follows by
   deleting them and applying the reduced lower bound.

**Verdict:** **PASS — edit recommended.**  The current proof states the
construction but should add Steps 2 and 6 explicitly.

## Corollary 10.5 — size spectrum at fixed order

**Audit.**

1. The upper order inequality gives the lower edge bound
   `m>=ceil((n-c)/2)`.
2. Put `M=m-c+1` and `N=n-3c+3`; the lower order inequality becomes
   `M+ceil(2sqrt M)<=N`.
3. With `k=ceil(2sqrt(N+1))`, define `U=N+2-k`.
4. `k^2>=4(N+1)` gives `4U<=(k-2)^2`, so `U` is feasible.
5. `(k-1)^2<4(N+1)` gives `(k-3)^2<4(U+1)`, so `U+1` is infeasible.
6. Strict monotonicity in `M` makes `U` the largest solution.
7. Translating back gives the displayed upper edge bound.
8. Connected reduced component orders are exactly `3`, `5`, and all integers at
   least `7`.
9. Summing `c` component increments gives total increments `0`, `2`, or any
   integer at least `4`; increments `1` and `3` are impossible.

**Verdict:** **PASS.**

**Exact finite check:** exhaustive inversion agrees with Theorem 10.3 over the
workflow range.

**Formal status:** **NOT YET FORMALISED.**

## Corollary 10.6 — exact Levi cycle-rank spectrum

1. The Levi graph has `n+m` vertices, `3m` incidence edges, and `c` components.
2. Hence its cyclomatic number is `2m-n+c`.
3. Substituting both order endpoints gives the displayed exact interval.
4. Every intermediate value occurs because every intermediate order occurs.
5. Cyclomatic number zero is equivalent to being a forest.

**Verdict:** **PASS.**

**Formal status:** **NOT YET FORMALISED.**

## Corollary 10.7 — rigidity at balanced lower endpoints

1. The shadow has `2t` vertices and `t^2` edges, or `2t+1` vertices and
   `t(t+1)` edges.
2. In both cases it attains `floor(|V|^2/4)`.
3. Equality forces a complete bipartite graph with balanced part sizes.
4. For `t>=2`, `K_{t,t}` and `K_{t,t+1}` have no cut vertex.
5. A shadow assembled from two or more positive connected expansion pieces is a
   nontrivial one-point sum and therefore has a cut vertex.
6. The bridge-block decomposition consequently has one piece, so `F` is the
   expansion of the displayed complete bipartite graph.
7. The cases `t=1` reduce directly to one triple or two triples sharing one
   point.

**Verdict:** **PASS.**

**Formal status:** **NOT YET FORMALISED.**

---

# VIII. Formalisation and source-boundary audit

## Public Lean endpoints

The final classification endpoints match Theorem A after isolated reduction.
The formal source audit reports only the standard dependencies
`propext`, `Classical.choice`, and `Quot.sound`, with no project-defined axiom or
proof placeholder in the imported closure.

## Written proof versus Lean proof

The manuscript and Lean development agree on the final classification and on
the bridge-block, expansion, closure, lift, and missing-bridge architecture.
They are not literally identical at every intermediate step:

- the written odd-cycle proof cites the classical Erdős--Hajnal high-odd-girth
  graph;
- Lean constructs an explicit shift-graph/high-odd-girth host;
- one Lean audit records a closed-walk transfer sufficient for the odd-cycle
  obstruction, while the written fibre theorem proves a simple-cycle transfer.

This difference must be stated in the reproducibility section.  It is not a
mathematical gap, but omitting it would make the phrase “formalisation of this
implementation” sound more line-by-line than the repository itself claims.

## Imported theorem interfaces

- **Reiher Theorem 1.2:** correctly cited for obligatory complete bipartite
  expansions.
- **de Bruijn--Erdős:** correctly used for finite-colouring compactness.
- **Erdős--Rado:** the displayed relation is the standard pair-colouring
  instance needed for the triangle host.
- **Erdős--Hajnal:** the odd-cycle parameter substitution is correct.
- **Li Theorem 1.1 / bridge-trace architecture:** the priority and structural
  attribution agree with the current arXiv v2 statement.

## Final audit verdict

The classification proof is mathematically complete.  The finite parameter
spectrum is also correct under exhaustive integer checking.  The manuscript is
not yet “line-by-line publication clean”: the nine edits in the executive
summary should be applied, and the formalisation paragraph should distinguish
the written high-odd-girth proof from the Lean route.

No claim should be made that the Section 10 parameter spectrum is already a
Lean theorem unless separate endpoints are added and audited.
