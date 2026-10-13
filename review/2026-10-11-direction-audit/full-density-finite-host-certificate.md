# Finite certification of the full common-power density

For each fixed finite Markov host, an explicit spectral bound pays the signed tetrahedral term outside a finite set of exponent tuples. The statement concerns the full six-edge density, not the processed-overlap shadow. It does not prove the inequality simultaneously for every host: the remaining finite checks depend on the host and may still fail. No novelty or Lean-validation claim is made.

## Original host and density

Let X be finite and nonempty, let mu be a strictly positive probability law, and let T be a symmetric, entrywise nonnegative relative Markov kernel. Kernel composition uses the original mu. Put A=T^2 and K_j=A^j. For positive integers k,r,u,l,h, define

\[
F(k)=\mathbb E_{a,b,c,d\sim\mu}
K_k(a,b)K_{r+h}(a,c)K_u(a,d)
K_r(b,c)K_u(b,d)K_l(c,d).
\]

The retained research target imposes k>=u and r>=l. The bound below needs neither ordering. Zeros, nonuniform masses, negative eigenvalues of T, reducibility, periodicity and additional unit modes of A are allowed.

## Component normalization

Take the connected components C of the support graph of A, and write p_C=mu(C) and mu_C(x)=mu(x)/p_C. For x,y in C, the local relative kernel is

\[
A_C(x,y)=p_C A(x,y),\qquad
K_{C,j}(x,y)=p_C K_j(x,y).
\]

The second equality follows by composition under mu_C; the local stochastic matrix is the original stochastic matrix restricted to C. Each A_C is irreducible, nonnegative, self-adjoint and positive semidefinite. Its eigenvalue 1 is simple, and every other eigenvalue lies in [0,1). No nonnegative local square root is assumed: a periodic T may exchange two components of A.

Every edge in the six-edge expression has positive exponent, so it vanishes between distinct A-components. Since the four-vertex graph is connected, all four vertices in a nonzero summand lie in one C. Consequently

\[
F(k)=\sum_C p_C^{-2}F_C(k).
\]

There are four vertex-law factors and six relative-kernel factors: p_C^4 p_C^{-6}=p_C^{-2}. In particular, componentwise F_C>=1 implies F>=sum_C p_C^{-2}>=1. This normalization differs from the deleted-edge theta density and must not be replaced by its p_C^{-1} factor.

It remains to study one component, using its conditional law throughout. A one-state component is constant. More generally, if A_C=Pi_C, then every K_{C,j}=1 and F_C=1 exactly. The following argument treats the nonconstant case.

## Centered expansion and its positive proper terms

Suppress C from the notation. Let

\[
R_j=A^j-\Pi,\quad
0<\rho=\max\{\theta_i: i\ne0\}<1,\quad
N=k+2r+2u+l+h,
\]

where theta_i are the eigenvalues of A and phi_0=1. An orthonormal real eigenbasis gives

\[
R_j(x,y)=\sum_{i\ne0}\theta_i^j\phi_i(x)\phi_i(y),
\qquad \mathbb E_\mu R_j(x,Y)=0.
\]

Expand the product of six factors 1+R_j. Every edge subset with a vertex of degree one has zero expectation, by integrating that vertex. Of the 64 subsets, the only ones without a degree-one vertex are the empty subset, four triangles, three four-cycles, six diamonds and the full tetrahedron. Isolated vertices contribute one.

The triangle or four-cycle with edge-length sum s contributes
Tr(R_s)=sum_{i!=0} theta_i^s>=0. The notation R_s here uses the fact that products of centered powers compose to the centered power with the summed exponent.

For a diamond, its two degree-three vertices are joined by a direct edge of length a and two internally disjoint paths of length sums b and c. Integrating the two degree-two vertices gives

\[
\mathbb E_{x,y}R_a(x,y)R_b(x,y)R_c(x,y)
=\sum_{i,j,t\ne0}\theta_i^a\theta_j^b\theta_t^c
\bigl(\mathbb E_\mu\phi_i\phi_j\phi_t\bigr)^2\ge0.
\]

Thus all proper nonzero terms are nonnegative. Only the centered tetrahedral term

\[
Z=\mathbb E_{a,b,c,d}
R_k(a,b)R_{r+h}(a,c)R_u(a,d)
R_r(b,c)R_u(b,d)R_l(c,d)
\]

can have either sign. Its isolated coefficients must not be signed termwise.

## An explicit collective payment

Completeness of the eigenbasis gives the relative-kernel identity

\[
J(x)=\sum_{i\ne0}\phi_i(x)^2=\mu(x)^{-1}-1.
\]

Including zero modes in J is harmless. Cauchy--Schwarz and theta_i<=rho give, for j>=1,

\[
|R_j(x,y)|\le\rho^j\sqrt{J(x)J(y)}.
\]

Each tetrahedral vertex has degree three. Therefore

\[
|Z|\le\Gamma\rho^N,\qquad
\Gamma=\bigl(\mathbb E_\mu J^{3/2}\bigr)^4
\le J_{\max}^{6}.
\]

This estimate bounds the actual integrated tetrahedral contribution. It does not replace the kernel or discard the positive proper-subgraph budget. The four triangle lengths are

\[
\tau_{ABD}=k+2u,\quad
\tau_{BCD}=r+u+l,\quad
\tau_{ABC}=k+2r+h,\quad
\tau_{ACD}=r+h+u+l.
\]

Each triangle trace is at least rho^tau, because an eigenmode with eigenvalue rho exists. Keeping all four triangles, and discarding only other nonnegative proper terms, yields the proved bound

\[
F_C(k)\ge
1+\rho^{k+2u}+\rho^{r+u+l}
+\rho^{k+2r+h}+\rho^{r+h+u+l}-\Gamma\rho^N.
\]

In particular F_C>=1 if Gamma rho^L<=1 for any one of

\[
L\in\{2r+l+h,\ k+r+u+h,\ 2u+l,\ k+r+u\}.
\]

These are exactly N minus the four triangle lengths. For example, the first condition pays the entire tetrahedral term with the ABD triangle, uniformly in k and u, even when l=r. The other three positive triangles remain. Consequently the paid nonconstant component actually has F_C>1 at every finite tuple satisfying this sufficient condition.

This is a genuine collective sufficient bound. Failure of the bound is not a counterexample to F_C>=1, and the bound is not asserted necessary.

## A rational cutoff without eigenvalue computations

For a nonconstant component with n>=2 states, let P(x,y)=mu(y)A(x,y) be its stochastic matrix and put m=n-1. Every diagonal entry is positive: for the original A=T^2 this follows from A(x,x)=E_mu T(x,Y)^2>0. It also follows from positive semidefiniteness and the nonzero Markov row after restriction. Irreducibility and these self-loops imply P^m(x,y)>0 for every x,y: a shortest path has length at most n-1, and diagonal steps pad it to m.

Set

\[
\delta=\sum_y\min_x P^m(x,y)>0,\qquad
\alpha=1-\delta/m<1.
\]

Every row of P^m contains the common subprobability vector with masses min_x P^m(x,y), whose total mass is delta. The remaining row masses total 1-delta. Hence the oscillation of P^m f is at most (1-delta) times the oscillation of f. Applying this to a nonconstant eigenfunction gives theta_i^m<=1-delta. Concavity of x^(1/m) on [0,1] then gives

\[
\rho\le(1-\delta)^{1/m}\le1-\delta/m=\alpha.
\]

All these operations use the original conditional component law. For rational input, delta, alpha and the conservative constant gamma=J_max^6 are rational. Choose an integer B_C>=1 satisfying gamma alpha^(B_C)<=1. Such an integer exists because alpha<1. A component with A_C=Pi_C is handled directly and requires no cutoff. If alpha=0, A_C=Pi_C and the direct case applies.

Let B be the maximum of B_C over the nonconstant components. If there are none, F=sum_C p_C^(-2) exactly at every tuple. Otherwise every tuple with at least one of the four displayed L-values >=B is paid componentwise and therefore satisfies the original F>=1.

## A finite reduction for each fixed host

All possible failures for this fixed host are confined to

\[
\mathcal E_B=\{(k,r,u,l,h)\in\mathbb Z_{>0}^5:
2r+l+h<B,\ k+r+u+h<B,\ 2u+l<B,\ k+r+u<B\}.
\]

This set is finite: each variable is bounded by an inequality in which it occurs with a positive coefficient. Restricting further to k>=u and r>=l gives the retained ordered target. For rational host data, every remaining F-value is rational and can be evaluated exactly using finite matrix powers and finite sums. Checking those remaining values, together with the proved tail bound, is a complete decision procedure for this particular host. No exhaustive finite run has been performed here.

The cutoff can be very conservative, especially for rare states or slow mixing, and the finite enumeration may be enormous. This is not a uniform exponent cutoff over all hosts, and it does not remove the unrestricted theorem's dependence on arbitrary host geometry. It does supply a concrete full-density route after the universal processed-overlap shortcut has failed.

The earlier fixed-host tail argument held four base exponents fixed and reduced only the remaining long-edge exponent h to finitely many checks. Here the same host has a finite exceptional set in all five variables at once. The distinction is the triangle budget: its exponent cancels the otherwise unbounded k or u dependence in the tetrahedral estimate. Neither reduction establishes that every remaining check passes.

## Audit boundary and remaining obligation

The proof route is:

```text
full density for a fixed host
  <- component normalization AND componentwise density
componentwise density outside E_B
  <- centered expansion AND positive proper terms
     AND tetrahedral bound AND one triangle payment
all exponent tuples for that fixed host
  <- paid infinite tail AND exact checks of every tuple in E_B
unrestricted density over every host
  <- the preceding route AND a uniform argument for the remaining finite checks
```

The expansion, normalizations and tail payment are proved above. The finite checks have not been supplied for every host; a uniform proof of them is the remaining obligation. The tail theorem follows by the supplied analytical route, whereas the unrestricted density theorem is not established by this route. This distinction is maintained when using the cutoff as a research tool.

The note changes no manuscript, runs no Lean or service, and makes no external-audit or novelty claim. A separate source review and small exact algebra checks are to be recorded separately from this proof text.
