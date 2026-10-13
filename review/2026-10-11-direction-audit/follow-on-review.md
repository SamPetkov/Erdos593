# Direct mathematical follow-on — 11 October 2026

## Retained brief

Continue the already confirmed, bounded two-target investigation: exact
individual-edge entropy on every simple bipartite subdivision of \(K_4\)
for arbitrary finite alphabets, and the ordered common-power density
inequality on an actual finite Markov root under its original law.
Accept a complete proof, an admissible target counterexample, or a precisely
identified remaining obligation. A failed proof construction is not an
admissible target counterexample.

The density conventions and all quantifiers are in
[the tail note](fixed-host-tail.md). The entropy target retains a positive
singleton law \(\kappa\), a symmetric pair table \(\lambda\), and an
exchangeable triple extension, with zero pair/triple entries permitted.
For a subdivision \(J\) with six internally disjoint paths, the requested
law has every singleton exactly \(\kappa\), every oriented edge exactly
\(\lambda\), and
\[
D(\tau\Vert\kappa^{V(J)})\le |E(J)|D(\lambda\Vert\kappa^2).
\]
No averaged edge table or silent measure substitution within an individual
host is allowed. The universal-host reduction below changes the host
explicitly, with a proof preserving the original density value.

Methods in this pass were finite spectral expansion and Markov minorization
for density, finite constrained-KL duality for known entropy coverage, and
an adversarial positive three-symbol test of a proposed bridge coupling.
The finite arithmetic checks are small diagnostics, not a simulation proof
or a broad search. No optimizer, heavy compiler run or new research campaign
was launched.

The author-authorized continuation used a Gibbs selected-edge expansion,
uniform local covariance control and a finite exponential-family fit for
entropy, plus positive reversible-flux approximation and exact cloning
for density. It stayed within the same two-target brief.

## What was established

The density note proves, for each fixed actual host and fixed positive
\(k,u,r,l\), that \(F(h)\ge1\) for every sufficiently large \(h\). It gives
both a spectral error bound and a rational minorization certificate. The
limit is strictly greater than one unless \(A=T^2\) is the global constant
kernel, in which case the density is exactly one. Rational hosts reduce the
remaining fixed-tuple question to finitely many exact sums.

The proof uses components of \(A\), not components of \(T\). This matters
for periodic roots. It retains the original vertex law throughout and
does not assume that a root restricts to each stationary component of its
square. The cutoff is host-dependent; it is not a uniform proof or a
complexity bound.

The entropy note recovers the already known length-two clique subdivision
case using Conlon–Lee's scalar theorem and a finite unary-gauged KL dual
argument. Szegedy's entropy correspondence already gives this coverage.
This is not counted as a new graph class or a novelty claim.

The same note proves that an explicit feasible latent-branch/independent-
midpoint construction exceeds the budget on a positive, exchangeable,
three-symbol input. Its excess is greater than \(10t^6\) at \(t=10^{-6}\).
All prescribed edge tables still fit. Thus edge feasibility alone does not
justify the entropy estimate; a different global coupling is needed.

### Reviewed continuation

[The long-subdivision theorem](long-subdivision-entropy.md) supplies that
global coupling in a restricted regime. For each fixed positive
\(\kappa,\lambda\), an actual simple bipartite \(K_4\) subdivision whose
lengths satisfy the displayed finite conditions admits exact singleton
and individual-edge tables, with KL at most \(mI-r^g/8\).
All sufficiently large common even length increments satisfy those
conditions. The proof controls a Gibbs cycle gain, fits the complete
unary/pair moment vector, and bounds the entropy correction cost.
It needs no exchangeable triple extension in this restricted regime.

The quantifier order matters: the threshold depends on the input pair
table. This does not prove a fixed graph is Sidorenko, give a uniform
threshold over all pair tables, or settle arbitrary original lengths or
zero entries. It is a complete analytical theorem with a reviewed
proof, not an accepted Lean theorem or an assessed novelty claim.

The density tail note now also gives a cutoff for a quantitative connected
class, uniform in \(k,r\), provided the positive-support graph of
\(A=T^2\) is connected, all atom masses are at least a fixed floor and the
centered spectrum stays below a fixed number less than one.
[The separate reduction](uniform-host-reduction.md) proves that any strict
weighted counterexample would yield a positive rational uniform-host
counterexample at the same exponent tuple. Neither result handles all
finite exceptional exponents.

## Review and reproduction

Both complete analytical notes were checked by the root and by distinct
actual agents. The density transcription review passed. The entropy review
passed after clarifying the ordinary transition convention as
\((P^2)_{xy}=\kappa_y(1+t^2f_xf_y)\). These are source/mathematical reviews,
not an external referee report or proof-assistant acceptance.

[The exact checker](check_tail_and_bridge.py) uses only rational arithmetic.
It checks five actual hosts at eight exponents each, the reflection
obstruction derived from the actual two-state root, all 27 triple entries
and pair marginals, all 81 four-branch tuples, the moments and strict
Taylor-bound comparisons. The one-state, periodic, disconnected weighted
and connected weighted cases are included. Its final exit is zero; the
[saved output](tail-and-bridge-checks.json) records the limited test scope.

The first checker execution stopped at a premature symmetry lookup in a
dictionary while it was still being populated (KeyError: (1, 0, 0)).
Moving that check after population repaired the checker. No mathematical
statement or proof was changed by this diagnostic fix.

Inline/display delimiter counts and repository whitespace checks pass.
The manuscript/PDF, bibliography, accepted Lean source, pins and workflows
were not edited in this follow-on. No new Lean validation is claimed.

The complete saved long-subdivision proof, including constants, inserted
statistics, covariance floor, entropy signs and eventual quantifiers, passed
root source review and a distinct actual mathematical agent's review.
That review led to a precision correction: these estimates do not justify
a zero-table limit; they do not prove every other uniform-threshold method
impossible. The complete saved uniform-host reduction and quantitative
cutoff passed a different actual agent's review. Connectedness of \(A\),
and the integer nature of the cutoff, were made explicit.

The updated small checker exits zero in under a second. In addition to the
earlier checks it tests 64 exponent tuples under two quantitative-class
cutoffs, exact cloning of six root powers and four densities, and the
positive stationary-endpoint triangle obstruction. Its actual output is
[preserved separately](continuation-checks.json); the earlier output remains
unchanged. No numerical fitting, exhaustive large-alphabet experiment,
proof-assistant run or full external audit is represented by these checks.

## Exact remaining gaps

For density, the finite exceptional exponents must still be proved to pass
for **every** actual host and exponent tuple. Host-dependent convergence
does not settle that uniform assertion. A PSD trace-insertion shortcut also
fails on an admissible two-state host, while that host's actual density
remains above one.

For entropy, arbitrary original-length and zero-entry subdivisions still
require a global construction or a dual inequality controlling every edge
potential separately. Extending the known length-two argument by
independently attaching stationary bridges is not enough. The new positive,
long-subdivision theorem covers only its explicit input-dependent regime.
No counterexample to the target has been obtained.

One bounded, user-authorized GPT-6 Pro consultation was submitted on the
all-even path tuple \((2,4,6,8,10,12)\), after excluding probes already covered
by known results. Chrome showed GPT-6 and Pro maximum power, but not an Astra
label. The prompt initially persisted and the UI returned “Error in message
stream”. The author then explicitly requested a retry. One Retry of the
same saved question completed; no new question or second retry was sent.

[The returned advice audit](pro-advice-audit.md) retains its usable
copy-law and tree bounds and corrects its invalid stationary-bridge entropy
formula. A positive-table example on the exact requested tuple falsifies
that formula while satisfying all actual edge marginals. This is not an
entropy-target counterexample. The audited reply still did not supply a
full-target proof. Private conversation IDs, transcripts and screenshots
are not exported to this public packet.

Both full companion targets, formalization of the new density/entropy
material, novelty assessment and publication readiness remain unresolved.
The clocks stay paused. These connected research notes are delivered for
review rather than promoted into new manuscript claims.
