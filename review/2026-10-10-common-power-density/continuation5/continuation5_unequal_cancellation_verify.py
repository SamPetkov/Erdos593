"""Exact original-measure verification of the unequal-star cancellation family.
No optimizer, floating eigenvalue, or finite-difference sign decision is used.
"""
from fractions import Fraction as F
from pathlib import Path
import hashlib,itertools,json,time
start=time.time()

def mm(A,B,pi):
    return [[sum((pi[k]*A[i][k]*B[k][j] for k in range(len(pi))),F(0))
             for j in range(len(pi))] for i in range(len(pi))]
def ident(pi):
    return [[F(i==j)/pi[i] for j in range(len(pi))]for i in range(len(pi))]
def power(A,k,pi):
    R=ident(pi)
    while k:
        if k&1:R=mm(R,A,pi)
        A=mm(A,A,pi);k//=2
    return R
def trace(A,pi):return sum(pi[i]*A[i][i]for i in range(len(pi)))
def subtract(A,B):return [[a-b for a,b in zip(r,s)]for r,s in zip(A,B)]
def trprod(A,B,pi):return trace(mm(A,B,pi),pi)
def tr3(A,B,C,pi):return trace(mm(mm(A,B,pi),C,pi),pi)
def fields(Q,L,pi):
    return [[[sum(pi[a]*Q[i][a]*L[a][t]*Q[a][j]for a in range(len(pi)))
              for j in range(len(pi))]for i in range(len(pi))]for t in range(len(pi))]
def symmetric(A):return all(A[i][j]==A[j][i]for i in range(len(A))for j in range(len(A)))
def markov(A,pi):return symmetric(A)and min(map(min,A))>=0 and all(sum(pi[j]*A[i][j]for j in range(len(pi)))==1 for i in range(len(pi)))
def stats(S,Q,pi):
    fs={s:fields(Q,power(S,2*s,pi),pi)for s in(1,2,8)}
    xs={s:[subtract(M,Q)for M in fs[s]]for s in fs}
    for s in fs:
        assert [[sum(pi[t]*fs[s][t][i][j]for t in range(4))for j in range(4)]for i in range(4)]==Q
    pp={(s,t):sum(pi[i]*trprod(xs[s][i],xs[t][i],pi)for i in range(4))for s,t in((1,2),(1,8),(2,8))}
    assert all(v>=0 for v in pp.values())
    P=sum(pp.values());C=sum(pi[i]*tr3(xs[1][i],xs[2][i],xs[8][i],pi)for i in range(4))
    J=sum(pi[i]*tr3(fs[1][i],fs[2][i],fs[8][i],pi)for i in range(4))
    assert J==2+P+C
    return J,P,C,pp

def data(t):
    e=t**22;a=t**-9;D=1+t**4-t**22;delta=t**4/D;zeta=t**8
    pi=[e/2,e/2,(1-e)/2,(1-e)/2];v=[[a,0],[0,a],[0,1],[1,0]]
    Q=[[2*sum(v[i][k]*v[j][k]for k in range(2))/D for j in range(4)]for i in range(4)]
    S0=[[F(0)for j in range(4)]for i in range(4)]
    for i in range(4):
        for j in range(4):
            if i%2!=j%2:S0[i][j]=2*(1-t*t+(t*t/[e,1-e][i//2]if i//2==j//2 else 0))
    S=[[(1-zeta)*S0[i][j]+zeta for j in range(4)]for i in range(4)]
    return e,a,D,delta,zeta,pi,Q,S0,S

def density(K,exps,pi):
    powers={j:power(K,2*j,pi)for j in set(exps)};edges=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3));value=F(0)
    for colors in itertools.product(range(len(pi)),repeat=4):
        term=F(1)
        for c in colors:term*=pi[c]
        for (u,v),n in zip(edges,exps):term*=powers[n][colors[u]][colors[v]]
        value+=term
    return value

records=[]
for t in (F(1,2),F(1,4),F(1,8),F(1,16)):
    e,a,D,delta,zeta,pi,Q,S0,S=data(t)
    assert markov(S0,pi)and markov(S,pi)
    assert min(map(min,S))==zeta
    assert mm(Q,Q,pi)==Q and trace(Q,pi)==2
    assert min(map(min,Q))==0
    J,P,C,pp=stats(S0,Q,pi);Jp,Pp,Cp,ppp=stats(S,Q,pi)
    E2=t**12+t**36+t**40;E3=t**44
    def Hp(p):return 1+(1-p)/p*E2+(1-p)*(1-2*p)/p**2*E3
    jf=8*(delta**3*Hp(e)+(1-delta)**3*Hp(1-e))
    pf=6*(2*delta-1)**2+4*(delta**2*(1-e)/e+(1-delta)**2*e/(1-e))*E2
    jp=8/D**3*((1-e)**3+t**12+(1-e)*(t**2+t**26+t**30)+e*(1-e)**2*E2+t**12*(1-e)*(1-2*e)+e*(1-e)*(2*e-1)*t**44)
    ppolf=(6*(t**4-1+t**22)**2+4*(1-e)*(t**-2+t**22+t**26)+4*e*(1-e)*E2)/D**2
    assert J==jf==jp and P==pf==ppolf
    for s,r in pp:
        expected=2*(2*delta-1)**2+4*(delta**2*(1-e)/e+(1-delta)**2*e/(1-e))*t**(4*(s+r))
        assert pp[s,r]==expected
        assert ppp[s,r]==(1-zeta)**(2*(s+r))*pp[s,r]
    assert Cp==(1-zeta)**22*C
    assert (1-zeta)**20*P<=Pp<=P
    assert abs(Jp-J)<=20*zeta*P+22*zeta*abs(C)
    assert J>=8*(delta**3+(1-delta)**3)>=2
    # The strict-positive paired budget cancellation stays safely above d.
    assert Jp>2
    alpha=D*t**26/4
    assert alpha*max(map(max,Q))==zeta/2
    mu=[p/2 for p in pi for b in(-1,1)]
    T=[[S[i][j]+alpha*Q[i][j]*b*c for j in range(4)for c in(-1,1)]for i in range(4)for b in(-1,1)]
    p=t**20/4;W=[[p*x for x in row]for row in T]
    assert markov(T,mu)and min(map(min,T))>=zeta/2 and max(map(max,T))<=4*t**-20
    assert min(map(min,W))>0 and max(map(max,W))<=1
    assert all(sum(mu[j]*W[i][j]for j in range(8))==p for i in range(8))
    # Coarse eigenvectors, the proved sign split, and Q^2=Q determine every band including zero.
    tc=mm(T,T,mu);B=mm(S,S,pi)
    for j in(1,2,3):
        left=power(T,2*j,mu);coarse=power(S,2*j,pi)
        right=[[coarse[i][k]+alpha**(2*j)*Q[i][k]*b*c for k in range(4)for c in(-1,1)]for i in range(4)for b in(-1,1)]
        assert left==right
    nu=[e,1-e];rfun=[1-e,-e]
    vectors=[([F(1)for i in range(4)],F(1)),
             ([F(1 if i%2==0 else -1)for i in range(4)],(1-zeta)**2),
             ([rfun[i//2]for i in range(4)],(1-zeta)**2*t**4),
             ([rfun[i//2]*(1 if i%2==0 else -1)for i in range(4)],(1-zeta)**2*t**4)]
    for vv,ev in vectors:assert all(sum(pi[j]*B[i][j]*vv[j]for j in range(4))==ev*vv[i]for i in range(4))
    assert 0<alpha**2<(1-zeta)**2*t**4<(1-zeta)**2<1
    rec={'t':str(t),'J_unperturbed':str(J),'P_unperturbed':str(P),'C_unperturbed':str(C),'J_strict_positive':str(Jp),'P_strict_positive':str(Pp),'C_strict_positive':str(Cp),'cubic_to_pair_strict_positive':str(Cp/Pp),'all_arithmetic_exact':True,'actual_fine_centered_bands':[{'value':str((1-zeta)**2),'multiplicity':1},{'value':str((1-zeta)**2*t**4),'multiplicity':2},{'value':str(alpha**2),'multiplicity':2},{'value':'0','multiplicity':2}],'mu':[str(x)for x in mu],'p':str(p)}
    if t==F(1,16):
        assert 2<Jp<9 and Pp>1000 and Cp < -F(99,100)*Pp
        rec['strict_rational_margins']=['2<J<9','P>1000','C<-(99/100)P']
    if t==F(1,4):
        exps=(1,8,1,2,1,1)
        Fc=density(S,exps,pi);Ff=density(T,exps,mu)
        assert Ff>Fc>1
        rec['target_tuple']=[1,1,2,1,6];rec['edge_exponents_ab_ac_ad_bc_bd_cd']=list(exps)
        rec['exact_fine_density']=str(Ff);rec['exact_coarse_density']=str(Fc)
        rec['density_scope']='Ffine>Fcoarse>1; this is not a target counterexample'
    records.append(rec)
    print('PASS exact t=',t,'including original-law fields, strict root and full band count',flush=True)
files=['continuation5_unequal_cancellation.md','continuation5_unequal_cancellation_verify.py']
result={'status':'PASS','family_parameter_points':4,'star_exponents':[1,2,8],'proved_limit':'J -> 8; t^2 P -> 4; C/P -> -1; same after strict-positive Pi perturbation','claim_refuted':'a universal c>0 with J>=rank(Q)+c P','not_refuted':['J>=rank Q','unrestricted F>=1'],'finite_verification_is_not_the_asymptotic_proof':True,'records':records,'source_hashes':{p:hashlib.sha256(Path(p).read_bytes()).hexdigest()for p in files},'elapsed_seconds':time.time()-start}
Path('continuation5_unequal_cancellation_checks.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS: exact cancellation family; one complete actual fine density; no target violation')
