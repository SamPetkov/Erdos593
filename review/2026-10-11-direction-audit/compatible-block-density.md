# Ordered density under compatible block substitution

The ordered common-power density inequality is preserved by the compatible block construction below. In particular, independently proved low-rank hosts can be combined into connected hosts of arbitrarily large active rank. The construction pays the local six-edge contractions together; it does not try to bound each negative spectral entry by an external reserve. It is not a representation theorem for arbitrary Markov roots.

## Density and hypotheses

For a finite nonempty space with strictly positive probability law mu, let T be a symmetric, entrywise nonnegative relative Markov kernel. Composition uses mu, so T1=1. Write K_n=T^(2n), with all powers interpreted as relative kernels. For fixed integers

\[
k\ge u\ge1,\qquad r\ge l\ge1,\qquad h\ge1,\qquad J=r+h,
\]

define

\[
F(T)=E_{\mu^4}K_k(a,b)K_J(a,c)K_u(a,d)
K_r(b,c)K_u(b,d)K_l(c,d).
\tag{1}
\]

The tuple and the placement of its six labels are fixed throughout. The unrestricted claim F(T)>=1 remains open. The theorem below assumes (1) is already proved for the macro root and each local root; these assumptions must be discharged independently when applying it.

## Proper subgraphs have density at least one

Let A be any self-adjoint PSD, entrywise nonnegative Markov operator on a finite positive probability space. Let G be a proper simple subgraph of K4. Assign a positive integer n_e to each retained edge and put A^(n_e) on that edge. Then its density, with four independently sampled vertices and unused vertices integrated out, is at least one.

To prove this, integrate leaves and isolated vertices using the Markov identity. The remaining graph on at most four vertices has minimum degree at least two, and hence is empty, a cycle, or K4 with one edge removed. The empty graph has density one. A cycle has density Tr(A^N)>=1, where N is the sum of its edge labels; the constant eigenvector contributes one and all other eigenvalues of A are nonnegative.

For K4 with one edge removed, integrate the two degree-two vertices. The three internally disjoint paths between the remaining terminals give kernels A^alpha, A^beta and A^gamma, where all three exponents are positive integers. In an orthonormal eigenbasis phi_0=1, phi_1,... with nonnegative eigenvalues theta_0=1, theta_1,..., its density is

\[
E_{\mu^2}A^\alpha(x,y)A^\beta(x,y)A^\gamma(x,y)
=\sum_{i,j,s}\theta_i^\alpha\theta_j^\beta\theta_s^\gamma
\bigl(E_\mu\phi_i\phi_j\phi_s\bigr)^2\ge1.
\tag{2}
\]

All sums here are finite. Zero and nonconstant unit modes cause no difficulty. This argument applies to every edge subset except the full six-edge K4; it does not use a putative sign for a general PSD multilinear contraction.

## Construction of the global root

Let I be a finite nonempty macro space with strictly positive probability masses m_i. For each i, let X_i be a finite nonempty space with strictly positive probability law nu_i. Set

\[
X=\coprod_{i\in I}\{i\}\times X_i,\qquad
\mu(i,x)=m_i\nu_i(x).
\]

Let Q be a symmetric, entrywise nonnegative relative Markov root on (I,m), and let L_i be such a root on (X_i,nu_i). Choose scalars satisfying

\[
0\le d_i\le m_iQ(i,i).
\tag{3}
\]

Define T by

\[
T((i,x),(j,y))=Q(i,j)\quad(i\ne j),
\]

\[
T((i,x),(i,y))=Q(i,i)+\frac{d_i}{m_i}(L_i(x,y)-1).
\tag{4}
\]

Since (3) implies Q(i,i)-d_i/m_i>=0, the diagonal-fiber expression is a nonnegative combination of 1 and L_i. Symmetry is immediate. The centered local term integrates to zero, so every row of T integrates to one. Thus (4) is an actual nonnegative Markov root on the original global law, not a formal spectral perturbation. Also d_i<=1 because m_iQ(i,i) is a holding probability.

## Even powers have a nonnegative local expansion

Let M_n=Q^(2n), with composition using m, and N_(n,i)=L_i^(2n), with composition using nu_i. The orthogonal decomposition

\[
L^2(\mu)=\mathcal C\oplus\bigoplus_i\mathcal H_i^0
\]

has fiber-constant subspace C, identified isometrically with L^2(m), and local subspaces H_i^0 consisting of functions supported in fiber i whose nu_i mean is zero. T acts as Q on C and as d_i L_i on H_i^0. Consequently

\[
K_n((i,x),(j,y))=M_n(i,j)\quad(i\ne j),
\]

\[
K_n((i,x),(i,y))
=M_n(i,i)+\frac{d_i^{2n}}{m_i}(N_{n,i}(x,y)-1)
=a_{n,i}+b_{n,i}N_{n,i}(x,y),
\tag{5}
\]

where b_(n,i)=d_i^(2n)/m_i and a_(n,i)=M_n(i,i)-b_(n,i).

Both coefficients in (5) are nonnegative. Indeed, in the genuine path expansion of Q^(2n)(i,i), retain the path that stays at i at every intermediate step. This gives

\[
M_n(i,i)\ge m_i^{2n-1}Q(i,i)^{2n}
=\frac{(m_iQ(i,i))^{2n}}{m_i}
\ge\frac{d_i^{2n}}{m_i}.
\tag{6}
\]

No fractional Markov powers or division by a kernel value occurs.

## Substitution theorem

Suppose F(L_i)>=1 for every i, for the exact tuple in (1). Then

\[
F(T)\ge F(Q).
\tag{7}
\]

In particular, if the same ordered inequality is independently known for Q, then F(T)>=1.

To prove (7), condition on the macro labels of all four sampled vertices. Each cross-fiber edge contributes a nonnegative M_n(i,j). Expand every same-fiber edge by (5). Every resulting coefficient is nonnegative. Its remaining integrand factors, over the fibers, into densities of edge-selected simple subgraphs of K4 under the corresponding nu_i.

Every selected local graph is proper unless all four vertices have macro label i and every one of the six edges selects the N term. The proper-subgraph lemma pays each proper factor by one. The only possible full local K4 is paid by the hypothesis F(L_i)>=1; its six labels remain in their original positions. Therefore each monomial is at least its coefficient.

Summing these coefficients is equivalent to replacing each local N by one. By (5), a_(n,i)+b_(n,i)=M_n(i,i). Thus, for every macro assignment, the conditional density is at least the product of the six macro kernels in (1). Averaging under m^4 proves (7). There is no reuse of a triangle reserve: the complete local density is paid once in each distinct expansion monomial.

## Connected hosts of arbitrarily large active rank

The already proved rank-at-most-two theorem supplies the inequality for a macro root and all local roots of active rank at most two. The construction may be iterated using previously proved instances. It also gives high rank without iteration: take Q=(1-t)Pi+tI on any number of macro states, with 0<t<1, and take a nonconstant two-state local root in every fiber. This Q has flat positive centered spectrum and is independently covered by the flat-spectrum theorem. Choose 0<d_i<m_iQ(i,i).

The resulting T is strictly positive whenever all chosen local roots are strictly positive. Its active rank is the macro active rank plus the sum of the active ranks of d_iL_i on their local centered subspaces. With N two-point fibers and nonzero local eigenvalues, this is (N-1)+N=2N-1. Mixed eigenvalues and nonuniform positive masses are allowed. Hence (7) is not confined to globally rank-two or disconnected hosts.

## An internal payment in the concentrated three-mode family

This application uses the same actual-root family that obstructs payment of individual negative entries solely from external axis terms. Fix 0<epsilon<=1/4. Take macro masses (epsilon,1-epsilon) and

\[
Q=1+\frac45 z\otimes z,
\quad z(1)=\sqrt{\frac{1-\epsilon}{\epsilon}},
\quad z(2)=-\sqrt{\frac{\epsilon}{1-\epsilon}}.
\]

In the first fiber take nu=(1/2,1/4,1/4), v=(1,-1,-1), w=(0,sqrt(2),-sqrt(2)), C=sqrt(128/381), S=sqrt(253/381), f=Cv+Sw and g=-Sv+Cw. The functions f,g are orthonormal and centered. Set

\[
L_1=1+\tfrac14 f\otimes f+\tfrac18 g\otimes g,
\quad d_1=\tfrac45.
\]

The pointwise leverage f^2+g^2 is at most three, so L_1>=1-3/4=1/4. The second fiber is a singleton with root one and d_2=0. Condition (3) holds because m_1Q(1,1)=4/5+epsilon/5.

Writing x=f/sqrt(epsilon), y=g/sqrt(epsilon) on the first fiber and zero on the second, (4) becomes exactly

\[
T=1+\tfrac15 x\otimes x+\tfrac1{10}y\otimes y+\tfrac45 z\otimes z.
\tag{8}
\]

The macro root has active rank one and L_1 has active rank two. Their ordered inequalities are therefore independently known, and (7) proves F(T)>=F(Q)>=1 for every ordered tuple in (1). The root in (8) is connected and strictly positive, with three distinct active eigenvalues for A=T^2. Negative pairwise contraction entries may grow like epsilon^(-2); they are paid inside the complete first-fiber density, not charged individually against the smaller external reserve. The proof here is exact for every allowed epsilon, not an asymptotic or numerical verification.

The retained macro benchmark gives an explicit credit at the same scale. Put s=16/25 and Sigma=k+J+r+l+2u. In the rank-one macro expansion, a selected graph with a degree-one vertex vanishes, while every surviving degree-three moment occurs an even number of times. All surviving terms are therefore nonnegative. The constant and the full six-edge term alone give

\[
F(T)\ge F(Q)\ge
1+s^\Sigma\frac{(1-2\epsilon)^4}{\epsilon^2(1-\epsilon)^2}.
\tag{9}
\]

Here E_m z^3=(1-2epsilon)/sqrt(epsilon(1-epsilon)). Thus the complete retained macro density, unlike the smaller external axis reserve, already contains positive credit of order epsilon^(-2) for each fixed tuple. Equation (7) preserves that credit while the full local contraction is paid collectively.

## Boundary and scope

Zero d_i, singleton fibers, a single macro state, repeated or unit eigenvalues, and reducible or periodic roots are admitted. With a single macro state, (7) still assumes the corresponding local full inequality; with singleton fibers, it still assumes the macro full inequality. Neither degenerate partition proves the unrestricted theorem circularly.

General roots need not have constant off-fiber blocks or the invariant subspaces in (5). A proof that every actual root admits a noncircular compatible reduction, or a different payment for roots outside this class, is still missing. No unrestricted density conclusion, Lean validation, or novelty claim follows from (7).

## Proof obligation audit

The audit concerns the proof supplied above, not a search for a different unrestricted proof. Its accepted primitives are finite-dimensional spectral decomposition, the Markov leaf identity, nonnegative path composition, and the stated independently proved local full inequalities.

| ID | Exact obligation | Needed by | Classification | Support and status |
| --- | --- | --- | --- | --- |
| P1 | Every positively labeled proper subgraph of K4 has density at least one for PSD nonnegative Markov A | P5 | Proved earlier in this argument | Leaf pruning, cycle trace, and the three-path square expansion (2) |
| P2 | Formula (4) defines a nonnegative symmetric Markov root on mu | P3 | Hypotheses and direct algebra | Positive laws and holding bound (3); local centered rows integrate to zero |
| P3 | Formula (5) is the actual even-power kernel | P4 and P5 | Finite orthogonal operator decomposition | Fiber-constant and local-centered invariant subspaces; original-law normalization 1/m_i |
| P4 | All coefficients in (5) are nonnegative | P5 | Proved algebraic inequality | Actual all-stay path (6) and (3) |
| P5 | Each conditional expansion term is paid by one without changing its edge labels | P6 | Proved finite factorization | P1 for proper local graphs; the explicitly assumed local full inequalities for the sole full K4 case |
| P6 | F(T)>=F(Q) | Conditional conclusion | Proved finite summation | P2-P5; replace local N by one, then average under m^4 |
| P7 | F(Q)>=1 and each F(L_i)>=1 | Application conclusion | Explicit independent hypotheses | Rank-at-most-two or flat-spectrum theorem in the examples; otherwise must be supplied |
| U1 | Every arbitrary actual root has a noncircular compatible reduction or an alternative collective payment | Unrestricted theorem | Missing | Not established by a one-block or singleton-block partition |

**Verdict.** P1-P7 prove the stated conditional substitution theorem and its independently discharged examples. U1 remains outside this proof, so the unrestricted arbitrary-host theorem is not established.
