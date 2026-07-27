#!/usr/bin/env python3
"""Finite certificates for the bridge-core reconstruction in Erdős 593.

The checker uses only the Python standard library.  It verifies the graph lemma
behind the constructive/intrinsic equivalence, exhausts all graph expansions on
at most five core vertices, and records explicit negative controls for each
failed intrinsic hypothesis.
"""
from __future__ import annotations

from collections import defaultdict, deque
from dataclasses import asdict, dataclass
from itertools import combinations
import json
from typing import Iterable

Point = int
Hyperedge = frozenset[int]
Node = tuple[str, int]
Bridge = frozenset[Node]


@dataclass(frozen=True)
class ExpansionPiece:
    component: int
    hyperedges: tuple[int, ...]
    core_edges: tuple[tuple[int, int], ...]
    private_points: tuple[int, ...]
    points: tuple[int, ...]


def normalize_hyperedges(edges: Iterable[Iterable[int]]) -> tuple[Hyperedge, ...]:
    result = tuple(frozenset(edge) for edge in edges)
    if any(len(edge) != 3 for edge in result):
        raise AssertionError("the input is not 3-uniform")
    if len(result) != len(set(result)):
        raise AssertionError("duplicate hyperedge")
    return result


def is_linear(edges: tuple[Hyperedge, ...]) -> bool:
    return all(len(left & right) <= 1 for left, right in combinations(edges, 2))


def levi_graph(edges: tuple[Hyperedge, ...]) -> dict[Node, set[Node]]:
    adjacency: dict[Node, set[Node]] = defaultdict(set)
    for index, edge in enumerate(edges):
        edge_node = ("e", index)
        for point in edge:
            point_node = ("p", point)
            adjacency[edge_node].add(point_node)
            adjacency[point_node].add(edge_node)
    return {node: set(neighbors) for node, neighbors in adjacency.items()}


def graph_bridges(adjacency: dict[Node, set[Node]]) -> set[Bridge]:
    timer = 0
    discovery: dict[Node, int] = {}
    low: dict[Node, int] = {}
    result: set[Bridge] = set()

    def visit(node: Node, parent: Node | None) -> None:
        nonlocal timer
        discovery[node] = low[node] = timer
        timer += 1
        for neighbor in adjacency[node]:
            if neighbor == parent:
                continue
            if neighbor in discovery:
                low[node] = min(low[node], discovery[neighbor])
            else:
                visit(neighbor, node)
                low[node] = min(low[node], low[neighbor])
                if low[neighbor] > discovery[node]:
                    result.add(frozenset((node, neighbor)))

    for node in adjacency:
        if node not in discovery:
            visit(node, None)
    return result


def components_after_deletion(
    adjacency: dict[Node, set[Node]], removed: set[Bridge]
) -> tuple[frozenset[Node], ...]:
    seen: set[Node] = set()
    components: list[frozenset[Node]] = []
    for start in adjacency:
        if start in seen:
            continue
        stack = [start]
        seen.add(start)
        component: set[Node] = set()
        while stack:
            node = stack.pop()
            component.add(node)
            for neighbor in adjacency[node]:
                if frozenset((node, neighbor)) in removed:
                    continue
                if neighbor not in seen:
                    seen.add(neighbor)
                    stack.append(neighbor)
        components.append(frozenset(component))
    return tuple(components)


def is_bipartite(adjacency: dict[int, set[int]]) -> bool:
    color: dict[int, int] = {}
    for start in adjacency:
        if start in color:
            continue
        color[start] = 0
        queue: deque[int] = deque([start])
        while queue:
            vertex = queue.popleft()
            for neighbor in adjacency[vertex]:
                if neighbor not in color:
                    color[neighbor] = 1 - color[vertex]
                    queue.append(neighbor)
                elif color[neighbor] == color[vertex]:
                    return False
    return True


def is_forest(adjacency: dict[int, set[int]]) -> bool:
    seen: set[int] = set()
    for start in adjacency:
        if start in seen:
            continue
        stack = [(start, None)]
        seen.add(start)
        while stack:
            vertex, parent = stack.pop()
            for neighbor in adjacency[vertex]:
                if neighbor == parent:
                    continue
                if neighbor in seen:
                    return False
                seen.add(neighbor)
                stack.append((neighbor, vertex))
    return True


def bridge_core_certificate(raw_edges: Iterable[Iterable[int]]) -> dict[str, object]:
    edges = normalize_hyperedges(raw_edges)
    if not edges:
        return {
            "accepted": True,
            "reason": "edgeless",
            "bridges": 0,
            "pieces": 0,
        }
    if not is_linear(edges):
        return {"accepted": False, "reason": "nonlinear"}

    adjacency = levi_graph(edges)
    bridges = graph_bridges(adjacency)

    for index in range(len(edges)):
        edge_node = ("e", index)
        if not any(
            frozenset((edge_node, neighbor)) in bridges
            for neighbor in adjacency[edge_node]
        ):
            return {
                "accepted": False,
                "reason": "missing_bridge",
                "hyperedge": index,
            }

    components = components_after_deletion(adjacency, bridges)
    component_of = {
        node: index for index, component in enumerate(components) for node in component
    }

    quotient: dict[int, set[int]] = {index: set() for index in range(len(components))}
    quotient_edges: set[tuple[int, int]] = set()
    for bridge in bridges:
        left, right = tuple(bridge)
        first, second = component_of[left], component_of[right]
        if first == second:
            raise AssertionError("a deleted bridge stayed inside one component")
        pair = tuple(sorted((first, second)))
        if pair in quotient_edges:
            raise AssertionError("parallel bridge edges in the quotient")
        quotient_edges.add(pair)
        quotient[first].add(second)
        quotient[second].add(first)
    if not is_forest(quotient):
        raise AssertionError("the bridge quotient is not a forest")

    pieces: list[ExpansionPiece] = []
    for component_index, component in enumerate(components):
        hyperedge_indices = sorted(
            node[1] for node in component if node[0] == "e"
        )
        if not hyperedge_indices:
            continue

        core_edges: list[tuple[int, int]] = []
        private_points: list[int] = []
        piece_points = {node[1] for node in component if node[0] == "p"}

        for edge_index in hyperedge_indices:
            edge_node = ("e", edge_index)
            residual_points = sorted(
                neighbor[1]
                for neighbor in adjacency[edge_node]
                if frozenset((edge_node, neighbor)) not in bridges
            )
            if len(residual_points) not in (0, 2):
                raise AssertionError("residual hyperedge degree is not zero or two")

            if len(residual_points) == 2:
                core_edges.append(tuple(residual_points))
                outside_points = sorted(
                    neighbor[1]
                    for neighbor in adjacency[edge_node]
                    if frozenset((edge_node, neighbor)) in bridges
                )
                if len(outside_points) != 1:
                    raise AssertionError("an active edge does not have one private point")
                private_points.append(outside_points[0])
                piece_points.add(outside_points[0])
            else:
                # An all-bridge edge-node is isolated after bridge deletion.
                if len(hyperedge_indices) != 1:
                    raise AssertionError("an all-bridge edge shares an active component")
                endpoints = sorted(edges[edge_index])
                core_edges.append((endpoints[0], endpoints[1]))
                private_points.append(endpoints[2])
                piece_points.update(endpoints)

        canonical_core_edges = [tuple(sorted(edge)) for edge in core_edges]
        if len(canonical_core_edges) != len(set(canonical_core_edges)):
            raise AssertionError("suppression created parallel graph edges")
        if len(private_points) != len(set(private_points)):
            raise AssertionError("two hyperedges in one piece share a private point")

        core_adjacency: dict[int, set[int]] = defaultdict(set)
        for left, right in canonical_core_edges:
            core_adjacency[left].add(right)
            core_adjacency[right].add(left)
        if not is_bipartite(core_adjacency):
            return {
                "accepted": False,
                "reason": "odd_berge_cycle",
                "component": component_index,
            }

        pieces.append(
            ExpansionPiece(
                component=component_index,
                hyperedges=tuple(hyperedge_indices),
                core_edges=tuple(canonical_core_edges),
                private_points=tuple(private_points),
                points=tuple(sorted(piece_points)),
            )
        )

    active_components = {piece.component for piece in pieces}
    active_order: list[int] = []
    visited_quotient_vertices: set[int] = set()

    for candidate in sorted(active_components):
        if candidate in visited_quotient_vertices:
            continue
        quotient_component = {candidate}
        stack = [candidate]
        while stack:
            vertex = stack.pop()
            for neighbor in quotient[vertex]:
                if neighbor not in quotient_component:
                    quotient_component.add(neighbor)
                    stack.append(neighbor)

        root = min(active_components & quotient_component)
        distance = {root: 0}
        queue: deque[int] = deque([root])
        while queue:
            vertex = queue.popleft()
            for neighbor in quotient[vertex]:
                if neighbor not in distance:
                    distance[neighbor] = distance[vertex] + 1
                    queue.append(neighbor)

        active_order.extend(
            sorted(
                active_components & quotient_component,
                key=lambda vertex: (distance[vertex], vertex),
            )
        )
        visited_quotient_vertices.update(quotient_component)

    piece_by_component = {piece.component: piece for piece in pieces}
    assembled_points: set[int] = set()
    intersections: list[dict[str, object]] = []
    for component_index in active_order:
        current_points = set(piece_by_component[component_index].points)
        intersection = tuple(sorted(current_points & assembled_points))
        if len(intersection) > 1:
            raise AssertionError("running intersection uses more than one point")
        intersections.append(
            {"component": component_index, "intersection": intersection}
        )
        assembled_points.update(current_points)

    all_points = set().union(*edges)
    if assembled_points != all_points:
        raise AssertionError("the expansion pieces do not cover the point set")
    if sorted(
        index for piece in pieces for index in piece.hyperedges
    ) != list(range(len(edges))):
        raise AssertionError("the expansion pieces do not partition the hyperedges")

    return {
        "accepted": True,
        "reason": "bridge_core_certificate",
        "order": len(all_points),
        "size": len(edges),
        "bridges": len(bridges),
        "components_after_bridge_deletion": len(components),
        "quotient_edges": len(quotient_edges),
        "pieces": [asdict(piece) for piece in pieces],
        "active_order": active_order,
        "running_intersections": intersections,
    }


def graph_is_bipartite(
    vertex_count: int, edges: tuple[tuple[int, int], ...]
) -> bool:
    adjacency: dict[int, set[int]] = {
        vertex: set() for vertex in range(vertex_count)
    }
    for left, right in edges:
        adjacency[left].add(right)
        adjacency[right].add(left)
    return is_bipartite(adjacency)


def graph_expansion(
    edges: Iterable[tuple[int, int]], private_start: int
) -> tuple[Hyperedge, ...]:
    return tuple(
        frozenset((left, right, private_start + index))
        for index, (left, right) in enumerate(edges)
    )


def exhaustive_graph_expansions(max_vertices: int = 5) -> dict[str, int]:
    tested = accepted = rejected_odd = 0
    for vertex_count in range(2, max_vertices + 1):
        possible_edges = tuple(combinations(range(vertex_count), 2))
        for mask in range(1, 1 << len(possible_edges)):
            graph_edges = tuple(
                edge
                for index, edge in enumerate(possible_edges)
                if mask & (1 << index)
            )
            expected = graph_is_bipartite(vertex_count, graph_edges)
            certificate = bridge_core_certificate(
                graph_expansion(graph_edges, private_start=10_000)
            )
            tested += 1
            if expected:
                if not certificate["accepted"]:
                    raise AssertionError("a bipartite expansion was rejected")
                accepted += 1
            else:
                if certificate.get("reason") != "odd_berge_cycle":
                    raise AssertionError(
                        "a nonbipartite expansion had the wrong diagnosis"
                    )
                rejected_odd += 1
    return {
        "graphs_tested": tested,
        "bipartite_expansions_accepted": accepted,
        "nonbipartite_expansions_rejected": rejected_odd,
    }


def named_cases() -> dict[str, object]:
    c4_first = graph_expansion(((0, 1), (1, 2), (2, 3), (3, 0)), 100)
    # The private point 100 of the first expansion is a core point of the second.
    c4_second = graph_expansion(
        ((100, 11), (11, 12), (12, 13), (13, 100)), 200
    )
    disjoint_path = graph_expansion(((20, 21), (21, 22)), 300)

    positive = {
        "single_C4_expansion": bridge_core_certificate(c4_first),
        "private_to_core_amalgamation": bridge_core_certificate(
            c4_first + c4_second
        ),
        "disjoint_union_with_path_expansion": bridge_core_certificate(
            c4_first + disjoint_path
        ),
        "single_edge_atom": bridge_core_certificate(({40, 41, 42},)),
    }
    if not all(case["accepted"] for case in positive.values()):
        raise AssertionError("a named positive case was rejected")

    triangle_expansion = graph_expansion(((0, 1), (1, 2), (2, 0)), 500)
    fano_plane = (
        {0, 1, 3},
        {0, 2, 5},
        {0, 4, 6},
        {1, 2, 4},
        {1, 5, 6},
        {2, 3, 6},
        {3, 4, 5},
    )
    negative = {
        "nonlinear_pair": bridge_core_certificate(({0, 1, 2}, {0, 1, 3})),
        "triangle_expansion": bridge_core_certificate(triangle_expansion),
        "Fano_plane": bridge_core_certificate(fano_plane),
    }
    expected_reasons = {
        "nonlinear_pair": "nonlinear",
        "triangle_expansion": "odd_berge_cycle",
        "Fano_plane": "missing_bridge",
    }
    for name, reason in expected_reasons.items():
        if negative[name].get("reason") != reason:
            raise AssertionError(f"{name}: expected {reason}")

    return {"positive": positive, "negative": negative}


def main() -> None:
    if not __debug__:
        raise RuntimeError("verification must not be run with python -O")
    result = {
        "exhaustive_graph_expansions": exhaustive_graph_expansions(),
        "named_cases": named_cases(),
    }
    print("Erdos 593 bridge-core certificates: PASS")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
