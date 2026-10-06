OBLIGATORY UNIFORM HYPERGRAPHS
Canonical atoms and exact spectra
Author-review continuation dated 7 October 2026

MAIN FILES

erdos593_obligatory_uniform_hypergraphs.tex
  The complete manuscript source, including its typeset bibliography.

erdos593_obligatory_uniform_hypergraphs.pdf
  The compiled 57-page author-review manuscript.

references.bib
  The bibliographic database supplied with the original review packet.
  The manuscript uses an inline bibliography, so BibTeX is not needed.

REVISION_NOTE.txt
  Mathematical additions, proof mechanisms, literature attribution,
  verification scope, remaining editorial issues and publication assessment.

revision.patch
  Cumulative unified diff against the 4 October 2026 manuscript on main.

continuation.patch
  Unified diff against the preceding 50-page all-uniformity draft.

integration_audit.json and build_verification.json
  Source-preservation checks, baseline identifiers and final build results.

SHA256SUMS.txt
  Checksums of the other nine files in this packet.

BUILD

Use a standard TeX Live installation with the AMS classes and packages named
in the preamble. From this directory, run the following command three times:

  pdflatex -interaction=nonstopmode -halt-on-error -no-shell-escape erdos593_obligatory_uniform_hypergraphs.tex

No external image assets, network access, custom style files or shell execution
are required. The supplied source was compiled with pdfTeX from TeX Live 2023.
The final build has 57 pages and no LaTeX warnings, unresolved references or
citations, or overfull/underfull boxes. Rebuilt PDF byte hashes can differ
because of creation metadata; the mathematical content is the source.

BASELINES AND PRESERVATION

Repository: https://github.com/SamPetkov/Erdos593
Draft PR: https://github.com/SamPetkov/Erdos593/pull/53

Original main commit: 7b4d68b3a523c1f6997feab4588f041190568f61
Original file: review/2026-10-02/erdos593_obligatory_triple_systems.tex
Original manuscript date: 4 October 2026

Previous extension commit: ed904185796a91e38b009ffe2e504eea11507cb9
Previous file: review/2026-10-06-uniformity/erdos593_obligatory_uniform_hypergraphs.tex
Previous manuscript date: 6 October 2026

Sections 1-10 remain exactly as in the original manuscript. Their source span
has SHA256 20ca4cdeff9cf267136a070ca15c8a12ea5fc1062ff080d0bf5261acee1868ab.
Sections 1-11 are also preserved exactly from the previous extension draft.
All 38 bibliography entries retain their original contents; their order is
adjusted to preserve first-citation numbering in the expanded introduction.

The continuation adds Section 12 and introductory Theorem C. It updates the
title, abstract, scope and assistance statements to include the exact-cardinal
results. Section 11 remains the complete higher-uniformity classification,
introduced as Theorem B. The new mathematics has ordinary manuscript proofs;
no new Lean verification or external peer review is claimed.

QUICK READING ROUTE

Page 2: Theorem B, classification in every finite uniformity.
Page 3: Theorem C, exact uncountable avoidance spectra and contribution overview.
Pages 38-45: Section 11, the all-uniformity classification and finite structure.
Pages 45-46: Lemma 12.1, the sharp chromatic cap for the sequence lift.
Pages 46-47: Theorem 12.2, simultaneous avoidance for finite linear families.
Pages 47-49: Lemma 12.3, the full reservoir calibration proof.
Page 49: Theorem 12.4 and Corollary 12.5, bounded intersections and all cardinals.
Pages 49-50: Remark 12.6, the explicitly classical GCH size benchmark.
Page 50: Theorem 12.7, the full spectrum dichotomy and nonlinear witness bounds.
Pages 51-52: Proposition 12.8, an individually avoidable but jointly obligatory family.
Page 52: Scope of formal verification.

The revision remains an author-review draft. It does not establish first
priority, change the existing Lean development or constitute a journal submission.
