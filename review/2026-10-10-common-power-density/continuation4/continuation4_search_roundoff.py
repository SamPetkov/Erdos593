"""Resolve every above-one binary64 cover ratio in the frozen sample exactly."""
from fractions import Fraction as Q
from decimal import Decimal, localcontext
import hashlib
import json
from pathlib import Path
import sys

import numpy as np

from continuation4_search_engine import fine_flow, KEYS
from continuation_cover_engine import exact_integer_certificate

sys.set_int_max_str_digits(0)
cfg=json.loads(Path('continuation4_search_config.json').read_text())
samples=json.loads(Path('continuation4_search_samples.json').read_text())['completed']
records=[]
for sample in samples:
    for cover in sample['metrics']['covers']:
        if cover['ratio']<=1:
            continue
        rec=cfg['hosts'][sample['host_id']]
        G=fine_flow(np.array(rec['L_integer'],dtype=int))
        s=[int(x)for x in G.sum(1)]; C=sum(s); n=len(s)
        mu=[Q(x,C)for x in s]
        T=[[Q(C*int(G[i,j]),s[i]*s[j])for j in range(n)]for i in range(n)]
        p=1/max(x for row in T for x in row); W=[[p*x for x in row]for row in T]
        assert all(0<=x<=1 for row in W for x in row)
        assert all(sum(mu[j]*W[i][j]for j in range(n))==p for i in range(n))
        bits=cover['bits_bc_bd_cd']
        cert=exact_integer_certificate(G.tolist(),rec['tuple'],KEYS[bits])
        F=Q(cert['base_numerator'],cert['base_denominator'])
        Z=Q(cert['cover_numerator'],cert['cover_denominator'])
        with localcontext()as ctx:
            ctx.prec=50
            f=F-1; q=Z/(F*F)-1
            scale={'F_minus_1':str(Decimal(f.numerator)/Decimal(f.denominator)),
                   'Z_over_F2_minus_1':str(Decimal(q.numerator)/Decimal(q.denominator))}
        records.append({'host_id':rec['id'],'L_integer':rec['L_integer'],
                        'original_mu':list(map(str,mu)),'p':str(p),
                        'W':[[str(x)for x in row]for row in W],
                        'tuple':rec['tuple'],'two_cover_bits':bits,
                        'binary64_record':cover,'exact_certificate':cert,
                        'exact_F':str(F),'exact_Z':str(Z),'decimal_scale_only':scale})
        print('EXACT',rec['id'],bits,'target_violation',cert['target_violation'],
              'cover_violation',cert['cover_violation'],scale,flush=True)
out={'records':records,'all_sample_ratios_strictly_above_one_resolved':True,
     'configuration_sha256':hashlib.sha256(Path('continuation4_search_config.json').read_bytes()).hexdigest(),
     'samples_sha256':hashlib.sha256(Path('continuation4_search_samples.json').read_bytes()).hexdigest(),
     'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
Path('continuation4_search_roundoff.json').write_text(json.dumps(out,indent=2)+'\n')
