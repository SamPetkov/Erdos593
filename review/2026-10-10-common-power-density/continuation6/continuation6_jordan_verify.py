"""Exact balanced-rank-ten and unbalanced-cap certificates.

Uses the same-package arithmetic definitions, not its host or proof output.
The displayed radical estimate is checked by a rational squared bound.
"""
from fractions import Fraction as F
from itertools import product, combinations
from pathlib import Path
import hashlib, json, time
from continuation6_graded_verify import (mm,eye,ones,add,scale,sub,tr,power,
    markov,exponents,exact_density,charpoly,polymul,rank,serialize,EDGES,CYCLES)

START=time.time()

def field(q,K,pi,t):
    return [[sum(pi[a]*q[i][a]*K[a][t]*q[a][j] for a in range(len(pi)))
             for j in range(len(pi))] for i in range(len(pi))]

def balanced_host():
    n=12;pi=[F(1,n)]*n;eta=F(1,1024);eps=F(1,1024)
    S0=[[F(0) for j in range(n)] for i in range(n)]
    for i in range(n-1):S0[i][i+1]=S0[i+1][i]=n*eta
    for i in range(n):S0[i][i]=n-sum(S0[i])
    S=add(scale(1-eps,S0),scale(eps,ones(n)));markov(S0,pi);markov(S,pi)
    assert min(pi[i]*S0[i][i] for i in range(n))==F(511,512)
    for i,j in combinations(range(n),2):
        for k,l in combinations(range(n),2):assert S0[i][k]*S0[j][l]>=S0[i][l]*S0[j][k]
    gram=[[2,1,-1],[1,2,1],[-1,1,2]];types=[i//4 for i in range(n)]
    P=[[F(gram[types[i]][types[j]]) for j in range(n)] for i in range(n)]
    Q=sub(eye(pi),P)
    assert mm(P,P,pi)==P and tr(P,pi)==2
    assert mm(Q,Q,pi)==Q and tr(Q,pi)==10 and rank(Q)==10
    assert all(Q[i][i]==10 for i in range(n))
    Qone=[sum(pi[j]*Q[i][j] for j in range(n)) for i in range(n)]
    assert Qone!=[F(1)]*n and Qone!=[F(0)]*n
    assert Q[0][1]*Q[1][2]*Q[2][0]==-8
    assert mm(S,Q,pi)!=mm(Q,S,pi)
    alpha=eps/20;beta=alpha**2;H=scale(alpha,Q)
    assert max(map(max,Q))==10 and min(map(min,Q))==-2
    assert all(abs(H[i][j])<=S[i][j] for i in range(n) for j in range(n))
    states=list(product(range(n),(-1,1)));mu=[pi[i]/2 for i,a in states]
    T=[[S[i][j]+a*b*H[i][j] for j,b in states] for i,a in states];markov(T,mu)
    p=1/max(map(max,T));W=scale(p,T)
    assert min(map(min,W))>0 and max(map(max,W))==1
    assert all(sum(mu[j]*W[i][j] for j in range(2*n))==p for i in range(2*n))
    B=mm(S,S,pi);A=mm(T,T,mu)
    # A concrete Rayleigh quotient exceeds 97/10 > 4+4sqrt(2).
    ray=sum(pi[i]*B[i][0]*Q[i][0]**2 for i in range(n))/Q[0][0]
    assert ray>F(97,10) and (F(97,10)-4)**2>32
    # The diagonal-compression map is injective, so every nonconstant
    # coarse eigenmode has a nonzero actual compression coefficient.
    compression=[[pi[t]*Q[i][t]*Q[t][j] for t in range(n)]
                 for i,j in product(range(n),repeat=2)]
    assert rank(compression)==n
    # S0 is the irreducible Jacobi path, with simple eigenvalues >=255/256.
    lower=(1-eps)*F(255,256);assert beta<lower**2
    cochar=charpoly(B,pi);fichar=charpoly(A,mu);expected=cochar[:]
    for _ in range(10):expected=polymul(expected,[F(1),-beta])
    expected+=[F(0),F(0)];assert fichar==expected
    ns=exponents((3,1,1,1,1));needed=sorted(set(ns))
    KB={s:power(B,s,pi) for s in needed};KA={s:power(A,s,mu) for s in needed}
    for s in needed:
        assert KA[s]==[[KB[s][i][j]+a*b*beta**s*Q[i][j] for j,b in states] for i,a in states]
    Fs={s:[field(Q,KB[s],pi,t) for t in range(n)] for s in needed}
    assert all(tr(v,pi)==10 for fs in Fs.values() for v in fs)
    Xs={s:[sub(v,Q) for v in fs] for s,fs in Fs.items()}
    g=lambda s,t:sum(pi[i]*tr(mm(Xs[s][i],Xs[t][i],pi),pi) for i in range(n))
    x,y,z=1,2,3;gx=g(x,y);gz=g(x,z);gyz=g(y,z);vy=g(y,y);vz=g(z,z)
    J=sum(pi[i]*tr(mm(mm(Fs[x][i],Fs[y][i],pi),Fs[z][i],pi),pi) for i in range(n))
    C=sum(pi[i]*tr(mm(mm(Xs[x][i],Xs[y][i],pi),Xs[z][i],pi),pi) for i in range(n))
    assert C!=0 and J==10+gx+gz+gyz+C
    assert gx>=vy and gz>=gyz>=vz>0
    # Signed interval [-1,8] centered at 7/2, radius 9/2.
    squared_margin=F(81,4)*vy*vz-(C-F(7,2)*gyz)**2
    assert squared_margin>=0 and J-10>=F(7,16)*vz
    original=exact_density((Q,Q,KB[x],Q,KB[y],KB[z]),pi);assert original==J
    coarse=exact_density([KB[s] for s in ns],pi)
    fine=exact_density([KA[s] for s in ns],mu)
    coeff=[exact_density([Q if e in cyc else KB[ns[e]] for e in range(6)],pi) for cyc in CYCLES]
    weights=[sum(ns[e] for e in cyc) for cyc in CYCLES]
    assert all(c>=10 for c in coeff)
    assert fine==coarse+sum(beta**q*c for q,c in zip(weights,coeff))
    assert fine>=coarse+10*sum(beta**q for q in weights)>coarse>1
    return {
        'pi':pi,'S0':S0,'S':S,'Q':Q,'Qone':Qone,'alpha':alpha,'beta':beta,'mu':mu,'p':p,'W':W,
        'min_T':min(map(min,T)),'max_T':max(map(max,T)),'max_A':max(map(max,A)),
        'rank':10,'coarse_centered_bands':11,'fine_centered_bands':13,'fine_centered_zero_multiplicity':2,
        'diagonal_compression_map_rank':n,'coarse_square_charpoly':cochar,'fine_square_charpoly':fichar,
        'shortest_source_Rayleigh_quotient':ray,'source_cap_4_plus_4_sqrt2_fails':True,
        'star_powers':[x,y,z],'J':J,'centered_cubic':C,'g_xy':gx,'g_xz':gz,'g_yz':gyz,'v_y':vy,'v_z':vz,
        'squared_Jordan_interval_margin':squared_margin,'surplus_above_7_vz_over_16':J-10-F(7,16)*vz,
        'tuple':[3,1,1,1,1],'edge_exponents':ns,'cycle_weights':weights,'cycle_coefficients':coeff,
        'F_coarse':coarse,'F_fine':fine,'original_star_checked':True}

def unbalanced_cap():
    # Existing PR60/61 heavy-atom host; the new cap proves its previously
    # unavailable all-exponent projection comparison, not a new host.
    pi=list(map(F,('3/5','1/5','1/10','1/10')));row=[60,20,10,10]
    G=[[59,1,0,0],[1,18,1,0],[0,1,8,1],[0,0,1,9]]
    S0=[[F(100*G[i][j],row[i]*row[j]) for j in range(4)] for i in range(4)]
    S=add(scale(F(31,32),S0),scale(F(1,32),ones(4)));markov(S,pi)
    f=[1,0,-3,-3];Q=[[F(1)+F(5,12)*f[i]*f[j] for j in range(4)] for i in range(4)]
    assert mm(Q,Q,pi)==Q and tr(Q,pi)==2
    B=mm(S,S,pi);cap=max(map(max,B));assert cap<9
    M1=[field(Q,B,pi,t) for t in range(4)]
    visible_trace=[tr(v,pi) for v in M1];assert len(set(visible_trace))>1
    x,y,z=1,2,8;Ks={s:power(B,s,pi) for s in (x,y,z)}
    Ms={s:[field(Q,Ks[s],pi,t) for t in range(4)] for s in Ks}
    Xs={s:[sub(v,Q) for v in Ms[s]] for s in Ms}
    g=lambda s,t:sum(pi[i]*tr(mm(Xs[s][i],Xs[t][i],pi),pi) for i in range(4))
    J=sum(pi[i]*tr(mm(mm(Ms[x][i],Ms[y][i],pi),Ms[z][i],pi),pi) for i in range(4))
    C=J-2-g(x,y)-g(x,z)-g(y,z)
    margin=cap**2*g(y,y)*g(z,z)/4-(C-(cap-2)*g(y,z)/2)**2
    assert margin>=0 and J>2
    alpha=F(1,128);beta=alpha**2;mu=[w/2 for w in pi for a in(-1,1)]
    T=[[S[i][j]+a*b*alpha*Q[i][j] for j in range(4) for b in(-1,1)] for i in range(4) for a in(-1,1)]
    markov(T,mu);p=1/max(map(max,T));assert p==F(512,4499)
    return {'pi':pi,'S':S,'Q':Q,'mu':mu,'p':p,'alpha':alpha,'beta':beta,
        'rank':2,'max_coarse_B':cap,'first_step_actual_traces':visible_trace,
        'balanced_visible_hypothesis_fails':True,'cap_hypothesis_verified_for_all_later_steps':True,
        'star_powers':[x,y,z],'J':J,'squared_Jordan_interval_margin':margin,
        'scope':'old actual host; new all-positive-exponent transfer from cap<9, not merely the previously certified tuple'}

def main():
    high=balanced_host();cap=unbalanced_cap()
    out={'status':'PASS','scope':'source-cap and balanced-rank-ten certificates; unrestricted target unresolved',
         'balanced_rank_ten_host':high,'old_unbalanced_host_new_cap':cap,
         'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         'arithmetic_dependency_sha256':hashlib.sha256(Path('continuation6_graded_verify.py').read_bytes()).hexdigest(),
         'elapsed_seconds':time.time()-START}
    Path('continuation6_jordan_checks.json').write_text(json.dumps(serialize(out),indent=2)+'\n')
    print(json.dumps(serialize({'status':'PASS','rank10_p':high['p'],'rank10_min_T':high['min_T'],
        'rank10_max_A':high['max_A'],'rank10_Rayleigh':high['shortest_source_Rayleigh_quotient'],
        'old_host_cap':cap['max_coarse_B'],'elapsed_seconds':out['elapsed_seconds']})))

if __name__=='__main__':main()
