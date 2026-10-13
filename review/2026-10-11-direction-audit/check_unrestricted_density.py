"""Small exact read-only checks; no optimizer, compiler, network, or file writes."""

from fractions import Fraction as Q
from itertools import product
from math import factorial
import json


def identity(mu):
    return [[Q(int(i == j), 1) / mu[j] for j in range(len(mu))]
            for i in range(len(mu))]


def compose(b, c, mu):
    n = len(mu)
    return [[sum(mu[j] * b[i][j] * c[j][k] for j in range(n))
             for k in range(n)] for i in range(n)]


def powers(t, mu, top):
    ans = [identity(mu)]
    for _ in range(top):
        ans.append(compose(ans[-1], t, mu))
    return ans


def host_check(t, mu):
    assert sum(mu) == 1 and min(mu) > 0
    n = len(mu)
    assert all(t[i][j] == t[j][i] > 0
               for i in range(n) for j in range(n))
    assert all(sum(mu[j] * t[i][j] for j in range(n)) == 1
               for i in range(n))
    p = 1 / max(map(max, t))
    assert all(0 < p * x <= 1 for row in t for x in row)
    return p


def density(ks, mu, params):
    k, u, r, l, h = params
    return sum(mu[a] * mu[b] * mu[c] * mu[d]
               * ks[k][a][b] * ks[r+h][a][c] * ks[u][a][d]
               * ks[r][b][c] * ks[u][b][d] * ks[l][c][d]
               for a, b, c, d in product(range(len(mu)), repeat=4))


def pair_trace(ks, mu, params):
    k, u, r, l, h = params
    xy = list(product(range(len(mu)), repeat=2))
    nu = [mu[a] * mu[c] for a, c in xy]
    v = [[ks[u][a][b] * ks[l][c][b] for b in range(len(mu))]
         for a, c in xy]
    hmat = [[ks[k-u][a][x] * ks[r-l][c][z] for x, z in xy]
            for a, c in xy]
    hv = [[sum(nu[j] * hmat[i][j] * v[j][b] for j in range(len(xy)))
           for b in range(len(mu))] for i in range(len(xy))]
    assert all(hv[i][b] == ks[k][a][b] * ks[r][c][b]
               for i, (a, c) in enumerate(xy) for b in range(len(mu)))
    gamma = [[sum(mu[b] * mu[d] * v[i][b] * ks[u][b][d] * v[j][d]
                  for b, d in product(range(len(mu)), repeat=2))
              for j in range(len(xy))] for i in range(len(xy))]
    assert all(sum(nu[i] * v[i][b] for i in range(len(xy))) == 1
               for b in range(len(mu)))
    assert all(sum(nu[j] * gamma[i][j] for j in range(len(xy)))
               == ks[u+l][a][c] for i, (a, c) in enumerate(xy))
    value = sum(nu[i] * nu[j] * ks[r+h][a][c] * hmat[i][j] * gamma[j][i]
                for i, (a, c) in enumerate(xy) for j in range(len(xy)))
    assert value == density(ks, mu, params)
    return value


def sign_kernel(rho):
    signs = (-1, 1)
    return [[1 + rho * x * y for y in signs] for x in signs]


mu = [Q(1, 2)] * 2
t1 = sign_kernel(Q(1, 2))
assert host_check(t1, mu) == Q(2, 3)
theta1 = Q(1, 4)
ks1 = powers(compose(t1, t1, mu), mu, 4)
f1 = density(ks1, mu, (1, 1, 1, 1, 1))
assert f1 == 1 + 2*theta1**3 + 3*theta1**4 + 2*theta1**5 == 1 + Q(23, 512)
assert -Q(1, 16) + Q(1, 24) - Q(1, 512) + Q(1, 240) == -Q(143, 7680)

t2 = sign_kernel(Q(9, 10))
assert host_check(t2, mu) == Q(10, 19)
theta2 = Q(81, 100)
ks2 = powers(compose(t2, t2, mu), mu, 4)
f2 = density(ks2, mu, (3, 1, 1, 1, 1))
assert 1 + theta2**3 - 2*theta2 == -Q(88559, 10**6)
assert f2 == (1 + theta2**3 + theta2**4 + 2*theta2**5
              + 2*theta2**6 + theta2**7) > 1
assert all(1+a*b-a*d-b*d in (0, 4)
           for a, b, d in product((-1, 1), repeat=3))

xy = list(product(range(2), repeat=2))
mu4 = [mu[i] * mu[j] for i, j in xy]
tensor_t = [[t1[a][b] * t1[c][d] for b, d in xy] for a, c in xy]
host_check(tensor_t, mu4)
tensor_ks = powers(compose(tensor_t, tensor_t, mu4), mu4, 4)
assert density(tensor_ks, mu4, (1, 1, 1, 1, 1)) == f1*f1

g = [[Q(5), Q(2), Q(1)], [Q(2), Q(4), Q(3)], [Q(1), Q(3), Q(6)]]
row = list(map(sum, g))
total = sum(row)
mu3 = [s/total for s in row]
t3 = [[total*g[i][j]/(row[i]*row[j]) for j in range(3)] for i in range(3)]
host_check(t3, mu3)
ks3 = powers(compose(t3, t3, mu3), mu3, 4)
pair_values = [pair_trace(ks3, mu3, params)
               for params in ((3, 1, 2, 1, 2), (1, 1, 1, 1, 1))]

# This signed measure is a toy algebra check, NOT a claimed actual kernel.
atoms = (Q(1), Q(1, 4), Q(1, 9))
coef = (Q(2), -Q(1, 4), Q(1, 2))
mass = sum(coef)
variation = sum(map(abs, coef))
m = 20
grouped = {}
for n1 in range(m+1):
    for n2 in range(m-n1+1):
        n0 = m-n1-n2
        counts = (n0, n1, n2)
        eigenvalue = atoms[1]**n1 * atoms[2]**n2
        multiplicity = factorial(m)
        for n in counts:
            multiplicity //= factorial(n)
        value = multiplicity * coef[0]**n0 * coef[1]**n1 * coef[2]**n2
        assert eigenvalue not in grouped
        grouped[eigenvalue] = value
assert sum(grouped.values()) == mass**m
assert sum(map(abs, grouped.values())) == variation**m
negative = -sum(x for x in grouped.values() if x < 0)
assert negative == (variation**m-mass**m)/2 > coef[0]**m-1

print(json.dumps({
    "status": "PASS",
    "arithmetic": "fractions.Fraction; no floating point",
    "checks": {
        "binary_star_actual_density": str(f1),
        "star_log_upper_bound": str(-Q(143, 7680)),
        "branch_triangle_defect": str(-Q(88559, 10**6)),
        "branch_obstruction_actual_density": str(f2),
        "actual_tensor_density_factorization": True,
        "nonuniform_pair_space_identities": [str(x) for x in pair_values],
        "zero_increment_weighted_identity": True,
        "toy_signed_measure_tensor_algebra": True,
        "toy_measure_is_not_an_actual_host_certificate": True
    },
    "unrestricted_density_proved": False,
    "lean_validation": False,
    "file_writes": False
}, indent=2))
