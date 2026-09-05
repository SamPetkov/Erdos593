# Canonical atom / block research programme

The main manuscript already contains the canonical atom normal form. This folder studies the exact structure and quantitative geometry of those atoms while separating genuinely Erdős-593-specific consequences from classical hypergraph block theory.

## Historical boundary first

Two important facts are prior work.

1. **Komjáth (2001)** proved that a finite triple system is obligatory if and only if all of its 2-connected components are obligatory.
2. General hypergraph **block decomposition, separating vertices, and the block tree** are classical; Bahmanian--Šajna (2015) give a systematic treatment and relate hypergraph blocks to incidence-graph blocks.

See `CLASSICAL_BLOCK_THEORY_BOUNDARY.md`.

Therefore the claim of this programme is **not** that we invented block decomposition or block-locality.  The Erdős 593 payoff is that the completed classification determines exactly which blocks can be obligatory and then yields sharp spectra for every allowable assembly of those blocks.

## Clean block formulation of Erdős 593

After isolated points are deleted, the classification can be reformulated as

```text
F is obligatory
  iff
 every block of F is either
   one triple,
   or J^+ for a finite 2-connected simple bipartite graph J.
```

This combines Komjáth's reduction with the canonical-atom classification.  It is a synthesis/reformulation, not a priority claim over Komjáth.

## Current theorem stack

### Layer I — functorial reconstruction

`FUNCTORIAL_CANONICAL_FOREST.md` proves:

- isomorphisms induce unique isomorphisms of the atom--shared-point forest;
- the system is reconstructed exactly from the decorated forest;
- global isomorphism is decorated-forest isomorphism plus port-compatible local atom isomorphisms; and
- automorphisms fit into an exact local/global group extension.

These are useful structural consequences, but the underlying block tree is classical.

### Layer II — separator formulation and all coarsenings

`POINT_SEPARATOR_UNIVERSALITY.md` gives a construction-independent interface:

- shared points are edge-support point separators;
- canonical atoms coincide with the one-point blocks;
- every supported one-point decomposition is a coarsening of the block decomposition; and
- all coarsenings are connected set partitions of the atom intersection block graph.

Again, the general block theory is classical; this layer primarily connects the repository's intrinsic Levi formulation to standard language.

### Layer III — exact decomposition-lattice product

`LOCAL_DECOMPOSITION_LATTICE_PRODUCT.md` is where the 593-specific quantitative payoff begins.

If `mu(p)` is the number of canonical blocks through a shared point `p`, then the complete lattice `D(F)` of supported one-point decompositions satisfies

```text
D(F) ~= product_{p shared} Pi_{mu(p)},
```

where `Pi_m` is the ordinary partition lattice.

Consequences include

```text
|D(F)| = product_p Bell(mu(p)),
```

an exact decomposition polynomial, Möbius invariant, characteristic polynomial, and maximal-chain count.  The characteristic polynomial recovers the complete shared-point multiplicity profile.

The partition-lattice algebra is classical.  The important 593-specific input is the exact attachment theorem: every partition of `k-c` is realizable by the allowable obligatory blocks.

### Layer IV — sharp extremal attachment geometry

`DECOMPOSITION_LATTICE_EXTREMA.md` puts

```text
N = k-c.
```

For every system of decomposition rank `N`,

```text
2^N <= |D(F)| <= Bell(N+1),
```

with sharp and structurally rigid endpoints:

- **all shared points binary** gives the minimum `2^N`;
- **one shared point carries all excess** gives the maximum `Bell(N+1)`.

The same two geometries sharply minimize/maximize the Möbius magnitude and the number of maximal binary coarsening schedules.

The note also gives the exact law of the number of pieces in a uniformly random coarsening of one fixed system.

### Layer V — exact global phase diagram

`GLOBAL_DECOMPOSITION_LATTICE_SPECTRUM.md` combines the lattice product with the exact atom-count spectrum.

For

```text
s = n-m,
beta = 2m-n+c,
N = k-c,
q(r) = ceil(2 sqrt(r)),
```

the possible lattice ranks are exactly

```text
beta = 0:
    N = s-2c;

beta = 1:
    0 <= N <= s-2c-2,
    N == s-2c (mod 2);

beta >= 2:
    0 <= N <= s-2c-q(beta).
```

For every allowed `N`, **every** product

```text
product_i Pi_{lambda_i+1},
    lambda |- N,
```

occurs, and different `lambda` give nonisomorphic lattices.  Hence the exact number of one-point factorization-lattice types at fixed `(s,beta,c)` is

```text
beta = 0:
    p(s-2c);

beta = 1:
    sum p(N) over the allowed parity progression;

beta >= 2:
    sum_{N=0}^{s-2c-q(beta)} p(N).
```

This is the strongest Direction-1 result currently aimed at the 593 paper: it is an exact quantitative phase diagram produced by the completed classification, not a rediscovery of block theory.

### Isomorphisms and the complexity boundary

`ISOMORPHISM_COUNTING_AND_COMPLEXITY.md` contains:

- an exact product-sum formula for `|Iso(F,G)|`;
- the automorphism exact sequence;
- a canonical-center recursive canonization reduction; and
- a GI-completeness boundary showing that worst-case difficulty already occurs inside a single cyclic atom, using a standard external bipartite GI-hardness input.

This is structural-follow-up material, not core Erdős 593 content.

## Computational audits

The branch contains independent checks for each layer:

- `verify_functorial_canonical_forest.py`;
- `verify_point_separator_universality.py`;
- `verify_decomposition_lattice_product.py`;
- `verify_decomposition_lattice_extrema.py`; and
- `verify_global_decomposition_lattice_spectrum.py`.

The current CI workflow reproduces all five audits.  Finite checks validate definitions and implementations; the general claims rest on the written proofs.

## Publication recommendation

For the main Erdős 593 paper, avoid a large new block-theory section.  The strongest compact presentation is:

1. move Komjáth's 2001 block-locality theorem next to the atom theorem;
2. identify canonical atoms explicitly with the classical hypergraph blocks;
3. state the exact allowable block types as the substantive structural classification; and
4. if space permits, add one compact corollary giving the exact decomposition-lattice spectrum at fixed `(s,beta,c)`.

The full lattice algebra, automorphism theory, random coarsening laws, and GI material should stay supplementary or become a later structural paper.

## Terminology

Use **canonical atom** only for one triple or `J^+` with `J` 2-connected bipartite.  In literature-facing prose, it is useful to say that these atoms are precisely the blocks of a reduced obligatory triple system.  A larger sequence-lift fibre or bridge-decomposition expansion piece may contain several canonical atoms and should not be called an atom.
