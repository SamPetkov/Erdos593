# Primary-source scope check during this continuation

No external theorem newly encountered during this consultation is used
as a premise of the new cone transfer or quadratic estimate. The old
common-cone K4 and paired-star inputs are cited in the proof files at
their precise restricted scope.

## Recent Sidorenko preprint: statement checked, not a target resolution

The primary repository `openai/math` was inspected at the fixed commit
`adc7f1241b42e322a6451854ab7e4b4c146bf78a`. Its directory
[`preprints/A-counterexample-to-Sidorenkos-conjecture-September-23-2026`](https://github.com/openai/math/tree/adc7f1241b42e322a6451854ab7e4b4c146bf78a/preprints/A-counterexample-to-Sidorenkos-conjecture-September-23-2026)
contains a preprint attributed there to OpenAI, dated September 23, 2026.
The primary TeX sources were fetched directly, including the introduction,
kernel construction, complex, and geometric sections.

The [introduction's stated theorem](https://github.com/openai/math/blob/adc7f1241b42e322a6451854ab7e4b4c146bf78a/preprints/A-counterexample-to-Sidorenkos-conjecture-September-23-2026/build/sections/introduction.tex)
concerns the incidence graph of 22 triples on 13 points: it has 35
vertices, 66 edges, degrees three on the triple side and degrees four,
five or six on the point side. The preprint claims a finite host with a
strict Sidorenko deficit for that graph. This consultation checked that
statement and the construction's scope; it did **not** independently
referee the complete finite-field proof.

The [kernel section](https://github.com/openai/math/blob/adc7f1241b42e322a6451854ab7e4b4c146bf78a/preprints/A-counterexample-to-Sidorenkos-conjecture-September-23-2026/build/sections/kernel.tex)
uses fixed-dimensional rank layers over finite fields, activation laws
on incidences, and type weighting. Its limiting lemma is formulated for
the specified incidence complex and fixes the dimension before letting
the prime grow. It does not state an inequality or a counterexample for
the six actual common powers in the present problem.

There is a direct graph-level distinction, independent of whether that
preprint's claim is ultimately accepted. Replacing each edge of K4 by a
path of length `2 n_e` gives

\[
|E|=2N,\qquad |V|=4+\sum_e(2n_e-1)=2N-2,
\qquad |E|-|V|+1=3.
\]

It has exactly four degree-three branch vertices and degree-two internal
vertices. The stated 35-vertex graph has minimum degree three and is not
such a subdivision. No transfer from its construction to an admissible
`W,mu,(k,u,r,l,h)` with `F<1` has been established here.

Accordingly, the preprint is recorded as a checked primary-source scope
item, not a proof of or counterexample to this target. Its existence does
not justify assuming an affirmative result here, and absence of a matching
citation does not justify any novelty claim.

## Existing cover literature

The previous packet's primary-source checks for Csikvari's two-lift
sign-gauge theorem and Ruozzi's log-supermodular cover bounds remain at
their stated hypotheses. The new actual negative projection triangles
and negative cover coefficients do not establish those hypotheses. This
continuation does not import a generic PSD-to-cover domination rule or
infer positivity of a trace of three or more PSD matrices.
