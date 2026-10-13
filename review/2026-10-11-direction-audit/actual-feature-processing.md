# Why the actual ancestor must be retained

This follow-on to [Hellinger payment](hellinger-channel-payment.md) proves
that its simpler input certificate is not universally satisfied. The
processed certificate succeeds on the same admissible family because the
actual ancestor suppresses the loss by an extra order. The family is binary
and was already covered: this is a compensation mechanism, not new density
coverage, a counterexample to density, or a Lean result.

All quantities below use the original probability law and definitions of
that note. In particular its positive credit is \(\mathcal C_k\), its
processed loss is \(\mathcal P_H(k)\), and its input loss is
\(\mathcal P_r\). The current unrestricted question is still \(F\ge1\).

## An actual root and an admitted sequence

For every integer \(r\ge2\), set
\[
p=2^{-r},\quad q=1-p,\quad
\phi_R=\sqrt{q/p},\quad \phi_C=-\sqrt{p/q},\quad
T(i,j)=1+\tfrac12\phi_i\phi_j.
\]
The law has masses \(p,q\). It gives \(\mathbb E\phi=0\) and
\(\mathbb E\phi^2=1\). The root is symmetric and Markov; its cross entry
is \(1/2\), and both diagonal entries are positive. Thus this is an actual
nonnegative root for every member of the sequence, not a formal spectral
model. Put
\[
\theta=1/4,\quad l=2,\quad h=1,\quad k=u=r+2,
\quad a=\theta^l=1/16,\quad t=\theta^h=1/4,
\quad v=\theta^r=p^2,\quad b=\theta^u=av.
\tag{1}
\]
The original order conditions hold, including \(u=r+l\). Write
\(\alpha=\mathbb E\phi^3=(q-p)/\sqrt{pq}\). Actual weighted composition
gives \(K_j(i,j')=1+\theta^j\phi_i\phi_{j'}\).

## The input loss remains too large

Only \(c\ne x\) contributes to the square gradient. Put
\[
g_d=(\sqrt{K_l(R,d)}-\sqrt{K_l(C,d)})^2,\qquad
\delta_r=\sqrt{(1+v)^2+v\alpha^2}-(1-v).
\]
The exact two-state Gram determinant gives
\[
f_{Rd}f_{Cd}-H_{\rm in}(R,C,d)^2
=pq K_u(R,d)K_u(C,d)\delta_r^2.
\tag{2}
\]
This follows by expanding the weighted determinant: the two products of
\(K_r\) entries are
\((1+vq/p)(1+vp/q)=(1+v)^2+v\alpha^2\) and \((1-v)^2\).
Here \(\delta_r/p\to1/2\) and both \(K_u\) factors tend to one, uniformly
over the two possible \(d\)'s. Also
\[
p g_R\to a,\qquad
g_C\to(1-\sqrt{1-a})^2,\qquad
\mathbb E_d g_d\to L:=a+(1-\sqrt{1-a})^2>0.
\]
Accounting for both ordered cross pairs gives
\[
\mathcal P_r=pq(1-t)\mathbb E_d
 g_d[pqK_u(R,d)K_u(C,d)\delta_r^2],\qquad
\frac{\mathcal P_r}{p^4}\longrightarrow\frac{(1-t)L}{4}.
\tag{3}
\]
The exact triangle expansion, with \(\theta^{r+u}=ap^4\), is
\[
D-1=a^2(1+t)p^4+a^2tp^8+a^3tp^8\alpha^2.
\tag{4}
\]
Since \(\alpha^2=O(p^{-1})\), this implies
\[
\frac{D-1}{p^4}\longrightarrow a^2(1+t)=5/1024.
\tag{5}
\]

## The actual processed loss is a smaller order

Let \(y=\phi_d\), \(f_{id}=1+vb\phi_i y\), and define the actual normalized
flags
\[
\frac{q_k(e,i,d)}{f_{id}}=1+\phi_e\zeta_{id},\qquad
\zeta_{id}=\sqrt b\,
 \frac{v\phi_i+by+vb\alpha\phi_i y}{f_{id}}.
\tag{6}
\]
Equation (6) follows by expanding \(K_rK_u\), using
\(\phi^2=1+\alpha\phi\), and applying the actual \(T^k\), whose
nonconstant eigenvalue here is \(\sqrt b\). Its exact contrast is
\[
\zeta_{Rd}-\zeta_{Cd}
=\frac{\sqrt b\,v(1-b)(1+b+b\alpha y)}
       {\sqrt{pq}\,f_{Rd}f_{Cd}}
\sim\sqrt a\,p^{5/2}.
\tag{7}
\]
The asymptotic is uniform over \(d\). Moreover
\(\max_{e,i,d}|\phi_e\zeta_{id}|=O(p^2)\), so these normalized flags tend
uniformly to one and remain positive.

For two normalized binary densities
\(P_e=1+\phi_e\zeta_R\), \(Q_e=1+\phi_e\zeta_C\), the exact determinant
identity is
\[
1-(\mathbb E_e\sqrt{P_eQ_e})^2
=\frac{(\zeta_R-\zeta_C)^2}
 {(\sqrt{P_RQ_C}+\sqrt{P_CQ_R})^2}.
\tag{8}
\]
Its denominator tends to four. Thus the processed overlap deficit in each
\(d\) is asymptotic to \(ap^5/4\), and the original cross-pair weights yield
\[
\frac{\mathcal P_H(k)}{p^6}\longrightarrow\frac{a(1-t)L}{4}.
\tag{9}
\]
In particular \(\mathcal P_H(k)=O(p^6)=o(D-1)\).

The retained credit has the exact expression
\[
\mathcal C_k=b\,\mathbb E_d
 [b c_{0,d}y+v c_{1,d}(1+b\alpha y)]^2,
\quad c_{0,d}=\mathbb E_c\sqrt{K_l(c,d)},
\quad c_{1,d}=\sqrt{pq}\,[\sqrt{K_l(R,d)}-\sqrt{K_l(C,d)}].
\tag{10}
\]
Both \(c_0,c_1\) stay bounded. For rare \(d=R\), the bracket is
\(O(p^{3/2})\), weighted by \(p\); for \(d=C\), it is \(O(p^2)\).
Hence \(\mathcal C_k=O(p^6)\), not a hidden order-\(p^4\) credit.

## Conclusions and exact audit boundary

Because
\[
\frac{(1-t)L}{4}>\frac{(1-t)a}{4}
=3/256>5/1024=a^2(1+t),
\]
equations (3)--(5) and (10) imply that, for all sufficiently large integers
\(r\),
\[
\mathcal P_r>D-1+\mathcal C_k.
\tag{11}
\]
Thus the universal input-certificate obligation O18 of the earlier
[audit](hellinger-channel-audit.md) is **false**, not merely an unproved
shortcut. Its conditional implication remains valid. Limits along an
explicit admitted integer sequence establish existence of finite examples;
no numerical probe or asserted finite cutoff is used.

On the very same sequence, (5) and (9) give
\(\mathcal P_H(k)<D-1\) eventually. The actual processed certificate
therefore proves \(F>1\) there, with positive remaining surplus. This does
not close the universal processed obligation O17. It identifies the
information the input relaxation loses: the additional \(k\)-dependent
smoothing is quantitatively necessary for this certificate.

All four proof dependencies are discharged: admissibility (1), exact input
minor (2)--(5), actual normalized processing (6)--(9), and credit order (10).
The arbitrary-host payment, novelty, full external audit, and Lean
verification are not supplied by these analytical calculations.
