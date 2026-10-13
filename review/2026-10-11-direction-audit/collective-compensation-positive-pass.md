# Positive collective compensation for common powers

The unrestricted ordered common-power density inequality remains open.
The useful positive steps here are an exact grouping retaining proper-subgraph
compensation, a normalized overlap channel, and a compatible entropy witness
that succeeds on an already covered calibration host. None is an accepted
Lean theorem or a claim of new host coverage.

## Target and scope

On a finite nonempty probability space \((X,\mu)\) with all \(\mu_x>0\),
let \(T\) be a symmetric nonnegative relative Markov kernel:
\(\sum_y\mu_yT(x,y)=1\). All compositions use the original \(\mu\).
Put \(A=T^2\), \(K_j=A^j\), \(\Pi=1\), \(R_j=K_j-\Pi\).
The weighted identity is \(K_0(x,y)=\mathbf1_{x=y}/\mu_y\).
For integers \(k\ge u\ge1,r\ge l\ge1,h\ge1\), the target is
\[
F(h)=\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
                      K_r(b,c)K_u(b,d)K_l(c,d)\ge1.
\tag{1}
\]
Zero entries, extra stationary modes, periodicity, reducibility and zero
eigenvalues are permitted. Since \(X\) is finite, some \(p>0\) makes
\(W=pT\in[0,1]\); the root is therefore an actual nonnegative host, not an
arbitrary PSD substitute.

The bounded methods are Schur/conditional-channel compensation and compatible
Gibbs witnesses. Small rational checks test identities and one witness, not
all hosts. The unchanged unrestricted target has no new acceptance here.

## A Schur grouping that retains compensation

For every \(c\), define the Gram kernel
\[
M_c(a,b)=\mathbb E_dK_l(c,d)R_u(a,d)R_u(b,d).
\]
Thus \(M_c\succeq0\) and \(R_k\circ M_c\succeq0\) in \(L^2(\mu)\), with
\(\circ\) denoting entrywise multiplication. Expanding only the two
\(u\)-edges first, and then splitting \(K_k=\Pi+R_k\), gives the exact identity
\[
F=U_0+U_1+U_2+M_0+M_1,
\tag{2}
\]
where
\[
\begin{aligned}
U_0&=\mathbb E_{a,c}K_{k+r}(a,c)K_{r+h}(a,c),\\
U_1&=\mathbb E_{a,c}K_{k+r}K_{r+h}R_{u+l},\\
U_2&=\mathbb E_{b,c}K_{k+r+h}K_rR_{u+l},\\
M_0&=\mathbb E_{c,d}K_lR_{r+u}R_{r+h+u},\\
M_1&=\mathbb E_c\langle K_{r+h}(\cdot,c),
                 (R_k\circ M_c)K_r(\cdot,c)\rangle_\mu.
\end{aligned}
\]
All factors in each two-point expression use the displayed common pair.
For example, the term linear in \(R_u(a,d)\) collapses successively over
\(d\) and \(b\) to \(U_1\), using weighted convolution. The analogous other
linear term is \(U_2\).

Let \(\phi_0=1,\phi_i\) be an original-law orthonormal eigenbasis of \(A\),
with eigenvalues \(\theta_i\in[0,1]\), and
\(m_{ijs}=\mathbb E_\mu\phi_i\phi_j\phi_s\).
Then \(U_0=\operatorname{tr}A^{k+2r+h}\ge1\). Every other two-point expression
above is a sum of
\(\theta_i^\alpha\theta_j^\beta\theta_s^\gamma m_{ijs}^2\)
with the constant index omitted in every centered factor. Consequently
\[
U_1,U_2,M_0\ge0.
\tag{3}
\]
This argument retains every extra unit mode; it does not assert positivity
of the trace of three arbitrary PSD operators.

In \(M_1\), the \(ab,ad,bd\) factors are already centered. Expanding the
\(ac,bc,cd\) factors leaves exactly the centered triangle \(abd\), three
centered diamonds missing \(ac,bc,cd\), and the full centered tetrahedron.
Terms with exactly one selected \(c\)-edge vanish by centering. The triangle
is a positive trace. For a diamond, integrate its two degree-two vertices:
the result is a product of three common centered kernels on the remaining
pair, hence another sum of cubic-moment squares. These four positive terms
remain grouped with the potentially signed full term.

Thus \(M_1(h)\ge0\) would prove (1). It is a **stronger sufficient assertion**,
not an established lemma or an equivalent reformulation of (1).
The PSD property of \(R_k\circ M_c\) alone cannot sign its unequal cross-form.

There is an exact positive/error decomposition. Set
\(f_c=K_r(\cdot,c)\), \(g_d=R_u(\cdot,d)\). Then
\[
\begin{aligned}
M_1={}&\mathbb E_{c,d}K_l(c,d)
       \langle f_cg_d,R_{h+k}(f_cg_d)\rangle_\mu\\
&-\mathbb E_{c,d}K_l(c,d)
       \langle A^h(f_cg_d)-(A^hf_c)g_d,R_k(f_cg_d)\rangle_\mu.
\tag{4}
\end{aligned}
\]
The first term is nonnegative. The product commutator is exactly
\[
A^h(fg)(a)-(A^hf)(a)g(a)
=\mathbb E_xK_h(a,x)f(x)\bigl(g(x)-g(a)\bigr).
\]
Equation (4) follows from self-adjointness and \(A^hR_k=R_{h+k}\);
it gives no automatic sign or compensation bound for the second term.

## A normalized overlap channel

Write \(Y=X^2,\nu=\mu^2\), and regard
\[
V((a,c),b)=K_u(a,b)K_l(c,b),\quad
\Gamma=VK_uV^*,\quad g(a,c)=K_{u+l}(a,c)
\]
as weighted operators. Weighted convolution gives \(V^*1=1\),
\(\Gamma1=g\), and \(\mathbb E_\nu g=1\).
On \(Z=\{g>0\}\), define
\[
\rho(y)=g(y)\nu(y),\qquad
P(y,z)=\frac{\Gamma(y,z)}{g(y)g(z)}.
\]
Nonnegativity and \(\Gamma1=g\) imply that every zero-\(g\) row of
\(\Gamma\) vanishes. Therefore restriction to \(Z\) loses no contribution.
The kernel \(P\) is symmetric, nonnegative, PSD and Markov in \(L^2(\rho)\).
Its nonnegative conditional Gram factor is
\[
B(y,b)=\frac{(VT^u)(y,b)}{g(y)}.
\]
Indeed \(\mathbb E_\mu B(y,\cdot)=1\),
\(\mathbb E_\rho B(\cdot,b)=1\), and
\(P(y,z)=\mathbb E_\mu B(y,b)B(z,b)\).

For \(H=A^{k-u}\otimes A^{r-l}\) and \(L(a,c)=K_{r+h}(a,c)\),
direct expansion, followed by the dummy-variable swap \(b\leftrightarrow d\),
gives
\[
F=\mathbb E_{\rho^2}L(y)H(y,z)P(y,z).
\tag{5}
\]
Also \(Hg=K_{k+r}\). Thus the stationary part of this genuine channel is
\[
C=\mathbb E_{\mu^2}K_{r+h}K_{u+l}K_{k+r}\ge1,
\qquad
F=C+\mathbb E_{\rho^2}L(y)H(y,z)(P(y,z)-1).
\tag{6}
\]
The lower bound for \(C\) is again the cubic-moment-square identity.
Although \(H\) is Markov under \(\nu\), it need not be Markov under \(\rho\).
The auxiliary law is used only in the exact original-\(\mu\) identity (5).
No centered-remainder bound sufficient to prove (1) has been established.

## Compatible entropy witnesses

For nonnegative integer times \(t_v\), define the relative leaf density
\[
q_{\mathbf t}(x_a,x_b,x_c,x_d)
=\mathbb E_{z\sim\mu}\prod_{v=a,b,c,d}T^{t_v}(z,x_v).
\tag{7}
\]
It integrates to one against \(\mu^4\). Summing the other leaves gives the
pair kernel \(T^{t_v+t_w}\) under the original measure. This construction
does not prescribe potentially incompatible powered branch-pair tables.

Use natural logarithms, \(0\log0=0\), and
\[
J_T(s,t)=\mathbb E_{\mu^2}T^s\log T^t,\quad
I_T(t)=J_T(t,t).
\]
If the first kernel is positive where the second vanishes, \(J_T=-\infty\).
The finite Gibbs variational inequality gives
\[
\log F\ge\sum_{vw}J_T(t_v+t_w,2n_{vw})
                  -D(q_{\mathbf t}\Vert\mu^4).
\tag{8}
\]
Here \((n_{ab},n_{ac},n_{ad},n_{bc},n_{bd},n_{cd})=(k,r+h,u,r,u,l)\).
For the joint ancestor/leaf law \(Q\), entropy disintegration gives
\[
D(q_{\mathbf t}\Vert\mu^4)
=\sum_v I_T(t_v)-I_Q(Z;X_a,X_b,X_c,X_d).
\tag{9}
\]
Keeping the mutual-information subtraction is essential. Replacing the
marginalized entropy by the larger observed-ancestor entropy loses a
potential source of collective compensation.

### A strictly positive calibration

Take \(\mu=(1/2,1/2)\),
\[
T=\begin{pmatrix}3/2&1/2\\1/2&3/2\end{pmatrix},
\quad k=u=r=l=h=1,\quad t_a=t_b=t_c=t_d=1.
\]
The relative leaf densities are \(41/16\) on two all-equal configurations,
\(15/16\) on eight \(3+1\) configurations, and \(9/16\) on six \(2+2\)
configurations. Every pair kernel is \(K_1\). Formula (8) has payoff
\[
\begin{aligned}
\mathcal R={}&\frac{25}{8}\log\frac54+\frac{15}{8}\log\frac34
 +\frac12\log\frac{255}{256}+\frac18\log\frac{17}{15}\\
&-\frac{41}{128}\log\frac{41}{16}
 -\frac{15}{32}\log\frac{15}{16}
 -\frac{27}{128}\log\frac9{16}>\frac1{50}.
\end{aligned}
\tag{10}
\]
The strict inequality has an elementary rational certificate: for \(x>0\),
set \(z=(x-1)/(x+1)\), truncate
\[
\log x=2\sum_{j=0}^{3}\frac{z^{2j+1}}{2j+1}+e,\qquad
|e|\le\frac{2|z|^9}{9(1-z^2)}.
\]
Apply the bound with the correct sign to each coefficient in (10).
The resulting lower rational is
\[
\frac{86059558954613651713224506899082953297465490415676603572517453}
 {3945057957959529813223493024236019896819328179814400000000000000}
>\frac1{50}.
\]
Hence this witness proves \(F>e^{1/50}>1+1/50\), whereas the earlier fixed-star
witness had negative payoff. The actual density is \(535/512\).
This improves the witness on an already covered host; it is not a new
unrestricted theorem, host class, or novelty claim.

## Proved reflection endpoint and remaining work

At the auxiliary value \(h=0\), set
\(f_{cd}(a)=K_r(a,c)K_u(a,d)\). Since \(K_k-\Pi\succeq0\),
\[
F(0)\ge\mathbb E_{c,d}K_l(c,d)
       \bigl(\mathbb E_a f_{cd}(a)\bigr)^2
=\mathbb E_{c,d}K_l(c,d)K_{r+u}(c,d)^2\ge1.
\tag{11}
\]
Writing \(\sigma(t)=\operatorname{tr}A^t-1\), the constant-index parts in the
cubic expansion sharpen this to
\[
F(0)\ge1+\sigma(k+2r)+\sigma(2r+2u)+2\sigma(l+r+u).
\tag{12}
\]
For (12), use (2): \(M_1(0)\ge0\),
\(M_0\ge\sigma(2r+2u)\), and
\(U_1=U_2\ge\sigma(l+r+u)\).
All extra unit modes remain in \(\sigma\).
Neither bound interpolates to \(h\ge1\) or proves deleted-edge domination.

The exact missing positive step is still a **proved collective estimate**,
not an assumption that an entropy optimization or cross-form is nonnegative.
Possible sufficient routes are positivity of \(M_1\), a rigorously smaller
commutator budget in (4), or an adaptive compatible witness with provably
nonnegative payoff. The full remainder bound in (6) alone is equivalent to
the target and must not be presented as progress.

The arbitrary-band nested-partition theorem is already proved in the
[8 October note](../2026-10-08-rank-three-entropy/research-note.tex);
its maximum-spanning-forest audit also appears in the
[9 October record](../2026-10-09-entropy-density/public-review-round2-20261009/density-gap-attempt.json).
Likewise the rank-one Schur sign is already within the earlier restricted
coverage. Neither is counted again.
For the literature boundary, Im, Li and Liu's
[Theorems 1.3, 1.4 and 1.6](https://arxiv.org/html/2408.03491v2)
give uniform replacement, divisibility-controlled substitution, and one
special nonuniform clique family; these do not supply the six unequal
ordered powers in (1).

The [small exact checker](check_collective_compensation.py) verifies (2),
the centered-subgraph grouping, (4), the channel/support identities (5)–(6),
and (11)–(12) on a nonuniform three-state root, a periodic binary root, and a
constant root. It independently sums all sixteen binary witness
configurations and certifies (10). These finite checks support the written
derivations; they do not prove their universal hypotheses by sampling.
The [Pro brief](collective-compensation-pro-prompt.md) targets the remaining
collective step. Model advice will require its own proof audit.
