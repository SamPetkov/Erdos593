"""Local exploratory search; no claims are certified by this script."""
import itertools, json, time
import numpy as np
from scipy.optimize import minimize

def bases(q):
    out=[]
    seen=set()
    for p in itertools.permutations(range(q)):
        a=np.eye(q)[list(p)]
        a=(a+a.T)/2
        key=tuple(a.ravel())
        if key not in seen:
            seen.add(key);out.append(a)
    return np.array(out)

def lead(P,H):
    q=len(P)
    A=P@P;A2=A@A;A3=A2@A
    G=H@H
    G=G/np.trace(G)
    W=np.einsum('ab,ac,ad->bcd',A3,A2,A,optimize=True)
    return q*q*np.einsum('bcd,bc,bd,cd->',W,G,G,G,optimize=True)

def run(q,starts):
    rng=np.random.default_rng(593+q)
    pb=bases(q);nb=len(pb); inds=np.triu_indices(q); nh=len(inds[0])
    def unpack(z):
        w=np.exp(z[:nb]-np.max(z[:nb].real));w=w/w.sum()
        P=np.einsum('i,ijk->jk',w,pb)
        H=np.zeros((q,q),dtype=z.dtype);H[inds]=z[nb:];H=H+H.T-np.diag(H.diagonal())
        return P,H
    def f(z):return lead(*unpack(z))
    def jac(z):
        g=np.empty(len(z));e=1.e-20
        for i in range(len(z)):
            zz=z.astype(complex);zz[i]+=1j*e;g[i]=f(zz).imag/e
        return g
    best=1.e100; result=None
    for j in range(starts):
        z=np.r_[rng.normal(0,2,nb),rng.normal(size=nh)]
        fit=minimize(f,z,jac=jac,method='L-BFGS-B',options={'maxiter':300,'ftol':1e-14,'gtol':1e-10})
        if fit.fun<best:
            best=float(fit.fun);P,H=unpack(fit.x)
            result={'q':q,'start':j,'objective':best,'P':P.tolist(),'H':H.tolist(),'fit_success':bool(fit.success),'message':str(fit.message)}
            print(json.dumps(result),flush=True)
            with open(f'continuation2_markov_probe_q{q}.json','w') as out:json.dump(result,out,indent=2)
        if best < -1.e-8:break
    return result

if __name__=='__main__':
    import argparse
    p=argparse.ArgumentParser();p.add_argument('--q',type=int,default=4);p.add_argument('--starts',type=int,default=30)
    a=p.parse_args();run(a.q,a.starts)
