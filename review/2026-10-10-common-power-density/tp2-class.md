# A convex class of TP2 Markov kernels

**Status — 10 October 2026.** This restricted result was derived earlier during the present consultation. It is an application of established log-supermodular partition-function bounds, followed by elementary convexity and composition arguments. It is not a claimed literature novelty, a proof of the unrestricted common-power density target, or new Lean acceptance.

The input from the literature is Ruozzi's Boolean sorting inequality, [Theorem 3.8 of the 2012 paper](https://arxiv.org/abs/1202.6035); its graph-cover consequence is Theorem 4.1 of that paper. The extension to finite distributive lattices, including finite total orders, is also explicitly discussed at the beginning of the [2013 paper](https://arxiv.org/abs/1309.6859). We spell out the chain embedding and a finite counting argument, so that the normalization, zero entries, and passage to real probability tables are explicit.

## 1. Conventions and statement

Let $X=\{1,\ldots,q\}$ have one fixed total order, and let $\mu_x>0$ with $\sum_x\mu_x=1$. All kernel compositions use this original probability:

$$
(BC)(x,y)=\sum_z\mu_z B(x,z)C(z,y).
$$

The identity and refresh kernels are

$$
I(x,y)=\frac{\mathbf 1_{x=y}}{\mu_y},
\qquad \Pi(x,y)=1.
$$

A nonnegative kernel $K$ is **bistochastic relative to $\mu$** if

$$
\sum_y\mu_yK(x,y)=1,
\qquad
\sum_x\mu_xK(x,y)=1.
$$

Its transition matrix is $P_K(x,y)=\mu_yK(x,y)$. A symmetric Markov kernel is automatically bistochastic in this sense.

The kernel is **TP2** if

$$
K(i,k)K(j,l)\ge K(i,l)K(j,k)
\qquad(i<j,\ k<l).
$$

Let $G=(V,E)$ be a finite simple graph. Fix an orientation for each edge when using kernels that are not symmetric, and put

$$
Z_G(\{K_e\})=
\sum_{x\in X^V}
\prod_{v\in V}\mu_{x_v}
\prod_{e=(u,v)\in E}K_e(x_u,x_v).
$$

**Theorem 1.** If every $K_e$ is nonnegative, TP2 in the same order, and bistochastic relative to the same $\mu$, then

$$
Z_G(\{K_e\})\ge1.
$$

The edge kernels may be chosen independently. The theorem requires neither positive definiteness nor commutation of the edge kernels. Zero entries, isolated vertices, disconnected graphs, and disconnected Markov kernels are allowed. The case $q=1$ is immediate; the proof below covers $q\ge2$.

## 2. The cover upper bound

Write

$$
f(x)=\prod_{v\in V}\mu_{x_v}
      \prod_{e=(u,v)\in E}K_e(x_u,x_v).
$$

For a positive integer $M$, replace each vertex $v$ by copies $(v,1),\ldots,(v,M)$. For every edge $e=(u,v)$ choose a permutation $\sigma_e$ of $\{1,\ldots,M\}$, and join $(u,a)$ to $(v,\sigma_e(a))$. The corresponding cover function and partition function are

$$
g_\sigma(x)=
\prod_{v,a}\mu_{x_{v,a}}
\prod_{e=(u,v),a}K_e(x_{u,a},x_{v,\sigma_e(a)}),
\qquad
Z_\sigma=\sum_x g_\sigma(x).
$$

### Sorting and the finite-chain embedding

For nonnegative functions on a Boolean cube, the specialization of Ruozzi's Theorem 3.8 used here is the following: if $g$ is log-supermodular and

$$
g(x^1,\ldots,x^M)
\le\prod_{a=1}^M f(x^{[a]}),
$$

where $x^{[a]}$ are the coordinate order statistics, then

$$
\sum_{x^1,\ldots,x^M}g(x^1,\ldots,x^M)
\le \left(\sum_x f(x)\right)^M.
$$

The theorem is stated for nonnegative functions and permits zero values. Its graph-cover application is [Ruozzi 2012, Theorem 4.1](https://arxiv.org/abs/1202.6035).

To apply it on a finite chain, encode a state $x$ by its threshold word

$$
\iota(x)=
\bigl(\mathbf 1_{x>1},\ldots,\mathbf 1_{x>q-1}\bigr).
$$

The valid words form a Boolean sublattice and are totally ordered coordinatewise. Their meet, join, and coordinate sorting agree with the corresponding operations on chain states. Extend each function by zero off the valid words. This preserves log-supermodularity: the valid support is a sublattice, and if either original argument is invalid, the product of its value with the other original value is zero. This is the finite-chain version of the sublattice observation recorded in [Ruozzi 2013, Section 1](https://arxiv.org/abs/1309.6859).

A unary weight on a chain is log-supermodular. TP2 is precisely log-supermodularity of the pair factor. Thus both $f$ and every $g_\sigma$ have log-supermodular Boolean extensions.

Now sort the $M$ states over each original vertex. For one edge, pairing the two sorted lists in the same order can only increase the product of its $M$ factors. Indeed, an inversion swap is exactly one TP2 inequality. This argument multiplies inequalities and uses neither logarithms nor division, so it remains valid when some factors vanish. Unary products are unchanged by sorting. Consequently,

$$
g_\sigma(x^1,\ldots,x^M)
\le\prod_{a=1}^M f(x^{[a]}).
$$

The Boolean theorem therefore proves

$$
Z_\sigma\le Z_G^M
\tag{1}
$$

for every cover and every positive integer $M$. No binary encoding of a Bethe entropy is used; the embedding is applied only at the cover inequality.

## 3. An exact finite counting lower bound

Let $b_v(x)$ and $b_e(x,y)$ be rational nonnegative probability tables with consistent edge marginals:

$$
\sum_y b_e(x,y)=b_u(x),
\qquad
\sum_x b_e(x,y)=b_v(y)
\qquad(e=(u,v)).
$$

Require $b_e(x,y)=0$ wherever $K_e(x,y)=0$. Choose $M$ so that all $Mb_v(x)$ and $Mb_e(x,y)$ are integers, and choose the edge permutations independently and uniformly.

The number of assignments having vertex types $b_v$ is

$$
\prod_v\frac{M!}{\prod_x(Mb_v(x))!}.
$$

For any such assignment, the probability that an edge permutation realizes the prescribed joint type $b_e$ is

$$
\frac{
\prod_x(Mb_u(x))!\prod_y(Mb_v(y))!
}{
M!\prod_{x,y}(Mb_e(x,y))!
}.
$$

Retaining exactly these assignments and edge types gives

$$
\mathbb E_\sigma Z_\sigma
\ge C_M(b)\exp\bigl(M\mathcal E(b)\bigr),
\tag{2}
$$

where

$$
C_M(b)=
(M!)^{|V|-|E|}
\frac{
\displaystyle\prod_{v,x}(Mb_v(x))!^{\deg(v)-1}
}{
\displaystyle\prod_{e,x,y}(Mb_e(x,y))!
},
$$

and

$$
\mathcal E(b)=
\sum_{v,x}b_v(x)\log\mu_x
+\sum_{e,x,y:\,K_e(x,y)>0}b_e(x,y)\log K_e(x,y).
$$

All permitted energy coefficients are finite. The right side of (2) is strictly positive. Feasible rational supported types exist by the rational-polytope argument below, so (1) first gives $Z_G>0$ and justifies taking its logarithm.

Using (1), (2), and Stirling's formula along multiples of the common denominator yields

$$
\log Z_G\ge\Phi(b),
\tag{3}
$$

with

$$
\Phi(b)=
\mathcal E(b)+\sum_e H(b_e)
-\sum_v(\deg(v)-1)H(b_v).
$$

The conventions $0!=1$ and $0\log0=0$ cover zero type entries.

### Cancellation at the original Markov marginals

The desired real tables are

$$
b_v(x)=\mu_x,
\qquad
b_e(x,y)=\mu_x\mu_yK_e(x,y).
$$

Both marginal consistency conditions hold because $K_e$ is bistochastic relative to the original $\mu$. Put

$$
I_e=\sum_{x,y:\,K_e(x,y)>0}b_e(x,y)\log K_e(x,y).
$$

Then

$$
H(b_e)=2H(\mu)-I_e,
\qquad
\mathcal E(b)=-|V|H(\mu)+\sum_e I_e.
$$

Since $\sum_v(\deg(v)-1)=2|E|-|V|$, these terms cancel exactly:

$$
\Phi(b)=0.
$$

To remove rationality, consider the polytope of all locally consistent tables with the prescribed edge-support zeros. Its equations and inequalities have rational coefficients, and the displayed real tables belong to it. Rational points are dense in this polytope and in each of its faces. Approximate the real tables by rational supported tables while keeping the original potentials $\mu$ and $K_e$ fixed. Entropy is continuous at zero, and the permitted energy coefficients are finite. Hence $\Phi(b^{(m)})\to0$ in (3), proving $Z_G\ge1$ and Theorem 1.

## 4. Finite convex mixtures and Markov composition

Let $\mathcal C_\mu$ be the finite convex hull of the nonnegative TP2 kernels that are bistochastic relative to $\mu$, all in the same fixed order.

**Corollary 2.** If every edge kernel independently belongs to $\mathcal C_\mu$, then $Z_G\ge1$.

**Proof.** Expand the finite mixtures edge by edge. The partition function is multilinear in the edge kernels. Each resulting summand is a TP2 instance of Theorem 1, with a nonnegative coefficient, and the coefficients sum to one. This is a base-graph density argument; no cover upper bound for arbitrary convex mixtures is asserted. $\square$

**Corollary 3.** The class $\mathcal C_\mu$ is closed under the original-measure composition.

**Proof.** For TP2 kernels $B,C$, weighted Cauchy–Binet gives

$$
\det(BC)[i,j;k,l]
=\sum_{s<t}\mu_s\mu_t
  \det B[i,j;s,t]\det C[s,t;k,l]\ge0.
$$

Both Markov sum conditions are preserved under the same composition. Thus products of TP2 bistochastic kernels are TP2 and bistochastic. Expanding two finite mixtures proves the claim for $\mathcal C_\mu$. Components need not commute or be self-adjoint. $\square$

Both $I$ and $\Pi$ belong to this class. It therefore permits mixtures of $I$, $\Pi$, and any finite number of TP2 Markov kernels in one order.

For the common-power target, suppose the actual root $T$, or the actual square $A=T^2$, belongs to $\mathcal C_\mu$. Every $K_j=A^j$ then belongs to $\mathcal C_\mu$. Corollary 2 proves the target, and in fact the density inequality for every graph and every assignment of positive powers. The target restrictions $k\ge u$, $r\ge l$, and $h\ge1$ are unnecessary within this class.

## 5. Two actual path examples

### Seven states and six positive centered bands

For $q\ge2$, let $Q=I-L_{\mathrm{path}}/4$ be the reflecting lazy-path transition matrix. Its endpoint diagonals are $3/4$, its interior diagonals $1/2$, and its neighboring entries $1/4$. Use uniform $\mu=1/q$ and

$$
W=\frac43Q,
\qquad p=\frac4{3q}.
$$

Then $W\in[0,1]$ is symmetric, its original-$\mu$ row sum is $p$, and the actual normalized root kernel is $T=qQ$. The operator of $T$ is exactly $Q$.

This tridiagonal $Q$ is TP2. A nonzero crossed term in a $2\times2$ minor forces that minor to be adjacent and principal. Its determinant is $5/16$ at an endpoint and $3/16$ in the interior; for $q=2$ the sole determinant is $1/2$. All other minors have a zero crossed term and are nonnegative.

The root and square eigenvalues are

$$
\lambda_j(T)=\cos^2\!\left(\frac{\pi j}{2q}\right),
\qquad
\theta_j(A)=\cos^4\!\left(\frac{\pi j}{2q}\right),
\qquad j=0,\ldots,q-1.
$$

At $q=7$ there are six distinct positive centered values, and $K_1$ still has zero entries. At the simultaneous target boundary $(k,u,r,l,h)=(1,1,1,1,1)$, exact summation gives

$$
F=\frac{800010799}{67108864}>1.
$$

This finite value illustrates the theorem; the theorem proves every tuple.

The convex extension can be strictly larger than bare TP2. For $q=7$, set

$$
R=\frac{99}{100}Q+\frac1{100}\frac J7.
$$

Here $R$ is a transition matrix. Its relative-$\mu$ kernel $7R$ belongs to $\mathcal C_\mu$, and its square kernel is $7R^2$. The latter has equal positive offdiagonals on the three states $\{1,4,7\}$ and strictly larger diagonals there. Whichever of those states is middle in an ordering produces a negative TP2 minor. Thus $7R^2$ is not TP2 in any order. It still has six distinct positive centered values and an actual strictly positive bounded host: take $W=7pR$ with $p=400/2083$, endpoint diagonals of $W$ equal to $1$, interior diagonals $1390/2083$, neighboring entries $697/2083$, and all other entries $4/2083$.

### Six states and a centered zero eigenvalue

For $q=6$, instead take $Q=I-L_{\mathrm{path}}/3$. Its endpoint diagonals are $2/3$, interior diagonals $1/3$, and neighboring entries $1/3$. It is TP2: the adjacent principal minors are $1/9$ at an endpoint and zero in the interior; all other minors are nonnegative as above.

Use uniform $\mu=1/6$ and

$$
W=\frac32Q,
\qquad p=\frac14.
$$

The root eigenvalues are

$$
1,\quad \frac{1+\sqrt3}{3},\quad \frac23,
\quad\frac13,\quad0,\quad\frac{1-\sqrt3}{3}.
$$

The negative root eigenvalue is admissible: the root matrix is entrywise nonnegative, while its actual square is PSD. The centered square values are

$$
\frac{4+2\sqrt3}{9},\quad\frac49,\quad\frac19,
\quad0,\quad\frac{4-2\sqrt3}{9}.
$$

There are four positive centered values and an additional zero value. This is not an entire-centered-space two-band example. Corollaries 2 and 3 apply directly and retain the zero exactly.

## 6. Scope barrier

Membership in $\mathcal C_\mu$ imposes an order constraint that does not follow merely from actual square-root realizability. Every TP2 Markov kernel has stochastically monotone transition rows in its order. Indeed, for $x<x'$ and a lower set $B$, summing the relevant TP2 minors gives

$$
\begin{aligned}
P_K(x,B)-P_K(x',B)
&=\sum_{y\in B,\ z\notin B}\mu_y\mu_z
\bigl[K(x,y)K(x',z)-K(x,z)K(x',y)\bigr]\\
&\ge0.
\end{aligned}
$$

Finite convex mixtures preserve this condition. Thus a kernel with no stochastic-monotone ordering belongs to no such $\mathcal C_\mu$. The four-state coarse star square in Section 6 of the companion main note has precisely this property; the separate two-band argument proves its density. The weighted five-state refinement also lies outside every such order, and its density is proved by the refinement theorem. These are barriers to this mechanism, not density counterexamples.

The unrestricted common-power target remains outside this theorem's established scope. No assertion is made that all actual roots admit the required order or convex representation. The broader refinement theorem in the companion note uses a different conditional-density mechanism.

## References

1. Nicholas Ruozzi, *The Bethe Partition Function of Log-supermodular Graphical Models*, arXiv:1202.6035, version 2 (2012). Theorem 3.8 is the Boolean sorting inequality used above; Theorem 4.1 is its graph-cover consequence. [Primary source](https://arxiv.org/abs/1202.6035).
2. Nicholas Ruozzi, *Beyond Log-Supermodularity: Lower Bounds and the Bethe Partition Function*, arXiv:1309.6859 (2013). The initial discussion explicitly notes the extension to finite distributive lattices and finite total orders through Boolean sublattice embeddings. [Primary source](https://arxiv.org/abs/1309.6859).
