"""Exact host-scope and reproducibility audit of frozen completed continuation3 runs."""
from fractions import Fraction as Q
from collections import Counter
from pathlib import Path
import hashlib,json,math,platform,sys
import numpy as np
import scipy
from continuation3_channel import value, FAMILIES, TPLS

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def mm(A,B):
 n=len(A)
 return [[sum(A[i][k]*B[k][j] for k in range(n)) for j in range(n)] for i in range(n)]
def charpoly(A):
 n=len(A);B=[[Q(int(i==j))for j in range(n)]for i in range(n)];out=[Q(1)]
 for k in range(1,n+1):
  B=mm(A,B);c=-sum(B[i][i]for i in range(n))/k;out.append(c)
  for i in range(n):B[i][i]+=c
 assert all(v==0 for row in B for v in row)
 return out[::-1]
def trim(P):
 P=list(P)
 while len(P)>1 and P[-1]==0:P.pop()
 return P
def pdiv(A,B):
 A=trim(A);B=trim(B);out=[Q(0)]*max(1,len(A)-len(B)+1)
 while len(A)>=len(B) and any(A):
  j=len(A)-len(B);c=A[-1]/B[-1];out[j]=c
  for i in range(len(B)):A[i+j]-=c*B[i]
  A=trim(A)
 return trim(out),A
def pmul(A,B):
 out=[Q(0)]*(len(A)+len(B)-1)
 for i,a in enumerate(A):
  for j,b in enumerate(B):out[i+j]+=a*b
 return trim(out)
def distinct_degree(P):
 A=trim(P);B=trim([Q(i)*P[i]for i in range(1,len(P))])
 while any(B):
  _,R=pdiv(A,B);A=B;B=R
 return len(P)-len(A)
def exact_scope(G,q):
 n=len(G);G=[[Q(x) for x in row]for row in G];q=[[Q(x)for x in row]for row in q]
 assert all(G[i][j]==G[j][i]>=0 and q[i][j]==q[j][i] and abs(q[i][j])<=1 for i in range(n)for j in range(n))
 s=list(map(sum,G));C=sum(s);assert all(v>0 for v in s)
 pi=[v/C for v in s]
 S=[[C*G[i][j]/(s[i]*s[j]) for j in range(n)]for i in range(n)]
 H=[[S[i][j]*q[i][j]for j in range(n)]for i in range(n)]
 p=1/max(S[i][j]+abs(H[i][j]) for i in range(n)for j in range(n))
 maxA=max(sum(pi[t]*(S[i][t]*S[t][j])for t in range(n))+abs(sum(pi[t]*(H[i][t]*H[t][j])for t in range(n))) for i in range(n)for j in range(n))
 Ps=[[G[i][j]/s[i]for j in range(n)]for i in range(n)]
 Ph=[[G[i][j]*q[i][j]/s[i]for j in range(n)]for i in range(n)]
 polS=charpoly(mm(Ps,Ps));polH=charpoly(mm(Ph,Ph))
 centeredS,rem=pdiv(polS,[Q(-1),Q(1)]);assert not any(rem)
 assert pmul(centeredS,[Q(-1),Q(1)])==polS
 centeredFine=pmul(centeredS,polH)
 out={'p':str(p),'max_A_fine':str(maxA),'p_below_quarter':p<Q(1,4),'max_A_above_four':maxA>4,
  'coarse_centered_distinct_exact':distinct_degree(centeredS),'fine_centered_distinct_exact':distinct_degree(centeredFine),
  'coarse_centered_zero_band':centeredS[0]==0,'fine_centered_zero_band':centeredFine[0]==0,
  'root_has_zero_entry':any(S[i][j]==abs(H[i][j])for i in range(n)for j in range(n)),
  'uniform_coarse_measure':len(set(pi))==1,'coarse_pi':[str(v)for v in pi]}
 return out

def main():
 cfg=json.loads(Path('continuation3_config.json').read_text());sample=json.loads(Path('continuation3_samples.json').read_text());starts=json.loads(Path('continuation3_optimizer_starts.json').read_text());opts=json.loads(Path('continuation3_optimizations.json').read_text())
 assert cfg['source_sha256']==sha('continuation3_channel.py')==sample['source_sha256']
 assert sha('continuation3_config.json')==sample['config_sha256']==opts['config_sha256']
 assert sha('continuation3_optimizer_starts.json')==opts['starts_sha256']
 assert len(cfg['hosts'])==sample['completed']==len(sample['rows'])==180
 assert len(starts)==len(opts['runs'])==12
 audits=[]
 for rec,row in zip(cfg['hosts'],sample['rows']):
  assert all(row[k]==v for k,v in rec.items())
  G=rec['G_integer'];q=[[Q(v,rec['channel_denominator'])for v in line]for line in rec['channel_numerators']]
  audit=exact_scope(G,q);audit['id']=rec['id'];audit['n']=rec['n'];audits.append(audit)
  assert abs(float(Q(audit['p']))-row['p'])/row['p']<1e-12
  assert abs(float(Q(audit['max_A_fine']))-row['max_A_fine'])/row['max_A_fine']<1e-12
  v=value(G,np.array(rec['channel_numerators'])/rec['channel_denominator'],tuple(rec['tuple']))
  assert all(v[k]==row[k]for k in v)
 selected=[]
 for n in [4,5]:
  eligible=[r for r in sample['rows']if r['n']==n and r['p']<.25 and r['max_A_fine']>4 and r['coarse_centered_distinct_numeric']>=3]
  pairs=sorted([(r['cycle_normalized'][i],r,i)for r in eligible for i in range(7)],key=lambda x:x[0]);used=set()
  for score,r,i in pairs:
   if r['id']in used:continue
   selected.append({'kind':'cycle','cycle':i,'record':r});used.add(r['id'])
   if len(used)==4:break
  for r in sorted(eligible,key=lambda r:r['monotonicity_normalized'])[:2]:selected.append({'kind':'monotonicity','record':r})
 assert selected==starts
 optaudits=[]
 for j,(st,res)in enumerate(zip(starts,opts['runs'])):
  rec=st['record'];G0=np.array(rec['G_integer'],dtype=float);G0/=G0.max();q0=np.array(rec['channel_numerators'])/rec['channel_denominator'];ii,jj=np.nonzero(np.triu(G0>0));m=len(ii)
  x0=np.r_[np.log(G0[ii,jj]),np.arctanh(np.clip(q0[ii,jj],-.999,.999))];x0[:m]=np.clip(x0[:m],-10,10)
  assert x0.tolist()==res['starting_x'];assert res['run']==j and res['iterations']<=100
  x=np.array(res['best_x']);GG=np.zeros_like(G0);qq=np.zeros_like(q0);GG[ii,jj]=np.exp(x[:m]);qq[ii,jj]=np.tanh(x[m:]);GG+=np.triu(GG,1).T;qq+=np.triu(qq,1).T
  assert GG.tolist()==res['G_float']and qq.tolist()==res['channel_float']
  v=value(GG,qq,tuple(rec['tuple']));assert v==res['value']
  # JSON float coordinates are interpreted as exact dyadic values. Positivity,
  # symmetry, and |q|<=1 then give an exact actual host, independent of exp/tanh.
  audit=exact_scope(res['G_float'],res['channel_float']);audit['run']=j;optaudits.append(audit)
 inputs=['continuation3_channel.py','continuation3_config.json','continuation3_samples.json','continuation3_optimizer_starts.json','continuation3_optimizations.json','continuation3_engine_checks.py','continuation3_engine_checks.json','continuation_cover_engine.py','continuation3_audit.py']
 out={'status':'PASS','scope':'No new samples or optimizations; all stored host inputs and reported best points audited.',
  'source_and_config_hashes_match':True,'sample_replay_exact_binary64_equal':True,'adaptive_start_selection_reconstructed_exactly':True,'optimizer_initial_vectors_and_best_points_reconstructed_exactly':True,
  'actual_host_interpretation':'Samples: exact integer G and rational q. Optimizer best points: JSON float G and q are exact dyadic numbers; every G entry >=0, symmetric, positive row sums, |q|<=1. No boundary subtraction or clipping is used for root admissibility.',
  'exact_band_count_method':'Degree of squarefree part of rational characteristic polynomial of Ps^2 divided by x-1; for fine centered space multiply by characteristic polynomial of Ph^2 before taking squarefree part. Zero included whenever present; no approximate rank cutoff.',
  'sample_exact_scope':audits,'optimizer_exact_scope':optaudits,
  'counts':{'samples':180,'sample_cycle_evaluations':1260,'optimization_starts':12,'individual_cycle_starts':8,'whole_delta_starts':4,'optimization_iterations':sum(r['iterations']for r in opts['runs']),'objective_evaluations':sum(r['calls']for r in opts['runs']),
   'converged_starts':sum(r['success']for r in opts['runs']),'iteration_limit_starts':sum(r['status']==1 for r in opts['runs']),
   'sample_p_below_quarter':sum(r['p_below_quarter']for r in audits),'sample_max_A_above_four':sum(r['max_A_above_four']for r in audits),'sample_both':sum(r['p_below_quarter']and r['max_A_above_four']for r in audits),
   'sample_root_zero':sum(r['root_has_zero_entry']for r in audits),'sample_coarse_zero_band':sum(r['coarse_centered_zero_band']for r in audits),'sample_fine_zero_band':sum(r['fine_centered_zero_band']for r in audits),
   'sample_weighted_nonuniform':sum(not r['uniform_coarse_measure']for r in audits),
   'optimizer_p_below_quarter':sum(r['p_below_quarter']for r in optaudits),'optimizer_max_A_above_four':sum(r['max_A_above_four']for r in optaudits),
   'sample_coarse_band_counts':dict(Counter(r['coarse_centered_distinct_exact']for r in audits)),'sample_fine_band_counts':dict(Counter(r['fine_centered_distinct_exact']for r in audits)),
   'optimizer_coarse_band_counts':dict(Counter(r['coarse_centered_distinct_exact']for r in optaudits)),'optimizer_fine_band_counts':dict(Counter(r['fine_centered_distinct_exact']for r in optaudits))},
  'runtime_versions':{'python':sys.version.split()[0],'numpy':np.__version__,'scipy':scipy.__version__,'platform':platform.platform()},'hashes':{p:sha(p)for p in inputs}}
 Path('continuation3_audit.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS',json.dumps(out['counts'],sort_keys=True))
if __name__=='__main__':main()
