#!/usr/bin/env python3
"""Finite experiments for a uniform obligatory-hypergraph conjecture.

The experiment represents every connected linear r-uniform incidence type with
m labelled hyperedges by its shared vertices. A shared vertex is recorded by
the subset of hyperedges containing it. Linearity is equivalent to requiring
that no pair of hyperedges occurs in two shared subsets. Remaining incidences
are filled with private degree-one vertices.

For each incidence type satisfying the candidate intrinsic condition, the
script asks whether a recursive recognizer decomposes it at point articulation
vertices into r-uniform expansions J^(r) of finite bipartite graphs. The
intrinsic condition is:

  * every hyperedge-node has at least r-2 incident Levi bridges; and
  * every Berge cycle has even length.

The elementary forward implication (generated class implies the intrinsic
condition) is not the computational bottleneck and is not re-tested here.

For r=3 this is a finite sanity check of the known classification. For r>=4 it
is experimental evidence only; it does not prove obligatoriness or the proposed
classification.

No third-party Python packages are required.
"""

from __future__ import annotations

import argparse
import collections
import functools
import itertools
import json
import math
import random
import sys
import time
from pathlib import Path
from typing import Dict, FrozenSet, Iterator, List, Mapping, Sequence, Set, Tuple

Edge = FrozenSet[int]
Family = Tuple[FrozenSet[int], ...]
Node = Tuple[str, int]
Adjacency = Dict[Node, Set[Node]]


def incidence_adjacency(edges: Sequence[Edge]) -> Adjacency:
    adj: Adjacency = {}

    def add_node(node: Node) -> None:
        adj.setdefault(node, set())

    def add_edge(u: Node, v: Node) -> None:
        add_node(u)
        add_node(v)
        adj[u].add(v)
        adj[v].add(u)

    for edge_index, edge in enumerate(edges):
        edge_node = ("e", edge_index)
        add_node(edge_node)
        for vertex in edge:
            add_edge(edge_node, ("v", vertex))
    return adj


def connected_components(adj: Mapping[Node, Set[Node]]) -> List[Set[Node]]:
    unseen = set(adj)
    components: List[Set[Node]] = []
    while unseen:
        start = next(iter(unseen))
        stack = [start]
        unseen.remove(start)
        component = {start}
        while stack:
            node = stack.pop()
            for neighbour in adj[node]:
                if neighbour in unseen:
                    unseen.remove(neighbour)
                    component.add(neighbour)
                    stack.append(neighbour)
        components.append(component)
    return components


def tarjan_bridges_and_articulations(
    adj: Mapping[Node, Set[Node]],
) -> Tuple[Set[FrozenSet[Node]], Set[Node]]:
    """Return undirected bridges and articulation vertices."""
    timer = 0
    discovery: Dict[Node, int] = {}
    low: Dict[Node, int] = {}
    parent: Dict[Node, Node | None] = {}
    bridges: Set[FrozenSet[Node]] = set()
    articulations: Set[Node] = set()

    def dfs(node: Node) -> None:
        nonlocal timer
        discovery[node] = low[node] = timer
        timer += 1
        child_count = 0
        for neighbour in adj[node]:
            if neighbour not in discovery:
                parent[neighbour] = node
                child_count += 1
                dfs(neighbour)
                low[node] = min(low[node], low[neighbour])
                if low[neighbour] > discovery[node]:
                    bridges.add(frozenset((node, neighbour)))
                if parent[node] is None and child_count > 1:
                    articulations.add(node)
                if parent[node] is not None and low[neighbour] >= discovery[node]:
                    articulations.add(node)
            elif neighbour != parent[node]:
                low[node] = min(low[node], discovery[neighbour])

    for root in adj:
        if root not in discovery:
            parent[root] = None
            dfs(root)
    return bridges, articulations


def is_linear(edges: Sequence[Edge]) -> bool:
    return all(
        len(left.intersection(right)) <= 1
        for left, right in itertools.combinations(edges, 2)
    )


def bridge_counts(edges: Sequence[Edge]) -> List[int]:
    adj = incidence_adjacency(edges)
    bridges, _ = tarjan_bridges_and_articulations(adj)
    result: List[int] = []
    for edge_index, edge in enumerate(edges):
        edge_node = ("e", edge_index)
        result.append(
            sum(
                frozenset((edge_node, ("v", vertex))) in bridges
                for vertex in edge
            )
        )
    return result


def has_odd_berge_cycle(edges: Sequence[Edge]) -> bool:
    """Detect an odd Berge cycle by enumerating cycles on hyperedge labels.

    For a linear hypergraph, each intersecting pair of hyperedges has a unique
    shared point. A cycle of hyperedge labels is a Berge cycle exactly when all
    consecutive intersections exist and those shared points are distinct.
    """
    edge_count = len(edges)
    shared: Dict[Tuple[int, int], int] = {}
    for left in range(edge_count):
        for right in range(left + 1, edge_count):
            intersection = edges[left].intersection(edges[right])
            if len(intersection) > 1:
                return True
            if intersection:
                shared[(left, right)] = next(iter(intersection))

    for length in range(3, edge_count + 1, 2):
        for subset in itertools.combinations(range(edge_count), length):
            first = min(subset)
            remaining = tuple(vertex for vertex in subset if vertex != first)
            for permutation in itertools.permutations(remaining):
                cycle = (first,) + permutation
                if cycle[1] > cycle[-1]:
                    continue
                shared_points: List[int] = []
                valid = True
                for left, right in zip(cycle, cycle[1:] + cycle[:1]):
                    key = (left, right) if left < right else (right, left)
                    point = shared.get(key)
                    if point is None:
                        valid = False
                        break
                    shared_points.append(point)
                if valid and len(set(shared_points)) == length:
                    return True
    return False


def is_bipartite_graph(pairs: Sequence[Tuple[int, int]]) -> bool:
    adjacency: Dict[int, Set[int]] = collections.defaultdict(set)
    for left, right in pairs:
        if left == right:
            return False
        adjacency[left].add(right)
        adjacency[right].add(left)
    colour: Dict[int, int] = {}
    for start in adjacency:
        if start in colour:
            continue
        colour[start] = 0
        queue = collections.deque([start])
        while queue:
            vertex = queue.popleft()
            for neighbour in adjacency[vertex]:
                expected = 1 - colour[vertex]
                if neighbour in colour:
                    if colour[neighbour] != expected:
                        return False
                else:
                    colour[neighbour] = expected
                    queue.append(neighbour)
    return True


def is_expansion_atom(edges: Sequence[Edge], uniformity: int) -> bool:
    """Check whether the hypergraph is J^(r) for some finite bipartite J."""
    degree: collections.Counter[int] = collections.Counter(
        vertex for edge in edges for vertex in edge
    )
    candidate_pairs: List[List[Tuple[int, int]]] = []
    for edge in edges:
        mandatory = {vertex for vertex in edge if degree[vertex] > 1}
        if len(mandatory) > 2:
            return False
        candidates = [
            tuple(pair)
            for pair in itertools.combinations(sorted(edge), 2)
            if mandatory.issubset(pair)
        ]
        if not candidates:
            return False
        candidate_pairs.append(candidates)

    for choices in itertools.product(*candidate_pairs):
        normalised = [tuple(sorted(pair)) for pair in choices]
        if len(set(normalised)) != len(normalised):
            continue
        if is_bipartite_graph(normalised):
            return True
    return False


def remove_node(adj: Mapping[Node, Set[Node]], node: Node) -> Adjacency:
    reduced: Adjacency = {}
    for current, neighbours in adj.items():
        if current == node:
            continue
        reduced[current] = {neighbour for neighbour in neighbours if neighbour != node}
    return reduced


def canonical_key(edges: Sequence[Edge]) -> Tuple[Tuple[int, ...], ...]:
    return tuple(sorted(tuple(sorted(edge)) for edge in edges))


@functools.lru_cache(maxsize=None)
def generated_class(
    key: Tuple[Tuple[int, ...], ...], uniformity: int
) -> bool:
    edges = tuple(frozenset(edge) for edge in key)
    if not edges:
        return True

    adj = incidence_adjacency(edges)
    components = connected_components(adj)
    if len(components) > 1:
        for component in components:
            indices = sorted(node[1] for node in component if node[0] == "e")
            if indices and not generated_class(
                canonical_key(tuple(edges[index] for index in indices)), uniformity
            ):
                return False
        return True

    if is_expansion_atom(edges, uniformity):
        return True

    _, articulations = tarjan_bridges_and_articulations(adj)
    for articulation in articulations:
        if articulation[0] != "v":
            continue
        reduced = remove_node(adj, articulation)
        groups: List[Tuple[Edge, ...]] = []
        for component in connected_components(reduced):
            indices = sorted(node[1] for node in component if node[0] == "e")
            if indices:
                groups.append(tuple(edges[index] for index in indices))
        if len(groups) >= 2 and all(
            generated_class(canonical_key(group), uniformity) for group in groups
        ):
            return True
    return False


def in_generated_class(edges: Sequence[Edge], uniformity: int) -> bool:
    return generated_class(canonical_key(edges), uniformity)


def intrinsic_candidate(edges: Sequence[Edge], uniformity: int) -> bool:
    return (
        is_linear(edges)
        and min(bridge_counts(edges), default=uniformity) >= uniformity - 2
        and not has_odd_berge_cycle(edges)
    )


def shared_families(edge_count: int, uniformity: int) -> Iterator[Family]:
    """Generate all labelled linear shared-vertex incidence types."""
    subsets = [
        frozenset(subset)
        for size in range(2, edge_count + 1)
        for subset in itertools.combinations(range(edge_count), size)
    ]
    subsets.sort(key=lambda subset: (-len(subset), tuple(subset)))

    def recurse(
        index: int,
        family: List[FrozenSet[int]],
        used_pairs: Set[Tuple[int, int]],
        incidence_degrees: List[int],
    ) -> Iterator[Family]:
        if index == len(subsets):
            yield tuple(family)
            return

        yield from recurse(index + 1, family, used_pairs, incidence_degrees)

        subset = subsets[index]
        pairs = {
            tuple(sorted(pair)) for pair in itertools.combinations(subset, 2)
        }
        if pairs.intersection(used_pairs):
            return
        if any(incidence_degrees[edge] >= uniformity for edge in subset):
            return
        next_degrees = incidence_degrees.copy()
        for edge in subset:
            next_degrees[edge] += 1
        family.append(subset)
        yield from recurse(index + 1, family, used_pairs.union(pairs), next_degrees)
        family.pop()

    yield from recurse(0, [], set(), [0] * edge_count)


def family_is_connected(edge_count: int, family: Family) -> bool:
    if edge_count == 1:
        return True
    adjacency = {edge: set() for edge in range(edge_count)}
    for subset in family:
        for left, right in itertools.combinations(subset, 2):
            adjacency[left].add(right)
            adjacency[right].add(left)
    unseen = set(range(edge_count))
    stack = [unseen.pop()]
    while stack:
        edge = stack.pop()
        for neighbour in adjacency[edge]:
            if neighbour in unseen:
                unseen.remove(neighbour)
                stack.append(neighbour)
    return not unseen


def realise_family(edge_count: int, uniformity: int, family: Family) -> Tuple[Edge, ...]:
    incidences: List[List[int]] = [[] for _ in range(edge_count)]
    next_vertex = 0
    for subset in family:
        for edge in subset:
            incidences[edge].append(next_vertex)
        next_vertex += 1
    for edge in range(edge_count):
        missing = uniformity - len(incidences[edge])
        if missing < 0:
            raise ValueError("shared family exceeds the uniformity")
        for _ in range(missing):
            incidences[edge].append(next_vertex)
            next_vertex += 1
    return tuple(frozenset(vertices) for vertices in incidences)


def predicted_connected_orders(uniformity: int, edge_count: int) -> List[int]:
    lower = (uniformity - 2) * edge_count + math.ceil(2 * math.sqrt(edge_count))
    upper = (uniformity - 1) * edge_count + 1
    return list(range(lower, upper + 1))


def run_exhaustive(uniformity: int, max_edges: int) -> List[dict]:
    records: List[dict] = []
    for edge_count in range(1, max_edges + 1):
        counts: collections.Counter[str] = collections.Counter()
        observed_orders: Set[int] = set()
        for family in shared_families(edge_count, uniformity):
            counts["families"] += 1
            if not family_is_connected(edge_count, family):
                continue
            counts["connected"] += 1
            edges = realise_family(edge_count, uniformity, family)
            intrinsic = intrinsic_candidate(edges, uniformity)
            if not intrinsic:
                continue
            counts["intrinsic"] += 1
            generated = in_generated_class(edges, uniformity)
            if not generated:
                raise AssertionError(
                    "intrinsic candidate not recognized by generated class: "
                    f"r={uniformity}, m={edge_count}, family="
                    f"{[sorted(subset) for subset in family]}, "
                    f"bridges={bridge_counts(edges)}"
                )
            counts["recognized"] += 1
            observed_orders.add(len(set().union(*edges)))
        predicted = predicted_connected_orders(uniformity, edge_count)
        if sorted(observed_orders) != predicted:
            raise AssertionError(
                f"order-spectrum mismatch: r={uniformity}, m={edge_count}, "
                f"observed={sorted(observed_orders)}, predicted={predicted}"
            )
        records.append(
            {
                "uniformity": uniformity,
                "edge_count": edge_count,
                **dict(counts),
                "observed_connected_orders": sorted(observed_orders),
                "predicted_connected_orders": predicted,
            }
        )
    return records


def random_family(
    edge_count: int, uniformity: int, rng: random.Random
) -> Family:
    permutation = list(range(edge_count))
    rng.shuffle(permutation)
    family: List[FrozenSet[int]] = []
    used_pairs: Set[Tuple[int, int]] = set()
    degrees = [0] * edge_count

    for index in range(1, edge_count):
        left = permutation[index - 1]
        right = permutation[index]
        family.append(frozenset((left, right)))
        used_pairs.add(tuple(sorted((left, right))))
        degrees[left] += 1
        degrees[right] += 1

    for _ in range(3 * edge_count):
        if rng.random() < 0.45:
            continue
        size = rng.randint(2, min(4, edge_count))
        eligible = [edge for edge in range(edge_count) if degrees[edge] < uniformity]
        if len(eligible) < size:
            continue
        subset = frozenset(rng.sample(eligible, size))
        pairs = {
            tuple(sorted(pair)) for pair in itertools.combinations(subset, 2)
        }
        if pairs.intersection(used_pairs):
            continue
        family.append(subset)
        used_pairs.update(pairs)
        for edge in subset:
            degrees[edge] += 1
    return tuple(family)


def run_random(
    uniformity: int,
    min_edges: int,
    max_edges: int,
    trials: int,
    seed: int,
) -> List[dict]:
    rng = random.Random(seed + uniformity)
    records: List[dict] = []
    for edge_count in range(min_edges, max_edges + 1):
        counts: collections.Counter[str] = collections.Counter()
        for _ in range(trials):
            family = random_family(edge_count, uniformity, rng)
            edges = realise_family(edge_count, uniformity, family)
            counts["samples"] += 1
            intrinsic = intrinsic_candidate(edges, uniformity)
            if not intrinsic:
                continue
            counts["intrinsic"] += 1
            generated = in_generated_class(edges, uniformity)
            if not generated:
                raise AssertionError(
                    "random intrinsic candidate not recognized: "
                    f"r={uniformity}, m={edge_count}, family="
                    f"{[sorted(subset) for subset in family]}, "
                    f"bridges={bridge_counts(edges)}"
                )
            counts["recognized"] += 1
        records.append(
            {
                "uniformity": uniformity,
                "edge_count": edge_count,
                **dict(counts),
            }
        )
    return records


def parse_uniformities(value: str) -> List[int]:
    result = sorted({int(part) for part in value.split(",") if part.strip()})
    if not result or any(uniformity < 3 for uniformity in result):
        raise argparse.ArgumentTypeError("uniformities must be comma-separated integers >= 3")
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--uniformities", type=parse_uniformities, default=[3, 4, 5])
    parser.add_argument("--max-edges", type=int, default=5)
    parser.add_argument("--random-min-edges", type=int, default=7)
    parser.add_argument("--random-max-edges", type=int, default=10)
    parser.add_argument("--random-trials", type=int, default=500)
    parser.add_argument("--seed", type=int, default=593)
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--check",
        type=Path,
        help="compare the generated result with an existing JSON file, ignoring timing",
    )
    args = parser.parse_args()

    started = time.time()
    exhaustive: List[dict] = []
    random_records: List[dict] = []
    for uniformity in args.uniformities:
        exhaustive.extend(run_exhaustive(uniformity, args.max_edges))
        if args.random_trials > 0:
            random_records.extend(
                run_random(
                    uniformity,
                    args.random_min_edges,
                    args.random_max_edges,
                    args.random_trials,
                    args.seed,
                )
            )

    output = {
        "status": "passed",
        "interpretation": (
            "Finite evidence only. Every tested candidate satisfying the intrinsic "
            "condition was recognized by the recursively generated expansion class."
        ),
        "configuration": {
            "uniformities": args.uniformities,
            "max_edges": args.max_edges,
            "random_min_edges": args.random_min_edges,
            "random_max_edges": args.random_max_edges,
            "random_trials_per_size": args.random_trials,
            "seed": args.seed,
        },
        "exhaustive": exhaustive,
        "random": random_records,
        "elapsed_seconds": round(time.time() - started, 3),
    }

    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        comparable_output = dict(output)
        comparable_expected = dict(expected)
        comparable_output.pop("elapsed_seconds", None)
        comparable_expected.pop("elapsed_seconds", None)
        if comparable_output != comparable_expected:
            sys.stderr.write(
                "generated experiment result differs from " + str(args.check) + "\n"
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
