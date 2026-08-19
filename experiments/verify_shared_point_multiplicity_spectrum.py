#!/usr/bin/env python3
"""Finite audit for canonical-atom shared-point multiplicity spectra."""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from itertools import combinations
import json
from math import ceil, factorial
from pathlib import Path

from verify_canonical_atom_normal_form import (
    DisjointSet,
    bridge_ids,
    canonical_atoms,
    components,
    connected,
    graph_expansion,
    normalized_partition,
)


def partitions(n: int, cap: int | None = None):
    if n == 0:
        yield ()
        return
    bound = n if cap is None else min(n, cap)
    for first in range(bound, 0, -1):
        for tail in partitions(n - first, first):
            yield (first, *tail)


def compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(1, total - length + 2):
        for tail in compositions(total - first, length - 1):
            yield (first, *tail)


def partition_number(n: int) -> int:
    ways = [1] + [0] * n
    for part in range(1, n + 1):
        for value in range(part, n + 1):
            ways[value] += ways[value - part]
    return ways[n]


def multinomial(total: int, parts) -> int:
    answer = factorial(total)
    for part in parts:
        answer //= factorial(part)
    return answer


def degree_tree_count(left, right) -> int:
    return multinomial(len(right) - 1, [d - 1 for d in left]) * multinomial(
        len(left) - 1, [d - 1 for d in right]
    )


def profile_tree_count(k: int, profile) -> int:
    multiplicities = Counter(profile)
    assignments = factorial(len(profile))
    for count in multiplicities.values():
        assignments //= factorial(count)
    return assignments * (k ** (len(profile) - 1)) * multinomial(k - 1, profile)


def exhaustive_trees(k: int, t: int):
    vertices = {
        *(('L', i) for i in range(k)),
        *(('R', j) for j in range(t)),
    }
    possible = [(i, j) for i in range(k) for j in range(t)]
    for chosen in combinations(possible, k + t - 1):
        edges = [(('L', i), ('R', j)) for i, j in chosen]
        if connected(vertices, edges):
            yield chosen


def construct_tree(left_degrees, right_degrees):
    left = dict(enumerate(left_degrees))
    right = dict(enumerate(right_degrees))
    if sum(left.values()) != sum(right.values()) or sum(left.values()) != len(left) + len(right) - 1:
        raise ValueError("not bipartite tree degree sequences")
    edges = []
    while len(left) + len(right) > 2:
        left_leaf = next((i for i in sorted(left) if left[i] == 1), None)
        right_nonleaf = next((j for j in sorted(right) if right[j] > 1), None)
        if left_leaf is not None and right_nonleaf is not None:
            edges.append((left_leaf, right_nonleaf))
            del left[left_leaf]
            right[right_nonleaf] -= 1
            continue
        right_leaf = next((j for j in sorted(right) if right[j] == 1), None)
        left_nonleaf = next((i for i in sorted(left) if left[i] > 1), None)
        if right_leaf is None or left_nonleaf is None:
            raise AssertionError("leaf induction stuck")
        edges.append((left_nonleaf, right_leaf))
        del right[right_leaf]
        left[left_nonleaf] -= 1
    edges.append((next(iter(left)), next(iter(right))))
    return edges


def cycle_atom(length: int):
    return graph_expansion(
        range(length), [(i, (i + 1) % length) for i in range(length)]
    )


def single_atom():
    return {0, 1, 2}, [frozenset({0, 1, 2})]


def k23_atom():
    return graph_expansion(range(5), [(i, j) for i in (0, 1) for j in (2, 3, 4)])


def assemble(templates, incidence, shared_count):
    atom_points = []
    atom_triples = []
    expected = []
    all_points = []
    offset = 0
    for atom_id, (points, triples) in enumerate(templates):
        relabel = {point: (atom_id, point) for point in points}
        local_points = {relabel[p] for p in points}
        local_triples = [frozenset(relabel[p] for p in triple) for triple in triples]
        atom_points.append(sorted(local_points, key=repr))
        atom_triples.append(local_triples)
        all_points.extend(local_points)
        expected.append(frozenset(range(offset, offset + len(local_triples))))
        offset += len(local_triples)

    by_atom = defaultdict(list)
    by_point = defaultdict(list)
    for atom_id, point_id in incidence:
        by_atom[atom_id].append(point_id)
        by_point[point_id].append(atom_id)

    dsu = DisjointSet(all_points)
    chosen = {}
    for atom_id in range(len(templates)):
        point_ids = sorted(by_atom[atom_id])
        if len(point_ids) > len(atom_points[atom_id]):
            raise AssertionError("atom capacity exceeded")
        for point_id, vertex in zip(point_ids, atom_points[atom_id]):
            chosen[(atom_id, point_id)] = vertex

    representatives = {}
    for point_id in range(shared_count):
        atoms = sorted(by_point[point_id])
        if len(atoms) < 2:
            raise AssertionError("shared point degree below two")
        first = chosen[(atoms[0], point_id)]
        for atom_id in atoms[1:]:
            dsu.union(first, chosen[(atom_id, point_id)])
        representatives[point_id] = dsu.find(first)

    triples = []
    for local_triples in atom_triples:
        for triple in local_triples:
            image = frozenset(dsu.find(point) for point in triple)
            if len(image) != 3:
                raise AssertionError("one atom collapsed internally")
            triples.append(image)
    points = set().union(*triples)

    recovered = canonical_atoms(points, triples)
    if normalized_partition(atom["edge_ids"] for atom in recovered) != normalized_partition(expected):
        raise AssertionError("canonical atom partition changed")

    recovered_by_edges = {atom["edge_ids"]: atom for atom in recovered}
    atom_vertices = [recovered_by_edges[edge_set]["vertices"] for edge_set in expected]
    shared = {point_id: dsu.find(rep) for point_id, rep in representatives.items()}
    mu = [sum(shared[j] in vertices for vertices in atom_vertices) for j in range(shared_count)]
    shared_vertices = set(shared.values())
    d = [len(vertices & shared_vertices) for vertices in atom_vertices]

    graph_vertices = {
        *(('atom', i) for i in range(len(templates))),
        *(('point', j) for j in range(shared_count)),
    }
    graph_edges = [(('atom', i), ('point', j)) for i, j in incidence]
    if bridge_ids(graph_vertices, graph_edges) != set(range(len(graph_edges))):
        raise AssertionError("incidence graph is not a forest")
    return d, mu, len(components(graph_vertices, graph_edges))


def chain_incidence(profile, c: int):
    atom_count = sum(profile) + c
    if not profile:
        return atom_count, [], 0
    frontier = c - 1
    next_atom = c
    edges = []
    for point_id, part in enumerate(profile):
        children = list(range(next_atom, next_atom + part))
        next_atom += part
        edges.append((frontier, point_id))
        edges.extend((child, point_id) for child in children)
        frontier = children[0]
    return atom_count, edges, len(profile)


def run_audit():
    partition_checks = pair_checks = 0
    for n in range(25):
        current = list(partitions(n))
        if len(current) != partition_number(n):
            raise AssertionError(f"partition count mismatch at {n}")
        partition_checks += len(current)
        if n:
            for t in range(1, n + 1):
                observed = {max(p) for p in current if len(p) == t}
                expected = set(range(ceil(n / t), n - t + 2))
                if observed != expected:
                    raise AssertionError(f"(t,M) spectrum mismatch at {n},{t}")
                pair_checks += 1

    exhaustive_count = degree_checks = profile_checks = 0
    for k in range(1, 5):
        for t in range(1, 5):
            by_degree = Counter()
            by_profile = Counter()
            total = 0
            for edges in exhaustive_trees(k, t):
                left = [0] * k
                right = [0] * t
                for i, j in edges:
                    left[i] += 1
                    right[j] += 1
                by_degree[(tuple(left), tuple(right))] += 1
                if min(right) >= 2:
                    by_profile[tuple(sorted((x - 1 for x in right), reverse=True))] += 1
                total += 1
            if total != (k ** (t - 1)) * (t ** (k - 1)):
                raise AssertionError("bipartite Cayley count mismatch")
            exhaustive_count += total
            edge_count = k + t - 1
            for left in compositions(edge_count, k):
                for right in compositions(edge_count, t):
                    if by_degree[(left, right)] != degree_tree_count(left, right):
                        raise AssertionError("Prüfer degree count mismatch")
                    degree_checks += 1
            for profile in partitions(k - 1):
                if len(profile) == t:
                    if by_profile[profile] != profile_tree_count(k, profile):
                        raise AssertionError("profile tree count mismatch")
                    profile_checks += 1

    degree_realizations = 0
    c4 = cycle_atom(4)
    for k in range(2, 6):
        for t in range(1, min(4, k - 1) + 1):
            edge_count = k + t - 1
            right_sequences = [x for x in compositions(edge_count, t) if min(x) >= 2]
            for left in compositions(edge_count, k):
                for right in right_sequences:
                    incidence = construct_tree(left, right)
                    d, mu, c = assemble([c4] * k, incidence, t)
                    if tuple(d) != left or tuple(mu) != right or c != 1:
                        raise AssertionError("degree realization mismatch")
                    degree_realizations += 1

    profile_realizations = 0
    templates = [single_atom(), cycle_atom(4), cycle_atom(6), k23_atom()]
    for n in range(11):
        for profile in partitions(n):
            for requested_c in range(1, 5):
                k, incidence, t = chain_incidence(profile, requested_c)
                d, mu, actual_c = assemble(
                    [templates[i % len(templates)] for i in range(k)], incidence, t
                )
                recovered = tuple(sorted((x - 1 for x in mu), reverse=True))
                if recovered != profile or actual_c != requested_c:
                    raise AssertionError("profile realization mismatch")
                if sum(x - 1 for x in mu) != k - requested_c or max(d, default=0) > 2:
                    raise AssertionError("forest excess or capacity invariant failed")
                profile_realizations += 1

    return {
        "degree_formula_checks": degree_checks,
        "degree_sequence_realizations": degree_realizations,
        "exhaustive_labelled_bipartite_trees": exhaustive_count,
        "fixed_length_maximum_spectra": pair_checks,
        "integer_partitions_checked": partition_checks,
        "profile_formula_checks": profile_checks,
        "profile_realizations": profile_realizations,
        "status": "PASS",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    rendered = json.dumps(run_audit(), indent=2, sort_keys=True) + "\n"
    if args.output is None:
        print("Erdos 593 shared-point multiplicity audit")
        print(rendered, end="")
    else:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")


if __name__ == "__main__":
    main()
