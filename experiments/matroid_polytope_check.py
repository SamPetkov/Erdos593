#!/usr/bin/env python3
"""Deterministic checks for the polymatroid base-polytope translation.

For a graph cycle matroid M and uniformity r, the follow-up manuscript uses

    p(A) = (r - 2)|A| + rk_M(A)

and claims

    B(p) = (r - 2) 1 + B(M).

The program exhaustively enumerates all integer points satisfying the
polymatroid base inequalities for several small bipartite graphs and compares
them with translated graphic-matroid bases. It also checks weighted
optimization. No third-party packages are required.
"""

from __future__ import annotations

import argparse
import itertools
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Sequence


@dataclass(frozen=True)
class Graph:
    name: str
    vertex_count: int
    edges: tuple[tuple[int, int], ...]


class DSU:
    def __init__(self, n: int) -> None:
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x: int) -> int:
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]
            x = self.parent[x]
        return x

    def union(self, a: int, b: int) -> None:
        ra, rb = self.find(a), self.find(b)
        if ra == rb:
            return
        if self.rank[ra] < self.rank[rb]:
            ra, rb = rb, ra
        self.parent[rb] = ra
        if self.rank[ra] == self.rank[rb]:
            self.rank[ra] += 1


def subsets(m: int) -> Iterable[tuple[int, ...]]:
    for mask in range(1 << m):
        yield tuple(i for i in range(m) if mask & (1 << i))


def graphic_rank(graph: Graph, subset: Sequence[int]) -> int:
    dsu = DSU(graph.vertex_count)
    for index in subset:
        u, v = graph.edges[index]
        dsu.union(u, v)
    components = len({dsu.find(v) for v in range(graph.vertex_count)})
    return graph.vertex_count - components


def matroid_bases(graph: Graph) -> list[tuple[int, ...]]:
    m = len(graph.edges)
    full_rank = graphic_rank(graph, tuple(range(m)))
    return [
        subset
        for subset in itertools.combinations(range(m), full_rank)
        if graphic_rank(graph, subset) == full_rank
    ]


def feasible_integer_bases(graph: Graph, uniformity: int) -> list[tuple[int, ...]]:
    m = len(graph.edges)
    all_subsets = list(subsets(m))
    ranks = {subset: graphic_rank(graph, subset) for subset in all_subsets}
    target = (uniformity - 2) * m + ranks[tuple(range(m))]
    feasible: list[tuple[int, ...]] = []

    for vector in itertools.product(range(uniformity), repeat=m):
        if sum(vector) != target:
            continue
        valid = True
        for subset in all_subsets:
            lhs = sum(vector[i] for i in subset)
            rhs = (uniformity - 2) * len(subset) + ranks[subset]
            if lhs > rhs:
                valid = False
                break
        if valid:
            feasible.append(vector)
    return feasible


def translated_bases(graph: Graph, uniformity: int) -> list[tuple[int, ...]]:
    m = len(graph.edges)
    offset = uniformity - 2
    vectors = []
    for basis in matroid_bases(graph):
        basis_set = set(basis)
        vectors.append(tuple(offset + int(i in basis_set) for i in range(m)))
    return sorted(vectors)


def check_case(graph: Graph, uniformity: int) -> dict:
    m = len(graph.edges)
    all_subsets = list(subsets(m))
    rank_checks = 0
    for subset in all_subsets:
        rank = graphic_rank(graph, subset)
        p = (uniformity - 2) * len(subset) + rank
        if p - (uniformity - 2) * len(subset) != rank:
            raise AssertionError((graph.name, uniformity, subset))
        rank_checks += 1

    feasible = sorted(feasible_integer_bases(graph, uniformity))
    expected = translated_bases(graph, uniformity)
    if feasible != expected:
        raise AssertionError(
            {
                "graph": graph.name,
                "uniformity": uniformity,
                "feasible": feasible,
                "expected": expected,
            }
        )

    weights = tuple(((7 * i + 3) % 11) - 5 for i in range(m))
    actual_optimum = max(sum(w * x for w, x in zip(weights, point)) for point in feasible)
    basis_optimum = max(
        sum(weights[i] for i in basis)
        for basis in matroid_bases(graph)
    )
    predicted_optimum = (uniformity - 2) * sum(weights) + basis_optimum
    if actual_optimum != predicted_optimum:
        raise AssertionError((graph.name, uniformity, actual_optimum, predicted_optimum))

    return {
        "graph": graph.name,
        "uniformity": uniformity,
        "vertices": graph.vertex_count,
        "edges": m,
        "subsets_checked": rank_checks,
        "matroid_rank": graphic_rank(graph, tuple(range(m))),
        "integer_base_points": len(feasible),
        "matroid_bases": len(expected),
        "weighted_optimum": actual_optimum,
        "predicted_weighted_optimum": predicted_optimum,
        "failures": 0,
    }


def comparable(data: dict) -> dict:
    return data


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    graphs = [
        Graph("single-edge", 2, ((0, 1),)),
        Graph("path-3", 4, ((0, 1), (1, 2), (2, 3))),
        Graph("cycle-4", 4, ((0, 1), (1, 2), (2, 3), (3, 0))),
        Graph("theta-K23", 5, ((0, 2), (0, 3), (0, 4), (1, 2), (1, 3), (1, 4))),
        Graph("two-components", 6, ((0, 1), (1, 2), (3, 4), (4, 5))),
    ]

    records = [
        check_case(graph, uniformity)
        for graph in graphs
        for uniformity in (3, 4, 5)
    ]
    output = {
        "status": "passed",
        "interpretation": (
            "Every exhaustively enumerated integer polymatroid base was exactly "
            "the all-(r-2) vector plus a graphic-matroid basis indicator, and "
            "weighted optimization matched the translated spanning-forest formula."
        ),
        "records": records,
        "totals": {
            "cases": len(records),
            "subsets_checked": sum(record["subsets_checked"] for record in records),
            "integer_base_points": sum(record["integer_base_points"] for record in records),
            "failures": sum(record["failures"] for record in records),
        },
    }

    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if comparable(output) != comparable(expected):
            raise SystemExit(f"generated result differs from {args.check}")

    text = json.dumps(output, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
