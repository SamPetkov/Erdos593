# Real-rooted decomposition polynomial and random coarsening law

## Scope

Fix a finite reduced obligatory triple system `F`.  Let

```text
D_F(z) = sum_P z^{|P|},
```

where the sum ranges over all supported one-point decompositions and `|P|` is the number of pieces.

The local decomposition-lattice product gives

```text
D_F(z)
 = z^c * product_p R_{mu_p}(z),
```

where

```text
R_m(z) = sum_{b=1}^m S(m,b) z^(b-1)
        = T_m(z)/z,
```

`T_m` is the Touchard polynomial, and `mu_p` is the number of canonical atoms through the shared point `p`.

The zero theory of `T_m` is classical.  Harper's 1967 work proves the real-rooted Stirling behavior used below.  The contribution here is the translation to the exact decomposition space of an obligatory triple system.

---

## 1. Real-rootedness

### Theorem 1.1 — decomposition polynomial has only nonpositive real zeros

All zeros of `D_F(z)` are real and nonpositive.  The zero at the origin has multiplicity `c`; every nonzero zero is negative.

#### Proof

Harper proved that

```text
T_m(z) = sum_b S(m,b) z^b
```

has one zero at `0` and all remaining zeros real and negative.  Therefore `R_m(z)=T_m(z)/z` has only negative real zeros.  The displayed product formula for `D_F` proves the result.

### Corollary 1.2 — Pólya-frequency and log-concavity

Put

```text
d_j(F) = #{ supported one-point decompositions into j pieces }.
```

Then the shifted coefficient sequence

```text
(d_c,d_{c+1},...,d_k)
```

is a Pólya-frequency sequence.  In particular it is ultra-log-concave, hence log-concave and unimodal.

No strictness is asserted in general.  For the all-binary profile the shifted polynomial is `(1+z)^(k-c)`, where the normalized Newton inequalities are equalities.

---

## 2. Exact Poisson--binomial representation

Choose a supported one-point decomposition uniformly from `D(F)`, and let `J_F` be its number of pieces.  Put

```text
N = k-c.
```

### Theorem 2.1

There exist independent Bernoulli variables

```text
X_1,...,X_N
```

with parameters in `(0,1)` such that

```text
J_F =_d c + X_1 + ... + X_N.
```

#### Proof

The probability generating polynomial of `J_F-c` is

```text
G_F(z)
 = z^(-c) D_F(z) / D_F(1)
 = product_p R_{mu_p}(z)/Bell(mu_p).
```

It has nonnegative coefficients, positive constant term, value one at `z=1`, and only negative real zeros.  Factor each normalized linear term corresponding to a root `-a`, `a>0`, as

```text
(z+a)/(1+a)
 = (1-p) + p z,
qquad p=1/(1+a).
```

There are exactly `N=sum_p(mu_p-1)` nonzero roots counted with multiplicity, giving the Bernoulli representation.

This is a distributional representation.  The Bernoulli variables are auxiliary; they are not claimed to correspond to independent physical choices at the shared points.

### Consequences

Writing

```text
sigma^2 = Var(J_F),
```

we obtain the standard Bernoulli-sum bound

```text
Var(J_F) <= N/4,
```

and, for `x>=0`,

```text
Pr(|J_F-E J_F| >= x)
  <= 2 exp( -x^2 / (2(sigma^2+x/3)) ).
```

Along any sequence of obligatory systems for which `Var(J_F)->infinity`, Lindeberg's condition is automatic and

```text
(J_F-E J_F)/sqrt(Var(J_F))
    => N(0,1).
```

This CLT needs the variance-divergence hypothesis; no unconditional growing-system normal limit is claimed.

---

## 3. Exact mean and variance

For a uniformly random partition of an `m`-set, let `B_m` be its number of blocks.  Standard Bell-number identities give

```text
E B_m
  = Bell(m+1)/Bell(m) - 1,
```

and

```text
Var(B_m)
  = Bell(m+2)/Bell(m)
    - (Bell(m+1)/Bell(m))^2
    - 1.
```

The local-product theorem makes the block counts at distinct shared points independent under the uniform measure on global decompositions.  Therefore

```text
J_F =_d c + sum_p (B_{mu_p}-1),
```

with independent local variables, and

```text
E J_F
 = c + sum_p [ Bell(mu_p+1)/Bell(mu_p) - 2 ],
```

```text
Var(J_F)
 = sum_p [
     Bell(mu_p+2)/Bell(mu_p)
     - (Bell(mu_p+1)/Bell(mu_p))^2
     - 1
   ].
```

The first representation by independent set-partition block counts is combinatorially transparent; the Bernoulli representation is stronger for concentration and limit theory.

---

## 4. Two endpoint laws

The sharp extremal attachment profiles give two familiar probability laws.

### All-binary shared points

If every shared point has multiplicity two, there are `N` shared points and

```text
R_2(z)=1+z.
```

Hence

```text
J_F-c ~ Binomial(N,1/2).
```

### One common shared point

If one shared point carries all forest excess, then `mu=N+1` and

```text
J_F-c =_d B_{N+1}-1,
```

where `B_{N+1}` is the number of blocks in a uniformly chosen set partition of an `(N+1)`-set.  This is Harper's classical Stirling distribution.

Thus the two sharp geometries interpolate between binomial coarsening and uniform-set-partition (Stirling) coarsening.

---

## 5. Comparison with the random-attachment law

This probability space must not be confused with the occupancy law in `ATTACHMENT_OCCUPANCY_COLLAPSE.md`.

- **Random attachment law:** fix a labelled atom list and choose uniformly among distinct admissible quotient assemblies; the number of shared points follows an occupancy distribution.
- **Random coarsening law here:** fix one already assembled obligatory system and choose uniformly among all valid coarser one-point decompositions; the number of pieces is a product-Stirling / Poisson--binomial variable.

These are different random objects with different normalizations.

---

## 6. Literature boundary

The required root theorem and classical Stirling asymptotics are due to

L. H. Harper, *Stirling Behavior is Asymptotically Normal*, Annals of Mathematical Statistics 38(2) (1967), 410--414, DOI 10.1214/aoms/1177698956.

Real-rootedness-to-Bernoulli-sum consequences are standard Pólya-frequency theory; see, for example, Jim Pitman, *Probabilistic bounds on the coefficients of polynomials with only real zeros*, Journal of Combinatorial Theory A 77 (1997), 279--303.

No novelty claim is made for those classical results.  The 593-specific statement is that the complete one-point decomposition polynomial of an obligatory triple system factors into exactly these Stirling rows according to its canonical shared-point multiplicities.

---

## 7. Publication recommendation

This is elegant supplementary mathematics, but it should not enlarge the main Erdős 593 proof.  If the decomposition-lattice spectrum is included, one sentence noting real-rootedness/unimodality is enough.  The Poisson--binomial law and limit theory fit better in the research extension or a later enumerative/structural paper.
