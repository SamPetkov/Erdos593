OBLIGATORY UNIFORM HYPERGRAPHS
Canonical atoms and exact spectra
Author-review continuation dated 7 October 2026

MAIN DELIVERABLES

erdos593_obligatory_uniform_hypergraphs.pdf
  Complete 70-page manuscript. Theorem D is on page 4. Section 13 occupies
  pages 52-64. New unconditional results are on pages 53-58.

erdos593_obligatory_uniform_hypergraphs.tex
  Complete editable LaTeX source with its inline typeset bibliography.

references.bib
  All preceding 41 bibliographic entries retained, plus four primary
  references. BibTeX is not needed to compile the inline bibliography.

REVIEW AND REPRODUCIBILITY

REVISION_NOTE.txt
  Current results, exact novelty boundaries, relation to the original problem,
  proof assessment, journal positioning, and remaining submission issues.

SOURCE_AUDIT.txt
  Current mathematical and attribution review, final integration fixes, and
  the historical audit of the preceding density transfer. Historical theorem
  numbers are explicitly distinguished from the current numbering.

PROMPT_SOURCE_REVIEW.txt
  What OpenAI actually released, the scope of its exact formal target, prompt
  excerpts that were examined, versioned sources, and targeted prior-art checks.

RANK_LAYER_AUDIT.txt
  Bounded internal review of the written finite-field source, with quantitative
  audit observations. It is not a formal certificate or a Lean replay.

SPECTRA_REVISION_NOTE.txt
  Historical review of the preceding 57-page classification/spectra draft.
  Its pagination and theorem references describe that earlier draft.

revision.patch
  Cumulative unified diff from the original 4 October 2026 manuscript.

continuation.patch
  Unified diff from the preceding 65-page draft at commit
  c72b45e0d805a6b431e03fc92ea9de98ba8a9ea5.

integration_audit.json and build_verification.json
  Preservation, bibliography, proof scope, source reconciliation and build checks.

external_source_manifest.json
  Pinned OpenAI source sections and exact scope/challenge/configuration files,
  with Git blob and SHA256 hashes. Source identity does not certify the proof.

SHA256SUMS.txt
  Checksums of the other fourteen files in the packet.

BUILD

Run the following command three times with a standard TeX Live installation:

  pdflatex -interaction=nonstopmode -halt-on-error -no-shell-escape erdos593_obligatory_uniform_hypergraphs.tex

The source needs no external images, network access, or shell execution.
The final PDF has 70 pages and no LaTeX warnings, unresolved references or
citations, or overfull/underfull boxes. PDF hashes after a rebuild can differ
because of creation metadata.

PRESERVATION

Numbered Sections 1-12 are byte-for-byte unchanged from the preceding draft.
Their source span has SHA256:
7a03770423ff709b4dbdc55d1d32e67111a029dff9b48702c41fe920ba9976ad

The existing conditional transfer and its applications are also unchanged
from their opening lemma to the formal-verification section. The prior 41
bibliography entries retain their contents. All 45 entries are ordered by
first citation. The existing title and mathematical prose are preserved.

MATHEMATICAL AND SOURCE STATUS

Unconditional additions: universal pair-kernel realization is characterized
by the matching polytope; the scalar coefficient is universally optimal;
expansion densities satisfy explicit two-sided bounds of order 1/r;
regular kernels have a girth-sensitive bound of order r^(-g), with exact
forest equality and examples proving optimal rates at density 1/2.

Edmonds, Hoernig, Allerstorfer and coauthors, Hoeffding, and Nie-Spiro are
credited for the classical and nearby ingredients. No first-priority
certification is claimed by the bounded literature search.

Theorem D and the explicit Sidorenko counterexample retain the rank-layer
hypothesis from OpenAI's A counterexample to Sidorenko's conjecture, pinned
to openai/math commit adc7f1241b42e322a6451854ab7e4b4c146bf78a.
The new marginal and quantitative theorems do not use that hypothesis.

No new Lean formalization, external Lean replay, external peer review,
PR merge, or journal submission is claimed.

Repository: https://github.com/SamPetkov/Erdos593
Draft PR: https://github.com/SamPetkov/Erdos593/pull/53
