"""Fixed rational diagnostics only; the analytical proof is separate."""
from fractions import Fraction as Q
from itertools import product
import json
from continuation_checks import compose, power, density, check_host, EDGES


def main():
    mu = [Q(1, 2), Q(16, 33), Q(1, 66)]
    f = [Q(3, 5), Q(-2, 5), Q(-7)]
    assert sum(mu[i]*f[i] for i in range(3)) == 0
    assert sum(mu[i]*f[i]**2 for i in range(3)) == 1
    identity = [[Q(int(i == j))/mu[i] for j in range(3)] for i in range(3)]
    T = [[Q(3, 4)*identity[i][j]+Q(1, 4)+Q(1, 20)*f[i]*f[j]
          for j in range(3)] for i in range(3)]
    p, A = check_host(T, mu)
    x, y = Q(16, 25), Q(9, 16)
    assert A == [[y*identity[i][j]+1-y+(x-y)*f[i]*f[j]
                  for j in range(3)] for i in range(3)]
    exponents = (4, 3, 1, 2, 1, 1)
    kernels = {m: power(A, m, mu) for m in set(exponents)}
    sm = {m: [[Q(1)+(x**m-y**m)/(1-y**m)*f[i]*f[j]
               for j in range(3)] for i in range(3)] for m in set(exponents)}
    branches, coefficients = [], []
    # Exhaust exactly the 64 I/S choices for this one predetermined host.
    for mask in range(64):
        coefficient = Q(1)
        for e, m in enumerate(exponents):
            coefficient *= y**m if mask >> e & 1 else 1-y**m
        value = Q(0)
        for vertices in product(range(3), repeat=4):
            term = Q(1)
            for v in vertices:
                term *= mu[v]
            for e, ((v, w), m) in enumerate(zip(EDGES, exponents)):
                kernel = identity if mask >> e & 1 else sm[m]
                term *= kernel[vertices[v]][vertices[w]]
            value += term
        assert value >= 1
        branches.append(value)
        coefficients.append(coefficient)
    F = density(A, exponents, mu)
    assert sum(coefficients) == 1
    assert sum(c*v for c, v in zip(coefficients, branches)) == F
    mass_term = sum(q**-2 for q in mu)
    lower = 1+y**sum(exponents)*(mass_term-1)
    for triangle in ((0, 1, 3), (0, 2, 4), (1, 2, 5), (3, 4, 5)):
        term = Q(1)
        for e, m in enumerate(exponents):
            term *= x**m-y**m if e in triangle else 1-y**m
        lower += term
    assert F >= lower >= 1
    assert p == Q(5, 261) < Q(9, 320)
    assert exponents[0] not in (exponents[1], exponents[2], exponents[3])
    # One second, fixed host checks a generic-function shortcut, NOT the K4 target.
    nu = [Q(1, 6), Q(1, 6), Q(1, 3), Q(1, 3)]
    U = [[Q(35, 12), Q(17, 12), Q(1, 6), Q(2, 3)],
         [Q(17, 12), Q(35, 12), Q(1, 6), Q(2, 3)],
         [Q(1, 6), Q(1, 6), Q(13, 6), Q(2, 3)],
         [Q(2, 3), Q(2, 3), Q(2, 3), Q(5, 3)]]
    pu, Au = check_host(U, nu)
    assert pu == Q(12, 35)
    v, q = [-1, -1, -3, 4], [1, -1, 0, 0]
    g = [[1+Q(1, 8)*v[c]*q[d] for d in range(4)] for c in range(4)]
    assert all(Q(1, 2) <= z <= Q(3, 2) for row in g for z in row)
    assert all(sum(nu[d]*g[c][d] for d in range(4)) == 1 for c in range(4))
    assert all(sum(nu[c]*g[c][d] for c in range(4)) == 1 for d in range(4))
    K1, K3, K4 = Au, power(Au, 3, nu), power(Au, 4, nu)
    cross = sum(nu[c]*nu[d]*nu[cp]*K1[c][d]*K3[c][cp]*g[c][d]*g[cp][d]
                for c, d, cp in product(range(4), repeat=3))
    H1 = sum(nu[c]*nu[d]*K1[c][d]*g[c][d]**2 for c, d in product(range(4), repeat=2))
    H4 = sum(nu[c]*nu[d]*K4[c][d]*g[c][d]**2 for c, d in product(range(4), repeat=2))
    D = sum(nu[c]*nu[d]*nu[cp]*K1[c][d]*K3[c][cp]*(g[c][d]-g[cp][d])**2
            for c, d, cp in product(range(4), repeat=3))
    assert cross == 1-Q(35, 944784) < 1
    assert H1 >= 1 and H4 >= 1 and 2*cross == H1+H4-D
    return {"status": "TWO_FIXED_DIAGNOSTICS_PASS", "method": "Exact Fraction weighted sums",
            "mu": list(map(str, mu)), "f": list(map(str, f)),
            "T": [[str(v) for v in row] for row in T], "p": str(p),
            "A_centered_eigenvalues": [str(x), str(y)], "exponents": list(exponents),
            "F": str(F), "mass_term": str(mass_term), "quantitative_lower": str(lower),
            "all_identity_only_lower": str(1+y**sum(exponents)*(mass_term-1)),
            "all_branch_densities": list(map(str, branches)),
            "all_branch_coefficients": list(map(str, coefficients)),
            "generic_shortcut": {"mu": list(map(str, nu)), "p": str(pu),
                "T": [[str(z) for z in row] for row in U],
                "cross": str(cross), "H1": str(H1), "H4": str(H4), "D": str(D),
                "positive_bistochastic_g": True, "not_actual_source_family": True,
                "not_K4_target_counterexample": True},
            "universal_proof": False, "Lean_validation": False, "random_search": False}


if __name__ == "__main__":
    print(json.dumps(main(), indent=2, sort_keys=True))
