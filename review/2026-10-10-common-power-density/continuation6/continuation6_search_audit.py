"""Independent finite replay of the three bounded continuation6 diagnostics.
No optimization is performed; no floating sign is a mathematical certificate.
"""
import os
os.environ.setdefault('OPENBLAS_NUM_THREADS','1')
os.environ.setdefault('OMP_NUM_THREADS','1')
import hashlib,importlib,json,platform
from pathlib import Path
import numpy as np
import scipy

ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def asfloat(z):return float(np.real(z))
def relative(a,b):return abs(a-b)/max(1.,abs(a),abs(b))

def scalar_three_leaf(pi,K,Q,xyz):
    # Original-law triangle-source expansion, independent of coordinate-field product.
    weighted_triangle=np.einsum('a,b,c,ab,bc,ca->abc',pi,pi,pi,Q,Q,Q,optimize=True)
    star=np.einsum('t,at,bt,ct->abc',pi,K[0],K[1],K[2],optimize=True)
    summands=weighted_triangle*star
    return summands.sum(),np.abs(summands).sum()

def coordinate_compression(pi,P,Qh,xyz):
    # Euclidean representation of Q D_K Q, including the zero action off its range.
    Ks=[np.linalg.matrix_power(P,2*j)/pi[None,:] for j in xyz]
    fields=[np.array([Qh@np.diag(K[:,t])@Qh for t in range(len(pi))]) for K in Ks]
    local=np.array([np.trace(fields[0][t]@fields[1][t]@fields[2][t]) for t in range(len(pi))])
    return pi@local,Ks

def run():
    configs=[('rank_extremes','continuation6_search_rank_extremes_opt'),
             ('psd_field','continuation6_search_psd_field_opt'),
             ('path_completion','continuation6_search_path_completion_opt')]
    out=dict(status='passed',scope='Numerical replay and realization checks only; no averaged-star or F sign certificate.',
       source_sha256=sha(Path(__file__)),versions={'python':platform.python_version(),'numpy':np.__version__,'scipy':scipy.__version__},stages=[])
    for kind,module_name in configs:
        module=importlib.import_module(module_name);recpath=ROOT/f'continuation6_search_{kind}_optimizations.json'
        rec=json.loads(recpath.read_text());assert rec['status']=='complete'
        assert rec['source_sha256']==sha(ROOT/(module_name+'.py'))
        if kind=='psd_field':assert rec['root_source_sha256']==sha(ROOT/'continuation6_search_rank_extremes_opt.py')
        assert len(rec['cases'])==rec['caps']['starts']
        stats={'kind':kind,'source_sha256':rec['source_sha256'],'records_sha256':sha(recpath),'cases':len(rec['cases']),
          'replays':0,'sum_iterations':0,'sum_real_calls':0,'sum_all_calls':0,'termination_counts':{},
          'minimum_J_over_rank':1e300,'minimum_cubic_over_pair':1e300,
          'max_stored_replay_error':0.,'max_centered_identity_scaled_error':0.,
          'max_independent_J_error':0.,'max_triangle_condition_scaled_error':0.,
          'max_row_sum_error':0.,'max_reversibility_error':0.,'max_projection_error':0.,
          'max_refinement_transport_error':0.,'minimum_original_mass':1.,'candidate_count':0}
        for c in rec['cases']:
            result=c['result'];assert result['nit']<=rec['caps']['maxiter'];stats['sum_iterations']+=result['nit']
            stats['sum_real_calls']+=result['real_calls'];stats['sum_all_calls']+=result['all_calls']
            status=str(result['status']);stats['termination_counts'][status]=stats['termination_counts'].get(status,0)+1
            for label in ['initial','retained']:
                v=np.array(c[label+'_parameters']);xyz=c['xyz']
                if kind=='rank_extremes':
                    G,pi,P,q=module.model(v,c['n'],c['ij']);d=1 if c['kind']=='scalar' else c['n']-1
                    actual=module.budget(v,c['n'],c['ij'],xyz,c['kind'],True)
                    w=np.sqrt(q);Qh=np.outer(w,w)
                    if c['kind']=='complement':Qh=np.eye(len(pi))-Qh
                elif kind=='psd_field':
                    G,pi,P,V,Gram,inv,C=module.model(v,c['n'],c['d'],c['ij']);d=c['d']
                    actual=module.value(v,c['n'],d,c['ij'],xyz,c['objective'],True)
                    n=len(pi);mu=np.repeat(pi/d,d)
                    # Rationalizable rank-one refinement: L_i=V_i/sqrt(pi_i).
                    U=np.array([np.sqrt(d/pi[i])*V[i,:,a] for i in range(n) for a in range(d)])
                    Q=U@inv@U.T;Qh=np.sqrt(mu[:,None])*Q*np.sqrt(mu[None,:])
                    Pf=np.repeat(np.repeat(P,d,axis=0),d,axis=1)/d
                    ind,_=coordinate_compression(mu,Pf,Qh,xyz)
                    stats['max_refinement_transport_error']=max(stats['max_refinement_transport_error'],relative(ind,actual['J']))
                    stats['max_projection_error']=max(stats['max_projection_error'],float(np.max(abs(Qh@Qh-Qh))))
                    # The subsequent ordinary-source test uses this exact refinement.
                    pi,P=mu,Pf
                else:
                    G,pi,P0,P,delta,V,Gram,R=module.model(v);d=2
                    actual=module.value(v,xyz,c['objective'],True)
                    inv=np.linalg.inv(Gram);Q=V@inv@V.T;Qh=np.sqrt(pi[:,None])*Q*np.sqrt(pi[None,:])
                    assert 0<delta<1 and np.min(P/pi[None,:])>0
                stored=c[label]
                stats['replays']+=1
                stats['max_stored_replay_error']=max(stats['max_stored_replay_error'],*(relative(actual[key],stored[key]) for key in ['J','J_centered','pair','cubic']))
                stats['max_centered_identity_scaled_error']=max(stats['max_centered_identity_scaled_error'],
                    abs(actual['J']-actual['J_centered'])/max(1.,d,abs(actual['pair']),abs(actual['cubic']),abs(actual['J'])))
                stats['max_row_sum_error']=max(stats['max_row_sum_error'],float(np.max(abs(P.sum(1)-1))))
                flux=pi[:,None]*P
                stats['max_reversibility_error']=max(stats['max_reversibility_error'],float(np.max(abs(flux-flux.T))))
                stats['max_projection_error']=max(stats['max_projection_error'],float(np.max(abs(Qh@Qh-Qh))))
                stats['minimum_original_mass']=min(stats['minimum_original_mass'],float(pi.min()))
                independent,Ks=coordinate_compression(pi,P,Qh,xyz)
                stats['max_independent_J_error']=max(stats['max_independent_J_error'],relative(independent,actual['J']))
                Q=Qh/np.sqrt(pi[:,None]*pi[None,:]);direct,scale=scalar_three_leaf(pi,Ks,Q,xyz)
                stats['max_triangle_condition_scaled_error']=max(stats['max_triangle_condition_scaled_error'],abs(direct-actual['J'])/max(1.,scale,abs(actual['J'])))
                if label=='retained':
                    stats['minimum_J_over_rank']=min(stats['minimum_J_over_rank'],actual['J']/d)
                    budget=actual['objective'] if kind=='rank_extremes' else actual['budget']
                    stats['minimum_cubic_over_pair']=min(stats['minimum_cubic_over_pair'],budget)
                    if actual['J']<d-1e-6 and budget<-1-1e-6:stats['candidate_count']+=1
        assert stats['max_stored_replay_error']==0
        # Rare completion charts have condition-sensitive errors up to 4e-10.
        # This loose diagnostic gate is not an exact sign assertion.
        assert stats['max_centered_identity_scaled_error']<1e-8
        assert stats['max_independent_J_error']<2e-7
        assert stats['max_triangle_condition_scaled_error']<2e-10
        assert stats['max_row_sum_error']<1e-12 and stats['max_reversibility_error']<1e-12
        assert stats['max_projection_error']<2e-8
        assert stats['max_refinement_transport_error']<2e-7
        assert stats['minimum_original_mass']>0 and stats['candidate_count']==0
        out['stages'].append(stats)
    out['total_configured_completed_starts']=sum(s['cases'] for s in out['stages'])
    out['total_start_retained_replays']=sum(s['replays'] for s in out['stages'])
    target=ROOT/'continuation6_search_audit.json';target.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(out,indent=2))
if __name__=='__main__':run()
