# Direction 6 — Stability, repair, and property testing

## Objective

The exact Erdős 593 theorem recognizes the class through three intrinsic conditions after isolated vertices are removed:

1. linearity;
2. at least one incident Levi bridge at every hyperedge-node;
3. even Berge cycles.

The stability programme asks whether a system that violates these conditions only mildly is close, in a precise edit metric, to the obligatory class.

## Use an edit distance, not a raw defect count

For a finite triple system `F`, define the edge-deletion repair distance

`d_B(F) = min{|D| : (F-D)^circ satisfies the intrinsic conditions}`.

Normalized versions include `d_B(F)/|E(F)|`. One can also study vertex edits or incidence edits, but they should be kept separate.

This definition avoids a problem with naive quantities such as "number of odd Berge cycles": a single edge can lie on exponentially many odd cycles, so raw obstruction counts need not reflect edit distance.

## Local witness families

Three natural certificate types are:

- a pair of hyperedges meeting in at least two points;
- a hyperedge-node with no incident Levi bridge;
- an odd Berge cycle.

A first algorithmic question is whether one can pack many edge-disjoint local witnesses whenever `d_B(F)` is large.

### Packing/covering target

Find the best function `f` such that every finite triple system admits either

- an edge set `D` with `|D| <= f(k)` and `F-D` obligatory, or
- `k` suitably edge-disjoint intrinsic obstruction certificates.

Even a polynomial relation would give a meaningful structural stability theorem.

## Stability conjectures to test

### Conjecture A — bounded-degree linear stability

For each maximum Levi degree bound `Delta` and every `epsilon>0`, there is `delta>0` such that if a finite linear triple system has at most `delta |E|` edge-disjoint missing-bridge/odd-cycle obstruction witnesses, then deleting at most `epsilon |E|` hyperedges makes it obligatory.

The bounded-degree hypothesis is deliberate; without a sparsity condition, one obstruction can interact with many edges.

### Conjecture B — atom-forest stability after repair

If `d_B(F)=t`, then after deleting `t` hyperedges and taking the canonical atom forest of the repaired system, the original incidence structure can be represented as that forest plus at most `O(t)` exceptional hyperedges. Determine whether a universal linear bound is possible or construct a counterexample.

### Conjecture C — property testing in bounded degree

For bounded-degree incidence structures, membership in the reduced obligatory class may be testable with query complexity depending only on `epsilon`, because the intrinsic conditions are local except for odd-cycle parity. The graph bipartiteness-testing literature suggests the correct model and lower bounds need care.

None of these conjectures is claimed as proved.

## Concrete computational programme

1. Enumerate small linear triple systems and compute exact `d_B(F)` by branch-and-bound.
2. Record minimum obstruction transversals and maximum edge-disjoint obstruction packings.
3. Search for ratios that disprove naive linear packing/covering conjectures.
4. Separate bridge defects from odd-cycle defects to determine which one drives worst-case repair.
5. Test whether canonical atoms of optimal repairs are stable under one additional edge insertion/deletion.

## Potential theorem forms

The strongest desirable theorem would resemble a removal lemma:

> If a bounded-degree finite triple system is epsilon-far from obligatory, then it contains linearly many bounded-size certificates of non-obligatoriness.

A weaker but still useful result is a fixed-parameter algorithm for `d_B(F)` parameterized by the deletion budget or by the number of bad Levi incidences.

## Relation to the main paper

Do not put a conjectural stability section into the 593 manuscript. A short final paragraph may mention repair/stability as an open direction. Actual stability theorems should become a separate paper once there is a quantitatively nontrivial result.
