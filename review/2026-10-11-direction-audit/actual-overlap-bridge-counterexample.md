# An actual bridge-decoding obstruction to universal overlap

## Claim and scope

There is a finite strictly positive original probability law and an actual symmetric entrywise nonnegative relative Markov root \(T\) for which the processed overlap \(W_u\) is below one with \(u=1\), \(h=2\) and \(r=l\) sufficiently large. This is an analytical existential counterexample family, not a numerical value at a specified exponent. It refutes universal \(W_u\ge1\), **not** the unrestricted density \(F(k)\ge1\). Its tuples satisfy the already covered region \(u+l\le r+h\), so it supplies no counterexample in the unpaid strip and no counterexample to the maximum certificate there.

All products use the original law. Set \(A=T^2\), \(K_j=A^j\), and use the earlier definitions

\[
q_r(e,c,d)=\mathbb E_aT^u(e,a)K_r(a,c)K_u(a,d),\quad
H_r(c,x,d)=\mathbb E_e\sqrt{q_r(e,c,d)q_r(e,x,d)},
\quad W_r=\mathbb E K_h(c,x)K_r(c,d)H_r^2.
\]

The second external exponent is \(l=r\) throughout this note. Thus this does not contradict a fixed-\(l\) output-tail result.

## The finite host and its spectrum

Take \(q=257\) and a nondegenerate alternating form on \(\mathbb F_q^4\). Its points are the one-dimensional subspaces and its lines the totally isotropic two-dimensional subspaces. The incidence graph \(G\) has
\(n=2(q+1)(q^2+1)=34,081,800\) vertices and degree \(D=q+1=258\).
There are \((q+1)(q^2+1)\) points; each lies on \(q+1\) isotropic lines, and each line has \(q+1\) points, giving the same number of lines. The first line count follows from the two-dimensional symplectic quotient \(p^\perp/p\).

The graph has no four-cycle because two points determine at most one line. A six-cycle would give three pairwise orthogonal independent vectors, a three-dimensional totally isotropic space, impossible in this symplectic space. Thus a nonbacktracking path of length three has endpoint distance three and is the unique such path. The geometry is connected: an off-line point has exactly one collinear point on that line, since \(p^\perp\) meets the isotropic line in dimension one. A containment of that line in \(p^\perp\) would again create a three-dimensional isotropic space.

For a self-contained spectral calculation, the point collinearity graph has degree \(q(q+1)\), common-neighbour counts \(q-1\) for adjacent points and \(q+1\) for nonadjacent points. For adjacent points, the common points lie on their common isotropic line. For a nonadjacent pair, their perpendicular hyperplanes meet in dimension two and give \(q+1\) common projective points. If \(B\) is the point adjacency matrix,

\[
B^2=(q^2-1)I-2B+(q+1)\mathbf J.
\]

Consequently its nonconstant eigenvalues are \(q-1\) and \(-q-1\). For the point-line incidence matrix \(N\),
\(NN^\mathsf T=(q+1)I+B\). The normalized incidence adjacency \(P\) therefore has spectrum

\[
1,\quad -1,\quad +c,\quad -c,\quad 0,
\qquad c=\frac{\sqrt{2q}}{q+1}.
\]

This calculation also verifies the usual generalized-quadrangle spectrum directly. The standard geometric construction and spectral facts can be compared with [Bamberg, Bishnoi and Royle, *On regular induced subgraphs of generalized polygons*](https://arxiv.org/abs/1708.01095) and the author-hosted [Brouwer–Haemers, *Spectra of Graphs*, Section 9.6](https://aeb.win.tue.nl/2WF02/spectra.pdf). These sources concern the classical graph geometry, not the overlap claim. The authors and title were checked against the primary arXiv record.

Let \(\mu\) be uniform on the vertices. Define the stochastic transition matrix

\[
\mathsf T=aI+bP,\qquad
a=\frac{1-c}{3-c},\quad b=\frac2{3-c},\quad a+b=1.
\]

The relative kernel is \(T(x,y)=n\mathsf T_{xy}\), not the stochastic matrix itself. It is symmetric, nonnegative and Markov under the original \(\mu\). It is irreducible and has a positive diagonal. The largest nonconstant eigenvalue of \(A\) is

\[
\rho=\left(\frac{1+c}{3-c}\right)^2\in(0,1).
\]

Both the \(+c\) eigenspace of \(P\) and its \(-1\) eigenspace have squared-root eigenvalue \(\rho\). All other nonconstant eigenvalues of \(A\) are smaller. Write \(d>0\) for this top eigenspace dimension; no omission of the negative root mode is permitted.

## The actual conditional trace and decoding credit

Choose a real orthonormal \(A\)-eigenbasis \(\phi_i\), and let \(I\) index its top eigenspace. For \(u=1\), put

\[
m_{ed}=T^3(e,d),\qquad
b_i(e,d)=\mathbb E_aT(e,a)K_1(a,d)\phi_i(a),
\qquad
L_\rho=\sum_{i\in I}\mathbb E_{e,d}\frac{b_i(e,d)^2}{m_{ed}}.
\]

Zero-\(m\) summands are assigned zero: all the nonnegative original summands in that row vanish, so \(b_i=0\) there. The joint law of \((E,A,D)\) is exactly
\(\mu(e)\mu(a)\mu(d)T(e,a)K_1(a,d)\), with \(A\sim\mu\).
Thus \(b_i/m=\mathbb E[\phi_i(A)\mid E,D]\), and the \((E,D)\) marginal is \(\mu(e)\mu(d)m_{ed}\). This is a conditional identity under the original host law, not a substituted arbitrary channel.

Generate this law by three stochastic steps \(E-A-B-D\), where the first is reversed by reversibility. The event \(\operatorname{dist}_G(E,D)=3\) forces three moving, nonbacktracking steps, and reveals \(A\) uniquely. Conversely every three-moving-step nonbacktracking walk has this event. Its probability conditional on any given \(A\) is

\[
p=b^3\left(1-\frac1D\right)^2.
\]

The first move has probability \(b\), and each later moving neighbour must avoid the previous vertex, contributing \(b(1-1/D)\) twice. On this observable event the conditional mean is exactly \(\phi_i(A)\). Since the event probability is constant in \(A\) and \(\mathbb E\phi_i^2=1\),

\[
L_\rho\ge dp.
\]

This is a lower bound on the actual collective trace, including all top modes.

## Leading overlap term, including zero rows

The following finite-host asymptotic holds for every fixed mixing nonconstant actual root with \(0<\rho<1\), fixed \(u,h\), and \(l=r\). If \(A=\Pi\), self-adjointness implies \(T=\Pi\) and \(W_r=1\); this separately includes the one-state case, with no use of \(o(\rho^{2r})\) at zero. In the nonconstant case define \(b_i(e,d)=\mathbb E_aT^u(e,a)K_u(a,d)\phi_i(a)\), \(m=T^{3u}\), and \(L_\rho\) as above. Then

\[
W_r-1=\frac{\rho^{2r}}2
\left[(1+\rho^h)d(2\rho^u+\rho^{2u})-(1-\rho^h)L_\rho\right]
+o(\rho^{2r}).
\tag{1}
\]

Here is the needed Taylor justification. Set \(f_r=K_{r+u}\), and write
\(q_r(e,c,d)=m_{ed}+\sum_{i>0}\theta_i^r\phi_i(c)b_i(e,d)\).
For positive \(m\), the relative deviation is uniformly \(O(\rho^r)\), because
\(|q_r-m|\le\sup_{a,c}|K_r(a,c)-1|m\). Zero rows are identically zero and never divided by. Finiteness therefore allows the square-root Taylor expansion uniformly on every positive row.

Writing \(v_c=(q_r(e,c,d)-m)/m\), the exact defect \(U_r=f_r(c,d)f_r(x,d)-H_r^2\) has second-order term

\[
\frac14\left[\mathbb E_e m(v_c-v_x)^2
-(f_r(c,d)-f_r(x,d))^2\right]+O(\rho^{3r}).
\]

Every lower nonconstant eigenvalue contributes \(o(\rho^{2r})\). Integrating the top modes under the original \(K_h(c,x)\) uses
\(\mathbb E_{c,x}K_h(c,x)(\phi_i(c)-\phi_i(x))^2=2(1-\rho^h)\).
The other external factor \(K_r(c,d)=1+O(\rho^r)\) changes this leading term only by \(O(\rho^{3r})\). Consequently the weighted loss is

\[
L_r=\frac{\rho^{2r}}2(1-\rho^h)(L_\rho-d\rho^{2u})+o(\rho^{2r}).
\]

The exact positive surplus is
\(D_r-1=\sigma(2r+2u+h)+\sigma(2r+u)+\sigma(2r+u+h)+M(r,r+u,r+u+h)\).
Its leading coefficient is \(d(\rho^{2u+h}+\rho^u+\rho^{u+h})\); the nonconstant cubic term is \(O(\rho^{3r})\). Subtracting the loss from this surplus proves (1). The conditional-variance subtraction \(d\rho^{2u}\) has been retained, rather than dropped.

## Exact separation and conclusion

All comparisons can be made rationally:

\[
\frac{87}{1000}<c<\frac{88}{1000},\qquad
b>\frac{1373}{2000},\qquad
\left(\frac{257}{258}\right)^2>\frac{99}{100},\qquad
p>\frac8{25},\qquad \rho<\frac7{50}.
\]

The first bounds follow by squaring against \(c^2=514/66564\); the others follow by cross multiplication. With \(u=1,h=2\),

\[
(1+\rho^2)(2\rho+\rho^2)
<\frac{1909201}{6250000},\qquad
(1-\rho^2)p>\frac{1960800}{6250000}.
\]

Therefore the bracket in (1) is at most
\(-d\,51599/6250000<0\). For this fixed actual finite host, (1) proves \(W_r<1\) for every sufficiently large integer \(r=l\). A finite exponent exists by the uniform finite-host remainder; no numerical approximation is being treated as a proof and no explicit exponent has yet been supplied.

The original density goal remains open. This obstruction requires retaining more of its actual positive collective credit, or restricting an overlap certificate to a correctly justified region. It does not justify weakening the original theorem or removing difficult hosts.

## Verification scope

This analytical proof passed a complete root rederivation and an actual separate helper's complete final-source audit, including the constant-root correction. The exact rational comparisons were also checked using fractions. No explicit failing exponent or computed value of the overlap is claimed. The result has not been formalized in Lean or subjected to a full external audit. It leaves the unrestricted density theorem open.
