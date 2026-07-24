#!/usr/bin/env python3
"""Independent bridge-block certificates for finite uniform hypergraphs.

The primary experiment in ``uniformity_conjecture.py`` recognises the generated
class recursively by articulation points. This module implements a different
recogniser: delete all Levi bridges at once, suppress degree-two hyperedge
nodes, certify bipartite core graphs, and verify that the resulting expansion
pieces meet through an attachment forest.

The accompanying mathematical note proves that, for fixed uniformity ``r``,
this certificate is equivalent to membership in the generated class ``B_r``.
No third-party packages are required.
"""

from __future__ import annotations

import argparse
import collections
import importlib
import itertools
import json
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import DefaultDict, Dict, FrozenSet, Iterable, List, Mapping, Sequence, Set, Tuple

Edge = FrozenSet[int]
Node = Tuple[str, int]
Bridge = FrozenSet[Node]


@dataclass(frozen=True)
class PieceCertificate:
    piece_id: int
    kind: str
    hyperedges: Tuple[int, ...]
    core_edges: Tuple[Tuple[int, int], ...]
    bipartition_zero: Tuple[int, ...]
    bipartition_one: Tuple[int, ...]
    attachment_vertices: Tuple[int, ...]


@dataclass(frozen=True)
class StructureCertificate:
    uniformity: int
    vertex_count: int
    edge_count: int
    component_count: int
    levi_bridge_count: int
    pieces: Tuple[PieceCertificate, ...]
    attachment_edges: Tuple[Tuple[int, int], ...]
    levi_cycle_rank: int
    core_cycle_rank: int


def normalize_edges(raw_edges: Iterable[Iterable[int]]) -> Tuple[Edge, ...]:
    edges = tuple(frozenset(int(vertex) for vertex in edge) for edge in raw_edges)
    if len(set(edges)) != len(edges):
        raise ValueError("hyperedges must be distinct")
    return edges


def vertices_of(edges: Sequence[Edge]) -> Set[int]:
    return set().union(*edges) if edges else set()


def incidence_graph(edges: Sequence[Edge]) -> Dict[Node, Set[Node]]:
    adjacency: Dict[Node, Set[Node]] = {}
    for edge_index, edge in enumerate(edges):
        edge_node = ("e", edge_index)
        adjacency.setdefault(edge_node, set())
        for vertex in edge:
            vertex_node = ("v", vertex)
            adjacency.setdefault(vertex_node, set())
            adjacency[edge_node].add(vertex_node)
            adjacency[vertex_node].add(edge_node)
    return adjacency


def graph_components(adjacency: Mapping[Node, Set[Node]]) -> List[Set[Node]]:
    unseen = set(adjacency)
    result: List[Set[Node]] = []
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


def tarjan_bridges(adjacency: Mapping[Node, Set[Node]]) -> Set[Bridge]:
    timer = 0
    discovery: Dict[Node, int] = {}
    low: Dict[Node, int] = {}
    parent: Dict[Node, Node | None] = {}
    bridges: Set[Bridge] = set()

    def visit(node: Node) -> None:
        nonlocal timer
        discovery[node] = low[node] = timer
        timer += 1
        for neighbour in adjacency[node]:
            if neighbour not in discovery:
                parent[neighbour] = node
                visit(neighbour)
                low[node] = min(low[node], low[neighbour])
                if low[neighbour] > discovery[node]:
                    bridges.add(frozenset((node, neighbour)))
            elif neighbour != parent[node]:
                low[node] = min(low[node], discovery[neighbour])

    for root in adjacency:
        if root not in discovery:
            parent[root] = None
            visit(root)
    return bridges


def without_bridges(
    adjacency: Mapping[Node, Set[Node]], bridges: Set[Bridge]
) -> Dict[Node, Set[Node]]:
    return {
        node: {
            neighbour
            for neighbour in neighbours
            if frozenset((node, neighbour)) not in bridges
        }
        for node, neighbours in adjacency.items()
    }


def check_linearity(edges: Sequence[Edge]) -> Tuple[bool, str | None]:
    seen_pairs: Dict[Tuple[int, int], int] = {}
    for edge_index, edge in enumerate(edges):
        for pair in itertools.combinations(sorted(edge), 2):
            previous = seen_pairs.get(pair)
            if previous is not None:
                return False, f"hyperedges {previous} and {edge_index} share pair {pair}"
            seen_pairs[pair] = edge_index
    return True, None


def bipartition(
    pairs: Sequence[Tuple[int, int]],
) -> Tuple[bool, Tuple[int, ...], Tuple[int, ...]]:
    adjacency: DefaultDict[int, Set[int]] = collections.defaultdict(set)
    for left, right in pairs:
        if left == right:
            return False, (), ()
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
                old = colour.get(neighbour)
                if old is None:
                    colour[neighbour] = expected
                    queue.append(neighbour)
                elif old != expected:
                    return False, (), ()
    zero = tuple(sorted(vertex for vertex, value in colour.items() if value == 0))
    one = tuple(sorted(vertex for vertex, value in colour.items() if value == 1))
    return True, zero, one


class DisjointSet:
    def __init__(self) -> None:
        self.parent: Dict[Tuple[str, int], Tuple[str, int]] = {}
        self.rank: Dict[Tuple[str, int], int] = {}

    def find(self, item: Tuple[str, int]) -> Tuple[str, int]:
        if item not in self.parent:
            self.parent[item] = item
            self.rank[item] = 0
            return item
        if self.parent[item] != item:
            self.parent[item] = self.find(self.parent[item])
        return self.parent[item]

    def union(self, left: Tuple[str, int], right: Tuple[str, int]) -> bool:
        left_root = self.find(left)
        right_root = self.find(right)
        if left_root == right_root:
            return False
        if self.rank[left_root] < self.rank[right_root]:
            left_root, right_root = right_root, left_root
        self.parent[right_root] = left_root
        if self.rank[left_root] == self.rank[right_root]:
            self.rank[left_root] += 1
        return True


def certify_structure(
    raw_edges: Iterable[Iterable[int]], uniformity: int
) -> Tuple[StructureCertificate | None, str | None]:
    edges = normalize_edges(raw_edges)
    if uniformity < 2:
        return None, "uniformity must be at least two"
    if any(len(edge) != uniformity for edge in edges):
        return None, "not every hyperedge has the requested uniformity"
    if not edges:
        return (
            StructureCertificate(
                uniformity=uniformity,
                vertex_count=0,
                edge_count=0,
                component_count=0,
                levi_bridge_count=0,
                pieces=(),
                attachment_edges=(),
                levi_cycle_rank=0,
                core_cycle_rank=0,
            ),
            None,
        )

    linear, reason = check_linearity(edges)
    if not linear:
        return None, reason

    adjacency = incidence_graph(edges)
    bridges = tarjan_bridges(adjacency)
    reduced = without_bridges(adjacency, bridges)
    reduced_components = graph_components(reduced)
    component_of: Dict[Node, int] = {}
    for component_index, component in enumerate(reduced_components):
        for node in component:
            component_of[node] = component_index

    nonbridge_neighbours: Dict[int, Tuple[int, ...]] = {}
    active_by_component: DefaultDict[int, List[int]] = collections.defaultdict(list)
    zero_nonbridge_edges: List[int] = []

    for edge_index in range(len(edges)):
        edge_node = ("e", edge_index)
        remaining = tuple(
            sorted(node[1] for node in reduced[edge_node] if node[0] == "v")
        )
        if len(remaining) > 2:
            return (
                None,
                f"hyperedge {edge_index} has only {uniformity-len(remaining)} "
                f"incident bridges, fewer than {uniformity-2}",
            )
        if len(remaining) == 1:
            return (
                None,
                f"hyperedge {edge_index} has exactly one nonbridge incidence; "
                "a nonbridge cycle incidence must have a partner at the edge-node",
            )
        nonbridge_neighbours[edge_index] = remaining
        if remaining:
            active_by_component[component_of[edge_node]].append(edge_index)
        else:
            zero_nonbridge_edges.append(edge_index)

    piece_data: List[dict] = []

    for component_index in sorted(active_by_component):
        edge_indices = tuple(sorted(active_by_component[component_index]))
        core_pairs: List[Tuple[int, int]] = []
        pair_owner: Dict[Tuple[int, int], int] = {}
        for edge_index in edge_indices:
            pair = tuple(sorted(nonbridge_neighbours[edge_index]))
            assert len(pair) == 2
            if pair in pair_owner:
                return (
                    None,
                    f"active block has parallel core edges from hyperedges "
                    f"{pair_owner[pair]} and {edge_index}",
                )
            pair_owner[pair] = edge_index
            core_pairs.append(pair)

        is_bipartite, zero, one = bipartition(core_pairs)
        if not is_bipartite:
            return None, f"active bridge block {component_index} has an odd core cycle"

        private_owner: Dict[int, int] = {}
        for edge_index in edge_indices:
            core = set(nonbridge_neighbours[edge_index])
            for vertex in edges[edge_index] - core:
                previous = private_owner.get(vertex)
                if previous is not None:
                    return (
                        None,
                        f"vertex {vertex} is a deleted-incidence neighbour of both "
                        f"hyperedges {previous} and {edge_index} in one block",
                    )
                private_owner[vertex] = edge_index

        piece_data.append(
            {
                "kind": "bipartite_expansion",
                "hyperedges": edge_indices,
                "core_edges": tuple(sorted(core_pairs)),
                "zero": zero,
                "one": one,
            }
        )

    for edge_index in zero_nonbridge_edges:
        vertices = sorted(edges[edge_index])
        core_pair = (vertices[0], vertices[1])
        piece_data.append(
            {
                "kind": "one_edge_expansion",
                "hyperedges": (edge_index,),
                "core_edges": (core_pair,),
                "zero": (core_pair[0],),
                "one": (core_pair[1],),
            }
        )

    piece_data.sort(key=lambda data: data["hyperedges"])
    piece_vertices: List[Set[int]] = [
        set().union(*(edges[index] for index in data["hyperedges"]))
        for data in piece_data
    ]

    vertex_to_pieces: DefaultDict[int, List[int]] = collections.defaultdict(list)
    for piece_id, vertices in enumerate(piece_vertices):
        for vertex in vertices:
            vertex_to_pieces[vertex].append(piece_id)

    pair_shared: DefaultDict[Tuple[int, int], List[int]] = collections.defaultdict(list)
    for vertex, piece_ids in vertex_to_pieces.items():
        for left, right in itertools.combinations(sorted(piece_ids), 2):
            pair_shared[(left, right)].append(vertex)
    for pair, shared_vertices in pair_shared.items():
        if len(shared_vertices) > 1:
            return (
                None,
                f"pieces {pair[0]} and {pair[1]} share more than one point: "
                f"{sorted(shared_vertices)}",
            )

    attachment_edges: List[Tuple[int, int]] = []
    dsu = DisjointSet()
    for vertex, piece_ids in sorted(vertex_to_pieces.items()):
        if len(piece_ids) < 2:
            continue
        point_node = ("v", vertex)
        for piece_id in sorted(piece_ids):
            piece_node = ("p", piece_id)
            if not dsu.union(piece_node, point_node):
                return None, "the piece/attachment incidence graph contains a cycle"
            attachment_edges.append((piece_id, vertex))

    piece_certificates: List[PieceCertificate] = []
    for piece_id, data in enumerate(piece_data):
        attachments = tuple(
            sorted(
                vertex
                for vertex in piece_vertices[piece_id]
                if len(vertex_to_pieces[vertex]) >= 2
            )
        )
        piece_certificates.append(
            PieceCertificate(
                piece_id=piece_id,
                kind=data["kind"],
                hyperedges=data["hyperedges"],
                core_edges=data["core_edges"],
                bipartition_zero=data["zero"],
                bipartition_one=data["one"],
                attachment_vertices=attachments,
            )
        )

    component_count = len(graph_components(adjacency))
    vertex_count = len(vertices_of(edges))
    edge_count = len(edges)
    levi_cycle_rank = uniformity * edge_count - (vertex_count + edge_count) + component_count

    core_vertex_count = 0
    core_edge_count = 0
    core_component_count = 0
    for piece in piece_certificates:
        vertices = {vertex for pair in piece.core_edges for vertex in pair}
        core_vertex_count += len(vertices)
        core_edge_count += len(piece.core_edges)
        core_component_count += 1
    core_cycle_rank = core_edge_count - core_vertex_count + core_component_count

    if levi_cycle_rank != core_cycle_rank:
        return None, f"cycle-rank mismatch: Levi={levi_cycle_rank}, core={core_cycle_rank}"

    return (
        StructureCertificate(
            uniformity=uniformity,
            vertex_count=vertex_count,
            edge_count=edge_count,
            component_count=component_count,
            levi_bridge_count=len(bridges),
            pieces=tuple(piece_certificates),
            attachment_edges=tuple(attachment_edges),
            levi_cycle_rank=levi_cycle_rank,
            core_cycle_rank=core_cycle_rank,
        ),
        None,
    )


def fixture_suite() -> List[Tuple[str, int, Tuple[Edge, ...], bool]]:
    fixtures: List[Tuple[str, int, Tuple[Edge, ...], bool]] = []

    for uniformity in (3, 4, 5):
        next_vertex = 4
        edges: List[Edge] = []
        for left in (0, 1):
            for right in (2, 3):
                private = list(range(next_vertex, next_vertex + uniformity - 2))
                next_vertex += uniformity - 2
                edges.append(frozenset((left, right, *private)))
        fixtures.append((f"K22 expansion r={uniformity}", uniformity, tuple(edges), True))

    fixtures.append(
        (
            "private-point amalgamation r=4",
            4,
            (
                frozenset((0, 1, 2, 3)),
                frozenset((2, 4, 5, 6)),
            ),
            True,
        )
    )
    fixtures.append(
        (
            "odd cycle r=4",
            4,
            (
                frozenset((0, 1, 3, 4)),
                frozenset((1, 2, 5, 6)),
                frozenset((0, 2, 7, 8)),
            ),
            False,
        )
    )
    fixtures.append(
        (
            "nonlinear r=4",
            4,
            (
                frozenset((0, 1, 2, 3)),
                frozenset((0, 1, 4, 5)),
            ),
            False,
        )
    )
    return fixtures


def run_fixtures() -> dict:
    records = []
    for name, uniformity, edges, expected in fixture_suite():
        certificate, reason = certify_structure(edges, uniformity)
        accepted = certificate is not None
        if accepted != expected:
            raise AssertionError(
                f"fixture {name!r}: expected accepted={expected}, got {accepted}; "
                f"reason={reason}"
            )
        records.append(
            {
                "name": name,
                "uniformity": uniformity,
                "accepted": accepted,
                "reason": reason,
                "piece_count": len(certificate.pieces) if certificate else None,
            }
        )
    return {"fixtures": records}


def cross_check(uniformities: Sequence[int], max_edges: int) -> dict:
    base = importlib.import_module("uniformity_conjecture")
    records = []
    totals = collections.Counter()
    for uniformity in uniformities:
        for edge_count in range(1, max_edges + 1):
            counts = collections.Counter()
            for family in base.shared_families(edge_count, uniformity):
                counts["families"] += 1
                if not base.family_is_connected(edge_count, family):
                    continue
                counts["connected"] += 1
                edges = base.realise_family(edge_count, uniformity, family)
                intrinsic = base.intrinsic_candidate(edges, uniformity)
                recursive = base.in_generated_class(edges, uniformity)
                certificate, reason = certify_structure(edges, uniformity)
                direct = certificate is not None
                if not (intrinsic == recursive == direct):
                    raise AssertionError(
                        "recognizer disagreement: "
                        f"r={uniformity}, m={edge_count}, "
                        f"intrinsic={intrinsic}, recursive={recursive}, direct={direct}, "
                        f"reason={reason}, family={[sorted(item) for item in family]}"
                    )
                if intrinsic:
                    counts["accepted"] += 1
                    assert certificate is not None
                    expected_rank = (
                        (uniformity - 1) * edge_count
                        - len(set().union(*edges))
                        + 1
                    )
                    if certificate.levi_cycle_rank != expected_rank:
                        raise AssertionError("cycle-rank formula disagreement")
            records.append(
                {
                    "uniformity": uniformity,
                    "edge_count": edge_count,
                    **dict(counts),
                }
            )
            totals.update(counts)
    return {"records": records, "totals": dict(totals)}


def parse_uniformities(value: str) -> List[int]:
    result = sorted({int(part) for part in value.split(",") if part.strip()})
    if not result or any(uniformity < 2 for uniformity in result):
        raise argparse.ArgumentTypeError("uniformities must be integers >= 2")
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--uniformities", type=parse_uniformities, default=[3, 4, 5])
    parser.add_argument("--max-edges", type=int, default=6)
    parser.add_argument("--cross-check", action="store_true")
    parser.add_argument("--input", type=Path, help="JSON file with uniformity and edges")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    if args.input:
        raw = json.loads(args.input.read_text(encoding="utf-8"))
        certificate, reason = certify_structure(raw["edges"], int(raw["uniformity"]))
        result = {
            "accepted": certificate is not None,
            "reason": reason,
            "certificate": asdict(certificate) if certificate else None,
        }
    else:
        result = run_fixtures()
        if args.cross_check:
            result["cross_check"] = cross_check(args.uniformities, args.max_edges)

    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
