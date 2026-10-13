# A finite obstruction to nested-projection coarse domination

## Verdict and scope

The proposed signed binary-channel extension with coarse square in
$\operatorname{conv}\{\mathrm{Id},\Pi,P\}$ is **false as a coarse-domination statement**, even when all three coefficients are strictly positive and the fine actual root is strictly positive.

This note gives a fully specified rational ten-state host and an admissible tuple with

$$
1<F(T;n)<F(S;n).
$$

Thus it does **not** refute the original target $F(T;n)\ge1$. It identifies an obstruction to the stronger contraction $F(T;n)\ge F(S;n)$ and to the proposed coefficientwise nested-projection argument. No novelty or Lean claim is made.

The exact weighted construction uses a rational compressed-power seed supplied independently in [continuation3_tensor.md](continuation3_tensor.md), Section 2. Its arithmetic certificate was independently executed for this note; the exact trace numerator and denominator are recorded in [continuation3_seed_exact.json](continuation3_seed_exact.json). The construction below turns that seed into an actual nonnegative Markov root. Nothing is inferred from a rounded numerical trace.

## 1. Rational seed and exact negative trace

Let $e_0,\ldots,e_4$ be the Euclidean basis, and set $t=1/16$. If $w,e$ are orthogonal unit vectors and $c^2+s^2=1$, define

$$
G(w,e;c,s)=I+(c-1)(ww^\top+ee^\top)+s(we^\top-ew^\top).
$$

This is orthogonal. Define

$$
w_2=(3e_0+4e_1)/5,\qquad w_3=(3e_0-4e_1)/5,
$$

$$
\begin{aligned}
U={}&G(e_0,e_2;63/65,16/65)\\
&\cdot G\left(w_2,e_3;\frac{1-t^6}{1+t^6},
                       \frac{2t^3}{1+t^6}\right)\\
&\cdot G\left(w_3,e_4;\frac{1-t^{16}}{1+t^{16}},
                       \frac{2t^8}{1+t^{16}}\right),
\end{aligned}
$$

and

$$
R=U\operatorname{diag}(0,0,t^4,t^2,1)U^\top.
$$

All entries are rational. The matrix $R$ is symmetric, PSD, and has operator norm one. Let $E$ be coordinate restriction to $\{0,1\}$. Exact rational calculation gives

$$
\tau=\operatorname{tr}\bigl((ER^2E)(ER^4E)(ER^6E)\bigr)<-\eta,
\qquad \eta=2^{-156}. \tag{1}
$$

The executable certificate in the linked seed note constructs the three rational rotations, checks $UU^\top=I$, computes the three powers directly, and compares this rational trace with $-2^{-156}$ by integer arithmetic. The three compressed matrices are PSD, but their product has negative trace.

The strict inequality (1), symmetry, and $\|R\|=1$ are the only seed facts used below.

## 2. Exact original measures and actual host

Set

$$
L=2^{41},\qquad D=2+3L^2,\qquad
w=(1,1,L,L,L),\qquad
\pi_i=\frac{w_i^2}{D}\quad(0\le i\le4).
$$

Thus all five coarse masses are positive and sum to one. Let $P$ be conditional averaging on the partition

$$
\{0,1\},\quad\{2\},\quad\{3\},\quad\{4\}.
$$

If $m_B=\sum_{i\in B}\pi_i$, its **relative kernel** is

$$
P(i,j)=\frac{\mathbf1_{\{i,j\text{ lie in the same block }B\}}}{m_B}.
$$

In particular, $m_{\{0,1\}}=2/D$, while every singleton block has mass $L^2/D$. Write
$\mathrm{Id}(i,j)=\mathbf1_{i=j}/\pi_i$ and $\Pi(i,j)=1$.

Choose the following exact positive rational parameters:

$$
\varepsilon=\frac{\eta}{1024D^4},\qquad
\delta=\frac{\varepsilon}{2D},
$$

and relative kernels

$$
S=\varepsilon\,\mathrm{Id}+(1-2\varepsilon)P+\varepsilon\Pi,
\qquad
H(i,j)=\frac{\varepsilon R_{ij}}{2w_iw_j}. \tag{2}
$$

Every composition in this note uses the original measure $\pi$. In particular,

$$
S^2=\varepsilon^2\mathrm{Id}
 +(1-2\varepsilon)P
 +(2\varepsilon-\varepsilon^2)\Pi. \tag{3}
$$

All three coefficients are strictly positive and sum to one. The projections are nested:
$\Pi\le P\le\mathrm{Id}$. Thus this example is inside the proposed hierarchical coarse-square class with no coefficient forced to an endpoint.

Use uniform binary fibers over these five coarse states:

$$
X=\{0,1,2,3,4\}\times\{-1,+1\},\qquad
\mu(i,a)=\pi_i/2.
$$

The ten-state root and bounded host are

$$
T((i,a),(j,b))=S(i,j)+H(i,j)ab,\qquad
p=\frac1{2D},\qquad W=pT. \tag{4}
$$

These are the complete exact data of the host; all quantities are rational.

### Admissibility

The kernel $S$ is symmetric nonnegative Markov. Since $S(i,j)\ge\varepsilon$,
$|R_{ij}|\le1$, and $w_i\ge1$,

$$
|H(i,j)|\le\varepsilon/2<S(i,j).
$$

Therefore $T$ is strictly positive, symmetric, and Markov under the original masses $\mu$. Its row sum is one because averaging the target sign removes the $H$ term.

Also $\max S\le D$ and $\max T\le D+\varepsilon/2<2D$, so (4) gives $0<W<1$. Every original-$\mu$ weighted row of $W$ has sum $p>0$.

The original weighted operator matrix of $H$, conjugated to Euclidean coordinates, is

$$
\operatorname{diag}(\sqrt\pi)\,H\,\operatorname{diag}(\sqrt\pi)
=\delta R. \tag{5}
$$

Thus the root itself is PSD as well as entrywise positive: its even and odd fiber subspaces carry $S$ and $\delta R$, respectively. PSD of the root is an additional fact, not a substitute for the admissibility proof.

The counterexample tuple is

$$
(k,u,r,l,h)=(8,2,3,1,1),\qquad
(n_{ab},n_{ac},n_{ad},n_{bc},n_{bd},n_{cd})
=(8,4,2,3,2,1). \tag{6}
$$

It satisfies all required inequalities, and $N=\sum_e n_e=20$.


## 3. Exact signed-cycle expansion and leading coefficient

Define the relative kernel

$$
H_0(i,j)=\frac{D R_{ij}}{w_iw_j},
\qquad H=\delta H_0.
$$

Cancellation of the original intermediate masses gives, for every $m\ge1$,

$$
H_0^m(i,j)=\frac{D(R^m)_{ij}}{w_iw_j}. \tag{7}
$$

Indeed the factor $\pi_t=w_t^2/D$ cancels the two occurrences of $w_t$ and one occurrence of $D$ in a composition. In particular, for every positive $n$,

$$
|H_0^{2n}(i,j)|\le D. \tag{8}
$$

The bound follows from $\|R^{2n}\|\le1$, with no entrywise sign claim.

Averaging the four independent fiber signs leaves exactly the empty subgraph, four triangles, and three quadrilaterals. Therefore

$$
F(T;n)-F(S;n)
=\sum_C \delta^{2q_C}\,\Gamma_C(\varepsilon), \tag{9}
$$

where $C$ ranges over those seven cycles, $q_C=\sum_{e\in C}n_e$, and

$$
\Gamma_C(\varepsilon)=
\mathbb E_{i_a,i_b,i_c,i_d\sim\pi}
\prod_{e\in C}H_0^{2n_e}(i_{e_-},i_{e_+})
\prod_{e\notin C}S^{2n_e}(i_{e_-},i_{e_+}). \tag{10}
$$

The cycle weights for (6) are:

| Cycle | Weight $q_C$ |
|---|---:|
| $bcd$ | $6$ |
| $acd$ | $7$ |
| $abd$ | $12$ |
| $abc$ | $15$ |
| $a-b-c-d-a$ | $14$ |
| $a-b-d-c-a$ | $15$ |
| $a-c-b-d-a$ | $11$ |

Hence $bcd$ is the unique lowest-order channel term.

### Weighted block amplification at $\varepsilon=0$

Put $\Gamma_0=\Gamma_{bcd}(0)$, meaning that the three complementary coarse factors are replaced by $P$. These factors constrain the hub $a$ and the triangle vertices $b,c,d$ to lie in one block $B$. Their three factors $m_B^{-1}$ and the hub's measure sum $m_B$ leave $m_B^{-2}$, while the remaining original vertex weights convert (7) to the ordinary compressed trace. Thus

$$
\Gamma_0
=\frac{D^2}{4}\tau+
 \frac{D^2}{L^4}\sum_{j=2}^4
 (R^2)_{jj}(R^4)_{jj}(R^6)_{jj}. \tag{11}
$$

Each singleton product lies in $[0,1]$, because every even power of $R$ is a PSD contraction. By (1) and the exact choices $L=2^{41}$, $\eta=2^{-156}$,

$$
\frac3{L^4}=\frac{3\eta}{256}\le\frac{\eta}{8}.
$$

Consequently

$$
\Gamma_0\le-\frac{D^2\eta}{8}. \tag{12}
$$

This is the place where the original block masses matter. Unweighted compression, or silently replacing the block measures by uniform conditional measures without their $m_B^{-2}$ factors, would lose the mechanism.

### Passing to strictly positive global mixing

The nested projections give the exact formula

$$
S^m=\varepsilon^m\mathrm{Id}
 +\bigl((1-\varepsilon)^m-\varepsilon^m\bigr)P
 +\bigl(1-(1-\varepsilon)^m\bigr)\Pi. \tag{13}
$$

Its coefficients are nonnegative for $0<\varepsilon<1/2$. Hence $\max S^m\le D$. Moreover,

$$
S^m-P=\varepsilon^m(\mathrm{Id}-P)
 +\bigl(1-(1-\varepsilon)^m\bigr)(\Pi-P).
$$

Since $\|\mathrm{Id}-P\|_{\max}\le D$, $\|\Pi-P\|_{\max}\le D$, and
$1-(1-\varepsilon)^m\le m\varepsilon$,

$$
\|S^m-P\|_{\max}\le(m+1)\varepsilon D. \tag{14}
$$

For the leading triangle, its three complementary powers have root exponents $16,8,4$. Telescoping their product and using (8) gives

$$
|\Gamma_{bcd}(\varepsilon)-\Gamma_0|
\le(17+9+5)\varepsilon D^6
=31\varepsilon D^6
=\frac{31D^2\eta}{1024}.
$$

Combining this with (12),

$$
\Gamma_{bcd}(\varepsilon)\le-\frac{D^2\eta}{16}. \tag{15}
$$

The displayed constants leave a strict margin; no limiting parameter is left unspecified.

### The six higher cycle terms

Every factor in (10) has absolute value at most $D$, so

$$
|\Gamma_C(\varepsilon)|\le D^6.
$$

The other six cycle weights are all at least seven. Since $0<\delta<1$, their total contribution to (9) is at most $6D^6\delta^{14}$. The exact parameter
$\delta=\eta/(2048D^5)$ satisfies

$$
\delta^2\le\frac{\eta}{192D^4}.
$$

Equations (9) and (15) therefore yield the explicit strict inequality

$$
\boxed{
F(T;n)-F(S;n)
\le-\frac{D^2\eta}{32}\delta^{12}<0.
} \tag{16}
$$

This is an exact finite certificate against the claimed coarse domination. It is derived entirely from the actual common-root channel expansion, exact seed arithmetic, and rational inequalities.

## 4. The actual target remains positive in this example

The counterexample above is to (stronger) coarse domination. Its actual target density remains well above one.

For each coarse even power in (13), the coefficient of $P$ is

$$
b_n=(1-\varepsilon)^{2n}-\varepsilon^{2n}
\ge1-(2n+1)\varepsilon.
$$

For the six exponents in (6), $\sum_e(2n_e+1)=46$. Since $\varepsilon<1/92$,

$$
\prod_e b_{n_e}\ge1-46\varepsilon>\frac12.
$$

Keeping the all-$P$ term in the nonnegative coarse expansion gives

$$
F(S;n)\ge\frac12F(P)
=\frac12\sum_B m_B^{-2}\ge\frac{D^2}{8}. \tag{17}
$$

On the other hand, all seven terms in (9) have cycle weight at least six. Thus

$$
|F(T;n)-F(S;n)|\le7D^6\delta^{12}<1.
$$

It follows that

$$
\boxed{F(T;n)>\frac{D^2}{8}-1>1.} \tag{18}
$$

In particular, neither (16) nor the negative compressed trace is being presented as a counterexample to the original common-power density target.

## 5. Bands, endpoints, and limitation of the obstruction

The coarse root $S$ has centered eigenvalues $1-\varepsilon$ on the three-dimensional block-constant centered subspace and $\varepsilon$ on the one-dimensional within-block centered subspace. The odd channel has eigenvalues $\delta$, $\delta t^2$, $\delta t^4$, and two zeros. Consequently the fine square has five distinct positive centered values and an additional zero value. The three channel values are strictly below $\varepsilon^2$; the other two are $\varepsilon^2$ and $(1-\varepsilon)^2$. All six values belong to the entire centered space and are explicitly accounted for.

At the endpoint $\varepsilon=0$, a nonnegative actual root with coarse square supported on $P$ would force the even channel to preserve those blocks. Our negative seed is not asserted admissible at that endpoint. The explicit strictly positive $\varepsilon$ and smaller $\delta$ in (2)–(5) are essential: they allow tiny cross-block channel transitions while preserving actual root nonnegativity.

The result leaves intact the separately proved extension
$S^2=\rho\,\mathrm{Id}+(1-\rho)P$, where support forces block preservation. It disproves the unrestricted addition of a positive global $\Pi$ coefficient to that theorem without a new compensating hypothesis. No general failure of $F(T)\ge1$ follows.
