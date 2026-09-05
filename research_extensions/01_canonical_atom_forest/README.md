# Canonical atom forest research programme

The main manuscript already contains the canonical atom normal form. This folder studies the next structural layer while separating genuinely 593-specific consequences from classical hypergraph block theory.

## Current theorem stack

### Layer I — functorial reconstruction

`FUNCTORIAL_CANONICAL_FOREST.md` proves:

1. isomorphisms induce unique isomorphisms of the atom--shared-point forest;
2. the system is exactly reconstructed from the decorated forest;
3. irreducible forest assemblies are unique;
4. global isomorphism is decorated-forest isomorphism plus port-compatible atom isomorphisms; and
5. the automorphism group fits into an exact local/global extension.

### Layer II — universal one-point factorization

`POINT_SEPARATOR_UNIVERSALITY.md` records the construction-independent separator formulation:

1. shared points are point separators of the hyperedge support;
2. canonical atoms are point-inseparability classes of hyperedges;
3. the atom partition is the finest one-point forest decomposition;
4. coarser decompositions are connected set partitions of the atom intersection graph; and
5. that atom intersection graph is a block graph.

**Attribution warning:** the general existence/uniqueness of hypergraph blocks, separating vertices, and the block tree is classical. Bahmanian--Šajna (2015) already prove a general hypergraph block decomposition and its relation to the incidence graph. See `CLASSICAL_BLOCK_THEORY_BOUNDARY.md`. The separator statements above are therefore a specialization/reformulation and an independent interface to this repository's extractor, not an absolute novelty claim.

The 593-specific content is that the blocks are classified exactly as one triple or `J^+` for a finite 2-connected simple bipartite graph `J`, together with the sharp spectra developed in the repository.

`UNIVERSAL_ONE_POINT_FACTORIZATION_EXTENSION.tex` is the compact manuscript-facing candidate, but it should be edited to cite the classical block literature before integration.

### Layer III — exact decomposition-lattice product

`LOCAL_DECOMPOSITION_LATTICE_PRODUCT.md` combines the block structure with the exact shared-point multiplicity theorem.

If `mu(p)` is the number of canonical atoms through a shared point `p`, then

```text
D(F) ~= product_p Pi_{mu(p)},
```

where `D(F)` is the full lattice of supported one-point decompositions and `Pi_m` is the ordinary partition lattice.

Consequences include:

- `|D(F)| = product_p Bell(mu(p))`;
- a coefficientwise product formula for decompositions by number of pieces;
- exact Möbius and characteristic polynomials;
- an exact count of maximal binary coarsening chains;
- recovery of the complete shared-point multiplicity profile from the characteristic polynomial; and
- exactly `p(k-c)` nonisomorphic decomposition-lattice types at fixed atom count `k` and component count `c`.

The partition-lattice algebra is classical. The 593-specific theorem is the exact realization/spectrum: every integer partition of `k-c` is achievable by the canonical obligatory atoms, so every lattice product allowed by that formula actually occurs.

### Isomorphisms and the complexity boundary

`ISOMORPHISM_COUNTING_AND_COMPLEXITY.md` adds:

- an exact product-sum formula for `|Iso(F,G)|`;
- the automorphism exact sequence as a corollary;
- a canonical-center recursive canonization reduction; and
- a GI-completeness boundary showing that worst-case isomorphism hardness already occurs inside one cyclic atom, using a standard external bipartite GI-hardness input.

This belongs in a structural follow-up or appendix rather than the core Erdős 593 theorem.

## Why this improves the Erdős 593 story

The literature-aware structural picture is now

```text
obligatory
    <-> intrinsic Levi conditions
    <-> classical hypergraph blocks of exactly the allowed types
    <-> sharp atom/block and attachment spectra.
```

The conceptual gain is not that we invented block decomposition. It is that Erdős 593 identifies **exactly which blocks survive the uncountable-chromatic forcing problem**, and the later results quantify every allowable combination of those blocks.

## Computational audits

`experiments/verify_point_separator_universality.py` checks 5,000 random assemblies and exhaustively examines 9,352 edge partitions of 56 small systems.

`experiments/verify_decomposition_lattice_product.py` directly enumerates all connected partitions on those 56 systems and checks the decomposition-polynomial, Bell-product, Möbius, characteristic-profile, and maximal-chain formulas.

Finite audits test definitions and implementations; the general claims rest on the written proofs.

## Publication recommendation

For the main 593 paper, do **not** add a large new block-theory section. Prefer:

1. a short literature-aware remark identifying canonical atoms with the classical hypergraph blocks;
2. the existing 593-specific atom classification and sharp spectra as the substantive result; and
3. at most one compact corollary explaining the exact attachment/decomposition-lattice spectrum if it improves the narrative.

The full bond-lattice, automorphism, counting and GI material should remain supplementary or become a structural follow-up.

## Terminology

Use **canonical atom** only for one triple or `J^+` with `J` 2-connected bipartite. A larger bridge-decomposition fibre may contain several canonical atoms and should be called an expansion piece or base fibre, not an atom.
