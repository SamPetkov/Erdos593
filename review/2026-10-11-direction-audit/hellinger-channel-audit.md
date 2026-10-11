# Conclusion first audit of Hellinger channel payment

## Audit boundary

The source is [Hellinger channel payment](hellinger-channel-payment.md),
equations (1)--(15). The finite original positive law, actual symmetric
nonnegative Markov root, and original ordered integer exponents are unchanged.
The proved conclusion is the floor-free lower bound
\(F\ge D+\mathcal C_k-\mathcal P_H(k)\), its input relaxation, and the
stated conditional density certificates. The full target is still \(F\ge1\)
for every admitted host, not just hosts satisfying those certificates.

Accepted primitives are the earlier full-flag identity and triangle expansion,
finite weighted composition, the spectral theorem for the actual root,
Cauchy--Schwarz, stationary Markov normalization, the Gram-determinant
identity, and finite algebra. Generic weighted Jordan positivity, an assumed
root floor, universal Hellinger payment, and pair-table compatibility as a
substitute for an actual ancestor are not accepted primitives.

## Obligation graph

The source supplies the following routes. Cases at zero entries and
stationary modes are required side conditions, not alternative proofs.

\[
\begin{aligned}
C1:\ F\ge D+\mathcal C_k-\mathcal P_H(k)
 &\leftarrow R_{\rm overlap}(\mathrm{AND}:O1,O2,C2,C3,O6),\\
C2:\ G_q-G_0\ge\mathcal C_k
 &\leftarrow R_{\rm projection}(\mathrm{AND}:O3,O4),\\
C3:\ J_q\ge J_0-\mathcal P_H(k)
 &\leftarrow R_{\rm CS}(\mathrm{AND}:O5,O6),\\
C4:\ \mathcal P_H(n)\le\mathcal P_H(k)\quad(n\ge k)
 &\leftarrow R_{\rm process}(\mathrm{AND}:O7,O8,O9),\\
C5:\ F\ge D+\mathcal C_k-\mathcal P_r
 &\leftarrow R_{\rm input}(\mathrm{AND}:C1,O8,O10,O11),\\
C6:\ \text{certificate (8) implies }F\ge1
 &\leftarrow R_{\rm pay}(\mathrm{AND}:C1,O12),\\
C7:\ \text{input certificate implies }F\ge1
 &\leftarrow R_{\rm inputpay}(\mathrm{AND}:C5,O13),\\
C8:\ \text{old floor fails and input certificate passes on the binary host}
 &\leftarrow R_{\rm separate}(\mathrm{AND}:O14,O15,O16).
\end{aligned}
\]
The exact nonnegative remainder in source equation (7) is
\(C9\leftarrow R_{\rm remainder}(\mathrm{AND}:O2,O3,O5,O6)\).
It establishes that the relaxed certificate is sufficient, rather than an
equivalent relabelling of the original density.

For the unrestricted conclusion \(C0\), the source offers only partial
routes:
\[
\begin{aligned}
C0&\leftarrow R_{\rm universaloverlap}
       (\mathrm{AND}:C1,O17),\\
C0&\leftarrow R_{\rm universalinput}
       (\mathrm{AND}:C5,O18).
\end{aligned}
\]
Neither missing universal payment is proved. The decrease of both
\(\mathcal P_H(k)\) and \(\mathcal C_k\) cannot compare their difference.

## Critical findings

The generic processing kernel must preserve \(\mu\), not merely have
row sum one. All actual integer powers \(T^n\) do preserve it, including
odd powers and the identity. Thus the source uses no noninteger semigroup
or positivity assumption on the spectrum of \(T\).

Two distinct applications of Cauchy--Schwarz are necessary. One proves
\(H_k^2\le f_{cd}f_{xd}\); the other proves
\(H_k^2\le\mathbb E_e q_k(e,c,d)q_k(e,x,d)\). Their difference gives a
nonnegative loss and a nonnegative variance remainder respectively.
The \(\Pi\) projection of the Gram gain is also a valid lower bound;
the additional unit modes remain in \(R_k\) and \(A^h-\Pi\).

The binary comparison is a genuine admissible example. It disproves a
universal guarantee of the earlier root-floor and class-floor certificates,
including the largest allowed floor. It does not contradict the density:
the new input-overlap certificate succeeds, and direct weighted composition
gives \(F>1\). This closes the stronger old certificate routes negatively,
not the unrestricted mathematical question. Its host family was already
covered, so no additional density region or novelty claim follows.

The [rational checker](check_hellinger_separation.py) verifies this one
host's actual matrix powers and fractions. Its
[saved values](hellinger-separation-checks.json) are finite diagnostics,
not proof by sampling of the universal analytical arguments.

## Dependency table

| ID | Exact claim or obligation | Needed by | Route or edge | Classification | Support | Status |
| --- | --- | --- | --- | --- | --- | --- |
| C0 | F>=1 for every original-law admitted host | root | Universal routes | root | C1/O17 or C5/O18 | failing |
| C1 | F>=D+Ck−PH(k) | C6,C0 | Overlap primary route | major claim | O1,O2,C2,C3,O6 | discharged |
| O1 | Positive finite original law, actual root and ordered integer times | C1 | Domain | hypothesis | Source target | discharged |
| O2 | F=Gq+Jq, D=G0+J0 and D>=1 | C1,C9 | Retained full flag | proved earlier | Linked flag identity and triangle expansion | discharged |
| C2 | Gq−G0>=Ck>=0 with Ck=E_d<b_d,Rk b_d> | C1 | Projection | major claim | O3,O4 | discharged |
| O3 | Ah−Pi is PSD and its omitted gain is nonnegative | C2,C9 | Gain bound | algebraic/logical step | Actual square spectrum, including extra unit modes | discharged |
| O4 | Tk b_d equals E_c s_d qk and T^(2k)=Kk | C2 | Original-law Gram | algebraic/logical step | Finite composition and self-adjointness | discharged |
| C3 | Jq>=J0−PH(k) | C1 | Overlap variance | major claim | O5,O6 | discharged |
| O5 | Hk²<=E_e qc qx and difference is the variance of sqrt(qc qx) | C3,C9 | Cauchy--Schwarz | named theorem | Finite probability law, nonnegative q | discharged |
| O6 | Hk²<=fc fx, PH>=0 and gradient weights are nonnegative | C1,C3,C9 | Well-defined loss | algebraic/logical step | Cauchy--Schwarz and actual kernels, including zeros | discharged |
| C4 | PH(n)<=PH(k) for n>=k | root | Processing | major claim | O7--O9 | discharged |
| O7 | qn=T^(n−k)qk | C4 | Channel identity | algebraic/logical step | Integer root composition | discharged |
| O8 | Each processing kernel is nonnegative, row-Markov and mu-stationary | C4,C5 | Integrated processing | side condition | Actual integer powers of symmetric Markov T | discharged |
| O9 | Rowwise overlap CS and stationarity give Hn>=Hk | C4 | Data processing | algebraic/logical step | O7,O8 and finite CS | discharged |
| C5 | F>=D+Ck−Pr | C7,C0 | Input relaxation | major claim | C1,O8,O10,O11 | discharged |
| O10 | Hk>=Hin by actual channel processing | C5 | Input overlap | algebraic/logical step | O8 and same rowwise CS | discharged |
| O11 | Pr>=PH>=0 and input deficit equals the squared minor (12) | C5 | Local interaction | named theorem | Gram determinant with original weighted functions | discharged |
| C6 | Overlap certificate implies F>=1 | root | Conditional payment | major claim | C1,O12 | discharged |
| O12 | PH(k)<=D−1+Ck | C6 | Certificate scope | hypothesis | Explicit conditional certificate (8) | discharged |
| C7 | Input certificate implies F>=1 | root | Conditional input payment | major claim | C5,O13 | discharged |
| O13 | Pr<=D−1+Ck, or stronger Pr<=D−1 | C7 | Certificate scope | hypothesis | Explicit input certificate after (11) | discharged |
| C8 | Binary old-floor failure and new-input success | root | Exact separation | major claim | O14--O16 | discharged |
| O14 | Uniform binary root is positive symmetric Markov and tuple is admitted | C8 | Example admissibility | side condition | T=1+xy/2 and (4,4,4,2,1) | discharged |
| O15 | Best floor loss>D−1; smaller floors and one-class floor cannot succeed | C8 | Failed older guarantee | algebraic/logical step | (13)--(14), q0>=a²/2, positive integer comparison | discharged |
| O16 | Pr<=3(D−1)/160<D−1 and Ck>=0 | C8 | Positive input payment | algebraic/logical step | (15), q0<=a² and original binary probability factors | discharged |
| C9 | Exact relaxation remainder (7) is nonnegative | C1 | Remainder accounting | major claim | O2,O3,O5,O6 | discharged |
| O17 | PH(k)<=D−1+Ck on every admitted host | C0 | Universal overlap bridge | missing | No universal bound supplied | failing |
| O18 | Pr<=D−1+Ck on every admitted host | C0 | Universal input bridge | missing | No universal bound supplied | failing |

## Verdict

For the conditional lower bounds, processing, local minor, exact remainder
and binary certificate separation: **FOLLOWS**. For the unrestricted
\(C0\): **NOT ESTABLISHED BY THIS PROOF**, because \(O17\) and \(O18\)
remain unproved. This does not show the density false or exclude another
proof. No Lean acceptance or full external audit follows from this source
review.
