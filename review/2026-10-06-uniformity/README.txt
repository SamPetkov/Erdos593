OBLIGATORY UNIFORM HYPERGRAPHS
Canonical atoms and exact finite spectra
Author-review revision dated 6 October 2026

MAIN FILES

erdos593_obligatory_uniform_hypergraphs.tex
  The complete manuscript source, including its typeset bibliography.

erdos593_obligatory_uniform_hypergraphs.pdf
  The compiled 50-page author-review manuscript.

references.bib
  The existing bibliographic database supplied with the original review packet.
  The manuscript uses an inline bibliography, so BibTeX is not needed to build it.

REVISION_NOTE.txt
  The mathematical addition, attribution, verification scope and publication
  assessment. The new statements have manuscript proofs; no new Lean verification
  or external peer review is claimed.

revision.patch
  A unified diff against the exact 4 October 2026 manuscript source.

integration_audit.json and build_verification.json
  Preservation checks, change descriptions, source identifiers and build results.

SHA256SUMS.txt
  Checksums of the files in this source packet.

BUILD

Use a standard TeX Live installation with the AMS classes and the packages named
in the preamble. From this directory, run the following command three times:

  pdflatex -interaction=nonstopmode -halt-on-error -no-shell-escape erdos593_obligatory_uniform_hypergraphs.tex

No external image assets, network access, custom style files or shell execution
are required. The supplied source was compiled with pdfTeX from TeX Live 2023.
The final build has 50 pages and no LaTeX warnings, unresolved citations or
references, or overfull/underfull boxes. PDF byte hashes can differ after a
rebuild because of creation metadata; the mathematical content is the source.

BASELINE AND PRESERVATION

Repository: https://github.com/SamPetkov/Erdos593
Baseline commit: 7b4d68b3a523c1f6997feab4588f041190568f61
Baseline file: review/2026-10-02/erdos593_obligatory_triple_systems.tex
Baseline manuscript date: 4 October 2026

Sections 1-10 are preserved exactly. Their source span has SHA256:
20ca4cdeff9cf267136a070ca15c8a12ea5fc1062ff080d0bf5261acee1868ab

The substantive addition is Section 11, introduced as Theorem B. The title,
abstract and introduction identify the wider scope. Formal-verification and
AI-assistance statements are qualified accordingly. All 38 bibliography entries
are preserved verbatim, with their order adjusted to retain first-citation
numbering after the new introductory citation.

QUICK READING ROUTE

Page 2: Theorem B and the main idea.
Pages 37-44: Section 11, including the complete proof and finite transfer.
Pages 38-39: Lemma 11.3, the finite linear trace lemma over a hypergraph base.
Page 40: Lemma 11.4 and Proposition 11.5, inflation and iteration.
Pages 40-42: Intrinsic reconstruction and the classification proof.
Page 42: Corollary 11.7, canonical atoms.
Page 43: Remark 11.8, the four-uniform example, and Corollary 11.9.
Pages 44-45: Scope of formal verification.

This packet is an author-review draft. It does not change the existing Lean
development, establish first priority, or constitute a journal submission.
