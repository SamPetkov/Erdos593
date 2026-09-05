# Exact global spectrum of one-point decomposition lattices

## Purpose

This note combines three results already developed in the repository:

1. the exact global canonical atom-count spectrum;
2. the realization of every shared-point excess profile at fixed atom count; and
3. the product formula for the complete one-point decomposition lattice.

The result is an exact phase diagram for the **entire lattice of supported one-point decompositions** at fixed global invariants `(s,beta,c)`.

The partition-lattice algebra is classical; the content here is the exact spectrum forced by the Erdős 593 block/atom classification.

---

## 1. Parameters

Let `F` be a finite reduced obligatory triple system with at least one hyperedge.  Write

```text
m     = |E(F)|,
n     = |V(F)|,
c     = number of connected components,
s     = n-m,
beta  = 2m-n+c,
k     = number of canonical atoms,
N     = k-c.
```

Thus `N` is the rank of the one-point decomposition lattice: it is the total forest excess

```text
N = sum_p (mu(p)-1).
```

Put

```text
q(r) = ceil(2 sqrt(r)).
```

Let `p(N)` denote the integer partition number, with `p(0)=1`, and let `Bell(r)` be the Bell number.

For a partition

```text
lambda=(lambda_1,...,lambda_t) |- N,
```

write

```text
L_lambda = product_i Pi_{lambda_i+1},
```

where `Pi_j` is the ordinary partition lattice on `j` elements.  For `N=0`, `lambda` is empty and `L_empty` is the one-element lattice.

---

## 2. Exact rank spectrum

The global atom-count theorem translates immediately from `k` to `N=k-c`.

### Theorem 2.1 — decomposition-lattice rank spectrum

For every feasible `(s,beta,c)`, the possible values of `N` are exactly

```text
beta = 0:
    N = s-2c;

beta = 1:
    0 <= N <= s-2c-2,
    N == s-2c (mod 2);

beta >= 2:
    0 <= N <= s-2c-q(beta).
```

For `beta>=2` this is a complete interval.  The rank-one parity obstruction is the only gap phenomenon.

#### Proof

Subtract `c` from the exact global atom-count spectrum

```text
beta=0:  k=s-c;
beta=1:  c<=k<=s-c-2 and k==s-c (mod 2);
beta>=2: c<=k<=s-c-q(beta).
```

No additional argument is required.

---

## 3. Exact lattice-isomorphism spectrum

### Theorem 3.1 — complete decomposition-lattice spectrum

Fix a feasible `(s,beta,c)`.  For every admissible rank `N` from Theorem 2.1, the possible one-point decomposition lattices are exactly

```text
{ L_lambda : lambda |- N }.
```

Different partitions `lambda` give nonisomorphic lattices.  Consequently the exact number of lattice isomorphism types is

```text
beta = 0:
    p(s-2c);

beta = 1:
    sum p(N),
    over 0<=N<=s-2c-2 with N == s-2c (mod 2);

beta >= 2:
    sum_{N=0}^{s-2c-q(beta)} p(N).
```

#### Proof

At a fixed admissible `N`, choose any obligatory system with `k=N+c` atoms and the prescribed global parameters; existence is the atom-count theorem.  The shared-point multiplicity realization theorem says that, for that fixed atom list and component count, every partition

```text
lambda |- N
```

is realized by a capacity-safe forest reassembly without changing `(s,beta,c,k)`.

The local decomposition-lattice product theorem identifies the resulting lattice with

```text
L_lambda = product_i Pi_{lambda_i+1}.
```

Conversely every system gives such a partition `lambda` of `N`, so there are no other lattices.

Distinct `lambda` at fixed `N` are distinguished by the characteristic polynomial: the multiplicity of the root `j` is exactly the number of parts `lambda_i>=j`.  Lattices with different `N` have different rank.  Therefore all listed lattice types are pairwise nonisomorphic and the counting formulas follow.

### Interpretation

The coarse parameters `(s,beta,c)` determine an exact finite family of possible **factorization geometries**.  The only rank gap is the same unicyclic parity obstruction already visible in the atom-count spectrum; within any allowed rank, every partition-lattice product occurs.

---

## 4. Sharp number-of-decompositions envelope

Let

```text
H_0 = s-2c,
H_1 = s-2c-2,
H_beta = s-2c-q(beta)  (beta>=2).
```

All these quantities are nonnegative in their feasible regimes.

The sharp fixed-rank bound is

```text
2^N <= |D(F)| <= Bell(N+1),
```

with the all-binary and one-common-point profiles as the unique endpoints for `N>=2`.

Combining this with the rank spectrum gives the following exact global envelope.

### Theorem 4.1 — extrema at fixed `(s,beta,c)`

For `beta=0`,

```text
2^(s-2c)
    <= |D(F)|
    <= Bell(s-2c+1).
```

For `beta=1`,

```text
2^(s mod 2)
    <= |D(F)|
    <= Bell(s-2c-1).
```

Here `s mod 2` is `0` or `1`; thus the lower endpoint is `1` for even `s` and `2` for odd `s`.

For `beta>=2`,

```text
1
    <= |D(F)|
    <= Bell(s-2c-q(beta)+1).
```

Every displayed endpoint is attained.

#### Proof

The function `Bell(N+1)` is strictly increasing in `N`, and `2^N` is increasing as well.  Therefore the global maximum occurs at the largest admissible rank and the global minimum at the smallest admissible rank, except in the `beta=0` line where the rank is fixed.

For `beta=1`, the smallest admissible rank has the parity of `s-2c`, hence is `0` for even `s` and `1` for odd `s`.  For `beta>=2` it is zero.

At a fixed rank the binary and concentrated profiles are both realizable, so the fixed-rank endpoint bounds are sharp.  Substitution yields the formulas.

### Structural endpoint description

At maximum rank, the atom-count rigidity theorem already forces one minimum-order cyclic atom carrying the whole positive cycle rank (when `beta>0`), with all remaining atoms single triples.  Within that fixed atom list:

- the **minimum** number of coarser decompositions occurs when every attachment point is binary;
- the **maximum** occurs when the complete attachment excess inside the nontrivial component is concentrated at one shared point.

Thus the two extremal decomposition geometries are explicit.

---

## 5. Möbius and maximal-chain envelopes

The same synthesis gives sharp secondary invariants.

For fixed lattice rank `N`,

```text
1 <= |mu_D(0,1)| <= N!,
```

and

```text
N! <= M(D) <= N!(N+1)!/2^N,
```

where `M(D)` is the number of maximal refinement chains.

Therefore the maximum possible Möbius magnitude at fixed `(s,beta,c)` is `H!`, and the maximum possible number of maximal chains is

```text
H!(H+1)!/2^H,
```

where

```text
H = s-2c              if beta=0,
H = s-2c-2            if beta=1,
H = s-2c-q(beta)      if beta>=2.
```

The maxima are realized by the one-common-point profile at maximum atom count.  The minimum Möbius magnitude is always `1`; the minimum chain count is `H!` in the acyclic line `beta=0` (fixed rank), and `1` in every positive-rank line because the smallest admissible rank is `0` or `1`.

---

## 6. Manuscript value

This theorem is much more tightly connected to Erdős 593 than the abstract block-theory reformulation.  It says that once the global order/size/component data and Levi cycle rank are fixed, the classification determines **exactly which one-point factorization lattices can occur**.

A compact manuscript corollary could state only Theorems 2.1 and 3.1.  The Bell envelopes and Möbius/chain formulas are better suited to an appendix or follow-up.

The novelty boundary should remain explicit:

- partition lattices, bond lattices, Bell numbers and their Möbius functions are classical;
- hypergraph block decompositions are classical;
- the contribution under review is the exact spectrum obtained by combining these tools with the obligatory-system atom classification, the exact atom-count theorem, and the capacity-safe attachment realization theorem.

---

## 7. Verification

`experiments/verify_global_decomposition_lattice_spectrum.py` checks the arithmetic interfaces over a deterministic range of feasible parameters.  It verifies:

1. the translated rank spectrum from the atom-count formulas;
2. the explicit count of lattice isomorphism types;
3. the Bell-number endpoint formulas; and
4. the Möbius and maximal-chain envelopes.

The check is arithmetic support for the theorem interfaces; the proof is the combination above.
