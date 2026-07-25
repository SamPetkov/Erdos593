#!/usr/bin/env python3
"""
Finite sanity checks for the arbitrary-rank one-apex lift.

These checks do not prove the infinitary theorems. They independently test the
two local mechanisms used in the proof:

1. one-apex incidences are bridges in finite linear traces;
2. iterating the lift accumulates one guaranteed bridge per rank;
3. Berge triangles collapse to the source graph with their length preserved.

Only the Python standard library is used.
"""

from __future__ import annotations

import argparse
import collections
import itertools
import json
from pathlib import Path
from typing import Dict, FrozenSet, List, Mapping, Sequence, Set, Tuple

Node = Tuple[int, ...]
Vertex = Tuple[Node, object]
Edge = FrozenSet[Vertex]
Adjacency = Dict[Tuple[str, object], Set[Tuple[str, object]]]


def all_words(alphabet_size: int, depth: int) -> List[Node]:
    words: List[Node] = [()]
    for length in range(1, depth):
        words.extend(
            tuple(word)
            for word in itertools.product(range(alphabet_size), repeat=length)
        )
    return words


def finite_one_apex_lift(
    source_vertices: Sequence[object],
    source_edges: Sequence[FrozenSet[object]],
    depth: int,
) -> Tuple[Tuple[Vertex, ...], Tuple[Edge, ...], Tuple[dict, ...]]:
    """Truncate the complete-rank lift to source words of length < depth."""
    source_vertices = tuple(source_vertices)
    source_edges = tuple(frozenset(edge) for edge in source_edges)
    words = all_words(len(source_edges), depth)
    vertices = tuple((word, vertex) for word in words for vertex in source_vertices)

    edge_to_meta: Dict[Edge, dict] = {}
    for source_word in words:
        source_length = len(source_word)
        for apex_word in words:
            if (
                len(apex_word) <= source_length
                or apex_word[:source_length] != source_word
            ):
                continue
            source_edge_index = apex_word[source_length]
            source_edge = source_edges[source_edge_index]
            for apex_coordinate in source_vertices:
                lift_edge = frozenset(
                    [(source_word, vertex) for vertex in source_edge]
                    + [(apex_word, apex_coordinate)]
                )
                if len(lift_edge) != len(source_edge) + 1:
                    raise AssertionError("lift edge is not rank-raised by one")
                edge_to_meta.setdefault(
                    lift_edge,
                    {
                        "source_word": source_word,
                        "source_edge_index": source_edge_index,
                        "apex_word": apex_word,
                        "apex_coordinate": apex_coordinate,
                        "apex_vertex": (apex_word, apex_coordinate),
                    },
                )
    return vertices, tuple(edge_to_meta), tuple(edge_to_meta.values())


def levi_adjacency(edges: Sequence[Edge]) -> Adjacency:
    adjacency: Adjacency = collections.defaultdict(set)
    for edge_index, edge in enumerate(edges):
        edge_node = ("e", edge_index)
        adjacency[edge_node]
        for vertex in edge:
            vertex_node = ("v", vertex)
            adjacency[edge_node].add(vertex_node)
            adjacency[vertex_node].add(edge_node)
    return dict(adjacency)


def bridges(
    adjacency: Mapping[Tuple[str, object], Set[Tuple[str, object]]]
) -> Set[FrozenSet[Tuple[str, object]]]:
    timer = 0
    discovery: Dict[Tuple[str, object], int] = {}
    low: Dict[Tuple[str, object], int] = {}
    parent: Dict[Tuple[str, object], Tuple[str, object] | None] = {}
    result: Set[FrozenSet[Tuple[str, object]]] = set()

    def dfs(node: Tuple[str, object]) -> None:
        nonlocal timer
        discovery[node] = low[node] = timer
        timer += 1
        for neighbour in adjacency[node]:
            if neighbour not in discovery:
                parent[neighbour] = node
                dfs(neighbour)
                low[node] = min(low[node], low[neighbour])
                if low[neighbour] > discovery[node]:
                    result.add(frozenset((node, neighbour)))
            elif neighbour != parent[node]:
                low[node] = min(low[node], discovery[neighbour])

    for node in adjacency:
        if node not in discovery:
            parent[node] = None
            dfs(node)
    return result


def is_linear(edges: Sequence[Edge]) -> bool:
    return all(
        len(left.intersection(right)) <= 1
        for left, right in itertools.combinations(edges, 2)
    )


def bridge_counts(edges: Sequence[Edge]) -> List[int]:
    adjacency = levi_adjacency(edges)
    bridge_set = bridges(adjacency)
    return [
        sum(
            frozenset((("e", edge_index), ("v", vertex))) in bridge_set
            for vertex in edge
        )
        for edge_index, edge in enumerate(edges)
    ]


def has_berge_cycle(edges: Sequence[Edge]) -> bool:
    """Exact cycle search for the tiny traces used by this test."""
    edge_count = len(edges)
    shared: Dict[Tuple[int, int], Vertex] = {}
    for left in range(edge_count):
        for right in range(left + 1, edge_count):
            intersection = edges[left].intersection(edges[right])
            if len(intersection) > 1:
                return True
            if intersection:
                shared[(left, right)] = next(iter(intersection))

    for length in range(3, edge_count + 1):
        for subset in itertools.combinations(range(edge_count), length):
            first = min(subset)
            remaining = tuple(index for index in subset if index != first)
            for tail in itertools.permutations(remaining):
                cycle = (first,) + tail
                if cycle[1] > cycle[-1]:
                    continue
                connectors: List[Vertex] = []
                valid = True
                for left, right in zip(cycle, cycle[1:] + cycle[:1]):
                    key = (left, right) if left < right else (right, left)
                    connector = shared.get(key)
                    if connector is None:
                        valid = False
                        break
                    connectors.append(connector)
                if valid and len(set(connectors)) == length:
                    return True
    return False


def check_all_small_traces(
    edges: Sequence[Edge],
    rank: int,
    max_trace_edges: int,
    expect_acyclic: bool,
) -> dict:
    total = 0
    linear = 0
    for size in range(1, max_trace_edges + 1):
        for indices in itertools.combinations(range(len(edges)), size):
            total += 1
            trace = tuple(edges[index] for index in indices)
            if not is_linear(trace):
                continue
            linear += 1
            counts = bridge_counts(trace)
            if min(counts) < rank - 2:
                raise AssertionError(
                    f"bridge deficit in rank {rank}: indices={indices}, counts={counts}"
                )
            if expect_acyclic and has_berge_cycle(trace):
                raise AssertionError(
                    f"unexpected Berge cycle over acyclic base: rank={rank}, indices={indices}"
                )
    return {
        "rank": rank,
        "host_edges": len(edges),
        "subsets_examined": total,
        "linear_traces": linear,
        "minimum_required_bridges": rank - 2,
        "expect_acyclic": expect_acyclic,
    }


def is_berge_triangle(edges: Sequence[Edge]) -> bool:
    if len(edges) != 3 or not is_linear(edges):
        return False
    intersections = [
        edges[0].intersection(edges[1]),
        edges[1].intersection(edges[2]),
        edges[2].intersection(edges[0]),
    ]
    return (
        all(len(intersection) == 1 for intersection in intersections)
        and len({next(iter(intersection)) for intersection in intersections}) == 3
    )


def check_triangle_collapse(
    source_name: str,
    lift_rank: int,
    source_edges: Sequence[FrozenSet[object]],
    lift_edges: Sequence[Edge],
    metadata: Sequence[dict],
) -> dict:
    triangles = 0
    for indices in itertools.combinations(range(len(lift_edges)), 3):
        trace = tuple(lift_edges[index] for index in indices)
        if not is_berge_triangle(trace):
            continue
        triangles += 1
        connectors = [
            next(iter(trace[0].intersection(trace[1]))),
            next(iter(trace[1].intersection(trace[2]))),
            next(iter(trace[2].intersection(trace[0]))),
        ]
        if len({connector[0] for connector in connectors}) != 1:
            raise AssertionError(f"cycle collapse failed for {indices}")

        source_indices = [metadata[index]["source_edge_index"] for index in indices]
        projected_edges = [source_edges[index] for index in source_indices]
        projected_connectors = [
            next(iter(projected_edges[0].intersection(projected_edges[1]))),
            next(iter(projected_edges[1].intersection(projected_edges[2]))),
            next(iter(projected_edges[2].intersection(projected_edges[0]))),
        ]
        if len(set(projected_connectors)) != 3:
            raise AssertionError(
                f"projected source edges do not form a triangle: {indices}"
            )

    if triangles == 0:
        raise AssertionError("triangle-collapse test found no nontrivial cycles")
    return {
        "source": source_name,
        "rank": lift_rank,
        "berge_triangles_checked": triangles,
        "all_connector_nodes_collapsed": True,
        "all_projected_to_source_triangles": True,
    }


def run() -> dict:
    # Acyclic base K2.
    graph_vertices = (0, 1)
    graph_edges = (frozenset((0, 1)),)
    rank3_vertices, rank3_edges, _ = finite_one_apex_lift(
        graph_vertices, graph_edges, depth=3
    )
    _, rank4_edges, _ = finite_one_apex_lift(
        rank3_vertices, rank3_edges, depth=2
    )

    acyclic_checks = [
        check_all_small_traces(
            rank3_edges, rank=3, max_trace_edges=4, expect_acyclic=True
        ),
        check_all_small_traces(
            rank4_edges, rank=4, max_trace_edges=3, expect_acyclic=True
        ),
    ]

    # Nontrivial cycle base C3.
    triangle_vertices = (0, 1, 2)
    triangle_edges = (
        frozenset((0, 1)),
        frozenset((1, 2)),
        frozenset((0, 2)),
    )
    _, triangle_lift_edges, triangle_meta = finite_one_apex_lift(
        triangle_vertices, triangle_edges, depth=3
    )
    collapse_rank3 = check_triangle_collapse(
        "C3", 3, triangle_edges, triangle_lift_edges, triangle_meta
    )

    # Rank-four check: lift the 3-uniform expansion of C3.
    expanded_triangle_vertices = (0, 1, 2, 3, 4, 5)
    expanded_triangle_edges = (
        frozenset((0, 1, 3)),
        frozenset((1, 2, 4)),
        frozenset((0, 2, 5)),
    )
    _, rank4_cycle_edges, rank4_cycle_meta = finite_one_apex_lift(
        expanded_triangle_vertices, expanded_triangle_edges, depth=2
    )
    collapse_rank4 = check_triangle_collapse(
        "C3^(3)", 4, expanded_triangle_edges, rank4_cycle_edges, rank4_cycle_meta
    )

    return {
        "status": "passed",
        "interpretation": (
            "Finite truncation checks only. They validate the local bridge accumulation "
            "and cycle-collapse mechanisms used by the arbitrary-rank proof."
        ),
        "acyclic_base_checks": acyclic_checks,
        "cycle_collapse_checks": [collapse_rank3, collapse_rank4],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    result = run()
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if result != expected:
            raise SystemExit("generated result differs from checked result")
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
