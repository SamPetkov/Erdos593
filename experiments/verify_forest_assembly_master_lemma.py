#!/usr/bin/env python3
"""Exact finite audit of the forest-assembly master lemma.

The program checks the abstract piece--point incidence statement.  It does not
attempt to prove the infinite Problem 593 classification.  All enumeration is
finite, deterministic, and uses only the Python standard library.
"""
from __future__ import annotations

from collections import deque
import itertools
import json
from typing import Iterable

PieceNode = tuple[str, int]
PointNode = tuple[str, int]
Node = tuple[str, int] | tuple[str, int, int]
Edge = tuple[Node, Node]


def incidence_data(
    piece_count: int, point_count: int, mask: int
) -> tuple[list[set[int]], list[set[int]]]:
    piece_points = [set() for _ in range(piece_count)]
    point_pieces = [set() for _ in range(point_count)]
    bit = 0
    for piece in range(piece_count):
        for point in range(point_count):
            if mask & (1 << bit):
                piece_points[piece].add(point)
                point_pieces[point].add(piece)
            bit += 1
    return piece_points, point_pieces


def admissible(
    piece_points: list[set[int]], point_pieces: list[set[int]]
) -> bool:
    # Right vertices represent genuinely shared points.
    if any(len(pieces) < 2 for pieces in point_pieces):
        return False
    # Distinct pieces meet in at most one shared point.
    for first in range(len(piece_points)):
        for second in range(first + 1, len(piece_points)):
            if len(piece_points[first] & piece_points[second]) > 1:
                return False
    return True


def incidence_edges(
    piece_points: list[set[int]],
) -> list[tuple[PieceNode, PointNode]]:
    return [
        (("P", piece), ("S", point))
        for piece, points in enumerate(piece_points)
        for point in sorted(points)
    ]


def is_forest(piece_points: list[set[int]], point_count: int) -> bool:
    edges = incidence_edges(piece_points)
    nodes: list[PieceNode | PointNode] = [
        *(("P", piece) for piece in range(len(piece_points))),
        *(("S", point) for point in range(point_count)),
    ]
    parent = {node: node for node in nodes}
    rank = {node: 0 for node in nodes}

    def find(node: PieceNode | PointNode) -> PieceNode | PointNode:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    def union(left: PieceNode | PointNode, right: PieceNode | PointNode) -> bool:
        root_left, root_right = find(left), find(right)
        if root_left == root_right:
            return False
        if rank[root_left] < rank[root_right]:
            root_left, root_right = root_right, root_left
        parent[root_right] = root_left
        if rank[root_left] == rank[root_right]:
            rank[root_left] += 1
        return True

    for left, right in edges:
        if not union(left, right):
            return False
    return True


def intersection_points(
    piece: int, selected_mask: int, piece_points: list[set[int]], point_pieces: list[set[int]]
) -> set[int]:
    return {
        point
        for point in piece_points[piece]
        if any(selected_mask & (1 << other) for other in point_pieces[point] if other != piece)
    }


def find_running_order(
    piece_points: list[set[int]], point_pieces: list[set[int]]
) -> list[int] | None:
    piece_count = len(piece_points)
    full = (1 << piece_count) - 1
    predecessor: dict[int, tuple[int, int] | None] = {0: None}
    queue = deque([0])
    while queue:
        mask = queue.popleft()
        if mask == full:
            order: list[int] = []
            while mask:
                previous, piece = predecessor[mask]  # type: ignore[misc]
                order.append(piece)
                mask = previous
            return list(reversed(order))
        for piece in range(piece_count):
            if mask & (1 << piece):
                continue
            if len(intersection_points(piece, mask, piece_points, point_pieces)) <= 1:
                new_mask = mask | (1 << piece)
                if new_mask not in predecessor:
                    predecessor[new_mask] = (mask, piece)
                    queue.append(new_mask)
    return None


def rooted_forest_order(
    piece_points: list[set[int]], point_count: int
) -> list[int]:
    adjacency: dict[PieceNode | PointNode, set[PieceNode | PointNode]] = {
        **{("P", piece): set() for piece in range(len(piece_points))},
        **{("S", point): set() for point in range(point_count)},
    }
    for piece_node, point_node in incidence_edges(piece_points):
        adjacency[piece_node].add(point_node)
        adjacency[point_node].add(piece_node)

    seen: set[PieceNode | PointNode] = set()
    order: list[int] = []
    for root_piece in range(len(piece_points)):
        root: PieceNode = ("P", root_piece)
        if root in seen:
            continue
        distance = {root: 0}
        queue = deque([root])
        seen.add(root)
        component_pieces: list[tuple[int, int]] = []
        while queue:
            node = queue.popleft()
            if node[0] == "P":
                component_pieces.append((distance[node], node[1]))
            for neighbor in sorted(adjacency[node]):
                if neighbor not in seen:
                    seen.add(neighbor)
                    distance[neighbor] = distance[node] + 1
                    queue.append(neighbor)
        order.extend(piece for _, piece in sorted(component_pieces))
    return order


def check_order(
    order: list[int], piece_points: list[set[int]], point_pieces: list[set[int]]
) -> bool:
    selected = 0
    for piece in order:
        if len(intersection_points(piece, selected, piece_points, point_pieces)) > 1:
            return False
        selected |= 1 << piece
    return selected == (1 << len(piece_points)) - 1


def canonical_edge(left: Node, right: Node) -> Edge:
    return (left, right) if left <= right else (right, left)


def graph_bridges(nodes: set[Node], edges: list[Edge]) -> set[int]:
    adjacency: dict[Node, list[tuple[Node, int]]] = {node: [] for node in nodes}
    for edge_id, (left, right) in enumerate(edges):
        adjacency[left].append((right, edge_id))
        adjacency[right].append((left, edge_id))

    discovery: dict[Node, int] = {}
    low: dict[Node, int] = {}
    bridges: set[int] = set()
    time = 0

    def dfs(node: Node, parent_edge: int | None) -> None:
        nonlocal time
        discovery[node] = low[node] = time
        time += 1
        for neighbor, edge_id in adjacency[node]:
            if edge_id == parent_edge:
                continue
            if neighbor not in discovery:
                dfs(neighbor, edge_id)
                low[node] = min(low[node], low[neighbor])
                if low[neighbor] > discovery[node]:
                    bridges.add(edge_id)
            else:
                low[node] = min(low[node], discovery[neighbor])

    for node in sorted(nodes):
        if node not in discovery:
            dfs(node, None)
    return bridges


def verify_synthetic_assembly(piece_points: list[set[int]]) -> None:
    nodes: set[Node] = set()
    edges: list[Edge] = []
    labels: list[int] = []
    attachment_edge_ids: list[int] = []

    for piece, shared_points in enumerate(piece_points):
        cycle = [("V", piece, index) for index in range(4)]
        nodes.update(cycle)
        for index in range(4):
            edges.append(canonical_edge(cycle[index], cycle[(index + 1) % 4]))
            labels.append(piece)
        for point in sorted(shared_points):
            shared: PointNode = ("S", point)
            nodes.add(shared)
            edges.append(canonical_edge(cycle[0], shared))
            labels.append(piece)
            attachment_edge_ids.append(len(edges) - 1)

    bridges = graph_bridges(nodes, edges)
    if any(edge_id not in bridges for edge_id in attachment_edge_ids):
        raise AssertionError("a piece bridge failed to remain a bridge")

    # After all bridges are removed, every edge-containing component must use
    # edges from a single piece.  In this synthetic family, this checks cycle
    # localization independently of the running-order search.
    adjacency: dict[Node, list[tuple[Node, int]]] = {node: [] for node in nodes}
    for edge_id, (left, right) in enumerate(edges):
        if edge_id in bridges:
            continue
        adjacency[left].append((right, edge_id))
        adjacency[right].append((left, edge_id))

    seen: set[Node] = set()
    for start in sorted(nodes):
        if start in seen:
            continue
        queue = deque([start])
        seen.add(start)
        component_labels: set[int] = set()
        while queue:
            node = queue.popleft()
            for neighbor, edge_id in adjacency[node]:
                component_labels.add(labels[edge_id])
                if neighbor not in seen:
                    seen.add(neighbor)
                    queue.append(neighbor)
        if len(component_labels) > 1:
            raise AssertionError("a synthetic cycle component uses several pieces")


def verify_cyclic_negative_control(length: int) -> None:
    piece_points = [
        {(piece - 1) % length, piece}
        for piece in range(length)
    ]
    point_pieces = [
        {point, (point + 1) % length}
        for point in range(length)
    ]
    if is_forest(piece_points, length):
        raise AssertionError("cycle control incorrectly classified as a forest")
    if find_running_order(piece_points, point_pieces) is not None:
        raise AssertionError("cycle control unexpectedly has a running-intersection order")


def parameter_ranges() -> Iterable[tuple[int, int]]:
    for pieces in range(1, 5):
        for points in range(0, 5):
            yield pieces, points
    for points in range(0, 4):
        yield 5, points


def main() -> None:
    if not __debug__:
        raise RuntimeError("verification must not be run with python -O")

    raw = 0
    admissible_count = 0
    forest_count = 0
    cyclic_count = 0
    synthetic_assemblies = 0

    for piece_count, point_count in parameter_ranges():
        for mask in range(1 << (piece_count * point_count)):
            raw += 1
            piece_points, point_pieces = incidence_data(piece_count, point_count, mask)
            if not admissible(piece_points, point_pieces):
                continue
            admissible_count += 1
            forest = is_forest(piece_points, point_count)
            order = find_running_order(piece_points, point_pieces)
            if forest != (order is not None):
                raise AssertionError(
                    {
                        "pieces": piece_count,
                        "points": point_count,
                        "mask": mask,
                        "forest": forest,
                        "order": order,
                    }
                )
            if forest:
                forest_count += 1
                rooted_order = rooted_forest_order(piece_points, point_count)
                if not check_order(rooted_order, piece_points, point_pieces):
                    raise AssertionError("the rooted forest order failed")
                verify_synthetic_assembly(piece_points)
                synthetic_assemblies += 1
            else:
                cyclic_count += 1

    for length in (3, 4, 5, 6):
        verify_cyclic_negative_control(length)

    result = {
        "raw_bipartite_incidence_graphs": raw,
        "admissible_piece_point_graphs": admissible_count,
        "forest_cases": forest_count,
        "cyclic_cases": cyclic_count,
        "forest_running_order_equivalence": "PASS",
        "rooted_order_construction": "PASS",
        "synthetic_bridge_and_cycle_assemblies": synthetic_assemblies,
        "cyclic_negative_controls": 4,
    }
    print("Erdos 593 forest-assembly master lemma: PASS")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
