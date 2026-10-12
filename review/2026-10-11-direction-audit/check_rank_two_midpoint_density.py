"""Fixed Fraction diagnostics for the full rank-two midpoint proof.

No search, optimizer, eigensolve, compiler, network or file writes.
These finite checks are not the proof of the universal statement.
"""

from fractions import Fraction as F
from itertools import product
import importlib.util
import json
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    "spectral_diagnostics", Path(__file__).with_name("check_non_mixing_spectral_density.py"))
spectral = importlib.util.module_from_spec(spec)
spec.loader.exec_module(spectral)


def check_case(fixture, root_eigenvalues, parameters, split=False):
    if fixture == "nonnegative_wedge_coordinates":
        mu = [F(16, 25), F(9, 50), F(9, 50)]
        x = [F(-9, 20), F(32, 15), F(-8, 15)]
        y = [F(3, 5), F(-1, 15), F(-31, 15)]
        expected_coordinates = (F(193, 225), F(32, 225))
    elif fixture == "negative_wedge_coordinate":
        mu = [F(576, 625), F(49, 1250), F(49, 1250)]
        x = [F(-7, 30), F(171, 35), F(3, 5)]
        y = [F(7, 40), F(4, 5), F(-172, 35)]
        expected_coordinates = (-F(464, 175), F(639, 175))
    else:
        raise ValueError(fixture)
    if split:
        mu = [mu[0] / 2, mu[0] / 2, *mu[1:]]
        x = [x[0], *x]
        y = [y[0], *y]
    basis = [[F(1)] * len(mu), x, y]
    for i, fi in enumerate(basis):
        for j, fj in enumerate(basis):
            assert spectral.expectation(mu, [a * b for a, b in zip(fi, fj)]) == (i == j)
    root = [[sum((e * fi[a] * fi[b] for e, fi in zip(root_eigenvalues, basis)), F(0))
             for b in range(len(mu))] for a in range(len(mu))]
    spectral.assert_markov(mu, root)
    for eigenvalue, fi in zip(root_eigenvalues, basis):
        assert [spectral.expectation(mu, [root[a][b] * fi[b] for b in range(len(mu))])
                for a in range(len(mu))] == [eigenvalue * v for v in fi]
    if split:
        zero = [F(1), F(-1), F(0), F(0)]
        assert all(spectral.expectation(mu, [root[a][b] * zero[b] for b in range(len(mu))]) == 0
                   for a in range(len(mu)))
    theta = [e * e for e in root_eigenvalues]
    p, q = theta[1:]
    assert 1 >= p >= q > 0
    moment = spectral.moments(mu, basis)
    a, b, c, d = (moment[1][1][1], moment[1][1][2],
                  moment[1][2][2], moment[2][2][2])
    eta, zeta = b * b - a * c, c * c - b * d
    assert (eta, zeta) == expected_coordinates
    square_kernel = spectral.compose(mu, root, root)
    wedge = sum((mu[i] * mu[j] * square_kernel[i][j]
                 * (x[i] * y[j] - y[i] * x[j]) ** 2
                 for i, j in product(range(len(mu)), repeat=2)), F(0)) / 2
    assert wedge == 1 - p * eta - q * zeta and wedge >= 0
    maximum_power = max(max(k, u + 1) for k, u in parameters)
    powers = {v: spectral.power(mu, square_kernel, v) for v in range(1, maximum_power + 1)}
    gap = (abs(root_eigenvalues[1]) - abs(root_eigenvalues[2])) ** 2
    assert gap <= p
    rows = []
    for k, u in parameters:
        assert k >= u >= 3
        labels = (k, u, u - 1, 2, u + 1, u)
        indices, h = spectral.pair_matrix(theta, moment, u + 1, u)
        value = spectral.density(mu, powers, labels)
        assert value == spectral.contraction(theta, indices, h, labels)
        vx = (p ** (k + 2 * u - 1) * q ** 2
              + p ** (k + u + 2) * q ** (u - 1)
              + p ** (k + u + 1) * q ** u
              + p ** (2 * u + 1) * q ** k)
        vy = (p ** (u - 1) * q ** (k + u + 2)
              + p ** 2 * q ** (k + 2 * u - 1)
              + p ** k * q ** (2 * u + 1)
              + p ** u * q ** (k + u + 1))
        xv = lambda v: p ** v * a + q ** v * c
        yv = lambda v: p ** v * b + q ** v * d
        xproduct, yproduct = xv(u + 1) * xv(u), yv(u + 1) * yv(u)
        xchannel, ychannel = b ** 2 * xproduct, c ** 2 * yproduct
        assert xproduct == (p ** u * abs(root_eigenvalues[1]) * a
                           + q ** u * abs(root_eigenvalues[2]) * c) ** 2 + gap * (p * q) ** u * a * c
        assert yproduct == (p ** u * abs(root_eigenvalues[1]) * b
                           + q ** u * abs(root_eigenvalues[2]) * d) ** 2 + gap * (p * q) ** u * b * d
        ratio, credit = q / p, p ** (k + 2 * u + 1)
        assert credit * ratio ** 2 <= vx <= 4 * credit * ratio ** 2
        assert credit * ratio ** (2 * u + 1) <= vy <= 4 * credit * ratio ** (2 * u + 1)
        channel_sum = F(0)
        others = F(0)
        occurrences = [0, 0]
        for row, (i, j) in enumerate(indices):
            for col, (s, t) in enumerate(indices):
                weight = theta[i] ** k * theta[j] ** u * theta[s] ** (u - 1) * theta[t] ** 2
                pair = ((i, j), (s, t))
                is_x = pair in [((1, 1), (1, 2)), ((1, 1), (2, 1)),
                                ((1, 2), (1, 1)), ((2, 1), (1, 1))]
                is_y = pair in [((2, 2), (1, 2)), ((2, 2), (2, 1)),
                                ((1, 2), (2, 2)), ((2, 1), (2, 2))]
                if is_x or is_y:
                    assert h[row][col] == (xchannel if is_x else ychannel)
                    occurrences[int(is_y)] += 1
                    channel_sum += weight * h[row][col]
                else:
                    assert h[row][col] >= 0
                    others += weight * h[row][col]
        assert occurrences == [4, 4]
        assert channel_sum == vx * xchannel + vy * ychannel
        assert value == others + channel_sum
        assert h[indices.index((0, 0))][indices.index((1, 1))] == p ** u
        assert h[indices.index((1, 1))][indices.index((0, 0))] == p ** u
        assert others >= 1 + p ** (2 * u + 1) + p ** (k + 2 * u)
        branch = "no_negative_channel"
        if eta >= 0 and zeta >= 0:
            branch = "joint_wedge"
            assert p * eta + q * zeta <= 1
            actual_loss = vx * max(-xchannel, F(0)) + vy * max(-ychannel, F(0))
            certified_loss = gap * (p * q) ** u * max(vx / p ** 2, vy / q ** 2) / 4
            assert actual_loss <= certified_loss <= p ** (k + 4 * u)
        elif xchannel < 0:
            branch = "X_paid_by_Y"
            assert a * c < 0 and b * d >= 0 and ychannel > 0 and p > q
            z = -a / c
            assert ratio ** (u + 1) < z < ratio ** u
            assert -xproduct <= p ** (2 * u + 1) * c ** 2 * ratio ** (2 * u) * (1 - ratio) ** 2 / 4
            assert yproduct >= p ** (2 * u + 1) * b ** 2
            assert -vx * xchannel <= vy * ychannel
        elif ychannel < 0:
            assert a * c > 0 and b * d < 0 and xchannel > 0 and p > q
            tau, z = a / c, -d / b
            tau0 = ratio ** (u - 1) * (1 - ratio)
            assert ratio ** (-u) < z < ratio ** (-u - 1)
            assert -yproduct <= p ** (2 * u + 1) * b ** 2 * (1 - ratio) ** 2 / (4 * ratio)
            assert tau0 <= ratio / 4
            if tau >= tau0:
                branch = "Y_paid_by_X"
                assert -vy * ychannel <= vx * xchannel
            else:
                branch = "small_tau_wedge"
                assert p * (ratio - tau) * c ** 2 + p * (1 + ratio * z) * b ** 2 <= 1
                assert b ** 2 * c ** 2 <= ratio ** (u - 2) / (3 * p ** 2)
                assert -vy * ychannel <= p ** (k + 4 * u) / 3
        assert channel_sum >= -p ** (k + 4 * u)
        lower_bound = 1 + p ** (2 * u + 1) + p ** (k + 2 * u) - p ** (k + 4 * u)
        assert value >= lower_bound > 1
        if fixture == "negative_wedge_coordinate" and u == 5:
            assert ychannel < 0 and branch == "Y_paid_by_X"
        rows.append({"k": k, "u": u, "checked_branch": branch,
                     "negative_channel_count": int(xchannel < 0) + int(ychannel < 0),
                     "F_exact": str(value), "theorem_lower_bound_exact": str(lower_bound),
                     "signed_two_channel_sum_exact": str(channel_sum)})
    return {"fixture": fixture, "states": len(mu), "inactive_zero_mode": split,
            "root_eigenvalues": list(map(str, root_eigenvalues)),
            "minimum_root": str(min(map(min, root))), "eta": str(eta), "zeta": str(zeta),
            "wedge_exact": str(wedge), "fixed_midpoint_checks": rows}


if __name__ == "__main__":
    print(json.dumps({"method": "fixed_fraction_only_algebraic_diagnostics",
                      "cases": [
                          check_case("nonnegative_wedge_coordinates", [F(1), F(9, 10), F(3, 5)], [(4, 3), (7, 4)]),
                          check_case("nonnegative_wedge_coordinates", [F(1), F(9, 10), F(3, 5)], [(4, 3)], split=True),
                          check_case("nonnegative_wedge_coordinates", [F(1), F(9, 10), F(9, 10)], [(4, 3)]),
                          check_case("nonnegative_wedge_coordinates", [F(1), F(1), F(1)], [(4, 3)]),
                          check_case("nonnegative_wedge_coordinates", [F(1), -F(1, 10), -F(1, 20)], [(4, 3)]),
                          check_case("negative_wedge_coordinate", [F(1), F(9, 10), F(3, 4)], [(6, 5), (8, 5)]),
                          check_case("negative_wedge_coordinate", [F(1), F(9, 10), F(3, 4)], [(6, 5)], split=True)],
                      "not_every_analytical_branch_has_a_fixed_fixture": True,
                      "numerical_search": False, "lean_validation": False,
                      "unrestricted_density_proved": False}, indent=2))
