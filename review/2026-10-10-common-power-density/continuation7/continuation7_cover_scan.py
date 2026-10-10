"""Bounded deterministic *diagnostic* of all seven nontrivial two-covers.

No optimization and no numerical sign is a proof.  Every root is generated
from an explicit nonnegative symmetric integer flow, with its original law.
"""
import json
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS', '1')
os.environ.setdefault('OMP_NUM_THREADS', '1')
import time
from pathlib import Path
import numpy as np

SEED = 2026101007
TUPLES = [(1,1,1,1,1), (3,1,1,1,1), (4,4,1,1,8),
          (4,1,4,1,1), (5,2,3,2,4), (2,2,2,2,1)]
EDGES = [(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]

def contract(mu, kernels, mask=0, sheets=1):
    labels = 'abcdefgh'[:4*sheets]
    subs, arrays = [], []
    for edge, (v,w) in enumerate(EDGES):
        swap = sheets == 2 and edge >= 3 and ((mask >> (edge-3)) & 1)
        for s in range(sheets):
            subs.append(labels[4*s+v] + labels[4*(s ^ swap)+w])
            arrays.append(kernels[edge])
    for label in labels:
        subs.append(label)
        arrays.append(mu)
    expr = ','.join(subs) + '->'
    key = (len(mu),mask,sheets)
    if key not in PATHS:
        PATHS[key] = np.einsum_path(expr,*arrays,optimize='greedy')[0]
    return float(np.einsum(expr,*arrays,optimize=PATHS[key]))

PATHS = {}
def evaluate(G, tu):
    G = np.array(G,dtype=float)
    sums=G.sum(axis=1)
    mu=sums/sums.sum()
    P=G/sums[:,None]
    k,u,r,l,h=tu
    ns=(k,r+h,u,r,u,l)
    powers={e:np.linalg.matrix_power(P,2*e)/mu[None,:] for e in set(ns)}
    kernels=[powers[e] for e in ns]
    F=contract(mu,kernels)
    Z=[contract(mu,kernels,m,2) for m in range(1,8)]
    return F,Z,mu

def generate():
    rng=np.random.default_rng(SEED)
    for n in (3,4,5):
        for rep in range(12):
            mode=rep%4
            G=np.zeros((n,n),dtype=np.int64)
            for i in range(n):
                for j in range(i,n):
                    if mode==0:
                        val=2**int(rng.integers(0,9))
                    elif mode==1:
                        val=2**int(rng.integers(0,6)) if abs(i-j)==1 else 0
                    elif mode==2:
                        val=2**int(rng.integers(9,16)) if i==j else 2**int(rng.integers(0,6))
                    else:
                        val=2**int(rng.integers(0,7)) if (i==j or abs(i-j)==1) else 0
                        if i>0 and j>0: val*=1024
                    G[i,j]=G[j,i]=val
            yield {'n':n,'rep':rep,'mode':mode,'G':G.tolist()}

def main():
    start=time.perf_counter()
    roots=list(generate())
    rows=[]
    for host in roots:
        for tu in TUPLES:
            F,Z,mu=evaluate(host['G'],tu)
            ratios=[z/(F*F) for z in Z]
            rows.append({'host':roots.index(host),'tuple':tu,'F':F,'Z':Z,
                         'ratios':ratios,'min_mu':float(mu.min())})
    largest=max((r['ratios'][m-1],i,m) for i,r in enumerate(rows) for m in range(1,8))
    strict=[{'row':i,'mask':m,'ratio':r['ratios'][m-1]}
            for i,r in enumerate(rows) for m in range(1,8)
            if r['ratios'][m-1]>1+1e-8]
    out={'scope':'numerical diagnostic only; seven complete two-cover gauge classes',
         'seed':SEED,'roots':roots,'tuples':TUPLES,'root_count':len(roots),
         'tuple_count':len(rows),'cover_count':7*len(rows),
         'candidate_threshold':1e-8,'strict_candidates':strict,
         'max_ratio':largest,'rows':rows,'seconds':time.perf_counter()-start,
         'numpy_version':np.__version__}
    Path('continuation7_cover_scan_results.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('roots','rows')},indent=2))

if __name__=='__main__': main()
