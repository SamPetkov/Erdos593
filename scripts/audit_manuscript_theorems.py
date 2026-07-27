#!/usr/bin/env python3
"""Fail-closed theorem inventory and exact arithmetic audit for Erdős 593.

This script does not prove the infinitary classification.  It checks that the
canonical TeX contains the audited theorem ledger, that references resolve, and
that every finite numerical consequence in Section 10 agrees with independent
integer enumeration over a substantial deterministic range.
"""

from __future__ import annotations

from functools import lru_cache
import json
import math
from pathlib import Path
import re
from typing import Iterable

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "erdos593_obligatory_triple_systems.tex"

EXPECTED: tuple[tuple[str, str], ...] = (
    ("theoremA", "theorem-a-exact-characterisation"),
    ("lemma", "lemma-1.1-isolated-vertex-reduction"),
    ("lemma", "lemma-1.2-finite-deletion"),
    ("lemma", "lemma-1.3-two-elementary-colouring-facts"),
    ("lemma", "lemma-1.4-closure-chain-lemma"),
    ("lemma", "lemma-2.1-uncountable-chromatic-number-forces-complete-bipartite-graphs"),
    ("lemma", "lemma-3.1-rainbow-bipartite-submatrices"),
    ("proposition", "proposition-3.2-the-complete-bipartite-expansion-atom"),
    ("corollary", "corollary-3.3-every-finite-bipartite-expansion-is-obligatory"),
    ("lemma", "lemma-4.1-disjoint-union-closure"),
    ("definition", "definition-4.2-rooted-abundance"),
    ("lemma", "lemma-4.3-rooted-abundance-lemma"),
    ("proposition", "proposition-4.4-one-point-amalgamation-closure"),
    ("proposition", "proposition-5.1-the-intrinsic-conditions-are-preserved-by-the-generators-and-operations"),
    ("proposition", "proposition-5.2-bridge-block-decomposition"),
    ("definition", "definition-6.1-the-one-apex-lift"),
    ("lemma", "lemma-6.2-chromatic-lower-bound"),
    ("theorem", "theorem-6.3-exact-finite-linear-trace-theorem"),
    ("corollary", "corollary-6.4-restrictions-on-finite-linear-traces"),
    ("theorem", "theorem-7.1-high-odd-girth"),
    ("proposition", "proposition-8.1-avoidance-of-every-nonlinear-finite-triple-system"),
    ("proposition", "proposition-8.2-avoidance-when-the-bridge-condition-fails"),
    ("proposition", "proposition-8.3-avoidance-of-an-odd-berge-cycle"),
    ("proposition", "proposition-edge-deletion-bridge-condition"),
    ("lemma", "lemma-bipartite-shadow"),
    ("theorem", "theorem-order-size-component-spectrum"),
    ("corollary", "corollary-connected-order-size-spectrum"),
    ("corollary", "corollary-fixed-order-size-spectrum"),
    ("corollary", "corollary-levi-cycle-rank-spectrum"),
    ("corollary", "corollary-balanced-endpoint-rigidity"),
)

INTERNAL_CLAIMS: tuple[str, ...] = (
    "Claim 3.2.1",
    "5.2.1. Running intersection",
    "Claim 6.3.1",
    "Claim 6.3.2",
    "Claim 6.3.3",
    "6.3.4. Base-fibre running intersection",
    "Claim 6.3.5",
)

ENV_RE = re.compile(
    r"\\begin\{(theoremA|theorem|lemma|proposition|corollary|definition)\}"
    r"(?:\[([^\]]*)\])?"
)
LABEL_RE = re.compile(r"\\label\{([^}]+)\}")
REF_RE = re.compile(r"\\(?:ref|eqref)\{([^}]+)\}")
HYPERREF_RE = re.compile(r"\\hyperref\[([^\]]+)\]")


def line_number(text: str, offset: int) -> int:
    return text.count("\n", 0, offset) + 1


def theorem_inventory(text: str) -> list[dict[str, object]]:
    matches = list(ENV_RE.finditer(text))
    inventory: list[dict[str, object]] = []
    for index, match in enumerate(matches):
        env = match.group(1)
        title = match.group(2) or ""
        end_token = f"\\end{{{env}}}"
        end = text.find(end_token, match.end())
        if end < 0:
            raise AssertionError(
                f"unterminated {env} beginning at line {line_number(text, match.start())}"
            )
        body = text[match.end() : end]
        labels = LABEL_RE.findall(body)
        label = labels[0] if labels else None
        if len(labels) > 1:
            raise AssertionError(
                f"multiple labels in {env} at line {line_number(text, match.start())}: {labels}"
            )

        next_start = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        after = text[end + len(end_token) : next_start]
        if env not in {"definition", "theoremA"} and "\\begin{proof}" not in after:
            raise AssertionError(
                f"{env} {label or title!r} has no proof before the next theorem-like environment"
            )

        inventory.append(
            {
                "environment": env,
                "title": title,
                "label": label,
                "line": line_number(text, match.start()),
            }
        )
    return inventory


def verify_inventory(text: str) -> tuple[list[dict[str, object]], dict[str, int]]:
    inventory = theorem_inventory(text)
    actual = [(str(item["environment"]), str(item["label"])) for item in inventory]
    expected = list(EXPECTED)
    if actual != expected:
        max_len = max(len(actual), len(expected))
        diagnostics = []
        for index in range(max_len):
            left = actual[index] if index < len(actual) else None
            right = expected[index] if index < len(expected) else None
            if left != right:
                diagnostics.append({"index": index, "actual": left, "expected": right})
        raise AssertionError(f"theorem ledger mismatch: {diagnostics}")

    claim_counts: dict[str, int] = {}
    for marker in INTERNAL_CLAIMS:
        count = text.count(marker)
        if count < 1:
            raise AssertionError(f"internal claim marker {marker!r} is missing")
        claim_counts[marker] = count
    return inventory, claim_counts


def verify_references(text: str) -> dict[str, int]:
    labels = LABEL_RE.findall(text)
    if len(labels) != len(set(labels)):
        duplicates = sorted({label for label in labels if labels.count(label) > 1})
        raise AssertionError(f"duplicate labels: {duplicates}")
    label_set = set(labels)
    refs = REF_RE.findall(text) + HYPERREF_RE.findall(text)
    missing = sorted({ref for ref in refs if ref not in label_set})
    if missing:
        raise AssertionError(f"unresolved internal references: {missing}")
    return {"labels": len(labels), "references": len(refs)}


def q(value: int) -> int:
    if value < 1:
        raise ValueError("q is used only on positive edge counts")
    return math.isqrt(4 * value - 1) + 1


def spectrum_interval(m: int, c: int) -> tuple[int, int]:
    return m + 2 * (c - 1) + q(m - c + 1), 2 * m + c


@lru_cache(maxsize=None)
def possible_shadow_orders(m: int, c: int) -> frozenset[int]:
    if c == 0:
        return frozenset({0}) if m == 0 else frozenset()
    if m < c or c < 0:
        return frozenset()
    values: set[int] = set()
    for first_edges in range(1, m - c + 2):
        for remainder_order in possible_shadow_orders(m - first_edges, c - 1):
            for first_order in range(q(first_edges), first_edges + 2):
                values.add(first_order + remainder_order)
    return frozenset(values)


def verify_merge_inequality(limit: int = 500) -> int:
    checks = 0
    for a in range(1, limit + 1):
        for b in range(1, limit + 1):
            if q(a) + q(b) < q(a + b - 1) + 2:
                raise AssertionError((a, b))
            checks += 1
    return checks


def verify_connected_bipartite_interval(limit: int = 500) -> int:
    checks = 0
    for edges in range(1, limit + 1):
        for vertices in range(2, edges + 3):
            theorem_condition = q(edges) <= vertices <= edges + 1
            elementary_condition = vertices - 1 <= edges <= (vertices * vertices) // 4
            if theorem_condition != elementary_condition:
                raise AssertionError(
                    (edges, vertices, theorem_condition, elementary_condition)
                )
            checks += 1
    return checks


def verify_component_spectrum(max_edges: int = 40) -> int:
    checks = 0
    for m in range(1, max_edges + 1):
        for c in range(1, m + 1):
            shadow_orders = possible_shadow_orders(m, c)
            lower, upper = spectrum_interval(m, c)
            expected_shadow_orders = frozenset(range(lower - m, upper - m + 1))
            if shadow_orders != expected_shadow_orders:
                raise AssertionError(
                    {
                        "m": m,
                        "c": c,
                        "actual": sorted(shadow_orders),
                        "expected": sorted(expected_shadow_orders),
                    }
                )
            checks += len(expected_shadow_orders)
    return checks


def fixed_order_interval(n: int, c: int) -> tuple[int, int]:
    return (
        (n - c + 1) // 2,
        n - 2 * c + 4 - q(n - 3 * c + 4),
    )


def verify_fixed_order_inversion(max_components: int = 20, max_order: int = 160) -> int:
    checks = 0
    for c in range(1, max_components + 1):
        for n in range(3 * c, max_order + 1):
            actual = [
                m
                for m in range(c, max_order + 1)
                if spectrum_interval(m, c)[0] <= n <= spectrum_interval(m, c)[1]
            ]
            lower, upper = fixed_order_interval(n, c)
            expected = list(range(lower, upper + 1)) if lower <= upper else []
            if actual != expected:
                raise AssertionError(
                    {"c": c, "n": n, "actual": actual, "expected": expected}
                )
            allowed_order = n == 3 * c or n == 3 * c + 2 or n >= 3 * c + 4
            if bool(actual) != allowed_order:
                raise AssertionError(
                    {"c": c, "n": n, "has_system": bool(actual), "allowed": allowed_order}
                )
            checks += 1
    return checks


def verify_cycle_rank_spectrum(max_edges: int = 250) -> int:
    checks = 0
    for m in range(1, max_edges + 1):
        for c in range(1, m + 1):
            lower, upper = spectrum_interval(m, c)
            actual = {2 * m - n + c for n in range(lower, upper + 1)}
            maximum = m - c + 2 - q(m - c + 1)
            expected = set(range(0, maximum + 1))
            if actual != expected:
                raise AssertionError((m, c, actual, expected))
            checks += len(expected)
    return checks


def verify_rigidity_arithmetic(limit: int = 500) -> int:
    checks = 0
    for t in range(1, limit + 1):
        cases = (
            (2 * t, t * t),
            (2 * t + 1, t * (t + 1)),
        )
        for vertices, edges in cases:
            if edges != (vertices * vertices) // 4:
                raise AssertionError((t, vertices, edges))
            checks += 1
    return checks


def verify_required_markers(text: str) -> None:
    markers: Iterable[str] = (
        "m+2(c-1)+\\left\\lceil2\\sqrt{m-c+1}\\right\\rceil",
        "n-2c+4-\\left\\lceil2\\sqrt{n-3c+4}\\right\\rceil",
        "\\beta(I(F))=|E(I(F))|-|V(I(F))|+c=2m-n+c",
        "K_{t,t}^+",
        "K_{t,t+1}^+",
    )
    for marker in markers:
        if marker not in text:
            raise AssertionError(f"required theorem marker missing: {marker}")


def main() -> None:
    if not __debug__:
        raise RuntimeError("the audit must not be run with python -O")
    text = TEX.read_text(encoding="utf-8")
    inventory, claim_counts = verify_inventory(text)
    reference_counts = verify_references(text)
    verify_required_markers(text)

    result = {
        "manuscript": str(TEX.relative_to(ROOT)),
        "theorem_like_environments": len(inventory),
        "internal_claim_markers": claim_counts,
        "first_theorem_line": inventory[0]["line"],
        "last_theorem_line": inventory[-1]["line"],
        **reference_counts,
        "merge_inequality_checks": verify_merge_inequality(),
        "connected_bipartite_interval_checks": verify_connected_bipartite_interval(),
        "component_spectrum_attained_orders_checked": verify_component_spectrum(),
        "fixed_order_inversion_checks": verify_fixed_order_inversion(),
        "cycle_rank_values_checked": verify_cycle_rank_spectrum(),
        "rigidity_arithmetic_checks": verify_rigidity_arithmetic(),
    }
    print("Erdos 593 theorem inventory and finite arithmetic audit: PASS")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
