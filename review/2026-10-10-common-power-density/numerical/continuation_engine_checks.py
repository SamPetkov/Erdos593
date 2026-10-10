import json,time
from fractions import Fraction
import numpy as np
from continuation_host_helpers import random_H
from continuation_cover_engine import value_gradient,cover_registry,boundary_project,boundary_pullback,exact_integer_certificate,root_data

def cover_value(H,tpl,perms):
    # Independent contraction: eliminate the a-copies simultaneously first.
    data=root_data(H,tpl);mu=data['mu'];Ks=data['Ks'];M=len(perms[0])
    source=np.einsum('a,ab,ac,ad->bcd',mu,*Ks[:3],optimize=True)
    source*=mu[:,None,None]*mu[None,:,None]*mu[None,None,:]
    F=float(np.einsum('bcd,bc,bd,cd->',source,*Ks[3:],optimize=True));args=[]
    for s in range(M):args.extend([source,[3*s,3*s+1,3*s+2]])
    for e,(a,b)in enumerate([(0,1),(0,2),(1,2)]):
        for s in range(M):args.extend([Ks[e+3],[3*s+a,3*perms[e][s]+b]])
    args.append([])
    return F,float(np.einsum(*args,optimize='greedy')),data['theta']

rng=np.random.default_rng(10261010);results=[]
for n,key,tpl in [(3,((1,2,0),(2,0,1),(1,0,2)),(2,1,2,1,1)),
                  (4,((1,2,3,0),(1,0,3,2),(0,2,1,3)),(1,1,1,1,1))]:
    H=random_H(rng,n,'dense');oldF,oldZ,_=cover_value(H,tpl,key);Z,G,data,w=value_gradient(H,tpl,key,True)
    D=rng.normal(size=(n,n));D=(D+D.T)/2;D/=np.linalg.norm(D);eps=1e-7
    zp=value_gradient(H+eps*D,tpl,key)[0];zm=value_gradient(H-eps*D,tpl,key)[0];fd=(zp-zm)/(2*eps);an=float(np.sum(G*D))
    record={'n':n,'M':len(key[0]),'width':w,'legacy_value':oldZ,'new_value':Z,'relative_value_error':abs(Z-oldZ)/(1+abs(Z)),
            'gradient_fd':fd,'gradient_analytic':an,'relative_gradient_error':abs(fd-an)/(1+abs(an))}
    assert record['relative_value_error']<1e-10;assert record['relative_gradient_error']<1e-5
    Hb,cache=boundary_project(H);Zb,Gb,_,_=value_gradient(Hb,tpl,key,True);Gback=boundary_pullback(H,cache,Gb)
    zp=value_gradient(boundary_project(H+eps*D)[0],tpl,key)[0];zm=value_gradient(boundary_project(H-eps*D)[0],tpl,key)[0]
    fd=(zp-zm)/(2*eps);an=float(np.sum(Gback*D));record['boundary_gradient_error']=abs(fd-an)/(1+abs(an))
    assert record['boundary_gradient_error']<1e-5;results.append(record);print('CHECK',json.dumps(record),flush=True)
for M in [3,4]:
    start=time.time();reg=cover_registry(M);row={'M':M,'connected_switch_classes':len(reg),'widths':sorted(set(r['width']for r in reg)),'seconds':time.time()-start}
    print('REGISTRY',json.dumps(row),flush=True)
    with open(f'continuation_cover_registry_M{M}.json','w')as f:json.dump(reg,f,indent=2)
    results.append(row)
key=((1,2,0),(2,0,1),(1,0,2));tpl=(1,1,1,1,1)
for label,H in [('independent',np.outer([1,2,3],[1,2,3])),('identity',np.diag([1,2,3]))]:
    c=exact_integer_certificate(H,tpl,key)
    if label=='independent':assert c['base_numerator']==c['base_denominator'];assert c['comparison_integer']==0
    else:assert c['base_numerator']==49*c['base_denominator'];assert c['cover_numerator']==47449*c['cover_denominator'];assert c['comparison_integer']<0
    assert not c['target_violation'];assert not c['cover_violation']
    assert c['target_defect_integer']==c['base_numerator']-c['base_denominator']
    row={'exact_case':label,'comparison_sign':int(c['comparison_integer']>0)-int(c['comparison_integer']<0),'numerator_digits':len(str(c['cover_numerator']))}
    results.append(row);print('EXACT_CHECK',json.dumps(row),flush=True)

def must_reject(call):
    try:call()
    except ValueError:return
    raise AssertionError('invalid input was accepted')

H=np.eye(3,dtype=int);rejections=0
bad_tuples=[(),(1,1,1,1),(1,1,1,1,1,1),(1.,1,1,1,1),(1.5,1,1,1,1),
            (True,1,1,1,1),('1',1,1,1,1),(1,2,1,1,1),(1,1,1,2,1),
            (1,0,1,1,1),(1,1,1,0,1),(1,1,1,1,0),(1,1,1,1,-1)]
for bad in bad_tuples:
    must_reject(lambda:root_data(H,bad));must_reject(lambda:exact_integer_certificate(H,bad,key));rejections+=2
bad_covers=[(),((0,),),((0,),)*4,((),(),()),((0,1),(0,1),(0,)),
            ((0,0),(0,1),(0,1)),((0,2),(0,1),(0,1)),((-1,1),(0,1),(0,1)),
            ((0.,1.),(0,1),(0,1)),((False,True),(0,1),(0,1)),
            (('0','1'),(0,1),(0,1))]
for bad in bad_covers:
    must_reject(lambda:value_gradient(H,tpl,bad));must_reject(lambda:exact_integer_certificate(H,tpl,bad));rejections+=2
for bad_H in [np.ones((2,3),dtype=int),np.array([[1,0],[0,0]]),np.array([[1,-1],[-1,2]]),
              np.array([[1,1],[0,1]]),np.eye(3,dtype=float)]:
    must_reject(lambda:exact_integer_certificate(bad_H,tpl,key));rejections+=1
numpy_tpl=np.array(tpl,dtype=np.int64);numpy_key=np.array(key,dtype=np.int64)
root_data(H,numpy_tpl);c=exact_integer_certificate(H,numpy_tpl,numpy_key)
assert not c['target_violation'] and not c['cover_violation']
row={'input_validation':'passed','rejected_calls':rejections,'invalid_tuple_cases':len(bad_tuples),
     'invalid_cover_cases':len(bad_covers),'invalid_exact_host_cases':5,'numpy_integer_inputs_accepted':True}
results.append(row);print('INPUT_CHECKS',json.dumps(row),flush=True)
with open('continuation_roundoff_certificate.json')as f:roundoff=json.load(f)
c=exact_integer_certificate(roundoff['H_integer'],roundoff['tuple'],roundoff['perms_bc_bd_cd'])
assert c==roundoff['exact_certificate']
assert c['target_defect_integer']>0 and c['comparison_integer']<0
mu=list(map(Fraction,roundoff['original_mu']));p=Fraction(roundoff['p'])
W=[[Fraction(v)for v in row]for row in roundoff['W']];s=list(map(sum,roundoff['H_integer']));C=sum(s)
assert sum(mu)==1 and all(v>0 for v in mu) and p>0
for i in range(len(mu)):
    assert mu[i]==Fraction(s[i],C)
    assert sum(mu[j]*W[i][j]for j in range(len(mu)))==p
    for j in range(len(mu)):
        assert 0<=W[i][j]<=1 and W[i][j]==W[j][i]
        assert W[i][j]==p*Fraction(C*roundoff['H_integer'][i][j],s[i]*s[j])
row={'exact_case':'sample_roundoff_maximum','stored_certificate_exact_equal':True,
     'target_defect_sign':1,'cover_comparison_sign':-1,'original_mu_and_W_admissibility':'checked exactly'}
results.append(row);print('ROUNDOFF_CERTIFICATE',json.dumps(row),flush=True)
with open('continuation_engine_checks.json','w')as f:json.dump(results,f,indent=2)
print('ALL_CHECKS_PASSED',flush=True)
