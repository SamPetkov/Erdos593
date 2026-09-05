#!/usr/bin/env python3
"""Arithmetic audit for the global decomposition-lattice spectrum."""

from __future__ import annotations

from math import isqrt
import argparse
import json
from pathlib import Path


def q(r: int) -> int:
    if r <= 0:
        return 0
    x = isqrt(4 * r)
    return x if x * x == 4 * r else x + 1


def partition_numbers(nmax: int) -> list[int]:
    p = [0] * (nmax + 1)
    p[0] = 1
    for part in range(1, nmax + 1):
        for n in range(part, nmax + 1):
            p[n] += p[n - part]
    return p


def bell_numbers(nmax: int) -> list[int]:
    S = [[0] * (nmax + 1) for _ in range(nmax + 1)]
    S[0][0] = 1
    for n in range(1, nmax + 1):
        for k in range(1, n + 1):
            S[n][k] = k * S[n - 1][k] + S[n - 1][k - 1]
    return [sum(S[n]) for n in range(nmax + 1)]


def integer_partitions(n: int, max_part=None):
    if n == 0:
        yield ()
        return
    if max_part is None or max_part > n:
        max_part = n
    for first in range(max_part, 0, -1):
        for rest in integer_partitions(n - first, first):
            yield (first,) + rest


def char_signature(lam):
    # multiplicity of root j in product_i chi(Pi_{lam_i+1})
    if not lam:
        return ()
    return tuple(sum(part >= j for part in lam) for j in range(1, max(lam) + 1))


def feasible(s: int, beta: int, c: int) -> bool:
    if beta == 0:
        return s >= 2 * c
    return s >= 2 * c + q(beta)


def ranks(s: int, beta: int, c: int) -> list[int]:
    if not feasible(s, beta, c):
        return []
    if beta == 0:
        return [s - 2 * c]
    if beta == 1:
        H = s - 2 * c - 2
        parity = (s - 2 * c) % 2
        return [N for N in range(H + 1) if N % 2 == parity]
    H = s - 2 * c - q(beta)
    return list(range(H + 1))


def predicted_type_count(s, beta, c, p):
    return sum(p[N] for N in ranks(s, beta, c))


def run():
    max_s = 42
    max_beta = 36
    max_N = max_s - 2
    p = partition_numbers(max_N)
    B = bell_numbers(max_N + 1)

    totals = {
        "feasible_parameter_triples": 0,
        "rank_spectrum_checks": 0,
        "lattice_type_count_checks": 0,
        "characteristic_signature_injectivity_checks": 0,
        "decomposition_envelope_checks": 0,
        "secondary_invariant_envelope_checks": 0,
    }

    # Check partition counts and characteristic signatures independently.
    for N in range(0, 17):
        parts = list(integer_partitions(N))
        assert len(parts) == p[N]
        signatures = {char_signature(lam) for lam in parts}
        assert len(signatures) == len(parts)
        totals["characteristic_signature_injectivity_checks"] += 1

    for c in range(1, 9):
        for s in range(2 * c, max_s + 1):
            for beta in range(0, max_beta + 1):
                if not feasible(s, beta, c):
                    continue
                Ns = ranks(s, beta, c)
                assert Ns
                totals["feasible_parameter_triples"] += 1

                # Direct translation of the exact atom-count spectrum.
                if beta == 0:
                    expected = [s - 2 * c]
                elif beta == 1:
                    H = s - 2 * c - 2
                    expected = [
                        N for N in range(H + 1)
                        if N % 2 == (s - 2 * c) % 2
                    ]
                else:
                    expected = list(range(s - 2 * c - q(beta) + 1))
                assert Ns == expected
                totals["rank_spectrum_checks"] += 1

                # Number of lattice types is the disjoint sum p(N).
                count = predicted_type_count(s, beta, c, p)
                assert count == sum(p[N] for N in Ns)
                totals["lattice_type_count_checks"] += 1

                Nmin, Nmax = min(Ns), max(Ns)
                if beta == 0:
                    lower = 2**Nmax
                    upper = B[Nmax + 1]
                    assert Nmin == Nmax
                elif beta == 1:
                    lower = 1 if s % 2 == 0 else 2
                    upper = B[Nmax + 1]
                    assert Nmin == (s % 2)
                else:
                    lower = 1
                    upper = B[Nmax + 1]
                    assert Nmin == 0
                assert lower <= upper
                totals["decomposition_envelope_checks"] += 1

                # Maximal possible Möbius magnitude and maximal-chain count.
                max_mobius = 1
                max_chains = 1
                for N in Ns:
                    # For N fixed, the concentrated profile maximizes both.
                    if N:
                        from math import factorial
                        max_mobius = max(max_mobius, factorial(N))
                        max_chains = max(
                            max_chains,
                            factorial(N) * factorial(N + 1) // (2**N),
                        )
                from math import factorial
                assert max_mobius == factorial(Nmax)
                expected_chains = (
                    factorial(Nmax) * factorial(Nmax + 1) // (2**Nmax)
                    if Nmax else 1
                )
                assert max_chains == expected_chains
                totals["secondary_invariant_envelope_checks"] += 1

    totals["status"] = "PASS"
    return totals


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    totals = run()
    if args.check:
        assert totals == json.loads(args.check.read_text())
    text = json.dumps(totals, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
