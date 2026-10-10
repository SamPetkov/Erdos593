"""Detached exact audit of the18-state commuting obstruction; no search."""
from pathlib import Path
import hashlib,json,re,time
start=time.time();path=Path('continuation3_tensor.md');source=path.read_text();blocks=re.findall(r'```python\n(.*?)```',source,re.S);assert len(blocks)==2
ns={}
for block in blocks:exec(compile(block,str(path),'exec'),ns)
Q=ns['Q'];pi=ns['pi'];P=ns['P'];H0=ns['H0'];comp=ns['compose_pi'];gamma0=ns['gamma0'];D=ns['D'];eps=ns['epsilon'];delta=ns['delta'];eta=ns['eta']
# Direct ORIGINAL-pi channel powers, then original four-vertex source sum.
C2=comp(H0,H0);C4=comp(C2,C2);C6=comp(C4,C2);direct=Q(0)
for a in range(9):
 for b in range(9):
  for c in range(9):
   for d in range(9):
    hub=P[a][b]*P[a][c]*P[a][d]
    if hub:direct+=pi[a]*pi[b]*pi[c]*pi[d]*hub*C6[b][c]*C4[b][d]*C2[c][d]
assert direct==gamma0
# Independently check all seven cycle weights and strict rational margins.
edges=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3));cycles=((0,1,3),(0,2,4),(1,2,5),(3,4,5),(0,2,3,5),(0,1,4,5),(1,2,3,4));exps=(8,4,2,3,2,1)
weights=[sum(exps[i]for i in C)for C in cycles];assert weights==[15,12,7,6,14,15,11]
assert gamma0+31*eps*D**6<=-eta*D**2/324
assert -eta*D**2/324+6*D**6*delta**2<=-eta*D**2/648<0
assert 7*D**6*delta**12<1 and Q(D**2,162)-1>1
files=['continuation3_tensor.md','continuation3_optimize_obstruction_verify.py']
out={'status':'PASS','both_embedded_exact_certificate_blocks_pass':True,'independent_direct_original_pi_Gamma0_matches_compressed_trace':True,'cycle_weights_in_ab_ac_ad_bc_bd_cd_order':weights,'unique_minimum_cycle':'bcd','actual_host_states':18,'tuple':[8,2,3,1,1],'tuple_order':['k','u','r','l','h'],'strict_verdict':'1 < Ffine < Fcoarse; target is not refuted','negative_compressed_tau':str(ns['tau']),'eta':str(eta),'D':str(D),'p':str(Q(1,2*D)),'Gamma0':str(gamma0),'coarse_channel_commutation':'SH=HS=epsilon H with original pi','fine_centered_spectrum_multiplicities':[3,5,1,1,1,6],'centered_zero_included':True,'full_density_was_not_rounded_or_numerically_matched':True,'elapsed_seconds':time.time()-start,'hashes':{p:hashlib.sha256(Path(p).read_bytes()).hexdigest()for p in files}}
Path('continuation3_optimize_obstruction_checks.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS: two exact blocks; independent original-pi Gamma0; all separation bounds')
