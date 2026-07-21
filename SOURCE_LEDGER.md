# Source, priority, and dependency ledger

**Author:** Samuil Petkov  
**Revision date:** 21 July 2026

## Priority and relationship to Eric Li's preprint

Eric Li's preprint *A Resolution of Erdős Problems 593 and 1177: Obligatory
Triple Systems and Exact Spectra* (arXiv:2606.24882), posted on 23 June 2026,
contains the first publicly posted complete proof of the finite classification
in Erdős Problem 593.

The following structural ingredients used here already appear in Li's proof and
are cited at their points of use:

- the complete-rank one-apex sequence lift;
- the exact bridge-trace strategy for finite linear traces;
- the selected-incidence decomposition;
- the quotient forest and running-intersection assembly; and
- the division of the negative direction into nonlinear, missing-bridge, and
  odd-cycle avoidance hosts.

The present manuscript is an alternative implementation and exposition, not a
priority claim. Its detailed differences are the direct positive-atom and
closure proofs in the paper's notation, the base-fibre/support-incidence
formulation used for machine checking, direct invocation of the older
Erdős--Hajnal high-odd-girth theorem in the written proof, and a complete Lean
formal verification of this implementation. The Lean project is not a
line-by-line formalisation of Li's manuscript.

## Imported proof interfaces

| Source | Role in the manuscript |
|---|---|
| Erdős--Hajnal (1966), Theorem 7.4, p. 76 | Existence of uncountably chromatic graphs with prescribed odd-girth bound. The exact formulation is also quoted as Theorem C on p. 428 of Erdős--Galvin--Hajnal (1975). |
| de Bruijn--Erdős (1951), Theorem 1 | Graph-colouring compactness used for the finite-outdegree colouring lemma. |
| Erdős--Rado (1956), Theorem 4(i), formula (95) | Pair partition relation used to construct the uncountably chromatic linear host. |

The classical nonlinearity result of Erdős--Hajnal--Rothschild, Reiher's
private-vertex-expansion theorem, and the papers of Komjáth and
Hajnal--Komjáth are cited for historical context and comparison. The manuscript
includes the specific proofs it uses rather than treating those results as
unmarked premises.

## Public source access

- Li (2026): <https://arxiv.org/abs/2606.24882>
- Erdős--Hajnal (1966): <https://combinatorica.hu/~p_erdos/1966-07.pdf>
- Erdős--Galvin--Hajnal (1975): <https://combinatorica.hu/~p_erdos/1975-24.pdf>
- de Bruijn--Erdős (1951): <https://users.renyi.hu/~p_erdos/1951-01.pdf>
- Erdős--Rado (1956): <https://users.renyi.hu/~p_erdos/1956-02.pdf>
- Reiher (2024): <https://arxiv.org/abs/2403.11223>

## AI-use and provenance record

The author reports beginning development before becoming aware of Li's
preprint. OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle assisted with proof
development, checking, editing, and Lean formalisation. During substantial
stages the models were instructed not to use further internet access after an
initial source-retrieval stage. Such an instruction cannot independently prove
the provenance of every generated suggestion or guarantee informational
independence. The repository therefore makes no claim of full informational
independence and gives Li explicit priority and point-of-use attribution.
