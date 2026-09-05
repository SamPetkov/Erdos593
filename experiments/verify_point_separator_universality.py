#!/usr/bin/env python3
"""Exact finite audit for point separators and universal atom decompositions.

The checker deliberately reuses the repository's independent canonical atom
extractor, but implements point deletion, point-inseparability, decomposition
validation, the atom intersection graph, and exhaustive partition searches
separately.
"""

from __future__ import annotations

from collections import defaultdict
from itertools import combinations
import argparse
import json
import random
from pathlib import Path

from verify_canonical_atom_normal_form import canonical_atoms, linear


def ordered(xs):
    return sorted(xs, key=repr)


def single_atom(tag):
    return [frozenset((tag, "v", i) for i in range(3))]


def expansion_atom(tag, kind):
    if kind == "C4":
        edges = [(0, 1), (1, 2), (2, 3), (3, 0)]
    elif kind == "C6":
        edges = [(i, (i + 1) % 6) for i in range(6)]
    elif kind == "K23":
        edges = [(i, j) for i in (0, 1) for j in (2, 3, 4)]
    else:
        raise ValueError(kind)
    return [
        frozenset({(tag, "c", u), (tag, "c", v), (tag, "p", j)})
        for j, (u, v) in enumerate(edges)
    ]


def points_of(triples):
    return set().union(*triples) if triples else set()


def rename_point(triples, old, new):
    return [frozenset(new if p == old else p for p in e) for e in triples]


def sequential_assembly(kinds, seed):
    """Attach each new canonical atom at one existing point."""
    rng = random.Random(seed)
    triples = []
    expected = []
    for i, kind in enumerate(kinds):
        atom = single_atom(i) if kind == "single" else expansion_atom(i, kind)
        if triples:
            old = rng.choice(ordered(points_of(atom)))
            target = rng.choice(ordered(points_of(triples)))
            atom = rename_point(atom, old, target)
        start = len(triples)
        triples.extend(atom)
        expected.append(frozenset(range(start, len(triples))))
    assert linear(triples)
    return triples, sorted(expected, key=lambda A: (min(A), len(A)))


def levi_adjacency(triples, deleted_point=None):
    adj = defaultdict(set)
    for i, edge in enumerate(triples):
        en = ("edge", i)
        adj[en]
        for p in edge:
            if p == deleted_point:
                continue
            pn = ("point", p)
            adj[en].add(pn)
            adj[pn].add(en)
    return adj


def graph_components(adj):
    seen = set()
    out = []
    for start in ordered(adj):
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
        out.append(comp)
    return out


def edge_components(triples, deleted_point=None):
    out = []
    for comp in graph_components(levi_adjacency(triples, deleted_point)):
        edge_ids = {v[1] for v in comp if v[0] == "edge"}
        if edge_ids:
            out.append(edge_ids)
    return out


def separator_points(triples):
    base = len(edge_components(triples))
    return {
        p
        for p in points_of(triples)
        if len(edge_components(triples, p)) > base
    }


def recovered_atoms(triples):
    points = points_of(triples)
    return sorted(
        (frozenset(A["edge_ids"]) for A in canonical_atoms(points, triples)),
        key=lambda A: (min(A), len(A)),
    )


def atom_vertex_sets(triples, atoms):
    return [set().union(*(triples[i] for i in A)) for A in atoms]


def shared_points(triples, atoms):
    AV = atom_vertex_sets(triples, atoms)
    return {
        p
        for p in points_of(triples)
        if sum(p in V for V in AV) >= 2
    }


def point_inseparable_partition(triples):
    n = len(triples)
    base = edge_components(triples)
    base_id = {e: i for i, C in enumerate(base) for e in C}
    rel = [[base_id[i] == base_id[j] for j in range(n)] for i in range(n)]

    for p in ordered(points_of(triples)):
        after = edge_components(triples, p)
        idx = {e: i for i, C in enumerate(after) for e in C}
        for i in range(n):
            for j in range(i + 1, n):
                if rel[i][j] and idx[i] != idx[j]:
                    rel[i][j] = rel[j][i] = False

    # The theorem predicts transitivity; assert it independently here.
    for i, j, k in combinations(range(n), 3):
        if rel[i][j] and rel[j][k]:
            assert rel[i][k]
        if rel[i][k] and rel[k][j]:
            assert rel[i][j]
        if rel[j][i] and rel[i][k]:
            assert rel[j][k]

    seen = set()
    parts = []
    for i in range(n):
        if i in seen:
            continue
        part = frozenset(j for j in range(n) if rel[i][j])
        seen.update(part)
        parts.append(part)
    return sorted(parts, key=lambda A: (min(A), len(A)))


def atom_intersection_graph(triples, atoms):
    AV = atom_vertex_sets(triples, atoms)
    adj = {i: set() for i in range(len(atoms))}
    for i, j in combinations(range(len(atoms)), 2):
        meet = AV[i] & AV[j]
        assert len(meet) <= 1
        if meet:
            adj[i].add(j)
            adj[j].add(i)
    return adj


def induced_connected(adj, subset):
    X = set(subset)
    if not X:
        return False
    start = min(X)
    seen = {start}
    stack = [start]
    while stack:
        u = stack.pop()
        for v in adj[u] & X:
            if v not in seen:
                seen.add(v)
                stack.append(v)
    return seen == X


def piece_connected(triples, edge_ids):
    sub = [triples[i] for i in sorted(edge_ids)]
    return len(edge_components(sub)) == 1


def forest(adj):
    if not adj:
        return True
    edges = sum(len(N) for N in adj.values()) // 2
    comps = len(graph_components(adj))
    return edges == len(adj) - comps


def valid_one_point_decomposition(triples, parts):
    if any(not piece_connected(triples, P) for P in parts):
        return False
    PV = [set().union(*(triples[i] for i in P)) for P in parts]
    for i, j in combinations(range(len(parts)), 2):
        if len(PV[i] & PV[j]) > 1:
            return False

    S = {p for p in points_of(triples) if sum(p in V for V in PV) >= 2}
    adj = defaultdict(set)
    for i, V in enumerate(PV):
        pn = ("piece", i)
        adj[pn]
        for p in S:
            if p in V:
                sn = ("shared", p)
                adj[pn].add(sn)
                adj[sn].add(pn)
    return forest(adj)


def set_partitions(items):
    items = tuple(items)
    if not items:
        yield []
        return
    first = items[0]
    for rest in set_partitions(items[1:]):
        yield [{first}] + [set(B) for B in rest]
        for i in range(len(rest)):
            out = [set(B) for B in rest]
            out[i].add(first)
            yield out


def union_atom_parts(atoms, atom_partition):
    return [set().union(*(atoms[i] for i in X)) for X in atom_partition]


def block_graph_check(triples, atoms):
    """Every atom-intersection cycle must lie in one shared-point clique."""
    B = atom_intersection_graph(triples, atoms)
    AV = atom_vertex_sets(triples, atoms)
    shared_cliques = [
        {i for i, V in enumerate(AV) if p in V}
        for p in shared_points(triples, atoms)
    ]
    # Every graph edge belongs to exactly one shared clique.
    for i, j in combinations(range(len(atoms)), 2):
        containing = sum(i in C and j in C for C in shared_cliques)
        assert containing == (1 if j in B[i] else 0)

    # A direct DFS over small generated graphs: any simple cycle found must be
    # contained in some shared clique.
    def dfs(start, u, path, used):
        for v in B[u]:
            if v == start and len(path) >= 3:
                cycle = set(path)
                assert any(cycle <= C for C in shared_cliques)
            elif v > start and v not in used:
                used.add(v)
                dfs(start, v, path + [v], used)
                used.remove(v)

    for start in range(len(atoms)):
        dfs(start, start, [start], {start})


def run(random_assemblies):
    totals = {
        "random_assemblies": 0,
        "random_atoms": 0,
        "random_hyperedges": 0,
        "separator_checks": 0,
        "inseparability_checks": 0,
        "block_graph_checks": 0,
        "exhaustive_systems": 0,
        "exhaustive_edge_partitions": 0,
        "valid_one_point_decompositions": 0,
        "universal_refinement_checks": 0,
        "connected_atom_partitions": 0,
        "connected_partition_converse_checks": 0,
    }

    choices = ["single", "single", "C4", "C6", "K23"]
    for seed in range(random_assemblies):
        rng = random.Random(593000 + seed)
        kinds = [rng.choice(choices) for _ in range(rng.randint(1, 7))]
        triples, expected = sequential_assembly(kinds, 811000 + seed)
        atoms = recovered_atoms(triples)
        assert atoms == expected

        totals["random_assemblies"] += 1
        totals["random_atoms"] += len(atoms)
        totals["random_hyperedges"] += len(triples)

        assert separator_points(triples) == shared_points(triples, atoms)
        totals["separator_checks"] += len(points_of(triples))

        assert point_inseparable_partition(triples) == atoms
        totals["inseparability_checks"] += len(triples) * (len(triples) + 1) // 2

        block_graph_check(triples, atoms)
        totals["block_graph_checks"] += 1

    small_families = [
        ["single", "single"],
        ["single", "single", "single"],
        ["single", "single", "single", "single"],
        ["C4"],
        ["C4", "single"],
        ["C4", "single", "single"],
        ["C4", "single", "single", "single"],
    ]

    for kinds in small_families:
        for seed in range(8):
            triples, expected = sequential_assembly(kinds, 991000 + seed)
            if len(triples) > 7:
                continue
            atoms = recovered_atoms(triples)
            assert atoms == expected
            B = atom_intersection_graph(triples, atoms)
            totals["exhaustive_systems"] += 1

            for parts in set_partitions(range(len(triples))):
                totals["exhaustive_edge_partitions"] += 1
                if not valid_one_point_decomposition(triples, parts):
                    continue
                totals["valid_one_point_decompositions"] += 1
                atom_to_piece = {}
                for ai, A in enumerate(atoms):
                    containing = [pi for pi, P in enumerate(parts) if A <= P]
                    assert len(containing) == 1
                    atom_to_piece[ai] = containing[0]
                    totals["universal_refinement_checks"] += 1
                for pi in range(len(parts)):
                    X = {ai for ai, pj in atom_to_piece.items() if pj == pi}
                    assert X and induced_connected(B, X)

            for atom_partition in set_partitions(range(len(atoms))):
                if not all(induced_connected(B, X) for X in atom_partition):
                    continue
                totals["connected_atom_partitions"] += 1
                pieces = union_atom_parts(atoms, atom_partition)
                assert valid_one_point_decomposition(triples, pieces)
                totals["connected_partition_converse_checks"] += 1

    totals["status"] = "PASS"
    return totals


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--assemblies", type=int, default=5000)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    totals = run(args.assemblies)
    text = json.dumps(totals, indent=2, sort_keys=True) + "\n"
    if args.check:
        expected = json.loads(args.check.read_text())
        expected["status"] = "PASS"
        assert totals == expected
    if args.output:
        args.output.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
