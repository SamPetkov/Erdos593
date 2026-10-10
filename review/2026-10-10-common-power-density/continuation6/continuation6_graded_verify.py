"""Exact original-measure rank-four graded-source certificate.

Standard library only. No numerical diagonalization or optimization.
The complete density is integrated independently as an integer numerator.
"""
from fractions import Fraction as F
from itertools import product, combinations
from pathlib import Path
from math import lcm
import hashlib, json, time

START=time.time()
EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
CYCLES=((0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,3,5,2),(0,4,5,1),(1,3,4,2))

def mm(a,b,pi):
    return [[sum(pi[k]*a[i][k]*b[k][j] for k in range(len(pi)))
             for j in range(len(b[0]))] for i in range(len(a))]
def eye(pi):return [[F(i==j)/pi[i] for j in range(len(pi))] for i in range(len(pi))]
def ones(n):return [[F(1) for _ in range(n)] for _ in range(n)]
def add(a,b):return [[x+y for x,y in zip(r,s)] for r,s in zip(a,b)]
def scale(c,a):return [[c*x for x in r] for r in a]
def sub(a,b):return add(a,scale(-1,b))
def tr(a,pi):return sum(pi[i]*a[i][i] for i in range(len(pi)))
def power(a,n,pi):
    ans=eye(pi)
    while n:
        if n&1:ans=mm(ans,a,pi)
        a=mm(a,a,pi);n//=2
    return ans
def markov(a,pi):
    assert all(a[i][j]==a[j][i]>=0 for i in range(len(pi)) for j in range(len(pi)))
    assert all(sum(pi[j]*a[i][j] for j in range(len(pi)))==1 for i in range(len(pi)))
def exponents(t):
    k,u,r,l,h=t
    assert all(type(v)is int for v in t) and k>=u>=1 and r>=l>=1 and h>=1
    return (k,r+h,u,r,u,l)
def exact_density(kernels,pi):
    # This four-vertex integral does not use the cycle or source identities.
    q=lcm(*(v.denominator for v in pi));w=[int(q*v) for v in pi]
    ds=[lcm(*(v.denominator for row in a for v in row)) for a in kernels]
    ints=[[[int(d*v) for v in row] for row in a] for d,a in zip(ds,kernels)]
    out=0
    for a,b,c,d in product(range(len(pi)),repeat=4):
        out+=w[a]*w[b]*w[c]*w[d]*ints[0][a][b]*ints[1][a][c]*ints[2][a][d]*ints[3][b][c]*ints[4][b][d]*ints[5][c][d]
    den=q**4
    for d in ds:den*=d
    return F(out,den)
def charpoly(a,pi):
    n=len(pi);b=eye(pi);out=[F(1)]
    for k in range(1,n+1):
        ab=mm(a,b,pi);c=-tr(ab,pi)/k;out.append(c);b=add(ab,scale(c,eye(pi)))
    assert all(v==0 for row in b for v in row)
    return out
def polymul(a,b):
    out=[F(0)]*(len(a)+len(b)-1)
    for i,v in enumerate(a):
        for j,w in enumerate(b):out[i+j]+=v*w
    return out
def rank(a):
    a=[list(map(F,r)) for r in a];r=0
    for j in range(len(a[0])):
        p=next((p for p in range(r,len(a)) if a[p][j]),None)
        if p is None:continue
        a[r],a[p]=a[p],a[r];v=a[r][j];a[r]=[z/v for z in a[r]]
        for p in range(len(a)):
            if p!=r:
                v=a[p][j];a[p]=[x-v*y for x,y in zip(a[p],a[r])]
        r+=1
        if r==len(a):break
    return r
def serialize(x):
    if isinstance(x,F):return str(x)
    if isinstance(x,dict):return {str(k):serialize(v) for k,v in x.items()}
    if isinstance(x,(tuple,list)):return [serialize(v) for v in x]
    return x

def make_host():
    pi=list(map(F,('3/16','3/16','5/16','5/16')))
    flow=[[F(0) for _ in pi] for _ in pi]
    for i in range(3):flow[i][i+1]=flow[i+1][i]=F(1,64)
    for i in range(4):flow[i][i]=pi[i]-sum(flow[i])
    S0=[[flow[i][j]/(pi[i]*pi[j]) for j in range(4)] for i in range(4)]
    S=add(scale(F(15,16),S0),scale(F(1,16),ones(4)))
    markov(S0,pi);markov(S,pi)
    assert min(pi[i]*S0[i][i] for i in range(4))==F(5,6)
    minors=[S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k]
            for i,j in combinations(range(4),2) for k,l in combinations(range(4),2)]
    assert min(minors)>=0
    Id2=[[F(1),F(0)],[F(0),F(1)]]
    Rot=[[F(-3,5),F(-4,5)],[F(4,5),F(-3,5)]]
    RotT=list(map(list,zip(*Rot)))
    rotations=[Id2,Id2,Rot,RotT]
    vectors=[];Cs=[]
    for i,rot in enumerate(rotations):
        assert mm(rot,list(map(list,zip(*rot))),[F(1),F(1)])==Id2
        vs=[[rot[0][a],rot[1][a],F(a==0),F(a==1)] for a in range(2)]
        if i==0:vs[0]=[-v for v in vs[0]] # signed gauge: does not change C_i
        vectors.extend(vs)
        Cs.append([[sum(v[a]*v[b] for v in vs) for b in range(4)] for a in range(4)])
    Id=eye([F(1)]*4)
    assert [[sum(pi[i]*Cs[i][a][b] for i in range(4)) for b in range(4)] for a in range(4)]==Id
    Xs=[sub(c,Id) for c in Cs]
    grading=[[F((1 if i<2 else -1) if i==j else 0) for j in range(4)] for i in range(4)]
    for x in Xs:assert mm(mm(grading,x,[F(1)]*4),grading,[F(1)]*4)==scale(-1,x)
    for x,y,z in product(Xs,repeat=3):assert tr(mm(mm(x,y,[F(1)]*4),z,[F(1)]*4),[F(1)]*4)==0
    negative_mixed_trace=tr(mm(mm(Cs[0],Cs[2],[F(1)]*4),Cs[3],[F(1)]*4),[F(1)]*4)
    assert negative_mixed_trace==-F(48,25)
    pp=[v/2 for v in pi for a in range(2)]
    SS=[[S[i//2][j//2] for j in range(8)] for i in range(8)]
    Q=[[2*sum(v*w for v,w in zip(vectors[i],vectors[j])) for j in range(8)] for i in range(8)]
    markov(SS,pp);assert mm(Q,Q,pp)==Q and tr(Q,pp)==4 and rank(Q)==4
    assert set(Q[i][i] for i in range(8))=={F(4)}
    Qone=[sum(pp[j]*Q[i][j] for j in range(8)) for i in range(8)]
    assert Qone!=[F(0)]*8 and Qone!=[F(1)]*8
    assert mm(SS,Q,pp)!=mm(Q,SS,pp)
    negative_triangles=[(i,j,k,Q[i][j]*Q[j][k]*Q[k][i]) for i,j,k in combinations(range(8),3) if Q[i][j]*Q[j][k]*Q[k][i]<0]
    assert negative_triangles
    alpha=F(1,128);beta=alpha**2;H=scale(alpha,Q)
    assert mm(H,H,pp)==scale(beta,Q)
    assert all(abs(H[i][j])<=SS[i][j] for i in range(8) for j in range(8))
    states=list(product(range(8),(-1,1)));mu=[pp[i]/2 for i,a in states]
    T=[[SS[i][j]+a*b*H[i][j] for j,b in states] for i,a in states]
    markov(T,mu);p=1/max(map(max,T));W=scale(p,T)
    assert p==F(96,449) and min(map(min,T))>=F(1,32)
    assert min(map(min,W))>0 and max(map(max,W))==1
    assert all(sum(mu[j]*W[i][j] for j in range(16))==p for i in range(16))
    B=mm(S,S,pi);BB=mm(SS,SS,pp);A=mm(T,T,mu)
    assert BB==[[B[i//2][j//2] for j in range(8)] for i in range(8)]
    # Frame coordinates use psi=sqrt(2)*v; their actual rank-one fields are 2vv^T.
    Rs=[[[2*v[a]*v[b] for b in range(4)] for a in range(4)] for v in vectors]
    assert all(tr(mm(mm(sub(r,Id),sub(r,Id),[F(1)]*4),sub(r,Id),[F(1)]*4),[F(1)]*4)==24 for r in Rs)
    field1=[[[sum(pp[j]*BB[t][j]*Rs[j][a][b] for j in range(8)) for b in range(4)] for a in range(4)] for t in range(8)]
    coarse1=[[[sum(pi[j]*B[t][j]*Cs[j][a][b] for j in range(4)) for b in range(4)] for a in range(4)] for t in range(4)]
    assert field1==[coarse1[t//2] for t in range(8)]
    for m in field1:assert mm(mm(grading,sub(m,Id),[F(1)]*4),grading,[F(1)]*4)==scale(-1,sub(m,Id))
    # Every centered coarse eigenmode is visible: the generated centered
    # coefficient fields have rank 3. Simplicity is proved by the Jacobi path.
    obs=[]
    for n in range(4):
        bn=power(B,n,pi)
        for a,b in product(range(4),repeat=2):
            obs.append([sum(pi[j]*bn[t][j]*Xs[j][a][b] for j in range(4)) for t in range(4)])
    assert rank(obs)==3
    cochar=charpoly(B,pi);widechar=charpoly(BB,pp);fichar=charpoly(A,mu)
    assert widechar==polymul(cochar,[F(1),F(0),F(0),F(0),F(0)])
    expect=cochar[:]
    for _ in range(4):expect=polymul(expect,[F(1),-beta])
    expect+=([F(0)]*8)
    assert fichar==expect and beta<F(25,64)
    return locals()

def main():
    h=make_host();pi,S,B,Cs=h['pi'],h['S'],h['B'],h['Cs'];pp,SS,BB,Q=h['pp'],h['SS'],h['BB'],h['Q']
    mu,T,A,beta=h['mu'],h['T'],h['A'],h['beta'];Id=eye([F(1)]*4);unit=[F(1)]*4
    tuples=[(3,1,1,1,1),(1,1,2,1,6),(1,1,1,1,1)]
    needed=sorted({v for tpl in tuples for v in exponents(tpl)})
    KB={n:power(B,n,pi) for n in needed};KBB={n:power(BB,n,pp) for n in needed};KA={n:power(A,n,mu) for n in needed}
    for n in needed:
        assert KBB[n]==[[KB[n][i//2][j//2] for j in range(8)] for i in range(8)]
        assert KA[n]==[[KBB[n][i][j]+a*b*beta**n*Q[i][j] for j,b in h['states']] for i,a in h['states']]
    fields={n:[[[sum(pi[j]*KB[n][t][j]*Cs[j][a][b] for j in range(4)) for b in range(4)] for a in range(4)] for t in range(4)] for n in needed}
    stars=[]
    for xyz in [(1,2,3),(1,2,8),(1,1,1),(1,1,2)]:
        ms=[fields[s] for s in xyz];xs=[[sub(m,Id) for m in fs] for fs in ms]
        J=sum(pi[t]*tr(mm(mm(ms[0][t],ms[1][t],unit),ms[2][t],unit),unit) for t in range(4))
        pairs=[sum(pi[t]*tr(mm(xs[a][t],xs[b][t],unit),unit) for t in range(4)) for a,b in combinations(range(3),2)]
        cubic=sum(pi[t]*tr(mm(mm(xs[0][t],xs[1][t],unit),xs[2][t],unit),unit) for t in range(4))
        assert cubic==0 and min(pairs)>=0 and J==4+sum(pairs)>4
        x,y,z=xyz
        original=exact_density((Q,Q,KBB[x],Q,KBB[y],KBB[z]),pp)
        assert original==J
        stars.append({'powers':xyz,'J':J,'pair_surpluses':pairs,'cubic':cubic,'original_projection_integral':original})
    rows=[]
    for tpl in tuples:
        ns=exponents(tpl);coarse=exact_density([KB[n] for n in ns],pi)
        pulled=exact_density([KBB[n] for n in ns],pp);fine=exact_density([KA[n] for n in ns],mu)
        assert pulled==coarse>1
        coeff=[exact_density([Q if e in cyc else KBB[ns[e]] for e in range(6)],pp) for cyc in CYCLES]
        weights=[sum(ns[e] for e in cyc) for cyc in CYCLES]
        assert all(v>=4 for v in coeff)
        assert fine==coarse+sum(beta**q*c for q,c in zip(weights,coeff))
        lower=coarse+4*sum(beta**q for q in weights)
        assert fine>=lower>coarse>1
        k,u,r,l,hh=tpl
        rows.append({'tuple':tpl,'exponents':ns,'reflection':(k==u and r==l)or(k==r and u==l)or(k==r+hh and u==l),'F_base':coarse,'F_pullback':pulled,'F_fine':fine,'cycle_weights':weights,'cycle_coefficients':coeff,'lower_bound_with_exact_base':lower})
    # Equality and null-mode checks for the same actual projection.
    refresh=ones(8);Mrefresh=[[[sum(pp[j]*h['Rs'][j][a][b] for j in range(8)) for b in range(4)] for a in range(4)] for t in range(8)]
    assert all(v==Id for v in Mrefresh)
    assert exact_density((Q,Q,refresh,Q,refresh,refresh),pp)==4
    zeroH=[[F(0) for _ in range(8)] for _ in range(8)]
    Tzero=[[SS[i][j] for j,b in h['states']] for i,a in h['states']]
    markov(Tzero,mu)
    Kzero=power(Tzero,2,mu);assert exact_density([power(Kzero,n,mu) for n in exponents(tuples[0])],mu)==rows[0]['F_base']
    # A varying-trace field in the line with vanishing cubic trace.
    D=[F(1),F(12),F(-9),F(-10)];tt=[F(1,100),F(-1,100),F(1,100),F(-1,100)]
    assert sum(pi[i]*tt[i] for i in range(4))==0 and sum(v**3 for v in D)==0 and sum(D)==-6
    vals={s:[sum(pi[j]*KB[s][t][j]*tt[j] for j in range(4)) for t in range(4)] for s in (1,2,3)}
    varying_J=sum(pi[t]*sum((1+vals[1][t]*v)*(1+vals[2][t]*v)*(1+vals[3][t]*v) for v in D) for t in range(4))
    varying_pair=sum(v*v for v in D)*sum(sum(pi[t]*vals[s][t]*vals[u][t] for t in range(4)) for s,u in combinations((1,2,3),2))
    assert varying_J==4+varying_pair>=4
    out={'status':'PASS','scope':'restricted cubic-subspace contraction and actual rank-four transfer; unrestricted target unresolved',
         'tuple_order':['k','u','r','l','h'],'edge_order':EDGES,'cycle_order':CYCLES,
         'host':{k:h[k] for k in ('pi','flow','S0','S','pp','SS','Q','Qone','alpha','beta','mu','p','W','negative_triangles','negative_mixed_trace','cochar','widechar','fichar')},
         'min_T':min(map(min,T)),'max_T':max(map(max,T)),'max_A':max(map(max,A)),
         'base_TP2_minors_checked':36,'coarse_visible_centered_rank':3,'full_fine_centered_bands':5,'centered_zero_multiplicity':8,'projection_rank':4,
         'source_condition':'only required after one positive smoothing step; raw centered rank-one cubes have trace 24',
         'stars':stars,'actual_root_tuple_checks':rows,'refresh_star_equality':4,'zero_channel_density_checked':True,
         'varying_trace_line':{'D':D,'t':tt,'J':varying_J,'pair_surplus':varying_pair},
         'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'elapsed_seconds':time.time()-START}
    Path('continuation6_graded_checks.json').write_text(json.dumps(serialize(out),indent=2)+'\n')
    print(json.dumps(serialize({k:out[k] for k in ('status','min_T','max_T','max_A','projection_rank','full_fine_centered_bands','centered_zero_multiplicity','coarse_visible_centered_rank','elapsed_seconds')})))
    print('ALL_EXACT_GRADED_CHECKS_PASSED')

if __name__=='__main__':main()
