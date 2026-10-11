# Exact-pair entropy compensation near the constant root

This note gives a complete, constructive entropy certificate in a weak-host
regime of the remaining ordered density strip. It corrects higher-order
information while preserving all six required pair laws. Weak-host density
positivity itself is already accessible by proper-subgraph expansion; the
contribution here is an explicit compatible entropy mechanism, not a new
unrestricted density class, a novelty claim, or an accepted Lean result.

## Exact statement

Use the finite positive original probability space and relative-kernel
conventions of [the regional theorem](markov-jensen-compensation.md).
Let \(R\ne0\) be a real symmetric relative kernel with \(R1=0\). Put
\(\rho=\|R\|_{L^2(\mu)\to L^2(\mu)}>0\), \(R_0=R/\rho\),
\(B=1/\min_x\mu_x\), and \(C=6B\). For \(z>0\), define
\[
T_z=\Pi+zR_0 .
\]
All operator products below use \(\mu\); this is an actual nonnegative
symmetric Markov root under the size condition specified below.

Consider positive integers satisfying
\[
k\ge u,\quad r\ge l,\quad h\ge1,\qquad r+h-l<u<r+l.
\tag{1}
\]
If \(u<l\), assume also \(k<2u\). The omitted case \(u<l,\ k\ge2u\)
is already covered by the additional \(u\le r,\ k\ge2u\) orientation
of the regional theorem.

Label the six edges of \(K_4\) by
\[
n_{ab}=k,\ n_{ac}=r+h,\ n_{ad}=u,\quad
n_{bc}=r,\ n_{bd}=u,\ n_{cd}=l,
\]
and put
\[
\tau=\min\{k+2u,\ r+u+l\},\qquad
N_\tau=\mathbf1_{k+2u=\tau}+\mathbf1_{r+u+l=\tau}.
\]
Thus \(N_\tau\) is either one or two. Suppose
\[
0<z\le\frac1{2C^{(\tau+2)/2}}.
\tag{2}
\]
For \(x=(x_a,x_b,x_c,x_d)\), set
\[
f_e(x)=z^{2n_e}R_0^{2n_e}(x_i,x_j),\qquad
q(x)=1+\sum_{e=ij}f_e(x).
\tag{3}
\]
Then \(T_z\) and the relative probability density \(q\) are at least
\(1/2\) entrywise. The law \(q\,\mu^4\) has singleton marginals \(\mu\)
and, on every edge \(e=ij\), the exact pair density
\[
(q\,\mu^4)_{ij}/\mu^2=T_z^{2n_e}=1+z^{2n_e}R_0^{2n_e}.
\tag{4}
\]

Let \(I_{T_z}(m)=\mathbb E_{\mu^2}T_z^m\log T_z^m\), with natural
logarithms. Its Gibbs payoff for the six target factors is
\[
P(z)=\sum_e I_{T_z}(2n_e)-D(q\,\mu^4\Vert\mu^4).
\tag{5}
\]
It satisfies
\[
\left|P(z)-N_\tau\operatorname{tr}(R_0^{2\tau})z^{2\tau}\right|
\le2C^{\tau+2}z^{2\tau+2},
\qquad
P(z)\ge \tfrac12z^{2\tau}>0.
\tag{6}
\]
Consequently the actual target density is at least \(\exp(P(z))>1\).
No latent variable is charged as though it were observed.

## Positivity and exact compatibility

The finite weighted spectral theorem and \(\|R_0\|=1\) give
\[
|R_0^m(x,y)|\le(\mu_x\mu_y)^{-1/2}\le B,\qquad m\ge1.
\]
Indeed, apply the operator norm bound to the normalized coordinate
vectors. Symmetry and \(R_01=0\) also give \(\Pi R_0=R_0\Pi=0\).
Thus \(T_z^m=\Pi+z^mR_0^m\) for every positive integer \(m\).

Condition (2), \(C\ge6\), and \(\tau\ge3\) imply \(z\le1\),
\(zB\le1/2\), and \(Cz^2\le1/2\). Hence \(T_z\ge1/2\) and
\(|q-1|\le6Bz^2=Cz^2\le1/2\).

Every summand \(f_e\) integrates to zero in either endpoint.
Integrating (3) over the two other vertices retains exactly \(1+f_e\);
every other edge term loses an endpoint and vanishes. Integrating over
three vertices retains one. This proves normalization, the singleton
claims, and (4), simultaneously, under the original law.

## Entropy expansion and all surviving supports

Write
\[
\phi(t)=(1+t)\log(1+t)
=t+\sum_{m\ge2}\frac{(-1)^m}{m(m-1)}t^m,\qquad |t|<1.
\]
Exact pair compatibility gives
\[
P(z)=\sum_e\mathbb E_{\mu^2}\phi(f_e)
       -\mathbb E_{\mu^4}\phi\!\left(\sum_e f_e\right).
\tag{7}
\]
Here the first expectation means the same two-coordinate summand.
The series converges absolutely by the positivity bounds. Every
single-edge monomial cancels exactly between the two terms. Every
integrated mixed monomial with a vertex of total multiplicity one
vanishes, because its only incident centered kernel integrates to zero.

At order two all mixed terms vanish. At order three the only surviving
mixed supports are triangles, with multiplicity one on each edge.
The minus sign in (7), the coefficient \(-1/6\), and the six
permutations give coefficient \(+1\). A triangle of total edge weight
\(w\) integrates to \(\operatorname{tr}(R_0^{2w})\).

The four triangle weights are
\[
k+2r+h,\quad k+2u,\quad r+h+u+l,\quad r+u+l.
\]
The first exceeds the last by \(k-u+r+h-l>0\); the third exceeds
the last by \(h>0\). The two minimum candidates are therefore precisely
those defining \(\tau\).

For completeness, every other possibly nonzero mixed monomial has
total weight at least \(\tau+1\):

- If its support contains a triangle, either its triangle is nonminimal
  or it adds at least one positive-weight factor to a minimal triangle.
- If its support is triangle-free but has a cycle, it contains a
  four-cycle. The three four-cycle weights exceed \(r+u+l\):
  their differences are \(k\), \(r+h+u-l\), and \(k+h\), respectively.
- Otherwise the support is a forest with at least two distinct edges.
  It has at least two distinct leaf edges. Each must occur at least
  twice, or its leaf would have multiplicity one and the integral
  would vanish. If \(u\ge l\), their combined weight is at least
  \(2(l+\min(u,r))>r+u+l\), by both inequalities in (1).
  If \(u<l\), it is at least \(4u>k+2u\), by \(k<2u\).

This also covers disconnected supports and repeated wedges. No sign
claim about those later mixed integrals is needed.

## Explicit remainder

At series order \(m\), there are at most \(6^m\) ordered mixed products,
each bounded in absolute value by \(B^m\) times its power of \(z\);
the scalar series coefficient has absolute value at most one.
For \(m\le\tau+1\), every nonleading survivor therefore contributes
in total at most \(C^m z^{2\tau+2}\).
For \(m\ge\tau+2\), the total is at most \((Cz^2)^m\).
Since \(Cz^2\le1/2\), their sum is bounded by
\[
z^{2\tau+2}\frac{C^{\tau+2}}{C-1}
+2C^{\tau+2}z^{2\tau+4}
\le
\left(\frac{C^{\tau+2}}{C-1}+C^{\tau+1}\right)z^{2\tau+2}
<2C^{\tau+2}z^{2\tau+2}.
\]
This proves the first bound in (6). The self-adjoint operator \(R_0\)
has at least one eigenvalue of absolute value one, so
\(\operatorname{tr}(R_0^{2\tau})\ge1\).
Condition (2) implies \(2C^{\tau+2}z^2\le1/2\), proving the second bound.

Finally, finite Gibbs variational duality gives
\(\log F\ge\mathbb E_q\sum_e\log T_z^{2n_e}-D(q\mu^4\Vert\mu^4)=P(z)\).
All target factors are positive, so there is no support or infinite-log
exception in this last step.

## What this does, and what it does not do

The [9 October full-table correction](../2026-10-09-entropy-density/public-review-round2-20261009/entropy-gap-attempt.json),
construction step 3, already uses pair-additive centered corrections.
The [long-subdivision argument](long-subdivision-entropy.md), sections
"Cycle gain in the original Gibbs law" and "Global fitting and entropy cost",
already obtains weak interactions and fits actual edge laws by a different
Gibbs parameter construction. The pair-additive correction is not new.
This proof instead audits its specific unequal-power entropy valuation,
including the repeated-leaf cases and an explicit positive radius.
It shows that an exact-marginal replacement can remove excess
higher-order information from a latent-tree trial without corrupting
the target energies.

This is useful evidence for collective compensation rather than a
modewise shortcut. Extending the positive Gibbs-payoff mechanism to
arbitrary roots in the residual strip remains open. This does not impose
exact fitting of every powered branch pair as a universal requirement:
such pair laws can be incompatible, as the earlier
[powered-branch obstruction](unrestricted-density-pass.md) demonstrates.
An unrestricted witness may instead use different pair laws and must
pay their actual cross-energies. Neither the
existence of exact pair laws in this small neighborhood nor the
strict positive payoff proves that unrestricted extension.
The root is strictly positive and near \(\Pi\); zeros and distant roots
are not covered by this certificate. The regional theorem separately
permits them.

The argument is a complete finite analytical proof. Root self-review
and actual separate-agent analytical review are recorded in the
adjacent review receipt. No numerical run, compiler, optimizer,
service request, external full audit, novelty clearance, manuscript
promotion, or Lean acceptance is asserted.
