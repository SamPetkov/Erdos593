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
No averaged edge table or change to uniform vertex weights is allowed.

Methods in this pass were finite spectral expansion and Markov minorization
for density, finite constrained-KL duality for known entropy coverage, and
an adversarial positive three-symbol test of a proposed bridge coupling.
The finite arithmetic checks are small diagnostics, not a simulation proof
or a broad search. No optimizer, heavy compiler run or new research campaign
was launched.

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

## Exact remaining gaps

For density, the finite exceptional exponents must still be proved to pass
for **every** actual host and exponent tuple. Host-dependent convergence
does not settle that uniform assertion. A PSD trace-insertion shortcut also
fails on an admissible two-state host, while that host's actual density
remains above one.

For entropy, unequal-length subdivisions still require a global construction
or a dual inequality controlling all edge potentials separately. Extending
the known length-two argument by independently attaching bridges is not
enough. No counterexample to the target has been obtained.

One bounded, user-authorized GPT-6 Pro consultation was submitted on the
all-even path tuple \((2,4,6,8,10,12)\), after excluding probes already covered
by known results. Chrome showed GPT-6 and Pro maximum power, but not an Astra
label. The prompt persisted and the UI returned “Error in message stream”;
there is no response to use and no automatic retry. Its private record is
not exported to this public packet.

Both full companion targets, formalization of the new density/entropy
material, novelty assessment and publication readiness remain unresolved.
The clocks stay paused. These connected research notes are delivered for
review rather than promoted into new manuscript claims.
