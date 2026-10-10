"""Independent small exact original-measure audit; no search."""
from fractions import Fraction as Q
from itertools import product
import hashlib,json
from pathlib import Path
import numpy as np
from continuation3_channel import value, exact_certificate, exps, EDGES, CYCLES

def mm(X,Y,mu):
 n=len(mu)
 return [[sum(X[i][j]*mu[j]*Y[j][k] for j in range(n)) for k in range(n)] for i in range(n)]
def power(T,e,mu):
 n=len(mu);out=[[Q(int(i==j),1)/mu[j] for j in range(n)] for i in range(n)]
 for _ in range(e):out=mm(out,T,mu)
 return out
def density(mu,matrices):
 n=len(mu);total=Q(0)
 for a,b,c,d in product(range(n),repeat=4):
  xs=(a,b,c,d);v=mu[a]*mu[b]*mu[c]*mu[d]
  for M,(i,j) in zip(matrices,EDGES):v*=M[xs[i]][xs[j]]
  total+=v
 return total
G=[[3,1,0],[1,7,2],[0,2,5]];Qn=[[3,-2,0],[-2,-3,1],[0,1,2]];D=3;tpl=(3,2,3,1,2)
s=list(map(sum,G));C=sum(s);pi=[Q(v,C) for v in s]
S=[[Q(C*G[i][j],s[i]*s[j]) for j in range(3)] for i in range(3)]
H=[[S[i][j]*Q(Qn[i][j],D) for j in range(3)] for i in range(3)]
states=list(product(range(3),[-1,1]));mu=[pi[i]/2 for i,a in states]
T=[[S[i][j]+a*b*H[i][j] for j,b in states] for i,a in states]
assert all(x>=0 for row in T for x in row)
assert all(sum(T[i][j]*mu[j] for j in range(6))==1 for i in range(6))
ep=exps(tpl);Ks={e:power(S,2*e,pi) for e in set(ep)};Ls={e:power(H,2*e,pi) for e in set(ep)}
Fine={e:power(T,2*e,mu) for e in set(ep)}
assert all(Fine[e][v][w]==Ks[e][i][j]+a*b*Ls[e][i][j] for e in set(ep) for v,(i,a) in enumerate(states) for w,(j,b) in enumerate(states))
base=density(pi,[Ks[e] for e in ep]);fine=density(mu,[Fine[e] for e in ep])
cycles=[density(pi,[Ls[e] if t in cyc else Ks[e] for t,e in enumerate(ep)]) for cyc in CYCLES]
assert fine==base+sum(cycles)
cert=exact_certificate(G,Qn,D,tpl)
assert Q(cert['Fcoarse'])==base and Q(cert['Ffine'])==fine and list(map(Q,cert['cycle_terms']))==cycles
numeric=value(G,np.array(Qn)/D,tpl)
rel=lambda a,b:abs(float(a)-b)/max(1,abs(float(a)))
assert rel(fine,numeric['Ffine'])<2e-14
assert max(rel(a,b) for a,b in zip(cycles,numeric['cycle_terms']))<2e-14
rejected=[]
for bad in [(1.,1,1,1,1),(1,1,1,1),(1,2,1,1,1),(1,1,1,2,1),(1,1,1,1,0)]:
 for fn in [lambda: value(G,np.array(Qn)/D,bad),lambda:exact_certificate(G,Qn,D,bad)]:
  try:fn()
  except ValueError:rejected.append(True)
  else:raise AssertionError('invalid tuple accepted')
for bad in [[[4,0,0],[0,0,0],[0,0,0]],[[3,1,0],[0,0,0],[0,0,0]]]:
 try:exact_certificate(G,bad,D,tpl)
 except ValueError:rejected.append(True)
 else:raise AssertionError('invalid channel accepted')
out={'status':'PASS','exact_original_measure_fraction_density_equal':True,'exact_fine_power_decomposition_equal':True,'all_seven_exact_cycles_equal':True,'integer_engine_direct_fine_density_equal':True,'rejected_invalid_inputs':len(rejected),'weighted_coarse_pi':list(map(str,pi)),'original_fine_mu':list(map(str,mu)),'tuple':tpl,'G':G,'Qn':Qn,'D':D,'Fcoarse':str(base),'Ffine':str(fine),'cycle_terms':list(map(str,cycles)),'numeric_relative_fine_error':rel(fine,numeric['Ffine']),'hashes':{f:hashlib.sha256(Path(f).read_bytes()).hexdigest() for f in ['continuation3_channel.py','continuation3_config.json','continuation_cover_engine.py','continuation3_engine_checks.py']}}
Path('continuation3_engine_checks.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS',out['rejected_invalid_inputs'],'invalid-input checks; exact fine original-measure summation and all seven cycles agree')
