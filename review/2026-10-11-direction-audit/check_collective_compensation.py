"""Small exact identity/calibration checks, not a universal density proof.

Standard library only. No optimizer, compiler, network, or file writes.
"""

from fractions import Fraction as Q
from itertools import product
import json


def ident(mu):
    return [[Q(int(i == j)) / mu[j] for j in range(len(mu))]
            for i in range(len(mu))]


def compose(a, b, mu):
    n = len(mu)
    return [[sum(mu[j] * a[i][j] * b[j][k] for j in range(n))
             for k in range(n)] for i in range(n)]


def powers(t, mu, top):
    ans = [ident(mu)]
    for _ in range(top):
        ans.append(compose(ans[-1], t, mu))
    return ans


def centered(a):
    return [[x - 1 for x in row] for row in a]


def check_host(t, mu):
    n = len(mu)
    assert sum(mu) == 1 and min(mu) > 0
    assert all(t[i][j] == t[j][i] >= 0
               for i, j in product(range(n), repeat=2))
    assert all(sum(mu[j] * t[i][j] for j in range(n)) == 1
               for i in range(n))
    p = 1 / max(map(max, t))
    assert all(0 <= p * x <= 1 for row in t for x in row)


def density(ks, mu, params):
    k, u, r, l, h = params
    return sum(mu[a]*mu[b]*mu[c]*mu[d] * ks[k][a][b]
               * ks[r+h][a][c] * ks[u][a][d] * ks[r][b][c]
               * ks[u][b][d] * ks[l][c][d]
               for a, b, c, d in product(range(len(mu)), repeat=4))


def schur_check(ks, mu, params):
    k, u, r, l, h = params
    n = len(mu)
    rs = [centered(a) for a in ks]
    pair = list(product(range(n), repeat=2))
    u0 = sum(mu[a]*mu[c]*ks[k+r][a][c]*ks[r+h][a][c]
             for a, c in pair)
    u1 = sum(mu[a]*mu[c]*ks[k+r][a][c]*ks[r+h][a][c]
             * rs[u+l][a][c] for a, c in pair)
    u2 = sum(mu[b]*mu[c]*ks[k+r+h][b][c]*ks[r][b][c]
             * rs[u+l][b][c] for b, c in pair)
    m0 = sum(mu[c]*mu[d]*ks[l][c][d]*rs[r+u][c][d]
             * rs[r+h+u][c][d] for c, d in pair)
    m1 = sum(mu[a]*mu[b]*mu[c]*mu[d]*ks[l][c][d]
             * ks[r+h][a][c]*rs[k][a][b]*rs[u][a][d]
             * rs[u][b][d]*ks[r][b][c]
             for a, b, c, d in product(range(n), repeat=4))
    full = density(ks, mu, params)
    assert full == u0+u1+u2+m0+m1
    assert u0 >= 1 and min(u1, u2, m0) >= 0

    # Independent eight-term expansion of the retained centered triangle.
    edges = [(0, 2, r+h), (1, 2, r), (2, 3, l)]
    terms = []
    for bits in product((0, 1), repeat=3):
        term = Q(0)
        for x in product(range(n), repeat=4):
            a, b, c, d = x
            value = mu[a]*mu[b]*mu[c]*mu[d]
            value *= rs[k][a][b]*rs[u][a][d]*rs[u][b][d]
            for bit, (v, w, j) in zip(bits, edges):
                if bit:
                    value *= rs[j][x[v]][x[w]]
            term += value
        terms.append((bits, term))
    assert sum(value for _, value in terms) == m1
    assert all(value == 0 for bits, value in terms if sum(bits) == 1)
    assert all(value >= 0 for bits, value in terms if sum(bits) < 3)

    # Actual product commutator identity; neither error sign nor global
    # compensation is asserted.
    positive, error = Q(0), Q(0)
    for c, d in pair:
        fg = [ks[r][a][c]*rs[u][a][d] for a in range(n)]
        ahfg = [sum(mu[x]*ks[h][a][x]*fg[x] for x in range(n))
                for a in range(n)]
        rkfg = [sum(mu[b]*rs[k][a][b]*fg[b] for b in range(n))
                for a in range(n)]
        positive += mu[c]*mu[d]*ks[l][c][d]*sum(
            mu[a]*mu[b]*fg[a]*rs[h+k][a][b]*fg[b]
            for a, b in pair)
        error += mu[c]*mu[d]*ks[l][c][d]*sum(
            mu[a]*(ahfg[a]-ks[r+h][a][c]*rs[u][a][d])*rkfg[a]
            for a in range(n))
    assert m1 == positive-error and positive >= 0
    return {"F": str(full), "U0": str(u0), "U1": str(u1),
            "U2": str(u2), "M0": str(m0), "M1": str(m1),
            "positive_commutator_part": str(positive),
            "commutator_error": str(error)}


def overlap_check(t, ks, mu, params):
    k, u, r, l, h = params
    n = len(mu)
    xy = list(product(range(n), repeat=2))
    nu = [mu[a]*mu[c] for a, c in xy]
    g = [ks[u+l][a][c] for a, c in xy]
    v = [[ks[u][a][b]*ks[l][c][b] for b in range(n)]
         for a, c in xy]
    gamma = [[sum(mu[b]*mu[d]*v[i][b]*ks[u][b][d]*v[j][d]
                  for b, d in product(range(n), repeat=2))
              for j in range(len(xy))] for i in range(len(xy))]
    hmat = [[ks[k-u][a][x]*ks[r-l][c][z] for x, z in xy]
            for a, c in xy]
    assert all(sum(nu[j]*gamma[i][j] for j in range(len(xy))) == g[i]
               for i in range(len(xy)))
    assert all(sum(nu[j]*hmat[i][j]*g[j] for j in range(len(xy)))
               == ks[k+r][a][c] for i, (a, c) in enumerate(xy))
    support = [i for i in range(len(xy)) if g[i] > 0]
    rho = [nu[i]*g[i] for i in support]
    assert sum(rho) == 1
    assert all(all(x == 0 for x in gamma[i])
               for i in range(len(xy)) if not g[i])
    pmat = [[gamma[i][j]/(g[i]*g[j]) for j in support] for i in support]
    assert all(sum(rho[j]*row[j] for j in range(len(support))) == 1
               for row in pmat)
    tu = powers(t, mu, u)[u]
    cond = [[sum(mu[b]*v[i][b]*tu[b][d] for b in range(n))/g[i]
             for d in range(n)] for i in support]
    assert all(sum(mu[d]*row[d] for d in range(n)) == 1 for row in cond)
    assert all(sum(rho[i]*cond[i][d] for i in range(len(support))) == 1
               for d in range(n))
    assert all(pmat[i][j] == sum(mu[d]*cond[i][d]*cond[j][d]
                                for d in range(n))
               for i, j in product(range(len(support)), repeat=2))
    value = sum(rho[i]*rho[j]*ks[r+h][xy[si][0]][xy[si][1]]
                * hmat[si][sj]*pmat[i][j]
                for i, si in enumerate(support)
                for j, sj in enumerate(support))
    assert value == density(ks, mu, params)
    coarse = sum(mu[a]*mu[c]*ks[r+h][a][c]*ks[u+l][a][c]
                 * ks[k+r][a][c] for a, c in xy)
    assert coarse >= 1
    return {"support": len(support), "pair_states": len(xy),
            "C": str(coarse), "centered_channel_remainder": str(value-coarse)}


def log_interval(x):
    z = (x-1)/(x+1)
    approximation = 2*sum(z**(2*j+1)/Q(2*j+1) for j in range(4))
    remainder = 2*abs(z)**9/(9*(1-z*z))
    return approximation-remainder, approximation+remainder


def binary_entropy_check():
    mu = [Q(1, 2), Q(1, 2)]
    t = [[Q(3, 2), Q(1, 2)], [Q(1, 2), Q(3, 2)]]
    check_host(t, mu)
    ks = powers(compose(t, t, mu), mu, 4)
    configs = list(product(range(2), repeat=4))
    relative = {}
    for x in configs:
        relative[x] = sum(mu[z]*t[z][x[0]]*t[z][x[1]]
                          *t[z][x[2]]*t[z][x[3]] for z in range(2))
    assert sum(relative.values(), Q(0))/16 == 1
    counts = {}
    for x, q in relative.items():
        kind = min(sum(x), 4-sum(x))
        expected = {0: Q(41, 16), 1: Q(15, 16), 2: Q(9, 16)}[kind]
        assert q == expected
        counts[kind] = counts.get(kind, 0)+1
    assert counts == {0: 2, 1: 8, 2: 6}
    for v, w in product(range(4), repeat=2):
        if v == w:
            continue
        for a, b in product(range(2), repeat=2):
            marginal = sum(relative[x]/16 for x in configs
                           if x[v] == a and x[w] == b)
            assert marginal == mu[a]*mu[b]*ks[1][a][b]

    # Aggregate the direct expected edge logs minus marginalized entropy,
    # independently of the seven-term closed expression.
    direct = {}
    edges = [(0, 1, 1), (0, 2, 2), (0, 3, 1),
             (1, 2, 1), (1, 3, 1), (2, 3, 1)]
    for x in configs:
        prob = relative[x]/16
        for v, w, j in edges:
            key = ks[j][x[v]][x[w]]
            direct[key] = direct.get(key, Q(0))+prob
        key = relative[x]
        direct[key] = direct.get(key, Q(0))-prob
    coefficients = [(Q(25, 8), Q(5, 4)), (Q(15, 8), Q(3, 4)),
                    (Q(1, 2), Q(255, 256)), (Q(1, 8), Q(17, 15)),
                    (-Q(41, 128), Q(41, 16)),
                    (-Q(15, 32), Q(15, 16)),
                    (-Q(27, 128), Q(9, 16))]
    # The ac logarithms combine by exact product identities:
    # log(17/16), log(15/16) become the two terms displayed above.
    grouped = [(Q(25, 8), Q(5, 4)), (Q(15, 8), Q(3, 4)),
               (Q(5, 8), Q(17, 16)), (Q(3, 8), Q(15, 16)),
               (-Q(41, 128), Q(41, 16)), (-Q(15, 32), Q(15, 16)),
               (-Q(27, 128), Q(9, 16))]
    combined = {}
    for coefficient, x in grouped:
        combined[x] = combined.get(x, Q(0))+coefficient
    assert combined == direct
    assert Q(17, 16)*Q(15, 16) == Q(255, 256)
    assert Q(17, 16)/Q(15, 16) == Q(17, 15)
    lower, upper = Q(0), Q(0)
    for coefficient, x in coefficients:
        lo, hi = log_interval(x)
        lower += coefficient*(lo if coefficient >= 0 else hi)
        upper += coefficient*(hi if coefficient >= 0 else lo)
    assert lower > Q(1, 50)
    f = density(ks, mu, (1, 1, 1, 1, 1))
    assert f == Q(535, 512)
    return {"F": str(f), "entropy_payoff_lower": str(lower),
            "entropy_payoff_upper": str(upper),
            "payoff_above_one_fiftieth": True}


def main():
    conductances = [[5, 2, 1], [2, 4, 3], [1, 3, 6]]
    sums = [sum(row) for row in conductances]
    mu3 = [Q(s, 27) for s in sums]
    t3 = [[Q(27*conductances[i][j], sums[i]*sums[j])
           for j in range(3)] for i in range(3)]
    mu2 = [Q(1, 2), Q(1, 2)]
    hosts = [("nonuniform_three_states", t3, mu3),
             ("periodic_two_states", [[Q(0), Q(2)], [Q(2), Q(0)]], mu2),
             ("constant_two_states", [[Q(1), Q(1)], [Q(1), Q(1)]], mu2)]
    rows = []
    for name, t, mu in hosts:
        check_host(t, mu)
        ks = powers(compose(t, t, mu), mu, 9)
        params = (3, 1, 2, 1, 2)
        schur = schur_check(ks, mu, params)
        overlap = overlap_check(t, ks, mu, params)
        zero_params = (3, 1, 2, 1, 0)
        fzero = density(ks, mu, zero_params)
        reflection = sum(mu[c]*mu[d]*ks[1][c][d]*ks[3][c][d]**2
                         for c, d in product(range(len(mu)), repeat=2))
        assert fzero >= reflection >= 1
        sigma = lambda j: sum(mu[a]*ks[j][a][a]
                              for a in range(len(mu)))-1
        strengthened = 1+sigma(7)+sigma(6)+2*sigma(4)
        assert fzero >= strengthened
        rows.append({"host": name, "parameters": list(params),
                     "schur": schur, "overlap": overlap,
                     "F_auxiliary_h0": str(fzero),
                     "reflection_lower": str(reflection),
                     "strengthened_h0_lower": str(strengthened)})
    print(json.dumps({"kind": "bounded_exact_identity_and_witness_checks",
                      "unrestricted_theorem_proved": False,
                      "lean_validation": False,
                      "binary_entropy": binary_entropy_check(),
                      "identity_cases": rows}, indent=2))


if __name__ == "__main__":
    main()
