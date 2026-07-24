# Formalisation provenance and attribution

Eric Li's arXiv:2606.24882v1, submitted on 23 June 2026, contains the first
publicly posted complete mathematical proof of Erdős Problem 593.  It
introduces the complete-rank one-apex sequence lift and bridge-trace theorem;
its selected-incidence, quotient-forest, and running-intersection architecture
is cited in the manuscript.

The Lean development in this repository is a separate implementation.  Its
principal implementation choices are:

- an explicit base-node, base-letter, base-fibre, and canonical-apex API;
- a support-incidence forest proof of the global finite-linear trace theorem;
- direct finite graph-factor and private-vertex-expansion interfaces;
- a machine-checked rooted-abundance and one-point-amalgamation closure route;
- a machine-checked Erdős--Rado nonlinear host; and
- an explicit shift-graph realisation of the high-odd-girth input.

## Public timestamps

- `ba37b8c` (15 July 2026): verified Lean scaffold;
- `6fd00a7` (15 July 2026): complete finite structural classification;
- `8153938` (19 July 2026, Europe/Sofia): complete Problem 593 endpoints;
- arXiv:2606.24882v2 and Li's separate public Lean repository (23 July 2026).

Accordingly, this is the earliest complete public Lean formalisation located in
the present audit, while Li's v1 retains priority for the mathematical
classification.  See `PUBLIC_CHRONOLOGY.md` for exact links and UTC timestamps.
This is a public-record statement only and makes no inference about private
development or influence.
