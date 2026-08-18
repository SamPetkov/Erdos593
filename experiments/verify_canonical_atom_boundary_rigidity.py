#!/usr/bin/env python3
"""Exact audit for the canonical-atom boundary rigidity theorems.

The graph primitives and the three previously proved spectrum endpoints are
imported from verify_indecomposable_parameter_spectrum.  This checker adds the
equality classifications: cycles/even thetas at the atomic lower boundary,
balanced complete bipartite cores at the atomic upper boundary, and a balanced
complete bipartite graph plus one leaf at the decomposable ceiling.
"""

from __future__ import annotations

import argparse
import json
from collections import deque
from pathlib import Path

from verify_indecomposable_parameter_spectrum import (
    atomic_min_edges as alpha,
    decomposable_max_edges as delta,
    edge_count,
    fixed_bipartition_graph,
    graph_from_edges,
    has_cut_vertex,
    is_bipartite,
    is_connected,
    is_two_connected,
    max_bipartite_edges as turan_bipartite,
)


def bipartition(adj: list[set[int]]) -> tuple[set[int], set[int]] | None:
    colour: dict[int, int] = {}
    for root in range(len(adj)):
        if root in colour:
            continue
        colour[root] = 0
        queue = deque([root])
        while queue:
            u = queue.popleft()
            for v in adj[u]:
                if v in colour:
                    if colour[v] == colour[u]:
                        return None
                else:
                    colour[v] = 1 - colour[u]
                    queue.append(v)
    return (
        {v for v, c in colour.items() if c == 0},
        {v for v, c in colour.items() if c == 1},
    )


def is_balanced_complete_bipartite(adj: list[set[int]]) -> bool:
    parts = bipartition(adj)
    if parts is None or not is_connected(adj):
        return False
    left, right = parts
    return (
        bool(left)
        and bool(right)
        and abs(len(left) - len(right)) <= 1
        and edge_count(adj) == len(left) * len(right)
    )


def delete_vertex(adj: list[set[int]], removed: int) -> list[set[int]]:
    keep = [v for v in range(len(adj)) if v != removed]
    index = {v: i for i, v in enumerate(keep)}
    edges = [
        (index[u], index[v])
        for u in keep
        for v in adj[u]
        if u < v and v != removed
    ]
    return graph_from_edges(len(keep), edges)


def is_balanced_complete_plus_leaf(adj: list[set[int]]) -> bool:
    return any(
        len(adj[leaf]) == 1
        and is_balanced_complete_bipartite(delete_vertex(adj, leaf))
        for leaf in range(len(adj))
    )


def is_cycle(adj: list[set[int]]) -> bool:
    return len(adj) >= 3 and is_connected(adj) and all(len(ns) == 2 for ns in adj)


def theta_path_lengths(adj: list[set[int]]) -> tuple[int, int, int] | None:
    branch = [v for v, ns in enumerate(adj) if len(ns) == 3]
    if (
        not is_connected(adj)
        or len(branch) != 2
        or any(len(ns) not in {2, 3} for ns in adj)
    ):
        return None
    start, target = branch
    used_internal: set[int] = set()
    lengths: list[int] = []
    for first in adj[start]:
        prev, current = start, first
        internal: list[int] = []
        length = 1
        while current != target:
            if current == start or len(adj[current]) != 2:
                return None
            internal.append(current)
            nxt = next(v for v in adj[current] if v != prev)
            prev, current = current, nxt
            length += 1
            if length > len(adj):
                return None
        if any(v in used_internal for v in internal):
            return None
        used_internal.update(internal)
        lengths.append(length)
    if (
        len(lengths) != 3
        or used_internal != set(range(len(adj))) - {start, target}
        or sum(lengths) != edge_count(adj)
    ):
        return None
    return tuple(sorted(lengths))


def positive_three_partitions(total: int) -> list[tuple[int, int, int]]:
    return [
        (a, b, total - a - b)
        for a in range(1, total // 3 + 1)
        for b in range(a, (total - a) // 2 + 1)
    ]


def count_positive_three_partitions(total: int) -> int:
    return sum(
        max(0, (total - a) // 2 - a + 1)
        for a in range(1, total // 3 + 1)
    )


def cycle_graph(s: int) -> list[set[int]]:
    return graph_from_edges(s, [(i, (i + 1) % s) for i in range(s)])


def theta_graph(lengths: tuple[int, int, int]) -> list[set[int]]:
    edges: list[tuple[int, int]] = []
    next_vertex = 2
    for length in lengths:
        path = [0, *range(next_vertex, next_vertex + length - 1), 1]
        next_vertex += length - 1
        edges.extend(zip(path, path[1:]))
    return graph_from_edges(next_vertex, edges)


def complete_bipartite(a: int, b: int) -> list[set[int]]:
    return graph_from_edges(
        a + b,
        [(u, a + j) for u in range(a) for j in range(b)],
    )


def balanced_complete_plus_leaf(s: int) -> list[set[int]]:
    a = (s - 1) // 2
    b = s - 1 - a
    core = complete_bipartite(a, b)
    edges = [
        (u, v)
        for u in range(s - 1)
        for v in core[u]
        if u < v
    ]
    edges.append((0, s - 1))
    return graph_from_edges(s, edges)


def exhaustive_audit(max_s: int = 8) -> dict:
    totals = {
        "graphs_examined": 0,
        "connected_graphs": 0,
        "minimum_atomic_graphs": 0,
        "maximum_atomic_graphs": 0,
        "maximum_cut_vertex_graphs": 0,
    }
    rows = []
    for s in range(2, max_s + 1):
        row = {key: 0 for key in totals}
        theta_signatures: set[tuple[int, int, int]] = set()
        for a in range(1, s // 2 + 1):
            b = s - a
            for mask in range(1 << (a * b)):
                row["graphs_examined"] += 1
                adj = fixed_bipartition_graph(a, b, mask)
                if not is_connected(adj):
                    continue
                row["connected_graphs"] += 1
                m = edge_count(adj)
                cut = has_cut_vertex(adj)

                if not cut and s >= 4 and m == alpha(s):
                    row["minimum_atomic_graphs"] += 1
                    if s % 2 == 0:
                        assert is_cycle(adj)
                    else:
                        lengths = theta_path_lengths(adj)
                        assert lengths is not None and all(x % 2 == 0 for x in lengths)
                        theta_signatures.add(tuple(x // 2 for x in lengths))

                if not cut and s >= 4 and m == turan_bipartite(s):
                    row["maximum_atomic_graphs"] += 1
                    assert is_balanced_complete_bipartite(adj)

                if cut and s >= 3 and m == delta(s):
                    row["maximum_cut_vertex_graphs"] += 1
                    assert is_balanced_complete_plus_leaf(adj)

        expected = (
            set(positive_three_partitions((s + 1) // 2))
            if s >= 5 and s % 2 == 1
            else set()
        )
        assert theta_signatures == expected
        for key, value in row.items():
            totals[key] += value
        rows.append(
            {
                "shadow_order": s,
                **row,
                "odd_minimum_theta_half_length_signatures": [
                    list(x) for x in sorted(theta_signatures)
                ],
            }
        )
    return {"max_shadow_order": max_s, "totals": totals, "rows": rows}


def construction_audit(max_s: int = 64) -> dict:
    counts = {
        "minimum_atomic_witnesses": 0,
        "maximum_atomic_witnesses": 0,
        "maximum_cut_vertex_witnesses": 0,
        "odd_minimum_theta_isomorphism_types": 0,
    }
    for s in range(3, max_s + 1):
        cut = balanced_complete_plus_leaf(s)
        assert edge_count(cut) == delta(s)
        assert is_bipartite(cut) and is_connected(cut) and has_cut_vertex(cut)
        assert is_balanced_complete_plus_leaf(cut)
        counts["maximum_cut_vertex_witnesses"] += 1

        if s < 4:
            continue
        maximum = complete_bipartite(s // 2, s - s // 2)
        assert edge_count(maximum) == turan_bipartite(s)
        assert is_two_connected(maximum) and is_balanced_complete_bipartite(maximum)
        counts["maximum_atomic_witnesses"] += 1

        if s % 2 == 0:
            minimum = cycle_graph(s)
            assert edge_count(minimum) == alpha(s)
            assert is_two_connected(minimum) and is_bipartite(minimum) and is_cycle(minimum)
            counts["minimum_atomic_witnesses"] += 1
        else:
            signatures = positive_three_partitions((s + 1) // 2)
            counts["odd_minimum_theta_isomorphism_types"] += len(signatures)
            for signature in signatures:
                lengths = tuple(2 * x for x in signature)
                minimum = theta_graph(lengths)
                assert len(minimum) == s and edge_count(minimum) == alpha(s)
                assert is_two_connected(minimum) and is_bipartite(minimum)
                assert theta_path_lengths(minimum) == tuple(sorted(lengths))
                counts["minimum_atomic_witnesses"] += 1
    return {"max_shadow_order": max_s, **counts}


def arithmetic_audit(max_s: int = 4096) -> dict:
    cut_partition_checks = 0
    theta_partition_formula_checks = 0
    for s in range(3, max_s + 1):
        best = -1
        for a in range(1, s):
            b = s - a
            best = max(best, a * b - a + 1, a * b - b + 1)
            cut_partition_checks += 2
        assert best == delta(s)
        if s >= 5 and s % 2 == 1:
            total = (s + 1) // 2
            assert count_positive_three_partitions(total) == (total * total + 3) // 12
            theta_partition_formula_checks += 1
    return {
        "max_shadow_order": max_s,
        "cut_partition_checks": cut_partition_checks,
        "theta_partition_formula_checks": theta_partition_formula_checks,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = {
        "theorem": "canonical atom boundary rigidity",
        "formulas": {
            "minimum_atomic_edges": "alpha(s)=s for even s and s+1 for odd s",
            "maximum_atomic_edges": "floor(s^2/4)",
            "maximum_decomposable_edges": "delta(s)=floor((s-1)^2/4)+1",
            "odd_minimum_type_count": "floor((((s+1)/2)^2+3)/12)",
        },
        "exhaustive": exhaustive_audit(),
        "constructions": construction_audit(),
        "arithmetic": arithmetic_audit(),
    }
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
