#!/usr/bin/env python3
"""Finite complete-rank tests for the uniform one-apex trace theorem.

The finite model uses all edge-index sequences of length at most `depth` and
all proper-prefix pairs, rather than only immediate extensions. It tests the
two one-step conclusions needed by the iterated avoidance proof:

* the selected apex incidence of every edge in every finite linear trace is a
  Levi bridge;
* every Berge cycle has one common base node and projects, preserving length,
  to a Berge cycle in the base hypergraph.

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
class Hypergraph:
    uniformity: int
    vertex_count: int
    edges: Tuple[Edge, ...]
    name: str


@dataclasses.dataclass(frozen=True)
class Lift:
    host: Hypergraph
    base: Hypergraph
    vertex_coordinate_count: int
    node_sequences: Tuple[Tuple[int, ...], ...]
    base_edge_of: Tuple[int, ...]
    base_node_of: Tuple[int, ...]
    apex_node_of: Tuple[int, ...]
    apex_vertex_of: Tuple[int, ...]


def graph(vertex_count: int, pairs: Sequence[Tuple[int, int]], name: str) -> Hypergraph:
    return Hypergraph(2, vertex_count, tuple(frozenset(pair) for pair in pairs), name)


def expansion(base_graph: Hypergraph, uniformity: int, name: str) -> Hypergraph:
    if base_graph.uniformity != 2 or uniformity < 2:
        raise ValueError("expansion expects a graph and uniformity >= 2")
    edges: List[Edge] = []
    next_vertex = base_graph.vertex_count
    for pair in base_graph.edges:
        extras = set(range(next_vertex, next_vertex + uniformity - 2))
        next_vertex += uniformity - 2
        edges.append(frozenset(set(pair) | extras))
    return Hypergraph(uniformity, next_vertex, tuple(edges), name)


def is_prefix(left: Tuple[int, ...], right: Tuple[int, ...]) -> bool:
    return len(left) < len(right) and right[: len(left)] == left


def complete_rank_lift(H: Hypergraph, depth: int, name: str) -> Lift:
    if depth < 1:
        raise ValueError("depth must be positive")
    alphabet = range(len(H.edges))
    sequences: List[Tuple[int, ...]] = [()]
    for length in range(1, depth + 1):
        sequences.extend(itertools.product(alphabet, repeat=length))
    node_index = {sequence: index for index, sequence in enumerate(sequences)}
    n = H.vertex_count

    edges: List[Edge] = []
    base_edge_of: List[int] = []
    base_node_of: List[int] = []
    apex_node_of: List[int] = []
    apex_vertex_of: List[int] = []

    for sigma in sequences:
        for tau in sequences:
            if not is_prefix(sigma, tau):
                continue
            base_edge = tau[len(sigma)]
            sigma_index = node_index[sigma]
            tau_index = node_index[tau]
            base_vertices = {
                sigma_index * n + coordinate for coordinate in H.edges[base_edge]
            }
            for z in range(n):
                apex = tau_index * n + z
                edges.append(frozenset(base_vertices | {apex}))
                base_edge_of.append(base_edge)
                base_node_of.append(sigma_index)
                apex_node_of.append(tau_index)
                apex_vertex_of.append(apex)

    host = Hypergraph(H.uniformity + 1, len(sequences) * n, tuple(edges), name)
    return Lift(
        host=host,
        base=H,
        vertex_coordinate_count=n,
        node_sequences=tuple(sequences),
        base_edge_of=tuple(base_edge_of),
        base_node_of=tuple(base_node_of),
        apex_node_of=tuple(apex_node_of),
        apex_vertex_of=tuple(apex_vertex_of),
    )


def is_linear(H: Hypergraph, selected: Sequence[int]) -> bool:
    return all(
        len(H.edges[left].intersection(H.edges[right])) <= 1
        for left, right in itertools.combinations(selected, 2)
    )


def incidence_adjacency(H: Hypergraph, selected: Sequence[int]) -> Adjacency:
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


def berge_cycles(H: Hypergraph, selected: Sequence[int]) -> List[Tuple[Tuple[int, ...], Tuple[int, ...]]]:
    """Return `(local edge cycle, connector vertices)` canonically oriented."""
    selected = tuple(selected)
    edge_count = len(selected)
    shared: Dict[Tuple[int, int], int] = {}
    for left, right in itertools.combinations(range(edge_count), 2):
        intersection = H.edges[selected[left]].intersection(H.edges[selected[right]])
        if len(intersection) > 1:
            return []
        if intersection:
            shared[(left, right)] = next(iter(intersection))

    cycles: List[Tuple[Tuple[int, ...], Tuple[int, ...]]] = []
    for length in range(3, edge_count + 1):
        for subset in itertools.combinations(range(edge_count), length):
            first = min(subset)
            remaining = tuple(index for index in subset if index != first)
            for permutation in itertools.permutations(remaining):
                cycle = (first,) + permutation
                if cycle[1] > cycle[-1]:
                    continue
                connectors: List[int] = []
                valid = True
                for left, right in zip(cycle, cycle[1:] + cycle[:1]):
                    key = (left, right) if left < right else (right, left)
                    point = shared.get(key)
                    if point is None:
                        valid = False
                        break
                    connectors.append(point)
                if valid and len(set(connectors)) == length:
                    cycles.append((cycle, tuple(connectors)))
    return cycles


def base_cycle_valid(
    base: Hypergraph,
    base_edges: Sequence[int],
    connector_coordinates: Sequence[int],
) -> bool:
    length = len(base_edges)
    if len(set(base_edges)) != length or len(set(connector_coordinates)) != length:
        return False
    for index in range(length):
        left = base_edges[index]
        right = base_edges[(index + 1) % length]
        connector = connector_coordinates[index]
        if connector not in base.edges[left] or connector not in base.edges[right]:
            return False
    return True


def check_trace(lift: Lift, selected: Tuple[int, ...]) -> Tuple[bool, int, int, int]:
    """Return success, cycle count, odd cycle count, and minimum bridge count."""
    H = lift.host
    if not is_linear(H, selected):
        return True, 0, 0, H.uniformity

    adjacency = incidence_adjacency(H, selected)
    bridges = tarjan_bridges(adjacency)
    bridge_counts: List[int] = []

    for local_index, host_index in enumerate(selected):
        apex = lift.apex_vertex_of[host_index]
        apex_incidence = frozenset((("e", local_index), ("v", apex)))
        if apex_incidence not in bridges:
            return False, 0, 0, 0
        bridge_counts.append(
            sum(
                frozenset((("e", local_index), ("v", vertex))) in bridges
                for vertex in H.edges[host_index]
            )
        )

    cycles = berge_cycles(H, selected)
    odd_cycles = 0
    n = lift.vertex_coordinate_count
    for edge_cycle, connector_vertices in cycles:
        connector_nodes = tuple(vertex // n for vertex in connector_vertices)
        if len(set(connector_nodes)) != 1:
            return False, len(cycles), odd_cycles, min(bridge_counts)
        common_node = connector_nodes[0]
        base_edges = tuple(lift.base_edge_of[selected[index]] for index in edge_cycle)
        base_nodes = tuple(lift.base_node_of[selected[index]] for index in edge_cycle)
        if any(node != common_node for node in base_nodes):
            return False, len(cycles), odd_cycles, min(bridge_counts)
        connector_coordinates = tuple(vertex % n for vertex in connector_vertices)
        if not base_cycle_valid(lift.base, base_edges, connector_coordinates):
            return False, len(cycles), odd_cycles, min(bridge_counts)
        odd_cycles += len(edge_cycle) % 2

    return True, len(cycles), odd_cycles, min(bridge_counts)


def exhaustive_three_edge(lift: Lift) -> dict:
    total = 0
    linear = 0
    checked = 0
    failures = 0
    cycles = 0
    odd_cycles = 0
    minimum_bridge_count: Optional[int] = None

    for selected in itertools.combinations(range(len(lift.host.edges)), 3):
        total += 1
        if not is_linear(lift.host, selected):
            continue
        linear += 1
        success, local_cycles, local_odd, local_min = check_trace(lift, selected)
        checked += 1
        if not success:
            failures += 1
            break
        cycles += local_cycles
        odd_cycles += local_odd
        minimum_bridge_count = (
            local_min if minimum_bridge_count is None else min(minimum_bridge_count, local_min)
        )

    return {
        "host": lift.host.name,
        "base": lift.base.name,
        "uniformity": lift.host.uniformity,
        "host_edges": len(lift.host.edges),
        "edge_subsets": total,
        "linear_traces": linear,
        "checked_traces": checked,
        "failures": failures,
        "cycles": cycles,
        "odd_cycles": odd_cycles,
        "minimum_bridge_count": minimum_bridge_count,
    }


def random_linear(
    lift: Lift,
    target: int,
    minimum_size: int,
    maximum_size: int,
    seed: int,
) -> dict:
    rng = random.Random(seed)
    attempts = 0
    linear = 0
    failures = 0
    cycles = 0
    odd_cycles = 0
    minimum_bridge_count: Optional[int] = None

    while linear < target:
        attempts += 1
        if attempts > 5_000_000:
            raise RuntimeError(f"could not collect {target} linear traces in {lift.host.name}")
        size = rng.randint(minimum_size, min(maximum_size, len(lift.host.edges)))
        selected = tuple(sorted(rng.sample(range(len(lift.host.edges)), size)))
        if not is_linear(lift.host, selected):
            continue
        linear += 1
        success, local_cycles, local_odd, local_min = check_trace(lift, selected)
        if not success:
            failures += 1
            break
        cycles += local_cycles
        odd_cycles += local_odd
        minimum_bridge_count = (
            local_min if minimum_bridge_count is None else min(minimum_bridge_count, local_min)
        )

    return {
        "host": lift.host.name,
        "base": lift.base.name,
        "uniformity": lift.host.uniformity,
        "host_edges": len(lift.host.edges),
        "attempts": attempts,
        "linear_traces": linear,
        "target_linear_traces": target,
        "failures": failures,
        "cycles": cycles,
        "odd_cycles": odd_cycles,
        "minimum_bridge_count": minimum_bridge_count,
        "seed": seed,
    }


def comparable(data: dict) -> dict:
    result = dict(data)
    result.pop("elapsed_seconds", None)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target-linear", type=int, default=2500)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    started = time.time()

    K3 = graph(3, [(0, 1), (1, 2), (0, 2)], "K3")
    C4 = graph(4, [(0, 1), (1, 2), (2, 3), (3, 0)], "C4")
    C3exp3 = expansion(K3, 3, "C3^(3)")
    C4exp3 = expansion(C4, 3, "C4^(3)")

    lifts = [
        complete_rank_lift(K3, 2, "FullLift_2(K3)"),
        complete_rank_lift(C4, 2, "FullLift_2(C4)"),
        complete_rank_lift(C3exp3, 2, "FullLift_2(C3^(3))"),
        complete_rank_lift(C4exp3, 2, "FullLift_2(C4^(3))"),
    ]

    exhaustive = [exhaustive_three_edge(lifts[0]), exhaustive_three_edge(lifts[1])]
    random_results = [
        random_linear(lifts[2], args.target_linear, 3, 7, 59333),
        random_linear(lifts[3], args.target_linear, 3, 7, 59344),
    ]

    for record in [*exhaustive, *random_results]:
        if record["failures"] != 0:
            raise AssertionError(record)
        if record["minimum_bridge_count"] < 1:
            raise AssertionError(record)

    if exhaustive[1]["odd_cycles"] != 0 or random_results[1]["odd_cycles"] != 0:
        raise AssertionError("odd cycle found above a Berge-even base")

    output = {
        "status": "passed",
        "interpretation": (
            "Finite complete-rank evidence only. Every tested linear trace had "
            "a bridge at its selected apex incidence, all connector nodes on "
            "each Berge cycle collapsed to one base node, and every cycle "
            "projected length-preservingly to the base hypergraph."
        ),
        "configuration": {"depth": 2, "target_linear_per_random_host": args.target_linear},
        "hosts": [
            {
                "name": lift.host.name,
                "base": lift.base.name,
                "uniformity": lift.host.uniformity,
                "vertices": lift.host.vertex_count,
                "edges": len(lift.host.edges),
                "nodes": len(lift.node_sequences),
            }
            for lift in lifts
        ],
        "exhaustive": exhaustive,
        "random": random_results,
        "elapsed_seconds": round(time.time() - started, 3),
    }

    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if comparable(output) != comparable(expected):
            sys.stderr.write(f"generated result differs from {args.check}\n")
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
