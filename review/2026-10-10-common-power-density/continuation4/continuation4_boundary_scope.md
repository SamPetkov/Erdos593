# Reflection boundary: a scope check, not new density coverage

The unrestricted target remains unresolved. The projection-channel comparison
in this packet is a quantitative comparison with the original coarse density.
It must not be presented as new coverage of the simultaneous boundary
`k=u, r=l`: that entire boundary has the following direct proof, for every
admissible actual root, without a channel or spectral-band hypothesis.

Every composition and inner product below uses the original probability
`mu`. Write `A=T^2`, `K_j=A^j`, and `Pi(x,y)=1`.

## 1. Direct reflection at k=u, r=l

Fix `a,c` and define the actual function

`f_(a,c)(b)=K_u(a,b)K_r(c,b)`.

The two inner vertices `b,d` have identical incident powers to `a,c`.
Consequently the full six-factor density is exactly

\[
F=\mathbb E_{a,c}K_{r+h}(a,c)
       \langle f_{a,c},K_u f_{a,c}\rangle_\mu.
\tag{1}
\]

The operator `K_u-Pi` is PSD. Since the outside factor `K_(r+h)` is
entrywise nonnegative, (1) implies

\[
F\ge\mathbb E_{a,c}K_{r+h}(a,c)
              (\mathbb E_b f_{a,c}(b))^2
 =\mathbb E_{a,c}K_{r+h}(a,c)K_{u+r}(a,c)^2.
\tag{2}
\]

The equality uses `K_u K_r=K_(u+r)` in the original measure. The Schur
square `K_(u+r) circ K_(u+r)` is PSD. Its Hilbert--Schmidt pairing with
the PSD operator `K_(r+h)-Pi` is therefore nonnegative. It follows that

\[
\boxed{F\ge\operatorname{tr} A^{2(u+r)}\ge1.}
\tag{3}
\]

In particular the exact surplus decomposition is

\[
\begin{aligned}
F-\operatorname{tr}A^{2(u+r)}
={}&\mathbb E_{a,c}K_{r+h}(a,c)
 \langle f_{a,c},(K_u-\Pi)f_{a,c}\rangle_\mu\\
 &+\langle K_{r+h}-\Pi,
       K_{u+r}\circ K_{u+r}\rangle_{\mathrm{HS}}.
\end{aligned}
\tag{4}
\]

Both terms are nonnegative for the stated reasons. This uses pairwise PSD
pairings only. It makes no sign assertion about a trace of three arbitrary
PSD matrices. The functions in (1) are the displayed actual sources.

Zeros, disconnected roots and disconnected squares are allowed. The
complete spectrum of `A` is `1,theta_1,...` with `theta_i>=0`. Thus equality
`F=1` at this boundary forces every centered `theta_i=0`, so `A=Pi`.
Self-adjointness and `T1=1` then imply `T=Pi`; conversely `T=Pi` gives
`F=1`. This also handles the one-state case.

## 2. A second reflection ray and the paired-star classification

More generally, if two vertices have the same powers to each of the other
two vertices, the same proof applies. If their common incident powers are
`s,t`, the bound is `F>=tr A^(2(s+t))`, independently of the positive powers
on the inner and outside edges. For the target pattern the three possible
vertex-pair reflections are exactly:

| Reflected vertices | Required equalities | Trace lower bound |
|---|---|---|
| `b,d` | `k=u, r=l` | `tr A^(2(u+r))` |
| `a,c` | `k=r, u=l` | `tr A^(2(u+r))` |
| `b,c` | `k=r+h, u=l` | `tr A^(2(k+u))` |

The other three vertex pairs would force `h=0` or `r+h<=l`, contrary to
the target inequalities. These are ordinary reflection cases, not newly
solved portions of the remaining target. The paired-star classification
below is a different question: it asks when every complementary star has
a repeated pair, as required by the separate projection-cycle proof.

For general edge exponents `n=(k,r+h,u,r,u,l)`, the four stars at `a,b,c,d`
have lengths

`(k,r+h,u), (k,r,u), (r+h,r,l), (u,u,l)`.

Under the target inequalities, all four have a repeated pair exactly when

1. `r=l` and `k=u`; or
2. `r=l=u` and `k=u+h`.

Indeed the star at `c` forces `r=l`. If `k!=u`, the star at `a` forces
`k=r+h` or `u=r+h`. The latter is incompatible with a repetition at `b`
and `k>=u`; the former forces `r=u` at `b`. The converse is direct.

The second case has edge exponents `(u+h,u+h,u,u,u,u)` and a reflection
exchanging `b,c`. Setting

`g_(a,d)(b)=K_(u+h)(a,b)K_u(d,b)`

and repeating (1)--(3), now with the outside edge `ad` and inner edge
`bc` both carrying `K_u`, gives

\[
F\ge\operatorname{tr}A^{2(2u+h)}\ge1.
\tag{5}
\]

Thus this ray also supplies no new density coverage for a paired-star
projection theorem. The projection comparison does retain `F(S;n)` and
positive channel-cycle surplus, which (3) and (5) do not by themselves
compare with the original coarse density.

## 3. What is and is not concluded

The direct reflection proof is included to prevent a scope overclaim, not
as progress on the remaining unequal-exponent target. The separate
projection lemmas prove a more structured quantitative comparison with the
coarse host, and the canonical-cover constraints address a different route.
Neither extends (3) to unrestricted `k>=u, r>=l` in this packet.

There is no inference that arbitrary binary channels contract the coarse
density at a reflection boundary. Expanding that comparison leaves signed
cross terms; the two scalar reflection inequalities above do not give the
required comparison. The projection-channel proof supplies its own cycle
contractions under its explicit `H^2=beta Q` hypothesis.
