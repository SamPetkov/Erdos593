OBLIGATORY UNIFORM HYPERGRAPHS
Canonical atoms and exact spectra
Author-review continuation dated 7 October 2026

MAIN DELIVERABLE

erdos593_obligatory_uniform_hypergraphs.pdf
  Complete 65-page manuscript. Theorem D is on page 4. The new Section 13
  is on pages 52-59, with the expansion-conjecture corollary on page 57.

erdos593_obligatory_uniform_hypergraphs.tex
  Complete editable LaTeX source, with its inline typeset bibliography.

references.bib
  Bibliographic database: all existing entries retained, with three added
  primary sources. BibTeX is not needed to compile the inline bibliography.

REVIEW AND REPRODUCIBILITY

REVISION_NOTE.txt
  Current mathematical contribution, source dependence, novelty boundaries,
  proof review, publication assessment and recommended next verification.

SOURCE_AUDIT.txt
  Detailed internal proof and primary-literature comparisons for the new
  density extension. The source's long finite-field estimate is an imported
  hypothesis, not independently certified by these transfer checks.

SPECTRA_REVISION_NOTE.txt
  Historical review of the preceding 57-page classification/spectra draft.
  Its page references describe that previous version, not this 65-page draft.

revision.patch
  Cumulative unified diff from the original 4 October 2026 manuscript.

continuation.patch
  Unified diff from the immediately preceding 57-page draft at commit
  0b7002f3518cf131ab2dd4c7c47ef729ade44c61.

integration_audit.json and build_verification.json
  Source preservation, bibliography preservation, review scope and build checks.

external_source_manifest.json
  Exact version, paths, Git blob hashes and SHA256 hashes of the eight OpenAI
  preprint sections examined. Exact text identity was checked, ignoring only
  one additional terminal newline introduced in local review copies.

SHA256SUMS.txt
  Checksums of the other twelve files in this packet.

BUILD

Use a standard TeX Live installation with the AMS classes and packages named
in the preamble. Run the following command three times from this directory:

  pdflatex -interaction=nonstopmode -halt-on-error -no-shell-escape erdos593_obligatory_uniform_hypergraphs.tex

No external image assets, network access or shell execution are required.
The supplied final PDF has 65 pages and no unresolved references, citations,
LaTeX warnings or overfull/underfull boxes. PDF byte hashes after rebuilding
may differ because of creation metadata; the mathematical content is the source.

PRESERVATION

Numbered Sections 1-12 are byte-for-byte unchanged from the preceding draft.
Their source span has SHA256:
7a03770423ff709b4dbdc55d1d32e67111a029dff9b48702c41fe920ba9976ad

The existing 38 bibliography entries retain their contents. Three primary
references were added, and all 41 entries are ordered by first citation.
Changes outside the new Section 13 are limited to its introductory statement,
abstract summary, references, verification scope and assistance disclosure.
The title and existing mathematical prose have been retained.

EXTERNAL INPUT AND STATUS

Theorem D and the density conclusions in Section 13 explicitly assume the
rank-layer limit in OpenAI, A counterexample to Sidorenko's conjecture
(23 September 2026), at openai/math commit
adc7f1241b42e322a6451854ab7e4b4c146bf78a, released 6 October 2026.

The new contribution is a proved transfer from that input, including a
proper-subgraph limit extraction and symmetric matching construction.
It yields a conditional counterexample to Nie-Spiro's published expansion
conjecture. The classification and chromatic spectra do not use this input.

No new Lean replay, formalization, external peer review, first-priority
certification, PR merge or journal submission is claimed.

Repository: https://github.com/SamPetkov/Erdos593
Draft PR: https://github.com/SamPetkov/Erdos593/pull/53
