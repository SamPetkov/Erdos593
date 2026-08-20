#!/usr/bin/env python3
"""Exact finite audit for canonical-atom attachment enumeration.

The verifier uses only the Python standard library.  It independently checks:

1. the closed count by the number of shared points;
2. the profile-refined formula;
3. the restricted largest-multiplicity formula;
4. the free t! quotient from labelled point nodes to quotient assemblies;
5. the injective-port Cayley identity;
6. strict log-concavity of the attachment coefficients; and
7. the exact first large-capacity correction.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from functools import lru_cache
import itertools
import json
import math
from pathlib import Path


def falling(n: int, r: int) -> int:
    if r < 0:
        raise ValueError("negative falling-factorial index")
    if r > n:
        return 0
    value = 1
    for j in range(r):
        value *= n - j
    return value


@lru_cache(maxsize=None)
def stirling(n: int, k: int) -> int:
    if n == 0 and k == 0:
        return 1
    if n == 0 or k == 0 or k > n:
        return 0
    return stirling(n - 1, k - 1) + k * stirling(n - 1, k)


@lru_cache(maxsize=None)
def restricted_stirling(n: int, k: int, q: int) -> int:
    """Partitions of an n-set into k blocks, each of size at most q."""
    if n == 0 and k == 0:
        return 1
    if n <= 0 or k <= 0 or k > n or q <= 0:
        return 0
    return sum(
        math.comb(n - 1, j - 1) * restricted_stirling(n - j, k - 1, q)
        for j in range(1, min(q, n) + 1)
    )


def is_bipartite_tree(
    edge_set: tuple[tuple[int, int], ...], k: int, t: int
) -> bool:
    if len(edge_set) != k + t - 1:
        return False

    adjacency = [[] for _ in range(k + t)]
    for atom, point in edge_set:
        left = atom
        right = k + point
        adjacency[left].append(right)
        adjacency[right].append(left)

    if any(not neighbours for neighbours in adjacency):
        return False

    seen = {0}
    stack = [0]
    while stack:
        vertex = stack.pop()
        for neighbour in adjacency[vertex]:
            if neighbour not in seen:
                seen.add(neighbour)
                stack.append(neighbour)
    return len(seen) == k + t


@lru_cache(maxsize=None)
def bipartite_trees(
    k: int, t: int
) -> tuple[
    tuple[
        tuple[tuple[int, int], ...],
        tuple[int, ...],
        tuple[int, ...],
        tuple[tuple[int, ...], ...],
    ],
    ...,
]:
    possible_edges = [(i, j) for i in range(k) for j in range(t)]
    output = []

    for edge_set in itertools.combinations(possible_edges, k + t - 1):
        if not is_bipartite_tree(edge_set, k, t):
            continue

        atom_degrees = [0] * k
        point_degrees = [0] * t
        incident_points = [[] for _ in range(k)]
        for atom, point in edge_set:
            atom_degrees[atom] += 1
            point_degrees[point] += 1
            incident_points[atom].append(point)

        output.append(
            (
                edge_set,
                tuple(atom_degrees),
                tuple(point_degrees),
                tuple(tuple(sorted(points)) for points in incident_points),
            )
        )

    return tuple(output)


def formula_unlabelled(k: int, t: int, capacities: tuple[int, ...]) -> int:
    if k == 1:
        return int(t == 0)
    if t < 1 or t > k - 1:
        return 0
    excess_capacity = sum(capacity - 1 for capacity in capacities)
    return (
        math.prod(capacities)
        * stirling(k - 1, t)
        * falling(excess_capacity, t - 1)
    )


def brute_labelled_count(
    k: int, t: int, capacities: tuple[int, ...]
) -> tuple[int, dict[tuple[int, ...], int]]:
    total = 0
    by_profile: dict[tuple[int, ...], int] = defaultdict(int)

    for _, atom_degrees, point_degrees, _ in bipartite_trees(k, t):
        if min(point_degrees) < 2:
            continue
        weight = math.prod(
            falling(capacity, degree)
            for capacity, degree in zip(capacities, atom_degrees, strict=True)
        )
        total += weight
        profile = tuple(sorted((degree - 1 for degree in point_degrees), reverse=True))
        by_profile[profile] += weight

    return total, dict(by_profile)


def profile_formula_unlabelled(
    k: int, capacities: tuple[int, ...], profile: tuple[int, ...]
) -> int:
    t = len(profile)
    if sum(profile) != k - 1:
        raise ValueError("profile has the wrong total excess")
    excess_capacity = sum(capacity - 1 for capacity in capacities)
    multiplicities = Counter(profile)
    denominator = math.prod(math.factorial(part) for part in profile)
    denominator *= math.prod(
        math.factorial(multiplicity) for multiplicity in multiplicities.values()
    )
    numerator = (
        math.prod(capacities)
        * falling(excess_capacity, t - 1)
        * math.factorial(k - 1)
    )
    if numerator % denominator:
        raise AssertionError("profile formula is not integral")
    return numerator // denominator


def injection_maps(
    capacity: int, incident_points: tuple[int, ...]
) -> tuple[dict[int, int], ...]:
    return tuple(
        dict(zip(incident_points, values, strict=True))
        for values in itertools.permutations(range(capacity), len(incident_points))
    )


def quotient_keys_for_tree(
    k: int,
    t: int,
    capacities: tuple[int, ...],
    incident_points: tuple[tuple[int, ...], ...],
):
    per_atom = [
        injection_maps(capacities[i], incident_points[i]) for i in range(k)
    ]
    for choices in itertools.product(*per_atom):
        classes = []
        for point in range(t):
            equivalence_class = tuple(
                sorted(
                    (atom, choices[atom][point])
                    for atom in range(k)
                    if point in choices[atom]
                )
            )
            classes.append(equivalence_class)
        yield tuple(sorted(classes))


def ordinary_tree_degrees_from_pruefer(
    word: tuple[int, ...], k: int
) -> tuple[int, ...]:
    degrees = [1] * k
    for letter in word:
        degrees[letter] += 1
    return tuple(degrees)


def weighted_cayley_brute(capacities: tuple[int, ...]) -> int:
    k = len(capacities)
    if k == 1:
        return 1
    total = 0
    for word in itertools.product(range(k), repeat=k - 2):
        degrees = ordinary_tree_degrees_from_pruefer(word, k)
        total += math.prod(
            falling(capacity, degree)
            for capacity, degree in zip(capacities, degrees, strict=True)
        )
    return total


def integer_partitions(n: int, maximum: int | None = None):
    if n == 0:
        yield ()
        return
    if maximum is None or maximum > n:
        maximum = n
    for first in range(maximum, 0, -1):
        for remainder in integer_partitions(n - first, first):
            yield (first,) + remainder


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    summary: Counter[str] = Counter()

    # Exhaustive incidence-tree, profile, and maximum-multiplicity checks.
    for k in range(2, 5):
        capacity_vectors = [
            tuple(3 for _ in range(k)),
            tuple(2 + i for i in range(k)),
            tuple(4 + (i % 2) for i in range(k)),
        ]
        for capacities in capacity_vectors:
            for t in range(1, k):
                brute, by_profile = brute_labelled_count(k, t, capacities)
                expected = math.factorial(t) * formula_unlabelled(k, t, capacities)
                if brute != expected:
                    raise AssertionError(
                        ("attachment count mismatch", k, t, capacities, brute, expected)
                    )

                summary["exhaustive_bipartite_tree_cases"] += 1
                summary["exhaustive_bipartite_trees"] += len(bipartite_trees(k, t))

                for profile, value in by_profile.items():
                    profile_expected = (
                        math.factorial(t)
                        * profile_formula_unlabelled(k, capacities, profile)
                    )
                    if value != profile_expected:
                        raise AssertionError(
                            (
                                "profile count mismatch",
                                k,
                                t,
                                capacities,
                                profile,
                                value,
                                profile_expected,
                            )
                        )
                    summary["profile_formula_cases"] += 1

                excess_capacity = sum(capacity - 1 for capacity in capacities)
                for maximum_multiplicity in range(2, k + 1):
                    value = sum(
                        count
                        for profile, count in by_profile.items()
                        if max(profile) + 1 <= maximum_multiplicity
                    )
                    maximum_expected = (
                        math.factorial(t)
                        * math.prod(capacities)
                        * falling(excess_capacity, t - 1)
                        * restricted_stirling(k - 1, t, maximum_multiplicity - 1)
                    )
                    if value != maximum_expected:
                        raise AssertionError(
                            (
                                "restricted maximum mismatch",
                                k,
                                t,
                                capacities,
                                maximum_multiplicity,
                                value,
                                maximum_expected,
                            )
                        )
                    summary["restricted_maximum_cases"] += 1

    # Explicitly enumerate quotient equivalence relations and verify that
    # forgetting point labels is exactly t!-to-one.
    for k in range(2, 5):
        capacities = (3,) * k
        for t in range(1, k):
            quotient_keys = set()
            labelled_total = 0
            for _, _, point_degrees, incident_points in bipartite_trees(k, t):
                if min(point_degrees) < 2:
                    continue
                for key in quotient_keys_for_tree(k, t, capacities, incident_points):
                    labelled_total += 1
                    quotient_keys.add(key)

            if labelled_total != math.factorial(t) * len(quotient_keys):
                raise AssertionError("point-label action is not free")
            if len(quotient_keys) != formula_unlabelled(k, t, capacities):
                raise AssertionError("explicit quotient count mismatch")

            summary["explicit_quotient_cases"] += 1
            summary["explicit_quotient_assemblies"] += len(quotient_keys)

    # Direct ordinary Prüfer verification of the binary endpoint.
    for k in range(2, 7):
        capacity_vectors = [
            tuple(3 for _ in range(k)),
            tuple(2 + (i % 4) for i in range(k)),
            tuple(4 + ((2 * i) % 3) for i in range(k)),
        ]
        for capacities in capacity_vectors:
            value = weighted_cayley_brute(capacities)
            excess_capacity = sum(capacity - 1 for capacity in capacities)
            expected = math.prod(capacities) * falling(excess_capacity, k - 2)
            if value != expected:
                raise AssertionError(
                    ("weighted Cayley mismatch", k, capacities, value, expected)
                )
            summary["weighted_cayley_cases"] += 1
            summary["ordinary_pruefer_words"] += k ** max(k - 2, 0)

    # Sum the profile-refined formula back to the unrefined formula.
    for k in range(2, 26):
        capacities = tuple(3 + (i % 5) for i in range(k))
        all_partitions = tuple(integer_partitions(k - 1))
        for t in range(1, k):
            profiles = tuple(
                profile for profile in all_partitions if len(profile) == t
            )
            value = sum(
                profile_formula_unlabelled(k, capacities, profile)
                for profile in profiles
            )
            expected = formula_unlabelled(k, t, capacities)
            if value != expected:
                raise AssertionError(
                    ("partition sum mismatch", k, t, value, expected)
                )
            summary["partition_sum_cases"] += 1
            summary["partitions_examined"] += len(profiles)

    # Exact integer checks of strict log-concavity.
    for k in range(3, 81):
        n = k - 1
        for excess_capacity in (n - 1, n, n + 3, 2 * k, 3 * k + 7):
            row = [
                stirling(n, t) * falling(excess_capacity, t - 1)
                for t in range(1, n + 1)
            ]
            row = [value for value in row if value > 0]
            for i in range(1, len(row) - 1):
                if row[i] * row[i] <= row[i - 1] * row[i + 1]:
                    raise AssertionError(
                        ("strict log-concavity failure", k, excess_capacity, i)
                    )
                summary["strict_log_concavity_inequalities"] += 1
            summary["strict_log_concavity_rows"] += 1

    # Exact first correction at the binary endpoint.
    for k in range(3, 51):
        n = k - 1
        for excess_capacity in (2 * k, 5 * k, 10 * k):
            top = stirling(n, n) * falling(excess_capacity, n - 1)
            next_term = stirling(n, n - 1) * falling(excess_capacity, n - 2)
            if (
                next_term * (excess_capacity - k + 3)
                != math.comb(k - 1, 2) * top
            ):
                raise AssertionError(
                    ("first correction mismatch", k, excess_capacity)
                )
            summary["first_correction_identities"] += 1

    result = dict(sorted(summary.items()))
    result["status"] = "PASS"
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"

    if args.output is None:
        print("Erdos 593 canonical attachment enumeration audit")
        print(rendered, end="")
    else:
        args.output.write_text(rendered, encoding="utf-8")


if __name__ == "__main__":
    main()
