"""Small deterministic rational checks; examples are not universal proofs.

Run: python -B review/2026-10-08-rank-three-entropy/exact_checks.py
No dependencies, network, random search, compiler, or file writes.
Matrices below are probability-space kernels, not stochastic matrices.
"""
from fractions import Fraction as Q
from itertools import combinations, product
from collections import Counter
from pathlib import Path
import json

EDGES = ((0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3))


def density(kernels):
    n = len(kernels[0])
    total = Q(0)
    for xs in product(range(n), repeat=4):
        term = Q(1)
        for (v, w), kernel in zip(EDGES, kernels):
            term *= kernel[xs[v]][xs[w]]
        total += term
    return total / n**4


def flat_kernel(projection, eta, j):
    return [[1 + eta**j * value for value in row] for row in projection]


def record(value):
    return {'numerator': str(value.numerator), 'denominator': str(value.denominator),
            'decimal_for_display_only': float(value)}


def test_flat():
    projection = [[Q(2), Q(-2), Q(0), Q(0)],
                  [Q(-2), Q(2), Q(0), Q(0)],
                  [Q(0), Q(0), Q(2), Q(-2)],
                  [Q(0), Q(0), Q(-2), Q(2)]]
    eta, d, exponents = Q(1, 16), 2, (3, 4, 1, 2, 1, 1)
    for row in flat_kernel(projection, eta, 1):
        assert sum(row) == 4 and min(row) >= 0
    actual = density([flat_kernel(projection, eta, j) for j in exponents])
    s, m = sum(exponents), min(exponents)
    bound = 1 + 2*d*eta**(s-3*m) + d*d*eta**s
    assert actual >= bound >= 1
    return {'name': 'Four-state flat rank-two host with signed projection',
            'uniform_states': 4, 'projection': [[str(x) for x in row] for row in projection],
            'eta': str(eta), 'rank': d, 'exponents': exponents,
            'F': record(actual), 'quantitative_lower_bound': record(bound),
            'exact_comparison': True, 'projection_has_negative_entries': True}


def test_coordinates():
    states = list(product(range(3), range(2)))
    exponents, t1, t2 = (3, 3, 1, 2, 1, 1), Q(1, 4), Q(1, 3)
    theta1, theta2 = t1*t1, t2*t2
    def kernel(j):
        return [[1 + theta1**j * (3*(x[0] == y[0])-1)
                    + theta2**j * (2*(x[1] == y[1])-1)
                 for y in states] for x in states]
    root = [[1 + t1*(3*(x[0] == y[0])-1) + t2*(2*(x[1] == y[1])-1)
             for y in states] for x in states]
    assert all(sum(row) == 6 and min(row) > 0 for row in root)
    maximum = max(x for row in root for x in row)
    assert maximum == Q(11, 6)
    actual = density([kernel(j) for j in exponents])
    s, m = sum(exponents), min(exponents)
    bound = 1 + sum(2*d*theta**(s-3*m) + d*d*theta**s
                    for d, theta in ((2, theta1), (1, theta2)))
    locals_ = []
    for n, theta in ((3, theta1), (2, theta2)):
        projection = [[Q(n*(x == y)-1) for y in range(n)] for x in range(n)]
        locals_.append(density([flat_kernel(projection, theta, j) for j in exponents]))
    assert actual == 1 + sum(value-1 for value in locals_)
    assert actual >= bound >= 1
    return {'name': 'Six-state independent-coordinate mixture',
            'uniform_states': 6, 'coordinate_sizes': [3, 2], 'weights': [str(t1), str(t2)],
            'positive_centered_eigenvalues': [str(theta1), str(theta2)],
            'multiplicities': [2, 1], 'zero_modes': 2, 'p': '6/11',
            'exponents': exponents, 'F': record(actual),
            'quantitative_lower_bound': record(bound), 'exact_coordinate_identity': True,
            'exact_comparison': True}


def test_weighted_obstruction():
    operator = [[Q(13,18), Q(1,18), Q(2,9)],
                [Q(1,18), Q(13,18), Q(2,9)],
                [Q(2,9), Q(2,9), Q(5,9)]]
    def multiply(a, b):
        return [[sum(a[i][k]*b[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
    a = multiply(operator, operator)
    a3 = multiply(multiply(a, a), a)
    v = (-1, -3, 4)
    av = [sum(a3[i][j]*v[j] for j in range(3)) for i in range(3)]
    value = sum(3*a[i][0]*v[i]*av[i] for i in range(3))/3
    assert value == Q(-140, 19683)
    return {'name': 'Weighted-positivity route obstruction', 'exact_value': record(value),
            'target_counterexample': False, 'scope': 'Arbitrary-vector shortcut only'}


def classify_subsets():
    counts = Counter()
    for mask in range(64):
        edges = {edge for index, edge in enumerate(EDGES) if mask & (1 << index)}
        while True:
            degree = Counter(v for edge in edges for v in edge)
            leaves = {v for v, d in degree.items() if d == 1}
            if not leaves: break
            edges = {edge for edge in edges if not leaves.intersection(edge)}
        size = len(edges)
        counts[{0: 'forest', 3: 'triangle_core', 4: 'four_cycle', 5: 'diamond', 6: 'K4'}[size]] += 1
    assert dict(counts) == {'forest': 38, 'triangle_core': 16, 'four_cycle': 3, 'diamond': 6, 'K4': 1}
    return dict(counts)


def test_individual_coefficient():
    data = json.loads(Path(__file__).with_name('route-diagnostics.json').read_text())
    p = [[int(x) for x in row] for row in data['P']]
    m = [[int(x) for x in row] for row in data['eigenfunction_numerator_M']]
    denominator, n = int(data['D']), int(data['N'])
    beta_num = [int(value.split('/')[0]) for value in data['beta']]
    assert all(sum(row) == denominator and min(row) > 0 for row in p)
    assert all(p[i][j] == p[j][i] for i in range(4) for j in range(4))
    for s in range(3):
        assert sum(m[x][s] for x in range(4)) == 0
        for x in range(4):
            assert 10**6 * sum(p[x][y]*m[y][s] for y in range(4)) == denominator*beta_num[s]*m[x][s]
        for t in range(3):
            assert sum(m[x][s]*m[x][t] for x in range(4)) == (4*n*n if s == t else 0)
    def multiply(a, b):
        return [[sum(a[i][z]*b[z][j] for z in range(4)) for j in range(4)] for i in range(4)]
    v = multiply(p, p)
    v2 = multiply(v, v)
    v3 = multiply(v2, v)
    u = multiply(v3, v3)
    u2 = multiply(u, u)
    r0 = Q(4*sum(v[b][d]*v2[b][d]*u2[b][d] for b,d in product(range(4), repeat=2)), denominator**30)
    rs = []
    for s in range(3):
        c = sum(v[b][d]*sum(m[a][s]*v[a][b]*v[a][d] for a in range(4))
                *sum(m[z][s]*u[b][z]*u[z][d] for z in range(4))
                for b,d in product(range(4), repeat=2))
        rs.append(Q(4*c, n*n*denominator**30))
    assert Q(-390859,10**11) < rs[0] < Q(-390858,10**11)
    prefix, prefixes = Q(0), []
    for s in (2, 1, 0):
        prefix += Q(beta_num[s],10**6)**12 * rs[s]
        assert prefix > 0 and r0 + prefix >= 1
        prefixes.append({'mode': s+1, 'S': record(prefix), 'R0_plus_S': record(r0+prefix)})
    return {'name': 'Individual coefficient positivity fails on an actual four-state host',
            'R1': record(rs[0]), 'certified_interval': '-390859/10^11 < R1 < -390858/10^11',
            'R0': record(r0), 'prefixes': prefixes, 'exact_host_and_eigenbasis_checks': True,
            'all_old_and_shifted_prefixes_positive': True, 'target_counterexample': False}


if __name__ == '__main__':
    results = {'date': '2026-10-08', 'method': 'Exhaustive small finite sums using exact rational arithmetic',
               'subsets_checked': 64, 'subset_classification': classify_subsets(),
               'cases': [test_flat(), test_coordinates(), test_weighted_obstruction(), test_individual_coefficient()],
               'random_search': False, 'universal_proof': False, 'Lean_validation': False,
               'interpretation': 'Reproducible examples and route diagnostic; analytical proof is separately stated in research-note.tex'}
    print(json.dumps(results, indent=2, sort_keys=True))
