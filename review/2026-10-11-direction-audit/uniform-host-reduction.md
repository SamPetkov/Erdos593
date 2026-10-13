# Strict density counterexamples reduce to rational uniform hosts

This is a reduction of the universal problem, not a change of measure in
an individual host calculation. It preserves the exponent tuple, actual
nonnegative Markov root, and strict violation. It does not establish the
density inequality.

## Statement and conventions

Use the original-law conventions and six-edge density \(F(h)\) from
[the tail note](fixed-host-tail.md). Thus \(X\) is finite, \(\mu>0\) is a
probability law, \(T\) is a symmetric nonnegative relative kernel,
\(\sum_y\mu_yT(x,y)=1\), and \(W=pT\in[0,1]\) for some \(p>0\).
Every composition uses the current host's law. The exponents
\(k\ge u\ge1\), \(r\ge l\ge1\), \(h\ge1\) are fixed.

If some such host has \(F(h)<1\), there is a finite host with uniform law,
strictly positive rational \(W'\in(0,1)\), constant rational row mean
\(p'>0\), and its actual root \(T'=W'/p'\), with \(F(h)<1\) at precisely
the same exponent tuple.

Consequently the universal inequality on all retained weighted hosts is
equivalent to the inequality on this smaller, rational uniform class.
Zeros and irrational weights cannot be the only locations of a strict
counterexample.

## Positive smoothing

Let \(\Pi(x,y)=1\) be the constant relative kernel under the original
\(\mu\). For \(0<\rho<1\), set
\[
T_\rho=\rho T+(1-\rho)\Pi.
\]
It is positive, symmetric and Markov under \(\mu\). Finite kernel powers
and the defining density are continuous in \(\rho\), so a strict
violation persists for \(\rho<1\) sufficiently close to one.
This is a legitimate bounded host: \(pT_\rho=\rho W+(1-\rho)p\in[0,1]\),
because the original row mean has \(0<p\le1\).

## Rationalize the reversible flux, not the measure alone

The positive symmetric table
\[
H_{ij}=\mu_i\mu_jT_\rho(i,j)
\]
has total sum one and row sums \(\mu_i\). Approximate \(H\) by positive
symmetric rational tables \(H'\) of total sum one. Such approximants can
be obtained by approximating the independent upper-triangular entries
positively and then dividing by their rational full-table sum.

Set
\[
\mu'_i=\sum_jH'_{ij},\qquad
T'(i,j)=\frac{H'_{ij}}{\mu'_i\mu'_j}.
\]
Then \(\mu'>0\) is rational and \(T'>0\) is symmetric, rational, and
Markov under \(\mu'\), exactly rather than approximately. Moreover
\((\mu',T')\to(\mu,T_\rho)\). Every finite density at the fixed exponent
tuple is continuous on positive weights, so \(F_{\mu',T'}(h)<1\) for a
sufficiently close approximant.

Choose rational \(p'>0\) so small that \(p'\max_{i,j}T'(i,j)<1\).
Then \(W'=p'T'\) is a positive rational bounded host with constant
\(\mu'\)-row mean \(p'\). This step rescales the bounded host; it does not
replace the actual root by an unrelated PSD matrix.

## Exact uniform cloning

Write \(\mu'_i=m_i/M\), with positive integers \(m_i\) summing to \(M\).
Replace state \(i\) by \(m_i\) distinct clones \((i,s)\), each of mass
\(1/M\), and define
\[
\widetilde T((i,s),(j,t))=T'(i,j),\qquad
\widetilde W=p'\widetilde T.
\]
The uniform row mean of \(\widetilde T\) is one. By induction, for each
positive integer \(a\),
\[
\widetilde T^{\,a}((i,s),(j,t))=(T')^a(i,j),
\]
where the left composition uses the uniform clone law and the right one
uses \(\mu'\). The induction step aggregates precisely \(m_j/M=\mu'_j\)
at intermediate type \(j\).

Aggregating the four density vertices by clone type therefore gives
\[
F_{\mathrm{uniform},\widetilde T}(h)=F_{\mu',T'}(h)<1.
\]
Every clone edge retains its actual prescribed root value; no averaging
of the six density factors, stationary-law substitution within the old
host, or exponent change occurs.

## What this achieves and what remains

It is enough to prove the universal assertion on all finite positive
rational uniform hosts. Conversely, a strict weighted counterexample can
be represented in that class after smoothing and rational approximation.
The rationalization does not give a uniform bound on clone count or on
how accurately one must approximate without a specified violation margin.
It does not reduce to two states, a fixed finite list, arbitrary PSD
matrices, or unweighted simple graphs in this reviewed argument.

This source proof is not Lean-validated, a novelty claim, or a solution
of the remaining finite exceptional exponents.
