"""Bounded actual-root unequal-star diagnostic: scalar and codimension-one Q.
No floating-point sign here is a theorem or a target-density counterexample.
Original pi and all powers are built from the same nonnegative symmetric flow.
"""
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS','1')
os.environ.setdefault('OMP_NUM_THREADS','1')
import hashlib,json,time
from pathlib import Path
import numpy as np
from scipy.optimize import minimize

SEED=202610106
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'continuation6_search_rank_extremes_optimizations.json'
CAPS={'starts':18,'maxiter':180,'maxfun':36000,'maxls':30}

def model(v,n,ij):
    nf=len(ij); G=np.zeros((n,n),dtype=v.dtype)
    for a,(i,j) in zip(np.exp(v[:nf]),ij):G[i,j]=G[j,i]=a
    s=G.sum(1); pi=s/s.sum(); P=G/s[:,None]
    q=np.exp(v[nf:]);q=q/q.sum()
    return G,pi,P,q

def budget(v,n,ij,xyz,kind,details=False):
    G,pi,P,q=model(v,n,ij)
    K=[np.linalg.matrix_power(P,2*j)/pi[None,:] for j in xyz]
    # Symmetry in original measure permits rows indexed by the averaging state.
    # Qhat is an ordinary Euclidean orthogonal projection, representing Q.
    w=np.sqrt(q);Qh=np.outer(w,w)
    if kind=='complement':Qh=np.eye(n)-Qh;d=n-1
    else:d=1
    F=[np.einsum('ab,tb,bc->tac',Qh,Kj,Qh,optimize=True)-Qh for Kj in K]
    pair=sum(pi@np.einsum('tij,tji->t',F[i],F[j],optimize=True) for i,j in [(0,1),(0,2),(1,2)])
    cubic=pi@np.einsum('tij,tjk,tki->t',*F,optimize=True)
    objective=cubic/(pair+1e-14)
    if not details:return objective
    local=np.einsum('tij,tjk,tki->t',*(A+Qh for A in F),optimize=True)
    J=pi@local
    B=P@P; sym=np.sqrt(pi[:,None])*B/np.sqrt(pi[None,:])
    return dict(pair=float(pair.real),cubic=float(cubic.real),objective=float(objective.real),
      J=float(J.real),J_centered=float((d+pair+cubic).real),rank=d,
      local=local.real.tolist(),pi=pi.real.tolist(),q=q.real.tolist(),G=G.real.tolist(),
      square_spectrum=np.linalg.eigvalsh((sym+sym.T)/2).real.tolist(),
      min_root=float(np.min((P/pi[None,:]).real)),max_A=float(np.max((B/pi[None,:]).real)))

def initial(rng,n,family):
    if family=='geometric_path':
        G=np.zeros((n,n));q=2.**rng.integers(2,8)
        for i in range(n-1):G[i,i+1]=G[i+1,i]=q**(i-n+2)
        G[-1,-1]=q
        for i in range(n-1):G[i,i]=G.sum(1)[i]*2.**(-rng.integers(4,18))
    elif family=='rare_bipartite':
        G=np.zeros((n,n)); masses=2.**(-rng.integers(0,32,size=n))
        for i in range(n):
            for j in range(i,n):
                if (i%2)!=(j%2):G[i,j]=G[j,i]=min(masses[i],masses[j])*2.**rng.uniform(-3,2)
            G[i,i]=masses[i]*2.**(-rng.integers(6,20))
    elif family=='double_reservoir':
        G=np.zeros((n,n));masses=2.**(-rng.integers(0,26,size=n));masses[-2:]=1
        for i in range(n):G[i,i]=masses[i]*rng.uniform(.2,.9)
        for i in range(n-2):
            G[i,n-2+i%2]=G[n-2+i%2,i]=masses[i]*rng.uniform(.1,.8)
            if i<n-3:G[i,i+1]=G[i+1,i]=min(masses[i],masses[i+1])*rng.uniform(.05,.5)
        G[-1,-2]=G[-2,-1]=2.**(-rng.integers(8,20))
    else:raise ValueError(family)
    G=G/G.max()
    ij=[(int(i),int(j)) for i,j in zip(*np.where(np.triu(G)>0))]
    pi=G.sum(1)/G.sum()
    # Deliberately put nonconstant projection mass on several rare atoms.
    qq=pi*np.exp(rng.uniform(-9,9,n));qq[:min(3,n)]+=rng.uniform(.03,.2,min(3,n));qq/=qq.sum()
    logs=np.log(qq);logs-=logs.max()
    v=np.r_[np.log([G[i,j] for i,j in ij]),logs]
    return ij,np.clip(v,-36,5)

def run():
    t0=time.time();rng=np.random.default_rng(SEED)
    triples=[(1,2,3),(1,2,8),(1,3,16),(2,5,31),(1,4,64),(2,3,12),(1,2,32),(1,5,17),(3,7,24)]
    specs=[(8+2*(i%3),triples[i],['geometric_path','rare_bipartite','double_reservoir'][i%3],kind)
      for kind in ['scalar','complement'] for i in range(9)]
    out=dict(source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),seed=SEED,caps=CAPS,
      stop_rule='exactly eighteen configured starts unless strict candidate triggers rational certification',status='running',cases=[])
    for index,(n,xyz,family,kind) in enumerate(specs):
        ij,v=initial(rng,n,family);best=[float('inf'),None];real_calls=0;all_calls=0;hist=[]
        def fun(w):
            nonlocal real_calls,all_calls
            all_calls+=1;val=budget(w,n,ij,xyz,kind)
            if not np.iscomplexobj(w):
                real_calls+=1
                if float(val)<best[0]:best[:]=[float(val),w.copy()]
            return val
        def callback(w):hist.append(float(budget(w,n,ij,xyz,kind)))
        res=minimize(fun,v,method='L-BFGS-B',jac='cs',bounds=[(-36,5)]*len(v),callback=callback,
          options={'maxiter':CAPS['maxiter'],'maxfun':CAPS['maxfun'],'maxls':CAPS['maxls'],'ftol':2e-13,'gtol':2e-8})
        retained=budget(best[1],n,ij,xyz,kind,True)
        out['cases'].append(dict(index=index,n=n,xyz=xyz,family=family,kind=kind,ij=ij,
          initial_parameters=v.tolist(),initial=budget(v,n,ij,xyz,kind,True),
          retained_parameters=best[1].tolist(),retained=retained,history=hist,
          result={'success':bool(res.success),'status':int(res.status),'message':str(res.message),
             'nit':int(res.nit),'nfev':int(res.nfev),'njev':int(res.njev),'real_calls':real_calls,'all_calls':all_calls}))
        out['elapsed_seconds']=time.time()-t0;OUT.write_text(json.dumps(out,indent=2)+'\n')
        print(index,kind,family,n,xyz,'C/P',retained['objective'],'J/d',retained['J']/retained['rank'],
          'P',retained['pair'],'nit',res.nit,flush=True)
        if retained['J']<retained['rank']-1e-6 and retained['objective']<-1-1e-6:
            out['status']='strict numerical candidate; requires rational certificate';break
    else:out['status']='complete'
    out['elapsed_seconds']=time.time()-t0;OUT.write_text(json.dumps(out,indent=2)+'\n');print('DONE',out['status'],time.time()-t0,flush=True)
if __name__=='__main__':run()
