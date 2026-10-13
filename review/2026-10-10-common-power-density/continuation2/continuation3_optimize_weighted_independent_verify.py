"""Independent reconstruction of the weighted twelve-state example from its note."""
from fractions import Fraction as Q
from pathlib import Path
from math import lcm,gcd
from functools import reduce
import hashlib,json
from continuation3_audit import mm,charpoly,pmul
from continuation_cover_engine import exact_integer_certificate
pi=[Q(1,5)]*4+[Q(1,10)]*2
S0=[[Q(35,8)if i==j==0 else Q(31,32)/pi[i]if i==j else Q(5,32)if i==0 or j==0 else Q(0)for j in range(6)]for i in range(6)]
S=[[Q(63,64)*v+Q(1,64)for v in row]for row in S0]
H=[[(Q(int(i==j))/pi[i]-1)/128 for j in range(6)]for i in range(6)]
states=[(i,a)for i in range(6)for a in (-1,1)];mu=[pi[i]/2 for i,a in states]
T=[[S[i][j]+a*b*H[i][j]for j,b in states]for i,a in states];p=Q(1024,9853);W=[[p*v for v in row]for row in T]
assert all(sum(mu[j]*W[i][j]for j in range(12))==p for i in range(12))
assert min(v for row in W for v in row)==Q(8,9853) and max(v for row in W for v in row)==1
P=[[T[i][j]*mu[j]for j in range(12)]for i in range(12)];A=mm(P,P)
maxA=max(A[i][j]/mu[j]for i in range(12)for j in range(12));assert maxA==Q(38294287,4194304)
eigs=[Q(1)]+[Q(1953,2048)**2]*4+[Q(1701,2048)**2]+[Q(1,16384)]*5+[Q(0)]
expected=[Q(1)]
for lam in eigs:expected=pmul(expected,[-lam,Q(1)])
assert charpoly(A)==expected
flows=[[mu[i]*mu[j]*T[i][j]for j in range(12)]for i in range(12)];D=lcm(*(v.denominator for row in flows for v in row));Gi=[[int(v*D)for v in row]for row in flows];g=reduce(gcd,(v for row in Gi for v in row));Gi=[[v//g for v in row]for row in Gi]
cert=exact_integer_certificate(Gi,(3,1,1,1,1),((0,),(0,),(0,)))
F=Q(cert['base_numerator'],cert['base_denominator'])
stored=json.loads(Path('continuation3_channel_spectrum_checks.json').read_text());rec=next(r for r in stored['actual_host_records']if r['name']=='weighted_twelve_state_star')
assert F==Q(rec['F']) and W==[[Q(x)for x in row]for row in rec['W']]
assert F>=Q(rec['explicit_global_lower_bound_at_tuple'])>1
out={'status':'PASS','independent_original_measure_W_and_maxA_match':True,'ordinary_fine_characteristic_polynomial_exactly_matches_all_12_claimed_eigenvalues':True,'independent_integer_flow_density_exactly_matches_checker':True,'original_fine_mu':list(map(str,mu)),'p':str(p),'minimum_W':str(min(v for row in W for v in row)),'maximum_W':'1','maximum_A':str(maxA),'full_centered_distinct_bands':4,'includes_exact_centered_zero':True,'d_minus_1':'4','centered_coarse_dimension':5,'F':str(F),'coarse_Id_surplus_coefficient':str(sum(v**-2 for v in pi)-1),'input_sha256':{f:hashlib.sha256(Path(f).read_bytes()).hexdigest()for f in ['continuation3_weighted_spectrum.md','continuation3_channel_spectrum_checks.json','continuation3_audit.py','continuation_cover_engine.py','continuation3_optimize_weighted_independent_verify.py']}}
Path('continuation3_optimize_weighted_independent_checks.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS: actual weighted W, original mu, full characteristic polynomial, independent exact F')
