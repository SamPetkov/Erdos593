#!/usr/bin/env python3
"""Integrate the reviewed canonical-atom results into the public manuscript.

The script is deliberately deterministic and idempotent.  It patches the sole
authoritative TeX source, the synchronization/verification metadata, README,
and citation metadata.  The ordinary artifact synchronizer then regenerates
all TeX, Markdown, PDF, arXiv, manifest, and checksum mirrors.
"""

from __future__ import annotations

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "erdos593_obligatory_triple_systems.tex"
SYNC = ROOT / "scripts" / "sync_manuscript_artifacts.py"
MANUSCRIPT_WORKFLOW = ROOT / ".github" / "workflows" / "manuscript-artifacts.yml"
README = ROOT / "README.md"
CITATION = ROOT / "CITATION.cff"
REVISION = ROOT / "REVISION_NOTES.md"

OLD_TITLE = "Obligatory Triple Systems: An Alternative Proof"
NEW_TITLE = "Obligatory Triple Systems: Canonical Atoms and Exact Finite Spectra"
MARKER = r"\label{theorem-canonical-atom-normal-form}"


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected one occurrence, found {count}")
    return text.replace(old, new, 1)


FRAGMENT = ROOT / "reader-first" / "CANONICAL_ATOM_MANUSCRIPT_SECTION.tex"
STRUCTURAL_MARKER = "% === STRUCTURAL BLOCK ==="
FINITE_MARKER = "% === FINITE SPECTRA BLOCK ==="


def load_blocks() -> tuple[str, str]:
    text = FRAGMENT.read_text(encoding="utf-8")
    if text.count(STRUCTURAL_MARKER) != 1 or text.count(FINITE_MARKER) != 1:
        raise RuntimeError("integration fragment markers are missing or duplicated")
    structural = text.split(STRUCTURAL_MARKER, 1)[1].split(FINITE_MARKER, 1)[0].strip()
    finite = text.split(FINITE_MARKER, 1)[1].strip()
    return structural, finite

def patch_tex() -> None:
    canonical_atom_block, finite_atom_block = load_blocks()
    text = TEX.read_text(encoding="utf-8")
    if MARKER not in text:
        text = replace_once(
            text,
            r"pdftitle={Obligatory Triple Systems: An Alternative Proof}",
            r"pdftitle={Obligatory Triple Systems: Canonical Atoms and Exact Finite Spectra}",
            "PDF title",
        )
        text = replace_once(
            text,
            "pdfsubject={An alternative proof, finite parameter consequences, and Lean verification for obligatory triple systems}",
            "pdfsubject={A canonical atom decomposition, exact finite spectra, and Lean verification for obligatory triple systems}",
            "PDF subject",
        )
        text = replace_once(
            text,
            "pdfkeywords={obligatory triple system, hypergraph colouring, Levi graph, Berge cycle, uncountable chromatic number, Erdos Problem 593}",
            "pdfkeywords={obligatory triple system, canonical atom, hypergraph colouring, Levi graph, Berge cycle, exact spectrum, Erdos Problem 593}",
            "PDF keywords",
        )
        text = replace_once(
            text,
            r"\title[Obligatory triple systems]{Obligatory Triple Systems: An Alternative Proof}",
            r"\title[Obligatory triple systems]{Obligatory Triple Systems: Canonical Atoms and Exact Finite Spectra}",
            "document title",
        )
        text = replace_once(
            text,
            "\\author{Samuil Petkov}\n\\date{24 July 2026}",
            "\\author{Samuil Petkov}\n\\address{École normale supérieure--PSL, 45 rue d'Ulm, 75005 Paris, France}\n\\email{samuil.petkov@ens.psl.eu}",
            "author metadata",
        )

        abstract = r"""\begin{abstract}
We give an alternative proof of the classification of finite obligatory
triple systems and a Lean~4 verification of its finite structural core.  After
isolated vertices are removed, obligatoriness is equivalent to linearity, an
incident bridge at every hyperedge-node of the Levi graph, and evenness of
every Berge cycle.  The bridge decomposition sharpens to a canonical forest
of atoms: one triple or the private-vertex expansion of a finite
$2$-connected bipartite graph.  This normal form yields the exact
order--size--component spectrum and, more finely, exact indecomposability,
cycle-rank, and atom-count spectra.  The possible atom counts form an interval
except for a parity obstruction at cycle rank one.  The avoiding-host
direction uses a one-apex sequence lift; all arguments are in ZFC.
\end{abstract}"""
        text, count = re.subn(
            r"\\begin\{abstract\}.*?\\end\{abstract\}",
            lambda _: abstract,
            text,
            count=1,
            flags=re.DOTALL,
        )
        if count != 1:
            raise RuntimeError(f"abstract: expected one block, found {count}")

        text = replace_once(
            text,
            "finite disjoint unions and one-point amalgamations.  If $F$ is a triple\nsystem, let $F^\\circ$ denote the system obtained by deleting its isolated\nvertices.",
            "finite disjoint unions and one-point amalgamations.  Membership in\n$\\mathcal B$ is understood up to triple-system isomorphism.  If $F$ is a\ntriple system, let $F^\\circ$ denote the system obtained by deleting its\nisolated vertices.",
            "isomorphism closure",
        )
        text = replace_once(
            text,
            "The present paper gives a different implementation, direct positive\narguments, sharp finite parameter consequences, and a Lean formalisation of\nthis implementation.",
            "The present paper gives a different implementation, direct positive\narguments, a canonical atom normal form, exact finite structural spectra, and\na Lean formalisation of the finite classification.",
            "contribution paragraph",
        )

        canonical_anchor = "Hence \\(F\\in\\mathcal B\\).\n\\end{proof}\n\nThis proves"
        text = replace_once(
            text,
            canonical_anchor,
            "Hence \\(F\\in\\mathcal B\\).\n\\end{proof}\n\n"
            + canonical_atom_block
            + "\n\nThis proves",
            "canonical atom insertion",
        )

        text = replace_once(
            text,
            r"\section*{Formal verification and reproducibility}",
            finite_atom_block
            + "\n\n\\section*{Formal verification and reproducibility}",
            "finite atom spectra insertion",
        )
        TEX.write_text(text, encoding="utf-8", newline="\n")
    else:
        required = [
            NEW_TITLE,
            r"\label{theorem-exact-canonical-atom-count-spectrum}",
            r"\label{theorem-indecomposability-phase-diagram}",
            r"\label{proposition-componentwise-atom-count-spectrum}",
        ]
        missing = [needle for needle in required if needle not in text]
        if missing:
            raise RuntimeError(f"partially integrated canonical TeX: {missing}")


def patch_sync_script() -> None:
    text = SYNC.read_text(encoding="utf-8")
    text = text.replace(OLD_TITLE, NEW_TITLE)

    old_metadata = '''    text = re.sub(r"^\\\\author\\{.*?\\}\\s*$", r"\\\\author{Samuil Petkov}", text, count=1, flags=re.MULTILINE)
    text = re.sub(r"^\\\\address\\{.*?\\}\\s*\\n?", "", text, flags=re.MULTILINE)
    text = re.sub(r"^\\\\email\\{.*?\\}\\s*\\n?", "", text, flags=re.MULTILINE)
'''
    new_metadata = '''    text = re.sub(r"^\\\\author\\{.*?\\}\\s*$", r"\\\\author{Samuil Petkov}", text, count=1, flags=re.MULTILINE)
    text = re.sub(
        r"^\\\\address\\{.*?\\}\\s*$",
        r"\\\\address{École normale supérieure--PSL, 45 rue d'Ulm, 75005 Paris, France}",
        text,
        count=1,
        flags=re.MULTILINE,
    )
    text = re.sub(
        r"^\\\\email\\{.*?\\}\\s*$",
        r"\\\\email{samuil.petkov@ens.psl.eu}",
        text,
        count=1,
        flags=re.MULTILINE,
    )
    if r"\\address{" not in text:
        text = text.replace(
            r"\\author{Samuil Petkov}",
            "\\\\author{Samuil Petkov}\\n"
            "\\\\address{École normale supérieure--PSL, 45 rue d'Ulm, 75005 Paris, France}\\n"
            "\\\\email{samuil.petkov@ens.psl.eu}",
            1,
        )
'''
    if old_metadata in text:
        text = text.replace(old_metadata, new_metadata, 1)
    elif "samuil.petkov@ens.psl.eu" not in text:
        raise RuntimeError("synchronizer metadata normalization anchor missing")

    old_required = '        "Exact order--size--component spectrum",\n'
    new_required = (
        '        "Exact order--size--component spectrum",\n'
        '        "Canonical atom normal form",\n'
        '        "Exact canonical atom-count spectrum",\n'
    )
    if "Exact canonical atom-count spectrum" not in text:
        text = replace_once(text, old_required, new_required, "sync required markers")

    old_header = '''# Obligatory Triple Systems: Canonical Atoms and Exact Finite Spectra

**Samuil Petkov**  
24 July 2026

**2020 Mathematics Subject Classification.** Primary 05C65; Secondary 05C15, 05C63, 03E05
'''
    new_header = '''# Obligatory Triple Systems: Canonical Atoms and Exact Finite Spectra

**Samuil Petkov**  
École normale supérieure--PSL

**2020 Mathematics Subject Classification.** Primary 05C65; Secondary 05C15, 05C63, 03E05
'''
    if old_header in text:
        text = text.replace(old_header, new_header, 1)
    elif "École normale supérieure--PSL" not in text:
        raise RuntimeError("Markdown header anchor missing")

    SYNC.write_text(text, encoding="utf-8", newline="\n")


def patch_existing_workflow() -> None:
    text = MANUSCRIPT_WORKFLOW.read_text(encoding="utf-8")
    text = text.replace(OLD_TITLE, NEW_TITLE)
    MANUSCRIPT_WORKFLOW.write_text(text, encoding="utf-8", newline="\n")


def patch_readme() -> None:
    text = README.read_text(encoding="utf-8")
    text = text.replace(
        "# Obligatory Triple Systems: Alternative Proof and Lean Verification",
        "# Obligatory Triple Systems: Canonical Atoms and Exact Finite Spectra",
        1,
    )
    text = text.replace("**Manuscript revision:** 24 July 2026", "**Manuscript revision:** 18 August 2026", 1)
    text = text.replace(
        "This repository contains an alternative proof of the finite classification in\nErdős Problem 593, a complete Lean 4 verification of the implementation used\nhere, and sharp finite consequences of the classification.",
        "This repository contains an alternative proof of the finite classification in\nErdős Problem 593, a complete Lean 4 verification of the implementation used\nhere, a canonical atom normal form, and exact finite structural spectra.",
        1,
    )
    marker = "## Relationship to Eric Li's preprint"
    if "## Canonical atoms and structural spectra" not in text:
        section = r"""## Canonical atoms and structural spectra

Every reduced obligatory system has a canonical forest decomposition into
atoms.  Each atom is either one triple or the private-vertex expansion `J⁺` of
a finite 2-connected bipartite graph `J`.  This gives exact
indecomposability, atom-rank, and atom-count spectra.

For a connected system, put `s=n-m` and `β=2m-n+1`.  The possible total
numbers `k` of canonical atoms are

\[
\beta=0:\ k=s-1;
\qquad
\beta=1:\ 1\le k\le s-3,\ k\equiv s+1\pmod2;
\]

and, for `β≥2`,

\[
1\le k\le s-1-\left\lceil2\sqrt\beta\right\rceil.
\]

The rank-one parity obstruction is the only gap phenomenon.  The companion
reader-first notes contain the indecomposability phase diagram, boundary
rigidity, prescribed atom-rank partitions, and the exact componentwise
extension.

"""
        text = replace_once(text, marker, section + marker, "README canonical section")
    text = text.replace(
        "The visible\ninstitutional address and email are intentionally omitted.",
        "The manuscript includes the author's institutional address and email in standard\nAMS form.",
        1,
    )
    README.write_text(text, encoding="utf-8", newline="\n")


def patch_citation() -> None:
    text = CITATION.read_text(encoding="utf-8")
    text = text.replace(
        'title: "Obligatory Triple Systems: An Alternative Proof and Lean Verification"',
        'title: "Obligatory Triple Systems: Canonical Atoms and Exact Finite Spectra"',
        1,
    )
    text = text.replace("version: 1.3.0", "version: 1.4.0", 1)
    text = text.replace("date-released: 2026-07-24", "date-released: 2026-08-18", 1)
    CITATION.write_text(text, encoding="utf-8", newline="\n")


def patch_revision_notes() -> None:
    text = REVISION.read_text(encoding="utf-8")
    marker = "## 18 August 2026 -- canonical atoms and exact structural spectra"
    if marker not in text:
        entry = f"""\n\n{marker}\n\n- changed the manuscript title to *{NEW_TITLE}*;\n- integrated the canonical atom normal form and minimal-generator corollary;\n- added the exact connected and componentwise atom-count spectra;\n- added the indecomposability phase diagram and boundary-rigidity corolary;\n- replaced the displayed abstract formula by a self-contained AMS-style abstract;\n- added the ENS--PSL address and author email; and\n- regenerated all public TeX, Markdown, PDF, arXiv, manifest, and checksum artifacts.\n"""
        text = text.rstrip() + entry
    REVISION.write_text(text.rstrip() + "\n", encoding="utf-8", newline="\n")


def main() -> None:
    patch_tex()
    patch_sync_script()
    patch_existing_workflow()
    patch_readme()
    patch_citation()
    patch_revision_notes()


if __name__ == "__main__":
    main()
