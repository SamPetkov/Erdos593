# Conclusion-first audit of actual channel tail payment

## Audit boundary

The source is [actual channel compensation](actual-channel-tail-payment.md),
equations (1)--(10). Its two analytical conclusions are the conditional
root-floor density certificate and the exact centered-edge variance
identity. The unrestricted target is the original-law six-edge density
\(F\ge1\), for every finite positive law and actual symmetric nonnegative
Markov root, with \(k\ge u\ge1,r\ge l\ge1,h\ge1\).
The source does not claim to have proved that target.

Accepted primitives are finite original-law kernel composition; symmetry
and Markov normalization; the real finite spectral theorem; positivity of
\(A^h=T^{2h}\); conditional variance and Cauchy--Schwarz; the earlier
cubic-moment-square expansion; and elementary finite algebra. No arbitrary
PSD Jordan-product sign, uniform transition floor, centered-flag positivity,
or unproved weighted contraction is accepted.

This audit checks only the supplied arguments and the exact bridges they
leave missing. It is not a search for all proofs of the unrestricted target,
Lean validation, or a full external audit.

## Obligation graph

The first complete claim is
\[
C1:\quad F\ge D-(1-\beta)^2(D-G_0),
\]
under the stated actual floor \(T^k\ge\beta\Pi\), \(0\le\beta\le1\).
Its primary route is
\[
\begin{aligned}
C1&\leftarrow R_{\rm flag}
    (\mathrm{AND}:O1,C2,C3,O7,O8),\\
C2:\ F=G_q+J_q&\leftarrow R_{\rm sym}
    (\mathrm{AND}:O2,O3,O4),\\
C3:\ G_q\ge G_0,
\ J_q\ge(2\beta-\beta^2)J_0
&\leftarrow R_{\rm floor}
    (\mathrm{AND}:O5,O6,O8).
\end{aligned}
\]
The \(\beta<1\) and \(\beta=1\) cases must both close; they are not
alternative proofs. At zero floor the bound remains valid but can be
less than one. The density certificate is the separate conditional claim
\[
C4:\ (1-\beta)^2(D-G_0)\le D-1\ \Longrightarrow\ F\ge1
\leftarrow R_{\rm pay}(\mathrm{AND}:C1,O9).
\]

The second complete claim is
\[
C5:\ C_6(k)=C_6(u)+V_h-\tfrac12(L_0+L_h)+\tfrac12L_{\rm diff}.
\]
Its primary covariance route is
\[
C5\leftarrow R_{\rm length}
  (\mathrm{AND}:O10,O11,O12,O13,O14).
\]
The consequent lower bound \(C6\) follows from weighted covariance
Cauchy--Schwarz, \(O15\).

For the unrestricted conclusion \(C0\), the source supplies only partial
routes. The missing bridges are explicit:
\[
\begin{aligned}
C0&\leftarrow R_{\rm certificate}
     (\mathrm{AND}:C1,O16),\\
C0&\leftarrow R_{\rm transfer}
     (\mathrm{AND}:C5,O17,O18).
\end{aligned}
\]
Here \(O16\) is a universal guarantee of the sufficient certificate, not
a fact proved by the source. For the second route define
\(P(k)=F(k)-1-C_6(k)\), the proper centered-subgraph sum. Its terms are
nonnegative by the previously checked expansion: degree-one subgraphs
vanish, cycles are traces, and triangles and diamonds are cubic-moment
squares. The exact missing leaf is
\[
O18:\quad P(k)+C_6(u)+V_h
\ge\tfrac12(L_0+L_h-L_{\rm diff}).
\]
By \(C5\) and \(O17\), this is equivalent to the full target, not a
smaller newly proved lemma. Neither route is completed universally.

## Critical findings

The root-floor bound retains the **full nonnegative flag** \(q\). Replacing
it by a centered flag would invalidate the pointwise proof of \(J_q\ge0\).
The argument also needs the actual entrywise floor, not merely a spectral
gap or an arbitrary PSD decomposition. The residual \(P\) in the source
is nonnegative symmetric Markov; it need not have a nonnegative square root.

Every integration and covariance uses the original probability law. Zeros
cause no division by a kernel: only \(1-\beta\) is divided out, and the
\(\beta=1\) case is handled separately. Reducibility, periodicity, negative
root eigenvalues and extra stationary modes remain admissible. In particular,
\(I-A^d\) annihilates every unit mode, not just the global constant.

The sign of \(V_h\) is valid because the only changed exponent is
\(u\le k\) and the cubic moments are squared. The weight-one correction
uses two centered \(r\)-legs and two centered \(u\)-legs; dropping that
correction would give the wrong length-transfer identity.

The rare-state two-symbol illustration shows that the sufficient certificate
can succeed with unbounded transition density. That family was already
covered, so this is a mechanism example, not new density coverage. The
earlier overlap-channel floor certificate has different kernels and is not
silently counted again as a theorem.

The failing leaves \(O16\) and \(O18\) are missing proofs, not counterexamples
to the target. The source does not claim either leaf as a known theorem.
A zero root floor alone is not an admissible density counterexample.

## Dependency table

| ID | Exact claim or obligation | Needed by | Route / edge | Classification | Support | Status |
| --- | --- | --- | --- | --- | --- | --- |
| C0 | Unrestricted original-root ordered density F>=1 | root | Certificate or transfer route | root | Missing O16 or O18 | failing |
| O1 | Finite positive law, actual symmetric nonnegative Markov root, ordered exponents and actual floor 0<=beta<=1 | C1 | Claim scope | hypothesis | Exact conditional statement | discharged |
| C1 | F>=D−(1−beta)^2(D−G0) | C4, C0 | Full-flag primary route | major claim | C2, C3, O7, O8 | discharged |
| C2 | F=Gq+Jq with both terms nonnegative | C1 | Symmetrization route | major claim | O2--O4 | discharged |
| O2 | Full flag q>=0, mean over e equal to Km, and two-copy composition reproduces F | C2 | Weighted composition | algebraic/logical step | Equation (1), T^(2k)=Kk and ab symmetry | discharged |
| O3 | Symmetric difference is one half of (sqrt(w(c))−sqrt(w(x)))^2 | C2 | Gradient identity | algebraic/logical step | Equation (2), w>=0 | discharged |
| O4 | Ah is PSD and full flags and Kh are entrywise nonnegative | C2 | Signs | proved earlier | Actual-root powers and O2 | discharged |
| C3 | Gq>=G0 and Jq>=(2beta−beta²)J0 | C1 | Floor expansion and beta=1 endpoint | major claim | O5, O6, O8 | discharged |
| O5 | For beta<1 residual P is nonnegative symmetric Markov and q=beta f+(1−beta)p, mean p=f | C3 | Residual construction | algebraic/logical step | Actual floor and Markov normalization | discharged |
| O6 | Zero mean removes Gram cross terms; both integrated gradient cross terms equal J0 | C3 | Bilinear expansion | algebraic/logical step | Equations (3)--(4) and finite averaging | discharged |
| O7 | D=G0+J0, J0>=0, and D>=1 by the cubic-square expansion | C1 | Baseline | algebraic/logical step | Equations (3), (5) | discharged |
| O8 | beta=1 forces T^k=Pi, q=f, Gq=G0, Jq=J0 and F=D; no division is used in this case | C1, C3 | Endpoint case | side condition | Positive law and Markov rows | discharged |
| C4 | Certificate (7) implies density>=1 | root | Conditional payment | major claim | C1, O9 | discharged |
| O9 | (1−beta)^2(D−G0)<=D−1 | C4 | Certificate scope | hypothesis | Explicit sufficient condition, not assumed universally | discharged |
| C5 | Exact centered-edge length-transfer identity (9) | C6, C0 | Covariance primary route | major claim | O10--O14 | discharged |
| O10 | d=k−u>=0, a_t=T^u b_t and all integrals are finite | C5 | Domain and definitions | definition | Equation (8) and ordered exponents | discharged |
| O11 | E_d(v,z)=<v,(I−A^d)z> is actual integrated conditional covariance and PSD | C5 | Variance representation | algebraic/logical step | Markov invariance, symmetry, T^(2d)=A^d | discharged |
| O12 | Rk−Ru=−T^u(I−A^d)T^u gives the negative weighted covariance difference | C5 | Edge transfer | algebraic/logical step | Original-law composition; Pi cancels | discharged |
| O13 | Replacing Rl by Kl−1 gives exactly Vh=M(u,2r+h,2u)−M(k,2r+h,2u)>=0 | C5 | Constant-weight correction | algebraic/logical step | Compose both centered leg pairs, then cubic squares | discharged |
| O14 | Polarization of covariance weighted by Kl yields (9), including Ldiff | C5 | Covariance identity | algebraic/logical step | Kl>=0 and equation (8) | discharged |
| C6 | C6(k)>=C6(u)+Vh−sqrt(L0 Lh) | root | Covariance bound | major claim | C5, O15 | discharged |
| O15 | Weighted covariance Cauchy--Schwarz applies to the finite PSD form | C6 | Norm inequality | named theorem | Nonnegative Kl, O11, finite norms | discharged |
| O16 | Every admitted host satisfies certificate (7) for a usable actual floor | C0 | Universal certificate bridge | missing | No supplied universal estimate | failing |
| O17 | F(k)−1=P(k)+C6(k), with P the nonnegative proper-subgraph sum | C0 | Exact earlier expansion | proved earlier | Centered expansion in the existing packet | discharged |
| O18 | P(k)+C6(u)+Vh>=(L0+Lh−Ldiff)/2 on every admitted host | C0 | Universal variance payment | missing | Exact full target reformulation, not proved | failing |

## Verdict

For the conditional root-floor estimate \(C1\), certificate \(C4\), and
variance identity and bound \(C5,C6\): **FOLLOWS**. Their stated hypotheses
and every required boundary case discharge the supplied routes.

For the unrestricted \(C0\): **NOT ESTABLISHED BY THIS PROOF**. The supplied
partial routes leave \(O16\) or \(O18\) unproved. This does not show the
target is false or exclude another proof. No Lean acceptance, novelty claim,
or full external audit follows from these analytical verdicts.
