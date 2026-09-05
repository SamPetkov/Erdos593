#!/usr/bin/env python3
"""Arithmetic audit for sharp decomposition-lattice extrema."""

from __future__ import annotations

from fractions import Fraction
from math import factorial, prod
import argparse
import json
from pathlib import Path


def stirling_table(nmax):
    table = [[0] * (nmax + 1) for _ in range(nmax + 1)]
    table[0][0] = 1
    for n in range(1, nmax + 1):
        for k in range(1, n + 1):
            table[n][k] = k * table[n - 1][k] + table[n - 1][k - 1]
    return table


S = stirling_table(20)


def bell(n):
    return sum(S[n][k] for k in range(n + 1))


def partitions(n, max_part=None):
    if n == 0:
        yield ()
        return
    if max_part is None or max_part > n:
        max_part = n
    for first in range(max_part, 0, -1):
        for rest in partitions(n - first, first):
            yield (first,) + rest


def run():
    totals = {
        "N_values": 0,
        "profiles": 0,
        "decomposition_count_extrema_checks": 0,
        "mobius_extrema_checks": 0,
        "maximal_chain_extrema_checks": 0,
        "random_decomposition_moment_checks": 0,
    }

    for N in range(1, 13):
        values = []
        for lam in partitions(N):
            mus = [part + 1 for part in lam]
            decomp = prod(bell(mu) for mu in mus)
            mobius = prod(factorial(part) for part in lam)
            chains = factorial(N) * prod(factorial(mu) for mu in mus) // (2**N)
            values.append((lam, decomp, mobius, chains))
            totals["profiles"] += 1

        min_decomp = min(v[1] for v in values)
        max_decomp = max(v[1] for v in values)
        assert min_decomp == 2**N
        assert max_decomp == bell(N + 1)
        assert [v[0] for v in values if v[1] == min_decomp] == [(1,) * N]
        assert [v[0] for v in values if v[1] == max_decomp] == [(N,)]
        totals["decomposition_count_extrema_checks"] += 1

        min_mobius = min(v[2] for v in values)
        max_mobius = max(v[2] for v in values)
        assert min_mobius == 1
        assert max_mobius == factorial(N)
        assert [v[0] for v in values if v[2] == min_mobius] == [(1,) * N]
        assert [v[0] for v in values if v[2] == max_mobius] == [(N,)]
        totals["mobius_extrema_checks"] += 1

        min_chains = min(v[3] for v in values)
        max_chains = max(v[3] for v in values)
        assert min_chains == factorial(N)
        assert max_chains == factorial(N) * factorial(N + 1) // (2**N)
        assert [v[0] for v in values if v[3] == min_chains] == [(1,) * N]
        assert [v[0] for v in values if v[3] == max_chains] == [(N,)]
        totals["maximal_chain_extrema_checks"] += 1
        totals["N_values"] += 1

    # Check the exact mean/variance of the number of blocks in a uniform
    # random set partition.  These are the independent local variables in the
    # uniform-random coarsening law.
    for mu in range(2, 13):
        total = bell(mu)
        mean = sum(Fraction(k * S[mu][k], total) for k in range(1, mu + 1))
        second = sum(Fraction(k * k * S[mu][k], total) for k in range(1, mu + 1))
        variance = second - mean * mean

        ratio1 = Fraction(bell(mu + 1), bell(mu))
        ratio2 = Fraction(bell(mu + 2), bell(mu))
        assert mean == ratio1 - 1
        assert variance == ratio2 - ratio1 * ratio1 - 1
        totals["random_decomposition_moment_checks"] += 1

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
