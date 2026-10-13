"""Bounded exploration of special exterior-square cycle coefficients.
All hosts arise from actual nonnegative symmetric flow matrices. Floating
results are diagnostics only; exact certificates are separate.
"""
import json,time,hashlib
from itertools import combinations
import numpy as np
from scipy.optimize import minimize
from continuation_cover_engine import root_data

EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
CYCLES=((0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,2,3,5),(0,1,4,5),(1,2,3,4))

def channels(G,tpl):
    data=root_data(G,tpl); mu=data['mu']; n=len(mu)
    ps=list(combinations(range(n),2))+[(i,i) for i in range(n)]
    x=np.array([p[0] for p in ps]);y=np.array([p[1] for p in ps]);
    pi=mu[x]*mu[y]*np.where(x==y,1,2)
    S=[];H=[]
    for K in data['Ks']:
        P=K[x[:,None],x[None,:]]*K[y[:,None],y[None,:]]
        Q=K[x[:,None],y[None,:]]*K[y[:,None],x[None,:]]
        S.append((P+Q)/2);H.append((P-Q)/2)
    return pi,S,H,data

def coef(G,tpl,cycle):
    pi,S,H,data=channels(G,tpl);m=len(pi)
    z=pi[:,None,None,None]*pi[None,:,None,None]*pi[None,None,:,None]*pi[None,None,None,:]
    for e,(a,b) in enumerate(EDGES):
        shape=[1]*4;shape[a]=shape[b]=m
        z*= (H[e] if e in CYCLES[cycle] else S[e]).reshape(shape)
    signed=float(z.sum());absval=float(np.abs(z).sum())
    return signed,absval,data

def main():
    rng=np.random.default_rng(2026101401);tpls=[(1,1,1,1,1),(3,1,2,1,1),(8,2,3,1,1),(6,1,1,1,1),(5,2,4,1,3),(2,2,3,2,1)]
    samples=[];best=[];starts=[];clock=time.time()
    for n in [3,4,5]:
        rows=[]
        for j in range(84):
            G=rng.integers(0,33,size=(n,n));G=np.triu(G)+np.triu(G,1).T
            kind=j%4
            if kind==0:G*=rng.integers(1,17,size=n)[:,None]*rng.integers(1,17,size=n)[None,:];G=np.triu(G)+np.triu(G,1).T
            if kind==1:G=G*np.eye(n,dtype=int)+G//16
            if kind==2:G=G*(np.eye(n,dtype=int)+np.eye(n,k=1,dtype=int)+np.eye(n,k=-1,dtype=int))
            if not np.all(G.sum(1)>0):G+=np.eye(n,dtype=int)
            tpl=tpls[j%len(tpls)];c=j%7;s,a,data=coef(G,tpl,c)
            row={'n':n,'index':j,'kind':kind,'flow':G.tolist(),'tuple':tpl,'cycle':c,'coefficient':s,'absolute_sum':a,'ratio':s/a if a else 1,'p':1/np.max(data['H']*data['Z']/data['s'][:,None]/data['s'][None,:])}
            rows.append(row);samples.append(row)
        rows.sort(key=lambda x:x['ratio']);best.append(rows[0]);starts+=rows[:4]
        print('SAMPLES',n,'best',rows[0]['ratio'],rows[0]['cycle'],rows[0]['tuple'],flush=True)
    with open('continuation4_cover_samples.json','w')as f:json.dump({'seed':2026101401,'samples':samples,'best':best,'elapsed':time.time()-clock},f,indent=2)
    outs=[]
    for run,row in enumerate(starts):
        n=row['n'];G=np.array(row['flow'],float);inds=np.triu_indices(n);tpl=row['tuple'];c=row['cycle'];xx=np.log(np.maximum(G[inds],1e-4))
        def unpack(x):
            g=np.zeros((n,n));g[inds]=np.exp(x);return g+np.triu(g,1).T
        calls=0
        def obj(x):
            nonlocal calls
            calls+=1;s,a,_=coef(unpack(x),tpl,c);return s/a if a else 1
        res=minimize(obj,xx,method='L-BFGS-B',bounds=[(-9,9)]*len(xx),options={'maxiter':60,'ftol':1e-12,'gtol':1e-7,'maxls':15})
        g=unpack(res.x);s,a,data=coef(g,tpl,c)
        rr={'run':run,'n':n,'tuple':tpl,'cycle':c,'flow':g.tolist(),'starting_ratio':row['ratio'],'ratio':s/a if a else 1,'coefficient':s,'absolute_sum':a,'iterations':int(res.nit),'calls':calls,'success':bool(res.success),'message':str(res.message)}
        outs.append(rr);print('OPT',run,n,c,rr['ratio'],res.nit,calls,flush=True)
        with open('continuation4_cover_optimizations.json','w')as f:json.dump({'maxiter':60,'runs':outs,'elapsed':time.time()-clock},f,indent=2)
        if rr['ratio'] < -1e-5:break
if __name__=='__main__':main()
