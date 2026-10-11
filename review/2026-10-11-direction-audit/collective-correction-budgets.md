# Explicit collective compensation for common power densities

Two constructive estimates retain compensation that a single reflection or
ancestral trial can lose. The operator estimate uses positive two-point
budgets. The entropy estimate removes higher-order information while
preserving all pair laws, including on a support face with zero entries.
Neither proves the unrestricted ordered inequality. The entropy correction
does repair an actually negative ancestral trial on a host already covered
by the earlier density results.

## Original law and target

Let \(X\) be finite and nonempty, with positive probability law \(\mu\).
All kernels are relative kernels; composition and inner products use this
original law. Let \(T\ge0\) be symmetric and Markov, and put
\[
A=T^2,\qquad K_j=A^j,\qquad\Pi=1,\qquad
K_0(x,y)=\mathbf1_{x=y}/\mu_y.
\]
For integers \(k\ge u\ge1,r\ge l\ge1,h\ge1\), define
\[
\Phi=K_k(a,b)K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d),
\qquad F=\mathbb E_{\mu^4}\Phi. \tag{1}
\]
The goal remains \(F\ge1\) for every input, allowing reducibility,
periodicity, extra stationary modes, zero modes and zero entries.
The [regional theorem](markov-jensen-compensation.md) already covers
\(u+l\le r+h\) or \(u\ge r+l\).
The following estimates are input-specific certificates, not a new
host-uniform exponent region or a Lean implementation.

## Positive two point budgets

Write \(m=r+h,n=u+l,p=k+r,\alpha=k-u,\beta=r-l\).
On \(Y=X^2,\nu=\mu^2\), define
\[
V((a,c),b)=K_u(a,b)K_l(c,b),\quad g=V1=K_n,\quad
\Gamma=VK_uV^*,\quad H=K_\alpha\otimes K_\beta,\quad L=K_m.
\]
Weighted convolution gives \(V^*1=1,\Gamma1=g,Hg=K_p\), and
\[
F=\mathbb E_{\nu^2}L(y)H(y,z)\Gamma(y,z). \tag{2}
\]
For (2), expand the two integrations in \(\Gamma\), integrate both
coordinates of \(z\), and interchange the names \(b,d\).
The six remaining factors are exactly (1).

Suppose \(0\le\gamma,\eta\le1\) satisfy the **entrywise** bounds
\[
\Gamma(y,z)\ge\gamma g(y)g(z),\qquad H(y,z)\ge\eta. \tag{3}
\]
Put \(J=\mathbb E_\nu g\sqrt L\),
\(C_0=\mathbb E_\nu gL\), and \(C_H=\mathbb E_\nu Lg(Hg)\). Then
\[
\boxed{F\ge\gamma C_H+(1-\gamma)\eta C_0
 +(1-\gamma)(1-\eta)J^2.} \tag{4}
\]
The distinct **PSD** comparisons \(\Gamma\succeq g\otimes g\) and
\(H\succeq\Pi_Y\) follow from \(K_u-\Pi\succeq0\) and the PSD Markov
property of \(H\). Thus
\[
\Gamma'=\Gamma-\gamma g\otimes g,\quad H'=H-\eta\Pi_Y
\]
are entrywise nonnegative, with
\[
\Gamma'\succeq(1-\gamma)g\otimes g,\quad
H'\succeq(1-\eta)\Pi_Y,\quad \Gamma'1=(1-\gamma)g.
\]
Expanding each as its displayed PSD lower bound plus a PSD remainder and
using the Schur product theorem gives
\(R=H'\circ\Gamma'\succeq(1-\gamma)(1-\eta)g\otimes g\).
The exact splitting is
\[
F=\gamma C_H+(1-\gamma)\eta C_0+\mathbb E_{\nu^2}L(y)R(y,z).
\]
Since \(R\) is symmetric and entrywise nonnegative, arithmetic--geometric
mean bounds its last term by
\[
\tfrac12\mathbb E_{\nu^2}(L(y)+L(z))R(y,z)
\ge\langle\sqrt L,R\sqrt L\rangle_\nu
\ge(1-\gamma)(1-\eta)J^2.
\]
This proves (4), without dividing by a possibly zero entry.

The retained budgets are explicit. Write
\(\sigma(t)=\operatorname{tr}A^t-1\) and
\(M_3=\mathbb E_{\mu^2}(K_m-1)(K_n-1)(K_p-1)\). Then
\[
C_0=1+\sigma(m+n),\qquad
C_H=1+\sigma(m+n)+\sigma(m+p)+\sigma(n+p)+M_3. \tag{5}
\]
In an original-law orthonormal eigenbasis
\(\phi_0=1,A\phi_i=\theta_i\phi_i,0\le\theta_i\le1\),
\[
M_3=\sum_{i,j,s\ne0}\theta_i^m\theta_j^n\theta_s^p
       (\mathbb E_\mu\phi_i\phi_j\phi_s)^2\ge0.
\]
Nonconstant unit modes are retained. Consequently a sufficient test is
\[
\begin{split}
&\gamma[\sigma(m+n)+\sigma(m+p)+\sigma(n+p)+M_3]
 +(1-\gamma)\eta\sigma(m+n)\\
&\hspace{2em}\ge(1-\gamma)(1-\eta)(1-J^2). \tag{6}
\end{split}
\]
It holds immediately if \(J\ge1\); otherwise it compares a two-point
deficit with positive budgets, not the full four-vertex remainder.

### Floors from the actual conditional channel

Simple valid choices are
\(\gamma_0=\min K_u\) and
\(\eta=(\min K_\alpha)(\min K_\beta)\).
An identity-power minimum is zero on a nonsingleton space.
On \(Z=\{g>0\}\), set
\[
\beta_y(b)=V(y,b)/g(y),\qquad \rho(y)=\nu(y)g(y).
\]
These are normalized densities and \(\mathbb E_\rho\beta_y=1\).
For \(0\le j\le u\), put \(a_j(b)=\min_{y\in Z}(K_j\beta_y)(b)\).
Thus \(0\le a_j\le1\), and
\[
\frac{\Gamma(y,z)}{g(y)g(z)}
=\langle K_j\beta_y,K_{u-j}\beta_z\rangle_\mu
\ge\mathbb E_\mu a_j a_{u-j}.
\]
Another valid floor is
\(\gamma_P=\min_{y\in Z}\langle\beta_y,a_u\rangle_\mu\ge\gamma_0\).
Their maximum, together with all \(u+1\) overlap floors, is a valid
\(\gamma\in[0,1]\). Zero-\(g\) rows of \(V,\Gamma\) vanish, so they require
no conditional law. The conditional tables have \(|X|^3\) entries, but
dense convolution can still take \(O(|X|^4)\) arithmetic per \(j\);
no complexity improvement is claimed.

### Component compensation

Use communicating components \(C_i\) of \(A=T^2\), not of \(T\).
Set \(\pi_i=\mu(C_i)\), \(\mu_i=\mu|_{C_i}/\pi_i\), and
\(A_i=\pi_i A|_{C_i^2}\). These component operators are nonnegative,
symmetric, PSD and Markov. Connectedness of the six-edge graph gives
\[
F=\sum_i\pi_i^{-2}F_i
\ge\sum_i\pi_i^{-2}
 [\gamma_i C_{H,i}+(1-\gamma_i)\eta_i C_{0,i}
 +(1-\gamma_i)(1-\eta_i)J_i^2]. \tag{7}
\]
The factor comes from four vertex masses versus six relative kernels.
The proof needs no restriction of a periodic root to an \(A\)-component.
Component scaling and minorization already occur in the
[fixed-host tail proof](fixed-host-tail.md); (4) retains a different finite
budget, not new mixing-tail coverage.

## Entropy correction preserving every pair law

Let \(m_0=\mu^4\), and let \(p\) be a normalized relative density with
\(\Omega=\{p>0\}\subseteq\{\Phi>0\}\). Define
\[
\mathcal R(p)=\mathbb E_{m_0}p\log\Phi-\mathbb E_{m_0}p\log p.
\]
Gibbs variational inequality gives \(\log F\ge\mathcal R(p)\).
Let \(W\) be the span of all functions of at most two coordinates,
restricted to \(\Omega\). In \(L^2(pm_0)\), put
\[
w=\operatorname{Proj}_W\log p,\qquad h=\log p-w,\qquad
a=\mathbb E_p h^2,\qquad M=\max_\Omega|h|.
\]
This projection requires no invertible redundant covariance matrix.
The law
\[
\boxed{q=p(1-h/(1+M))} \tag{8}
\]
is normalized, supported on \(\Omega\), and has every complete pair law
and singleton law of \(p\). Moreover
\[
\boxed{\mathcal R(q)-\mathcal R(p)\ge a/[2(1+M)].} \tag{9}
\]
Orthogonality to constants and pair indicators gives
\(\mathbb E_p h=0\) and \(\mathbb E_p[h\mid X_i,X_j]=0\) on positive pair
events. Thus \(q_t=p(1-th)\) preserves every pair law and every actual
pair-log energy, whether or not its pair tables equal the target powers.
For \(0\le t\le(1+M)^{-1}\), \(q_t\ge p/(1+M)\), and differentiation gives
\[
\mathcal R'(0)=\mathbb E_p h\log p=a,\qquad
\mathcal R''(t)=-\mathbb E_p\frac{h^2}{1-th}\ge-(1+M)a.
\]
Integration at \(t=(1+M)^{-1}\) proves (9).
If \(h=0\), the law already minimizes relative-entropy cost among compatible laws on
\(\Omega\): for any compatible \(s\),
\(D(s\Vert m_0)-D(p\Vert m_0)=D(s\Vert p)\ge0\).
This does not permit expansion of the support.
The sufficient density certificate is
\[
\mathcal R(p)+a/[2(1+M)]\ge0. \tag{10}
\]
A finite gain cannot pay infinite negative pair energy; the support
hypothesis is essential.

### A finite fitting gap certificate

Let \(D_*\) be the minimum entropy cost among laws with these pair laws
on \(\Omega\), and \(\mathcal R_*\) their maximum score.
Set \(Z=\mathbb E_p e^{-h}=\sum_\Omega m_0e^w\).
For every feasible \(s\), \(\mathbb E_s w=\mathbb E_p w=D(p\Vert m_0)\).
Apply nonnegative KL divergence to the probability law \(m_0e^w/Z\):
\[
D(p\Vert m_0)-\log Z\le D_*\le D(p\Vert m_0),\qquad
\mathcal R(p)\le\mathcal R_*\le\mathcal R(p)+\log Z. \tag{11}
\]
Taylor's remainder bound, \(\mathbb E_p h=0\), and \(\log(1+x)\le x\)
give \(0\le\log Z\le e^M a/2\).
An upper bound \(\mathcal R_*<0\) excludes this fixed-pair support witness,
not the density theorem or other admissible witnesses.

## A globally convergent compensation path

There is a continuous variant whose convergence does not require an
assumed floor for successive explicit linear updates. Fix a positive
feasible probability law \(c\) on \(\Omega\), set \(p_0=c/m_0\), and solve
\[
\dot p_t=-p_t h_t,\qquad
h_t=\log p_t-\operatorname{Proj}^{L^2(p_tm_0)}_W\log p_t,\qquad
a(t)=\mathbb E_{p_t}h_t^2. \tag{12}
\]
Every pair law stays fixed. An independent basis of \(W\) makes the vector
field smooth in the positive feasible simplex, even if the original list
of pair indicators is redundant.

For global existence, put \(r=m_0(\Omega)\),
\(G_0=D(c\Vert m_0)+\log r\ge0\), and
\(H(c)=-\sum c_x\log c_x\). The reverse divergence
\(V_c=D(c\Vert p_tm_0)\) satisfies
\[
V_c'=D(c\Vert m_0)-V_c-D(p_tm_0\Vert m_0)\le G_0-V_c.
\]
Here fixed pair moments identify the expectations of the projection,
and every law on \(\Omega\) has entropy cost at least \(-\log r\).
Hence \(V_c\le G_0\). Writing \(\rho_t=m_0p_t\), we have
\(V_c+H(c)=-\sum c_x\log\rho_t(x)\ge-c_x\log\rho_t(x)\).
Therefore
\[
\rho_t(x)\ge\exp[-(G_0+H(c))/c_x]
\ge\exp[-(G_0+H(c))/\min_xc_x]>0. \tag{13}
\]
This is a compact interior region, giving global ODE continuation.

The unique entropy minimizer \(\rho_*=m_0p_*\) exists by compactness and
strict convexity. It is positive on \(\Omega\): mixing a boundary
minimizer with \(c>0\) introduces a favorable
\(\varepsilon\log\varepsilon\) term that dominates the bounded linear
changes at positive masses. First-order optimality on the affine
constraint space yields \(\log p_*\in W\). Consequently
\[
V(t)=D(\rho_*\Vert\rho_t),\qquad
V'=-V-D(\rho_t\Vert\rho_*),\qquad
V(t)\le\log(1/\min c_x)e^{-t}. \tag{14}
\]
Indeed \(V'=D_*-V-D(\rho_t\Vert m_0)\), and fixed pair moments give
\(D(\rho_t\Vert m_0)-D_*=D(\rho_t\Vert\rho_*)\).
This proves convergence. Fixed pair-log energy also gives
\[
\frac{d}{dt}\mathcal R(p_t)=a(t),\qquad
\int_0^\infty a(t)\,dt=D(c\Vert m_0)-D_*. \tag{15}
\]

For a finite accuracy estimate, let \(N=|\Omega|\ge2\) and
\(A_0=\log(1/\min c_x)\). Pinsker's inequality gives total variation
at most \(\sqrt{A_0e^{-t}/2}\).
Fixed singleton laws make \(\mathbb E\log m_0\) constant, so entropy-cost
gaps equal Shannon-entropy gaps. Finite entropy continuity gives
\[
D(\rho_t\Vert m_0)-D_*\le H_2(v)+v\log(N-1)
\]
if the total variation bound is at most \(v\le1/2\), where \(H_2\) is binary
entropy with natural logarithms. For accuracy \(\varepsilon>0\), choose
\[
v=\min\{1/2,[\varepsilon/(2+\log(N-1))]^2\},\qquad
t\ge\max\{0,\log[A_0/(2v^2)]\}.
\]
The elementary bound \(H_2(v)\le2\sqrt v\) gives a gap at most
\(\varepsilon\). This is mathematical flow time, not a computer-runtime
bound or an executed simulation. A singleton support is stationary.
Certificate (11) applies at every time. Global convergence of the
discrete updates (8) is not asserted.

The path realizes the entire available fixed-pair compensation budget.
It does not prove that budget sufficient. If the trial fits the six
target pair laws, the missing inequality is
\[
D_*\stackrel{?}{\le}\sum_e I_T(2n_e),\qquad
I_T(s)=\mathbb E_{\mu^2}T^s\log T^s.
\]
Away from the compatible face these pair laws can be impossible to fit;
a general trial requires its actual pair-log energy instead.

## An actual negative trial repaired

Take \(\mu=(1/10,9/10)\), \(f=(3,-1/3)\), and
\[
\mathbb E_\mu f=0,\quad\mathbb E_\mu f^2=1,\quad
m_3=\mathbb E_\mu f^3=8/3,\qquad
T_\lambda=1+\lambda f\otimes f,\quad0<\lambda<1.
\]
This is an actual strictly positive symmetric Markov root.
At \((k,u,r,l,h)=(5,3,2,2,2)\), use two stationary ancestors joined by
\(T_\lambda^2\); attach \(a,d\) to the first by times \(5,1\) and \(b,c\)
to the second by times \(3,1\). Their marginalized density fits exactly
all six target pair laws, and equals
\[
\begin{split}
p={}&1+\sum_e\lambda^{2n_e}f_if_j
 +m_3\lambda^7f_bf_cf_d+m_3\lambda^9f_af_cf_d\\
 &+m_3\lambda^{11}(f_af_bf_d+f_af_bf_c)
 +(\lambda^{10}+m_3^2\lambda^{12})f_af_bf_cf_d. \tag{16}
\end{split}
\]
Its score satisfies
\[
\mathcal R(p)=-23\lambda^{14}/9+O(\lambda^{15}). \tag{17}
\]
All single-edge entropy terms cancel their matching pair energies.
Up to degree \(14\), the only remaining pair interaction is the \(bcd\)
triangle, giving \(+\lambda^{14}\). The first triple term in (16) costs
\(m_3^2\lambda^{14}/2=32\lambda^{14}/9\).
Pair--triple quadratic cross terms vanish by centering; the next
pair--pair--triple degree is \(15\), four pair factors have degree at least
\(16\), and the first four-coordinate term has degree \(10\).
The finite Taylor series of \((1+x)\log(1+x)\) establishes (17).

At zero, projection onto \(W\) is ordinary product-law projection.
Its Gram matrix in an independent basis remains invertible near zero.
The first higher-order component therefore gives
\[
h=m_3\lambda^7f_bf_cf_d+O(\lambda^8),\qquad
a=64\lambda^{14}/9+O(\lambda^{15}),\qquad M=O(\lambda^7).
\]
The guaranteed gain (9) is \(32\lambda^{14}/9+O(\lambda^{15})\);
hence \(\mathcal R(q)\ge\lambda^{14}+O(\lambda^{15})>0\) for sufficiently
small positive \(\lambda\). These are fixed-input finite analytic
expansions, not a host-uniform radius or an explicit numerical threshold.
This rank-one host was already density-covered. The advance is a
constructive repair of its negative ancestral trial.

## Exact remaining obligation

The unrestricted proof still needs a budget valid on every root and
tuple. Sufficient routes are (6), possibly summed as (7), or an admissible
trial whose actual deficit is paid by (9) or (15). None is proved globally.

This differs from [long-subdivision fitting](long-subdivision-entropy.md),
which changes Gibbs parameters to fit prescribed tables: the current
tables stay fixed as higher-order information is removed.
The [weak-host exact-pair proof](weak-host-exact-pair-compensation.md)
already supplied near-constant-host density coverage; it is not counted
again. Entropy projection, entropy flows and minorization are established
methods, not novelty-cleared results here. No manuscript theorem or
accepted Lean interface is added by this research note.
