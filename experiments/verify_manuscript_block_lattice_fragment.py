#!/usr/bin/env python3
"""Hostile arithmetic/construction audit for MANUSCRIPT_BLOCK_AND_LATTICE_EXTENSION.tex."""

from __future__ import annotations

import argparse
import json
import math
from collections import Counter
from math import comb
from pathlib import Path


def partitions(n: int, max_part: int | None = None):
    if n == 0:
        yield ()
        return
    if max_part is None or max_part > n:
        max_part = n
    for first in range(max_part, 0, -1):
        for rest in partitions(n - first, first):
            yield (first,) + rest


def qfun(r: int) -> int:
    return math.ceil(2 * math.sqrt(r))


def bell_numbers(nmax: int) -> list[int]:
    out = [0] * (nmax + 1)
    out[0] = 1
    for n in range(nmax):
        out[n + 1] = sum(comb(n, k) * out[k] for k in range(n + 1))
    return out


def chain_of_stars(k: int, c: int, profile: tuple[int, ...]):
    """Return incidence pairs (atom, shared_point) from the manuscript construction."""
    n = k - c
    assert sum(profile) == n
    incidence: list[tuple[int, int]] = []
    if n == 0:
        return incidence

    t = len(profile)
    active_atoms = n + 1
    next_atom = 0

    if t == 1:
        for atom in range(active_atoms):
            incidence.append((atom, 0))
        return incidence

    for i in range(t - 1):
        atom = next_atom
        next_atom += 1
        incidence.append((atom, i))
        incidence.append((atom, i + 1))

    current_degree = [0] * t
    for _, point in incidence:
        current_degree[point] += 1

    for i, part in enumerate(profile):
        target = part + 1
        for _ in range(target - current_degree[i]):
            atom = next_atom
            next_atom += 1
            incidence.append((atom, i))

    assert next_atom == active_atoms
    return incidence


def verify_chain_of_stars(k: int, c: int, profile: tuple[int, ...]) -> None:
    incidence = chain_of_stars(k, c, profile)
    t = len(profile)
    vertices = [("a", i) for i in range(k)] + [("p", i) for i in range(t)]
    adjacency = {v: [] for v in vertices}
    for atom, point in incidence:
        adjacency[("a", atom)].append(("p", point))
        adjacency[("p", point)].append(("a", atom))

    seen = set()
    components = 0
    for root in vertices:
        if root in seen:
            continue
        components += 1
        seen.add(root)
        stack = [(root, None)]
        while stack:
            u, parent = stack.pop()
            for v in adjacency[u]:
                if v == parent:
                    continue
                assert v not in seen, "chain-of-stars construction produced a cycle"
                seen.add(v)
                stack.append((v, u))

    assert components == c
    assert [len(adjacency[("p", i)]) for i in range(t)] == [x + 1 for x in profile]
    assert max([len(adjacency[("a", i)]) for i in range(k)] + [0]) <= 2
    assert len(incidence) == k + t - c


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    totals = {
        "chain_profile_realizations": 0,
        "characteristic_profile_recoveries": 0,
        "feasible_rank_translation_cases": 0,
        "bell_extremal_profile_cases": 0,
    }

    # Self-contained profile-realization lemma, including N=0 and c>1.
    for k in range(1, 14):
        for c in range(1, k + 1):
            for profile in partitions(k - c):
                verify_chain_of_stars(k, c, profile)
                totals["chain_profile_realizations"] += 1

    # Characteristic-polynomial root multiplicities recover the partition profile.
    for n in range(16):
        for profile in partitions(n):
            roots: Counter[int] = Counter()
            for part in profile:
                for j in range(1, part + 1):
                    roots[j] += 1
            largest = max(roots, default=0)
            recovered: list[int] = []
            for r in range(largest, 0, -1):
                recovered.extend([r] * (roots[r] - roots.get(r + 1, 0)))
            assert tuple(sorted(recovered, reverse=True)) == profile
            totals["characteristic_profile_recoveries"] += 1

    # The manuscript N-spectrum is exactly the componentwise k-spectrum shifted by c.
    for c in range(1, 9):
        for beta in range(31):
            for s in range(2 * c, 61):
                feasible = s >= 2 * c if beta == 0 else s >= 2 * c + qfun(beta)
                if not feasible:
                    continue
                if beta == 0:
                    ks = {s - c}
                    ns = {s - 2 * c}
                elif beta == 1:
                    ks = {
                        k for k in range(c, s - c - 1)
                        if k <= s - c - 2 and k % 2 == (s - c) % 2
                    }
                    ns = {
                        n for n in range(0, s - 2 * c - 1)
                        if n <= s - 2 * c - 2 and n % 2 == (s - 2 * c) % 2
                    }
                else:
                    ks = set(range(c, s - c - qfun(beta) + 1))
                    ns = set(range(0, s - 2 * c - qfun(beta) + 1))
                assert {k - c for k in ks} == ns
                totals["feasible_rank_translation_cases"] += 1

    # Sharp Bell extrema used in the supplementary phase-diagram discussion.
    bells = bell_numbers(20)
    for n in range(16):
        values = []
        for profile in partitions(n):
            value = 1
            for part in profile:
                value *= bells[part + 1]
            values.append((profile, value))
            totals["bell_extremal_profile_cases"] += 1
        assert min(v for _, v in values) == 2**n
        assert max(v for _, v in values) == bells[n + 1]
        if n >= 2:
            assert [p for p, v in values if v == 2**n] == [(1,) * n]
            assert [p for p, v in values if v == bells[n + 1]] == [(n,)]

    totals["status"] = "PASS"
    text = json.dumps(totals, indent=2, sort_keys=True) + "\n"

    if args.check:
        expected = json.loads(args.check.read_text())
        assert expected == totals
    if args.output:
        args.output.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
