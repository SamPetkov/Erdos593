# Spectral classes with a paid tetrahedral density

Two structural conditions pay the full six-edge density without a small-kernel or mixing assumption. A flat positive nonconstant spectrum pays every positive edge labeling. With at most two active nonconstant modes, an equal opposite pair of edge lengths suffices. The arbitrary-spectrum, unequal-length theorem remains open.

## Original law and statement

Let X be finite and nonempty, with a strictly positive probability law mu. Let A be an entrywise nonnegative, self-adjoint, positive-semidefinite Markov operator on L2(mu). Write Pi for projection onto constants and K_s for the relative kernel of A^s. All expectations and compositions below use mu.

This includes the original problem A=T^2, where T is an actual symmetric, entrywise nonnegative relative Markov root. The statements also apply directly to A; no nonnegative within-component square root is required.

For six positive integers alpha, beta, gamma, delta, J, U, define

\[
F=E_{\mu^4}K_\alpha(a,b)K_J(a,c)K_\beta(a,d)
K_\gamma(b,c)K_U(b,d)K_\delta(c,d).
\tag{1}
\]

Then F>=1 in either of the following cases:

1. Every positive eigenvalue of A on the orthogonal complement of constants equals one number rho. Zero eigenvalues are permitted; the number of active modes is unrestricted.
2. rank(A-Pi)<=2 and some opposite pair of edge lengths in (1) agrees.

In either class, equality holds exactly when A=Pi. For the original self-adjoint root this is equivalent to T=Pi. Unit modes, reducibility, periodic roots, negative eigenvalues of T, kernel zeros, and arbitrary positive masses are included.

An active mode means an eigenfunction orthogonal to constants with a positive eigenvalue of A. Additional stationary eigenfunctions count as active modes; they are not discarded.

For the retained ordered placement

\[
(\alpha,\beta,\gamma,\delta,J,U)=(k,u,r,l,r+h,u),
\]

the equal-opposite-pair alternatives are k=l, r+h=u, or r=u. The first may be restrictive under k>=u and r>=l; the latter two include tuples in the previously unpaid exponent strip. These are structural sufficient families, not unrestricted closure or a novelty claim.

## Flat spectrum payment

Take a complete real orthonormal eigenbasis phi_0=1, with theta_0=1. If no active mode exists, A=Pi and F=1. Otherwise let P be the orthogonal projection onto the active nonconstant subspace. Flatness gives

\[
A^s=\Pi+\rho^sP\qquad(s\ge1),\quad 0<\rho\le1.
\tag{2}
\]

Expand only the b--d edge of (1). Its constant term is

\[
D=E_{a,c}K_J(a,c)K_{\alpha+\gamma}(a,c)
K_{\beta+\delta}(a,c)\ge1.
\tag{3}
\]

Indeed, with m_ist=E phi_i phi_s phi_t,

\[
D=\sum_{i,s,t\ge0}\theta_i^J\theta_s^{\alpha+\gamma}
\theta_t^{\beta+\delta}m_{ist}^2,
\]

and its all-constant term is one. All powers here are positive.

For an active i, put

\[
q_i(a,c)=(P D_{\phi_i}P)(a,c),\qquad
v_i=(A^\alpha D_{\phi_i}A^\gamma)(a,c),\quad
z_i=(A^\beta D_{\phi_i}A^\delta)(a,c).
\]

Here D_phi denotes multiplication. Orthogonality to constants and (2) give the exact decompositions

\[
v_i=\rho^\alpha\phi_i(a)+\rho^\gamma\phi_i(c)
+\rho^{\alpha+\gamma}q_i(a,c),
\]
\[
z_i=\rho^\beta\phi_i(a)+\rho^\delta\phi_i(c)
+\rho^{\beta+\delta}q_i(a,c).
\tag{4}
\]

Integrating b and d in the original expression gives

\[
F-D=\rho^U\sum_{i\text{ active}}E_{a,c}K_J(a,c)v_i(a,c)z_i(a,c).
\tag{5}
\]

Every one of the nine terms in each product (4) is paid. The two same-coordinate integrals are one by the Markov marginals; the two different-coordinate integrals equal rho^J. Both axis-to-q integrals are

\[
E K_J(a,c)\phi_i(a)q_i(a,c)
=E K_J(a,c)\phi_i(c)q_i(a,c)
=\rho^J\sum_{s,t\text{ active}}m_{ist}^2\ge0.
\tag{6}
\]

To check (6), integrate the c-coordinate in K_J(a,c)P(z,c), obtaining rho^J P(a,z), then expand P(a,z)^2. This gives a square of each triple moment, not a sign assumption on that moment. Finally E K_J q_i^2>=0 because K_J is entrywise nonnegative. All prefactors in (4)--(5) are positive. Thus F>=D>=1, without an ordering assumption or negative powers of A.

If an active mode exists, (3) contains the positive pair term theta_i^(J+beta+delta), so F>1. This also handles rho=1. Inactive zero modes vanish from the expanded b--d edge because U>0.

## Two active modes and matching opposite lengths

Expand the four outer edges ab, ad, bc, cd. On the complete active index set, including 0, put

\[
Q_J[(i,j),(s,t)]=\sum_v\theta_v^Jm_{ijv}m_{stv},
\]
\[
W_U[(i,j),(s,t)]=\sum_v\theta_v^U m_{isv}m_{jtv},
\quad H=Q_J\circ W_U.
\tag{7}
\]

Direct integration yields

\[
F=\sum_{i,j,s,t}\theta_i^\alpha\theta_j^\beta
\theta_s^\gamma\theta_t^\delta H_{ij,st}.
\tag{8}
\]

Q_J is a Gram matrix. W_U is the matrix of multiplication by the actual nonnegative K_U on L2(mu^2), so W_U is positive semidefinite. Their entrywise product H is positive semidefinite. This alone does not sign the unequal-vector contraction (8); the entrywise argument below is essential.

If any one of i,j,s,t is zero, the H entry is nonnegative. For example,

\[
H_{0j,st}=\theta_j^J\theta_s^U m_{jst}^2,\qquad
H_{i0,st}=\theta_i^J\theta_t^U m_{ist}^2.
\tag{9}
\]

The other two zero positions follow by symmetry. Every inactive index has zero contribution in (8), since the four outer exponents are positive; inactive indices in (7) also vanish because J,U>0. Products of active eigenfunctions need not stay in their span.

For two active modes x,y, with eigenvalues p,q>0, define

\[
\mathfrak a=Ex^3,\quad\mathfrak b=Ex^2y,\quad
\mathfrak c=Exy^2,\quad\mathfrak d=Ey^3,
\]
\[
\begin{aligned}
A_v&=1+p^v\mathfrak a^2+q^v\mathfrak b^2,&
Z_v&=1+p^v\mathfrak c^2+q^v\mathfrak d^2,\\
D_v&=1+p^v\mathfrak a\mathfrak c+q^v\mathfrak b\mathfrak d,&
E_v&=p^v\mathfrak b^2+q^v\mathfrak c^2,\\
X_v&=p^v\mathfrak a+q^v\mathfrak c,&
Y_v&=p^v\mathfrak b+q^v\mathfrak d.
\end{aligned}
\]

Importantly, D_v=E K_v(a,c)x(a)^2 y(c)^2>=0 uses the actual nonnegative kernel. With \(B=\mathfrak b^2\) and \(C=\mathfrak c^2\), the complete centered block of H, in order 11,12,21,22, is

\[
\begin{pmatrix}
A_JA_U&BX_JX_U&BX_JX_U&D_JE_U\\
BX_JX_U&E_JD_U&E_JE_U&CY_JY_U\\
BX_JX_U&E_JE_U&E_JD_U&CY_JY_U\\
D_JE_U&CY_JY_U&CY_JY_U&Z_JZ_U
\end{pmatrix}.
\tag{10}
\]

Only X_JX_U and Y_JY_U can have a negative sign. When J=U, these are squares. Every H entry is then nonnegative; the all-zero entry in (8) contributes exactly one. Any active i contributes the additional positive term theta_i^(J+beta+delta), proving strictness. Rank one has no mixed centered entry, and rank zero is the constant case.

Relabeling the four vertices sends any chosen opposite pair to ac,bd, giving the stated three alternatives. Equal active eigenvalues also make the two filter products squares times p^(J+U), consistent with the stronger flat-spectrum proof. No three-state associativity identity or constant leverage is assumed.

## Why the matching certificate does not extend by entrywise positivity

For every unequal positive J,U, an actual strictly positive rank-two root can have a negative H entry. This is a limitation of the certificate, not a counterexample to F>=1.

Use mu=(1/2,1/4,1/4), v=(1,-1,-1), w=(0,sqrt(2),-sqrt(2)). Choose R strictly between 4^J and 4^U, and set

\[
c^2=\frac{R}{3(R-1)},\qquad s^2=\frac{2R-3}{3(R-1)},
\quad x=cv+sw,\quad y=-sv+cw.
\]

The actual root T=1+(x tensor x)/4+(y tensor y)/8 is symmetric and Markov. Its pointwise leverage is x^2+y^2=v^2+w^2<=3; Cauchy--Schwarz bounds the absolute perturbation by 3/4, so T>=1/4. The active eigenvalues of A are p=1/16, q=1/64.

The moments satisfy

\[
\mathfrak b=-\frac{s}{R-1},\quad
\mathfrak d=\frac{Rs}{R-1},\quad
\mathfrak c=\frac{c(R-2)}{R-1}.
\]

Consequently

\[
H_{22,12}=\mathfrak c^2\frac{s^2q^{J+U}}{(R-1)^2}
(R-4^J)(R-4^U)<0.
\tag{11}
\]

At J=4,U=3,R=128 this is -111573/(2^20 127^6). Those lengths occur in the retained residual tuple k=r=u=3,l=2,h=1, but this host is already covered by its minimum mass and by relabeling the equal r,u opposite pair. Actual-root covariance and wedge constraints all hold, yet do not eliminate (11) in this particular pair matrix. Positive diagonal and constant-pair budgets must therefore be kept when no matching opposite pair is available.

## Exact checks and remaining scope

The accompanying fraction-only checker compares (8) with direct original-law summation on a nonuniform rank-two root, checks all H entries for matched filters, and checks an actual negative entry for unequal filters. Splitting a state tests an inactive zero mode. A separate rank-three flat-spectrum host has min(mu)=1/100 and max(T)=901/10, outside the earlier minimum-mass and kernel-cap guards; its previously stated sufficient spectral-mixing guard also fails. These fixed checks are algebraic diagnostics, not an enumeration or proof by numerical agreement.

Neither class pays a general mixed-rate active spectrum with unequal opposite lengths. In the retained flag decomposition the still-missing comparison is the collective payment of its doubly centered term by the deleted-edge and explicitly nonnegative axis surplus. No generic PSD bilinear sign, universal per-mode payment, unrestricted conclusion, Lean validation, or journal-level novelty is inferred.
