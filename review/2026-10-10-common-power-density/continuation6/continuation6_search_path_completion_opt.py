"""Targeted averaged-star diagnostic around the exact pointwise path geometry.

The positive completion cost is explicitly optimized. Every S is an actual
strictly positive root; Q is an actual original-law rank-two projection.
A floating candidate must still be rounded and independently certified.
"""
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS','1')
os.environ.setdefault('OMP_NUM_THREADS','1')
import hashlib,json,time
from pathlib import Path
import numpy as np
from scipy.optimize import minimize

ROOT=Path(__file__).resolve().parent
OUT=ROOT/'continuation6_search_path_completion_optimizations.json'
SEED=2026101063
CAPS={'starts':12,'maxiter':400,'maxfun':44000,'maxls':30}
IJ=[(i,i+1) for i in range(6)]+[(6,6),(7,7),(8,8)]

def model(v):
    G=np.zeros((9,9),dtype=v.dtype)
    for a,(i,j) in zip(np.exp(v[:9]),IJ):G[i,j]=G[j,i]=a
    s=G.sum(1);pi=s/s.sum();P0=G/s[:,None]
    delta=1/(1+np.exp(-v[9]));P=(1-delta)*P0+delta*np.ones((9,1))*pi[None,:]
    V=np.vstack([v[10:].reshape(7,2),np.eye(2)])
    Gram=V.T@np.diag(pi)@V;inv=np.linalg.inv(Gram)
    R=np.einsum('ab,tb,tc->tac',inv,V,V)
    return G,pi,P0,P,delta,V,Gram,R

def value(v,xyz,objective,details=False):
    G,pi,P0,P,delta,V,Gram,R=model(v)
    F=[np.einsum('ti,iab->tab',np.linalg.matrix_power(P,2*j),R)-np.eye(2) for j in xyz]
    pair=sum(pi@np.einsum('tij,tji->t',F[i],F[j],optimize=True) for i,j in [(0,1),(0,2),(1,2)])
    cubic=pi@np.einsum('tij,tjk,tki->t',*F,optimize=True)
    local=np.einsum('tij,tjk,tki->t',*(A+np.eye(2) for A in F),optimize=True);J=pi@local
    obj=cubic/(pair+1e-14) if objective=='budget' else J/2
    if not details:return obj
    return dict(pair=float(pair.real),cubic=float(cubic.real),objective=float(obj.real),
      budget=float((cubic/(pair+1e-14)).real),J=float(J.real),J_centered=float((2+pair+cubic).real),
      local=local.real.tolist(),pi=pi.real.tolist(),G=G.real.tolist(),delta=float(delta.real),
      V=V.real.tolist(),Gram=Gram.real.tolist(),min_root=float(np.min((P/pi[None,:]).real)))

def initial(q,mass,noise,rng):
    vals=np.array([q**float(i-6) for i in range(6)]+[1.,0.,0.])
    D=2*sum(vals[:6])+vals[6]; vals[7]=vals[8]=D*(1-mass)/(2*mass)
    V=np.zeros((7,2));V[2]=[.05,0];V[4]=[.03,.04];V[6]=[.03,-.04]
    V+=noise*rng.normal(size=V.shape)
    return np.r_[np.log(vals),-16*np.log(2),V.ravel()]

def run():
    t0=time.time();rng=np.random.default_rng(SEED)
    specs=[(q,mass,xyz,obj) for obj in ['budget','direct'] for q,mass,xyz in
      [(4,.2,(1,2,3)),(16,.5,(1,2,3)),(64,.9,(1,2,3)),(4,.9,(1,2,8)),(16,.2,(1,2,8)),(64,.5,(1,2,8))]]
    out=dict(source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),seed=SEED,caps=CAPS,
      status='running',cases=[],stop_rule='exactly twelve completion-cost starts unless strict U candidate triggers rational certification')
    for index,(q,mass,xyz,objective) in enumerate(specs):
        v=initial(q,mass,.002 if index%2 else 0,rng);hist=[];best=[float('inf'),None];real_calls=0;all_calls=0
        def fun(w):
            nonlocal real_calls,all_calls
            all_calls+=1;val=value(w,xyz,objective)
            if not np.iscomplexobj(w):
                real_calls+=1
                if float(val)<best[0]:best[:]=[float(val),w.copy()]
            return val
        def callback(w):hist.append(float(value(w,xyz,objective)))
        bounds=[(-60,5)]*9+[(-30,-.2)]+[(-200,200)]*14
        res=minimize(fun,v,method='L-BFGS-B',jac='cs',bounds=bounds,callback=callback,
          options={'maxiter':CAPS['maxiter'],'maxfun':CAPS['maxfun'],'maxls':CAPS['maxls'],'ftol':2e-13,'gtol':2e-8})
        retained=value(best[1],xyz,objective,True)
        out['cases'].append(dict(index=index,q=q,path_mass=mass,xyz=xyz,objective=objective,
          initial_parameters=v.tolist(),initial=value(v,xyz,objective,True),retained_parameters=best[1].tolist(),retained=retained,
          history=hist,result={'success':bool(res.success),'status':int(res.status),'message':str(res.message),
             'nit':int(res.nit),'nfev':int(res.nfev),'njev':int(res.njev),'real_calls':real_calls,'all_calls':all_calls}))
        out['elapsed_seconds']=time.time()-t0;OUT.write_text(json.dumps(out,indent=2)+'\n')
        print(index,objective,q,mass,xyz,'C/P',retained['budget'],'J/2',retained['J']/2,
          'P',retained['pair'],'minlocal',min(retained['local']),'nit',res.nit,flush=True)
        if retained['J']<2-1e-6 and retained['budget']<-1-1e-6:
            out['status']='strict numerical U candidate; requires rational certificate';break
    else:out['status']='complete'
    out['elapsed_seconds']=time.time()-t0;OUT.write_text(json.dumps(out,indent=2)+'\n');print('DONE',out['status'],time.time()-t0,flush=True)
if __name__=='__main__':run()
