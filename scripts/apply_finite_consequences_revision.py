#!/usr/bin/env python3
"""Apply the 24 July 2026 finite-consequences and chronology revision.

This is a one-shot repository migration used by the bootstrap workflow.  The
canonical manuscript remains the only hand-edited manuscript source; generated
mirrors are rebuilt by ``sync_manuscript_artifacts.py`` after this script runs.
"""

from __future__ import annotations

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def write(path: str, text: str) -> None:
    (ROOT / path).write_text(text.rstrip() + "\n", encoding="utf-8", newline="\n")


def replace_required(text: str, old: str, new: str, label: str, *, count: int = 1) -> str:
    hits = text.count(old)
    if hits < count:
        raise RuntimeError(f"missing required {label}: expected at least {count}, found {hits}")
    return text.replace(old, new, count)


def regex_replace_required(text: str, pattern: str, replacement: str, label: str) -> str:
    result, hits = re.subn(pattern, lambda _: replacement, text, count=1, flags=re.DOTALL)
    if hits != 1:
        raise RuntimeError(f"failed to replace {label}: matched {hits} times")
    return result


NEW_TITLE = "Obligatory Triple Systems: An Alternative Proof, Lean Formalisation, and Finite Consequences"

NEW_ABSTRACT = r"""\begin{abstract}
Eric Li's June 2026 preprint gave the first publicly posted complete
classification of the finite triple systems that occur in every triple system
of uncountable chromatic number.  We give an alternative proof of that
classification, a Lean formalisation, and further finite consequences.  After
isolated vertices are removed, obligatoriness is equivalent to linearity,
incidence of every hyperedge-node of the Levi graph with a bridge, and evenness
of every Berge cycle; equivalently, the systems are assembled from
private-vertex expansions of finite bipartite graphs by disjoint unions and
one-point amalgamations.  The positive direction uses a probabilistic rainbow
lemma and rooted abundance.  The converse uses the one-apex sequence-lift and
bridge-trace framework introduced by Li, reorganised as a base-fibre and
support-incidence analysis.  As consequences of the classification, we
determine the exact possible triples consisting of the number of hyperedges,
the number of vertices, and the number of connected components; derive the
exact Levi cycle-rank spectrum; give a forbidden-Levi-subgraph formulation;
and obtain balanced-hypergraph and colouring-polynomial consequences.
\end{abstract}"""

NEW_INTRO_PRIORITY = r"""Theorem~A, including both the constructive and intrinsic formulations, was
first proved by \citet[Theorem~1.1]{li2026}.  Li also introduced the
complete-rank one-apex sequence lift and exact bridge-trace theorem used in the
negative half of the classification
\citep[Sections~3--4 and Theorem~4.6]{li2026}.  The present paper gives an
alternative implementation: direct positive-atom and closure proofs, an
explicit base-fibre and support-incidence form of the finite trace theorem, a
complete Lean formalisation, and the finite consequences in
Section~\ref{finite-consequences}.  Dependencies on Li's proof are cited where
they enter.
"""

NEW_RELATION = r"""\paragraph{Relation to Li's proof.}
Li's preprint has priority for Theorem~A and for the one-apex and bridge-trace
framework.  The selected-incidence decomposition, quotient forest, and
running-intersection assembly are also cited at their points of use
\citep[Sections~3--5]{li2026}.  The implementation here differs in its direct
proof of the positive expansion atom, its rooted-abundance closure argument,
its base-fibre/support-incidence organisation, its Lean development, and the
additional finite deductions of Section~\ref{finite-consequences}.
"""

FINITE_SECTION = r"""
\section{Finite consequences of the classification}\label{finite-consequences}

The classification turns several finite questions about obligatory systems
into elementary questions about bipartite graphs.  We record the resulting
parameter spectrum and some structural and enumerative consequences.  A
longer proof ledger, including the source audit behind this section, is
available in the accompanying repository file
\href{https://github.com/SamPetkov/Erdos593/blob/main/FURTHER_FINITE_RESULTS.md}{\texttt{FURTHER\_FINITE\_RESULTS.md}}.

For an integer $r\ge1$, put
\[
\sigma(r)=\left\lceil2\sqrt r\right\rceil.
\]
For a reduced triple system $F$, let $c(F)$ denote the number of connected
components of its Levi graph.

\begin{proposition}[Numerical bipartite shadow]\label{proposition-10.1-numerical-bipartite-shadow}
Let $F$ be obligatory and have no isolated vertices.  If
\[
m=|E(F)|,\qquad n=|V(F)|,\qquad c=c(F),
\]
then there is a finite bipartite graph $J$, without isolated vertices and with
$c$ connected components, such that
\[
|E(J)|=m,
\qquad
|V(J)|=n-m.
\tag{10.1}
\]
Conversely, every finite bipartite graph $J$ without isolated vertices gives an
obligatory expansion $J^+$ with these parameter identities and the same number
of components.
\end{proposition}

\begin{proof}
Consider one connected component $H$ of $F$.  Proposition~5.2 and its
running-intersection order write $H$ as a succession of one-point
amalgamations of connected pieces
\[
J_1^+,\ldots,J_k^+,
\]
where each $J_i$ is a connected finite bipartite graph.  Put
$m_i=|E(J_i)|$ and $v_i=|V(J_i)|$.  Since a connected assembly of $k$ pieces
makes exactly $k-1$ point identifications,
\[
|E(H)|=\sum_{i=1}^k m_i,
\qquad
|V(H)|=\sum_{i=1}^k(m_i+v_i)-(k-1).
\tag{10.2}
\]
Take vertex-disjoint copies of the graphs $J_i$ and form arbitrary one-vertex
sums along a tree.  Before an identification, interchange the two bipartition
classes in one factor when necessary.  The resulting graph $J_H$ is connected
and bipartite, and (10.2) gives
\[
|E(J_H)|=|E(H)|,
\qquad
|V(J_H)|=|V(H)|-|E(H)|.
\]
The disjoint union of the $J_H$ over the components of $F$ is the required
shadow.  This shadow records the numerical data; it need not retain the
attachment points of $F$.

Conversely, $J^+$ is obligatory by Corollary~3.3, and the parameter identities
are immediate from the definition of expansion.
\end{proof}

\begin{lemma}[Connected bipartite parameters]\label{lemma-10.2-connected-bipartite-parameters}
A connected simple bipartite graph with $r\ge1$ edges and $s$ vertices exists
if and only if
\[
\sigma(r)\le s\le r+1.
\tag{10.3}
\]
Equivalently,
\[
s-1\le r\le\left\lfloor\frac{s^2}{4}\right\rfloor.
\tag{10.4}
\]
\end{lemma}

\begin{proof}
Connectedness gives $r\ge s-1$.  If the bipartition classes have sizes $a,b$,
then
\[
r\le ab\le\left\lfloor\frac{(a+b)^2}{4}\right\rfloor
=\left\lfloor\frac{s^2}{4}\right\rfloor.
\]
Conversely, the balanced complete bipartite graph
$K_{\lfloor s/2\rfloor,\lceil s/2\rceil}$ contains a spanning tree.  Starting
with that tree and adding arbitrary unused edges realises every integer between
$s-1$ and $\lfloor s^2/4\rfloor$.  Finally,
$r\le\lfloor s^2/4\rfloor$ is equivalent to $\sigma(r)\le s$.
\end{proof}

\begin{theorem}[Exact finite order--size--component spectrum]\label{theorem-10.3-exact-finite-spectrum}
Let $m\ge1$, $1\le c\le m$, and $n$ be integers.  There exists an obligatory
triple system $F$ with no isolated vertices, exactly $c$ connected components,
and
\[
|E(F)|=m,
\qquad
|V(F)|=n,
\]
if and only if
\[
\boxed{
 m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
 \le n\le 2m+c.
}
\tag{10.5}
\]
Every integer in this interval occurs.
\end{theorem}

\begin{proof}
By Proposition~10.1, it is enough to determine the possible orders of a
bipartite graph with $m$ edges and $c$ nontrivial connected components.  Let
the component edge counts be $m_1,\ldots,m_c$, where
\[
m_1+\cdots+m_c=m,
\qquad
m_i\ge1.
\]
Lemma~10.2 shows that the $i$th component has between $\sigma(m_i)$ and
$m_i+1$ vertices.  For $a,b\ge1$,
\[
\sigma(a)+\sigma(b)\ge\sigma(a+b-1)+2.
\tag{10.6}
\]
Indeed,
\[
(\sqrt a+\sqrt b-1)^2-(a+b-1)
=2(\sqrt a-1)(\sqrt b-1)\ge0,
\]
and taking ceilings gives (10.6).  Iterating it yields
\[
\sum_{i=1}^c\sigma(m_i)
\ge\sigma(m-c+1)+2(c-1).
\tag{10.7}
\]
The maximum shadow order is
\[
\sum_{i=1}^c(m_i+1)=m+c.
\]
Adding the $m$ private expansion vertices proves the two bounds in (10.5).

For attainability, take $c-1$ shadow components equal to $K_2$, and let the
remaining connected bipartite component have $m-c+1$ edges.  Lemma~10.2 lets
its order vary through every integer from $\sigma(m-c+1)$ to $m-c+2$.
Expanding the resulting graph realises every integer in (10.5).
\end{proof}

\begin{corollary}[Connected and unrestricted spectra]\label{corollary-10.4-connected-unrestricted-spectra}
For $m\ge1$:
\begin{enumerate}
\item a connected obligatory reduced system with $m$ hyperedges and $n$
vertices exists exactly when
\[
\boxed{m+\left\lceil2\sqrt m\right\rceil\le n\le2m+1};
\tag{10.8}
\]
\item without a connectivity requirement, an obligatory reduced system with
$m$ hyperedges and $n$ vertices exists exactly when
\[
\boxed{m+\left\lceil2\sqrt m\right\rceil\le n\le3m}.
\tag{10.9}
\]
\end{enumerate}
\end{corollary}

\begin{proof}
The first statement is Theorem~10.3 with $c=1$.  For the second, let $c$ range
from $1$ to $m$.  The fixed-$c$ intervals are consecutive, because the lower
endpoint for $c+1$ is at most one more than the upper endpoint for $c$ by the
inequality $\sigma(r)\le r+1$.
\end{proof}

For a finite graph $G$, write
$\beta(G)=|E(G)|-|V(G)|+c(G)$ for its cyclomatic number.  Since
\[
|E(I(F))|=3m,
\qquad
|V(I(F))|=n+m,
\]
we have
\[
\beta(I(F))=2m-n+c.
\tag{10.10}
\]

\begin{corollary}[Exact Levi cycle-rank spectrum]\label{corollary-10.5-cycle-rank-spectrum}
For obligatory reduced systems with $m\ge1$ hyperedges and exactly $c$
components, the possible Levi cycle ranks are precisely
\[
\boxed{
0\le\beta(I(F))
\le m-c+2-\left\lceil2\sqrt{m-c+1}\right\rceil.
}
\tag{10.11}
\]
Every integer in this interval occurs.  Moreover,
$|V(F)|=2m+c$ if and only if $I(F)$ is a forest; in the connected case,
$|V(F)|=2m+1$ if and only if $I(F)$ is a tree.
\end{corollary}

\begin{proposition}[Rigidity at two lower-endpoint families]\label{proposition-10.6-lower-endpoint-rigidity}
Let $F$ be connected, obligatory, and reduced.
\begin{enumerate}
\item If $|E(F)|=t^2$ and $|V(F)|=t^2+2t$, then
$F\cong K_{t,t}^+$.
\item If $|E(F)|=t(t+1)$ and $|V(F)|=t(t+1)+2t+1$, then
$F\cong K_{t,t+1}^+$.
\end{enumerate}
\end{proposition}

\begin{proof}
At either lower endpoint, the bipartite shadow of Proposition~10.1 attains
equality in the balanced bipartite edge bound.  It is therefore respectively
$K_{t,t}$ or $K_{t,t+1}$.  For $t\ge2$ these graphs have no cut vertex, whereas
a nontrivial one-vertex sum of two or more connected bridge-block shadows has
a cut vertex.  Hence the canonical decomposition has one expansion piece.
The cases $t=1$ are immediate.
\end{proof}

\paragraph{A forbidden-Levi formulation.}
Let $e$ be a hyperedge-node with point-neighbours $x,y,z$.  A \emph{full theta
rooted at $e$} consists of a vertex $w\ne e$ and three pairwise internally
vertex-disjoint $e$--$w$ paths whose first edges are respectively $ex,ey,ez$.

\begin{lemma}[Full-theta criterion]\label{lemma-10.7-full-theta-criterion}
The node $e$ has no incident bridge if and only if the Levi graph contains a
full theta rooted at $e$.
\end{lemma}

\begin{proof}
No incidence at $e$ is a bridge exactly when $x,y,z$ lie in one connected
component after $e$ is deleted.  In that component, a minimal tree joining
$x,y,z$ has a branch point, possibly one of the terminals.  Its three
terminal-to-branch paths, together with $ex,ey,ez$, give the full theta.
Conversely, a full theta supplies an alternative route around each incidence
at $e$, so none is a bridge.
\end{proof}

\begin{corollary}[Forbidden Levi configurations]\label{corollary-10.8-forbidden-levi-configurations}
A finite triple system $F$ is obligatory if and only if $I(F^\circ)$ contains
none of the following:
\begin{enumerate}
\item a $4$-cycle;
\item a cycle of length congruent to $2$ modulo $4$;
\item a full theta rooted at a hyperedge-node.
\end{enumerate}
\end{corollary}

\begin{proof}
A $4$-cycle in the Levi graph is exactly a pair of hyperedges sharing two
points.  A Berge cycle of length $\ell$ is a Levi cycle of length $2\ell$, so
odd Berge cycles are exactly the Levi cycles of length $2$ modulo $4$.
Lemma~10.7 translates the remaining bridge condition.  Apply Theorem~A.
\end{proof}

\paragraph{Balanced-hypergraph consequence.}
A hypergraph is balanced when its incidence matrix contains no odd square
submatrix having exactly two $1$s in each row and column; equivalently, it has
no strong odd Berge cycle.  Since an obligatory system has no odd Berge cycle
at all, it is balanced.  The classical theorem of Berge and Las Vergnas then
gives the following hereditary K\H{o}nig property
\citep{bergelasvergnas1970,berge1972}.

\begin{corollary}[Hereditary matching--transversal equality]\label{corollary-10.9-balanced-konig}
Let $F$ be obligatory.  Every hypergraph $H$ obtained from $F^\circ$ by
deleting vertices and/or hyperedges satisfies
\[
\nu(H)=\tau(H),
\tag{10.12}
\]
where $\nu$ is the maximum matching size and $\tau$ is the minimum vertex
transversal size.
\end{corollary}

\paragraph{Colouring-polynomial factorisation.}
For a finite hypergraph $H$, let $\mathsf P_H(q)$ count weak proper
$q$-colourings and let $\mathsf S_H(q)$ count strong $q$-colourings, in which
the three vertices of each hyperedge have pairwise distinct colours.  For a
finite graph $J$ and $A\subseteq E(J)$, let $k_J(A)$ be the number of connected
components of the spanning graph $(V(J),A)$, including isolated graph
vertices, and put
\[
Q_J(q)=\sum_{A\subseteq E(J)}
(-1)^{|A|}q^{|E(J)|-|A|+k_J(A)}.
\tag{10.13}
\]
If
\[
Z_J(q,v)=\sum_{A\subseteq E(J)}q^{k_J(A)}v^{|A|}
\]
is the Fortuin--Kasteleyn/Potts partition function, then
\[
Q_J(q)=q^{|E(J)|}Z_J(q,-q^{-1}).
\tag{10.14}
\]
See \citet{white2011} for hypergraph chromatic polynomials and
\citet{sokal2005} for the multivariate Tutte/Potts framework.

\begin{theorem}[Canonical colouring factorisation]\label{theorem-10.10-colouring-factorisation}
Let the canonical bridge-block decomposition of $F^\circ$ have $k$ active
pieces
\[
J_1^+,\ldots,J_k^+,
\]
let $c=c(F^\circ)$, let $m=|E(F)|$, and let $z$ be the number of isolated
vertices of $F$.  If $F^\circ$ is nonempty, then
\[
\boxed{
q^{k-c}\mathsf P_F(q)=q^z\prod_{i=1}^k Q_{J_i}(q)
}
\tag{10.15}
\]
and
\[
\boxed{
q^{k-c}\mathsf S_F(q)
=q^z(q-2)^m\prod_{i=1}^k P_{J_i}(q),
}
\tag{10.16}
\]
where $P_{J_i}$ is the ordinary graph chromatic polynomial.
\end{theorem}

\begin{proof}
For one expansion atom, inclusion--exclusion over the events that an expanded
triple is monochromatic gives
\[
\mathsf P_{J^+}(q)=Q_J(q).
\]
Indeed, imposing the events indexed by $A\subseteq E(J)$ collapses the core
vertices according to the $k_J(A)$ components of $(V(J),A)$, while the
$|E(J)|-|A|$ private vertices outside $A$ remain free.  For strong colourings,
the graph core must be properly coloured, and every private vertex then has
$q-2$ independent choices.  Thus
\[
\mathsf S_{J^+}(q)=(q-2)^{|E(J)|}P_J(q).
\]
If $H$ is a one-point amalgamation of $H_0,H_1$, colour symmetry at the
identified point gives
\[
q\mathsf P_H(q)=\mathsf P_{H_0}(q)\mathsf P_{H_1}(q),
\qquad
q\mathsf S_H(q)=\mathsf S_{H_0}(q)\mathsf S_{H_1}(q).
\]
There are exactly $k-c$ amalgamation steps.  Disjoint unions multiply the
polynomials, and each isolated vertex contributes a factor $q$.
\end{proof}
"""

NEW_FORMAL_SECTION = r"""\section*{Formal verification and public chronology}

Li's v1, submitted on 23 June 2026, contains the first publicly posted complete
mathematical proof of Theorem~A \citep[Theorem~1.1]{li2026}.  The public history
of the present repository records a verified Lean scaffold on 15 July 2026, the
complete finite constructive/intrinsic structural theorem later that day, and
the complete Problem~593 endpoints by 19 July 2026.  Li's v2, submitted on
23 July 2026, announced a separate Lean verification.  On these public
timestamps, the development here is the earliest complete public Lean
formalisation located in the present audit.  This statement concerns public
records only and makes no inference about private development or influence.
The dated commits and the scope of the comparison are recorded in
\href{https://github.com/SamPetkov/Erdos593/blob/main/PUBLIC_CHRONOLOGY.md}{\texttt{PUBLIC\_CHRONOLOGY.md}}.

The self-contained Lean~4 source is available in the public
\href{https://github.com/SamPetkov/Erdos593/blob/main/formalization/Erdos593SelfContained.lean}{\texttt{Erdos593} repository}.
For every finite triple system $F$, the exported theorems establish
\[
\begin{aligned}
\mathtt{F.IsObligatory}
&\Longleftrightarrow \mathtt{F.isolatedReduction.Intrinsic},\\
\mathtt{F.IsObligatory}
&\Longleftrightarrow \mathtt{Constructible\ F.isolatedReduction}.
\end{aligned}
\]
Thus the development verifies both directions of the classification, including
the isolated-vertex reduction.  Host triple systems are not assumed finite and
are quantified within the formalisation's documented ambient-universe
convention.  The formalisation supplements, rather than replaces, mathematical
review.
"""

NEW_ACK = r"""\section*{Acknowledgments}

The author thanks Tom de Groot for his advice on revising the manuscript for
greater clarity, and Eric Li for a discussion about the relationship between
the two proofs.
"""

NEW_AI = r"""\section*{AI assistance and provenance}

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle~\citep{achim-et-al-2025}
were used for proof development, adversarial checking, editorial restructuring,
and the Lean formalisation.  The author reviewed all incorporated suggestions
and assumes full responsibility for the arguments, citations, attribution, and
final manuscript.  Mathematical priority and the public formalisation
chronology are recorded above; no inference about private development or
influence is intended.
"""


def patch_tex() -> None:
    path = "erdos593_obligatory_triple_systems.tex"
    text = read(path)
    text = replace_required(
        text,
        r"\title[Obligatory triple systems]{Obligatory Triple Systems: An Alternative Proof}",
        rf"\title[Obligatory triple systems]{{{NEW_TITLE}}}",
        "manuscript title",
    )
    text = replace_required(
        text,
        "pdftitle={Obligatory Triple Systems: An Alternative Proof}",
        f"pdftitle={{{NEW_TITLE}}}",
        "PDF title",
    )
    text = replace_required(
        text,
        "pdfsubject={An alternative proof and Lean verification of the classification of finite obligatory triple systems first proved by Eric Li}",
        "pdfsubject={An alternative proof, Lean formalisation, and finite consequences for the classification of finite obligatory triple systems}",
        "PDF subject",
    )
    text = replace_required(
        text,
        "pdfkeywords={obligatory triple system, hypergraph colouring, Levi graph, Berge cycle, uncountable chromatic number, Erdos Problem 593}",
        "pdfkeywords={obligatory triple system, finite parameter spectrum, hypergraph colouring, Levi graph, Berge cycle, balanced hypergraph, chromatic polynomial, Erdos Problem 593}",
        "PDF keywords",
    )
    text = replace_required(text, r"\date{21 July 2026}", r"\date{24 July 2026}", "manuscript date")
    text = replace_required(
        text,
        r"\keywords{obligatory triple system, hypergraph colouring, Levi graph, Berge cycle, uncountable chromatic number, Erdős Problem 593}",
        r"\keywords{obligatory triple system, finite parameter spectrum, hypergraph colouring, Levi graph, Berge cycle, balanced hypergraph, chromatic polynomial, Erdős Problem 593}",
        "visible keywords",
    )
    text = regex_replace_required(text, r"\\begin\{abstract\}.*?\\end\{abstract\}", NEW_ABSTRACT, "abstract")
    text = regex_replace_required(
        text,
        r"Theorem~A, including both the constructive and intrinsic formulations, was.*?suited to machine\s+checking\.\n",
        NEW_INTRO_PRIORITY,
        "introductory priority paragraph",
    )
    text = regex_replace_required(
        text,
        r"\\paragraph\{Relation to Li's proof\.\}.*?complete Lean formalisation of\s+this implementation\.\n",
        NEW_RELATION,
        "relation-to-Li paragraph",
    )

    anchor = (
        "All embeddings are non-induced: additional host hyperedges on the image vertices are irrelevant throughout. "
        "The proof uses only ZFC, graph-colouring compactness, the classical Erd\\H{o}s--Hajnal high-odd-girth theorem, "
        "and the standard Erd\\H{o}s--Rado relation (8.1). It assumes neither CH nor GCH, and no forcing axiom or "
        "large-cardinal hypothesis.\n\n"
    )
    if anchor not in text:
        raise RuntimeError("could not locate finite-consequences insertion anchor")
    text = text.replace(anchor, anchor + FINITE_SECTION + "\n", 1)

    text = regex_replace_required(
        text,
        r"\\section\*\{Formal verification and reproducibility\}.*?(?=\\section\*\{Acknowledgments\})",
        NEW_FORMAL_SECTION + "\n",
        "formal verification section",
    )
    text = regex_replace_required(
        text,
        r"\\section\*\{Acknowledgments\}.*?(?=\\section\*\{AI assistance and provenance\})",
        NEW_ACK + "\n",
        "acknowledgments",
    )
    text = regex_replace_required(
        text,
        r"\\section\*\{AI assistance and provenance\}.*?(?=\\section\*\{Funding\})",
        NEW_AI + "\n",
        "AI provenance section",
    )

    text = replace_required(text, r"\begin{thebibliography}{13}", r"\begin{thebibliography}{17}", "bibliography width")
    li_old = r"""\newblock arXiv:2606.24882, submitted 23 June 2026.
\newblock \doi{10.48550/arXiv.2606.24882}."""
    li_new = r"""\newblock arXiv:2606.24882v1, submitted 23 June 2026; v2 submitted
  23 July 2026.
\newblock \doi{10.48550/arXiv.2606.24882}."""
    text = replace_required(text, li_old, li_new, "Li version history")

    bib_anchor = r"""\bibitem[Achim et~al.(2025)Achim, Best, Der, F{\'e}d{\'e}rico, Gukov,"""
    if bib_anchor not in text:
        raise RuntimeError("could not locate bibliography insertion anchor")
    extra_bib = r"""\bibitem[Berge and Las Vergnas(1970)]{bergelasvergnas1970}
Claude Berge and Michel Las Vergnas.
\newblock Sur un th{\'e}or{\`e}me du type {K}{\"o}nig pour hypergraphes.
\newblock \emph{Annals of the New York Academy of Sciences}, 175(1):32--40,
  1970.
\newblock \doi{10.1111/j.1749-6632.1970.tb56451.x}.

\bibitem[Berge(1972)]{berge1972}
Claude Berge.
\newblock Balanced matrices.
\newblock \emph{Mathematical Programming}, 2:19--31, 1972.
\newblock \doi{10.1007/BF01584535}.

\bibitem[White(2011)]{white2011}
Jacob~A. White.
\newblock On multivariate chromatic polynomials of hypergraphs and hyperedge
  elimination.
\newblock \emph{Electronic Journal of Combinatorics}, 18(1):P160, 2011.
\newblock \doi{10.37236/647}.

\bibitem[Sokal(2005)]{sokal2005}
Alan~D. Sokal.
\newblock The multivariate {T}utte polynomial (alias {P}otts model) for graphs
  and matroids.
\newblock In \emph{Surveys in Combinatorics 2005}, pages 173--226. Cambridge
  University Press, 2005.
\newblock \doi{10.1017/CBO9780511734885.009}.
\newblock arXiv:math/0503607.

"""
    text = text.replace(bib_anchor, extra_bib + bib_anchor, 1)
    write(path, text)


def patch_readme() -> None:
    content = f"""# {NEW_TITLE}

**Author:** Samuil Petkov  
**Manuscript revision:** 24 July 2026

This repository contains an alternative proof of the finite classification in
Erdős Problem 593, a complete Lean 4 verification of the implementation, and
new finite consequences of the classification.

## Priority and public chronology

Eric Li's arXiv:2606.24882v1, submitted on 23 June 2026, contains the first
publicly posted complete mathematical proof of the classification and
introduces the one-apex and bridge-trace framework used in the negative half.
Those dependencies are cited at their points of use.

The public Lean history here begins on 15 July 2026.  The complete finite
structural classification was public later that day, and the complete Problem
593 endpoints were public by 19 July.  Li's v2 and separate public Lean
formalisation followed on 23 July.  On those timestamps, this is the earliest
complete public Lean formalisation located in the present audit.  This is a
statement about public records only, not private development or influence.  See
[`PUBLIC_CHRONOLOGY.md`](PUBLIC_CHRONOLOGY.md) for the dated commits.

## Further finite results

The revised manuscript derives:

- the exact order--size--component spectrum for reduced obligatory systems;
- the exact Levi cycle-rank spectrum and endpoint rigidity;
- a forbidden-Levi-subgraph formulation using four-cycles, cycles of length
  `2 mod 4`, and full thetas rooted at hyperedge-nodes;
- hereditary matching--transversal equality through balanced-hypergraph theory;
- canonical weak and strong colouring-polynomial factorisations.

The full proof ledger is in
[`FURTHER_FINITE_RESULTS.md`](FURTHER_FINITE_RESULTS.md).

## Main theorem

For every finite triple system `F`, the checked public endpoints are

```lean
F.IsObligatory ↔ F.isolatedReduction.Intrinsic
F.IsObligatory ↔ Constructible F.isolatedReduction
```

The intrinsic predicate consists of linearity, a bridge incident with every
hyperedge-node of the Levi graph, and even length of every Berge cycle.  The
constructive class is generated from private-vertex expansions of finite
bipartite graphs and finite edgeless systems under finite disjoint unions and
one-point amalgamations.

## Manuscript files

- `erdos593_obligatory_triple_systems.tex` — canonical A4 `amsart` source.
- `erdos593_obligatory_triple_systems.pdf` — compiled manuscript.
- `erdos593_obligatory_triple_systems.md` — readable Markdown version.
- `arxiv/Erdos593_arxiv_source.zip` — submission-ready source archive.
- `FURTHER_FINITE_RESULTS.md` — detailed derivation of the new finite results.
- `PUBLIC_CHRONOLOGY.md` — timestamped mathematical and Lean chronology.
- `references.bib` — bibliography maintenance file.
- `SOURCE_LEDGER.md` — source, priority, and proof-dependency record.
- `REVISION_NOTES.md` — record of the 24 July revision.
- `formalization/` — complete Lean project and generated one-file source closure.

## Build

```bash
./build.sh
cd formalization
python scripts/generate_self_contained.py --check
lake env lean Erdos593.lean
lake env lean Erdos593SelfContained.lean
```

See `formalization/SELF_CONTAINED_BUILD.md` for exact scope and verification
instructions, and `formalization/PROVENANCE.md` for the relationship between the
formalised proof and Li's v1.

## AI-use statement

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle were used for proof
development, adversarial checking, editorial restructuring, and Lean
formalisation.  Samuil Petkov reviewed the incorporated material and accepts
responsibility for the mathematics, citations, attribution, and conclusions.

## License

Original repository material is licensed under CC BY 4.0.  Third-party results
and references retain their own rights and attribution requirements.

## Manuscript synchronization

This section is regenerated by `scripts/sync_manuscript_artifacts.py`.
"""
    write("README.md", content)


def patch_source_ledger() -> None:
    content = """# Source, priority, and dependency ledger

**Author:** Samuil Petkov  
**Revision date:** 24 July 2026

## Classification priority

Eric Li's *A Resolution of Erdős Problems 593 and 1177: Obligatory Triple
Systems and Exact Spectra* (arXiv:2606.24882v1), submitted on 23 June 2026,
contains the first publicly posted complete proof of the finite classification
in Erdős Problem 593.

The present proof cites Li where it uses the complete-rank one-apex lift,
bridge-trace strategy, selected-incidence decomposition, quotient forest, and
running-intersection architecture.  It does not claim mathematical priority
for those ingredients.

## Public Lean chronology

The public repository history records:

- a verified Lean scaffold on 15 July 2026;
- the complete finite constructive/intrinsic classification later on 15 July;
- the complete Problem 593 endpoints by 19 July;
- Li's separate public formalisation and arXiv v2 announcement on 23 July.

On those public timestamps, this repository is the earliest complete public
Lean formalisation located in the present audit.  The precise commits and UTC
conversion are recorded in `PUBLIC_CHRONOLOGY.md`.  No inference about private
development or influence is made.

## Additional finite deductions

The 24 July revision derives an exact order--size--component spectrum, an exact
Levi cycle-rank spectrum, lower-endpoint rigidity, a forbidden-Levi-subgraph
criterion, a balanced-hypergraph consequence, and weak/strong
colouring-polynomial factorisations.  Detailed proofs and the novelty search
are recorded in `FURTHER_FINITE_RESULTS.md`.

## Imported proof interfaces

| Source | Role in the manuscript |
|---|---|
| Erdős--Hajnal (1966), Theorem 7.4 | Uncountably chromatic graphs with prescribed odd-girth bound. |
| de Bruijn--Erdős (1951), Theorem 1 | Graph-colouring compactness. |
| Erdős--Rado (1956), Theorem 4(i), formula (95) | Pair partition relation for the linear avoidance host. |
| Berge--Las Vergnas (1970); Berge (1972) | Hereditary König property of balanced hypergraphs. |
| White (2011); Sokal (2005) | Chromatic-polynomial and Potts/Tutte interfaces. |

## Public source access

- Li v1/v2: <https://arxiv.org/abs/2606.24882>
- Erdős--Hajnal (1966): <https://combinatorica.hu/~p_erdos/1966-07.pdf>
- de Bruijn--Erdős (1951): <https://users.renyi.hu/~p_erdos/1951-01.pdf>
- Erdős--Rado (1956): <https://users.renyi.hu/~p_erdos/1956-02.pdf>
- Reiher (2024): <https://arxiv.org/abs/2403.11223>
- Sokal (2005): <https://arxiv.org/abs/math/0503607>

## AI-use record

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle assisted with proof
development, checking, editing, and Lean formalisation.  The author reviewed
all incorporated material and assumes responsibility for the final work.
"""
    write("SOURCE_LEDGER.md", content)


def patch_provenance() -> None:
    content = """# Formalisation provenance and attribution

Eric Li's arXiv:2606.24882v1, submitted on 23 June 2026, contains the first
publicly posted complete mathematical proof of Erdős Problem 593.  It
introduces the complete-rank one-apex sequence lift and bridge-trace theorem;
its selected-incidence, quotient-forest, and running-intersection architecture
is cited in the manuscript.

The Lean development in this repository is a separate implementation.  Its
principal implementation choices are:

- an explicit base-node, base-letter, base-fibre, and canonical-apex API;
- a support-incidence forest proof of the global finite-linear trace theorem;
- direct finite graph-factor and private-vertex-expansion interfaces;
- a machine-checked rooted-abundance and one-point-amalgamation closure route;
- a machine-checked Erdős--Rado nonlinear host; and
- an explicit shift-graph realisation of the high-odd-girth input.

## Public timestamps

- `ba37b8c` (15 July 2026): verified Lean scaffold;
- `6fd00a7` (15 July 2026): complete finite structural classification;
- `8153938` (19 July 2026, Europe/Sofia): complete Problem 593 endpoints;
- arXiv:2606.24882v2 and Li's separate public Lean repository (23 July 2026).

Accordingly, this is the earliest complete public Lean formalisation located in
the present audit, while Li's v1 retains priority for the mathematical
classification.  See `PUBLIC_CHRONOLOGY.md` for exact links and UTC timestamps.
This is a public-record statement only and makes no inference about private
development or influence.
"""
    write("formalization/PROVENANCE.md", content)


def patch_revision_notes() -> None:
    content = """# Revision notes: finite consequences and public chronology

**Revision date:** 24 July 2026

1. Added the exact order--size--component spectrum for reduced obligatory
   systems, including all intermediate values.
2. Added the exact Levi cycle-rank spectrum, the forest/tree upper endpoint,
   and rigidity for the square and pronic lower-endpoint families.
3. Added a forbidden-Levi-subgraph formulation using four-cycles, cycles of
   length `2 mod 4`, and full thetas rooted at hyperedge-nodes.
4. Added the balanced-hypergraph consequence `nu = tau` for every vertex/edge
   deletion, with primary citations to Berge and Las Vergnas.
5. Added canonical weak and strong colouring-polynomial factorisations through
   the bipartite expansion pieces.
6. Added `FURTHER_FINITE_RESULTS.md` as a detailed proof and source ledger.
7. Added `PUBLIC_CHRONOLOGY.md`, separating Li's v1 mathematical priority from
   the public chronology of the two Lean developments.
8. Recorded that the complete Problem 593 endpoints in this repository were
   public by 19 July 2026, before Li's 23 July v2 announcement and public Lean
   commit.  The wording is limited to public records and makes no inference
   about influence.
9. Condensed the repeated discussion of Li's work while retaining the first
   preprint credit and point-of-use citations.
10. Retained Tom de Groot's acknowledgment in full and shortened the Eric Li
    acknowledgment to the fact of the discussion.
11. Updated the title, abstract, metadata, bibliography, README, source ledger,
    and deterministic manuscript artifacts for the new results.
"""
    write("REVISION_NOTES.md", content)


def patch_citation() -> None:
    content = f"""cff-version: 1.2.0
message: >-
  If you use material from this repository, please cite Samuil Petkov using
  the metadata below.  Eric Li's arXiv:2606.24882v1 should also be cited for
  the first complete proof of the Problem 593 classification where relevant.
title: "{NEW_TITLE}"
type: article
authors:
  - family-names: Petkov
    given-names: Samuil
version: 1.3.0
date-released: 2026-07-24
url: "https://github.com/SamPetkov/Erdos593"
repository-code: "https://github.com/SamPetkov/Erdos593"
license: CC-BY-4.0
references:
  - type: article
    title: "A Resolution of Erdős Problems 593 and 1177: Obligatory Triple Systems and Exact Spectra"
    authors:
      - family-names: Li
        given-names: Eric
    year: 2026
    doi: "10.48550/arXiv.2606.24882"
    url: "https://arxiv.org/abs/2606.24882"
"""
    write("CITATION.cff", content)


def patch_references_bib() -> None:
    path = "references.bib"
    text = read(path)
    text = replace_required(
        text,
        "note         = {Submitted 23 June 2026; arXiv:2606.24882}",
        "note         = {v1 submitted 23 June 2026; v2 submitted 23 July 2026; arXiv:2606.24882}",
        "Li BibTeX version note",
    )
    if "@article{berge1972" not in text:
        text += r"""

@article{bergelasvergnas1970,
  author       = {Berge, Claude and Las Vergnas, Michel},
  title        = {Sur un th{\'e}or{\`e}me du type {K}{\"o}nig pour hypergraphes},
  journal      = {Annals of the New York Academy of Sciences},
  volume       = {175},
  number       = {1},
  year         = {1970},
  pages        = {32--40},
  doi          = {10.1111/j.1749-6632.1970.tb56451.x}
}

@article{berge1972,
  author       = {Berge, Claude},
  title        = {Balanced Matrices},
  journal      = {Mathematical Programming},
  volume       = {2},
  year         = {1972},
  pages        = {19--31},
  doi          = {10.1007/BF01584535}
}

@article{white2011,
  author       = {White, Jacob A.},
  title        = {On Multivariate Chromatic Polynomials of Hypergraphs and Hyperedge Elimination},
  journal      = {Electronic Journal of Combinatorics},
  volume       = {18},
  number       = {1},
  year         = {2011},
  pages        = {P160},
  doi          = {10.37236/647}
}

@incollection{sokal2005,
  author       = {Sokal, Alan D.},
  title        = {The Multivariate {T}utte Polynomial (Alias {P}otts Model) for Graphs and Matroids},
  booktitle    = {Surveys in Combinatorics 2005},
  publisher    = {Cambridge University Press},
  year         = {2005},
  pages        = {173--226},
  doi          = {10.1017/CBO9780511734885.009},
  eprint       = {math/0503607},
  archiveprefix = {arXiv}
}
"""
    write(path, text)


def patch_sync_script() -> None:
    path = "scripts/sync_manuscript_artifacts.py"
    text = read(path)
    text = replace_required(
        text,
        r'        r"\title[Obligatory triple systems]{Obligatory Triple Systems: An Alternative Proof}",',
        rf'        r"\title[Obligatory triple systems]{{{NEW_TITLE}}}",',
        "sync required title",
    )
    old_required = '''        "first publicly posted complete classification",\n        "no claim of informational independence",\n        "complete Lean formalisation",'''
    new_required = '''        "first publicly posted complete",\n        "earliest complete public Lean",\n        "Exact finite order--size--component spectrum",'''
    text = replace_required(text, old_required, new_required, "sync required wording")
    text = replace_required(
        text,
        "# Obligatory Triple Systems: An Alternative Proof\n\n**Samuil Petkov**  \n21 July 2026",
        f"# {NEW_TITLE}\n\n**Samuil Petkov**  \n24 July 2026",
        "Markdown publication header",
    )
    text = replace_required(
        text,
        "**Keywords.** obligatory triple system; hypergraph colouring; Levi graph; Berge cycle; uncountable chromatic number; Erdős Problem 593",
        "**Keywords.** obligatory triple system; finite parameter spectrum; hypergraph colouring; Levi graph; Berge cycle; balanced hypergraph; chromatic polynomial; Erdős Problem 593",
        "Markdown keywords",
    )
    text = replace_required(
        text,
        'body = re.sub(r"^#?\\s*Obligatory Triple Systems: An Alternative Proof\\s*\\n+", "", body, count=1)',
        f'body = re.sub(r"^#?\\s*{re.escape(NEW_TITLE)}\\s*\\n+", "", body, count=1)',
        "Markdown title stripping",
    )
    text = replace_required(text, '"SOURCE_DATE_EPOCH": "1784635200"', '"SOURCE_DATE_EPOCH": "1784894400"', "PDF epoch")
    text = replace_required(text, '(2026, 7, 21, 12, 0, 0)', '(2026, 7, 24, 12, 0, 0)', "ZIP timestamp")
    write(path, text)


def patch_manuscript_workflow() -> None:
    path = ".github/workflows/manuscript-artifacts.yml"
    text = read(path)
    expanded = """      - 'README.md'\n      - 'FURTHER_FINITE_RESULTS.md'\n      - 'PUBLIC_CHRONOLOGY.md'\n      - 'SOURCE_LEDGER.md'\n      - 'REVISION_NOTES.md'\n      - 'formalization/PROVENANCE.md'\n      - 'references.bib'"""
    text = text.replace("      - 'README.md'", expanded)
    sed_block = """          sed -i 's/no claim of full informational independence/no claim of informational independence/g' \\
            erdos593_obligatory_triple_systems.tex
          python -u scripts/sync_manuscript_artifacts.py 2>&1 | tee manuscript-sync.log"""
    text = replace_required(
        text,
        sed_block,
        "          python -u scripts/sync_manuscript_artifacts.py 2>&1 | tee manuscript-sync.log",
        "obsolete workflow normalization",
    )
    text = replace_required(
        text,
        "grep -Fq 'Obligatory Triple Systems: An Alternative Proof' /tmp/erdos593-pdfinfo.txt",
        f"grep -Fq '{NEW_TITLE}' /tmp/erdos593-pdfinfo.txt",
        "PDF title verification",
    )
    text = replace_required(
        text,
        "grep -Fq 'Eric Li' /tmp/erdos593-text.txt",
        "grep -Fq 'Eric Li' /tmp/erdos593-text.txt\n            grep -Fq 'Exact finite order--size--component spectrum' /tmp/erdos593-text.txt\n            grep -Fq 'earliest complete public Lean formalisation' /tmp/erdos593-text.txt",
        "new PDF content verification",
    )
    write(path, text)


def main() -> None:
    patch_tex()
    patch_readme()
    patch_source_ledger()
    patch_provenance()
    patch_revision_notes()
    patch_citation()
    patch_references_bib()
    patch_sync_script()
    patch_manuscript_workflow()


if __name__ == "__main__":
    main()
