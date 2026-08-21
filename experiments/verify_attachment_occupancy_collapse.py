#!/usr/bin/env python3
"""Exact audit for the occupancy collapse of canonical attachment counts."""

from __future__ import annotations

from collections import Counter
from fractions import Fraction
from itertools import product
from math import comb, factorial
import argparse
import json
from pathlib import Path


def falling(x: int, r: int) -> int:
    out = 1
    for j in range(r):
        out *= x - j
    return out


def stirling_table(nmax: int) -> list[list[int]]:
    s = [[0] * (nmax + 1) for _ in range(nmax + 1)]
    s[0][0] = 1
    for n in range(1, nmax + 1):
        for t in range(1, n + 1):
            s[n][t] = t * s[n - 1][t] + s[n - 1][t - 1]
    return s


S = stirling_table(40)


def attachment_coeffs(n: int, q: int) -> list[int]:
    # q = R + 1 and n = k - 1.
    return [0] + [S[n][t] * falling(q - 1, t - 1) for t in range(1, n + 1)]


def occupancy_coeffs(n: int, q: int) -> list[int]:
    return [0] + [S[n][t] * falling(q, t) for t in range(1, n + 1)]


def profile_formula(n: int, q: int, profile: tuple[int, ...]) -> int:
    # Normalized attachment codes: one profile block is anchored at the special symbol.
    t = len(profile)
    multiplicities = Counter(profile)
    denominator = 1
    for r in profile:
        denominator *= factorial(r)
    for count in multiplicities.values():
        denominator *= factorial(count)
    return falling(q - 1, t - 1) * factorial(n) // denominator


def profile_probability_numerator(n: int, q: int, profile: tuple[int, ...]) -> int:
    # Ordinary occupancy count with unlabeled boxes but a load profile.
    t = len(profile)
    multiplicities = Counter(profile)
    denominator = 1
    for r in profile:
        denominator *= factorial(r)
    for count in multiplicities.values():
        denominator *= factorial(count)
    return falling(q, t) * factorial(n) // denominator


# Fraction-polynomial utilities, coefficients low degree first.
def trim(p: list[Fraction]) -> list[Fraction]:
    while len(p) > 1 and p[-1] == 0:
        p.pop()
    return p


def derivative(p: list[Fraction]) -> list[Fraction]:
    if len(p) <= 1:
        return [Fraction(0)]
    return trim([Fraction(i) * p[i] for i in range(1, len(p))])


def divmod_poly(a: list[Fraction], b: list[Fraction]) -> tuple[list[Fraction], list[Fraction]]:
    a = trim(a[:])
    b = trim(b[:])
    if b == [0]:
        raise ZeroDivisionError
    if len(a) < len(b):
        return [Fraction(0)], a
    q = [Fraction(0)] * (len(a) - len(b) + 1)
    while len(a) >= len(b) and a != [0]:
        shift = len(a) - len(b)
        coeff = a[-1] / b[-1]
        q[shift] += coeff
        for i, value in enumerate(b):
            a[i + shift] -= coeff * value
        trim(a)
    return trim(q), trim(a)


def sturm_sequence(p: list[Fraction]) -> list[list[Fraction]]:
    p = trim(p[:])
    seq = [p, derivative(p)]
    while seq[-1] != [0]:
        _, rem = divmod_poly(seq[-2], seq[-1])
        if rem == [0]:
            break
        seq.append(trim([-x for x in rem]))
    return seq


def sign_at_zero(p: list[Fraction]) -> int:
    value = p[0]
    return (value > 0) - (value < 0)


def sign_at_negative_infinity(p: list[Fraction]) -> int:
    leading = p[-1]
    sign = (leading > 0) - (leading < 0)
    if (len(p) - 1) % 2:
        sign = -sign
    return sign


def variations(signs: list[int]) -> int:
    filtered = [s for s in signs if s]
    return sum(filtered[i] != filtered[i - 1] for i in range(1, len(filtered)))


def negative_root_count(p: list[Fraction]) -> int:
    seq = sturm_sequence(p)
    return variations([sign_at_negative_infinity(q) for q in seq]) - variations(
        [sign_at_zero(q) for q in seq]
    )


def recurrence_next(coeffs: list[int], q: int) -> list[int]:
    # z(1-z)G'(z) + q z G(z)
    p = [0] * (len(coeffs) + 1)
    for degree, value in enumerate(coeffs):
        if degree == 0 or value == 0:
            continue
        p[degree] += degree * value
        p[degree + 1] -= degree * value
        p[degree + 1] += q * value
    while len(p) > 1 and p[-1] == 0:
        p.pop()
    return p



def integer_partitions(n: int, max_part: int | None = None):
    if n == 0:
        yield ()
        return
    if max_part is None or max_part > n:
        max_part = n
    for first in range(max_part, 0, -1):
        for rest in integer_partitions(n - first, first):
            yield (first,) + rest


def set_partitions(items: tuple[int, ...]):
    if not items:
        yield ()
        return
    first, *rest = items
    for partition in set_partitions(tuple(rest)):
        yield ((first,),) + partition
        for i in range(len(partition)):
            block = tuple(sorted((first,) + partition[i]))
            yield partition[:i] + (block,) + partition[i + 1 :]


def canonical_partition(partition):
    return tuple(sorted((tuple(sorted(block)) for block in partition), key=lambda b: (b[0], len(b), b)))


def connected_total(weights: tuple[int, ...]) -> int:
    if len(weights) == 1:
        return 1
    p = 1
    for w in weights:
        p *= w
    q = 1 + sum(w - 1 for w in weights)
    return p * q ** (len(weights) - 2)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    coefficient_identity_cases = 0
    coefficient_terms = 0
    total_count_cases = 0
    recurrence_cases = 0
    sturm_cases = 0
    certified_negative_roots = 0
    ultra_log_concavity_checks = 0
    moment_cases = 0
    factorial_moment_checks = 0
    normalized_functions = 0
    normalized_profile_cases = 0
    profile_expectation_checks = 0
    component_partition_checks = 0

    # Exact coefficient collapse, total count, recurrence, roots, and Newton inequalities.
    for n in range(1, 21):
        for q in range(n, n + 13):
            a = attachment_coeffs(n, q)
            o = occupancy_coeffs(n, q)
            coefficient_identity_cases += 1
            for t in range(1, n + 1):
                assert q * a[t] == o[t]
                coefficient_terms += 1
            assert sum(a) == q ** (n - 1)
            total_count_cases += 1

            if n < 20:
                expected_next = occupancy_coeffs(n + 1, q)
                while len(expected_next) > 1 and expected_next[-1] == 0:
                    expected_next.pop()
                assert recurrence_next(o, q) == expected_next
                recurrence_cases += 1

            # Divide the occupancy polynomial by its simple zero z.
            h = [Fraction(value) for value in o[1:]]
            count = negative_root_count(h)
            assert count == n - 1
            sturm_cases += 1
            certified_negative_roots += count

            for t in range(2, n):
                left = Fraction(o[t], comb(n, t)) ** 2
                right = Fraction(o[t - 1], comb(n, t - 1)) * Fraction(
                    o[t + 1], comb(n, t + 1)
                )
                assert left > right
                ultra_log_concavity_checks += 1

            total = q**n
            mean_from_pmf = sum(Fraction(t * o[t], total) for t in range(1, n + 1))
            a0 = Fraction(q - 1, q) ** n
            mean_formula = q * (1 - a0)
            assert mean_from_pmf == mean_formula
            second = sum(Fraction(t * t * o[t], total) for t in range(1, n + 1))
            variance_from_pmf = second - mean_from_pmf**2
            b0 = Fraction(q - 2, q) ** n
            variance_formula = q * a0 + q * (q - 1) * b0 - q * q * a0 * a0
            assert variance_from_pmf == variance_formula
            moment_cases += 1

            for j in range(1, min(5, n) + 1):
                lhs = sum(
                    Fraction(falling(t, j) * o[t], total) for t in range(j, n + 1)
                )
                all_occupied = sum(
                    Fraction(((-1) ** ell) * comb(j, ell) * (q - ell) ** n, q**n)
                    for ell in range(j + 1)
                )
                rhs = falling(q, j) * all_occupied
                assert lhs == rhs
                factorial_moment_checks += 1

            profiles = list(integer_partitions(n))
            profile_total = sum(profile_formula(n, q, profile) for profile in profiles)
            assert profile_total == q ** (n - 1)
            for r in range(1, min(6, n) + 1):
                # Expected number of boxes containing exactly r balls, summed over
                # the complete unordered load-profile distribution.
                numerator = sum(
                    Counter(profile)[r] * profile_formula(n, q, profile)
                    for profile in profiles
                )
                expected_formula = Fraction(
                    comb(n, r) * (q - 1) ** (n - r), q ** (n - 1)
                )
                assert Fraction(numerator, profile_total) == expected_formula
                profile_expectation_checks += 1

    # Exhaustive normalized occupancy words and full load-profile formulas.
    small_cases = []
    for n in range(1, 7):
        for q in range(max(1, n), min(8, n + 3)):
            small_cases.append((n, q))
    for n, q in small_cases:
        by_t = Counter()
        by_profile = Counter()
        for tail in product(range(q), repeat=max(0, n - 1)):
            word = (0,) + tail
            loads = Counter(word)
            profile = tuple(sorted(loads.values(), reverse=True))
            by_t[len(loads)] += 1
            by_profile[profile] += 1
            normalized_functions += 1
        for t, count in by_t.items():
            assert count == attachment_coeffs(n, q)[t]
        for profile, count in by_profile.items():
            assert count == profile_formula(n, q, profile)
            assert q * count == profile_probability_numerator(n, q, profile)
            normalized_profile_cases += 1
        assert sum(by_t.values()) == q ** (n - 1)

    # Componentwise factorization for prescribed atom-label component partitions.
    weight_vectors = [
        (3, 3, 3),
        (3, 4, 5, 3),
        (4, 3, 6, 5, 3),
        (3, 3, 4, 5, 6, 3),
    ]
    for weights in weight_vectors:
        seen = set()
        for raw_partition in set_partitions(tuple(range(len(weights)))):
            partition = canonical_partition(raw_partition)
            if partition in seen:
                continue
            seen.add(partition)
            lhs = 1
            for block in partition:
                lhs *= connected_total(tuple(weights[i] for i in block))
            p = 1
            for w in weights:
                p *= w
            rhs = p
            for block in partition:
                q_block = 1 + sum(weights[i] - 1 for i in block)
                # The singleton convention P_B Q_B^{-1}=1 is handled explicitly.
                if len(block) == 1:
                    rhs //= weights[block[0]]
                else:
                    rhs *= q_block ** (len(block) - 2)
            assert lhs == rhs
            component_partition_checks += 1

    result = {
        "certified_negative_roots": certified_negative_roots,
        "coefficient_identity_cases": coefficient_identity_cases,
        "coefficient_terms": coefficient_terms,
        "component_partition_checks": component_partition_checks,
        "factorial_moment_checks": factorial_moment_checks,
        "moment_cases": moment_cases,
        "normalized_functions": normalized_functions,
        "normalized_profile_cases": normalized_profile_cases,
        "profile_expectation_checks": profile_expectation_checks,
        "recurrence_cases": recurrence_cases,
        "status": "PASS",
        "sturm_cases": sturm_cases,
        "total_count_cases": total_count_cases,
        "ultra_log_concavity_checks": ultra_log_concavity_checks,
    }
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered, encoding="utf-8")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
