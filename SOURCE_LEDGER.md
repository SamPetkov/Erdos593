# Source, chronology, and dependency ledger

**Author:** Samuil Petkov  
**Revision date:** 24 July 2026

## Mathematical priority and comparison

Eric Li's preprint *A Resolution of Erdős Problems 593 and 1177: Obligatory
Triple Systems and Exact Spectra* (arXiv:2606.24882v1), posted on 23 June 2026,
contains the first publicly posted complete mathematical proof of the finite
classification in Erdős Problem 593. The manuscript cites Li at the points
where the one-apex lift, bridge-trace method, selected-incidence reconstruction,
and avoidance architecture are used.

The present manuscript uses a separately organised implementation: direct
positive-atom and closure proofs, an all-bridges decomposition, an explicit
base-fibre/support-incidence trace analysis, and a complete Lean verification
of the finite classification.

## Public Lean chronology

- 15 July 2026: the public repository added its verified Lean scaffold
  ([commit `ba37b8c`](https://github.com/SamPetkov/Erdos593/commit/ba37b8c511ab390c14a905110366d7cac1ffa08f)).
- 15 July 2026: the repository recorded the complete finite structural
  classification
  ([commit `6fd00a7`](https://github.com/SamPetkov/Erdos593/commit/6fd00a76064401f3f10aabef474f59d3c6ecd6bf)).
- 19 July 2026: the complete finite obligatoriness classification was published
  in the repository's public status interface
  ([commit `901af24`](https://github.com/SamPetkov/Erdos593/commit/901af24b8a94a0bfd93299651adfabe1f2b1d143)).
- 22--23 July 2026: the first commit in the repository accompanying Li's v2 and
  arXiv v2 itself recorded a separate formalisation of the broader Problems 593
  and 1177.

This chronology makes the present repository the earlier publicly timestamped
Lean formalisation of the finite Problem 593 classification. It does not alter
Li's priority for the first complete mathematical preprint.

## Finite parameter results added in this revision

The revised manuscript derives from the classification:

- a hypergraph-native edge-separation form of the Levi bridge condition;
- the exact order--size--component spectrum
  `m + 2(c-1) + ceil(2 sqrt(m-c+1)) ≤ n ≤ 2m+c`;
- the connected and unrestricted order intervals;
- the exact Levi cyclomatic-number spectrum; and
- rigidity of the dense endpoints `K_{t,t}^+` and `K_{t,t+1}^+`.

A targeted comparison was made against Li v2, Komjáth (2001), Hajnal--Komjáth
(2008), Reiher (2024), and Wang--Duan--Gerbner--Hama Karim (2026). No matching
finite order--size--component statement was located. This records the search
performed; it is not an absolute priority guarantee.

## Imported proof interfaces

| Source | Role in the manuscript |
|---|---|
| Erdős--Hajnal (1966), Theorem 7.4, p. 76 | Existence of uncountably chromatic graphs with prescribed odd-girth bound. The exact formulation is also quoted as Theorem C on p. 428 of Erdős--Galvin--Hajnal (1975). |
| de Bruijn--Erdős (1951), Theorem 1 | Graph-colouring compactness used for the finite-outdegree colouring lemma. |
| Erdős--Rado (1956), Theorem 4(i), formula (95) | Pair partition relation used to construct the uncountably chromatic linear host. |

The classical nonlinearity result of Erdős--Hajnal--Rothschild, Reiher's
private-vertex-expansion theorem, and the papers of Komjáth and
Hajnal--Komjáth are cited for historical context and comparison. The finite
parameter theorem is proved self-containedly from the classification and
standard bipartite graph bounds.

## Public source access

- Li v2: <https://arxiv.org/pdf/2606.24882>
- Erdős--Hajnal (1966): <https://combinatorica.hu/~p_erdos/1966-07.pdf>
- Erdős--Galvin--Hajnal (1975): <https://combinatorica.hu/~p_erdos/1975-24.pdf>
- de Bruijn--Erdős (1951): <https://users.renyi.hu/~p_erdos/1951-01.pdf>
- Erdős--Rado (1956): <https://users.renyi.hu/~p_erdos/1956-02.pdf>
- Reiher (2024): <https://arxiv.org/abs/2403.11223>
- Wang--Duan--Gerbner--Hama Karim (2026): <https://arxiv.org/abs/2604.21551>

## AI-use and provenance record

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle assisted with proof
development, checking, editing, and Lean formalisation. The author reviewed all
incorporated suggestions and accepts responsibility for the final mathematics,
citations, and historical statements. No assertion is made that either public
formal development was derived from the other.
