# Erdős 593 manuscript review — 2 October 2026

This packet contains the author's revised extended manuscript for review. Start with [the PDF](erdos593_obligatory_triple_systems.pdf), then consult [the change comparison](CHANGES.md) and [the mathematics and Lean audit](AUDIT.md). The complete editable source is [the TeX file](erdos593_obligatory_triple_systems.tex); [references.bib](references.bib) is included for reference, although this standalone TeX file uses an inline bibliography.

## What changed

The two bounded passes repair the feasible domain of the connected atom-count theorem, replace an invalid overlapping-subtree contraction with a vertex-disjoint auxiliary-forest argument, and make canonical-atom preservation in the capacity construction explicit. The second pass clarifies the phase domain, binds the edge-count variable, handles the small tree boundary cases separately, and explains theta parity. The abstract and introduction now connect the results through one question: what is constrained by cyclic content, and what can vary through assembly?

The formal-verification section distinguishes accepted Lean results from the remaining interfaces. No new theorem or novelty claim has been inserted. The manuscript date remains 2 October 2026 because these are substantive manuscript revisions, not monitoring updates.

## Review boundary

The deliverable is a complete manuscript plus a source-backed review, not a claim that every statement is formalized or that the paper is ready for publication. The classification is verified. Several extensions are also accepted, but grading, fixed-atom realization and other exact interfaces remain open; see the audit.

This packet is deliberately separate from the repository's root publication files and the existing draft PR stack. Adding it does not promote every manuscript statement to the accepted Lean tree. Accepted proof source, toolchain pins, proof evidence, workflows and attribution are unchanged. Both author-stopped monitors remain paused.

## Checks

The revised source was built with the existing MiKTeX pdfLaTeX runtime, with automatic installation and shell execution disabled. The final two passes returned zero and produced a 24-page PDF. All pages were rendered for overview inspection; the changed passages and bibliography were also inspected at page scale. The built-in editor's compiler failed during platform-directory initialization, so its preview was not counted as successful compilation.

Between the first and second passes, all 111 displayed mathematical environments, 70 labels, 34 citation commands and 16 bibliography keys retain their normalized contents and order. No citation or mathematical display was added by the story revision. File hashes are listed in [SHA256SUMS](SHA256SUMS).

The author-requested review used Codex self-review and real supplementary same-session mathematical, Lean-source and editorial reviews. These are not represented as a full external independent audit. No Lean compiler, Aristotle, AXLE or new Pro request was launched for this manuscript pass.

## Suggested reading order

1. Abstract and introduction: whether the structural question and contribution are clear.
2. Section 10, especially Theorem 10.9 and Lemmas 10.15–10.16: exact domains, local partitions and the canonical-profile construction.
3. Formal verification and reproducibility: whether every qualification is visible and consistent with the audit.
4. The remainder of the paper: chronology, attribution, definitions and proof details outside the bounded second-pass audit still merit the author's full review.

The public and private packets are intended to be byte-identical. No private coordination directory, credentials or original private service logs are part of this export.
