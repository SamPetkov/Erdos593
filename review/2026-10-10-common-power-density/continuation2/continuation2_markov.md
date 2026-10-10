# Actual interacting-channel contraction

Status: a restricted sufficient mechanism and an exact obstruction to an unrestricted **pointwise conditional** argument. The unrestricted common-power target remains unresolved. No novelty, unrestricted proof, global counterexample, or Lean claim is made. This file records established mathematics from the second continuation; no further search is needed for these statements.

## 1. Weighted channels and nonnegative actual cubic moments

Let $(I,\pi)$ be a finite positive probability space. For every $i\in I$, let $(Y_i,\nu_i)$ be a finite positive probability space. Choose a common finite index set $\mathcal A$ containing $0$, and an orthonormal **family** $(\psi_{i,\alpha})_{\alpha\in\mathcal A}$ in $L^2(\nu_i)$, with $\psi_{i,0}=1$. Completeness is not needed for graphs of maximum degree at most three. Assume every actual cubic coefficient is nonnegative:

$$
c_i(\alpha,\beta,\gamma)
=\sum_{a\in Y_i}\nu_i(a)\psi_{i,\alpha}(a)
  \psi_{i,\beta}(a)\psi_{i,\gamma}(a)\ge0. \tag{1}
$$

For each $\alpha$, let $B_\alpha$ be a symmetric real **relative kernel** on $(I,\pi)$. All its powers use original-$\pi$ composition:

$$
(B_\alpha B_\beta)(i,j)=\sum_t\pi_t B_\alpha(i,t)B_\beta(t,j).
$$

Let $B_0=S$ be a nonnegative Markov kernel, and assume the following displayed kernel is entrywise nonnegative:

$$
T((i,a),(j,b))=
\sum_{\alpha\in\mathcal A}B_\alpha(i,j)
\psi_{i,\alpha}(a)\psi_{j,\alpha}(b). \tag{2}
$$

The fine space has its original measure

$$
\mu(i,a)=\pi_i\nu_i(a).
$$

Then $T$ is an actual nonnegative self-adjoint Markov kernel. Indeed symmetry is explicit, and integration in $(j,b)$ removes every nonconstant channel and leaves $\sum_j\pi_j S(i,j)=1$. Every such finite kernel gives an admissible host $W=T/M$, $p=1/M$, where $M=\max T\ge1$. Thus (2) assumes actual entrywise root realizability, not merely PSD even powers.

**Channel contraction theorem.** Suppose in addition that every $B_\alpha^2$ is entrywise nonnegative. For every finite graph $G$ of maximum degree at most three and every choice of positive integer edge exponents $n_e$,

$$
\mathbb E_{x_v\sim\mu}\prod_{e=uv}T^{2n_e}(x_u,x_v)
\ \ge\
\mathbb E_{i_v\sim\pi}\prod_{e=uv}S^{2n_e}(i_u,i_v). \tag{3}
$$

No commutation between distinct coarse channel matrices is assumed. No channel except $S$ needs to be Markov or PSD. In particular, negative eigenvalues of the actual root channels are allowed.

### Proof with the original measure

Orthonormality inside the intermediate fiber gives

$$
\sum_b\nu_j(b)\psi_{j,\alpha}(b)\psi_{j,\beta}(b)
=\mathbf1_{\alpha=\beta}.
$$

Consequently, for every $m\ge1$,

$$
T^m((i,a),(j,b))=
\sum_\alpha B_\alpha^m(i,j)
\psi_{i,\alpha}(a)\psi_{j,\alpha}(b). \tag{4}
$$

This uses $\pi$ at each intermediate coarse vertex and $\nu_j$ inside its fiber. If a family is incomplete, $T$ annihilates the fiberwise orthogonal complement; no omitted mode appears in a positive power.

Fix coarse colors $(i_v)$. Expand every edge in (4) with $m=2n_e$ and then integrate the independent fine fiber variables. A channel assignment $\alpha:E(G)\to\mathcal A$ contributes

$$
\prod_{e=uv}B_{\alpha_e}^{2n_e}(i_u,i_v)
\prod_{v\in V(G)}
\mathbb E_{\nu_{i_v}}\prod_{e\ni v}\psi_{i_v,\alpha_e}. \tag{5}
$$

All channel entries in (5) are nonnegative: $B_\alpha^{2n}=(B_\alpha^2)^n$ and original-$\pi$ composition preserves entrywise nonnegativity. Vertex moments of degrees zero, one, and two are respectively $1$, $\mathbf1_{\alpha=0}$, and $\mathbf1_{\alpha=\beta}$. Degree-three moments are nonnegative by (1). Thus every summand in (5) is nonnegative. The all-zero channel assignment is exactly $\prod_e S^{2n_e}(i_u,i_v)$. Keeping it and then integrating the original coarse colors proves (3).

This proves the requested $K_4$ inequality whenever the coarse root $S$ is already valid for the same six exponents. It never assumes an unknown inner target inequality. It also gives a precise conditional inequality for this restricted channel class.

### Complete bases and arbitrary graphs

If each family is complete, multiplication has the exact expansion

$$
\psi_{i,\alpha}\psi_{i,\beta}
=\sum_\gamma c_i(\alpha,\beta,\gamma)\psi_{i,\gamma}.
$$

Repeated multiplication preserves nonnegative coefficients. Integrating the final product extracts its coefficient of $\psi_{i,0}=1$, so **all** higher mixed moments are nonnegative. Therefore the same proof gives (3) for every finite graph. Complete bases indexed by one common set require all fibers to have that same cardinality; their probability laws may differ. The maximum-degree-three statement allows different larger fiber cardinalities and incomplete families.

## 2. Concrete moment families and gauge scope

For a two-state fiber with rarer-state mass $q_i\le1/2$, put

$$
\psi_{i,1}(\text{rare})=\sqrt{(1-q_i)/q_i},\qquad
\psi_{i,1}(\text{other})=-\sqrt{q_i/(1-q_i)}.
$$

Then $\mathbb E\psi=0$, $\mathbb E\psi^2=1$, and

$$
\mathbb E\psi^3=\frac{1-2q_i}{\sqrt{q_i(1-q_i)}}\ge0.
$$

Every cubic coefficient of $\{1,\psi\}$ is therefore nonnegative. The complete-basis theorem covers unequal binary weights independently in every fiber. Products of these binary bases also have nonnegative cubic moments, because their moments factor coordinatewise.

Uniform fibers $Y_i=(\mathbb Z/2)^d$ with the character basis are a special case. Their cubic coefficients are either zero or one. Formula (5) is then a sum over character assignments with product equal to the trivial character at every vertex.

For uniform binary fibers, an additional common diagonal sign gauge is harmless. If $D=\operatorname{diag}(\varepsilon_i)$ with $\varepsilon_i\in\{\pm1\}$ and $DB_1^2D$ is entrywise nonnegative, relabel the two states in each fiber according to $\varepsilon_i$. The binary cubic moment is zero and every surviving channel degree is even, so the sign factors cancel. For several character channels, arbitrary independent gauges are **not** justified: they must be multiplicative in the character label at each coarse color. For unequal binary fibers, a sign flip can make the cubic moment negative. The general theorem above uses the stated ungauged nonnegativity conditions and does not silently discard this issue.


## 3. Exact eight-state interacting-channel host

Let $\pi_i=1/4$ on four coarse states $0,1,2,3$, with $0$ the center, and define

$$
M=\begin{pmatrix}5&1&1&1\\1&7&0&0\\1&0&7&0\\1&0&0&7\end{pmatrix},
\qquad
C=\begin{pmatrix}16&1&2&3\\1&40&0&0\\2&0&44&0\\3&0&0&48\end{pmatrix}.
$$

Use uniform binary fibers with sign coordinate $a$. Distinguish **relative kernels**
$S=M/2$, $H=C/16$ from their operator matrices $P_S=M/8$, $P_H=C/64$.
The fine measure is $\mu(i,a)=1/8$. An actual bounded host is

$$
W((i,a),(j,b))=\frac{8M_{ij}+C_{ij}ab}{104},\qquad p=\frac2{13}. \tag{6}
$$

All numerators lie between zero and $104$. Summing both target signs gives $16M_{ij}$, so every original-$\mu$ row average is $128/(8\cdot104)=2/13$. Thus
$T=W/p=M/2+(C/16)ab=S+Hab$ is actual. The channel is entrywise nonnegative, hence its square is too. Its center-to-leaf cross-fiber blocks are nonconstant.

The coarse square has centered eigenvalues $49/64$ with multiplicity two and $1/4$. The already proved complete common-cone theorem gives $F(S;n)\ge1$ for every six positive edge exponents. The new contraction therefore gives $F(T;n)\ge F(S;n)\ge1$. Retaining the known coarse all-identity term yields

$$
F(T;n)\ge1+63\cdot4^{-N},\qquad N=\sum_e n_e. \tag{7}
$$

### Spectrum and old compensation tests

The root operator is the direct sum of $M/8$ on fiberwise constants and $C/64$ on odd functions. The symmetric matrix $C$ is strictly diagonally dominant with positive diagonal, hence positive definite. Its secular equation is

$$
16-t-\frac1{40-t}-\frac4{44-t}-\frac9{48-t}=0.
$$

The left side has strictly negative derivative between its poles. Its endpoint limits give one eigenvalue in each of the four complementary intervals. The Rayleigh quotient at the center puts the smallest eigenvalue strictly below $16$; Gershgorin bounds put all eigenvalues in $[10,51]$. Thus the four simple eigenvalues lie in $(0,16)$, $(40,44)$, $(44,48)$, and $(48,51]$. None is $32$ or $56$.

The square consequently has **six distinct positive centered values**: $49/64$, $1/4$, and the four distinct numbers $\lambda_j(C)^2/4096$. The four latter values differ from both coarse values. The actual square kernel is

$$
A((i,a),(j,b))=\frac{64(M^2)_{ij}+(C^2)_{ij}ab}{1024}, \tag{8}
$$

where

$$
M^2=\begin{pmatrix}28&12&12&12\\12&50&1&1\\12&1&50&1\\12&1&1&50\end{pmatrix},\qquad
C^2=\begin{pmatrix}270&56&120&192\\56&1601&2&3\\120&2&1940&6\\192&3&6&2313\end{pmatrix}.
$$

Hence $\max A=5513/1024>4$. At $(k,u,r,l,h)=(3,1,1,1,1)$ the previously recorded compensation threshold is $1/4$. Both tests fail: $p=2/13<1/4$ and $(1/4)\max A=5513/4096>1$. This does not assert exclusion from every previous fixed-host local neighborhood.

### No ordered convex-TP2 representation

Every kernel in the earlier convex-TP2 class $\mathcal C_\mu$ has stochastically monotone transition rows. In any such order, the first kernel column is nonincreasing down rows and the last is nondecreasing; positive column masses do not affect these comparisons.

In (8), center-to-leaf values lie in $[576,960]/1024$, values between different leaf groups lie in $[58,70]/1024$, and the value between the two center states is $1522/1024$.

If the first endpoint is a center and the last a leaf, a leaf from another group contradicts the last-column condition. The reversed case contradicts the first-column condition. If both endpoints are centers, any leaf contradicts the first-column comparison with the last center. Thus both endpoints are leaves. Choose a leaf $z$ from a group different from both endpoint groups, and a center $c$. The first-column condition requires $c$ before $z$; the last requires it after $z$. This is impossible. Thus $A$ is in no $\mathcal C_\mu$ in any order. Composition closure excludes the root as well.

### No nontrivial constant-cross-block partition

A subset $U$ is a matrix module if its rows agree on all columns outside $U$. Any nonsingleton fiber of a constant-off-diagonal-block refinement is a module. This root has no proper module of size at least two.

Two distinct leaf states have different entries in each center column, because these numerators are $8\pm1$, $8\pm2$, and $8\pm3$. Hence a module containing two leaves must contain both centers. A module containing both centers must contain all leaves, since their rows differ at every leaf column. A module containing a center and a leaf must contain all leaves in the other two groups, because its center row is positive there and its leaf row is zero. The preceding cases then force the full space. These cases cover every subset of size at least two.

Thus no nontrivial partition supports the previous constant-cross-block refinement argument. The single full-space block and the singleton partition provide no new certificate.

### No nontrivial tensor product after relabeling

The root diagonal has four distinct values, each repeated exactly twice: $7/2$, $6$, $25/4$, and $13/2$. Any nontrivial product on eight uniformly weighted states has a uniform two-state factor. A symmetric two-state Markov kernel has equal diagonal entries, so the pairs of that factor would have to be exactly these four diagonal pairs. Averaging that factor recovers $S$, and its other channel must be one scalar multiple of $S$, up to independently swapping the states in each pair. Such swaps do not change diagonal channel ratios. Here

$$
H_{00}/S_{00}=2/5,\quad H_{11}/S_{11}=5/7,\quad
H_{22}/S_{22}=11/14,\quad H_{33}/S_{33}=6/7.
$$

They differ, so no relabeling makes this root a nontrivial tensor product.

### Strict positivity

For $\rho=99/100$, let $T_\rho=\Pi+\rho(T-\Pi)$. Its coarse root is $\Pi+\rho(S-\Pi)$ and channel is $\rho H$. The resulting bounded host is strictly positive, with

$$
p=200/1289,\qquad \min W=2/1289,\qquad
\max A=54236689/10240000>4.
$$

Centered square bands are multiplied by $\rho^2$. Root row differences are multiplied by $\rho$, and square row differences by $\rho^2$, preserving the module and stochastic-order obstructions. The inherited surplus is $F(T_\rho;n)\ge1+63\rho^{2N}4^{-N}$.


## 4. Exact failure of pointwise conditional contraction without the sign condition

This is **not** a global density counterexample and does **not** refute $F(T)\ge F(S)$.

Take three coarse states with $\pi_i=1/3$, $S=\Pi$, and uniform binary fibers. Let $J=I-\Pi$, the original-$\pi$ relative kernel $J(i,j)=3\mathbf1_{i=j}-1$, and let $H=J/4$. Then

$$
T((i,a),(j,b))=1+\frac{3\mathbf1_{i=j}-1}{4}ab,\qquad
\mu(i,a)=1/6,\qquad W=(2/3)T,\quad p=2/3. \tag{9}
$$

The possible $W$ entries are $1$, $1/3$, $1/2$, and $5/6$, so the host is strictly positive and admissible. Its square channel is $H^2=J/16$. Its three off-diagonal coarse entries are negative; their triangle product is negative and invariant under diagonal sign gauges. Thus the channel-square sign condition is not automatic for actual roots.

For the requested tuple $(k,u,r,l,h)=(3,1,1,1,1)$, the edge exponents in order $(ab,ac,ad,bc,bd,cd)$ are $(3,2,1,1,1,1)$. Write $x=1/16$. Since $J^m=J$ for every positive $m$,

$$
T^{2n}((i,a),(j,b))=1+x^nJ(i,j)ab.
$$

Condition the four coarse colors to $(i_a,i_b,i_c,i_d)=(0,0,1,2)$. Averaging the four independent fiber signs leaves only the empty graph, four triangles, and three quadrilaterals. The conditional defect is exactly

$$
-x^3-x^4+3x^5-2x^7
=-\frac{34433}{134217728}<0. \tag{10}
$$

For example, the six $J$ edge values are $(2,-1,-1,-1,-1,-1)$. Their triangle products are $(2,2,-1,-1)$, with weights $(6,5,4,3)$, and their quadrilateral products are $(-2,-2,1)$, with weights $(6,7,5)$. This directly checks (10).

The global density is instead

$$
F(T)=1+2(x^3+x^4+2x^5+2x^6+x^7)
=1+\frac{70177}{134217728}>1. \tag{11}
$$

Indeed every cycle, after averaging coarse colors, gives $\operatorname{tr}(H^{2w})=2x^w$. Thus the exact obstruction is to a pointwise coarse-color contraction without a sign or other compensating mechanism. Constant-mode and other-color surplus cannot be dropped. This example is inside older positive classes and is used solely to delimit the pointwise proof.

## 5. Verification and bounded diagnostic

The adjacent file continuation2_markov_verify.py uses exact integer and rational arithmetic to check the two actual hosts, original-measure powers, the eight-state square, matrix-module obstruction, finite densities, and the conditional defect. Its general claims require the analytic proofs above; no rounded numerical match is treated as proof.

The separate exploratory continuation2_markov_probe.py completed 30 fixed-seed four-coarse-state starts, minimizing the leading small-channel triangle coefficient at the tuple $(3,1,1,1,1)$. It found no negative coefficient. This failed diagnostic proves no monotonicity theorem. No further search is needed for the results recorded here.
