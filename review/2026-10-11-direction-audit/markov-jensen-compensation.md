# Markov Jensen compensation for unequal path lengths

For every actual finite reversible root in the retained density problem,
collective compensation proves the target in two exponent regions. Their
union covers every allowed tuple with \(\min(u,l)=1\), and every tuple with
\(h\ge 2l-1\). The argument is analytical and uses the original probability
law throughout. The unrestricted theorem remains open in the residual strip
specified below. No Lean implementation or literature novelty is asserted.

## Definitions and target

Let \(X\) be finite and nonempty, let \(\mu_x>0\) with
\(\sum_x\mu_x=1\), and let \(T(x,y)\ge0\) be a symmetric relative Markov
kernel: \(\sum_y\mu_yT(x,y)=1\). Composition and every inner product use
\(\mu\). Write \(A=T^2\), \(K_j=A^j=T^{2j}\), and \(\Pi(x,y)=1\).
The identity kernel is \(K_0(x,y)=\mathbf1_{x=y}/\mu_y\).
Periodicity, reducibility, zero entries, zero modes, and extra unit modes
are permitted.

For integers \(k\ge u\ge1, r\ge l\ge1, h\ge1\), put
\[
F=\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
                         K_r(b,c)K_u(b,d)K_l(c,d).
\tag{1}
\]
The goal is \(F\ge1\) for all such inputs.

## A square step Markov inequality

Let \(S\) be any symmetric nonnegative Markov operator on the same finite
probability space, and \(f\ge0\) with \(\mathbb E_\mu f=1\). Then
\[
\mathbb E_\mu f\sqrt{S^2f}
 \ge\mathbb E_\mu(Sf)^{3/2}\ge1.
\tag{2}
\]
Indeed, concavity of the square root gives pointwise
\(\sqrt{S(Sf)}\ge S\sqrt{Sf}\). Multiplying by \(f\ge0\), integrating,
and using self-adjointness gives
\[
\langle f,\sqrt{S^2f}\rangle_\mu
\ge\langle f,S\sqrt{Sf}\rangle_\mu
=\langle Sf,\sqrt{Sf}\rangle_\mu.
\]
Finally \(\mathbb E Sf=1\), so convex Jensen for \(x^{3/2}\) proves (2).
This uses no strict positivity or PSD assumption on \(S\).

Consequently, for integers \(0\le z\le w\), every row satisfies
\[
\sum_y\mu_yK_z(x,y)\sqrt{K_w(x,y)}\ge1.
\tag{3}
\]
Take \(f=K_z(x,\cdot)\) and the actual Markov operator
\(S=T^{w-z}\). Symmetry and convolution give
\(Sf=T^{w+z}(x,\cdot)\) and \(S^2f=K_w(x,\cdot)\).
The exponent \(w-z\) may be odd; \(S\) remains a nonnegative Markov
operator because it is an integer power of the actual root.

## A reusable six edge theorem

Let \(s,t,v\ge1\), \(p\ge s\), \(q\ge t\), and \(w\ge s+t\) be integers.
Then
\[
D=\mathbb E_{\mu^4}K_w(a,b)K_s(a,c)K_t(b,c)
                       K_v(c,d)K_p(a,d)K_q(b,d)\ge1.
\tag{4}
\]
There is no order condition on the opposite-edge exponent \(v\).

To prove this, work on \(Y=X^2\) with its original product law
\(\nu=\mu\otimes\mu\), and set
\[
\begin{aligned}
V((a,b),c)&=K_s(a,c)K_t(b,c),\\
g(a,b)&=(V1)(a,b)=K_{s+t}(a,b),\\
\Gamma&=VK_vV^*,\\
H&=A^{p-s}\otimes A^{q-t},\qquad L(a,b)=K_w(a,b),\\
B&=H\circ\Gamma.
\end{aligned}
\tag{5}
\]
The circle is entrywise multiplication of relative kernels. Expanding the
weighted compositions and integrating the two intermediate pair coordinates
gives the exact identity
\[
D=\mathbb E_{y,z\sim\nu}L(y)B(y,z).
\tag{6}
\]
For example, the first coordinate convolution is
\(K_{p-s}K_s=K_p\), and the second is \(K_{q-t}K_t=K_q\).
Thus no measure change or new conclusion replaces (4).

The kernel \(B\) is symmetric and entrywise nonnegative. All \(K_j\) are
PSD Markov operators; \(K_j-\Pi\succeq0\), including when there are extra
unit modes. Therefore
\[
\Gamma\succeq g\otimes g,\qquad H\succeq\Pi_Y.
\]
Weighted Schur positivity and diagonal congruence imply
\[
B\succeq D_gHD_g\succeq g\otimes g,
\tag{7}
\]
where \(D_g\) multiplies by \(g\). These are two distinct PSD comparisons,
not a claim that a product of three arbitrary PSD operators has positive
trace.

Symmetry, entrywise nonnegativity, and arithmetic--geometric mean give
\[
\begin{aligned}
D&=\tfrac12\mathbb E_{y,z}B(y,z)(L(y)+L(z))\\
 &\ge\langle\sqrt L,B\sqrt L\rangle_\nu
 \ge\bigl(\mathbb E_\nu g\sqrt L\bigr)^2\ge1.
\end{aligned}
\tag{8}
\]
The final step is (3) with \(z=s+t\le w\), averaged over the first row
coordinate. All square roots are well defined even at zero. No division
by \(g\) or support restriction is needed in this proof.

## Quantitative compensation and equality

In (4), define the actual powered relative kernel
\(P=T^{w+s+t}\), and
\[
\delta=\mathbb E_{\mu^2}(\sqrt P-1)^2.
\]
The same proof gives the quantitative bound
\[
D\ge(1+\delta/2)^2.
\tag{9}
\]
Indeed, the row argument in (2) shows that
\(\mathbb E g\sqrt L\ge\mathbb E P^{3/2}\), while
\(\mathbb E P=1\). The elementary identity
\[
x^{3/2}-1-\tfrac32(x-1)
=(\sqrt x-1)^2(\sqrt x+\tfrac12)
\]
then proves \(\mathbb E P^{3/2}\ge1+\delta/2\).

Equality \(D=1\) holds if and only if \(T=\Pi\). In fact equality forces
\(\delta=0\), hence \(T^{w+s+t}=\Pi\) since every original weight is
positive. By the finite self-adjoint spectral theorem, every centered
eigenvalue of \(T\) is then zero, so \(T=\Pi\). This reasoning retains
negative eigenvalues of the root as well as additional stationary modes.
Conversely a constant root makes every positive-power edge kernel one.
The quantitative statement is a measure of departure from that constant
root in the covered regions, not a claim about arbitrary covers.

## The ordered density regions

There are two direct applications of (4) to (1).

| Distinguished edge | Short legs | Long legs | Opposite edge | Sufficient condition |
| --- | --- | --- | --- | --- |
| \(ac\), exponent \(r+h\) | \(ad=u, cd=l\), at \(d\) | \(ab=k, cb=r\), at \(b\) | \(db=u\) | \(r+h\ge u+l\) |
| \(bd\), exponent \(u\) | \(bc=r, dc=l\), at \(c\) | \(ba=k, da=u\), at \(a\) | \(ca=r+h\) | \(u\ge r+l\) |

For the first row, \(k\ge u\) and \(r\ge l\) are exactly the long-leg
conditions. For the second, \(u\ge r+l\) and \(k\ge u\) imply
\(k\ge r\) and \(u\ge l\). Hence
\[
\boxed{F\ge1\quad\text{if}\quad
u+l\le r+h\ \text{or}\ u\ge r+l.}
\tag{10}
\]
Both applications retain all other factors, including the opposite edge.
The equality characterization and (9) apply with powers
\(T^{r+h+u+l}\) and \(T^{u+r+l}\), respectively.

Because \(u\) is an integer, the two regions cover all tuples whenever
\(h\ge2l-1\). In particular, **every tuple with \(l=1\) is covered**, for
every admissible actual root and original probability law.

The still-uncovered integer strip is
\[
1\le h\le2l-2,\qquad
r+h-l+1\le u\le r+l-1,\qquad k\ge u,\quad r\ge l\ge2.
\tag{11}
\]
The same six-edge theorem gives optional further regions:
\(u\le r, k\ge2u\), using distinguished edge \(ab\) and short vertex \(d\);
and \(u\ge r+h, k\ge2r+h\), using the same edge and short vertex \(c\).
These do not exhaust (11). The existing exact reflection families and
host-dependent tail results remain available but must not be mistaken for
a uniform proof of this strip.

## The exact positive surplus and logarithmic transfer

The channel lower bound retains four individually nonnegative corrections.
More generally, on a finite positive probability space \((Y,\nu)\), let
\(H\) be a symmetric nonnegative PSD Markov kernel, and let \(\Gamma\)
be symmetric, nonnegative and PSD with \(\langle1,\Gamma1\rangle_\nu=1\).
Set \(g=\Gamma1\), \(H_0=H-\Pi_Y\), \(\Gamma_0=\Gamma-g\otimes g\),
\(B=H\circ\Gamma\), and \(f=\sqrt L\) for any \(L\ge0\). Then
\[
\begin{aligned}
\mathbb E_{\nu^2} L(y)B(y,z)
={}&(\mathbb E_\nu gf)^2
 +\tfrac12\mathbb E_{\nu^2}B(y,z)(f(y)-f(z))^2\\
 &+\langle gf,H_0(gf)\rangle_\nu
 +\langle f,\Gamma_0f\rangle_\nu
 +\langle f,(H_0\circ\Gamma_0)f\rangle_\nu.
\end{aligned}
\tag{12}
\]
PSD Cauchy--Schwarz gives \(\Gamma_0\succeq0\), using the normalization;
\(H_0\succeq0\) follows from PSD and \(H1=1\).
Expand \(B=(\Pi_Y+H_0)\circ(g\otimes g+\Gamma_0)\), then apply the
symmetric Dirichlet identity. This proves (12) and the nonnegativity of
each correction. Signed entries of the centered Schur factors cause no
problem: only their quadratic forms, not their entrywise signs, are used.
In (5), \(V^*1=1\), so \(\Gamma1=g\) and this normalization holds.

There is also a useful logarithmic counterpart of (3). With natural
logarithms and \(0\log0=0\), define
\(J_T(a,b)=\mathbb E_{\mu^2}T^a\log T^b\) and
\(I_T(b)=J_T(b,b)\). For integers \(0\le s\le t\),
\[
J_T(2s,2t)\ge I_T(s+t)\ge I_T(2t)\ge0.
\tag{13}
\]
For a fixed row, take \(S=T^{t-s}\) and \(f=T^{2s}(x,\cdot)\).
Concave Jensen, with \(\varepsilon>0\), gives
\[
\log(S^2f+\varepsilon)\ge S\log(Sf+\varepsilon).
\]
Multiply by \(f\), use self-adjointness, and average over \(x\).
The right side is
\(\mathbb E_{\mu^2}T^{s+t}\log(T^{s+t}+\varepsilon)\).
As \(\varepsilon\downarrow0\) it has a finite limit. The finite left sum
therefore cannot have a positive-weight term at a zero logarithmic
argument; its limit proves the first inequality in (13).
Data processing for the stationary pair law
\(\mu_x\mu_yT^j(x,y)\) gives the second inequality, since
\(2t\ge s+t\). Nonnegativity of relative entropy gives the last.
This proof also covers \(s=0\), \(s=t\) and periodic roots; it makes no
PSD assertion about entrywise logarithms.

Equation (12) is useful even in the residual strip, but proving that its
four corrections pay \(1-(\mathbb E g\sqrt L)^2\), when this is positive,
is still an unresolved universal estimate. Equation (13) supplies
positive cross-energy budgets, not an automatic bound on the full
four-leaf entropy.

## The remaining collective information route

A different compatible mechanism remains available in the residual strip.
Use the natural logarithms and quantities just defined. A cross-energy is
\(-\infty\) if its first kernel
puts positive mass where its logarithmic kernel vanishes.

Let two ancestors \(Z,W\) have joint law
\(\mu_z\mu_wT^\tau(z,w)\). Emit \(a,d\) independently from \(Z\) through
times \(\alpha,\delta\), and \(b,c\) independently from \(W\) through
times \(\beta,\gamma\). All times are nonnegative integers.

Their within-group pair kernels are \(T^{\alpha+\delta}\) and
\(T^{\beta+\gamma}\), and the cross-group kernels are the actual powers
\(T^{t_i+\tau+t_j}\). The marginalized leaf entropy is exactly
\[
D(q\Vert\mu^4)=I_T(\alpha+\delta)+I_T(\beta+\gamma)
                   +I((X_a,X_d);(X_b,X_c)),
\]
with the last term at most \(I_T(\tau)\) by data processing. Thus choosing
\(\alpha+\delta=2u\) and \(\beta+\gamma=2r\) cancels the two corresponding
target energies. A sufficient remaining estimate is that the four other
cross-energy terms pay this **joint group information**. No such universal
estimate has been proved. Replacing the joint information with zero, or
assuming all entrywise logarithms are PSD, would be invalid.

Write \(\mathcal R(q)=\mathbb E_q\sum_e\log K_{n_e}
-D(q\Vert\mu^4)\). For a finite mixture \(q=\sum_i\pi_iq_i\) with finite
payoffs, its Gibbs payoff satisfies
\[
\mathcal R(q)=\sum_i\pi_i\mathcal R(q_i)+I(I;X_a,X_b,X_c,X_d).
\]
The positive mixture-label information is another legitimate compensation
term; claiming that it always closes (11) would still require a proof.
An [exact rational mixture certificate](entropy-mixture-certificate.md)
shows that this term really can turn two negative trial payoffs into a
positive payoff. Its binary host and reflection tuple were already covered;
the example validates the mechanism, not new unrestricted coverage.

## Scope and relation to the paper

The result is a uniform exponent-region theorem, rather than another finite
host example or a modewise sign assertion. Its square-step Markov inequality
and quantitative form are reusable mechanisms for the density companion
problem. They preserve the paper's organizing distinction: structural
decomposition is already supported by accepted Lean results, while new
quantitative questions require global budgets for correlated contributions.

The inspected internal packets contain no equivalent square-step or
exponent-region theorem. This is only an internal comparison.
[Im, Li and Liu](https://arxiv.org/html/2408.03491v2) establish uniform
replacements, divisibility-controlled replacements and a special nonuniform
clique family in Theorems 1.3, 1.4 and 1.6; the present comparison is not a
literature-wide novelty clearance. The general ordered problem (11) remains
unresolved here.

The logarithmic transfer is a direct finite Jensen calculation.
[Li and Szegedy](https://arxiv.org/pdf/1107.1153), Section 3, develop
logarithmic smoothness and gluing methods for subgraph densities. This is
methodological context, not an attribution of the displayed region theorem
to their paper or a claim of novelty.

The mathematical proof was reviewed by Codex and an actual separate agent.
This is not an external audit or Lean acceptance. The authorized Pro reply
has completed and was fully read. It independently gives the same regions,
the exact surplus decomposition and logarithmic transfer, and the mixture
example. The returned arguments were audited separately; no second question,
automatic retry, unrestricted proof or new formal acceptance is claimed.
