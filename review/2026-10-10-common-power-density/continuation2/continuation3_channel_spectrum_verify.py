"""Exact finite checks for continuation3_channel_spectrum.md.

This standard-library program verifies actual roots in their original measures,
all Id/P cycle contraction formulas on six fixed coarse spaces, and the
quantitative density comparison. It performs no randomized search.
"""
from fractions import Fraction as Q
from itertools import product, combinations
from pathlib import Path
import json

EDGES = ((0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3))
CYCLES = ((0, 1, 3), (0, 2, 4), (1, 2, 5), (3, 4, 5),
          (0, 2, 3, 5), (0, 1, 4, 5), (1, 2, 3, 4))


def compose(a, b, mu):
    return [[sum(mu[t]*a[i][t]*b[t][j] for t in range(len(mu)))
             for j in range(len(mu))] for i in range(len(mu))]


def power(a, n, mu):
    out = [[Q(int(i == j))/mu[i] for j in range(len(mu))]
           for i in range(len(mu))]
    while n:
        if n & 1:
            out = compose(out, a, mu)
        a = compose(a, a, mu)
        n //= 2
    return out


def trace(a, mu):
    return sum(mu[i]*a[i][i] for i in range(len(mu)))


def density(kernels, mu):
    total = Q(0)
    for colors in product(range(len(mu)), repeat=4):
        term = Q(1)
        for c in colors:
            term *= mu[c]
        for e, (v, w) in enumerate(EDGES):
            term *= kernels[e][colors[v]][colors[w]]
        total += term
    return total


def encoded(x):
    return str(x)


def contraction_checks(S, mu=None):
    m = len(S)
    mu = mu or [Q(1, m)]*m
    d = 1/max(mu)
    ident = [[Q(int(i == j))/mu[i] for j in range(m)] for i in range(m)]
    proj = [[x-1 for x in row] for row in ident]
    ls = {n: power(S, 2*n, mu) for n in (1, 2, 3)}
    assert all(sum(mu[j]*S[i][j] for j in range(m)) == 1 for i in range(m))
    assert min(map(min, S)) >= 0
    vi = [sum(mu[j]*ls[1][i][j]*ls[2][i][j]*ls[3][i][j] for j in range(m)) for i in range(m)]
    di = [ls[1][i][i]*ls[2][i][i] for i in range(m)]
    V = sum(mu[i]*vi[i] for i in range(m))
    D = sum(mu[i]*di[i] for i in range(m))
    weighted_v = lambda j: sum(mu[i]*(1/mu[i]-j)*vi[i] for i in range(m))
    weighted_d = lambda j: sum(mu[i]*(1/mu[i]-j)*di[i] for i in range(m))
    pair_trace = lambda x, y: trace(compose(ls[x], ls[y], mu), mu)
    assert V >= 1 and D >= 1
    records = []
    # The triangle is abc; the coarse star labels at a,b,c are 1,2,3.
    cyc = (0, 1, 3)
    for mask in range(8):
        chosen = {e for j, e in enumerate(cyc) if (mask >> j) & 1}
        kernels = [ident if e in chosen else proj for e in range(6)]
        kernels[2], kernels[4], kernels[5] = ls[1], ls[2], ls[3]
        if len(chosen) == 0:
            expected = -1+sum(pair_trace(x, y) for x, y in combinations((1, 2, 3), 2))+weighted_v(3)
        elif len(chosen) == 1:
            v, w = EDGES[next(iter(chosen))]
            expected = weighted_v(2)+pair_trace(v+1, w+1)
        elif len(chosen) == 2:
            expected = weighted_v(1)
        else:
            expected = weighted_v(0)
        actual = density(kernels, mu)
        assert actual == expected
        assert actual >= (d if len(chosen) == 3 else d-1)
        records.append({"cycle": "abc", "identity_edges": sorted(chosen), "value": encoded(actual)})
    # The quadrilateral is abcd; the coarse diagonals are ac and bd.
    cyc = (0, 2, 3, 5)
    tx, ty, txy = trace(ls[1], mu), trace(ls[2], mu), pair_trace(1, 2)
    for mask in range(16):
        chosen = {e for j, e in enumerate(cyc) if (mask >> j) & 1}
        kernels = [ident if e in chosen else proj for e in range(6)]
        kernels[1], kernels[4] = ls[1], ls[2]
        if len(chosen) == 0:
            expected = -3+2*tx+2*ty+2*txy+weighted_d(4)
        elif len(chosen) == 1:
            expected = -1+tx+ty+txy+weighted_d(3)
        elif len(chosen) == 2:
            parent = list(range(4))
            def find(v):
                while parent[v] != v:
                    v = parent[v]
                return v
            for e in chosen:
                v, w = EDGES[e]
                parent[find(v)] = find(w)
            loops = [e for e in (1, 4) if find(EDGES[e][0]) == find(EDGES[e][1])]
            extra = (tx if loops[0] == 1 else ty) if loops else txy
            expected = weighted_d(2)+extra
        elif len(chosen) == 3:
            expected = weighted_d(1)
        else:
            expected = weighted_d(0)
        actual = density(kernels, mu)
        assert actual == expected
        assert actual >= (d if len(chosen) == 4 else d-1)
        records.append({"cycle": "abcd", "identity_edges": sorted(chosen), "value": encoded(actual)})
    if m == 3 and len(set(mu)) == 1:
        assert D <= tx+ty+2*txy-3
    return {"coarse_size": m, "mu": list(map(encoded, mu)), "d": encoded(d), "checks": records}


def actual_host_checks(name, S, H, alpha, beta, ns, equality=False, pi=None):
    m = len(S)
    pi = pi or [Q(1, m)]*m
    d = 1/max(pi)
    states = list(product(range(m), (-1, 1)))
    mu = [pi[i]/2 for i, a in states]
    assert all(abs(H[i][j]) <= S[i][j] for i in range(m) for j in range(m))
    H2 = power(H, 2, pi)
    assert H2 == [[beta*int(i == j)/pi[i]+alpha-beta for j in range(m)] for i in range(m)]
    T = [[S[i][j]+H[i][j]*a*b for j, b in states] for i, a in states]
    assert min(map(min, T)) >= 0
    assert all(T[i][j] == T[j][i] for i in range(2*m) for j in range(2*m))
    assert all(sum(mu[j]*T[i][j] for j in range(2*m)) == 1 for i in range(2*m))
    p = 1/max(map(max, T))
    W = [[p*x for x in row] for row in T]
    assert min(map(min, W)) >= 0 and max(map(max, W)) == 1
    assert all(sum(mu[j]*W[i][j] for j in range(2*m)) == p for i in range(2*m))
    A = power(T, 2, mu)
    K, L, B = {}, {}, {}
    for n in set(ns):
        K[n], L[n], B[n] = power(A, n, mu), power(S, 2*n, pi), power(H, 2*n, pi)
        assert K[n] == [[L[n][i][j]+B[n][i][j]*a*b for j, b in states] for i, a in states]
        assert K[n] == power(T, 2*n, mu)
    F = density([K[n] for n in ns], mu)
    coarse = density([L[n] for n in ns], pi)
    contributions = []
    total_bound = Q(0)
    for cyc in CYCLES:
        q = sum(ns[e] for e in cyc)
        lower = alpha**q+(d-1)*beta**q
        value = density([B[n] if e in cyc else L[n] for e, n in enumerate(ns)], pi)
        assert value >= lower
        if equality:
            assert value == lower
        total_bound += lower
        contributions.append({"edges": list(cyc), "q": q, "value": encoded(value), "cycle_lower_bound": encoded(lower)})
    assert F-coarse == sum(Q(v["value"]) for v in contributions)
    assert F >= coarse+total_bound
    if equality:
        assert coarse == 1 and F == 1+total_bound
    return {"name": name, "mu": list(map(encoded, mu)), "p": encoded(p),
            "W": [[encoded(x) for x in row] for row in W],
            "minimum_W": encoded(min(map(min, W))), "maximum_A": encoded(max(map(max, A))),
            "edge_exponents": list(ns), "alpha": encoded(alpha), "beta": encoded(beta),
            "F": encoded(F), "coarse_F": encoded(coarse), "F_minus_coarse": encoded(F-coarse),
            "cycle_surplus_lower_bound": encoded(total_bound), "cycles": contributions}, A


def verify():
    M = [[12 if i == j == 0 else 15 if i == j else 1 if i == 0 or j == 0 else 0
          for j in range(5)] for i in range(5)]
    S5 = [[Q(155*M[i][j]+16, 512) for j in range(5)] for i in range(5)]
    H5 = [[Q(5*int(i == j)-1, 64) for j in range(5)] for i in range(5)]
    S3 = [[Q(3, 10), Q(27, 20), Q(27, 20)],
          [Q(27, 20), Q(3, 5), Q(21, 20)],
          [Q(27, 20), Q(21, 20), Q(3, 5)]]
    S4 = [[Q(4-degree) if i == j else Q(1) if abs(i-j) == 1 else Q(0)
           for j in range(4)] for i, degree in enumerate((1, 2, 2, 1))]
    formula_checks = [contraction_checks(S) for S in (
        [[Q(1)]], [[Q(0), Q(2)], [Q(2), Q(0)]], S3, S4, S5)]
    actual = []
    ns = (3, 2, 1, 1, 1, 1)
    example, A = actual_host_checks("strictly_positive_ten_state_star", S5, H5, Q(0), Q(1, 4096), ns)
    assert example["p"] == "512/2373" and example["minimum_W"] == "8/2373"
    assert example["maximum_A"] == "551157/131072"
    assert Q(example["p"]) < Q(1, 4) and Q(example["maximum_A"]) > 4
    x, y, b = Q(465, 512)**2, Q(341, 512)**2, Q(1, 4096)
    eigs = [Q(1)]+[x]*3+[y]+[b]*4+[Q(0)]
    # Ten power sums determine the exact ten-dimensional characteristic polynomial.
    mu = [Q(1, 10)]*10
    for k in range(1, 11):
        assert trace(power(A, k, mu), mu) == sum(e**k for e in eigs)
    bound = 1+124*y**sum(ns)+Q(example["cycle_surplus_lower_bound"])
    assert Q(example["F"]) >= bound
    example["eigenvalues_with_multiplicity"] = list(map(encoded, eigs))
    example["explicit_global_lower_bound_at_tuple"] = encoded(bound)
    actual.append(example)
    # Nonflat three-point coarse square; the actual coarse root has two negative centered eigenvalues.
    H3 = [[Q(3*int(i == j)-1, 64)-Q(1, 128) for j in range(3)] for i in range(3)]
    rec, _ = actual_host_checks("three_points_alpha_positive_negative_constant_channel_root", S3, H3,
                                Q(1, 128)**2, Q(1, 64)**2, (2, 1, 3, 4, 1, 2))
    actual.append(rec)
    # The boundary tuple and a disconnected coarse square; alpha=beta.
    S2 = [[Q(0), Q(2)], [Q(2), Q(0)]]
    H2 = [[x/3 for x in row] for row in S2]
    rec, _ = actual_host_checks("disconnected_square_alpha_equals_beta", S2, H2,
                                Q(1, 9), Q(1, 9), (1, 2, 1, 1, 1, 1))
    actual.append(rec)
    rec, _ = actual_host_checks("sharp_Pi_baseline", [[Q(1)]*3 for _ in range(3)],
                                [[Q(3*int(i == j)-1, 4) for j in range(3)] for i in range(3)],
                                Q(0), Q(1, 16), ns, equality=True)
    actual.append(rec)
    rec, _ = actual_host_checks("zero_channel_endpoint", [[Q(1)]], [[Q(0)]],
                                Q(0), Q(0), (1, 2, 1, 1, 1, 1), equality=True)
    actual.append(rec)
    # Unequal original masses: the bound uses d-1=4, not the centered dimension 5.
    pi6 = [Q(1, 5)]*4+[Q(1, 10)]*2
    S0 = [[Q(35, 8) if i == j == 0 else Q(31, 32)/pi6[i] if i == j
           else Q(5, 32) if i == 0 or j == 0 else Q(0) for j in range(6)] for i in range(6)]
    S6 = [[Q(63, 64)*v+Q(1, 64) for v in row] for row in S0]
    H6 = [[(Q(int(i == j))/pi6[i]-1)/128 for j in range(6)] for i in range(6)]
    formula_checks.append(contraction_checks(S6, pi6))
    rec, A6 = actual_host_checks("weighted_twelve_state_star", S6, H6, Q(0), Q(1, 16384), ns, pi=pi6)
    assert rec["p"] == "1024/9853" and rec["minimum_W"] == "8/9853"
    assert rec["maximum_A"] == "38294287/4194304"
    x6, y6, b6 = Q(1953, 2048)**2, Q(1701, 2048)**2, Q(1, 16384)
    eigs6 = [Q(1)]+[x6]*4+[y6]+[b6]*5+[Q(0)]
    mu6 = [p/2 for p in pi6 for _ in range(2)]
    for k in range(1, 13):
        assert trace(power(A6, k, mu6), mu6) == sum(e**k for e in eigs6)
    rec["eigenvalues_with_multiplicity"] = list(map(encoded, eigs6))
    bound6 = 1+299*y6**sum(ns)+Q(rec["cycle_surplus_lower_bound"])
    assert Q(rec["F"]) >= bound6
    rec["explicit_global_lower_bound_at_tuple"] = encoded(bound6)
    actual.append(rec)
    return {"verdict": "PASS", "scope": "Finite exact verification of a proved restricted theorem; no unrestricted target solution.",
            "contraction_formula_checks": 144, "fixed_actual_hosts": 6,
            "formula_records": formula_checks, "actual_host_records": actual}


if __name__ == "__main__":
    result = verify()
    destination = Path(__file__).with_name("continuation3_channel_spectrum_checks.json")
    destination.write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps({"verdict": result["verdict"], "contraction_formula_checks": 144,
                      "fixed_actual_hosts": 6, "output": destination.name}))
