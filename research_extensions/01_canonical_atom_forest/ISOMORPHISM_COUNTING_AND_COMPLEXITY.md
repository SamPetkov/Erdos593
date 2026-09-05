# Isomorphisms, automorphisms, and the local complexity boundary

## Purpose

The functorial canonical forest separates the global tree-like geometry of an obligatory triple system from the internal isomorphism problem of its 2-connected bipartite atoms.  This note makes that separation exact.

The main results are:

1. an exact product-sum formula for the number of isomorphisms between two systems;
2. the automorphism exact sequence as a corollary rather than a definition-driven statement;
3. a canonical-center recursion for canonization; and
4. a complexity boundary showing that graph-isomorphism hardness already occurs inside one cyclic atom.

The last item uses a standard external GI-hardness input and is not needed for the Erdős 593 classification.

---

## 1. Port-compatible local isomorphisms

Let `F,G` be finite reduced obligatory triple systems.  Let `Q(F),Q(G)` be their canonical atom--shared-point forests.

For an atom `A` of `F`, define its port set

```text
P_A = S(F) intersect V(A).
```

Let `theta : Q(F) -> Q(G)` be a type-preserving forest isomorphism.  Define

```text
Iso_A(theta)
```

to be the set of atom isomorphisms

```text
f : A -> theta(A)
```

such that

```text
f(p) = theta(p)
```

for every port `p in P_A`.  Write

```text
n_A(theta) = |Iso_A(theta)|.
```

If no such local isomorphism exists, `n_A(theta)=0`.

---

## 2. Exact isomorphism-count formula

### Theorem 2.1

For finite reduced obligatory triple systems `F,G`,

```text
|Iso(F,G)|
  = sum_{theta in Iso_bip(Q(F),Q(G))}
      product_{A in A(F)} n_A(theta).
```

Here `Iso_bip` denotes forest isomorphisms preserving the atom/shared-point bipartition.

#### Proof

Every global triple-system isomorphism induces, by functoriality, one unique type-preserving forest isomorphism `theta`.  Its restrictions to the canonical atoms belong to the corresponding sets `Iso_A(theta)`.

Conversely fix `theta` and choose independently one element of `Iso_A(theta)` for every atom `A`.  Whenever two atoms overlap, they overlap in one shared point `p`, and both local maps send that point to the prescribed point `theta(p)`.  Hence all local maps agree on every overlap.  Exact reconstruction therefore glues them to one global triple-system isomorphism inducing `theta`.

Different local tuples give different global maps, and different `theta` give disjoint classes of global maps.  Summing the product counts proves the formula.

### Interpretation

There is no hidden global compatibility condition beyond the port conditions.  All global symmetry coupling is carried by the finite forest isomorphism `theta`; once `theta` is fixed, the choices inside distinct atoms are independent.

---

## 3. Automorphism formula and exact sequence

For an atom `A` of `F`, put

```text
K_A = Aut(A; P_A pointwise).
```

If `theta` is a forest automorphism for which `Iso_A(theta)` is nonempty, then any chosen `f_0 in Iso_A(theta)` identifies

```text
Iso_A(theta) = f_0 K_A,
```

so

```text
n_A(theta) = |K_A|.
```

Let

```text
Aut_dec(Q(F))
```

be the set of type-preserving forest automorphisms `theta` for which `n_A(theta)>0` for every atom `A`.  The preceding observation shows this is exactly the image of `Aut(F)` on the canonical forest.

### Corollary 3.1

```text
|Aut(F)|
  = |Aut_dec(Q(F))| * product_A |K_A|.
```

Moreover restriction gives a short exact sequence

```text
1 -> product_A K_A -> Aut(F) -> Aut_dec(Q(F)) -> 1.
```

#### Proof

The counting formula with `G=F` gives the order formula.  The kernel consists precisely of global automorphisms fixing every atom node and every shared-point node.  Such a map restricts independently to an element of `K_A` on each atom, and conversely all those local automorphisms glue because they fix every overlap point.  This identifies the kernel and proves exactness.

No canonical splitting is claimed.  A semidirect-product statement would require coherent group-theoretic choices of lifts of decorated-forest automorphisms.

---

## 4. Canonical center and recursive canonization

For a connected `F`, the canonical forest `Q(F)` is a tree.  Root it at its canonical center.  If the center is an edge, the atom endpoint and shared-point endpoint have different types and therefore cannot be exchanged by a type-preserving automorphism.

This gives a choice-free rooted decomposition object.

### Canonization reduction

Suppose one has a canonization procedure for a canonical atom with distinguished ports carrying finite colours.  Then a canon for `F` can be computed bottom-up on the rooted tree:

1. a shared-point node receives the sorted multiset of the canonical codes of its child atom subtrees;
2. at an atom node, colour each child port by the code of the corresponding child shared-point subtree and distinguish the parent port, if present;
3. canonize that port-coloured atom and use the result as the atom-subtree code;
4. continue to the center.

For a forest, canonize each connected component and sort the component codes.

Thus canonization of the whole obligatory system reduces to canonization of **port-coloured canonical atoms** plus ordinary tree sorting.  The global one-point assembly introduces no additional hard isomorphism mechanism.

This is a reduction statement, not a claim that arbitrary atom canonization is easy.

---

## 5. The hard part already occurs in one atom

A cyclic canonical atom has the form `J^+`, where `J` is a finite 2-connected simple bipartite graph.

### Lemma 5.1 — the core is intrinsic when `delta(J)>=2`

If `J` has minimum degree at least two, then in `J^+`:

- every core vertex has hypergraph degree at least two;
- every private expansion vertex has hypergraph degree one.

Therefore every triple-system isomorphism `J^+ -> K^+` maps core vertices to core vertices and restricts to a graph isomorphism `J -> K`.  Conversely every graph isomorphism `J -> K` extends uniquely to an isomorphism of the expansions by sending the private point of edge `e` to the private point of its image edge.

Hence

```text
J^+ ~= K^+  iff  J ~= K
```

for 2-connected `J,K`, and

```text
Aut(J^+) ~= Aut(J).
```

### Complexity corollary 5.2 — GI-hardness is local

Standard graph-isomorphism literature records that general Graph Isomorphism reduces to isomorphism on highly connected regular bipartite graphs; in particular Babai's Handbook of Combinatorics chapter lists `k`-connected regular bipartite graphs among GI-complete target classes.

For any such graph with `k>=2`, the expansion `J^+` is a connected reduced obligatory triple system consisting of a **single canonical cyclic atom**.  Lemma 5.1 shows that the expansion preserves and reflects isomorphism.

Consequently, using that standard external hardness input, isomorphism of finite obligatory triple systems is GI-hard already on one-atom systems.  Since finite 3-uniform hypergraph isomorphism reduces polynomially to ordinary graph isomorphism through the incidence graph (with the two sides distinguished by standard colour gadgets), the problem is GI-complete.

### Source boundary

The external complexity input should be cited rather than reproved in the Erdős paper:

L. Babai, *Automorphism Groups, Isomorphism, Reconstruction*, Chapter 27 in **Handbook of Combinatorics**, Vol. 2, Elsevier, 1995, pp. 1447--1540.  The chapter explicitly records reductions of general isomorphism to classes including `k`-connected regular bipartite graphs.

The new deduction here is only the transfer through the obligatory expansion `J -> J^+` and the observation that the canonical forest isolates, rather than removes, that local hardness.

This complexity corollary belongs in a structural follow-up or appendix, not in the statement of Erdős Problem 593.

---

## 6. What the decomposition does and does not solve

The results give a sharp separation:

```text
global structure:
    canonical forest, exact reconstruction, tree recursion

local structure:
    port-coloured 2-connected bipartite atom isomorphism
```

So the canonical decomposition has genuine algorithmic content even though worst-case isomorphism remains GI-complete:

- repeated subassemblies can be hashed and compared bottom-up;
- all separator geometry is handled in linear graph time;
- automorphism counts factor once the decorated forest action is known;
- hard instances cannot be blamed on complicated global one-point gluing, because one atom already contains them.

This is analogous in spirit to classical block-cut decompositions: decomposition is valuable because it localizes difficult structure, not because every block problem becomes trivial.

---

## 7. Publication recommendation

For the main Erdős 593 manuscript, keep only the decorated-forest isomorphism criterion if space permits.  The exact isomorphism count and GI-completeness boundary are mathematically useful but change the paper's emphasis toward algorithms and symmetry.

For a structural follow-up, the strongest package is:

1. point-separator characterization of atoms;
2. universal finest one-point factorization;
3. bond-lattice classification of all coarsenings;
4. exact isomorphism/automorphism factorization; and
5. localization of GI hardness to a single atom.

Together these turn the canonical atom theorem into a complete **decomposition theory**, rather than another normal-form statement.
