# The complete monochromatic-edge process is a matroid invariant

This note records a direct consequence of the dependence formula in
`MONOCHROMATIC_DEPENDENCE_AND_HYPERTUTTE.md`.

Let \(F\in\mathcal B_r\), let \(M_{\mathrm B}(F)\) be its canonical labelled
Berge-cycle matroid, and color \(V(F)\) independently and uniformly with
\(q\ge2\) colors. Write

\[
X_e=\mathbf 1_{\{e	ext{ is monochromatic}\}}\qquad(e\in E(F)).
\]

For every \(A\subseteq E(F)\), the preceding note proves

\[
\Pr(X_e=1	ext{ for all }e\in A)
=
q^{-(r-2)|A|-r_{\mathrm B}(A)}.
	ag{1}
\]

The upper-set probabilities in (1) determine the complete joint law of the
binary vector \((X_e)_{e\in E(F)}\). Möbius inversion gives, for every
\(S\subseteq E(F)\),

\[
oxed{
\Prigl(\{e:X_e=1\}=Sigr)
=
\sum_{A:\,S\subseteq A\subseteq E(F)}
(-1)^{|A|-|S|}
q^{-(r-2)|A|-r_{\mathrm B}(A)}.
}
	ag{2}
\]

Consequently:

1. the full labelled process \((X_e)\) depends only on \(r\), \(q\), and the
   labelled matroid \(M_{\mathrm B}(F)\);
2. two systems with isomorphic Berge-cycle matroids have identical
   monochromatic-edge processes after transporting edge labels;
3. the distribution of the total number
   \(M_F=\sum_eX_e\) depends only on \(r\), \(q\), and the ordinary Tutte
   polynomial of \(M_{\mathrm B}(F)\);
4. every mixed moment, factorial moment, cumulant, and exact-set probability is
   recoverable from the matroid rank function;
5. attachment geometry outside the Berge-cycle matroid is statistically
   invisible to the entire monochromatic-edge process.

The probability-generating function is

\[
\mathbb E[t^{M_F}]
=
q^{-n}\Phi_F(q,t),
\]

so the Potts--Tutte formula from the main note gives

\[
\mathbb E[t^{M_F}]
=
q^{-n+(r-2)m}
Z_J\!\left(q,(t-1)q^{-(r-2)}ight).
	ag{3}
\]

Equation (2) is stronger than equality of weak chromatic polynomials or of the
first few moments: it identifies the complete random subset of monochromatic
hyperedges.

The existing verifier checks (1) for every edge subset in 24 deterministic
examples. Formula (2) is finite Boolean-lattice inversion of those checked
upper-set probabilities.
