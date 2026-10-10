"""Bounded actual-root search for an unequal-star projection contraction.

Every root is specified by a nonnegative symmetric flow G.  Its ORIGINAL
stationary law is pi=G1/(1^T G1).  Q is a rank-d original-law projection.
No candidate from this numerical file is an exact sign certificate.
"""
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS','1')
os.environ.setdefault('OMP_NUM_THREADS','1')
import json, time, hashlib
from pathlib import Path
import numpy as np
from scipy.optimize import minimize

SEED=202610105
MAXITER=140
MAXFUN=24000
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'continuation5_search_projection_optimizations.json'

def model(v, n, d, ij):
    nf=len(ij)
    G=np.zeros((n,n), dtype=v.dtype)
    for w,(i,j) in zip(np.exp(v[:nf]),ij):
        G[i,j]=G[j,i]=w
    s=G.sum(1); pi=s/s.sum()
    P=G/s[:,None]
    # Euclidean chart avoids large projection coordinates on rare atoms.
    V=np.vstack([np.eye(d,dtype=v.dtype),v[nf:].reshape(n-d,d)])
    U=V/np.sqrt(pi[:,None])
    gram=V.T@V
    inv=np.linalg.inv(gram)
    Q=U@inv@U.T
    return G,pi,P,U,inv,Q

def value(v,n,d,ij,xyz,details=False):
    G,pi,P,U,inv,Q=model(v,n,d,ij)
    K={j:np.linalg.matrix_power(P,2*j)/pi[None,:] for j in set(xyz)}
    fields=[]
    for j in xyz:
        # t,a,b indices: inv Gram * V^T diag(pi K_j(.,t)) V.
        C=np.einsum('ab,ib,i,it,ic->tac',inv,U,pi,K[j],U,optimize=True)
        fields.append(C)
    local=np.einsum('tij,tjk,tki->t',*fields,optimize=True)
    J=pi@local
    if not details: return J/d
    B=P@P
    bhat=np.sqrt(pi[:,None])*B/np.sqrt(pi[None,:])
    ev=np.linalg.eigvalsh((bhat+bhat.T)/2)
    return dict(J=float(J.real),defect=float((J-d).real),ratio=float((J/d).real),
      pi=pi.real.tolist(),G=G.real.tolist(),projection_functions=U.real.tolist(),
      Q=Q.real.tolist(),local_trace=local.real.tolist(),square_eigenvalues=ev.tolist(),
      p=float(1/np.max(P/pi[None,:])),max_A=float(np.max(B/pi[None,:])),
      min_root=float(np.min(P/pi[None,:])),projection_defect=float(np.max(abs(Q@np.diag(pi)@Q-Q))),
      complement_star=xyz)

def make_case(rng,n,xyz,family,index):
    d=2
    if family=='rare_chain':
        masses=np.array([2.**(-10-i%3) for i in range(n-1)]+[1.])
        G=np.diag(masses*rng.uniform(.03,.8,n))
        for i in range(n-1):
            w=min(masses[i],masses[i+1])*rng.uniform(.03,.7)
            G[i,i+1]=G[i+1,i]=w
    elif family=='rare_fan':
        masses=np.array([2.**(-9-2*i) for i in range(n-1)]+[1.])
        G=np.diag(masses*rng.uniform(.01,.4,n))
        for i in range(n-1):
            G[i,-1]=G[-1,i]=masses[i]*rng.uniform(.1,1.)
        for i in range(n-2):
            G[i,i+1]=G[i+1,i]=min(masses[i],masses[i+1])*rng.uniform(.01,.3)
    elif family=='transport':
        G=np.zeros((n,n))
        for i in range(n):
            G[i,i]=2.**(-rng.integers(1,10))
            for j in range(i+1,n):
                if (i<3)!=(j<3):G[i,j]=G[j,i]=2.**(-rng.integers(0,15))
    else:raise ValueError(family)
    ij=[(int(i),int(j)) for i,j in zip(*np.where(np.triu(G)>0))]
    # Initial projected plane has a negative triangle on first three atoms.
    Y=rng.normal(0,.03,(n-d,d));Y[0]=[-1,-1]
    v=np.concatenate([np.log([G[i,j] for i,j in ij]),Y.ravel()])
    bounds=[(-24.,5.)]*len(ij)+[(-8.,8.)]*((n-d)*d)
    return dict(index=index,n=n,d=d,xyz=xyz,family=family,ij=ij,v=v,bounds=bounds)

def run():
    t0=time.time();rng=np.random.default_rng(SEED)
    # Twelve targeted starts, all genuinely unequal x,y,z; no global retry.
    specs=[(6,(1,3,8),'rare_chain'),(6,(1,2,4),'rare_fan'),
      (6,(2,4,8),'transport'),(8,(1,4,12),'rare_chain'),
      (8,(1,2,8),'rare_fan'),(8,(1,3,7),'transport'),
      (6,(1,4,16),'rare_chain'),(6,(2,3,8),'rare_fan'),
      (6,(1,2,3),'transport'),(8,(2,5,13),'rare_chain'),
      (8,(1,3,12),'rare_fan'),(8,(1,2,5),'transport')]
    out=dict(seed=SEED,source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      maxiter=MAXITER,maxfun=MAXFUN,stop_rule='exactly twelve configured starts; threshold triggers certification, not accepted sign',
      status='running',cases=[])
    for index,(n,xyz,family) in enumerate(specs):
        c=make_case(rng,n,xyz,family,index);v=c.pop('v');bounds=c.pop('bounds')
        ij=c['ij'];d=c['d'];history=[];calls=0;best=[float('inf'),None]
        def fun(w):
            nonlocal calls
            val=value(w,n,d,ij,xyz)
            if not np.iscomplexobj(w):
                calls+=1
                if float(val)<best[0]:best[:]=[float(val),w.copy()]
            return val
        initial=value(v,n,d,ij,xyz,True)
        def callback(w):history.append(float(value(w,n,d,ij,xyz)))
        # Complex-step differentiates the actual flow/projection formulas.
        res=minimize(fun,v,method='L-BFGS-B',jac='cs',bounds=bounds,callback=callback,
          options={'maxiter':MAXITER,'maxfun':MAXFUN,'ftol':2e-13,'gtol':2e-8,'maxls':30})
        retained=value(best[1],n,d,ij,xyz,True)
        case={**c,'initial_parameters':v.tolist(),'initial':initial,
          'result':dict(success=bool(res.success),status=int(res.status),message=str(res.message),
             nit=int(res.nit),nfev=int(res.nfev),njev=int(res.njev),real_calls=calls),
          'history':history,'retained_parameters':best[1].tolist(),'retained':retained}
        out['cases'].append(case);out['elapsed_seconds']=time.time()-t0
        OUT.write_text(json.dumps(out,indent=2)+'\n')
        print(index,family,n,xyz,'J/d',initial['ratio'],'->',retained['ratio'],
          'status',res.status,'iterations',res.nit,flush=True)
    out['status']='complete';OUT.write_text(json.dumps(out,indent=2)+'\n')
    print('DONE',time.time()-t0,flush=True)

if __name__=='__main__':run()
