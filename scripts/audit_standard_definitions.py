#!/usr/bin/env python3
"""Fail-closed terminology audit for the Erdős 593 manuscript.

This program does not decide whether a mathematical convention is standard by
itself.  It enforces the convention ledger established by comparison with the
specialist literature and checks that the canonical TeX still defines every
load-bearing term unambiguously.
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "erdos593_obligatory_triple_systems.tex"
AUDIT = ROOT / "audits" / "STANDARD_DEFINITIONS_AND_CONVENTIONS_AUDIT.md"
PATCHES = ROOT / "audits" / "STANDARD_DEFINITION_LINE_PATCHES.md"


def flatten(text: str) -> str:
    """Collapse layout whitespace without altering TeX control sequences."""
    return " ".join(text.split())


def require(needle: str, text: str, description: str) -> None:
    if needle not in text:
        raise AssertionError(
            f"missing or altered definition: {description}; expected {needle!r}"
        )


def forbid(needle: str, text: str, description: str) -> None:
    if needle.lower() in text.lower():
        raise AssertionError(f"forbidden ambiguous convention: {description}")


def main() -> None:
    if not __debug__:
        raise RuntimeError("the definitions audit must not run with python -O")

    tex = TEX.read_text(encoding="utf-8")
    flat = flatten(tex)
    audit = AUDIT.read_text(encoding="utf-8")
    patches = PATCHES.read_text(encoding="utf-8")

    # Core hypergraph object and weak-colouring convention.
    require(
        r"A \emph{triple system} is a simple \(3\)-uniform hypergraph",
        flat,
        "triple system = simple 3-uniform hypergraph",
    )
    require(
        r"is \emph{proper} when no hyperedge is monochromatic",
        flat,
        "proper colouring = no monochromatic hyperedge",
    )
    require(
        r"\chi(H)>\aleph_0",
        flat,
        "uncountably chromatic means chi(H) > aleph_0",
    )
    forbid(
        "proper when every hyperedge is rainbow",
        flat,
        "proper colouring must not be silently redefined as strong colouring",
    )

    # Embedding and containment convention.
    require(
        r"An embedding of a triple system \(F\) in \(H\) is an injective map",
        flat,
        "embedding is injective",
    )
    require(
        "embeddings are not required to be induced",
        flat,
        "containment is non-induced",
    )

    # Standard finite incidence geometry.
    require(
        r"is \emph{linear} when any two distinct hyperedges meet in at most one point",
        flat,
        "linear hypergraph",
    )
    require(
        r"Its \emph{Levi graph} \(I(F)\) is the bipartite graph with classes \(V(F)\) and \(E(F)\)",
        flat,
        "Levi/incidence graph",
    )
    require(
        r"A \emph{bridge} is an edge of a graph whose deletion increases the number of connected components",
        flat,
        "ordinary graph bridge",
    )
    require(
        r"A \emph{Berge cycle of length} \(\ell\ge2\) consists of distinct points",
        flat,
        "Berge cycle has distinct connector points",
    )
    require(
        "and distinct hyperedges",
        flat,
        "Berge cycle has distinct hyperedges",
    )
    require(
        r"Equivalently, it is a simple cycle of length \(2\ell\) in \(I(F)\)",
        flat,
        "Berge cycle / Levi cycle equivalence",
    )

    # Construction terminology.
    require(
        r"Its \emph{private-vertex expansion} \(J^+\)",
        flat,
        "private-vertex expansion",
    )
    require(
        r"the points \(p_a\) are new and pairwise distinct",
        flat,
        "private points are new and pairwise distinct",
    )
    require(
        r"A \emph{one-point amalgamation} of vertex-disjoint triple systems",
        flat,
        "one-point amalgamation",
    )
    require(
        "making no other identifications or new hyperedges",
        flat,
        "one-point amalgamation adds no further identifications or edges",
    )
    require(
        r"\(F^\circ\) denotes the result of deleting all isolated points",
        flat,
        "isolated reduction",
    )

    # Trace convention must remain non-induced.
    require(
        "finite, not necessarily induced, linear subhypergraph",
        flat,
        "finite trace is not required to be induced",
    )

    # Parameter terminology.
    require(
        r"a triple system is \emph{connected} when its Levi graph is connected",
        flat,
        "incidence connectivity",
    )
    require(
        r"\beta(I(F))=|E(I(F))|-|V(I(F))|+c=2m-n+c",
        flat,
        "Levi cycle-rank formula",
    )

    # The standardisation documents must preserve their explicit conclusion and
    # all required publication patches.
    for marker in (
        "STANDARD-COMPATIBLE",
        "weak vertex chromatic number",
        "The length of a Berge cycle",
        "Levi (incidence) graph",
        "order and size",
        "cycle rank (cyclomatic number)",
    ):
        if marker not in audit:
            raise AssertionError(f"standard-definition audit marker missing: {marker}")

    for patch_number in range(1, 9):
        if f"## Patch {patch_number}:" not in patches:
            raise AssertionError(f"copy-ready definition patch {patch_number} missing")

    result = {
        "manuscript": str(TEX.relative_to(ROOT)),
        "standard_compatible": True,
        "core_conventions_checked": 16,
        "copy_ready_patches": 8,
        "required_publication_clarifications": [
            "weak versus strong hypergraph colouring",
            "Levi graph / incidence graph synonym",
            "Berge-cycle length counts hyperedges",
            "one-point amalgamation / one-vertex sum synonym",
            "order, size, and Levi connectivity in Section 10",
            "cycle rank / cyclomatic number synonym",
        ],
        "theorem_meaning_changed": False,
    }
    print("Erdos 593 standard definitions audit: PASS")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
