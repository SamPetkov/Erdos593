#!/usr/bin/env python3
"""Finite tests for iterated one-apex lift traces.

This script studies a finite immediate-extension model of the iterated
one-apex lift.  It does not prove the infinitary theorem.  Its purpose is to
stress-test two necessary trace conclusions used by the proof draft:

1. every edge of a finite linear r-uniform trace has at least r-2 certified
   Levi bridge incidences, one contributed at each lift level;
2. every Berge cycle projects, preserving its length, to a cycle of the base
   graph.

The exhaustive test covers every three-edge trace of the four-uniform lift of
K3.  The randomized tests deliberately collect a fixed number of linear traces
from the four- and five-uniform lifts of K3 and C4.

No third-party packages are required.
"""

from __future__ import annotations

import argparse
import collections
import dataclasses
import itertools
import json
import random
import sys
import time
from pathlib import Path
from typing import Dict, FrozenSet, List, Mapping, Optional, Sequence, Set, Tuple


Edge = FrozenSet[int]
Node = Tuple[str, int]
Adjacency = Dict[Node, Set[Node]]


@dataclasses.dataclass(frozen=True)
class FiniteHypergraph:
    uniformity: int
    vertex_count: int
    edges: Tuple[Edge, ...]
    parent: Optional["FiniteHypergraph"] = None
    base_edge_of: Optional[Tuple[int, ...]] = None
    apex_of: Optional[Tuple[int, ...]] = None
    name: str = ""


def graph_hypergraph(
    vertex_count: int, pairs: Sequence[Tuple[int, int]], name: str
) -> FiniteHypergraph:
    return FiniteHypergraph(
        uniformity=2,
        vertex_count=vertex_count,
        edges=tuple(frozenset(pair) for pair in pairs),
        name=name,
    )


def immediate_lift(H: FiniteHypergraph, name: str) -> FiniteHypergraph:
    """One finite layer using the empty node and its immediate extensions.

    If H has n vertices and m edges, the lifted vertices are pairs (sigma,x)
    where sigma is either the empty node or one of m one-edge nodes.  Vertex
    IDs at the empty node are the original IDs 0,...,n-1, so recursive
    certificates lift without an additional translation.
    """

    n = H.vertex_count
    lifted_edges: List[Edge] = []
    base_edge_of: List[int] = []
    apex_of: List[int] = []

    for base_index, base_edge in enumerate(H.edges):
        for apex_coordinate in range(n):
            apex = (base_index + 1) * n + apex_coordinate
            lifted_edges.append(frozenset(set(base_edge) | {apex}))
            base_edge_of.append(base_index)
            apex_of.append(apex)

    return FiniteHypergraph(
        uniformity=H.uniformity + 1,
        vertex_count=(len(H.edges) + 1) * n,
        edges=tuple(lifted_edges),
        parent=H,
        base_edge_of=tuple(base_edge_of),
        apex_of=tuple(apex_of),
        name=name,
    )


def is_linear(H: FiniteHypergraph, selected: Sequence[int]) -> bool:
    return all(
        len(H.edges[left].intersection(H.edges[right])) <= 1
        for left, right in itertools.combinations(selected, 2)
    )


def trace_adjacency(H: FiniteHypergraph, selected: Sequence[int]) -> Adjacency:
    adjacency: Adjacency = collections.defaultdict(set)
    for local_index, host_index in enumerate(selected):
        edge_node = ("e", local_index)
        adjacency[edge_node]
        for vertex in H.edges[host_index]:
            point_node = ("v", vertex)
            adjacency[edge_node].add(point_node)
            adjacency[point_node].add(edge_node)
    return {node: set(neighbours) for node, neighbours in adjacency.items()}


def tarjan_bridges(adjacency: Mapping[Node, Set[Node]]) -> Set[FrozenSet[Node]]:
    discovery: Dict[Node, int] = {}
    low: Dict[Node, int] = {}
    parent: Dict[Node, Optional[Node]] = {}
    bridges: Set[FrozenSet[Node]] = set()
    timer = 0

    def dfs(node: Node) -> None:
        nonlocal timer
        discovery[node] = low[node] = timer
        timer += 1
        for neighbour in adjacency[node]:
            if neighbour not in discovery:
                parent[neighbour] = node
                dfs(neighbour)
                low[node] = min(low[node], low[neighbour])
                if low[neighbour] > discovery[node]:
                    bridges.add(frozenset((node, neighbour)))
            elif parent.get(node) != neighbour:
                low[node] = min(low[node], discovery[neighbour])

    for root in adjacency:
        if root not in discovery:
            parent[root] = None
            dfs(root)
    return bridges


def components_after_removing(
    adjacency: Mapping[Node, Set[Node]],
    removed_edges: Set[FrozenSet[Node]],
) -> List[Set[Node]]:
    unseen = set(adjacency)
    components: List[Set[Node]] = []
    while unseen:
        start = unseen.pop()
        component = {start}
        stack = [start]
        while stack:
            node = stack.pop()
            for neighbour in adjacency[node]:
                if frozenset((node, neighbour)) in removed_edges:
                    continue
                if neighbour in unseen:
                    unseen.remove(neighbour)
                    component.add(neighbour)
                    stack.append(neighbour)
        components.append(component)
    return components


def bridge_counts(H: FiniteHypergraph, selected: Sequence[int]) -> List[int]:
    adjacency = trace_adjacency(H, selected)
    bridges = tarjan_bridges(adjacency)
    return [
        sum(
            frozenset((("e", local_index), ("v", vertex))) in bridges
            for vertex in H.edges[host_index]
        )
        for local_index, host_index in enumerate(selected)
    ]


def bridge_certificate(
    H: FiniteHypergraph, selected: Tuple[int, ...]
) -> Optional[Dict[int, List[int]]]:
    """Return r-2 certified bridge points per selected host edge.

    The certificate follows the lift levels.  The top-level apex incidence is
    checked directly.  After deleting all such incidences, each edge-containing
    component is projected to the parent hypergraph and certified recursively.
    Every lifted parent certificate is then checked again as an actual bridge
    of the original trace, testing the bridge-persistence step rather than
    assuming it.
    """

    if not is_linear(H, selected):
        return None
    if H.uniformity == 2:
        return {edge: [] for edge in selected}

    assert H.parent is not None
    assert H.base_edge_of is not None
    assert H.apex_of is not None

    adjacency = trace_adjacency(H, selected)
    bridges = tarjan_bridges(adjacency)
    removed: Set[FrozenSet[Node]] = set()

    for local_index, host_index in enumerate(selected):
        apex = H.apex_of[host_index]
        incidence = frozenset((("e", local_index), ("v", apex)))
        if incidence not in bridges:
            return None
        removed.add(incidence)

    certificate: Dict[int, List[int]] = {
        host_index: [H.apex_of[host_index]] for host_index in selected
    }

    for component in components_after_removing(adjacency, removed):
        local_edges = sorted(
            node[1] for node in component if node[0] == "e"
        )
        if not local_edges:
            continue
        host_edges = [selected[index] for index in local_edges]
        base_edges = tuple(H.base_edge_of[index] for index in host_edges)
        if len(set(base_edges)) != len(base_edges):
            return None
        parent_certificate = bridge_certificate(H.parent, base_edges)
        if parent_certificate is None:
            return None
        for host_edge, base_edge in zip(host_edges, base_edges):
            certificate[host_edge].extend(parent_certificate[base_edge])

    local_of = {host_index: local for local, host_index in enumerate(selected)}
    for host_index, points in certificate.items():
        if len(points) != H.uniformity - 2 or len(set(points)) != len(points):
            return None
        local_index = local_of[host_index]
        for point in points:
            if point not in H.edges[host_index]:
                return None
            incidence = frozenset((("e", local_index), ("v", point)))
            if incidence not in bridges:
                return None

    return certificate


def berge_cycles(
    H: FiniteHypergraph, selected: Sequence[int]
) -> List[Tuple[int, ...]]:
    """Enumerate canonical oriented simple Berge cycles on local edge labels."""

    selected = tuple(selected)
    edge_count = len(selected)
    shared: Dict[Tuple[int, int], int] = {}

    for left, right in itertools.combinations(range(edge_count), 2):
        intersection = H.edges[selected[left]].intersection(
            H.edges[selected[right]]
        )
        if len(intersection) > 1:
            return []
        if intersection:
            shared[(left, right)] = next(iter(intersection))

    cycles: List[Tuple[int, ...]] = []
    for length in range(3, edge_count + 1):
        for subset in itertools.combinations(range(edge_count), length):
            first = min(subset)
            remaining = tuple(index for index in subset if index != first)
            for permutation in itertools.permutations(remaining):
                cycle = (first,) + permutation
                if cycle[1] > cycle[-1]:
                    continue
                connector_points: List[int] = []
                valid = True
                for left, right in zip(cycle, cycle[1:] + cycle[:1]):
                    key = (left, right) if left < right else (right, left)
                    point = shared.get(key)
                    if point is None:
                        valid = False
                        break
                    connector_points.append(point)
                if valid and len(set(connector_points)) == length:
                    cycles.append(cycle)
    return cycles


def cycle_projection_valid(
    H: FiniteHypergraph,
    selected: Sequence[int],
    cycle_local: Tuple[int, ...],
) -> bool:
    """Check length-preserving projection through every lift level."""

    current = H
    current_edges = tuple(selected[index] for index in cycle_local)
    length = len(current_edges)

    while current.uniformity > 2:
        assert current.parent is not None
        assert current.base_edge_of is not None
        assert current.apex_of is not None

        for left, right in zip(
            current_edges, current_edges[1:] + current_edges[:1]
        ):
            intersection = current.edges[left].intersection(
                current.edges[right]
            )
            if len(intersection) != 1:
                return False
            connector = next(iter(intersection))
            if connector == current.apex_of[left]:
                return False
            if connector == current.apex_of[right]:
                return False

        current_edges = tuple(
            current.base_edge_of[edge] for edge in current_edges
        )
        if len(set(current_edges)) != length:
            return False
        current = current.parent

    connector_points: List[int] = []
    for left, right in zip(
        current_edges, current_edges[1:] + current_edges[:1]
    ):
        intersection = current.edges[left].intersection(current.edges[right])
        if len(intersection) != 1:
            return False
        connector_points.append(next(iter(intersection)))
    return len(set(connector_points)) == length


def exhaustive_three_edge_test(H: FiniteHypergraph) -> dict:
    total = 0
    linear = 0
    certified = 0
    cycles = 0
    odd_cycles = 0
    projection_failures = 0
    certificate_failures = 0
    minimum_bridge_count: Optional[int] = None

    for selected in itertools.combinations(range(len(H.edges)), 3):
        total += 1
        if not is_linear(H, selected):
            continue
        linear += 1

        certificate = bridge_certificate(H, selected)
        if certificate is None:
            certificate_failures += 1
            continue
        certified += 1

        local_minimum = min(bridge_counts(H, selected))
        minimum_bridge_count = (
            local_minimum
            if minimum_bridge_count is None
            else min(minimum_bridge_count, local_minimum)
        )

        trace_cycles = berge_cycles(H, selected)
        cycles += len(trace_cycles)
        odd_cycles += sum(len(cycle) % 2 for cycle in trace_cycles)
        projection_failures += sum(
            not cycle_projection_valid(H, selected, cycle)
            for cycle in trace_cycles
        )

    return {
        "host": H.name,
        "uniformity": H.uniformity,
        "edge_subsets": total,
        "linear_traces": linear,
        "certified_traces": certified,
        "certificate_failures": certificate_failures,
        "cycles": cycles,
        "odd_cycles": odd_cycles,
        "projection_failures": projection_failures,
        "minimum_bridge_count": minimum_bridge_count,
    }


def random_linear_test(
    H: FiniteHypergraph,
    target_linear: int,
    seed: int,
    minimum_size: int,
    maximum_size: int,
) -> dict:
    rng = random.Random(seed)
    attempts = 0
    linear = 0
    certified = 0
    cycles = 0
    odd_cycles = 0
    projection_failures = 0
    certificate_failures = 0
    minimum_bridge_count: Optional[int] = None

    while linear < target_linear:
        attempts += 1
        if attempts > 2_000_000:
            raise RuntimeError(f"failed to collect enough linear traces in {H.name}")
        size = rng.randint(minimum_size, min(maximum_size, len(H.edges)))
        selected = tuple(sorted(rng.sample(range(len(H.edges)), size)))
        if not is_linear(H, selected):
            continue
        linear += 1

        certificate = bridge_certificate(H, selected)
        if certificate is None:
            certificate_failures += 1
            continue
        certified += 1

        local_minimum = min(bridge_counts(H, selected))
        minimum_bridge_count = (
            local_minimum
            if minimum_bridge_count is None
            else min(minimum_bridge_count, local_minimum)
        )

        trace_cycles = berge_cycles(H, selected)
        cycles += len(trace_cycles)
        odd_cycles += sum(len(cycle) % 2 for cycle in trace_cycles)
        projection_failures += sum(
            not cycle_projection_valid(H, selected, cycle)
            for cycle in trace_cycles
        )

    return {
        "host": H.name,
        "uniformity": H.uniformity,
        "attempts": attempts,
        "target_linear_traces": target_linear,
        "linear_traces": linear,
        "certified_traces": certified,
        "certificate_failures": certificate_failures,
        "cycles": cycles,
        "odd_cycles": odd_cycles,
        "projection_failures": projection_failures,
        "minimum_bridge_count": minimum_bridge_count,
        "seed": seed,
    }


def build_hosts() -> Dict[str, FiniteHypergraph]:
    K3 = graph_hypergraph(3, [(0, 1), (1, 2), (0, 2)], "K3")
    C4 = graph_hypergraph(4, [(0, 1), (1, 2), (2, 3), (3, 0)], "C4")

    L3K3 = immediate_lift(K3, "L3(K3)")
    L4K3 = immediate_lift(L3K3, "L4(K3)")
    L5K3 = immediate_lift(L4K3, "L5(K3)")

    L3C4 = immediate_lift(C4, "L3(C4)")
    L4C4 = immediate_lift(L3C4, "L4(C4)")
    L5C4 = immediate_lift(L4C4, "L5(C4)")

    return {
        host.name: host
        for host in [K3, L3K3, L4K3, L5K3, C4, L3C4, L4C4, L5C4]
    }


def comparable_output(data: dict) -> dict:
    result = dict(data)
    result.pop("elapsed_seconds", None)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target-linear", type=int, default=2500)
    parser.add_argument("--minimum-size", type=int, default=3)
    parser.add_argument("--maximum-size", type=int, default=7)
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--check",
        type=Path,
        help="compare against checked JSON, ignoring elapsed time",
    )
    args = parser.parse_args()

    started = time.time()
    hosts = build_hosts()

    exhaustive = exhaustive_three_edge_test(hosts["L4(K3)"])
    random_results = [
        random_linear_test(
            hosts["L4(K3)"],
            args.target_linear,
            5934,
            args.minimum_size,
            args.maximum_size,
        ),
        random_linear_test(
            hosts["L5(K3)"],
            args.target_linear,
            5935,
            args.minimum_size,
            args.maximum_size,
        ),
        random_linear_test(
            hosts["L4(C4)"],
            args.target_linear,
            5944,
            args.minimum_size,
            args.maximum_size,
        ),
        random_linear_test(
            hosts["L5(C4)"],
            args.target_linear,
            5945,
            args.minimum_size,
            args.maximum_size,
        ),
    ]

    for record in [exhaustive, *random_results]:
        if record["certificate_failures"] != 0:
            raise AssertionError(record)
        if record["projection_failures"] != 0:
            raise AssertionError(record)
        if record["minimum_bridge_count"] < record["uniformity"] - 2:
            raise AssertionError(record)

    # C4 is bipartite, so its iterated lifts should expose no odd cycle in the
    # tested finite linear traces.
    for record in random_results:
        if "C4" in record["host"] and record["odd_cycles"] != 0:
            raise AssertionError(record)

    output = {
        "status": "passed",
        "interpretation": (
            "Finite immediate-extension evidence only. Every tested finite "
            "linear trace had r-2 recursively certified bridge incidences per "
            "edge, and every enumerated Berge cycle projected length-preservingly "
            "to the base graph."
        ),
        "configuration": {
            "target_linear_per_random_host": args.target_linear,
            "minimum_trace_size": args.minimum_size,
            "maximum_trace_size": args.maximum_size,
        },
        "hosts": [
            {
                "name": host.name,
                "uniformity": host.uniformity,
                "vertices": host.vertex_count,
                "edges": len(host.edges),
            }
            for host in hosts.values()
        ],
        "exhaustive": exhaustive,
        "random": random_results,
        "elapsed_seconds": round(time.time() - started, 3),
    }

    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if comparable_output(output) != comparable_output(expected):
            sys.stderr.write(
                f"generated result differs from {args.check}\n"
            )
            return 1

    text = json.dumps(output, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
