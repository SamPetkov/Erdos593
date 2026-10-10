"""Bounded signed-binary-channel diagnostic on actual original-measure hosts.

S_ij=C G_ij/(s_i s_j), pi_i=s_i/C, H=S*q, |q_ij|<=1.
Fine mu(i,a)=pi_i/2 and T((i,a),(j,b))=S_ij+H_ij*a*b.
T is an actual symmetric nonnegative Markov root. The even fine powers
are S^(2e)+a*b H^(2e), all products using ORIGINAL pi.
Only the empty edge set and the seven K4 cycles survive averaging spins.
"""
import argparse,hashlib,json,math,sys,time
from fractions import Fraction as Q
from functools import lru_cache
from pathlib import Path
from math import lcm
import numpy as np
from scipy.optimize import minimize

EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
CYCLES=((0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,3,5,2),(0,4,5,1),(1,3,4,2))
TPLS=((1,1,1,1,1),(2,2,1,1,1),(3,1,1,1,1),(6,1,1,1,1),
 (1,1,3,3,1),(2,1,3,1,1),(4,4,1,1,8),(8,4,1,1,8),
 (3,2,5,3,7),(1,1,1,1,16),(4,1,2,1,6),(4,4,2,2,1))
FAMILIES=('diagonal_weighted','weighted_star','weighted_path','sparse_integer','bridged_blocks','dense_logwide')

def dump(name,x):Path('continuation3_'+name+'.json').write_text(json.dumps(x,indent=2)+'\n')
def read(name):return json.loads(Path('continuation3_'+name+'.json').read_text())
def sha(name):return hashlib.sha256(Path(name).read_bytes()).hexdigest()
def exps(tpl):
 if len(tpl)!=5 or any(type(x)is not int for x in tpl):raise ValueError('five exact integer tuple entries required')
 k,u,r,l,h=tpl
 if not(k>=u>=1 and r>=l>=1 and h>=1):raise ValueError('ordered target tuple required')
 return k,r+h,u,r,u,l

def edge_shapes(mats,n):
 ans=[]
 for M,(a,b)in zip(mats,EDGES):
  shape=[1]*4;shape[a]=shape[b]=n;ans.append(np.asarray(M).reshape(shape))
 return ans

def value(G,q,tpl,only_cycle=None):
 G=np.asarray(G,dtype=float);q=np.asarray(q,dtype=float);n=len(G)
 if G.shape!=(n,n)or q.shape!=(n,n)or not np.array_equal(G,G.T)or not np.array_equal(q,q.T)or np.min(G)<0 or np.max(np.abs(q))>1:raise ValueError('invalid symmetric actual-channel parameters')
 s=G.sum(1);C=s.sum();pi=s/C
 if np.any(s<=0):raise ValueError('positive rows required')
 Ps=G/s[:,None];Ph=Ps*q;ep=exps(tpl);K={};L={}
 for e in set(ep)|{1}:
  A=np.linalg.matrix_power(Ps,2*e)/pi[None,:];B=np.linalg.matrix_power(Ph,2*e)/pi[None,:]
  K[e]=(A+A.T)/2;L[e]=(B+B.T)/2
 Ks=edge_shapes([K[e]for e in ep],n);Ls=edge_shapes([L[e]for e in ep],n)
 weight=pi[:,None,None,None]*pi[None,:,None,None]*pi[None,None,:,None]*pi[None,None,None,:]
 if only_cycle is not None:
  cyc=CYCLES[only_cycle];terms=weight.copy()
  for e in range(6):terms*=Ls[e]if e in cyc else Ks[e]
  v=float(terms.sum());a=float(np.abs(terms).sum());return v/max(a,1e-300)
 terms=weight.copy()
 for x in Ks:terms*=x
 coarse=float(terms.sum());cycles=[];abss=[]
 for cyc in CYCLES:
  terms=weight.copy()
  for e in range(6):terms*=Ls[e]if e in cyc else Ks[e]
  cycles.append(float(terms.sum()));abss.append(float(np.abs(terms).sum()))
 delta=sum(cycles);fine=coarse+delta;S=G*C/(s[:,None]*s[None,:]);Tmax=float(np.max(S*(1+np.abs(q))))
 B=G/np.sqrt(s[:,None]*s[None,:]);ev=np.linalg.eigvalsh(B);centered=list(ev[np.arange(n)!=int(np.argmin(np.abs(ev-1))) ]**2)
 return {'coarse_pi':pi.tolist(),'Fcoarse':coarse,'Ffine':fine,'monotonicity_defect':delta,
  'cycle_terms':cycles,'cycle_absolute_sums':abss,'cycle_normalized':[v/max(a,1e-300)for v,a in zip(cycles,abss)],
  'monotonicity_normalized':delta/max(sum(abss),1e-300),'p':1/Tmax,'max_A_fine':float(np.max(K[1]+np.abs(L[1]))),
  'coarse_centered_eigenvalues':centered,'coarse_centered_distinct_numeric':len(np.unique(np.round(centered,10)))}

def host(rng,n,family):
 if family=='dense_logwide':
  G=2**rng.integers(0,13,size=(n,n));G=np.triu(G)+np.triu(G,1).T
 elif family=='diagonal_weighted':
  G=rng.integers(1,5,size=(n,n));G=np.triu(G)+np.triu(G,1).T
  G+=np.diag(2**rng.integers(1,15,size=n))
 elif family in ('weighted_star','weighted_path'):
  G=np.diag(rng.integers(1,6,size=n)*(2**rng.integers(0,10,size=n)))
  for i in range(1,n):
   j=0 if family=='weighted_star'else i-1;G[i,j]=G[j,i]=int(rng.integers(1,9))
 elif family=='sparse_integer':
  G=rng.integers(1,17,size=(n,n))*(rng.random((n,n))<.45);G=np.triu(G)+np.triu(G,1).T
  G+=np.diag(2**rng.integers(0,12,size=n))
 elif family=='bridged_blocks':
  cut=int(rng.integers(1,n));G=np.zeros((n,n),dtype=int)
  for inds in [range(cut),range(cut,n)]:
   for i in inds:
    for j in inds:
     if j>=i:G[i,j]=G[j,i]=int(rng.integers(1,17))*(2**int(rng.integers(0,7)))
  G[cut-1,cut]=G[cut,cut-1]=1
 else:raise ValueError(family)
 # A deterministic rare, sticky vertex gives substantial original-measure
 # normalization contrasts in most families, without any zero probability.
 if rng.random()<.75:
  G[0,:]=np.minimum(G[0,:],2);G[:,0]=G[0,:];G[0,0]=int(rng.integers(1,5))
 Qn=rng.integers(-8,9,size=(n,n));Qn=np.triu(Qn)+np.triu(Qn,1).T
 if rng.random()<.5:Qn=np.where(Qn>=0,8,-8)
 Qn[G==0]=0
 return G,Qn,8

def freeze():
 rng=np.random.default_rng(20261013);hosts=[]
 for n in [3,4,5]:
  for fi,fam in enumerate(FAMILIES):
   for j in range(10):
    G,Qn,d=host(rng,n,fam);tpl=TPLS[(fi*10+j)%len(TPLS)]
    hosts.append({'id':len(hosts),'n':n,'family':fam,'G_integer':G.tolist(),'channel_numerators':Qn.tolist(),'channel_denominator':d,'tuple':tpl})
 cfg={'schema':'actual-signed-binary-channel/v1','seed':20261013,'tuples':TPLS,'tuple_order':['k','u','r','l','h'],'cycles':CYCLES,
  'sample_cap':180,'optimization_start_cap':12,'iterations_per_start':100,'log_G_bounds':[-10,10],'channel_atanh_bounds':[-6,6],
  'optimizer_options':{'maxiter':100,'ftol':1e-12,'gtol':1e-8,'maxls':25},'candidate_normalized_threshold':-1e-8,
  'target_absolute_threshold':1-1e-8,'hosts':hosts,'source_sha256':sha('continuation3_channel.py')}
 dump('config',cfg);print('CONFIG_FROZEN',sha('continuation3_config.json'),flush=True)

def exact_certificate(G,Qn,d,tpl):
 from continuation_cover_engine import exact_integer_certificate
 G=np.asarray(G,dtype=object);Qn=np.asarray(Qn,dtype=object);n=len(G)
 if type(d)is not int or d<=0 or G.shape!=(n,n)or Qn.shape!=(n,n):raise ValueError('invalid dimensions')
 if any(type(x)is not int for x in G.flat)or any(type(x)is not int for x in Qn.flat):raise ValueError('integer G and channel numerators required')
 if any(G[i,j]!=G[j,i]or Qn[i,j]!=Qn[j,i]or G[i,j]<0 or abs(Qn[i,j])>d for i in range(n)for j in range(n)):raise ValueError('invalid actual channel')
 s=list(map(int,G.sum(1)));C=sum(s)
 if min(s)<=0:raise ValueError('positive row sums required')
 ep=exps(tpl);N=sum(ep);L=lcm(*s)
 R=np.array([[G[i,j]*(L//s[i])for j in range(n)]for i in range(n)],dtype=object);RH=R*Qn
 B={};J={}
 for e in set(ep)|{1}:
  Ps=np.linalg.matrix_power(R,2*e);Ph=np.linalg.matrix_power(RH,2*e)
  B[e]=np.array([[C*(L//s[j])*Ps[i,j]*d**(2*e)for j in range(n)]for i in range(n)],dtype=object)
  J[e]=np.array([[C*(L//s[j])*Ph[i,j]for j in range(n)]for i in range(n)],dtype=object)
 den=C**4*L**(2*N+6)*d**(2*N);Bs=edge_shapes([B[e]for e in ep],n);Js=edge_shapes([J[e]for e in ep],n)
 weights=np.array(s,dtype=object);weight=weights[:,None,None,None]*weights[None,:,None,None]*weights[None,None,:,None]*weights[None,None,None,:]
 terms=weight.copy()
 for x in Bs:terms*=x
 coarse=int(terms.sum());cycles=[]
 for cyc in CYCLES:
  terms=weight.copy()
  for e in range(6):terms*=Js[e]if e in cyc else Bs[e]
  cycles.append(int(terms.sum()))
 delta=sum(cycles);fine=coarse+delta
 fineG=np.array([[int(G[i,j])*(d+int(Qn[i,j])*a*b)for j in range(n)for b in (-1,1)]for i in range(n)for a in (-1,1)],dtype=object)
 independent=exact_integer_certificate(fineG.tolist(),tpl,((0,),(0,),(0,)))
 assert Q(fine,den)==Q(independent['base_numerator'],independent['base_denominator'])
 T=[[Q(C*int(G[i,j])*(d+int(Qn[i,j])*a*b),d*s[i]*s[j])for j in range(n)for b in (-1,1)]for i in range(n)for a in (-1,1)]
 p=1/max(v for row in T for v in row);W=[[p*v for v in row]for row in T];mu=[Q(s[i],2*C)for i in range(n)for a in (-1,1)]
 assert all(sum(mu[j]*W[i][j]for j in range(2*n))==p for i in range(2*n))
 assert all(0<=v<=1 for row in W for v in row)
 maxA=max(Q(int(B[1][i,j])+abs(int(J[1][i,j])),d*d*L**3)for i in range(n)for j in range(n))
 return {'G_integer':G.tolist(),'channel_numerators':Qn.tolist(),'channel_denominator':d,'tuple':tpl,'tuple_order':'k,u,r,l,h','cycles':CYCLES,
  'original_coarse_pi':[str(Q(v,C))for v in s],'original_fine_mu':list(map(str,mu)),'fine_state_order':[[i,a]for i in range(n)for a in (-1,1)],
  'p':str(p),'max_A_fine':str(maxA),'W':[[str(v)for v in row]for row in W],
  'Fcoarse':str(Q(coarse,den)),'Ffine':str(Q(fine,den)),'monotonicity_defect':str(Q(delta,den)),'cycle_terms':[str(Q(v,den))for v in cycles],
  'negative_cycle_indices':[i for i,v in enumerate(cycles)if v<0],'monotonicity_violation':delta<0,'target_violation':fine<den,
  'independent_fine_integer_density_equal':True,'p_below_quarter':p<Q(1,4),'max_A_above_four':maxA>4}

def certify_record(rec,label):
 c=exact_certificate(rec['G_integer'],rec['channel_numerators'],rec['channel_denominator'],tuple(rec['tuple']));c['source_record']=rec['id'];dump(label,c)
 print('EXACT_CERTIFICATE',label,'negative_cycles',c['negative_cycle_indices'],'monotonicity',c['monotonicity_violation'],'target',c['target_violation'],flush=True);return c

def sample():
 cfg=read('config');assert cfg['source_sha256']==sha('continuation3_channel.py');out=[];certs=[];start=time.time()
 for rec in cfg['hosts']:
  v=value(rec['G_integer'],np.array(rec['channel_numerators'])/rec['channel_denominator'],tuple(rec['tuple']));row={**rec,**v};out.append(row)
  if min(v['cycle_normalized'])<cfg['candidate_normalized_threshold']or v['monotonicity_normalized']<cfg['candidate_normalized_threshold']or v['Ffine']<cfg['target_absolute_threshold']:
   c=certify_record(row,'sample_certificate_'+str(rec['id']));certs.append({'file':'continuation3_sample_certificate_'+str(rec['id'])+'.json','negative_cycles':c['negative_cycle_indices'],'monotonicity_violation':c['monotonicity_violation'],'target_violation':c['target_violation']})
  if len(out)%30==0:print('SAMPLE_PROGRESS',len(out),'minimum_cycle_normalized',min(min(x['cycle_normalized'])for x in out),'seconds',round(time.time()-start,3),flush=True)
 dump('samples',{'config_sha256':sha('continuation3_config.json'),'source_sha256':cfg['source_sha256'],'rows':out,'completed':len(out),'certificates':certs,'elapsed':time.time()-start})
 # Eight cycle objectives and four whole-monotonicity objectives, all on n4/5.
 starts=[]
 for n in [4,5]:
  eligible=[r for r in out if r['n']==n and r['p']<.25 and r['max_A_fine']>4 and r['coarse_centered_distinct_numeric']>=3]
  pairs=sorted([(r['cycle_normalized'][i],r,i)for r in eligible for i in range(7)],key=lambda x:x[0]);used=set()
  for score,r,i in pairs:
   if r['id']in used:continue
   starts.append({'kind':'cycle','cycle':i,'record':r});used.add(r['id'])
   if len(used)==4:break
  for r in sorted(eligible,key=lambda x:x['monotonicity_normalized'])[:2]:starts.append({'kind':'monotonicity','record':r})
 assert len(starts)==12;dump('optimizer_starts',starts)
 print('SAMPLE_DONE',len(out),'exact_certificates',len(certs),'selected_starts',len(starts),flush=True)

def rationalized_certificate(G,q,tpl,label):
 for scale,d in [(1000,100),(10000,1000),(1000000,10000)]:
  Gi=np.rint(G/G.max()*scale).astype(int);Gi[(G>0)&(Gi==0)]=1;Qn=np.rint(q*d).astype(int);Qn=np.maximum(-d,np.minimum(d,Qn));Qn[Gi==0]=0
  v=value(Gi,Qn/d,tpl)
  if min(v['cycle_normalized'])>=-1e-8 and v['monotonicity_normalized']>=-1e-8 and v['Ffine']>=1-1e-8:continue
  c=exact_certificate(Gi.astype(object),Qn.astype(object),d,tpl);c['rationalization']={'flow_scale':scale,'channel_denominator':d,'positive_flow_floor':1};dump(label,c)
  print('EXACT_OPT_CERTIFICATE',label,'negative_cycles',c['negative_cycle_indices'],'monotonicity',c['monotonicity_violation'],'target',c['target_violation'],flush=True)
  return c
 return None

def optimize():
 cfg=read('config');assert cfg['source_sha256']==sha('continuation3_channel.py');starts=read('optimizer_starts');out=[];start=time.time()
 for j,seed in enumerate(starts):
  rec=seed['record'];G0=np.array(rec['G_integer'],dtype=float);G0/=G0.max();q0=np.array(rec['channel_numerators'])/rec['channel_denominator'];mask=np.triu(G0>0);ii,jj=np.nonzero(mask);m=len(ii);qstart=np.clip(q0[ii,jj],-.999,.999)
  x0=np.r_[np.log(G0[ii,jj]),np.arctanh(qstart)];x0[:m]=np.maximum(-10,np.minimum(10,x0[:m]));tpl=tuple(rec['tuple']);calls=0;best=None
  def unpack(x):
   G=np.zeros_like(G0);q=np.zeros_like(q0);G[ii,jj]=np.exp(x[:m]);q[ii,jj]=np.tanh(x[m:]);G+=np.triu(G,1).T;q+=np.triu(q,1).T;return G,q
  def obj(x):
   nonlocal calls,best
   calls+=1;G,q=unpack(x)
   if seed['kind']=='cycle':score=value(G,q,tpl,seed['cycle'])
   else:score=value(G,q,tpl)['monotonicity_normalized']
   if best is None or score<best['score']:best={'score':score,'x':x.tolist(),'call':calls}
   return score
  res=minimize(obj,x0,method='L-BFGS-B',bounds=[(-10,10)]*m+[(-6,6)]*m,options=cfg['optimizer_options'])
  G,q=unpack(np.array(best['x']));v=value(G,q,tpl);row={'run':j,'objective_kind':seed['kind'],'cycle':seed.get('cycle'),'seed_record_id':rec['id'],'tuple':tpl,
   'starting_x':x0.tolist(),'best_x':best['x'],'G_float':G.tolist(),'channel_float':q.tolist(),'value':v,'iterations':res.nit,'calls':calls,'success':bool(res.success),'status':int(res.status),'message':str(res.message),'best_call':best['call']}
  if min(v['cycle_normalized'])<-1e-8 or v['monotonicity_normalized']<-1e-8 or v['Ffine']<1-1e-8:
   c=rationalized_certificate(G,q,tpl,'optimization_certificate_'+str(j));row['certificate_found']=c is not None
   if c:row['certificate_flags']={k:c[k]for k in ['negative_cycle_indices','monotonicity_violation','target_violation']}
  out.append(row);dump('optimizations',{'config_sha256':sha('continuation3_config.json'),'starts_sha256':sha('continuation3_optimizer_starts.json'),'runs':out,'elapsed':time.time()-start})
  print('OPT_DONE',j,seed['kind'],'cycle_min',min(v['cycle_normalized']),'delta_norm',v['monotonicity_normalized'],'nit',res.nit,'calls',calls,'success',res.success,'seconds',round(time.time()-start,3),flush=True)

if __name__=='__main__':
 sys.set_int_max_str_digits(0);ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['freeze','sample','optimize']);args=ap.parse_args();globals()[args.mode]()
