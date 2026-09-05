# Canonical atom forest research programme

The main manuscript already contains the canonical atom normal form. This folder studies the next structural layer rather than restating that theorem.

## Current theorem stack

The programme now has two layers of ordinary mathematics.

### Layer I — functorial reconstruction

`FUNCTORIAL_CANONICAL_FOREST.md` proves:

1. isomorphisms induce unique isomorphisms of the atom--shared-point forest;
2. the system is exactly reconstructed from the decorated forest;
3. irreducible forest assemblies are unique;
4. global isomorphism is decorated-forest isomorphism plus port-compatible atom isomorphisms; and
5. the automorphism group fits into an exact local/global extension.

### Layer II — universal one-point factorization

`POINT_SEPARATOR_UNIVERSALITY.md` strengthens this substantially:

1. **shared points are intrinsic point separators** of the hyperedge support;
2. **canonical atoms are exactly the point-inseparability classes of hyperedges**;
3. the canonical atom partition is the unique finest one-point forest decomposition even among competing pieces not assumed obligatory;
4. every coarser one-point decomposition is a connected set partition of the atom intersection graph;
5. that atom intersection graph is a block graph, and the full decomposition poset is its bond lattice; and
6. a connected system has a canonical center object fixed by all automorphisms.

`UNIVERSAL_ONE_POINT_FACTORIZATION_EXTENSION.tex` is the compact manuscript-facing version.

### Isomorphisms and the complexity boundary

`ISOMORPHISM_COUNTING_AND_COMPLEXITY.md` adds:

- an exact product-sum formula for `|Iso(F,G)|`;
- the automorphism exact sequence as a corollary;
- a canonical-center recursive canonization reduction; and
- a GI-completeness boundary showing that worst-case isomorphism hardness already occurs inside one cyclic atom, using the standard bipartite GI-hardness input recorded by Babai.

This last result is best treated as a structural follow-up or appendix rather than part of the Erdős 593 theorem statement.

## Why this improves the Erdős 593 story

The classification now has three conceptual levels:

```text
obligatory
    <-> intrinsic Levi conditions
    <-> canonical atoms
    <-> universal one-point prime factorization.
```

The last equivalence says what the atoms *are* without referring to the cyclic-block construction: they are the maximal hyperedge sets that no single point deletion can separate.

This makes the result look much closer to a genuine block/prime decomposition theorem than to a list of generators.

## Computational audit

`experiments/verify_point_separator_universality.py` checks the strengthened statements independently of the proof text.  The committed deterministic result covers 5,000 random assemblies and an exhaustive search through 9,352 edge partitions of 56 small systems.

The audit checks:

- separator points versus shared points;
- point-inseparability classes versus canonical atoms;
- block-graph structure of the atom intersection graph;
- universal refinement for every valid small one-point decomposition; and
- the converse from every connected atom partition.

## Publication recommendation

For the main 593 paper, the strongest addition is one compact proposition:

> the canonical atoms are exactly the maximal point-inseparable hyperedge sets, and they give the unique finest supported one-point forest decomposition.

The bond-lattice, automorphism, counting and GI-completeness material should remain supplementary unless a separate structural paper is developed.

## Terminology

Use **canonical atom** only for one triple or `J^+` with `J` 2-connected bipartite. A larger bridge-decomposition fibre may contain several canonical atoms and should be called an expansion piece or base fibre, not an atom.

## Literature boundary

Block-cut decompositions, block graphs and bond lattices are classical graph theory.  The research claim under review is the exact identification of those structures with the canonical obligatory-triple-system factorization.  No novelty claim is made for the classical machinery itself.
