#!/usr/bin/env python3
"""Adversarial finite search for the uniform cycle-collapse theorem.

The theorem under review says that every Berge cycle in a finite linear trace
of the complete-rank one-apex lift has all connector points at one common
sequence node. The same cycle then projects, with unchanged length, to a Berge
cycle in the base hypergraph, and no selected apex incidence can be a cycle
incidence.

This program searches cycles directly, rather than sampling arbitrary edge
sets. For each finite complete-rank lift it enumerates every canonically
oriented Berge cycle up to the specified length whose selected lift edges are
pairwise linear. It checks connector collapse, length-preserving projection,
and avoidance of selected apices. Non-immediate proper-prefix jumps are
included.

The computation is evidence only. It does not replace the transfinite proof.
No third-party packages are required.
"""

from __future__ import annotations

import argparse
import collections
import dataclasses
import itertools
import json
import sys
import time
from pathlib import Path
from typing import FrozenSet, List, Optional, Sequence, Tuple

Edge = FrozenSet[int]


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
    coordinate_count: int
    node_sequences: Tuple[Tuple[int, ...], ...]
    base_edge_of: Tuple[int, ...]
    base_node_of: Tuple[int, ...]
    apex_node_of: Tuple[int, ...]
    apex_vertex_of: Tuple[int, ...]


def graph(vertex_count: int, pairs: Sequence[Tuple[int, int]], name: str) -> Hypergraph:
    return Hypergraph(
        uniformity=2,
        vertex_count=vertex_count,
        edges=tuple(frozenset(pair) for pair in pairs),
        name=name,
    )


def expansion(base_graph: Hypergraph, uniformity: int, name: str) -> Hypergraph:
    if base_graph.uniformity != 2 or uniformity < 2:
        raise ValueError("expansion expects a graph and uniformity >= 2")
    edges: List[Edge] = []
    next_vertex = base_graph.vertex_count
    for pair in base_graph.edges:
        private = set(range(next_vertex, next_vertex + uniformity - 2))
        next_vertex += uniformity - 2
        edges.append(frozenset(set(pair) | private))
    return Hypergraph(uniformity, next_vertex, tuple(edges), name)


def is_proper_prefix(left: Tuple[int, ...], right: Tuple[int, ...]) -> bool:
    return len(left) < len(right) and right[: len(left)] == left


def complete_rank_lift(base: Hypergraph, depth: int, name: str) -> Lift:
    if depth < 1:
        raise ValueError("depth must be positive")

    alphabet = range(len(base.edges))
    sequences: List[Tuple[int, ...]] = [()]
    for length in range(1, depth + 1):
        sequences.extend(itertools.product(alphabet, repeat=length))
    node_index = {sequence: index for index, sequence in enumerate(sequences)}

    n = base.vertex_count
    edges: List[Edge] = []
    base_edge_of: List[int] = []
    base_node_of: List[int] = []
    apex_node_of: List[int] = []
    apex_vertex_of: List[int] = []

    for sigma in sequences:
        for tau in sequences:
            if not is_proper_prefix(sigma, tau):
                continue
            base_edge = tau[len(sigma)]
            sigma_index = node_index[sigma]
            tau_index = node_index[tau]
            base_vertices = {
                sigma_index * n + coordinate for coordinate in base.edges[base_edge]
            }
            for apex_coordinate in range(n):
                apex = tau_index * n + apex_coordinate
                edges.append(frozenset(base_vertices | {apex}))
                base_edge_of.append(base_edge)
                base_node_of.append(sigma_index)
                apex_node_of.append(tau_index)
                apex_vertex_of.append(apex)

    host = Hypergraph(
        uniformity=base.uniformity + 1,
        vertex_count=len(sequences) * n,
        edges=tuple(edges),
        name=name,
    )
    return Lift(
        host=host,
        base=base,
        coordinate_count=n,
        node_sequences=tuple(sequences),
        base_edge_of=tuple(base_edge_of),
        base_node_of=tuple(base_node_of),
        apex_node_of=tuple(apex_node_of),
        apex_vertex_of=tuple(apex_vertex_of),
    )


def verify_projected_cycle(
    lift: Lift,
    edge_cycle: Sequence[int],
    connectors: Sequence[int],
) -> Optional[str]:
    length = len(edge_cycle)
    connector_nodes = tuple(vertex // lift.coordinate_count for vertex in connectors)
    if len(set(connector_nodes)) != 1:
        return "connector nodes did not collapse"

    common_node = connector_nodes[0]
    base_nodes = tuple(lift.base_node_of[edge] for edge in edge_cycle)
    if any(node != common_node for node in base_nodes):
        return "a cycle edge did not use the common connector node as its base"

    base_edges = tuple(lift.base_edge_of[edge] for edge in edge_cycle)
    coordinates = tuple(vertex % lift.coordinate_count for vertex in connectors)
    if len(set(base_edges)) != length:
        return "projected base edge labels were not distinct"
    if len(set(coordinates)) != length:
        return "projected connector coordinates were not distinct"

    for index, base_edge in enumerate(base_edges):
        previous = coordinates[index - 1]
        following = coordinates[index]
        if previous not in lift.base.edges[base_edge]:
            return "previous connector was absent from a projected base edge"
        if following not in lift.base.edges[base_edge]:
            return "following connector was absent from a projected base edge"

    for index, edge in enumerate(edge_cycle):
        if lift.apex_vertex_of[edge] in (connectors[index - 1], connectors[index]):
            return "a selected apex was used as a cycle connector"

    return None


def enumerate_linear_cycles(lift: Lift, maximum_length: int) -> dict:
    host_edges = lift.host.edges
    edge_count = len(host_edges)

    # None means disjoint, -1 means a non-linear pair, and an integer is the
    # unique shared vertex.
    intersection: List[List[Optional[int]]] = [
        [None for _ in range(edge_count)] for _ in range(edge_count)
    ]
    linear_pair = [[True for _ in range(edge_count)] for _ in range(edge_count)]
    neighbours: List[List[int]] = [[] for _ in range(edge_count)]

    for left in range(edge_count):
        for right in range(left + 1, edge_count):
            shared = host_edges[left].intersection(host_edges[right])
            if len(shared) > 1:
                linear_pair[left][right] = linear_pair[right][left] = False
                intersection[left][right] = intersection[right][left] = -1
            elif len(shared) == 1:
                point = next(iter(shared))
                intersection[left][right] = intersection[right][left] = point
                neighbours[left].append(right)
                neighbours[right].append(left)

    counts: collections.Counter[str] = collections.Counter()
    failure: Optional[dict] = None

    for start in range(edge_count):
        def extend(path: List[int], connectors: List[int]) -> None:
            nonlocal failure
            if failure is not None:
                return

            last = path[-1]
            length = len(path)

            if length >= 3:
                closing = intersection[last][start]
                if closing not in (None, -1) and closing not in connectors:
                    # start is the least edge index; this removes reversal
                    # duplicates.
                    if path[1] < path[-1]:
                        cycle_edges = tuple(path)
                        cycle_connectors = tuple(connectors + [int(closing)])
                        counts["cycles"] += 1
                        counts[f"length_{length}"] += 1

                        if any(
                            len(lift.node_sequences[lift.apex_node_of[edge]])
                            - len(lift.node_sequences[lift.base_node_of[edge]])
                            > 1
                            for edge in cycle_edges
                        ):
                            counts["cycles_using_nonimmediate_prefix_jump"] += 1

                        error = verify_projected_cycle(
                            lift, cycle_edges, cycle_connectors
                        )
                        if error is not None:
                            failure = {
                                "error": error,
                                "edge_cycle": list(cycle_edges),
                                "connectors": list(cycle_connectors),
                                "connector_nodes": [
                                    vertex // lift.coordinate_count
                                    for vertex in cycle_connectors
                                ],
                            }
                            return
                        counts["collapsed_and_projected"] += 1

            if length == maximum_length:
                return

            for following in neighbours[last]:
                if following <= start or following in path:
                    continue
                if any(not linear_pair[following][edge] for edge in path):
                    continue
                connector = intersection[last][following]
                if connector in connectors:
                    continue
                extend(path + [following], connectors + [int(connector)])
                if failure is not None:
                    return

        for second in neighbours[start]:
            if second <= start:
                continue
            extend([start, second], [int(intersection[start][second])])
            if failure is not None:
                break
        if failure is not None:
            break

    if failure is not None:
        raise AssertionError(
            f"{lift.host.name}: cycle-collapse failure: {json.dumps(failure)}"
        )

    return {
        "host": lift.host.name,
        "base": lift.base.name,
        "base_uniformity": lift.base.uniformity,
        "lift_uniformity": lift.host.uniformity,
        "depth": max(map(len, lift.node_sequences)),
        "nodes": len(lift.node_sequences),
        "vertices": lift.host.vertex_count,
        "edges": len(lift.host.edges),
        "maximum_cycle_length": maximum_length,
        **dict(counts),
        "failures": 0,
    }


def comparable(data: dict) -> dict:
    result = dict(data)
    result.pop("elapsed_seconds", None)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    started = time.time()

    k3 = graph(3, [(0, 1), (1, 2), (0, 2)], "K3")
    c4 = graph(4, [(0, 1), (1, 2), (2, 3), (3, 0)], "C4")
    c3_expansion = expansion(k3, 3, "C3^(3)")
    c4_expansion = expansion(c4, 3, "C4^(3)")

    tests = [
        (complete_rank_lift(k3, 2, "FullLift_2(K3)"), 3),
        (complete_rank_lift(k3, 3, "FullLift_3(K3)"), 3),
        (complete_rank_lift(c4, 2, "FullLift_2(C4)"), 4),
        (complete_rank_lift(c3_expansion, 2, "FullLift_2(C3^(3))"), 3),
        (complete_rank_lift(c4_expansion, 2, "FullLift_2(C4^(3))"), 4),
    ]

    records = [
        enumerate_linear_cycles(lift, maximum_length)
        for lift, maximum_length in tests
    ]

    total_cycles = sum(record.get("cycles", 0) for record in records)
    nonimmediate = sum(
        record.get("cycles_using_nonimmediate_prefix_jump", 0)
        for record in records
    )
    projected = sum(
        record.get("collapsed_and_projected", 0) for record in records
    )

    if total_cycles == 0 or projected != total_cycles:
        raise AssertionError("the search did not certify every enumerated cycle")
    if nonimmediate == 0:
        raise AssertionError("the search did not exercise non-immediate jumps")

    output = {
        "status": "passed",
        "interpretation": (
            "Finite adversarial evidence only. Every exhaustively enumerated "
            "pairwise-linear Berge cycle collapsed to one connector node, "
            "projected length-preservingly to the base, and avoided every "
            "selected apex incidence."
        ),
        "records": records,
        "totals": {
            "cycles": total_cycles,
            "collapsed_and_projected": projected,
            "cycles_using_nonimmediate_prefix_jump": nonimmediate,
            "failures": 0,
        },
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
