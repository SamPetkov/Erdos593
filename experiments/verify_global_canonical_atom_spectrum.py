#!/usr/bin/env python3
"""Exact audit for componentwise/global canonical-atom spectra in Erdős 593.

This extends the connected atom-rank verifier to reduced obligatory systems
with an arbitrary fixed number c of connected components.  The canonical atom
forest then has c tree components.  The checker verifies exact cyclic-rank
profiles, cyclic-component counts, cyclic-atom counts, and total atom counts.
"""

from __future__ import annotations

import argparse
import json
from collections import defaultdict, deque
from pathlib import Path

from verify_canonical_atom_rank_spectrum import (
    block_rank,
    ceil_two_sqrt,
    cyclic_core_witness,
    edge_blocks,
    edge_count,
    edges_of,
    fixed_bipartition_graph,
    graph_from_edges,
    integer_partitions,
    is_bipartite,
    max_cycle_rank,
    one_point_sum,
)


def connected_components(adj: list[set[int]]) -> list[list[int]]:
    seen: set[int] = set()
    out: list[list[int]] = []
    for root in range(len(adj)):
        if root in seen:
            continue
        seen.add(root)
        queue = deque([root])
        component: list[int] = []
        while queue:
            u = queue.popleft()
            component.append(u)
            for v in adj[u]:
                if v not in seen:
                    seen.add(v)
                    queue.append(v)
        out.append(sorted(component))
    return out


def induced_subgraph(adj: list[set[int]], vertices: list[int]) -> list[set[int]]:
    index = {v: i for i, v in enumerate(vertices)}
    return graph_from_edges(
        len(vertices),
        (
            (index[u], index[v])
            for u in vertices
            for v in adj[u]
            if u < v and v in index
        ),
    )


def disjoint_union(graphs: list[list[set[int]]]) -> list[set[int]]:
    edges: list[tuple[int, int]] = []
    offset = 0
    for graph in graphs:
        edges.extend((u + offset, v + offset) for u, v in edges_of(graph))
        offset += len(graph)
    return graph_from_edges(offset, edges)


def atom_cost(rank: int) -> int:
    if rank < 1:
        raise ValueError(rank)
    return 1 + ceil_two_sqrt(rank)


def component_min_order(rank: int) -> int:
    return 2 if rank == 0 else 2 + ceil_two_sqrt(rank)


def global_partition_min_order(c: int, partition: tuple[int, ...]) -> int:
    q = len(partition)
    return c + sum(atom_cost(rank) for rank in partition) + max(0, c - q)


def expected_rank_partitions(s: int, beta: int, c: int) -> set[tuple[int, ...]]:
    if beta == 0:
        return {()} if s >= 2 * c else set()
    return {
        partition
        for partition in integer_partitions(beta)
        if global_partition_min_order(c, partition) <= s
    }


def expected_component_profiles(
    s: int, beta: int, c: int
) -> set[tuple[int, ...]]:
    if beta == 0:
        profile = (0,) * c
        return {profile} if s >= 2 * c else set()
    return {
        partition + (0,) * (c - len(partition))
        for partition in integer_partitions(beta)
        if len(partition) <= c
        and sum(component_min_order(rank) for rank in partition)
        + 2 * (c - len(partition))
        <= s
    }


def expected_cyclic_atom_counts(s: int, beta: int, c: int) -> set[int]:
    if beta == 0:
        return {0} if s >= 2 * c else set()
    return {
        q
        for q in range(1, beta + 1)
        if s
        >= c
        + 3 * q
        - 2
        + ceil_two_sqrt(beta - q + 1)
        + max(0, c - q)
    }


def expected_cyclic_component_counts(s: int, beta: int, c: int) -> set[int]:
    if beta == 0:
        return {0} if s >= 2 * c else set()
    return {
        h
        for h in range(1, min(c, beta) + 1)
        if s >= 2 * c + 2 * h - 2 + ceil_two_sqrt(beta - h + 1)
    }


def expected_total_atom_counts(s: int, beta: int, c: int) -> set[int]:
    if beta == 0:
        return {s - c} if s >= 2 * c else set()
    if beta == 1:
        return {
            k
            for k in range(c, s - c - 1)
            if (k - (s - c)) % 2 == 0
        }
    return set(range(c, s - c - ceil_two_sqrt(beta) + 1))


def global_feasible(s: int, beta: int, c: int) -> bool:
    return (
        s >= 2 * c
        if beta == 0
        else s >= 2 * c + ceil_two_sqrt(beta)
    )


def graph_component_ranks(adj: list[set[int]]) -> tuple[int, ...]:
    ranks = []
    for vertices in connected_components(adj):
        component = induced_subgraph(adj, vertices)
        ranks.append(edge_count(component) - len(component) + 1)
    return tuple(sorted(ranks, reverse=True))


def audit_graph(
    adj: list[set[int]],
    s: int,
    beta: int,
    c: int,
    partition: tuple[int, ...] | None = None,
    component_profile: tuple[int, ...] | None = None,
    expected_k: int | None = None,
) -> None:
    assert len(adj) == s
    assert all(adj[v] for v in range(s))
    assert is_bipartite(adj)
    components = connected_components(adj)
    assert len(components) == c
    assert edge_count(adj) - s + c == beta

    blocks = edge_blocks(adj)
    ranks = tuple(
        sorted(
            (block_rank(block) for block in blocks if block_rank(block) > 0),
            reverse=True,
        )
    )
    if partition is not None:
        assert ranks == tuple(sorted(partition, reverse=True)), (ranks, partition)
    if component_profile is not None:
        assert graph_component_ranks(adj) == tuple(
            sorted(component_profile, reverse=True)
        )
    if expected_k is not None:
        assert len(blocks) == expected_k, (len(blocks), expected_k)


def exhaustive_audit(max_s: int = 8) -> dict:
    totals = {
        "graphs_examined": 0,
        "reduced_graphs": 0,
        "edge_blocks": 0,
        "cyclic_blocks": 0,
    }
    observed: dict[tuple[int, int, int], dict[str, set]] = defaultdict(
        lambda: {
            "partitions": set(),
            "profiles": set(),
            "q": set(),
            "h": set(),
            "k": set(),
        }
    )
    rows = []

    for s in range(2, max_s + 1):
        row = {key: 0 for key in totals}
        for a in range(1, s // 2 + 1):
            b = s - a
            for mask in range(1 << (a * b)):
                row["graphs_examined"] += 1
                adj = fixed_bipartition_graph(a, b, mask)
                if any(not neighbours for neighbours in adj):
                    continue
                row["reduced_graphs"] += 1
                components = connected_components(adj)
                c = len(components)
                beta = edge_count(adj) - s + c
                blocks = edge_blocks(adj)
                positive_ranks = tuple(
                    sorted(
                        (
                            block_rank(block)
                            for block in blocks
                            if block_rank(block) > 0
                        ),
                        reverse=True,
                    )
                )
                profile = graph_component_ranks(adj)
                key = (s, beta, c)
                observed[key]["partitions"].add(positive_ranks)
                observed[key]["profiles"].add(profile)
                observed[key]["q"].add(len(positive_ranks))
                observed[key]["h"].add(sum(rank > 0 for rank in profile))
                observed[key]["k"].add(len(blocks))
                row["edge_blocks"] += len(blocks)
                row["cyclic_blocks"] += len(positive_ranks)

        for key, value in row.items():
            totals[key] += value
        rows.append({"shadow_order": s, **row})

    comparisons = 0
    for s in range(2, max_s + 1):
        for c in range(1, s // 2 + 1):
            max_beta = max_cycle_rank(s - 2 * (c - 1))
            for beta in range(max_beta + 1):
                key = (s, beta, c)
                expected_p = expected_rank_partitions(s, beta, c)
                expected_profiles = expected_component_profiles(s, beta, c)
                expected_q = expected_cyclic_atom_counts(s, beta, c)
                expected_h = expected_cyclic_component_counts(s, beta, c)
                expected_k = expected_total_atom_counts(s, beta, c)
                actual = observed[key]
                assert actual["partitions"] == expected_p, (
                    key,
                    actual["partitions"],
                    expected_p,
                )
                assert actual["profiles"] == expected_profiles, (
                    key,
                    actual["profiles"],
                    expected_profiles,
                )
                assert actual["q"] == expected_q, (key, actual["q"], expected_q)
                assert actual["h"] == expected_h, (key, actual["h"], expected_h)
                assert actual["k"] == expected_k, (key, actual["k"], expected_k)
                assert bool(expected_p) == global_feasible(s, beta, c)
                comparisons += 1

    return {
        "max_shadow_order": max_s,
        "totals": totals,
        "parameter_triples_compared": comparisons,
        "rows": rows,
    }


def allocate_partition(partition: tuple[int, ...], c: int) -> list[list[int]]:
    if c < 1:
        raise ValueError(c)
    allocation = [[] for _ in range(c)]
    q = len(partition)
    if q >= c:
        for i, rank in enumerate(partition):
            allocation[min(i, c - 1)].append(rank)
    else:
        for i, rank in enumerate(partition):
            allocation[i].append(rank)
    return allocation


def witness_for_partition(
    s: int, c: int, partition: tuple[int, ...]
) -> list[set[int]]:
    min_s = global_partition_min_order(c, partition)
    if s < min_s:
        raise ValueError((s, c, partition))
    allocation = allocate_partition(partition, c)
    extra = s - min_s
    components = []
    for i, ranks in enumerate(allocation):
        cores = [cyclic_core_witness(rank) for rank in ranks]
        bridges = 0 if ranks else 1
        if i == 0:
            bridges += extra
        components.append(one_point_sum(cores, bridges))
    return disjoint_union(components)


def witness_for_component_profile(
    s: int, profile: tuple[int, ...]
) -> list[set[int]]:
    min_s = sum(component_min_order(rank) for rank in profile)
    if s < min_s:
        raise ValueError((s, profile))
    extra = s - min_s
    components = []
    for i, rank in enumerate(profile):
        cores = [] if rank == 0 else [cyclic_core_witness(rank)]
        bridges = 1 if rank == 0 else 0
        if i == 0:
            bridges += extra
        components.append(one_point_sum(cores, bridges))
    return disjoint_union(components)


def witness_for_total_atom_count(
    s: int, beta: int, c: int, k: int
) -> list[set[int]]:
    if k not in expected_total_atom_counts(s, beta, c):
        raise ValueError((s, beta, c, k))
    if beta == 0:
        bridge_counts = [1] * c
        bridge_counts[0] += k - c
        return disjoint_union(
            [one_point_sum([], count) for count in bridge_counts]
        )

    connected_s = s - 2 * (c - 1)
    connected_k = k - (c - 1)
    core_order = connected_s - connected_k + 1
    cyclic = one_point_sum(
        [cyclic_core_witness(beta, core_order)],
        connected_k - 1,
    )
    return disjoint_union(
        [cyclic, *[one_point_sum([], 1) for _ in range(c - 1)]]
    )


def construction_audit(
    max_s: int = 30,
    max_components: int = 6,
    partition_max_s: int = 14,
) -> dict:
    counts = {
        "rank_partition_witnesses": 0,
        "component_profile_witnesses": 0,
        "cyclic_atom_count_witnesses": 0,
        "cyclic_component_count_witnesses": 0,
        "total_atom_count_witnesses": 0,
    }

    for s in range(2, max_s + 1):
        for c in range(1, min(max_components, s // 2) + 1):
            max_beta = max_cycle_rank(s - 2 * (c - 1))
            for beta in range(max_beta + 1):
                if s <= partition_max_s:
                    for partition in expected_rank_partitions(s, beta, c):
                        adj = witness_for_partition(s, c, partition)
                        audit_graph(adj, s, beta, c, partition=partition)
                        counts["rank_partition_witnesses"] += 1

                    for profile in expected_component_profiles(s, beta, c):
                        adj = witness_for_component_profile(s, profile)
                        audit_graph(
                            adj,
                            s,
                            beta,
                            c,
                            component_profile=profile,
                        )
                        counts["component_profile_witnesses"] += 1

                for q in expected_cyclic_atom_counts(s, beta, c):
                    partition = (
                        ()
                        if beta == 0
                        else (beta - q + 1,) + (1,) * (q - 1)
                    )
                    adj = witness_for_partition(s, c, partition)
                    audit_graph(adj, s, beta, c, partition=partition)
                    counts["cyclic_atom_count_witnesses"] += 1

                for h in expected_cyclic_component_counts(s, beta, c):
                    profile = (
                        (0,) * c
                        if beta == 0
                        else (beta - h + 1,)
                        + (1,) * (h - 1)
                        + (0,) * (c - h)
                    )
                    adj = witness_for_component_profile(s, profile)
                    audit_graph(
                        adj,
                        s,
                        beta,
                        c,
                        component_profile=profile,
                    )
                    counts["cyclic_component_count_witnesses"] += 1

                for k in expected_total_atom_counts(s, beta, c):
                    adj = witness_for_total_atom_count(s, beta, c, k)
                    audit_graph(adj, s, beta, c, expected_k=k)
                    counts["total_atom_count_witnesses"] += 1

    return {
        "max_shadow_order": max_s,
        "max_components": max_components,
        "max_full_partition_shadow_order": partition_max_s,
        **counts,
    }


def arithmetic_audit(max_rank: int = 4096, max_components: int = 128) -> dict:
    feasibility_checks = 0
    monotonicity_checks = 0
    for beta in range(max_rank + 1):
        for c in range(1, max_components + 1):
            minimum_s = (
                2 * c
                if beta == 0
                else 2 * c + ceil_two_sqrt(beta)
            )
            assert global_feasible(minimum_s, beta, c)
            assert not global_feasible(minimum_s - 1, beta, c)
            feasibility_checks += 2

        if beta >= 1:
            previous = None
            for q in range(1, beta + 1):
                threshold = 3 * q - 2 + ceil_two_sqrt(beta - q + 1)
                if previous is not None:
                    assert threshold > previous
                    monotonicity_checks += 1
                previous = threshold

    return {
        "max_rank": max_rank,
        "max_components": max_components,
        "feasibility_checks": feasibility_checks,
        "monotonicity_checks": monotonicity_checks,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = {
        "theorem": "global componentwise canonical atom spectra",
        "formulas": {
            "global_feasibility": (
                "beta=0: s>=2c; beta>=1: s>=2c+ceil(2sqrt(beta))"
            ),
            "prescribed_rank_partition": (
                "s>=c+sum(1+ceil(2sqrt(r_i)))+max(0,c-q)"
            ),
            "cyclic_components": (
                "s>=2c+2h-2+ceil(2sqrt(beta-h+1))"
            ),
            "cyclic_atoms": (
                "s>=c+3q-2+ceil(2sqrt(beta-q+1))+max(0,c-q)"
            ),
            "total_atoms_beta0": "k=s-c",
            "total_atoms_beta1": (
                "c<=k<=s-c-2 and k==s-c (mod 2)"
            ),
            "total_atoms_beta_ge_2": (
                "c<=k<=s-c-ceil(2sqrt(beta))"
            ),
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
