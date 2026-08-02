# Erdős 593: AMS mathematical writing and style audit

## Scope

This audit checks the publication manuscript against the writing and manuscript-preparation conventions used by the American Mathematical Society.  It is narrower than the theorem-by-theorem audit in PR #32: no theorem, proof strategy, attribution boundary, or formalisation endpoint is changed here.

The comparison basis is:

- the AMS journal Author Resource Center and journal submission instructions;
- the AMS `amsart` article structure and front-matter conventions;
- Leonard Gillman, *Writing Mathematics Well: A Manual for Authors*, especially the chapters on organisation, stating results before proving them, keeping the reader informed, definitions, the grammar of symbols, notation, and numbering;
- current AMS journal practice for Mathematics Subject Classification, abstracts, references, theorem environments, and author metadata.

Journal-specific limits differ.  For example, Communications of the AMS requires an abstract of at most 150 words, while some AMS journals permit up to 300 words.  The conservative publication target adopted here is therefore a self-contained abstract of at most 150 words, with no citations, footnotes, numbered equations, or displayed formula.

## Overall verdict

**MATHEMATICALLY WELL WRITTEN, BUT NOT YET AMS-SUBMISSION CLEAN.**

The manuscript already has a sound mathematical architecture and uses `amsart`, standard theorem environments, a 2020 Mathematics Subject Classification, keywords, labels, cross-references, and complete proofs.  The principal remaining AMS-style work concerns:

1. front matter and author metadata;
2. the abstract;
3. theorem and display punctuation;
4. paragraph structure and the grammar of symbols;
5. reference-list normalisation;
6. removal of preprint-specific layout machinery from an AMS submission branch;
7. consolidation of the formalisation and disclosure material.

The changes below are editorial.  They do not alter the classification or the finite parameter results.

---

## 1. Front matter

### Current strengths

- The manuscript uses `amsart`.
- A short title is supplied.
- The 2020 MSC and keywords are present.
- The abstract precedes `\maketitle`, as required by `amsart`.

### Required changes

#### 1.1 Remove the author-supplied date

The current source contains

```tex
\date{24 July 2026}
```

An AMS journal article should not use an author-selected publication date in the title block.  Receipt, revision, acceptance, and publication dates are production metadata.  Delete this command from the submission source.

#### 1.2 Add the author address and email

The source currently ends without `\address` or `\email`.  Add

```tex
\address{École normale supérieure--PSL, 45 rue d'Ulm, 75005 Paris, France}
\email{samuil.petkov@ens.psl.eu}
```

These commands belong in the preamble and are typeset by `amsart` at the end of the article.

#### 1.3 Use an informative title

`Obligatory Triple Systems: An Alternative Proof` is accurate but generic.  It does not advertise the bridge decomposition or the exact finite spectra, which are the manuscript's distinguishing contributions.

Recommended title:

```tex
\title[Obligatory triple systems]
  {Obligatory Triple Systems: Bridge Decompositions and Exact Finite Spectra}
```

A conservative alternative is `Obligatory Triple Systems: An Alternative Proof and Exact Finite Spectra`.

#### 1.4 Number the introduction

The current introduction is an unnumbered section.  Numbering it as Section 1 gives the reader a conventional AMS article structure and avoids a theorem-numbering jump from an unnumbered introduction directly to Section 1 preliminaries.

Use

```tex
\section{Introduction}\label{introduction}
```

and renumber the later sections automatically.

---

## 2. Abstract

### Current strengths

- The abstract states the classification, the constructive form, the proof mechanisms, the finite spectrum, and the formalisation.
- It contains no citation or footnote.

### Required changes

#### 2.1 Remove displayed mathematics

The exact order--size--component interval is important, but a displayed formula interrupts a short abstract and is unnecessary for indexing.  Write the formula inline or state the spectrum qualitatively.

#### 2.2 Keep the abstract below 150 words

The conservative AMS-compatible version in

```text
reader-first/AMS_COMPLIANT_FRONT_MATTER.tex
```

is below 150 words after TeX commands are removed.

#### 2.3 Replace compressed nominal prose

The phrase

> incidence of every hyperedge-node of the Levi graph with a bridge

should be replaced by the grammatical clause

> every hyperedge-node of the Levi graph is incident with a bridge.

Likewise, replace `deletes selected Levi-graph bridges` by `deletes all Levi-graph bridges`, which is both more precise and easier to read.

#### 2.4 Avoid novelty labels inside the abstract

`As a new finite consequence` is unnecessary.  State the result directly.  Priority and relation to earlier work belong in the introduction.

---

## 3. Introduction and organisation

The AMS writing principle `state first, prove second` is already mostly respected: Theorem A appears near the beginning.  The introduction can nevertheless be made more linear.

### Recommended order

1. define obligatoriness and state the problem;
2. define `J^+`, `F^\circ`, and `\mathcal B`;
3. state Theorem A;
4. give one paragraph on prior work and attribution;
5. give the three-part proof map;
6. state the finite spectrum contribution;
7. describe the organisation of the paper.

### Required changes

#### 3.1 Make isomorphism closure explicit

Immediately after defining `\mathcal B`, add:

```tex
Membership in $\mathcal B$ is understood up to triple-system isomorphism.
```

This aligns the prose with the Lean `ofIso` constructor and with ordinary structural usage.

#### 3.2 Replace `two stories` by the exact logical decomposition

The proof has three parts, not two:

```tex
\[
\mathcal B\Longrightarrow\text{obligatory},\qquad
\mathcal B\Longleftrightarrow\text{intrinsic},\qquad
\neg\text{intrinsic}\Longrightarrow\neg\text{obligatory}.
\]
```

The finite structural equivalence deserves its own place between the positive and negative infinitary arguments.

#### 3.3 Shorten chronology in the mathematical narrative

The exact public dates and commit chronology should remain in `PROVENANCE.md` and the repository README.  In the article, use one concise attribution paragraph and point-of-use citations.  The introduction should explain mathematical dependence, not repository history.

#### 3.4 Move the detailed black-box inventory

The list of de Bruijn--Erdős, Erdős--Hajnal, and Erdős--Rado inputs is useful, but it interrupts the introduction.  Move the detailed locators to the preliminaries or a short `External inputs` paragraph after the definitions.

---

## 4. Definitions and mathematical English

### Required changes

#### 4.1 Break the opening preliminaries into shorter paragraphs

The current preliminaries introduce triple systems, colourings, embeddings, obligatoriness, isolated reduction, linearity, Levi graphs, bridges, and Berge cycles in two very long paragraphs.  Split them into four units:

1. triple systems and weak colourings;
2. embeddings, obligatoriness, and isolated reduction;
3. incidence geometry and Berge cycles;
4. expansion and amalgamation operations.

Each definition should be a complete sentence, and each paragraph should introduce one conceptual group.

#### 4.2 State the weak-colouring convention

On first use, write:

```tex
Throughout, chromatic number means weak vertex chromatic number: a colouring is
proper when no hyperedge is monochromatic.
```

This prevents confusion with strong or rainbow hypergraph colourings.

#### 4.3 Clarify Berge-cycle length

State that a Berge cycle of length `\ell` has `\ell` hyperedges and corresponds to a Levi cycle of length `2\ell`.  The word `even` then unambiguously refers to the Berge length.

#### 4.4 Use words where symbols would not form grammatical prose

Reserve `\Longleftrightarrow` and `\iff` for displayed equivalences.  In running prose, write `if and only if`.  Do not begin a sentence with a bare symbol or formula when a noun phrase is available.

#### 4.5 Use `\colon` for maps

Use

```tex
c\colon V(H)\to\lambda,
\qquad
f\colon V(F)\to V(H)
```

rather than a relation colon.  This is standard mathematical typography and makes function declarations visually consistent.

#### 4.6 Use `\operatorname` for named operators

Named operators introduced in mathematics mode should use `\operatorname{...}` or a declared operator, rather than italic letter strings.

---

## 5. Theorem statements and proofs

### Required changes

#### 5.1 Theorem statements must be complete sentences

Replace

```tex
For every finite triple system $F$, the following are equivalent:
```

by

```tex
For every finite triple system $F$, the following assertions are equivalent.
```

Punctuate every enumerated assertion, with a period after the final item.

#### 5.2 Punctuate displayed mathematics as part of the sentence

A display does not suspend grammar.  If a display ends a sentence, place a period after the displayed expression; if the sentence continues, use a comma or semicolon as appropriate.

The final integration should inspect every display, especially displays inside theorem statements and multi-line calculations.

#### 5.3 Remove decorative boxes from theorem statements

The `\boxed{...}` expressions in the fixed-order spectrum and related statements are visually heavy and not needed in an AMS article.  The theorem environment already provides emphasis.

#### 5.4 Number only equations that are cited

Keep equation numbers only when the equation is referenced later.  Use `equation`, `align`, or `gather` with `\label` and `\eqref`; avoid manual `\tag` where automatic numbering is sufficient.

#### 5.5 Replace generated list artefacts

The source contains Pandoc-style fragments such as

```tex
\def\labelenumi{\arabic{enumi}.}
\tightlist
```

Use ordinary `enumerate` environments.  These artefacts are not wrong, but they make the source look generated rather than edited and complicate AMS production.

#### 5.6 Cite reasons at the point of inference

The strongest proofs already do this.  Retain the pattern

> Since ..., it follows that ...

rather than `clearly`, `obviously`, or `immediately` when a nontrivial graph- or cardinal-theoretic step is involved.

---

## 6. Notation and consistency

### Required changes

- Use `hyperedge-node` and `point-node` consistently as compound modifiers.
- Use `one-point amalgamation` as a noun and `one-point-amalgamation order` only when the entire phrase modifies another noun.
- Choose either `base fibre` or `base-fibre` under the same grammatical rule; do not alternate freely.
- Use `order--size--component` with an en dash in compound mathematical labels.
- Introduce `cycle rank (cyclomatic number)` on first use, then use one term consistently.
- Define `order`, `size`, and connectedness at the beginning of the finite-parameter section.
- Keep `point` for hypergraph vertices and `vertex` for ordinary graph vertices when both objects occur in one argument.

### Spelling

The manuscript currently uses British spellings such as `colouring` and `formalisation`.  AMS production commonly normalises to American journal spelling, but mathematical correctness does not depend on this choice.  The source must at least be internally consistent.  For a direct AMS submission, the cleanest choice is to use `coloring`, `formalization`, `characterization`, and `realizes` throughout; a global conversion should be made in one mechanical pass, not piecemeal.

---

## 7. Bibliography

### Required changes

#### 7.1 Use one AMS-compatible bibliography system

Prefer `amsrefs`, or BibTeX with an AMS-compatible style.  Do not combine generated `natbib` boilerplate with hand-edited entries unless the output is checked carefully.

#### 7.2 Alphabetise the reference list

For a numbered mathematical bibliography, order entries alphabetically by author rather than by first citation.

#### 7.3 Use standard journal abbreviations

Examples:

- `Proc. Amer. Math. Soc.`;
- `Acta Math. Hungar.`;
- `Bull. Amer. Math. Soc.`;
- `Nederl. Akad. Wetensch. Proc. Ser. A`.

The current reference list alternates between full journal names and abbreviations.

#### 7.4 Give complete published metadata

For published articles, include author, title, standard journal abbreviation, volume, year, issue when useful, page range or article number, and DOI.  Do not leave a published article as only `journal, year` when volume and pages are available.

#### 7.5 Avoid duplicate identifiers

For an arXiv preprint, one stable arXiv identifier or DOI is enough.  Avoid listing a DOI, a raw arXiv URL, and a separate `arXiv:` line unless the target journal explicitly requests all three.

#### 7.6 Use sentence case for article titles

Protect only proper nouns, abbreviations, and symbols with braces.

---

## 8. TeX source and submission layout

The current preprint source uses `geometry`, custom Times-like fonts, `needspace`, `enumitem`, extensive theorem-spacing hooks, and manual tolerance settings.  These choices can be useful for an arXiv PDF, but they should not define the AMS submission source.

Create a clean submission branch with:

- `\documentclass[11pt,reqno]{amsart}`;
- only mathematically necessary packages;
- no custom margins or fonts;
- no theorem-spacing hooks;
- no `\raggedbottom`, manual tolerance settings, or PDF-producer metadata unless needed;
- no self-modifying build workflow.

Keep the designed preprint PDF as a separate generated artefact if desired.

---

## 9. Formalisation, acknowledgments, and disclosures

### Required changes

#### 9.1 Compress formalisation chronology

The article should state the exact Lean endpoints, the ambient-universe convention, and the difference between the written and formal odd-cycle routes.  Detailed commit chronology belongs in the repository provenance file.

#### 9.2 Consolidate back matter

The separate unnumbered sections `AI assistance`, `Funding`, and `Competing interests` are not the usual shape of a short AMS mathematics article.  Unless the target journal requires separate headings, use:

- `Acknowledgments` for mathematical and editorial thanks;
- one concise `Disclosure` paragraph covering computational/AI assistance, funding, and competing interests.

#### 9.3 Keep responsibility language direct

Retain the statement that the author reviewed all incorporated suggestions and is responsible for the arguments and citations.  Do not describe automated checks as replacing mathematical proof or peer review.

---

## 10. Material already compliant

The following features should be retained:

- theorem, lemma, proposition, corollary, definition, and remark environments;
- section-based theorem numbering;
- labelled cross-references rather than hard-coded theorem numbers;
- an explicit statement of the embedding convention;
- conservative attribution to Li and Reiher;
- exact separation of the manuscript theorem from the Lean endpoint surface;
- explicit finite-versus-infinite quantifier boundaries;
- the `reqno` equation-number placement.

---

## Publication acceptance test

Before calling the paper AMS-ready, verify all of the following.

1. The abstract is one paragraph, self-contained, and at most 150 words.
2. The abstract contains no citation, footnote, display, or numbered equation.
3. The title is informative and contains no unexplained notation.
4. `\date` is absent; `\address`, `\email`, `\subjclass[2020]`, and `\keywords` are present.
5. The introduction states the theorem and contribution before technical proof details.
6. Every theorem statement is a grammatical sentence ending in punctuation.
7. Every display is punctuated according to its sentence.
8. Every symbol is defined before substantive use.
9. No equation is numbered unless it is cited.
10. The bibliography is alphabetised, complete, consistently abbreviated, and free of duplicate identifiers.
11. The AMS submission source uses minimal `amsart` formatting.
12. The formalisation and disclosure sections state their scope without chronology-heavy prose.
13. The PDF metadata, title, README, and `CITATION.cff` agree.
14. A clean build produces no undefined references, overfull boxes, or bibliography warnings.

## Conclusion

The paper does not need a new mathematical proof cycle to satisfy AMS writing standards.  It needs one disciplined source integration applying the patch ledger in `audits/AMS_WRITING_LINE_PATCHES.md`, followed by a clean `amsart` build and visual inspection.  The copy-ready front matter is in `reader-first/AMS_COMPLIANT_FRONT_MATTER.tex`.