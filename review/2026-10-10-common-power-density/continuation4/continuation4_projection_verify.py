"""Exact original-measure checks for the projection-channel contraction proofs.

Uses only Python's standard library. Auxiliary independent diagonal kernels
are distinguished from actual roots; all density examples use actual roots.
"""
from fractions import Fraction as F
from itertools import product, combinations
from pathlib import Path
import hashlib
import json

EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
CYCLES=((0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,3,5,2),(0,4,5,1),(1,3,4,2))

def mat(rows):return [[F(x) for x in row] for row in rows]
def plus(a,b):return [[x+y for x,y in zip(r,s)] for r,s in zip(a,b)]
def scale(c,a):return [[c*x for x in row] for row in a]
def eye(pi):return [[F(i==j)/pi[i] for j in range(len(pi))] for i in range(len(pi))]
def ones(n):return [[F(1) for j in range(n)] for i in range(n)]
def zero(n):return [[F(0) for j in range(n)] for i in range(n)]
def mm(a,b,pi):
    return [[sum(pi[k]*a[i][k]*b[k][j] for k in range(len(pi))) for j in range(len(pi))] for i in range(len(pi))]
def power(a,k,pi):
    ans=eye(pi)
    while k:
        if k%2:ans=mm(ans,a,pi)
        a=mm(a,a,pi);k//=2
    return ans
def trace(a,pi):return sum(pi[i]*a[i][i] for i in range(len(pi)))
def hs(a,b,pi):return sum(pi[i]*pi[j]*a[i][j]*b[i][j] for i in range(len(pi)) for j in range(len(pi)))
def schur(a,b):return [[x*y for x,y in zip(r,s)] for r,s in zip(a,b)]
def same(a,b):return a==b
def markov(a,pi):
    return all(a[i][j]==a[j][i] and a[i][j]>=0 for i in range(len(pi)) for j in range(len(pi))) and all(sum(pi[j]*a[i][j] for j in range(len(pi)))==1 for i in range(len(pi)))
def proj(a,pi):return a==list(map(list,zip(*a))) and mm(a,a,pi)==a
def exp_tuple(tpl):
    assert len(tpl)==5 and all(type(x)is int for x in tpl)
    k,u,r,l,h=tpl;assert k>=u>=1 and r>=l>=1 and h>=1
    return k,r+h,u,r,u,l
def density(ks,pi):
    out=F(0);n=len(pi)
    for v in product(range(n),repeat=4):
        w=pi[v[0]]*pi[v[1]]*pi[v[2]]*pi[v[3]]
        for a,(i,j) in zip(ks,EDGES):w*=a[v[i]][v[j]]
        out+=w
    return out
def quad(q,L,M,pi):return density((q,L,q,q,M,q),pi)
def triangle(q,L,M,pi):
    # Triangle abc; star at d has powers (x,x,z).
    return density((q,q,L,q,L,M),pi)
def field(q,K,pi,t):
    n=len(pi)
    return [[sum(pi[z]*q[i][z]*K[z][t]*q[z][j] for z in range(n)) for j in range(n)] for i in range(n)]
def charpoly(a,pi):
    # Faddeev--LeVerrier on the original relative operator.
    n=len(pi);B=eye(pi);out=[F(1)]
    for k in range(1,n+1):
        AB=mm(a,B,pi);c=-trace(AB,pi)/k;out.append(c);B=plus(AB,scale(c,eye(pi)))
    assert B==zero(n)
    return out
def polymul(a,b):
    out=[F(0)]*(len(a)+len(b)-1)
    for i,x in enumerate(a):
        for j,y in enumerate(b):out[i+j]+=x*y
    return out
def polydivide_root_one(a):
    b=[a[0]]
    for v in a[1:-1]:b.append(v+b[-1])
    assert a[-1]+b[-1]==0
    return b
def serialize(x):
    if isinstance(x,F):return str(x)
    if isinstance(x,dict):return {str(k):serialize(v) for k,v in x.items()}
    if isinstance(x,(tuple,list)):return [serialize(v) for v in x]
    return x

def primary_host():
    pi=list(map(F,('3/5','1/5','1/10','1/10')))
    M=[[59,1,0,0],[1,18,1,0],[0,1,8,1],[0,0,1,9]]
    row=[sum(r) for r in M]
    S0=[[F(100*M[i][j],row[i]*row[j]) for j in range(4)] for i in range(4)]
    S=plus(scale(F(31,32),S0),scale(F(1,32),ones(4)))
    f=list(map(F,(1,0,-3,-3)));assert sum(pi[i]*f[i] for i in range(4))==0
    assert sum(pi[i]*f[i]**2 for i in range(4))==F(12,5)
    R=[[F(5,12)*f[i]*f[j] for j in range(4)] for i in range(4)]
    Q=plus(ones(4),R)
    assert proj(Q,pi) and trace(Q,pi)==2
    Qcenter=plus(plus(eye(pi),scale(-1,ones(4))),scale(-1,R))
    assert proj(Qcenter,pi) and trace(Qcenter,pi)==2
    for i,j in combinations(range(4),2):
        for k,l in combinations(range(4),2):assert S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k]>=0
    assert markov(S0,pi) and markov(S,pi)
    assert mm(S,Q,pi)!=mm(Q,S,pi)
    # The negative triangle product is invariant under any binary sign gauge.
    assert Q[0][1]*Q[1][2]*Q[2][0]==-F(1,4)
    return pi,S0,S,Q,Qcenter

def lemma_checks(pi,S,Q,Qcenter):
    n=len(pi);A=mm(S,S,pi);P=plus(eye(pi),scale(-1,ones(n)))
    # An independent actual root on the same pi, from conductances 1/100.
    flow=[[F(0) for j in range(n)] for i in range(n)]
    for i,j in ((0,2),(0,3),(1,3)):flow[i][j]=flow[j][i]=F(1,100)
    for i in range(n):flow[i][i]=pi[i]-sum(flow[i])
    R=[[flow[i][j]/(pi[i]*pi[j]) for j in range(n)] for i in range(n)]
    assert markov(R,pi);M=power(R,4,pi);assert mm(A,M,pi)!=mm(M,A,pi)
    projections=[zero(n),ones(n),P,Q,Qcenter,eye(pi)]
    records=[]
    for qi,q in enumerate(projections):
        d=trace(q,pi);assert proj(q,pi)
        for li,L in enumerate((ones(n),A,power(A,2,pi))):
            for mi,m in enumerate((ones(n),M)):
                G=[[sum(pi[b]*pi[t]*m[b][t]*q[a][b]*q[a][t]*q[c][b]*q[c][t] for b in range(n) for t in range(n)) for c in range(n)] for a in range(n)]
                J=quad(q,L,m,pi)
                first=hs(plus(L,scale(-1,ones(n))),G,pi)
                second=hs(plus(m,scale(-1,ones(n))),schur(q,q),pi)
                assert J-d==first+second and first>=0 and second>=0
                if L==ones(n) and m==ones(n):assert J==d
                records.append({'type':'quad','projection':qi,'left_kernel':li,'right_kernel':mi,'rank':d,'J':J,'first_surplus':first,'second_surplus':second})
        for x,z in ((1,1),(1,3),(3,1),(2,5)):
            L=power(A,x,pi);m=power(A,z,pi);J=triangle(q,L,m,pi)
            Bs=[field(q,L,pi,t) for t in range(n)];Cs=[field(q,m,pi,t) for t in range(n)]
            g=sum(pi[t]*hs(Bs[t],Cs[t],pi) for t in range(n))
            trsum=sum(pi[t]*trace(mm(mm(Bs[t],Bs[t],pi),Cs[t],pi),pi) for t in range(n))
            assert J==trsum and g>=d
            assert J*d>=g*g if d else J==0 and g==0
            records.append({'type':'triangle','projection':qi,'x':x,'z':z,'rank':d,'J':J,'g':g,'cauchy_gap':J*d-g*g})
    return records

def host_checks(label,pi,S,H,Q,beta,tuples):
    n=len(pi);assert markov(S,pi) and proj(Q,pi) and mm(H,H,pi)==scale(beta,Q)
    assert all(abs(H[i][j])<=S[i][j] for i in range(n) for j in range(n))
    states=list(product(range(n),(-1,1)));mu=[pi[i]/2 for i,a in states]
    T=[[S[i][j]+a*b*H[i][j] for j,b in states] for i,a in states]
    assert markov(T,mu)
    p=1/max(map(max,T));W=scale(p,T);assert markov(scale(1/p,W),mu)
    assert all(0<=v<=1 for r in W for v in r)
    assert all(sum(mu[j]*W[i][j] for j in range(2*n))==p for i in range(2*n))
    A=mm(S,S,pi);Af=mm(T,T,mu);d=trace(Q,pi);rows=[]
    for tpl in tuples:
        k,u,r,l,h=tpl;assert k==u and r==l
        ep=exp_tuple(tpl);K={e:power(A,e,pi) for e in set(ep)}
        KF={e:power(Af,e,mu) for e in set(ep)}
        for e in set(ep):
            predicted=[[K[e][i][j]+a*b*beta**e*Q[i][j] for j,b in states] for i,a in states]
            assert KF[e]==predicted
        coarse=density([K[e] for e in ep],pi);fine=density([KF[e] for e in ep],mu)
        contractions=[density([Q if e in cyc else K[ep[e]] for e in range(6)],pi) for cyc in CYCLES]
        qweights=[sum(ep[e] for e in cyc) for cyc in CYCLES]
        assert qweights==[u+2*r+h,3*u,u+2*r+h,u+2*r,2*u+2*r,2*u+2*r+h,2*u+2*r+h]
        assert all(c>=d for c in contractions)
        correction=sum(beta**w*c for w,c in zip(qweights,contractions))
        bound=d*sum(beta**w for w in qweights)
        assert fine==coarse+correction and fine>=coarse+bound
        rows.append({'tuple':tpl,'edge_exponents':ep,'cycle_exponents':qweights,'F_coarse':coarse,'F_fine':fine,'cycle_contractions':contractions,'channel_surplus':correction,'proved_lower_surplus':bound})
    return {'label':label,'coarse_pi':pi,'fine_mu':mu,'S':S,'H':H,'Q':Q,'rank_Q':d,'beta':beta,'p':p,'W':W,'min_T':min(map(min,T)),'max_T':max(map(max,T)),'max_A':max(map(max,Af)),'rows':rows},Af,mu

def main():
    pi,S0,S,Q,Qcenter=primary_host()
    lemmas=lemma_checks(pi,S,Q,Qcenter)
    tuples=((1,1,1,1,1),(2,2,1,1,1),(1,1,3,3,1),(2,2,3,3,5))
    primary,Af,mu=host_checks('weighted_noncentral_projection',pi,S,scale(F(1,128),Q),Q,F(1,16384),tuples)
    assert primary['p']==F(512,4499)
    assert primary['p']<F(1,4) and primary['max_A']>4
    cochar=charpoly(mm(S,S,pi),pi);fichar=charpoly(Af,mu)
    center=polydivide_root_one(cochar)
    expected=polymul(polymul(polymul([F(1),F(-1)],center),[F(1),-F(1,16384)]),[F(1),-F(1,16384)])
    expected=polymul(expected,[F(1),F(0),F(0)])
    assert fichar==expected
    more=[]
    for label,h,q,b in (('weighted_centered_rank_two',scale(F(1,128),Qcenter),Qcenter,F(1,16384)),('negative_channel_eigenvalues',scale(-F(1,128),Q),Q,F(1,16384)),('zero_channel',zero(4),Q,F(0))):
        a,_,_=host_checks(label,pi,S,h,q,b,(tuples[0],));more.append(a)
    p1=[F(1)];a,_,_=host_checks('one_coarse_state',p1,[[F(1)]],[[F(1,2)]],[[F(1)]],F(1,4),(tuples[0],));more.append(a)
    p2=[F(1,2),F(1,2)];flip=mat(((0,2),(2,0)))
    a,_,_=host_checks('connected_bipartite_root_disconnected_square',p2,flip,scale(F(1,2),flip),eye(p2),F(1,4),(tuples[0],tuples[-1]));more.append(a)
    pp=list(map(F,('1/2','1/3','1/6')));qq=eye(pp);qq[2][2]=0
    a,_,_=host_checks('weighted_disconnected_root',pp,eye(pp),scale(F(1,2),qq),qq,F(1,4),(tuples[0],));more.append(a)
    # Exact equality of both lemmas at the refresh kernel, for all projections.
    for q in (Q,Qcenter,eye(pi),zero(4)):
        assert quad(q,ones(4),ones(4),pi)==trace(q,pi)
        assert triangle(q,ones(4),ones(4),pi)==trace(q,pi)
    out={'scope':'Exact finite checks supplement, do not replace, the written proofs; unrestricted target unresolved.',
         'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         'tuple_order':['k','u','r','l','h'],'edge_order':EDGES,'cycle_order':CYCLES,
         'lemma_check_count':len(lemmas),'actual_host_count':1+len(more),
         'actual_host_tuple_count':len(primary['rows'])+sum(len(x['rows']) for x in more),
         'lemma_checks':lemmas,'primary_host':primary,'additional_hosts':more,
         'coarse_square_charpoly':cochar,'fine_square_charpoly':fichar,
         'factorization_exact':True,'negative_Q_triangle_product':-F(1,4),
         'coarse_channel_noncommutation':True,'S0_all_TP2_minors_nonnegative':True}
    Path('continuation4_projection_checks.json').write_text(json.dumps(serialize(out),indent=2)+'\n')
    print(json.dumps(serialize({k:out[k] for k in ('lemma_check_count','actual_host_count','actual_host_tuple_count','coarse_square_charpoly','fine_square_charpoly')})))
    print(json.dumps(serialize({k:primary[k] for k in ('p','min_T','max_T','max_A','rank_Q')})))
    print('ALL_EXACT_CHECKS_PASSED')

if __name__=='__main__':main()
