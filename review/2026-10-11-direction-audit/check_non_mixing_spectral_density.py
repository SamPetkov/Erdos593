"""Fixed exact diagnostics for the analytical spectral-density proofs.

Fraction-only finite identities. No optimizer, eigensolve, numerical search,
network, compiler, or file writes. The proof is in the accompanying note.
"""

from fractions import Fraction as F
from itertools import product
import json


def expectation(mu, values):
    return sum((p * value for p, value in zip(mu, values)), F(0))


def compose(mu, left, right):
    n = len(mu)
    return [[sum((mu[z] * left[x][z] * right[z][y]
                  for z in range(n)), F(0)) for y in range(n)]
            for x in range(n)]


def power(mu, kernel, exponent):
    assert exponent >= 1
    out = kernel
    for _ in range(exponent - 1):
        out = compose(mu, out, kernel)
    return out


def assert_markov(mu, kernel):
    n = len(mu)
    assert all(p > 0 for p in mu) and sum(mu) == 1
    assert all(kernel[x][y] >= 0 and kernel[x][y] == kernel[y][x]
               for x, y in product(range(n), repeat=2))
    assert all(expectation(mu, row) == 1 for row in kernel)


def density(mu, powers, labels):
    alpha, beta, gamma, delta, j, u = labels
    ka, kb, kg, kd, kj, ku = (powers[v] for v in labels)
    return sum((mu[a] * mu[b] * mu[c] * mu[d]
                * ka[a][b] * kj[a][c] * kb[a][d]
                * kg[b][c] * ku[b][d] * kd[c][d]
                for a, b, c, d in product(range(len(mu)), repeat=4)), F(0))


def moments(mu, basis):
    return [[[expectation(mu, [fi[x] * fj[x] * fv[x]
                              for x in range(len(mu))])
              for fv in basis] for fj in basis] for fi in basis]


def pair_matrix(theta, m, j, u):
    indices = list(product(range(len(theta)), repeat=2))
    h = []
    for i, z in indices:
        row = []
        for a, b in indices:
            q = sum((theta[t] ** j * m[i][z][t] * m[a][b][t]
                     for t in range(len(theta))), F(0))
            w = sum((theta[t] ** u * m[i][a][t] * m[z][b][t]
                     for t in range(len(theta))), F(0))
            row.append(q * w)
        h.append(row)
    return indices, h


def contraction(theta, indices, h, labels):
    alpha, beta, gamma, delta, _, _ = labels
    return sum((theta[i] ** alpha * theta[j] ** beta
                * theta[a] ** gamma * theta[b] ** delta * h[row][col]
                for row, (i, j) in enumerate(indices)
                for col, (a, b) in enumerate(indices)), F(0))


def axis_extraction(mu, theta, m, basis, powers, labels):
    # Here the retained placement has beta=U=u; no half powers are used.
    k, u, r, l, j, bd = labels
    assert bd == u
    active = range(1, len(theta))
    w = powers[j]
    deleted = sum((mu[a] * mu[c] * w[a][c]
                   * powers[k + r][a][c] * powers[u + l][a][c]
                   for a, c in product(range(len(mu)), repeat=2)), F(0))
    b = sum((theta[i] ** (k + 2 * u)
             + theta[i] ** (r + u + l)
             + theta[i] ** (k + u + l + j)
             + theta[i] ** (r + 2 * u + j) for i in active), F(0))
    for i, a, c in product(active, repeat=3):
        b += m[i][a][c] ** 2 * (
            theta[i] ** (u + k) * theta[a] ** u * theta[c] ** (l + j)
            + theta[i] ** (2 * u) * theta[a] ** k * theta[c] ** (r + j)
            + theta[i] ** (u + r) * theta[a] ** (u + j) * theta[c] ** l
            + theta[i] ** (u + l) * theta[a] ** (k + j) * theta[c] ** r)
    residual = F(0)
    for i in active:
        for x, y in product(range(len(mu)), repeat=2):
            z = sum((theta[a] ** u * theta[c] ** l * m[i][a][c]
                     * basis[a][x] * basis[c][y]
                     for a, c in product(active, repeat=2)), F(0))
            v = sum((theta[a] ** k * theta[c] ** r * m[i][a][c]
                     * basis[a][x] * basis[c][y]
                     for a, c in product(active, repeat=2)), F(0))
            residual += theta[i] ** u * mu[x] * mu[y] * w[x][y] * v * z
    return deleted, b, residual


def rank_two_case(split=False):
    mu = [F(576, 625), F(49, 1250), F(49, 1250)]
    phi1 = [F(-7, 30), F(171, 35), F(3, 5)]
    phi2 = [F(7, 40), F(4, 5), F(-172, 35)]
    if split:
        mu = [mu[0] / 2, mu[0] / 2, *mu[1:]]
        phi1 = [phi1[0], *phi1]
        phi2 = [phi2[0], *phi2]
    basis = [[F(1)] * len(mu), phi1, phi2]
    for i, fi in enumerate(basis):
        for j, fj in enumerate(basis):
            assert expectation(mu, [fi[x] * fj[x] for x in range(len(mu))]) == (i == j)
    root_eigenvalues = [F(1), F(9, 10), F(3, 4)]
    theta = [t * t for t in root_eigenvalues]
    t = [[sum((e * fi[x] * fi[y] for e, fi in zip(root_eigenvalues, basis)), F(0))
          for y in range(len(mu))] for x in range(len(mu))]
    assert_markov(mu, t)
    assert min(map(min, t)) == F(79, 1000)
    for eigenvalue, fi in zip(root_eigenvalues, basis):
        assert [sum((mu[y] * t[x][y] * fi[y] for y in range(len(mu))), F(0))
                for x in range(len(mu))] == [eigenvalue * v for v in fi]
    if split:
        zero = [F(1), F(-1), F(0), F(0)]
        assert all(sum((mu[y] * t[x][y] * zero[y] for y in range(len(mu))), F(0)) == 0
                   for x in range(len(mu)))
    a = compose(mu, t, t)
    powers = {v: power(mu, a, v) for v in range(1, 12)}
    m = moments(mu, basis)
    out = []
    # Ordered residual tuple with J=U, an unordered positive labeling, and
    # an unequal-filter tuple where the entrywise certificate really fails.
    for labels in [(5, 5, 4, 2, 5, 5), (1, 4, 2, 3, 5, 5),
                   (5, 5, 5, 2, 6, 5), (4, 4, 5, 3, 6, 4)]:
        indices, h = pair_matrix(theta, m, labels[4], labels[5])
        direct = density(mu, powers, labels)
        assert direct == contraction(theta, indices, h, labels)
        assert direct > 1
        negative = [(indices[i], indices[j], h[i][j])
                    for i, j in product(range(len(indices)), repeat=2) if h[i][j] < 0]
        if labels[4] == labels[5]:
            assert not negative
        else:
            assert h[indices.index((2, 2))][indices.index((1, 2))] < 0
        record = {"labels_alpha_beta_gamma_delta_J_U": labels,
                  "F_exact": str(direct), "negative_H_entries": len(negative)}
        alpha, beta, gamma, delta, j, bd = labels
        if beta == gamma:
            # Swap c,d: AD/BC become the matched AC/BD pair.
            relabeled = (alpha, j, bd, delta, beta, gamma)
            other_indices, other_h = pair_matrix(theta, m, relabeled[4], relabeled[5])
            assert min(map(min, other_h)) >= 0
            assert density(mu, powers, relabeled) == direct
            assert contraction(theta, other_indices, other_h, relabeled) == direct
            record["equal_opposite_pair_relabeling_exact"] = True
        if labels[1] == labels[5]:
            deleted, positive, residual = axis_extraction(mu, theta, m, basis, powers, labels)
            assert direct == deleted + positive + residual
            assert deleted > 1 and positive >= 0
            record["axis_extraction_exact"] = True
        out.append(record)
    return {"states": len(mu), "inactive_zero_mode": split,
            "minimum_mu": str(min(mu)), "minimum_T": str(min(map(min, t))),
            "exact_pair_identity_checks": out}


def flat_rank_three_case():
    mu = [F(97, 100), F(1, 100), F(1, 100), F(1, 100)]
    tau = F(9, 10)
    rho = tau * tau
    identity = [[(F(1) / mu[y] if x == y else F(0)) for y in range(4)] for x in range(4)]
    t = [[1 + tau * (identity[x][y] - 1) for y in range(4)] for x in range(4)]
    assert_markov(mu, t)
    a = compose(mu, t, t)
    assert a == [[1 + rho * (identity[x][y] - 1) for y in range(4)] for x in range(4)]
    powers = {s: [[1 + rho ** s * (identity[x][y] - 1)
                   for y in range(4)] for x in range(4)] for s in range(1, 12)}
    for s in range(1, 4):
        assert powers[s] == power(mu, a, s)
    labels = (3, 3, 3, 2, 4, 3)
    value = density(mu, powers, labels)
    assert value > 1 and max(map(max, t)) == F(901, 10)
    # gamma=(E J^(3/2))^4 >= ((3/100)*99^(3/2))^4.
    gamma_rho7_lower = F(3, 100) ** 4 * 99 ** 6 * rho ** 7
    assert gamma_rho7_lower > 1
    return {"states": 4, "active_rank": 3, "rho": str(rho),
            "minimum_mu": str(min(mu)), "maximum_T": str(max(map(max, t))),
            "labels_alpha_beta_gamma_delta_J_U": labels, "F_exact": str(value),
            "previous_spectral_guard_gamma_rho7_lower": str(gamma_rho7_lower)}


def sharpness_check():
    r = F(128)
    c2 = r / (3 * (r - 1))
    s2 = (2 * r - 3) / (3 * (r - 1))
    j, u, q = 4, 3, F(1, 64)
    entry = c2 * (r - 2) ** 2 / (r - 1) ** 2 * s2 * q ** (j + u) \
        / (r - 1) ** 2 * (r - 4 ** j) * (r - 4 ** u)
    assert entry == -F(111573, 2 ** 20 * 127 ** 6)
    return {"J": j, "U": u, "R": str(r), "negative_H_22_12_exact": str(entry),
            "density_counterexample": False}


def boundary_checks():
    # One state and constant roots are exact equality. Three singleton
    # A-components include two active stationary modes; binary flip checks
    # an actual negative root eigenvalue without deleting its square mode.
    labels = (2, 3, 1, 4, 3, 3)
    results = []
    for mu, t, expected, name in [
        ([F(1)], [[F(1)]], F(1), "one_state"),
        ([F(1, 2)] * 2, [[F(1)] * 2 for _ in range(2)], F(1), "constant_root"),
        ([F(1, 3)] * 3, [[F(3) if i == j else F(0) for j in range(3)] for i in range(3)],
         F(27), "three_stationary_components"),
        ([F(1, 2)] * 2, [[F(0), F(2)], [F(2), F(0)]], F(8), "binary_flip"),
    ]:
        assert_markov(mu, t)
        a = compose(mu, t, t)
        powers = {v: power(mu, a, v) for v in range(1, 5)}
        value = density(mu, powers, labels)
        assert value == expected
        results.append({"case": name, "F_exact": str(value)})
    return results


if __name__ == "__main__":
    print(json.dumps({"method": "fixed_fraction_only_algebraic_checks",
                      "rank_two": rank_two_case(),
                      "rank_two_with_inactive_zero_mode": rank_two_case(split=True),
                      "flat_rank_three": flat_rank_three_case(),
                      "sharpness_of_entrywise_certificate": sharpness_check(),
                      "boundaries": boundary_checks(),
                      "numerical_search": False, "lean_validation": False,
                      "unrestricted_density_proved": False}, indent=2))
