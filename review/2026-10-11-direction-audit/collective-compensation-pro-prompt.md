# Collective compensation for unequal common powers

One bounded mathematical consultation. Seek a constructive proof of the
unrestricted inequality below through collective compensation. Do not stop
after excluding another shortcut. A complete proof, a genuinely smaller proved
lemma advancing the target, or an exact unresolved obligation is acceptable.
Do not assume a desired theorem must exist. Distinguish analytical proof from
finite diagnostics and from formal verification.

## Exact target

Let \(X\) be any finite nonempty set and \(\mu_x>0\), \(\sum_x\mu_x=1\).
The symmetric relative kernel \(T(x,y)\ge0\) is an actual Markov root:
\(\sum_y\mu_yT(x,y)=1\). Composition is against this same original \(\mu\).
Equivalently one may take \(W=pT\in[0,1]\), \(p>0\).
Set \(A=T^2\), \(K_j=A^j\), with the weighted identity at exponent zero.
For every integer \(k\ge u\ge1\), \(r\ge l\ge1\), \(h\ge1\), prove
\[
F(h)=\mathbb E_{\mu^4}
 K_k(a,b)K_{r+h}(a,c)K_u(a,d)
 K_r(b,c)K_u(b,d)K_l(c,d)\ge1.
\]
Allow zeros, nonuniform weights, disconnected and periodic roots, extra
stationary modes and zero modes. An arbitrary commuting PSD replacement is
not an admissible root. No altered-measure conclusion may replace this target.

## Positive collective grouping

Write \(\Pi(x,y)=1\), \(R_j=K_j-\Pi\). These centered powers are PSD.
For each \(c\), define
\[
M_c(a,b)=\mathbb E_d K_l(c,d)R_u(a,d)R_u(b,d).
\]
This is a Gram kernel, so \(R_k\circ M_c\) is PSD, where \(\circ\) is
entrywise multiplication. Direct expansion under the original measure gives
\[
F=U_0+U_1+U_2+M_0+M_1,
\]
with
\[
\begin{aligned}
U_0&=\mathbb E_{a,c}K_{k+r}(a,c)K_{r+h}(a,c)\ge1,\\
U_1&=\mathbb E_{a,c}K_{k+r}K_{r+h}R_{u+l}\ge0,\\
U_2&=\mathbb E_{b,c}K_{k+r+h}K_rR_{u+l}\ge0,\\
M_0&=\mathbb E_{c,d}K_lR_{r+u}R_{r+h+u}\ge0,\\
M_1&=\mathbb E_c\langle K_{r+h}(\cdot,c),
             (R_k\circ M_c)K_r(\cdot,c)\rangle_\mu.
\end{aligned}
\]
The first four bounds are trace/cubic-moment-square identities, not assertions
that arbitrary products of PSD operators have positive trace.

Expanding the remaining three factors in \(M_1\) gives exactly one positive
centered triangle \(abd\), the three positive centered diamonds missing
\(ac\), \(bc\), or \(cd\), and the difficult full centered tetrahedral term.
Thus \(M_1\ge0\) is a **stronger sufficient assertion**, not a proved theorem.
It keeps proper-subgraph compensation together. At \(h=0\) it is a sum of
squared norms. Its constant \(\Pi\) first-leg component is
\(\mathbb E_{b,d}R_{k+u}R_uK_{r+l}\ge0\); this is not the full infinite-time
limit on reducible/periodic hosts. PSD alone does not sign its unequal
cross-form. Can actual-root nonnegativity and \(k\ge u,r\ge l\) close a
collective estimate here without discarding modes?

## Actual normalized overlap channel

There is a second exact formulation. Put \(Y=X^2,\nu=\mu^2\),
\[
V((a,c),b)=K_u(a,b)K_l(c,b),\quad
\Gamma=VK_uV^*,\quad g(a,c)=K_{u+l}(a,c).
\]
Then \(V^*1=1\), \(\Gamma1=g\), \(\mathbb E_\nu g=1\).
On \(g>0\), let \(\rho=g\nu\), \(P(y,z)=\Gamma(y,z)/(g(y)g(z))\).
It is a genuine symmetric nonnegative PSD Markov kernel under \(\rho\),
with nonnegative conditional Gram factor \(VT^u/g\). Zero-\(g\) rows vanish.
With \(H=A^{k-u}\otimes A^{r-l}\) and \(L(a,c)=K_{r+h}(a,c)\),
\[
F=\mathbb E_{\rho^2}L(y)H(y,z)P(y,z),\qquad
Hg=K_{k+r},
\]
and the \(P=1\) contribution is
\[
C=\mathbb E_{\mu^2}K_{r+h}K_{u+l}K_{k+r}\ge1.
\]
Here \(H\) is Markov under \(\nu\), not generally under \(\rho\).
Use this auxiliary law only through the exact identity for the original \(F\).
Seek a proved positive-channel/entropy bound paying the centered remainder;
merely restating \(F\ge1\) as its remainder bound does not advance the proof.

## Compatible entropy route

For nonnegative integer times \(t_v\), the latent ancestor density
\[
q_{\mathbf t}(a,b,c,d)
=\mathbb E_{z\sim\mu}\prod_vT^{t_v}(z,x_v)
\]
is globally compatible and has pair kernels \(T^{t_v+t_w}\).
Let \(J_T(s,t)=\mathbb E_{\mu^2}T^s\log T^t\).
The Gibbs bound is
\[
\log F\ge
\sum_{vw}J_T(t_v+t_w,2n_{vw})-D(q_{\mathbf t}\Vert\mu^4),
\quad (n_{ab},n_{ac},n_{ad},n_{bc},n_{bd},n_{cd})
=(k,r+h,u,r,u,l).
\]
Crucially this is the entropy of the **marginalized four-leaf law**, not the
larger observed-root tree entropy. A compatible adaptive law or mixture may
recover compensation unavailable to fixed-tree budgets.

Calibration: for uniform two states,
\(T=\left(\begin{smallmatrix}3/2&1/2\\1/2&3/2\end{smallmatrix}\right)\),
and \(k=u=r=l=h=1\), taking all \(t_v=1\) gives relative leaf weights
\(41/16,15/16,9/16\) on the \(2,8,6\) configurations of respective types
all equal, \(3+1\), \(2+2\). Its exact Gibbs payoff exceeds \(1/50\).
The actual density is \(535/512\). This is a positive witness calibration on
an already covered host, not unrestricted coverage.

## Boundaries and requested output

An auxiliary reflection proof gives
\(F(0)\ge\mathbb E K_lK_{r+u}^2\ge1\), but \(h=0\) is outside the target.
Do not infer interpolation or deleted-edge domination.
Individual active spectral coefficients can be negative on actual positive
roots. Total negative spectral variation is not universally paid by the
deleted-edge surplus. Exact powered branch-pair tables may be incompatible.
Fixed-star entropy witnesses can fail even when \(F>1\).
Nested conditional-expectation mixtures, two-level hosts, and structured
projection lifts already have restricted proofs; reproving them is not new
coverage.

Test at least two genuinely different constructive mechanisms above.
Prioritize a complete collective bound over another counterlemma. If the
unrestricted result does not close, provide the strongest proved positive
step with exact quantifiers and a smaller remaining obligation, including
why it is not merely the original theorem in disguise. Audit signs,
normalization, support, extra unit modes, and compatibility. Do not claim
novelty or Lean acceptance. No automatic follow-up, expensive search or
service dispatch is authorized by this consultation.
