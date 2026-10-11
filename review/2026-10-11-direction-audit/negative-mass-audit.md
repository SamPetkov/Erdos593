# Conclusion first audit of the compensation estimate

## Audit boundary

The unrestricted conclusion \(C0\) is \(F\ge1\) for every original finite
positive probability law and symmetric nonnegative relative Markov root,
with \(k\ge u\ge1,\ r\ge l\ge1,\ h\ge1\). The notation and full target are
in [the checked derivation](ordered-negative-mass.md).
The supplied compensation route, not every possible proof of \(C0\), is
the object of this audit. The further ten-state corollary is a separate
direct deduction.

Accepted primitives are the finite real spectral theorem; Markov
normalization, self-adjointness and contraction of the actual root;
finite original-law kernel composition; the earlier exact collective
expansion; Cauchy--Schwarz and its equality case; weighted AM--GM;
orthonormal completeness; and elementary algebra with checked domains.
No weighted semigroup contraction, positivity of a general PSD triple
product, or sign of the unequal mixed form is assumed.

The completed consultation explicitly did **not** claim a full proof or
an admissible density counterexample. Its reported numerical probes are
not adopted as our run evidence. The analytical steps below have been
checked independently of those probes.

## Obligation graph

The principal supplied route is the paid-cutoff decomposition:
\[
C0\leftarrow R_{\rm tail}
  (\mathrm{AND}:\ O1,\ C1,\ C2,\ O7).
\]
Here \(C1\) is the negative spatial-mass bound
\(\delta\le\Delta\le a_0(Z-\sigma_0)\), \(C2\) is the exact identity
\(F-1=B+Q_{b_*}-H_{b_*}\) for \(\Delta>0\), and \(O7\) is the
unproved payment \(H_{b_*}\le B+Q_{b_*}\).
The \(\Delta=0\) case closes separately by \(O6\).
These are cases requiring both branches, not alternative proofs.

The dependencies are
\[
\begin{aligned}
C1&\leftarrow R_{\rm mass}
   (\mathrm{AND}:\ O2,O3,O4,O5),\\
C2&\leftarrow R_{\rm expand}
   (\mathrm{AND}:\ O8,O9,O10).
\end{aligned}
\]
The actual \(Q\)-budget is retained. Replacing \(O7\) by
\(H_{b_*}\le B\) would strengthen the required estimate without support.

The cap route proves a different conditional conclusion:
\[
C3:\ \max K_l\le b_0\Rightarrow F\ge1+B+\sigma_0
\leftarrow R_{\rm cap}
(\mathrm{AND}:\ O11,C1,O12,O13).
\]
It is not a route to the universal \(C0\), since \(O11\) is not a
universal hypothesis. Likewise the actual loop covariance inequality
is a supplied alternative bound \(C4\), not a proof that its right-hand
side reaches one. A marginal-only diagnostic is recorded in
[the exact loop check](loop-information-check.md).

The new direct deduction has its own conclusion and scope:
\[
C5:\ \min\mu\ge1/10
\Rightarrow F\ge1+B+(57-40\sqrt2)\sigma_0
\leftarrow R_{\rm finite}
(\mathrm{AND}:\ O14,O15,O16,O17,C1,O18,O19).
\]
No private chat transcript or identifier is included in these public sources.

## Critical findings

All supplied identities and the negative spatial-mass bound pass;
the global payment \(O7\) remains unproved.
The spatial negative part must be taken after summing correlated flags;
modewise negative variation would be a different and weaker quantity.
The new \(N_t\) family must not be confused with the older squared-norm
notation: \(N_{2h}\), not \(N_h\), is \(\|A_c^hV\|^2\).

The cutoff \(b_*=Z/\Delta\) is defined only on \(\Delta>0\).
The zero case is proved without division, including \(N_0=0\).
Nonuniform weights, extra stationary modes, zero eigenvalues and negative
root eigenvalues do not change the signs; every composition retains \(\mu\).

The exact global leaf \(O7\) is **missing**, not a hidden background
theorem. The supplied response expressly leaves it unproved.
Markov rarity of the high-density set supplies no estimate on \(g_-\)
there. The loop marginals also do not supply the particular fourth-order
dependence of the actual semigroup law.

The finite-host result uses \(\min\mu\ge1/10\), not merely
\(|X|\le10\). It is stronger than the automatic nine-state consequence
of the cutoff, but no claim of literature novelty is made.
The earlier balanced projection-rank-ten theorem has different hypotheses.

## Dependency table

| ID | Exact claim or obligation | Needed by | Route or edge | Classification | Support | Status |
| --- | --- | --- | --- | --- | --- | --- |
| C0 | Universal original-root ordered density \(F\ge1\) | root | Tail primary route, both zero and positive cases | root | C1, C2, O6, O7 | failing |
| O1 | Finite positive law, actual root and ordered integer exponents | C0, C1, C4 | Target scope | hypothesis | Exact target | discharged |
| C1 | \(\delta\le\Delta\le a_0(Z-\sigma_0)\) | C0, C3, C5 | Mass route | major claim | O2--O5 | discharged |
| O2 | \(N_t\le Z_t\) for every integer \(t\ge0\) | C1 | Exponent comparison | algebraic/logical step | Symmetric factorization with k>=u and r>=l | discharged |
| O3 | \(S=A_c^h\) is a positive self-adjoint contraction | C1 | Original-law operator | proved earlier | Spectral theorem and actual-root square | discharged |
| O4 | \(\|V\|^2=N_0,\ \langle V,SV\rangle=N_h,\ \|SV\|^2=N_{2h}\) | C1 | Finite Parseval | algebraic/logical step | Exact eigenbasis expansion | discharged |
| O5 | Spatial CS and scalar ratio give the stated constants | C1 | Norm bound | named theorem | Cauchy--Schwarz; finite norms; checked scalar square | discharged |
| O6 | \(\Delta=0\Rightarrow g\ge0\) pointwise | C0 | Zero case | named theorem | CS equality when N0>0; zero norm otherwise | discharged |
| C2 | \(F-1=B+Q_{b_*}-H_{b_*}\) on Delta>0 | C0 | Exact expansion | major claim | O8--O10 | discharged |
| O7 | \(H_{b_*}\le B+Q_{b_*}\) for every admitted host with Delta>0 | C0 | Tail payment | missing | No supplied estimate discharges this exact equivalent target | failing |
| O8 | Definitions of H, Q and their original-law expectations | C2 | Unfolding | definition | Equation (7) of derivation | discharged |
| O9 | Delta>0, so b*=Z/Delta is finite and positive | C2 | Domain | side condition | Finite host and C1 | discharged |
| O10 | Expansion of positive and negative parts yields exact identity | C2 | Algebra | algebraic/logical step | g=g+−g− and scalar clipping | discharged |
| C3 | Cap-conditioned quantitative density bound | root | Cap route | major claim | O11--O13, C1 | discharged |
| O11 | max K_l<=b0 | C3 | Cap scope | hypothesis | Conditional statement only | discharged |
| O12 | \(Z-b_0\Delta\ge\sigma_0\) | C3 | Square completion | algebraic/logical step | Equation (5), c0²−1=2c0 | discharged |
| O13 | \(\mathbb E wg\ge-\|w\|_\infty\delta\) | C3 | Weighted loss | algebraic/logical step | w>=0 and decomposition g=g+−g− | discharged |
| C4 | Actual-loop covariance lower bound, with no RHS>=1 assertion | root | Supplied loop alternative | major claim | Exact loop normalization and covariance CS | discharged |
| C5 | Minimum-mass quantitative density bound | root | Separate direct finite route | major claim | O14--O19 and C1 | discharged |
| O14 | min mu>=1/10, and at least two states in the nontrivial case | C5 | Corollary scope | hypothesis | Separate conditional theorem | discharged |
| O15 | Centered cubic row mass <=L_mu−2 | C5 | Completeness | algebraic/logical step | Subtract both constant rows; intersection zero | discharged |
| O16 | M(a,b,c)<=(L_mu−2)sigma(a+b+c) | C5 | Moment bound | named theorem | Weighted AM--GM, positive exponents, cubic symmetry | discharged |
| O17 | K_l<=L_mu and Y<=2(L_mu−2)sigma0 | C5 | Original-law cap | algebraic/logical step | Markov rows; exponent monotonicity; O16 | discharged |
| O18 | Two L_mu ranges give coefficient 57−40sqrt2>0 | C5 | Finite endpoint bound | algebraic/logical step | L_mu<=10 and 57²>3200 | discharged |
| O19 | One-state F=1; nonconstant T makes sigma0>0 | C5 | Edge and strictness cases | algebraic/logical step | Self-adjoint T, A=T², positive exponent | discharged |

## Verdict

For the unrestricted conclusion **NOT ESTABLISHED BY THIS PROOF**:
the supplied route fails to discharge \(O7\). This does not show the
target is false or rule out a different proof.

For the capped result \(C3\) and the separately derived minimum-mass
result \(C5\), **FOLLOWS**: their stated hypotheses discharge every
required leaf. Neither verdict supplies Lean acceptance or a full
external audit.
