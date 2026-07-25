# Uniform Lean formalisation route

**Status:** first gap-free kernel; stacked on the uniform bridge-block theorem PR.

This branch begins the finite, uniformity-parametric Lean development without
refactoring or destabilising the completed Problem 593 formalisation.

## Checked interface

The new namespace `Erdos593.UniformSystem` provides:

- a simple edge-indexed `r`-uniform incidence structure;
- finite edge sets, linearity, and the pairwise-intersection formulation;
- the Levi graph and the exact `r`-neighbour count at every hyperedge-node;
- the set and number of incident Levi bridges;
- the bridge lower bound `r - 2`;
- the residual incidence count and the arithmetic bound `residualCount <= 2`;
- the generic theorem that an actual bridge-free Levi degree cannot equal one;
- the actual bridge-free `0/2` dichotomy whenever that degree is at most two;
- the even-Berge-cycle and intrinsic predicates; and
- cycle-rank arithmetic showing why the attainable nullity interval is
  independent of the uniformity.

All declarations in the branch compile without `sorry`, `admit`, or new axioms.

## Why this is not a wholesale refactor

The existing `TripleSystem` development is complete, large, and publication
facing. Replacing it in situ by an `r`-uniform type would create a high-risk
migration across the sequence lift, positive atoms, avoidance hosts, and the
self-contained source generator. The safer route is additive:

1. establish a small uniform kernel in a separate namespace;
2. prove the graph-theoretic bridge-deletion lemmas there;
3. formalise active bridge blocks and the suppressed bipartite core;
4. define uniform expansions and the generated class `B_r`;
5. prove the finite constructive/intrinsic equivalence;
6. only then decide whether shared abstractions should be backported to the
   triple-system project.

## Remaining finite obligations

The main missing declarations are:

1. **Bridge-count accounting.** Identify the arithmetic residual count
   `r - bridgeCount e` with the degree of the hyperedge-node in the graph
   obtained by deleting every actual Levi bridge. This turns the checked bridge
   lower bound directly into the checked actual-degree `0/2` theorem.
2. **Active block suppression.** A bridge-free active component has every
   hyperedge-node of degree two and therefore suppresses to an ordinary graph.
3. **Simplicity and bipartiteness.** Source linearity makes the suppressed graph
   simple; even Berge cycles make it bipartite.
4. **Private-incidence lemma.** The other `r-2` points of an active hyperedge are
   private inside its block.
5. **Bridge quotient and running intersection.** Contracting bridge-free
   components gives a forest and a certificate-producing amalgamation order.
6. **Uniform expansion packaging.** Identify active pieces with `J^(r)` and
   all-bridge edges with the one-edge expansion atom.

## Suggested module sequence

```text
UniformSystem/BridgeDeletion.lean
UniformSystem/ActiveBlock.lean
UniformSystem/SuppressedCore.lean
UniformSystem/Expansion.lean
UniformSystem/BridgeQuotient.lean
UniformSystem/Constructive.lean
UniformSystem/Classification.lean
```

The next target is the bridge-count accounting identity. The no-singleton graph
lemma and the zero-or-two actual-degree endpoint are already imported and
checked from the general finite-graph bridge kernel.

## Separation from the infinitary problem

This route formalises the finite theorem about the generated class `B_r`. It
does not depend on the candidate all-uniformity obligatoriness theorem. The
iterated-lift avoidance construction is maintained in a separate research PR
and should be formalised only after its ordinary proof has been independently
checked under issue #20.
