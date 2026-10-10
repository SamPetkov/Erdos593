"""Independent exact root review of the uniform-complement mechanism.

This file does not import an author verifier.  It reconstructs ordinary
transition matrices and computes compressed-field products directly, as a
check separate from the author's scalar kernel expansion.  No optimizer
is run and no unrestricted sign certificate is claimed.
"""
from fractions import Fraction as F
from itertools import product
from pathlib import Path
import hashlib
import json

HERE = Path(__file__).resolve().parent


def mm(a, b):
    return [[sum(u*v for u, v in zip(row, col))
             for col in zip(*b)] for row in a]


def identity(n):
    return [[F(i == j) for j in range(n)] for i in range(n)]


def power(a, s):
    out = identity(len(a))
    for _ in range(s):
        out = mm(out, a)
    return out


def trace(a):
    return sum(a[i][i] for i in range(len(a)))


def field(q, transition, t):
    n = len(q)
    # q is an ordinary Euclidean orthogonal projection.  The original
    # relative kernel equals n times the transition matrix.
    weighted = [[q[i][j]*n*transition[t][j] for j in range(n)]
                for i in range(n)]
    return mm(weighted, q)


def star(q, transitions):
    n = len(q)
    return sum(trace(mm(mm(field(q, transitions[0], t),
                           field(q, transitions[1], t)),
                        field(q, transitions[2], t)))
               for t in range(n))/n


def ser(x):
    if isinstance(x, F):
        return str(x)
    if isinstance(x, dict):
        return {str(k): ser(v) for k, v in x.items()}
    if isinstance(x, (list, tuple)):
        return [ser(v) for v in x]
    return x


def uniform_flat_check(p, signs, xyz):
    n = len(p)
    q = [[F(i == j)-F(signs[i]*signs[j], n)
          for j in range(n)] for i in range(n)]
    assert all(sum(row) == 1 for row in p)
    assert all(p[i][j] == p[j][i] >= 0 for i, j in product(range(n), repeat=2))
    assert mm(q, q) == q and trace(q) == n-1
    bp = [power(p, 2*s) for s in xyz]
    actual = star(q, bp)
    # Scalar identity independently assembled with all n^-2 weights.
    ell = n*sum(bp[0][a][t]*bp[1][a][t]*bp[2][a][t]
                for a, t in product(range(n), repeat=2))
    taus = [trace(power(p, 2*(xyz[i]+xyz[j])))
            for i, j in ((0, 1), (0, 2), (1, 2))]
    assert actual == (n-3)*ell+sum(taus)-1
    assert ell >= max(taus) >= 1
    if n >= 3:
        assert actual >= n-1+(n-3)*(max(taus)-1)+sum(t-1 for t in taus)
    return actual, ell, taus, q, bp


def run():
    n = 13
    p0 = identity(n)
    for i in range(n-1):
        p0[i][i] -= F(1, 64)
        p0[i+1][i+1] -= F(1, 64)
        p0[i][i+1] = p0[i+1][i] = F(1, 64)
    delta = F(1, 1024)
    p = [[(1-delta)*p0[i][j]+delta/n for j in range(n)]
         for i in range(n)]
    actual, ell, taus, q, bp = uniform_flat_check(
        p, [(-1)**i for i in range(n)], (1, 2, 3))
    saved = json.loads((HERE/'continuation6_search_codimension_one_checks.json').read_text())
    assert actual == F(saved['J']) and ell == F(saved['L'])
    assert taus == [F(saved['pair_traces'][str(s)]) for s in (3, 4, 5)]
    assert 12*bp[0][0][0] == F(saved['actual_first_field_cap_lower']) > 10
    m0 = field(q, bp[0], 0)
    x0 = [[m0[i][j]-q[i][j] for j in range(n)] for i in range(n)]
    cubic = trace(mm(mm(x0, x0), x0))
    assert cubic == F(saved['actual_centered_cubic_at_0']) > 0
    # Reconstruct the complete actual 26-state root in ordinary coordinates.
    alpha = F(1, 24576)
    states = list(product(range(n), (-1, 1)))
    transition = [[(p[i][j]+sg*tg*alpha*q[i][j])/2
                   for j, tg in states] for i, sg in states]
    assert all(sum(row) == 1 for row in transition)
    assert min(map(min, transition)) > 0
    t = [[2*n*x for x in row] for row in transition]
    density_p = 1/max(map(max, t))
    assert density_p == F(saved['p']) == F(65536, 837933)
    assert min(map(min, t)) == F(saved['min_T']) == F(23, 24576)
    actual_square = mm(transition, transition)
    expected_square = [[(bp[0][i][j]+sg*tg*alpha**2*q[i][j])/2
                        for j, tg in states] for i, sg in states]
    assert actual_square == expected_square

    controls = []
    for size, ordinary, label in (
        (1, identity(1), 'rank_zero'),
        (2, [[F(3, 4), F(1, 4)], [F(1, 4), F(3, 4)]], 'two_state_rank_one'),
        (4, identity(4), 'disconnected_identity'),
        (4, [[F(j == (i ^ 1)) for j in range(4)] for i in range(4)],
         'nonnegative_root_with_disconnected_square'),
        (5, [[F(1, 5)]*5 for _ in range(5)], 'refresh_equality'),
    ):
        j, _, _, _, _ = uniform_flat_check(ordinary, [(-1)**i for i in range(size)], (1, 2, 3))
        if size in (1, 2) or label == 'refresh_equality':
            assert j == size-1
        controls.append({'case': label, 'states': size, 'J': j})

    line_controls = []
    # Two diagonal eigenspaces suffice to audit the arbitrary-dimension
    # line example without generating a 730 by 730 matrix.
    for m in (2, 9):
        d = m**3+1
        mu = [F(1, m+1), F(m, m+1)]
        tv = [F(1), -F(1, m)]
        rho = F(1023, 1024)**2
        assert sum(w*t for w, t in zip(mu, tv)) == 0
        assert sum(w*t*t for w, t in zip(mu, tv)) == F(1, m)
        for xyz in ((1, 1, 1), (1, 2, 3), (1, 2, 8)):
            terms = []
            for t in tv:
                positive, negative = F(1), F(1)
                for s in xyz:
                    positive *= 1+m*rho**s*t
                    negative *= 1-rho**s*t
                terms.append(positive+m**3*negative)
            direct = sum(w*v for w, v in zip(mu, terms))
            pair_sum = sum(rho**(xyz[i]+xyz[j]) for i, j in ((0, 1), (0, 2), (1, 2)))
            assert direct == d+m*(m+1)*pair_sum > d
            line_controls.append({'m': m, 'rank': d, 'xyz': xyz, 'J': direct})
        if m == 9:
            assert 1+m*rho > F(97, 10)
            assert (F(97, 10)-4)**2 > 32
            assert (d+rho*(m-m**3)) != (d-rho*(m-m**3)/m)

    names = ['continuation6_search_codimension_one.md',
             'continuation6_search_codimension_one_verify.py',
             'continuation6_search_codimension_one_checks.json',
             'continuation6_cubic_subspace.md']
    out = {
        'status': 'PASS', 'reviewer': '/root',
        'scope': 'Exact uniform-complement and zero-cubic-line checks; no unrestricted U, C, or F proof.',
        'independent_arithmetic': 'Ordinary stochastic matrices, ambient compressed-field traces, no author imports.',
        'source_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'reviewed_files': {name: hashlib.sha256((HERE/name).read_bytes()).hexdigest() for name in names},
        'uniform_rank_twelve': {'J': actual, 'L': ell, 'pair_traces': taus,
            'actual_centered_cubic': cubic, 'actual_cap_lower': 12*bp[0][0][0],
            'fine_states': 26, 'p': density_p, 'actual_square_identity': True,
            'full_F_enumerated': False},
        'boundary_controls': controls, 'unbounded_cap_zero_cubic_line': line_controls,
        'proof_checks': [
            'Original uniform n factors retained in three-, two-, one-, and zero-identity terms.',
            'The Schur-product step pairs two PSD operators only; it does not assert positivity of a triple operator trace.',
            'Nonnegative square, all common powers, rank n-1, and separate n=1,2 cases retained.',
            'Fine actual root, original fine measure, positive p, and square transport reconstructed independently.',
            'The two-state diagonal line has variable trace, zero cubic trace, and exact pair surplus; its original-law projection realization is proved in the note.',
            'Coarse density for the 26-state example uses the explicitly named prior convex-TP2 theorem; the full F was not independently enumerated here.',
        ],
    }
    (HERE/'continuation6_root_review.json').write_text(json.dumps(ser(out), indent=2)+'\n')
    print(json.dumps({'status': 'PASS', 'uniform_rank': 12, 'boundary_controls': len(controls), 'diagonal_line_controls': len(line_controls)}))


if __name__ == '__main__':
    run()
