# Quantitative refinements and an actual-root boundary reduction

## Verdict and exact scope

**The unrestricted common-power density inequality remains unresolved. This packet supplies no certified counterexample to it.** The new proved statements are an unconditional block-refinement inequality, a uniform sufficient criterion allowing arbitrary internal Markov dynamics, and a reduction of any strict counterexample to the boundary of the actual nonnegative-root region. These statements retain the original probability measure and all constant-mode surplus.

This is a continuation of [PR 56](https://github.com/SamPetkov/Erdos593/pull/56) and [PR 57](https://github.com/SamPetkov/Erdos593/pull/57), based on commit `2f8731673a4ad49952c2eb203ed4f00fe4ba85ec`. The proper centered-core expansion and the common-cone theorem are prior results in those records. Their use below is explicit. No claim of literature novelty, unrestricted completion, or formal-kernel acceptance is made.

### The target

Let $X$ be finite and nonempty, and let $\mu_x>0$ with $\sum_x\mu_x=1$. A kernel is written relative to this probability: composition is

$$
(BC)(x,z)=\sum_y\mu_y B(x,y)C(y,z),\qquad
I(x,y)=\frac{\mathbf1_{x=y}}{\mu_y},\qquad \Pi(x,y)=1.
$$

Let $W$ be symmetric, take values in $[0,1]$, and have every $\mu$-weighted row sum equal to $p>0$. Then $T=W/p$ is an actual entrywise nonnegative self-adjoint Markov kernel. Put $A=T^2$ and $K_j=A^j$. For

$$
k\ge u\ge1,\qquad r\ge l\ge1,\qquad h\ge1,
$$

the open assertion is

$$
F=\mathbb E_{a,b,c,d\sim\mu}
K_k(a,b)K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d)\ge1.
$$

Throughout the proofs, write $E=E(K_4)$ with edge order $(ab,ac,ad,bc,bd,cd)$ and

$$
n=(k,r+h,u,r,u,l),\qquad N=\sum_{e\in E}n_e=k+2r+h+2u+l.
$$

The structural inequalities below hold for arbitrary six positive integers $n_e$, and thus include every requested tuple. Write $F(T;n)$ for this density and $F_H(T;n)$ when only edges of $H\subseteq K_4$ are retained. Every density uses the probability belonging to its displayed root. Whenever a root $T$ is constructed below, the bounded host

$$
W=T/M,\qquad p=1/M,\qquad M=\max_{x,y}T(x,y)
$$

is admissible. This follows from $M\ge1$, entrywise nonnegativity, symmetry, and the original-measure Markov row sums. No proposed root is accepted merely because its square is PSD.

## 1. The proper subgraphs and the constant surplus

The centered expansion used here is the one already recorded in [density-centered.json](../2026-10-09-entropy-density/universal-round1-20261009/density-centered.json). We include the short derivation to make the new deductions checkable.

Set $C_j=A^j-\Pi$. Since $A\Pi=\Pi A=\Pi$,

$$
C_j\mathbf1=0,\qquad C_sC_t=C_{s+t}.
$$

For $H\subseteq K_4$, let

$$
c_H=\mathbb E_{\mu^4}\prod_{e=vw\in E(H)} C_{n_e}(x_v,x_w).
$$

Every term with a degree-one vertex vanishes by its centered row sum. The nonempty proper survivors are exactly four triangles, three quadrilaterals, and six diamonds. If $H$ is a cycle, contraction of its degree-two vertices gives

$$
c_H=\operatorname{tr} C_{\sum_{e\in H}n_e}
=\sum_{i\ge1}\theta_i^{\sum_{e\in H}n_e}\ge0,
$$

where $\phi_0=1,\phi_1,\ldots$ is a complete real orthonormal basis and the operator eigenvalues of $A$ are $\theta_0=1$ and $0\le\theta_i\le1$. Centered unit modes from a disconnected root are included in this sum.

A diamond is three internally disjoint paths between its two degree-three vertices. Integrating its degree-two vertices, with the original measure, gives positive integers $s,t,v$ such that

$$
\begin{aligned}
c_H
&=\mathbb E_{x,y\sim\mu}C_s(x,y)C_t(x,y)C_v(x,y)\\
&=\sum_{i,j,z\ge1}\theta_i^s\theta_j^t\theta_z^v
\left(\mathbb E_\mu\phi_i\phi_j\phi_z\right)^2\ge0.
\end{aligned}
$$

This is an expansion of a pointwise product into squared cubic moments. It is not a sign assertion for a trace of three arbitrary PSD operators. Put $Q=c_{K_4}$, which is not assumed nonnegative, and let $\mathcal P$ be the thirteen proper survivors. Then

$$
F(T;n)=1+\sum_{H\in\mathcal P}c_H+Q. \tag{1}
$$

If $T\ne\Pi$, some centered eigenvalue of $A$ is positive, so every triangle coefficient is strictly positive. Indeed, $A=\Pi$ would imply that the self-adjoint $T$ vanishes on the centered subspace, hence $T=\Pi$.

**Proper-subgraph lemma.** For every proper $H\subsetneq K_4$,

$$
F_H(T;n)\ge1. \tag{2}
$$

One proof expands each retained $A^{n_e}$ as $1+C_{n_e}$ and applies the preceding nonnegative coefficients. Equivalently, remove Markov leaves exactly. The remaining core is empty, a cycle, or a diamond. Cycles have density $\operatorname{tr}A^s\ge1$; the diamond expansion above, now including indices $0$, has the constant $(0,0,0)$ summand equal to one and all other summands nonnegative. Isolated vertices integrate to one. This proof covers zero entries, arbitrary positive weights, and disconnected roots.

## 2. Independent edge resampling: an unconditional defect bound

For independently chosen $0\le t_e\le1$, put

$$
L_e=(1-t_e)\Pi+t_eA^{n_e},\qquad
Z(L)=\mathbb E_{\mu^4}\prod_{e=vw}L_e(x_v,x_w).
$$

Then

$$
\boxed{\quad Z(L)\ge1+\left(\prod_{e\in E}t_e\right)[F(T;n)-1].\quad} \tag{3}
$$

**Proof.** Directly from (1),

$$
Z(L)-1-\left(\prod_e t_e\right)[F(T;n)-1]
=\sum_{H\in\mathcal P}c_H
\left[\prod_{e\in H}t_e-\prod_{e\in E}t_e\right]\ge0. \tag{4}
$$

The entire possibly negative tetrahedral coefficient cancels. Each remaining bracket and coefficient is nonnegative. Alternatively, expand the convex mixtures over all retained edge subsets and apply (2) to each proper subset. Neither proof assumes $F(T;n)\ge1$.

If $T\ne\Pi$, every $t_e>0$, and some $t_e<1$, (3) is strict: a triangle omitting such an edge has both a positive coefficient and a positive bracket. The zero cases need no limiting argument.

The six $L_e$ are intermediate edge kernels; they are not asserted to be powers of a common new root. Their role is to prove a collective estimate for actual refinements in Section 4.

## 3. Every strict counterexample reaches a zero of the actual root

For a fixed actual nonconstant root define

$$
T_\tau=\Pi+\tau(T-\Pi),\qquad \tau\ge0.
$$

The original $\mu$ is unchanged. Algebraically,

$$
T_\tau^2=\Pi+\tau^2(A-\Pi),\qquad
(T_\tau^2)^j=\Pi+\tau^{2j}C_j.
$$

For $w_H=\sum_{e\in H}n_e$ and $\tau>0$, (1) gives

$$
\Psi(\tau):=\frac{F(T_\tau;n)-1}{\tau^{2N}}
=Q+\sum_{H\in\mathcal P}c_H\tau^{-2(N-w_H)}. \tag{5}
$$

Every $N-w_H>0$. Hence $\Psi$ is strictly decreasing on $(0,\infty)$, with limits $+\infty$ at zero and $Q$ at infinity. These assertions concern the explicitly defined polynomial even when $T_\tau$ is outside its nonnegative range.

Consequently, for $0<\sigma<\tau$,

$$
F(T_\sigma;n)-1\ge
\left(\frac{\sigma}{\tau}\right)^{2N}[F(T_\tau;n)-1]. \tag{6}
$$

If $Q\ge0$, the ray has positive defect at every positive parameter. If $Q<0$, there is exactly one positive crossing of $F=1$ on the full polynomial ray; that crossing might lie outside the admissible segment. Validity is preserved towards $\Pi$. A strict violation persists, and its negative normalized defect increases in magnitude, as one moves outwards while the root stays nonnegative.

The admissible segment is exact. Set $m=\min_{x,y}T(x,y)$. Since $T$ is nonconstant and every weighted row average is one, $0\le m<1$. Then

$$
T_\tau\ge0\quad\Longleftrightarrow\quad
0\le\tau\le\tau_{\max}:=\frac1{1-m}. \tag{7}
$$

At $\tau_{\max}$ the root has a zero entry; it remains self-adjoint and Markov with the same original measure. Normalizing by its maximum gives an actual admissible $W_{\tau_{\max}}$.

**Boundary-reduction corollary.** If any admissible finite host violates the requested density inequality strictly, then an admissible host with the same measure, cardinality, and exponent tuple violates it strictly and has a zero entry in its actual Markov root.

This does not assert a counterexample exists, does not make arbitrary PSD roots admissible, and does not prove the inequality on the boundary. The constant root has $F=1$ and is excluded from the nonconstant-ray statement. The deduction is a structural corollary of the prior centered expansion, not a separate novelty claim.

## 4. A universal quantitative inequality for block refinements

Let $(I,\pi)$ be a finite positive probability space and $S$ an actual nonnegative self-adjoint Markov root on it. Let

$$
P_S(i,j)=\pi_j S(i,j).
$$

For each $i$, choose a finite positive probability space $(Y_i,\nu_i)$ and an actual nonnegative self-adjoint Markov root $R_i$. Choose

$$
0\le\gamma_i\le P_S(i,i).
$$

The refined space is the disjoint union of the fibers, with its original probability

$$
\mu(i,a)=\pi_i\nu_i(a).
$$

Define its relative-measure kernel by

$$
T((i,a),(j,b))
=S(i,j)+\mathbf1_{i=j}\frac{\gamma_i}{\pi_i}\bigl(R_i(a,b)-1\bigr). \tag{8}
$$

### Admissibility and all powers

The within-fiber transition probability is

$$
\mu(i,b)T((i,a),(i,b))
=[P_S(i,i)-\gamma_i]\nu_i(b)
+\gamma_i\nu_i(b)R_i(a,b).
$$

This is nonnegative. Transitions to other fibers use the coarse transition and then a fresh draw from their conditional law. Symmetry of the kernel and its original-measure Markov row sums follow immediately. Thus (8) is an actual nonnegative Markov root, and its square has the required realization.

Functions constant on fibers form a copy of $L^2(\pi)$, on which $T$ acts as $S$. The centered functions within fiber $i$ form an invariant subspace on which $T$ acts as $\gamma_iR_i$. These subspaces are mutually orthogonal. Therefore, for every integer $m\ge1$,

$$
T^m((i,a),(j,b))
=S^m(i,j)+\mathbf1_{i=j}\frac{\gamma_i^m}{\pi_i}
\bigl(R_i^m(a,b)-1\bigr). \tag{9}
$$

The factor $1/\pi_i$ is essential to original-measure composition.

For $m=2n_e$, set

$$
t_{e,i}=\frac{\gamma_i^{2n_e}}{\pi_i S^{2n_e}(i,i)}
=\frac{\gamma_i^{2n_e}}{P_S^{2n_e}(i,i)}.
$$

The denominator is positive: $S^2(i,i)=\sum_j\pi_jS(i,j)^2>0$, and repeating that two-step return gives positivity for every even power. The all-stay path also gives

$$
P_S^{2n_e}(i,i)\ge P_S(i,i)^{2n_e}\ge\gamma_i^{2n_e}.
$$

Thus $t_{e,i}\in[0,1]$, including $\gamma_i=0$. The within-fiber edge factor is exactly

$$
T^{2n_e}((i,a),(i,b))=S^{2n_e}(i,i)
\left[(1-t_{e,i})+t_{e,i}R_i^{2n_e}(a,b)\right]. \tag{10}
$$

### Main refinement theorem

Without assuming the target for either the coarse or internal roots,

$$
\boxed{\quad
F(T;n)\ge F(S;n)+\sum_i\pi_i^{-2}\gamma_i^{2N}
\bigl[F(R_i;n)-1\bigr].
\quad} \tag{11}
$$

**Proof.** Condition the four vertex states on their coarse indices. Each edge between different fibers becomes its coarse $S^{2n_e}$ factor by (9). Factor the within-fiber terms by (10).

If the coarse coloring is nonconstant, every single fiber contains at most three of the four vertices. Each induced within-fiber graph is a proper subgraph of $K_4$. Expanding its independent edge mixtures and applying (2) shows that its conditional $\nu_i$ integral is at least one. The coarse edge factors are nonnegative, including possible zeros, so the complete conditional contribution is at least the coarse one.

For the constant coloring $i,i,i,i$, apply (3) on the internal space. Its conditional factor is at least

$$
1+\left(\prod_e t_{e,i}\right)[F(R_i;n)-1].
$$

The coefficient of this correction, including the probability of the coloring, is exactly

$$
\begin{aligned}
\pi_i^4\prod_e S^{2n_e}(i,i)\prod_e t_{e,i}
&=\pi_i^4\prod_e S^{2n_e}(i,i)
\prod_e\frac{\gamma_i^{2n_e}}{\pi_i S^{2n_e}(i,i)}\\
&=\pi_i^{-2}\gamma_i^{2N}.
\end{aligned}
$$

Summing all colorings proves (11). In particular, the proof remains valid when an internal density is less than one. No modewise positivity or replacement of actual cubic sources is used.

### Consequences and exact boundary cases

- The collection of actual roots satisfying a fixed six-exponent inequality is closed under (8) when its coarse and internal roots all belong to that collection.
- A counterexample of the form (8) implies a counterexample among its coarse or internal roots. This does not assert that every root admits a nontrivial such decomposition.
- When all $\gamma_i=0$, or all fibers are singletons, (9) gives the exact identity $F(T;n)=F(S;n)$.
- If $S=I$ and all $\gamma_i=1$, different fibers cannot interact. A nonzero four-vertex contribution lies in one fiber and has probability factor $\pi_i^4$ and six kernel factors $\pi_i^{-1}$. Hence, exactly,

$$
F(T;n)=\sum_i\pi_i^{-2}F(R_i;n).
$$

This proves the component transport with the original measure. It is not a newly normalized component assertion.
- If all roots are $\Pi$, every density is exactly one. Zeros, negative eigenvalues of actual roots, centered unit modes, and centered zero modes are allowed; only positive integral even powers enter the density.

## 5. A uniform budget permitting arbitrary internal dynamics

The following consequence removes the need to know the target for the internal roots.

### A quantitative use of the established common-cone theorem

Suppose $A_0=S^2$ has at most two values $0<y\le x\le1$ on its **entire** centered space. No additional centered zero eigenspace is permitted in this coarse assumption. Equivalently,

$$
A_0=yI+(1-y)\Pi+(x-y)P,
$$

where $P$ is an orthogonal projection with $P\mathbf1=0$. For $y<1$ put

$$
C=\frac{A_0-yI}{1-y}.
$$

This kernel is nonnegative PSD Markov. Off-diagonal entries follow from those of $A_0$; diagonal entries are $1+[(x-y)/(1-y)]P(i,i)\ge1$. It has only centered eigenvalues $0$ and $t=(x-y)/(1-y)$. Thus each positive power admits

$$
A_0^n=y^n I+b_n C+c_n\Pi,\qquad b_n,c_n\ge0,\qquad y^n+b_n+c_n=1. \tag{12}
$$

For example, expand $(yI+(1-y)C)^n$ binomially and use $C^j=t^{j-1}C+(1-t^{j-1})\Pi$ for $j\ge1$, with $C=\Pi$ handled directly when $t=0$. The coefficient of $I$ is exactly $y^n$. If $y=1$, then $A_0=I$ directly.

The prior [common-cone theorem and its independent audit](../2026-10-09-entropy-density/universal-round1-20261009/density-two-level-audit.json) prove density at least one for every independent choice of the six edge kernels from $\{I,\Pi,C\}$ with this one common $C$. That result includes weighted identity contractions and all quotient multigraphs of $K_4$; it is not being extended to distinct $C_e$.

In (12), the all-six-$I$ choice has coefficient $y^N$ and exact density

$$
B:=F(I;n)=\sum_i\pi_i^{-2}.
$$

Keeping this term's surplus and bounding every other elementary choice by one proves

$$
F(S;n)\ge1+(B-1)y^N. \tag{13}
$$

### Arbitrary-inner refinement criterion

Choose an active set of fibers $J\subseteq I$, keep the others trivial or set their $\gamma_i=0$, and require

$$
\gamma_i\le\min\{P_S(i,i),\sqrt y\}\qquad(i\in J).
$$

Every active $R_i$ may be an arbitrary actual finite reversible nonnegative Markov root, with arbitrary positive internal weights. Since $F(R_i;n)\ge0$ follows just from its nonnegative integrand, (11) and (13) imply

$$
\begin{aligned}
F(T;n)
&\ge1+(B-1)y^N-\sum_{i\in J}\pi_i^{-2}\gamma_i^{2N}\\
&\ge\boxed{\ 1+\left[\sum_{i\notin J}\pi_i^{-2}-1\right]y^N.\ } \tag{14}
\end{aligned}
$$

If at least one coarse state is inactive, this coefficient is nonnegative. If the coarse space has at least two states, it is strictly positive. The bound is uniform in internal dimensions, positive weights, spectra, and dynamics. It uses neither an internal instance of the open target nor a fixed-host perturbation radius. The restriction is the displayed coarse structure and the allowed refinement strength.

### A finite entrywise certificate for a given root

The construction can be checked from a given root. Suppose its states admit a partition for which every off-diagonal block of the relative-measure kernel is constant. Let $\pi_i$ be the original block mass, $\nu_i$ its conditional law, and $S$ the lumped coarse kernel. The within-block conditional row sum is constant; write

$$
s_i=\pi_iS(i,i),\qquad m_i=\min_{a,b\in Y_i}T((i,a),(i,b)).
$$

For $0<\gamma_i\le s_i$, define

$$
R_i(a,b)=1+\frac{\pi_i}{\gamma_i}
\left[T((i,a),(i,b))-S(i,i)\right].
$$

It is symmetric and Markov for $\nu_i$, and is nonnegative exactly when $\gamma_i\ge s_i-\pi_i m_i$. A zero strength is possible precisely for a constant diagonal block. Therefore, if the coarse square satisfies the preceding two-band hypothesis, at least one diagonal block is constant, and every other block satisfies

$$
\pi_i m_i\ge\max\{s_i-\sqrt y,0\}, \tag{15}
$$

choose $\gamma_i=\min\{s_i,\sqrt y\}$ on the nonconstant blocks and apply (14). A zero coarse diagonal forces the corresponding nonnegative block to be zero, which is an inactive case. This is an explicit sufficient certificate on the actual root, rather than an assumed inequality for unknown internal sources.

## 6. Examples outside several earlier sufficient classes

### The coarse star and its arbitrary fibers

Use uniform $\pi_i=1/4$ and coarse transition matrix

$$
P_S=\frac18\begin{pmatrix}
5&1&1&1\\1&7&0&0\\1&0&7&0\\1&0&0&7
\end{pmatrix}.
$$

The centered square eigenvalues are $49/64$ with multiplicity two and $1/4$. Thus (13) gives $F(S;n)\ge1+63\cdot4^{-N}$. Keep the center fiber trivial and refine any of the three leaves with arbitrary actual internal roots and strengths $\gamma_i\le1/2$. Since their diagonal transition probabilities are $7/8$, (14) gives

$$
\boxed{F(T;n)\ge1+15\cdot4^{-N}.} \tag{16}
$$

With only one active leaf, it gives $F(T;n)\ge1+47\cdot4^{-N}$. These statements hold for every positive six-edge exponent choice and every internal probability space, even if some hypothetical internal root violated the unrestricted target.

### An exact weighted five-state host

Split one leaf with internal law $(1/4,3/4)$, internal root $I_2$, and strength $\gamma=3/8$. Then

$$
\mu=\left(\frac14,\frac1{16},\frac3{16},\frac14,\frac14\right),\qquad p=\frac18,
$$

$$
W=\begin{pmatrix}
5/16&1/16&1/16&1/16&1/16\\
1/16&1&1/4&0&0\\
1/16&1/4&1/2&0&0\\
1/16&0&0&7/16&0\\
1/16&0&0&0&7/16
\end{pmatrix}. \tag{17}
$$

All entries lie in $[0,1]$ and each original-$\mu$ row sum is $1/8$. Thus $T=8W$ is the actual root. Its square, as an original-measure kernel, is

$$
A=\begin{pmatrix}
7/4&3/4&3/4&3/4&3/4\\
3/4&77/16&41/16&1/16&1/16\\
3/4&41/16&53/16&1/16&1/16\\
3/4&1/16&1/16&25/8&1/16\\
3/4&1/16&1/16&1/16&25/8
\end{pmatrix}. \tag{18}
$$

Its entire centered spectrum consists of three positive values,

$$
49/64\text{ (multiplicity two)},\qquad 1/4,\qquad 9/64.
$$

It is outside the earlier entire-centered-space two-band class. In fact $A$ and $A^2$ cannot both belong to one cone $\operatorname{conv}\{I,\Pi,C\}$: a representation of the nonflat $A$ forces the common $C$ to be affine in $A,I,\Pi$, and the representation of $A^2$ would impose a quadratic equation on three distinct centered eigenvalues.

At $(k,u,r,l,h)=(3,1,1,1,1)$ the previous compensation threshold is $1/4$. Here $p=1/8<1/4$ and $(1/4)\max A=77/64>1$, so both that density test and that maximum-kernel mixing test fail. This does not claim exclusion from every previously established local neighborhood.

### No ordering puts this square in the convex TP2 class

Let $\mathcal C_\mu$ denote the finite convex hull of original-measure bistochastic TP2 kernels in one order; its density theorem is proved separately in [tp2-class.md](tp2-class.md). Each TP2 Markov kernel has stochastically monotone transition rows: summing its minors over a lower set and its complement yields the required cumulative-probability inequalities. Convex mixtures preserve those inequalities.

In (18), the center-to-leaf kernel value is $\alpha=3/4$, whereas the value between leaves in different coarse groups is $\beta=1/16<\alpha$. There are three leaf groups, including the split one. A stochastic-monotone ordering requires its first kernel column to be nonincreasing down rows and its last column to be nondecreasing. Multiplication by each positive column mass does not affect these comparisons.

If the center were first, choose the last leaf and a leaf from another group: their last-column comparison would decrease from $\alpha$ to $\beta$. If the center were last, the corresponding first-column comparison would increase. Otherwise both endpoints are leaves; choose a leaf $z$ from a group different from both endpoint groups. The first column requires the center to precede $z$, while the last column requires it to follow $z$. This is impossible.

Thus no ordering is stochastic-monotone, and $A$ belongs to no $\mathcal C_\mu$ in any order. Since that class is composition-closed, neither does its root. The same comparison also excludes positive mixtures of nested block conditional expectations: those satisfy $A(a,b)\ge\min\{A(a,c),A(c,b)\}$, whereas leaves in distinct groups and the center violate it.

The proof of (16) still applies. In particular, the new sufficient class contains examples beyond the direct convex-TP2 and complete-two-band classes, without claiming to exhaust admissible hosts.

### Strict positivity, unbounded bands, and a genuine zero band

Replace $T$ in (17) by $T_\rho=\Pi+\rho(T-\Pi)$ with $\rho=99/100$. This remains a refinement, with coarse root $S_\rho=\Pi+\rho(S-\Pi)$ and strengths $\rho\gamma_i$. Formula (14) gives the one-active-leaf bound

$$
F(T_\rho;n)\ge1+47\rho^{2N}4^{-N}.
$$

The bounded host is strictly positive, with $p=100/793$ and minimum entry $1/793$. Its maximum square entry is $757861/160000>4$. Its three centered bands are the preceding bands multiplied by $\rho^2$, and the stochastic-order obstruction persists because all row differences of the square transition matrix are multiplied by $\rho^2$.

There is no bound on the number of allowed internal states or bands. For example, a reflecting lazy path of arbitrary size in one leaf and strength $1/4$ supplies arbitrarily many distinct positive centered square bands below $1/16$, disjoint from the two coarse bands.

For an exact zero mode inside the new class, replace one leaf by six equally weighted internal states, use the internal transition root $Q=I-L_{\mathrm{path}}/3$, and take $\gamma=3/8$. Here $L_{\mathrm{path}}$ is the ordinary six-vertex path Laplacian. The resulting nine-state host has original masses $1/4$ at the center and the other two leaves, and $1/24$ on each internal state. Its within-fiber root kernel is $2+9Q$, its root maximum is eight, and $p=1/8$ is admissible. Its centered square eigenvalues are

$$
49/64\text{ (multiplicity two)},\quad1/4,\quad
\frac{2+\sqrt3}{32},\quad\frac1{16},\quad\frac1{64},\quad
\frac{2-\sqrt3}{32},\quad0.
$$

These are six distinct positive centered values plus zero. Formula (14) gives $F\ge1+47\cdot4^{-N}$. The same three-leaf-group argument excludes every stochastic-monotone order. Global positive refresh preserves the zero centered eigenvalue exactly.

## 7. Exact verification and remaining obligation

[verify_exact.py](verify_exact.py) uses only Python's standard library and exact rational arithmetic. It checks actual-host admissibility, original-measure powers, the displayed rational spectra by characteristic polynomials, all 120 possible orders for the five-state obstruction, all 64 centered subgraphs, all 63 proper uncentered subgraphs, the radial identity through its nonnegative boundary, and the refinement inequality on weighted examples. [exact-results.json](exact-results.json) records deterministic results. The general inequalities above are proved analytically; these checks audit formulas and examples.

For (17), at $(3,1,1,1,1)$ the exact values are

$$
F(T;n)=\frac{2059998202834705}{281474976710656},\qquad
F(S;n)=\frac{128468580607093}{17592186044416}.
$$

At the simultaneous tuple boundary $(1,1,1,1,1)$,

$$
F(T;n)=\frac{688657530025}{68719476736}.
$$

All are above one. A separate seven-state check uses three distinct weighted internal roots, one with a negative centered root eigenvalue, and verifies (11) directly. No rounded numerical match is used as a proof or certificate of a violation.

The distinct tensor, Markov, and optimization routes are recorded in [route-registry.md](route-registry.md). Their strongest outstanding sufficient statement is the following **unproved common-power cover comparison**. For every positive integer $M$ and every set of six sheet permutations $\sigma_e$, let $Z_\sigma$ be the partition function of the corresponding $M$-cover of $K_4$, using the original node weights $\mu$ and the same edge-labelled actual powers. The missing statement is

$$
Z_\sigma\le F(T;n)^M. \tag{19}
$$

This is a theorem-strength obligation. It is stronger than the target and compares different finite graphs; it is not the supplied Dirichlet identity with the target moved to one side. The finite type-counting proof in [tp2-class.md](tp2-class.md), without its TP2 upper-bound step, yields $\limsup_M(\mathbb E_\sigma Z_\sigma)^{1/M}\ge1$. Thus (19) would imply the target. The literature proves the needed upper comparison under TP2, and clique maximality gives the equal-edge-kernel special case; neither supplies (19) for the unrestricted unequal common powers. The computational appendix tests this obligation but does not prove it.

There is no second claimed global mechanism hidden in the refinement result. Arbitrary roots need not satisfy its constant-block hypothesis, and proving the target for all remaining roots would simply be the original unresolved work. The supplied actual negative mode remains a counterexample only to modewise positivity. No Lean interface is added before complete mathematics.
