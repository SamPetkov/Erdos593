# Manuscript changes and comparison — 2 October 2026

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
