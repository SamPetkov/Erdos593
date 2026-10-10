"""Post-run provenance/admissibility audit; matching floats is not proof."""
from collections import Counter
from fractions import Fraction as Q
from pathlib import Path
import hashlib,json
import numpy as np
import scipy
from continuation4_cover_search import coef
from continuation_cover_engine import validate_tuple


def exact_host(G):
    G=[[Q(x) for x in row] for row in G];n=len(G)
    assert G and all(len(row)==n for row in G)
    assert all(G[i][j]==G[j][i]>=0 for i in range(n) for j in range(n))
    s=[sum(row) for row in G];assert all(x>0 for x in s)
    z=sum(s);mu=[x/z for x in s]
    T=[[z*G[i][j]/(s[i]*s[j]) for j in range(n)] for i in range(n)]
    assert all(sum(mu[j]*T[i][j] for j in range(n))==1 for i in range(n))
    p=1/max(x for row in T for x in row)
    A=[[sum(mu[t]*T[i][t]*T[t][j] for t in range(n)) for j in range(n)] for i in range(n)]
    return {'p':str(p),'p_below_one_quarter':p<Q(1,4),'max_square_entry_above_four':max(x for row in A for x in row)>4,
            'mu':list(map(str,mu)),'original_root_zeros':sum(x==0 for row in G for x in row)}

samples=json.load(open('continuation4_cover_samples.json'))['samples']
optim=json.load(open('continuation4_cover_optimizations.json'))['runs']
assert len(samples)==252 and Counter(s['n'] for s in samples)=={3:84,4:84,5:84}
assert len(optim)==12 and Counter(s['n'] for s in optim)=={3:4,4:4,5:4}
assert len({(s['n'],s['index']) for s in samples})==252
seed_audits=[];opt_audits=[]
for category,items,out in [('sample',samples,seed_audits),('optimization',optim,opt_audits)]:
    for row in items:
        validate_tuple(row['tuple']);assert isinstance(row['cycle'],int) and 0<=row['cycle']<7
        G=np.array(row['flow'],float);assert np.array_equal(G,G.T) and np.isfinite(G).all()
        if category=='sample':assert all(isinstance(x,int) and not isinstance(x,bool) for r in row['flow'] for x in r)
        else:assert np.min(G)>0 and row['iterations']<=60
        # Independent exact rational flow normalization establishes admissibility
        # for the stored seeds, or the exact dyadics represented by stored floats.
        exact=exact_host(row['flow'])
        s,a,_=coef(G,row['tuple'],row['cycle']);ratio=s/a if a else 1
        assert abs(ratio-row['ratio'])<1e-10
        assert abs(s-row['coefficient'])<1e-11*max(abs(s),abs(row['coefficient']),1e-100)
        assert abs(a-row['absolute_sum'])<1e-11*max(a,row['absolute_sum'],1e-100)
        record={'n':row['n'],'index':row.get('index',row.get('run')),'cycle':row['cycle'],'tuple':row['tuple'],'exact_host':exact,
                'recomputed_floating_ratio':ratio,'finite_exact_source':category=='sample'}
        out.append(record)
files=['continuation4_cover_search.py','continuation4_cover_samples.json','continuation4_cover_optimizations.json','continuation_cover_engine.py']
manifest={f:{'bytes':Path(f).stat().st_size,'sha256':hashlib.sha256(Path(f).read_bytes()).hexdigest()} for f in files}
summary={'status':'all stored hosts exactly admissible; scores are floating diagnostics only','seed':2026101401,
         'samples':len(samples),'one_tuple_and_one_cycle_per_sample':True,'starts':len(optim),'maximum_iterations_per_start':60,
         'total_iterations':sum(x['iterations'] for x in optim),'total_optimizer_calls':sum(x['calls'] for x in optim),
         'optimizer_successes':sum(x['success'] for x in optim),'optimizer_status_counts':dict(Counter(x['message'] for x in optim)),
         'sample_minimum_ratio':min(x['ratio'] for x in samples),'optimized_minimum_ratio':min(x['ratio'] for x in optim),
         'negative_sample_or_optimized_cycle_candidates':sum(x['ratio']<0 for x in samples+optim),
         'sample_p_below_one_quarter':sum(x['exact_host']['p_below_one_quarter'] for x in seed_audits),
         'sample_p_below_quarter_and_max_square_above_four':sum(x['exact_host']['p_below_one_quarter'] and x['exact_host']['max_square_entry_above_four'] for x in seed_audits),
         'optimized_p_below_one_quarter':sum(x['exact_host']['p_below_one_quarter'] for x in opt_audits),
         'samples_with_root_zeros':sum(x['exact_host']['original_root_zeros']>0 for x in seed_audits),
         'libraries':{'numpy':np.__version__,'scipy':scipy.__version__},'manifest':manifest,
         'interpretation':'Only canonical individual-cycle coefficients were searched. This run did not search complete two-cover or target defects. No sign theorem follows from absence of a negative coefficient. The starting_ratio optimization field is the score of its selected exact integer seed; zeros in that seed were replaced by 1e-4 before logarithms, and the optimizer enforced the stated [-9,9] bounds.'}
Path('continuation4_cover_audit.json').write_text(json.dumps({'summary':summary,'samples':seed_audits,'optimizations':opt_audits},indent=2)+'\n')
print(json.dumps(summary,indent=2))
