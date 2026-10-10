"""One finite continuation batch and selected local optimization, actual roots only."""
import argparse,json,time,sys
import numpy as np
from scipy.optimize import minimize
from continuation_host_helpers import random_H,pieces
from continuation_cover_engine import (value_gradient,boundary_project,boundary_pullback,
    cover_registry,exact_integer_certificate,contract_cover,root_pullback)

TPLS=[(1,1,1,1,1),(2,2,1,1,1),(2,1,2,1,1),(3,2,3,2,1),
      (1,1,3,3,1),(4,4,1,1,8),(8,4,1,1,8),(2,1,3,1,2),
      (3,2,5,3,7),(1,1,1,1,16),(4,1,2,1,6),(2,2,3,2,2)]
KINDS=['positive_integer','sparse_integer','gram_integer','nearblocks_integer','star_integer','logwide']
BASE=((0,),(0,),(0,))

def host(rng,n,kind):
    if kind=='logwide':return random_H(rng,n,'logwide')
    if kind=='gram_integer':
        R=rng.integers(0,6,(n,max(2,n-1)))
        for i in range(n):
            if not R[i].any():R[i,0]=1
        return (R@R.T).astype(float)
    if kind=='star_integer':
        H=np.zeros((n,n));H[0,1:]=rng.integers(1,10,n-1);H+=H.T
        H+=np.diag(rng.integers(0,3,n));return H
    H=rng.integers(1,10,(n,n));H=np.triu(H)+np.triu(H,1).T
    if kind=='sparse_integer':
        mask=rng.random((n,n))<rng.uniform(.2,.65);mask=np.triu(mask)+np.triu(mask,1).T;H*=mask
        for i in range(n):
            if not H[i].any():H[i,i]=1
    if kind=='nearblocks_integer':
        split=int(rng.integers(1,n));H[:split,:split]*=int(rng.integers(5,30));H[split:,split:]*=int(rng.integers(5,30))
    return H.astype(float)

def record(H,Hseed,tpl,key,mode,kind,F,Z,data,width,cell,cycle_counts):
    M=len(key[0]);ratio=Z/F**M
    amplification=np.log(Z)/(M*(np.log(F)+1e-8))if F>1 and Z>0 else 0.
    p=pieces(H,tpl)
    return {'n':len(H),'M':M,'perms':key,'tuple':tpl,'mode':mode,'kind':kind,'cell':cell,'H':H.tolist(),'seed_H':Hseed.tolist(),
            'F':F,'Z':Z,'cover_ratio':float(ratio),'amplification':float(amplification),'width':width,'theta':data['theta'].tolist(),
            'min_root_entry':float(np.min(H/H.sum()/np.outer(data['mu'],data['mu']))),'fixed_cycle_counts':cycle_counts,
            'target_centered':p}

def certify_candidate(rec,label):
    sys.set_int_max_str_digits(0)
    with open(f'continuation_{label}_candidate.json','w')as f:json.dump(rec,f,indent=2)
    H=np.asarray(rec['H']);key=rec['perms'];tpl=rec['tuple']
    for scale in [10,30,100,300,1000,3000,10000]:
        R=np.rint(H/H.max()*scale).astype(int)
        if np.any(R.sum(1)==0):continue
        F,_,_=value_gradient(R,tpl,BASE);Z,_,_=value_gradient(R,tpl,key)
        if not (Z>F**len(key[0])*(1+1e-10)or F<1-1e-10):continue
        exact=exact_integer_certificate(R,tpl,key)
        out={'H_integer':R.tolist(),'tuple':tpl,'perms':key,'numeric_F':F,'numeric_Z':Z,
             'exact':{k:str(v)if isinstance(v,int)and len(str(v))>100 else v for k,v in exact.items()}}
        with open(f'continuation_{label}_exact_certificate.json','w')as f:json.dump(out,f,indent=2)
        print('EXACT_CANDIDATE_RESULT',label,'cover_violation',exact['cover_violation'],'target_violation',exact['target_violation'],flush=True)
        return out
    return None

def sample(args):
    rng=np.random.default_rng(args.seed);start=time.time();count=0;host_count=0;rows=[];best=None;besttarget=None;selected={};selected_target={}
    for M in [3,4]:
        registry=cover_registry(M)
        for n in [3,4,5,6]:
            initial_count=count;cellbest=-np.inf;targetbest=np.inf
            for j,rc in enumerate(registry):
                kind=KINDS[j%6];tpl=TPLS[(j//6)%len(TPLS)];key=rc['perms'];Hseed=host(rng,n,kind);Hb,cache=boundary_project(Hseed);host_count+=1
                modes=[('interior',Hseed)]
                if not cache['trivial']and cache['m']>1e-12:modes.append(('boundary',Hb))
                elif cache['m']<=1e-12:modes=[('boundary',Hb)]
                for mode,H in modes:
                    F,data,_=value_gradient(H,tpl,BASE);Z,_,w=value_gradient(H,tpl,key);count+=1
                    rec=record(H,Hseed,tpl,key,mode,kind,F,Z,data,w,[M,n,j],rc['fixed_cycle_counts'])
                    ratio=rec['cover_ratio'];cellbest=max(cellbest,ratio);targetbest=min(targetbest,F)
                    if best is None or ratio>best['cover_ratio']:best=rec
                    if besttarget is None or rec['target_centered']['ratio']<besttarget['target_centered']['ratio']:besttarget=rec
                    if max(rc['fixed_cycle_counts'])<M and F>1+1e-6:
                        group=f'{M}_{n}_{mode}';top=selected.setdefault(group,[]);top.append(rec);top.sort(key=lambda x:x['amplification'],reverse=True);del top[2:]
                    if mode=='boundary':
                        group=str(n);top=selected_target.setdefault(group,[]);top.append(rec);top.sort(key=lambda x:x['target_centered']['ratio']);del top[3:]
                    if ratio>1+1e-8 or F<1-1e-8:
                        certify_candidate(rec,'sample');return
            row={'M':M,'n':n,'connected_cover_classes':len(registry),'evaluations':count-initial_count,'max_cover_ratio':cellbest,'min_F':targetbest};rows.append(row)
            print('CELL',json.dumps(row),'elapsed',time.time()-start,flush=True)
            out={'seed':args.seed,'host_count':host_count,'count':count,'elapsed':time.time()-start,'rows':rows,'best':best,'best_target_centered':besttarget,'optimizer_starts':selected,'target_optimizer_starts':selected_target,'tuples':TPLS,'families':KINDS}
            with open('continuation_cover_samples.json','w')as f:json.dump(out,f,indent=2)
    print('SAMPLE_DONE',count,'host_count',host_count,'max_ratio',best['cover_ratio'],'min_full_surplus_ratio',besttarget['target_centered']['ratio'],flush=True)

def optimize(args):
    source=json.load(open('continuation_cover_samples.json'));start=time.time();out=[]
    seeds=json.load(open(args.starts)) if args.starts else [rec for group in source['optimizer_starts'].values()for rec in group]
    if args.limit:seeds=seeds[:args.limit]
    if args.resume:out=json.load(open('continuation_cover_optimizations.json'))['runs']
    for run,rec in enumerate(seeds[len(out):],start=len(out)):
        H0=np.asarray(rec['seed_H']);H0/=H0.sum();n=len(H0);mask=np.triu(H0>0);ii,jj=np.nonzero(mask);x0=np.log(H0[ii,jj]);tpl=rec['tuple'];key=rec['perms'];mode=rec['mode'];M=len(key[0]);calls=0
        def unpack(x):
            H=np.zeros((n,n));H[ii,jj]=np.exp(x);H+=np.triu(H,1).T;return H
        def obj(x):
            nonlocal calls
            calls+=1;H=unpack(x);cache=None
            if mode=='boundary':H,cache=boundary_project(H)
            F,GF,_,_=value_gradient(H,tpl,BASE,True);Z,GZ,_,_=value_gradient(H,tpl,key,True)
            d=np.log(F)+1e-8
            if d<=0:raise RuntimeError('target candidate entered objective')
            g=np.log(Z)/(M*d);G=GZ/(Z*M*d)-np.log(Z)*GF/(M*F*d*d)
            if cache is not None:G=boundary_pullback(unpack(x),cache,G)
            Gsym=G+G.T;Gsym[np.diag_indices(n)]=np.diag(G)
            return -g,-Gsym[ii,jj]*np.exp(x)
        res=minimize(obj,x0,jac=True,method='L-BFGS-B',bounds=[(-24,4)]*len(x0),options={'maxiter':args.maxiter,'ftol':1e-12,'gtol':1e-8,'maxls':25})
        seedH=unpack(res.x);H=boundary_project(seedH)[0]if mode=='boundary'else seedH
        F,data,_=value_gradient(H,tpl,BASE);Z,_,w=value_gradient(H,tpl,key);rr=record(H,seedH,tpl,key,mode,rec['kind'],F,Z,data,w,rec['cell'],rec['fixed_cycle_counts'])
        rr.update({'run':run,'success':bool(res.success),'message':str(res.message),'iterations':res.nit,'calls':calls,'starting_ratio':rec['cover_ratio'],'starting_amplification':rec['amplification']});out.append(rr)
        print('OPT',run,'M',M,'n',n,mode,'ratio',rr['cover_ratio'],'amplification',rr['amplification'],'nit',res.nit,'success',res.success,flush=True)
        with open('continuation_cover_optimizations.json','w')as f:json.dump({'runs':out,'elapsed':time.time()-start,'limit':args.limit,'maxiter':args.maxiter,'regularization':1e-8,'starts_file':args.starts,'resumed':args.resume},f,indent=2)
        if rr['cover_ratio']>1+1e-8 or F<1-1e-8:certify_candidate(rr,'optimized_cover');return

def target_optimize(args):
    source=json.load(open('continuation_cover_samples.json'));seeds=json.load(open(args.starts)) if args.starts else [rec for group in source['target_optimizer_starts'].values()for rec in group];start=time.time();out=[]
    if args.limit:seeds=seeds[:args.limit]
    for run,rec in enumerate(seeds):
        H0=np.asarray(rec['seed_H']);H0/=H0.sum();n=len(H0);ii,jj=np.nonzero(np.triu(H0>0));x0=np.log(H0[ii,jj]);tpl=rec['tuple'];calls=0
        def unpack(x):
            H=np.zeros((n,n));H[ii,jj]=np.exp(x);H+=np.triu(H,1).T;return H
        def obj(x):
            nonlocal calls
            calls+=1;Hin=unpack(x);H,cache=boundary_project(Hin);F,GF,data,_=value_gradient(H,tpl,BASE,True)
            centers=[K-1 for K in data['Ks']];Q,Gmu,GKs,_=contract_cover(data['mu'],centers,BASE,True);GQ=root_pullback(data,Gmu,GKs)
            dec=pieces(H,tpl);S=dec['cycles']+dec['diamonds'];Q=dec['full'];GS=GF-GQ;d=S+1e-12
            g=-Q/d;G=-GQ/d+Q*GS/(d*d);G=boundary_pullback(Hin,cache,G)
            Gsym=G+G.T;Gsym[np.diag_indices(n)]=np.diag(G)
            return -g,-Gsym[ii,jj]*np.exp(x)
        res=minimize(obj,x0,jac=True,method='L-BFGS-B',bounds=[(-24,4)]*len(x0),options={'maxiter':args.maxiter,'ftol':1e-12,'gtol':1e-8,'maxls':25})
        seedH=unpack(res.x);H=boundary_project(seedH)[0];F,data,_=value_gradient(H,tpl,BASE);Z,_,w=value_gradient(H,tpl,rec['perms'])
        rr=record(H,seedH,tpl,rec['perms'],'boundary',rec['kind'],F,Z,data,w,rec['cell'],rec['fixed_cycle_counts']);rr.update({'run':run,'success':bool(res.success),'message':str(res.message),'iterations':res.nit,'calls':calls,'starting_centered_ratio':rec['target_centered']['ratio']});out.append(rr)
        print('TARGET_OPT',run,'n',n,'F',F,'full_surplus_ratio',rr['target_centered']['ratio'],'nit',res.nit,'success',res.success,flush=True)
        with open('continuation_target_optimizations.json','w')as f:json.dump({'runs':out,'elapsed':time.time()-start,'maxiter':args.maxiter,'regularization':1e-12,'starts_file':args.starts},f,indent=2)
        if F<1-1e-8 or rr['target_centered']['ratio']< -1-1e-8:certify_candidate(rr,'optimized_target');return

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['sample','optimize','target_optimize']);ap.add_argument('--seed',type=int,default=26101011);ap.add_argument('--maxiter',type=int,default=80);ap.add_argument('--limit',type=int,default=0);ap.add_argument('--starts');ap.add_argument('--resume',action='store_true');args=ap.parse_args();globals()[args.mode](args)
