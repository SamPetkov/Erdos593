"""Actual-root cover densities with controlled variable elimination.

Tuples are (k,u,r,l,h); edge A-exponents are (k,r+h,u,r,u,l).
All numerical results are exploratory unless the integer certificate routine
has completed. No arbitrary PSD kernel is admitted as a host.
"""
from functools import lru_cache
from itertools import permutations,product
from math import lcm
from numbers import Integral
import numpy as np

BASE_EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))

def _is_integer(x):
    return isinstance(x,Integral) and not isinstance(x,(bool,np.bool_))

def validate_tuple(tpl):
    """Require the exact target tuple; never truncate supplied numeric values."""
    try:tpl=tuple(tpl)
    except TypeError as exc:raise ValueError('requires a five-integer tuple (k,u,r,l,h)') from exc
    if len(tpl)!=5 or not all(_is_integer(x)for x in tpl):
        raise ValueError('requires exactly five integer entries (k,u,r,l,h)')
    k,u,r,l,h=map(int,tpl)
    if not (k>=u>=1 and r>=l>=1 and h>=1):
        raise ValueError('requires k>=u>=1, r>=l>=1, h>=1')
    return k,u,r,l,h

def validate_cover(key):
    """Require three permutations of one nonempty sheet set {0,...,M-1}."""
    try:key=tuple(tuple(p)for p in key)
    except TypeError as exc:raise ValueError('requires three sheet permutations') from exc
    if len(key)!=3 or not key[0]:raise ValueError('requires three nonempty sheet permutations')
    M=len(key[0]);expected=set(range(M))
    if any(len(p)!=M or not all(_is_integer(x)for x in p) or set(p)!=expected for p in key):
        raise ValueError('each matching must be an integer permutation of the same sheet set')
    return tuple(tuple(int(x)for x in p)for p in key)

def root_data(H,tpl):
    k,u,r,l,h=validate_tuple(tpl)
    H=np.asarray(H,dtype=float)
    if H.ndim!=2 or H.shape[0]!=H.shape[1] or H.shape[0]==0:raise ValueError('requires nonempty square H')
    if not np.isfinite(H).all() or np.min(H)<0 or not np.array_equal(H,H.T):raise ValueError('inadmissible H')
    n=len(H);s=H.sum(1);Z=s.sum()
    if not np.isfinite(Z) or np.any(s<=0):raise ValueError('requires finite positive row sums')
    mu=s/Z
    v=np.sqrt(mu);B=H/np.sqrt(s[:,None]*s[None,:]);w=np.eye(n)[0]-v
    V=(np.eye(n)-2*np.outer(w,w)/(w@w))[:,1:] if w@w>1e-28 else np.eye(n)[:,1:]
    C=V.T@B@V;cl,Q=np.linalg.eigh((C+C.T)/2)
    lam=np.r_[1.,cl];U=np.column_stack((v,V@Q));theta=cl**2
    ep=(k,r+h,u,r,u,l);qs=tuple(2*e for e in ep)
    Ks=[1+(V@Q*theta**e)@(V@Q).T/np.outer(v,v)for e in ep]
    return {'H':H,'n':n,'s':s,'Z':Z,'mu':mu,'B':B,'lam':lam,'U':U,'Ks':Ks,'qs':qs,'theta':theta}

def boundary_project(H):
    H=np.asarray(H,dtype=float);s=H.sum(1);Z=s.sum();mu=s/Z;J=H/Z
    T=J/np.outer(mu,mu);which=np.unravel_index(np.argmin(T),T.shape);m=float(T[which])
    if m>=1-1e-13:return J,{'mu':mu,'J':J,'m':m,'which':which,'trivial':True}
    Jb=(J-m*np.outer(mu,mu))/(1-m)
    Jb=(Jb+Jb.T)/2
    Jb[np.abs(Jb)<5e-16]=0
    return Jb,{'mu':mu,'J':J,'m':m,'which':which,'trivial':False}

def boundary_pullback(H,cache,GB):
    """Pull d objective/d boundary-H back through its selected minimum entry."""
    H=np.asarray(H,dtype=float);Z=H.sum();J=cache['J'];mu=cache['mu'];m=cache['m']
    if cache['trivial']:return np.zeros_like(H)
    Jb=(J-m*np.outer(mu,mu))/(1-m);G=(GB+GB.T)/2
    gmu=-m/(1-m)*(G+G.T)@mu
    gm=float(np.sum(G*(Jb-np.outer(mu,mu)))/(1-m))
    a,b=cache['which'];gmu[a]-=gm*m/mu[a];gmu[b]-=gm*m/mu[b]
    GJ=G/(1-m)+gmu[:,None]
    GJ[a,b]+=gm/(mu[a]*mu[b])
    return (GJ-np.sum(GJ*J))/Z

def lifted_edges(key):
    ps=validate_cover(key);sheets=len(ps[0]);edges=[]
    for s in range(sheets):
        for e,(a,b)in enumerate(BASE_EDGES[:3]):edges.append((4*s+a,4*s+b,e))
    for e,(a,b)in enumerate(BASE_EDGES[3:]):
        for s in range(sheets):edges.append((4*s+a,4*ps[e][s]+b,e+3))
    return tuple(edges)

@lru_cache(maxsize=None)
def elimination_order(key):
    nv=4*len(key[0]);edges=lifted_edges(key);best=None
    for mode in range(2):
        for shift in range(4):
            graph={v:set()for v in range(nv)}
            for a,b,_ in edges:graph[a].add(b);graph[b].add(a)
            order=[];width=0;cost=0
            while graph:
                def score(v):
                    ns=graph[v];fill=sum(b not in graph[a]for a in ns for b in ns if a<b)
                    return (fill,len(ns),(v+shift)%nv)if mode==0 else(len(ns),fill,(v+shift)%nv)
                v=min(graph,key=score);ns=graph[v].copy();width=max(width,len(ns));cost+=4**len(ns)
                for a in ns:
                    graph[a].discard(v);graph[a].update(ns-{a})
                del graph[v];order.append(v)
            cand=(width,cost,tuple(order))
            if best is None or cand<best:best=cand
    return best[2],best[0]

def _contract(vals,scopes,outscope,n,objects=False):
    if not objects:
        args=[]
        for val,scope in zip(vals,scopes):args.extend([val,list(scope)])
        represented=set().union(*(set(s)for s in scopes))
        for var in outscope:
            if var not in represented:args.extend([np.ones(n),[var]])
        args.append(list(outscope))
        return np.einsum(*args,optimize=False)
    union=tuple(sorted(set().union(*(set(s)for s in scopes),set(outscope))))
    value=np.asarray(1,dtype=object)
    for val,scope in zip(vals,scopes):
        loc=tuple(sorted(scope));perm=tuple(scope.index(v)for v in loc)
        arr=np.asarray(val,dtype=object)
        if len(perm)>1:arr=arr.transpose(perm)
        shape=tuple(n if v in scope else 1 for v in union)
        value=value*arr.reshape(shape)
    for var in outscope:
        if not any(var in s for s in scopes):
            shape=tuple(n if v==var else 1 for v in union);value=value*np.ones(shape,dtype=object)
    removed=tuple(i for i,v in enumerate(union)if v not in outscope)
    if removed:value=value.sum(axis=removed)
    remaining=tuple(v for v in union if v in outscope)
    perm=tuple(remaining.index(v)for v in outscope)
    if len(perm)>1:value=value.transpose(perm)
    return value

def contract_cover(mu,Ks,key,gradient=False,objects=False):
    key=validate_cover(key);n=len(mu);nv=4*len(key[0]);edges=lifted_edges(key)
    vals=[np.asarray(mu)for _ in range(nv)]+[np.asarray(Ks[e])for _,_,e in edges]
    scopes=[(v,)for v in range(nv)]+[(a,b)for a,b,_ in edges]
    active=set(range(len(vals)));ops=[];order,width=elimination_order(key)
    for v in order:
        ids=tuple(sorted(i for i in active if v in scopes[i]));out=tuple(sorted(set().union(*(set(scopes[i])for i in ids))-{v}))
        value=_contract([vals[i]for i in ids],[scopes[i]for i in ids],out,n,objects)
        oi=len(vals);vals.append(value);scopes.append(out);active.difference_update(ids);active.add(oi);ops.append((oi,ids))
    ids=tuple(sorted(active));oi=len(vals);vals.append(_contract([vals[i]for i in ids],[scopes[i]for i in ids],(),n,objects));scopes.append(());ops.append((oi,ids))
    Z=vals[-1].item() if hasattr(vals[-1],'item') else vals[-1]
    if not gradient:return Z,width
    adj={len(vals)-1:np.asarray(1.)}
    for oi,ids in reversed(ops):
        go=adj.pop(oi)
        for ii in ids:
            other=[i for i in ids if i!=ii]
            gi=_contract([go]+[vals[i]for i in other],[scopes[oi]]+[scopes[i]for i in other],scopes[ii],n)
            adj[ii]=adj.get(ii,0)+gi
    Gmu=sum((adj[i]for i in range(nv)),np.zeros(n))
    GKs=[np.zeros((n,n))for _ in range(6)]
    for j,(_,_,e)in enumerate(edges):GKs[e]+=adj[nv+j]
    return Z,Gmu,GKs,width

def root_pullback(data,Gmu,GKs):
    mu=data['mu'];s=data['s'];Z=data['Z'];B=data['B'];lam=data['lam'];U=data['U'];Ks=data['Ks'];qs=data['qs']
    Gmu=Gmu.copy();GB=np.zeros_like(B);scale=np.sqrt(mu[:,None]*mu[None,:]);a=lam[:,None];b=lam[None,:]
    for GK,K,q in zip(GKs,Ks,qs):
        GK=(GK+GK.T)/2;Gmu-=np.sum(GK*K,axis=1)/mu
        GC=GK/scale;L=np.zeros_like(B)
        for t in range(q):L+=a**t*b**(q-1-t)
        GB+=U@((U.T@GC@U)*L)@U.T
    GB=(GB+GB.T)/2;gs=(Gmu-Gmu@mu)/Z-np.sum(GB*B,axis=1)/s
    return GB/np.sqrt(s[:,None]*s[None,:])+gs[:,None]

def value_gradient(H,tpl,key,gradient=False):
    data=root_data(H,tpl)
    if not gradient:
        Z,w=contract_cover(data['mu'],data['Ks'],key);return float(Z),data,w
    Z,Gmu,GKs,w=contract_cover(data['mu'],data['Ks'],key,True)
    return float(Z),root_pullback(data,Gmu,GKs),data,w

def connected(key):
    reached={0}
    while True:
        expanded=reached|{p[v]for p in key for v in reached}
        if expanded==reached:return len(reached)==len(key[0])
        reached=expanded

def cover_registry(M):
    ps=list(permutations(range(M)));seen=set();records=[]
    for key in product(ps,repeat=3):
        if key in seen:continue
        orbit=[]
        for sig in ps:
            inv=[sig.index(i)for i in range(M)]
            orbit.append(tuple(tuple(sig[p[inv[i]]]for i in range(M))for p in key))
        seen.update(orbit);rep=min(orbit)
        if not connected(rep):continue
        p,q,r=rep;qi=[q.index(i)for i in range(M)];pi=[p.index(i)for i in range(M)];ri=[r.index(i)for i in range(M)]
        walks=[p,q,r,tuple(qi[r[p[i]]]for i in range(M)),tuple(r[p[i]]for i in range(M)),tuple(ri[q[i]]for i in range(M)),tuple(q[pi[i]]for i in range(M))]
        records.append({'perms':rep,'fixed_cycle_counts':tuple(sum(w[i]==i for i in range(M))for w in walks),'width':elimination_order(rep)[1]})
    return records

def exact_integer_certificate(H,tpl,key):
    k,u,r,l,h=validate_tuple(tpl);key=validate_cover(key)
    H=np.asarray(H,dtype=object)
    if H.ndim!=2 or H.shape[0]!=H.shape[1] or H.shape[0]==0:raise ValueError('requires nonempty square H')
    n=len(H)
    if any(not _is_integer(x) or x<0 for x in H.flat):raise ValueError('requires nonnegative integer H')
    if any(H[i,j]!=H[j,i]for i in range(n)for j in range(n)):raise ValueError('requires symmetric H')
    s=H.sum(axis=1)
    if any(x<=0 for x in s):raise ValueError('requires positive row sums')
    Z=int(s.sum());L=lcm(*(int(x)for x in s));R=np.array([[int(H[i,j])*L//int(s[i])for j in range(n)]for i in range(n)],dtype=object)
    ep=(k,r+h,u,r,u,l);Ks=[]
    for e in ep:
        power=np.linalg.matrix_power(R,2*e)
        Ks.append(np.array([[Z*(L//int(s[j]))*power[i,j]for j in range(n)]for i in range(n)],dtype=object))
    basekey=((0,),(0,),(0,));Fnum,_=contract_cover(s,Ks,basekey,objects=True);Znum,width=contract_cover(s,Ks,key,objects=True)
    M=len(key[0]);den=Z**4*L**sum(2*e+1 for e in ep);difference=int(Znum)-int(Fnum)**M
    return {'base_numerator':int(Fnum),'base_denominator':den,'cover_numerator':int(Znum),'cover_denominator':den**M,
            'comparison_integer':difference,'cover_violation':difference>0,
            'target_defect_integer':int(Fnum)-den,'target_violation':int(Fnum)<den,'L':L,'Z':Z,'width':width}
