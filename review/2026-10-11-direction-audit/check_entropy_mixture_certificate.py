"""Exact rational certificate for one compatible binary entropy mixture.

This is a read-only, standard-library calculation on 16 configurations.
It proves the displayed finite signs using rational log intervals. It is
neither an optimizer nor an unrestricted density proof nor Lean evidence.
"""

from collections import Counter
from fractions import Fraction as Q
from itertools import combinations, product
import json

CONFIGS = tuple(product((-1, 1), repeat=4))
EDGES = ((0, 1, 2), (0, 2, 3), (0, 3, 2),
         (1, 2, 2), (1, 3, 2), (2, 3, 2))
TIMES = ((2, 3, 3, 1), (3, 1, 2, 3))


def ancestor_density(times, x):
    # Directly marginalize the actual root ancestor, not fitted pair tables.
    return sum(
        product_value(Q(1) + Q(z * x[i], 2 ** times[i])
                      for i in range(4))
        for z in (-1, 1)
    ) / 2


def product_value(values):
    out = Q(1)
    for value in values:
        out *= value
    return out


def log_interval(x):
    assert x > 0
    z = (x - 1) / (x + 1)
    partial = 2 * sum((z ** (2 * j + 1)) / (2 * j + 1)
                      for j in range(19))
    error = 2 * abs(z) ** 39 / (39 * (1 - z * z))
    return partial - error, partial + error


def log_linear_interval(terms):
    lower = upper = Q(0)
    for argument, coefficient in terms.items():
        lo, hi = log_interval(argument)
        if coefficient >= 0:
            lower += coefficient * lo
            upper += coefficient * hi
        else:
            lower += coefficient * hi
            upper += coefficient * lo
    return lower, upper


def add_term(terms, argument, coefficient):
    terms[argument] = terms.get(argument, Q(0)) + coefficient


def energy_terms(q):
    out = {}
    for x, density in zip(CONFIGS, q):
        for i, j, power in EDGES:
            kernel = Q(1) + Q(x[i] * x[j], 2 ** (2 * power))
            add_term(out, kernel, density / 16)
    return out


def entropy_terms(q):
    out = {}
    for density in q:
        add_term(out, density, density / 16)
    return out


def payoff_interval(q):
    terms = energy_terms(q)
    for argument, coefficient in entropy_terms(q).items():
        add_term(terms, argument, -coefficient)
    return log_linear_interval(terms)


def as_record(interval):
    lo, hi = interval
    return {
        "rational_lower": str(lo),
        "rational_upper": str(hi),
        "decimal_display_only": [float(lo), float(hi)],
    }


def main():
    q0, q1 = (tuple(ancestor_density(times, x) for x in CONFIGS)
              for times in TIMES)
    qm = tuple((a + b) / 2 for a, b in zip(q0, q1))
    for q in (q0, q1, qm):
        assert min(q) > 0 and sum(q) / 16 == 1
        for i in range(4):
            for sign in (-1, 1):
                assert sum(d for x, d in zip(CONFIGS, q)
                           if x[i] == sign) / 16 == Q(1, 2)
    # Verify the explicit mixture polynomial independently of the histogram.
    coefficients = (Q(3, 64), Q(1, 32), Q(9, 128),
                    Q(9, 128), Q(1, 16), Q(3, 64))
    for x, density in zip(CONFIGS, qm):
        polynomial = Q(1) + sum(c * x[i] * x[j]
                               for (i, j), c in zip(
                                   combinations(range(4), 2), coefficients))
        polynomial += Q(product_value(x), 512)
        assert density == polynomial
    assert Counter(q0) == Counter(q1) == {
        Q(423, 512): 2, Q(441, 512): 4, Q(487, 512): 2,
        Q(489, 512): 2, Q(567, 512): 4, Q(681, 512): 2,
    }
    assert Counter(qm) == {
        Q(441, 512): 4, Q(489, 512): 2, Q(495, 512): 4,
        Q(527, 512): 4, Q(681, 512): 2,
    }
    # This involution preserves all six edge exponents.
    for x, d0 in zip(CONFIGS, q0):
        assert d0 == ancestor_density(TIMES[1], (x[2], x[3], x[0], x[1]))
    assert energy_terms(q0) == energy_terms(q1) == energy_terms(qm)
    expected_energy = {
        Q(17, 16): Q(5, 2) + Q(19, 128),
        Q(15, 16): Q(5, 2) - Q(19, 128),
        Q(65, 64): Q(1, 2) + Q(1, 64),
        Q(63, 64): Q(1, 2) - Q(1, 64),
    }
    assert energy_terms(q0) == expected_energy
    g0, g1, gm = map(payoff_interval, (q0, q1, qm))
    assert g0 == g1
    assert Q(-3209, 10 ** 6) < g0[0] <= g0[1] < Q(-3207, 10 ** 6)
    assert Q(9, 100000) < gm[0] <= gm[1] < Q(1, 10000)
    density = sum(product_value(
        Q(1) + Q(x[i] * x[j], 2 ** (2 * power))
        for i, j, power in EDGES
    ) for x in CONFIGS) / 16
    assert density == Q(131155, 131072)
    # The entropy-chain-rule gain is checked as a log-linear expression,
    # independently of any displayed floating-point approximation.
    mi_terms = {}
    for x, a, b, c in zip(CONFIGS, q0, q1, qm):
        add_term(mi_terms, a / c, a / 32)
        add_term(mi_terms, b / c, b / 32)
    mi = log_linear_interval(mi_terms)
    assert mi[0] > 0
    difference = (gm[0] - g0[1], gm[1] - g0[0])
    assert max(mi[0], difference[0]) <= min(mi[1], difference[1])
    print(json.dumps({
        "status": "PASS",
        "scope": "one exact binary mixture; already covered host/reflection tuple",
        "configurations": len(CONFIGS),
        "tuple_k_u_r_l_h": [2, 2, 2, 2, 1],
        "component_times": TIMES,
        "component_payoff": as_record(g0),
        "mixture_payoff": as_record(gm),
        "mixture_label_information": as_record(mi),
        "actual_density": str(density),
        "checks": ["normalization", "singleton laws", "actual ancestor laws",
                   "mixture polynomial", "histograms", "automorphism",
                   "equal exact energies", "rational logarithm remainder",
                   "strict payoff signs", "exact density", "mixture identity intervals"],
        "unrestricted_proof": False,
        "lean_accepted": False,
    }, indent=2))


if __name__ == "__main__":
    main()
