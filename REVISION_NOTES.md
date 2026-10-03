# Revision notes

## 24 July 2026: finite parameter consequences

1. Added the exact order--size--component spectrum for reduced obligatory triple systems:
   \[
   m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
   \le n\le2m+c.
   \]
   Every integer in the interval is realized.
2. Added the bipartite-shadow principle that transfers the finite parameters of an obligatory triple system to an ordinary bipartite graph.
3. Added the exact Levi cycle-rank spectrum, the forest characterization of the upper endpoint, and rigidity at the balanced lower endpoints `K_{t,t}^+` and `K_{t,t+1}^+`.
4. Added an edge-deletion reformulation of the Levi-bridge condition: deleting each hyperedge must separate its three points into at least two components.
5. Added `FINITE_PARAMETER_SPECTRUM.md` with the full proof and a targeted novelty screen against Li v1/v2 and the principal earlier obligatory-system literature.
6. Streamlined the discussion of Eric Li to one neutral priority paragraph plus point-of-use citations. Li's 23 June preprint remains credited as the first public complete mathematical proof.
7. Replaced repeated independence and provenance disclaimers with a factual public chronology of the two Lean developments. No claim of shared code or derivation is made.
8. Retained Tom de Groot's acknowledgment in full and shortened the acknowledgment to Eric Li to a single sentence thanking him for a discussion of the relationship between the proofs.
9. Simplified the AI-use section while retaining full author responsibility.

## 21 July 2026: attribution and arXiv readiness

1. Retitled the manuscript *Obligatory Triple Systems: An Alternative Proof*.
2. Credited Eric Li's 23 June 2026 preprint as the first publicly posted complete proof of the classification.
3. Added point-of-use citations for the one-apex sequence lift and bridge-trace method.
4. Replaced the written shift-graph section by the older Erdős--Hajnal high-odd-girth theorem, cited through Erdős--Hajnal (1966), Theorem 7.4, and Erdős--Galvin--Hajnal (1975), Theorem C.
5. Retained the complete proof, numeric citations, A4 `amsart` layout, one-inch margins, embedded fonts, populated metadata, and omission of the visible affiliation and email address.
6. Updated the Lean documentation to describe the complete machine-checked finite classification.
7. Added a deterministic arXiv source archive, synchronization checks, and Pandoc 3.1.3 pinning.
