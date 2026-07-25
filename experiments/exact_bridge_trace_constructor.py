#!/usr/bin/env python3
"""Constructive checks for the arbitrary-rank exact bridge-trace theorem.

The program generates random finite quotient trees with arbitrary edge
orientations. Every non-sink quotient node carries a connected linear
q-uniform derivative embedded in a fixed star hypergraph; every oriented tree
edge is a selected apex incidence. It then independently:

* verifies linearity and the selected-incidence bridge condition;
* deletes the selected incidences and recovers the expected components;
* constructs the labelled-forest words used in the sufficiency proof;
* builds the resulting embedding into a finite part of the one-apex lift; and
* verifies every lifted edge exactly.

This is finite validation only. It is not a proof of the transfinite theorem.
Only the Python standard library is used.
"""

from __future__ import annotations

import argparse
import collections
import json
import random
from pathlib import Path
from typing import Dict, FrozenSet, Hashable, Iterable, List, Mapping, Sequence, Set, Tuple

Vertex = Tuple[Hashable, ...]
Edge = FrozenSet[Vertex]
LeviNode = Tuple[str, Hashable]
DirectedEdge = Tuple[int, int, int]


def star_hypergraph(
    rank: int, edge_count: int
) -> Tuple[Tuple[int, ...], Tuple[FrozenSet[int], ...]]:
    if rank < 2 or edge_count < 1:
        raise ValueError("rank >= 2 and edge_count >= 1 are required")
    edges: List[FrozenSet[int]] = []
    next_leaf = 1
    for _ in range(edge_count):
        leaves = tuple(range(next_leaf, next_leaf + rank - 1))
        next_leaf += rank - 1
        edges.append(frozenset((0, *leaves)))
    return tuple(range(next_leaf)), tuple(edges)


def random_tree(node_count: int, rng: random.Random) -> List[Tuple[int, int]]:
    return [(node, rng.randrange(node)) for node in range(1, node_count)]


def orient_tree(
    tree_edges: Sequence[Tuple[int, int]], rng: random.Random
) -> List[Tuple[int, int]]:
    return [
        (left, right) if rng.randrange(2) else (right, left)
        for left, right in tree_edges
    ]


def labelled_tree_words(
    node_count: int, edges: Sequence[DirectedEdge]
) -> Dict[int, Tuple[int, ...]]:
    """Li's leaf-induction construction for an arbitrarily oriented tree."""
    if node_count < 1:
        return {}
    adjacency: Dict[int, Set[int]] = {node: set() for node in range(node_count)}
    edge_data: Dict[FrozenSet[int], DirectedEdge] = {}
    for source, target, label in edges:
        adjacency[source].add(target)
        adjacency[target].add(source)
        edge_data[frozenset((source, target))] = (source, target, label)

    def recurse(nodes: FrozenSet[int]) -> Dict[int, Tuple[int, ...]]:
        if len(nodes) == 1:
            return {next(iter(nodes)): ()}
        leaf = next(
            node for node in nodes if len(adjacency[node].intersection(nodes)) == 1
        )
        neighbour = next(iter(adjacency[leaf].intersection(nodes)))
        old = recurse(nodes - {leaf})
        source, target, label = edge_data[frozenset((leaf, neighbour))]
        if source == neighbour and target == leaf:
            maximum = max(map(len, old.values()), default=-1)
            base = old[neighbour] + (label,)
            padding = max(0, maximum + 1 - len(base))
            result = dict(old)
            result[leaf] = base + (0,) * padding
            return result
        if source == leaf and target == neighbour:
            return {
                leaf: (),
                **{node: (label,) + word for node, word in old.items()},
            }
        raise AssertionError("oriented edge does not match the leaf")

    words = recurse(frozenset(range(node_count)))
    if len(set(words.values())) != node_count:
        raise AssertionError("labelled-forest construction produced duplicate words")
    for source, target, label in edges:
        source_word = words[source]
        target_word = words[target]
        if not (
            len(source_word) < len(target_word)
            and target_word[: len(source_word)] == source_word
            and target_word[len(source_word)] == label
        ):
            raise AssertionError("labelled-forest edge condition failed")
    return words


def levi_adjacency(edges: Sequence[Edge]) -> Dict[LeviNode, Set[LeviNode]]:
    adjacency: Dict[LeviNode, Set[LeviNode]] = collections.defaultdict(set)
    for edge_index, edge in enumerate(edges):
        edge_node: LeviNode = ("e", edge_index)
        adjacency[edge_node]
        for vertex in edge:
            vertex_node: LeviNode = ("v", vertex)
            adjacency[edge_node].add(vertex_node)
            adjacency[vertex_node].add(edge_node)
    return dict(adjacency)


def tarjan_bridges(
    adjacency: Mapping[LeviNode, Set[LeviNode]]
) -> Set[FrozenSet[LeviNode]]:
    timer = 0
    discovery: Dict[LeviNode, int] = {}
    low: Dict[LeviNode, int] = {}
    parent: Dict[LeviNode, LeviNode | None] = {}
    result: Set[FrozenSet[LeviNode]] = set()

    def dfs(node: LeviNode) -> None:
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


def connected_components(
    adjacency: Mapping[LeviNode, Set[LeviNode]]
) -> List[Set[LeviNode]]:
    unseen = set(adjacency)
    result = []
    while unseen:
        start = unseen.pop()
        component = {start}
        stack = [start]
        while stack:
            node = stack.pop()
            for neighbour in adjacency[node]:
                if neighbour in unseen:
                    unseen.remove(neighbour)
                    component.add(neighbour)
                    stack.append(neighbour)
        result.append(component)
    return result


def delete_incidences(
    adjacency: Mapping[LeviNode, Set[LeviNode]],
    selected: Iterable[FrozenSet[LeviNode]],
) -> Dict[LeviNode, Set[LeviNode]]:
    selected = set(selected)
    return {
        node: {
            neighbour
            for neighbour in neighbours
            if frozenset((node, neighbour)) not in selected
        }
        for node, neighbours in adjacency.items()
    }


def is_linear(edges: Sequence[Edge]) -> bool:
    return all(
        len(left.intersection(right)) <= 1
        for index, left in enumerate(edges)
        for right in edges[index + 1 :]
    )


def build_certificate(rank: int, node_count: int, rng: random.Random) -> dict:
    tree = random_tree(node_count, rng)
    oriented = orient_tree(tree, rng)
    outgoing: Dict[int, List[int]] = collections.defaultdict(list)
    for edge_id, (source, _) in enumerate(oriented):
        outgoing[source].append(edge_id)

    maximum_outdegree = max((len(value) for value in outgoing.values()), default=1)
    _, base_edges = star_hypergraph(rank, max(1, maximum_outdegree))

    active = {node for node in range(node_count) if outgoing[node]}
    local_vertices: Dict[int, Dict[int, Vertex]] = {}
    for node in active:
        used_base_vertices = set().union(
            *(base_edges[index] for index in range(len(outgoing[node])))
        )
        local_vertices[node] = {
            coordinate: ("a", node, coordinate)
            for coordinate in used_base_vertices
        }

    def target_point(node: int) -> Vertex:
        if node in active:
            return local_vertices[node][0]
        return ("p", node)

    edges: List[Edge] = []
    selectors: List[Vertex] = []
    directed_labels: List[DirectedEdge] = []
    edge_sources: List[int] = []
    edge_targets: List[int] = []
    source_position: Dict[int, int] = collections.defaultdict(int)

    for source, target in oriented:
        label = source_position[source]
        source_position[source] += 1
        base = {
            local_vertices[source][coordinate]
            for coordinate in base_edges[label]
        }
        apex = target_point(target)
        edge = frozenset((*base, apex))
        if len(edge) != rank + 1:
            raise AssertionError("constructed edge has the wrong rank")
        edges.append(edge)
        selectors.append(apex)
        directed_labels.append((source, target, label))
        edge_sources.append(source)
        edge_targets.append(target)

    if not is_linear(edges):
        raise AssertionError("generated certificate source is not linear")

    adjacency = levi_adjacency(edges)
    bridge_set = tarjan_bridges(adjacency)
    selected_incidences: List[FrozenSet[LeviNode]] = []
    for edge_index, apex in enumerate(selectors):
        incidence = frozenset((("e", edge_index), ("v", apex)))
        if incidence not in bridge_set:
            raise AssertionError("selected apex incidence is not a bridge")
        selected_incidences.append(incidence)

    reduced = delete_incidences(adjacency, selected_incidences)
    components = connected_components(reduced)
    component_of: Dict[LeviNode, int] = {}
    for component_index, component in enumerate(components):
        for item in component:
            component_of[item] = component_index

    expected_component: Dict[int, int] = {}
    for node in range(node_count):
        if node in active:
            source_indices = [
                index
                for index, source in enumerate(edge_sources)
                if source == node
            ]
            component = component_of[("e", source_indices[0])]
            if any(
                component_of[("e", index)] != component
                for index in source_indices
            ):
                raise AssertionError("one derivative component split")
            if any(
                component_of[("v", vertex)] != component
                for vertex in local_vertices[node].values()
            ):
                raise AssertionError("a derivative point left its component")
            expected_component[node] = component
        else:
            expected_component[node] = component_of[("v", ("p", node))]

    if (
        len(components) != node_count
        or len(set(expected_component.values())) != node_count
    ):
        raise AssertionError("bridge deletion did not recover the components")

    quotient_pairs = set()
    for edge_index, (source, target, _) in enumerate(directed_labels):
        source_component = component_of[("e", edge_index)]
        target_component = component_of[("v", selectors[edge_index])]
        if source_component != expected_component[source]:
            raise AssertionError("source quotient component mismatch")
        if target_component != expected_component[target]:
            raise AssertionError("target quotient component mismatch")
        quotient_pairs.add(frozenset((source_component, target_component)))

    expected_pairs = {
        frozenset((expected_component[left], expected_component[right]))
        for left, right in tree
    }
    if quotient_pairs != expected_pairs:
        raise AssertionError("quotient does not recover the original tree")

    words = labelled_tree_words(node_count, directed_labels)

    vertex_component: Dict[Vertex, int] = {}
    for node in active:
        for vertex in local_vertices[node].values():
            vertex_component[vertex] = node
    for node in range(node_count):
        if node not in active:
            vertex_component[("p", node)] = node

    def second_coordinate(vertex: Vertex) -> int:
        if vertex[0] == "a":
            return int(vertex[2])
        return 0

    image: Dict[Vertex, Tuple[Tuple[int, ...], int]] = {
        vertex: (words[vertex_component[vertex]], second_coordinate(vertex))
        for edge in edges
        for vertex in edge
    }
    if len(set(image.values())) != len(image):
        raise AssertionError("constructed lift embedding is not injective")

    for edge_index, edge in enumerate(edges):
        source = edge_sources[edge_index]
        target = edge_targets[edge_index]
        label = directed_labels[edge_index][2]
        source_word = words[source]
        target_word = words[target]
        if not (
            len(source_word) < len(target_word)
            and target_word[: len(source_word)] == source_word
            and target_word[len(source_word)] == label
        ):
            raise AssertionError("word relation does not define a lift edge")
        expected = {
            (source_word, coordinate) for coordinate in base_edges[label]
        } | {(target_word, second_coordinate(selectors[edge_index]))}
        actual = {image[vertex] for vertex in edge}
        if actual != expected:
            raise AssertionError("source edge does not map to the lift")

    return {
        "rank_of_base": rank,
        "rank_of_lift": rank + 1,
        "components": node_count,
        "source_edges": len(edges),
        "active_components": len(active),
        "maximum_word_length": max(map(len, words.values()), default=0),
    }


def run(trials_per_rank: int, seed: int) -> dict:
    rng = random.Random(seed)
    summaries = []
    for rank in (2, 3, 4, 5):
        cases = [
            build_certificate(rank, rng.randint(2, 10), rng)
            for _ in range(trials_per_rank)
        ]
        summaries.append(
            {
                "rank_of_base": rank,
                "rank_of_lift": rank + 1,
                "cases": len(cases),
                "source_edges_checked": sum(
                    case["source_edges"] for case in cases
                ),
                "maximum_components": max(
                    case["components"] for case in cases
                ),
                "maximum_word_length": max(
                    case["maximum_word_length"] for case in cases
                ),
            }
        )
    return {
        "status": "passed",
        "seed": seed,
        "trials_per_rank": trials_per_rank,
        "total_certificates": 4 * trials_per_rank,
        "summaries": summaries,
        "interpretation": (
            "Finite constructive checks only. Every generated bridge-selector and "
            "derivative-embedding certificate produced an explicit injective lift embedding."
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--trials-per-rank", type=int, default=2000)
    parser.add_argument("--seed", type=int, default=593)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    result = run(args.trials_per_rank, args.seed)
    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if result != expected:
            raise SystemExit("generated result differs from checked result")
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
