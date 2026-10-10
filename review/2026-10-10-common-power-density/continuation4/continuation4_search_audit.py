"""Detached exact admissibility/scope and deterministic replay audit."""
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations
from math import isqrt
import hashlib
import json
from pathlib import Path
import platform
import sys
import time

import numpy as np
import scipy

from continuation4_search_engine import WALSH, fine_flow, values, unpack_factory


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(name):return json.loads(Path('continuation4_search_'+name+'.json').read_text())
def q(x):return Q(int(x))if isinstance(x,(int,np.integer))else Q(float(x))


# Standard-library rational characteristic-polynomial / Euclidean-gcd
# calculation, following the same exact procedure used by the earlier audit.
def mm(A,B):
    n=len(A)
    return [[sum(A[i][k]*B[k][j]for k in range(n))for j in range(n)]for i in range(n)]


def charpoly(A):
    n=len(A);B=[[Q(i==j)for j in range(n)]for i in range(n)];out=[Q(1)]
    for k in range(1,n+1):
        B=mm(A,B);c=-sum(B[i][i]for i in range(n))/k;out.append(c)
        for i in range(n):B[i][i]+=c
    assert all(v==0 for row in B for v in row)
    return out[::-1]


def trim(P):
    P=list(P)
    while len(P)>1 and P[-1]==0:P.pop()
    return P


def pdiv(A,B):
    A=trim(A);B=trim(B);out=[Q(0)]*max(1,len(A)-len(B)+1)
    while len(A)>=len(B)and any(A):
        j=len(A)-len(B);c=A[-1]/B[-1];out[j]=c
        for i in range(len(B)):A[i+j]-=c*B[i]
        A=trim(A)
    return trim(out),A


def pmul(A,B):
    out=[Q(0)]*(len(A)+len(B)-1)
    for i,a in enumerate(A):
        for j,b in enumerate(B):out[i+j]+=a*b
    return trim(out)


def coprime_mod_prime(A,B,prime):
    if any(x.denominator%prime==0 for x in A+B):return False
    aa=[int(x.numerator%prime)*pow(int(x.denominator%prime),-1,prime)%prime for x in A]
    bb=[int(x.numerator%prime)*pow(int(x.denominator%prime),-1,prime)%prime for x in B]
    if not aa[-1]or not bb[-1]:return False
    while any(bb):
        while len(aa)>=len(bb)and any(aa):
            j=len(aa)-len(bb);c=aa[-1]*pow(bb[-1],-1,prime)%prime
            for i in range(len(bb)):aa[i+j]=(aa[i+j]-c*bb[i])%prime
            aa=trim(aa)
        aa,bb=bb,aa
    return len(aa)==1


def pgcd(A,B):
    A=trim(A);B=trim(B)
    if not any(B):return [x/A[-1]for x in A]
    # A good degree-preserving reduction with gcd one certifies gcd one over Q.
    if any(coprime_mod_prime(A,B,p)for p in (1000000007,1000000009)):
        return [Q(1)]
    while any(B):
        _,R=pdiv(A,B);A=B;B=R
        if any(B):B=[x/B[-1]for x in B]
    return [x/A[-1]for x in A]


def distinct_union_degree(polys):
    # Every individual characteristic polynomial has degree at most five.
    # Inclusion/exclusion of their squarefree root sets avoids a degree-19
    # rational Euclidean calculation and is equally exact.
    sf=[]
    for P in polys:
        derivative=[Q(i)*P[i]for i in range(1,len(P))]or[Q(0)]
        squarefree,rem=pdiv(P,pgcd(P,derivative));assert not any(rem)
        sf.append(squarefree)
    total=0;cache={}
    for size in range(1,5):
        for inds in combinations(range(4),size):
            G=sf[inds[0]] if size==1 else pgcd(cache[inds[:-1]],sf[inds[-1]])
            cache[inds]=G
            total+=(-1)**(size+1)*(len(G)-1)
    return total


assert all(p%2 and all(p%d for d in range(3,isqrt(p)+1,2))
           for p in (1000000007,1000000009))
# Squarefree root-set inclusion/exclusion must count a shared zero or one
# once, including a completely zero channel with multiplicity three.
assert distinct_union_degree([[Q(0),Q(0),Q(1)],
                              [Q(-1),Q(2),Q(-1)],
                              [Q(0),Q(-1),Q(1)],
                              [Q(0),Q(0),Q(0),Q(1)]])==2


def exact_scope(raw, bands=True):
    m=len(raw);L=[[[q(x)for x in v]for v in row]for row in raw]
    assert all(L[i][j][g]>=0 and L[i][j][g]==L[j][i][g]
               for i in range(m)for j in range(m)for g in range(4))
    s=[sum(L[i][j][g]for j in range(m)for g in range(4))for i in range(m)]; C=sum(s)
    assert min(s)>0
    pi=[v/C for v in s]; mu=[v/4 for v in pi for _ in range(4)]
    root=[[[4*C*L[i][j][g]/(s[i]*s[j])for g in range(4)]for j in range(m)]for i in range(m)]
    p=1/max(x for row in root for v in row for x in v)
    assert 0<p and all(0<=p*x<=1 for row in root for v in row for x in v)
    assert all(sum(pi[j]*sum(root[i][j])/4 for j in range(m))==1 for i in range(m))
    fourier=[[[sum(int(WALSH[a,g])*L[i][j][g]for g in range(4))/s[i]
               for j in range(m)]for i in range(m)]for a in range(4)]
    squares=[mm(P,P)for P in fourier]
    mins=[min(x for row in squares[a]for x in row)for a in range(1,4)]
    comm=[mm(fourier[a],fourier[b])!=mm(fourier[b],fourier[a])
          for a in range(1,4)for b in range(a+1,4)]
    A=[[[sum(int(WALSH[a,g])*squares[a][i][j]/pi[j]for a in range(4))
          for g in range(4)]for j in range(m)]for i in range(m)]
    assert all(x>=0 for row in A for v in row for x in v)
    maxA=max(x for row in A for v in row for x in v)
    def comps(data):
        unseen=set(range(4*m));counts=[]
        while unseen:
            seed=min(unseen);seen={seed};front=[seed];unseen.remove(seed)
            while front:
                x=front.pop();i,a=divmod(x,4)
                for y in list(unseen):
                    j,b=divmod(y,4)
                    if data[i][j][a^b]>0:unseen.remove(y);seen.add(y);front.append(y)
            counts.append(len(seen))
        return counts
    result={'original_coarse_pi':list(map(str,pi)),'original_fine_mu':list(map(str,mu)),
            'exact_p':str(p),'p_less_than_quarter':p<Q(1,4),'exact_max_A':str(maxA),
            'max_A_greater_than_4':maxA>4,'nonuniform_original_measure':len(set(mu))>1,
            'root_zero_entries':4*sum(x==0 for row in L for v in row for x in v),
            'negative_channel_square_count':sum(x<0 for x in mins),
            'exact_channel_square_minima':list(map(str,mins)),
            'noncommuting_channel_pair_count':sum(comm),'noncommuting_pairs_12_13_23':comm,
            'root_component_sizes':comps(root),'square_component_sizes':comps(A)}
    if bands:
        polys=[charpoly(P)for P in squares]
        polys[0],rem=pdiv(polys[0],[Q(-1),Q(1)]);assert not any(rem)
        result.update({'entire_centered_band_count':distinct_union_degree(polys),
                       'has_centered_zero_band':any(poly[0]==0 for poly in polys),
                       'has_centered_one_band':any(sum(poly)==0 for poly in polys),
                       'centered_zero_multiplicity':sum(next(j for j,v in enumerate(poly)if v)for poly in polys),
                       'centered_dimension':4*m-1})
    return result


cfg=read('config');samples=read('samples');starts=read('optimizer_starts');runs=read('optimizations');begin=time.time()
assert len(cfg['hosts'])==144==len(samples['completed']) and not samples['early_stop']
assert len(starts['starts'])==21==len(runs['runs'])
assert cfg['source_sha256']==sha('continuation4_search_engine.py')
assert cfg['dependency_sha256']==sha('continuation_cover_engine.py')
assert samples['configuration_sha256']==sha('continuation4_search_config.json')
assert starts['configuration_sha256']==sha('continuation4_search_config.json')
assert starts['samples_sha256']==sha('continuation4_search_samples.json')
assert runs['starts_sha256']==sha('continuation4_search_optimizer_starts.json')
sample_audits=[]
for row in samples['completed']:
    rec=cfg['hosts'][row['host_id']]
    assert rec['id']==row['host_id']
    L=np.array(rec['L_integer'])
    replay=values(L,rec['tuple'])
    assert replay==row['metrics']
    audit=exact_scope(rec['L_integer'])
    sample_audits.append({'host_id':rec['id'],'fine_states':rec['fine_states'],
                          'family':rec['family'],'tuple':rec['tuple'],
                          'numeric_replay_identical':True,**audit})

# Reconstruct the exact deterministic start selection from the frozen sample.
start_checks=[]
for start in starts['starts']:
    m=start['coarse_states'];bits=start['two_cover_bits'];eligible=[]
    for row in samples['completed']:
        rec=cfg['hosts'][row['host_id']];met=row['metrics']
        if rec['coarse_states']!=m or met['F']<=1+1e-5:continue
        if not(met['p']<.25 and met['max_A']>4 and met['centered_band_count_numeric']>=3):continue
        if not any(v < -1e-12 for v in met['channel_square_minima']):continue
        if m==5 and rec['family']!='uniform_matchings':continue
        eligible.append((met['covers'][bits-1]['log_amplification'],-rec['id'],rec['id']))
    expected=max(eligible)[:];assert start['host_id']==expected[2]
    rec=cfg['hosts'][start['host_id']]
    unpack,pullback,bounds=unpack_factory(start)
    x=np.array(start['initial_vector']);L=unpack(x)
    if m==5:
        weights=np.array(rec['weights'],dtype=float);weights/=weights.max()
        assert x.tolist()==np.log(weights).tolist()
    else:
        L0=np.array(rec['L_integer'],dtype=float);L0/=L0.max()
        ii,jj,gg=np.array(start['coordinate_indices']).T
        assert x.tolist()==np.log(L0[ii,jj,gg]).tolist()
    start_checks.append({'run_id':start['run_id'],'selected_host_id':start['host_id'],
                         'selection_reconstructed':True,'initial_vector_reconstructed':True})

run_audits=[]
for run in runs['runs']:
    start=starts['starts'][run['run_id']];unpack,_,_=unpack_factory(start)
    L=unpack(np.array(run['best']['vector']))
    assert L.tolist()==run['L_float']
    assert values(L,run['tuple'])==run['metrics']
    trace=run['objective_trace']
    assert len(trace)==run['objective_calls']
    assert all(v['call']==j+1 for j,v in enumerate(trace))
    assert all(v['F']>=cfg['candidate_target_threshold'] and
               v['ratio']<=cfg['candidate_cover_ratio_threshold'] for v in trace)
    earliest=min(trace,key=lambda v:v['objective'])
    assert earliest['call']==run['best']['call'] and earliest['objective']==run['best']['objective']
    assert run['iterations']<=cfg['iterations_per_start']
    scope=exact_scope(run['L_float'])
    run_audits.append({'run_id':run['run_id'],'literal_rounded_flow_scope':scope,
                       'rounded_flow_reconstruction_identical':True,'numeric_replay_identical':True,
                       'objective_trace_count_verified':True,'best_call_verified':True})

uniform=read('uniform_certificates');uniform_audits=[]
assert len(uniform['endpoints'])==7
for ep in uniform['endpoints']:
    scope=exact_scope(ep['flow_integer'])
    assert not scope['nonuniform_original_measure']
    assert scope['original_fine_mu']==['1/20']*20
    cert=ep['exact_certificate']
    assert cert['target_defect_integer']>0 and cert['comparison_integer']<0
    uniform_audits.append({'run_id':ep['run_id'],'authoritative_exact_uniform_scope':scope,
                           'target_strictly_above_1':True,'selected_cover_strictly_below_F2':True})

summary={'samples':len(sample_audits),'sample_covers':7*len(sample_audits),
         'sample_fine_states':dict(Counter(a['fine_states']for a in sample_audits)),
         'sample_families':dict(Counter(a['family']for a in sample_audits)),
         'sample_nonuniform_original_measures':sum(a['nonuniform_original_measure']for a in sample_audits),
         'sample_p_below_quarter':sum(a['p_less_than_quarter']for a in sample_audits),
         'sample_p_below_quarter_and_maxA_above4':sum(a['p_less_than_quarter']and a['max_A_greater_than_4']for a in sample_audits),
         'sample_with_negative_channel_square':sum(a['negative_channel_square_count']>0 for a in sample_audits),
         'sample_with_noncommuting_channels':sum(a['noncommuting_channel_pair_count']>0 for a in sample_audits),
         'sample_with_zero_centered_band':sum(a['has_centered_zero_band']for a in sample_audits),
         'sample_with_three_or_more_entire_centered_bands':sum(a['entire_centered_band_count']>=3 for a in sample_audits),
         'sample_entire_centered_band_counts':dict(Counter(a['entire_centered_band_count']for a in sample_audits)),
         'sample_disconnected_roots':sum(len(a['root_component_sizes'])>1 for a in sample_audits),
         'sample_disconnected_squares':sum(len(a['square_component_sizes'])>1 for a in sample_audits),
         'sample_roots_with_zero_entries':sum(a['root_zero_entries']>0 for a in sample_audits),
         'optimization_starts':len(run_audits),'optimization_iterations':sum(a['iterations']for a in runs['runs']),
         'optimization_objective_calls':sum(a['objective_calls']for a in runs['runs']),
         'optimization_termination_counts':dict(Counter(a['termination_message']for a in runs['runs'])),
         'optimized_retained_points_all_cover_evaluations':7*len(run_audits),
         'exact_uniform_endpoint_certificates':len(uniform_audits),
         'sample_min_F':min(a['metrics']['F']for a in samples['completed']),
         'sample_max_cover_ratio_float':max(c['ratio']for a in samples['completed']for c in a['metrics']['covers']),
         'optimization_min_retained_F':min(a['metrics']['F']for a in runs['runs']),
         'optimization_max_retained_cover_ratio':max(c['ratio']for a in runs['runs']for c in a['metrics']['covers'])}
summary.update({'optimization_max_objective_trace_cover_ratio':max(v['ratio']for a in runs['runs']for v in a['objective_trace']),
                'optimization_min_objective_trace_F':min(v['F']for a in runs['runs']for v in a['objective_trace']),
                'optimization_distinct_starting_host_ids':sorted({a['host_id']for a in runs['runs']}),
                'optimization_literal_flows_p_below_quarter':sum(a['literal_rounded_flow_scope']['p_less_than_quarter']for a in run_audits),
                'optimization_literal_flows_p_below_quarter_and_maxA_above4':sum(a['literal_rounded_flow_scope']['p_less_than_quarter']and a['literal_rounded_flow_scope']['max_A_greater_than_4']for a in run_audits)})
payload={'summary':summary,'sample_audits':sample_audits,'start_checks':start_checks,
         'optimization_audits':run_audits,'uniform_endpoint_audits':uniform_audits,
         'elapsed_seconds':time.time()-begin,'runtime':{'Python':platform.python_version(),
           'NumPy':np.__version__,'SciPy':scipy.__version__},
         'source_sha256':sha(__file__),'input_sha256':{p:sha(p)for p in (
           'continuation4_search_engine.py','continuation_cover_engine.py',
           'continuation4_search_config.json','continuation4_search_samples.json',
           'continuation4_search_optimizer_starts.json','continuation4_search_optimizations.json',
           'continuation4_search_uniform_certificates.json')}}
Path('continuation4_search_audit.json').write_text(json.dumps(payload,indent=2)+'\n')
print(json.dumps(summary,indent=2),flush=True)
