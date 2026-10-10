"""Small numerical helpers copied verbatim from the audited first-batch functions.

This module keeps the continuation experiment independent of older scripts.
"""
import numpy as np
EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
CYCLES=[(0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,3,5,2),(0,4,5,1),(1,3,4,2)]

def random_H(rng,n,kind):
    if kind=='logwide':
        H=np.exp(rng.uniform(-8,4,(n,n))); H=(H+H.T)/2
    elif kind=='sparse':
        H=rng.exponential(size=(n,n))*(rng.random((n,n))<rng.uniform(.1,.65))
        H=(H+H.T)/2+1e-12
        if rng.random()<.5: np.fill_diagonal(H,0)
        H+=np.eye(n)*1e-10
    elif kind=='near_identity':
        H=rng.random((n,n)); H=(H+H.T)/2
        H*=10**rng.uniform(-3,0)
        H+=np.diag(np.exp(rng.uniform(-3,3,n)))
    elif kind=='near_bipartite':
        split=rng.integers(1,n)
        H=rng.random((n,n))*10**rng.uniform(-5,-1)
        H[:split,split:]+=rng.exponential(size=(split,n-split))
        H=(H+H.T)/2
    elif kind=='rank_deficient':
        R=rng.exponential(size=(n,max(2,n//2)))
        H=R@R.T
    else:
        H=rng.exponential(size=(n,n)); H=(H+H.T)/2
    return H/H.sum()

def pieces(H,tpl):
    n=len(H);s=H.sum(1);mu=s/s.sum();v=np.sqrt(mu)
    B=H/np.sqrt(s[:,None]*s[None,:]);w=np.eye(n)[0]-v
    V=(np.eye(n)-2*np.outer(w,w)/(w@w))[:,1:]
    ce=V.T@B@V;lam,O=np.linalg.eigh((ce+ce.T)/2);U=V@O;theta=lam**2
    k,u,r,l,h=tpl;pows=(k,r+h,u,r,u,l)
    matrices=[(U*theta**q)@U.T/np.outer(v,v) for q in pows]
    W=mu[:,None,None,None]*mu[None,:,None,None]*mu[None,None,:,None]*mu[None,None,None,:]
    shaped=[]
    for M,(i,j) in zip(matrices,EDGES):
        sh=[1]*4;sh[i]=sh[j]=n;shaped.append(M.reshape(sh))
    K=W.copy()
    for S in shaped:K*=S
    full=K.sum()
    cycles=float(sum(np.sum(theta**sum(pows[e] for e in cyc)) for cyc in CYCLES))
    diamonds=[]
    for missing in range(6):
        D=W.copy()
        for e,S in enumerate(shaped):
            if e!=missing:D*=S
        diamonds.append(float(D.sum()))
    diamond=sum(diamonds)
    return {'F':float(1+cycles+diamond+full),'cycles':cycles,'diamonds':diamond,'full':float(full),
            'ratio':float(full/(cycles+diamond)) if cycles+diamond>1e-100 else 0,
            'theta':theta.tolist(),'mu':mu.tolist()}
