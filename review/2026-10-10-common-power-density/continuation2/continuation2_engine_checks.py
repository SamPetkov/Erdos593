"""Fixed checks only; no search coverage is added by this verifier."""
import json,time
from fractions import Fraction
from math import lcm
import numpy as np
from continuation2_sign_engine import (CUBE,STAR_VALUES,STARS,law_data,actual_root,
 base_poly,cover_poly,defect_poly,evaluate,exact_certificate,color_records,boundary_float)
from continuation_cover_engine import value_gradient,exact_integer_certificate

start=time.time();out=[]
t=tuple(map(Fraction,['1/2','1/2','1/2','-1/2']))
ld=law_data(t);states=ld['states'];mu=np.array(ld['mu_numerators'])/ld['mu_denominator']
phi=np.column_stack((np.ones(len(mu)),states));tensor=np.einsum('x,xi,xj,xk->ijk',mu,phi,phi,phi)
expected=np.zeros((7,7,7));expected[0,0,0]=1
for i in range(1,7):expected[0,i,i]=expected[i,0,i]=expected[i,i,0]=1
from itertools import permutations
for v,s in enumerate(STARS):
 for ids in permutations(tuple(i+1 for i in s)):expected[ids]=float(t[v])
assert np.array_equal(phi.T@(mu[:,None]*phi),np.eye(7));assert np.array_equal(tensor,expected)
out.append({'check':'original_measure_orthonormality_and_cubic_tensor','states':len(mu),'nonzero_tensor_entries':int(np.count_nonzero(tensor)),'exact_binary_arithmetic_equal':True})
# Three active modes retain a nontrivial cubic star; aggregate only kernel-identical
# states, summing their ORIGINAL masses. Reference is independent state contraction.
lam=tuple(map(Fraction,['3/25','-1/5','17/100','0','0','0']));active=[0,1,2]
unique,inverse=np.unique(states[:,active],axis=0,return_inverse=True)
nums=[sum(ld['mu_numerators'][i]for i in range(len(states))if inverse[i]==j)for j in range(len(unique))]
muf=[Fraction(v,ld['mu_denominator'])for v in nums]
Hr=[[muf[i]*muf[j]*(1+sum(lam[a]*int(unique[i,a])*int(unique[j,a])for a in active))for j in range(len(unique))]for i in range(len(unique))]
HD=lcm(*(x.denominator for row in Hr for x in row));Hi=[[int(x*HD)for x in row]for row in Hr];H=np.array(Hi,dtype=float)
tpl=(2,1,2,1,1);Fref=value_gradient(H,tpl,((0,),(0,),(0,)))[0];F=float(evaluate(base_poly(tpl),tuple(map(float,t)),tuple(map(float,lam)))[0]);assert abs(F-Fref)<1e-12
for bits in range(1,8):
 key=tuple((1,0)if (bits>>e)&1 else(0,1)for e in range(3))
 zref=value_gradient(H,tpl,key)[0];z=float(evaluate(cover_poly(tpl,bits),tuple(map(float,t)),tuple(map(float,lam)))[0]);d=float(evaluate(defect_poly(tpl,bits),tuple(map(float,t)),tuple(map(float,lam)))[0])
 assert abs(z-zref)<1e-12;assert abs(F*F-z-d)<1e-12
 out.append({'check':'state_contraction','bits':bits,'states':len(unique),'absolute_cover_error':abs(z-zref),'base_error':abs(F-Fref)})
# Exact rational equivalence against the independent ordinary-Markov-power engine.
key=((1,0),(0,1),(0,1));c=exact_certificate(t,lam,tpl,1);r=exact_integer_certificate(Hi,tpl,key)
assert Fraction(c['base_numerator'],c['base_denominator'])==Fraction(r['base_numerator'],r['base_denominator'])
assert Fraction(c['cover_numerator'],c['cover_denominator'])==Fraction(r['cover_numerator'],r['cover_denominator'])
out.append({'check':'exact_integer_reference','base_equal':True,'two_cover_equal':True,'target_violation':c['target_violation'],'cover_violation':c['cover_violation']})
raw=np.array([.08,-.2,.17,.11,.05,.03]);lamf,J,_=boundary_float(raw,ld['products'],True)
poly=defect_poly((3,2,3,2,1),3);val,g,scale=evaluate(poly,tuple(map(float,t)),tuple(lamf),True)
direction=np.array([.3,-.1,.2,-.2,.4,.1]);eps=1e-6
fp=evaluate(poly,tuple(map(float,t)),tuple(boundary_float(raw+eps*direction,ld['products'])[0]))[0]
fm=evaluate(poly,tuple(map(float,t)),tuple(boundary_float(raw-eps*direction,ld['products'])[0]))[0]
fd=(fp-fm)/(2*eps);an=float(g[4:]@J@direction);err=abs(fd-an)/(1e-30+abs(fd)+abs(an));assert err<1e-7
out.append({'check':'boundary_gradient','relative_error':err})
for bits in [None,1,2,3,4,5,6,7]:
 a,b,ch,n=color_records(bits);out.append({'check':'color_registry','bits':bits,'free_chords':ch,'assignments':n,'valid_assignments':len(a)})
with open('continuation2_engine_checks.json','w')as f:json.dump({'checks':out,'seconds':time.time()-start,'all_passed':True,'adds_search_coverage':False},f,indent=2)
print(json.dumps({'all_passed':True,'checks':len(out),'seconds':time.time()-start,'boundary_gradient_relative_error':err}),flush=True)
