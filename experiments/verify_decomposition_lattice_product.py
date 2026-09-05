#!/usr/bin/env python3
"""Exact audit of the local product theorem for decomposition lattices."""

from __future__ import annotations

from collections import Counter, defaultdict
from math import factorial, prod
import argparse
import json
from pathlib import Path

from verify_point_separator_universality import (
    atom_intersection_graph,
    induced_connected,
    recovered_atoms,
    sequential_assembly,
    set_partitions,
)


def stirling(n: int, k: int) -> int:
    table = [[0] * (n + 1) for _ in range(n + 1)]
    table[0][0] = 1
    for i in range(1, n + 1):
        for j in range(1, i + 1):
            table[i][j] = j * table[i - 1][j] + table[i - 1][j - 1]
    return table[n][k]


def bell(n: int) -> int:
    return sum(stirling(n, k) for k in range(n + 1))


def canon_partition(partition):
    return tuple(
        sorted(
            (frozenset(block) for block in partition),
            key=lambda block: (min(block), len(block), tuple(sorted(block))),
        )
    )


def refines(pi, sigma) -> bool:
    return all(any(block <= target for target in sigma) for block in pi)


def connected_partitions(adj):
    out = []
    for partition in set_partitions(range(len(adj))):
        if all(induced_connected(adj, block) for block in partition):
            out.append(canon_partition(partition))
    # The recursive set-partition generator is canonical, but deduplicate
    # defensively so this verifier does not depend on that implementation fact.
    return list(dict.fromkeys(out))


def component_count(adj) -> int:
    seen = set()
    total = 0
    for start in adj:
        if start in seen:
            continue
        total += 1
        seen.add(start)
        stack = [start]
        while stack:
            u = stack.pop()
            for v in adj[u]:
                if v not in seen:
                    seen.add(v)
                    stack.append(v)
    return total


def shared_multiplicities(triples, atoms):
    atom_vertices = []
    for atom in atoms:
        vertices = set()
        for edge_id in atom:
            vertices.update(triples[edge_id])
        atom_vertices.append(vertices)

    points = set().union(*atom_vertices) if atom_vertices else set()
    multiplicities = []
    for point in points:
        mu = sum(point in vertices for vertices in atom_vertices)
        if mu >= 2:
            multiplicities.append(mu)
    return sorted(multiplicities)


def predicted_decomposition_polynomial(c: int, mus):
    # z^c prod_p sum_{b=1}^{mu_p} S(mu_p,b) z^(b-1)
    poly = Counter({c: 1})
    for mu in mus:
        next_poly = Counter()
        for degree, coeff in poly.items():
            for b in range(1, mu + 1):
                next_poly[degree + b - 1] += coeff * stirling(mu, b)
        poly = next_poly
    return poly


def mobius_bottom_top(partitions) -> int:
    ordered = sorted(partitions, key=lambda pi: -len(pi))
    bottom = ordered[0]
    minimum_blocks = min(len(pi) for pi in ordered)
    tops = [pi for pi in ordered if len(pi) == minimum_blocks]
    assert len(tops) == 1
    top = tops[0]

    mu = {bottom: 1}
    for x in ordered[1:]:
        mu[x] = -sum(value for y, value in mu.items() if refines(y, x))
    return mu[top]


def maximal_chain_count(partitions) -> int:
    by_blocks = defaultdict(list)
    for pi in partitions:
        by_blocks[len(pi)].append(pi)
    maximum = max(by_blocks)
    minimum = min(by_blocks)
    assert len(by_blocks[maximum]) == 1
    assert len(by_blocks[minimum]) == 1

    dp = {by_blocks[maximum][0]: 1}
    for blocks in range(maximum, minimum, -1):
        for pi in by_blocks[blocks]:
            value = dp.get(pi, 0)
            if not value:
                continue
            for sigma in by_blocks[blocks - 1]:
                if refines(pi, sigma):
                    dp[sigma] = dp.get(sigma, 0) + value
    return dp[by_blocks[minimum][0]]


def run_audit():
    families = [
        ["single", "single"],
        ["single", "single", "single"],
        ["single", "single", "single", "single"],
        ["C4"],
        ["C4", "single"],
        ["C4", "single", "single"],
        ["C4", "single", "single", "single"],
    ]

    totals = {
        "systems": 0,
        "decomposition_lattice_elements": 0,
        "decomposition_polynomial_checks": 0,
        "bell_product_checks": 0,
        "mobius_product_checks": 0,
        "maximal_chain_formula_checks": 0,
        "characteristic_profile_checks": 0,
    }

    for kinds in families:
        for seed in range(8):
            triples, _ = sequential_assembly(kinds, 991000 + seed)
            atoms = recovered_atoms(triples)
            block_graph = atom_intersection_graph(triples, atoms)
            partitions = connected_partitions(block_graph)
            mus = shared_multiplicities(triples, atoms)
            c = component_count(block_graph)
            k = len(atoms)
            rank = k - c

            observed_poly = Counter(len(pi) for pi in partitions)
            predicted_poly = predicted_decomposition_polynomial(c, mus)
            assert observed_poly == predicted_poly
            totals["decomposition_polynomial_checks"] += 1

            assert len(partitions) == prod(bell(mu) for mu in mus)
            totals["bell_product_checks"] += 1

            observed_mu = mobius_bottom_top(partitions)
            predicted_mu = (-1) ** rank * prod(factorial(mu - 1) for mu in mus)
            assert observed_mu == predicted_mu
            totals["mobius_product_checks"] += 1

            observed_chains = maximal_chain_count(partitions)
            predicted_chains = (
                factorial(rank) * prod(factorial(mu) for mu in mus) // (2**rank)
            )
            assert observed_chains == predicted_chains
            totals["maximal_chain_formula_checks"] += 1

            # The characteristic polynomial has root j with multiplicity
            # #{p : mu_p >= j+1}; successive differences recover each exact mu.
            max_mu = max(mus, default=1)
            roots = {
                j: sum(mu >= j + 1 for mu in mus)
                for j in range(1, max_mu)
            }
            recovered = Counter()
            for mu in range(2, max_mu + 1):
                recovered[mu] = roots.get(mu - 1, 0) - roots.get(mu, 0)
            assert recovered == Counter(mus)
            totals["characteristic_profile_checks"] += 1

            totals["systems"] += 1
            totals["decomposition_lattice_elements"] += len(partitions)

    totals["status"] = "PASS"
    return totals


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    totals = run_audit()
    if args.check:
        assert totals == json.loads(args.check.read_text())
    text = json.dumps(totals, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
