"""Independent exact audit: original-law fields, inverse filter, cycle space.

No author verifier is imported. The cover audit enumerates the three
binary cycle-space planes, rather than completing seven-character flows
along a spanning tree. All saved interval budgets are checked exactly.
"""
from collections import defaultdict, deque
from fractions import Fraction as Q
from itertools import product, permutations
from pathlib import Path
import hashlib
import json
import sys
import time

sys.set_int_max_str_digits(0)
HERE = Path(__file__).resolve().parent


def eye(n):
    return [[Q(i == j) for j in range(n)] for i in range(n)]


def mm(a, b):
    return [[sum((x*y for x, y in zip(row, col)), Q(0))
             for col in zip(*b)] for row in a]


def mp(a, k):
    out = eye(len(a))
    for _ in range(k):
        out = mm(out, a)
    return out


def tr(a):
    return sum((a[i][i] for i in range(len(a))), Q(0))


def inverse(a):
    """Ordinary rational row reduction, separate from fraction-free adjugates."""
    n = len(a)
    b = [list(map(Q, row)) + eye(n)[i] for i, row in enumerate(a)]
    determinant = Q(1)
    for j in range(n):
        pivot = next(i for i in range(j, n) if b[i][j])
        if pivot != j:
            b[pivot], b[j] = b[j], b[pivot]
            determinant = -determinant
        q = b[j][j]
        determinant *= q
        b[j] = [x/q for x in b[j]]
        for i in range(n):
            if i != j:
                q = b[i][j]
                b[i] = [x-q*y for x, y in zip(b[i], b[j])]
    assert [row[:n] for row in b] == eye(n)
    result = [row[n:] for row in b]
    assert mm(a, result) == eye(n)
    return result, determinant


def rational(x):
    return str(x.numerator) + '/' + str(x.denominator)


def parse_rational(x):
    return Q(int(x['numerator']), int(x['denominator']))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def weighted_fields():
    pi = [Q(1,5), Q(1,4), Q(1,4), Q(3,10)]
    n = len(pi)
    f = [1, -1, 1, -1]
    q = [[Q(i == j)/pi[i]-f[i]*f[j] for j in range(n)] for i in range(n)]
    qo = [[q[i][j]*pi[j] for j in range(n)] for i in range(n)]
    assert mm(qo, qo) == qo and tr(qo) == 3
    raw = [[[qo[a][i]*qo[i][b]/pi[i] for b in range(n)]
            for a in range(n)] for i in range(n)]
    assert [[sum(pi[i]*raw[i][a][b] for i in range(n))
             for b in range(n)] for a in range(n)] == qo
    v = [Q(-4), Q(-4), Q(-1), Q(41,6)]
    assert sum(pi[i]*v[i] for i in range(n)) == 0
    norm = sum(pi[i]*v[i]**2 for i in range(n))
    third = sum(pi[i]*v[i]**3 for i in range(n))
    raw_cubic = sum(x**3 for x in v)-3*third
    assert (norm, third, raw_cubic) == (Q(515,24), Q(9601,144), -Q(4295,432))
    rank_one = [[pi[j]*(1+v[i]*v[j]/128) for j in range(n)] for i in range(n)]
    disconnected = [[Q(2,5),0,0,Q(3,5)], [0,0,1,0],
                    [0,1,0,0], [Q(2,5),0,0,Q(3,5)]]
    roots = {'negative_cubic': rank_one, 'refresh_equality': [pi[:]]*n,
             'identity_disconnected': eye(n),
             'zero_and_stationary_modes': disconnected}
    a = [1/p-n for p in pi]
    delta = max(map(abs, a))
    assert delta == 1
    m, cap = n-2-delta, n+delta-1
    assert delta*delta*cap <= 8*(n-3)*m and m > 0
    records = []
    for name, p in roots.items():
        assert all(sum(row) == 1 for row in p)
        assert min(map(min,p)) >= 0
        assert all(pi[i]*p[i][j] == pi[j]*p[j][i]
                   for i in range(n) for j in range(n))
        for triple in ((1,1,1), (1,2,3), (2,2,5)):
            xs = sorted(triple)
            needed = set(xs) | {xs[i]+xs[j] for i in range(3) for j in range(i+1,3)}
            powers = {s:mp(p,2*s) for s in needed}
            kernels = {s:[[powers[s][i][j]/pi[j] for j in range(n)] for i in range(n)]
                       for s in needed}
            fields = {s:[[[sum(powers[s][t][i]*raw[i][b][c] for i in range(n))
                            for c in range(n)] for b in range(n)] for t in range(n)]
                      for s in set(xs)}
            centered = {s:[[[fields[s][t][b][c]-qo[b][c] for c in range(n)]
                           for b in range(n)] for t in range(n)] for s in set(xs)}
            x,y,z = xs
            direct = sum(pi[t]*pi[i]*pi[j]*pi[k]*kernels[x][t][i]*kernels[y][t][j]
                         *kernels[z][t][k]*q[i][j]*q[j][k]*q[k][i]
                         for t,i,j,k in product(range(n),repeat=4))
            field_value = sum(pi[t]*tr(mm(mm(fields[x][t],fields[y][t]),fields[z][t]))
                              for t in range(n))
            assert direct == field_value
            cubic = sum(pi[t]*tr(mm(mm(centered[x][t],centered[y][t]),centered[z][t]))
                        for t in range(n))
            h = [[(kernels[x][i][t]-1)*(kernels[y][i][t]-1)*(kernels[z][i][t]-1)
                  for t in range(n)] for i in range(n)]
            h11 = sum(pi[i]*pi[t]*h[i][t] for i,t in product(range(n),repeat=2))
            ha1 = sum(pi[i]*pi[t]*a[i]*h[i][t] for i,t in product(range(n),repeat=2))
            haa = sum(pi[i]*pi[t]*a[i]*a[t]*h[i][t]
                      for i,t in product(range(n),repeat=2))
            assert cubic == (n-3)*h11+ha1
            assert cubic >= -haa/(4*(n-3))
            sig = {s:tr(powers[s])-1 for s in needed}
            lower = m*sig[x+z] + (m-delta**2*cap/(8*(n-3)))*(sig[x+y]+sig[y+z])
            assert direct-3 >= lower >= 0
            assert (direct == 3) == (name == 'refresh_equality')
            if name == 'negative_cubic':
                theta = (norm/128)**2
                assert cubic == theta**(x+y+z)*third*raw_cubic/norm**3 < 0
            records.append({'root':name,'triple':xs,'J':rational(direct),
                            'centered_cubic':rational(cubic),
                            'proved_surplus_lower':rational(lower)})
    return {'original_pi':list(map(rational,pi)), 'delta':'1',
            'negative_cubic_source':{'v':list(map(rational,v)),'root':'1+v tensor v/128',
                                     'E_v3':rational(third),'sum_v3_minus_3E':rational(raw_cubic)},
            'checks':records}


def ac_inverse_filter():
    saved = json.loads((HERE/'continuation7_opt_ac_exact_checks.json').read_text())
    diagonal = [1480000000000,2450,602,20500,385,152,780,445000,611000000,1480000000000]
    adjacent = [188000,321000,12800000,5990000,6520,801,97700,41200000,9200000000]
    n = len(diagonal)
    g = [[Q(0)]*n for _ in range(n)]
    for i,v in enumerate(diagonal): g[i][i] = Q(v)
    for i,v in enumerate(adjacent): g[i][i+1] = g[i+1][i] = Q(v)
    g[3][9] = g[9][3] = Q(4310000000)
    rows = list(map(sum,g))
    mass = sum(rows)
    mu = [x/mass for x in rows]
    p = [[Q(4095,4096)*g[i][j]/rows[i]+mu[j]/4096 for j in range(n)] for i in range(n)]
    assert mu == list(map(parse_rational,saved['original_mu']))
    assert all(sum(row) == 1 for row in p)
    assert all(mu[i]*p[i][j] == mu[j]*p[j][i] for i in range(n) for j in range(n))
    assert min(map(min,p)) > 0
    _,det_p = inverse(p)
    assert det_p != 0
    t = [[p[i][j]/mu[j] for j in range(n)] for i in range(n)]
    normalizer = min(mu)/2
    assert normalizer == parse_rational(saved['p'])
    assert 0 < min(map(min,t))*normalizer <= max(map(max,t))*normalizer <= Q(1,2)
    kernels = {}
    for s in (1,2,8):
        a = mp(p,2*s)
        kernels[s] = [[a[i][j]/mu[j] for j in range(n)] for i in range(n)]
    d = [[sum(mu[b]*mu[e]*kernels[8][a][b]*kernels[1][a][e]
              *kernels[2][b][c]*kernels[1][b][e]*kernels[1][c][e]
              for b,e in product(range(n),repeat=2)) for c in range(n)] for a in range(n)]
    c = [[1024*p[i][j]-Q(i==j) for j in range(n)] for i in range(n)]
    inv,det_c = inverse(c)
    assert det_c != 0
    assert all(mu[i]*inv[i][j] == mu[j]*inv[j][i] for i in range(n) for j in range(n))
    h = mm(inv,inv)
    norm = tr(h)
    assert norm > 0
    h = [[x/norm for x in row] for row in h]
    assert tr(h) == 1 and mm(h,p) == mm(p,h)
    filtered = sum(mu[i]*h[i][j]*d[j][i] for i,j in product(range(n),repeat=2))
    assert filtered == parse_rational(saved['filtered_ac_average'])
    assert -Q(1,10000) < filtered < -Q(1,20000)
    lower = p[0][0]**32/mu[0]**2
    assert lower == parse_rational(saved['full_F_lower_bound']) and lower > 4
    return {'method':'ordinary Fraction transitions; all100 literal five-edge source entries; normalized inverse square',
            'filtered_ac_average':rational(filtered),'full_F_lower':rational(lower),
            'original_mu_preserved':True,'root_invertible':True,
            'checked_author_json_sha256':sha(HERE/'continuation7_opt_ac_exact_checks.json')}


EDGES = [(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]
CHAR = [0,3,5,6,1,2,4]
DEG = [0,128,10,4,6,8,6]
FIXED = [0,9,4,1,4,1]


def decode(x):
    return Q(int(x[0],16),1<<x[1])


def poly_decode(p):
    return {int(k):decode(v) for k,v in p.items()}


def poly_mul(a,b):
    c = defaultdict(Q)
    for i,x in a.items():
        for j,y in b.items():c[i+j] += x*y
    return {i:x for i,x in c.items() if x}


def cycle_plane_polynomial(degree, triple, moments):
    identity = tuple(range(degree))
    perms = [identity]*3+list(triple)
    edges = [(4*s+v,4*perms[e][s]+w,e) for e,(v,w) in enumerate(EDGES) for s in range(degree)]
    n = 4*degree
    # Reverse the edge ordering for an independent spanning tree.
    components = [{i} for i in range(n)]
    tree, chords = [], []
    for j in reversed(range(len(edges))):
        v,w,_ = edges[j]
        av = next(c for c in components if v in c)
        aw = next(c for c in components if w in c)
        if av is aw: chords.append(j)
        else:
            tree.append(j)
            components.remove(av);components.remove(aw);components.append(av|aw)
    assert len(components) == 1 and len(chords) == 2*degree+1
    adjacency = [[] for _ in range(n)]
    for e in tree:
        v,w,_ = edges[e];adjacency[v].append((w,e));adjacency[w].append((v,e))
    cycles = []
    for e in chords:
        v,w,_ = edges[e]
        pending = deque([v]);previous = {v:None}
        while w not in previous:
            t = pending.popleft()
            for u,j in adjacency[t]:
                if u not in previous:previous[u]=(t,j);pending.append(u)
        mask = 1<<e
        t = w
        while t != v:
            t,j = previous[t];mask ^= 1<<j
        cycles.append(mask)
    planes = [0]
    for cycle in cycles:planes += [v^cycle for v in planes]
    assert len(set(planes)) == 2**len(chords)
    incident = [[j for j,(v,w,_) in enumerate(edges) if i in (v,w)] for i in range(n)]
    idx = {c:i for i,c in enumerate(CHAR)}
    coefficient = defaultdict(int)
    denominator_bits = 2436*degree
    valid = negative = 0
    for b0,b1,b2 in product(planes,repeat=3):
        if b0 & b1 & b2: continue  # The omitted character seven on any edge.
        colors = [((b0>>e)&1)+2*((b1>>e)&1)+4*((b2>>e)&1) for e in range(len(edges))]
        mode = [idx[c] for c in colors]
        sign, bits, exponent = 1, 0, 0
        for inds in incident:
            v = moments[tuple(mode[e] for e in inds)]
            assert v in (Q(1),Q(1,2),-Q(1,2))
            if v < 0:sign = -sign
            if abs(v) == Q(1,2):bits += 1
        for e,(_,_,kind) in enumerate(edges):
            if kind == 0: exponent += DEG[mode[e]]
            else: bits += FIXED[kind]*DEG[mode[e]]
        coefficient[exponent] += sign*(1<<(denominator_bits-bits))
        valid += 1
        negative += sign < 0
    return {e:Q(v,1<<denominator_bits) for e,v in coefficient.items() if v}, {'valid':valid,'negative':negative}


def cover_budgets():
    saved = json.loads((HERE/'continuation7_cover_orbits_checks.json').read_text())
    states = []
    for v in product((-1,1),repeat=6):
        if v[0]*v[1]*v[2]+v[0]*v[3]*v[4]+v[1]*v[3]*v[5]-v[2]*v[4]*v[5] == 2:
            states.append((1,)+v)
    assert len(states) == 32
    moments = {t:Q(sum(v[t[0]]*v[t[1]]*v[t[2]] for v in states),32)
               for t in product(range(7),repeat=3)}
    assert sum(bool(v) for v in moments.values()) == 43
    base = defaultdict(Q)
    good = 0
    for modes in product(range(7),repeat=6):
        weight = Q(1)
        for inds in ((0,1,2),(0,3,4),(1,3,5),(2,4,5)):
            weight *= moments[tuple(modes[j] for j in inds)]
            if not weight:break
        if not weight:continue
        good += 1
        bits = sum(FIXED[e]*DEG[modes[e]] for e in range(1,6))
        base[DEG[modes[0]]] += weight/Q(1<<bits)
    base = {e:v for e,v in base.items() if v}
    assert good == 235 and base == poly_decode(saved['base_polynomial'])
    powers = {2:poly_mul(base,base),3:poly_mul(poly_mul(base,base),base)}
    minimum = None
    checked = []
    selected_three = False
    for rec in saved['records']:
        p = poly_decode(rec['defect_coefficients'])
        q0 = min(p)
        lower = p[q0] + sum((v/Q(1<<(4*(e-q0))) for e,v in p.items() if e>q0 and v<0),Q(0))
        assert q0 == rec['first_power'] and q0 in (0,4)
        assert lower == decode(rec['interval_lower']) > Q(1,1<<60)
        assert sum(v<0 for v in p.values()) == rec['negative_defect_coefficients']
        minimum = lower if minimum is None else min(minimum,lower)
        if rec['M'] == 2 or (not selected_three and not rec['commuting']):
            actual,counts = cycle_plane_polynomial(rec['M'],rec['chord_permutations'],moments)
            expected = defaultdict(Q,powers[rec['M']])
            for e,v in p.items():expected[e] -= v
            expected = {e:v for e,v in expected.items() if v}
            assert actual == expected
            assert counts['valid'] == rec['flow_stats']['valid_flows']
            assert counts['negative'] == rec['flow_stats']['negative_flows']
            checked.append({'degree':rec['M'],'index':rec['index'],'counts':counts})
            selected_three |= rec['M'] == 3
    assert len(checked) == 8 and minimum == decode(saved['minimum_interval_lower'])
    assert len(saved['records']) == 48
    assert sum(r['M']==3 and not r['commuting'] for r in saved['records']) == 28
    assert sum(not r['single_edge_gauge'] for r in saved['records']) == 36
    return {'all_saved_interval_bounds_checked':48,'original_cubic_moments_checked':343,
            'base_nonzero_assignments':good,'independent_binary_cycle_plane_checks':checked,
            'minimum_interval_lower':rational(minimum),
            'checked_author_json_sha256':sha(HERE/'continuation7_cover_orbits_checks.json')}


def main():
    start = time.perf_counter()
    result = {'status':'PASS','method':'independent standard-library exact arithmetic; no author code imported'}
    result['weighted_fields'] = weighted_fields()
    print('PASS original weighted fields and negative cubic',flush=True)
    result['ac_inverse_filter'] = ac_inverse_filter()
    print('PASS independent rational inverse-square ac filter',flush=True)
    result['cover_budgets'] = cover_budgets()
    print('PASS saved budgets and independent cycle-space polynomials',flush=True)
    names = ['continuation7_source_weighted_complement.md','continuation7_opt_ac_obstruction.md',
             'continuation7_opt_ac_exact.py','continuation7_opt_ac_exact_checks.json',
             'continuation7_cover_orbits.md','continuation7_cover_orbits_verify.py',
             'continuation7_cover_orbits_checks.json']
    result['reviewed_file_sha256'] = {name:sha(HERE/name) for name in names}
    result['review_program_sha256'] = sha(Path(__file__))
    result['elapsed_seconds'] = time.perf_counter()-start
    (HERE/'continuation7_root_review.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS root audit; seconds',result['elapsed_seconds'],flush=True)


if __name__ == '__main__':main()
