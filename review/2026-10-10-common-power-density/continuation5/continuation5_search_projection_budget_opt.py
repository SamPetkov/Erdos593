"""Second, fixed bounded stage: avoid the trivial rapidly mixing endpoint.

Objective is the actual centered cubic divided by the actual nonnegative
pair surplus.  This is a diagnostic sufficient-budget search, not F itself.
"""
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS','1')
os.environ.setdefault('OMP_NUM_THREADS','1')
import hashlib,json,time
from pathlib import Path
import numpy as np
from scipy.optimize import minimize
import continuation5_search_projection_opt as base

ROOT=Path(__file__).resolve().parent
OUT=ROOT/'continuation5_search_projection_budget_optimizations.json'

def budget(v,n,d,ij,xyz,details=False):
    G,pi,P,U,inv,Q=base.model(v,n,d,ij)
    F=[np.einsum('ab,ib,i,it,ic->tac',inv,U,pi,
       np.linalg.matrix_power(P,2*j)/pi[None,:],U,optimize=True)-np.eye(d) for j in xyz]
    pair=sum(pi@np.einsum('tij,tji->t',F[i],F[j]) for i,j in [(0,1),(0,2),(1,2)])
    cubic=pi@np.einsum('tij,tjk,tki->t',*F)
    obj=cubic/(pair+1e-14)
    if not details:return obj
    local=np.einsum('tij,tjk,tki->t',*(x+np.eye(d) for x in F))
    return dict(pair=float(pair.real),cubic=float(cubic.real),ratio=float(obj.real),
        J_centered=float((d+pair+cubic).real),local_trace=local.real.tolist())

def run():
    t0=time.time();original=json.loads((ROOT/'continuation5_search_projection_optimizations.json').read_text())
    out=dict(source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      model_source_sha256=hashlib.sha256((ROOT/'continuation5_search_projection_opt.py').read_bytes()).hexdigest(),
      parent_records_sha256=hashlib.sha256((ROOT/'continuation5_search_projection_optimizations.json').read_bytes()).hexdigest(),
      caps={'starts':12,'maxiter':180,'maxfun':32000,'maxls':30},
      motivation='Stage-one J minimizers reach the constant-field value without testing cancellation efficiently.',
      status='running',cases=[])
    for c in original['cases']:
        n,d,ij,xyz=c['n'],c['d'],c['ij'],c['xyz'];v=np.array(c['initial_parameters']);history=[];best=[1e300,None];calls=0
        def fun(w):
            nonlocal calls
            val=budget(w,n,d,ij,xyz)
            if not np.iscomplexobj(w):
                calls+=1
                if val<best[0]:best[:]=[float(val),w.copy()]
            return val
        def callback(w):history.append(float(budget(w,n,d,ij,xyz)))
        bounds=[(-24.,5.)]*len(ij)+[(-8.,8.)]*((n-d)*d)
        res=minimize(fun,v,method='L-BFGS-B',jac='cs',bounds=bounds,callback=callback,
          options={'maxiter':180,'maxfun':32000,'ftol':2e-13,'gtol':2e-8,'maxls':30})
        det=budget(best[1],n,d,ij,xyz,True)
        out['cases'].append(dict(index=c['index'],family=c['family'],n=n,d=d,ij=ij,xyz=xyz,
          initial=budget(v,n,d,ij,xyz,True),initial_parameters=v.tolist(),
          result=dict(success=bool(res.success),status=int(res.status),message=str(res.message),
            nit=int(res.nit),nfev=int(res.nfev),njev=int(res.njev),real_calls=calls),
          history=history,retained_parameters=best[1].tolist(),retained_budget=det,
          retained=base.value(best[1],n,d,ij,xyz,True)))
        out['elapsed_seconds']=time.time()-t0;OUT.write_text(json.dumps(out,indent=2)+'\n')
        print(c['index'],c['family'],xyz,'C/pair',det['ratio'],'J',det['J_centered'],
          'minlocal',min(det['local_trace']),'status',res.status,'nit',res.nit,flush=True)
    out['status']='complete';OUT.write_text(json.dumps(out,indent=2)+'\n');print('DONE',time.time()-t0,flush=True)

if __name__=='__main__':run()
