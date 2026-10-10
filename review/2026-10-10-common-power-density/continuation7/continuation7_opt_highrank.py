"""Twelve bounded direct actual-star searches; floating signs are not proofs.

The original law comes from symmetric nonnegative flow G.  The actual
root is S=(1-delta)S0+delta Pi, and every smoothed field uses S^(2s).
Q is the orthogonal complement of a two/three-column rational Gram chart.
No independent PSD kernel or arbitrary-source relaxation is optimized.
"""
import os
os.environ['OPENBLAS_NUM_THREADS']='1'
os.environ['OMP_NUM_THREADS']='1'
import hashlib,json,time,sys
from pathlib import Path
import numpy as np
from scipy.optimize import minimize

SEED=202610107
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'continuation7_opt_highrank_results.json'
DELTA=1/4096
CAPS={'starts':12,'maxiter':200,'maxfun':32000,'maxls':25}

def model(v,n,q,ij,scales):
    nf=len(ij);G=np.zeros((n,n),dtype=v.dtype)
    for a,(i,j) in zip(np.exp(v[:nf]),ij):G[i,j]=G[j,i]=a
    rows=G.sum(1);pi=rows/rows.sum();P0=G/rows[:,None]
    P=(1-DELTA)*P0+DELTA*pi[None,:]
    raw=np.vstack([v[nf:].reshape(n-q,q),np.eye(q)])
    V=scales[:,None]*raw
    H=np.sqrt(pi)[:,None]*V
    Qh=np.eye(n)-H@np.linalg.solve(H.T@H,H.T)
    return G,pi,P,V,Qh

def budget(v,n,q,ij,scales,xyz,details=False):
    G,pi,P,V,Qh=model(v,n,q,ij,scales)
    kernels=[np.linalg.matrix_power(P,2*s)/pi[None,:] for s in xyz]
    fields=[np.einsum('ab,tb,bc->tac',Qh,K,Qh,optimize=True) for K in kernels]
    local=np.einsum('tij,tjk,tki->t',*fields,optimize=True)
    J=pi@local;d=n-q
    if not details:return J/d
    X=[M-Qh for M in fields]
    pair=sum(pi@np.einsum('tij,tji->t',X[i],X[j],optimize=True)
             for i,j in [(0,1),(0,2),(1,2)])
    cubic=pi@np.einsum('tij,tjk,tki->t',*X,optimize=True)
    B=P@P;K1=B/pi[None,:]
    M1=np.einsum('ab,tb,bc->tac',Qh,K1,Qh,optimize=True)
    traces=np.trace(M1,axis1=1,axis2=2)
    Q=Qh/np.sqrt(pi[:,None]*pi[None,:])
    S=P/pi[None,:]
    sym=np.sqrt(pi[:,None])*B/np.sqrt(pi[None,:])
    cap=max(np.linalg.eigvalsh((M+M.T)/2)[-1] for M in M1)
    # The displayed coarse actual host already has W=pS in [0,1].
    # Strict positivity additionally permits a fine binary channel, but F
    # of that binary host is not evaluated and no F claim is made.
    alpha=DELTA/(2*np.max(np.abs(Q)))
    return dict(J=float(J.real),ratio=float((J/d).real),rank=d,
       pair=float(pair.real),cubic=float(cubic.real),
       centered_J=float((d+pair+cubic).real),local=local.real.tolist(),
       pi=pi.real.tolist(),G=G.real.tolist(),P=P.real.tolist(),
       S=S.real.tolist(),V=V.real.tolist(),Q=Q.real.tolist(),
       coarse_p=float((1/np.max(S)).real),permitted_binary_alpha=float(alpha.real),
       square_spectrum=np.linalg.eigvalsh((sym+sym.T)/2).real.tolist(),
       first_source_traces=traces.real.tolist(),
       visible_trace_residual=float(np.max(np.abs(traces-d)).real),
       actual_first_source_cap=float(cap.real),
       min_root=float(np.min(S).real),min_original_mass=float(np.min(pi).real),
       projection_residual=float(np.max(np.abs(Qh@Qh-Qh)).real))

def initial(rng,n,q,family):
    G=np.zeros((n,n))
    if family=='asymmetric_fork':
        # Two nonisomorphic arms meet at a hub; the final q vertices form
        # a slowly communicating reservoir. All conductances are symmetric.
        split=(n-q)//2
        paths=[list(range(split))+[n-q],list(range(split,n-q))+[n-q+1]]
        for pth in paths:
            slope=rng.uniform(.45,1.1)
            for a,(i,j) in enumerate(zip(pth,pth[1:])):
                G[i,j]=G[j,i]=np.exp(-slope*(len(pth)-a)+rng.uniform(-.4,.4))
        for i in range(n-q,n):
            for j in range(i+1,n):G[i,j]=G[j,i]=np.exp(rng.uniform(-4,-2))
        for i in range(n):
            G[i,i]=max(G[i].sum(),1e-8)*np.exp(rng.uniform(-4,2))
    elif family=='alternating_traps':
        # Inhomogeneous path with slow traps at alternating vertices and
        # a bypass joining two interior atoms: not a monotone path kernel.
        slope=rng.uniform(.4,.9)
        for i in range(n-1):
            G[i,i+1]=G[i+1,i]=np.exp(slope*(i-n+2)+rng.uniform(-.5,.5))
        for i in range(n):
            G[i,i]=max(G[i].sum(),1e-9)*np.exp((2 if i%2 else -2)+rng.uniform(-.5,.5))
        G[n//3,2*n//3]=G[2*n//3,n//3]=np.exp(-slope*n/2-2)
    else:raise ValueError(family)
    G/=G.max()
    ij=[(int(i),int(j)) for i,j in zip(*np.where(np.triu(G)>0))]
    pi=G.sum(1)/G.sum()
    scales=2.**np.rint(-.5*np.log2(pi))
    raw=rng.normal(0,.6,size=(n-q,q))
    # Opposite multiaxis directions seed signed complement triangles.
    for i in range(min(3,n-q)):raw[i,i%q]+=(-1)**i
    params=np.r_[np.log([G[i,j] for i,j in ij]),raw.ravel()]
    return ij,scales,params

def run():
    start=time.time();rng=np.random.default_rng(SEED)
    triples=[(1,2,3),(1,2,8),(1,3,16),(2,3,7),(1,4,12),(2,5,13)]
    specs=[(n,q,family,triples[j%6]) for j,(n,q,family) in enumerate(
       ( (n,q,family) for n in (14,16,18) for q in (2,3)
         for family in ('asymmetric_fork','alternating_traps') ))]
    out={'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         'seed':SEED,'delta':DELTA,'caps':CAPS,'status':'running',
         'objective':'direct J/rank',
         'stop_rule':'twelve configured starts, or stop on strict J/rank<1-1e-6 candidate for exact reconstruction',
         'cases':[]}
    for index,(n,q,family,xyz) in enumerate(specs):
        ij,scales,v=initial(rng,n,q,family);nf=len(ij)
        best=[float('inf'),None];calls={'real':0,'all':0};history=[]
        def fun(w):
            calls['all']+=1;val=budget(w,n,q,ij,scales,xyz)
            if not np.iscomplexobj(w):
                calls['real']+=1
                if float(val)<best[0]:best[:]=[float(val),w.copy()]
            return val
        def callback(w):history.append(float(budget(w,n,q,ij,scales,xyz)))
        res=minimize(fun,v,method='L-BFGS-B',jac='cs',
            bounds=[(-18,5)]*nf+[(-8,8)]*(len(v)-nf),callback=callback,
            options={'maxiter':CAPS['maxiter'],'maxfun':CAPS['maxfun'],'maxls':CAPS['maxls'],
                     'ftol':2e-13,'gtol':3e-8})
        retained=budget(best[1],n,q,ij,scales,xyz,True)
        out['cases'].append({'index':index,'n':n,'codimension':q,'rank':n-q,
           'family':family,'xyz':xyz,'ij':ij,'row_scales':scales.tolist(),
           'initial_parameters':v.tolist(),'initial':budget(v,n,q,ij,scales,xyz,True),
           'retained_parameters':best[1].tolist(),'retained':retained,'history':history,
           'result':{'success':bool(res.success),'status':int(res.status),'message':str(res.message),
                     'nit':int(res.nit),'nfev':int(res.nfev),'njev':int(res.njev),
                     'real_calls':calls['real'],'all_calls':calls['all']}})
        out['elapsed_seconds']=time.time()-start
        OUT.write_text(json.dumps(out,indent=2)+'\n')
        print(index,n,n-q,family,xyz,'J/rank',retained['ratio'],
              'cap',retained['actual_first_source_cap'],
              'trace_variation',retained['visible_trace_residual'],'nit',res.nit,flush=True)
        if retained['ratio']<1-1e-6:
            out['status']='strict numerical candidate requiring exact certificate';break
    else:out['status']='complete'
    out['elapsed_seconds']=time.time()-start
    OUT.write_text(json.dumps(out,indent=2)+'\n')
    print('DONE',out['status'],time.time()-start,flush=True)

if __name__=='__main__':run()
