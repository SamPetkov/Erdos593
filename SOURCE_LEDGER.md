# Source, priority, and dependency ledger

**Author:** Samuil Petkov  
**Revision date:** 24 July 2026

## Classification priority

Eric Li's *A Resolution of Erdős Problems 593 and 1177: Obligatory Triple
Systems and Exact Spectra* (arXiv:2606.24882v1), submitted on 23 June 2026,
contains the first publicly posted complete proof of the finite classification
in Erdős Problem 593.

The present proof cites Li where it uses the complete-rank one-apex lift,
bridge-trace strategy, selected-incidence decomposition, quotient forest, and
running-intersection architecture.  It does not claim mathematical priority
for those ingredients.

## Public Lean chronology

The public repository history records:

- a verified Lean scaffold on 15 July 2026;
- the complete finite constructive/intrinsic classification later on 15 July;
- the complete Problem 593 endpoints by 19 July;
- Li's separate public formalisation and arXiv v2 announcement on 23 July.

On those public timestamps, this repository is the earliest complete public
Lean formalisation located in the present audit.  The precise commits and UTC
conversion are recorded in `PUBLIC_CHRONOLOGY.md`.  No inference about private
development or influence is made.

## Additional finite deductions

The 24 July revision derives an exact order--size--component spectrum, an exact
Levi cycle-rank spectrum, lower-endpoint rigidity, a forbidden-Levi-subgraph
criterion, a balanced-hypergraph consequence, and weak/strong
colouring-polynomial factorisations.  Detailed proofs and the novelty search
are recorded in `FURTHER_FINITE_RESULTS.md`.

## Imported proof interfaces

| Source | Role in the manuscript |
|---|---|
| Erdős--Hajnal (1966), Theorem 7.4 | Uncountably chromatic graphs with prescribed odd-girth bound. |
| de Bruijn--Erdős (1951), Theorem 1 | Graph-colouring compactness. |
| Erdős--Rado (1956), Theorem 4(i), formula (95) | Pair partition relation for the linear avoidance host. |
| Berge--Las Vergnas (1970); Berge (1972) | Hereditary König property of balanced hypergraphs. |
| White (2011); Sokal (2005) | Chromatic-polynomial and Potts/Tutte interfaces. |

## Public source access

- Li v1/v2: <https://arxiv.org/abs/2606.24882>
- Erdős--Hajnal (1966): <https://combinatorica.hu/~p_erdos/1966-07.pdf>
- de Bruijn--Erdős (1951): <https://users.renyi.hu/~p_erdos/1951-01.pdf>
- Erdős--Rado (1956): <https://users.renyi.hu/~p_erdos/1956-02.pdf>
- Reiher (2024): <https://arxiv.org/abs/2403.11223>
- Sokal (2005): <https://arxiv.org/abs/math/0503607>

## AI-use record

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle assisted with proof
development, checking, editing, and Lean formalisation.  The author reviewed
all incorporated material and assumes responsibility for the final work.
