# Local product structure of the full decomposition lattice

## Scope

The universal one-point factorization identifies the poset of supported one-point forest decompositions of a reduced obligatory triple system `F` with the bond lattice of its atom intersection block graph `B(F)`.

For this special block graph the bond lattice factors completely.  The factorization makes the entire hierarchy of coarser decompositions depend only on the multiplicities of the shared points, not on the atom types or on how the shared points are arranged in the canonical forest.

Throughout, let

```text
k = number of canonical atoms,
c = number of connected components,
S(F) = set of shared points,
mu_p = number of canonical atoms containing p.
```

The canonical incidence forest gives

```text
sum_{p in S(F)} (mu_p - 1) = k - c.
```

Write `Pi_m` for the ordinary partition lattice of an `m`-element set, and `Bell(m)` for the `m`th Bell number.

The partition-lattice and bond-lattice identities used below are classical.  The contribution under review is their exact realization as the decomposition lattice of obligatory triple systems.

---

## 1. Direct-product theorem

Let `D(F)` denote the lattice of supported one-point forest decompositions from `POINT_SEPARATOR_UNIVERSALITY.md`, ordered by refinement.

### Theorem 1.1 — local partition product

There is a canonical lattice isomorphism

```text
D(F)  ~=  product_{p in S(F)} Pi_{mu_p}.
```

For a system with no shared points, the empty product is the one-element lattice.

#### Proof

By the universal decomposition theorem, `D(F)` is the bond lattice of the atom intersection graph `B(F)`.  Proposition 4.1 there shows that `B(F)` is a block graph whose nontrivial graph blocks are exactly the cliques

```text
C_p = { A : p in V(A) } ~= K_{mu_p}.
```

We give a direct form of the product map.

Let `Pi` be a connected set partition of `B(F)`.  Restrict its equivalence relation to each clique `C_p`.  This produces an arbitrary set partition

```text
Pi_p in Pi(C_p).
```

Thus restriction defines a map

```text
R : D(F) -> product_p Pi(C_p).
```

Conversely choose independently one partition `sigma_p` of each `C_p`.  On the atom set, generate an equivalence relation by declaring two atoms equivalent whenever they lie in the same block of some `sigma_p`.  Equivalently, form a spanning subgraph `H_sigma` of `B(F)` by replacing every clique `C_p` with the disjoint union of the complete subgraphs on the blocks of `sigma_p`; take the connected components of `H_sigma` as the global partition.

Every global block is connected in `B(F)`, so this gives an element of the bond lattice.  It remains only to show that restriction recovers each prescribed `sigma_p`.

Suppose two vertices of one clique `C_p`, placed in different blocks of `sigma_p`, became connected in `H_sigma`.  Choose a shortest `H_sigma`-path between such a pair.  The path cannot lie wholly inside one local block of `C_p`, so together with the original edge of the clique joining its endpoints it contains a graph cycle using an edge from outside the single block clique `C_p`.  But every cycle of the block graph `B(F)` lies in one graph block, and its graph blocks are precisely the cliques `C_q`.  This is impossible.  Hence no local blocks are accidentally identified.

The two constructions are inverse.  They plainly preserve refinement coordinatewise, proving the lattice isomorphism.

### Matroid interpretation

Equivalently, the bond lattice is the flat lattice of the graphic matroid of `B(F)`.  Since every graphic circuit lies in a single graph block, this matroid is the direct sum of the cycle matroids of the cliques `K_{mu_p}`.  The flat lattice of `M(K_m)` is `Pi_m`, and flat lattices turn direct sums into direct products.  This gives a short classical proof of the same factorization.

---

## 2. Exact decomposition polynomial

Let

```text
D_F(z) = sum_P z^(number of pieces of P),
```

where the sum ranges over all supported one-point forest decompositions of `F`.

For `m>=1` put

```text
R_m(z) = sum_{b=1}^m S(m,b) z^(b-1),
```

where `S(m,b)` is a Stirling number of the second kind.  Thus `z R_m(z)` is the ordinary Touchard polynomial.

### Corollary 2.1 — product formula

```text
D_F(z)
  = z^c * product_{p in S(F)} R_{mu_p}(z).
```

In particular,

```text
|D(F)| = product_p Bell(mu_p).
```

#### Proof

A local partition of `C_p` into `b_p` blocks has `S(mu_p,b_p)` choices.  Under the product theorem, the resulting global decomposition has

```text
j = c + sum_p (b_p - 1)
```

pieces.  Indeed its lattice rank is

```text
k-j = sum_p (mu_p-b_p),
```

and the forest identity `sum_p(mu_p-1)=k-c` gives the displayed expression for `j`.  Multiplying the independent local generating functions proves the formula.  Setting `z=1` gives the Bell-number product.

### Consequence — arrangement independence

The number of decompositions into each possible number of pieces depends only on

```text
c and the multiset {mu_p : p in S(F)}.
```

It is completely independent of:

- the isomorphism types of the canonical atoms;
- which vertices of those atoms are used as ports; and
- the arrangement of the shared points in the canonical forest.

The arrangement remains essential for reconstructing `F`; it is invisible only to this decomposition-lattice statistic.

---

## 3. Möbius and characteristic polynomial

Put

```text
R = k-c = sum_p(mu_p-1).
```

The ordinary partition lattice satisfies

```text
mu_{Pi_m}(0,1) = (-1)^(m-1) (m-1)!,
chi_{Pi_m}(t) = product_{j=1}^{m-1} (t-j).
```

Möbius functions and characteristic polynomials multiply under direct products.

### Corollary 3.1

The top-bottom Möbius invariant of the decomposition lattice is

```text
mu_D(0,1)
  = (-1)^R * product_p (mu_p-1)!.
```

Its characteristic polynomial is

```text
chi_D(t)
  = product_{p in S(F)} product_{j=1}^{mu_p-1} (t-j).
```

### Corollary 3.2 — the characteristic polynomial recovers the multiplicity profile

Let `a_j` be the multiplicity of the root `t=j` in `chi_D(t)`.  Then

```text
a_j = #{ p : mu_p >= j+1 }.
```

Consequently

```text
#{p : mu_p=m} = a_{m-1} - a_m,
```

where `a_m=0` beyond the largest root.

Thus the characteristic polynomial of the decomposition lattice determines the complete shared-point multiplicity profile.

This is stronger than the numerical Bell-product formula: no information about the multiset of multiplicities is lost by passing to `chi_D`.

---

## 4. Maximal refinement chains

A maximal chain in `D(F)` starts at the canonical atom decomposition and finishes at the decomposition into connected components.  Every cover merges exactly two current pieces along a valid one-point connection.

The partition lattice `Pi_m` has

```text
m!(m-1)! / 2^(m-1)
```

maximal chains: when `r` blocks remain, choose the two blocks to merge, and multiply `binom(r,2)` for `r=m,m-1,...,2`.

For a direct product, maximal chains are obtained by choosing a maximal chain in every factor and interleaving the factor steps.

### Corollary 4.1 — exact number of binary coarsening schedules

```text
M(F)
 = (k-c)! * product_p mu_p! / 2^(k-c).
```

This counts maximal chains of decomposition *partitions*.  It should not be conflated with every possible implementation-level history in which atoms or vertices carry additional labels.

---

## 5. Exact spectrum of decomposition-lattice types

Write the excess multiplicity profile as

```text
lambda(F) = sort_{>=} { mu_p-1 : p in S(F) }.
```

Then `lambda(F)` is a partition of `k-c`.  The product theorem becomes

```text
D(F) ~= product_i Pi_{lambda_i+1}.
```

The earlier shared-point multiplicity theorem proves that for any fixed list of `k` canonical atom types and any `1<=c<=k`, **every** integer partition

```text
lambda |- k-c
```

is realizable by a capacity-safe forest assembly.

### Theorem 5.1 — exact decomposition-lattice spectrum at fixed `(k,c)`

The possible decomposition lattices are exactly

```text
L_lambda = product_i Pi_{lambda_i+1},
    lambda |- k-c.
```

Two different partitions `lambda` give nonisomorphic lattices, because their characteristic polynomials have different root-multiplicity profiles by Corollary 3.2.

Therefore the exact number of isomorphism types is

```text
p(k-c),
```

where `p` is the integer partition function (with `p(0)=1`).

### Global invariant version

If `K(s,beta,c)` is the exact canonical atom-count set from the structural spectrum, then at fixed feasible `(s,beta,c)` the number of possible decomposition-lattice isomorphism types is

```text
sum_{k in K(s,beta,c)} p(k-c).
```

Ranks `k-c` differ when `k` differs, so the contributions from different atom counts are automatically nonisomorphic.

This recovers the earlier count of shared-point multiplicity profiles, but upgrades it from a list of integer partitions to a classification of the **entire one-point decomposition lattices**.

---

## 6. Relation to classical bond-lattice theory

The graph-theoretic ingredients are standard:

- connected set partitions form the bond lattice / lattice of contractions;
- partition lattices have the displayed Möbius and characteristic-polynomial formulas;
- direct products multiply these invariants.

For connected set partitions and splitting at separators, see:

F. Simon, P. Tittmann and M. Trinks, *Counting Connected Set Partitions of Graphs*, Electronic Journal of Combinatorics 18 (2011), P14, DOI 10.37236/501.

The research content under review is the structural bridge

```text
obligatory triple system
    -> canonical atom block graph
    -> product of local partition lattices,
```

and the resulting exact classification in terms of shared-point multiplicities.

---

## 7. Verification

`experiments/verify_decomposition_lattice_product.py` checks the product theorem independently on every small system used in the exhaustive universal-refinement audit.  It enumerates the full connected-partition lattice directly and verifies:

1. the coefficient-by-coefficient decomposition-polynomial product;
2. the Bell-number total;
3. the Möbius top-bottom product formula; and
4. the maximal-chain formula.

The committed deterministic run checks 56 small systems for each of these four identities, with no failure.

The formulas are theorems; finite enumeration validates the implementation and catches convention errors.
