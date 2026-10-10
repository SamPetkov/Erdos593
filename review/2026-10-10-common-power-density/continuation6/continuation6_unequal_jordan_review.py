"""Independent coordinate and density audit of the Jordan examples.

This program does not import either author's arithmetic. It reconstructs
the uniform example as ordinary transition matrices and the reused
weighted example in a two-dimensional rational Gram coordinate system.
The author's checker is separately replayed in an isolated directory.
"""
from fractions import Fraction as F
from itertools import combinations, product
from math import lcm
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile

HERE=Path(__file__).resolve().parent


def matmul(a,b):
    return [[sum(a[i][k]*b[k][j] for k in range(len(b)))
             for j in range(len(b[0]))] for i in range(len(a))]


def identity(n):
    return [[F(i==j) for j in range(n)] for i in range(n)]


def matpow(a,n):
    ans=identity(len(a))
    for _ in range(n):
        ans=matmul(ans,a)
    return ans


def tr(a):
    return sum(a[i][i] for i in range(len(a)))


def minus(a,b):
    return [[a[i][j]-b[i][j] for j in range(len(a[0]))]
            for i in range(len(a))]


def scal(c,a):
    return [[c*x for x in row] for row in a]


def rank(a):
    a=[list(map(F,row)) for row in a]
    r=0
    for c in range(len(a[0])):
        k=next((k for k in range(r,len(a)) if a[k][c]),None)
        if k is None:
            continue
        a[r],a[k]=a[k],a[r]
        pivot=a[r][c]
        a[r]=[x/pivot for x in a[r]]
        for k in range(r+1,len(a)):
            factor=a[k][c]
            a[k]=[x-factor*y for x,y in zip(a[k],a[r])]
        r+=1
        if r==len(a):
            break
    return r


def density_by_two_vertex_contraction(ks,n):
    """Uniform original measure; independently contract the last two vertices."""
    ds=[lcm(*(x.denominator for row in k for x in row)) for k in ks]
    ints=[[[int(d*x) for x in row] for row in k] for k,d in zip(ks,ds)]
    ab,ac,ad,bc,bd,cd=ints
    total=0
    for a,b in product(range(n),repeat=2):
        left=[ac[a][c]*bc[b][c] for c in range(n)]
        right=[ad[a][d]*bd[b][d] for d in range(n)]
        contracted=sum(left[c]*sum(cd[c][d]*right[d] for d in range(n))
                       for c in range(n))
        total+=ab[a][b]*contracted
    den=n**4
    for d in ds:
        den*=d
    return F(total,den)


def rank_ten_check(stored):
    n=12;eps=F(1,1024);eta=eps
    P0=identity(n)
    for i in range(n-1):
        P0[i][i]-=eta;P0[i+1][i+1]-=eta
        P0[i][i+1]=P0[i+1][i]=eta
    P=[[(1-eps)*P0[i][j]+eps/n for j in range(n)] for i in range(n)]
    assert all(sum(row)==1 for row in P)
    gram=((2,1,-1),(1,2,1),(-1,1,2))
    small=[[F(gram[i//4][j//4],n) for j in range(n)] for i in range(n)]
    q=minus(identity(n),small)
    assert matmul(q,q)==q and tr(q)==10 and rank(q)==10
    assert all(n*q[i][i]==10 for i in range(n))
    assert matmul(P,q)!=matmul(q,P)
    assert (n*q[0][1])*(n*q[1][2])*(n*q[2][0])==-8
    assert rank([[q[i][a]*q[a][j] for a in range(n)]
                 for i,j in product(range(n),repeat=2)])==12
    # TP2 is checked on the original transition matrix; positive column
    # scaling transports every minor to the relative original-law kernel.
    minors=[P0[i][k]*P0[j][l]-P0[i][l]*P0[j][k]
            for i,j in combinations(range(n),2)
            for k,l in combinations(range(n),2)]
    assert len(minors)==4356 and min(minors)>=0
    B=matmul(P,P)
    powers={s:matpow(B,s) for s in (1,2,3)}
    fields={}
    for s in powers:
        fields[s]=[]
        for t in range(n):
            # In ordinary Euclidean coordinates M=q diag(n B^s(.,t))q.
            diagonal=[[F(n)*powers[s][i][t] if i==j else F(0)
                       for j in range(n)] for i in range(n)]
            m=matmul(matmul(q,diagonal),q)
            assert tr(m)==10
            fields[s].append(m)
    centered={s:[minus(m,q) for m in fields[s]] for s in fields}
    corr=lambda s,t:sum(tr(matmul(centered[s][i],centered[t][i]))
                        for i in range(n))/n
    gxy,gxz,gyz=corr(1,2),corr(1,3),corr(2,3)
    vy,vz=corr(2,2),corr(3,3)
    J=sum(tr(matmul(matmul(fields[1][i],fields[2][i]),fields[3][i]))
          for i in range(n))/n
    C=sum(tr(matmul(matmul(centered[1][i],centered[2][i]),centered[3][i]))
          for i in range(n))/n
    assert J==10+gxy+gxz+gyz+C and C!=0
    assert gxy>=vy and gxz>=gyz>=vz>0
    margin=F(81,4)*vy*vz-(C-F(7,2)*gyz)**2
    assert margin>=0 and J-10>F(7,16)*vz
    v=[q[i][0] for i in range(n)]
    ray=sum(n*B[i][0]*v[i]**2 for i in range(n))/sum(a*a for a in v)
    assert ray>F(97,10) and (F(97,10)-4)**2>32
    for key,value in {'J':J,'centered_cubic':C,'g_xy':gxy,'g_xz':gxz,
                      'g_yz':gyz,'v_y':vy,'v_z':vz,
                      'shortest_source_Rayleigh_quotient':ray,
                      'squared_Jordan_interval_margin':margin}.items():
        assert F(stored[key])==value
    # Rebuild the actual fine root as an ordinary stochastic matrix.
    alpha=F(1,20480);states=list(product(range(n),(-1,1)))
    Pf=[[(P[i][j]+alpha*a*b*q[i][j])/2 for j,b in states]
        for i,a in states]
    assert all(sum(row)==1 and min(row)>0 for row in Pf)
    T=scal(24,Pf);p=1/max(x for row in T for x in row)
    assert p==F(262144,3139971)
    assert min(x for row in T for x in row)==F(9,10240)
    Af=matmul(Pf,Pf)
    assert max(x for row in scal(24,Af) for x in row)==F(8215521496079,687194767360)
    ep=(3,2,1,1,1,1)
    coarse=density_by_two_vertex_contraction([scal(n,powers[s]) for s in ep],n)
    finep={s:scal(24,matpow(Af,s)) for s in (1,2,3)}
    fine=density_by_two_vertex_contraction([finep[s] for s in ep],24)
    assert coarse==F(stored['F_coarse']) and fine==F(stored['F_fine'])
    assert fine>coarse>1
    return {'J':str(J),'centered_cubic_nonzero':True,'exact_Rayleigh':str(ray),
            'interval_margin':str(margin),'independent_F_coarse':str(coarse),
            'independent_F_fine':str(fine),'original_uniform_fine_measure':'1/24',
            'diagonal_compression_rank':12,'TP2_minor_count':4356,
            'source_cap_fails_but_balanced_trace_applies':True}


def old_host_check(stored):
    pi=list(map(F,('3/5','1/5','1/10','1/10')))
    ss=[60,20,10,10]
    G=((59,1,0,0),(1,18,1,0),(0,1,8,1),(0,0,1,9))
    S0=[[F(100*G[i][j],ss[i]*ss[j]) for j in range(4)] for i in range(4)]
    S=[[F(31,32)*S0[i][j]+F(1,32) for j in range(4)] for i in range(4)]
    P=[[pi[j]*S[i][j] for j in range(4)] for i in range(4)]
    assert all(sum(row)==1 for row in P)
    assert all(S0[i][k]*S0[j][l]>=S0[i][l]*S0[j][k]
               for i,j in combinations(range(4),2)
               for k,l in combinations(range(4),2))
    B=matmul(P,P)
    cap=max(B[i][j]/pi[j] for i,j in product(range(4),repeat=2))
    assert cap==F(9929,1280)<9
    f=list(map(F,(1,0,-3,-3)))
    U=[[[F(1),v],[v,v*v]] for v in f]
    invgram=[[F(1),F(0)],[F(0),F(5,12)]]
    moments={}
    for s in (1,2,8):
        b=matpow(B,s)
        moments[s]=[[[sum(b[i][j]*U[j][a][c] for j in range(4))
                       for c in range(2)] for a in range(2)] for i in range(4)]
    trace1=[tr(matmul(invgram,u)) for u in moments[1]]
    assert len(set(trace1))>1 and trace1==list(map(F,stored['first_step_actual_traces']))
    J=sum(pi[i]*tr(matmul(matmul(matmul(matmul(matmul(invgram,moments[1][i]),
            invgram),moments[2][i]),invgram),moments[8][i])) for i in range(4))
    assert J==F(stored['J'])>2
    Q=[[F(1)+F(5,12)*f[i]*f[j] for j in range(4)] for i in range(4)]
    states=list(product(range(4),(-1,1)));mu=[pi[i]/2 for i,a in states]
    T=[[S[i][j]+a*b*Q[i][j]/128 for j,b in states] for i,a in states]
    assert min(x for row in T for x in row)>0
    assert all(sum(mu[j]*T[i][j] for j in range(8))==1 for i in range(8))
    p=1/max(x for row in T for x in row);assert p==F(512,4499)
    return {'max_coarse_B':str(cap),'actual_first_step_traces':list(map(str,trace1)),
            'J_in_independent_Gram_coordinates':str(J),'p':str(p),
            'visible_balance_fails_but_uniform_cap_applies':True,
            'old_TP2_minor_count':36}


def main():
    names=['continuation6_jordan_contraction.md','continuation6_jordan_examples.md',
           'continuation6_jordan_verify.py','continuation6_graded_verify.py',
           'continuation6_jordan_checks.json']
    hashes={n:hashlib.sha256((HERE/n).read_bytes()).hexdigest() for n in names}
    saved=json.loads((HERE/'continuation6_jordan_checks.json').read_text())
    high=rank_ten_check(saved['balanced_rank_ten_host'])
    old=old_host_check(saved['old_unbalanced_host_new_cap'])
    with tempfile.TemporaryDirectory(prefix='e593_jordan_independent_') as td:
        for n in ('continuation6_jordan_verify.py','continuation6_graded_verify.py'):
            shutil.copy2(HERE/n,Path(td)/n)
        proc=subprocess.run([sys.executable,'continuation6_jordan_verify.py'],cwd=td,
                            text=True,capture_output=True,check=True)
        replay=json.loads((Path(td)/'continuation6_jordan_checks.json').read_text())
    a=dict(saved);b=dict(replay)
    a.pop('elapsed_seconds');b.pop('elapsed_seconds')
    assert a==b
    assert hashes=={n:hashlib.sha256((HERE/n).read_bytes()).hexdigest() for n in names}
    result={'reviewer':'/root/unequal6','status':'PASS_FOR_STATED_EXAMPLES',
            'reviewed_files':hashes,
            'independent_arithmetic':'No author module imported. Uniform roots reconstructed as ordinary stochastic matrices; weighted rank-two star reconstructed in rational Gram coordinates; full fine density independently contracted over its final two vertices.',
            'rank_ten_review':high,'unbalanced_host_review':old,
            'isolated_author_checker_replay_matches_except_elapsed_seconds':True,
            'original_files_unchanged':True,
            'scope':'Exact restricted-host and proof-hypothesis checks only. Unrestricted U and the original density target remain unresolved.',
            'review_source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    (HERE/'continuation6_unequal_jordan_review.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'status':'PASS','independent_full_density_host_count':1,
          'independent_full_density_tuple_count':1,'independent_weighted_Gram_star_count':1,
          'reviewed_file_count':len(hashes)}))


if __name__=='__main__':
    main()
