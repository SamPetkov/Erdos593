#!/usr/bin/env python3
"""Exact finite audit for the canonical atom normal form in Erdős 593.

The verifier uses only the Python standard library. It checks three claims.

1. For every nonempty simple labelled graph on at most six vertices, the
   canonical Levi-block atoms of its private-vertex expansion agree exactly
   with the graph's biconnected edge blocks (bridges are singleton atoms).
2. Such an expansion satisfies the even-cycle part of the intrinsic test
   exactly when the source graph is bipartite.
3. For every connected bipartite graph in the same range, its expansion is
   indecomposable under nontrivial one-point amalgamation exactly when the
   graph is K_2 or is 2-connected.

It also checks 2,000 deterministic forest assemblies, including attachments at
core points and private points, and verifies that the original irreducible atom
partition is recovered canonically.
"""

from __future__ import annotations

from collections import defaultdict
from itertools import combinations
import argparse
import json
from pathlib import Path
import random


def adjacency(vertices, edges):
    out = {v: set() for v in vertices}
    for u, v in edges:
        if u == v:
            raise AssertionError("loops are not allowed")
        out.setdefault(u, set()).add(v)
        out.setdefault(v, set()).add(u)
    return out


def components(vertices, edges, removed=None):
    kept = {v for v in vertices if v != removed}
    kept_edges = [(u, v) for u, v in edges if u != removed and v != removed]
    adj = adjacency(kept, kept_edges)
    seen = set()
    result = []
    for start in adj:
        if start in seen:
            continue
        stack = [start]
        seen.add(start)
        comp = set()
        while stack:
            u = stack.pop()
            comp.add(u)
            for v in adj[u]:
                if v not in seen:
                    seen.add(v)
                    stack.append(v)
        result.append(comp)
    return result


def connected(vertices, edges):
    vertices = set(vertices)
    return not vertices or len(components(vertices, edges)) == 1


def bipartite(vertices, edges):
    adj = adjacency(vertices, edges)
    color = {}
    for start in adj:
        if start in color:
            continue
        color[start] = 0
        stack = [start]
        while stack:
            u = stack.pop()
            for v in adj[u]:
                if v in color:
                    if color[v] == color[u]:
                        return False
                else:
                    color[v] = 1 - color[u]
                    stack.append(v)
    return True


def bridge_ids(vertices, edges):
    adj = {v: [] for v in vertices}
    for edge_id, (u, v) in enumerate(edges):
        adj.setdefault(u, []).append((v, edge_id))
        adj.setdefault(v, []).append((u, edge_id))

    entered = {}
    low = {}
    timer = 0
    answer = set()

    def dfs(u, parent_edge=-1):
        nonlocal timer
        entered[u] = low[u] = timer
        timer += 1
        for v, edge_id in adj[u]:
            if edge_id == parent_edge:
                continue
            if v in entered:
                low[u] = min(low[u], entered[v])
            else:
                dfs(v, edge_id)
                low[u] = min(low[u], low[v])
                if low[v] > entered[u]:
                    answer.add(edge_id)

    for vertex in adj:
        if vertex not in entered:
            dfs(vertex)
    return answer


def biconnected_edge_components(vertices, edges):
    """Tarjan edge blocks; bridges occur as singleton components."""
    adj = {v: [] for v in vertices}
    for edge_id, (u, v) in enumerate(edges):
        adj.setdefault(u, []).append((v, edge_id))
        adj.setdefault(v, []).append((u, edge_id))

    entered = {}
    low = {}
    stack = []
    result = []
    timer = 0

    def dfs(u, parent_edge=-1):
        nonlocal timer
        entered[u] = low[u] = timer
        timer += 1
        for v, edge_id in adj[u]:
            if edge_id == parent_edge:
                continue
            if v not in entered:
                stack.append(edge_id)
                dfs(v, edge_id)
                low[u] = min(low[u], low[v])
                if low[v] >= entered[u]:
                    comp = set()
                    while stack:
                        current = stack.pop()
                        comp.add(current)
                        if current == edge_id:
                            break
                    result.append(comp)
            elif entered[v] < entered[u]:
                stack.append(edge_id)
                low[u] = min(low[u], entered[v])

    for start in adj:
        if start not in entered:
            dfs(start)
            if stack:
                result.append(set(stack))
                stack.clear()
    return result


def two_connected(vertices, edges):
    vertices = set(vertices)
    if len(vertices) < 3 or not connected(vertices, edges):
        return False
    return all(len(components(vertices - {v}, edges, removed=v)) <= 1 for v in vertices)


def graph_expansion(vertices, edges):
    triples = []
    for edge_id, (u, v) in enumerate(edges):
        triples.append(
            frozenset({("core", u), ("core", v), ("private", edge_id)})
        )
    points = set().union(*triples) if triples else set()
    return points, triples


def linear(triples):
    return all(
        len(triples[i] & triples[j]) <= 1
        for i, j in combinations(range(len(triples)), 2)
    )


def levi_graph(points, triples):
    vertices = {("point", p) for p in points}
    edges = []
    for edge_id, triple in enumerate(triples):
        edge_node = ("hyperedge", edge_id)
        vertices.add(edge_node)
        for point in triple:
            edges.append((edge_node, ("point", point)))
    return vertices, edges


def is_forest(vertices, edges):
    return bridge_ids(set(vertices), edges) == set(range(len(edges)))


def canonical_atoms(points, triples):
    if not linear(triples):
        raise AssertionError("the canonical atom theorem assumes linearity")

    levi_vertices, levi_edges = levi_graph(points, triples)
    levi_bridges = bridge_ids(levi_vertices, levi_edges)
    nonbridge_degree = [0] * len(triples)

    for edge_id in range(len(triples)):
        node = ("hyperedge", edge_id)
        incidences = [i for i, edge in enumerate(levi_edges) if node in edge]
        bridge_count = sum(i in levi_bridges for i in incidences)
        if bridge_count == 0:
            raise AssertionError("a hyperedge-node has no incident bridge")
        nonbridge_degree[edge_id] = 3 - bridge_count
        if nonbridge_degree[edge_id] not in (0, 2):
            raise AssertionError("residual hyperedge degree is not zero or two")

    atoms = []
    assigned = set()
    for block in biconnected_edge_components(levi_vertices, levi_edges):
        if len(block) == 1:
            continue
        block_vertices = set()
        for incidence_id in block:
            block_vertices.update(levi_edges[incidence_id])
        edge_nodes = sorted(
            (v for v in block_vertices if v[0] == "hyperedge"), key=repr
        )
        if not edge_nodes:
            continue

        core_vertices = set()
        core_edges = []
        atom_edge_ids = set()
        for edge_node in edge_nodes:
            incident = [i for i in block if edge_node in levi_edges[i]]
            if len(incident) != 2:
                raise AssertionError("cyclic-block hyperedge degree is not two")
            endpoints = []
            for incidence_id in incident:
                u, v = levi_edges[incidence_id]
                point_node = v if u == edge_node else u
                if point_node[0] != "point":
                    raise AssertionError("Levi bipartition failure")
                endpoints.append(point_node[1])
            if endpoints[0] == endpoints[1]:
                raise AssertionError("suppression produced a loop")
            core_vertices.update(endpoints)
            core_edges.append(tuple(endpoints))
            atom_edge_ids.add(edge_node[1])

        if len({frozenset(edge) for edge in core_edges}) != len(core_edges):
            raise AssertionError("suppression produced parallel edges")
        if not two_connected(core_vertices, core_edges):
            raise AssertionError(
                "a cyclic Levi block did not suppress to a 2-connected core"
            )
        if assigned & atom_edge_ids:
            raise AssertionError("a hyperedge belongs to two cyclic atoms")
        assigned.update(atom_edge_ids)
        atoms.append(
            {
                "kind": "cyclic",
                "edge_ids": frozenset(atom_edge_ids),
                "vertices": frozenset().union(*(triples[i] for i in atom_edge_ids)),
                "core_bipartite": bipartite(core_vertices, core_edges),
            }
        )

    for edge_id, degree in enumerate(nonbridge_degree):
        if degree == 2 and edge_id not in assigned:
            raise AssertionError("an active hyperedge is missing from the cyclic blocks")
        if degree == 0:
            if edge_id in assigned:
                raise AssertionError("an all-bridge hyperedge entered a cyclic block")
            atoms.append(
                {
                    "kind": "single",
                    "edge_ids": frozenset({edge_id}),
                    "vertices": frozenset(triples[edge_id]),
                    "core_bipartite": True,
                }
            )
            assigned.add(edge_id)

    if assigned != set(range(len(triples))):
        raise AssertionError("the atoms do not partition the hyperedges")

    for i, j in combinations(range(len(atoms)), 2):
        if len(atoms[i]["vertices"] & atoms[j]["vertices"]) > 1:
            raise AssertionError("two atoms meet in more than one point")

    shared = {
        p
        for p in points
        if sum(p in atom["vertices"] for atom in atoms) >= 2
    }
    incidence_vertices = {("atom", i) for i in range(len(atoms))}
    incidence_vertices.update(("shared", p) for p in shared)
    incidence_edges = [
        (("atom", i), ("shared", p))
        for i, atom in enumerate(atoms)
        for p in shared
        if p in atom["vertices"]
    ]
    if not is_forest(incidence_vertices, incidence_edges):
        raise AssertionError("the atom-point incidence graph is not a forest")

    return atoms


def one_point_indecomposable(points, triples):
    if not triples:
        return False
    levi_vertices, levi_edges = levi_graph(points, triples)
    edge_nodes = {("hyperedge", i) for i in range(len(triples))}
    edge_components = [
        comp & edge_nodes
        for comp in components(levi_vertices, levi_edges)
        if comp & edge_nodes
    ]
    if len(edge_components) != 1:
        return False

    for point in points:
        removed = ("point", point)
        remaining_vertices = levi_vertices - {removed}
        remaining_edges = [
            (u, v) for u, v in levi_edges if u != removed and v != removed
        ]
        edge_components = [
            comp & edge_nodes
            for comp in components(remaining_vertices, remaining_edges)
            if comp & edge_nodes
        ]
        if len(edge_components) >= 2:
            return False
    return True


def labelled_graphs(n):
    possible = list(combinations(range(n), 2))
    for mask in range(1, 1 << len(possible)):
        yield [
            possible[i]
            for i in range(len(possible))
            if (mask >> i) & 1
        ]


def normalized_partition(parts):
    return sorted(
        (tuple(sorted(part)) for part in parts),
        key=lambda part: (len(part), part),
    )


class DisjointSet:
    def __init__(self, elements):
        self.parent = {x: x for x in elements}

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        x = self.find(x)
        y = self.find(y)
        if x != y:
            self.parent[y] = x


def atom_templates():
    templates = {"single": ({0, 1, 2}, [frozenset({0, 1, 2})])}
    graphs = {
        "C4": (4, [(0, 1), (1, 2), (2, 3), (3, 0)]),
        "C6": (6, [(0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 0)]),
        "K23": (5, [(i, j) for i in (0, 1) for j in (2, 3, 4)]),
    }
    for name, (n, edges) in graphs.items():
        templates[name] = graph_expansion(range(n), edges)
    return templates


def random_forest_assembly(rng, templates):
    atom_count = rng.randint(1, 8)
    names = [rng.choice(tuple(templates)) for _ in range(atom_count)]
    atom_triples = []
    expected = []
    all_points = []
    edge_offset = 0

    for atom_id, name in enumerate(names):
        points, triples = templates[name]
        relabel = {p: (atom_id, p) for p in points}
        current_points = {relabel[p] for p in points}
        current_triples = [
            frozenset(relabel[p] for p in triple) for triple in triples
        ]
        atom_triples.append(current_triples)
        all_points.extend(current_points)
        expected.append(
            frozenset(range(edge_offset, edge_offset + len(current_triples)))
        )
        edge_offset += len(current_triples)

    dsu = DisjointSet(all_points)
    for child in range(1, atom_count):
        parent = rng.randrange(child)
        parent_point = rng.choice(tuple(templates[names[parent]][0]))
        child_point = rng.choice(tuple(templates[names[child]][0]))
        dsu.union((parent, parent_point), (child, child_point))

    classes = defaultdict(list)
    for point in all_points:
        classes[dsu.find(point)].append(point)
    representative = {}
    for values in classes.values():
        rep = min(values, key=repr)
        for value in values:
            representative[value] = rep

    triples = []
    for current in atom_triples:
        for triple in current:
            relabelled = frozenset(representative[p] for p in triple)
            if len(relabelled) != 3:
                raise AssertionError("an assembly collapsed two points of one triple")
            triples.append(relabelled)
    points = set().union(*triples)
    return points, triples, expected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    graph_total = 0
    bipartite_total = 0
    nonbipartite_total = 0
    connected_bipartite_total = 0
    indecomposable_total = 0

    for n in range(2, 7):
        for graph_edges in labelled_graphs(n):
            graph_total += 1
            points, triples = graph_expansion(range(n), graph_edges)
            atoms = canonical_atoms(points, triples)

            graph_blocks = normalized_partition(
                biconnected_edge_components(set(range(n)), graph_edges)
            )
            atom_blocks = normalized_partition(atom["edge_ids"] for atom in atoms)
            if graph_blocks != atom_blocks:
                raise AssertionError(
                    f"atom partition mismatch for n={n}, edges={graph_edges}"
                )

            source_bipartite = bipartite(range(n), graph_edges)
            atom_bipartite = all(atom["core_bipartite"] for atom in atoms)
            if source_bipartite != atom_bipartite:
                raise AssertionError(
                    f"bipartite-core mismatch for n={n}, edges={graph_edges}"
                )
            if source_bipartite:
                bipartite_total += 1
            else:
                nonbipartite_total += 1

            used = {v for edge in graph_edges for v in edge}
            if source_bipartite and connected(used, graph_edges):
                connected_bipartite_total += 1
                actual = one_point_indecomposable(points, triples)
                expected = len(graph_edges) == 1 or two_connected(used, graph_edges)
                if actual != expected:
                    raise AssertionError(
                        "indecomposability mismatch for "
                        f"n={n}, edges={graph_edges}, actual={actual}, "
                        f"expected={expected}"
                    )
                indecomposable_total += int(actual)

    templates = atom_templates()
    rng = random.Random(593)
    assembly_total = 2_000
    for _ in range(assembly_total):
        points, triples, expected = random_forest_assembly(rng, templates)
        atoms = canonical_atoms(points, triples)
        actual_partition = normalized_partition(
            atom["edge_ids"] for atom in atoms
        )
        expected_partition = normalized_partition(expected)
        if actual_partition != expected_partition:
            raise AssertionError("forest assembly did not recover its atom partition")

    result = {
        "labelled_nonempty_graphs": graph_total,
        "bipartite_graphs": bipartite_total,
        "nonbipartite_graphs": nonbipartite_total,
        "connected_bipartite_graphs": connected_bipartite_total,
        "indecomposable_expansions": indecomposable_total,
        "deterministic_forest_assemblies": assembly_total,
        "status": "PASS",
    }
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output is not None:
        args.output.write_text(rendered, encoding="utf-8")
    else:
        print("Erdos 593 canonical atom normal-form audit")
        print(rendered, end="")


if __name__ == "__main__":
    main()
