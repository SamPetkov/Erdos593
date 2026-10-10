"""One bounded four-state group-fiber search on actual common-power roots.

Every stored input is a nonnegative symmetric coarse-pair flow L[i,j,g],
g in (Z/2)^2.  Fine flow is G[(i,a),(j,b)] = L[i,j,a xor b].
Original fine probabilities, roots, powers, and cover contractions use the
ordinary symmetric-flow construction in the unchanged cover engine.

The three nonconstant Walsh channels interact through actual cubic moments.
They are not assumed to have entrywise nonnegative squares.  This is a finite
numerical search, not a proof or an exact counterexample certificate.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path
import sys
import time

import numpy as np
from scipy.optimize import minimize

from continuation_cover_engine import (
    contract_cover, exact_integer_certificate, root_data, root_pullback,
    validate_tuple,
)

PREFIX = 'continuation4_search_'
BASE = ((0,), (0,), (0,))
KEYS = {b: tuple((1, 0) if b >> e & 1 else (0, 1) for e in range(3))
        for b in range(1, 8)}
TUPLES = ((1,1,1,1,1), (2,2,1,1,1), (6,1,1,1,1), (8,2,3,1,1),
          (3,1,2,1,3), (1,1,3,3,1), (4,4,1,1,8), (8,4,1,1,8),
          (3,2,5,3,7), (1,1,1,1,16), (4,1,2,1,6), (4,4,2,2,1))
FAMILIES = ('shift_dominated', 'positive_tetrahedral', 'bipartite_transport',
            'zero_character', 'interacting_blocks', 'uniform_matchings')
WALSH = np.array([[1,1,1,1], [1,-1,1,-1],
                  [1,1,-1,-1], [1,-1,-1,1]], dtype=int)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def dump(name, value):
    Path(PREFIX + name + '.json').write_text(json.dumps(value, indent=2) + '\n')


def read(name):
    return json.loads(Path(PREFIX + name + '.json').read_text())


def validate_L(L):
    L = np.asarray(L)
    if L.ndim != 3 or L.shape[0] == 0 or L.shape[0] != L.shape[1] or L.shape[2] != 4:
        raise ValueError('L must have dimensions m by m by 4 with m positive')
    if not np.isfinite(L.astype(float)).all() or np.any(L < 0):
        raise ValueError('L must be finite and nonnegative')
    if not np.array_equal(L, L.transpose(1,0,2)):
        raise ValueError('L must be symmetric in its coarse indices')
    if np.any(L.sum(axis=(1,2)) <= 0):
        raise ValueError('Every original coarse row must have positive mass')
    return L


def fine_flow(L):
    L = validate_L(L)
    m = len(L)
    return np.array([[L[i,j,a ^ b] for j in range(m) for b in range(4)]
                     for i in range(m) for a in range(4)], dtype=L.dtype)


def flow_gradient_to_L(G):
    m = len(G) // 4
    ans = np.zeros((m,m,4))
    for i in range(m):
        for j in range(m):
            for g in range(4):
                ans[i,j,g] = sum(G[4*i+a, 4*j+(a ^ g)] for a in range(4))
    return ans


def diagnostics(L, data):
    L = np.asarray(L, dtype=float)
    s = L.sum(axis=(1,2)); C = s.sum(); pi = s/C
    fourier = np.einsum('ijg,ag->aij', L, WALSH)
    ordinary = fourier / s[None,:,None]
    square = ordinary @ ordinary
    comm = [float(np.max(np.abs(ordinary[a] @ ordinary[b] - ordinary[b] @ ordinary[a])))
            for a in range(1,4) for b in range(a+1,4)]
    fineG = fine_flow(L)
    fs = fineG.sum(1); fC = fs.sum()
    T = fC*fineG/(fs[:,None]*fs[None,:])
    A = (fineG/fs[:,None]) @ (fineG/fs[:,None]) / data['mu'][None,:]
    return {'original_coarse_pi': pi.tolist(), 'original_fine_mu': data['mu'].tolist(),
            'p': float(1/T.max()), 'max_A': float(A.max()),
            'root_zero_entries': int(np.sum(fineG == 0)),
            'channel_square_minima': [float(x.min()) for x in square[1:]],
            'channel_commutator_maxima': comm,
            'centered_square_eigenvalues_numeric': data['theta'].tolist(),
            'centered_band_count_numeric': len(np.unique(np.round(data['theta'], 10)))}


def values(L, tpl):
    tpl = validate_tuple(tpl)
    G = fine_flow(L).astype(float)
    data = root_data(G, tpl)
    F, _ = contract_cover(data['mu'], data['Ks'], BASE)
    covers = []
    for bits, key in KEYS.items():
        Z, width = contract_cover(data['mu'], data['Ks'], key)
        covers.append({'bits_bc_bd_cd': bits, 'Z': float(Z), 'ratio': float(Z/F**2),
                       'defect_F2_minus_Z': float(F**2-Z), 'width': width,
                       'log_amplification': float(math.log(Z)/(2*(math.log(F)+1e-8)))})
    return {'F': float(F), 'covers': covers, **diagnostics(L, data)}


def one_value_gradient(L, tpl, bits, gradient=True):
    G = fine_flow(L).astype(float)
    data = root_data(G, tpl)
    if not gradient:
        F, _ = contract_cover(data['mu'], data['Ks'], BASE)
        Z, _ = contract_cover(data['mu'], data['Ks'], KEYS[bits])
        return F, Z
    F, Gmu, GKs, _ = contract_cover(data['mu'], data['Ks'], BASE, True)
    GF = root_pullback(data, Gmu, GKs)
    Z, Gmu, GKs, _ = contract_cover(data['mu'], data['Ks'], KEYS[bits], True)
    GZ = root_pullback(data, Gmu, GKs)
    d = math.log(F) + 1e-8
    if d <= 0 or F <= 0 or Z <= 0:
        raise ArithmeticError('Potential target candidate or ill-conditioned objective')
    amplification = math.log(Z)/(2*d)
    Gscore = GZ/(2*Z*d) - math.log(Z)*GF/(2*F*d*d)
    return -amplification, -flow_gradient_to_L(Gscore), float(F), float(Z)


def uniform_matching(rng, m):
    generators = []
    # Every generator is an involutive permutation of all fine states and
    # commutes with the group translations.  Each coarse row has sum one.
    for index in range(12):
        order = rng.permutation(m).tolist()
        pairs = []
        if index % 4 == 0:
            pairs = [(i,i) for i in range(m)]
        else:
            while len(order) >= 2:
                i, j = order.pop(), order.pop(); pairs.append((i,j))
            pairs.extend((i,i) for i in order)
        M = np.zeros((m,m,4), dtype=int)
        for i,j in pairs:
            g = int(rng.integers(0,4)); M[i,j,g] = M[j,i,g] = 1
        assert np.all(M.sum(axis=(1,2)) == 1)
        generators.append(M)
    weights = rng.integers(1,17,size=len(generators))
    L = np.einsum('a,aijg->ijg', weights, generators)
    return L, {'generators': [g.tolist() for g in generators], 'weights': weights.tolist()}


def host(rng, m, family, rep):
    L = np.zeros((m,m,4), dtype=int)
    if family == 'uniform_matchings':
        return uniform_matching(rng, m)
    cut = max(1, m//2)
    for i in range(m):
        for j in range(i,m):
            if family == 'shift_dominated':
                v = np.zeros(4, dtype=int)
                v[int(rng.integers(0,4))] = int(rng.integers(1,17))
                if i == j:
                    v[0] += int(2**rng.integers(0,9))
            elif family == 'positive_tetrahedral':
                v = rng.integers(1,5,size=4)
                v[int(rng.integers(0,4))] += int(2**rng.integers(2,9))
            elif family == 'bipartite_transport':
                v = np.zeros(4,dtype=int)
                if (i < cut) != (j < cut):
                    v = rng.integers(0,9,size=4)
                    v[int(rng.integers(0,4))] += int(2**rng.integers(0,7))
                elif rep % 2:
                    v[0] = 1
            elif family == 'zero_character':
                a,b,c,d = rng.integers(0,17,size=4)
                v = np.array([a+b, a+c, b+d, c+d])
                if i == j:
                    v += int(2**rng.integers(0,8))
                assert v[0]-v[1]-v[2]+v[3] == 0
            elif family == 'interacting_blocks':
                if (i < cut) == (j < cut):
                    v = rng.integers(0,9,size=4)*int(2**rng.integers(0,7))
                    v[int(rng.integers(0,4))] += 1
                else:
                    v = np.zeros(4,dtype=int)
                    if (i,j) == (cut-1,cut):
                        v[int(rng.integers(0,4))] = 1
            else:
                raise ValueError(family)
            L[i,j] = L[j,i] = v
    if np.any(L.sum(axis=(1,2)) == 0):
        raise AssertionError('Generator made a zero original mass')
    return L, {}


def freeze():
    rng = np.random.default_rng(20261014)
    hosts = []
    for m in (3,4,5):
        for family in FAMILIES:
            for rep in range(8):
                L, extra = host(rng,m,family,rep)
                hosts.append({'id': len(hosts), 'coarse_states': m, 'fine_states': 4*m,
                              'family': family, 'replicate': rep, 'L_integer': L.tolist(),
                              'tuple': TUPLES[len(hosts)%len(TUPLES)], **extra})
    config = {'schema': 'actual-four-state-group-fiber/v1', 'seed': 20261014,
              'tuple_order': ['k','u','r','l','h'], 'tuples': TUPLES,
              'group_state_order': [0,1,2,3], 'Walsh_characters': WALSH.tolist(),
              'families': FAMILIES, 'sample_host_tuple_cap': 144,
              'all_two_cover_bits': list(range(1,8)), 'optimizer_start_cap': 21,
              'iterations_per_start': 80, 'optimizer_regularization': 1e-8,
              'flow_log_bounds': [-16,4], 'fixed_uniform_log_bounds': [-12,4],
              'optimizer_options': {'maxiter':80,'ftol':1e-12,'gtol':1e-8,'maxls':25},
              'candidate_cover_ratio_threshold': 1+1e-8,
              'candidate_target_threshold': 1-1e-8,
              'source_sha256': sha('continuation4_search_engine.py'),
              'dependency_sha256': sha('continuation_cover_engine.py'), 'hosts': hosts}
    dump('config', config)
    print('FROZEN', len(hosts), sha(PREFIX+'config.json'), flush=True)


def candidate(rec, label):
    dump(label+'_candidate', rec)
    L = np.asarray(rec['L_float'] if 'L_float' in rec else rec['L_integer'], dtype=float)
    tpl = rec['tuple']
    bits = max(rec['metrics']['covers'], key=lambda r:r['ratio'])['bits_bc_bd_cd']
    attempts = []
    for scale in (16,64,256,1024,4096,16384):
        Li = np.rint(L/L.max()*scale).astype(int)
        if np.any(Li.sum(axis=(1,2)) <= 0):
            attempts.append({'scale':scale,'status':'zero row after rationalization'}); continue
        met = values(Li,tpl)
        if met['F'] >= 1-1e-10 and met['covers'][bits-1]['ratio'] <= 1+1e-10:
            attempts.append({'scale':scale,'status':'no retained numeric sign'}); continue
        exact = exact_integer_certificate(fine_flow(Li).tolist(), tpl, KEYS[bits])
        sys.set_int_max_str_digits(0)
        cert = {'L_integer':Li.tolist(), 'fine_flow_integer':fine_flow(Li).tolist(),
                'tuple':tpl,'two_cover_bits':bits,'exact':exact}
        dump(label+'_exact_certificate', cert)
        attempts.append({'scale':scale,'status':'exact arithmetic completed',
                         'cover_violation':exact['cover_violation'],
                         'target_violation':exact['target_violation']})
        if exact['cover_violation'] or exact['target_violation']:
            dump(label+'_certificate_attempts',attempts); return True
    dump(label+'_certificate_attempts',attempts)
    return False


def sample():
    cfg = read('config'); start=time.time(); samples=[]
    assert cfg['source_sha256'] == sha('continuation4_search_engine.py')
    for host_rec in cfg['hosts']:
        met = values(np.array(host_rec['L_integer']),host_rec['tuple'])
        samples.append({'host_id':host_rec['id'],'metrics':met})
        if met['F'] < cfg['candidate_target_threshold'] or max(v['ratio'] for v in met['covers']) > cfg['candidate_cover_ratio_threshold']:
            candidate({**host_rec,'metrics':met},'sample')
            dump('samples',{'completed':samples,'early_stop':True,'elapsed_seconds':time.time()-start})
            return
    dump('samples',{'completed':samples,'early_stop':False,'elapsed_seconds':time.time()-start,
                    'configuration_sha256':sha(PREFIX+'config.json')})
    print('SAMPLED',len(samples),'covers',7*len(samples), 'max_ratio',
          max(c['ratio'] for r in samples for c in r['metrics']['covers']),flush=True)


def freeze_starts():
    cfg=read('config'); samples=read('samples')['completed']; starts=[]
    for m in (3,4,5):
        for bits in range(1,8):
            eligible=[]
            for row in samples:
                rec=cfg['hosts'][row['host_id']]; met=row['metrics']
                if rec['coarse_states'] != m or met['F'] <= 1+1e-5:
                    continue
                if not(met['p']<.25 and met['max_A']>4 and met['centered_band_count_numeric']>=3):
                    continue
                if not any(v < -1e-12 for v in met['channel_square_minima']):
                    continue
                if m == 5 and rec['family'] != 'uniform_matchings':
                    continue
                eligible.append((met['covers'][bits-1]['log_amplification'], -rec['id'], rec, met))
            if not eligible:
                raise RuntimeError(f'No eligible frozen start for {m=}, {bits=}')
            _,_,rec,met=max(eligible,key=lambda x:x[:2])
            L=np.array(rec['L_integer'],dtype=float)
            if m == 5:
                weights=np.array(rec['weights'],dtype=float); weights/=weights.max()
                x=np.log(weights); mode='fixed_uniform_mixture'
                coordinate_data={'generators':rec['generators']}
            else:
                L/=L.max(); ii,jj,gg=np.nonzero(np.triu(np.ones((m,m),dtype=bool))[:,:,None] & (L>0))
                x=np.log(L[ii,jj,gg]); mode='free_original_measure_flow'
                coordinate_data={'coordinate_indices':np.column_stack((ii,jj,gg)).tolist()}
            starts.append({'run_id':len(starts),'host_id':rec['id'],'coarse_states':m,
                           'fine_states':4*m,'family':rec['family'],'tuple':rec['tuple'],
                           'two_cover_bits':bits,'mode':mode,'initial_vector':x.tolist(),
                           'initial_metrics':met,**coordinate_data})
    dump('optimizer_starts',{'starts':starts,'configuration_sha256':sha(PREFIX+'config.json'),
                             'samples_sha256':sha(PREFIX+'samples.json')})
    print('STARTS_FROZEN',len(starts),sha(PREFIX+'optimizer_starts.json'),flush=True)


def unpack_factory(start):
    m=start['coarse_states']
    if start['mode']=='fixed_uniform_mixture':
        generators=np.array(start['generators'],dtype=float)
        def unpack(x):return np.einsum('a,aijg->ijg',np.exp(x),generators)
        def pullback(x,G):return np.einsum('ijg,aijg->a',G,generators)*np.exp(x)
        return unpack,pullback,(-12,4)
    inds=np.array(start['coordinate_indices'],dtype=int);ii,jj,gg=inds.T
    def unpack(x):
        L=np.zeros((m,m,4));L[ii,jj,gg]=np.exp(x);L[jj,ii,gg]=np.exp(x);return L
    def pullback(x,G):
        out=G[ii,jj,gg]+G[jj,ii,gg];diag=ii==jj;out[diag]*=.5
        return out*np.exp(x)
    return unpack,pullback,(-16,4)


def optimize():
    cfg=read('config'); starts=read('optimizer_starts')['starts']; runs=[];begin=time.time()
    for start in starts:
        unpack,pullback,bounds=unpack_factory(start);tpl=start['tuple'];bits=start['two_cover_bits']
        calls=0;best=None;trace=[]
        def objective(x):
            nonlocal calls,best
            calls+=1;L=unpack(x);v,G,F,Z=one_value_gradient(L,tpl,bits)
            ratio=Z/F**2
            trace.append({'call':calls,'objective':float(v),'F':F,'Z':Z,'ratio':ratio})
            if best is None or v<best['objective']:
                best={'call':calls,'objective':float(v),'vector':x.tolist(),'F':F,'Z':Z,'ratio':ratio}
            return v,pullback(x,G)
        result=minimize(objective,np.array(start['initial_vector']),jac=True,method='L-BFGS-B',
                        bounds=[bounds]*len(start['initial_vector']), options=cfg['optimizer_options'])
        L=unpack(np.array(best['vector']));met=values(L,tpl)
        run={'run_id':start['run_id'],'host_id':start['host_id'],'tuple':tpl,
             'two_cover_bits':bits,'mode':start['mode'],'fine_states':4*start['coarse_states'],
             'L_float':L.tolist(),'best':best,'final_vector':result.x.tolist(),
             'iterations':int(result.nit),'objective_calls':calls,'success':bool(result.success),
             'termination_message':str(result.message),'metrics':met,'objective_trace':trace}
        runs.append(run)
        dump('optimizations',{'runs':runs,'elapsed_seconds':time.time()-begin,
                              'starts_sha256':sha(PREFIX+'optimizer_starts.json')})
        print('OPT',start['run_id'],'n',4*start['coarse_states'],'bits',bits,
              'ratio',best['ratio'],'amplification',-best['objective'],
              'nit',result.nit,'calls',calls,'success',result.success,flush=True)
        if met['F']<cfg['candidate_target_threshold'] or max(v['ratio']for v in met['covers'])>cfg['candidate_cover_ratio_threshold']:
            candidate(run,'optimized');return
    print('OPTIMIZATION_CAP_COMPLETE',len(runs),flush=True)


if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['freeze','sample','freeze_starts','optimize'])
    args=ap.parse_args();globals()[args.mode]()
