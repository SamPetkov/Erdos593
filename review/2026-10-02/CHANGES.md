# Manuscript changes and comparison — updated 3 October 2026

## Literature and reader-staging pass — 3 October

| Passage | Prior form | Current revision |
| --- | --- | --- |
| Introduction | Finite versus uncountable contrast lacked historical lead-in | Adds Erdős1959 and Erdős–Lovász1975 before the unchanged modern F-free contrast |
| Result hierarchy | Finite consequences introduced in one dense paragraph | Adds a roadmap: canonical structure, numerical constraints, then attachment choices; points to the existing equal-parameter/four-versus-five example |
| Cardinal inputs | Exact imported statements already listed | Adds Erdős–Hajnal–Máté–Rado as background, not a replacement black box |
| Canonical decomposition | Structural graph proof | Adds bridge/biconnected algorithmic context with Tarjan references; no runtime certification claim |
| Partition-lattice story | Local products and profile recovery | Adds binary versus ternary-joint context and a properly qualified direct-factor comparison |
| Piece counts | Existing Stirling enumeration and profile comparison | Gives the counting convention a Comtet citation and separates Lieb's classical row results from our profile bounds |
| Formal verification | Cover extension accepted locally, delivery pending | Records merged public PR51 and distinguishes formal-statement review from external verified typechecking |

Both the inline bibliography and references.bib now contain 34 cited entries,
up from 23 in the immediately preceding source and 16 in the historical PDF.
There are 67 citation commands after the requested introduction expansion.
CITATION_REVIEW.md supplies primary provenance,
comparison notes and access limitations. No uncited entries were added.

All 119 existing displays, 45 theorem/definition statement bodies and 73 ordered
labels pass the preservation screen. The new explanatory binary/ternary-joint
observation is not called a newly accepted Lean theorem. The GATE comparison is
used for exposition standards, not to claim equal research impact or to cite
unrelated inference work. No chronology, authorship, hypothesis, numerical
diagnostic, Lean source or workflow was changed by this editorial pass.

The open TeX remains the current review source. The built-in compiler returned
the same platform-directory initialization failure after these edits, not a
successful PDF build. The unchanged PDF remains historical and current layout
is unverified. This follow-up updates only the public draft; no private PR55
update, monitor restart or manuscript merge is included.

## Author follow-up: finite mathematics beyond the classification

The introduction's two short roadmap paragraphs are replaced by a dedicated
overview of the paper's finite contribution. It defines the numerical parameters
and separates canonical types, exact feasibility/atom counts and connected
phase boundaries, profile-controlled lattice types and fixed-atom realization,
the connected positive-rank budget, and counts at each actual piece number.
The same-atoms four-versus-five example explains why assembly geometry is not
determined by cyclic concentration. Classical block, partition-lattice and
Stirling ingredients are cited without adding bibliography padding.

Reducedness, nonempty-edge scope and obligatoriness are explicit. Connected
phase/budget results are not extended to arbitrary disconnected systems, and
lattice/profile recovery is not presented as full system-isomorphism recovery.
The overview ends with the partial Lean boundary. CITATION_REVIEW.md gives the
paragraph-by-paragraph comparison; no proof or theorem statement was changed.

## New mathematical pass — 3 October

The clean revised version is the existing open TeX file, edited in place. Medium English academic editing was used for the connective introduction and new subsection; mathematics received a separate adversarial review. Existing citations, attribution, 111 displays, 43 mathematical statements and 70 labels are preserved. Two statements, eight displays and three labels are intentionally added, not described as unchanged mathematics.

| Passage | Previous version | Revised version | Reason |
| --- | --- | --- | --- |
| Rooted-abundance proof | The off-root part meets `S_v` “although both are subsets of A.” | Off-root vertices lie in `A`, contradicting `S_v ∩ A = ∅`. | `S_v` is not a subset of `A`; repair the supporting sentence without changing the valid proof route. |
| Trace fibre terminology | General fibres `J_s^+` are called expansion atoms. | They are expansion pieces. | `J_s` may be disconnected or have cut vertices; these need not be canonical indecomposable atoms. |
| Structural question in the introduction | Core constraints followed by a local-product description. | Adds the exact cyclic cost and prescribed-piece-number counts as their connection. | Explain how the new deductions advance the existing story rather than append unrelated facts. |
| After the lattice spectrum | Only a summary distinguishing numerical and lattice types. | Exact budget `N+C+L=s-2-q(beta)` and its positive-atom/slack bound. | Bring the already accepted deficit arithmetic into the manuscript; distinguish its still-unformalized lattice-rank packaging. |
| New counting corollary | Rank/count bounds were only proposals in review notes. | Original-piece-number generating polynomial, binomial/Stirling bounds, and exact equality profiles at every interior degree. | Give complete injections and strictness witnesses; avoid assuming the unfinished Lean cover theorem. |
| Sharpness wording | Potentially ambiguous simultaneous attainment. | Each extremal profile attains its corresponding bound at every piece number. | One assembly cannot attain both different interior bounds when `N>=2`. |
| Example | No concrete extremal assembly comparison. | `C4^+` plus two triples has four or five decomposition choices with the same atoms and parameters. | Make “rigid cyclic content, flexible assembly” testable and intelligible. |
| Verification | Separately validated piece checkpoint; deficit/new count scope not explicit. | Canonical/final piece acceptance stated; deficit arithmetic distinguished from lattice rank; new count proof explicitly not a Lean endpoint. | Prevent whole-paper or service-green acceptance overclaim. |
| AI-assistance disclosure | Says the author reviewed every incorporated suggestion. | Retains author responsibility but explicitly leaves new material subject to author review. | Agent checks are not an invented receipt of the author's completed review. |
| Date and PDF | Substantive journal revision dated 2 October, matching PDF. | Source dated 3 October; retained PDF explicitly labeled 2 October and stale. | Date real mathematical revisions, not polls; editor compiler cannot initialize and no separate PDF was authorized. |

Both monitors remain paused. This pass introduces no Lean/source/pin/cache/workflow change, compiler or proof-service request, external full audit, publication-readiness or novelty claim. See the current audit for the exact acceptance and remaining obligations.

The clean TeX contains the entire revised manuscript. This comparison identifies the substantive changed paragraphs; it is not an invitation to replace the author's concurrent working copy blindly. The academic-humanizer guidance was used for restrained English revision, while mathematical changes were separately checked against their source obligations. Equations, variables, labels, citations and attribution are preserved unless a correction is identified below.

## First-pass mathematical and coverage repairs retained

| Passage | Before | Revised | Reason |
| --- | --- | --- | --- |
| Imported results | The black-box list was unqualified. | The list is scoped to the classification proof; the later use of Komjáth's block reduction is explicitly credited. | Avoid an inaccurate provenance claim; no citation removed. |
| Theorem 10.9 opener | Systems ranged over fixed `s,beta` without an explicit feasible domain or nonempty-edge condition. | `beta=0,s>=2`, or `beta>=1,s>=2+q(beta)`, with at least one hyperedge. | An empty parameter class has no atom-count maximum. Displays (10.13)–(10.15) are unchanged. |
| Lemma 10.15 construction | Generated classes spanned subtrees that were then contracted independently. | Each shared-point star is replaced by a two-level tree. Atom-containing components after deleting central edges are vertex-disjoint; they are contracted with those edges restored. | Distinct classes can have overlapping subtrees in the original forest. The new proof checks no reconnection/repeated incidences and both inverses. |
| Lemma 10.16 transport | Incidence multiplicities and port counts led directly to the parameter conclusion. | An intervening paragraph proves closure and uses separating shared points plus supplied-atom indecomposability to identify the images as canonical blocks. | An auxiliary incidence pattern alone is not an actual canonical profile. |
| Verification section | All finite structural extensions were described as outside the Lean endpoints. | Accepted extensions are named with their hypotheses; open exact interfaces and the separately accepted but undelivered piece checkpoint are explicitly distinguished. | Correct a stale blanket exclusion without claiming whole-paper verification. |
| Bibliography and typesetting | `wang2026` was cited without an inline bibliography entry; four symbolic tags were not math-protected. | Existing verified Wang entry is included; symbolic tags receive math protection; a long final bibliography item receives page-break protection. | Citation completeness and successful rendering, no new research claim. |

## Second-pass paragraph comparisons

### Abstract

Before:

> We give an independent proof of the classification and determine its finite structural consequences. […] This decomposition gives exact finite parameter and atom-count spectra […] and an exact spectrum of one-point factorization lattices.

Revised:

> We give an independent proof of the classification and use its canonical decomposition to determine exact finite spectra. […] The cyclic ranks and core orders constrain the possible atom counts, while the attachment profile determines the one-point factorization lattice as a product of partition lattices.

The revision explains the relationship between the results, instead of only listing them. It retains the independent-proof wording and the explicit distinction between classification verification and extension coverage.

### Introduction after the chronology comparison

Before:

> Our approach supplies direct positive arguments, a separate fibre-decomposition proof for the negative direction, a canonical atom normal form, exact finite structural spectra, an exact one-point factorization-lattice spectrum, and a Lean formalisation of the finite classification.

Revised:

> The classification also raises a finite structural question: which features of an obligatory system are forced by its cyclic content, and which can vary through one-point assembly? The canonical atom normal form separates these two roles. The parameter and atom-count spectra quantify the constraints on the cores and the number of atoms. The local partition-lattice product then describes the freedom in assembling those atoms. We develop these consequences alongside direct positive and negative proofs of the classification and its Lean formalisation.

The chronology, Li comparison and citations immediately preceding this paragraph are untouched. This is a clearer statement of the existing programme, not a claim to a new classification.

### After the atom-count maximizer proof

Before: the proof ended with “proving the rigidity statement,” without an explicit qualification about numerical core uniqueness.

Added:

> The rigidity in the maximum concerns the distribution of cyclic rank: all positive rank lies in one minimum-order atom. It does not assert that the numerical parameters determine the graph-isomorphism type of that atom's core.

This prevents a stronger uniqueness reading than either the prose proof or accepted Lean theorem establishes.

### Phase-zone sentence

Before:

> Consequently the feasible connected parameters split into three exact zones.

Revised:

> Consequently, for `s>=3`, the feasible connected parameters split into three exact zones.

The functions used by the display are defined for `s>=3`; the single-triple case `s=2` remains separate. The displayed zones are unchanged.

### Structural-boundary corollary opener

Before:

> Let `F` be connected, reduced and obligatory, with shadow order `s`.

Revised:

> Let `F` be connected, reduced and obligatory, with shadow order `s` and `m=|E(F)|` hyperedges.

This locally binds the variable already used in all four clauses. Their conclusions are unchanged.

### Theta parity and extremal shadow transport

Before:

> The three resulting paths have the same parity, hence are all even. Equality in the cut-vertex estimate […] forces a balanced complete bipartite graph […] plus one leaf, which translates to the fourth assertion.

Revised:

> The three resulting paths have the same parity. Their total length is `s+1`, which is even, so all three paths are even. For the fourth assertion when `s>=5`, choose the shadow by assembling the canonical atom cores. Its cyclic blocks are precisely the nontrivial canonical cores. Equality in the cut-vertex estimate forces a balanced complete bipartite graph on `s-1` vertices plus one leaf, and hence the displayed complete-bipartite atom and one singleton atom. The tree cases `s=3,4` are immediate.

The parity inference now states the fact that excludes three odd paths. The core-shadow bridge is explicit and does not incorrectly describe `K_{1,2}^+` as one canonical atom in the small tree case.

### After the factorization-lattice spectrum

Before: the proof ended at recovery of the partition from characteristic-polynomial root multiplicities.

Added:

> The numerical and lattice spectra record different parts of the same decomposition. The shadow order, cyclic rank and component count restrict the possible excess `N=k-c`. For each allowed `N`, the attachment profile `lambda` determines the product of partition lattices, and every such profile is realizable. These assertions classify the available factorization-lattice types; they do not identify all systems with the same numerical parameters.

This connects the preceding results and explicitly limits the classification to lattice types. It does not claim that a profile determines the geometric assembly up to isomorphism.

## Preserved scope

No new numbered theorem, displayed equation, citation command, label or attribution statement was added in the second pass. The 111 displays, 70 labels, 34 citation commands and 16 bibliography entries retain their normalized contents and order relative to the first-pass revision. The date remains 2 October 2026. No proof-assistant source or accepted evidence was edited. Full external mathematical review and the remaining formal interfaces are still necessary.

## Journal-style and attribution follow-up

The clean manuscript incorporates the following bounded follow-up. The earlier comparisons above describe historical revisions, not the final reference count.

| Passage | Second-pass version | Journal revision | Reason |
| --- | --- | --- | --- |
| Presentation | AMS class, Times-style fonts, one-inch margins and environment page-space hooks. | Standard AMS/Latin Modern typography, 31-pica text width and 48-pica text height, broader abstract, natural page flow and unobtrusive links. | Restrained Annals-like presentation; the installed Annals class could not compile because a dependency was missing. No journal branding or publication metadata fabricated. |
| MSC 2020 | Primary 05C65; secondary 05C15, 05C63, 03E05. | Retain those codes; add 05C40 (connectivity) and 06A07 (combinatorics of partially ordered sets). | Cover the block structure and partition-lattice consequences actually treated. Codes are visible on the first page. |
| Preliminaries and block arguments | Standard graph facts and incidence terminology without local background references at every use. | Add Diestel (2017) and Whitney (1932); repeat Bahmanian–Šajna at the incidence/separation passages. | Credit standard tools without attributing the paper's classification or atom identification to these sources. |
| Local-product proof | “This is the bond-lattice product in the present block-forest setting.” | “For the related theory of connected set partitions and bond lattices, see Simon et al. and Stanley. The factors here are full partition lattices on the atoms through each shared point, not the bond lattice of the incidence forest itself.” | Prevent a false identification: the forest's bond lattice is Boolean, whereas the local factors can be larger partition lattices. The theorem and construction are unchanged. |
| Product rank and polynomial recovery | Standard rank and characteristic-polynomial formulas used without explicit background attribution. | Cite Stanley (2012), Rota (1964), and Stanley (2007) near the rank/product/Möbius and braid-arrangement formulas. | Distinguish standard lattice machinery from the manuscript's application and profile recovery. |
| Formal-verification opening | Lean source link without software/library scholarly citations. | Add de Moura–Ullrich (2021) and the mathlib Community (2020); explicitly say these do not certify this paper. | Attribute the actual prover/library without expanding the verified theorem scope. |
| AI disclosure | General list of assistance roles. | Name the Section 10 local forest/capacity review and the abstract incidence-forest Lean construction; keep author responsibility. | Location-specific, source-backed disclosure; no claim that Aristotle proved fixed-atom geometric realization. |
| Bibliography | 16 entries, with an incomplete journal-year assertion for Reiher. | 23 alphabetically ordered entries, all cited; Reiher identified by the verified 2024 arXiv version with the existing journal DOI retained. | Complete the seven new records from primary publisher/author sources; do not invent an unverified journal volume/page/year. |
| End matter | Separate no-funding and no-competing-interests sections. | Preserve both declarations in the acknowledgments paragraph. | Reduce administrative headings while preserving disclosure. |

The follow-up increases citation commands from 34 to 51. All 23 bibliography keys occur in the text and match the editable BibTeX file. All 111 mathematical displays and 43 mathematical statements preserve content; only one existing textual condition is line-wrapped within its display. All 70 labels retain their order. No new Lean validation, theorem, novelty or journal-acceptance claim is introduced. The academic-humanizer skill informed restrained prose and this comparison; it did not certify mathematics.
