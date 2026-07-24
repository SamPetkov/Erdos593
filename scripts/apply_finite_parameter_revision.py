from pathlib import Path

TEX = Path('erdos593_obligatory_triple_systems.tex')
SYNC = Path('scripts/sync_manuscript_artifacts.py')
SECTION = Path('scripts/finite_parameter_section.tex')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected exactly one occurrence, found {count}')
    return text.replace(old, new, 1)


text = TEX.read_text(encoding='utf-8')
text = replace_once(
    text,
    '  pdfsubject={An alternative proof and Lean verification of the classification of finite obligatory triple systems first proved by Eric Li},',
    '  pdfsubject={An alternative proof, finite parameter consequences, and Lean verification for obligatory triple systems},',
    'PDF subject',
)
text = replace_once(text, r'\date{21 July 2026}', r'\date{24 July 2026}', 'date')

start = text.index(r'\begin{abstract}')
end = text.index(r'\end{abstract}', start) + len(r'\end{abstract}')
text = text[:start] + r'''\begin{abstract}
We present an alternative proof of the classification of finite obligatory
triple systems, together with a Lean formalisation and sharp finite parameter
consequences.  After isolated vertices are removed, obligatoriness is
equivalent to linearity, incidence of every hyperedge-node of the Levi graph
with a bridge, and evenness of every Berge cycle; equivalently, the systems
are generated from private-vertex expansions of finite bipartite graphs and
finite edgeless systems by disjoint unions and one-point amalgamations.  The
positive direction uses a probabilistic rainbow lemma and rooted abundance,
while the intrinsic decomposition deletes selected Levi-graph bridges and
reassembles the resulting expansion pieces along a quotient forest.  The
negative direction uses a one-apex sequence lift in a base-fibre and
support-incidence form.  As a new finite consequence, a reduced obligatory
system with $m\ge1$ hyperedges and $c$ connected components has order $n$
precisely when
\[
m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
\le n\le 2m+c.
\]
All arguments are in ZFC.
\end{abstract}''' + text[end:]

text = replace_once(text, r'''Theorem~A, including both the constructive and intrinsic formulations, was
first proved by \citet[Theorem~1.1]{li2026}.  Li also introduced the
complete-rank one-apex sequence lift and exact bridge-trace theorem that
organise the negative half of the proof
\citep[Sections~3--4 and Theorem~4.6]{li2026}.  The author began developing
the present argument before becoming aware of Li's preprint, but, for the
provenance reasons stated at the end of the paper, no claim of informational
independence is made.  This paper presents an alternative proof and a Lean
formalisation of the finite classification.  Its main expository difference
is to replace the bridge-selector derivative theorem by an explicit
base-fibre decomposition and support-incidence forest suited to machine
checking.''', r'''Li's preprint, posted on 23 June 2026, contains the first publicly posted
complete mathematical proof of Theorem~A \citep[Theorem~1.1]{li2026}.  It
also introduced the complete-rank one-apex lift and bridge-trace method used
in the negative direction \citep[Sections~3--4 and Theorem~4.6]{li2026}.
The present paper gives a different implementation, direct positive
arguments, sharp finite parameter consequences, and a Lean formalisation of
this implementation.''', 'priority paragraph')

text = replace_once(text, r'''\paragraph{Relation to Li's proof.}
The classification theorem, complete-rank one-apex lift, bridge-trace
architecture, selected-incidence decomposition, quotient forest, and
running-intersection assembly all appear in Li's preprint
\citep[Sections~3--5]{li2026}.  The present paper makes no priority claim for
those ingredients.  Its alternative implementation gives direct proofs of
the positive expansion atoms and closure statements in the notation used
here, replaces the bridge-selector derivative formalism by an explicit
base-fibre and support-incidence analysis, invokes the older Erdős--Hajnal
high-odd-girth theorem directly, and supplies a complete Lean formalisation of
this implementation.

''', '', 'relation paragraph')

text = replace_once(text,
    "On the negative side, we use Li's one-apex sequence-lift strategy\n\\citep[Sections~3--4]{li2026}.",
    "On the negative side, we use the one-apex sequence-lift strategy of\n\\citet[Sections~3--4]{li2026}.",
    'negative-side attribution')

text = replace_once(text, r'''The selected-incidence decomposition, quotient forest, and running-intersection
architecture in this section follow the positive structural framework of
\citet[Sections~4--5]{li2026}.  We give the full argument in the present
notation because its explicit assembly order is also used by the Lean
development.''', r'''We give the selected-incidence decomposition and running-intersection
argument in the explicit form used by the Lean development; compare the
structural framework in \citet[Sections~4--5]{li2026}.''', 'decomposition intro')

text = replace_once(text, r'''The one-apex construction and bridge-trace strategy were introduced by Li
\citep[Sections~3--4 and Theorem~4.6]{li2026}.  We specialise the lift to
$\omega_1$ and replace Li's bridge-selector derivative formulation by a
base-fibre and support-incidence decomposition convenient for formalisation.
The detailed proof below is self-contained as an exposition, but it is not a
claim of independent discovery.''', r'''We use the one-apex construction and bridge-trace strategy of
\citet[Sections~3--4 and Theorem~4.6]{li2026}, specialised to $\omega_1$ and
written as a base-fibre and support-incidence decomposition convenient for
formalisation.''', 'lift intro')

section = SECTION.read_text(encoding='utf-8').rstrip() + '\n\n'
marker = r'\section*{Formal verification and reproducibility}'
if text.count(marker) != 1:
    raise SystemExit('formal verification marker mismatch')
text = text.replace(marker, section + marker, 1)

text = replace_once(text, r'''Li's preprint, posted on 23 June 2026, contains the first publicly posted
complete proof of Theorem~A \citep[Theorem~1.1]{li2026}.  The present Lean
development is a separate formal verification of the alternative proof
organised in this paper; it is not a line-by-line formalisation of Li's
manuscript and carries no priority claim.  The
self-contained Lean~4 source is available in the public
\href{https://github.com/SamPetkov/Erdos593/blob/main/formalization/Erdos593SelfContained.lean}{\texttt{Erdos593} repository}.''', r'''The self-contained Lean~4 source is available in the public
\href{https://github.com/SamPetkov/Erdos593/blob/main/formalization/Erdos593SelfContained.lean}{\texttt{Erdos593} repository}.
The public commit history records a checked formalisation scaffold on
\href{https://github.com/SamPetkov/Erdos593/commit/ba37b8c511ab390c14a905110366d7cac1ffa08f}{15 July 2026}
and the complete finite structural classification later that day in
\href{https://github.com/SamPetkov/Erdos593/commit/6fd00a76064401f3f10aabef474f59d3c6ecd6bf}{commit \texttt{6fd00a7}}.
To the author's knowledge, this is the first publicly timestamped Lean
formalisation of the finite structural theorem.  Li's arXiv v2, submitted on
23 July 2026, contains a separate formal verification of the broader results
in his paper.  No assertion of shared code or derivation between the two Lean
developments is made.''', 'formal chronology')

ack_start = text.index(r'\section*{Acknowledgments}')
funding = text.index(r'\section*{Funding}', ack_start)
text = text[:ack_start] + r'''\section*{Acknowledgments}

The author thanks Tom de Groot for his advice on revising the manuscript for
greater clarity.  The author also thanks Eric Li for a discussion of the
relationship between the two proofs.

\section*{AI assistance}

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle~\citep{achim-et-al-2025}
were used for proof development, adversarial checking, editorial restructuring,
and the Lean formalisation.  The author reviewed all incorporated suggestions
and assumes full responsibility for the arguments, citations, and final
manuscript.

''' + text[funding:]

TEX.write_text(text, encoding='utf-8')

sync = SYNC.read_text(encoding='utf-8')
sync = replace_once(sync, '21 July 2026\n\n**2020 Mathematics', '24 July 2026\n\n**2020 Mathematics', 'Markdown date')
sync = replace_once(sync, '"SOURCE_DATE_EPOCH": "1784635200"', '"SOURCE_DATE_EPOCH": "1784894400"', 'PDF epoch')
sync = replace_once(sync, '(2026, 7, 21, 12, 0, 0)', '(2026, 7, 24, 12, 0, 0)', 'ZIP date')
sync = replace_once(sync, '''        "first publicly posted complete classification",
        "no claim of informational independence",
        "complete Lean formalisation",''', '''        "first publicly posted complete mathematical proof",
        "first publicly timestamped Lean",
        "Exact order--size--component spectrum",''', 'release wording checks')
sync = replace_once(sync, '''CI reruns the same synchronization and fails when a committed mirror differs
from the canonical TeX source.  The synchronization script does not modify the
Lean formalization.''', '''CI reruns the same synchronization and commits regenerated artifacts back to
same-repository pull-request branches when necessary.  The synchronization
script does not modify the Lean formalization.''', 'sync note')
SYNC.write_text(sync, encoding='utf-8')

print('applied finite-parameter manuscript revision')
