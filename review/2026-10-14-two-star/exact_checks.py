#!/usr/bin/env python3
"""Exact checks for the two-star smoothing continuation.
Standard library only. Rational identities and rigorous dyadic log enclosures.
These finite checks do not prove the unrestricted theorem.
"""
from fractions import Fraction as Q
from itertools import product, combinations
from functools import lru_cache
from pathlib import Path
import json
from math import isqrt

COUNT=0
E=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
FULL=tuple(range(6))
PROPER=[]
for m in range(1,6):
    for H in combinations(FULL,m):
        deg=[sum(v in E[e] for e in H) for v in range(4)]
        if 1 not in deg: PROPER.append(H)
assert len(PROPER)==13

def check(p,msg):
    global COUNT
    if not p: raise AssertionError(msg)
    COUNT+=1

def matmul(A,B,mu):
    n=len(mu)
    return [[sum((mu[k]*A[i][k]*B[k][j] for k in range(n)),Q(0)) for j in range(n)] for i in range(n)]
def powers(T,mu,M):
    n=len(mu);out=[[[Q(i==j)/mu[j] for j in range(n)] for i in range(n)]]
    for _ in range(M): out.append(matmul(out[-1],T,mu))
    return out

def rootcheck(T,mu):
    n=len(mu)
    check(sum(mu)==1 and min(mu)>0,'positive probability')
    check(all(T[i][j]==T[j][i] and T[i][j]>=0 for i in range(n) for j in range(n)),'actual symmetric nonnegative root')
    check(all(sum(mu[j]*T[i][j] for j in range(n))==1 for i in range(n)),'relative Markov rows')

# log(x) enclosure. On y in [1,2], z=(y-1)/(y+1) is in [0,1/3].
# log y = 2 sum_{j=0}^{M-1} z^(2j+1)/(2j+1) + positive remainder.
# Remainder <= 3^(-2M). Directed integer rounding encloses every operation.
BITS=256; SCALE=1<<BITS; TERMS=100

def ceildiv(a,b): return -((-a)//b)

def log_unit(y):
    check_local = (Q(1)<=y<=Q(2))
    if not check_local: raise ValueError('range')
    z=(y-1)/(y+1)
    lo=(z.numerator*SCALE)//z.denominator
    hi=ceildiv(z.numerator*SCALE,z.denominator)
    slo=lo*lo//SCALE;shi=ceildiv(hi*hi,SCALE)
    plo,phi=lo,hi;L=U=0
    for j in range(TERMS):
        den=2*j+1
        L+=plo//den;U+=ceildiv(phi,den)
        plo=plo*slo//SCALE;phi=ceildiv(phi*shi,SCALE)
    tail=ceildiv(SCALE,3**(2*TERMS))
    return Q(2*L,SCALE),Q(2*U+tail,SCALE)
LOG2=log_unit(Q(2))

@lru_cache(None)
def log_bounds(x):
    x=Q(x)
    if x<=0: raise ValueError('log nonpositive')
    if x==1:return Q(0),Q(0)
    exponent=x.numerator.bit_length()-x.denominator.bit_length()
    factor=Q(2**exponent) if exponent>=0 else Q(1,2**(-exponent))
    y=x/factor
    if y<1:y*=2;exponent-=1
    if y>=2:y/=2;exponent+=1
    L,U=log_unit(y)
    if exponent>=0:return L+exponent*LOG2[0],U+exponent*LOG2[1]
    return L+exponent*LOG2[1],U+exponent*LOG2[0]

def add_interval(A,B):return A[0]+B[0],A[1]+B[1]
def scale_interval(q,A):
    return (q*A[0],q*A[1]) if q>=0 else (q*A[1],q*A[0])

def rational_bracket(A,lo,hi,msg):
    check(Q(lo)<A[0] and A[1]<Q(hi),msg)

def tensor(A,mu,B,nu):
    ii=list(product(range(len(mu)),range(len(nu))))
    rho=[mu[i]*nu[j] for i,j in ii]
    T=[[A[i][k]*B[j][l] for k,l in ii] for i,j in ii]
    return T,rho


def entropy_density(f,weights):
    out=(Q(0),Q(0))
    for z,val in f.items():
        if val:out=add_interval(out,scale_interval(weights[z]*val,log_bounds(val)))
    return out

def cross_entropy(f,g,weights):
    out=(Q(0),Q(0))
    for z,val in f.items():
        if val:
            if g[z]<=0:raise ValueError('unsupported logarithm')
            out=add_interval(out,scale_interval(weights[z]*val,log_bounds(g[z])))
    return out

def sub_interval(A,B):return A[0]-B[1],A[1]-B[0]

def apply_product(f,matrices,mu):
    n=len(mu);keys=list(product(range(n),repeat=3));out=f
    for axis,L in enumerate(matrices):
        nxt={}
        for key in keys:
            acc=Q(0)
            for y in range(n):
                src=list(key);src[axis]=y
                acc+=mu[y]*L[key[axis]][y]*out[tuple(src)]
            nxt[key]=acc
        out=nxt
    return out

def original_density(T,mu,tup):
    k,u,r,l,h=tup; ns=(k,r+h,u,r,u,l)
    pw=powers(T,mu,2*max(ns));out=Q(0)
    for x in product(range(len(mu)),repeat=4):
        term=Q(1)
        for a in x:term*=mu[a]
        for (a,b),e in zip(E,ns):term*=pw[2*e][x[a]][x[b]]
        out+=term
    return out

def two_star(name,T,mu,pars,original=None,require_long=True):
    rootcheck(T,mu);k,p,q,s,t,l=pars;n=len(mu)
    check(p>=s>=1 and q>=t>=1 and l>=1,'componentwise star comparison')
    check(k>=1,'positive long-edge parameter')
    if require_long:check(k>=s+t,'long-edge premise')
    Mmax=max(2*max(pars),2*(s+t),p+s,q+t,k+s+t)
    pw=powers(T,mu,Mmax);K=lambda j:pw[2*j]
    keys=list(product(range(n),repeat=3));wt={x:mu[x[0]]*mu[x[1]]*mu[x[2]] for x in keys}
    f={x:K(s)[x[0]][x[2]]*K(t)[x[1]][x[2]] for x in keys}
    g={x:sum((mu[z]*K(p)[x[0]][z]*K(q)[x[1]][z]*K(l)[x[2]][z] for z in range(n)),Q(0)) for x in keys}
    M={x:sum((mu[z]*pw[p+s][x[0]][z]*pw[q+t][x[1]][z]*pw[l][x[2]][z] for z in range(n)),Q(0)) for x in keys}
    Pm=[pw[p-s],pw[q-t],pw[l]]
    Pf=apply_product(f,Pm,mu);P2f=apply_product(Pf,Pm,mu)
    check(Pf==M,'actual product smoothing midpoint identity')
    check(P2f==g,'actual product smoothing square identity')
    check(sum(wt[x]*f[x] for x in keys)==1,'reference law normalized')
    check(sum(wt[x]*M[x] for x in keys)==1,'midpoint law normalized')
    check(sum(wt[x]*g[x] for x in keys)==1,'target star density normalized')
    check(all(g[x]>0 for x in keys if f[x]>0),'star logarithm supported')
    for j in range(3):
        check(all(sum((wt[x]*M[x] for x in keys if x[j]==a),Q(0))==mu[a] for a in range(n)),'midpoint singleton original law')
    pair={(x,y):K(s+t)[x][y] for x,y in product(range(n),repeat=2)}
    pairwt={(x,y):mu[x]*mu[y] for x,y in pair}
    pairg={(x,y):K(k)[x][y] for x,y in pair}
    check(all(sum((mu[w]*f[x,y,w] for w in range(n)),Q(0))==pair[x,y] for x,y in pair),'reference endpoint marginal')
    if require_long:
        pe=pw[k-s-t]
        mid=matmul(pe,K(s+t),mu)
        check(mid==pw[k+s+t],'pair midpoint uses integer T power')
        check(matmul(pe,mid,mu)==K(k),'pair smoothing square identity')
        check(all(pairg[x]>0 for x in pair if pair[x]>0),'edge logarithm supported')
    F=sum((wt[x]*f[x]*g[x]*K(k)[x[0]][x[1]] for x in keys),Q(0))
    direct=norm=Q(0)
    for x,y,z,w in product(range(n),repeat=4):
        weight=mu[x]*mu[y]*mu[z]*mu[w]
        star=K(p)[x][z]*K(q)[y][z]*K(l)[z][w]
        direct+=weight*K(k)[x][y]*f[x,y,w]*star
        if f[x,y,w]>0:
            norm+=weight*f[x,y,w]*star/g[x,y,w]
    check(F==direct,'factorized and four-vertex densities agree')
    check(norm==1,'four-vertex trial law exactly normalized')
    if original is not None:
        ko,u,r,lo,h=original
        check(ko>=u>=1 and r>=lo>=1 and h>=1,'original ordered domain')
        check(r+h-lo<u<r+lo,'original unpaid strip')
        check(F==original_density(T,mu,original),'exact original contraction after hub labeling')
    V3=cross_entropy(f,g,wt);V2=cross_entropy(pair,pairg,pairwt)
    V=add_interval(V3,V2);D3=entropy_density(M,wt)
    G3=sub_interval(V3,D3)
    # These interval consistency checks are finite diagnostics, not the proof of Jensen.
    check(G3[1]>=0,'star Jensen gain interval consistent with nonnegativity')
    rec={'parameters_k_p_q_s_t_l':pars,'original_tuple':original,'mu':mu,'T':T,'F':F,'V':V,'V3':V3,'V2':V2,'D3':D3,'G3':G3}
    if require_long:
        mid={(x,y):pw[k+s+t][x][y] for x,y in pair}
        D2=entropy_density(mid,pairwt);G2=sub_interval(V2,D2)
        bound=add_interval(D3,D2)
        check(G2[1]>=0,'edge Jensen gain interval consistent with nonnegativity')
        check(sub_interval(V,bound)[1]>=0,'complete paid entropy budget')
        check(sub_interval(log_bounds(F),V)[1]>=0,'full variational Jensen bound')
        check(F>=1,'exact density in proved exponent region')
        if any(T[i][j]!=1 for i,j in product(range(n),repeat=2)):
            check(D2[0]>0 and F>1,'strictness for nonconstant actual root')
        rec.update({'D2':D2,'G2':G2,'entropy_lower_bound':bound})
    return rec

def from_W(W):
    W=[[Q(x) for x in row]for row in W];r=[sum(row) for row in W];total=sum(r)
    return [[total*W[i][j]/(r[i]*r[j])for j in range(len(r))]for i in range(len(r))],[x/total for x in r]

def decode(o):
    if isinstance(o,Q):return str(o)
    if isinstance(o,dict):return {str(k):decode(v) for k,v in o.items()}
    if isinstance(o,(list,tuple)):return [decode(v)for v in o]
    return o

def main():
    fixtures=[]
    fixtures.append(('singleton',[[Q(1)]],[Q(1)]))
    fixtures.append(('independent_nonuniform',[[Q(1)]*3 for _ in range(3)],[Q(1,5),Q(3,10),Q(1,2)]))
    mu=[Q(1,3),Q(2,3)];fixtures.append(('identity_nonuniform',[[Q(3),Q(0)],[Q(0),Q(3,2)]],mu))
    fixtures.append(('period_two',[[Q(0),Q(2)],[Q(2),Q(0)]],[Q(1,2)]*2))
    fixtures.append(('negative_mode',[[Q(1,2),Q(3,2)],[Q(3,2),Q(1,2)]],[Q(1,2)]*2))
    fixtures.append(('reducible_extra_unit_zero',[[Q(2)if i//2==j//2 else Q(0)for j in range(4)]for i in range(4)],[Q(1,4)]*4))
    signs=list(product((-1,1),repeat=2))
    T=[[1+Q(1,100)*x[0]*y[0]+Q(9,10)*x[1]*y[1]for y in signs]for x in signs]
    fixtures.append(('positive_singular_four',T,[Q(1,4)]*4))
    fixtures.append(('supplied_positive_three',[[Q(4,5),Q(18,13),Q(32,39)],[Q(18,13),Q(1,2),Q(40,39)],[Q(32,39),Q(40,39),Q(148,117)]],[Q(5,12),Q(1,3),Q(1,4)]))
    fixtures.append(('supplied_zero_three',[[Q(16,21),Q(40,21),Q(0)],[Q(40,21),Q(8,63),Q(20,21)],[Q(0),Q(20,21),Q(18,7)]],[Q(3,8),Q(3,8),Q(1,4)]))
    W=[[8,1,0,2,0],[1,1,3,0,1],[0,3,2,1,0],[2,0,1,1,4],[0,1,0,4,2]]
    T,mu=from_W(W);fixtures.append(('generic_five',T,mu))
    records={}
    for name,T,mu in fixtures:
        # r=u and r=l boundaries, k=2u, h=1.
        records[name+'_A']=two_star(name+'_A',T,mu,(4,3,2,2,2,2),(4,2,2,2,1))
        # u=J boundary and k=J+r, also r=l and h=1.
        records[name+'_B']=two_star(name+'_B',T,mu,(5,3,3,3,2,2),(5,3,2,2,1))
        print('checked',name,'both orientations',flush=True)
    T,mu=fixtures[-1][1:]
    records['strict_A']=two_star('strict_A',T,mu,(10,6,5,4,4,3),(10,4,5,3,1))
    records['strict_B']=two_star('strict_B',T,mu,(7,5,5,4,3,3),(7,5,3,3,1))
    check(sum(mu[i]*mu[j]*T[i][j]*([0,1,-1,0,0][i])*([0,1,-1,0,0][j])for i,j in product(range(5),repeat=2))==-Q(3,38),'generic root has negative Rayleigh direction')
    ds=[sum(mu[j]*(T[i][j]-1)**2 for j in range(5))for i in range(5)]
    low=Q(0)
    for m,d in zip(mu,ds):low+=m*d*Q(isqrt((d.numerator*SCALE*SCALE)//d.denominator),SCALE)
    check(max(ds)>1 and low>1,'generic root outside both previous moment premises')
    # Actual counterexample to dropping the long-edge premise, NOT to F>=1.
    n=9;mu=[Q(1,n)]*n
    cyc=[[Q(n,2)if (i-j)%n in(1,n-1)else Q(0)for j in range(n)]for i in range(n)]
    pw=powers(cyc,mu,6)
    check(pw[4][4][0]>0 and pw[4][5][0]>0 and pw[4][4][5]==0,'zero-root long-edge support obstruction')
    eps=Q(1,10**14)
    T=[[eps+(1-eps)*cyc[i][j]for j in range(n)]for i in range(n)]
    rec=two_star('positive_short_edge_obstruction',T,mu,(2,3,2,2,2,2),(2,2,2,2,1),require_long=False)
    check(min(x for row in T for x in row)==eps,'strict positive actual-root obstruction')
    rational_bracket(rec['V'],'-0.321858','-0.321857','negative total entropy of invalid extension')
    check(Q('9.475444078443')<rec['F']<Q('9.475444078445'),'actual density remains greater than one')
    records['positive_short_edge_obstruction']=rec
    # Independent actual bridge normalization with negative/zero support.
    T,mu=fixtures[3][1:];pw=powers(T,mu,4)
    for a,b in product(range(2),repeat=2):
        s=sum((mu[x]*mu[y]*mu[z]*T[a][x]*T[x][y]*T[y][z]*T[z][b]for x,y,z in product(range(2),repeat=3)),Q(0))
        check(s==pw[4][a][b],'actual four-step bridge composition')
    out={'assertions':COUNT,'status':'unrestricted density unresolved; two all-host exponent ranges proved','logs':{'bits':BITS,'terms':TERMS},'records':records}
    Path(__file__).with_name('exact_certificate.json').write_text(json.dumps(decode(out),indent=2))
    print('PASS',COUNT,'exact assertions')
    for key in ['strict_A','strict_B','positive_short_edge_obstruction']:
        rec=records[key];print(key,'F=',float(rec['F']),'V enclosure=',tuple(float(q)for q in rec['V']))

if __name__=='__main__':main()
