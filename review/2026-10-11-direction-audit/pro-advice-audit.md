# Returned entropy advice: usable bounds and a corrected identity

The previously failed analytical consultation was retried once at the
author's explicit request. The response completed and was read. It did not
prove the six-length target or supply an admissible counterexample.
Visible selection was GPT-6 with Pro maximum power; an exact Astra identity
was not displayed. This public note contains the mathematical audit, not
private conversation identifiers or a transcript.

The reviewed example has actual path lengths
\((2,4,6,8,10,12)\), hence \(m=42\) edges and \(n=40\) vertices.
Write \(I=D(\lambda\Vert\kappa^2)\), where the positive singleton law is
\(\kappa\), the symmetric pair table has both marginals \(\kappa\), and
zero pair entries are allowed. Natural logarithms are used.

## Feasibility and two information bounds

Choose \((S,T)\sim\lambda\), and put \(S\) on one bipartition class and
\(T\) on the other. Every actual edge table is exactly \(\lambda\).
The copying map is injective, since both classes are nonempty, so
\[
D(\tau_{\rm copy}\Vert\kappa^{40})
=40H(\kappa)-H(\lambda)=38H(\kappa)+I.
\]
Thus this construction meets the \(42I\) budget when
\[
I\ge \frac{38}{41}H(\kappa).
\]
This is a restricted high-information regime, not a proof for all inputs.
The exchangeable triple extension is unnecessary for this construction.

For any rooted spanning tree \(\mathcal T\), let \(Q_{\mathcal T}\) have
root law \(\kappa\) and ordinary transition \(P_{xy}=\lambda_{xy}/\kappa_x\)
on each oriented tree edge. For every feasible law \(\tau\) on the full
graph,
\[
D(\tau\Vert\kappa^{40})
=39I+D(\tau\Vert Q_{\mathcal T})\ge39I.
\]
Indeed \(Q_{\mathcal T}/\kappa^{40}\) is the product of the relative pair
densities on the 39 tree edges. Taking its log under a feasible law
gives \(39I\). A zero pair entry forces zero \(\tau\)-mass on every
configuration using that tree edge, giving the needed support inclusion.
There is no subtraction of infinite divergences.

The tree law itself need not fit the three remaining graph edges. The
identity locates the remaining budget as at most \(3I\) of divergence
from a tree law; it does not bound that extra cost.

## Stationary-bridge formula: the sign matters

Let \(q\) be a joint law on the four branch vertices, with singleton
\(\kappa\). For core edge \(e\), set
\[
R_{L_e}(x,y)=\kappa_x(P^{L_e})_{xy},
\]
an endpoint probability table, not a relative kernel. Suppose the
conditional path laws are bridges of the original stationary chain and
are independent given the branch vertices. If every actual path edge
also has its prescribed law \(\lambda\), the correct identity is
\[
\boxed{
D(\tau\Vert\kappa^n)
=mI+D(q\Vert\kappa^4)
-\sum_eD(q_e\Vert\kappa^2)
+\sum_eD(q_e\Vert R_{L_e}).}
\]
The returned advice instead subtracted the endpoint-to-powered-table
divergences and omitted the pair mutual-information terms. That
displayed identity is incorrect even when every actual edge table fits.
The response later withdrew unrestricted use of its construction, but
that qualification does not repair the formula.

To derive the correction, a stationary path law has density
\(\prod_{\mathrm{path}}w\) relative to \(\kappa^{L_e+1}\), with
\(w=\lambda/\kappa^2\). Its conditional interior density relative to
\(\kappa^{L_e-1}\) is
\[
\frac{\prod_{\mathrm{path}}w}{R_{L_e}(x,y)/(\kappa_x\kappa_y)}.
\]
The log numerator has expectation \(L_eI\) precisely under the stated
individual edge constraints. The expected endpoint denominator is
\[
\mathbb E_{q_e}\log\frac{R_{L_e}}{\kappa^2}
=D(q_e\Vert\kappa^2)-D(q_e\Vert R_{L_e}).
\]
Conditional KL decomposition over all interiors now gives the boxed
identity. Required bridges exist only on the support of \(R_{L_e}\);
actual edge-support constraints imply \(q_e\ll R_{L_e}\), so all displayed
divergences are finite. Unused conditional versions can be chosen arbitrarily.

There is a direct positive-table check on the exact requested graph.
Take binary uniform \(\kappa\), \(\lambda=\kappa^2\), and
\[
q=(1-\varepsilon)\operatorname{Law}(S,S,S,S)+\varepsilon\kappa^4,
\qquad 0<\varepsilon<1.
\]
Every path has length at least two. Make every interior variable
independent with law \(\kappa\), also independent of all branches.
All 42 actual edge tables are \(\lambda\), and
\(D(\tau\Vert\kappa^{40})=D(q\Vert\kappa^4)\). Every branch-pair marginal
is nonproduct and \(R_{L_e}=\kappa^2\).
The incorrect formula would subtract six strictly positive pair
divergences from this value. The corrected formula cancels them.
This disproves only the returned formula, not the target entropy bound:
the independent law is a valid zero-cost witness for this pair table.

## Why unequal stationary endpoint laws need not fit jointly

Even a positive exchangeable triple extension does not guarantee that
all six stationary-powered endpoint tables admit a joint branch law.
For binary uniform \(\kappa\) and \(0<\theta<1\), take
\[
\lambda=\theta\operatorname{Law}(S,S)+(1-\theta)\kappa^2,\quad
\eta=\theta\operatorname{Law}(S,S,S)+(1-\theta)\kappa^3.
\]
Both are positive, and all pair marginals of \(\eta\) are \(\lambda\).
The transition is \(P=\theta I+(1-\theta)\Pi\).
A stationary length-\(L\) endpoint pair disagrees with probability
\(\delta_L=(1-\theta^L)/2\).

Every three jointly distributed branch variables obey the union-bound
triangle inequality
\(\Pr(X_b\ne X_c)\le\Pr(X_a\ne X_b)+\Pr(X_a\ne X_c)\).
But for the requested lengths \(L_{ab}=2\), \(L_{ac}=4\), \(L_{bc}=8\),
at \(\theta=9/10\),
\[
\delta_8-\delta_2-\delta_4
=\frac{3563279}{200000000}>0.
\]
Thus those three original stationary endpoint laws cannot fit jointly.
This does not preclude paths that fit all actual edges but are not
jointly the original stationary chains. The
[long-subdivision proof](long-subdivision-entropy.md) uses global
moment fitting instead and does not make that incompatible prescription.

## Verdict

The copying regime, exact tree identity and corrected bridge identity
were checked by the root and an actual separate mathematical reviewer.
The finite dual restatement and junction-tree remarks in the response
do not discharge the cyclic six-edge problem. No full-target proof,
novelty claim, Lean acceptance or automatic follow-up follows from the
returned advice.
