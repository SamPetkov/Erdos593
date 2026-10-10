"""Exact actual-source cover obstructions. Standard library only.

Negative coefficient/core signs are NOT full density or cover violations.
Every displayed host is built from one actual original-measure root.
"""
from fractions import Fraction as Q
from itertools import product
from collections import defaultdict
from pathlib import Path
import hashlib,json,time
START=time.time()
EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
def identity(mu):return [[Q(i==j)/mu[i]for j in range(len(mu))]for i in range(len(mu))]
def mm(A,B,mu):return [[sum(mu[k]*A[i][k]*B[k][j]for k in range(len(mu)))for j in range(len(mu))]for i in range(len(mu))]
def power(A,m,mu):
    R=identity(mu)
    while m:
        if m&1:R=mm(R,A,mu)
        A=mm(A,A,mu);m//=2
    return R

def centered(A):return [[x-1 for x in row]for row in A]
def tr(A,mu):return sum(mu[i]*A[i][i]for i in range(len(mu)))
def admissible(T,mu):
    n=len(mu);assert sum(mu)==1 and min(mu)>0
    assert all(T[i][j]==T[j][i]for i in range(n)for j in range(n))
    assert min(map(min,T))>=0
    assert all(sum(mu[j]*T[i][j]for j in range(n))==1 for i in range(n))
    p=1/max(map(max,T));W=[[p*x for x in row]for row in T]
    assert max(map(max,W))==1 and min(map(min,W))>=0
    assert all(sum(mu[j]*W[i][j]for j in range(n))==p for i in range(n))
    return p,W

def exponents(tpl):
    k,u,r,l,h=tpl;assert k>=u>=1 and r>=l>=1 and h>=1
    return (k,r+h,u,r,u,l)
def base_and_ab_cover(T,mu,tpl):
    ne=exponents(tpl);K=[power(T,2*n,mu)for n in ne];n=len(mu)
    # H is the actual five-edge diamond, with only c,d integrated out.
    H=[[sum(mu[c]*mu[d]*K[1][a][c]*K[2][a][d]*K[3][b][c]*K[4][b][d]*K[5][c][d]
             for c in range(n)for d in range(n))for b in range(n)]for a in range(n)]
    F=sum(mu[a]*mu[b]*K[0][a][b]*H[a][b]for a in range(n)for b in range(n))
    HT=[list(x)for x in zip(*H)];R=mm(K[0],HT,mu)
    assert tr(R,mu)==F
    Z=tr(mm(R,R,mu),mu)
    return F,Z,K

def barbell(T,mu,s,k,t):
    Ks=power(T,2*s,mu);Kk=power(T,2*k,mu);Kt=power(T,2*t,mu)
    return sum(mu[x]*mu[y]*(Ks[x][x]-1)*(Kk[x][y]-1)*(Kt[y][y]-1)
               for x in range(len(mu))for y in range(len(mu)))

def rowmat(A):return [[str(x)for x in row]for row in A]

# 1. Exact rank-one radial defect polynomial; all 2^12 subsets enumerated.
polys=[defaultdict(lambda:defaultdict(int)),defaultdict(lambda:defaultdict(int))]
counts=[];ne=(1,2,1,1,1,1)
for switch in (False,True):
    lifted=[(4*sh+a,4*(1-sh if switch and e==0 else sh)+b,e)
            for sh in (0,1)for e,(a,b)in enumerate(EDGES)]
    surviving=0
    for mask in range(1<<12):
        deg=[0]*8;weight=0
        for j,(a,b,e)in enumerate(lifted):
            if (mask>>j)&1:deg[a]+=1;deg[b]+=1;weight+=ne[e]
        if 1 in deg:continue
        b=deg.count(3);assert b%2==0
        surviving+=1;polys[int(switch)][weight][b//2]+=1
    counts.append(surviving)
expected={3:{0:2},4:{0:4},5:{0:2,1:2},6:{0:2,1:8},7:{0:6,2:2},
          8:{0:8,1:-2},9:{0:6,1:8},10:{0:2,1:2},11:{1:-2}}
actual={}
for w in set(polys[0])|set(polys[1]):
    terms={b:polys[0][w][b]-polys[1][w][b]for b in set(polys[0][w])|set(polys[1][w])}
    terms={b:v for b,v in terms.items()if v}
    if terms:actual[w]=terms
assert actual==expected and counts==[225,175]
mu2=[Q(1,10),Q(9,10)];phi=[Q(3),-Q(1,3)]
assert sum(mu2[i]*phi[i]for i in range(2))==0
assert sum(mu2[i]*phi[i]**2 for i in range(2))==1
c=sum(mu2[i]*phi[i]**3 for i in range(2))**2
assert c==Q(64,9)
def polynomial(z):return sum(Q(coeff)*c**b*z**w for w,terms in expected.items()for b,coeff in terms.items())
def regrouped(z):
    return (2*z**3+4*z**4+2*(1+c)*z**5+2*z**6+2*c*z**6*(4-z*z)
            +(6+2*c*c)*z**7+8*z**8+(6+8*c)*z**9+2*z**10+2*c*z**10*(1-z))
rankone=[]
for lam in (Q(0),Q(1,2),Q(1)):
    T=[[1+lam*phi[i]*phi[j]for j in range(2)]for i in range(2)]
    p,W=admissible(T,mu2);F,Z,K=base_and_ab_cover(T,mu2,(1,1,1,1,1));z=lam*lam
    assert F*F-Z==polynomial(z)==regrouped(z)>=0
    # Independent literal eight-vertex integration for the switched cover.
    direct=Q(0)
    for xs in product(range(2),repeat=8):
        term=Q(1)
        for x in xs:term*=mu2[x]
        for sh in (0,1):
            for e,(a,b)in enumerate(EDGES):
                term*=K[e][xs[4*sh+a]][xs[4*(1-sh if e==0 else sh)+b]]
        direct+=term
    assert direct==Z
    rankone.append({'lambda':str(lam),'p':str(p),'W':rowmat(W),'F':str(F),'Z_ab':str(Z),'F2_minus_Z_ab':str(F*F-Z)})
assert sum(Q(v)*c**b for b,v in expected[8].items())/4**8==-Q(7,73728)
assert sum(Q(v)*c**b for b,v in expected[11].items())/4**11==-Q(1,294912)

# 2. A small actual three-state root with a negative proper barbell.
G=[[21,0,8],[0,7,5],[8,5,43]];s=list(map(sum,G));total=sum(s)
assert s==[29,12,56] and total==97
mu3=[Q(x,total)for x in s]
T3=[[Q(total*G[i][j],s[i]*s[j])for j in range(3)]for i in range(3)]
p3,W3=admissible(T3,mu3);assert p3==Q(144,679)
B3=barbell(T3,mu3,4,10,3);assert B3<-Q(1,2*10**10)
F3,Z3,K3=base_and_ab_cover(T3,mu3,(10,1,1,1,1));assert F3>1 and Z3<F3*F3
# Direct six-variable integral of the specified seven-edge proper core.
CC=[centered(K)for K in K3];directB=Q(0)
for a,c,d,b,cc,dd in product(range(3),repeat=6):
    directB+=mu3[a]*mu3[c]*mu3[d]*mu3[b]*mu3[cc]*mu3[dd]*CC[1][a][c]*CC[2][a][d]*CC[5][c][d]*CC[0][a][b]*CC[3][b][cc]*CC[4][b][dd]*CC[5][cc][dd]
assert directB==B3
# Tied base-edge multidegree (1,1,1,1,1,2) has exactly two surviving
# barbells in the switched cover and no survivor in two disjoint K4s.
tied_counts=[]
for switch in (False,True):
    lifted=[(4*sh+a,4*(1-sh if switch and e==0 else sh)+b,e)for sh in(0,1)for e,(a,b)in enumerate(EDGES)]
    survivors=[]
    for onechoices in product((0,1),repeat=5):
        chosen=[lifted[6*onechoices[e]+e]for e in range(5)]+[lifted[5],lifted[11]]
        deg=[0]*8
        for a,b,e in chosen:deg[a]+=1;deg[b]+=1
        if 1 not in deg:survivors.append(chosen)
    tied_counts.append(len(survivors))
assert tied_counts==[0,2]
# Base centered eigenvalues are distinct positive roots of this quadratic.
b=-Q(5239,4872);cc=Q(191,696)
P3=[[T3[i][j]*mu3[j]for j in range(3)]for i in range(3)]
assert sum(P3[i][i]for i in range(3))==1-b
P3sq=[[sum(P3[i][k]*P3[k][j]for k in range(3))for j in range(3)]for i in range(3)]
assert sum(P3sq[i][i]for i in range(3))==1+b*b-2*cc
assert Q(1,16)+b/4+cc>0 and Q(1,4)+b/2+cc<0 and Q(9,16)+3*b/4+cc>0

# 3. Strict-positive five-state refinement: three positive bands plus zero.
# Split coarse state 0 with rare weight eta and state 1 by pure duplication.
gamma=Q(1,100);eta=gamma**4;tau=Q(1,2)
coarse=[0,0,1,1,2];nu=[eta,1-eta,Q(1,2),Q(1,2),Q(1)]
mu5=[mu3[coarse[i]]*nu[i]for i in range(5)]
Qf=[[Q(0)for j in range(5)]for i in range(5)]
for i in(0,1):
    for j in(0,1):Qf[i][j]=(Q(i==j)/nu[i]-1)/mu3[0]
assert mm(Qf,Qf,mu5)==Qf and tr(Qf,mu5)==1
L=[[T3[coarse[i]][coarse[j]]for j in range(5)]for i in range(5)]
zero=[[Q(0)for j in range(5)]for i in range(5)]
assert mm(L,Qf,mu5)==mm(Qf,L,mu5)==zero
U=[[L[i][j]+gamma*Qf[i][j]for j in range(5)]for i in range(5)]
admissible(U,mu5)
T5=[[1-tau+tau*U[i][j]for j in range(5)]for i in range(5)]
p5,W5=admissible(T5,mu5);assert min(map(min,T5))>=1-tau>0 and p5<Q(1,10000)
A5=power(T5,2,mu5);assert max(map(max,A5))>1000
# Full original-law transport, including all zero modes from duplication.
for q in(1,3,4,10):
    actual=power(T5,2*q,mu5);base=power(T3,2*q,mu3)
    expected_power=[[1+tau**(2*q)*(base[coarse[i]][coarse[j]]-1+gamma**(2*q)*Qf[i][j])for j in range(5)]for i in range(5)]
    assert actual==expected_power
B5=barbell(T5,mu5,4,10,3)
# Independent reduction into coarse fields and the centered rare split.
C10=centered(power(T3,20,mu3));D4=[power(T3,8,mu3)[i][i]-1 for i in range(3)];D3=[power(T3,6,mu3)[i][i]-1 for i in range(3)]
m=[1/mu3[0],Q(0),Q(0)]
reduced=sum(mu3[i]*mu3[j]*(D4[i]+gamma**8*m[i])*C10[i][j]*(D3[j]+gamma**6*m[j])for i in range(3)for j in range(3))
reduced+=gamma**34*(1-2*eta)**2/(mu3[0]*eta*(1-eta))
assert B5==tau**34*reduced<-Q(1,2*10**10*2**34)
F5,Z5,K5=base_and_ab_cover(T5,mu5,(10,1,1,1,1));assert F5>1 and Z5<F5*F5
# Characteristic polynomial by exact Faddeev-LeVerrier; verifies whole spectrum.
def usual_mm(A,B):return [[sum(A[i][k]*B[k][j]for k in range(len(A)))for j in range(len(A))]for i in range(len(A))]
def charpoly(A):
    n=len(A);I=[[Q(i==j)for j in range(n)]for i in range(n)];R=I;out=[Q(1)]
    for k in range(1,n+1):
        R=usual_mm(A,R);a=-sum(R[i][i]for i in range(n))/k;out.append(a)
        for i in range(n):R[i][i]+=a
    return out
# Eigenvalues of T5: 1, tau*lambda1, tau*lambda2, tau*gamma, 0.
def polymul(a,b):
    o=[Q(0)]*(len(a)+len(b)-1)
    for i,x in enumerate(a):
        for j,y in enumerate(b):o[i+j]+=x*y
    return o
expected_poly=polymul(polymul([1,-1],[1,b*tau,cc*tau*tau]),[1,-tau*gamma,0])
P5=[[T5[i][j]*mu5[j]for j in range(5)]for i in range(5)]
assert charpoly(P5)==expected_poly

files=['continuation5_cover_obstructions.md','continuation5_cover_obstructions_verify.py']
out={'status':'PASS','scope':'Negative proper-core and actual-ray coefficient signs; no target or full-cover counterexample.',
     'rank_one':{'original_mu':list(map(str,mu2)),'phi':list(map(str,phi)),'tuple':[1,1,1,1,1],
                 'core_counts_trivial_switched':counts,'radial_polynomial_in_z_lambda_squared':{str(w):{str(b):v for b,v in terms.items()}for w,terms in expected.items()},
                 'negative_tau_coefficients':{'16':'-7/73728','22':'-1/294912'},'direct_checks':rankone},
     'weighted_three_state':{'G':G,'mu':list(map(str,mu3)),'T':rowmat(T3),'p':str(p3),'W':rowmat(W3),'tuple':[10,1,1,1,1],
             'B_4_10_3':str(B3),'strict_B_bound':'B < -1/(2*10^10)','direct_six_vertex_barbell_verified':True,
             'tied_multidegree':[1,1,1,1,1,2],'tied_survivors_trivial_switched':tied_counts,'tied_cover_coefficient':str(2*B3),
             'F':str(F3),'Z_ab':str(Z3),'F2_minus_Z_ab':str(F3*F3-Z3),'centered_root_quadratic':[str(x)for x in(1,b,cc)]},
     'strict_positive_five_state':{'gamma':str(gamma),'eta':str(eta),'tau':str(tau),'coarse_map':coarse,'conditional_weights':list(map(str,nu)),
             'mu':list(map(str,mu5)),'T':rowmat(T5),'p':str(p5),'W':rowmat(W5),'max_A':str(max(map(max,A5))),'B_4_10_3':str(B5),
             'strict_B_bound':'B < -1/(2*10^10*2^34)','whole_centered_square_bands':['tau^2 lambda1^2','tau^2 lambda2^2','tau^2 gamma^2','0'],
             'whole_centered_multiplicities':[1,1,1,1],'root_characteristic_polynomial':list(map(str,expected_poly)),
             'F':str(F5),'Z_ab':str(Z5),'F2_minus_Z_ab':str(F5*F5-Z5)},
     'source_hashes':{f:hashlib.sha256(Path(f).read_bytes()).hexdigest()for f in files},'elapsed_seconds':time.time()-START}
Path('continuation5_cover_obstructions_checks.json').write_text(json.dumps(out,indent=2)+'\n')
print('PASS exact cover polynomial, paired-edge coefficient, original-law barbell, complete comparisons, and all five-state bands')
