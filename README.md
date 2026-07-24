# Obligatory Triple Systems: An Alternative Proof, Lean Formalisation, and Finite Consequences

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
