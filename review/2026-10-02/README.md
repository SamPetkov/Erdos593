# Erdős 593 manuscript review — journal-style revision, 2 October 2026

This packet contains the author's revised extended manuscript for review. Start with [the PDF](erdos593_obligatory_triple_systems.pdf), then consult [the change comparison](CHANGES.md) and [the mathematics and Lean audit](AUDIT.md). The complete editable source is [the TeX file](erdos593_obligatory_triple_systems.tex); [references.bib](references.bib) is included for reference, although this standalone TeX file uses an inline bibliography.

## What changed

The first two bounded passes repair the feasible domain of the connected atom-count theorem, replace an invalid overlapping-subtree contraction with a vertex-disjoint auxiliary-forest argument, and make canonical-atom preservation in the capacity construction explicit. The second pass clarifies the phase domain, binds the edge-count variable, handles the small tree boundary cases separately, and explains theta parity. The abstract and introduction connect the results through one question: what is constrained by cyclic content, and what can vary through assembly?

The journal-style pass uses restrained AMS typography with Annals-like text dimensions, visible MSC 2020 codes and an alphabetical bibliography. References increase from 16 to 23, and in-text citation commands from 34 to 51. Added sources support graph-block background, partition-lattice rank and characteristic polynomials, and Lean/Mathlib. The proof now distinguishes local partition-lattice factors from the bond lattice of the incidence forest. The disclosure names the recorded locations of AI assistance. None of these changes adds a theorem or proves a remaining formal interface.

The formal-verification section distinguishes accepted Lean results from the remaining interfaces. No new theorem or novelty claim has been inserted. The manuscript date remains 2 October 2026 because these are substantive manuscript revisions, not monitoring updates.

## Review boundary

The deliverable is a complete manuscript plus a source-backed review, not a claim that every statement is formalized or that the paper is ready for publication. The classification is verified. Several extensions are also accepted, but grading, fixed-atom realization and other exact interfaces remain open; see the audit.

This packet is deliberately separate from the repository's root publication files and the existing draft PR stack. Adding it does not promote every manuscript statement to the accepted Lean tree. Accepted proof source, toolchain pins, proof evidence, workflows and attribution are unchanged. Both author-stopped monitors remain paused.

## Checks

The revised source was built with the existing MiKTeX pdfLaTeX runtime, with automatic installation and shell execution disabled. The final two passes returned zero and produced a 35-page A4 PDF. All pages were rendered for overview inspection; the title, changed passages and bibliography were also inspected at page scale. There are no unresolved references/citations or overfull/underfull boxes. The harmless shell-escape-disabled warning is retained. The installed `aomart` class lacks `zref-savepos`, so the deliverable uses the standard `amsart` class rather than installing dependencies. It carries no Annals banner, publication DOI or acceptance claim. The earlier built-in editor initialization failure is not counted as successful compilation.

Against the second-pass source, all 111 displayed mathematical environments, 70 labels and 43 theorem/lemma/proposition/corollary/claim/definition statements retain their mathematical contents and order. One existing prose condition inside a display is wrapped over two lines to fit the narrower measure; no equation is added. All 23 references are cited and have matching inline/BibTeX keys. Citation additions and bibliography reordering are intentional. File hashes are listed in [SHA256SUMS](SHA256SUMS).

The earlier author-requested review used Codex self-review and real supplementary same-session mathematical, Lean-source and editorial reviews. The journal-style follow-up is Codex self-review only. Neither is represented as a full external independent audit. No Lean compiler, Aristotle, AXLE or new Pro request was launched for this manuscript pass.

## Suggested reading order

1. Abstract and introduction: whether the structural question and contribution are clear.
2. Section 10, especially Theorem 10.9 and Lemmas 10.15–10.16: exact domains, local partitions and the canonical-profile construction.
3. Formal verification and reproducibility: whether every qualification is visible and consistent with the audit.
4. The remainder of the paper: chronology, attribution, definitions and proof details outside the bounded second-pass audit still merit the author's full review.

The public and private packets are intended to be byte-identical. No private coordination directory, credentials or original private service logs are part of this export.
