# Signed-channel contraction with an unrestricted uniform coarse kernel

**Scope.** This is a restricted theorem for the actual binary-fiber root below.
It does not prove the unrestricted common-power density inequality. Its coarse
kernel is arbitrary; its extra hypothesis concerns the square of the signed
channel. It is complementary to the flat-coarse theorem in
[continuation2_signed_channel.md](continuation2_signed_channel.md).

## 1. Statement and original-measure transport

Let the coarse space have `m>=1` points with original law `pi_i=1/m`.
Write `Id(i,j)=m 1_{i=j}`, `Pi(i,j)=1`, and `P=Id-Pi`.
Let `S` be an entrywise nonnegative symmetric Markov kernel and `H` a real
symmetric kernel with `|H(i,j)|<=S(i,j)`. Every operator composition below
uses the original uniform coarse law. On `X=I x {-1,1}` with
`mu(i,a)=1/(2m)`, set

\[
T((i,a),(j,b))=S(i,j)+H(i,j)ab.
\tag{1}
\]

This is an actual nonnegative symmetric Markov root. Suppose

\[
H^2=\beta\,\mathrm{Id}+(\alpha-\beta)\Pi,
\qquad 0\le\alpha\le\beta.
\tag{2}
\]

Let `n_e>=1` be six independently chosen positive integers on `K4`, and let
`C` run over its four triangles and three quadrilaterals. Put
`q_C=sum_{e in C} n_e`. Then

\[
\boxed{F(T;n)\ \ge\ F(S;n)
+\sum_C\bigl(\alpha^{q_C}+(m-1)\beta^{q_C}\bigr).}
\tag{3}
\]

In particular, any established lower bound for the coarse density transfers
with an explicit positive surplus whenever `H` is nonzero. No spectral,
dimension, density or mixing condition is imposed on `S`. The uniformity of
the coarse law is a hypothesis of this theorem, not of the unrestricted target.

Summing the intermediate fiber sign with its original probability `1/2`
gives, for every integer `r>=1`,

\[
T^r((i,a),(j,b))=S^r(i,j)+H^r(i,j)ab.
\tag{4}
\]

Thus `L_e=S^{2n_e}` and `B_e=H^{2n_e}` are exactly the two channels of each
actual even power. Averaging the four independent fiber signs in the density
gives the exact identity

\[
F(T;n)-F(S;n)=\sum_C J_C,
\quad
J_C=\mathbb E_{\pi^4}
\prod_{e\in C}B_e\prod_{e\notin C}L_e.
\tag{5}
\]

Only the seven nonempty even subgraphs survive. We prove the stronger
individual bound `J_C>=tr H^{2q_C}`.

If `beta=0`, then `alpha=0` and self-adjointness gives `H=0`, so there is
nothing to prove. Otherwise, (2) gives

\[
B_e=\beta^{n_e}\left[t_e\mathrm{Id}+(1-t_e)P\right],
\qquad t_e=(\alpha/\beta)^{n_e}\in[0,1].
\tag{6}
\]

Notice that `P` has negative off-diagonal entries. We expand the **cycle**
edges in (6); the complementary coarse kernels are kept intact.

## 2. Three elementary coarse bounds

Every `L_x=S^{2x}` is entrywise nonnegative, PSD and Markov. Its constant
eigenvalue is one, and therefore `L_x-Pi` is PSD. Consequently

\[
L_x(i,i)\ge1,\qquad
\operatorname{tr}(L_xL_y)\ge1.
\tag{7}
\]

For any three positive exponents, also

\[
V=\mathbb E_{i,d}L_x(i,d)L_y(i,d)L_z(i,d)\ge1.
\tag{8}
\]

To see (8), expand each factor as `Pi+(L-Pi)`. A one-centered-factor average
is zero. Each two- or three-centered-factor average is nonnegative because
the relevant Schur product is PSD and its average is its quadratic form on
the constant function. This is an entrywise Schur-product argument, not a
claim about a trace of three arbitrary PSD matrices. We will also use

\[
D=\mathbb E_i L_x(i,i)L_y(i,i)\ge1.
\tag{9}
\]

For identity-edge contractions, a tree with `v` vertices contributes the
vertex factor `m^{-v}` and the edge factor `m^{v-1}`, leaving exactly `1/m`.
If all edges of a cycle are identities, its one extra identity edge leaves
one additional factor `m`. No new measure is introduced.

## 3. Triangle contractions

Fix a triangle. Its three complementary edges form a star with kernels
`L_x,L_y,L_z`. If all triangle edges are `P=Id-Pi`, direct expansion gives

\[
U_0=-1+\operatorname{tr}(L_xL_y)
+\operatorname{tr}(L_xL_z)+\operatorname{tr}(L_yL_z)+(m-3)V.
\tag{10}
\]

The eight terms are: `-1` from no identity edges; the three traces from one
identity edge; `-3V` from two; and `mV` from all three. For `m>=3`, (7)-(8)
give `U_0>=m-1`.

For the other choices of identity cycle edges the exact formulas are:

| Number of identity cycle edges | Contracted value |
|---:|---|
| 1 | `(m-2)V + tr(L_x L_y)` |
| 2 | `(m-1)V` |
| 3 | `mV` |

In the first row, `x,y` label the two coarse star edges incident to the
identified triangle vertices. It follows from the entrywise identity
`P(i,j)^2=(m-2)Id(i,j)+Pi(i,j)`. The other rows use `P(i,i)=m-1`.
Every row with at least one remaining `P` is at least `m-1`, and the all
identity row is at least `m`, for `m>=2`.

## 4. Quadrilateral contractions

The two complementary coarse kernels lie on the diagonals; call them
`L_x,L_y`. When all four cycle edges are `P`, expansion gives

\[
U_0=-3+2\operatorname{tr}L_x+2\operatorname{tr}L_y
+2\operatorname{tr}(L_xL_y)+(m-4)D.
\tag{11}
\]

Indeed, zero and one identity edges contribute `1-4`; two adjacent identity
edges give two copies of each single trace; the two pairs of opposite
identity edges give `2tr(L_xL_y)`; three identities give `-4D`; four give
`mD`. For `m>=4`, (7) and (9) imply `U_0>=m-1`.

All other choices have the following exact values, with the stated relabeling
of the complementary diagonal kernels:

| Identity cycle edges | Contracted value |
|---|---|
| One | `-1+tr L_x+tr L_y+tr(L_x L_y)+(m-3)D` |
| Two adjacent | `(m-2)D+tr L_x` (or `tr L_y`) |
| Two opposite | `(m-2)D+tr(L_x L_y)` |
| Three | `(m-1)D` |
| Four | `mD` |

For `m>=3`, the first row is at least `m-1`. For `m>=2`, each of the next
three rows is at least `m-1`, and the final row is at least `m`.

### The three-point case in (11)

This is the only case where a negative coefficient remains. Diagonalize the
common coarse square `S^2` on its two-dimensional centered space. Let the
eigenvalues be `lambda_1>=lambda_2>=0` and let `phi_1,phi_2` be an original-law
orthonormal centered basis. Every such basis on three uniform points satisfies

\[
\mathbb E\phi_i^4=3/2,\qquad
\mathbb E\phi_1^2\phi_2^2=1/2.
\tag{12}
\]

For the first identity, a three-vector with sum zero satisfies
`sum v_i^4=(sum v_i^2)^2/2`. The second follows from the pointwise identity
`phi_1^2+phi_2^2=2` and the first identity.

Set `a_i=lambda_i^x`, `b_i=lambda_i^y`. Their common ordering gives
`a_1b_2+a_2b_1<=a_1b_1+a_2b_2`. Expansion with (12) therefore yields

\[
\begin{aligned}
D&=1+a_1+a_2+b_1+b_2
+\tfrac32(a_1b_1+a_2b_2)+\tfrac12(a_1b_2+a_2b_1)\\
&\le\operatorname{tr}L_x+\operatorname{tr}L_y
+2\operatorname{tr}(L_xL_y)-3.
\end{aligned}
\tag{13}
\]

Substituting into (11) gives `U_0>=tr L_x+tr L_y>=2=m-1`.
Repeated and zero eigenvalues are allowed. This uses that the two coarse
kernels are powers of the same square; it does not assert this bound for two
arbitrary PSD Markov kernels.

### One and two coarse points

For `m=2`, `P(i,j)=s_i s_j` with signs `s=(1,-1)`. Its product around a cycle
is identically one. This handles the all-`P` triangle and quadrilateral
directly. After contracting one identity edge of a quadrilateral the same
observation handles the remaining triangle; its two coarse edges form a
Markov star. All other rows above apply at `m=2`. For `m=1`, `P=0`, and
only the all-identity term survives, with value one.

## 5. Summing the nonnegative mixture

For any fixed cycle, every term of (6) with a remaining `P` has value at least
`m-1`, and the all-identity term has value at least `m`. The mixture weights
sum to one and the all-identity weight is `prod_{e in C}t_e`. Hence

\[
\begin{aligned}
J_C&\ge\beta^{q_C}\left[m-1+\prod_{e\in C}t_e\right]\\
&=(m-1)\beta^{q_C}+\alpha^{q_C}
=\operatorname{tr}H^{2q_C}.
\end{aligned}
\tag{14}
\]

The same expression is obtained when every complementary coarse kernel is
`Pi`. Summing (14) proves (3). Thus the proof supplies a sharp coarse-uniform
baseline for every one of the seven cycle terms. Equality holds throughout
the comparison when `S=Pi` and the actual-root condition permits `H`.
Zero channel eigenvalues, negative eigenvalues of `H` or `S`, and disconnected
actual roots are not excluded. The proof needs no ordering among the six
positive edge exponents.

## 6. An exact strictly positive ten-state example

Let `m=5`, with state `0` the center, and let `M` be the symmetric matrix
whose center diagonal is `12`, four leaf diagonals are `15`, all center-leaf
entries are `1`, and all other entries are zero. Each row sums to `16`.
Define relative coarse kernels

\[
S_0=5M/16,\quad S=\tfrac{31}{32}S_0+\tfrac1{32}\Pi,
\quad H=\tfrac1{64}(\mathrm{Id}-\Pi).
\tag{15}
\]

The original fine law is uniform on ten states. With fine states `(i,a)`,
`a in {-1,1}`, the following is an explicit admissible graphon:

\[
\boxed{
W((i,a),(j,b))=
\frac{155M_{ij}+16+(40\mathbf1_{i=j}-8)ab}{2373},
\qquad p=\frac{512}{2373}.}
\tag{16}
\]

Indeed, `T=W/p=S+Hab`, `min W=8/2373>0`, `max W=1`, and every original
weighted row of `W` is `p`. Here `alpha=0`, `beta=1/4096`.
The four distinct values on the **entire centered space** of `A=T^2` are

\[
\left(\frac{465}{512}\right)^2\ (\text{multiplicity }3),\qquad
\left(\frac{341}{512}\right)^2\ (\text{multiplicity }1),\qquad
\frac1{4096}\ (\text{multiplicity }4),\qquad
0\ (\text{multiplicity }1).
\tag{17}
\]

The zero is explicitly counted. The channel square has negative entries on
every pair of distinct coarse states; a triangle of those signs rules out an
entrywise nonnegative diagonal sign gauge. The coarse square has two unequal
positive centered eigenvalues, so the flat-coarse hypothesis of the earlier
signed theorem fails in this displayed decomposition. The nonnegative-square
channel hypothesis also fails.

Let `y=(341/512)^2` and `N=sum_e n_e`. The previously proved complete
common-cone theorem on the coarse space gives
`F(S;n)>=1+(5^3-1)y^N`. Combining it with (3) gives the global-in-exponents
bound

\[
\boxed{F(T;n)\ge1+124y^N+4\sum_C4096^{-q_C}.}
\tag{18}
\]

At the admissible tuple `(k,u,r,l,h)=(3,1,1,1,1)`, both earlier compensation
tests fail:

\[
p=512/2373<1/4,\qquad
\max A=551157/131072>4.
\tag{19}
\]

This example demonstrates the different hypotheses and the quantitative
surplus. It is not asserted to lie outside every possible relabeling of all
earlier constructions or every fixed-host local neighborhood.

The adjacent standard-library checker verifies the actual finite matrices,
original weighted powers, all seven cycle contributions, the finite-density
comparison, the spectral polynomial, and the endpoint contraction formulas.
Those finite checks are not substitutes for the proof above.
