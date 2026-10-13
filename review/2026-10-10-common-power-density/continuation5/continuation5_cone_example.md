# A signed, noncentral four-band host at every target tuple

**Scope.** This reuses the exact eight-state host from
[PR #60](../continuation4/continuation4_tensor_example.md). The host is not
newly discovered. The result proved here extends its quantitative bound
from the earlier reflection boundary to **all six positive exponents**,
using [the common-cone projection transfer](continuation5_cone_theorem.md).
It does not settle the unrestricted target or claim exclusion from every
previous sufficient class or local neighborhood.

## Exact original data

On four coarse states let

\[
\pi=(1/2,1/4,1/8,1/8),\qquad
S_0=\begin{pmatrix}
7/4&1/4&1/4&1/4\\
1/4&7/2&0&0\\
1/4&0&7&0\\
1/4&0&0&7
\end{pmatrix},
\]

\[
Q=\frac1{19}\begin{pmatrix}
32&-8&8&24\\
-8&40&-40&32\\
8&-40&40&-32\\
24&32&-32&56
\end{pmatrix},\qquad
S=\frac{15}{16}S_0+\frac1{16}\Pi.
\tag{1}
\]

Set `H=Q/64`, `beta=1/4096`. On the original fine law
`mu(i,sigma)=pi_i/2`, an actual host is

\[
\boxed{W((i,\sigma),(j,\rho))
=\frac{76}{507}\left[S(i,j)+\frac{Q(i,j)}{64}\sigma\rho\right],
\qquad p=\frac{76}{507}.}
\tag{2}
\]

The projection is certified directly by `Q diag(pi) Q=Q`, symmetry and
`sum_i pi_i Q(i,i)=2`. Equivalently its two-column Gram representation
uses rows `(1,0),(-1,1),(1,-1),(0,1)` and Gram inverse
`(1/19)[[32,24],[24,56]]`. Therefore `H^2=beta Q` in the original law.

Every weighted row of `S` is one. Its signed lift satisfies `|H|<=S`, and

\[
\min W=\frac3{676}>0,\qquad \max W=1,
\qquad \max T^2=\frac{861135}{155648}>4.
\tag{3}
\]

Averaging the target sign removes `H`, so each original-`mu` row sum of
`W` is exactly `p`. This supplies the single actual nonnegative Markov
root required by the target.

This is not an entrywise nonnegative or centered channel in disguise:

\[
Q1=(18,5,-5,23)^T/19,\quad
Q_{01}Q_{13}Q_{30}=-6144/6859,\quad
(SQ-QS)_{01}=-157/1216.
\tag{4}
\]

The negative triangle product is invariant under diagonal sign gauges.
The original-law projection neither fixes nor annihilates constants and
does not commute with the coarse root.

## The new all-exponent conclusion

The exact eigenvalues of `S` are `1`, `105/128` twice, and `45/64` once.
Put `x=(105/128)^2` and `y=(45/64)^2`. The coarse square has exactly two
values on its entire centered space, namely `x,y`. For
`C=(S^2-yI)/(1-y)`, every positive power of `S^2` lies in
`conv{I,Pi,C}`, with the nonnegative coefficients proved in the theorem.

The **entire centered fine square** has:

| Value | Multiplicity |
|---|---:|
| `x=(105/128)^2` | 2 |
| `y=(45/64)^2` | 1 |
| `beta=1/4096` | 2 |
| `0` | 2 |

Thus there are four distinct centered values, including both zero modes.
The finite checker verifies the full original-weight characteristic
polynomial; no numeric eigenvalue clustering is used.

For **any** six positive exponents `n_e`, let `N=sum_e n_e` and let
`q_D=sum_(e in D)n_e` run over the four triangles and three quadrilaterals
of `K4`. Since `sum_i pi_i^(-2)=148`, the new theorem gives

\[
\boxed{F(T;n)\ge F(S;n)+2\sum_D\beta^{q_D}
\ge1+147y^N+2\sum_D\beta^{q_D}>1.}
\tag{5}
\]

For the target tuple `(k,u,r,l,h)=(3,1,1,1,1)`, the edge exponents are
`(3,2,1,1,1,1)`, `N=9`, and the cycle exponents, in the order
`abc,abd,acd,bcd,abcd,abdc,acbd`, are
`(6,5,4,3,6,7,5)`. In particular,

\[
\boxed{F(T)\ge1+147y^9+
2(\beta^3+\beta^4+2\beta^5+2\beta^6+\beta^7)>1.}
\tag{6}
\]

This tuple lies outside all three previously identified reflection
families: `k=u,r=l`; `k=r,u=l`; and `k=r+h,u=l`. Here the first two require
`3=1`, and the third requires `3=2`. The all-exponent comparison in (5),
unlike the earlier paired-star statement, applies without those equalities.

## Exact verification and limits

Run from any directory:

```bash
python path/to/continuation5/continuation5_cone_verify.py
```

The standard-library checker uses the unchanged arithmetic module in the
sibling `continuation4` directory. It verifies 55 generator/mixed-star
inequalities, original-law trace identities, exact cone coefficients,
actual powers, all seven cycle contractions, and full finite densities.
It includes seven distinct actual roots, with eight projection/root
specifications and fourteen specification/tuple checks (thirteen distinct
root/tuple pairs). The duplicate root is deliberately tested once with a
zero channel strength and once with a rank-zero projection.

For (2), four checked tuples are outside all reflection families:
`(3,1,1,1,1)`, `(4,2,3,1,2)`, `(8,2,3,1,1)`, and `(1,1,2,1,6)`.
The other checks include `k=u`, `r=l`, `h=1`, negative eigenvalues of the
actual root channel, a zero channel, a rank-zero projection, exact equality
at `T=Pi`, a weighted disconnected root, and a connected bipartite root
whose square is disconnected. These finite checks audit the displayed
data and identities. The general conclusion (5) comes from the written
proof, not from sampling tuples.
