"""Small, read-only exact checks; no optimizer, file writes, or Lean invocation."""
from fractions import Fraction as Q
from itertools import product, combinations
import json
from pathlib import Path


def matrix_power(kernel, exponent, mu):
    identity = [
        [Q(int(i == j), 1) / mu[j] for j in range(len(mu))]
        for i in range(len(mu))
    ]
    result = identity
    for _ in range(exponent):
        result = compose(result, kernel, mu)
    return result


def compose(left, right, mu):
    n = len(mu)
    return [[sum(mu[z] * left[i][z] * right[z][j] for z in range(n))
             for j in range(n)] for i in range(n)]


def components(kernel):
    unseen = set(range(len(kernel)))
    answer = []
    while unseen:
        todo = [min(unseen)]
        block = set()
        while todo:
            i = todo.pop()
            if i in block:
                continue
            block.add(i)
            todo.extend(j for j in unseen if kernel[i][j] > 0)
        unseen -= block
        answer.append(sorted(block))
    return answer


def density(mu, powers, k, u, r, ell, h):
    result = Q(0)
    for a, b, c, d in product(range(len(mu)), repeat=4):
        result += (mu[a] * mu[b] * mu[c] * mu[d]
                   * powers[k][a][b] * powers[r + h][a][c]
                   * powers[u][a][d] * powers[r][b][c]
                   * powers[u][b][d] * powers[ell][c][d])
    return result


def check_host(name, mu, root, p):
    n = len(mu)
    assert sum(mu) == 1 and all(x > 0 for x in mu)
    assert all(root[i][j] == root[j][i] for i, j in product(range(n), repeat=2))
    assert all(0 <= p * root[i][j] <= 1 for i, j in product(range(n), repeat=2))
    assert all(sum(mu[j] * root[i][j] for j in range(n)) == 1 for i in range(n))
    a_kernel = compose(root, root, mu)
    blocks = components(a_kernel)
    projection = [[Q(0) for _ in mu] for _ in mu]
    for block in blocks:
        mass = sum(mu[i] for i in block)
        for i, j in product(block, repeat=2):
            projection[i][j] = 1 / mass
    m = max(1, n - 1)
    powers = {j: matrix_power(a_kernel, j, mu) for j in range(1, 11)}
    epsilon = min(sum(mu[i] for i in block) * powers[m][x][y]
                  for block in blocks for x, y in product(block, repeat=2))
    assert 0 < epsilon <= 1
    d_total = Q(0)
    limit = Q(0)
    for block in blocks:
        mass = sum(mu[i] for i in block)
        dj = sum((mu[x] / mass) * (mu[y] / mass)
                 * (mass * powers[2][x][y]) * (mass * powers[1][x][y])
                 * (mass * powers[2][x][y])
                 for x, y in product(block, repeat=2))
        assert dj >= 1
        d_total += dj / mass
        limit += dj / mass**2
    mr = max(powers[1][x][x] - projection[x][x] for x in range(n))
    cutoff_q = 0
    if epsilon < 1:
        # These fixed test cases have tiny cutoffs; do not run an unbounded search.
        while (1 - epsilon)**cutoff_q * mr * d_total > limit - 1:
            cutoff_q += 1
            assert cutoff_q <= 100
    else:
        assert a_kernel == projection
    values = {}
    for h in range(1, 9):
        value = density(mu, powers, 1, 1, 1, 1, h)
        assert abs(value - limit) <= (1 - epsilon)**(h // m) * mr * d_total
        if h >= max(1, m * cutoff_q):
            assert value >= 1
        values[str(h)] = str(value)
    return {
        "name": name, "components_of_A": blocks, "m": m,
        "epsilon": str(epsilon), "D": str(d_total), "L": str(limit),
        "M_r": str(mr), "q_star": cutoff_q,
        "certified_h_from": max(1, m * cutoff_q), "F_h_1_to_8": values,
    }


hosts = [
    check_host("one_state", [Q(1)], [[Q(1)]], Q(1)),
    check_host("periodic_root", [Q(1, 2)] * 2,
               [[Q(0), Q(2)], [Q(2), Q(0)]], Q(1, 2)),
    check_host("connected_two_state", [Q(1, 2)] * 2,
               [[Q(3, 2), Q(1, 2)], [Q(1, 2), Q(3, 2)]], Q(2, 3)),
    check_host("disconnected_weighted", [Q(1, 4), Q(1, 4), Q(1, 2)],
               [[Q(3), Q(1), Q(0)], [Q(1), Q(3), Q(0)],
                [Q(0), Q(0), Q(2)]], Q(1, 3)),
    check_host("connected_weighted", [Q(1, 4), Q(1, 4), Q(1, 2)],
               [[Q(3, 2), Q(1, 2), Q(1)], [Q(1, 2), Q(3, 2), Q(1)],
                [Q(1), Q(1), Q(1)]], Q(2, 3)),
]
assert hosts[2]["D"] == "265/256" and hosts[2]["q_star"] == 2
assert hosts[3]["L"] == "521/64"
assert Q(hosts[2]["F_h_1_to_8"]["4"]) == 1 + Q(1157, 32768)

# Actual-host reflection shortcut: orthonormal L2(mu) coordinate matrix.
h_matrix = [[Q(1285, 2048), Q(1020, 2048)],
            [Q(1020, 2048), Q(771, 2048)]]
two_mu = [Q(1, 2)] * 2
two_root = [[Q(3, 2), Q(1, 2)], [Q(1, 2), Q(3, 2)]]
two_a = compose(two_root, two_root, two_mu)
two_k4 = matrix_power(two_a, 4, two_mu)
derived_h = [[(two_a[i][0] + two_a[j][0]) * two_k4[i][j] / 4
              for j in range(2)] for i in range(2)]
assert derived_h == h_matrix
determinant = h_matrix[0][0] * h_matrix[1][1] - h_matrix[0][1]**2
quadratic = sum(Q(x) * h_matrix[i][j] * Q(y)
                for i, x in enumerate([4, -5]) for j, y in enumerate([4, -5]))
assert determinant == Q(-49665, 4194304) and quadratic == Q(-965, 2048)

# Positive three-symbol input and analytic Taylor bounds; no floating-point logs.
kappa = [Q(1, 20), Q(1, 20), Q(9, 10)]
g = [Q(4), Q(2), Q(-1, 3)]
s = Q(11, 10)
t = Q(1, 10**6)
assert sum(kappa[i] * g[i] for i in range(3)) == 0
assert sum(kappa[i] * g[i]**2 for i in range(3)) == s
mu3_squared = sum(kappa[i] * g[i]**3 for i in range(3))**2 / s**3
mu4 = sum(kappa[i] * g[i]**4 for i in range(3)) / s**2
assert mu3_squared == Q(114490, 11979) and mu4 == Q(12250, 1089)
p_transition = [[kappa[y] * (1 + t * g[x] * g[y] / s)
                 for y in range(3)] for x in range(3)]
eta = {}
for x, y, z in product(range(3), repeat=3):
    eta[x, y, z] = (kappa[x] * kappa[y] * kappa[z]
                   * (1 + t * (g[x]*g[y] + g[x]*g[z] + g[y]*g[z]) / s))
    assert eta[x, y, z] > 0
assert sum(eta.values()) == 1
for x, y, z in product(range(3), repeat=3):
    assert eta[x, y, z] == eta[z, x, y]
for x, y in product(range(3), repeat=2):
    assert sum(eta[x, y, z] for z in range(3)) == kappa[x] * p_transition[x][y]
assert min(1 + t * g[x] * g[y] / s
           for x, y in product(range(3), repeat=2)) == 1 - Q(40, 33) * t
assert min(1 + t * (g[x]*g[y] + g[x]*g[z] + g[y]*g[z]) / s
           for x, y, z in product(range(3), repeat=3)) == 1 - Q(230, 99) * t
for singleton in range(3):
    other = [x for x in range(3) if x != singleton]
    assert p_transition[other[0]][singleton] != p_transition[other[1]][singleton]

eu2 = Q(0)
eu3 = Q(0)
ea3 = Q(0)
for colors in product(range(3), repeat=4):
    weight = Q(1)
    for x in colors:
        weight *= kappa[x]
    branch_density = Q(0)
    for z in range(3):
        factor = kappa[z]
        for x in colors:
            factor *= 1 + t * g[z] * g[x] / s
        branch_density += factor
    u = branch_density - 1
    eu2 += weight * u**2
    eu3 += weight * u**3
    a4 = sum(g[colors[i]] * g[colors[j]] / s
             for i, j in combinations(range(4), 2))
    ea3 += weight * a4**3
assert ea3 == 24 + 6 * mu3_squared
assert eu2 == 6*t**4 + 4*mu3_squared*t**6 + mu4**2*t**8
tc_lower = eu2 / 2 - eu3 / 6
six_i2_upper = 3*t**4 - mu3_squared*t**6 + mu4**2*t**8 / (2*(1-16*t**2)**3)
assert six_i2_upper < 3*t**4 - mu3_squared*t**6 + 144*t**8
assert tc_lower - six_i2_upper > 10*t**6
error_scaled = 4737024*t + 50725776*t**2 + Q(1086373952, 6)*t**3
assert error_scaled < 5
assert 2*mu3_squared - 4 - 5 == Q(121169, 11979) > 10

# Quantitative connected-class cutoffs on two rank-one centered squares.
class_cutoffs = []
for name, weights, transition, lam in [
    ("connected_two_state", two_mu, two_root, Q(1, 4)),
    ("connected_weighted", [Q(1, 4), Q(1, 4), Q(1, 2)],
     [[Q(3, 2), Q(1, 2), Q(1)], [Q(1, 2), Q(3, 2), Q(1)],
      [Q(1), Q(1), Q(1)]], Q(1, 16)),
]:
    square = compose(transition, transition, weights)
    centered = [[entry - 1 for entry in row] for row in square]
    assert compose(centered, centered, weights) == [
        [lam * entry for entry in row] for row in centered
    ]
    assert sum(weights[i] * centered[i][i] for i in range(len(weights))) == lam
    assert len(components(square)) == 1
    a0, s0 = min(weights), Q(1, 2)
    c0 = Q(len(weights), 1) / a0 * (1 / a0 - 1)
    cutoff = next(j for j in range(17) if c0 * s0**j <= 1)
    powers = {j: matrix_power(square, j, weights) for j in range(1, 16)}
    checked = 0
    for u, ell in product([1, 2], repeat=2):
        for k, r in product([u, u + 1], [ell, ell + 1]):
            for h in [u + ell + cutoff, u + ell + cutoff + 1]:
                assert density(weights, powers, k, u, r, ell, h) >= 1
                checked += 1
    class_cutoffs.append({
        "host": name, "actual_centered_eigenvalue": str(lam),
        "class_s0": str(s0), "class_a0": str(a0),
        "C0": str(c0), "H": cutoff, "tuples_checked": checked,
    })

# Uniform cloning preserves actual powers and six individual factors.
clone_mu = [Q(1, 4)] * 4
type_mu = [Q(1, 4), Q(1, 4), Q(1, 2)]
types = [0, 1, 2, 2]
type_root = [[Q(3, 2), Q(1, 2), Q(1)],
             [Q(1, 2), Q(3, 2), Q(1)],
             [Q(1), Q(1), Q(1)]]
clone_root = [[type_root[i][j] for j in types] for i in types]
assert all(sum(clone_mu[j] * row[j] for j in range(4)) == 1
           for row in clone_root)
for exponent in range(1, 7):
    original_power = matrix_power(type_root, exponent, type_mu)
    cloned_power = matrix_power(clone_root, exponent, clone_mu)
    assert cloned_power == [[original_power[i][j] for j in types] for i in types]
type_a = compose(type_root, type_root, type_mu)
clone_a = compose(clone_root, clone_root, clone_mu)
type_powers = {j: matrix_power(type_a, j, type_mu) for j in range(1, 6)}
clone_powers = {j: matrix_power(clone_a, j, clone_mu) for j in range(1, 6)}
clone_densities = []
for h in [1, 2, 3, 4]:
    original = density(type_mu, type_powers, 1, 1, 1, 1, h)
    cloned = density(clone_mu, clone_powers, 1, 1, 1, 1, h)
    assert original == cloned
    clone_densities.append(str(cloned))

# Unequal stationary endpoint laws cannot fit the three branch variables.
theta = Q(9, 10)
delta = lambda exponent: (1 - theta**exponent) / 2
endpoint_excess = delta(8) - delta(2) - delta(4)
assert endpoint_excess == Q(3563279, 200000000) > 0

for filename in ["fixed-host-tail.md", "entropy-construction-boundary.md",
                 "long-subdivision-entropy.md", "uniform-host-reduction.md",
                 "pro-advice-audit.md"]:
    source = Path(__file__).with_name(filename).read_text(encoding="utf-8")
    assert source.count(r"\(") == source.count(r"\)")
    assert source.count(r"\[") == source.count(r"\]")
    assert "\\\\(" not in source and "\\\\)" not in source

print(json.dumps({
    "status": "PASS", "arithmetic": "fractions.Fraction, no floating-point logs",
    "density_fixed_base_exponents": [1, 1, 1, 1],
    "density_hosts": hosts,
    "reflection": {"determinant": str(determinant), "quadratic": str(quadratic)},
    "quantitative_connected_class_cutoffs": class_cutoffs,
    "uniform_cloning": {
        "type_weights": [str(x) for x in type_mu], "clone_types": types,
        "root_powers_checked": list(range(1, 7)),
        "density_base_exponents": [1, 1, 1, 1],
        "equal_density_h_1_to_4": clone_densities,
    },
    "stationary_endpoint_triangle": {
        "theta": str(theta), "path_lengths": [2, 4, 8],
        "strict_triangle_excess": str(endpoint_excess),
        "target_counterexample": False,
    },
    "entropy": {
        "alphabet_size": 3, "triple_entries_checked": 27,
        "branch_tuples_checked": 81, "t": str(t),
        "mu3_squared": str(mu3_squared), "mu4": str(mu4),
        "scaled_error_less_than": 5, "analytic_bridge_excess_greater_than": "10*t^6",
        "pair_and_triple_positive": True, "all_pair_marginals_exact": True,
        "nontrivial_deterministic_lumpings": "all three fail",
    },
    "scope": "Fixed exact diagnostics supporting the written analytic arguments; "
             "not an unrestricted proof, theorem novelty check, or Lean validation.",
}, indent=2))
