"""Replay the two frozen bounded numerical projection-star diagnostics."""
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS','1')
os.environ.setdefault('OMP_NUM_THREADS','1')
from pathlib import Path
import hashlib,json,collections
import numpy as np
import scipy
import continuation5_search_projection_opt as first
import continuation5_search_projection_budget_opt as second

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()

def main():
    files=['continuation5_search_projection_optimizations.json',
           'continuation5_search_projection_budget_optimizations.json']
    packs=[json.loads((ROOT/f).read_text()) for f in files]
    assert packs[0]['source_sha256']==sha('continuation5_search_projection_opt.py')
    assert packs[1]['source_sha256']==sha('continuation5_search_projection_budget_opt.py')
    assert packs[1]['model_source_sha256']==sha('continuation5_search_projection_opt.py')
    assert packs[1]['parent_records_sha256']==sha(files[0])
    sums=[];max_identity=0.;max_relative_replay=0.;checks=0
    for stage,pack in enumerate(packs):
        assert pack['status']=='complete' and len(pack['cases'])==12
        for i,c in enumerate(pack['cases']):
            assert c['index']==i and c['d']==2
            x,y,z=c['xyz'];assert 1<=x<y<z
            tpl=(z,x,y-1,1,1);k,u,r,l,h=tpl
            assert k>=u>=1 and r>=l>=1 and h>=1
            assert not(k==u and r==l) and not(k==r and u==l) and not(k==r+h and u==l)
            assert c['initial_parameters']==packs[0]['cases'][i]['initial_parameters']
            for label in ['initial','retained']:
                v=np.array(c[label+'_parameters']);n=c['n'];d=c['d'];ij=c['ij'];nf=len(ij)
                assert np.all(v[:nf]>=-24.-1e-12) and np.all(v[:nf]<=5.+1e-12)
                assert np.all(v[nf:]>=-8.-1e-12) and np.all(v[nf:]<=8.+1e-12)
                G,pi,P,U,inv,Q=first.model(v,n,d,ij)
                assert np.array_equal(G,G.T) and np.min(G)>=0 and np.min(pi)>0
                assert abs(pi.sum()-1)<1e-13 and np.max(abs(P.sum(1)-1))<1e-13
                assert np.max(abs(pi[:,None]*P-(pi[:,None]*P).T))<1e-13
                qhat=np.sqrt(pi[:,None])*Q*np.sqrt(pi[None,:])
                assert np.max(abs(qhat@qhat-qhat))<2e-12 and abs(np.trace(qhat)-2)<2e-12
                val=first.value(v,n,d,ij,c['xyz'],True)
                if stage==0 or label=='retained':
                    old=c[label]
                    for key in ['J','ratio','p','max_A']:
                        err=abs(val[key]-old[key])/max(1.,abs(old[key]))
                        max_relative_replay=max(max_relative_replay,err);assert err<1e-11
                bud=second.budget(v,n,d,ij,c['xyz'],True)
                err=abs(val['J']-bud['J_centered'])/max(1.,abs(val['J']))
                max_identity=max(max_identity,err);assert err<1e-11
                if stage==1:
                    old=c['initial'] if label=='initial' else c['retained_budget']
                    for key in ['pair','cubic','ratio','J_centered']:
                        err=abs(bud[key]-old[key])/max(1.,abs(old[key]))
                        max_relative_replay=max(max_relative_replay,err);assert err<1e-11
                checks+=1
            assert c['result']['nit']<= (140 if stage==0 else 180)
            assert len(c['history'])==c['result']['nit']
        cs=pack['cases']
        sums.append(dict(stage=stage+1,starts=12,
          iterations=sum(c['result']['nit'] for c in cs),
          objective_evaluations_including_complex_step=sum(c['result']['nfev'] for c in cs),
          real_objective_evaluations=sum(c['result']['real_calls'] for c in cs),
          statuses=dict(collections.Counter(c['result']['message'] for c in cs)),
          min_retained_J=min(c['retained']['J'] for c in cs),
          min_retained_cubic_pair_ratio=min(c['retained_budget']['ratio'] for c in cs) if stage else None))
    rng=np.random.default_rng(202610106);grad=[]
    for stage in range(2):
        c=packs[stage]['cases'][2];v=np.array(c['initial_parameters'])
        fn=first.value if stage==0 else second.budget
        for j in range(3):
            w=rng.normal(size=v.shape);w/=np.linalg.norm(w)
            cs=fn(v+1e-24j*w,c['n'],c['d'],c['ij'],c['xyz']).imag/1e-24
            h=2e-5
            fd=(fn(v+h*w,c['n'],c['d'],c['ij'],c['xyz'])-fn(v-h*w,c['n'],c['d'],c['ij'],c['xyz']))/(2*h)
            err=abs(cs-fd)/max(1.,abs(cs));assert err<2e-7
            grad.append(dict(stage=stage+1,direction=j,relative_error=float(err)))
    out=dict(status='passed',scope='Floating-point replay and diagnostic checks only; no exact J or F sign claim.',
      source_sha256=sha(Path(__file__).name),bindings={f:sha(f) for f in files+[
        'continuation5_search_projection_opt.py','continuation5_search_projection_budget_opt.py']},
      replayed_start_or_retained_points=checks,stages=sums,
      maximum_relative_replay_error=max_relative_replay,maximum_centered_identity_relative_error=max_identity,
      directional_gradient_checks=grad,numpy=np.__version__,scipy=scipy.__version__)
    (ROOT/'continuation5_search_projection_audit.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(out,indent=2))

if __name__=='__main__':main()
