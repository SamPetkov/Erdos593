# Uniformity-extension experiments for obligatory hypergraphs

**Status:** research note and reproducible finite experiment; not part of the
current publication PR and not yet Lean-formalised.

## 1. Proposed extension

For an integer `r >= 2` and a finite graph `J`, let `J^(r)` be the `r`-uniform
expansion obtained by adjoining `r-2` new private vertices to every graph edge.
Let `B_r` be the smallest class of finite `r`-uniform hypergraphs containing
`J^(r)` for every finite bipartite graph `J` and all finite edgeless systems,
and closed under disjoint unions and one-point amalgamations.

Reiher proved that `K_(n,n)^(r)` is obligatory for every finite `r >= 2` and
`n >= 1`. Since every finite bipartite graph is a subgraph of a sufficiently
large complete bipartite graph, every bipartite expansion `J^(r)` is
obligatory. Together with the known closure of obligatory uniform hypergraphs
under disjoint unions and one-point amalgamations, this shows that every member
of `B_r` is obligatory.

The finite structure suggests the following uniform extension of the triple
system criterion.

> **Proposed structural theorem.** A finite `r`-uniform hypergraph `F` belongs
> to `B_r` if and only if, after deleting isolated vertices,
>
> 1. `F` is linear;
> 2. every hyperedge-node of the Levi graph is incident with at least `r-2`
>    bridges; and
> 3. every Berge cycle has even length.

For `r=2` this is the bipartite-graph criterion. For `r=3` it is the finite
structural theorem proved in the main development. For larger uniformities the
statement has not yet been Lean-checked or independently refereed.

### Proof strategy

Delete every Levi-graph bridge. At each hyperedge-node, the number of remaining
incidences is either zero or two: a nonbridge lies on a cycle and therefore
cannot be the unique nonbridge incident with that node. Each nontrivial
bridge-free component can consequently be suppressed to a simple ordinary
graph whose edges are the hyperedge-nodes. Linearity makes this graph simple,
and evenness of all Berge cycles makes it bipartite. The other `r-2`
incidences of each hyperedge supply the private expansion vertices. Hyperedge
nodes with no nonbridge incidence give one-edge expansion atoms. The quotient
formed by the deleted bridges is a forest, so the atoms can be reassembled in
a running-intersection order by one-point amalgamations.

This is a proof programme, not a substitute for a checked formal proof. The
experiment below was designed to search for small counterexamples to precisely
this decomposition.

## 2. Exact parameter spectrum of the generated class

The bipartite-shadow argument from the triple-system case extends without
change to `B_r`. If `F in B_r` has no isolated vertices, `m >= 1` hyperedges,
and exactly `c` Levi components, then the possible orders are exactly

\[
\boxed{
(r-2)m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
\le |V(F)|\le
(r-1)m+c.
}
\]

Every integer in the interval occurs. In the connected case this becomes

\[
\boxed{
(r-2)m+\left\lceil2\sqrt m\right\rceil
\le |V(F)|\le
(r-1)m+1.
}
\]

This is a theorem about the generated class `B_r`; it does not assume the
conjecture that `B_r` contains every obligatory `r`-uniform hypergraph.

## 3. Exhaustive incidence-type experiment

The script `experiments/uniformity_conjecture.py` represents a connected linear
`r`-uniform hypergraph with labelled hyperedges by its shared vertices. A
shared vertex is encoded by the subset of hyperedges containing it. Linearity
is exactly the condition that no pair of hyperedges occurs together in two
shared subsets. The remaining incidences are filled by degree-one private
vertices.

For every generated incidence type satisfying the proposed intrinsic
condition, the script applies a recursive recogniser:

1. split disconnected systems;
2. split connected systems at point articulation vertices of the Levi graph;
3. accept terminal pieces exactly when they are expansions `J^(r)` of finite
   bipartite graphs.

The search is exhaustive over all such connected labelled incidence types with
at most six hyperedges for `r=3,4,5`.

| uniformity | connected types examined | intrinsic candidates | candidates recognised as `B_r` | mismatches |
|---:|---:|---:|---:|---:|
| 3 | 77,678 | 8,445 | 8,445 | 0 |
| 4 | 157,589 | 8,810 | 8,810 | 0 |
| 5 | 172,039 | 8,816 | 8,816 | 0 |
| **total** | **407,306** | **26,071** | **26,071** | **0** |

The counts of intrinsic candidates by number `m` of hyperedges were:

| `m` | `r=3` | `r=4` | `r=5` |
|---:|---:|---:|---:|
| 1 | 1 | 1 | 1 |
| 2 | 1 | 1 | 1 |
| 3 | 4 | 4 | 4 |
| 4 | 32 | 32 | 32 |
| 5 | 426 | 431 | 431 |
| 6 | 7,981 | 8,341 | 8,347 |

For every `r` and `m` in the exhaustive range, the observed connected orders
were exactly the integers predicted by

\[
(r-2)m+\lceil2\sqrt m\rceil
\le n\le
(r-1)m+1.
\]

## 4. Random stress test

A second search generated 2,500 random connected linear incidence types for
each pair

\[
r\in\{3,4,5\},\qquad m\in\{7,8,9,10\}.
\]

This gave 30,000 random samples. Among them, 336 satisfied the candidate
intrinsic condition. Every one of those 336 was recognised by the recursive
`B_r` decomposition; no mismatch was found.

| uniformity | intrinsic random candidates | recognised | mismatches |
|---:|---:|---:|---:|
| 3 | 83 | 83 | 0 |
| 4 | 126 | 126 | 0 |
| 5 | 127 | 127 | 0 |

The random generator is deliberately simple and is not a uniform sampler on
isomorphism classes. These numbers are stress-test evidence, not statistical
confidence levels.

## 5. Obligatory-hypergraph conjecture

The finite structure and Reiher's positive theorem motivate the broader
conjecture

> **Uniform obligatory-hypergraph conjecture.** For every finite `r >= 2`, the
> obligatory finite `r`-uniform hypergraphs are exactly the members of `B_r`.

Equivalently, after isolated vertices are removed, obligatoriness would be
characterised by linearity, at least `r-2` bridge incidences at every
hyperedge-node, and evenness of every Berge cycle.

The experiment only checks the finite structural decomposition. It does not
address the difficult infinitary avoidance direction: for `r >= 4`, one still
needs uncountably chromatic hosts excluding every system that fails one of the
three intrinsic conditions.

## 6. Next experiments

The most useful next computational steps are:

1. **Canonical isomorphism pruning.** Replace labelled enumeration by canonical
   incidence-graph labelling to reach seven and eight hyperedges exhaustively.
2. **SAT counterexample search.** Encode linearity, the bridge lower bound,
   odd-Berge-cycle exclusion, and failure of recursive decomposition as a SAT
   instance.
3. **Uniformity-independent Lean structure.** Generalise the existing
   bridge-block and running-intersection modules to a finite uniformity
   parameter before attempting any infinitary theorem.
4. **Avoidance experiments.** Test whether the one-apex lift admits an
   `r`-uniform version that separately witnesses nonlinearity, insufficient
   bridge incidence, and odd Berge cycles.
5. **Parameter formalisation.** Prove the displayed `B_r` order spectrum in
   Lean as a finite corollary independent of the open obligatoriness
   conjecture.

## 7. Reproduction

A full run matching the checked-in result is:

```bash
python experiments/uniformity_conjecture.py \
  --uniformities 3,4,5 \
  --max-edges 6 \
  --random-min-edges 7 \
  --random-max-edges 10 \
  --random-trials 2500 \
  --seed 593 \
  --output experiments/uniformity_results.json
```

The script uses only the Python standard library. On the reference run it
finished in approximately 32 seconds. Exact timings depend on the Python
implementation and hardware.

## 8. Literature boundary

Christian Reiher's *Obligatory hypergraphs* proves that
`K_(n,n)^(r)` is obligatory for every finite `r >= 2` and records closure under
disjoint unions and one-point amalgamations. It also notes that, as of that
work, no comparable general classification was known. A targeted arXiv search
performed for this experiment did not locate a later `r >= 4` classification
matching the criterion above. This is a search record, not an absolute novelty
claim.
