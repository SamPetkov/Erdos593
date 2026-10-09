# Erdős 593 manuscript review — front matter, story and references, 4 October 2026

## Current entropy and density review 9 October 2026

The [current PDF](erdos593_obligatory_triple_systems.pdf) is a fresh 57-page build
of the in-place [manuscript](erdos593_obligatory_triple_systems.tex), with
44 cited references numbered by first appearance. Six directly relevant sources
were added, including the recent Im–Li–Liu subdivision comparison.

The new quantitative section states exact restricted entropy and common-power
density results. Full Gibbs-fitting, marginal-correction and weighted-cone proofs
are in Appendix B. The original classification and finite-result mathematical
body, its 74 existing labels, Appendix A and attribution are preserved.
The three-colour example illustrates explicit entropy-budget transfer on a graph
with already known entropy existence. Both unrestricted questions remain open.

Read the two detailed adversarial source reviews in
[the research packet](../2026-10-09-entropy-density/README.md), along with the
[paragraph comparison](../2026-10-09-entropy-density/public-review-round2-20261009/editorial-comparison.json)
and [static QA](../2026-10-09-entropy-density/public-review-round2-20261009/static-qa.json).
Their conclusion is a scoped analytical review draft, not a full external audit,
novelty clearance, B-level result or complete Lean formalization.
The new entropy/density arguments have no accepted Lean implementation.

Three installed MiKTeX pdfLaTeX runs returned zero, with automatic installation
and shell execution disabled. The final build has no unresolved references or
citations, rerun requests, overfull or underfull boxes; the expected disabled-shell
warning is retained. All 57 pages were rendered and checked, with selected pages
inspected at full page scale. The built-in editor compiler's Windows-path
initialization failure remains a separate platform limitation, not a successful build.

Source SHA256: `21bfa389a60599829b1a674d5d0b413ea18275146570427c873ef2c5cc4a6326`.
PDF SHA256: `c549243bd742bbdb7398c57f2780f24a61a8bd28d3ce5237bf42999b3b6f5359`.
BibTeX SHA256: `b2079ec8a672115f532d33ad5baec73e12a597276601a17b735be647e825e0ae`.

Public-only development continues in scoped draft PRs. Accepted Lean source,
pins and workflows remain unchanged; both stopped monitors remain paused.
The dated sections below are historical where their counts or PDF differ.

## Current review version — 4 October 2026

Read the [current PDF](erdos593_obligatory_triple_systems.pdf) and matching
[open-document source](erdos593_obligatory_triple_systems.tex). This is a fresh
42-page build, not the historical 16-reference PDF. The bibliography now has
**38 cited references**, numbered by **first appearance**, with 72 citation
commands and a synchronized [BibTeX file](references.bib).

The date sits beneath the author; MSC codes and keywords follow the abstract,
rather than appearing in footnotes below the first theorem. The abstract and
introduction foreground the finite spectra, fixed-atom profile freedom, cyclic
budget and sharp actual-piece counts beyond the classification. Their exact
finite, connected-positive-rank and interior-equality restrictions are retained.

Only implementation, exported interfaces and validation provenance have moved
to Appendix A. The canonical structure, spectra, profile realization and
counting proofs remain in the main text. All 119 displays, 45 mathematical
statement bodies and 43 proof environments are unchanged from the previous
public review source. All 73 old labels remain, with one new appendix label.
[CITATION_REVIEW.md](CITATION_REVIEW.md) gives paragraph comparisons and primary
provenance for the four new references.

Three serial passes of the existing MiKTeX pdfLaTeX returned zero; installation
and shell execution were disabled. Reference states agree, all 42 pages were
rendered and checked, and there are no unresolved citations/references, rerun
requests, overfull/underfull boxes or TeX errors. The expected disabled-shell
warning is retained. The built-in editor still fails at platform initialization;
the successful native build is recorded separately, not attributed to it.

Source SHA256: `7a6416962c4b17791114209714b37377878e700c4988fbfc78fefd4e0f96cf08`.
PDF SHA256: `5e5ce1df94e4fc4abe22aed652bf957d7b0c33294b202b110db783d5060f160b`.

This is an editorial and source-based review, not new Lean acceptance, a full
external audit or a journal-readiness claim. Whole-manuscript formalization is
still incomplete. Accepted proof source, pins and workflows are unchanged.
Development is **public-only** and both stopped monitors remain paused. Earlier
dated sections below are historical where their counts, formatting or PDF differ.

## Current source and PDF — 3 October 2026

Read the saved TeX source, matching references.bib and [citation review](CITATION_REVIEW.md).
The source now has 34 references and 67 citation commands, with every entry cited.
Eleven additions support the finite/uncountable contrast, classical graph
decomposition, partition-lattice factors and formal-verification scope. An early
overview after the classification explains the finite results beyond solving
Problem 593: canonical atoms, exact numerical spectra and phase boundaries,
profile-controlled lattice types, cyclic costs, and sharp counts by actual
piece number. It distinguishes manuscript proofs from accepted Lean interfaces.
The GATE benchmark informs exposition standards, not claims of equivalent impact.

The accepted supported-cover/piece-deficit/cover-increment block is now on
[public main via PR51](https://github.com/SamPetkov/Erdos593/pull/51): 250 modules,
401 ordered standard-only audits. The final harmonization checked 258 accepted
source files and 73 shared status/evidence files byte-identical in the two repositories.
**All further development is public-only.** No private manuscript PR was updated.

The existing 119 displays, 45 statement bodies and 73 ordered labels remain unchanged
under the bounded source screen; proof prose and citation relevance were reviewed
separately. This is not full mathematical or Lean certification. Maximal flags,
height, fixed-atom realization and other remaining interfaces are not promoted
by an editorial revision.

The accompanying [PDF](erdos593_obligatory_triple_systems.pdf) is now a fresh
40-page build of the exact saved 3 October source, with all 34 references.
Three serial passes of the existing MiKTeX pdfLaTeX returned zero; automatic
package installation and shell execution were disabled. The last two reference
states agree. There are no unresolved references/citations, rerun requests,
overfull/underfull boxes or TeX errors. The expected shell-escape-disabled
warning is retained. All 40 pages were rendered and visually checked, including
page-scale checks of the introduction, local-product proof, new budget/counting
passages, verification boundary and bibliography. PDF SHA256:
`e8dbf2cfa64fe2525ebd1203f277b5d6b39a49124cb343860a7edcffed52a144`.
The source SHA256 is
`ae148bd6c2c0c5a49ec9018615a69c614b3693b57b3691ea8fc83b481bde9d68`.

The built-in editor's initialization failure remains a separate platform
limitation; it is not described as successful compilation. This local native
build required no installation and changed no mathematical source. The earlier
2 October PDF is preserved locally and in Git history, not presented as current.
Both stopped monitors remain paused. The earlier pass records below are historical
where their counts, delivery, PDF or future-private workflow differ.

Start with the revised [PDF](erdos593_obligatory_triple_systems.pdf), [TeX source](erdos593_obligatory_triple_systems.tex), [change comparison](CHANGES.md) and [mathematics and Lean audit](AUDIT.md). [references.bib](references.bib) remains synchronized with the source's inline bibliography. A clean PDF build verifies typesetting, not completion of the extended manuscript's Lean coverage or a full external mathematical audit.

## Latest bounded pass — 3 October

The manuscript now connects the accepted cyclic-deficit identity with the assembly budget and gives sharp counts of decompositions at every prescribed original-edge piece number. Two explicit anchor injections prove the bounds and their interior equality cases. A fixed-atom example illustrates why extremal cyclic concentration does not determine assembly choices. These are reviewed manuscript deductions, not two newly accepted Lean endpoints or research-priority claims.

The pass also corrects a false set-inclusion sentence in the rooted-abundance proof and distinguishes general expansion pieces from canonical atoms in the trace theorem. All 111 earlier displays and 43 earlier statements remain in order and mathematically unchanged. Totals are now 119 displays, 45 statements and 73 labels. The 23 references remain cited; citation commands total 53. The revision date advances because new mathematical exposition was actually incorporated.

The Lean audit confirms canonical and final acceptance of actual-piece accounting (246 modules/383 audits) but pending source delivery; recorded merged mains retain 245/379. A read-only comparison verified all 566 retained original/dispatch/retrieval Git blobs. No Lean compiler, proof service or scheduler job was launched and neither stopped monitor was resumed. Genuine grading, actual fixed-atom geometry, componentwise/full lattice spectra and other exact interfaces remain open.

## Earlier passes — 2 October

The first two bounded passes repair the feasible domain of the connected atom-count theorem, replace an invalid overlapping-subtree contraction with a vertex-disjoint auxiliary-forest argument, and make canonical-atom preservation in the capacity construction explicit. The second pass clarifies the phase domain, binds the edge-count variable, handles the small tree boundary cases separately, and explains theta parity. The abstract and introduction connect the results through one question: what is constrained by cyclic content, and what can vary through assembly?

The journal-style pass uses restrained AMS typography with Annals-like text dimensions, visible MSC 2020 codes and an alphabetical bibliography. References increase from 16 to 23, and in-text citation commands from 34 to 51. Added sources support graph-block background, partition-lattice rank and characteristic polynomials, and Lean/Mathlib. The proof now distinguishes local partition-lattice factors from the bond lattice of the incidence forest. The disclosure names the recorded locations of AI assistance. None of these changes adds a theorem or proves a remaining formal interface.

The formal-verification section distinguishes accepted Lean results from remaining interfaces. Those earlier passes inserted no numbered theorem or novelty claim; the two reviewed deductions added on 3 October are documented separately above.

## Review boundary

The deliverable is a complete manuscript plus a source-backed review, not a claim that every statement is formalized or that the paper is ready for publication. The classification is verified. Several extensions are also accepted, but grading, fixed-atom realization and other exact interfaces remain open; see the audit.

This packet is deliberately separate from the repository's root publication files and the existing draft PR stack. Adding it does not promote every manuscript statement to the accepted Lean tree. Accepted proof source, toolchain pins, proof evidence, workflows and attribution are unchanged. Both author-stopped monitors remain paused.

## Historical PDF checks — 2 October only

The revised source was built with the existing MiKTeX pdfLaTeX runtime, with automatic installation and shell execution disabled. The final two passes returned zero and produced a 35-page A4 PDF. All pages were rendered for overview inspection; the title, changed passages and bibliography were also inspected at page scale. There are no unresolved references/citations or overfull/underfull boxes. The harmless shell-escape-disabled warning is retained. The installed `aomart` class lacks `zref-savepos`, so the deliverable uses the standard `amsart` class rather than installing dependencies. It carries no Annals banner, publication DOI or acceptance claim. The earlier built-in editor initialization failure is not counted as successful compilation.

Against the second-pass source, all 111 displayed mathematical environments, 70 labels and 43 theorem/lemma/proposition/corollary/claim/definition statements retain their mathematical contents and order. One existing prose condition inside a display is wrapped over two lines to fit the narrower measure; no equation is added. All 23 references are cited and have matching inline/BibTeX keys. Citation additions and bibliography reordering are intentional. File hashes are listed in [SHA256SUMS](SHA256SUMS).

The earlier author-requested review used Codex self-review and real supplementary same-session mathematical, Lean-source and editorial reviews. The journal-style follow-up is Codex self-review only. Neither is represented as a full external independent audit. No Lean compiler, Aristotle, AXLE or new Pro request was launched for this manuscript pass.

## Suggested reading order

1. Introduction and the new “Cyclic costs and assembly freedom” subsection: whether the constraints and remaining choices form a coherent story.
2. Section 10, especially Theorem 10.9 and Lemmas 10.15–10.16: exact domains, local partitions and the canonical-profile construction.
3. Formal verification and reproducibility: whether every qualification is visible and consistent with the audit.
4. The remainder of the paper: chronology, attribution, definitions and proof details outside the bounded second-pass audit still merit the author's full review.

The earlier mirrored-packet workflow is superseded by the author's public-only
instruction. This follow-up updates only the public review packet. No private
coordination directory, credentials or original private service logs are exported.
