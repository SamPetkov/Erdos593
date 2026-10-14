#!/usr/bin/env python3
"""Exact tree-smoothing and calibrated-reference checks; not universal proof."""
from fractions import Fraction as Q
from itertools import product, combinations
from pathlib import Path
from math import prod
import importlib.util
import json

BASE = Path(__file__).resolve().parents[1] / '2026-10-14-two-star' / 'exact_checks.py'
spec = importlib.util.spec_from_file_location('two_star_exact', BASE)
core = importlib.util.module_from_spec(spec)
spec.loader.exec_module(core)
check = core.check


def apply_product(f, matrices, mu):
    """Original-law tensor action in arbitrary dimension."""
    out = f
    for axis, matrix in enumerate(matrices):
        nxt = {}
        for key in f:
            val = Q(0)
            for y in range(len(mu)):
                source = key[:axis] + (y,) + key[axis + 1:]
                val += mu[y] * matrix[key[axis]][y] * out[source]
            nxt[key] = val
        out = nxt
    return out


def distances(vertices, edges):
    adjacency = [[] for _ in range(vertices)]
    for i, j, length in edges:
        adjacency[i].append((j, length))
        adjacency[j].append((i, length))
    result = {}
    for start in range(vertices):
        seen = {start: 0}
        todo = [start]
        while todo:
            i = todo.pop()
            for j, length in adjacency[i]:
                if j not in seen:
                    seen[j] = seen[i] + length
                    todo.append(j)
        check(len(seen) == vertices, 'tree connected')
        for j, length in seen.items():
            result[start, j] = length
    check(len(edges) == vertices - 1, 'connected graph has tree edge count')
    return result


def tree_case(name, T, mu, edges, times, chords):
    core.rootcheck(T, mu)
    v = len(times)
    d = distances(v, edges)
    for i, j, length in chords:
        check(length >= d[i, j] and (length - d[i, j]) % 2 == 0,
              'actual chord length and parity premises')
    limit = max([sum(x[2] for x in edges) + 2 * max(times)] +
                [x[2] for x in chords] + [2 * max(times)])
    powers = core.powers(T, mu, limit)
    keys = list(product(range(len(mu)), repeat=v))
    weights = {x: prod(mu[z] for z in x) for x in keys}
    f = {x: prod(powers[L][x[i]][x[j]] for i, j, L in edges) for x in keys}
    matrices = [powers[a] for a in times]
    mid = apply_product(f, matrices, mu)
    g = apply_product(mid, matrices, mu)
    check(g == apply_product(f, [powers[2*a] for a in times], mu),
          'actual tensor square composition')
    for density in (f, mid, g):
        check(sum(weights[x]*density[x] for x in keys) == 1,
              'original product density normalized')
    check(all(g[x] > 0 for x in keys if f[x] > 0), 'square output support')
    pair_weights = {(a,b):mu[a]*mu[b] for a,b in product(range(len(mu)), repeat=2)}
    for i,j in combinations(range(v), 2):
        for a,b in pair_weights:
            marginal = sum((weights[x]*f[x]/pair_weights[a,b]
                            for x in keys if (x[i],x[j]) == (a,b)), Q(0))
            check(marginal == powers[d[i,j]][a][b], 'exact tree marginal')
            mid_marginal = sum((weights[x]*mid[x]/pair_weights[a,b]
                                for x in keys if (x[i],x[j]) == (a,b)), Q(0))
            check(mid_marginal == powers[times[i]+d[i,j]+times[j]][a][b],
                  'exact midpoint marginal')
    V = core.cross_entropy(f, g, weights)
    bound = core.entropy_density(mid, weights)
    for i,j,L in chords:
        base = {(a,b):powers[d[i,j]][a][b] for a,b in pair_weights}
        target = {(a,b):powers[L][a][b] for a,b in pair_weights}
        midpoint = {(a,b):powers[(L+d[i,j])//2][a][b] for a,b in pair_weights}
        V = core.add_interval(V, core.cross_entropy(base, target, pair_weights))
        bound = core.add_interval(bound, core.entropy_density(midpoint, pair_weights))
    density = sum((weights[x]*f[x]*g[x]*
                   prod(powers[L][x[i]][x[j]] for i,j,L in chords) for x in keys), Q(0))
    check(density >= 1, 'exact finite density in proved tree range')
    check(core.sub_interval(V, bound)[1] >= 0, 'entropy-bound interval consistency')
    check(core.sub_interval(core.log_bounds(density), V)[1] >= 0,
          'variational-bound interval consistency')
    if any(value != 1 for row in T for value in row):
        check(bound[0] > 0 and density > 1, 'strictness for nonconstant root')
    # Explicit two-copy normalization where small enough for a separate enumeration.
    if len(mu) ** (2*v) <= 4096:
        norm = Q(0)
        for x in keys:
            if f[x] == 0:
                continue
            inner = sum((weights[y]*f[y]*prod(powers[2*times[i]][x[i]][y[i]]
                                             for i in range(v)) for y in keys), Q(0))
            check(inner == g[x], 'explicit copied-tree conditional normalizer')
            norm += weights[x]*f[x]*inner/g[x]
        check(norm == 1, 'full two-copy law exactly normalized')
    return {'name':name, 'edges':edges, 'times':times, 'chords':chords,
            'F':density, 'V':V, 'entropy_bound':bound}


def calibrated_case(name, T, mu, pars):
    core.rootcheck(T, mu)
    k,p,q,s,t,ell = pars
    check(p>=s>=1 and q>=t>=1 and 1<=k<=s+t, 'calibrated reference premises')
    powers = core.powers(T, mu, max(2*max(pars),2*(s+t),k+s+t))
    K = lambda a: powers[2*a]
    keys = list(product(range(len(mu)), repeat=3))
    weights = {x:prod(mu[z] for z in x) for x in keys}
    f = {x:K(s)[x[0]][x[2]]*K(t)[x[1]][x[2]] for x in keys}
    g = {x:sum((mu[z]*K(p)[x[0]][z]*K(q)[x[1]][z]*K(ell)[x[2]][z]
                for z in range(len(mu))), Q(0)) for x in keys}
    a = K(s+t)
    c = K(k)
    b = {x:f[x]*c[x[0]][x[1]]/a[x[0]][x[1]] if a[x[0]][x[1]] else Q(0)
         for x in keys}
    check(sum(weights[x]*b[x] for x in keys) == 1, 'calibrated law normalized')
    check(all(g[x]>0 and f[x]>0 for x in keys if b[x]>0), 'calibrated support')
    pair_weights = {(x,y):mu[x]*mu[y] for x,y in product(range(len(mu)),repeat=2)}
    for x,y in pair_weights:
        check(sum((mu[w]*b[x,y,w] for w in range(len(mu))),Q(0)) == c[x][y],
              'calibrated endpoint marginal equals actual K_k')
    pair_c = {x:c[x[0]][x[1]] for x in pair_weights}
    pair_a = {x:a[x[0]][x[1]] for x in pair_weights}
    star = core.cross_entropy(b,g,weights)
    edge = core.cross_entropy(pair_c,pair_a,pair_weights)
    V = core.add_interval(star,edge)
    # Exact selection ratio proves equality of the two KL costs without rounding.
    check(all(b[x]/f[x] == c[x[0]][x[1]]/a[x[0]][x[1]]
              for x in keys if b[x]>0), 'selection-cost likelihood ratio retained')
    F = sum((weights[x]*f[x]*g[x]*c[x[0]][x[1]] for x in keys),Q(0))
    check(core.sub_interval(core.log_bounds(F),V)[1]>=0, 'calibrated Gibbs inequality')
    if p==s and q==t:
        mid = {x:powers[k+s+t][x[0]][x[1]] for x in pair_weights}
        lower = core.scale_interval(2,core.entropy_density(mid,pair_weights))
        check(core.sub_interval(V,lower)[1]>=0, 'matched-star analytical bound')
    return {'name':name,'parameters':pars,'mu':mu,'T':T,'F':F,'V':V,
            'star_log_score':star,'edge_log_score':edge}


def main():
    fixtures = [
        ('independent', [[Q(1)]*2 for _ in range(2)], [Q(1,3),Q(2,3)]),
        ('identity_nonuniform', [[Q(3),Q(0)],[Q(0),Q(3,2)]], [Q(1,3),Q(2,3)]),
        ('period_two', [[Q(0),Q(2)],[Q(2),Q(0)]], [Q(1,2)]*2),
        ('negative', [[Q(1,2),Q(3,2)],[Q(3,2),Q(1,2)]], [Q(1,2)]*2),
        ('extra_unit_zero', [[Q(2) if i//2==j//2 else Q(0) for j in range(4)]
                             for i in range(4)], [Q(1,4)]*4),
        ('supplied_three', [[Q(4,5),Q(18,13),Q(32,39)],
                            [Q(18,13),Q(1,2),Q(40,39)],
                            [Q(32,39),Q(40,39),Q(148,117)]],
                            [Q(5,12),Q(1,3),Q(1,4)])]
    signs = list(product((-1,1),repeat=2))
    T = [[1+Q(1,100)*x[0]*y[0]+Q(9,10)*x[1]*y[1] for y in signs] for x in signs]
    fixtures.append(('positive_singular',T,[Q(1,4)]*4))
    records=[]
    for name,T,mu in fixtures:
        # Three leaves, all three added chords; identity factors and exact chord boundaries.
        records.append(tree_case(name+'_star',T,mu,
            [(0,3,2),(1,3,4),(2,3,2)], [1,0,1,1],
            [(0,1,6),(0,2,4),(1,2,8)]))
        # A non-star tree with odd root lengths; a zero smoothing time is the identity.
        records.append(tree_case(name+'_path',T,mu,
            [(0,1,1),(1,2,2)], [0,1,1], [(0,2,3)]))
        records.append(calibrated_case(name+'_matched',T,mu,(2,2,3,2,3,1)))
        print('checked',name,'tree, multistar, and calibrated matched stars',flush=True)
    n=9;mu=[Q(1,n)]*n;eps=Q(1,10**14)
    cycle=[[Q(n,2) if (i-j)%n in(1,n-1) else Q(0) for j in range(n)]for i in range(n)]
    T=[[eps+(1-eps)*cycle[i][j] for j in range(n)]for i in range(n)]
    rec=calibrated_case('calibrated_C9',T,mu,(2,3,2,2,2,2))
    check(rec['V'][0]>0,'rigorously positive calibrated budget on old negative fixture')
    core.rational_bracket(rec['V'],'2.13769805608317','2.13769805608318',
                          'strict calibrated budget interval')
    core.rational_bracket(rec['star_log_score'],'1.46326379831862','1.46326379831863',
                          'strict calibrated star score interval')
    records.append(rec)
    print('calibrated_C9 V interval',tuple(float(x)for x in rec['V']))
    print('calibrated_C9 star interval',tuple(float(x)for x in rec['star_log_score']))
    print('PASS',core.COUNT,'exact assertions')
    report={'assertions':core.COUNT,'unrestricted_theorem':'open',
            'universal_calibrated_sign':'not proved', 'records':records}
    Path(__file__).with_name('generated_certificate.json').write_text(
        json.dumps(core.decode(report),indent=2)+'\n')

if __name__=='__main__':
    main()
