# Unrestricted density and the limits of independent compensation

The unrestricted common-power density inequality remains open. This pass
rules out a stronger global shortcut: the total negative spectral mass cannot
always be paid for by the deleted-edge surplus. The obstruction uses actual
strictly positive Markov roots and their original product probability laws.
It does not produce a counterexample to the density inequality.

## Exact target and scope

Let \(X\) be finite and nonempty, with \(\mu_x>0\) and \(\sum_x\mu_x=1\).
Let \(T\) be a symmetric, entrywise nonnegative relative kernel with
\(\sum_y\mu_yT(x,y)=1\). Composition always integrates against \(\mu\).
The bounded host is \(W=pT\in[0,1]\), with \(p>0\).
Put \(A=T^2\) and \(K_j=A^j\). The question is whether
\[
 F(h)=\mathbb E_{\mu^4}
 K_k(a,b)K_{r+h}(a,c)K_u(a,d)
 K_r(b,c)K_u(b,d)K_l(c,d)\ge1
 \tag{1}
\]
for every \(k\ge u\ge1,\ r\ge l\ge1,\ h\ge1\).
An arbitrary PSD replacement for the actual nonnegative root \(T\) is not
admissible. Zeros, periodicity and reducibility remain part of the target.

The deliverable is a complete proof, an admissible counterexample, or a precise
account of the remaining global obligation. The bounded pass tests tensor
amplification, compatible entropy couplings and an exact operator
factorization. It does not launch a broad search or an expensive computation.
Analytic route exclusions and small rational checks below are not Lean
acceptance, a novelty claim or a solution of (1).

## A positive universal constant would already be sharp

Fix the exponent tuple. Suppose a constant \(c>0\), depending only on that
tuple, satisfies \(F(h)\ge c\) on every admissible finite host.
For each \(m\), take the actual product host
\[
 \mu_m=\mu^{\otimes m},\quad T_m=T^{\otimes m},\quad
 W_m=W^{\otimes m},\quad p_m=p^m.
\]
It remains admissible, its powers factor, and \(F_m(h)=F(h)^m\).
If \(F(h)<1\), then \(F(h)^m<c\) for large \(m\), a contradiction.
Thus a host-independent positive lower bound is equivalent to (1).
The constant cannot depend on dimension, minimum atom mass, root or \(p\).

This is the standard tensor-power reduction, not a newly discovered
principle; compare [Sidorenko, Lemma 3.2](https://www.combinatorics.org/ojs/index.php/eljc/article/download/v28i1p32/pdf/).
The previously established fixed-host tail estimate has host-dependent
constants and therefore does not close this route.

## The total negative variation budget is false

Choose an orthonormal eigenbasis with \(\phi_0=1\), and write the active
centered eigenvalues of \(A\) as \(\theta_i\). Expanding the \(ac\) edge gives
\[
 F(h)=L+\sum_i d_i\theta_i^h,\qquad
 d_i=\theta_i^r w_i,
\]
where \(w_i\) is the actual ordered-fan coefficient. The constant coefficient is
\[
 L=\mathbb E_{\mu^2}K_u(b,d)K_{k+u}(b,d)K_{r+l}(b,d)\ge1.
 \tag{2}
\]
Indeed, integrating \(a,c\) gives (2), and its spectral expansion is a sum
of nonnegative squared cubic moments, including the constant term one.

A tempting sufficient condition for (1) is
\[
 N:=\sum_{d_i<0}|d_i|\le L-1.
 \tag{3}
\]
It would allow every positive centered contribution to be discarded, while
bounding each remaining filter between zero and one. Condition (3) is false
in the actual-root class.

### A negative coefficient survives admissible rational perturbation

Use the exact 32-state sign host in
[the ordered-fan certificate](../2026-10-10-common-power-density/continuation2/continuation2_tensor.md),
at \((k,u,r,l)=(6,1,1,1)\). Its six centered orthonormal sign functions have
root eigenvalues
\[
 (s_1,\ldots,s_6)=(2^{-20},1/8,1/8,1/2,2^{-10},1/8).
\]
The actual kernel is \(T=1+\sum_i s_i\phi_i\phi_i\);
\(\sum_i s_i=918529/1048576<1\), so every entry is strictly positive.
The exact source calculation gives \(w_1<-2^{-57}\), hence \(d_1<0\).
This input was previously checked directly from the original 32 states.

Root positivity, \(\sum_i s_i<1\), and \(d_1<0\) persist under sufficiently
small perturbations of these six coefficients in the same sign basis.
They can be perturbed to rational coefficients whose squares are
multiplicatively independent. Here is an explicit density argument.

Inductively choose a new prime \(p_i\) exceeding every earlier numerator
and denominator. With \(Q_i=\prod_{j<i}p_j\), choose
\[
 0<m_i<p_i,\qquad m_i\equiv1\pmod{Q_i},
\]
so that \(m_i/p_i\) lies in the desired open interval about \(s_i\).
The available grid has spacing \(Q_i/p_i\), which tends to zero along
arbitrarily large new primes. In the final family
\[
 v_{p_i}(s_j)=-\mathbf1_{i=j}.
\]
Consequently \(\theta_j=s_j^2\) are multiplicatively independent.
The perturbed kernel is rational, remains strictly positive and Markov
under the same uniform law, and can be normalized by
\(p=(1+\sum_i s_i)^{-1}\) to an actual bounded host.

The other 25 centered root modes remain zero. Their contributions vanish
because the \(ac\) exponent includes \(r\ge1\), even at the auxiliary value
\(h=0\). They are not omitted by an invertibility assumption.

### Tensor powers exceed the proposed surplus

For this perturbed host define the signed measure
\[
 \eta=L\delta_1+\sum_{i=1}^6d_i\delta_{\theta_i},\quad
 S=L+\sum_i|d_i|,\quad F_0=F(0)=L+\sum_i d_i.
\]
Here \(F_0>0\) because every actual kernel entry is positive. Since some
\(d_i<0\), we have \(S>F_0\) and \(S>L\).
The value \(h=0\) is auxiliary bookkeeping, not an extra target hypothesis.

For \(T^{\otimes m}\), the \(ac\) expansion has signed measure
\(\eta^{\odot m}\), its multiplicative convolution. Its constant coefficient
is \(L^m\). Multiplicative independence makes different centered count
vectors correspond to different eigenvalues. All permutations of one
count vector have the same coefficient sign, so no opposite-sign
cancellation occurs within a repeated eigenspace. Therefore
\[
 \|\eta^{\odot m}\|_{\rm TV}=S^m,\qquad
 \eta^{\odot m}([0,1])=F_0^m,\qquad
 N_m=\frac{S^m-F_0^m}{2}.
 \tag{4}
\]
All nonconstant contributing eigenvalues lie strictly below one.
The original tensor probability law and actual bounded host are retained.

Choose \(m\) so that
\((F_0/S)^m\le1/2\) and \((L/S)^m\le1/8\).
Then \(N_m\ge S^m/4\ge2L^m>L^m-1\), contradicting (3).
Thus even an arbitrarily large constant-mode surplus need not cover the
total negative variation.

This does not contradict (1). Its filters are the correlated values
\(\theta_i^h\), not independent choices in \([0,1]\). A valid global proof
must retain compensation from positive centered terms and exploit those
common-power correlations.

## A compatible Markov star gives a certificate but not a universal bound

Use natural logarithms and define
\[
 J(s,t)=\mathbb E_{\mu^2}K_s(x,y)\log K_t(x,y),\qquad I_t=J(t,t).
\]
A zero \(K_s\) term contributes zero; \(K_s>0,\ K_t=0\) gives
\(-\infty\). The following law is always a genuine compatible coupling:
\[
 q(a,b,c,d)=\mu_a\mu_b\mu_c\mu_d
 K_u(a,d)K_u(b,d)K_l(c,d).
\]
Its \(ab\) pair kernel is \(K_{2u}\), its \(ac,bc\) kernels are
\(K_{u+l}\), and its three star kernels are \(K_u,K_u,K_l\).
Moreover \(D(q\Vert\mu^4)=2I_u+I_l\).
The finite Gibbs variational inequality cancels these three star energies
against the relative entropy and yields the sufficient certificate
\[
 \log F(h)\ge R:=J(2u,k)+J(u+l,r+h)+J(u+l,r).
 \tag{5}
\]
When \(R\ge0\), (1) follows. This two-point certificate is not automatic.

Take \(\mu=(1/2,1/2)\),
\[
 W=\begin{pmatrix}1&1/3\\1/3&1\end{pmatrix},\quad p=2/3,\quad
 T=\begin{pmatrix}3/2&1/2\\1/2&3/2\end{pmatrix}.
\]
The centered eigenvalue of \(A\) is \(\theta=1/4\). At
\((k,u,r,l,h)=(1,1,1,1,1)\), direct sign averaging gives
\[
 J(s,t)=\tfrac12\log(1-\theta^{2t})
 +\tfrac12\theta^s\log\frac{1+\theta^t}{1-\theta^t}.
\]
Hence
\[
 R=\log(15/16)+\tfrac1{16}\log(5/3)
 +\tfrac12\log(255/256)+\tfrac1{32}\log(17/15)
 <-\frac1{16}+\frac1{24}-\frac1{512}+\frac1{240}
 =-\frac{143}{7680}.
\]
The bound uses \(\log(1-z)\le-z\) and \(\log(1+z)\le z\).
Nevertheless the actual density is
\[
 F=1+2\theta^3+3\theta^4+2\theta^5=1+\frac{23}{512}>1.
\]
Under tensor products \(R_m=mR\), whereas \(F_m=F^m\).
Thus no host-independent finite constant \(C\) can make \(R+C\ge0\) on
all actual hosts. This excludes a fixed additive correction to this
particular certificate; other globally compatible couplings remain possible.

## Prescribed powered branch marginals can be incompatible

For a uniform two-state root with centered square eigenvalue \(\theta\),
the pair kernel \(K_j\) prescribes sign correlation \(\theta^j\).
Let \(s,t,L\) be positive integers. If three branches were required to have correlations
\(\theta^s,\theta^t,\theta^L\), the pointwise sign inequality
\(1+AB-AD-BD\ge0\) would require
\[
 1+\theta^L-\theta^s-\theta^t\ge0.
 \tag{6}
\]
When \(L>s+t\), (6) fails for \(\theta\) sufficiently close to one.
Indeed, putting \(\theta=1-\varepsilon\), the Taylor remainder bound
and Bernoulli inequality give
\[
 1+\theta^L-\theta^s-\theta^t
 \le-(L-s-t)\varepsilon+\tfrac12L(L-1)\varepsilon^2<0
\]
for \(0<\varepsilon<\min\{1,2(L-s-t)/(L(L-1))\}\).
The centered root eigenvalue \(\sqrt\theta\) defines an actual positive
Markov kernel; normalization again gives a bounded host.

For an exact rational example take
\[
 W=\begin{pmatrix}1&1/19\\1/19&1\end{pmatrix},\quad
 p=10/19,\quad T=\begin{pmatrix}19/10&1/10\\1/10&19/10\end{pmatrix},
\]
so \(\theta=81/100\). At the allowed tuple \((3,1,1,1,1)\),
the requested \(ab,ad,bd\) correlations would give
\[
 1+\theta^3-2\theta=-88559/10^6<0.
\]
The actual density remains
\(1+\theta^3+\theta^4+2\theta^5+2\theta^6+\theta^7>1\).

This only excludes a coupling with all the extra powered *branch*
marginals. It does not exclude the separate exact-edge entropy target:
a law on subdivision vertices need not make each path internally Markov
or impose these branch-endpoint tables.

## The exact operator gap

An operator formulation isolates, but does not discharge, the global step.
On \(Y=X^2\) with law \(\nu=\mu^2\), define relative-kernel operators
\[
 V((a,c),b)=K_u(a,b)K_l(c,b),\quad
 H=A^{k-u}\otimes A^{r-l},\quad
 \Gamma=VK_uV^*,
\]
and let \(L_{ac}\) multiply by \(K_{r+h}(a,c)\).
Zero powers in \(H\) are weighted identities, not constant kernels.
Then
\[
 (HV)((a,c),b)=K_k(a,b)K_r(c,b),\qquad
 F(h)=\operatorname{Tr}_Y(L_{ac}H\Gamma).
 \tag{7}
\]
Each of \(L_{ac},H,\Gamma\) is PSD, but a trace of three PSD factors
is not generally nonnegative. Nor is \(\Gamma\) generally Markov:
\[
 V^*1=1,\qquad V1=\Gamma1=K_{u+l}.
\]
Replacing these actual operators by arbitrary PSD matrices loses the
essential root geometry; assuming \(\Gamma1=1\) loses the actual weights.

The remaining question is a collective inequality for the special
common-power operators in (7), or a different compatible variational
witness with a host-independent lower bound. Merely restating
“the full negative contribution is at most the positive surplus” is
equivalent to (1), not a smaller established lemma. No such global
inequality is proved here.

## Evidence boundary

The [small exact checker](check_unrestricted_density.py) tests the two
binary examples, the product-host identity, the pair-space identity on
positive nonuniform three-state roots, and the signed-measure
amplification algebra. Its toy signed measure is not represented as an
actual host. The total-variation theorem instead uses the previously
verified actual 32-state coefficient and the analytic perturbation proof.
The [review record](unrestricted-density-review.json) distinguishes these
checks from source review and formal-kernel acceptance.
