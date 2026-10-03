# Obligatory Triple Systems: Alternative Proof and Lean Verification

**Author:** Samuil Petkov  
**Manuscript revision:** 24 July 2026

This repository contains an alternative proof of the finite classification in
Erdős Problem 593, a complete Lean 4 verification of the implementation used
here, and sharp finite consequences of the classification.

For every finite triple system `F`, the checked public endpoints are

```lean
F.IsObligatory ↔ F.isolatedReduction.Intrinsic
F.IsObligatory ↔ Constructible F.isolatedReduction
```

The intrinsic predicate consists of linearity, an incident Levi-graph bridge at
every hyperedge-node, and even length of every Berge cycle. The constructive
class is generated from private-vertex expansions of finite bipartite graphs
and finite edgeless systems under finite disjoint unions and one-point
amalgamations.

## New finite parameter spectrum

For integers `m ≥ 1` and `1 ≤ c ≤ m`, a reduced obligatory triple system with
`m` hyperedges, `n` vertices, and exactly `c` connected components exists if
and only if

\[
m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
\le n\le 2m+c.
\]

Every integer in this interval occurs. In particular, the connected range is

\[
m+\left\lceil2\sqrt m\right\rceil\le n\le2m+1,
\]

and the reduced range without a prescribed component count is

\[
m+\left\lceil2\sqrt m\right\rceil\le n\le3m.
\]

The branch note [`FINITE_PARAMETER_SPECTRUM.md`](FINITE_PARAMETER_SPECTRUM.md)
contains the bipartite-shadow proof, the exact Levi cycle-rank spectrum,
balanced-endpoint rigidity, and an edge-deletion reformulation of the bridge
condition.

## Relationship to Eric Li's preprint

Eric Li's preprint, posted on 23 June 2026, was the first publicly posted
complete mathematical proof of the classification and introduced the
complete-rank one-apex lift and bridge-trace method used in the negative
direction. This repository gives a different proof implementation and retains
point-of-use citations to that work.

The public commit history records a checked Lean scaffold on 15 July 2026 and
the complete finite structural classification later that day in commit
[`6fd00a7`](https://github.com/SamPetkov/Erdos593/commit/6fd00a76064401f3f10aabef474f59d3c6ecd6bf).
To the author's knowledge, this is the first publicly timestamped Lean
formalisation of the finite structural theorem. Li's later arXiv v2 contains a
separate formal verification of his broader paper. No claim of shared code or
derivation between the two Lean developments is made.

## Manuscript files

- `erdos593_obligatory_triple_systems.tex` — canonical A4 `amsart` source.
- `erdos593_obligatory_triple_systems.pdf` — compiled manuscript.
- `erdos593_obligatory_triple_systems.md` — readable Markdown version.
- `arxiv/Erdos593_arxiv_source.zip` — submission-ready self-contained source archive.
- `FINITE_PARAMETER_SPECTRUM.md` — proof note for the new finite consequences.
- `references.bib` — bibliography maintenance file.
- `SOURCE_LEDGER.md` — source, priority, chronology, and proof-dependency record.
- `REVISION_NOTES.md` — record of manuscript and release-readiness revisions.
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
instructions, and `formalization/PROVENANCE.md` for the public formalisation
chronology and the relationship between the two proof implementations.

## AI-use statement

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle were used for proof
development, adversarial checking, editorial restructuring, and Lean
formalisation. Samuil Petkov is the sole named author and accepts responsibility
for the mathematics, citations, attribution, and conclusions.

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

CI reruns the same synchronization and commits regenerated artifacts back to
same-repository pull-request branches when necessary.  The synchronization
script does not modify the Lean formalization.  Markdown generation is pinned to Pandoc 3.1.3; set the
`PANDOC` environment variable to a compatible executable when another version
is first on `PATH`.
