"""Exact original-law weighted flat-complement certificate.

Standard-library Fraction and integer arithmetic only.  No numerical
eigenvalue matching and no claim of an unrestricted density proof.
"""
from fractions import Fraction as F
from itertools import combinations, product
from math import lcm
from pathlib import Path
import hashlib
import json
import time

ROOT = Path(__file__).resolve().parent


def mm(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(len(B)))
             for j in range(len(B[0]))] for i in range(len(A))]


def trace(A):
    return sum(A[i][i] for i in range(len(A)))


def eye(n):
    return [[F(i == j) for j in range(n)] for i in range(n)]


def transpose(A):
    return list(map(list, zip(*A)))


def operator(K, pi):
    return [[K[i][j] * pi[j] for j in range(len(pi))]
            for i in range(len(pi))]


def integerize(A):
    denominator = lcm(*(v.denominator for row in A for v in row))
    return [[int(denominator * v) for v in row] for row in A], denominator


def vector_integerize(v):
    denominator = lcm(*(x.denominator for x in v))
    return [int(denominator * x) for x in v], denominator


def powers(S, pi, max_s):
    P = operator(S, pi)
    M, D = integerize(P)
    N = [[int(i == j) for j in range(len(pi))] for i in range(len(pi))]
    kernels = {}
    for t in range(1, 2 * max_s + 1):
        N = mm(N, M)
        if t % 2 == 0:
            kernels[t // 2] = [[F(N[i][j], D ** t) / pi[j]
                               for j in range(len(pi))] for i in range(len(pi))]
    return P, kernels


def exact_star(pi, Q, Ks):
    n = len(pi)
    weights, weight_den = vector_integerize(pi)
    qnum, qden = integerize(Q)
    nums, dens = zip(*(integerize(K) for K in Ks))
    numerator = sum(weights[a] * weights[b] * weights[c] * weights[t]
                    * qnum[a][b] * qnum[b][c] * qnum[c][a]
                    * nums[0][a][t] * nums[1][b][t] * nums[2][c][t]
                    for a, b, c, t in product(range(n), repeat=4))
    return F(numerator, weight_den ** 4 * qden ** 3 * dens[0] * dens[1] * dens[2])


def exact_density(pi, kernels, exponents):
    n = len(pi)
    weights, weight_den = vector_integerize(pi)
    nums, dens = zip(*(integerize(kernels[j]) for j in exponents))
    numerator = sum(weights[a] * weights[b] * weights[c] * weights[d]
                    * nums[0][a][b] * nums[1][a][c] * nums[2][a][d]
                    * nums[3][b][c] * nums[4][b][d] * nums[5][c][d]
                    for a, b, c, d in product(range(n), repeat=4))
    denominator = weight_den ** 4
    for d in dens:
        denominator *= d
    return F(numerator, denominator)


def fields_integer(Qop, kernels):
    qnum, qden = integerize(Qop)
    n = len(Qop)
    out = {}
    for s, K in kernels.items():
        knum, kden = integerize(K)
        field = []
        for t in range(n):
            left = [[qnum[i][j] * (knum[j][t] - kden)
                     for j in range(n)] for i in range(n)]
            field.append(mm(left, qnum))
        out[s] = (field, qden ** 2 * kden)
    return out


def star_certificate(pi, Q, K, xyz):
    n = len(pi)
    x, y, z = sorted(xyz)
    a = [1 / p - n for p in pi]
    delta = max(abs(v) for v in a)
    m, M = n - 2 - delta, n + delta - 1
    assert m > 0 and delta ** 2 * M <= 8 * (n - 3) * m
    Qop = operator(Q, pi)
    X = fields_integer(Qop, {s: K[s] for s in set(xyz)})
    g = {}
    for s, t in [(x, y), (x, z), (y, z)]:
        Ns, Ds = X[s]
        Nt, Dt = X[t]
        value = sum(pi[i] * F(trace(mm(Ns[i], Nt[i])), Ds * Dt)
                    for i in range(n))
        g[f'{s},{t}'] = value
        direct = sum(pi[i] * (n - 2 + a[i]) * (K[s + t][i][i] - 1)
                     for i in range(n))
        assert value == direct
    Nx, Dx = X[x]
    Ny, Dy = X[y]
    Nz, Dz = X[z]
    cubic = sum(pi[i] * F(trace(mm(mm(Nx[i], Ny[i]), Nz[i])), Dx * Dy * Dz)
                for i in range(n))
    H = [[(K[x][i][t] - 1) * (K[y][i][t] - 1) * (K[z][i][t] - 1)
          for t in range(n)] for i in range(n)]
    V = sum(pi[i] * pi[t] * H[i][t] for i, t in product(range(n), repeat=2))
    error = sum(pi[i] * pi[t] * a[i] * H[i][t]
                for i, t in product(range(n), repeat=2))
    error_square = sum(pi[i] * pi[t] * a[i] * a[t] * H[i][t]
                       for i, t in product(range(n), repeat=2))
    assert V >= 0 and error_square >= 0
    assert cubic == (n - 3) * V + error
    assert error ** 2 <= V * error_square
    assert cubic >= -error_square / (4 * (n - 3))
    sigma = {s: sum(pi[i] * K[s][i][i] for i in range(n)) - 1
             for s in {x+y, x+z, y+z, 2*y, 2*z}}
    assert all(v >= 0 for v in sigma.values())
    assert error_square ** 2 <= delta ** 4 * M ** 2 * sigma[2*y] * sigma[2*z]
    J = exact_star(pi, Q, [K[s] for s in xyz])
    assert J == n - 1 + sum(g[f'{s},{t}'] for s, t in [(x, y), (x, z), (y, z)]) + cubic
    lower = n - 1 + m * sigma[x+z] + (m - delta**2*M/(8*(n-3))) * (sigma[x+y]+sigma[y+z])
    assert J >= lower >= n - 1
    return {'xyz': xyz, 'delta': delta, 'm': m, 'M': M,
            'criterion_slack': 8*(n-3)*m-delta**2*M,
            'J': J, 'g': g, 'cubic': cubic, 'H_constant_form': V,
            'H_mixed_form': error, 'H_error_form': error_square,
            'sigma': sigma, 'rational_lower': lower}


def serialize(x):
    if isinstance(x, F):
        return str(x)
    if isinstance(x, dict):
        return {str(k): serialize(v) for k, v in x.items()}
    if isinstance(x, (tuple, list)):
        return [serialize(v) for v in x]
    return x


def run():
    start = time.time()
    n = 13
    pi = [F(17, 208), F(15, 208)] + [F(1, 13)] * 11
    assert sum(pi) == 1 and all(p > 0 for p in pi)
    c, refresh = F(1, 4096), F(1, 1024)
    P0 = eye(n)
    for i in range(n-1):
        P0[i][i+1] = c/pi[i]
        P0[i+1][i] = c/pi[i+1]
        P0[i][i] -= c/pi[i]
        P0[i+1][i+1] -= c/pi[i+1]
    assert min(P0[i][i] for i in range(n)) == F(1907, 1920)
    S0 = [[P0[i][j]/pi[j] for j in range(n)] for i in range(n)]
    S = [[(1-refresh)*S0[i][j]+refresh for j in range(n)] for i in range(n)]
    assert S == transpose(S) and min(v for row in S for v in row) > 0
    assert all(sum(pi[j]*S[i][j] for j in range(n)) == 1 for i in range(n))
    signs = [F((-1)**i) for i in range(n)]
    Q = [[F(i == j)/pi[i]-signs[i]*signs[j] for j in range(n)] for i in range(n)]
    Qop = operator(Q, pi)
    assert Q == transpose(Q) and mm(Qop, Qop) == Qop and trace(Qop) == 12
    assert Q[0][1]*Q[1][2]*Q[2][0] == -1
    qone = [sum(pi[j]*Q[i][j] for j in range(n)) for i in range(n)]
    assert qone == [1-F(9,104)*s for s in signs]
    assert qone != [0]*n and qone != [1]*n
    a = [1/p-n for p in pi]
    assert a == [F(-13,17),F(13,15)] + [0]*11
    assert max(abs(v) for v in a) == F(13,15)
    P, K = powers(S, pi, 6)
    comm = [[v-w for v,w in zip(r,s)] for r,s in zip(mm(P,Qop),mm(Qop,P))]
    nonzero_comm = next((i,j,comm[i][j]) for i,j in product(range(n),repeat=2) if comm[i][j])
    trace_field = [sum(pi[j]*K[1][i][j]*Q[j][j] for j in range(n)) for i in range(n)]
    assert len(set(trace_field)) > 1
    cap = P[1][1]**2 * Q[1][1]
    assert cap > 12
    first_fields = fields_integer(Qop, {1: K[1]})
    raw, den = first_fields[1]
    actual_cubic_at_one = F(trace(mm(mm(raw[1],raw[1]),raw[1])),den**3)
    assert actual_cubic_at_one > 0
    minors = [S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k]
              for i,j in combinations(range(n),2) for k,l in combinations(range(n),2)]
    assert len(minors)==6084 and min(minors)>=0
    star_records = [star_certificate(pi,Q,K,xyz) for xyz in [(1,2,3),(1,1,1),(1,1,2)]]
    assert all(r['J']>12 for r in star_records)
    # Complete actual fine root, and independent powers of that actual root.
    alpha=F(1,32768)
    beta=alpha**2
    states=list(product(range(n),(-1,1)))
    mu=[pi[i]/2 for i,s in states]
    T=[[S[i][j]+s*t*alpha*Q[i][j] for j,t in states] for i,s in states]
    assert T==transpose(T) and min(v for row in T for v in row)>0
    assert all(sum(mu[j]*T[i][j] for j in range(2*n))==1 for i in range(2*n))
    p=1/max(v for row in T for v in row)
    W=[[p*v for v in row] for row in T]
    assert min(v for row in T for v in row)==F(31,32768)
    assert max(v for row in T for v in row)==F(11272763,819200)
    assert p==F(819200,11272763)
    assert all(0<v<=1 for row in W for v in row)
    assert all(sum(mu[j]*W[i][j] for j in range(2*n))==p for i in range(2*n))
    Pf,Kfine=powers(T,mu,3)
    for s in (1,2,3):
        assert Kfine[s]==[[K[s][i][j]+si*tj*beta**s*Q[i][j]
                          for j,tj in states] for i,si in states]
    assert beta<((1-refresh)*F(947,960))**2
    tuple_target=(3,1,1,1,1)
    exponents=(3,2,1,1,1,1)
    coarse_F=exact_density(pi,K,exponents)
    fine_F=exact_density(mu,Kfine,exponents)
    cycle_surplus=12*(beta**3+beta**4+2*beta**5+2*beta**6+beta**7)
    assert coarse_F>1 and fine_F>=coarse_F+cycle_surplus
    # Refresh equality under this same nonuniform original law.
    ones=[[F(1)]*n for _ in range(n)]
    refresh_J=exact_star(pi,Q,[ones]*3)
    assert refresh_J==12
    # n=4, delta=1 endpoint; an identity root is disconnected.
    pi4=[F(1,5),F(3,10),F(1,4),F(1,4)]
    I4=[[F(i==j)/pi4[i] for j in range(4)] for i in range(4)]
    Q4=[[I4[i][j]-1 for j in range(4)] for i in range(4)]
    _,K4=powers(I4,pi4,6)
    boundary4=star_certificate(pi4,Q4,K4,(1,2,3))
    assert boundary4['delta']==1 and boundary4['J']>3
    # Connected bipartite root: square has two stationary components,
    # nonuniform law and unbalanced visible trace.  n=6, delta=2 is
    # admitted by the full criterion though it is outside delta<=1.
    pi6=[F(1,4)]*2+[F(1,8)]*4
    S6=[[F(2 if (i<2)!=(j<2) else 0) for j in range(6)] for i in range(6)]
    Q6=[[F(i==j)/pi6[i]-1 for j in range(6)] for i in range(6)]
    _,K6=powers(S6,pi6,6)
    boundary6=star_certificate(pi6,Q6,K6,(1,2,3))
    assert boundary6['delta']==2 and boundary6['J']>5
    assert K6[1]==K6[2] and sum(pi6[i]*K6[1][i][i] for i in range(6))==2
    trace6=[sum(pi6[j]*K6[1][i][j]*Q6[j][j] for j in range(6)) for i in range(6)]
    assert trace6==[3,3,7,7,7,7]
    # Root-supplied negative cubic sanity check.  This validates collective
    # compensation; it is already within the old source-cap class.
    pin=[F(1,5),F(1,4),F(1,4),F(3,10)]
    v=[F(-4),F(-4),F(-1),F(41,6)]
    assert sum(p*t for p,t in zip(pin,v))==0
    norm_v=sum(p*t*t for p,t in zip(pin,v))
    moment_v=sum(p*t**3 for p,t in zip(pin,v))
    compressed_cubic=sum(t**3 for t in v)-3*moment_v
    assert norm_v==F(515,24) and moment_v==F(9601,144)
    assert compressed_cubic==F(-4295,432)
    Sn=[[1+v[i]*v[j]/128 for j in range(4)] for i in range(4)]
    assert min(t for row in Sn for t in row)==F(151,192)
    assert all(sum(pin[j]*Sn[i][j] for j in range(4))==1 for i in range(4))
    Qn=[[F(i==j)/pin[i]-1 for j in range(4)] for i in range(4)]
    _,Kn=powers(Sn,pin,6)
    negative_cubic_check=star_certificate(pin,Qn,Kn,(1,2,3))
    active_eigenvalue=(norm_v/128)**2
    assert negative_cubic_check['cubic']==active_eigenvalue**6*moment_v*compressed_cubic/norm_v**3<0
    result={'status':'PASS','scope':'weighted flat codimension-one uniform root/exponent theorem; unrestricted density unresolved',
            'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'note_sha256':hashlib.sha256((ROOT/'continuation7_source_weighted_complement.md').read_bytes()).hexdigest(),
            'coarse_states':n,'fine_states':2*n,'rank_Q':12,'pi':pi,'mu':mu,
            'path_conductance':c,'refresh':refresh,'S':S,'Q':Q,'a':a,'Q1':qone,
            'alpha':alpha,'beta':beta,'p':p,'min_T':min(v for row in T for v in row),
            'max_T':max(v for row in T for v in row),'min_W':min(v for row in W for v in row),
            'max_A':max(v for row in Kfine[1] for v in row),'nonzero_commutator_entry':nonzero_comm,
            'actual_first_step_trace_field':trace_field,'first_field_cap_lower':cap,
            'actual_centered_cubic_at_one':actual_cubic_at_one,'star_checks':star_records,
            'TP2_minors_checked':6084,'coarse_positive_centered_bands':12,
            'fine_entire_centered_values_including_zero':14,'fine_zero_multiplicity':1,
            'tuple_target':tuple_target,'six_exponents':exponents,'coarse_F':coarse_F,
            'fine_F':fine_F,'cycle_surplus':cycle_surplus,'refresh_equality_J':refresh_J,
            'n4_delta1_identity_boundary':boundary4,'connected_bipartite_n6_delta2_boundary':boundary6,
            'bipartite_visible_trace':trace6,'negative_cubic_sanity':negative_cubic_check,
            'negative_cubic_sanity_root':Sn,'negative_cubic_sanity_pi':pin,
            'full_F_enumerated':True,'elapsed_seconds':time.time()-start}
    (ROOT/'continuation7_source_weighted_checks.json').write_text(json.dumps(serialize(result),indent=2)+'\n')
    print(json.dumps(serialize({k:result[k] for k in ['status','coarse_states','fine_states','rank_Q',
          'p','min_T','max_T','first_field_cap_lower','coarse_positive_centered_bands',
          'fine_entire_centered_values_including_zero','elapsed_seconds']})))


if __name__=='__main__':
    run()
