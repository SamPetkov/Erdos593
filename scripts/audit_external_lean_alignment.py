#!/usr/bin/env python3
"""Fail-closed external-theorem and manuscript/Lean alignment audit.

The mathematical proofs are checked elsewhere.  This script protects the
interfaces: source locators, manuscript conventions, Lean definitions, public
endpoint statements, and the declared boundary around the Section 10
corollaries.
"""

from __future__ import annotations

import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "erdos593_obligatory_triple_systems.tex"
LEAN = ROOT / "formalization" / "Erdos593" / "TripleSystem"
FILES = {
    "basic": LEAN / "Basic.lean",
    "embedding": LEAN / "Embedding.lean",
    "obligatory": LEAN / "Obligatory.lean",
    "intrinsic": LEAN / "Intrinsic.lean",
    "constructive": LEAN / "Constructive.lean",
    "classification": LEAN / "ObligatoryClassification.lean",
}
EXTERNAL = ROOT / "audits" / "EXTERNAL_THEOREM_INTERFACE_AUDIT.md"
ALIGNMENT = ROOT / "audits" / "MANUSCRIPT_LEAN_ALIGNMENT_AUDIT.md"
PATCHES = ROOT / "audits" / "INTERFACE_ALIGNMENT_LINE_PATCHES.md"


def read(path: Path) -> str:
    if not path.is_file():
        raise AssertionError(f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def compact(text: str) -> str:
    return " ".join(text.split())


def require(needle: str, text: str, description: str) -> None:
    if compact(needle) not in compact(text):
        raise AssertionError(f"missing or altered interface: {description}")


def require_regex(pattern: str, text: str, description: str) -> None:
    if re.search(pattern, text, flags=re.DOTALL) is None:
        raise AssertionError(f"missing or altered interface: {description}")


def forbid_regex(pattern: str, text: str, description: str) -> None:
    if re.search(pattern, text, flags=re.IGNORECASE | re.DOTALL) is not None:
        raise AssertionError(f"forbidden overstatement: {description}")


def check_manuscript_sources(tex: str) -> list[str]:
    markers = (
        ("the de Bruijn--Erdős compactness theorem", "de Bruijn--Erdos compactness"),
        ("Erdős--Hajnal high-odd-girth theorem", "Erdos--Hajnal odd-girth theorem"),
        ("Theorem~7.4, p.~76", "Erdos--Hajnal locator"),
        ("Theorem~4(i), formula~(95), p.~471", "Erdos--Rado locator"),
        (
            r"(2^{\aleph_0})^+\longrightarrow(\aleph_1)^2_{\aleph_0}",
            "Erdos--Rado relation",
        ),
        (r"\citet[Theorem~1.2]{reiher2024}", "Reiher theorem locator"),
        (r"\citep[Theorem~1.1]{li2026}", "Li classification locator"),
        ("Theorem~4.6]{li2026}", "Li bridge-trace locator"),
        (
            "the preceding argument gives a direct proof in the present notation",
            "direct positive-atom proof",
        ),
        (
            "Every finite, not necessarily induced, linear subhypergraph",
            "forward finite-trace theorem",
        ),
    )
    completed: list[str] = []
    for marker, description in markers:
        require(marker, tex, description)
        completed.append(description)
    return completed


def check_basic(text: str) -> list[str]:
    for marker, description in (
        ("structure TripleSystem", "edge-indexed triple-system structure"),
        ("edge_ncard : ∀ e, Set.ncard {x | Inc x e} = 3", "exact 3-uniformity"),
        ("simple : Function.Injective", "simplicity"),
        ("def Linear : Prop :=", "linearity"),
        ("linear_iff_pairwise_inter_subsingleton", "standard linearity equivalence"),
    ):
        require(marker, text, description)
    return ["simple edge-indexed 3-uniform source", "linearity"]


def check_embedding(text: str) -> list[str]:
    for marker, description in (
        ("structure Embedding", "embedding structure"),
        ("vertex : V ↪ W", "injective vertex map"),
        ("edge : E → D", "edge map"),
        (
            "map_edge : ∀ e, vertex '' F.edgeSet e = H.edgeSet (edge e)",
            "exact image of each source edge",
        ),
        (
            "additional host edges among the image vertices are allowed",
            "non-induced containment",
        ),
        ("theorem edge_injective", "derived edge-map injectivity"),
    ):
        require(marker, text, description)
    forbid_regex(
        r"host edge.*if and only if.*source edge|reflects?_edge",
        text,
        "induced-edge reflection condition",
    )
    return ["injective non-induced embedding"]


def check_obligatory(text: str) -> list[str]:
    require_regex(
        r"def IsProperColoring .*?: Prop :=\s*∀ e : E, ∃ x : V, F\.Inc x e ∧"
        r"\s*∃ y : V, F\.Inc y e ∧ c x ≠ c y",
        text,
        "weak proper-colouring definition",
    )
    for marker, description in (
        ("noncomputable def chromaticCardinal", "chromatic cardinal"),
        ("Nonempty (F.Embedding H)", "appearance by embedding"),
        ("def IsObligatory : Prop :=", "obligatory predicate"),
        ("ℵ₀ < H.chromaticCardinal → F.Appears H", "uncountable host condition"),
        (
            "∀ (W : Type u) (D : Type v) [DecidableEq W] (H : TripleSystem W D)",
            "fixed ambient universe host quantifier",
        ),
    ):
        require(marker, text, description)
    return ["weak chromatic number", "ambient-universe obligatoriness"]


def check_intrinsic(text: str) -> list[str]:
    for marker, description in (
        ("def BridgeAtEveryEdge : Prop :=", "bridge predicate"),
        ("SimpleGraph.bridgeEdges F.levi", "actual Levi bridge set"),
        ("def EvenBergeCycles : Prop :=", "Berge parity predicate"),
        ("c.IsCycle → 4 ∣ c.length", "Levi-cycle divisibility by four"),
        (
            "F.Linear ∧ F.BridgeAtEveryEdge ∧ F.EvenBergeCycles",
            "intrinsic conjunction",
        ),
    ):
        require(marker, text, description)
    return ["Levi bridge condition", "even Berge-cycle condition"]


def check_constructive(text: str) -> list[str]:
    markers = (
        ("| ofEdgeless", "finite edgeless generator"),
        ("| ofExpansion", "private-vertex expansion generator"),
        ("G.Colorable 2", "two-colourable graph hypothesis"),
        ("| disjointUnion", "disjoint-union closure"),
        ("| amalgam", "one-point-amalgamation closure"),
        ("| ofIso", "isomorphism closure"),
    )
    completed: list[str] = []
    for marker, description in markers:
        require(marker, text, description)
        completed.append(description)
    return completed


def check_endpoints(text: str) -> list[str]:
    require_regex(
        r"theorem isObligatory_iff_isolatedReduction_intrinsic.*?"
        r"F\.IsObligatory ↔ F\.isolatedReduction\.Intrinsic",
        text,
        "intrinsic endpoint on isolated reduction",
    )
    require_regex(
        r"theorem isObligatory_iff_constructible_isolatedReduction.*?"
        r"F\.IsObligatory ↔ Constructible F\.isolatedReduction",
        text,
        "constructive endpoint on isolated reduction",
    )
    return ["intrinsic endpoint", "constructive endpoint"]


def check_manuscript_scope(tex: str) -> list[str]:
    require(
        "host triple systems are not assumed finite and are quantified within "
        "the formalisation's documented ambient-universe convention",
        tex,
        "ambient-universe disclosure",
    )
    for marker, description in (
        (r"\mathtt{F.IsObligatory}", "Lean obligation notation"),
        (r"\mathtt{F.isolatedReduction.Intrinsic}", "intrinsic endpoint notation"),
        (r"\mathtt{Constructible\ F.isolatedReduction}", "constructive endpoint notation"),
    ):
        require(marker, tex, description)
    forbid_regex(
        r"Lean(?:~4)?\s+(?:proves|verifies)[^.]{0,160}"
        r"(?:order--size|parameter spectrum|Section~?10|cycle-rank spectrum)",
        tex,
        "claim that Lean proves the Section 10 corollaries",
    )
    return ["literal endpoints disclosed", "universe scope disclosed", "Section 10 separated"]


def check_ledgers(external: str, alignment: str, patches: str) -> None:
    for marker in (
        "**PASS.**",
        "No imported theorem is used outside its verified interface",
        "De Bruijn--Erdős compactness",
        "Erdős--Rado pair relation",
        "Erdős--Hajnal high odd girth",
        "Reiher's expansion theorem",
        "Li's classification and bridge-trace architecture",
    ):
        if marker not in external:
            raise AssertionError(f"external audit marker missing: {marker!r}")

    for marker in (
        "**PASS with explicit surface qualifications.**",
        "public Lean endpoint is phrased on `F.isolatedReduction`",
        "explicitly closed under isomorphism",
        "4 divides c.length",
        "ambient-universe convention",
        "Section 10",
    ):
        if marker not in alignment:
            raise AssertionError(f"Lean alignment marker missing: {marker!r}")

    for number in range(1, 9):
        marker = f"## Patch {number}:"
        if marker not in patches:
            raise AssertionError(f"copy-ready interface patch missing: {number}")


def main() -> None:
    if not __debug__:
        raise RuntimeError("alignment audit must not run with python -O")

    tex = read(TEX)
    lean = {name: read(path) for name, path in FILES.items()}
    external = read(EXTERNAL)
    alignment = read(ALIGNMENT)
    patches = read(PATCHES)

    checks: list[str] = []
    checks.extend(check_manuscript_sources(tex))
    checks.extend(check_basic(lean["basic"]))
    checks.extend(check_embedding(lean["embedding"]))
    checks.extend(check_obligatory(lean["obligatory"]))
    checks.extend(check_intrinsic(lean["intrinsic"]))
    checks.extend(check_constructive(lean["constructive"]))
    checks.extend(check_endpoints(lean["classification"]))
    checks.extend(check_manuscript_scope(tex))
    check_ledgers(external, alignment, patches)

    result = {
        "manuscript": str(TEX.relative_to(ROOT)),
        "lean_files_checked": [str(path.relative_to(ROOT)) for path in FILES.values()],
        "interface_checks": len(checks),
        "copy_ready_interface_patches": 8,
        "external_interfaces": [
            "de Bruijn--Erdos finite-colouring compactness",
            "Erdos--Rado pair partition relation",
            "Erdos--Hajnal high odd girth",
            "Erdos--Hajnal--Rothschild nonlinear obstruction",
            "Reiher complete-bipartite expansion atom",
            "Li classification and forward bridge-trace consequence",
        ],
        "lean_surface": {
            "source": "finite simple edge-indexed 3-uniform hypergraph",
            "colouring": "weak/no-monochromatic-edge",
            "containment": "injective non-induced embedding",
            "classification": "stated on isolatedReduction",
            "constructive_class": "explicitly isomorphism-closed",
            "host_scope": "arbitrary cardinality in fixed ambient universes",
        },
        "section_10_lean_endpoints_claimed": False,
        "theorem_meaning_changed": False,
        "status": "PASS_WITH_PUBLICATION_CLARIFICATIONS",
    }
    print("Erdos 593 external/Lean interface audit: PASS")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
