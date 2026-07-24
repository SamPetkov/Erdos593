# Source, priority, chronology, and dependency ledger

**Author:** Samuil Petkov  
**Revision date:** 24 July 2026

## Mathematical priority and relationship to Eric Li's preprint

Eric Li's preprint *A Resolution of Erdős Problems 593 and 1177: Obligatory
Triple Systems and Exact Spectra* (arXiv:2606.24882), posted on 23 June 2026,
contains the first publicly posted complete mathematical proof of the finite
classification in Erdős Problem 593. It also introduces the complete-rank
one-apex lift and bridge-trace method used in the negative direction. Those
facts are stated once in the introduction and cited again where the lift is
used.

The present manuscript gives a different implementation: direct positive-atom
and closure proofs, an explicit base-fibre/support-incidence formulation of the
finite trace theorem, a separate Lean development, and the finite parameter
consequences recorded in `FINITE_PARAMETER_SPECTRUM.md`. It is not a line-by-line
reworking of Li's manuscript.

## Public Lean chronology

The public Git history records:

- 15 July 2026, 03:49 +03:00 — checked Lean scaffold committed as
  [`ba37b8c`](https://github.com/SamPetkov/Erdos593/commit/ba37b8c511ab390c14a905110366d7cac1ffa08f);
- 15 July 2026, 12:09 +03:00 — complete finite constructive/intrinsic
  classification committed as
  [`6fd00a7`](https://github.com/SamPetkov/Erdos593/commit/6fd00a76064401f3f10aabef474f59d3c6ecd6bf);
- 19 July 2026 — the remaining obstruction machinery and complete finite
  obligatoriness endpoint were published in the same repository;
- 23 July 2026 — Li's arXiv v2 announced a separate formal verification of his
  broader paper, and his public Lean repository appeared with that revision.

To the author's knowledge, the 15 July checkpoint is the first publicly
timestamped Lean formalisation of the finite structural classification. This is
a statement about public chronology only. No assertion of copied code,
derivation, or informational dependence between the two Lean developments is
made.

## New finite consequences

The order--size--component spectrum, Levi cycle-rank spectrum, balanced endpoint
rigidity, and edge-deletion bridge test are derived from the classification and
from elementary connected bipartite graph bounds. A targeted novelty screen was
performed against both versions of Li's preprint and the principal earlier
obligatory-system literature. The detailed proof and screening record are in
`FINITE_PARAMETER_SPECTRUM.md`.

## Imported proof interfaces

| Source | Role in the manuscript |
|---|---|
| Erdős--Hajnal (1966), Theorem 7.4, p. 76 | Existence of uncountably chromatic graphs with prescribed odd-girth bound. The formulation is also quoted as Theorem C on p. 428 of Erdős--Galvin--Hajnal (1975). |
| de Bruijn--Erdős (1951), Theorem 1 | Graph-colouring compactness used for the finite-outdegree colouring lemma. |
| Erdős--Rado (1956), Theorem 4(i), formula (95) | Pair partition relation used to construct the uncountably chromatic linear host. |

The classical nonlinearity result of Erdős--Hajnal--Rothschild, Reiher's
private-vertex-expansion theorem, and the papers of Komjáth and
Hajnal--Komjáth are cited for historical context and comparison. The manuscript
includes the specific proofs it uses rather than treating those results as
unmarked premises.

## Public source access

- Li v1/v2 (2026): <https://arxiv.org/abs/2606.24882>
- Komjáth (2001): <https://doi.org/10.1007/s004930100021>
- Hajnal--Komjáth (2008): <https://doi.org/10.1007/s10474-007-6231-2>
- Erdős--Hajnal (1966): <https://doi.org/10.1007/BF02020444>
- Erdős--Galvin--Hajnal (1975): <https://combinatorica.hu/~p_erdos/1975-24.pdf>
- de Bruijn--Erdős (1951): <https://users.renyi.hu/~p_erdos/1951-01.pdf>
- Erdős--Rado (1956): <https://users.renyi.hu/~p_erdos/1956-02.pdf>
- Reiher (2024): <https://arxiv.org/abs/2403.11223>
- Wang--Duan--Gerbner--Hama Karim (2026): <https://arxiv.org/abs/2604.21551>

## AI-use record

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle assisted with proof
development, checking, editing, source organisation, and Lean formalisation.
Samuil Petkov reviewed the incorporated material and accepts responsibility for
the mathematical claims, citations, attribution, and final manuscript.
