"""Small exact channel/Gram checks, not proof by finite sampling.

Standard library only. No compiler, optimizer, network, or file writes.
The square-root Jensen step is proved analytically in the companion note.
"""

from fractions import Fraction as Q
from itertools import product
import json

from check_collective_compensation import check_host, compose, powers, density


def generic_channel(troot, ks, mu, exponents):
    s, t, v, p, q, w = exponents
    assert min(s, t, v) >= 1 and p >= s and q >= t and w >= s+t
    n = len(mu)
    states = list(product(range(n), repeat=2))
    nu = [mu[a]*mu[b] for a, b in states]
    vv = [[ks[s][a][c]*ks[t][b][c] for c in range(n)]
          for a, b in states]
    g = [ks[s+t][a][b] for a, b in states]
    gamma = [[sum(mu[c]*mu[d]*vv[i][c]*ks[v][c][d]*vv[j][d]
                  for c, d in product(range(n), repeat=2))
              for j in range(n*n)] for i in range(n*n)]
    h = [[ks[p-s][a][x]*ks[q-t][b][y] for x, y in states]
         for a, b in states]
    bmat = [[h[i][j]*gamma[i][j] for j in range(n*n)]
            for i in range(n*n)]
    assert all(bmat[i][j] == bmat[j][i] >= 0
               for i, j in product(range(n*n), repeat=2))
    assert all(sum(mu[c]*vv[i][c] for c in range(n)) == g[i]
               for i in range(n*n))

    # Explicit real Gram factors prove the two PSD comparisons in the note.
    # They also retain all extra stationary modes.
    root_powers = powers(troot, mu, max(p-s, q-t, v))
    sh = [[root_powers[p-s][a][x]*root_powers[q-t][b][y]
           for x, y in states] for a, b in states]
    wc = [[sum(mu[c]*vv[i][c]*(root_powers[v][c][d]-1)
               for c in range(n)) for d in range(n)] for i in range(n*n)]
    for i, j in product(range(n*n), repeat=2):
        first = g[i]*g[j]*sum(
            nu[z]*(sh[i][z]-1)*(sh[j][z]-1) for z in range(n*n))
        second = sum(
            nu[z]*mu[d]*sh[i][z]*wc[i][d]*sh[j][z]*wc[j][d]
            for z, d in product(range(n*n), range(n)))
        assert bmat[i][j]-g[i]*g[j] == first+second

    channel = sum(nu[i]*nu[j]*ks[w][states[i][0]][states[i][1]]
                  * bmat[i][j] for i, j in product(range(n*n), repeat=2))
    literal = sum(
        mu[a]*mu[b]*mu[c]*mu[d]*ks[w][a][b]*ks[s][a][c]
        *ks[t][b][c]*ks[v][c][d]*ks[p][a][d]*ks[q][b][d]
        for a, b, c, d in product(range(n), repeat=4))
    assert channel == literal >= 1
    return {"exponents_s_t_v_p_q_w": list(exponents),
            "literal_density": str(literal), "channel_identity": True,
            "explicit_remainder_gram_identity": True}


def main():
    conductances = [[5, 2, 1], [2, 4, 3], [1, 3, 6]]
    totals = [sum(row) for row in conductances]
    mu3 = [Q(s, 27) for s in totals]
    t3 = [[Q(27*conductances[i][j], totals[i]*totals[j])
           for j in range(3)] for i in range(3)]
    mu2 = [Q(1, 2), Q(1, 2)]
    hosts = [("nonuniform_three_states", t3, mu3),
             ("periodic_two_states", [[Q(0), Q(2)], [Q(2), Q(0)]], mu2),
             ("constant_two_states", [[Q(1), Q(1)], [Q(1), Q(1)]], mu2)]
    # Both orientations, a zero-difference H, and l=1 at the second boundary.
    tuples = [(4, 3, 3, 2, 2), (6, 5, 3, 2, 1),
              (3, 3, 2, 2, 3), (3, 3, 2, 1, 1)]
    rows = []
    for name, troot, mu in hosts:
        check_host(troot, mu)
        ks = powers(compose(troot, troot, mu), mu, 8)
        for k, u, r, l, h in tuples:
            params = (k, u, r, l, h)
            if u+l <= r+h:
                orient = "ac"
                exponents = (u, l, u, k, r, r+h)
            else:
                assert u >= r+l
                orient = "bd"
                exponents = (r, l, r+h, k, u, u)
            result = generic_channel(troot, ks, mu, exponents)
            assert Q(result["literal_density"]) == density(ks, mu, params)
            rows.append({"host": name, "parameters_k_u_r_l_h": list(params),
                         "distinguished_edge": orient, **result})
    print(json.dumps({"kind": "short_exact_channel_and_gram_checks",
                      "proof_of_square_root_step": "analytical, not sampled",
                      "unrestricted_theorem_proved": False,
                      "lean_validation": False, "cases": rows}, indent=2))


if __name__ == "__main__":
    main()
