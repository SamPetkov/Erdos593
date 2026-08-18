# Canonical-atom manuscript integration ledger

## Scope

This integration applies the reviewed structural and quantitative results from
PRs #35--#37 to the authoritative Problem 593 manuscript.  It does not alter
the classification proof, the avoiding-host construction, the Lean source, or
the attribution boundary.

## Main-text changes

1. Retitle the paper **Obligatory Triple Systems: Canonical Atoms and Exact
   Finite Spectra**.
2. Replace the abstract by a self-contained AMS-style paragraph with no display
   mathematics or citations.
3. Add the ENS--PSL address and author email and remove the author-supplied date.
4. Make closure of the constructive class under isomorphism explicit.
5. Insert the canonical atom normal form immediately after the bridge-block
   reconstruction.
6. State the minimal generating family and classify one-point-indecomposable
   obligatory systems.
7. Add the minimum-order lemma for a 2-connected bipartite core of prescribed
   cycle rank.
8. Add the exact connected canonical atom-count spectrum.
9. Add the indecomposability phase diagram and its boundary rigidity.
10. Add the concise componentwise atom-count extension.

## Editorial compression

The manuscript does not import the full research notes.  It retains only:

- one canonical atom theorem and one corollary in the structural section;
- one minimum-order lemma;
- one atom-count theorem;
- one indecomposability theorem;
- one boundary-rigidity corollary; and
- one componentwise proposition.

Prescribed rank partitions, cyclic-component counts, the full theta-type
enumeration, and the large finite audits remain in the reader-first notes and
PR descriptions rather than the main paper.

## Artifact policy

`erdos593_obligatory_triple_systems.tex` remains the sole authoritative source.
The integration-ready theorem fragment is retained in
`reader-first/CANONICAL_ATOM_MANUSCRIPT_SECTION.tex`.
The integration workflow runs the repository's deterministic synchronization
script, recompiles the PDF, regenerates Markdown and arXiv mirrors, updates the
manifest and checksums, verifies typography and theorem markers, and commits the
synchronized artifacts back to the same-repository PR branch.

## Attribution boundary

The manuscript continues to credit Li for the first publicly posted complete
classification proof and the one-apex bridge-trace architecture, Reiher for the
positive expansion theorem, and Komjáth for the earlier 2-connected reduction.
The canonical atom and exact spectrum statements are presented as structural
corollaries of the classification under review, not as absolute priority
claims.
