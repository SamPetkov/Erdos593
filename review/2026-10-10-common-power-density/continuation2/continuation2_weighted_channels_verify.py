"""Exact original-measure checks for a weighted, three-character actual root.

Only standard-library rational arithmetic is used. The infinite family theorem
is proved in continuation2_markov.md, not inferred from this finite calculation.
"""
from fractions import Fraction as Q
from itertools import product
from pathlib import Path
import json

EDGES = ((0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3))


def compose(a, b, mu):
    return [[sum(mu[t]*a[i][t]*b[t][j] for t in range(len(mu)))
             for j in range(len(mu))] for i in range(len(mu))]


def power(a, n, mu):
    assert isinstance(n, int) and n >= 0
    out = [[Q(int(i == j), 1)/mu[i] for j in range(len(mu))]
           for i in range(len(mu))]
    while n:
        if n & 1:
            out = compose(out, a, mu)
        a = compose(a, a, mu)
        n //= 2
    return out


def density(kernels, mu):
    out = Q(0)
    for colors in product(range(len(mu)), repeat=4):
        term = Q(1)
        for i in colors:
            term *= mu[i]
        for (v, w), kernel in zip(EDGES, kernels):
            term *= kernel[colors[v]][colors[w]]
        out += term
    return out


def encode(x):
    return str(x.numerator) if x.denominator == 1 else str(x)


def verify():
    pi = [Q(1, 3), Q(2, 3)]
    matrices = [
        [[Q(1), Q(1)], [Q(1), Q(1)]],
        [[Q(1, 8), Q(1, 8)], [Q(1, 8), Q(1, 4)]],
        [[Q(1, 8), Q(1, 16)], [Q(1, 16), Q(1, 16)]],
        [[Q(1, 32), Q(1, 16)], [Q(1, 16), Q(1, 32)]],
    ]
    fibers = list(product((-1, 1), repeat=2))
    psi = [[1, a, b, a*b] for a, b in fibers]
    assert all(sum(Q(v[i]*v[j], 4) for v in psi) == int(i == j)
               for i in range(4) for j in range(4))
    cubic = [[[sum(Q(v[i]*v[j]*v[k], 4) for v in psi)
               for k in range(4)] for j in range(4)] for i in range(4)]
    assert all(x >= 0 for row in cubic for line in row for x in line)
    assert cubic[1][2][3] == 1
    states = list(product(range(2), range(4)))
    mu = [pi[i]/4 for i, _ in states]
    T = [[sum(matrices[z][i][j]*psi[a][z]*psi[b][z] for z in range(4))
          for j, b in states] for i, a in states]
    p = Q(32, 43)
    W = [[p*x for x in row] for row in T]
    assert min(map(min, T)) == Q(23, 32)
    assert max(map(max, T)) == Q(43, 32)
    assert min(map(min, W)) == Q(23, 43) and max(map(max, W)) == 1
    assert all(sum(mu[j]*T[i][j] for j in range(8)) == 1 for i in range(8))
    assert all(sum(mu[j]*W[i][j] for j in range(8)) == p for i in range(8))
    assert all(T[i][j] == T[j][i] for i in range(8) for j in range(8))

    A = power(T, 2, mu)
    for n in (1, 2, 7):
        coarse_powers = [power(B, 2*n, pi) for B in matrices]
        assert all(min(map(min, B)) >= 0 for B in coarse_powers)
        expected = [[sum(coarse_powers[z][i][j]*psi[a][z]*psi[b][z]
                         for z in range(4)) for j, b in states]
                    for i, a in states]
        assert power(T, 2*n, mu) == expected
        assert power(A, n, mu) == expected

    polynomials = []
    for B in matrices[1:]:
        op = [[B[i][j]*pi[j] for j in range(2)] for i in range(2)]
        polynomials.append([Q(1), -op[0][0]-op[1][1],
                            op[0][0]*op[1][1]-op[0][1]*op[1][0]])
    assert polynomials == [[Q(1), Q(-5, 24), Q(1, 288)],
                           [Q(1), Q(-1, 12), Q(1, 1152)],
                           [Q(1), Q(-1, 32), Q(-1, 1536)]]
    assert polynomials[2][2] < 0  # One actual root channel has a negative eigenvalue.
    assert compose(matrices[1], matrices[2], pi) != compose(matrices[2], matrices[1], pi)
    # Rational bounds for the three radicals certify six distinct positive squares.
    for m, lo, hi in ((17, Q(4123, 1000), Q(4124, 1000)),
                      (2, Q(1414, 1000), Q(1415, 1000)),
                      (33, Q(5744, 1000), Q(5745, 1000))):
        assert lo*lo < m < hi*hi
    absolute_root_intervals = [
        ((5-Q(4124, 1000))/48, (5-Q(4123, 1000))/48),
        ((5+Q(4123, 1000))/48, (5+Q(4124, 1000))/48),
        ((2-Q(1415, 1000))/48, (2-Q(1414, 1000))/48),
        ((2+Q(1414, 1000))/48, (2+Q(1415, 1000))/48),
        ((Q(5744, 1000)-3)/192, (Q(5745, 1000)-3)/192),
        ((3+Q(5744, 1000))/192, (3+Q(5745, 1000))/192),
    ]
    squared_intervals = sorted((lo*lo, hi*hi) for lo, hi in absolute_root_intervals)
    assert all(0 < lo < hi for lo, hi in squared_intervals)
    assert all(squared_intervals[i][1] < squared_intervals[i+1][0] for i in range(5))
    # The coarse centered direction is annihilated, so zero is an additional band.
    coarse_centered = [Q(-2) if i == 0 else Q(1) for i, a in states]
    assert sum(mu[i]*coarse_centered[i] for i in range(8)) == 0
    assert all(sum(mu[j]*T[i][j]*coarse_centered[j] for j in range(8)) == 0 for i in range(8))

    ns = (1, 2, 1, 1, 1, 1)
    kernels = {n: power(A, n, mu) for n in set(ns)}
    F = density([kernels[n] for n in ns], mu)
    assert F > 1
    return {
        "states": [[i, *fibers[a]] for i, a in states],
        "mu": list(map(encode, mu)),
        "p": encode(p),
        "W": [[encode(x) for x in row] for row in W],
        "minimum_W": "23/43", "maximum_W": "1",
        "channel_characteristic_polynomials": [[encode(x) for x in p] for p in polynomials],
        "distinct_centered_positive_bands": 6, "additional_centered_zero_bands": 1,
        "squared_eigenvalue_isolating_intervals": [[encode(lo), encode(hi)] for lo, hi in squared_intervals],
        "nontrivial_character_cubic_123": "1",
        "coarse_channels_commute": False,
        "actual_root_has_negative_eigenvalue": True,
        "tuple_k_u_r_l_h": [1, 1, 1, 1, 1],
        "F": encode(F), "F_minus_one": encode(F-1),
        "scope": "Weighted interacting-channel example; its base density also satisfies the older density criterion."
    }


def verify_signed_binary():
    pi = [Q(1, 2), Q(1, 3), Q(1, 6)]
    ident = [[Q(int(i == j), 1)/pi[i] for j in range(3)] for i in range(3)]
    alpha, delta = Q(7, 8), Q(1, 8)
    shift = [Q(1, 64), Q(1, 32), Q(0)]
    S = [[alpha*ident[i][j]+1-alpha for j in range(3)] for i in range(3)]
    H = [[delta*(ident[i][j]-1)+int(i == j)*shift[i]/pi[i]
          for j in range(3)] for i in range(3)]
    assert all(abs(H[i][j]) <= S[i][j] for i in range(3) for j in range(3))
    assert power(S, 2, pi) == [[alpha**2*ident[i][j]+1-alpha**2
                               for j in range(3)] for i in range(3)]
    H2 = power(H, 2, pi)
    assert all(H2[i][j] < 0 for i in range(3) for j in range(3) if i != j)
    assert H2[0][1]*H2[1][2]*H2[2][0] < 0  # Gauge-invariant frustration.
    states = list(product(range(3), (-1, 1)))
    mu = [pi[i]/2 for i, a in states]
    T = [[S[i][j]+H[i][j]*a*b for j, b in states] for i, a in states]
    p = Q(1, 6)
    W = [[p*x for x in row] for row in T]
    assert min(map(min, T)) == 0 and max(map(max, T)) == 6
    assert all(sum(mu[j]*T[i][j] for j in range(6)) == 1 for i in range(6))
    assert all(sum(mu[j]*W[i][j] for j in range(6)) == p for i in range(6))
    A = power(T, 2, mu)
    assert max(map(max, A)) == Q(157, 32)
    assert p < Q(1, 4) and Q(1, 4)*max(map(max, A)) > 1
    op = [[H[i][j]*pi[j] for j in range(3)] for i in range(3)]
    det = (op[0][0]*(op[1][1]*op[2][2]-op[1][2]*op[2][1])
           - op[0][1]*(op[1][0]*op[2][2]-op[1][2]*op[2][0])
           + op[0][2]*(op[1][0]*op[2][1]-op[1][1]*op[2][0]))
    charpoly = [Q(1), -sum(op[i][i] for i in range(3)),
                sum(op[i][i]*op[j][j]-op[i][j]*op[j][i]
                    for i in range(3) for j in range(i+1, 3)), -det]
    assert det > 0
    ns = (3, 2, 1, 1, 1, 1)
    K = {n: power(A, n, mu) for n in set(ns)}
    L = {n: power(S, 2*n, pi) for n in set(ns)}
    full = density([K[n] for n in ns], mu)
    coarse = density([L[n] for n in ns], pi)
    assert full > coarse > 1
    for n in set(ns):
        B = power(H, 2*n, pi)
        assert K[n] == [[L[n][i][j]+B[i][j]*a*b for j, b in states]
                        for i, a in states]
    # The zero-shift variant has a zero odd-channel eigenvalue and two positive bands.
    Hzero = [[delta*(ident[i][j]-1) for j in range(3)] for i in range(3)]
    assert power(Hzero, 2, pi) == [[delta**2*(ident[i][j]-1)
                                  for j in range(3)] for i in range(3)]
    assert all(sum(pi[j]*Hzero[i][j] for j in range(3)) == 0 for i in range(3))

    # An exact endpoint case checks the disconnected original-measure factor pi^-2.
    signs = [Q(1, 2), Q(-1, 3), Q(0)]
    Tdisc = [[ident[i][j]*(1+signs[i]*a*b) for j, b in states] for i, a in states]
    disc_k = {n: power(Tdisc, 2*n, mu) for n in set(ns)}
    disc_full = density([disc_k[n] for n in ns], mu)
    cycles = [(0, 1, 3), (0, 2, 4), (1, 2, 5), (3, 4, 5),
              (0, 3, 5, 2), (0, 4, 5, 1), (1, 3, 4, 2)]
    predicted = sum(pi[i]**-2*(1+sum(signs[i]**(2*sum(ns[e] for e in C))
                                    for C in cycles)) for i in range(3))
    assert disc_full == predicted > sum(x**-2 for x in pi) == 49
    ones = [[Q(1) for j in range(6)] for i in range(6)]
    assert density([ones]*6, mu) == 1
    refresh = Q(99, 100)
    return {
        "states": [list(s) for s in states], "mu": list(map(encode, mu)),
        "p": encode(p), "W": [[encode(x) for x in row] for row in W],
        "minimum_W": "0", "maximum_W": "1", "max_A": "157/32",
        "channel_square": [[encode(x) for x in row] for row in H2],
        "channel_characteristic_polynomial": list(map(encode, charpoly)),
        "centered_positive_bands": 4,
        "zero_shift_centered_bands": ["49/64", "1/64", "0"],
        "tuple_k_u_r_l_h": [3, 1, 1, 1, 1],
        "F": encode(full), "F_coarse": encode(coarse), "F_minus_F_coarse": encode(full-coarse),
        "disconnected_endpoint_F": encode(disc_full), "disconnected_coarse_F": "49",
        "constant_root_F": "1",
        "positive_refresh": {"tau": "99/100", "p": encode(1/(1+5*refresh)),
                             "minimum_W": encode((1-refresh)/(1+5*refresh)),
                             "max_A": encode(1+refresh**2*(Q(157, 32)-1))},
        "scope": "Signed-channel theorem example beyond the old density/mixing tests; no unrestricted target claim."
    }


if __name__ == "__main__":
    result = {"three_character": verify(), "signed_binary": verify_signed_binary()}
    Path("continuation2_weighted_channels_checks.json").write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps({k: {a: b for a, b in v.items() if a != "W"}
                      for k, v in result.items()}, indent=2))
