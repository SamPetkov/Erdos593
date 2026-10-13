# Tetrahedral density under cubic orthogonality

Different spectral rates can be treated together when their eigenspaces do not
interact through third moments. Under this explicit condition, the tetrahedral
density is at least one for every six positive edge lengths, even with inactive
zero modes and a signed spectral range projection. The condition is not a
consequence of having a nonnegative Markov root.

## Original measure and spectral condition

Let X be finite and nonempty, with a probability law mu(x)>0. Kernels and
operator compositions are relative to this original law. Let A be a
self-adjoint, positive-semidefinite, entrywise nonnegative Markov operator.
Write Pi(x,y)=1 and suppose

\[
A=\Pi+\sum_{s=1}^m\theta_s P_s,
\qquad 0<\theta_s\le1,
\tag{1}
\]

where P_s are mutually orthogonal nonzero projections orthogonal to constants.
They exhaust the positive centered spectral subspace. Their sum need not be
I-Pi: centered zero modes are allowed. The numbers theta_s need not be distinct.
Assume the basis-independent cubic orthogonality condition

\[
\mathbb E_\mu f g h=0
\quad\text{for }f\in\operatorname{ran}P_s,
\ g\in\operatorname{ran}P_t,
\ h\in\operatorname{ran}P_v,
\quad\text{unless }s=t=v.
\tag{2}
\]

For independently chosen integers n_e>=1 on the six edges of K4, define

\[
F_A(\mathbf n)=\mathbb E_{\mu^4}
\prod_{e=xy\in E(K_4)} A^{n_e}(x,y).
\tag{3}
\]

Then F_A(n)>=1. If A is not Pi, the inequality is strict. This includes the
ordered lengths k,r+h,u,r,u,l, but requires neither their ordering nor a
nonnegative square root of A.

## A statement with independent edge coefficients

We prove a slightly more general algebraic statement. For each edge e, let

\[
R_e=1+\sum_s t_{e,s}P_s,\qquad t_{e,s}\ge0.
\tag{4}
\]

Only the distinguished kernel W=R_ac is required to be entrywise nonnegative.
Under (2),

\[
\mathbb E_{\mu^4}\prod_e R_e\ge1.
\tag{5}
\]

The other five kernels in this statement may have signed entries. For (3),
take t_e,s=theta_s^(n_e); every kernel is then an actual nonnegative power.

Choose orthonormal real bases phi_i of the sectors and put
m_ijk=E_mu phi_i phi_j phi_k. Expand the six factors in (4). A nonempty
selected centered subgraph with a degree-one vertex integrates to zero.
The surviving proper subgraphs are four triangles, three four-cycles and
six diamonds (K4 with one edge removed), in addition to the full K4.
They are all connected. A degree-two vertex forces its two mode indices to
agree by orthonormality. At a degree-three vertex, a nonzero cubic moment
forces the three modes into the same sector by (2). Thus each surviving
centered diagram uses just one sector.

Let F_s denote the formal density obtained by retaining only P_s in all six
factors. The exact expansion gives

\[
F-1=\sum_s(F_s-1).
\tag{6}
\]

This identity alone does not sign F_s: the kernel 1+t_ac,s P_s need not be
nonnegative. We retain the actual weight W to prove that sign.

## Paying one sector with the actual kernel

Fix a sector and abbreviate its edge coefficients on ab,bc,ad,cd,ac,bd by
alpha,beta,delta,gamma,eta,zeta, respectively. Write

\[
r_s=\operatorname{rank}P_s,\qquad
q_i(a,c)=\sum_{j,k\in s}m_{ijk}\phi_j(a)\phi_k(c),
\qquad M_i=\sum_{j,k\in s}m_{ijk}^2,
\qquad M_s=\sum_{i\in s}M_i.
\tag{7}
\]

Integrating b and d after expanding their connecting edge gives the exact
common-projection formula

\[
\begin{aligned}
F_s-1={}&(\eta\alpha\beta+\eta\delta\gamma+
                  \alpha\beta\delta\gamma)r_s
                  +\eta\alpha\beta\delta\gamma M_s\\
&+\zeta\sum_{i\in s}\bigl[
\alpha\delta+\beta\gamma+\eta(\alpha\gamma+\beta\delta)\\
&\qquad+\eta M_i(\alpha\delta\gamma+\beta\delta\gamma+
                         \alpha\beta\delta+\alpha\beta\gamma)
       +\alpha\beta\delta\gamma N_i\bigr],
\end{aligned}
\tag{8}
\]

where N_i=E_ac(1+eta P_s(a,c))q_i(a,c)^2. For completeness, the two
degree-two paths in the constant bd term have kernels
1+alpha beta P_s and 1+delta gamma P_s. In the nonconstant bd term the
two factors are

\[
\alpha\phi_i(a)+\beta\phi_i(c)+\alpha\beta q_i(a,c),
\qquad
\delta\phi_i(a)+\gamma\phi_i(c)+\delta\gamma q_i(a,c).
\]

Their nine pairings give (8): same-coordinate axis pairings equal one,
different-coordinate pairings equal eta, and each axis-to-q pairing equals
eta M_i. These identities are algebraic projection identities and do not
assume positivity of the one-sector kernel.

If t differs from s, expansion in the two original coordinates gives

\[
\begin{aligned}
\mathbb E_{a,c}P_t(a,c)q_i(a,c)^2
=\sum_{j,k,j',k'\in s}\sum_{\ell\in t}
m_{ijk}m_{ij'k'}m_{\ell jj'}m_{\ell kk'}=0.
\end{aligned}
\tag{9}
\]

Both mixed cubic moments vanish by (2). Consequently

\[
N_i=\mathbb E_{a,c}W(a,c)q_i(a,c)^2\ge0.
\tag{10}
\]

Every coefficient and every term in (8) is now nonnegative. Equations
(6)--(10) prove (5), hence (3). For actual powers, the retained triangle
coefficient eta alpha beta r_s is strictly positive in every nonempty
sector. Therefore A!=Pi implies F_A(n)>1. If A=Pi, direct summation gives
F_A(n)=1.

## Nonuniform coordinate roots with a signed range

There are actual roots satisfying (2) with arbitrarily many spectral rates
and arbitrarily large active ranks. Let X be a product of finite nonempty
sets X_s, with product law mu=product_s nu_s, every atom positive. Discard
singleton factors. Let E_s be conditional expectation onto coordinate s
and put P_s=E_s-Pi. These projections have orthogonal ranges. A centered
function in one sector depends only on its coordinate; independence gives
(2), including triples with exactly two indices in the same sector.

For positive numbers a_s with sum_s a_s<=1, set

\[
T=\Pi+\sum_s a_s P_s.
\tag{11}
\]

Its relative kernel is

\[
T(x,y)=1-\sum_s a_s+
\sum_s a_s\frac{\mathbf1_{x_s=y_s}}{\nu_s(y_s)}\ge0.
\tag{12}
\]

It is symmetric and Markov under the original product law. Orthogonality
gives A=T^2=Pi+sum_s a_s^2 P_s, so (3) applies to every six positive
edge lengths. Negative eigenvalues of T are not needed for this example;
the theorem itself does not impose a sign on eigenvalues of a supplied root.

For at least two nontrivial factors, the range projection is

\[
E=\Pi+\sum_sP_s=\sum_sE_s-(m-1)\Pi.
\tag{13}
\]

At two states differing in every coordinate, E(x,y)=-(m-1)<0. Thus this
corollary does not use a nonnegative range projection or an identity-mixture
argument. Choosing distinct a_s produces arbitrarily many distinct positive
centered levels; inactive interaction modes remain present.

## Localizing the two-mode payment

The ordered theorem permits a wider cubic decomposition than (1). Retain an
actual symmetric nonnegative Markov root T and A=T^2. Suppose the positive
centered subspace has an orthogonal A-invariant decomposition

\[
\operatorname{ran}A\cap\mathbf1^\perp=\bigoplus_C H_C,
\tag{14}
\]

with the cubic orthogonality condition (2) for these blocks. Suppose every
block is either at most two-dimensional or flat, meaning
A|_H_C=rho_C I for some rho_C>0. Then every ordered tuple
k>=u>=1, r>=l>=1, h>=1 has F>=1. This assertion, unlike (3), is restricted
to the ordered edge placement.

Put J=r+h and K_v=A^v, with all kernels relative to the original law.

Choose orthonormal eigenfunctions in each block, with positive eigenvalues
theta_i, and set phi_0=1,theta_0=1. Define formal kernels

\[
B_{C,n}=1+\sum_{i\in C}\theta_i^n\phi_i\otimes\phi_i
\tag{15}
\]

and let L_C be their ordered six-edge density. The centered-diagram argument
used in (6) gives F=1+sum_C(L_C-1). The kernels in (15) are not asserted
nonnegative, and need not possess admissible roots.

For a two-dimensional block with eigenfunctions x,y and eigenvalues
1>=p>=q>0, put a=Ex^3,b=Ex^2y,c=Exy^2,d=Ey^3. Every outside positive
mode z has E x^2 z=E xy z=E y^2 z=0 by cubic orthogonality. Therefore,
for every positive integer v, the full actual kernel supplies exactly

\[
\begin{aligned}
D_v&=1+p^v ac+q^v bd
   =\mathbb E_{s,t}K_v(s,t)x(s)^2y(t)^2\ge0,\\
W_v&=1-p^v(b^2-ac)-q^v(c^2-bd)\\
   &=\tfrac12\mathbb E_{s,t}K_v(s,t)
          [x(s)y(t)-y(s)x(t)]^2\ge0.
\end{aligned}
\tag{16}
\]

Zero eigenmodes contribute nothing because v>0. These are inequalities
from the full actual operator, not from a signed compression.

The complete restricted contraction is

\[
L_C=\sum_{i,j,s,t\in\{0\}\cup C}
\theta_i^k\theta_j^u\theta_s^r\theta_t^l
\left(\sum_v\theta_v^Jm_{ijv}m_{stv}\right)
\left(\sum_v\theta_v^um_{isv}m_{jtv}\right).
\tag{17}
\]

Every positive inner index outside C vanishes by cubic orthogonality or
orthonormality; both inner sums may therefore be taken over {0} union C.
Equation (17) is thus exactly the polynomial of the
[two-mode ordered proof](rank-two-ordered-density.md), without assuming an
admissible compressed operator. Its complete table, displayed in the
[spectral density proof](non-mixing-spectral-density.md), has only
two potentially signed channels. The other centered entries are products
of nonnegative sums of squares and D_J,D_u; entries with a constant outer
index are nonnegative cubic squares.

Inside the residual strip J-l<u<r+l, the retained two-mode calculations use
only that polynomial, 0<q<=p<=1, D_J,D_u>=0 and the positive-integer wedge
inequalities W_v>=0. Equations (16)--(17) supply precisely these premises.
The distinct triangle entries (0,0,x,x) and (x,x,0,0) give

\[
C_{bcd}=p^{u+r+l},\qquad C_{abd}=p^{k+2u}.
\tag{18}
\]

The joint-wedge loss is at most C_abd. The negative-Y branch is paid by its
positive companion or by at most C_abd/2, as shown in the
[general compensation proof](rank-two-general-compensation.md).
For negative X and u>=l, the
[selected-power calculation](rank-two-power-selected-compensation.md) uses
v=ceil((k+r+|J-u|)/2) and spends at most C_bcd/2. Here the strip forces
r<=2u-2, so its required domain holds. For negative X and u<l, the final
ordered calculation uses v=ceil((3r+2h-u)/2) and spends less than C_abd.
Both selected powers are strictly positive. Equal eigenvalues, equal
filters and zero moments remove the negative channel or are included in
the retained sign cases. Consequently the unchanged polynomial estimates
give

\[
L_C\ge1+\tfrac12p^{u+r+l}
\tag{19}
\]

throughout the strip. Each block spends only its own entries (18); the
constant density term is counted once in the global decomposition.

A one-dimensional block is covered directly: its four triangle and three
four-cycle coefficients are one, its six diamond coefficients are
(E phi^3)^2, and its full-K4 coefficient is (E phi^3)^4. All are
nonnegative. For a flat block of any dimension, the proof (7)--(10)
localizes with W=K_J: outside positive modes in the weighted q_i^2 term
give vanishing mixed cubic products, so its possibly signed local weight
can again be replaced by the full actual one. Hence L_C>=1 in both cases.

This proves F>=1 inside the strip. Outside it, the established
[whole-host Markov Jensen theorem](markov-jensen-compensation.md) applies
directly when J>=u+l or u>=r+l. No compressed root is needed in this step.
Additional unit modes stay in (14); there is no condition on cubic moments
involving zero eigenmodes. Only strictly positive eigenvalues are divided
by in the local payment.

## Relation to general compensation

Without (2), mixed diamonds have nonnegative cubic-square expansions, but
the full K4 also contains mixed contractions of four cubic moments. Their
sign is not fixed by those individual square expansions. Condition (2)
removes these interactions, while (10) pays the possibly signed pure-sector
contraction with the original nonnegative kernel.

The unrestricted ordered theorem therefore still requires a payment of
the interacting-block remainder. The results above are analytical conditional
theorems, not Lean-validated endpoints or literature-wide novelty claims.
They do not replace the original law, discard stationary modes, assume
positivity of a spectral compression, or use numerical agreement as proof.
