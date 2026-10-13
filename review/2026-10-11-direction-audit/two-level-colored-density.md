# Tetrahedral density for two positive spectral levels

A nonsingular positive-semidefinite nonnegative Markov operator with at most
two distinct positive centered eigenvalues satisfies the tetrahedral density
inequality for every six
independently chosen positive edge lengths. The multiplicities are arbitrary.
The proof expands each power into the identity and a kernel built from one
common orthogonal projection, then pays all identity contractions under the
original probability law. It does not reduce an arbitrary Markov operator to
this spectral class.

## Theorem and conventions

Let X be finite and nonempty, and let mu(x)>0 with sum_x mu(x)=1. All kernels
are relative to this original law:

\[
(Bf)(x)=\sum_y\mu(y)B(x,y)f(y),\qquad
\Pi(x,y)=1,\qquad I(x,y)=\frac{\mathbf1_{x=y}}{\mu(y)}.
\tag{1}
\]

Let A be self-adjoint, positive semidefinite, entrywise nonnegative and Markov.
Suppose

\[
A=\Pi+pP+qQ,\qquad P+Q=I-\Pi,\qquad 0<q\le p\le1,
\tag{2}
\]

where P and Q are mutually orthogonal projections orthogonal to constants.
Either projection may have rank zero; their other multiplicities are
unrestricted. In particular, (2) excludes centered zero modes.

For any six integers n_e>=1, one for each edge e=vw of K4, put

\[
F_A(\mathbf n)=\mathbb E_{\mu^4}
\prod_{e=vw\in E(K_4)} A^{n_e}(x_v,x_w).
\tag{3}
\]

Then, writing N=sum_e n_e,

\[
F_A(\mathbf n)\ge
1+q^N\left(\sum_x\mu(x)^{-2}-1\right)\ge1.
\tag{4}
\]

For X with more than one point the final inequality is strict. The original
ordered target is obtained by choosing lengths k,r+h,u,r,u,l on
ab,ac,ad,bc,bd,cd. If A=T^2 for an actual symmetric nonnegative relative
Markov root, negative eigenvalues of T and periodic roots require no extra
argument: the proof uses the actual A, not a replacement or truncation.

## A common projection with different edge coefficients

We first prove a statement whose edge coefficients need not be powers of one
number. Let P be an orthogonal projection with P1=0. Suppose each of the six
kernels R_e=1+t_e P is entrywise nonnegative and t_e>=0. Then

\[
\mathbb E_{\mu^4}\prod_{e=vw}R_e(x_v,x_w)\ge1.
\tag{5}
\]

Write the coefficients on ab,bc,ad,cd,ac,bd respectively as
alpha,beta,delta,gamma,eta,zeta. Choose a real orthonormal basis phi_i of
ran(P), and define

\[
m_{ijk}=\mathbb E_\mu\phi_i\phi_j\phi_k,
\qquad q_i(a,c)=(P D_{\phi_i}P)(a,c)
=\sum_{j,k}m_{ijk}\phi_j(a)\phi_k(c).
\tag{6}
\]

Here D_phi is multiplication; i,j,k in this section range only over ran(P).
No closure of this subspace under multiplication is assumed. Put

\[
r_P=\operatorname{Tr}P,\qquad
M_3=\mathbb E_{a,c}P(a,c)^3=\sum_{i,j,k}m_{ijk}^2\ge0.
\tag{7}
\]

Expand the bd edge. Integrating b and d in its constant part, using P^2=P,
gives

\[
D=\mathbb E_{a,c}(1+\eta P_{ac})
(1+\alpha\beta P_{ac})(1+\delta\gamma P_{ac})
\]
\[
=1+(\eta\alpha\beta+\eta\delta\gamma+
\alpha\beta\delta\gamma)r_P+
\eta\alpha\beta\delta\gamma M_3\ge1.
\tag{8}
\]

We used E P=0 and E P^2=r_P. The nonconstant bd part is
zeta sum_i E_{a,c}(1+eta P_ac)v_i w_i, where

\[
v_i=\alpha\phi_i(a)+\beta\phi_i(c)+\alpha\beta q_i(a,c),
\quad
w_i=\delta\phi_i(a)+\gamma\phi_i(c)+\delta\gamma q_i(a,c).
\tag{9}
\]

Let M_i=sum_{j,k}m_{ijk}^2 and
N_i=E_{a,c}(1+eta P_ac)q_i(a,c)^2>=0. The nine cross terms are determined by

\[
\mathbb E R_{ac}\phi_i(a)^2=
\mathbb E R_{ac}\phi_i(c)^2=1,\qquad
\mathbb E R_{ac}\phi_i(a)\phi_i(c)=\eta,
\]
\[
\mathbb E R_{ac}\phi_i(a)q_i=
\mathbb E R_{ac}\phi_i(c)q_i=\eta M_i.
\tag{10}
\]

For the last identities, insert (6) and the projection expansion of R_ac.
Orthonormality in the coordinate not occupied by phi_i leaves
eta sum_{j,k}m_{ijk}^2. The constant part vanishes because P1=0.
Consequently the full density equals

\[
D+\zeta\sum_i\bigl[
\alpha\delta+\beta\gamma+\eta(\alpha\gamma+\beta\delta)
\]
\[
\quad+\eta M_i(\alpha\delta\gamma+\beta\delta\gamma+
\alpha\beta\delta+\alpha\beta\gamma)
+\alpha\beta\delta\gamma N_i\bigr]\ge1.
\tag{11}
\]

All coefficients are nonnegative. The proof uses squares of third moments,
not a sign for an individual third moment or a generic unequal PSD cross form.

## Decomposing the powers with nonnegative coefficients

First assume q<1. Define

\[
d=\frac{p-q}{1-q}\in[0,1],\qquad R=1+dP.
\]

The spectral decomposition (2) gives A=qI+(1-q)R. Off the diagonal,
R(x,y)=A(x,y)/(1-q)>=0; on the diagonal,
R(x,x)=1+dP(x,x)>=1. Thus R is a nonnegative Markov kernel.

For every n>=1,

\[
A^n=q^n I+(1-q^n)R_n,\qquad R_n=1+d_nP,
\qquad d_n=\frac{p^n-q^n}{1-q^n}.
\tag{12}
\]

The coefficients satisfy 0<=d_n<=d. Indeed p=(1-d)q+d, and convexity of t^n
on [0,1] gives p^n<=(1-d)q^n+d. If d>0, R_n is therefore the convex
combination (1-d_n/d)1+(d_n/d)R. If d=0, R_n=1 directly. Each R_n is
nonnegative and Markov, has R_n(x,x)>=1, and is built from the same P.
The numbers d_n are not assumed to be powers of a common eigenvalue.

Expanding (12) on the six edges produces 64 terms. The scalar coefficient
of the term with identity edges S is

\[
\lambda_S=\prod_{e\in S}q^{n_e}
\prod_{e\notin S}(1-q^{n_e})\ge0,
\qquad \sum_{S\subseteq E(K_4)}\lambda_S=1.
\tag{13}
\]

We now show that each integrated term is at least one before summing it.

## Identity contractions and the original measure

Within a connected component of the selected identity graph, let v be its
number of vertices and e its selected edges. Identity kernels force all v
variables to one value x. Their exact contribution from the original law is

\[
\mu(x)^v\mu(x)^{-e}=
\mu(x)\mu(x)^{-(e-v+1)}.
\tag{14}
\]

Its cycle rank e-v+1 is nonnegative, including the value zero for an isolated
vertex. The extra factor is at least one since 0<mu(x)<=1. All unselected
edge factors are still nonnegative. We may discard these cycle factors
pointwise. An unselected edge whose ends lie in one identity component
becomes a loop R_n(x,x)>=1 and may also be discarded pointwise.

After these two lower bounds, quotient vertices have independent copies of
the original law mu. No tilted law or missing block-mass correction is used.
Only then do we expand kernels involving the possibly signed entries of P.

The component sizes exhaust the following quotient graphs:

| Identity components | Remaining non-loop graph |
| --- | --- |
| Four singletons | The six-edge K4 of (5) |
| Sizes 2,1,1 | A triangle with edge multiplicities 2,2,1 |
| Sizes 3,1 | Three parallel edges |
| Sizes 2,2 | Four parallel edges |
| One component | No edges |

The first case follows from (5); the last has density one. We prove the
remaining cases next. This covers selected cycles as well as forests.

### Parallel edges

For every j>=1 the projection expansion gives

\[
\mathbb E_{x,y}P(x,y)^j=
\sum_{i_1,\ldots,i_j}
\left(\mathbb E_\mu\phi_{i_1}\cdots\phi_{i_j}\right)^2\ge0.
\tag{15}
\]

Thus any product of parallel factors 1+t_e P, t_e>=0, has integrated
density at least one. Equation (15) includes the vanishing j=1 moment;
it does not assert pointwise positivity of odd powers.

### The triangle with multiplicities 2,2,1

Write the products on ab and ac as

\[
B=1+\alpha P+\beta P^{\circ2},\qquad
C=1+\gamma P+\eta P^{\circ2},
\tag{16}
\]

where their four coefficients are nonnegative. The edge bc has kernel
1+zeta P, zeta>=0. For fixed a let p_a=P(a,cdot) and D(a)=P(a,a).
Projection identities give Pp_a=p_a, ||p_a||_mu^2=D(a), and P1=0.

The constant bc term is E_a(1+beta D(a))(1+eta D(a)). The other term is
zeta E_a <B(a,cdot),P C(a,cdot)>_mu. Hence the triangle density is exactly

\[
\mathbb E_a(1+\beta D(a))(1+\eta D(a))
\]
\[
\quad+\zeta\left[
\alpha\gamma\operatorname{Tr}P+
(\alpha\eta+\beta\gamma)\mathbb E_{a,b}P(a,b)^3+
\beta\eta\mathbb E_a\|P(p_a^2)\|_\mu^2
\right]\ge1.
\tag{17}
\]

The first term is at least one, D(a)>=0, and the averaged cube is
nonnegative by (7). For the last term, self-adjoint idempotence gives
<p_a^2,Pp_a^2>=||Pp_a^2||^2. No pointwise sign for <p_a,p_a^2> is required.

This completes every quotient case, so (13) proves F_A>=1. For S consisting
of all six edges the exact term, without discarding its cycles, is
F_I=sum_x mu(x)^(-2). Its coefficient is q^N. Retaining that term instead
of merely bounding it by one proves the sharper estimate (4).

## Boundaries and an extension with zero modes

If q=1 then p=1 and A=I. Direct original-law summation gives
F_A=sum_x mu(x)^(-2), so (4) still holds. If p=q<1, then d_n=0 and the same
proof applies. A singleton space gives equality. Extra unit eigenvalues,
reducibility and zero entries cause no change in the argument.

The exclusion of centered zero modes in (2) is substantive. If instead
A=Pi+pP+qQ with E=Pi+P+Q a proper range projection and q<1, the decomposition is

\[
A^n=q^nE+(1-q^n)(1+d_nP),
\tag{18}
\]

not an identity mixture. E need not be entrywise nonnegative. For example,
on uniform four-point mu, take the orthonormal centered modes

\[
x=(1,1,-1,-1),\quad y=(1,-1,1,-1),\quad z=(1,-1,-1,1).
\]

The actual root T=1+(x tensor x)/4+(y tensor y)/8 is at least 5/8.
Its A=T^2 has positive centered levels 1/16,1/64 and an inactive zero mode z.
Its range projection is E=I-z tensor z, with E(1,4)=-1. This obstructs the
nonnegative-mixture argument, not the density inequality: this root is
already covered by the independently proved rank-two theorem.

There is an extension when the range projection E in (18) is explicitly
entrywise nonnegative. Such a self-adjoint Markov projection is conditional
expectation onto a partition. Here is a finite proof. Form the components of
its nonnegative transition graph. A fixed vector Ef=f is constant on each
component: at a component maximum, the Markov average forces the same value
on every adjacent point, hence throughout the component. Conversely,
component indicators are fixed. Since E is an orthogonal projection, it
averages over each component C using the conditional law mu/m_C, where
m_C=sum_{x in C}mu(x).

The identity EA=AE=A then makes the kernel of A constant on each pair of
components. Lumping gives a nonnegative PSD Markov operator Ahat on the
original component masses m_C. Its spectrum has no zero modes and satisfies
(2) with the same positive levels. Original-law summation gives the exact
identity, without a prefactor,

\[
F_{\mu,A}(\mathbf n)=F_{m,\widehat A}(\mathbf n)
\ge1+q^N\left(\sum_C m_C^{-2}-1\right).
\tag{19}
\]

No internal nonnegative square root is required for the lumped operator.
When q=1, also p=1 and A=E; its nonnegative range projection is already
conditional expectation, giving F=sum_C m_C^(-2) directly. No d_n or
division by 1-q is used in this boundary case, and (19) remains valid.
Entrywise nonnegativity of E is an additional verified condition, not a
consequence of the original root assumptions. Operators with one flat
positive centered level, allowing arbitrary inactive zeros, remain covered
by the earlier flat-spectrum theorem independently of this extension.

## Relation to the unrestricted target

This proves a mixed-rate class of arbitrary multiplicity without a mass
floor, mixing bound, equal opposite lengths, or ordering restriction. Its
identity contractions keep the whole nonnegative local contribution rather
than charging separate signed spectral entries to a limited axis reserve.
The independently proved compatible-block theorem can use these operators
as macro or local inputs only when the required actual roots and holding
bounds are separately verified.

The general operator may have three or more positive centered levels, or
two levels with a signed range projection. Neither case is covered by this
proof. Adding a small identity to an operator with two distinct positive
centered levels and zero modes creates a third centered level; it is not a
continuity proof of (3) for that operator. Repeated
minimum-eigenvalue peeling likewise introduces zero modes and arbitrary
edge labels, so it is not a completed induction for the ordered theorem.

The unrestricted original-law common-power inequality remains open. This
is an analytical proof, not an accepted Lean endpoint, literature-wide
novelty clearance, a full external audit, or a publication-readiness claim.
