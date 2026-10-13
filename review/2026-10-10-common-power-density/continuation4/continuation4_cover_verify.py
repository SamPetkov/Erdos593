"""Exact audit of canonical two-cover channels; rational arithmetic throughout.

No decimal sign is used. The general rank/commutation results are proved in
continuation4_cover_structure.md. The finite cover checks do not prove the
unrestricted target or its complete-cover sufficient lemma.
"""
from fractions import Fraction as Q
from itertools import combinations,product
from pathlib import Path
import hashlib,json
import numpy as np
from continuation_cover_engine import exact_integer_certificate

EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
CYCLES=((0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,2,3,5),(0,1,4,5),(1,2,3,4))

def eye(n):return [[Q(i==j) for j in range(n)] for i in range(n)]
def mm(a,b):return [[sum(a[i][k]*b[k][j] for k in range(len(b))) for j in range(len(b[0]))] for i in range(len(a))]
def tr(a):return sum(a[i][i] for i in range(len(a)))
def transpose(a):return [list(x) for x in zip(*a)]
def weighted(a,b,mu):return mm([[a[i][j]*mu[j] for j in range(len(mu))] for i in range(len(a))],b)
def power(a,m,mu):
    n=len(mu);out=[[Q(i==j)/mu[i] for j in range(n)] for i in range(n)]
    for _ in range(m):out=weighted(out,a,mu)
    return out

def kernels(G,tpl):
    n=len(G);rows=[sum(row) for row in G];total=sum(rows);mu=[Q(x,total) for x in rows]
    T=[[Q(total*G[i][j],rows[i]*rows[j]) for j in range(n)] for i in range(n)]
    assert all(x>=0 for row in T for x in row) and T==transpose(T)
    assert [sum(mu[j]*T[i][j] for j in range(n)) for i in range(n)]==[1]*n
    p=1/max(x for row in T for x in row)
    k,u,r,l,h=tpl;n_e=(k,r+h,u,r,u,l)
    return mu,T,p,[power(T,2*q,mu) for q in n_e],n_e

def pair_data(T,mu):
    n=len(mu);pairs=list(combinations(range(n),2))+[(i,i) for i in range(n)]
    pi=[mu[x]*mu[y]*(1 if x==y else 2) for x,y in pairs]
    S=[[Q(T[x][z]*T[y][w]+T[x][w]*T[y][z],2) for z,w in pairs] for x,y in pairs]
    H=[[Q(T[x][z]*T[y][w]-T[x][w]*T[y][z],2) for z,w in pairs] for x,y in pairs]
    return pairs,pi,S,H

def density(mu,M):
    n=len(mu);ans=Q(0)
    for x in product(range(n),repeat=4):
        z=mu[x[0]]*mu[x[1]]*mu[x[2]]*mu[x[3]]
        for e,(a,b) in enumerate(EDGES):z*=M[e][x[a]][x[b]]
        ans+=z
    return ans

def strmatrix(a):return [[str(x) for x in row] for row in a]
def rank(a):
    b=[[Q(x) for x in row] for row in a];m=len(b);n=len(b[0]);r=0
    for j in range(n):
        pivot=next((i for i in range(r,m) if b[i][j]),None)
        if pivot is None:continue
        b[r],b[pivot]=b[pivot],b[r];d=b[r][j];b[r]=[x/d for x in b[r]]
        for i in range(r+1,m):
            z=b[i][j]
            if z:b[i]=[x-z*y for x,y in zip(b[i],b[r])]
        r+=1
        if r==m:break
    return r
def det(a):
    b=[[Q(x) for x in row] for row in a];n=len(b);ans=Q(1)
    for j in range(n):
        pivot=next((i for i in range(j,n) if b[i][j]),None)
        if pivot is None:return Q(0)
        if pivot!=j:b[j],b[pivot]=b[pivot],b[j];ans=-ans
        d=b[j][j];ans*=d;b[j]=[x/d for x in b[j]]
        for i in range(j+1,n):
            z=b[i][j]
            if z:b[i]=[x-z*y for x,y in zip(b[i],b[j])]
    return ans
def charpoly(a):
    n=len(a);p=eye(n);traces=[Q(0)]
    for _ in range(n):p=mm(p,a);traces.append(tr(p))
    e=[Q(1)]
    for k in range(1,n+1):e.append(sum((-1)**(i-1)*e[k-i]*traces[i] for i in range(1,k+1))/k)
    return [(-1)**i*e[i] for i in range(n+1)]

def verify_case(name,G,tpl,full_covers=False):
    mu,T,p,Ks,ep=kernels(G,tpl);n=len(mu);pairs,pi,S,H=pair_data(T,mu);N=len(pi)
    assert sum(pi)==1 and all(x>0 for x in pi)
    assert S==transpose(S) and H==transpose(H)
    assert all(abs(H[i][j])<=S[i][j] for i in range(N) for j in range(N))
    assert [sum(pi[j]*S[i][j] for j in range(N)) for i in range(N)]==[1]*N
    for i,(x,y) in enumerate(pairs):
        if x==y:assert all(H[i][j]==H[j][i]==0 for j in range(N))
    r=rank(T);s=rank(S);h=rank(H)
    assert s==r*(r+1)//2 and h==r*(r-1)//2
    A=power(T,2,mu);S2=power(S,2,pi);H2=power(H,2,pi)
    _,pi2,AS,AH=pair_data(A,mu)
    assert pi2==pi and S2==AS and H2==AH
    for m in (1,2,3):
        tm=power(T,m,mu);sm=power(S,m,pi);hm=power(H,m,pi)
        trtm=sum(mu[i]*tm[i][i] for i in range(n))
        trt2m=sum(mu[i]*power(T,2*m,mu)[i][i] for i in range(n))
        assert sum(pi[i]*sm[i][i] for i in range(N))==(trtm**2+trt2m)/2
        assert sum(pi[i]*hm[i][i] for i in range(N))==(trtm**2-trt2m)/2
        _,_,expected_s,expected_h=pair_data(tm,mu)
        assert sm==expected_s and hm==expected_h
    commute=weighted(S,H,pi)==weighted(H,S,pi)
    squares_commute=weighted(S2,H2,pi)==weighted(H2,S2,pi)
    is_involution=A==[[Q(i==j)/mu[i] for j in range(n)] for i in range(n)]
    if r==n:assert commute==squares_commute==is_involution
    states=list(product(range(N),(-1,1)));muh=[pi[i]/2 for i,a in states]
    That=[[S[i][j]+H[i][j]*a*b for j,b in states] for i,a in states]
    assert all(x>=0 for row in That for x in row)
    assert max(x for row in That for x in row)*p*p<=1
    assert [sum(muh[j]*That[i][j] for j in range(len(states))) for i in range(len(states))]==[1]*len(states)
    # Direct doubled-state composition, independent of the pair-power formula.
    That2=weighted(That,That,muh)
    assert That2==[[S2[i][j]+H2[i][j]*a*b for j,b in states] for i,a in states]
    result={'name':name,'flow':G,'tuple':tpl,'mu':list(map(str,mu)),'p':str(p),'root':strmatrix(T),'pair_mu':list(map(str,pi)),
            'ranks':{'original':r,'coarse':s,'channel':h},'channels_commute':commute,'squared_channels_commute':squares_commute,'root_is_involution':is_involution}
    if full_covers:
        cs=[];ch=[]
        for K,e in zip(Ks,ep):
            _,_,ss,hh=pair_data(K,mu);assert ss==power(S,2*e,pi) and hh==power(H,2*e,pi)
            cs.append(ss);ch.append(hh)
        gammas=[density(pi,[ch[e] if e in C else cs[e] for e in range(6)]) for C in CYCLES]
        coarse=density(pi,cs);base=density(mu,Ks)
        assert base*base==coarse+sum(gammas)
        zvals=[]
        for bits in range(8):
            key=tuple((1,0) if (bits>>e)&1 else (0,1) for e in range(3))
            cert=exact_integer_certificate(np.array(G,dtype=object),tpl,key)
            f=Q(cert['base_numerator'],cert['base_denominator']);z=Q(cert['cover_numerator'],cert['cover_denominator'])
            assert f==base
            signs=[1,1,1]+[(-1 if (bits>>e)&1 else 1) for e in range(3)]
            odd=[j for j,C in enumerate(CYCLES) if np.prod([signs[e] for e in C])==-1]
            assert len(odd)==(4 if bits else 0)
            assert base*base-z==2*sum(gammas[j] for j in odd)
            zvals.append(z)
        assert sum(zvals)/8==coarse
        result.update({'base_density':str(base),'coarse_density':str(coarse),'cycle_coefficients':list(map(str,gammas)),
                       'cover_densities':list(map(str,zvals)),'all_seven_comparisons_hold_in_this_case':all(z<=base*base for z in zvals),
                       'all_seven_cycle_coefficients_nonnegative_in_this_case':all(x>=0 for x in gammas)})
    if name=='uniform_flat_three':
        assert (H2[0][1],H2[0][2],H2[1][2])==(Q(9,32),-Q(9,32),Q(9,32))
        assert H2[0][1]*H2[0][2]*H2[1][2]<0
        result['frustrated_triangle']=list(map(str,(H2[0][1],H2[0][2],H2[1][2])))
    if name in ('weighted_three_bands','weighted_three_positive_plus_zero'):
        M=[[T[i][j]*mu[j] for j in range(n)] for i in range(n)];poly=charpoly(M)
        center=[poly[0]]
        for a in poly[1:-1]:center.append(a+center[-1])
        assert poly[-1]+center[-1]==0
        positive_center=center
        if name=='weighted_three_positive_plus_zero':
            assert center[-1]==0
            positive_center=center[:-1]
        a,b,c,d=positive_center;disc=b*b*c*c-4*a*c**3-4*b**3*d-27*a*a*d*d+18*a*b*c*d
        assert disc!=0
        minors=[det([row[:i] for row in G[:i]]) for i in range(1,n+1)]
        if name=='weighted_three_bands':assert all(z>0 for z in minors)
        else:
            V0=[[1,0,0,0],[0,2,0,0],[0,0,3,0],[0,0,0,4],[1,1,1,1]]
            assert G==mm(V0,transpose(V0)) and r==4
        assert sum(center)!=0
        result['leading_principal_minors']=list(map(str,minors));result['centered_root_polynomial_descending_coefficients']=list(map(str,center));result['three_distinct_positive_centered_square_values']=True
        result['additional_centered_zero_value']=name=='weighted_three_positive_plus_zero'
    print('EXACT_CASE_OK',name,flush=True)
    return result

CASES=[('singleton',[[1]],(1,1,1,1,1),True),
       ('weighted_constant',[[1,2,3],[2,4,6],[3,6,9]],(1,1,1,1,1),True),
       ('weighted_involution',[[0,1,0],[1,0,0],[0,0,2]],(1,1,1,1,1),True),
       ('weighted_rank_two',[[1,1,2],[1,2,3],[2,3,5]],(1,1,1,1,1),True),
       ('uniform_flat_three',[[4,1,1],[1,4,1],[1,1,4]],(1,1,1,1,1),True),
       ('weighted_three_bands',[[1,1,0,0],[1,7,2,0],[0,2,13,1],[0,0,1,23]],(1,1,1,1,1),True),
       ('weighted_three_positive_plus_zero',[[1,0,0,0,1],[0,4,0,0,2],[0,0,9,0,3],[0,0,0,16,4],[1,2,3,4,4]],(2,1,2,1,1),False),
       ('weighted_unequal',[[3,1,0],[1,4,2],[0,2,1]],(3,1,2,1,3),True)]

if __name__=='__main__':
    results=[verify_case(*c) for c in CASES]
    # A direct finite cubic check for the inherited natural eigenfunctions:
    states=[]
    for R in product((-1,1),repeat=6):
        ab,ac,ad,bc,bd,cd=R
        if ab*ac*ad+ab*bc*bd+ac*bc*cd-ad*bd*cd==2:states.append(R)
    assert len(states)==32
    stars=((0,1,2),(0,3,4),(1,3,5),(2,4,5))
    original=[sum(Q(R[i]*R[j]*R[k],32) for R in states) for i,j,k in stars]
    # psi=(R(x)+R(y))/sqrt(2), so its cubic coefficient times sqrt(2)
    # equals the following rational sum with denominator 2.
    induced_times_sqrt2=[sum(Q((X[i]+Y[i])*(X[j]+Y[j])*(X[k]+Y[k]),2*32**2) for X in states for Y in states) for i,j,k in stars]
    assert original==induced_times_sqrt2==[Q(1,2),Q(1,2),Q(1,2),-Q(1,2)]
    assert np.prod(original)/4==-Q(1,64)
    doc=Path('continuation4_cover_structure.md');src=Path(__file__)
    out={'status':'exact finite verification; no unrestricted sign theorem','source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),
         'note_sha256':hashlib.sha256(doc.read_bytes()).hexdigest(),'case_count':len(results),'full_cover_comparisons':7*sum(c[3] for c in CASES),
         'cases':results,'induced_four_star_product':'-1/64'}
    Path('continuation4_cover_checks.json').write_text(json.dumps(out,indent=2)+'\n')
    print('ALL_EXACT_CHECKS_PASSED',len(results),flush=True)
