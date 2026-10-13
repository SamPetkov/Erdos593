# Closing the weighted gradient compensation gap

One author-confirmed mathematical consultation. The aim is the unrestricted
ordered common-power density theorem, not another restricted example. Try to
close the exact weighted mixed-gradient estimate below. If the stronger
estimate is false, retain the other positive budgets rather than silently
strengthening the target's hypotheses. A complete proof, an admissible
counterexample, or a genuinely useful smaller proved estimate is acceptable.
Do not assume a desired conclusion exists.

## Exact target

Let \(X\) be any finite nonempty set, with \(\mu_x>0\) and
\(\sum_x\mu_x=1\). Let \(T(x,y)\ge0\) be a symmetric relative Markov root:
\(\sum_y\mu_yT(x,y)=1\). Every composition uses this same original law.
Put \(A=T^2\), \(K_j=A^j\), and \(\Pi=1\).
For every integer \(k\ge u\ge1,\ r\ge l\ge1,\ h\ge1\), prove
\[
F=\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
                      K_r(b,c)K_u(b,d)K_l(c,d)\ge1.
\]
Zeros, reducibility, periodicity, nonuniform weights, additional unit modes
and zero eigenvalues remain admissible. An arbitrary commuting PSD
replacement is not an actual nonnegative root. Do not change the measure,
replace the target, or use numerical agreement as proof.

## Regions already proved

For every actual host the target is proved when \(r+h\ge u+l\) or
\(u\ge r+l\). Further orientations cover \(u\le r,k\ge2u\), and
\(u\ge r+h,k\ge2r+h\). Thus the remaining strip has
\[
l\ge2,\quad 1\le h\le2l-2,\quad
r+h-l+1\le u\le r+l-1,\quad k\ge u,
\]
excluding those further orientations and previously covered reflection
families. Do not repeat these results as a solution of the remaining strip.

The positive channel proof yields \(F\ge J^2\), with
\(J=\mathbb E_{\mu^2}K_{u+l}\sqrt{K_{r+h}}\), plus four explicit nonnegative
Dirichlet/PSD corrections. In the remaining strip \(J\) may be below one.
Discarding those corrections and trying to pay \(1-J^2\) with only the
mixed-trace surplus fails even on actual primitive binary roots.

## Exact collective grouping

Set \(R_j=K_j-\Pi\). Direct expansion gives
\[
F=U_0+U_1+U_2+M_0+M_1,
\]
where the two-point factors in each expression use the same pair:
\[
\begin{aligned}
U_0&=\mathbb E K_{k+r}K_{r+h}\ge1,\\
U_1&=\mathbb E K_{k+r}K_{r+h}R_{u+l}\ge0,\\
U_2&=\mathbb E K_{k+r+h}K_rR_{u+l}\ge0,\\
M_0&=\mathbb E K_lR_{r+u}R_{r+h+u}\ge0.
\end{aligned}
\]
These signs are trace and cubic-moment-square identities, not positivity
of an arbitrary product of PSD operators.

Choose an original-law orthonormal eigenbasis \(A\phi_i=\theta_i\phi_i\),
\(\phi_0=1\). Centered indices exclude only \(0\). Put
\[
\sigma(a)=\sum_{i\ne0}\theta_i^a,\qquad
\mathcal M(a,b,c)=\sum_{i,j,s\ne0}\theta_i^a\theta_j^b\theta_s^c
                 (\mathbb E_\mu\phi_i\phi_j\phi_s)^2.
\]
For multiplication \(D_{\phi_i}\), define
\[
q_i=A^rD_{\phi_i}R_u,\qquad v_i=R_rD_{\phi_i}R_u.
\]
Thus
\[
q_i(c,d)=\theta_i^u\phi_i(d)+v_i(c,d),\quad
M_1=\sum_{i\ne0}\theta_i^k
       \mathbb E_{c,d}K_l(c,d)q_i(c,d)(A_c^hq_i)(c,d).
\]
The operator \(A_c^h\) acts only on \(c\).

## New positive budget

Expanding the constant part of \(q_i\) gives
\[
M_1=Z+\sum_{i\ne0}\theta_i^k
     \mathbb E_{c,d}K_l(c,d)v_i(c,d)(A_c^hv_i)(c,d),
\]
\[
Z=\sigma(k+2u)+\mathcal M(k+u,u,r+l)
                   +\mathcal M(k+u,u,r+l+h)\ge0.
\]
The actual ordering assumptions prove the dimension-free bound
\[
N:=\sum_{i\ne0}\theta_i^k\|v_i\|_{\mu^2}^2
 =\mathcal M(k,2u,2r)
 \le\mathcal M(k+u,u,r+l)\le Z.
\]
To check it, symmetrize the first two tensor indices and use
\[
x^{k+u}y^u+y^{k+u}x^u-x^ky^{2u}-y^kx^{2u}
=(xy)^u(x^u-y^u)(x^{k-u}-y^{k-u})\ge0.
\]
Then \(2r\ge r+l\) finishes the comparison.
The inequality pays for the whole unweighted centered norm, but it does
not justify replacing the \(K_l\)-weight by one.

## The weighted mixed-gradient obligation

Let \(s_d(c)=\sqrt{K_l(c,d)}\). Define
\[
\begin{aligned}
G_v&=\sum_{i\ne0}\theta_i^k\mathbb E_d
 \langle s_dv_i,A^h(s_dv_i)\rangle_\mu,\\
P_v&=\tfrac12\sum_{i\ne0}\theta_i^k\mathbb E_{c,x,d}
 K_h(c,x)v_i(c,d)^2(s_d(c)-s_d(x))^2,\\
E_v&=\tfrac14\sum_{i\ne0}\theta_i^k\mathbb E_{c,x,d}
 K_h(c,x)(s_d(c)-s_d(x))^2
 (v_i(c,d)-v_i(x,d))^2.
\end{aligned}
\]
All three terms are nonnegative and support-safe. Symmetry and polarization
prove
\[
M_1=Z+G_v+P_v-E_v,\qquad E_v\le2P_v.
\]
The remaining full collective estimate is
\[
E_v\le Z+G_v+P_v+(U_0-1)+U_1+U_2+M_0.
\]
This last displayed estimate is EXACTLY equivalent to the original density
target through the retained identities. Merely naming it a lemma proves
nothing. The stronger \(E_v\le Z+G_v+P_v\) would give \(M_1\ge0\), but is
not required if the other positive terms must compensate.

## Routes and adversarial checks

Try two materially different constructive routes:

1. Exploit \(r\ge l\) and \(k\ge u\), the actual smoothing structure
   \(v_i=R_rD_{\phi_i}R_u\), and the new norm budget to control the coupled
   square-root and flag gradients. Generic weighted Jordan-product
   positivity is false; ordinary unweighted PSD contraction does not suffice.
2. Retain all proper-subgraph budgets through an alternative actual
   semigroup, conditional-channel or compatible marginalized-entropy
   representation. Do not discard negative modes independently.

Total negative spectral variation is not paid universally by the deleted-edge
surplus. Even positivity against every monotone spectral cutoff is too
strong under tensor amplification: a valid proof must retain the particular
correlated common-power filters. Compatible two-ancestor entropy witnesses
can have negative payoff even with all target pairs exact; relative-entropy
projection has an explicit positive correction, but its universal budget
is still unproved. Do not assume arbitrary powered pair tables are feasible.

Audit signs, powers, normalization, support, original measures, extra unit
modes, all quantifiers and circular dependencies. Test small residual tuples,
but do not mistake their finite checks for a theorem. A failed stronger
estimate is not a counterexample to \(F\ge1\).

Return a complete derivation if possible. Otherwise state the strongest
genuine positive step and the precise missing estimate, explaining how it
advances the target rather than restating it. Do not claim novelty, B-level
impact, Lean acceptance or publication readiness. No automatic follow-up,
large search, compiler or additional service dispatch is requested.
