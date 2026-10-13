"""Bounded unequal-star search over exactly refinable PSD matrix fields.

For original pi from actual flow, put V_last=I and D_i=V_i V_i^T,
G=sum_i D_i. The field C_i=G^-1 D_i/pi_i in the common Gram metric
has original mean I. Rank-one refinement converts it to actual Q.
Only a rational reconstructed and separately checked candidate is proof.
"""
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS','1')
os.environ.setdefault('OMP_NUM_THREADS','1')
import hashlib,json,time
from pathlib import Path
import numpy as np
from scipy.optimize import minimize
import continuation6_search_rank_extremes_opt as roots

ROOT=Path(__file__).resolve().parent
OUT=ROOT/'continuation6_search_psd_field_optimizations.json'
SEED=2026101062
CAPS={'starts':24,'maxiter':200,'maxfun':44000,'maxls':30}

def model(v,n,d,ij):
    nf=len(ij);Gflow=np.zeros((n,n),dtype=v.dtype)
    for a,(i,j) in zip(np.exp(v[:nf]),ij):Gflow[i,j]=Gflow[j,i]=a
    s=Gflow.sum(1);pi=s/s.sum();P=Gflow/s[:,None]
    V=np.concatenate([v[nf:].reshape(n-1,d,d),np.eye(d)[None]])
    D=V@V.transpose(0,2,1);Gram=D.sum(0);inv=np.linalg.inv(Gram)
    C=np.einsum('ab,tbc->tac',inv,D)/pi[:,None,None]
    return Gflow,pi,P,V,Gram,inv,C

def value(v,n,d,ij,xyz,objective,details=False):
    Gflow,pi,P,V,Gram,inv,C=model(v,n,d,ij)
    F=[np.einsum('ti,iab->tab',np.linalg.matrix_power(P,2*j),C)-np.eye(d) for j in xyz]
    pair=sum(pi@np.einsum('tij,tji->t',F[i],F[j],optimize=True) for i,j in [(0,1),(0,2),(1,2)])
    cubic=pi@np.einsum('tij,tjk,tki->t',*F,optimize=True)
    local=np.einsum('tij,tjk,tki->t',*(A+np.eye(d) for A in F),optimize=True)
    J=pi@local
    obj=cubic/(pair+1e-14) if objective=='budget' else J/d
    if not details:return obj
    B=P@P;sym=np.sqrt(pi[:,None])*B/np.sqrt(pi[None,:])
    return dict(pair=float(pair.real),cubic=float(cubic.real),objective=float(obj.real),
      budget=float((cubic/(pair+1e-14)).real),J=float(J.real),J_centered=float((d+pair+cubic).real),
      local=local.real.tolist(),pi=pi.real.tolist(),Gflow=Gflow.real.tolist(),
      V=V.real.tolist(),Gram=Gram.real.tolist(),C_gram_coordinates=C.real.tolist(),
      min_root=float(np.min((P/pi[None,:]).real)),max_A=float(np.max((B/pi[None,:]).real)),
      square_spectrum=np.linalg.eigvalsh((sym+sym.T)/2).real.tolist())

def run():
    t0=time.time();rng=np.random.default_rng(SEED)
    triples=[(1,2,3),(1,2,8),(1,3,16),(2,3,7),(1,4,9),(1,2,32)]
    specs=[(4+(i%3),2+(i//3),triples[i],['geometric_path','rare_bipartite','double_reservoir'][i%3],objective)
      for objective in ['budget','direct'] for rep in range(2) for i in range(6)]
    out=dict(source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      root_source_sha256=hashlib.sha256((ROOT/'continuation6_search_rank_extremes_opt.py').read_bytes()).hexdigest(),
      seed=SEED,caps=CAPS,status='running',cases=[],stop_rule='exactly twenty-four configured starts unless strict U candidate triggers rational certification')
    for index,(n,d,xyz,family,objective) in enumerate(specs):
        ij,r=roots.initial(rng,n,family)
        # Negative-triangle frame directions with full-rank perturbations.
        V=rng.normal(0,.5,(n-1,d,d));V[0,:,0]=np.r_[1.,np.zeros(d-1)]
        V[1,:,0]=np.r_[.6,.8,np.zeros(d-2)]
        V[2,:,0]=np.r_[.6,-.8,np.zeros(d-2)]
        v=np.r_[r[:len(ij)],V.ravel()]
        bounds=[(-36,5)]*len(ij)+[(-20,20)]*((n-1)*d*d)
        best=[float('inf'),None];real_calls=0;all_calls=0;hist=[]
        def fun(w):
            nonlocal real_calls,all_calls
            all_calls+=1;val=value(w,n,d,ij,xyz,objective)
            if not np.iscomplexobj(w):
                real_calls+=1
                if float(val)<best[0]:best[:]=[float(val),w.copy()]
            return val
        def callback(w):hist.append(float(value(w,n,d,ij,xyz,objective)))
        res=minimize(fun,v,method='L-BFGS-B',jac='cs',bounds=bounds,callback=callback,
          options={'maxiter':CAPS['maxiter'],'maxfun':CAPS['maxfun'],'maxls':CAPS['maxls'],'ftol':2e-13,'gtol':2e-8})
        retained=value(best[1],n,d,ij,xyz,objective,True)
        out['cases'].append(dict(index=index,n=n,d=d,xyz=xyz,family=family,objective=objective,ij=ij,
          initial_parameters=v.tolist(),initial=value(v,n,d,ij,xyz,objective,True),retained_parameters=best[1].tolist(),
          retained=retained,history=hist,result={'success':bool(res.success),'status':int(res.status),'message':str(res.message),
             'nit':int(res.nit),'nfev':int(res.nfev),'njev':int(res.njev),'real_calls':real_calls,'all_calls':all_calls}))
        out['elapsed_seconds']=time.time()-t0;OUT.write_text(json.dumps(out,indent=2)+'\n')
        print(index,objective,family,n,d,xyz,'C/P',retained['budget'],'J/d',retained['J']/d,
          'P',retained['pair'],'nit',res.nit,flush=True)
        if retained['J']<d-1e-6 and retained['budget']<-1-1e-6:
            out['status']='strict numerical U candidate; requires rational certificate';break
    else:out['status']='complete'
    out['elapsed_seconds']=time.time()-t0;OUT.write_text(json.dumps(out,indent=2)+'\n');print('DONE',out['status'],time.time()-t0,flush=True)
if __name__=='__main__':run()
