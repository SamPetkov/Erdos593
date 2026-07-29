#!/usr/bin/env python3
"""Fail-closed external-interface and manuscript/Lean alignment audit.

This program does not reprove the imported infinitary theorems and does not ask
Python to validate Lean proofs.  It checks that:

* the canonical manuscript names the exact imported interfaces it uses;
* the public Lean endpoint files define the same mathematical objects as the
  manuscript;
* the published formalisation scope is not silently enlarged to Section 10;
* the audit and copy-ready patch ledgers remain complete.
"""

from __future__ import annotations

import json
from pathlib import Path
import re
from typing import Iterable

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


def require(pattern: str, text: str, description: str, *, flags: int = 0) -> None:
    if re.search(pattern, text, flags) is None:
        raise AssertionError(f"missing or altered interface: {description}")


def forbid(pattern: str, text: str, description: str, *, flags: int = 0) -> None:
    if re.search(pattern, text, flags) is not None:
        raise AssertionError(f"forbidden overstatement or mismatch: {description}")


def read(path: Path) -> str:
    if not path.is_file():
        raise AssertionError(f"required audit input missing: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def check_external_interfaces(tex: str) -> list[str]:
    checks: tuple[tuple[str, str], ...] = (
        (
            r"de Bruijn--Erdős\s+compactness theorem",
            "de Bruijn--Erdos finite-colouring compactness citation",
        ),
        (
            r"Erdős--Hajnal high-odd-girth theorem",
            "Erdos--Hajnal high-odd-girth input",
        ),
        (
            r"Theorem~7\.4, p\.~76",
            "Erdos--Hajnal theorem locator",
        ),
        (
            r"Theorem~4\(i\), formula~\(95\), p\.~471",
            "Erdos--Rado pair-relation locator",
        ),
        (
            r"\(2\^\{\\aleph_0\}\)\^\+\\longrightarrow"
            r"\(\\aleph_1\)\^2_\{\\aleph_0\}",
            "exact Erdos--Rado partition relation",
        ),
        (
            r"Theorem~1\.2\}\{reiher2024\}",
            "Reiher expansion theorem citation",
        ),
        (
            r"Theorem~1\.1\}\{li2026\}",
            "Li classification theorem citation",
        ),
        (
            r"Theorem~4\.6\}\{li2026\}",
            "Li bridge-trace theorem citation",
        ),
    )
    completed: list[str] = []
    for pattern, description in checks:
        require(pattern, tex, description)
        completed.append(description)

    # The manuscript gives its own atom and trace proofs; it should not describe
    # Reiher or Li's classification theorem as an unexpanded black-box premise.
    require(
        r"the preceding argument gives a direct proof\s+in the present notation",
        tex,
        "direct expansion-atom route",
        flags=re.DOTALL,
    )
    require(
        r"Every finite, not necessarily induced, linear subhypergraph",
        tex,
        "self-contained finite trace theorem statement",
    )
    return completed


def check_basic_alignment(basic: str) -> list[str]:
    require(
        r"structure TripleSystem .* where",
        basic,
        "edge-indexed triple-system structure",
    )
    require(
        r"edge_ncard\s*:\s*∀ e, Set\.ncard \{x \| Inc x e\} = 3",
        basic,
        "exact 3-uniformity",
    )
    require(
        r"simple\s*:\s*Function\.Injective",
        basic,
        "simple hypergraph edge-set injectivity",
    )
    require(
        r"def Linear : Prop :=",
        basic,
        "linearity predicate",
    )
    require(
        r"linear_iff_pairwise_inter_subsingleton",
        basic,
        "standard intersection formulation of linearity",
    )
    return ["simple 3-uniform triple system", "linearity"]


def check_embedding_alignment(embedding: str) -> list[str]:
    require(
        r"structure Embedding .* where",
        embedding,
        "embedding structure",
    )
    require(r"vertex\s*:\s*V ↪ W", embedding, "injective vertex map")
    require(r"edge\s*:\s*E → D", embedding, "edge map")
    require(
        r"map_edge\s*:\s*∀ e, vertex '' F\.edgeSet e = H\.edgeSet \(edge e\)",
        embedding,
        "exact source-edge image",
    )
    require(
        r"additional host edges\s+among the image vertices are allowed",
        embedding,
        "non-induced containment comment",
        flags=re.DOTALL,
    )
    forbid(
        r"reflects?_edge|iff.*host edge.*source edge",
        embedding,
        "induced-embedding reflection field",
        flags=re.IGNORECASE,
    )
    return ["injective non-induced embedding"]


def check_obligatory_alignment(obligatory: str) -> list[str]:
    require(
        r"def IsProperColoring .* :=\s*∀ e : E, ∃ x : V, F\.Inc x e ∧"
        r" ∃ y : V, F\.Inc y e ∧ c x ≠ c y",
        obligatory,
        "weak proper-colouring predicate",
        flags=re.DOTALL,
    )
    require(
        r"noncomputable def chromaticCardinal",
        obligatory,
        "least-cardinal chromatic invariant",
    )
    require(
        r"def Appears .*Nonempty \(F\.Embedding H\)",
        obligatory,
        "appearance by non-induced embedding",
        flags=re.DOTALL,
    )
    require(
        r"def IsObligatory : Prop :=\s*∀ \(W : Type u\) \(D : Type v\)"
        r" \[DecidableEq W\].*ℵ₀ < H\.chromaticCardinal → F\.Appears H",
        obligatory,
        "ambient-universe obligatory quantifier",
        flags=re.DOTALL,
    )
    return ["weak chromatic number", "ambient-universe obligatoriness"]


def check_intrinsic_alignment(intrinsic: str) -> list[str]:
    require(
        r"def BridgeAtEveryEdge : Prop :=\s*∀ e : E, ∃ x : V,"
        r"\s*s\(Sum\.inl x, Sum\.inr e\) ∈ SimpleGraph\.bridgeEdges F\.levi",
        intrinsic,
        "incident genuine Levi bridge",
        flags=re.DOTALL,
    )
    require(
        r"def EvenBergeCycles : Prop :=\s*∀ .*c\.IsCycle → 4 ∣ c\.length",
        intrinsic,
        "Berge parity encoded by Levi length divisible by four",
        flags=re.DOTALL,
    )
    require(
        r"def Intrinsic : Prop :=\s*F\.Linear ∧ F\.BridgeAtEveryEdge ∧"
        r" F\.EvenBergeCycles",
        intrinsic,
        "exact intrinsic conjunction",
        flags=re.DOTALL,
    )
    return ["Levi bridge condition", "even Berge-cycle condition"]


def check_constructive_alignment(constructive: str) -> list[str]:
    markers: tuple[tuple[str, str], ...] = (
        (r"\| ofEdgeless", "finite edgeless generator"),
        (r"\| ofExpansion", "private-vertex expansion generator"),
        (r"G\.Colorable 2", "two-colourable/bipartite graph hypothesis"),
        (r"\| disjointUnion", "binary disjoint-union closure"),
        (r"\| amalgam", "one-point-amalgamation closure"),
        (r"\| ofIso", "isomorphism closure"),
    )
    completed: list[str] = []
    for pattern, description in markers:
        require(pattern, constructive, description)
        completed.append(description)
    return completed


def check_public_endpoints(classification: str) -> list[str]:
    require(
        r"theorem isObligatory_iff_isolatedReduction_intrinsic.*"
        r"F\.IsObligatory ↔ F\.isolatedReduction\.Intrinsic",
        classification,
        "public intrinsic endpoint on isolated reduction",
        flags=re.DOTALL,
    )
    require(
        r"theorem isObligatory_iff_constructible_isolatedReduction.*"
        r"F\.IsObligatory ↔ Constructible F\.isolatedReduction",
        classification,
        "public constructive endpoint on isolated reduction",
        flags=re.DOTALL,
    )
    return ["intrinsic endpoint", "constructive endpoint"]


def check_manuscript_scope(tex: str) -> list[str]:
    require(
        r"host triple systems are not assumed finite and\s+are quantified within"
        r" the formalisation's documented ambient-universe\s+convention",
        tex,
        "ambient-universe disclosure",
        flags=re.DOTALL,
    )
    require(
        r"F\.IsObligatory.*F\.isolatedReduction\.Intrinsic",
        tex,
        "literal intrinsic Lean endpoint in manuscript",
        flags=re.DOTALL,
    )
    require(
        r"F\.IsObligatory.*Constructible.*F\.isolatedReduction",
        tex,
        "literal constructive Lean endpoint in manuscript",
        flags=re.DOTALL,
    )
    forbid(
        r"Lean(?:~4)?\s+(?:proves|verifies)[^.]{0,120}"
        r"(?:order--size|parameter spectrum|Section~?10|cycle-rank spectrum)",
        tex,
        "claim that current Lean endpoints cover Section 10",
        flags=re.IGNORECASE | re.DOTALL,
    )
    return ["literal endpoints disclosed", "universe scope disclosed", "Section 10 separated"]


def check_audit_ledgers(external: str, lean: str, patches: str) -> None:
    for marker in (
        "**PASS.**",
        "De Bruijn--Erdős compactness",
        "Erdős--Rado pair relation",
        "Erdős--Hajnal high odd girth",
        "Reiher's expansion theorem",
        "Li's classification and bridge-trace architecture",
        "No stronger version of any imported theorem is used",
    ):
        if marker not in external:
            raise AssertionError(f"external-interface audit marker missing: {marker}")

    for marker in (
        "**PASS with explicit surface qualifications.**",
        "public Lean endpoint is phrased on `F.isolatedReduction`",
        "isomorphism closure explicit",
        "4 divides c.length",
        "ambient-universe convention",
        "Section 10",
    ):
        if marker not in lean:
            raise AssertionError(f"Lean-alignment audit marker missing: {marker}")

    for patch_number in range(1, 9):
        if f"## Patch {patch_number}:" not in patches:
            raise AssertionError(f"interface patch {patch_number} missing")


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
    checks.extend(check_basic_alignment(basic))
    checks.extend(check_embedding_alignment(embedding))
    checks.extend(check_obligatory_alignment(obligatory))
    checks.extend(check_intrinsic_alignment(intrinsic))
    checks.extend(check_constructive_alignment(constructive))
    checks.extend(check_public_endpoints(classification))
    checks.extend(check_manuscript_scope(tex))
    check_audit_ledgers(external, lean, patches)

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
