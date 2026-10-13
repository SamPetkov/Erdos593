"""Replay only; independent original-law contraction, no optimization.

All acceptance tolerances here are floating diagnostics.  They certify no
mathematical inequality, root spectrum sign, or finite counterexample.
"""
import os
os.environ['OPENBLAS_NUM_THREADS']='1'
os.environ['OMP_NUM_THREADS']='1'
import hashlib,json,platform
from pathlib import Path
import numpy as np
import scipy
import continuation7_opt_highrank as source

ROOT=Path(__file__).resolve().parent
RESULTS=ROOT/'continuation7_opt_highrank_results.json'
OUT=ROOT/'continuation7_opt_highrank_audit.json'
TOL=2e-8

def relerr(a,b):return float(np.max(np.abs(a-b))/max(1.,float(np.max(np.abs(a))),float(np.max(np.abs(b)))))

def audit():
    data=json.loads(RESULTS.read_text())
    assert data['status']=='complete' and len(data['cases'])==12
    assert hashlib.sha256((ROOT/'continuation7_opt_highrank.py').read_bytes()).hexdigest()==data['source_sha256']
    records=[]
    for case in data['cases']:
        n=case['n'];q=case['codimension'];d=n-q
        ij=[tuple(x) for x in case['ij']];scales=np.array(case['row_scales']);xyz=case['xyz']
        for stage in ('initial','retained'):
            params=np.array(case[stage+'_parameters']);old=case[stage]
            replay=source.budget(params,n,q,ij,scales,xyz,True)
            # Assemble the original law, root, and relative projection directly
            # from stored conductances and frame coordinates.  This route does
            # not use the optimizer's Euclidean Qhat or compressed fields.
            G=np.array(old['G']);rows=G.sum(1);mu=rows/rows.sum()
            P0=G/rows[:,None];P=(1-source.DELTA)*P0+source.DELTA*mu[None,:]
            S=P/mu[None,:];V=np.array(old['V'])
            Gram=V.T@(mu[:,None]*V)
            Q=np.diag(1/mu)-V@np.linalg.solve(Gram,V.T)
            powers=[np.linalg.matrix_power(P,2*s) for s in xyz]
            Qh=Q*np.sqrt(mu[:,None]*mu[None,:])
            shortest_fields=np.einsum('ab,tb,bc->tac',Qh,powers[0]/mu[None,:],Qh,optimize=True)
            shortest_cap=max(np.linalg.eigvalsh((M+M.T)/2)[-1] for M in shortest_fields)
            shortest_trace_residual=float(np.max(np.abs(np.trace(shortest_fields,axis1=1,axis2=2)-d)))
            tri=Q[:,:,None]*Q[None,:,:]*Q.T[:,None,:]
            direct_local=np.array([np.einsum('a,b,c,abc->',powers[0][t],powers[1][t],powers[2][t],tri,optimize=True) for t in range(n)])
            directJ=float(mu@direct_local)
            pair=sum(float(np.einsum('t,ta,tb,ab->',mu,powers[i],powers[j],Q*Q,optimize=True))-d
                     for i,j in ((0,1),(0,2),(1,2)))
            checked={'J_replay':relerr(replay['J'],old['J']),
                'J_direct':relerr(directJ,old['J']),
                'local_direct':relerr(direct_local,np.array(old['local'])),
                'pair_direct':relerr(pair,old['pair']),
                'centered_identity':relerr(old['J'],d+old['pair']+old['cubic']),
                'original_law_replay':relerr(mu,np.array(old['pi'])),
                'relative_root_symmetry':relerr(S,S.T),
                'relative_root_rows':relerr(S@mu,np.ones(n)),
                'projection_reconstruction':relerr(Q,np.array(old['Q'])),
                'projection_identity':relerr((Q*mu[None,:])@Q,Q),
                'projection_trace':abs(float(mu@np.diag(Q))-d)/max(1,d),
                'coarse_W_normalization':relerr(old['coarse_p']*S@mu,np.full(n,old['coarse_p']))}
            assert min(mu)>0 and min(S.ravel())>0
            assert max((old['coarse_p']*S).ravel())<=1+TOL
            # Independently validate the permission bound for the optional
            # binary channel, without treating it as an evaluated F host.
            assert np.min(S-old['permitted_binary_alpha']*np.abs(Q))>0
            assert max(checked.values())<TOL,(case['index'],stage,checked)
            records.append({'case':case['index'],'stage':stage,'rank':d,'direct_J':directJ,
                'J_over_rank':directJ/d,'minimum_mu':float(min(mu)),
                'source_cap':old['actual_first_source_cap'],
                'actual_shortest_time_source_cap':float(shortest_cap),
                'shortest_time_trace_residual':shortest_trace_residual,
                'visible_trace_residual':old['visible_trace_residual'],
                'errors':checked})
    retained=[r for r in records if r['stage']=='retained']
    counts={'configured_starts':len(data['cases']),
        'replayed_evaluations':len(records),
        'iterations':sum(c['result']['nit'] for c in data['cases']),
        'real_objective_calls':sum(c['result']['real_calls'] for c in data['cases']),
        'all_objective_calls':sum(c['result']['all_calls'] for c in data['cases']),
        'converged':sum(c['result']['success'] for c in data['cases']),
        'iteration_cap':sum('ITERATIONS REACHED LIMIT' in c['result']['message'] for c in data['cases']),
        'evaluation_cap':sum('EVALUATIONS EXCEEDS LIMIT' in c['result']['message'] for c in data['cases'])}
    output={'status':'PASS: floating replay and admissibility diagnostics only',
       'source_sha256':data['source_sha256'],
       'results_sha256':hashlib.sha256(RESULTS.read_bytes()).hexdigest(),
       'audit_source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
       'diagnostic_tolerance':TOL,'counts':counts,
       'versions':{'Python':platform.python_version(),'NumPy':np.__version__,'SciPy':scipy.__version__},
       'minimum_retained_ratio':min(r['J_over_rank'] for r in retained),
       'maximum_diagnostic_error':max(max(r['errors'].values()) for r in records),
       'records':records}
    OUT.write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({k:output[k] for k in ('status','counts','minimum_retained_ratio','maximum_diagnostic_error')},indent=2))

if __name__=='__main__':audit()
