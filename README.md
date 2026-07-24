# Obligatory Triple Systems: An Alternative Proof, Finite Parameter Spectra, and Lean Verification

**Author:** Samuil Petkov  
**Manuscript revision:** 24 July 2026

This repository contains an alternative proof of the finite classification in
Erdős Problem 593, a complete Lean 4 verification of the classification
implementation presented here, and new exact finite parameter consequences.

Eric Li's 23 June 2026 v1 is the first publicly posted complete mathematical
proof of the classification and is cited where its one-apex lift, bridge-trace
method, and reconstruction architecture are used. The proof and formalisation
in this repository use a separately organised all-bridges/base-fibre
implementation.

The public commit history records a Lean scaffold on 15 July 2026 and the
complete finite structural classification later that day, before the separate
repository accompanying Li's broader v2 formalisation. Accordingly this is the
earlier publicly timestamped Lean formalisation of the finite Problem 593
classification; Li's later development covers both Problems 593 and 1177.

## Main classification

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

## New finite parameter spectra

For integers `m ≥ 1` and `1 ≤ c ≤ m`, an obligatory triple system without
isolated vertices exists with `m` hyperedges, `n` vertices, and exactly `c`
Levi components if and only if

```text
m + 2(c - 1) + ceil(2 sqrt(m - c + 1)) ≤ n ≤ 2m + c.
```

Every integer in the interval occurs. In particular, the connected orders are
exactly

```text
m + ceil(2 sqrt(m)) ≤ n ≤ 2m + 1,
```

and, with no prescribed component count, the orders are exactly

```text
m + ceil(2 sqrt(m)) ≤ n ≤ 3m.
```

The manuscript also gives an edge-deletion formulation of the bridge condition,
the exact Levi cycle-rank spectrum, and rigidity of the dense endpoints
`K_{t,t}^+` and `K_{t,t+1}^+`.

## Manuscript files

- `erdos593_obligatory_triple_systems.tex` — canonical A4 `amsart` source.
- `erdos593_obligatory_triple_systems.pdf` — compiled manuscript.
- `erdos593_obligatory_triple_systems.md` — readable Markdown version.
- `arxiv/Erdos593_arxiv_source.zip` — submission-ready source archive containing only `main.tex`.
- `references.bib` — bibliography maintenance file.
- `SOURCE_LEDGER.md` — source, chronology, and proof-dependency record.
- `REVISION_NOTES.md` — record of the finite-spectrum and attribution revisions through 24 July.
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
instructions, and `formalization/PROVENANCE.md` for the formalisation chronology
and relationship between the two public projects.

## AI-use and provenance statement

OpenAI's GPT-5.6 Pro through ChatGPT and Aristotle were used for proof
development, adversarial checking, editorial restructuring, and Lean
formalisation. Samuil Petkov is the sole named author and accepts responsibility
for the mathematics, citations, attribution, and conclusions. The dated commit
history is used for formalisation chronology; no claim is made that either
formal development was derived from the other.

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
