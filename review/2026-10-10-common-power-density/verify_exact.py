#!/usr/bin/env python3
"""Exact finite checks for the 10 October density continuation.

Uses only Python's standard library and Fraction arithmetic. These finite
checks verify the stated examples, normalizations, and algebraic identities;
they are not a proof of the unrestricted common-power inequality.
"""

from fractions import Fraction as Q
from itertools import combinations, permutations, product
import argparse
import json
from pathlib import Path


EDGES = ((0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3))


def ident(n):
    return [[Q(i == j) for j in range(n)] for i in range(n)]


def mm(a, b):
    n = len(a)
    return [[sum(a[i][s] * b[s][j] for s in range(n))
             for j in range(n)] for i in range(n)]


def transition(kernel, mu):
    return [[kernel[i][j] * mu[j] for j in range(len(mu))]
            for i in range(len(mu))]


def kernel_from_transition(p, mu):
    return [[p[i][j] / mu[j] for j in range(len(mu))]
            for i in range(len(mu))]


def matrix_power(a, n):
    out = ident(len(a))
    while n:
        if n & 1:
            out = mm(out, a)
        a = mm(a, a)
        n //= 2
    return out


def assert_root(t, mu):
    assert all(x > 0 for x in mu) and sum(mu) == 1
    n = len(mu)
    assert all(t[i][j] >= 0 and t[i][j] == t[j][i]
               for i, j in product(range(n), repeat=2))
    assert all(sum(mu[j] * t[i][j] for j in range(n)) == 1
               for i in range(n))
    maximum = max(map(max, t))
    assert maximum >= 1
    p = 1 / maximum
    w = [[p * a for a in row] for row in t]
    assert all(0 <= a <= 1 for row in w for a in row)
    assert all(sum(mu[j] * w[i][j] for j in range(n)) == p
               for i in range(n))
    return p, w


def edge_exponents(tpl):
    k, u, r, l, h = tpl
    assert k >= u >= 1 and r >= l >= 1 and h >= 1
    return (k, r + h, u, r, u, l)


def edge_kernels(t, mu, ns):
    p = transition(t, mu)
    cache = {j: kernel_from_transition(matrix_power(p, 2 * j), mu)
             for j in set(ns)}
    return [cache[j] for j in ns]


def graph_density(kernels, mu, mask=63):
    total = Q(0)
    n = len(mu)
    selected = [(e, kernels[e]) for e in range(6) if mask & (1 << e)]
    for x in product(range(n), repeat=4):
        term = mu[x[0]] * mu[x[1]] * mu[x[2]] * mu[x[3]]
        for e, kernel in selected:
            i, j = EDGES[e]
            term *= kernel[x[i]][x[j]]
        total += term
    return total


def density(t, mu, ns):
    return graph_density(edge_kernels(t, mu, ns), mu)


def tp2(t):
    pairs = list(combinations(range(len(t)), 2))
    return all(t[i][s] * t[j][v] >= t[i][v] * t[j][s]
               for i, j in pairs for s, v in pairs)


def monotone_orders(t, mu):
    p = transition(t, mu)
    n = len(mu)
    return [list(order) for order in permutations(range(n))
            if all(sum(p[order[i]][j] for j in order[:cut]) >=
                   sum(p[order[i+1]][j] for j in order[:cut])
                   for i in range(n-1) for cut in range(1, n))]


def poly_mul(a, b):
    out = [Q(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i+j] += x * y
    return out


def expected_charpoly(roots):
    p = [Q(1)]
    for r in roots:
        p = poly_mul(p, [Q(1), -r])
    return p


def charpoly(a):
    # Faddeev--LeVerrier, with exact matrix arithmetic.
    n = len(a)
    b = ident(n)
    coeff = [Q(1)]
    for k in range(1, n+1):
        ab = mm(a, b)
        c = -sum(ab[i][i] for i in range(n)) / k
        coeff.append(c)
        b = [[ab[i][j] + (c if i == j else 0)
              for j in range(n)] for i in range(n)]
    assert all(x == 0 for row in b for x in row)
    return coeff


def path_root(n, step=Q(1, 4)):
    p = [[Q(0) for _ in range(n)] for _ in range(n)]
    for i in range(n):
        p[i][i] = 1 - (1 if i in (0, n-1) else 2) * step
        if i+1 < n:
            p[i][i+1] = p[i+1][i] = step
    mu = [Q(1, n)] * n
    return kernel_from_transition(p, mu), mu


def refresh(t, rho):
    return [[1 + rho * (a - 1) for a in row] for row in t]


def star_root():
    ints = [[5, 1, 1, 1], [1, 7, 0, 0],
            [1, 0, 7, 0], [1, 0, 0, 7]]
    return [[Q(a, 2) for a in row] for row in ints], [Q(1, 4)] * 4


def refine(s, pi, fibers, gammas):
    # fibers[i] is (actual root R_i, original probability nu_i).
    assert_root(s, pi)
    assert len(pi) == len(fibers) == len(gammas)
    for i, (root, prob) in enumerate(fibers):
        assert_root(root, prob)
        assert 0 <= gammas[i] <= pi[i] * s[i][i]
    states = [(i, a) for i, (_, nu) in enumerate(fibers)
              for a in range(len(nu))]
    mu = [pi[i] * fibers[i][1][a] for i, a in states]
    t = [[s[i][j] + (gammas[i] / pi[i] * (fibers[i][0][a][b] - 1)
                     if i == j else 0)
          for j, b in states] for i, a in states]
    assert_root(t, mu)
    return t, mu, states


def verify_refinement_powers(s, pi, fibers, gammas, powers):
    t, mu, states = refine(s, pi, fibers, gammas)
    for m in powers:
        sm = kernel_from_transition(matrix_power(transition(s, pi), m), pi)
        rms = [kernel_from_transition(matrix_power(transition(r, nu), m), nu)
               for r, nu in fibers]
        expected = [[sm[i][j] + (gammas[i]**m / pi[i] * (rms[i][a][b]-1)
                     if i == j else 0) for j, b in states] for i, a in states]
        actual = kernel_from_transition(matrix_power(transition(t, mu), m), mu)
        assert actual == expected


def one_state():
    return [[Q(1)]], [Q(1)]


def format_fractions(obj):
    if isinstance(obj, Q):
        return str(obj)
    if isinstance(obj, dict):
        return {k: format_fractions(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [format_fractions(v) for v in obj]
    return obj


def run():
    out = {"scope": "Exact finite example and identity checks; unrestricted target open.",
           "tuple_order": "k,u,r,l,h"}
    tpl = (3, 1, 1, 1, 1)
    ns = edge_exponents(tpl)
    total_power = sum(ns)

    # Reproduce the previous TP2 examples independently by rational powers.
    path, mu7 = path_root(7)
    assert tp2(path)
    p_path, _ = assert_root(path, mu7)
    assert p_path == Q(4, 21)
    f_path = density(path, mu7, ns)
    f_path_boundary = density(path, mu7, edge_exponents((1, 1, 1, 1, 1)))
    assert f_path == Q(160101096827, 17179869184)
    assert f_path_boundary == Q(800010799, 67108864)
    positive_path = refresh(path, Q(99, 100))
    p_positive, _ = assert_root(positive_path, mu7)
    assert p_positive == Q(400, 2083)
    max_a = max(map(max, edge_kernels(positive_path, mu7, (1,))[0]))
    assert max_a == Q(344627, 80000)
    out["tp2_path"] = {"F": f_path, "boundary_F": f_path_boundary,
                       "positive_p": p_positive, "positive_max_A": max_a}

    # Genuine zero eigenvalue and a negative eigenvalue of the actual root.
    zero_path, mu6 = path_root(6, Q(1, 3))
    assert tp2(zero_path)
    assert assert_root(zero_path, mu6)[0] == Q(1, 4)
    expected = expected_charpoly([Q(1), Q(2, 3), Q(1, 3), Q(0)])
    expected = poly_mul(expected, [Q(1), Q(-2, 3), Q(-2, 9)])
    assert charpoly(transition(zero_path, mu6)) == expected
    out["spectral_zero_path"] = {"root_charpoly": expected}

    coarse, pi = star_root()
    assert_root(coarse, pi)
    coarse_a = edge_kernels(coarse, pi, (1,))[0]
    assert monotone_orders(coarse_a, pi) == []
    assert charpoly(transition(coarse_a, pi)) == expected_charpoly(
        [Q(1), Q(49, 64), Q(49, 64), Q(1, 4)])
    f_coarse = density(coarse, pi, ns)
    coarse_gap_bound = 63 * Q(1, 4) ** total_power
    assert f_coarse >= 1 + coarse_gap_bound
    out["coarse_star"] = {"F": f_coarse, "p": Q(2, 7),
                          "N": total_power, "gap_bound": coarse_gap_bound,
                          "monotone_orders_of_A": []}

    # Weighted five-state witness, with exactly three positive centered bands.
    nu = [Q(1, 4), Q(3, 4)]
    inner_i = [[Q(i == j) / nu[j] for j in range(2)] for i in range(2)]
    fibers = [one_state(), (inner_i, nu), one_state(), one_state()]
    gammas = [Q(0), Q(3, 8), Q(0), Q(0)]
    refined, mu5, states = refine(coarse, pi, fibers, gammas)
    assert mu5 == [Q(1, 4), Q(1, 16), Q(3, 16), Q(1, 4), Q(1, 4)]
    p5, w5 = assert_root(refined, mu5)
    assert p5 == Q(1, 8)
    expected_w = [[Q(5,16),Q(1,16),Q(1,16),Q(1,16),Q(1,16)],
                  [Q(1,16),Q(1),Q(1,4),Q(0),Q(0)],
                  [Q(1,16),Q(1,4),Q(1,2),Q(0),Q(0)],
                  [Q(1,16),Q(0),Q(0),Q(7,16),Q(0)],
                  [Q(1,16),Q(0),Q(0),Q(0),Q(7,16)]]
    assert w5 == expected_w
    a5 = edge_kernels(refined, mu5, (1,))[0]
    assert max(map(max, a5)) == Q(77, 16)
    expected5 = expected_charpoly([Q(1),Q(49,64),Q(49,64),Q(1,4),Q(9,64)])
    assert charpoly(transition(a5, mu5)) == expected5
    assert monotone_orders(a5, mu5) == []
    f5 = density(refined, mu5, ns)
    assert f5 == Q(2059998202834705, 281474976710656)
    f5_boundary = density(refined, mu5, edge_exponents((1,1,1,1,1)))
    assert f5_boundary == Q(688657530025, 68719476736)
    verify_refinement_powers(coarse, pi, fibers, gammas, (1,2,3,5,6))
    inner_f = density(inner_i, nu, ns)
    refinement_rhs = f_coarse + 16 * Q(3, 8)**(2*total_power) * (inner_f-1)
    assert f5 >= refinement_rhs
    assert f5 >= 1 + 47 * Q(1,4)**total_power
    out["weighted_refinement"] = {
        "mu": mu5, "p": p5, "W": w5, "square_charpoly": expected5,
        "max_A": Q(77,16), "F": f5, "boundary_F": f5_boundary,
        "inner_F": inner_f,
        "quantitative_rhs": refinement_rhs, "residual": f5-refinement_rhs,
        "monotone_orders_of_A": []}

    positive5 = refresh(refined, Q(99,100))
    positive5_p, positive5_w = assert_root(positive5, mu5)
    assert min(map(min, positive5_w)) > 0
    assert positive5_p == Q(100,793)
    positive5_a = edge_kernels(positive5, mu5, (1,))[0]
    assert max(map(max,positive5_a)) == 1 + Q(61,16)*Q(99,100)**2
    assert max(map(max,positive5_a)) > 4
    assert monotone_orders(positive5_a, mu5) == []
    out["positive_weighted_refinement"] = {
        "p": positive5_p, "min_W": min(map(min, positive5_w)),
        "max_A": max(map(max,positive5_a)), "monotone_orders_of_A": []}

    # All 64 centered subgraphs, evaluated independently of the closed formulas.
    full_kernels = edge_kernels(refined, mu5, ns)
    centered = [[[x-1 for x in row] for row in k] for k in full_kernels]
    coefficients = {}
    counts = {"empty":0,"leaf":0,"triangle":0,"square":0,"diamond":0,"full":0}
    for mask in range(64):
        degrees = [sum(bool(mask & (1<<e)) for e,pair in enumerate(EDGES) if v in pair)
                   for v in range(4)]
        c = graph_density(centered, mu5, mask)
        coefficients[mask] = c
        if mask == 0:
            assert c == 1
            kind = "empty"
        elif 1 in degrees:
            assert c == 0
            kind = "leaf"
        elif mask == 63:
            kind = "full"
        else:
            assert c >= 0
            count = mask.bit_count()
            kind = {3:"triangle",4:"square",5:"diamond"}[count]
        counts[kind] += 1
    assert counts == {"empty":1,"leaf":49,"triangle":4,"square":3,"diamond":6,"full":1}
    assert sum(coefficients.values()) == f5
    for mask in range(63):
        assert graph_density(full_kernels, mu5, mask) >= 1
    out["proper_subgraph_audit"] = {"counts": counts, "full_centered": coefficients[63]}

    # Start strictly inside the admissible segment, then reach an exact root zero.
    interior = refresh(refined, Q(3,4))
    minimum = min(map(min,interior))
    endpoint = 1/(1-minimum)
    assert endpoint == Q(4,3)
    assert refresh(interior, endpoint) == refined
    cs = {mask: coefficients[mask] * Q(3,4)**(2*sum(ns[e] for e in range(6) if mask&(1<<e)))
          for mask in range(1,64)}
    ray_rows=[]
    for tau in [Q(1,2),Q(3,4),Q(1),Q(4,3)]:
        root_tau = refresh(interior,tau)
        assert_root(root_tau,mu5)
        direct = density(root_tau,mu5,ns)
        expansion = 1 + sum(c*tau**(2*sum(ns[e] for e in range(6) if mask&(1<<e)))
                            for mask,c in cs.items())
        assert direct == expansion
        ray_rows.append({"tau":tau,"F":direct,"normalized_defect":(direct-1)/tau**(2*total_power)})
    assert all(ray_rows[i]["normalized_defect"] > ray_rows[i+1]["normalized_defect"]
               for i in range(len(ray_rows)-1))
    out["radial_identity"] = {"root_minimum":minimum,"endpoint":endpoint,"values":ray_rows}

    # Three independent, weighted internal roots, including a negative root mode.
    nus = [[Q(1,3),Q(2,3)],[Q(1,2),Q(1,2)],[Q(3,4),Q(1,4)]]
    ps = [[[Q(1,2),Q(1,2)],[Q(1,4),Q(3,4)]],
          [[Q(1,4),Q(3,4)],[Q(3,4),Q(1,4)]],
          [[Q(5,6),Q(1,6)],[Q(1,2),Q(1,2)]]]
    fibers7 = [one_state()] + [(kernel_from_transition(p,nu),nu) for p,nu in zip(ps,nus)]
    gammas7 = [Q(0),Q(1,2),Q(3,8),Q(1,4)]
    ref7, refmu7, _ = refine(coarse,pi,fibers7,gammas7)
    verify_refinement_powers(coarse,pi,fibers7,gammas7,(1,2,3,5,6))
    for root,prob in fibers7:
        assert_root(root,prob)
    ns7 = edge_exponents((1,1,1,1,1))
    n7 = sum(ns7)
    f7 = density(ref7,refmu7,ns7)
    rhs7 = density(coarse,pi,ns7) + sum(pi[i]**(-2)*gammas7[i]**(2*n7)*
                (density(root,prob,ns7)-1) for i,(root,prob) in enumerate(fibers7))
    assert f7 >= rhs7
    assert f7 >= 1 + 15*Q(1,4)**n7
    root7_expected = expected_charpoly([Q(1),Q(7,8),Q(7,8),Q(1,2),Q(1,8),Q(-3,16),Q(1,12)])
    assert charpoly(transition(ref7,refmu7)) == root7_expected
    out["three_arbitrary_fibers_example"] = {
        "mu":refmu7,"gammas":gammas7,"root_charpoly":root7_expected,
        "F":f7,"quantitative_rhs":rhs7,"residual":f7-rhs7,
        "uniform_gap_bound":15*Q(1,4)**n7}

    # A genuine centered zero eigenvalue inside the new refinement class.
    fibers9 = [one_state(), (zero_path, mu6), one_state(), one_state()]
    gammas9 = [Q(0), Q(3,8), Q(0), Q(0)]
    ref9, refmu9, states9 = refine(coarse,pi,fibers9,gammas9)
    assert assert_root(ref9,refmu9)[0] == Q(1,8)
    a9 = edge_kernels(ref9,refmu9,(1,))[0]
    assert max(map(max,a9)) == Q(71,16)
    q6 = transition(zero_path,mu6)
    for i,(fiber_i,a) in enumerate(states9):
        for j,(fiber_j,b) in enumerate(states9):
            if fiber_i == fiber_j == 1:
                assert ref9[i][j] == 2 + 9*q6[a][b]
    char9 = expected_charpoly([Q(1),Q(49,64),Q(49,64),Q(1,4),
                              Q(1,16),Q(1,64),Q(0)])
    char9 = poly_mul(char9,[Q(1),Q(-1,8),Q(1,1024)])
    assert charpoly(transition(a9,refmu9)) == char9
    verify_refinement_powers(coarse,pi,fibers9,gammas9,(1,2,3))
    out["zero_band_refinement"] = {
        "mu":refmu9,"p":Q(1,8),"max_A":Q(71,16),"square_charpoly":char9,
        "one_active_leaf_bound_coefficient":47}

    # Exact original-measure transport in a disconnected weighted host.
    component_pi = [Q(1,3),Q(2,3)]
    component_s = kernel_from_transition(ident(2),component_pi)
    component_fibers = [fibers7[1],one_state()]
    component_t, component_mu, _ = refine(component_s,component_pi,
                                           component_fibers,[Q(1),Q(1)])
    component_f = density(component_t,component_mu,ns7)
    component_rhs = sum(component_pi[i]**(-2)*density(r,nu,ns7)
                         for i,(r,nu) in enumerate(component_fibers))
    assert component_f == component_rhs
    out["disconnected_original_measure"] = {
        "mu":component_mu,"F":component_f,"component_sum":component_rhs}
    out["passed"] = True
    return format_fractions(out)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = run()
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
        print("Exact checks passed; wrote", args.output)
    else:
        print(rendered, end="")
