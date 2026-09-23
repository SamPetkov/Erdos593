#!/usr/bin/env python3
"""Integrate the audited block/factorization-lattice results into the manuscript.

The script is deterministic and idempotent. It patches the sole authoritative
TeX manuscript, source bibliography, and fail-closed theorem inventory. The
existing artifact synchronizer then regenerates all PDF/Markdown/arXiv mirrors.
"""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "erdos593_obligatory_triple_systems.tex"
REFERENCES = ROOT / "references.bib"
THEOREM_AUDIT = ROOT / "scripts" / "audit_manuscript_theorems.py"
FRAGMENT = (
    ROOT
    / "research_extensions"
    / "01_canonical_atom_forest"
    / "MANUSCRIPT_BLOCK_AND_LATTICE_EXTENSION.tex"
)
BIB_FRAGMENT = (
    ROOT
    / "research_extensions"
    / "01_canonical_atom_forest"
    / "MANUSCRIPT_BLOCK_AND_LATTICE_BIBLIOGRAPHY.bib"
)

SECTION_LABEL = r"\label{corollary-factorization-lattice-spectrum}"
FORMAL_MARKER = r"\section*{Formal verification and reproducibility}"


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected one occurrence, found {count}")
    return text.replace(old, new, 1)


def manuscript_fragment() -> str:
    text = FRAGMENT.read_text(encoding="utf-8")
    lines = [line for line in text.splitlines() if not line.startswith("%")]
    body = "\n".join(lines).strip()
    required = [
        r"\label{remark-komjath-block-reduction}",
        r"\label{corollary-block-formulation}",
        r"\label{lemma-local-decomposition-lattice-product}",
        r"\label{lemma-capacity-safe-profile-realization}",
        SECTION_LABEL,
    ]
    missing = [needle for needle in required if needle not in body]
    if missing:
        raise RuntimeError(f"audited manuscript fragment is incomplete: {missing}")
    return body


def patch_tex() -> None:
    text = TEX.read_text(encoding="utf-8")
    if SECTION_LABEL not in text:
        old_abstract = """normal form determines the exact order--size--component spectrum, together
with exact indecomposability, cycle-rank, and atom-count spectra.  The
possible atom counts form an interval, apart from a parity obstruction at
cycle rank one.  The negative direction is proved using a one-apex sequence
lift.  All arguments are in ZFC."""
        new_abstract = """normal form determines the exact order--size--component spectrum, together
with exact indecomposability, cycle-rank, and atom-count spectra.  It also
determines the exact spectrum of one-point factorization lattices at fixed
global parameters.  The possible atom counts form an interval, apart from a
parity obstruction at cycle rank one.  The negative direction is proved using
a one-apex sequence lift.  All arguments are in ZFC."""
        text = replace_once(text, old_abstract, new_abstract, "abstract framing")

        old_contribution = """Our approach supplies direct positive arguments, a separate
fibre-decomposition proof for the negative direction, a canonical atom normal
form, exact finite structural spectra, and a Lean formalisation of the finite
classification."""
        new_contribution = """Our approach supplies direct positive arguments, a separate
fibre-decomposition proof for the negative direction, a canonical atom normal
form, exact finite structural spectra, an exact one-point factorization-lattice
spectrum, and a Lean formalisation of the finite classification."""
        text = replace_once(
            text, old_contribution, new_contribution, "introduction contribution paragraph"
        )

        block = manuscript_fragment()
        text = replace_once(
            text,
            FORMAL_MARKER,
            block + "\n\n" + FORMAL_MARKER,
            "block/lattice manuscript insertion",
        )

        old_formal_scope = """The manuscript proves the canonical-atom normal
form and the exact finite spectra, which are also supported by finite
certificates, but does not claim them as additional Lean endpoints."""
        new_formal_scope = """The manuscript proves the canonical-atom normal
form and the exact finite spectra, including the one-point
factorization-lattice spectrum; these statements are supported by finite
certificates but are not claimed as additional Lean endpoints."""
        text = replace_once(text, old_formal_scope, new_formal_scope, "Lean scope boundary")

        text = replace_once(
            text,
            r"\begin{thebibliography}{13}",
            r"\begin{thebibliography}{15}",
            "bibliography count",
        )

        bibitems = r"""\bibitem[Bahmanian and \v{S}ajna(2015)]{bahmanian2015}
M.~Amin Bahmanian and Mateja \v{S}ajna.
\newblock Connection and separation in hypergraphs.
\newblock \emph{Theory Appl. Graphs}, 2\penalty0 (2):\penalty0 Article~5, 2015.
\newblock \doi{10.20429/tag.2015.020205}.
\newblock URL \url{https://arxiv.org/abs/1504.04274}.

\bibitem[Simon et~al.(2011)Simon, Tittmann, and Trinks]{simon2011}
Frank Simon, Peter Tittmann, and Martin Trinks.
\newblock Counting connected set partitions of graphs.
\newblock \emph{Electron. J. Combin.}, 18\penalty0 (1):\penalty0 P14, 2011.
\newblock \doi{10.37236/501}.
\newblock URL \url{https://arxiv.org/abs/1005.1726}.

"""
        anchor = r"\bibitem[Achim et~al.(2025)Achim, Best, Der, F{\'e}d{\'e}rico, Gukov,"
        text = replace_once(text, anchor, bibitems + anchor, "embedded bibliography additions")
        TEX.write_text(text, encoding="utf-8", newline="\n")
    else:
        required = [
            "exact spectrum of one-point factorization lattices",
            "exact one-point factorization-lattice",
            r"\label{remark-komjath-block-reduction}",
            r"\label{corollary-block-formulation}",
            r"\label{lemma-local-decomposition-lattice-product}",
            r"\label{lemma-capacity-safe-profile-realization}",
            r"\bibitem[Bahmanian and \v{S}ajna(2015)]{bahmanian2015}",
            r"{simon2011}",
            "are not claimed as additional Lean endpoints",
        ]
        missing = [needle for needle in required if needle not in text]
        if missing:
            raise RuntimeError(f"partially integrated manuscript: {missing}")


def patch_references() -> None:
    text = REFERENCES.read_text(encoding="utf-8")
    additions = BIB_FRAGMENT.read_text(encoding="utf-8")
    for key in ("bahmanian2015", "simon2011"):
        if f"{{{key}," in text:
            continue
        marker = f"@article{{{key},"
        start = additions.find(marker)
        if start < 0:
            raise RuntimeError(f"missing bibliography fragment for {key}")
        next_entry = additions.find("\n@article{", start + len(marker))
        entry = additions[start:] if next_entry < 0 else additions[start:next_entry]
        text = text.rstrip() + "\n\n" + entry.strip() + "\n"
    REFERENCES.write_text(text, encoding="utf-8", newline="\n")


def patch_theorem_audit() -> None:
    text = THEOREM_AUDIT.read_text(encoding="utf-8")
    new_entries = """    (\"corollary\", \"corollary-block-formulation\"),
    (\"lemma\", \"lemma-local-decomposition-lattice-product\"),
    (\"lemma\", \"lemma-capacity-safe-profile-realization\"),
    (\"corollary\", \"corollary-factorization-lattice-spectrum\"),
"""
    if "corollary-factorization-lattice-spectrum" not in text:
        anchor = '    ("proposition", "proposition-componentwise-atom-count-spectrum"),\n'
        text = replace_once(
            text,
            anchor,
            anchor + new_entries,
            "theorem inventory extension",
        )
    required_marker = '        "K_{t,t+1}^+",\n'
    if "factorization-lattice-spectrum" not in text.split("def verify_required_markers", 1)[-1]:
        marker_insert = (
            required_marker
            + '        "\\\\label{corollary-factorization-lattice-spectrum}",\n'
            + '        "\\\\mathcal D(F)\\\\cong\\\\prod_{p\\\\in S(F)}\\\\Pi_{\\\\mu(p)}",\n'
        )
        text = replace_once(text, required_marker, marker_insert, "theorem required markers")
    THEOREM_AUDIT.write_text(text, encoding="utf-8", newline="\n")


def validate() -> None:
    text = TEX.read_text(encoding="utf-8")
    required = [
        r"\label{corollary-block-formulation}",
        r"\label{lemma-local-decomposition-lattice-product}",
        r"\label{lemma-capacity-safe-profile-realization}",
        SECTION_LABEL,
        r"\citep{bahmanian2015}",
        r"\citet{simon2011}",
        r"\bibitem[Bahmanian and \v{S}ajna(2015)]{bahmanian2015}",
        "Counting connected set partitions of graphs.",
    ]
    missing = [needle for needle in required if needle not in text]
    if missing:
        raise RuntimeError(f"integrated TeX validation failed: {missing}")

    refs = REFERENCES.read_text(encoding="utf-8")
    for key in ("bahmanian2015", "simon2011"):
        if f"{{{key}," not in refs:
            raise RuntimeError(f"references.bib missing {key}")

    audit = THEOREM_AUDIT.read_text(encoding="utf-8")
    for label in (
        "corollary-block-formulation",
        "lemma-local-decomposition-lattice-product",
        "lemma-capacity-safe-profile-realization",
        "corollary-factorization-lattice-spectrum",
    ):
        if label not in audit:
            raise RuntimeError(f"theorem audit inventory missing {label}")


if __name__ == "__main__":
    patch_tex()
    patch_references()
    patch_theorem_audit()
    validate()
