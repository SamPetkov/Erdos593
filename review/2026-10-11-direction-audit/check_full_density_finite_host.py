"""Small exact fixtures for the finite-host argument, not a universal search."""

from fractions import Fraction as Q
from itertools import combinations, product
import json


def mm(a, b):
    return [[sum((a[i][t] * b[t][j] for t in range(len(a))), Q(0))
             for j in range(len(a))] for i in range(len(a))]


def powers(p, count):
    n = len(p)
    result = [[[Q(i == j) for j in range(n)] for i in range(n)]]
    for _ in range(count):
        result.append(mm(result[-1], p))
    return result


def kernels(p, mu, count):
    ps = powers(p, 2 * count)
    return {j: [[ps[2*j][x][y] / mu[y] for y in range(len(mu))]
                for x in range(len(mu))] for j in range(1, count + 1)}


def term(mu, ks, edges):
    result = Q(0)
    for xs in product(range(len(mu)), repeat=4):
        value = Q(1)
        for x in xs:
            value *= mu[x]
        for x, y, j in edges:
            value *= ks[j][xs[x]][xs[y]]
        result += value
    return result


def edge_data(k, r, u, l, h):
    return [(0, 1, k), (0, 2, r+h), (0, 3, u),
            (1, 2, r), (1, 3, u), (2, 3, l)]


def validate_host(p, mu):
    assert sum(mu) == 1 and all(x > 0 for x in mu)
    assert all(sum(row) == 1 and all(x >= 0 for x in row) for row in p)
    assert all(mu[i]*p[i][j] == mu[j]*p[j][i]
               for i in range(len(mu)) for j in range(len(mu)))


def components(a):
    unseen, result = set(range(len(a))), []
    while unseen:
        first = min(unseen)
        seen, queue = {first}, [first]
        while queue:
            x = queue.pop()
            for y in unseen:
                if a[x][y] > 0 and y not in seen:
                    seen.add(y)
                    queue.append(y)
        unseen -= seen
        result.append(sorted(seen))
    return result


def component_identity(p, mu, params):
    validate_host(p, mu)
    es = edge_data(*params)
    maximum = max(e[2] for e in es)
    global_value = term(mu, kernels(p, mu, maximum), es)
    a = mm(p, p)
    local_sum = Q(0)
    for c in components(a):
        mass = sum(mu[x] for x in c)
        law = [mu[x] / mass for x in c]
        ac = [[a[x][y] for y in c] for x in c]
        aps = powers(ac, maximum)
        kc = {j: [[aps[j][x][y] / law[y] for y in range(len(c))]
                  for x in range(len(c))] for j in range(1, maximum+1)}
        local_sum += mass**(-2) * term(law, kc, es)
    assert global_value == local_sum
    return str(global_value), len(components(a))


def main():
    params = (3, 2, 3, 2, 1)
    mu = [Q(1, 3)] * 3
    p = [[Q(3, 8), Q(1, 8), Q(1, 2)],
         [Q(1, 8), Q(3, 8), Q(1, 2)],
         [Q(1, 2), Q(1, 2), Q(0)]]
    validate_host(p, mu)
    es = edge_data(*params)
    ks = kernels(p, mu, max(e[2] for e in es))
    rs = {j: [[x-1 for x in row] for row in value] for j, value in ks.items()}
    counts = {"empty": 0, "triangle": 0, "four_cycle": 0,
              "diamond": 0, "tetrahedron": 0, "leaf": 0}
    expansion, tetra = Q(0), None
    for mask in range(64):
        selected = [es[i] for i in range(6) if mask & (1 << i)]
        ds = [0] * 4
        for x, y, _ in selected:
            ds[x] += 1
            ds[y] += 1
        value = term(mu, rs, selected)
        expansion += value
        if 1 in ds:
            kind = "leaf"
            assert value == 0
        else:
            kind = {0: "empty", 3: "triangle", 4: "four_cycle",
                    5: "diamond", 6: "tetrahedron"}[len(selected)]
            if kind != "tetrahedron":
                assert value >= 0
            if kind in {"triangle", "four_cycle"}:
                length = sum(j for _, _, j in selected)
                a_power = powers(mm(p, p), length)[length]
                assert value == sum(a_power[x][x] for x in range(3)) - 1
            if kind == "tetrahedron":
                tetra = value
        counts[kind] += 1
    assert counts == {"empty": 1, "triangle": 4, "four_cycle": 3,
                      "diamond": 6, "tetrahedron": 1, "leaf": 49}
    direct = term(mu, ks, es)
    assert direct == expansion
    k, r, u, l, h = params
    n = k + 2*r + 2*u + l + h
    complements = [2*r+l+h, k+r+u+h, 2*u+l, k+r+u]
    rho, gamma = Q(1, 4), Q(64)
    assert abs(tetra) <= gamma*rho**n
    lower = 1 + sum(rho**(n-s) for s in complements) - gamma*rho**n
    assert direct >= lower > 1
    a = mm(p, p)
    m = len(mu) - 1
    am = powers(a, m)[m]
    delta = sum(min(am[x][y] for x in range(3)) for y in range(3))
    alpha = 1 - delta/m
    assert Q(0) < delta <= 1 and rho <= alpha < 1
    cutoff = 1
    while gamma*alpha**cutoff > 1:
        cutoff += 1
    assert all(sum(row) == 1 for row in am)
    fixtures = {"one_state": component_identity([[Q(1)]], [Q(1)], params),
                "periodic_flip": component_identity([[Q(0), Q(1)],
                                                      [Q(1), Q(0)]],
                                                     [Q(1, 2)]*2, params)}
    q = [[Q(3, 4), Q(1, 4)], [Q(1, 4), Q(3, 4)]]
    periodic = [[Q(0), Q(0), *q[0]], [Q(0), Q(0), *q[1]],
                [*q[0], Q(0), Q(0)], [*q[1], Q(0), Q(0)]]
    fixtures["periodic_two_component_nonconstant"] = component_identity(
        periodic, [Q(1, 4)]*4, params)
    print(json.dumps({"status": "PASS", "exact_arithmetic": True,
                      "universal_proof": False, "exhaustive_run": False,
                      "subset_counts": counts, "fixed_tuple": params,
                      "density": str(direct), "tetrahedron": str(tetra),
                      "proven_lower_bound": str(lower), "delta": str(delta),
                      "alpha": str(alpha), "conservative_cutoff": cutoff,
                      "component_fixtures": fixtures}, indent=2))


if __name__ == "__main__":
    main()
