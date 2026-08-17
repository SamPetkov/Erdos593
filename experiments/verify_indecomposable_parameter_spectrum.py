#!/usr/bin/env python3
"""Exact finite audit for the Erdős 593 indecomposability spectrum.

The mathematical reduction is graph-theoretic.  A connected reduced obligatory
triple system with m hyperedges and n vertices has shadow order s=n-m.
One-point indecomposable systems are exactly one triple or J^+ with J finite,
2-connected, simple, and bipartite.  Decomposable systems admit a connected
bipartite shadow with a cut vertex.

This verifier checks the resulting edge spectra in two independent ways:
  * exhaustive fixed-bipartition enumeration through s=8;
  * explicit constructions for every admissible edge count through s=64.
Only the Python standard library is used.
"""

from __future__ import annotations

import argparse
import json
from collections import deque
from pathlib import Path


def max_bipartite_edges(s: int) -> int:
    return (s * s) // 4


def connected_min_edges(s: int) -> int:
    return s - 1


def decomposable_max_edges(s: int) -> int:
    return ((s - 1) * (s - 1)) // 4 + 1


def atomic_min_edges(s: int) -> int:
    return s if s % 2 == 0 else s + 1


def graph_from_edges(n: int, edges: list[tuple[int, int]]) -> list[set[int]]:
    adj = [set() for _ in range(n)]
    for u, v in edges:
        if u == v:
            raise AssertionError("loop")
        adj[u].add(v)
        adj[v].add(u)
    return adj


def edge_count(adj: list[set[int]]) -> int:
    return sum(map(len, adj)) // 2


def is_connected(adj: list[set[int]]) -> bool:
    if not adj:
        return True
    seen = {0}
    q = deque([0])
    while q:
        u = q.popleft()
        for v in adj[u]:
            if v not in seen:
                seen.add(v)
                q.append(v)
    return len(seen) == len(adj)


def has_cut_vertex(adj: list[set[int]]) -> bool:
    n = len(adj)
    if n <= 2:
        return False
    if not is_connected(adj):
        raise AssertionError("cut-vertex test expects a connected graph")

    disc = [-1] * n
    low = [0] * n
    parent = [-1] * n
    time = 0
    found = False

    def dfs(u: int) -> None:
        nonlocal time, found
        disc[u] = low[u] = time
        time += 1
        children = 0
        for v in adj[u]:
            if disc[v] == -1:
                parent[v] = u
                children += 1
                dfs(v)
                low[u] = min(low[u], low[v])
                if parent[u] == -1 and children > 1:
                    found = True
                if parent[u] != -1 and low[v] >= disc[u]:
                    found = True
            elif v != parent[u]:
                low[u] = min(low[u], disc[v])

    dfs(0)
    return found


def is_bipartite(adj: list[set[int]]) -> bool:
    colour: dict[int, int] = {}
    for root in range(len(adj)):
        if root in colour:
            continue
        colour[root] = 0
        q = deque([root])
        while q:
            u = q.popleft()
            for v in adj[u]:
                if v in colour:
                    if colour[v] == colour[u]:
                        return False
                else:
                    colour[v] = 1 - colour[u]
                    q.append(v)
    return True


def is_two_connected(adj: list[set[int]]) -> bool:
    return len(adj) >= 3 and is_connected(adj) and not has_cut_vertex(adj)


def fixed_bipartition_graph(a: int, b: int, mask: int) -> list[set[int]]:
    edges: list[tuple[int, int]] = []
    bit = 0
    for u in range(a):
        for j in range(b):
            if (mask >> bit) & 1:
                edges.append((u, a + j))
            bit += 1
    return graph_from_edges(a + b, edges)


def spanning_tree_in_complete_bipartite(a: int, b: int) -> list[tuple[int, int]]:
    if a < 1 or b < 1:
        raise ValueError("positive bipartition sizes required")
    # Double star: connect A_0 to every B vertex, then B_0 to A_1,...,A_{a-1}.
    edges = [(0, a + j) for j in range(b)]
    edges += [(i, a) for i in range(1, a)]
    assert len(edges) == a + b - 1
    return edges


def fill_to_size(a: int, b: int, base: list[tuple[int, int]], m: int) -> list[set[int]]:
    edges = list(base)
    used = {tuple(sorted(e)) for e in edges}
    for u in range(a):
        for j in range(b):
            e = tuple(sorted((u, a + j)))
            if len(edges) >= m:
                return graph_from_edges(a + b, edges)
            if e not in used:
                edges.append(e)
                used.add(e)
    if len(edges) != m:
        raise AssertionError((a, b, len(edges), m))
    return graph_from_edges(a + b, edges)


def connected_witness(s: int, m: int) -> list[set[int]]:
    a = s // 2
    b = s - a
    if not (s - 1 <= m <= a * b):
        raise ValueError((s, m))
    return fill_to_size(a, b, spanning_tree_in_complete_bipartite(a, b), m)


def decomposable_witness(s: int, m: int) -> list[set[int]]:
    if s < 3 or not (s - 1 <= m <= decomposable_max_edges(s)):
        raise ValueError((s, m))
    h = connected_witness(s - 1, m - 1)
    # Add a leaf at vertex 0.  This forces a cut vertex without changing bipartiteness.
    edges: list[tuple[int, int]] = []
    for u in range(s - 1):
        for v in h[u]:
            if u < v:
                edges.append((u, v))
    edges.append((0, s - 1))
    return graph_from_edges(s, edges)


def atomic_base(s: int) -> tuple[int, int, list[tuple[int, int]]]:
    if s < 4:
        raise ValueError(s)
    if s % 2 == 0:
        t = s // 2
        a = b = t
        # Hamiltonian cycle in K_{t,t}: A_i-B_i-A_{i+1}-B_i.
        edges: list[tuple[int, int]] = []
        for i in range(t):
            edges.append((i, a + i))
            edges.append(((i + 1) % t, a + i))
        return a, b, edges

    t = (s - 1) // 2
    a, b = t, t + 1
    # Start with C_{2t} on A and B_0,...,B_{t-1}; then add B_t adjacent
    # to two distinct A vertices.  Adding a vertex with two neighbours to a
    # 2-connected graph preserves 2-connectivity.
    edges = []
    for i in range(t):
        edges.append((i, a + i))
        edges.append(((i + 1) % t, a + i))
    edges.append((0, a + t))
    edges.append((1, a + t))
    return a, b, edges


def atomic_witness(s: int, m: int) -> list[set[int]]:
    if not (s >= 4 and atomic_min_edges(s) <= m <= max_bipartite_edges(s)):
        raise ValueError((s, m))
    a, b, base = atomic_base(s)
    return fill_to_size(a, b, base, m)


def exhaustive_audit(max_s: int = 8) -> dict:
    totals = {
        "graphs_examined": 0,
        "connected_graphs": 0,
        "cut_vertex_graphs": 0,
        "two_connected_graphs": 0,
    }
    rows = []
    for s in range(2, max_s + 1):
        connected_sizes: set[int] = set()
        cut_sizes: set[int] = set()
        two_sizes: set[int] = set()
        row_counts = {k: 0 for k in totals}
        for a in range(1, s // 2 + 1):
            b = s - a
            for mask in range(1 << (a * b)):
                row_counts["graphs_examined"] += 1
                adj = fixed_bipartition_graph(a, b, mask)
                if not is_connected(adj):
                    continue
                row_counts["connected_graphs"] += 1
                m = edge_count(adj)
                connected_sizes.add(m)
                if has_cut_vertex(adj):
                    row_counts["cut_vertex_graphs"] += 1
                    cut_sizes.add(m)
                elif s >= 3:
                    row_counts["two_connected_graphs"] += 1
                    two_sizes.add(m)

        expected_connected = set(range(s - 1, max_bipartite_edges(s) + 1))
        expected_cut = (
            set(range(s - 1, decomposable_max_edges(s) + 1)) if s >= 3 else set()
        )
        expected_two = (
            set(range(atomic_min_edges(s), max_bipartite_edges(s) + 1))
            if s >= 4
            else set()
        )
        assert connected_sizes == expected_connected, (s, connected_sizes, expected_connected)
        assert cut_sizes == expected_cut, (s, cut_sizes, expected_cut)
        assert two_sizes == expected_two, (s, two_sizes, expected_two)

        for key, value in row_counts.items():
            totals[key] += value
        rows.append(
            {
                "shadow_order": s,
                **row_counts,
                "connected_edge_spectrum": sorted(connected_sizes),
                "cut_vertex_edge_spectrum": sorted(cut_sizes),
                "two_connected_edge_spectrum": sorted(two_sizes),
            }
        )
    return {"max_shadow_order": max_s, "totals": totals, "rows": rows}


def construction_audit(max_s: int = 64) -> dict:
    counts = {
        "connected_witnesses": 0,
        "decomposable_witnesses": 0,
        "indecomposable_witnesses": 1,  # the single triple / K2 shadow case
    }
    for s in range(2, max_s + 1):
        for m in range(s - 1, max_bipartite_edges(s) + 1):
            adj = connected_witness(s, m)
            assert len(adj) == s and edge_count(adj) == m
            assert is_connected(adj) and is_bipartite(adj)
            counts["connected_witnesses"] += 1

        if s >= 3:
            for m in range(s - 1, decomposable_max_edges(s) + 1):
                adj = decomposable_witness(s, m)
                assert len(adj) == s and edge_count(adj) == m
                assert is_connected(adj) and is_bipartite(adj) and has_cut_vertex(adj)
                counts["decomposable_witnesses"] += 1

        if s >= 4:
            for m in range(atomic_min_edges(s), max_bipartite_edges(s) + 1):
                adj = atomic_witness(s, m)
                assert len(adj) == s and edge_count(adj) == m
                assert is_bipartite(adj) and is_two_connected(adj)
                counts["indecomposable_witnesses"] += 1

        # Algebraic identity used for the sharp dense threshold.
        assert decomposable_max_edges(s) == (
            max_bipartite_edges(s) - s // 2 + 1
        )

    return {"max_shadow_order": max_s, **counts}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    result = {
        "theorem": "exact connected indecomposability phase diagram",
        "formulas": {
            "all_connected": "s-1 <= m <= floor(s^2/4)",
            "decomposable_exists": "s>=3 and s-1 <= m <= floor((s-1)^2/4)+1",
            "indecomposable_exists": "(s,m)=(2,1), or s>=4 and alpha(s)<=m<=floor(s^2/4)",
            "alpha": "alpha(s)=s for even s and s+1 for odd s",
            "forced_indecomposable": "m > floor((s-1)^2/4)+1",
        },
        "exhaustive": exhaustive_audit(),
        "constructions": construction_audit(),
    }
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
