"""Exact quadratic unequal-star certificate on the frozen weighted host."""
from fractions import Fraction as F
from pathlib import Path
import hashlib,itertools,json,time
start=time.time()
def eye(pi):return [[F(i==j)/pi[i]for j in range(len(pi))]for i in range(len(pi))]
def mm(A,B,pi):return [[sum(pi[k]*A[i][k]*B[k][j]for k in range(len(pi)))for j in range(len(pi))]for i in range(len(pi))]
def power(A,n,pi):
 R=eye(pi)
 while n:
  if n&1:R=mm(R,A,pi)
  A=mm(A,A,pi);n//=2
 return R
def tr(A,pi):return sum(pi[i]*A[i][i]for i in range(len(pi)))
def tr2(A,B,pi):return tr(mm(A,B,pi),pi)
def tr3(A,B,C,pi):return tr(mm(mm(A,B,pi),C,pi),pi)
def sub(A,B):return [[a-b for a,b in zip(r,s)]for r,s in zip(A,B)]
def field(Q,K,pi):return [[[sum(pi[a]*Q[i][a]*K[a][t]*Q[a][j]for a in range(len(pi)))for j in range(len(pi))]for i in range(len(pi))]for t in range(len(pi))]
def charpoly(A,pi):
 B=eye(pi);Id=eye(pi);out=[F(1)]
 for k in range(1,len(pi)+1):
  B=mm(A,B,pi);c=-tr(B,pi)/k;out.append(c);B=[[B[i][j]+c*Id[i][j]for j in range(len(pi))]for i in range(len(pi))]
 assert all(x==0 for row in B for x in row)
 return out
def polymul(p,q):
 out=[F(0)]*(len(p)+len(q)-1)
 for i,a in enumerate(p):
  for j,b in enumerate(q):out[i+j]+=a*b
 return out
def polytrim(p):
 while len(p)>1 and p[0]==0:p=p[1:]
 return p
def polyrem(p,q):
 p=p[:]
 while len(p)>=len(q)and any(p):
  z=p[0]/q[0]
  for i in range(len(q)):p[i]-=z*q[i]
  p=polytrim(p)
 return p
def coprime(p,q):
 while any(q):p,q=q,polyrem(p,q)
 return len(p)==1
pi=[F(3,5),F(1,5),F(1,10),F(1,10)];weights=[60,20,10,10]
flow=[[59,1,0,0],[1,18,1,0],[0,1,8,1],[0,0,1,9]]
S0=[[F(100*flow[i][j],weights[i]*weights[j])for j in range(4)]for i in range(4)]
S=[[F(31,32)*S0[i][j]+F(1,32)for j in range(4)]for i in range(4)]
f=[1,0,-3,-3];Q=[[1+F(5,12)*f[i]*f[j]for j in range(4)]for i in range(4)]
assert mm(Q,Q,pi)==Q and tr(Q,pi)==2 and min(map(min,Q))==-F(1,4)
assert mm(S,Q,pi)!=mm(Q,S,pi)
assert sum(pi[i]*f[i]for i in range(4))==0 and sum(pi[i]*f[i]**2 for i in range(4))==F(12,5)
for root in(S0,S):
 assert min(map(min,root))>=0 and all(sum(pi[j]*root[i][j]for j in range(4))==1 for i in range(4))
assert min(pi[i]*S0[i][i]for i in range(4))==F(4,5)
alpha=F(1,128);beta=alpha*alpha;p=F(512,4499)
mu=[x/2 for x in pi for a in(-1,1)]
T=[[S[i][j]+alpha*Q[i][j]*a*b for j in range(4)for b in(-1,1)]for i in range(4)for a in(-1,1)]
assert min(map(min,T))==F(3,128) and max(map(max,T))==F(4499,512)
W=[[p*x for x in row]for row in T]
assert min(map(min,W))>0 and max(map(max,W))==1
assert all(sum(mu[j]*W[i][j]for j in range(8))==p for i in range(8))
B=mm(S,S,pi);A=mm(T,T,mu)
powB={s:power(B,s,pi)for s in(1,2,8)};powA={s:power(A,s,mu)for s in(1,2,8)}
for n in powB:
 assert powA[n]==[[powB[n][i][j]+beta**n*Q[i][j]*a*b for j in range(4)for b in(-1,1)]for i in range(4)for a in(-1,1)]
fields={s:field(Q,powB[s],pi)for s in powB}
g21=sum(pi[t]*tr2(fields[2][t],fields[1][t],pi)for t in range(4))
g81=sum(pi[t]*tr2(fields[8][t],fields[1][t],pi)for t in range(4))
v28=sum(pi[t]*tr2(sub(fields[2][t],fields[8][t]),sub(fields[2][t],fields[8][t]),pi)for t in range(4))
m1=max(map(max,B));LB=(g21*g21+g81*g81)/4-m1*v28/2
assert g21>=2 and g81>=2 and v28>=0
assert LB>F(24,5)
J=sum(pi[t]*tr3(fields[1][t],fields[2][t],fields[8][t],pi)for t in range(4))
assert J>=LB
# Independently integrate the original four-colour star.
star=sum(pi[a]*pi[b]*pi[c]*pi[d]*Q[a][b]*Q[b][c]*Q[c][a]*powB[1][a][d]*powB[2][b][d]*powB[8][c][d]for a,b,c,d in itertools.product(range(4),repeat=4))
assert star==J
# Paired polarization and its actual PSD domination bound are exact.
J221=sum(pi[t]*tr3(fields[2][t],fields[2][t],fields[1][t],pi)for t in range(4))
J881=sum(pi[t]*tr3(fields[8][t],fields[8][t],fields[1][t],pi)for t in range(4))
error=sum(pi[t]*tr3(sub(fields[2][t],fields[8][t]),sub(fields[2][t],fields[8][t]),fields[1][t],pi)for t in range(4))
assert 2*J==J221+J881-error
assert 2*J221>=g21*g21 and 2*J881>=g81*g81 and error<=m1*v28
edges=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3));exps=(1,8,1,2,1,1)
cycles=((0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,2,3,5),(0,1,4,5),(1,2,3,4))
cycleweights=[sum(exps[i]for i in cyc)for cyc in cycles];assert cycleweights==[11,3,10,4,5,11,12]
coeff=[]
for cyc in cycles:
 val=F(0)
 for cs in itertools.product(range(4),repeat=4):
  term=F(1)
  for color in cs:term*=pi[color]
  for idx,(u,v)in enumerate(edges):term*=Q[cs[u]][cs[v]]if idx in cyc else powB[exps[idx]][cs[u]][cs[v]]
  val+=term
 coeff.append(val)
assert coeff[1]==J and all(v>=2 for v in coeff)
def density(powers,prob):
 value=F(0)
 for cs in itertools.product(range(len(prob)),repeat=4):
  term=F(1)
  for color in cs:term*=prob[color]
  for (u,v),n in zip(edges,exps):term*=powers[n][cs[u]][cs[v]]
  value+=term
 return value
Fc=density(powB,pi);Ff=density(powA,mu)
assert Ff==Fc+sum(beta**q*v for q,v in zip(cycleweights,coeff))
claimed=Fc+F(24,5)*beta**3+2*(beta**4+beta**5+beta**10+2*beta**11+beta**12)
assert Ff>claimed>Fc>1
# Reflection family scope and full centered band check.
k,u,r,l,h=(1,1,2,1,6)
assert not(k==u and r==l)and not(k==r and u==l)and not(k==r+h and u==l)
pc=charpoly(B,pi);pf=charpoly(A,mu)
assert pf==polymul(pc,[1,-2*beta,beta*beta,0,0])
deriv=[pc[i]*(4-i)for i in range(4)]
assert coprime(pc,deriv)
assert beta<F(93,160)**2
# The sufficient quadratic criterion is not necessary: test all orientations
# on an independently reconstructed strict-positive cancellation-family member.
t=F(1,16);e=t**22;aa=t**-9;DD=1+t**4-t**22;zz=t**8
piC=[e/2,e/2,(1-e)/2,(1-e)/2];vC=[[aa,0],[0,aa],[0,1],[1,0]]
QC=[[2*sum(vC[i][j]*vC[k][j]for j in range(2))/DD for k in range(4)]for i in range(4)]
SC0=[[2*(1-t*t+(t*t/[e,1-e][i//2]if i//2==j//2 else 0))if i%2!=j%2 else F(0)for j in range(4)]for i in range(4)]
SC=[[(1-zz)*SC0[i][j]+zz for j in range(4)]for i in range(4)]
KC={s:power(SC,2*s,piC)for s in(1,2,8)};MC={s:field(QC,KC[s],piC)for s in KC}
JC=sum(piC[t]*tr3(MC[1][t],MC[2][t],MC[8][t],piC)for t in range(4));assert 2<JC<9
limit_bounds=[]
for z in(1,2,8):
 x,y=[v for v in(1,2,8)if v!=z]
 gx=sum(piC[t]*tr2(MC[x][t],MC[z][t],piC)for t in range(4));gy=sum(piC[t]*tr2(MC[y][t],MC[z][t],piC)for t in range(4))
 variance=sum(piC[t]*tr2(sub(MC[x][t],MC[y][t]),sub(MC[x][t],MC[y][t]),piC)for t in range(4))
 bound=(gx*gx+gy*gy)/4-max(map(max,KC[z]))*variance/2
 assert bound<0
 limit_bounds.append({'x':x,'y':y,'z':z,'exact_bound':str(bound)})
files=['continuation5_unequal_quadratic_bound.md','continuation5_unequal_quadratic_verify.py']
result={'status':'PASS','scope':'quadratic sufficient certificate on a fixed actual host; not universal J>=d or F>=1','original_coarse_mu':[str(x)for x in pi],'original_fine_mu':[str(x)for x in mu],'tuple':[k,u,r,l,h],'edge_exponents':list(exps),'d':2,'g_2_1':str(g21),'g_8_1':str(g81),'v_2_8':str(v28),'m_1':str(m1),'quadratic_lower_bound':str(LB),'exact_gap_above_24_over_5':str(LB-F(24,5)),'direct_star_J':str(J),'cycle_weights':cycleweights,'cycle_coefficients':[str(x)for x in coeff],'coarse_F':str(Fc),'fine_F':str(Ff),'claimed_lower_bound':str(claimed),'coarse_characteristic_polynomial':[str(x)for x in pc],'fine_characteristic_polynomial':[str(x)for x in pf],'full_centered_band_count':5,'centered_zero_multiplicity':2,'coarse_distinct_centered_positive_bands':3,'exact_fine_factorization_verified':True,'source_hashes':{p:hashlib.sha256(Path(p).read_bytes()).hexdigest()for p in files},'limitation_control':{'t':'1/16','exact_J':str(JC),'bounds_all_strictly_negative':limit_bounds,'conclusion':'the sufficient quadratic certificate is not necessary'},'elapsed_seconds':time.time()-start}
Path('continuation5_unequal_quadratic_checks.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS: original weighted roots, quadratic bound >24/5, seven cycles, full F, and five complete centered bands')
