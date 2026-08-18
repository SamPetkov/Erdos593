#!/usr/bin/env python3
"""Exact finite audit for canonical atom-rank spectra in Erdős 593.

For a connected simple bipartite graph J, its edge blocks are the graph shadows
of the canonical atoms of J^+.  A bridge block has cycle rank zero and a cyclic
block is 2-connected with positive cycle rank.  This verifier checks:

* additivity of cycle rank over edge blocks;
* the exact minimum order 2 + ceil(2 sqrt(r)) of a cyclic block of rank r;
* the exact prescribed cyclic-rank partition criterion;
* the exact spectrum of the number of cyclic atoms;
* the exact spectrum of the total number of atoms, including the unicyclic
  parity obstruction.

The checks are independent of the hypergraph implementation and use only the
Python standard library.
"""

from __future__ import annotations

import argparse
import json
import math
from collections import defaultdict, deque
from pathlib import Path
from typing import Iterable


def ceil_two_sqrt(r: int) -> int:
    if r < 0:
        raise ValueError(r)
    if r == 0:
        return 0
    # Integer-safe implementation: start from floor(sqrt(4r)) and round up.
    x = math.isqrt(4 * r)
    return x if x * x == 4 * r else x + 1


def max_cycle_rank(s: int) -> int:
    """Maximum m-s+1 for a simple bipartite graph on s vertices."""
    return ((s - 2) * (s - 2)) // 4


def min_cyclic_order(r: int) -> int:
    if r < 1:
        raise ValueError(r)
    return 2 + ceil_two_sqrt(r)


def graph_from_edges(n: int, edges: Iterable[tuple[int, int]]) -> list[set[int]]:
    adj = [set() for _ in range(n)]
    for u, v in edges:
        if not (0 <= u < n and 0 <= v < n) or u == v:
            raise AssertionError((n, u, v))
        adj[u].add(v)
        adj[v].add(u)
    return adj


def edges_of(adj: list[set[int]]) -> list[tuple[int, int]]:
    return [(u, v) for u in range(len(adj)) for v in adj[u] if u < v]


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


def has_cut_vertex(adj: list[set[int]]) -> bool:
    n = len(adj)
    if n <= 2:
        return False
    if not is_connected(adj):
        raise AssertionError("cut-vertex test expects connected graph")
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


def is_two_connected(adj: list[set[int]]) -> bool:
    return len(adj) >= 3 and is_connected(adj) and not has_cut_vertex(adj)


def edge_blocks(adj: list[set[int]]) -> list[list[tuple[int, int]]]:
    """Tarjan edge-block decomposition, including bridges as singleton blocks."""
    n = len(adj)
    disc = [-1] * n
    low = [0] * n
    parent = [-1] * n
    stack: list[tuple[int, int]] = []
    blocks: list[list[tuple[int, int]]] = []
    time = 0

    def canonical(u: int, v: int) -> tuple[int, int]:
        return (u, v) if u < v else (v, u)

    def pop_through(stop: tuple[int, int]) -> None:
        block: list[tuple[int, int]] = []
        while stack:
            e = stack.pop()
            block.append(e)
            if e == stop:
                break
        if not block or stop not in block:
            raise AssertionError((stop, block))
        blocks.append(block)

    def dfs(u: int) -> None:
        nonlocal time
        disc[u] = low[u] = time
        time += 1
        for v in sorted(adj[u]):
            e = canonical(u, v)
            if disc[v] == -1:
                parent[v] = u
                stack.append(e)
                dfs(v)
                low[u] = min(low[u], low[v])
                if low[v] >= disc[u]:
                    pop_through(e)
            elif v != parent[u] and disc[v] < disc[u]:
                stack.append(e)
                low[u] = min(low[u], disc[v])

    for root in range(n):
        if disc[root] == -1:
            dfs(root)
            if stack:
                blocks.append(list(reversed(stack)))
                stack.clear()

    flattened = sorted(e for block in blocks for e in block)
    assert flattened == sorted(edges_of(adj)), (flattened, sorted(edges_of(adj)))
    return blocks


def block_rank(block: list[tuple[int, int]]) -> int:
    vertices = {x for e in block for x in e}
    return len(block) - len(vertices) + 1


def block_order(block: list[tuple[int, int]]) -> int:
    return len({x for e in block for x in e})


def integer_partitions(n: int, cap: int | None = None) -> Iterable[tuple[int, ...]]:
    if n == 0:
        yield ()
        return
    if cap is None or cap > n:
        cap = n
    for first in range(cap, 0, -1):
        for rest in integer_partitions(n - first, first):
            yield (first,) + rest


def partition_min_shadow_order(partition: tuple[int, ...]) -> int:
    if not partition:
        return 2
    return 1 + sum(1 + ceil_two_sqrt(r) for r in partition)


def expected_rank_partitions(s: int, beta: int) -> set[tuple[int, ...]]:
    if beta == 0:
        return {()}
    return {
        p for p in integer_partitions(beta)
        if partition_min_shadow_order(p) <= s
    }


def expected_cyclic_atom_counts(s: int, beta: int) -> set[int]:
    if beta == 0:
        return {0}
    return {
        q for q in range(1, beta + 1)
        if s >= 3 * q - 1 + ceil_two_sqrt(beta - q + 1)
    }


def expected_total_atom_counts(s: int, beta: int) -> set[int]:
    if beta == 0:
        return {s - 1}
    if beta == 1:
        return {
            k for k in range(1, s - 2)
            if (k - (s + 1)) % 2 == 0
        }
    return set(range(1, s - ceil_two_sqrt(beta)))


def fixed_bipartition_graph(a: int, b: int, mask: int) -> list[set[int]]:
    edges = []
    bit = 0
    for u in range(a):
        for j in range(b):
            if (mask >> bit) & 1:
                edges.append((u, a + j))
            bit += 1
    return graph_from_edges(a + b, edges)


def exhaustive_audit(max_s: int = 8) -> dict:
    totals = {
        "graphs_examined": 0,
        "connected_graphs": 0,
        "edge_blocks": 0,
        "cyclic_blocks": 0,
    }
    rows = []
    for s in range(2, max_s + 1):
        observed_partitions: dict[int, set[tuple[int, ...]]] = defaultdict(set)
        observed_q: dict[int, set[int]] = defaultdict(set)
        observed_k: dict[int, set[int]] = defaultdict(set)
        row_counts = {key: 0 for key in totals}
        for a in range(1, s // 2 + 1):
            b = s - a
            for mask in range(1 << (a * b)):
                row_counts["graphs_examined"] += 1
                adj = fixed_bipartition_graph(a, b, mask)
                if not is_connected(adj):
                    continue
                row_counts["connected_graphs"] += 1
                m = edge_count(adj)
                beta = m - s + 1
                blocks = edge_blocks(adj)
                ranks = [block_rank(block) for block in blocks]
                cyclic_ranks = tuple(sorted((r for r in ranks if r > 0), reverse=True))
                q = len(cyclic_ranks)
                k = len(blocks)
                row_counts["edge_blocks"] += k
                row_counts["cyclic_blocks"] += q

                assert all(r >= 0 for r in ranks)
                assert sum(ranks) == beta
                for block, r in zip(blocks, ranks):
                    if r == 0:
                        assert len(block) == 1
                    else:
                        assert block_order(block) >= min_cyclic_order(r)

                observed_partitions[beta].add(cyclic_ranks)
                observed_q[beta].add(q)
                observed_k[beta].add(k)

        beta_rows = []
        for beta in range(max_cycle_rank(s) + 1):
            expected_p = expected_rank_partitions(s, beta)
            expected_q = expected_cyclic_atom_counts(s, beta)
            expected_k = expected_total_atom_counts(s, beta)
            assert observed_partitions[beta] == expected_p, (
                s, beta, observed_partitions[beta], expected_p
            )
            assert observed_q[beta] == expected_q, (
                s, beta, observed_q[beta], expected_q
            )
            assert observed_k[beta] == expected_k, (
                s, beta, observed_k[beta], expected_k
            )
            beta_rows.append(
                {
                    "cycle_rank": beta,
                    "rank_partitions": [list(p) for p in sorted(expected_p, reverse=True)],
                    "cyclic_atom_counts": sorted(expected_q),
                    "total_atom_counts": sorted(expected_k),
                }
            )

        for key, value in row_counts.items():
            totals[key] += value
        rows.append({"shadow_order": s, **row_counts, "cycle_rank_rows": beta_rows})

    return {"max_shadow_order": max_s, "totals": totals, "rows": rows}


def spanning_two_connected_base(v: int, rank: int) -> tuple[int, int, list[tuple[int, int]]]:
    """A 2-connected bipartite base with v vertices and minimum rank for parity."""
    if v < 4 or rank < 1:
        raise ValueError((v, rank))
    if v % 2 == 0:
        t = v // 2
        a = b = t
        edges: list[tuple[int, int]] = []
        for i in range(t):
            edges.append((i, a + i))
            edges.append(((i + 1) % t, a + i))
        return a, b, edges

    if rank < 2:
        raise ValueError((v, rank))
    t = (v - 1) // 2
    a, b = t, t + 1
    edges = []
    for i in range(t):
        edges.append((i, a + i))
        edges.append(((i + 1) % t, a + i))
    edges.append((0, a + t))
    edges.append((1, a + t))
    return a, b, edges


def fill_complete_bipartite(
    a: int, b: int, base: list[tuple[int, int]], target_edges: int
) -> list[set[int]]:
    edges = list(base)
    used = {tuple(sorted(e)) for e in edges}
    for u in range(a):
        for j in range(b):
            e = (u, a + j)
            if len(edges) >= target_edges:
                adj = graph_from_edges(a + b, edges)
                assert edge_count(adj) == target_edges
                return adj
            if e not in used:
                edges.append(e)
                used.add(e)
    if len(edges) != target_edges:
        raise AssertionError((a, b, len(edges), target_edges))
    return graph_from_edges(a + b, edges)


def cyclic_core_witness(rank: int, order: int | None = None) -> list[set[int]]:
    if rank < 1:
        raise ValueError(rank)
    if order is None:
        order = min_cyclic_order(rank)
    if order < min_cyclic_order(rank):
        raise ValueError((rank, order))
    if order % 2 == 1 and rank == 1:
        raise ValueError((rank, order))
    target_edges = order - 1 + rank
    a, b, base = spanning_two_connected_base(order, rank)
    if target_edges > a * b:
        raise AssertionError((rank, order, target_edges, a * b))
    adj = fill_complete_bipartite(a, b, base, target_edges)
    assert is_bipartite(adj) and is_two_connected(adj)
    assert edge_count(adj) - len(adj) + 1 == rank
    return adj


def one_point_sum(cores: list[list[set[int]]], bridge_atoms: int) -> list[set[int]]:
    if bridge_atoms < 0:
        raise ValueError(bridge_atoms)
    # Identify vertex 0 of every core.  All other vertices get fresh labels.
    total = 1 + sum(len(core) - 1 for core in cores) + bridge_atoms
    edges: list[tuple[int, int]] = []
    next_vertex = 1
    for core in cores:
        mapping = {0: 0}
        for u in range(1, len(core)):
            mapping[u] = next_vertex
            next_vertex += 1
        for u, v in edges_of(core):
            edges.append((mapping[u], mapping[v]))
    for _ in range(bridge_atoms):
        edges.append((0, next_vertex))
        next_vertex += 1
    assert next_vertex == total
    adj = graph_from_edges(total, edges)
    assert is_connected(adj) and is_bipartite(adj)
    return adj


def witness_for_partition(s: int, partition: tuple[int, ...]) -> list[set[int]]:
    min_s = partition_min_shadow_order(partition)
    if s < min_s:
        raise ValueError((s, partition))
    if not partition:
        # Connected rank-zero graph: a tree with s-1 bridge blocks.
        return one_point_sum([], s - 1)
    cores = [cyclic_core_witness(r) for r in partition]
    return one_point_sum(cores, s - min_s)


def audit_witness(
    adj: list[set[int]], s: int, beta: int, partition: tuple[int, ...],
    expected_k: int | None = None,
) -> None:
    assert len(adj) == s
    assert is_connected(adj) and is_bipartite(adj)
    assert edge_count(adj) - s + 1 == beta
    blocks = edge_blocks(adj)
    ranks = tuple(sorted((block_rank(block) for block in blocks if block_rank(block) > 0), reverse=True))
    assert ranks == tuple(sorted(partition, reverse=True)), (ranks, partition)
    if expected_k is not None:
        assert len(blocks) == expected_k, (len(blocks), expected_k)


def construction_audit(max_s: int = 40, partition_max_s: int = 16) -> dict:
    counts = {
        "rank_partition_witnesses": 0,
        "cyclic_atom_count_witnesses": 0,
        "total_atom_count_witnesses": 0,
    }
    for s in range(2, max_s + 1):
        for beta in range(max_cycle_rank(s) + 1):
            # Every admissible cyclic-rank partition through a moderate order.
            # Partition numbers grow rapidly, while the exhaustive graph audit
            # already checks the exact partition theorem through s=8.
            if s <= partition_max_s:
                for partition in expected_rank_partitions(s, beta):
                    adj = witness_for_partition(s, partition)
                    audit_witness(adj, s, beta, partition)
                    counts["rank_partition_witnesses"] += 1

            # Every admissible number of cyclic atoms, using the extremal
            # partition (beta-q+1,1,...,1).
            for q in expected_cyclic_atom_counts(s, beta):
                if beta == 0:
                    partition = ()
                else:
                    partition = (beta - q + 1,) + (1,) * (q - 1)
                adj = witness_for_partition(s, partition)
                audit_witness(adj, s, beta, partition)
                assert len(partition) == q
                counts["cyclic_atom_count_witnesses"] += 1

            # Every admissible total atom count.
            for k in expected_total_atom_counts(s, beta):
                if beta == 0:
                    adj = one_point_sum([], s - 1)
                    partition = ()
                elif beta == 1:
                    core_order = s - k + 1
                    assert core_order >= 4 and core_order % 2 == 0
                    adj = one_point_sum([cyclic_core_witness(1, core_order)], k - 1)
                    partition = (1,)
                else:
                    core_order = s - k + 1
                    adj = one_point_sum([cyclic_core_witness(beta, core_order)], k - 1)
                    partition = (beta,)
                audit_witness(adj, s, beta, partition, expected_k=k)
                counts["total_atom_count_witnesses"] += 1

    return {
        "max_shadow_order": max_s,
        "max_full_partition_shadow_order": partition_max_s,
        **counts,
    }


def arithmetic_audit(max_rank: int = 4096) -> dict:
    checked_pairs = 0
    strict_pairs = 0
    for a in range(1, max_rank + 1):
        assert ((min_cyclic_order(a) - 2) ** 2) // 4 >= a
        if min_cyclic_order(a) > 2:
            u = min_cyclic_order(a) - 3
            assert (u * u) // 4 < a
        for b in range(1, min(max_rank - a + 1, 128) + 1):
            checked_pairs += 1
            assert ceil_two_sqrt(a) + ceil_two_sqrt(b) >= ceil_two_sqrt(a + b)
            assert ceil_two_sqrt(a) + ceil_two_sqrt(b) >= ceil_two_sqrt(a + b) + 1
            assert ceil_two_sqrt(a) + ceil_two_sqrt(b) >= ceil_two_sqrt(a + b - 1) + 2
            strict_pairs += 1
    return {
        "max_rank": max_rank,
        "minimum_order_checks": max_rank,
        "square_root_pair_checks": checked_pairs,
        "strict_pair_checks": strict_pairs,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--max-exhaustive-shadow-order", type=int, default=8)
    parser.add_argument("--max-constructive-shadow-order", type=int, default=40)
    parser.add_argument("--max-full-partition-shadow-order", type=int, default=16)
    args = parser.parse_args()

    result = {
        "theorem": "canonical atom-rank, cyclic-atom-count, and total-atom-count spectra",
        "notation": {
            "shadow_order": "s=n-m",
            "cycle_rank": "beta=m-s+1=2m-n+1",
            "rank_cost": "c(r)=ceil(2 sqrt(r))",
        },
        "formulas": {
            "prescribed_rank_partition": "s >= 1 + sum_i (1+c(beta_i))",
            "q_cyclic_atoms": "beta=0,q=0; otherwise 1<=q<=beta and s>=3q-1+c(beta-q+1)",
            "total_atoms_beta_0": "k=s-1",
            "total_atoms_beta_1": "1<=k<=s-3 and k congruent to s+1 mod 2",
            "total_atoms_beta_ge_2": "1<=k<=s-1-c(beta)",
        },
        "arithmetic": arithmetic_audit(),
        "exhaustive": exhaustive_audit(args.max_exhaustive_shadow_order),
        "constructions": construction_audit(
            args.max_constructive_shadow_order,
            args.max_full_partition_shadow_order,
        ),
    }
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
