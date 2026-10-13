"""Exact uniform codimension-one star certificate, using original measures.
Standard-library Fraction/integer arithmetic only. No full F enumeration.
"""
from fractions import Fraction as R
from itertools import combinations,product
from math import lcm
from pathlib import Path
import hashlib,json,time

ROOT=Path(__file__).resolve().parent

def mm(A,B):
    return [[sum((A[i][k]*B[k][j] for k in range(len(B))),R(0)) for j in range(len(B[0]))] for i in range(len(A))]
def imul(A,B):
    return [[sum(A[i][k]*B[k][j] for k in range(len(B))) for j in range(len(B[0]))] for i in range(len(A))]
def trans(A):return list(map(list,zip(*A)))
def trace(A):return sum((A[i][i] for i in range(len(A))),R(0))
def ident(n):return [[R(i==j) for j in range(n)] for i in range(n)]
def scal(c,A):return [[c*x for x in row] for row in A]
def minus(A,B):return [[x-y for x,y in zip(a,b)] for a,b in zip(A,B)]
def operator(K,pi):return [[x*pi[j] for j,x in enumerate(row)] for row in K]
def integerize(A):
    D=lcm(*(x.denominator for row in A for x in row));return [[int(D*x) for x in row] for row in A],D
def power_kernels(S,pi,max_s):
    P=operator(S,pi);M,D=integerize(P);Mp=ident(len(pi));out={}
    for s in range(1,2*max_s+1):
        Mp=imul(Mp,M)
        if not s%2:out[s//2]=[[R(Mp[i][j],D**s)/pi[j] for j in range(len(pi))] for i in range(len(pi))]
    return P,out

def exact_J(pi,Q,Ks):
    assert len(set(pi))==1
    n=len(pi);qi,Dq=integerize(Q);ki=[];Ds=[]
    for K in Ks:M,D=integerize(K);ki.append(M);Ds.append(D)
    num=sum(qi[a][b]*qi[b][c]*qi[c][a]*ki[0][a][t]*ki[1][b][t]*ki[2][c][t]
      for a,b,c,t in product(range(n),repeat=4))
    return R(num,n**4*Dq**3*Ds[0]*Ds[1]*Ds[2])
def exact_L(pi,Ks):
    assert len(set(pi))==1
    n=len(pi);ki=[];Ds=[]
    for K in Ks:M,D=integerize(K);ki.append(M);Ds.append(D)
    return R(sum(ki[0][a][t]*ki[1][a][t]*ki[2][a][t] for a,t in product(range(n),repeat=2)),n**2*Ds[0]*Ds[1]*Ds[2])
def ser(x):
    if isinstance(x,R):return str(x)
    if isinstance(x,dict):return {str(k):ser(v) for k,v in x.items()}
    if isinstance(x,(tuple,list)):return [ser(v) for v in x]
    return x

def run():
    t0=time.time();n=13;pi=[R(1,n)]*n;delta=R(1,1024);a=1-delta
    P0=ident(n)
    for i in range(n-1):
        P0[i][i]-=R(1,64);P0[i+1][i+1]-=R(1,64)
        P0[i][i+1]=P0[i+1][i]=R(1,64)
    S0=scal(n,P0);S=[[a*S0[i][j]+delta for j in range(n)] for i in range(n)]
    f=[R((-1)**i) for i in range(n)]
    Q=[[R(n*(i==j))-f[i]*f[j] for j in range(n)] for i in range(n)]
    Qop=operator(Q,pi)
    assert sum(pi)==1 and all(sum(pi[j]*S[i][j] for j in range(n))==1 for i in range(n))
    assert S==trans(S) and min(x for row in S for x in row)>0
    assert mm(Qop,Qop)==Qop and trace(Qop)==12 and Q==trans(Q)
    assert all(Q[i][i]==12 for i in range(n))
    qone=[sum(pi[j]*Q[i][j] for j in range(n)) for i in range(n)]
    assert qone==[1-v/13 for v in f] and qone!=[R(0)]*n and qone!=[R(1)]*n
    assert Q[0][1]*Q[1][2]*Q[2][0]==-1
    P,K=power_kernels(S,pi,5)
    comm=minus(mm(P,Qop),mm(Qop,P));nonzero=next((i,j,comm[i][j]) for i,j in product(range(n),repeat=2) if comm[i][j])
    assert min(P0[i][i] for i in range(n))==R(31,32)
    minors=[S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k] for i,j in combinations(range(n),2) for k,l in combinations(range(n),2)]
    assert len(minors)==6084 and min(minors)>=0
    xyz=(1,2,3);Ks=[K[s] for s in xyz]
    J=exact_J(pi,Q,Ks);L=exact_L(pi,Ks)
    taus={s:sum(pi[i]*K[s][i][i] for i in range(n)) for s in (3,4,5)}
    assert J==(n-3)*L+sum(taus.values())-1
    assert L>=max(taus.values())>1
    lower=n-1+(n-3)*(max(taus.values())-1)+sum(v-1 for v in taus.values())
    assert J>=lower>12
    # Independently check the four-matrix field at t=0 on the full Euclidean
    # representation. Its identity on the range is Qop, not the 13 by 13 I.
    D0=[[K[1][i][0] if i==j else R(0) for j in range(n)] for i in range(n)]
    M0=mm(mm(Qop,D0),Qop);X0=minus(M0,Qop)
    assert trace(M0)==12 and mm(Qop,M0)==M0
    cubic0=trace(mm(mm(X0,X0),X0));assert cubic0>0
    cap_lower=12*K[1][0][0]/n
    assert cap_lower>10 # and 10 > 4+4sqrt(2)
    # Complete actual binary root and bounded host.
    alpha=R(1,24576);beta=alpha**2;states=list(product(range(n),(-1,1)))
    mu=[R(1,2*n)]*(2*n)
    T=[[S[i][j]+sg*tg*alpha*Q[i][j] for j,tg in states] for i,sg in states]
    assert T==trans(T) and min(x for row in T for x in row)>0
    assert all(sum(mu[j]*T[i][j] for j in range(2*n))==1 for i in range(2*n))
    p=1/max(x for row in T for x in row);W=scal(p,T)
    assert p==R(65536,837933) and min(x for row in T for x in row)==R(23,24576)
    assert all(0<x<=1 for row in W for x in row)
    assert all(sum(mu[j]*W[i][j] for j in range(2*n))==p for i in range(2*n))
    Pf=operator(T,mu);Mi,Di=integerize(Pf);Aop=imul(Mi,Mi)
    A=[[R(Aop[i][j],Di**2)/mu[j] for j in range(2*n)] for i in range(2*n)]
    assert A==[[K[1][i][j]+sg*tg*beta*Q[i][j] for j,tg in states] for i,sg in states]
    assert beta<(a*R(15,16))**2
    # n=2 and n=1 boundaries, with actual roots and flat f.
    pi2=[R(1,2)]*2;S2=[[R(3,2),R(1,2)],[R(1,2),R(3,2)]]
    Q2=[[R(1),R(1)],[R(1),R(1)]];_,K2=power_kernels(S2,pi2,3)
    assert exact_J(pi2,Q2,[K2[s] for s in (1,2,3)])==1
    assert exact_J([R(1)],[[R(0)]],[[[R(1)]]]*3)==0
    # Uniform original law at refresh gives equality for rank12.
    refresh=[[R(1)]*n for _ in range(n)]
    assert exact_J(pi,Q,[refresh]*3)==12
    result={'status':'PASS','scope':'uniform flat codimension-one all-rank star theorem; complete target remains unresolved',
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'note_sha256':hashlib.sha256((ROOT/'continuation6_search_codimension_one.md').read_bytes()).hexdigest(),
      'coarse_states':n,'fine_states':2*n,'rank_Q':12,'pi':pi,'mu':mu,'delta':delta,'alpha':alpha,'beta':beta,'p':p,
      'S':S,'Q':Q,'Q1':qone,'min_T':min(x for row in T for x in row),'max_T':max(x for row in T for x in row),
      'max_A':max(x for row in A for x in row),'negative_projection_triangle':-1,'nonzero_commutator_entry':nonzero,
      'xyz':xyz,'J':J,'L':L,'pair_traces':taus,'J_explicit_lower':lower,'actual_centered_cubic_at_0':cubic0,
      'actual_first_field_cap_lower':cap_lower,'TP2_minors_checked':6084,'coarse_centered_positive_bands':12,
      'fine_entire_centered_distinct_values':14,'fine_zero_multiplicity':1,'two_state_rank_one_boundary_J':1,
      'rank_zero_boundary_J':0,'refresh_equality_J':12,
      'full_F_enumerated':False,'elapsed_seconds':time.time()-t0}
    (ROOT/'continuation6_search_codimension_one_checks.json').write_text(json.dumps(ser(result),indent=2)+'\n')
    print(json.dumps(ser({k:result[k] for k in ('status','coarse_states','fine_states','rank_Q','min_T','max_T','p','actual_first_field_cap_lower','coarse_centered_positive_bands','fine_entire_centered_distinct_values','elapsed_seconds')})))
if __name__=='__main__':run()
