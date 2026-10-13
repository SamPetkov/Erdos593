"""Exact certificates for the seven fixed-uniform generator endpoints.

The positive binary64 generator weights are interpreted as exact dyadics.
Their rational sum, rather than a rounded floating-point sum of flow entries,
is the authoritative uniform host.  Rounded-flow results remain archived
separately as numerical diagnostics of admissible, slightly nonuniform roots.
"""
from decimal import Decimal, localcontext
from fractions import Fraction as Q
from functools import reduce
from math import gcd, lcm
import hashlib
import json
from pathlib import Path
import sys
import time

import numpy as np

from continuation4_search_engine import KEYS, fine_flow, values
from continuation_cover_engine import exact_integer_certificate

sys.set_int_max_str_digits(0)
starts=json.loads(Path('continuation4_search_optimizer_starts.json').read_text())['starts']
runs=json.loads(Path('continuation4_search_optimizations.json').read_text())['runs']
out=[];begin=time.time()
for run in runs:
    if run['mode']!='fixed_uniform_mixture':continue
    start=starts[run['run_id']]
    coeff_float=np.exp(np.array(run['best']['vector'],dtype=float))
    coeff=[Q(float(x))for x in coeff_float]
    denominator=lcm(*(x.denominator for x in coeff))
    integers=[int(x*denominator)for x in coeff]
    generators=np.array(start['generators'],dtype=object)
    L=np.zeros(generators.shape[1:],dtype=object)
    for weight,generator in zip(integers,generators):L+=weight*generator
    common=reduce(gcd,(int(x)for x in L.flat)); L=np.array([[list(map(lambda x:int(x)//common,v))for v in row]for row in L],dtype=object)
    G=fine_flow(L);row_sums=[int(x)for x in G.sum(1)]
    assert len(set(row_sums))==1
    n=len(G);row=row_sums[0]
    p=Q(row,n*max(int(x)for x in G.flat))
    max_rounding=Q(0)
    for i in range(len(L)):
        for j in range(len(L)):
            for g in range(4):
                exact=Q(int(L[i,j,g])*common,denominator)
                rounded=Q(run['L_float'][i][j][g])
                max_rounding=max(max_rounding,abs(exact-rounded))
    assert max_rounding <= Q(1,2**42)*max(coeff)
    bits=run['two_cover_bits']
    cert=exact_integer_certificate(G.tolist(),run['tuple'],KEYS[bits])
    F=Q(cert['base_numerator'],cert['base_denominator'])
    Z=Q(cert['cover_numerator'],cert['cover_denominator'])
    with localcontext()as ctx:
        ctx.prec=50
        fd=F-1;gap=1-Z/(F*F)
        scale={'F_minus_1':str(Decimal(fd.numerator)/Decimal(fd.denominator)),
               'one_minus_Z_over_F2':str(Decimal(gap.numerator)/Decimal(gap.denominator))}
    entry={'run_id':run['run_id'],'source_host_id':run['host_id'],
           'tuple':run['tuple'],'two_cover_bits':bits,'original_mu':str(Q(1,n)),
           'positive_generator_weights_dyadic':list(map(str,coeff)),
           'generators':start['generators'],'flow_integer':L.tolist(),
           'integer_flow_scale':str(Q(common,denominator)),
           'max_rounded_entry_discrepancy':str(max_rounding),
           'p':str(p),'W_definition':'W_ij = flow_fine_ij / max(flow_fine)',
           'exact_certificate':cert,'decimal_scale_only':scale}
    out.append(entry)
    payload={'endpoints':out,'elapsed_seconds':time.time()-begin,
             'starts_sha256':hashlib.sha256(Path('continuation4_search_optimizer_starts.json').read_bytes()).hexdigest(),
             'optimizations_sha256':hashlib.sha256(Path('continuation4_search_optimizations.json').read_bytes()).hexdigest(),
             'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    Path('continuation4_search_uniform_certificates.json').write_text(json.dumps(payload,indent=2)+'\n')
    print('UNIFORM_EXACT',run['run_id'],'cover_violation',cert['cover_violation'],
          'target_violation',cert['target_violation'],scale,flush=True)
