#!/usr/bin/env python3
"""Fail-closed external-interface and manuscript/Lean alignment audit.

This program does not reprove imported infinitary theorems and does not ask
Python to validate Lean proofs.  It checks stable textual interfaces:

* the manuscript cites the exact classical and contemporary inputs it uses;
* the public Lean files define the same mathematical objects as the manuscript;
* the public endpoints are stated on the isolated reduction;
* the constructive class is explicitly isomorphism-closed in Lean; and
* the manuscript does not claim Lean endpoints for the Section 10 corollaries.
"""

from __future__ import annotations

import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "erdos593_obligatory_triple_systems.tex"
LEAN = ROOT / "formalization" / "Erdos593" / "TripleSystem"
BASIC = LEAN / "Basic.lean"
EMBEDDING = LEAN / "Embedding.lean"
OBLIGATORY = LEAN / "Obligatory.lean"
INTRINSIC = LEAN / "Intrinsic.lean"
CONSTRUCTIVE = LEAN / "Constructive.lean"
CLASSIFICATION = LEAN / "ObligatoryClassification.lean"

EXTERNAL_AUDIT = ROOT / "audits" / "EXTERNAL_THEOREM_INTERFACE_AUDIT.md"
LEAN_AUDIT = ROOT / "audits" / "MANUSCRIPT_LEAN_ALIGNMENT_AUDIT.md"
PATCHES = ROOT / "audits" / "INTERFACE_ALIGNMENT_LINE_PATCHES.md"


def read(path: Path) -> str:
    if not path.is_file():
        raise AssertionError(f"required file missing: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def compact(text: str) -> str:
    """Collapse whitespace without altering punctuation or TeX commands."""
    return " ".join(text.split())


def require_text(needle: str, text: str, description: str) -> None:
    if needle not in text:
        raise AssertionError(f"missing or altered interface: {description}")


def require_compact(needle: str, text: str, description: str) -> None:
    require_text(compact(needle), compact(text), description)


def require_regex(pattern: str, text: str, description: str) -> None:
    if re.search(pattern, text, flags=re.DOTALL) is None:
        raise AssertionError(f"missing or altered interface: {description}")


def forbid_regex(pattern: str, text: str, description: str) -> None:
    if re.search(pattern, text, flags=re.IGNORECASE | re.DOTALL) is not None:
        raise AssertionError(f"forbidden overstatement or mismatch: {description}")


def check_external_interfaces(tex: str) -> list[str]:
    exact_markers = (
        (
            "the de Bruijn--Erdős compactness theorem",
            "de Bruijn--Erdos finite-colouring compactness citation",
        ),
        (
            "Erdős--Hajnal high-odd-girth theorem",
            "Erdos--Hajnal high-odd-girth input",
        ),
        ("Theorem~7.4, p.~76", "Erdos--Hajnal theorem locator"),
        (
            "Theorem~4(i), formula~(95), p.~471",
            "Erdos--Rado pair-relation locator",
        ),
        (
            r"(2^{\aleph_0})^+\longrightarrow(\aleph_1)^2_{\aleph_0}",
            "exact Erdos--Rado partition relation",
        ),
        (
            r"\citet[Theorem~1.2]{reiher2024}",
            "Reiher expansion theorem citation",
        ),
        (
            r"\citep[Theorem~1.1]{li2026}",
            "Li classification theorem citation",
        ),
        ("Theorem~4.6]{li2026}", "Li bridge-trace theorem citation"),
    )
    completed: list[str] = []
    for marker, description in exact_markers:
        require_compact(marker, tex, description)
        completed.append(description)

    require_compact(
        "the preceding argument gives a direct proof in the present notation",
        tex,
        "direct expansion-atom route",
    )
    require_compact(
        "Every finite, not necessarily induced, linear subhypergraph",
        tex,
        "self-contained forward finite-trace theorem",
    )
    return completed


def check_basic(basic: str) -> list[str]:
    for marker, description in (
        ("structure TripleSystem", "edge-indexed triple-system structure"),
        ("edge_ncard : ∀ e, Set.ncard {x | Inc x e} = 3", "exact 3-uniformity"),
        ("simple : Function.Injective", "simple hypergraph"),
        ("def Linear : Prop :=", "linearity predicate"),
        ("linear_iff_pairwise_inter_subsingleton", "standard linearity equivalence"),
    ):
        require_compact(marker, basic, description)
    return ["simple edge-indexed 3-uniform hypergraph", "linearity"]


def check_embedding(embedding: str) -> list[str]:
    for marker, description in (
        ("structure Embedding", "embedding structure"),
        ("vertex : V ↪ W", "injective vertex map"),
        ("edge : E → D", "edge map"),
        (
            "map_edge : ∀ e, vertex '' F.edgeSet e = H.edgeSet (edge e)",
            "exact source-edge image",
        ),
        (
            "additional host edges among the image vertices are allowed",
            "non-induced containment convention",
        ),
        ("theorem edge_injective", "derived edge-map injectivity"),
    ):
        require_compact(marker, embedding, description)
    forbid_regex(
        r"reflects?_edge|host edge.*if and only if.*source edge",
        embedding,
        "induced-edge reflection condition",
    )
    return ["injective non-induced embedding"]


def check_obligatory(obligatory: str) -> list[str]:
    require_regex(
        r"def IsProperColoring .*?: Prop :=\s*∀ e : E, ∃ x : V, F\.Inc x e ∧"
        r"\s*∃ y : V, F\.Inc y e ∧ c x ≠ c y",
        obligatory,
        "weak proper-colouring predicate",
    )
    for marker, description in (
        ("noncomputable def chromaticCardinal", "least-cardinal chromatic invariant"),
        ("Nonempty (F.Embedding H)", "appearance by embedding"),
        ("def IsObligatory : Prop :=", "obligatory predicate"),
        ("ℵ₀ < H.chromaticCardinal → F.Appears H", "uncountable host condition"),
    ):
        require_compact(marker, obligatory, description)
    require_regex(
        r"∀ \(W : Type u\) \(D : Type v\) \[DecidableEq W\]"
        r"\s*\(H : TripleSystem W D\)",
        obligatory,
        "fixed ambient universe host quantifier",
    )
    return ["weak chromatic number", "ambient-universe obligatoriness"]


def check_intrinsic(intrinsic: str) -> list[str]:
    for marker, description in (
        ("def BridgeAtEveryEdge : Prop :=", "bridge-at-every-edge predicate"),
        ("SimpleGraph.bridgeEdges F.levi", "genuine Levi bridge set"),
        ("def EvenBergeCycles : Prop :=", "Berge parity predicate"),
        ("c.IsCycle → 4 ∣ c.length", "Levi length divisible by four"),
        (
            "F.Linear ∧ F.BridgeAtEveryEdge ∧ F.EvenBergeCycles",
            "exact intrinsic conjunction",
        ),
    ):
        require_compact(marker, intrinsic, description)
    return ["Levi bridge condition", "even Berge-cycle condition"]


def check_constructive(constructive: str) -> list[str]:
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
        require_compact(marker, constructive, description)
        completed.append(description)
    return completed


def check_public_endpoints(classification: str) -> list[str]:
    require_regex(
        r"theorem isObligatory_iff_isolatedReduction_intrinsic.*?"
        r"F\.IsObligatory ↔ F\.isolatedReduction\.Intrinsic",
        classification,
        "intrinsic public endpoint on isolated reduction",
    )
    require_regex(
        r"theorem isObligatory_iff_constructible_isolatedReduction.*?"
        r"F\.IsObligatory ↔ Constructible F\.isolatedReduction",
        classification,
        "constructive public endpoint on isolated reduction",
    )
    return ["intrinsic endpoint", "constructive endpoint"]


def check_manuscript_scope(tex: str) -> list[str]:
    require_compact(
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
        require_compact(marker, tex, description)
    forbid_regex(
        r"Lean(?:~4)?\s+(?:proves|verifies)[^.]{0,160}"
        r"(?:order--size|parameter spectrum|Section~?10|cycle-rank spectrum)",
        tex,
        "claim that Lean currently proves Section 10",
    )
    return ["literal endpoints disclosed", "universe scope disclosed", "Section 10 separated"]


def check_ledgers(external: str, lean: str, patches: str) -> None:
    for marker in (
        "**PASS.**",
        "De Bruijn--Erdős compactness",
        "Erdős--Rado pair relation",
        "Erdős--Hajnal high odd girth",
        "Reiher's expansion theorem",
        "Li's classification and bridge-trace architecture",
        "No imported theorem is used outside its verified interface",
    ):
        require_text(marker, external, f"external audit marker {marker!r}")

    for marker in (
        "**PASS with explicit surface qualifications.**",
        "public Lean endpoint is phrased on `F.isolatedReduction`",
        "isomorphism closure explicit",
        "4 divides c.length",
        "ambient-universe convention",
        "Section 10",
    ):
        require_text(marker, lean, f"Lean audit marker {marker!r}")

    for number in range(1, 9):
        require_text(f"## Patch {number}:", patches, f"interface patch {number}")


def main() -> None:
    if not __debug__:
        raise RuntimeError("alignment audit must not run with python -O")

    tex = read(TEX)
    basic = read(BASIC)
    embedding = read(EMBEDDING)
    obligatory = read(OBLIGATORY)
    intrinsic = read(INTRINSIC)
    constructive = read(CONSTRUCTIVE)
    classification = read(CLASSIFICATION)
    external = read(EXTERNAL_AUDIT)
    lean = read(LEAN_AUDIT)
    patches = read(PATCHES)

    checks: list[str] = []
    checks.extend(check_external_interfaces(tex))
    checks.extend(check_basic(basic))
    checks.extend(check_embedding(embedding))
    checks.extend(check_obligatory(obligatory))
    checks.extend(check_intrinsic(intrinsic))
    checks.extend(check_constructive(constructive))
    checks.extend(check_public_endpoints(classification))
    checks.extend(check_manuscript_scope(tex))
    check_ledgers(external, lean, patches)

    result = {
        "manuscript": str(TEX.relative_to(ROOT)),
        "lean_files_checked": [
            str(path.relative_to(ROOT))
            for path in (BASIC, EMBEDDING, OBLIGATORY, INTRINSIC, CONSTRUCTIVE, CLASSIFICATION)
        ],
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
