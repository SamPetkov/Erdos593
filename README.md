# Obligatory Triple Systems: Alternative Proof and Lean Verification

**Author:** Samuil Petkov  
**Manuscript revision:** 21 July 2026

This repository contains an alternative proof of the finite classification in
Erdős Problem 593 and a complete Lean 4 formal verification of the proof
implementation presented here.

Eric Li's preprint, posted on 23 June 2026, contains the first publicly posted
complete proof of the classification. It also introduces the complete-rank
one-apex sequence lift and exact bridge-trace architecture used in the negative
half of the theorem. This repository makes no competing priority claim for the
classification or those ingredients. The manuscript cites Li at the points
where the one-apex lift, bridge-trace, selected-incidence, quotient-forest, and
running-intersection architecture is used.

The present implementation differs in its detailed organisation: it gives
explicit direct proofs of the positive expansion atoms and closure statements,
uses a base-fibre and support-incidence formulation of the finite trace theorem,
invokes the older Erdős--Hajnal high-odd-girth theorem in the written proof, and
supplies a complete machine-checked Lean development of this implementation.
The Lean project is not a line-by-line formalisation of Li's manuscript.

## Main theorem

For every finite triple system `F`, the checked public endpoints are

```lean
F.IsObligatory ↔ F.isolatedReduction.Intrinsic
F.IsObligatory ↔ Constructible F.isolatedReduction
```

The intrinsic predicate consists of linearity, a bridge incident with every
hyperedge-node of the Levi graph, and even length of every Berge cycle. The
constructive class is generated from private-vertex expansions of finite
bipartite graphs and finite edgeless systems under finite disjoint unions and
one-point amalgamations.

## Manuscript files

- `erdos593_obligatory_triple_systems.tex` — canonical A4 `amsart` source.
- `erdos593_obligatory_triple_systems.pdf` — compiled manuscript.
- `erdos593_obligatory_triple_systems.md` — readable Markdown version.
- `arxiv/Erdos593_arxiv_source.zip` — submission-ready source archive containing only `main.tex`.
- `references.bib` — bibliography maintenance file.
- `SOURCE_LEDGER.md` — source, priority, and proof-dependency record.
- `REVISION_NOTES.md` — record of the attribution and release-readiness revisions through 21 July.
- `formalization/` — complete Lean project and generated one-file source closure.

The manuscript uses numeric citations, A4 paper, one-inch margins, standard AMS
theorem environments, embedded fonts, and populated PDF metadata. The visible
institutional address and email are intentionally omitted.

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
formalised proof and Li's preprint.

## AI-use and provenance statement

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle were used for proof
development, adversarial checking, editorial restructuring, and Lean
formalisation. The author began developing the argument before becoming aware
of Li's preprint. During substantial stages the models were instructed to work
without further internet access after initial source retrieval, but that
instruction is not an auditable guarantee of informational independence.
Accordingly, neither the manuscript nor this repository claims full
informational independence. Samuil Petkov is the sole named author and accepts
responsibility for the mathematics, citations, attribution, and conclusions.

## License

Original repository material is licensed under CC BY 4.0. Third-party results
and references retain their own rights and attribution requirements.

## Manuscript synchronization

`erdos593_obligatory_triple_systems.tex` is the sole authoritative manuscript
source.  The root PDF and Markdown file, the `arxiv/main.*` mirrors,
`Erdos593_revised.tex`, and `arxiv/Erdos593_arxiv_source.zip` are deterministic
generated artifacts.  The arXiv ZIP contains only `main.tex`, since the
bibliography is embedded in that file.  Regenerate everything with:

```bash
python scripts/sync_manuscript_artifacts.py
```

CI reruns the same synchronization and fails when a committed mirror differs
from the canonical TeX source.  The synchronization script does not modify the
Lean formalization.  Markdown generation is pinned to Pandoc 3.1.3; set the
`PANDOC` environment variable to a compatible executable when another version
is first on `PATH`.
