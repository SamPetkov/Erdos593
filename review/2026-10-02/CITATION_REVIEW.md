# Literature and exposition review — 3 October 2026

This is an author-review draft. It is not a whole-paper mathematical certificate,
an external audit, a novelty judgment or a prediction of journal acceptance.
Further repository development is public-only; both stopped monitors stay paused.

## Bounded brief and evidence standard

Improve the existing manuscript's explanation of obligatory systems, cyclic
constraints and assembly freedom. Add references only where a specific paragraph
needs historical attribution, terminology or comparison. Preserve the
classification's chronology, equations, hypotheses, original-edge interpretation,
author attribution and honest Lean-coverage boundary. Distinguish a contextual
citation from a theorem imported as a proof input. No new proof-service request,
installation, broad research programme or numerical result is involved in this
literature pass.

The live source previously contained 23 references, not the 16 in the retained
2 October PDF. This pass adds 11 substantive references, bringing both the inline
bibliography and matching BibTeX file to **34 entries**, all cited in the text.
There are **67 citation commands** after the requested introduction expansion.
Static checks found no missing, uncited or
duplicate keys. Reference count is not a quality or impact measure.

## Expanded contribution overview — author follow-up

The introduction now contains a dedicated **Finite structure beyond the
classification** overview after the classification and Li chronology. This is
source-grounded exposition of existing manuscript results, not a new theorem or
an additional claim of Lean acceptance. Medium scholarly editing preserves the
classification's attribution and the exact hypotheses of each result group.

| Original introduction | Revised passage | Claim-scope check |
| --- | --- | --- |
| Two compact paragraphs listed structure, constraints and choices | Defines reduced obligatory systems, positive edge count, n, m, c, s and Levi cycle rank before discussing the finite results | Reducedness is no isolated vertices, not a synonym for nonempty edges; both conditions are retained separately |
| Normal form and numerical spectra were mentioned generically | Explains the admissible atoms, exact parameter and atom-count spectra, rank-one parity, connected phase diagram and structural equality forms | Classical block theory is credited; the phase diagram explicitly requires connectedness and does not imply uniqueness of every core |
| The local product was only a roadmap pointer | Explains actual original-edge decompositions, local partition factors, rank N=k-c, fixed-atom every-profile realization and profile recovery from lattice type | These are the existing manuscript statements under reduced obligatory/nonempty-edge scope, not all-system isomorphism classification or fully accepted Lean realization |
| The deficit identity was described as a cost | Explains the connected positive-rank budget and how splitting cyclic rank or surplus core order consumes available assembly rank | Does not extend the budget to zero rank or assert a metric stability theorem |
| Prescribed-piece bounds were named without their content | Gives the actual d_j bounds, binary/common-joint interior equality profiles and same-atoms four-versus-five example | Counts nonempty original-edge pieces; N=0 and N=1 retain the corollary's separate boundary conventions |
| Partial formalization was a short pointer | Identifies unfinished profile/lattice/maximal-chain/height/counting interfaces immediately beside the result overview | No editorial revision is presented as kernel acceptance, complete formalization or a full external audit |

Whitney/Diestel, Stanley and Comtet are cited beside the corresponding classical
ingredients in the overview. No new bibliography key or novelty/priority claim
is introduced. The clean revision is the existing open TeX, not a replacement
document. All 119 display environments, 45 mathematical statement bodies and
73 ordered labels remain fixed under the bounded structural screen. The editor
compiler was called after these edits and again failed at initialization.
The later native build described below supersedes the earlier PDF/layout
limitation without changing this source or its mathematical contents.

## Paragraph-by-paragraph comparison and provenance

| Passage | Earlier version | Clean revision and purpose | Primary evidence |
| --- | --- | --- | --- |
| Finite versus uncountable hosts | The precise modern F-free contrast, but little historical context | Places finite high-girth/high-chromatic constructions before the unchanged Wang et al. contrast; does not turn a finite theorem into an uncountable one | Erdős, *Graph theory and probability* (1959), pp.35–37, [publisher paper](https://www.cambridge.org/core/services/aop-cambridge-core/content/view/S0008414X00002947); Erdős–Lovász (1975), Theorem1′, [author paper](https://www.renyi.hu/~p_erdos/1975-34.pdf) |
| Imported cardinal inputs | Three exact black-box statements listed | Adds a general partition-calculus reference while retaining the same exact black-box list | Erdős–Hajnal–Máté–Rado, *Combinatorial Set Theory: Partition Relations for Cardinals* (1984), [publisher](https://shop.elsevier.com/books/combinatorial-set-theory-partition-relations-for-cardinals/erdos/978-0-444-86157-3), [actual title page and contents](https://api.pageplace.de/preview/DT0400.9780444537454_A34352306/preview-9780444537454_A34352306.pdf) |
| Canonical normal form | Structural bridge/block proof | Explains that the two finite graph primitives have classical algorithmic counterparts; does not claim a verified runtime for our Lean development | Tarjan (1972), [SIAM publisher](https://epubs.siam.org/doi/abs/10.1137/0201010); Tarjan (1974), [author report](https://www2.eecs.berkeley.edu/Pubs/TechRpts/1974/Archive/ERL-m-427.pdf), [journal metadata](https://collaborate.princeton.edu/en/publications/a-note-on-finding-the-bridges-of-a-graph/) |
| Full local partition factors | Distinguishes the factors from the forest's bond lattice | Adds the concrete binary-chain/ternary-diamond distinction to explain why attachment multiplicity changes lattice structure | Grätzer, *Lattice Theory: Foundation* (2011), ChapterII, Theorem101, [publisher chapter](https://link.springer.com/chapter/10.1007/978-3-0348-0018-1_2) |
| Profile recovery | Root multiplicities recover the profile | Places the explicit argument beside classical indecomposable-factor theory; leaves the root-multiplicity proof intact | Schmitt (1994), Lemma6.1 in its stated incidence-poset setting, [actual preprint](https://sites.math.washington.edu/~billey/classes/Hopf.algebra/bulletins/schmitt.1994.pdf), [publisher](https://www.sciencedirect.com/science/article/pii/0022404994901058) |
| Piece-number counts | Stirling notation used without a nearby convention reference | States the nonempty-block and empty-set conventions outside the unchanged corollary | Comtet, *Advanced Combinatorics* (1974), Section5.1, [publisher chapter](https://link.springer.com/chapter/10.1007/978-94-010-2196-8_5) |
| Structural meaning of coefficient bounds | Elementary injections and illustrative two-profile example | Separates classical Stirling-row concavity/generating functions from comparisons between attachment profiles | Lieb (1968), [publisher article](https://www.sciencedirect.com/science/article/pii/S0021980068800572), [author institutional record](https://collaborate.princeton.edu/en/publications/concavity-properties-and-a-generating-function-for-stirling-numbers/) |
| Formal-verification scope | Lean and Mathlib references, acceptance boundary | Separates theorem/formulation review from verified typechecking; does not assert use of an external checker | Avigad–Harrison (2014), [author page and paper](https://www.cl.cam.ac.uk/~jrh13/papers/cacm.html); Carneiro, *Lean4Lean*, [specific v3](https://arxiv.org/abs/2403.14064v3) |
| Accepted cover extension | Canonical/final accepted, GitHub delivery pending | Updates only the verified delivery status to public PR51; maximal flags/height and fixed-atom realization remain separately pending | [Merged public cover/grading PR51](https://github.com/SamPetkov/Erdos593/pull/51), pinned canonical66570/final66573 acceptance, exact merged-Git reconciliation |

The scholarly-editing review used the academic-humanizer procedure: clean source
plus these comparisons, preserving mathematical meaning rather than substituting
decorative claims. A read-only Zotero check found no relevant additional library
item; no reference was imported into or changed in the user's library.

## Source-check limitations

The graph papers' relevant passages and the Erdős–Hajnal–Máté–Rado title page
were read from primary sources. Separate source reviewers read the actual
Comtet and Grätzer publisher previews and Schmitt's complete Lemma6.1 passage;
the Schmitt PDF required visual reading because its extracted text is corrupt.
Lieb's attribution uses the primary publisher abstract/issue and the author's
institutional metadata, not an invented theorem number or a claim of having
read an inaccessible full article. Some later root fetches of Springer preview
and ScienceDirect URLs failed; those failures are not described as successful
full-text readings. Tarjan1972's publisher abstract supports the algorithmic
context; Tarjan1974's full report supports the bridge-component distinction.
The 1975 Erdős–Lovász series volume is10, as printed on its first page.

Menger, Turán, Hashimoto, Ore and Berge were investigated but are not added in
this pass: source-access or edition limitations made them less useful than the
already verified support. No references to unrelated inference research are
inserted merely to borrow prestige. The GATE review corpus is an exposition
benchmark, not mathematical evidence for this paper.

The statement/display preservation screen checks the119 existing displays,
45 theorem/definition statement bodies and73 ordered labels. It does not
certify all proof prose, inline mathematics, citations or novelty. Those require
the accompanying source-based review. The ternary diamond observation is an
elementary consequence of the existing local product description, not a new
kernel-accepted Boolean/distributivity theorem. Lieb is not used to claim that
our full coefficient polynomial is already formally proved real-rooted or
log-concave. Schmitt's lemma is not quoted without its family hypotheses.

The built-in compiler was called on the existing open TeX after the citation
edits and returned `Unable to find standard directories for platform`. It gave
no TeX syntax diagnostic and produced no PDF. This platform limitation remains;
it is not relabeled a successful editor build.

The author's subsequent request for a current local PDF authorized a native
build of the exact same saved source. Three serial passes of the existing MiKTeX
pdfLaTeX returned zero with package installation and shell execution disabled.
The current 40-page PDF contains bibliography entries [1] through [34], the
3 October date and MSC codes, and no unresolved references/citations, rerun
requests, overfull/underfull boxes or TeX errors. The last two reference states
agree. All pages were rendered and visually checked; key introduction, proof,
new-result, verification and bibliography pages were also checked at page scale.
The expected shell-escape-disabled warning is retained. The exact PDF SHA256 is
`e8dbf2cfa64fe2525ebd1203f277b5d6b39a49124cb343860a7edcffed52a144`;
its source remains `ae148bd6c2c0c5a49ec9018615a69c614b3693b57b3691ea8fc83b481bde9d68`.
No TeX installation, source replacement, mathematical revision or Lean replay
was needed. The old 16-reference PDF is preserved locally and in Git history.
Successful typesetting does not supply missing Lean proofs or a full external
mathematical audit. The existing source/editor remains open and current.
