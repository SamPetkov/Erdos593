# Canonical atom forest research programme

The main manuscript already contains the canonical atom normal form. This folder studies the next structural layer rather than restating that theorem.

## Primary targets

1. **Functoriality.** Isomorphisms of obligatory triple systems induce unique isomorphisms of their atom--shared-point forests.
2. **Universal reconstruction.** The system is the quotient of the disjoint atom union by exactly the shared-point identifications encoded by the forest.
3. **Uniqueness among irreducible assemblies.** Any forest decomposition into one-point-indecomposable obligatory factors is the canonical atom decomposition.
4. **Isomorphism reduction.** Global isomorphism is equivalent to decorated-forest isomorphism plus port-compatible local atom isomorphisms.
5. **Automorphisms.** Compute `Aut(F)` from the decorated forest action and local pointwise port-fixing atom groups.
6. **Formalization.** Turn the canonical atom forest into a Lean object with reconstruction and functoriality theorems.

The full ordinary-mathematics proof package is in `FUNCTORIAL_CANONICAL_FOREST.md`.

## Why this is useful for the Erdős 593 paper

The classification then has three levels:

`obligatory <-> intrinsic conditions <-> canonical irreducible forest geometry`.

The first two classify membership. The third classifies internal structure and makes the decomposition reusable for automorphisms, algorithms, tensor contractions, and stability questions.

## Terminology

Use **canonical atom** only for one triple or `J^+` with `J` 2-connected bipartite. A larger bridge-decomposition fibre may contain several canonical atoms and should be called an expansion piece or base fibre, not an atom.
