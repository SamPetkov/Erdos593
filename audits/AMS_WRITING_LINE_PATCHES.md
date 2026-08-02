# Erdős 593: copy-ready AMS writing patches

These patches are editorial.  They preserve the mathematical statements, proof dependencies, attribution boundary, and Lean endpoint scope.  Apply them to the authoritative TeX in one integration commit, then regenerate every synchronized artefact.

## Patch 1: use a clean AMS article preamble

### Current

```tex
\documentclass[a4paper,11pt,reqno]{amsart}

\usepackage[margin=1in]{geometry}
\usepackage[T1]{fontenc}
\usepackage{newtxtext,newtxmath}
\usepackage{microtype}
\usepackage{amsmath,mathtools}
\usepackage[numbers,sort&compress]{natbib}
\usepackage{enumitem}
\usepackage{needspace}
\usepackage{etoolbox}
\usepackage{xurl}
\usepackage[hidelinks,pdfencoding=auto,psdextra]{hyperref}
\usepackage{bookmark}
```

### AMS submission form

```tex
\documentclass[11pt,reqno]{amsart}

\usepackage{mathtools}
\usepackage{xurl}
\usepackage[hidelinks,pdfencoding=auto,psdextra]{hyperref}
\usepackage{bookmark}
```

Use `amsrefs` or an AMS-compatible BibTeX style in the final bibliography integration.  Keep custom margins, Times-like fonts, `needspace`, and `enumitem` only in a separate designed-preprint build if they are still wanted for arXiv.

### Delete from the AMS submission source

```tex
\setlength{\parindent}{1.5em}
\setlength{\parskip}{0pt}
\setlist[itemize]{...}
\setlist[enumerate]{...}
\raggedbottom
\tolerance=1800
\pretolerance=500
\BeforeBeginEnvironment{...}{...}
```

Reason: the AMS class should control page geometry, fonts, paragraph layout, and theorem spacing.

---

## Patch 2: replace title metadata and add author metadata

### Replace

```tex
\title[Obligatory triple systems]{Obligatory Triple Systems: An Alternative Proof}
\author{Samuil Petkov}
\date{24 July 2026}
\subjclass[2020]{Primary 05C65; Secondary 05C15, 05C63, 03E05}
\keywords{obligatory triple system, hypergraph colouring, Levi graph, Berge cycle, uncountable chromatic number, Erdős Problem 593}
```

### By

```tex
\title[Obligatory triple systems]
  {Obligatory Triple Systems: Bridge Decompositions and Exact Finite Spectra}
\author{Samuil Petkov}
\address{École normale supérieure--PSL, 45 rue d'Ulm, 75005 Paris, France}
\email{samuil.petkov@ens.psl.eu}
\subjclass[2020]{Primary 05C65; Secondary 05C15, 05C63, 03E05}
\keywords{obligatory triple system, weak hypergraph colouring, Levi graph,
  Berge cycle, uncountable chromatic number, Erdős Problem 593}
```

If the original title is retained, still delete `\date` and add `\address` and `\email`.

Update `\hypersetup`, README metadata, `CITATION.cff`, and any arXiv metadata to the same title.

---

## Patch 3: replace the abstract

Replace the complete abstract by the version in

```text
reader-first/AMS_COMPLIANT_FRONT_MATTER.tex
```

The replacement is a single paragraph, contains no citation or display, and remains below 150 words after TeX commands are removed.

---

## Patch 4: number the introduction

### Replace

```tex
\section*{Introduction}\label{introduction}
```

### By

```tex
\section{Introduction}\label{introduction}
```

Let theorem and equation numbers adjust automatically.  Do not hard-code the old section numbers in prose.

---

## Patch 5: make isomorphism closure explicit

### Location

Immediately after the definition of `\mathcal B`.

### Insert

```tex
Membership in $\mathcal B$ is understood up to triple-system isomorphism.
```

Reason: the proof constructs incidence-isomorphic systems, and the Lean class has an explicit `ofIso` constructor.

---

## Patch 6: punctuate Theorem A as a sentence

### Replace

```tex
For every finite triple system $F$, the following are equivalent:
\begin{enumerate}
\item $F$ is obligatory;
\item $F\in\mathcal B$;
\item $F^\circ$ is linear, every hyperedge-node of $I(F^\circ)$ is incident
with a bridge, and every Berge cycle of $F^\circ$ has even length.
\end{enumerate}
```

### By

```tex
For every finite triple system $F$, the following assertions are equivalent.
\begin{enumerate}
\item $F$ is obligatory.
\item $F\in\mathcal B$.
\item The system $F^\circ$ is linear, every hyperedge-node of
$I(F^\circ)$ is incident with a bridge, and every Berge cycle of
$F^\circ$ has even length.
\end{enumerate}
```

After the theorem, add the isolated-reduction interface:

```tex
In the implication from the intrinsic condition to constructibility, we apply
Proposition~\ref{proposition-5.2-bridge-block-decomposition} to $F^\circ$ and
then use Lemma~\ref{lemma-1.1-isolated-vertex-reduction} to restore the isolated
vertices.
```

---

## Patch 7: replace the two-story roadmap by a three-part proof map

### Replace the opening sentence

```tex
The proof is best read as two stories.
```

### By

```tex
The proof separates into three implications:
\[
\mathcal B\Longrightarrow\text{obligatory},\qquad
\mathcal B\Longleftrightarrow\text{intrinsic},\qquad
\neg\text{intrinsic}\Longrightarrow\neg\text{obligatory}.
\]
```

Then give one short paragraph for each implication.  The finite bridge-block theorem should not be hidden inside the positive paragraph.

---

## Patch 8: compress the priority paragraph

### Replace the date-heavy paragraph beginning

```tex
Li's preprint, posted on 23 June 2026, contains ...
```

### By

```tex
Li's preprint contains the first publicly posted complete proof of the
classification and introduces the complete-rank one-apex lift and bridge-trace
method used in the negative direction
\citep[Theorem~1.1 and Sections~3--4]{li2026}.  The present paper gives an
alternative implementation, a direct all-bridges decomposition of the finite
structure, exact finite parameter consequences, and a Lean formalisation of
this implementation.  No competing priority claim is made for the
classification or the shared lift architecture.
```

Move exact dates and commit chronology to `PROVENANCE.md`.

---

## Patch 9: move the external-input inventory

Move the paragraph beginning

```tex
All embeddings are injective and non-induced.  The argument is carried out in
ZFC.  The imported results used as black boxes are ...
```

from the introduction to the end of the preliminaries, under the heading

```tex
\paragraph{External inputs.}
```

Use the precise names:

- de Bruijn--Erdős finite-colouring compactness theorem;
- Erdős--Hajnal graph with odd girth exceeding a prescribed finite bound;
- Erdős--Rado pair partition relation.

---

## Patch 10: split the first preliminaries paragraph

### Replace the opening definition block by

```tex
A \emph{triple system} is a simple $3$-uniform hypergraph
$H=(V(H),E(H))$, so $E(H)\subseteq [V(H)]^3$.
Throughout, chromatic number means weak vertex chromatic number.  A colouring
$c\colon V(H)\to\lambda$ is \emph{proper} when no hyperedge is monochromatic,
and $\chi(H)$ is the least cardinal $\lambda$ admitting such a colouring.

An embedding of a triple system $F$ in $H$ is an injective map
$f\colon V(F)\to V(H)$ such that $f[e]\in E(H)$ for every $e\in E(F)$.
Embeddings are not required to be induced.  A finite triple system $F$ is
\emph{obligatory} if every triple system $H$ with
$\chi(H)>\aleph_0$ contains an embedding of $F$.

A point is \emph{isolated} if it belongs to no hyperedge.  We write $F^\circ$
for the system obtained by deleting all isolated points.
```

Reason: each paragraph now introduces one conceptual group, and map colons use `\colon`.

---

## Patch 11: split and standardise the incidence definitions

### Replace the second long preliminaries paragraph by

```tex
All ordinary graphs in this paper are simple.  A triple system is
\emph{linear} if any two distinct hyperedges meet in at most one point.  Its
\emph{Levi graph}, or incidence graph, $I(F)$ is the bipartite graph with
classes $V(F)$ and $E(F)$, where a point-node $p$ is adjacent to a
hyperedge-node $e$ exactly when $p\in e$.  A \emph{bridge} is an edge of a
graph whose deletion increases the number of connected components.

A \emph{Berge cycle of length $\ell\ge2$} consists of distinct points
$p_0,\ldots,p_{\ell-1}$ and distinct hyperedges
$e_0,\ldots,e_{\ell-1}$ such that
$p_i\in e_i\cap e_{i+1}$, with indices modulo $\ell$.  Its length is the
number $\ell$ of hyperedges, or equivalently the number of connector points.
It corresponds to a simple cycle of length $2\ell$ in $I(F)$.  In a linear
triple system, necessarily $\ell\ge3$.
```

---

## Patch 12: standardise expansion and amalgamation definitions

Use

```tex
For a finite simple graph $J$, its \emph{private-vertex expansion} $J^+$ has
vertex set
\[
V(J)\mathbin{\dot\cup}\{p_a:a\in E(J)\}
\]
and hyperedges $\{u,v,p_{\{u,v\}}\}$ for $\{u,v\}\in E(J)$, where the
points $p_a$ are new and pairwise distinct.

A \emph{one-point amalgamation}, or one-vertex sum, of otherwise
vertex-disjoint triple systems $F_0$ and $F_1$ is obtained by choosing
$x_i\in V(F_i)$, identifying $x_0$ with $x_1$, and making no other
identifications and adding no new hyperedges.
```

Punctuate the display as part of the first sentence.

---

## Patch 13: remove generated enumerate boilerplate

Delete every local fragment of the form

```tex
\def\labelenumi{\arabic{enumi}.}
\tightlist
```

Use ordinary `enumerate` environments.  If a list needs a different label, use the relevant AMS/LaTeX list option in a single controlled macro rather than redefining `\labelenumi` inside theorem statements.

---

## Patch 14: remove decorative boxes

Replace theorem-statement displays such as

```tex
\boxed{
\left\lceil\frac{n-c}{2}\right\rceil
\le m\le
n-2c+4-\left\lceil2\sqrt{n-3c+4}\right\rceil
}
```

by the same display without `\boxed`.  The theorem heading already supplies the required emphasis.

---

## Patch 15: use automatic equation numbering and `\eqref`

Where an equation is cited later, replace

```tex
\[
...
\tag{10.6}
\]
```

by

```tex
\begin{equation}\label{eq:fixed-order-spectrum}
...
\end{equation}
```

and cite it as `\eqref{eq:fixed-order-spectrum}`.

Delete numbers from equations that are never cited.  Apply this systematically to the finite-parameter section.

---

## Patch 16: punctuate every display

Examples:

### Current

```tex
Then
\[
F\text{ is obligatory}\iff F^\circ\text{ is obligatory},
\]
and
\[
F\in\mathcal B\iff F^\circ\in\mathcal B.
\]
```

### Preferred

```tex
Then
\[
F\text{ is obligatory}
\quad\Longleftrightarrow\quad
F^\circ\text{ is obligatory},
\]
and
\[
F\in\mathcal B
\quad\Longleftrightarrow\quad
F^\circ\in\mathcal B.
\]
```

The comma and period are part of the surrounding sentence.  Perform the same check for every theorem statement, proof calculation, and concluding display.

---

## Patch 17: define finite-parameter terminology before use

### Replace the opening of the finite-parameter section by

```tex
In this section, the \emph{order} and \emph{size} of a finite triple system
are respectively its numbers of vertices and hyperedges.  The system is
\emph{connected} if its Levi graph is connected, and its connected components
are the components of that Levi graph.  We first work without isolated
vertices.
```

At first use, write `cycle rank (cyclomatic number)` and then use `cycle rank` thereafter.

---

## Patch 18: replace the square-root calculation literally

Replace the compressed merge-inequality justification by

```tex
Indeed,
\[
\bigl(\sqrt a+\sqrt b-1\bigr)^2-(a+b-1)
  =2(\sqrt a-1)(\sqrt b-1)\ge0.
\]
Both sides of the desired inequality are nonnegative.  Hence
$\sqrt a+\sqrt b\ge\sqrt{a+b-1}+1$; multiplying by two and taking ceilings
gives the claimed inequality.
```

This patch is both mathematically exact and stylistically clearer.

---

## Patch 19: complete the unrestricted-spectrum proof

After the connected case, insert

```tex
For arbitrary component count $c$, repeated application of the merge
inequality gives
\[
q(m-c+1)+2(c-1)\ge q(m).
\]
Thus the lower endpoint for $c$ components is never below the connected lower
endpoint $m+\lceil2\sqrt m\rceil$.
```

After adjoining isolated vertices, add

```tex
Conversely, deleting isolated vertices leaves the edge count unchanged and
produces a reduced obligatory system, so the same lower bound is necessary.
```

These sentences make both necessity directions explicit.

---

## Patch 20: compress the formal-verification section

Replace the chronology-heavy opening by

```tex
\section*{Formal verification and reproducibility}

A Lean~4 development verifies the complete finite classification in the
repository accompanying this paper.  The public endpoints are stated on the
isolated reduction: for every finite triple system $F$, they prove
\[
\begin{aligned}
\mathtt{F.IsObligatory}
&\Longleftrightarrow \mathtt{F.isolatedReduction.Intrinsic},\\
\mathtt{F.IsObligatory}
&\Longleftrightarrow
  \mathtt{Constructible\ F.isolatedReduction}.
\end{aligned}
\]
Together with the separately proved isolated-vertex equivalence, these are the
formal counterparts of Theorem~A.  Host systems are unrestricted in cardinality
but are quantified in the fixed ambient vertex and edge universes of the
theorem.

The written proof uses the classical Erdős--Hajnal high-odd-girth theorem for
the odd-cycle obstruction.  The Lean development reaches the same
classification endpoint through an explicit shift-graph host and a closed-walk
transfer theorem.  It is therefore a formal verification of the classification,
not a line-by-line encoding of every paragraph above.

The finite parameter consequences in the final section are checked separately
by exact integer arithmetic; they are not currently exported as additional
Lean theorems.  The formalisation supplements, rather than replaces,
mathematical review.
```

Keep detailed public dates and commit identifiers in `PROVENANCE.md`.

---

## Patch 21: consolidate acknowledgments and disclosures

Unless the target journal requests separate headings, replace the four sections

```tex
Acknowledgments
AI assistance
Funding
Competing interests
```

by

```tex
\section*{Acknowledgments and disclosure}

The author thanks Tom de Groot for advice on improving the exposition and Eric
Li for a discussion of the relationship between the two proofs.  OpenAI's
GPT-5.6 Pro through ChatGPT and Aristotle~\citep{achim-et-al-2025} were used for
proof development, adversarial checking, editorial restructuring, and Lean
formalisation.  The author reviewed all incorporated suggestions and assumes
full responsibility for the arguments, citations, and final manuscript.  The
author received no funding for this work and declares no competing interests.
```

If the target journal has a prescribed disclosure form, follow that form instead.

---

## Patch 22: normalise the bibliography

Apply all of the following in one bibliography-generation pass.

1. Alphabetise entries by author.
2. Use standard journal abbreviations.
3. Give complete volume, year, issue when useful, and page data for published articles.
4. Keep one stable DOI or arXiv identifier rather than duplicating DOI, raw URL, and a separate arXiv line.
5. Use sentence case for titles.
6. Remove generated `\penalty0` fragments.
7. Use `amsrefs` or an AMS-compatible BibTeX style.

Example form:

```tex
\bibitem{komjath2001}
P. Komjáth,
\emph{Some remarks on obligatory subsystems of uncountably chromatic triple
systems}, Combinatorica 21 (2001), no.~2, 233--238,
\doi{10.1007/s004930100021}.
```

Do not invent volume or page data for a paper still listed by the publisher as an article in press.

---

## Patch 23: keep spelling internally consistent

For an AMS-targeted source, make one global, mechanical conversion to American spellings:

```text
colouring       -> coloring
colour          -> color
formalisation   -> formalization
characterisation -> characterization
realise         -> realize
```

Do not mix the two systems.  If the author retains British spelling in the arXiv preprint, keep a separate AMS-submission branch rather than making partial substitutions.

---

## Patch 24: final source-quality pass

Before regenerating the PDF:

- replace literal theorem numbers in prose by labels;
- replace raw URLs in prose by bibliography citations or `\url` only where necessary;
- remove unused packages and macros;
- remove `\providecommand{\tightlist}` if no generated list requires it;
- run `git diff --check`;
- compile twice after bibliography generation;
- fail on undefined references and bibliography warnings;
- inspect every overfull box;
- verify PDF title, author, subject, and keywords;
- confirm that the root and arXiv sources are generated from the same canonical TeX.

## Integration order

1. Apply Patches 1--12 to front matter and definitions.
2. Apply Patches 13--19 to theorem statements and finite spectra.
3. Apply Patches 20--23 to back matter and bibliography.
4. Run `scripts/audit_ams_writing.py --mode enforce`.
5. Regenerate every TeX, Markdown, PDF, arXiv ZIP, manifest, and checksum.
6. Run the theorem, standard-definition, Lean-alignment, and manuscript-synchronisation workflows.
7. Visually inspect the abstract, Theorem A, all multi-line displays, bibliography, and final author metadata.