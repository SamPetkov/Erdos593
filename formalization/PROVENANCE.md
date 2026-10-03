# Formalisation provenance and public chronology

Eric Li's preprint arXiv:2606.24882 was posted on 23 June 2026 and contains the
first publicly posted complete mathematical proof of Erdős Problem 593. It
introduces the complete-rank one-apex lift and bridge-trace method used in the
negative direction of the classification.

The Lean development in this repository verifies a separate implementation of
the finite classification. Its principal design choices are:

- an edge-indexed incidence representation of finite triple systems;
- an explicit base-node, base-letter, base-fibre, and canonical-apex API;
- a support-incidence forest proof of the global finite-linear trace theorem;
- direct finite graph-factor and private-vertex-expansion interfaces;
- a machine-checked rooted-abundance and one-point-amalgamation closure route;
- a machine-checked Erdős--Rado nonlinear host; and
- an explicit shift-graph realization of the high-odd-girth obstruction.

## Timestamped public record

- [`ba37b8c`](https://github.com/SamPetkov/Erdos593/commit/ba37b8c511ab390c14a905110366d7cac1ffa08f),
  15 July 2026, adds the checked Lean scaffold.
- [`6fd00a7`](https://github.com/SamPetkov/Erdos593/commit/6fd00a76064401f3f10aabef474f59d3c6ecd6bf),
  later on 15 July 2026, completes the finite constructive/intrinsic
  classification.
- Subsequent commits through 19 July close the positive and avoidance endpoints
  and publish the complete finite obligatoriness theorem.
- Li's arXiv v2, submitted on 23 July 2026, announces a separate formal
  verification of the broader results in his paper.

To the author's knowledge, the 15 July record is the first publicly timestamped
Lean formalisation of the finite structural classification. This chronology does
not by itself imply shared code, derivation, or informational dependence, and no
such claim is made. The two projects use different finite-system
representations, module structures, and proof interfaces.

The formalisation's contribution is a reproducible Lean-kernel check of the
implementation presented in this repository. It supplements, rather than
replaces, mathematical review.
