"""Two fixed exact finite diagnostics; no random search or universal inference."""
from fractions import Fraction as Q
from itertools import product
import json


def compose(A, B, mu):
    n = len(mu)
    return [[sum((A[x][z] * mu[z] * B[z][y] for z in range(n)), Q(0))
             for y in range(n)] for x in range(n)]


def power(A, exponent, mu):
    n = len(mu)
    result = [[Q(int(x == y), 1) / mu[y] for y in range(n)] for x in range(n)]
    for _ in range(exponent):
        result = compose(result, A, mu)
    return result


EDGES = ((0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3))


def density(A, exponents, mu):
    kernels = {j: power(A, j, mu) for j in set(exponents)}
    total = Q(0)
    for vertices in product(range(len(mu)), repeat=4):
        term = Q(1)
        for v in vertices:
            term *= mu[v]
        for (v, w), j in zip(EDGES, exponents):
            term *= kernels[j][vertices[v]][vertices[w]]
        total += term
    return total


def check_host(T, mu):
    n = len(mu)
    assert sum(mu) == 1 and all(x > 0 for x in mu)
    assert all(T[x][y] == T[y][x] and T[x][y] >= 0 for x in range(n) for y in range(n))
    assert all(sum(mu[y] * T[x][y] for y in range(n)) == 1 for x in range(n))
    p = 1 / max(max(row) for row in T)
    W = [[p * value for value in row] for row in T]
    assert all(0 <= value <= 1 for row in W for value in row)
    assert all(sum(mu[y] * W[x][y] for y in range(n)) == p for x in range(n))
    return p, compose(T, T, mu)


def main():
    # A lazy five-cycle: original density threshold fails, actual mixing norm passes.
    mu = [Q(1, 5)] * 5
    T = [[Q(19, 4) if x == y else Q(1, 8) if (x-y) % 5 in (1, 4) else Q(0)
          for y in range(5)] for x in range(5)]
    p, A = check_host(T, mu)
    exponents = (2, 6, 1, 5, 1, 5)
    norm = max(max(row) for row in power(A, 5, mu))
    F = density(A, exponents, mu)
    assert p == Q(4, 19) < Q(1, 4) and norm <= 4 and F >= 1
    mixing = {"mu": list(map(str, mu)), "T": [[str(v) for v in row] for row in T],
              "p": str(p), "exponents": exponents, "gamma": "1/4",
              "K_l_norm": str(norm), "gamma_times_norm": str(norm / 4),
              "F": str(F), "original_density_condition": False,
              "actual_mixing_condition": True}

    # Unequal-mass nested partitions, two interacting nonconstant eigenvalues.
    mu = [Q(1, 2), Q(2, 5), Q(1, 10)]
    E0 = [[Q(1)] * 3 for _ in range(3)]
    block = [0, 1, 1]
    E1 = [[Q(1) / sum(mu[z] for z in range(3) if block[z] == block[x])
           if block[x] == block[y] else Q(0) for y in range(3)] for x in range(3)]
    E2 = [[Q(int(x == y)) / mu[y] for y in range(3)] for x in range(3)]
    T = [[Q(1, 10)*E0[x][y] + Q(1, 10)*E1[x][y] + Q(4, 5)*E2[x][y]
          for y in range(3)] for x in range(3)]
    p, A = check_host(T, mu)
    assert compose(E1, E2, mu) == compose(E2, E1, mu) == E1
    assert A == [[Q(19, 100)*E0[x][y] + Q(17, 100)*E1[x][y] + Q(16, 25)*E2[x][y]
                  for y in range(3)] for x in range(3)]
    exponents = (3, 2, 1, 1, 1, 1)
    F = density(A, exponents, mu)
    norm = max(max(row) for row in A)
    assert p == Q(10, 83) < Q(1, 4) and norm == Q(693, 100) > 4 and F >= 1
    hierarchy = {"mu": list(map(str, mu)), "T": [[str(v) for v in row] for row in T],
                 "p": str(p), "exponents": exponents, "gamma": "1/4",
                 "A_centered_eigenvalues": ["81/100", "16/25"],
                 "K_l_norm": str(norm), "F": str(F),
                 "original_density_condition": False, "mixing_norm_condition": False,
                 "hierarchical_host": True}
    return {"status": "TWO_FIXED_EXACT_DIAGNOSTICS_PASS", "method": "Finite weighted sums with Fraction",
            "cases": {"mixing": mixing, "hierarchy": hierarchy}, "random_search": False,
            "universal_proof": False, "Lean_validation": False}


if __name__ == "__main__":
    print(json.dumps(main(), indent=2, sort_keys=True))
