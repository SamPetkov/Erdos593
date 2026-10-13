# Exact edge entropy for sufficiently long subdivisions

For each fixed strictly positive pair table, sufficiently long bipartite
subdivisions of \(K_4\) admit a joint law fitting every actual edge table at
the desired KL cost. The proof globally corrects a Gibbs law. It does not
require the six stationary-powered branch marginals to fit simultaneously.

The threshold depends on the pair table and singleton law. This is not a
theorem for arbitrary original lengths, zero-entry pair tables, or the
specific tuple \((2,4,6,8,10,12)\) without checking the conditions below.
No novelty or Lean-validation claim is made.

## Finite sufficient criterion

Let \(J\) be an actual simple bipartite subdivision of \(K_4\), with six
positive path lengths \(L_e\), distinct branch vertices and disjoint path
interiors. Put
\[
m=\sum_e L_e,\qquad n=m-2,\qquad s=\min_e L_e,\qquad
g=\operatorname{girth}(J).
\]
Let the alphabet have size \(q\ge2\). Let \(\kappa>0\) be a probability law
and let \(\lambda>0\) be a symmetric probability table whose two marginals
are \(\kappa\). Define
\[
a=\min_x\kappa_x,\quad w(x,y)=\frac{\lambda_{xy}}{\kappa_x\kappa_y},
\quad \ell=\min w,\quad u=\max w,\quad
P_{xy}=\frac{\lambda_{xy}}{\kappa_x}.
\]
Write \(\Pi\) for the constant projection on \(L^2(\kappa)\), and
\[
K=P-\Pi,\qquad r=\|K\|_{L^2(\kappa)},\qquad
I=D(\lambda\Vert\kappa^2).
\]
Here \(P\) is an ordinary transition matrix. The relative kernel of \(K\)
is \(w-1\); all kernel compositions and inner products use \(\kappa\).
If \(r=0\), the independent joint law works. Otherwise positivity gives
\(0<r<1\).

Set
\[
\begin{aligned}
d&=n(q-1)+m(q-1)^2,\\
C_Z&=7(q-1)+7a^{-6},\\
C_G&=256a^{-9}+a^{-1}C_Z,\\
L_0&=a^{-1}\sqrt{(q-1)+3(q-1)^2},\qquad
\rho=(2L_0)^{-1},\\
c&=e^{-1}(\ell/u)^3,\qquad h=c^4/4.
\end{aligned}
\]
The following three explicit conditions suffice:
\[
7a^{-6}r^{2s}\le\tfrac12, \tag{A}
\]
\[
\sqrt d\,C_G r^{g-1}\le h\rho/4, \tag{B}
\]
\[
dC_G^2r^{g-2}\le h/4. \tag{C}
\]
Under these conditions there is a law \(\tau\) on the actual
\(\Omega^{V(J)}\) with singleton \(\kappa\) at every vertex, table
\(\lambda\) on every actual edge, and
\[
\boxed{D(\tau\Vert\kappa^{V(J)})\le mI-\tfrac18r^g.} \tag{1}
\]
Natural logarithms are used. An exchangeable triple extension is not
needed for this restricted result.

## Cycle gain in the original Gibbs law

Let \(R=\kappa^{V(J)}\) and
\[
\mu_0(z)=Z^{-1}R(z)\prod_{xy\in E(J)}w(z_x,z_y),
\qquad Z=\mathbb E_R\prod_e w_e.
\]
Expand every \(w_e=1+(w_e-1)\). A selected-edge subset with an unmarked
degree-one vertex has zero integral. Without inserted statistics, internal
degree-two vertices force each core path to be wholly selected or absent.
The surviving nonempty core subsets are four triangles, three quadrilaterals,
six diamonds and the complete \(K_4\).

A cycle of length \(t\) contributes \(\operatorname{tr}(K^t)\). Every such
\(t\) is even, so the contribution is nonnegative; a shortest cycle
contributes at least \(r^g\). For each \(j\ge1\), the relative kernel obeys
\[
|K^j(x,y)|\le\frac{r^j}{\sqrt{\kappa_x\kappa_y}}
\le a^{-1}r^j. \tag{2}
\]
Each diamond contains a triangle of length at least \(g\) and two additional
paths of length at least \(s\). The full core contains a triangle and three
additional paths. Bounding their contracted kernels by (2) gives
\[
Z-1\ge r^g-7a^{-6}r^{g+2s},\qquad
|Z-1|\le C_Zr^g.
\]
Thus (A) implies
\[
Z\ge1+\tfrac12r^g,\qquad \log Z\ge\tfrac14r^g. \tag{3}
\]

## All singleton and edge constraints

Choose a centered \(\kappa\)-orthonormal basis
\(\xi_1,\ldots,\xi_{q-1}\). Use all unary statistics \(\xi_i(X_v)\) and
all actual-edge statistics \(\xi_i(X_x)\xi_j(X_y)\), with an arbitrary
fixed orientation for each edge. Their number is \(d\). Let \(\mathbf b\)
be their required moment vector: zero for unary statistics and
\(\mathbb E_\lambda \xi_i(X)\xi_j(Y)\) for each edge statistic.
Each statistic and each target moment has absolute value at most \(a^{-1}\).

Insert one statistic \(S\) into the selected-edge expansion. Leaves outside
its one- or two-vertex support still kill the term. A surviving nonempty
forest cannot have only one supported vertex. With support at adjacent
vertices, the only surviving forest is a simple path between them. The
actual edge gives exactly the target moment \(b\); any other path has
length at least \(g-1\). Every other surviving subset contains a cycle
of length at least \(g\).

Splitting the six core paths at the one or two supported vertices gives at
most eight positive-length segments and at most \(2^8=256\) choices.
Unmarked internal vertices contract to exact \(K^j\) kernels. Every term
remaining after the target contribution has total selected length at least
\(g-1\). Equation (2), at most eight kernels and the statistic bound give
\[
\left|\mathbb E_R S\prod_e w_e-b\right|
\le256a^{-9}r^{g-1}.
\]
Dividing by \(Z\ge1\), and using (3) and the upper bound on \(Z-1\), yields
\[
|\mathbb E_{\mu_0}S-b|\le C_G r^{g-1},\qquad
\|\mathbb E_{\mu_0}\mathbf S-\mathbf b\|_2
\le G_0:=\sqrt d\,C_G r^{g-1}. \tag{4}
\]

## Covariance controlled by single-site conditionals

Let a positive pairwise Gibbs law \(\mu\) on a simple graph of maximum
degree \(\Delta\) satisfy, for every conditioning,
\[
\mu(X_v=x\mid X_{-v})\ge c\kappa_x.
\]
For centered unary functions \(A_v\) and separately centered pair functions
\(B_{xy}\), put \(H=\sum_v A_v(X_v)+\sum_{xy}B_{xy}(X_x,X_y)\).
Then
\[
\operatorname{Var}_\mu H\ge
\frac{c^{\Delta+1}}{\Delta+1}
\left(\sum_v\|A_v\|_\kappa^2+
2\sum_{xy}\|B_{xy}\|_{\kappa^2}^2\right). \tag{5}
\]

Properly color the graph with \(\Delta+1\) colors. Conditional on the
complement of a color class, its sites are independent. The minimum-over-
centering formula for variance gives
\(\operatorname{Var}_{p}f\ge c\operatorname{Var}_\kappa f\) whenever
\(p\ge c\kappa\). Tower conditioning preserves the same probability lower
bound when only a subset of sites is conditioned on. Consequently a
\(d_v\)-neighbor marginal dominates \(c^{d_v}\kappa^{N(v)}\).
Under independent reference neighbors, centering eliminates cross terms.
Summing the color-class conditional-variance inequalities counts each unary
norm once and each pair norm twice, and proves (5).

For the seed, the single-site conditional floor is
\((\ell/u)^3\kappa\). A Euclidean parameter displacement of norm at most
\(\rho\) changes a site's conditional potential by at most \(L_0\rho\),
because at most \(q-1+3(q-1)^2\) local statistics occur and each is bounded
by \(a^{-1}\). Its oscillation changes by at most \(2L_0\rho=1\).
Every law in that parameter ball therefore has conditional floor
\(c\kappa\), with the same \(c\) independently of \(m,n\).
With \(\Delta=3\), (5) gives covariance at least \(hI_d\).
The bipartition could improve the color factor from four to two; the stated
criterion uses the conservative factor four.

## Global fitting and entropy cost

The unary and pair basis gives a finite decomposition
\(\sum_e\log w_e=\gamma+\theta_0\cdot\mathbf S\). Define
\[
\Phi(\theta)=\log\mathbb E_R e^{\theta\cdot\mathbf S}
-\theta\cdot\mathbf b.
\]
Its gradient at \(\theta_0\) is the residual in (4); its Hessian is the
covariance matrix. On the radius-\(\rho\) ball its Hessian is at least
\(hI_d\). Condition (B) gives, for every boundary displacement \(z\),
\[
\Phi(\theta_0+z)\ge
\Phi(\theta_0)-G_0\rho+\tfrac h2\rho^2
\ge\Phi(\theta_0)+\tfrac h4\rho^2.
\]
The minimum on the compact ball is interior, with zero gradient. Its Gibbs
law matches every unary and edge-product moment. Completeness of the
tensor basis then recovers every full singleton and every full edge table.
Strong convexity gives
\[
\Phi(\theta_0)-\Phi(\theta_*)\le G_0^2/(2h).
\]
The constant \(\gamma\) cancels in
\(\Phi(\theta_0)=\log Z-mI\), while the fitted law has
\(D(\tau\Vert R)=-\Phi(\theta_*)\). Therefore, by (3), (4) and (C),
\[
D(\tau\Vert R)\le mI-\tfrac14r^g+
\frac{dC_G^2r^{2g-2}}{2h}
\le mI-\tfrac18r^g,
\]
as required.

## Eventual coverage and the remaining boundary

Fix \(\kappa,\lambda>0\) and any six parity-compatible positive lengths
\(\ell_e\) defining a simple bipartite subdivision. Let \(L_e=\ell_e+N\)
for even \(N\). The parity is unchanged, \(s\to\infty\), \(g\ge3s\),
and \(d=O(N)\). Since \(r<1\), conditions (A), (B) and (C) eventually hold.
Thus every sufficiently large even \(N\) admits the exact-edge witness,
with positive entropy slack.

The one-symbol and independent-pair cases use the product law directly.
The positivity hypothesis is substantive: as a pair entry tends to zero,
the conditional floor and the threshold can degenerate. These estimates
provide no common threshold that would justify a zero-table limit.
Neither arbitrary original lengths
nor the full arbitrary-alphabet target follows.
