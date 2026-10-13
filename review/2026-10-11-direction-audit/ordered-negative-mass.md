# Negative mass payment and finite host density

For the original ordered six-edge density, the two cubic budgets jointly
control the negative spatial mass of the correlated flag sum. This proves
the density inequality whenever the relevant transition density is at
most \(4(1+\sqrt2)\). A further original-law moment estimate covers every
law with \(\min_x\mu_x\ge1/10\), including every uniform host on at most ten
states. The unrestricted heavy-tail case remains open.

## Exact scope and notation

Retain the [original-law conventions and exact collective decomposition](ordered-gradient-compensation.md).
Thus \(X\) is finite and nonempty, \(\mu\) is a positive probability law,
\(T\) is a symmetric entrywise nonnegative relative Markov kernel,
\(A=T^2\), and \(K_j=A^j\). All compositions use \(\mu\), not a tilted law.
For integers \(k\ge u\ge1,\ r\ge l\ge1,\ h\ge1\), put
\[
F=\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
                         K_r(b,c)K_u(b,d)K_l(c,d).
\]
The eigenbasis \(A\phi_i=\theta_i\phi_i\) has \(\phi_0=1\).
Only index zero is excluded from centered sums; extra unit modes remain.
Use \(\sigma\), \(\mathcal M\), and \(v_i=R_rD_{\phi_i}R_u\) as defined in
the linked derivation. Define
\[
\begin{aligned}
N_t&=\mathcal M(k,2u,2r+t),&
Z_t&=\mathcal M(k+u,u,r+l+t),\\
\sigma_0&=\sigma(k+2u),&
Z&=\sigma_0+Z_0+Z_h,\\
B&=(U_0-1)+U_1+U_2+M_0\ge0.
\end{aligned}
\tag{1}
\]
Here the new family \(N_t\) differs from the older note's notation:
\(N_0=N\), its \(V_h=N_h\), and its squared filtered norm is \(N_{2h}\).

The exact weighted remainder is
\[
F-1=B+Z+\mathbb E_{\mu^2}w g,\qquad w=K_l,
\quad
g(c,d)=\sum_{i\ne0}\theta_i^k v_i(c,d)(A_c^h v_i)(c,d).
\tag{2}
\]
Take \(g_+=\max(g,0)\) and \(g_-=\max(-g,0)\) **after** this sum,
rather than summing separate modewise negative parts.

## Filtered moments pay the negative mass

The symmetric exponent factorization in the linked norm proof applies
with the unchanged nonnegative third-index weight for every \(t\ge0\).
Together with \(2r+t\ge r+l+t\), it proves
\[
N_t\le Z_t,\qquad Z\ge\sigma_0+N_0+N_h.
\tag{3}
\]
Let \(V=(\theta_i^{k/2}v_i)_{i\ne0}\) and \(S=A_c^h\). Parseval gives
\[
\|V\|^2=N_0,\qquad \langle V,SV\rangle=N_h,\qquad
\|SV\|^2=N_{2h},\qquad 0\le N_{2h}\le N_h\le N_0.
\]
Consequently, with
\[
\Delta=\tfrac12\bigl(\sqrt{N_0N_{2h}}-N_h\bigr)\ge0,\qquad
a_0=(\sqrt2-1)/4,
\]
pointwise and integrated Cauchy--Schwarz show that
\[
\delta:=\mathbb E g_-=
\tfrac12(\mathbb E|g|-N_h)
\le\Delta
\le\min\{N_0/8,\ a_0(N_0+N_h)\}
\le a_0(Z-\sigma_0).
\tag{4}
\]
For \(N_0>0\), the scalar estimate follows on setting
\(t=\sqrt{N_h/N_0}\): the two ratios are bounded using
\(t-t^2\le1/4\) and
\((t-t^2)/(2(1+t^2))\le(\sqrt2-1)/4\).
The latter is the nonnegative square
\((1+\sqrt2)(t-(\sqrt2-1))^2\ge0\), after clearing positive constants.
If \(N_0=0\), all terms vanish. These constants concern this scalar
relaxation; equality realizability by an actual root is not asserted.

If \(\Delta=0\) and \(N_0>0\), equality in Hilbert-space Cauchy--Schwarz
gives \(SV=(N_h/N_0)V\), so \(g\ge0\) pointwise. Thus this case is
already paid even when \(w\) is unbounded across a family of hosts.

## A transition density cap and the exact unpaid tail

Put \(c_0=1+\sqrt2\) and \(b_0=4c_0=1/a_0\). The exact identity
\[
\begin{aligned}
Z-b_0\Delta={}&\sigma_0+(Z_0-N_0)+(Z_h-N_h)\\
&+(\sqrt{N_0}-c_0\sqrt{N_h})^2\\
&+2c_0\sqrt{N_0}(\sqrt{N_h}-\sqrt{N_{2h}})
\end{aligned}
\tag{5}
\]
has only nonnegative terms; expand using \(c_0^2-1=2c_0\).
Since \(\mathbb E wg\ge-\|w\|_\infty\delta\), equations (2)--(5) prove
\[
\boxed{\ \max_{c,d}K_l(c,d)\le4(1+\sqrt2)
        \ \Longrightarrow\ F\ge1+B+\sigma_0.\ }
\tag{6}
\]
In particular, a uniform \(n\)-state law gives \(K_l\le n\), so every
uniform host with \(n\le9\) satisfies (6).

For arbitrary \(b>0\), define the exact nonnegative quantities
\[
H_b=\mathbb E(w-b)_+g_-,
\qquad
Q_b=b(\Delta-\delta)+
       \mathbb E\{wg_++(b-w)_+g_-\}.
\]
Direct expansion gives
\[
F-1=B+(Z-b\Delta)+Q_b-H_b.
\tag{7}
\]
For \(\Delta>0\), use \(b_*=Z/\Delta\ge b_0\). Then
\[
F-1=B+Q_{b_*}-H_{b_*}.
\tag{8}
\]
The remaining inequality \(H_{b_*}\le B+Q_{b_*}\) is exactly equivalent
to the unrestricted target in this representation. It has not been
proved. Neither rarity of \(\{w>b_*\}\) nor the nonnegativity of the
separate budgets controls the flag amplitudes there.

An additional proved smoothing bound is
\[
\Delta\le\tfrac14(N_0-2N_h+N_{2h})
       \le\tfrac{\eta_{r-l,h}}4 Z_0,
\tag{9}
\]
where
\[
\eta_{a,h}=
\begin{cases}
1,&a=0,\\
(a/(a+2h))^{a/h}(2h/(a+2h))^2,&a>0.
\end{cases}
\]
Indeed \(\eta_{a,h}=\max_{0\le x\le1}x^a(1-x^h)^2\);
factor \(\theta_j^{2r}=\theta_j^{r+l}\theta_j^{r-l}\) in the
squared innovation norm, then use the symmetric exponent comparison.
This attenuates the unweighted loss without proving the heavy-tail payment.

## A direct ten state corollary

A further deduction uses the actual original probability law, rather
than a compressed projection-source condition. Suppose \(X\) has at
least two states and set
\[
L_\mu=1/\min_x\mu_x\ge2.
\]
Writing \(m_{ijs}=\mathbb E_\mu\phi_i\phi_j\phi_s\), completeness gives,
for each centered \(i\),
\[
\sum_{j,s\ne0}m_{ijs}^2
=\mathbb E_\mu\frac{\phi_i^2}{\mu_x}-2
\le L_\mu-2.
\tag{10}
\]
To check the subtraction, sum first over all \(j,s\):
the squared Hilbert--Schmidt norm of multiplication by \(\phi_i\)
is \(\sum_x\phi_i(x)^2=\mathbb E_\mu(\phi_i^2/\mu_x)\).
The row \(j=0\) and the column \(s=0\) each contribute one, and their
intersection \(m_{i00}^2\) is zero.

For positive exponents \(a,b,c\), weighted AM--GM yields
\[
\theta_i^a\theta_j^b\theta_s^c
\le \frac{a\theta_i^{a+b+c}+b\theta_j^{a+b+c}
                      +c\theta_s^{a+b+c}}{a+b+c}.
\]
Cubic symmetry and (10) therefore imply
\[
\mathcal M(a,b,c)\le(L_\mu-2)\sigma(a+b+c).
\tag{11}
\]
Since \(\sigma\) decreases with its exponent and \(r+l\ge2\), this gives
\[
Y:=Z_0+Z_h\le2(L_\mu-2)\sigma_0.
\tag{12}
\]
Markov normalization gives \(w(c,d)\le1/\mu_d\le L_\mu\).
Combining it with (2) and (4), without spending a second copy of \(Z\),
proves
\[
F-1\ge B+\sigma_0+(1-L_\mu a_0)Y.
\tag{13}
\]
If \(L_\mu\le b_0\), the last term is nonnegative.
For \(b_0\le L_\mu\le10\), equations (12)--(13) instead give
\[
F-1\ge B+\{1-16(10a_0-1)\}\sigma_0
      =B+(57-40\sqrt2)\sigma_0.
\]
As \(57^2>3200=(40\sqrt2)^2\), the final coefficient is positive.
In the first range, the stronger coefficient one also implies this bound.
We have proved
\[
\boxed{\ \min_x\mu_x\ge1/10
 \ \Longrightarrow\
 F\ge1+B+(57-40\sqrt2)\sigma(k+2u)\ge1.\ }
\tag{14}
\]
This includes all uniform hosts with at most ten states, at every ordered
exponent tuple. It does **not** include arbitrary nonuniform laws on ten
states: the minimum-mass hypothesis is substantive. The one-state case
has \(T=K_j=1\) and \(F=1\). For every other admitted host,
\(T\ne\Pi\) implies a positive nonconstant eigenvalue of \(A=T^2\),
hence \(\sigma_0>0\) and \(F>1\). Conversely \(T=\Pi\) gives \(F=1\).

## Scope compared with the earlier projection result

The [earlier Jordan theorem](../2026-10-10-common-power-density/continuation6/continuation6_jordan_contraction.md)
uses the same constant \(4(1+\sqrt2)\) for an actual compressed
projection source, and proves a balanced-visible **projection rank** bound
through ten. Its density consequence also needs a separately proved coarse
density bound and an actual projection-channel representation.
Equations (6) and (14) instead concern the scalar transition density of
an arbitrary original root with the stated cap or minimum-mass condition.
No projection-channel representation or coarse density premise is used.
The two criteria are not silently identified, and no novelty claim is made.

These are analytical deductions, reviewed at source level, not accepted Lean
results or additions to the manuscript's theorem claims. The source review
and its unrestricted dependency boundary are in
[the conclusion-first audit](negative-mass-audit.md) and
[the review receipt](negative-mass-review.json). The accepted structural Lean
tree and the paused monitors are unchanged.
