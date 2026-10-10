# A weighted rank-four projection channel with three interacting coarse bands

**Scope.** This is an actual 16-state example of the new all-exponent
projection transfer. Its source has a block grading after one actual
smoothing step, and its visible trace is four. Thus both the exact
cubic-vanishing identity and the broader balanced-rank-ten theorem apply;
these are not counted as two distinct host families. The unrestricted
target remains unresolved.

## The complete finite construction

Use four base states with original probability

\[
\pi=(3/16,3/16,5/16,5/16),
\qquad
S_0=\begin{pmatrix}
44/9&4/9&0&0\\
4/9&40/9&4/15&0\\
0&4/15&72/25&4/25\\
0&0&4/25&76/25
\end{pmatrix},
\quad S={15\over16}S_0+{1\over16}\Pi.
\tag{1}
\]

Equivalently, the reversible flow has conductance `1/64` on each
adjacent path edge and the remaining row mass on its diagonal. Both
roots in (1) are symmetric and Markov under `pi`.

Let

\[
U_0=U_1=I_2,
\quad U_2=\begin{pmatrix}-3/5&-4/5\\4/5&-3/5\end{pmatrix},
\quad U_3=U_2^T.
\tag{2}
\]

These are orthogonal, and `sum_i pi_i U_i=0`. For each `i` take the
two columns `v_(i,a)` of the four-by-two matrix `[U_i; I_2]`. Negate
only `v_(0,0)`; this sign change leaves each outer product unchanged.
On eight refined states `(i,a)`, `a in {0,1}`, set

\[
\widehat\pi_{i,a}=\pi_i/2,\qquad
\widehat S((i,a),(j,b))=S(i,j),\qquad
Q((i,a),(j,b))=2v_{i,a}^Tv_{j,b}.
\tag{3}
\]

The frame sum is
`sum_(i,a) pi_hat_(i,a) (sqrt2 v_(i,a))(sqrt2 v_(i,a))^T=I_4`.
Therefore (3) is an original-law rank-four orthogonal projection. It has
diagonal four and

\[
Q\mathbf1=(-1/4,1,1/4,1,17/20,13/10,17/20,7/10).
\tag{4}
\]

It neither annihilates nor fixes constants and does not commute with
`S_hat`. For example, its triangle on refined indices `0,4,7` has
product `-1536/625`. Thus a nonnegative-entry or nonnegative-triangle
projection argument is not being used.

Use sixteen final states `(i,a,sigma)`, with original probability
`mu(i,a,sigma)=pi_i/4`, and put

\[
H=Q/128,\quad \beta=1/16384,\quad
T((i,a,\sigma),(j,b,\tau))
=S(i,j)+{\sigma\tau\over128}Q((i,a),(j,b)),
\quad p={96\over449},\quad W=pT.
\tag{5}
\]

All quantities are rational. Direct original-law composition gives
`H^2=beta Q`; the minimum and maximum of the actual root are

\[
\min T=1/20,\quad\max T=449/96,
\quad\min W=24/2245>0,\quad\max W=1.
\tag{6}
\]

Every original weighted row of `W` equals `p`. Its actual square has
`max A=50291/12288>4`.

## Why the cubic term disappears

In the frame coordinates, the raw source is
`R_(i,a)=2v_(i,a)v_(i,a)^T`, and its conditional mean is

\[
C_i=\frac12\sum_a R_{i,a}
=\begin{pmatrix}I_2&U_i\\U_i^T&I_2\end{pmatrix}.
\tag{7}
\]

By the explicit original-law refinement transport, all positive-time
fields are the pullbacks of `(S^2)^s C`. Their centered parts lie in the
off-diagonal block space for `diag(I_2,-I_2)`. Consequently every centered
triple trace vanishes, and for all positive `x,y,z`,

\[
J_{xyz}=4+g_{xy}+g_{xz}+g_{yz}\ge4.
\tag{8}
\]

The raw source does **not** satisfy the cubic condition:
`tr((R_(i,a)-I_4)^3)=24`. Smoothing removes its within-fiber part. Also,
`tr(C_0 C_2 C_3)=-48/25`; the argument does not assume that arbitrary
triples of PSD matrices have nonnegative trace.

## Complete centered spectrum and density scope

The reversible path `S0` is similar to an irreducible real symmetric
Jacobi matrix, so it has four simple eigenvalues. Its holding
probabilities are at least `5/6`. Writing
`S0=(5/6)I+(1/6)P` with a self-adjoint Markov `P` shows that its
eigenvalues are at least `5/6-1/6=2/3`.
All are positive. Refresh scales its three centered eigenvalues by
`15/16`, so their squares are distinct and at least `25/64`.

The checker verifies that the Krylov span of the centered matrix-field
coefficients has dimension three, so all three coarse bands interact
with the projection. The refined coarse square has those three values
and an additional zero of multiplicity four. The entire centered fine
square has exactly **five** values:

| Value | Multiplicity |
|---|---:|
| Three distinct positive base centered square eigenvalues | One each |
| `beta=1/16384` | Four |
| `0` | Eight |

In particular, the refined coarse square is not within the earlier
two-value whole-centered theorem. The exact characteristic-polynomial
identity is

`chi_A(z)=chi_(S^2)(z) (z-beta)^4 z^8`.

For completeness, the all-exponent **coarse** lower bound uses the
previously established common-order TP2-convex-hull theorem, not the new
projection argument. All 36 two-by-two minors of `S0` are nonnegative.
Composition preserves TP2 in this same order by weighted Cauchy--Binet.
For each positive integer `n`,

\[
S^{2n}=(15/16)^{2n}S_0^{2n}+
                [1-(15/16)^{2n}]\Pi.
\tag{9}
\]

Each kernel in (9) is in the convex hull of TP2 Markov kernels in that
one order. The previous base-density theorem applies by multilinearity
to six independently chosen such kernels. It does **not** assert that
the refreshed root is itself TP2 or that arbitrary mixtures preserve
cover domination. Pulling back the base root to (3) preserves the
density: the original conditional probabilities sum to one separately
at each of the four variables.

It follows that this actual 16-state host satisfies, for every six
positive exponents,

\[
F(T;n)\ge1+4\sum_{D\in\mathcal C(K_4)}
                      \beta^{\sum_{e\in D}n_e}>1.
\tag{10}
\]

For target tuple `(3,1,1,1,1)`, the seven cycle exponent sums are
`6,5,4,3,6,7,5`, hence the explicit bound is

\[
F\ge1+4(\beta^3+\beta^4+2\beta^5+2\beta^6+\beta^7).
\tag{11}
\]

The checker independently integrates the full sixteen-state density at
two nonreflection tuples and the `k=u,r=l,h=1` boundary, verifies every
actual power and all seven coefficients, and separately checks the
original four-variable star integral. It also checks refresh equality,
the zero channel, and a varying-trace line satisfying the cubic identity.
These computations supplement the written proof.

**Prior input:**
[`../tp2-class.md`](../tp2-class.md), common-order convex-hull and
composition propositions. The seven-cycle and quadrilateral calculations
are written in the companion cubic-subspace theorem and frozen PR #60.
