# Formalisation provenance and chronology

Eric Li's arXiv:2606.24882v1, posted on 23 June 2026, contains the first publicly
posted complete mathematical proof of Erdős Problem 593. It introduces the
complete-rank one-apex sequence lift and exact bridge-trace theorem, and uses a
selected-incidence/quotient-forest reconstruction. Those mathematical overlaps
are cited in the manuscript.

The public history of this repository records:

- a verified Lean scaffold on 15 July 2026 (`ba37b8c`);
- the complete finite structural classification later on 15 July 2026
  (`6fd00a7`); and
- the complete finite obligatoriness classification in the public status
  interface on 19 July 2026 (`901af24`).

The separate repository accompanying Li's v2 first records its broader joint
Problem 593/1177 formalisation on 22--23 July 2026. Thus this repository is the
earlier publicly timestamped Lean formalisation of the finite Problem 593
classification, while Li's later project has broader Problem 1177 scope.

The code here formalises the implementation developed in this repository. Its
principal choices are:

- an edge-indexed incidence representation of finite triple systems;
- an all-bridges bridge-block reconstruction;
- an explicit base-node, base-letter, base-fibre, and canonical-apex API;
- a support-incidence forest proof of the global finite-linear trace theorem;
- direct positive closure and complete-bipartite expansion interfaces;
- a machine-checked Erdős--Rado nonlinear host; and
- an explicit shift-graph high-odd-girth obstruction.

The projects are not line-by-line translations of one another and use different
representations and theorem interfaces. The dated chronology is a priority
record for the public formal artefacts; no assertion is made that either
formal development was derived from the other.
