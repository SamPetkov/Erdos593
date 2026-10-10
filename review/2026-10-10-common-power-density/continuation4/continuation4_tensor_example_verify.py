"""Exact finite certificate for the noncentral rank-two projection example.

The proof is in continuation4_tensor_example.md.  Every computation here uses
the original probability measure and Python's standard-library Fraction type.
No numerical eigenvalue or approximate density comparison is used.
"""
from fractions import Fraction as F
from pathlib import Path
import hashlib
import json
from continuation4_projection_verify import (
    mat, plus, scale, eye, ones, mm, power, trace, markov, proj,
    charpoly, polymul, host_checks, serialize,
)


def main():
    pi = [F(1, 2), F(1, 4), F(1, 8), F(1, 8)]
    V = [[F(x) for x in row] for row in ((1, 0), (-1, 1), (1, -1), (0, 1))]
    gram = [[sum(pi[i] * V[i][a] * V[i][b] for i in range(4))
             for b in range(2)] for a in range(2)]
    assert gram == mat(((F(7, 8), -F(3, 8)), (-F(3, 8), F(1, 2))))
    inverse = scale(F(1, 19), mat(((32, 24), (24, 56))))
    assert [[sum(gram[a][b] * inverse[b][c] for b in range(2))
             for c in range(2)] for a in range(2)] == mat(((1, 0), (0, 1)))
    Q = scale(F(1, 19), mat(((32, -8, 8, 24), (-8, 40, -40, 32),
                             (8, -40, 40, -32), (24, 32, -32, 56))))
    reconstructed = [[sum(V[i][a] * inverse[a][b] * V[j][b]
                          for a in range(2) for b in range(2))
                      for j in range(4)] for i in range(4)]
    assert Q == reconstructed and proj(Q, pi) and trace(Q, pi) == 2
    Qone = [sum(pi[j] * Q[i][j] for j in range(4)) for i in range(4)]
    assert Qone == [F(x, 19) for x in (18, 5, -5, 23)]
    assert Qone != [F(0)] * 4 and Qone != [F(1)] * 4
    negative_triangles = [Q[0][1] * Q[1][3] * Q[3][0],
                          Q[0][2] * Q[2][3] * Q[3][0]]
    assert negative_triangles == [-F(6144, 6859)] * 2

    S0 = mat(((F(7, 4), F(1, 4), F(1, 4), F(1, 4)),
              (F(1, 4), F(7, 2), 0, 0),
              (F(1, 4), 0, 7, 0), (F(1, 4), 0, 0, 7)))
    S = plus(scale(F(15, 16), S0), scale(F(1, 16), ones(4)))
    H = scale(F(1, 64), Q)
    beta = F(1, 4096)
    assert markov(S0, pi) and markov(S, pi)
    assert mm(H, H, pi) == scale(beta, Q)
    commutator = plus(mm(S, Q, pi), scale(-1, mm(Q, S, pi)))
    assert commutator[0][1] == -F(157, 1216)

    root_expected = [F(1)]
    for lam in (F(1), F(105, 128), F(105, 128), F(45, 64)):
        root_expected = polymul(root_expected, [F(1), -lam])
    assert charpoly(S, pi) == root_expected
    x, y = F(105, 128) ** 2, F(45, 64) ** 2
    A = mm(S, S, pi)
    P = scale(1 / (x - y), plus(plus(A, scale(-y, eye(pi))),
                                scale(-(1 - y), ones(4))))
    assert proj(P, pi) and trace(P, pi) == 2
    assert all(sum(pi[j] * P[i][j] for j in range(4)) == 0 for i in range(4))
    common_cone_kernel = scale(1 / (1 - y), plus(A, scale(-y, eye(pi))))
    assert markov(common_cone_kernel, pi)
    cone_expected = [F(1)]
    for lam in (F(1), (x - y) / (1 - y), (x - y) / (1 - y), F(0)):
        cone_expected = polymul(cone_expected, [F(1), -lam])
    assert charpoly(common_cone_kernel, pi) == cone_expected
    assert sum(p ** -2 for p in pi) == 148

    tuples = ((2, 2, 1, 1, 1), (1, 1, 3, 3, 1), (2, 2, 3, 3, 5))
    record, Af, mu = host_checks('weighted_noncentral_noncommuting_rank_two',
                                 pi, S, H, Q, beta, tuples)
    assert record['p'] == F(76, 507)
    assert record['min_T'] == F(9, 304) and record['max_T'] == F(507, 76)
    assert min(map(min, record['W'])) == F(3, 676)
    assert max(map(max, record['W'])) == 1
    assert record['max_A'] == F(861135, 155648)
    assert record['p'] < F(1, 4) and record['max_A'] > 4
    actual_expected = [F(1)]
    for lam in (F(1), x, x, y, beta, beta, F(0), F(0)):
        actual_expected = polymul(actual_expected, [F(1), -lam])
    assert charpoly(Af, mu) == actual_expected
    for row in record['rows']:
        N = sum(row['edge_exponents'])
        lower = 1 + 147 * y ** N + row['proved_lower_surplus']
        assert row['F_coarse'] >= 1 + 147 * y ** N
        assert row['F_fine'] >= lower > 1
        _, u, r, _, _ = row['tuple']
        reflection_exponent = 2 * (u + r)
        coarse_trace = trace(power(A, reflection_exponent, pi), pi)
        fine_trace = trace(power(Af, reflection_exponent, mu), mu)
        assert coarse_trace == 1 + 2 * x ** reflection_exponent + y ** reflection_exponent
        assert fine_trace == coarse_trace + 2 * beta ** reflection_exponent
        improved_trace_bound = coarse_trace + row['proved_lower_surplus']
        assert row['F_coarse'] >= coarse_trace
        assert row['F_fine'] >= improved_trace_bound > fine_trace
        assert row['cycle_exponents'][4] == reflection_exponent
        row['N'] = N
        row['coarse_surplus_bound'] = 147 * y ** N
        row['full_proved_lower_bound'] = lower
        row['coarse_reflection_trace'] = coarse_trace
        row['fine_reflection_trace'] = fine_trace
        row['improved_trace_bound'] = improved_trace_bound
        row['extra_six_cycle_terms'] = improved_trace_bound - fine_trace
    assert record['rows'][0]['cycle_exponents'] == [5, 6, 5, 4, 6, 7, 7]
    assert record['rows'][0]['N'] == 10

    out = {
        'scope': 'Restricted projection-channel boundary theorem; not an unrestricted target proof.',
        'source_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'utility_source_sha256': hashlib.sha256(Path('continuation4_projection_verify.py').read_bytes()).hexdigest(),
        'original_weighted_gram': gram, 'gram_inverse': inverse,
        'Q_one': Qone, 'negative_triangle_products': negative_triangles,
        'commutator_entry_01': commutator[0][1],
        'root_charpoly': root_expected, 'square_charpoly': actual_expected,
        'entire_centered_square_spectrum': [[x, 2], [y, 1], [beta, 2], [F(0), 2]],
        'coarse_centered_projection': P, 'common_cone_kernel': common_cone_kernel,
        'min_W': F(3, 676), 'host': record,
        'all_exact_checks_passed': True,
    }
    Path('continuation4_tensor_example_checks.json').write_text(json.dumps(serialize(out), indent=2) + '\n')
    print(json.dumps(serialize({
        'p': record['p'], 'min_W': F(3, 676), 'max_A': record['max_A'],
        'commutator_entry_01': commutator[0][1], 'host_tuple_count': len(tuples),
        'all_exact_checks_passed': True,
    })))


if __name__ == '__main__':
    main()
