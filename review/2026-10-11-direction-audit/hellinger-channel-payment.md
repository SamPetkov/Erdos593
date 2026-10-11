# Hellinger payment from the actual ancestor channel

The nonnegative ancestor channel gives a compensation bound without a
transition-density cap or an entrywise floor. Its loss is a Hellinger
overlap deficit, and a positive part of the retained Gram gain is available
to pay it. This is a sufficient certificate, not an unrestricted density
proof. An exact binary example separates it from the earlier root-floor
certificate, without adding a newly covered host family.

## Original law and target

Let \(X\) be finite and nonempty, with positive probability law \(\mu\).
Let \(T\) be a symmetric nonnegative relative Markov kernel, with all
compositions and expectations taken under \(\mu\). Put
\(A=T^2\), \(K_j=A^j\), \(\Pi=1\), and \(R_j=K_j-\Pi\).
Retain the original integers \(k\ge u\ge1,r\ge l\ge1,h\ge1\) and
\[
F=\mathbb E_{\mu^4}K_k(a,b)K_{r+h}(a,c)K_u(a,d)
                         K_r(b,c)K_u(b,d)K_l(c,d).
\]
The goal is \(F\ge1\) on every such host. Zeros, reducibility, periodicity,
negative eigenvalues of \(T\), and extra unit and zero modes remain
admissible.

Write \(m=r+u\), and define
\[
\begin{aligned}
v_{cd}(a)&=K_r(a,c)K_u(a,d),&
q_k(e,c,d)&=(T^kv_{cd})(e),\\
f_{cd}&=K_m(c,d)=\mathbb E_e q_k(e,c,d),&
s_d(c)&=\sqrt{K_l(c,d)}.
\end{aligned}
\tag{1}
\]
These are actual nonnegative flags, not centered spectral substitutions.
The [full flag identity](actual-channel-tail-payment.md), equations
(1)--(4), gives
\[
\begin{aligned}
F&=G_q+J_q,& D&=G_0+J_0,\\
D&=\mathbb E_{c,d}K_l(c,d)K_m(c,d)K_{m+h}(c,d)\ge1,\\
G_q-G_0
&=\mathbb E_{e,d}\langle s_d(q_k-f),A^h[s_d(q_k-f)]\rangle_\mu,\\
J_q&=\tfrac12\mathbb E_{e,c,x,d}K_h(c,x)
       (s_d(c)-s_d(x))^2q_k(e,c,d)q_k(e,x,d),\\
J_0&=\tfrac12\mathbb E_{c,x,d}K_h(c,x)
       (s_d(c)-s_d(x))^2f_{cd}f_{xd}.
\end{aligned}
\tag{2}
\]
Here \(f\) in the inner product means the function \(c\mapsto f_{cd}\).
The lower bound for \(D\) is the previously checked common-power
triangle expansion into traces and cubic-moment squares; no stationary
mode is removed.

## A positive part of the Gram gain

Define
\[
\mathcal C_k=\mathbb E_{e,d}
   \left[\mathbb E_c s_d(c)(q_k(e,c,d)-f_{cd})\right]^2\ge0.
\tag{3}
\]
Since \(A^h-\Pi\succeq0\), equation (2) gives
\(G_q-G_0\ge\mathcal C_k\). This projection retains a positive credit
without keeping the unresolved weighted cross form as an input.
For direct evaluation, put
\[
b_d(a)=K_u(a,d)\mathbb E_c\sqrt{K_l(c,d)}K_r(a,c).
\]
Then \(\mathbb E_c s_dq_k=T^kb_d\) and
\(\mathbb E_c s_df=\mathbb E_a b_d(a)\). Self-adjointness and
\(T^{2k}=K_k\) therefore prove
\[
\mathcal C_k=\mathbb E_d\langle b_d,R_kb_d\rangle_\mu.
\tag{4}
\]
All extra unit modes occur in this positive quadratic form.

## A floor free overlap loss

Set
\[
\begin{aligned}
H_k(c,x,d)&=\mathbb E_e
             \sqrt{q_k(e,c,d)q_k(e,x,d)},\\
\mathcal P_H(k)&=\tfrac12\mathbb E_{c,x,d}K_h(c,x)
 (s_d(c)-s_d(x))^2[f_{cd}f_{xd}-H_k(c,x,d)^2].
\end{aligned}
\tag{5}
\]
Cauchy--Schwarz gives \(H_k^2\le f_{cd}f_{xd}\), so
\(\mathcal P_H(k)\ge0\). Applied to the single random variable
\(\sqrt{q_k(e,c,d)q_k(e,x,d)}\) under the probability law \(\mu_e\),
it also gives
\[
\mathbb E_e q_k(e,c,d)q_k(e,x,d)\ge H_k(c,x,d)^2.
\]
Hence \(J_q\ge J_0-\mathcal P_H(k)\). Combining this with (2)--(3)
proves the floor-free bound
\[
\boxed{F\ge D+\mathcal C_k-\mathcal P_H(k).}
\tag{6}
\]

The information discarded in (6) is explicit and nonnegative. Put
\(z=q_k-f\). The exact difference between its two sides is
\[
\begin{aligned}
&\mathbb E_{e,d}\langle s_dz,(A^h-\Pi)(s_dz)\rangle_\mu\\
&\quad+\tfrac12\mathbb E_{c,x,d}K_h(c,x)(s_d(c)-s_d(x))^2
 \operatorname{Var}_{e\sim\mu}
      \bigl(\sqrt{q_k(e,c,d)q_k(e,x,d)}\bigr).
\end{aligned}
\tag{7}
\]
Thus
\[
\boxed{\mathcal P_H(k)\le D-1+\mathcal C_k}
\tag{8}
\]
is a genuinely sufficient, non-equivalent payment certificate. If it
fails, the nonnegative remainder in (7) may still compensate the loss.
No universal validity of (8) is established here.

## Data processing and an input minor

For any nonnegative functions \(v,w\) and nonnegative \(\mu\)-stationary
Markov kernel \(S\), rowwise Cauchy--Schwarz gives
\[
\sqrt{(Sv)(e)(Sw)(e)}\ge(S\sqrt{vw})(e).
\]
Integrating and using stationarity proves that the overlap cannot decrease
under this actual channel. Taking \(S=T^{k-u}\) and
\(q_k=T^{k-u}q_u\) gives
\[
H_k\ge H_u,\qquad \mathcal P_H(k)\le\mathcal P_H(u).
\tag{9}
\]
More generally \(\mathcal P_H(n)\le\mathcal P_H(k)\) for \(n\ge k\).
The positive credit \(\mathcal C_n\le\mathcal C_k\) also follows from
the spectrum of \(A\). These two monotonicities do not compare their
difference and do not prove (8).

Processing directly from \(v_{cd}\) gives
\[
H_k\ge H_{\rm in}(c,x,d)
 :=\mathbb E_aK_u(a,d)\sqrt{K_r(a,c)K_r(a,x)}.
\tag{10}
\]
Let \(\mathcal P_r\) be the expression in (5) with \(H_k\) replaced
by \(H_{\rm in}\). Then
\[
\boxed{F\ge D+\mathcal C_k-\mathcal P_H(k)
              \ge D+\mathcal C_k-\mathcal P_r.}
\tag{11}
\]
In particular \(\mathcal P_r\le D-1+\mathcal C_k\), or the stronger
\(\mathcal P_r\le D-1\), is sufficient.

The input deficit has an exact local form. Lagrange's Gram-determinant
identity applied under \(\mu_a\) to
\(\sqrt{K_u(a,d)K_r(a,c)}\) and
\(\sqrt{K_u(a,d)K_r(a,x)}\) proves
\[
\begin{aligned}
f_{cd}f_{xd}-H_{\rm in}^2
=\tfrac12\mathbb E_{a,b}K_u(a,d)K_u(b,d)
\left(\sqrt{K_r(a,c)K_r(b,x)}
     -\sqrt{K_r(a,x)K_r(b,c)}\right)^2.
\end{aligned}
\tag{12}
\]
Thus the loss couples the \(K_l\) square gradient to a two-by-two
minor built from actual \(K_r\) entries. It uses no kernel division.

## Exact separation from the root floor certificate

Take the uniform law on \(\{-1,1\}\) and
\(T(x,y)=1+xy/2\). This is an actual positive symmetric Markov root.
With \(\theta=1/4\), its powers are \(K_j(x,y)=1+\theta^jxy\).
Use the original ordered tuple
\[
k=u=r=4,\qquad l=2,\qquad h=1,
\]
and write
\[
\gamma=\theta^4=1/256,\quad b=\gamma^2=1/65536,
\quad a=\theta^2=1/16,\quad t=\theta=1/4,
\quad q_0=1-\sqrt{1-a^2}.
\]
The two-coordinate quantities in (2) satisfy
\[
D-1=a(1+t)b+tb^2,
\qquad J_0=\tfrac12(1-t)q_0(1-b^2).
\tag{13}
\]
For example, expand \(\sqrt{1+acd}=s_0+s_1cd\), with
\(s_0^2+s_1^2=1\), \(2s_0s_1=a\), and \(s_1^2=q_0/2\).
Multiplying by \(1+bcd\), and using the eigenvalues \(1,t\) of
\(A^h\), gives precisely (13).

The largest admissible root floor is
\(\beta=\min T^k=15/16\), so \((1-\beta)^2=\gamma\).
The elementary bound \(q_0\ge a^2/2\) gives
\[
(1-\beta)^2J_0
\ge\frac3{2^{20}}(1-2^{-32})
>\frac5{2^{22}}+2^{-34}=D-1.
\tag{14}
\]
After multiplying the strict comparison by \(2^{52}\), its numerator
is \(7\cdot2^{30}-2^{18}-3>0\). A smaller root floor only increases
the left side. Thus no admissible floor satisfies certificate (7) of
[the previous bound](actual-channel-tail-payment.md) on this host.
There is one support class of \(A\), of mass one, so its class-floor
certificate fails as well. This refutes a universal guarantee of those
certificates, not the density target.

The input-overlap certificate succeeds on the same host. Only \(c\ne x\)
contributes to its square gradient. There
\[
H_{\rm in}^2=1-\gamma^2=1-b,
\qquad f_{cd}f_{xd}-H_{\rm in}^2=b(1-b).
\]
The original binary probability factors consequently give
\[
\mathcal P_r=\tfrac12(1-t)q_0b(1-b).
\]
Since \(q_0\le a^2\) and \(D-1\ge a(1+t)b>0\),
\[
\mathcal P_r\le\frac{(1-t)a}{2(1+t)}(D-1)
             =\frac3{160}(D-1).
\tag{15}
\]
Equation (11) therefore certifies
\(F\ge1+(157/160)(D-1)+\mathcal C_k>1\).
This binary family was already covered. The example separates two
compensation estimates; it is not new density coverage or a novelty claim.

## Universal boundary

All arguments above use actual nonnegative integer powers of the root,
so odd channel times and negative root eigenvalues cause no sign change.
Zero entries require no conditional division. A constant or one-state
root has \(D=1\), \(\mathcal C_k=\mathcal P_H(k)=\mathcal P_r=0\).
Extra stationary modes are retained in (2), (4) and the PSD comparisons.
The auxiliary case \(h=0\) has zero square gradients and is consistent
with the earlier reflection endpoint.

The smaller loss in (8) still requires a joint payment by the triangle
surplus and actual Gram credit. No proof makes that payment universal.
The [exact original tail obligation](ordered-negative-mass.md),
\(H_{Z/\Delta}\le B+Q_{Z/\Delta}\) when \(\Delta>0\), therefore remains
open. Positivity of a generic PSD cross form, or compatibility of pair
tables alone, cannot replace the actual shared ancestor.

These are analytical compensation statements, not accepted Lean endpoints
or additions to the manuscript's theorem claims.
