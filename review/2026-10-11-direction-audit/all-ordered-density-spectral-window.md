# An explicit mixing window for every ordered exponent tuple

The full-density triangle payment gives a quantitative family in which every retained ordered tuple passes, not just an eventual tail. The family includes roots outside the earlier transition-cap and minimum-mass sufficient conditions. This is a checked sufficient class, not the unrestricted theorem or a literature-wide novelty claim.

## Spectral and component criterion

Use the finite positive original law mu, actual symmetric nonnegative Markov root T, A=T^2 and K_j=A^j. The target is

\[
F(k)=\mathbb E K_k(a,b)K_{r+h}(a,c)K_u(a,d)
K_r(b,c)K_u(b,d)K_l(c,d)\ge1,
\qquad k\ge u\ge1,\ r\ge l\ge1,\ h\ge1.
\]

For each nonconstant support component C of A, use the conditional law mu_C and set

\[
\gamma_C=\bigl(\max_x(\mu_C(x)^{-1}-1)\bigr)^6,\qquad
0<\rho_C<1
\]

where rho_C is the largest nonconstant eigenvalue of the normalized local A_C. Then

\[
\boxed{\gamma_C\rho_C^7\le1\quad\hbox{for every nonconstant C}
\quad\Longrightarrow\quad
F(k)\ge1\quad\hbox{for every retained ordered tuple}.}
\]

Constant and singleton components need no spectral condition.

For l>=2, the ABD-triangle complement in the full centered expansion is 2r+l+h>=7, since r>=l and h>=1. Thus gamma_C rho_C^(2r+l+h)<=1, and the finite-host triangle payment gives F_C>1 on each nonconstant component. Constant components have F_C=1. The original normalization F=sum_C mu(C)^(-2)F_C proves the global inequality.

For l=1, use the already proved original-law Markov Jensen regions, not a hypothetical local nonnegative square root. If u<=r, then u+l=u+1<=r+h. If u>=r+1, then u>=r+l. These are exhaustive integer cases, and each satisfies the actual six-edge Markov Jensen theorem. That theorem handles all original zeros, stationary modes and periodic roots. Its complete proof is retained in [Markov Jensen compensation](https://github.com/SamPetkov/Erdos593/blob/codex/e593-direction-audit-20261011/review/2026-10-11-direction-audit/markov-jensen-compensation.md).

Within this sufficient class, equality at any retained tuple holds exactly for T=Pi. In the l=1 case this follows from the Jensen theorem's equality characterization. In the l>=2 case a nonconstant component has strict triangle surplus; multiple components have sum_C mu(C)^(-2)>1. The only remaining equality case is one constant component, A=Pi, which forces T=Pi by self-adjointness.

The rational alpha_C from the finite-host certificate may replace rho_C in the sufficient condition. It is an upper bound, so gamma_C alpha_C^7<=1 is conservative, not necessary.

## A uniform radius over all roots on one original law

For any actual symmetric nonnegative Markov root Q on the same law, put

\[
T_\varepsilon=(1-\varepsilon)\Pi+\varepsilon Q,\qquad
0\le\varepsilon\le1,\qquad
J=\max_x(\mu(x)^{-1}-1)=1/\min_x\mu(x)-1.
\]

For a space with at least two states, J>=1. For epsilon<1 the kernel is positive and has one A-component. Every nonconstant eigenvalue of A_epsilon is at most epsilon^2, because a self-adjoint Markov operator Q has spectrum in [-1,1]. Therefore the explicit radius

\[
\boxed{0\le\varepsilon\le J^{-3/7}}
\]

proves the ordered inequality for every Q and every ordered tuple, under the original law. At epsilon=0 the constant-root equality is immediate. If the bound admits epsilon=1, then J=1, so the law is uniform on two states; the spectral/component criterion still applies, including reducible or periodic Q. The one-state law is constant and is handled separately.

This radius is uniform over Q and all five exponents for the fixed law. It is not uniform over laws with arbitrarily small masses. It is an actual-root statement: no fractional root, altered law or entrywise floor is assumed.

## Comparison with earlier sufficient conditions

For the uniform law on 101 states, J=100. The choice epsilon=1/10 satisfies J^6 epsilon^14=1/100<=1, so every actual symmetric Markov root Q yields such a retained all-tuple root T_epsilon.

Choose Q whose associated stochastic matrix P_Q(x,y)=mu(y)Q(x,y) has one isolated state, P_Q(1,1)=1; on the other 100 states take any symmetric stochastic block. Its relative diagonal is Q(1,1)=101. The actual relative diagonal of T_epsilon at state 1 is

\[
T_\varepsilon(1,1)=9/10+(1/10)\,101=11.
\]

Thus this family is not contained in the previously paid cap T<=4(1+sqrt(2)): 11>4(1+sqrt(2)), since 49>32. Its minimum mass 1/101 is also below 1/10. The remaining block may have many unequal modes; the proof does not rely on a rank-one or central-convolution representation. This is only a comparison with those two earlier sufficient guards, not a claim that the hosts are absent from every other known density family.

The lemma closes this explicit quantitative class. Removing its spectral/mass restriction, or controlling the original root at epsilon=1 in general, remains the unrestricted companion problem. No Lean implementation, new service run, manuscript theorem or external-audit claim is made here.
