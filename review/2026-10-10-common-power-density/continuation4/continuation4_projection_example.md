# An actual weighted eight-state projection-channel example

## Scope and the theorem being illustrated

This is an exact example for the projection-channel boundary theorem in
[continuation4_tensor_projection_lemmas.md](continuation4_tensor_projection_lemmas.md).
The unrestricted density target remains unresolved. The theorem permits
arbitrary original weights and any orthogonal projection `Q`, subject to
the actual-root condition `|H|<=S` and `H^2=beta Q`; its target conclusion
here is restricted to `k=u, r=l`.

The entire boundary already satisfies `F>=tr A^(2(u+r))>=1` by the
[direct reflection proof](continuation4_boundary_scope.md), for every
actual root. This example illustrates a retained-coarse-surplus comparison,
not new density coverage. No claim of novelty is made for the comparison.

If `d=rank Q` and `n=(u,r+h,u,r,u,r)`, that theorem proves

\[
F(T;n)\ge F(S;n)+d\sum_C\beta^{q_C},
\qquad q_C=\sum_{e\in C}n_e.
\tag{1}
\]

In the cycle order `abc,abd,acd,bcd,abcd,abdc,acbd`, the seven exponents are

`u+2r+h, 3u, u+2r+h, u+2r, 2u+2r, 2u+2r+h, 2u+2r+h`.

This example has largest coarse atom `3/5`, a noncentral projection, two
centered zero eigenvalues in the fine square, and five distinct values on
its entire centered space. The coarse and channel operators do not commute.

## 1. Complete rational host data

Let the coarse space be `I={0,1,2,3}`, with

\[
\pi=(3/5,1/5,1/10,1/10).
\]

Define the symmetric integer matrix

\[
M=\begin{pmatrix}
59&1&0&0\\
1&18&1&0\\
0&1&8&1\\
0&0&1&9
\end{pmatrix},
\qquad s=(60,20,10,10).
\]

Its row sums are `s`, and `sum s_i=100`. The actual relative root

`S0(i,j)=100 M_ij/(s_i s_j)`

is symmetric and has original-`pi` row sum one. Put

`S=(31/32)S0+(1/32)Pi`, where `Pi(i,j)=1`.

Let `f=(1,0,-3,-3)`. Under the original weights,

`E_pi f=0`, `E_pi f^2=12/5`.

The kernel

\[
Q(i,j)=1+\frac5{12}f_i f_j
=\begin{pmatrix}
17/12&1&-1/4&-1/4\\
1&1&1&1\\
-1/4&1&19/4&19/4\\
-1/4&1&19/4&19/4
\end{pmatrix}
\tag{2}
\]

is the original-law orthogonal projection onto `span{1,f}`. Thus
`Q^2=Q`, `rank Q=2`, and `Q1=1`; it does not annihilate constants. Set

`H=Q/128`, `beta=1/16384`.

Then `H^2=beta Q` under original-`pi` composition. On the eight states
`X=I x {-1,+1}`, ordered first by `i` and then by sign, define

\[
\mu(i,a)=\pi_i/2,
\qquad T((i,a),(j,b))=S(i,j)+\frac{ab}{128}Q(i,j),
\]

\[
\boxed{p=512/4499,\qquad W=pT.}
\tag{3}
\]

Equations (2)-(3) specify every entry of `W` and every original mass as a
rational number. The complete matrix is also serialized in the companion
exact check record.

## 2. Admissibility, powers, and the original measure

Checking the finitely displayed entries gives `|H(i,j)|<=S(i,j)`, and in
fact

`min T=3/128>0`, `max T=4499/512`.

Consequently `0<W<=1`. Symmetry is explicit. Since the intermediate or
target fiber sign has mean zero under its original conditional law `1/2`,

`sum_(j,b) mu(j,b) T((i,a),(j,b))=sum_j pi_j S(i,j)=1`.

Every original-`mu` weighted row sum of `W` is therefore exactly the `p`
in (3). The same sign averaging, inductively, proves

\[
T^{2n}((i,a),(j,b))=S^{2n}(i,j)+ab\,\beta^n Q(i,j),\qquad n\ge1.
\tag{4}
\]

No conditional measure replaces `pi` or `mu` in a composition or density.
The exact checker also squares the full eight-state root directly and
compares every entry of (4), without relying on the channel formula to
construct that square.

## 3. Independent certification of the coarse lower bound

The kernel `S0` is TP2 in the displayed path order: all its ordered two-by-two
minors are nonnegative. Positive row and column rescaling reduces this to
the matrix `M`, whose minors can be checked directly; the exact checker
checks all 36 of them. The refresh kernel `Pi` is also TP2 and Markov.

Thus `S` belongs to the finite convex hull, in one common order, of TP2
Markov kernels with the same original measure. This class is closed under
original-measure composition, and the independently chosen edge-kernel
density bound proved in the preceding [TP2 note](../tp2-class.md) gives

`F(S;n)>=1` for all six positive exponents.

For precision, this coarse certificate uses that earlier finite-chain
application of Ruozzi's sorting/cover theorem; it is not a new general
claim about coarse roots. The primary inputs are Ruozzi (2012), Theorems
3.8 and 4.1, and Ruozzi (2013), the finite-chain/distributive-lattice
extension discussed at the beginning of the paper:

- https://arxiv.org/abs/1202.6035
- https://arxiv.org/abs/1309.6859

Combining this coarse certificate with (1), for every `u,r,h>=1`, proves

\[
\boxed{F(T;u,u,r,r,h)\ge1+2\sum_C 16384^{-q_C}>1.}
\tag{5}
\]

At the exact tuple boundary `(1,1,1,1,1)`, the cycle exponents are
`(4,3,4,3,4,5,5)`, so the explicit bound is

`F >= 1 + 4 beta^3 + 6 beta^4 + 4 beta^5`, `beta=2^(-14)`.

The spectral refinement of the triangle estimate and the exact Schur
surplus of each quadrilateral give stronger bounds if retained. Bound (5)
is the simple dimension-only consequence.

## 4. Spectrum and separation from the particular preceding premises

The transition matrix of `S0` is an irreducible tridiagonal matrix similar
to a real symmetric tridiagonal matrix with nonzero adjacent entries. Its
eigenvalues are simple: in an eigenvector, its first coordinate and the
eigenvalue determine all subsequent coordinates by the three-term recurrence;
zero first coordinate forces the zero vector. Symmetry makes algebraic and
geometric multiplicities agree.

Every holding probability of `S0` is at least `4/5`. Therefore
`S0=(4/5)Id+(1/5)R` for an actual self-adjoint Markov root `R`. Its spectrum
lies in `[-1,1]` by the Markov contraction inequality, so every eigenvalue
of `S0` is at least `3/5`. Exactly one eigenvalue is one, since the path is
connected. Write its three distinct centered eigenvalues as `lambda_j`.

The three centered eigenvalues of `S` are `(31/32)lambda_j`. The fine
root acts as `S` on sign-constant functions and as `H` on sign-odd functions.
Consequently its square has, on its entire centered space,

\[
\left(\frac{31}{32}\lambda_j\right)^2\ (j=1,2,3),
\qquad \beta\text{ with multiplicity }2,
\qquad 0\text{ with multiplicity }2.
\tag{6}
\]

The three coarse values are distinct and at least `(93/160)^2>beta`, so
(6) has **five** distinct centered values, including zero. The exact
checker computes the full characteristic polynomial of the actual
eight-state square and verifies the factorization in (6).

Also

`p=512/4499<1/4`, `max_(x,y) A(x,y)=2541919/327680>4`.

This example therefore fails the two older simple density/mixing tests at
the minimal tuple, and it is outside the earlier uniform-coarse and
maximum-coarse-atom-at-most-`1/4` premises. It does not satisfy the entire
centered two-value premise. It is not claimed to avoid every other
restricted argument or every fixed-host local neighborhood in the repository.
In particular, the direct reflection argument just stated already proves
its boundary density inequality without any projection hypothesis.

The channel-square triangle product

`Q(0,1)Q(1,2)Q(2,0)=-1/4`

is negative. Hence no choice of binary sign gauges at the four coarse
states makes the channel square entrywise nonnegative. The exact check
also verifies `SQ!=QS`. Neither commutation nor nonnegative channel-square
entries are being smuggled into the proof.

## 5. Exact verification and boundary tests

Run `python continuation4_projection_verify.py` using the standard library.
It verifies 60 exact contraction checks and 11 host/tuple pairs on seven
actual roots. The fixed cases include this unequal-weight noncentral
projection, a centered rank-two projection, negative channel eigenvalues,
the zero channel, one coarse state with a nonzero channel, a connected
bipartite coarse root whose square disconnects, and a weighted disconnected
root. Every density is evaluated using its original weights.

The checker also tests the quadrilateral lemma with two independent
noncommuting PSD Markov diagonal kernels, verifies both nonnegative terms
in its exact Schur surplus, and compares the triangle's direct finite
integral with the matrix-field trace and its Cauchy--Schwarz bound. Equality
at the refresh kernel is checked exactly. These finite checks supplement
the written proofs; the theorem does not depend on a numerical scan.
