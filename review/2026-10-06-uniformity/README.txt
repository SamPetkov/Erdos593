OBLIGATORY UNIFORM HYPERGRAPHS
Canonical atoms and exact spectra
Complete 81-page author-review manuscript, 7 October 2026

MAIN DELIVERABLES

erdos593_obligatory_uniform_hypergraphs.pdf
  Complete manuscript. Section 13 runs from page 53 to page 75.
  Worked marginal constructions: pages 56-58.
  Full linear-pattern bounds and optimal rates: pages 62-65.
  Degree-variance refinement: pages 65-67.
  Attachment-sensitive example and finite transfer budget: pages 68-69.

erdos593_obligatory_uniform_hypergraphs.tex
  Complete editable source, including the inline typeset bibliography.

references.bib
  Complete 46-entry BibTeX file. The preceding 45 entries retain their
  contents; one primary counting reference is added. BibTeX is not required
  to compile the inline bibliography.

REVIEW PACKET

REVISION_NOTE.txt: current mathematical results, explanations, scope,
  novelty boundaries, and editorial assessment.
SOURCE_AUDIT.txt: current internal mathematical reviews followed by clearly
  marked historical reports. Historical theorem numbers describe old drafts.
PROMPT_SOURCE_REVIEW.txt: released OpenAI material and targeted primary-source
  comparisons, supplemented for the new full-linear density theorem.
RANK_LAYER_AUDIT.txt: retained bounded audit of the external finite-field input.
SPECTRA_REVISION_NOTE.txt: historical assessment of the 57-page spectra draft.
revision.patch: cumulative diff against the original 4 October manuscript.
continuation.patch: diff against the preceding 70-page draft at commit
  ba62fadcf3f7098a05fa6eabda25c46df227318a.
integration_audit.json and build_verification.json: preservation and final checks.
external_source_manifest.json: pinned external source identity and comparisons.
SHA256SUMS.txt: checksums of the other fourteen packet files.

BUILD

Run this command three times with a standard TeX Live installation:

  pdflatex -interaction=nonstopmode -halt-on-error -no-shell-escape erdos593_obligatory_uniform_hypergraphs.tex

No external images, shell execution, or network access is needed.
The final PDF has no LaTeX warnings, unresolved references/citations, or
overfull/underfull boxes. Creation metadata can change a rebuilt PDF's hash.

PRESERVATION AND SCOPE

Numbered Sections 1-12 are byte-for-byte unchanged. Their source span has SHA256:
7a03770423ff709b4dbdc55d1d32e67111a029dff9b48702c41fe920ba9976ad

The existing conditional transfer and all its applications are also unchanged,
from their opening lemma to the formal-verification section. A new finite
error-budget explanation precedes that retained lemma. The title and established
prose are preserved, with targeted additions to the abstract and introduction.

All new marginal, linear-pattern, regularity, and attachment results are
unconditional manuscript arguments. The explicit OpenAI-based non-Sidorenko
atom retains the rank-layer hypothesis from the pinned external source.
No new Lean formalization, external Lean replay, external peer review,
first-priority certification, PR merge, or journal submission is claimed.

Repository: https://github.com/SamPetkov/Erdos593
Draft PR: https://github.com/SamPetkov/Erdos593/pull/53
