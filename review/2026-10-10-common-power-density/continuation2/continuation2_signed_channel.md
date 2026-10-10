# A global contraction for signed binary channels

## Scope

This is a restricted host theorem, not a proof of the unrestricted common-power
density inequality. Unlike the pointwise Fourier-channel criterion, the theorem
allows the even channel powers to have negative entries. Its proof uses the
seven surviving cycle terms collectively with exact contractions on the coarse
space. All measures below are the original measures.

Let `(I, pi)` be a finite probability space with strictly positive masses. Write
`Pi(i,j)=1` and `Id(i,j)=1_{i=j}/pi_i` for the averaging and identity kernels.
Every kernel product on `I` means

\[
(BC)(i,j)=\sum_t\pi_t B(i,t)C(t,j).
\]

Let `S` be a symmetric nonnegative Markov kernel and let `H` be any symmetric
real kernel such that `|H(i,j)| <= S(i,j)`. On

\[
X=I\times\{-1,1\},\qquad \mu(i,a)=\pi_i/2,
\]

define the actual root

\[
T((i,a),(j,b))=S(i,j)+H(i,j)ab.
\tag{1}
\]

Then `T` is symmetric, nonnegative and Markov. If desired, the graphon data are
`p=1/max T` and `W=pT`; its weighted rows have sum `p` and `0<=W<=1`.
The kernel `H` need not be Markov, PSD, or entrywise nonnegative.

## Theorem

Assume

\[
S^2=\rho\,\mathrm{Id}+(1-\rho)\Pi,
\qquad 0\le\rho\le1.
\tag{2}
\]

For any six independently chosen positive integers `n_e` on the edges of `K4`,
let `F(T;n)` be the density formed from the six kernels `T^{2n_e}` in the
original measure `mu`, and let `F(S;n)` use `S^{2n_e}` in the original measure
`pi`. Then

\[
\boxed{F(T;n)\ge F(S;n)\ge1.}
\tag{3}
\]

The first inequality is strict whenever `H` is not the zero kernel.
In particular, this theorem covers the prescribed tuple, including `k=u`,
`r=l`, and `h=1`, without needing those ordering conditions.

## 1. Exact channel transport

Direct summation over the middle sign gives

\[
\begin{aligned}
T^2((i,a),(j,b))
&=\sum_{t,c}\frac{\pi_t}{2}
[S(i,t)+H(i,t)ac][S(t,j)+H(t,j)cb]\\
&=S^2(i,j)+H^2(i,j)ab.
\end{aligned}
\]

The same calculation, inductively, gives for every integer `m>=1`

\[
T^m((i,a),(j,b))=S^m(i,j)+H^m(i,j)ab.
\tag{4}
\]

There is no change of stationary measure in this identity. In particular,
with `B_e=H^{2n_e}` and `L_e=S^{2n_e}`,

\[
T^{2n_e}=L_e+B_e ab,
\qquad L_e=\rho^{n_e}\mathrm{Id}+(1-\rho^{n_e})\Pi.
\tag{5}
\]

Each `B_e` is PSD on `L^2(pi)`. The `B_e` commute because all are even powers
of the same symmetric `H`. Entrywise positivity of `B_e` is not assumed.

## 2. The seven cycle terms

Expand the product of the six factors in (5), then average the four independent
uniform signs. A selected set of `B`-edges survives exactly when every vertex
has even degree in it. In `K4`, the nonempty even subgraphs are precisely its
four triangles and three cycles of length four. Consequently,

\[
F(T;n)-F(S;n)
=\sum_{C\in\mathcal C}
\mathbb E_{i_a,i_b,i_c,i_d\sim\pi}
\prod_{e\in C}B_e(i_{e_-},i_{e_+})
\prod_{e\notin C}L_e(i_{e_-},i_{e_+}).
\tag{6}
\]

It remains to prove that every cycle term in (6) is nonnegative.

## 3. Original-measure contraction of identity edges

In a cycle term, expand each complementary `L_e` using (5). The coefficients
are nonnegative. A selected identity edge contributes
`1_{i_v=i_w}/pi_{i_v}`. Every chosen set of complementary edges is a forest:
the complement of a triangle is a three-edge star, and the complement of a
four-cycle is a pair of disjoint diagonals.

For a tree component with `v` vertices, assigning a common coarse color `i`
gives `pi_i^v` from its vertex measures and `pi_i^{-(v-1)}` from its identity
edges, leaving exactly `pi_i`. Thus contracting all these identity edges leaves
one original `pi` factor per identified component. There is no residual inverse
mass factor and no conditional reweighting. Every other complementary edge is
`Pi=1` and disappears.

The possible contractions are as follows. In the table, `s,t,v,w` are the
positive edge exponents on the residual cycle and all diagonal expressions are
relative kernels in the original measure.

| Cycle | Chosen complementary identity edges | Contracted value |
|---|---:|---|
| Triangle | 0 or 1 | `tr H^{2(s+t+v)}` |
| Triangle | 2 | `E_i H^{2s}(i,i) H^{2(t+v)}(i,i)` |
| Triangle | 3 | `E_i H^{2s}(i,i) H^{2t}(i,i) H^{2v}(i,i)` |
| Four-cycle | 0 | `tr H^{2(s+t+v+w)}` |
| Four-cycle | 1 | `E_i H^{2(s+t)}(i,i) H^{2(v+w)}(i,i)` |
| Four-cycle | 2 | `E_{i,j} H^{2s}(i,j) H^{2t}(i,j) H^{2v}(i,j) H^{2w}(i,j)` |

The exponents in a paired diagonal correspond to the two edges on that path;
cyclic relabeling accounts for every choice of contracted edge.

## 4. Positivity of each contracted value

The first and fourth rows are traces of an even power of a self-adjoint
operator and equal a sum of even powers of its real eigenvalues.

Each factor on a diagonal in the other triangle rows or the one-diagonal
four-cycle row is a diagonal entry of a PSD kernel. The pairing of two edges
uses the operator product of two powers of the same `H`, so it is again an
even power of `H`. These rows are therefore nonnegative pointwise in `i`.

For the last row, use a different operation: the **entrywise Schur product**

\[
J=H^{2s}\odot H^{2t}\odot H^{2v}\odot H^{2w}
\]

is PSD. Its original-measure average is

\[
\mathbb E_{i,j}J(i,j)=\langle1,J1\rangle_{L^2(\pi)}\ge0.
\]

For clarity, weighted PSD gives ordinary PSD of the entry matrix by the
congruence `diag(sqrt(pi)) B diag(sqrt(pi))`; Schur's theorem on the entry
matrices then gives weighted PSD of their entrywise product. This step does
not assert positivity of a trace of three or more arbitrary PSD matrices.

Every summand after the expansion of (6) is nonnegative. This proves
`F(T;n)>=F(S;n)`.

## 5. Coarse density and equality at the contraction

The expansion of all six coarse factors into `Id` and `Pi` has nonnegative
coefficients summing to one. For a connected component of the chosen identity
edges with `v` vertices and `e` edges, its density is

\[
\sum_i\pi_i^{v-e}.
\]

The exponent is at most one, so this sum is at least one. Isolated vertices
also contribute one. Hence every coarse expansion term is at least one and
`F(S;n)>=1`.

If `H` is nonzero and `rho<1`, the choice of no complementary identity edges
in any cycle has strictly positive coefficient, and its value is
`tr H^{2m}>0` for a positive integer `m`. Thus the contraction is strict.
If `rho=1`, take a triangle and its three complementary identity edges.
There exists a color `i` with `H^2(i,i)>0`; spectral expansion then gives
`H^{2n}(i,i)>0` for every positive `n`. The third row of the table is strictly
positive after integration. This also proves strictness at `rho=1`.

Zero channel eigenvalues, possible negative root eigenvalues, nonuniform
coarse masses, disconnected coarse hosts, and both endpoints of the parameter
interval are all allowed by this proof.

## 6. Exact pointwise failure inside the globally proved class

Let `I={0,1,2}`, `pi_i=1/3`, `S=Pi`, and

\[
H(i,j)=\frac{3\mathbf1_{i=j}-1}{4}.
\]

The six-state actual root is

\[
T((i,a),(j,b))=1+\frac{3\mathbf1_{i=j}-1}{4}ab,
\quad \mu=1/6,\quad p=2/3,\quad W=\frac23T.
\]

Its entries satisfy `1/2<=T<=3/2`, so `1/3<=W<=1`, and its original weighted
row sums are `p`. Here

\[
H^{2n}=16^{-n}(\mathrm{Id}-\Pi),
\]

which has negative off-diagonal entries for every `n>=1` and cannot be made
entrywise nonnegative by a diagonal sign gauge (the product of the three
off-diagonal signs is negative).

At the admissible tuple `(k,u,r,l,h)=(3,1,1,1,1)`, hence edge exponents
`(3,2,1,1,1,1)`, condition on the coarse colors `(0,0,1,2)` in the order
`a,b,c,d`. Averaging just the four fiber signs gives

\[
1-16^{-3}-16^{-4}+3\cdot16^{-5}-2\cdot16^{-7}
=1-\frac{34433}{134217728}<1.
\tag{7}
\]

In contrast, the full original-measure density is

\[
F(T;n)=1+2\bigl(16^{-3}+16^{-4}+2\cdot16^{-5}
+2\cdot16^{-6}+16^{-7}\bigr)
=1+\frac{70177}{134217728}>1.
\tag{8}
\]

The trace of `Id-Pi` is two, which explains the factor two in (8).
This is an exact failure of **pointwise** conditional fiber domination.
The global signed-channel theorem proves this host's target inequality for
every positive tuple. It is not a global contraction or target counterexample.
