# Erdős 593: manuscript--Lean statement alignment audit

## Scope

This audit compares the mathematical objects and public theorem statements in
the publication manuscript with the actual Lean declarations imported by the
public classification endpoint.  It is deliberately narrower than a code
review: the Lean kernel and axiom audits already check proof compilation and
trust dependencies.  Here the question is semantic:

> Does the formal theorem mean what the manuscript says it means?

The files inspected include:

- `TripleSystem/Basic.lean`;
- `TripleSystem/Embedding.lean`;
- `TripleSystem/Obligatory.lean`;
- `TripleSystem/Intrinsic.lean`;
- `TripleSystem/Constructive.lean`;
- `TripleSystem/ObligatoryClassification.lean`;
- the bridge-block and sequence-lift dependency records;
- the public formalisation README and classification audit.

## Verdict

**PASS with explicit surface qualifications.**  The public endpoints verify the
finite classification in the formalisation's documented ambient-universe
convention.  The formal objects agree with the manuscript on simplicity,
3-uniformity, weak colouring, injective non-induced containment, linearity,
Levi bridges, Berge-cycle parity, isolated reduction, and the constructive
operations.

Two distinctions must remain visible in publication prose:

1. the public Lean endpoint is phrased on `F.isolatedReduction`, whereas the
   displayed manuscript theorem writes `F in B`; these are mathematically
   equivalent by the isolated-vertex lemma, but they are not literally the same
   surface formula;
2. the Lean `Constructible` predicate is explicitly closed under isomorphism,
   while the manuscript currently leaves isomorphism closure implicit.

The second item deserves a direct manuscript edit.

---

## 1. Triple systems

### Manuscript

A triple system is a simple 3-uniform hypergraph.

### Lean

`TripleSystem V E` is edge-indexed and contains:

```text
Inc        : V -> E -> Prop
edge_ncard : every indexed edge contains exactly three vertices
simple     : distinct edge indices determine distinct vertex sets.
```

### Check

This is an exact representation of a simple 3-uniform hypergraph.  Edge indices
are implementation data; injectivity of the edge-set map prevents duplicate
edges.  The edge-indexed presentation is especially appropriate for the Levi
graph, whose two parts are literally `V` and `E`.

**Status: exact match.**

---

## 2. Weak proper colouring and chromatic number

### Manuscript

A colouring is proper when no hyperedge is monochromatic, and `chi(H)` is the
least cardinal admitting such a colouring.

### Lean

`IsProperColoring c` requires, for every edge, two incident vertices with
different colours.  Since every edge has exactly three vertices, this is
logically equivalent to `no edge is monochromatic`.

`chromaticCardinal` is the infimum of cardinals represented by colour types
admitting a proper colouring.

### Check

The formal definition is the standard weak hypergraph chromatic number.  It is
not strong/rainbow colouring.

**Status: exact match.**

Recommended formalisation sentence:

> Lean defines properness by exhibiting two differently coloured vertices in
> every edge; for a 3-uniform edge this is equivalent to the manuscript's
> no-monochromatic-edge convention.

---

## 3. Embeddings and containment

### Manuscript

Containment is injective and non-induced: every source edge maps to a host edge,
while additional host edges on the image vertices are allowed.

### Lean

`Embedding F H` contains:

```text
vertex   : V embeds into W
edge     : E -> D
map_edge : image of each source edge = the selected host edge.
```

The edge map is proved injective from source simplicity and vertex injectivity.
There is no reflection condition saying that every host edge on the image must
come from the source.

### Check

This is precisely a non-induced hypergraph embedding.  The equality in
`map_edge` does not make the embedding induced; it only says that each selected
host hyperedge has exactly the images of the three source vertices.

**Status: exact match.**

---

## 4. Obligatoriness and the universe boundary

### Manuscript

A finite source is obligatory when it appears in every triple system of
uncountable chromatic number.

### Lean

`F.IsObligatory` quantifies over arbitrary, possibly infinite host vertex and
edge types in the same two Lean universes as the source types and requires

```text
aleph_0 < H.chromaticCardinal -> F.Appears H.
```

A `DecidableEq` instance for the host vertex type is an implementation
parameter available classically; it is not a mathematical finiteness
restriction.

### Check

The host is not assumed finite.  The public theorem is universe-polymorphic but
not class-quantified across every larger universe in one proposition.  This is
the normal ambient-universe convention for such a Lean development.

**Status: correct with the existing qualification.**

The manuscript already says that hosts are quantified within the documented
ambient-universe convention.  That sentence must remain.  Avoid the stronger
claim that one Lean proposition literally quantifies over host types in all
universe levels simultaneously.

---

## 5. Linearity

### Manuscript

Any two distinct hyperedges meet in at most one point.

### Lean

`Linear` says that if two distinct edge indices both contain points `x` and
`y`, then `x=y`.  A proved equivalence identifies this with subsingleton
intersection of distinct edge sets.

**Status: exact match.**

---

## 6. Levi bridges and Berge parity

### Manuscript

Every hyperedge-node of the Levi graph is incident with a bridge, and every
Berge cycle has even length.

### Lean

`BridgeAtEveryEdge` quantifies over each edge index and requires an incident
edge in `SimpleGraph.bridgeEdges F.levi`.

`EvenBergeCycles` quantifies over simple closed walks in the Levi graph and
requires

```text
4 divides c.length.
```

A Berge cycle of length `ell` is a Levi cycle of length `2 ell`, so this is
exactly the requirement that `ell` be even.

### Check

Every simple cycle of a Levi graph alternates point-nodes and hyperedge-nodes
and hence corresponds to a Berge cycle.  A Berge 2-cycle may exist in a
nonlinear system, but `Intrinsic` also requires linearity, which rules it out.

**Status: exact match.**

---

## 7. The constructive class

### Manuscript

The class `B` is generated from finite edgeless systems and private-vertex
expansions of finite bipartite graphs under finite disjoint unions and one-point
amalgamations.

### Lean

`Constructible` has constructors for:

1. finite edgeless systems;
2. private-vertex expansions of finite graphs with `Colorable 2`;
3. binary disjoint union;
4. one-point amalgamation;
5. isomorphism.

Binary operations suffice because every construction term is finite.  For
finite simple graphs, `Colorable 2` is equivalent to bipartiteness.

### Check

The generators and operations agree.  The only prose mismatch is that the Lean
class makes isomorphism closure explicit, while the manuscript's definition of
`B` currently relies on the conventional understanding that a structural class
of finite hypergraphs is considered up to isomorphism.

**Status: mathematically equivalent; publication edit required.**

Add after the definition of `B`:

> As usual, membership in `B` is understood up to hypergraph isomorphism.

Alternatively, add `and closed under isomorphism` to the defining sentence.

This is not cosmetic.  Literal closure under the displayed constructors alone
would depend on the chosen vertex and edge labels, while obligatoriness is
isomorphism-invariant.

---

## 8. Isolated reduction and the public endpoints

The two public theorems are:

```text
F.IsObligatory <-> F.isolatedReduction.Intrinsic
F.IsObligatory <-> Constructible F.isolatedReduction.
```

The manuscript's Theorem A instead displays:

```text
F obligatory <-> F in B <-> F^circ intrinsic.
```

The manuscript separately proves

```text
F in B <-> F^circ in B,
```

so the statements are mathematically equivalent.  The formalisation README and
manuscript formal-verification section already quote the exact Lean endpoints,
which is the correct practice.

**Status: equivalent, but do not blur the surface distinction.**

Recommended wording:

> The public Lean endpoints are stated on the isolated reduction.  Together
> with the separately proved isolated-vertex equivalence, they verify the
> displayed form of Theorem A.

A future Lean wrapper theorem with the exact typeset surface statement would be
convenient, but its absence is not a theorem gap.

---

## 9. Positive direction

The formal dependency record includes:

- obligatory complete-bipartite expansion atoms;
- reduction of arbitrary finite two-colourable expansions to balanced complete
  bipartite atoms;
- disjoint-union closure;
- rooted abundance and one-point-amalgamation closure;
- obligatoriness of every `Constructible` system.

The formal proof is not merely a declaration that Reiher's theorem is
available.  The project contains a classical cardinal-minimal proof of the
balanced atoms and the exact closure arguments.

**Status: manuscript claim supported.**

The detailed Lean organisation is not line-by-line identical to the prose, so
`formalisation of the implementation presented here` is preferable to
`line-by-line formalisation of the manuscript`.

---

## 10. Negative direction

The public classification endpoint imports separate unconditional theorems for:

1. nonlinearity;
2. failure of the isolated-reduction bridge condition;
3. failure of isolated-reduction Berge parity.

The formal odd-cycle route uses an explicit shift-graph host and transfers a
Berge cycle to an odd closed host walk with the required doubled-length
relation.  The written proof instead invokes the classical Erdős--Hajnal graph
and the base-fibre theorem to obtain an ordinary cycle of the same Berge
length.

These are two proofs of the same obstruction, not a line-by-line match.

**Status: endpoint alignment correct; proof-route distinction must remain
explicit.**

---

## 11. Finite parameter consequences

The public endpoints above concern the classification.  The order--size--
component spectrum, fixed-order inversion, cycle-rank spectrum, and endpoint
rigidity are conventional consequences of the classification and the
bipartite-shadow lemma.  They are checked by exact Python enumeration in the
audit PR but are not currently exported as separate Lean theorems.

**Status: correct current disclosure.**

Do not write that Lean verifies every theorem in the enlarged manuscript unless
these Section 10 results are subsequently formalised.

---

## 12. Additional copy-ready edits

### Edit A: isomorphism closure

After the sentence defining `B`, insert:

> Membership in `B` is understood up to triple-system isomorphism.

### Edit B: exact Lean surface

Replace the first sentence of the formal-verification paragraph by:

> The public Lean endpoints state the classification on the isolated
> reduction: for every finite triple system `F`, they prove
> `F.IsObligatory <-> F.isolatedReduction.Intrinsic` and
> `F.IsObligatory <-> Constructible F.isolatedReduction`.

Then retain the explanation that Lemma 1.1 converts this to the displayed
Theorem A formulation.

### Edit C: universe scope

Retain and sharpen the ambient-universe sentence:

> Host systems are unrestricted in cardinality but are quantified in the
> fixed ambient vertex and edge universes of the theorem; this is the documented
> universe-polymorphic convention of the Lean development.

### Edit D: Section 10 scope

Add:

> The Lean endpoints cover the classification theorem.  The finite parameter
> consequences in Section 10 are conventional corollaries checked separately
> by exact integer arithmetic and are not yet exported as Lean theorems.

## Final conclusion

The Lean formalisation supports the mathematical claims made for the finite
classification.  The principal remaining task is not proof repair but exact
publication wording: make isomorphism closure explicit, quote the isolated-
reduction endpoints literally, retain the universe qualification, and separate
the Lean-checked classification from the exact-computation-supported parameter
corollaries.
