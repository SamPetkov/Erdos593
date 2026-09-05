# Sharp extremal geometry of one-point decompositions

## Scope

Fix a finite reduced obligatory triple system with `k` canonical atoms and `c` connected components, and put

```text
N = k-c.
```

Its shared-point excess profile is a partition

```text
lambda=(lambda_1,...,lambda_t) |- N,
qquad lambda_i = mu_i-1,
```

where `mu_i` is the number of atoms through the corresponding shared point.

The local-product theorem gives

```text
D(F) ~= product_i Pi_{lambda_i+1}.
```

Because every partition `lambda |- N` is realizable for any fixed list of `k` canonical atom types and any prescribed `c`, the extremal statements below are sharp structural theorems, not merely inequalities on an abstract product.

---

## 1. Number of one-point decompositions

The total number is

```text
|D(F)| = product_i Bell(lambda_i+1).
```

### Theorem 1.1 — sharp decomposition-count bounds

For `N>=1`,

```text
2^N <= |D(F)| <= Bell(N+1).
```

The lower equality holds exactly when

```text
lambda = (1,1,...,1),
```

that is, every shared point has multiplicity two.

The upper equality holds exactly when

```text
lambda = (N),
```

that is, one shared point is incident with all `N+1` atoms of the nontrivial attachment component and carries the entire forest excess.

Both equality patterns are realizable.

#### Proof of the lower bound

For `r>=1`,

```text
Bell(r+1) >= 2^r.
```

Indeed distinguish one element `0`; for each subset `S` of the other `r` elements take the partition whose distinguished block is `{0} union S` and whose remaining elements are singletons.  This gives `2^r` distinct set partitions.  If `r>=2`, there are additional partitions, for example one having a two-element block disjoint from `0`, so equality occurs only at `r=1`.

Multiplying with `sum_i lambda_i=N` gives the lower bound and its equality condition.

#### Proof of the upper bound

Let disjoint sets `X_i` have cardinality `lambda_i`, and add a distinguished point `0_i` to each.  Given independently one partition of every `X_i union {0_i}`, identify all the distinguished points `0_i` to one point `0` and merge the blocks that contained them.  All other blocks remain unchanged.

This defines an injection

```text
product_i Pi_{lambda_i+1} -> Pi_{N+1}.
```

The map is injective because restricting the resulting partition to `X_i union {0}` recovers the original local partition.  Hence the Bell-number product is at most `Bell(N+1)`.

If there are at least two positive parts, a partition containing a block that mixes elements of two different `X_i` but does not contain `0` is outside the image, so the inequality is strict.  This proves the equality condition.

### Interpretation

At fixed atom list, the most tree-like attachment pattern (all binary shared points) has the fewest valid coarsenings.  Concentrating all attachment excess at one shared point has the most.

This is about the **lattice of decompositions of a fixed assembled system**, not the number of different assemblies producing that system.

---

## 2. Möbius extremum

The product formula gives

```text
|mu_D(0,1)| = product_i lambda_i!.
```

### Corollary 2.1

```text
1 <= |mu_D(0,1)| <= N!.
```

The lower equality holds exactly for the all-binary profile `(1^N)`, and the upper equality holds exactly for the one-point profile `(N)`.

#### Proof

The lower statement is immediate.  For the upper bound,

```text
N! / product_i lambda_i!
```

is the multinomial coefficient counting ordered allocations of an `N`-set into labelled cells of sizes `lambda_i`, and is therefore an integer at least one.  It is one only for a single nonzero cell.

---

## 3. Maximal binary coarsening schedules

A maximal chain of the decomposition lattice records a sequence starting from the canonical atom partition and merging exactly two current pieces at every step until each connected component has become one piece.

From the local-product theorem,

```text
M(F)
 = N! * product_i (lambda_i+1)! / 2^N.
```

### Theorem 3.1 — sharp schedule bounds

```text
N!
  <= M(F)
  <= N!(N+1)! / 2^N.
```

The lower equality holds exactly for the all-binary profile `(1^N)`; the upper equality holds exactly for the one-point profile `(N)`.

#### Proof of the lower bound

For every integer `r>=1`,

```text
(r+1)! >= 2^r,
```

with equality only at `r=1`.  Multiplication gives

```text
product_i (lambda_i+1)! >= 2^N,
```

which proves the lower bound and its equality statement.

#### Proof of the upper bound

For positive `a,b`,

```text
(a+1)!(b+1)! <= (a+b+1)!.
```

For example, after division by `(a+1)!(b+1)!`, the right-hand side is a positive binomial-type product and is strictly larger than one.  Repeatedly merging parts of `lambda` gives

```text
product_i (lambda_i+1)! <= (N+1)!,
```

with equality only when there is one part.  Substitute into the exact chain formula.

### Endpoint geometries

- Binary attachments give `D(F)` a Boolean-lattice factorization `Pi_2^N`; their maximal chains are exactly the `N!` possible orders in which the `N` independent binary joins are performed.
- One common shared point gives `D(F) ~= Pi_{N+1}` and therefore `N!(N+1)!/2^N` maximal merge chains.

---

## 4. Uniform random coarsening

The product theorem also gives a simple probability law on the **decompositions of one fixed system**.

Choose a supported one-point decomposition uniformly from `D(F)`.  For each shared point `p`, let `B_p` be the number of blocks in a uniformly random partition of its `mu_p` incident atoms.  Then the variables `B_p` are independent and

```text
Pr(B_p=b) = S(mu_p,b) / Bell(mu_p).
```

If `J` is the number of pieces in the global decomposition, then

```text
J = c + sum_p (B_p-1)
```

in distribution.

Consequently

```text
E[J]
 = c + sum_p ( Bell(mu_p+1)/Bell(mu_p) - 2 ).
```

Using the standard second factorial moment of the number of blocks in a random set partition,

```text
Var(J)
 = sum_p [
     Bell(mu_p+2)/Bell(mu_p)
     - (Bell(mu_p+1)/Bell(mu_p))^2
     - 1
   ].
```

This probability law is different from the uniform-random **attachment** law studied elsewhere in the repository.  Here the assembled system is fixed and one chooses uniformly among its valid coarser decompositions.

---

## 5. Verification

`experiments/verify_decomposition_lattice_extrema.py` enumerates every integer partition of `N` through `N=12` and checks the exact lower and upper endpoints for:

- the Bell-product decomposition count;
- the Möbius magnitude; and
- the maximal-chain count.

It also checks the endpoint uniqueness conditions.  This arithmetic audit is supplementary; the inequalities above have direct proofs.
