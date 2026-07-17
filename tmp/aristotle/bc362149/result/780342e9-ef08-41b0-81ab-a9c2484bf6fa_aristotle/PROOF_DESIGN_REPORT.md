# Dynamic incidence-forest proof-design result

## Scope and repository

The work was checked against public `SamPetkov/Erdos593` commit
`38c62297b5eea3e3f52b7fe105e91170adbc75a8`, using its pinned Lean 4.32.0
and Mathlib dependency. No existing theorem statement was changed.

## Delivered declarations

The complete new module is in
`Erdos593/TripleSystem/SequenceLiftBaseFiberSupportIncidenceForestOrder.lean`,
and an apply-ready addition patch is in
`SequenceLiftBaseFiberSupportIncidenceForestOrder.patch`.

It contains:

* `SimpleGraph.setFamilyIncidenceGraph`: a bipartite graph on `Sum A P`.
* `SimpleGraph.setFamilyIncidenceGraph_adj_left_right` and
  `SimpleGraph.setFamilyIncidenceGraph_adj_right_left`: exact adjacency API.
* `SimpleGraph.IsAcyclic.exists_left_leaf_of_right_two_neighbors`: the generic
  finite dynamic-pruning leaf lemma. It induces an ambient forest on an
  arbitrary retained vertex set `R`; if `R` has a fibre-side vertex and every
  retained point-side vertex has two distinct retained fibre-side neighbours,
  then a fibre-side leaf exists.
* `Erdos593.SequenceLift.baseFiberSupportIncidenceGraph`: the required
  fibre/actual-support-point incidence graph.
* `Erdos593.SequenceLift.exists_activeBaseFiber_leaf_in_dynamic_incidence`:
  the exact concrete bridge for a finite selected set and each nonempty
  remaining fibre finset `Q`. Its retained point vertices are exactly those
  incident to two distinct members of `Q`, and ambient incidence acyclicity
  yields a remaining fibre with at most one retained neighbour.

The bridge's ambient acyclicity hypothesis is on
`baseFiberSupportIncidenceGraph S`, exactly as required; the generic lemma uses
`IsAcyclic.induce` internally. Common apex points are retained as one point
vertex and may be adjacent to arbitrarily many fibres. No support-overlap graph
or `baseFiberSupportTailAtMostOneNeighbor` conclusion is used.

## Exact remaining blocker to the full ordering theorem

The full recursive theorem producing a `List (Node G)` that covers `S` and
satisfies `baseFiberSupportTailOverlapCoherent S nodes` is not claimed here.
The remaining work is the well-founded recursion over `Q.erase q`, together
with the head coherence conversion:

1. use `exists_activeBaseFiber_leaf_in_dynamic_incidence` at the current `Q`;
2. show every nonempty intersection of the chosen fibre with a remaining fibre
   is represented by a retained point vertex;
3. leaf uniqueness makes the witnesses of all such nonempty intersections the
   same point;
4. use
   `SequenceLift.baseFiber_support_inter_subsingleton_of_linear hlinear` for
   each distinct pair to upgrade equality of the unique witnesses to equality
   of the two intersection sets;
5. prepend the chosen fibre to the recursively obtained order and transport
   the active-node subtype list to `List (Node G)`, proving cover and nodup.

Thus the missing component is recursive assembly plus the intersection-set
extensionality step, not the dynamic forest leaf fact or its concrete
SequenceLift bridge. No weaker ordering theorem is presented as the target.

## Verification commands and results

```text
$ lake build Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceForestOrder
✔ [1592/1592] Built Erdos593.TripleSystem.SequenceLiftBaseFiberSupportIncidenceForestOrder
Build completed successfully (1592 jobs).
```

A strict source scan for `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`,
`implemented_by`, and resource override syntax returned no matches in the new
module.

```text
#print axioms SimpleGraph.IsAcyclic.exists_left_leaf_of_right_two_neighbors
[propext, Classical.choice, Quot.sound]

#print axioms Erdos593.SequenceLift.exists_activeBaseFiber_leaf_in_dynamic_incidence
[propext, Classical.choice, Quot.sound]
```

These are standard permitted axioms.

## Prohibited-claim audit

* Full coherent ordering theorem: **not claimed**.
* `baseFiberSupportTailAtMostOneNeighbor`: **not claimed or used**.
* Static support-overlap forest: **not assumed**.
* Common-apex exclusion: **not assumed**; shared point vertices can have high
  degree.
* `sorry`, `admit`, new axioms, `unsafe`, `native_decide`, `implemented_by`,
  resource overrides, or nonstandard trust shortcuts: **none used**.
* Existing theorem statements: **unchanged**.
