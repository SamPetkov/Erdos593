# Compatible entropy mixture with positive compensation

An explicit mixture of two marginalized ancestor laws has positive Gibbs
payoff even though both component payoffs are negative. The example
demonstrates a compensation mechanism that a fixed trial law misses.
Its binary host and reflection tuple were already covered by the earlier
density results; it does not enlarge the all-host regions or prove the
unrestricted inequality.

## Actual root and compatible laws

Use \(\mu(-1)=\mu(1)=1/2\), the actual relative Markov root
\(T(s,t)=1+st/2\), and \(k=u=r=l=2,h=1\).
Every powered edge kernel is \(K_j(s,t)=1+2^{-2j}st\).
Let \(\Phi\) be the six-factor target product and
\[
\mathcal G(q)=\mathbb E_{\mu^4}q\log\Phi
             -\mathbb E_{\mu^4}q\log q.
\]
All logarithmic arguments below are strictly positive.

For a time vector \(\mathbf t\), marginalizing one stationary ancestor
gives the actual law
\[
q_{\mathbf t}(x)
=\tfrac12\sum_{z=\pm1}\prod_{i=a,b,c,d}(1+2^{-t_i}zx_i)
=1+\sum_{i<j}2^{-t_i-t_j}x_ix_j
 +2^{-\sum_i t_i}x_ax_bx_cx_d.
\]
Take \(\mathbf t^{(0)}=(2,3,3,1)\) and
\(\mathbf t^{(1)}=(3,1,2,3)\), and set
\(q_i=q_{\mathbf t^{(i)}}\), \(q=(q_0+q_1)/2\).
These laws have the original singleton marginals. The involution
\((a,c)(b,d)\) exchanges the two components and preserves \(\Phi\).
Consequently their exact energies and entropies agree.
The mixture polynomial is
\[
q=1+\tfrac3{64}x_ax_b+\tfrac1{32}x_ax_c
 +\tfrac9{128}x_ax_d+\tfrac9{128}x_bx_c
 +\tfrac1{16}x_bx_d+\tfrac3{64}x_cx_d
 +\tfrac1{512}x_ax_bx_cx_d.
\]

## Finite exact certificate

Every one of the sixteen configurations has reference weight \(1/16\).

| Density value | Multiplicity in either component | Multiplicity in the mixture |
| --- | ---: | ---: |
| \(423/512\) | 2 | 0 |
| \(441/512\) | 4 | 4 |
| \(487/512\) | 2 | 0 |
| \(489/512\) | 2 | 2 |
| \(495/512\) | 0 | 4 |
| \(527/512\) | 0 | 4 |
| \(567/512\) | 4 | 0 |
| \(681/512\) | 2 | 2 |

All three energies equal
\[
E=\tfrac52\log\tfrac{255}{256}
 +\tfrac{19}{128}\log\tfrac{17}{15}
 +\tfrac12\log\tfrac{4095}{4096}
 +\tfrac1{64}\log\tfrac{65}{63}.
\]
Their entropies are \(16^{-1}\sum_v m(v)v\log v\), with the multiplicities
in the table. These exact expressions give
\[
-\tfrac{3209}{10^6}<\mathcal G(q_0)=\mathcal G(q_1)
 <-\tfrac{3207}{10^6},\qquad
\tfrac9{100000}<\mathcal G(q)<\tfrac1{10000}.
\]
For each positive rational \(x\), let \(z=(x-1)/(x+1)\). The bound
\[
\left|\log x-2\sum_{j=0}^{18}\frac{z^{2j+1}}{2j+1}\right|
\le\frac{2|z|^{39}}{39(1-z^2)}
\]
follows from the absolutely convergent logarithm series and a geometric
tail estimate. Substitution proves the strict signs using rational
arithmetic only.
The [read-only checker](check_entropy_mixture_certificate.py) reconstructs
the laws from the ancestor, verifies normalization, singleton marginals,
the polynomial, histograms, equal energies and rational bounds, and gives
the exact density \(F=131155/131072\).
Floating-point displays in its output are for readability, not the certificate.

## What pays the deficit

If a fair label \(Z\) selects \(q_0\) or \(q_1\) and \(X\) is the sampled
four-leaf tuple, entropy chain rule gives
\[
\mathcal G(q)=\tfrac12\mathcal G(q_0)+\tfrac12\mathcal G(q_1)+I(Z;X).
\]
Here the positive label information pays both negative trial payoffs.
Gibbs variational inequality therefore yields
\(F>\exp(9/100000)>1\) for this benchmark.
The law being evaluated is the marginalized four-leaf law; no observed-root
entropy or incompatible pair fitting is substituted.

For roots with zeros, every component assigned positive mixture weight
must be supported on \(\{\Phi>0\}\); a finite information gain cannot repair
an infinite negative energy. Whether compatible mixtures can always pay
the residual all-host budget is still open. This finite illustration
and the logarithmic transfer in the
[regional theorem](markov-jensen-compensation.md) are tools for that problem,
not its resolution or an assertion of novelty or Lean verification.
