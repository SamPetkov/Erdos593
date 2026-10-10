# Active ac-mode positivity fails for an actual ten-state root

## Verdict and exact scope

The proposed sufficient lemma

\[
d_i=\mathbb E_{a,b,c,d}\phi_i(a)\phi_i(c)
 K_k(a,b)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d)\ge0
\]

for every actual active eigenfunction, under `k>=u` and `r>=l`, is false.
The counterexample below has a strictly positive rational actual root,
strictly positive original weights, and nine distinct positive values on
the entire centered square spectrum. It uses

\[
(k,u,r,l,h)=(8,1,2,1,1).
\]

An exact nonnegative spectral average of the coefficients satisfies

\[
\boxed{-\frac1{10000}<\sum_i w_i d_i<-\frac1{20000},
\qquad w_i\ge0,\quad\sum_iw_i=1.}
\]

Every square eigenmode is active. The constant coefficient is positive,
so at least one centered active eigenfunction has `d_i<-1/20000`.

This is **not** a counterexample to the full common-power density target.
At the displayed admissible tuple, the same actual host satisfies the
exact bound

\[
\boxed{F>4.}
\]

It also does not prove a failure of monotonicity in `h`: a negative single
coefficient need not overcome the other modal contributions. The complete
target remains unresolved.

All finite assertions are checked by `continuation7_opt_ac_exact.py`
using only integer and `fractions.Fraction` arithmetic. No eigensolver,
floating sign, or interval claim about an irrational eigenvector enters
the certificate.

## 1. Complete actual host

Let the states be `0,...,9`. Define a symmetric integer conductance
matrix `G` by the following diagonal entries:

\[
(1480000000000,2450,602,20500,385,152,780,445000,
611000000,1480000000000),
\]

and the following adjacent conductances `G(i,i+1)=G(i+1,i)`:

\[
(188000,321000,12800000,5990000,6520,801,97700,
41200000,9200000000).
\]

There is one additional undirected edge,

\[
G(3,9)=G(9,3)=4310000000.
\]

All unspecified entries are zero. Its row sums and their total are

\[
\begin{aligned}
s={}&(1480000188000,511450,13121602,4328810500,5996905,\\
&7473,99281,41742700,9852200000,1493510000000),\\
M={}&2987752677911.
\end{aligned}
\]

The **original probability** is

\[
\mu_i=s_i/M.
\]

Define the relative actual root

\[
\boxed{
T(i,j)=\frac{4095}{4096}\frac{M G(i,j)}{s_i s_j}
       +\frac1{4096}.
}
\]

Symmetry and strict positivity are immediate. Original-law row sums are

\[
\sum_j\mu_jT(i,j)
=\frac{4095}{4096}\frac{\sum_jG(i,j)}{s_i}
 +\frac1{4096}=1.
\]

Thus `T` is an actual nonnegative self-adjoint Markov root. Set

\[
\boxed{
p=\frac{\mu_{\min}}2=\frac{159}{127138411826},\qquad W=pT.
}
\]

Markovness and nonnegativity give `T(i,j)<=1/mu_j<=1/mu_min`, so
`0<W<=1/2`. Every original weighted row of `W` is `p`. This proves all
host admissibility conditions without assuming a realizable root from
PSD data.

The ordinary transition matrix representing this same root is

\[
P_{ij}=\mu_jT(i,j)
=\frac{4095}{4096}\frac{G(i,j)}{s_i}
 +\frac1{4096}\frac{s_j}{M}.
\]

All powers are computed under the original law:

\[
A=T^2,\qquad K_j(a,b)=\frac{(P^{2j})_{ab}}{\mu_b}.
\]

## 2. The coefficient being refuted

For the fixed four parameters `(k,u,r,l)=(8,1,2,1)`, define the relative
kernel

\[
D(a,c)=\sum_{b,d}\mu_b\mu_d
 K_8(a,b)K_1(a,d)K_2(b,c)K_1(b,d)K_1(c,d).
\]

It is entrywise strictly positive, but need not be self-adjoint. Its
ordinary operator matrix is

\[
D^{\mathrm{op}}_{ac}=D(a,c)\mu_c.
\]

For every original-law orthonormal eigenfunction of `P`, hence of `A`,
put

\[
d_i=\langle\phi_i,D\phi_i\rangle_{L^2(\mu)}.
\]

Expanding only the `ac` factor in the actual density gives

\[
F(h)=\sum_i\theta_i^{2+h}d_i,
\qquad \theta_i=\sigma_i^2,
\]

where `sigma_i` is the root eigenvalue. These are precisely the proposed
`ac` coefficients; the root is not changed between factors.

## 3. A rational positive spectral filter detects the sign

Let

\[
J=\operatorname{adj}(1024P-I),\qquad
H=\frac{J^2}{\operatorname{tr}(J^2)}.
\]

The exact verifier proves `det(1024P-I)!=0`. Therefore `J` is a nonzero
real scalar multiple of `(1024P-I)^(-1)`. Since `P` is self-adjoint in
the original `L^2(mu)`, `J` is self-adjoint in that same space and
commutes with `P`. Hence `J^2` is PSD, `tr(J^2)>0`, and `H` is a
PSD commuting operator of trace one. This use of a PSD spectral filter
does not replace any target edge kernel by an arbitrary PSD kernel; it
tests the signs of the actual coefficients defined in Section 2.

In an original-law orthonormal eigenbasis of `P`, write the eigenvalues
of `H` as `w_i`. Then

\[
w_i\ge0,\qquad \sum_iw_i=1,
\qquad
\operatorname{tr}(H D^{\mathrm{op}})=\sum_iw_id_i.
\]

An eigenbasis of `P` is also an eigenbasis of `A=P^2`; no arbitrary
function replaces an actual eigenfunction. Exact integer elimination
proves `det P!=0`, so all these square eigenvalues are strictly positive.

The exact arithmetic certificate establishes

\[
\boxed{
-\frac1{10000}<\operatorname{tr}(H D^{\mathrm{op}})
<-\frac1{20000}.
}
\]

Because this is a convex combination, some active coefficient obeys
`d_i<-1/20000`. The constant coefficient is positive because `D` is
entrywise positive, so the negative coefficient is centered. This
refutes the modal-positivity lemma under its stated order assumptions.

## 4. Explicit integer evaluation of the certificate

The following formulas specify the finite sign computation without any
spectral approximation. Put `L=lcm(s_0,...,s_9)` and initially set

\[
R=4096LM,\qquad
N_{ij}=4095M\frac L{s_i}G(i,j)+Ls_j.
\]

Then `P=N/R`. The verifier divides `R` and all entries of `N` by their
common gcd; this preserves `P`. For each positive `j`, define the
symmetric integer matrix

\[
E_j(a,b)=M\frac L{s_b}(N^{2j})_{ab}.
\]

The actual original-law kernel is exactly

\[
K_j(a,b)=\frac{E_j(a,b)}{L R^{2j}}.
\]

Its weighted composition checks include `K_1^2=K_2`, `K_2^2=K_4`, and
`K_4^2=K_8`, with every original weight retained.

The integer numerator of `D(a,c)` is

\[
\mathcal D_{ac}
=\sum_{b,d}s_bs_d
 E_8(a,b)E_1(a,d)E_2(b,c)E_1(b,d)E_1(c,d),
\]

with common denominator

\[
D_*=M^2L^5R^{26}.
\]

Set `C=1024N-RI`. Let `J_*` be `adj(C)` divided by the gcd of all its
entries, and set `H_*=J_*^2`. The scalar divisions between `J_*` and
`adj(1024P-I)` cancel after normalization. The claimed filtered average
is the exact rational number

\[
\boxed{
\frac{\displaystyle\sum_{i,j}(H_*)_{ij}\mathcal D_{ji}s_i}
     {\displaystyle M D_*\operatorname{tr}(H_*)}.
}
\]

The numerator uses `s_i`, not `s_j`: it is the ordinary trace of
`H_* D^op`, whose `ji` entry is `D(j,i)mu_i`. This explicitly checks the
weighted normalization at the final contraction.

The verifier constructs the adjugate by fraction-free Gauss–Jordan
elimination, checks every division, verifies `C adj(C)=det(C)I`, checks
original-law self-adjointness of `J_*`, and checks commutation with `N`.
It then checks the two displayed rational inequalities by exact integer
arithmetic. The complete reduced rational value is retained in
`continuation7_opt_ac_exact_checks.json`. Its approximate value,
`-0.0000826103640195177`, is included only to indicate scale.

## 5. Entire centered spectrum and the full target

In addition to `det N!=0`, exact elimination gives

\[
\det[e_0,N^2e_0,(N^2)^2e_0,\ldots,(N^2)^9e_0]\ne0.
\]

Thus the minimal polynomial of `N^2` has degree ten. Since the associated
operator is self-adjoint, it has ten distinct eigenvalues. Strict
positivity of `P` gives a unique eigenvalue one and places all other
root eigenvalues strictly between minus one and one. Invertibility
excludes zero. Consequently the whole centered space of `A` has
**nine distinct positive spectral values**, with no omitted zero band.

For the actual target tuple `(8,1,2,1,1)`, the six powers are

\[
(8,3,1,2,1,1),\qquad \sum_e n_e=16.
\]

Nonnegativity permits restricting every intermediate state of a
`2j`-step root composition to zero:

\[
K_j(0,0)=\frac{(P^{2j})_{00}}{\mu_0}
\ge\frac{P_{00}^{2j}}{\mu_0}.
\]

Restricting all four branch states to zero then proves

\[
F\ge\mu_0^4\prod_{e=1}^6\frac{P_{00}^{2n_e}}{\mu_0}
=\mu_0^{-2}P_{00}^{32}>4.
\]

The last strict inequality is an exact rational comparison in the
verifier. The approximate lower bound is `4.059304742738523`. This
argument does not use modal positivity, a coarse density theorem, or
the missing unrestricted target.

## 6. Reproduction and use

Run `python continuation7_opt_ac_exact.py`. Its certificate is
independent of the discovery diagnostics and uses no external numerical
packages. It verifies the complete original host, actual powers,
invertibility, full centered band count, the negative active spectral
average, and the strict positive bound for the complete target.

The construction rules out ac-mode nonnegativity as a proof of
edge-specific monotonicity. It does not create a third outstanding theorem obligation,
resolve the averaged-projection-star route, or settle simultaneous cover
comparison. No priority or novelty claim is made.
