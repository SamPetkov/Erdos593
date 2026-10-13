"""One exact binary certificate check, not a universal density proof."""

from fractions import Fraction as Q
from itertools import product
import json


def compose(left, right):
    return [[sum(Q(1, 2) * left[i][z] * right[z][j]
                 for z in range(2)) for j in range(2)] for i in range(2)]


def power(kernel, exponent):
    result = [[Q(2 if i == j else 0) for j in range(2)] for i in range(2)]
    for _ in range(exponent):
        result = compose(result, kernel)
    return result


signs = (-1, 1)
root = [[1 + Q(1, 2) * x * y for y in signs] for x in signs]
assert all(entry > 0 for row in root for entry in row)
assert all(sum(row) / 2 == 1 for row in root)
assert root[0][1] == root[1][0]

k = u = r = 4
l = 2
h = 1
theta = Q(1, 4)
ks = {j: power(root, 2 * j) for j in {k, u, r, l, h, r+h, r+u, r+u+h}}
for j, kernel in ks.items():
    assert kernel == [[1 + theta**j * x*y for y in signs] for x in signs]

density = sum(Q(1, 16) * ks[k][a][b] * ks[r+h][a][c] * ks[u][a][d]
              * ks[r][b][c] * ks[u][b][d] * ks[l][c][d]
              for a, b, c, d in product(range(2), repeat=4))
triangle = sum(Q(1, 4) * ks[l][c][d] * ks[r+u][c][d] * ks[r+u+h][c][d]
               for c, d in product(range(2), repeat=2))
assert density == 1 + sum(theta**j for j in (10, 11, 12, 13, 14, 15, 17))

gamma = theta**4
b = gamma**2
a = theta**2
t = theta
assert triangle - 1 == a*(1+t)*b + t*b*b
best_floor = min(entry for row in power(root, k) for entry in row)
assert best_floor == Q(15, 16)
assert (1-best_floor)**2 == gamma

# q0 = 1-sqrt(1-a^2) lies in [a^2/2,a^2], by squaring
# nonnegative quantities. These symbolic bounds avoid floating-point roots.
q0_lower = a*a/2
q0_upper = a*a
floor_loss_lower = gamma*(1-t)*q0_lower*(1-b*b)/2
assert floor_loss_lower == Q(3, 2**20)*(1-Q(1, 2**32))
assert floor_loss_lower > triangle-1
assert 7*2**30 - 2**18 - 3 > 0

# When c != x, every product under the input square root is 1-gamma^2,
# and the Ku row sums to one. Thus Hin^2 = 1-b exactly.
for d in range(2):
    assert all(ks[r][z][0]*ks[r][z][1] == 1-b for z in range(2))
    assert sum(Q(1, 2)*ks[u][z][d] for z in range(2)) == 1
    assert ks[r+u][0][d]*ks[r+u][1][d]-(1-b) == b*(1-b)

input_loss_upper = (1-t)*q0_upper*b*(1-b)/2
assert input_loss_upper <= Q(3, 160)*(triangle-1)
assert input_loss_upper < triangle-1

print(json.dumps({
    "scope": "one exact uniform binary actual root; already covered host",
    "tuple_k_u_r_l_h": [k, u, r, l, h],
    "all_matrix_powers_from_original_weighted_composition": True,
    "density": str(density),
    "triangle_D": str(triangle),
    "largest_actual_root_floor": str(best_floor),
    "root_floor_loss_lower": str(floor_loss_lower),
    "triangle_surplus": str(triangle-1),
    "largest_root_floor_certificate_fails": True,
    "input_hellinger_loss_upper": str(input_loss_upper),
    "input_loss_to_surplus_ratio_upper": "3/160",
    "input_hellinger_certificate_passes": True,
    "unrestricted_theorem_proved": False,
    "lean_validation": False
}, indent=2))
