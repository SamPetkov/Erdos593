#!/usr/bin/env python3
"""Finite audit of reconstruction and isomorphism-equivariance for atom forests.

The script deliberately reuses the repository's independent canonical atom extractor.
It generates deterministic forest assemblies from single triples and the expansions
C4^+, C6^+, K_{2,3}^+, recovers the canonical atom partition, and then repeats the
recovery after an arbitrary point relabelling.
"""

from __future__ import annotations

import argparse
import json
import random
from pathlib import Path

from verify_canonical_atom_normal_form import canonical_atoms, linear


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


def build_assembly(rng, atom_count):
    kinds = ["single", "C4", "C6", "K23"]
    triples = []
    atom_vertices = []
    expected_parts = []

    for i in range(atom_count):
        kind = rng.choice(kinds)
        atom = single_atom(i) if kind == "single" else expansion_atom(i, kind)
        expected_parts.append(frozenset(range(len(triples), len(triples) + len(atom))))
        triples.extend(atom)
        atom_vertices.append(set().union(*atom))

    representative = {v: v for vertices in atom_vertices for v in vertices}
    used = [set() for _ in range(atom_count)]
    intended = {}
    shared_counter = 0

    def free_vertices(a):
        return [v for v in atom_vertices[a] if v not in used[a]]

    for child in range(1, atom_count):
        parents = [a for a in range(child) if free_vertices(a)]
        if not parents:
            break
        parent = rng.choice(parents)
        child_choices = free_vertices(child)
        if not child_choices:
            continue
        vc = rng.choice(child_choices)

        reusable = [p for p, inc in intended.items() if parent in inc]
        if reusable and rng.random() < 0.35:
            p = rng.choice(reusable)
            representative[vc] = p
            used[child].add(vc)
            intended[p].add(child)
        else:
            parent_choices = free_vertices(parent)
            if not parent_choices:
                continue
            vp = rng.choice(parent_choices)
            p = ("shared", shared_counter)
            shared_counter += 1
            representative[vp] = p
            representative[vc] = p
            used[parent].add(vp)
            used[child].add(vc)
            intended[p] = {parent, child}

    glued = [frozenset(representative[v] for v in triple) for triple in triples]
    points = set().union(*glued) if glued else set()
    assert linear(glued)
    intended_by_parts = {
        p: frozenset(expected_parts[a] for a in incident)
        for p, incident in intended.items()
    }
    return points, glued, set(expected_parts), intended_by_parts


def recover(points, triples):
    atoms = canonical_atoms(points, triples)
    parts = {frozenset(atom["edge_ids"]) for atom in atoms}
    shared = {}
    for p in points:
        incident = frozenset(
            frozenset(atom["edge_ids"])
            for atom in atoms
            if p in atom["vertices"]
        )
        if len(incident) >= 2:
            shared[p] = incident
    return parts, shared


def relabel(points, triples, rng):
    ordered = sorted(points, key=repr)
    labels = list(range(len(ordered)))
    rng.shuffle(labels)
    phi = dict(zip(ordered, labels))
    return (
        set(labels),
        [frozenset(phi[v] for v in triple) for triple in triples],
        phi,
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--assemblies", type=int, default=2000)
    parser.add_argument("--seed", type=int, default=593)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    rng = random.Random(args.seed)
    totals = {
        "assemblies": args.assemblies,
        "seed": args.seed,
        "atoms": 0,
        "hyperedges": 0,
        "shared_points": 0,
        "relabel_equivariance_checks": 0,
        "max_atom_count": 0,
        "max_shared_multiplicity": 0,
    }

    for _ in range(args.assemblies):
        k = rng.randint(1, 9)
        points, triples, expected_parts, intended = build_assembly(rng, k)
        parts, shared = recover(points, triples)
        assert parts == expected_parts
        assert shared == intended

        points2, triples2, phi = relabel(points, triples, rng)
        parts2, shared2 = recover(points2, triples2)
        assert parts2 == expected_parts
        assert shared2 == {phi[p]: inc for p, inc in shared.items()}

        totals["atoms"] += len(parts)
        totals["hyperedges"] += len(triples)
        totals["shared_points"] += len(shared)
        totals["relabel_equivariance_checks"] += 1
        totals["max_atom_count"] = max(totals["max_atom_count"], len(parts))
        totals["max_shared_multiplicity"] = max(
            totals["max_shared_multiplicity"],
            max((len(inc) for inc in shared.values()), default=0),
        )

    totals["status"] = "PASS"
    text = json.dumps(totals, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
