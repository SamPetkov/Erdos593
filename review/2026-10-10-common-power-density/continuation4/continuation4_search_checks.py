"""Independent exact and finite-difference checks of the four-state search."""
from fractions import Fraction as Q
from itertools import product
import hashlib
import json
from pathlib import Path

import numpy as np

from continuation_cover_engine import contract_cover, exact_integer_certificate
from continuation4_search_engine import (
    BASE, KEYS, WALSH, fine_flow, one_value_gradient, unpack_factory,
    validate_L, values,
)


def kernel_power(T, mu, exponent):
    n=len(mu); P=T*np.array(mu,dtype=object)[None,:]
    return np.linalg.matrix_power(P, exponent)/np.array(mu,dtype=object)[None,:]


L=np.array([[[5,1,0,2],[1,3,2,0]],[[1,3,2,0],[0,4,1,7]]],dtype=int)
G=fine_flow(L); n=len(G); rows=[int(x)for x in G.sum(1)]; C=sum(rows)
mu=[Q(s,C)for s in rows]
T=np.array([[Q(C*int(G[i,j]),rows[i]*rows[j])for j in range(n)]for i in range(n)],dtype=object)
p=1/max(T.flat); W=p*T
assert all(0<=x<=1 for x in W.flat)
assert all(sum(mu[j]*W[i,j]for j in range(n))==p for i in range(n))
assert all(sum(mu[j]*T[i,j]for j in range(n))==1 for i in range(n))
tpl=(1,1,1,1,1); exps=(1,2,1,1,1,1)
Ks=[kernel_power(T,mu,2*e)for e in exps]
E=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))

# A direct four-vertex sum with the original probabilities.
F=Q(0)
for x in product(range(n),repeat=4):
    term=Q(1)
    for v in x:term*=mu[v]
    for K,(a,b)in zip(Ks,E):term*=K[x[a],x[b]]
    F+=term

# Independent six switched-edge formulas.  H is the actual five-edge
# diamond source, integrated only over its two missing vertices.
edge_bits=(3,5,6,1,2,4); exact_covers={}
for omitted,(a,b)in enumerate(E):
    inner=[v for v in range(4)if v not in (a,b)]
    H=np.empty((n,n),dtype=object)
    for xx,yy in product(range(n),repeat=2):
        total=Q(0)
        for zz,ww in product(range(n),repeat=2):
            x=[None]*4;x[a]=xx;x[b]=yy;x[inner[0]]=zz;x[inner[1]]=ww
            term=mu[zz]*mu[ww]
            for e,(v,w)in enumerate(E):
                if e!=omitted:term*=Ks[e][x[v],x[w]]
            total+=term
        H[xx,yy]=total
    D=np.diag(np.array(mu,dtype=object))
    R=Ks[omitted]@D@H.T@D
    assert np.trace(R)==F
    exact_covers[edge_bits[omitted]]=np.trace(R@R)

# Independent bipartite-double sum: integrate all four vertices of one
# side first. Each resulting fan depends on the other three original states.
edge_lookup={frozenset(e):j for j,e in enumerate(E)}
fans={}
for omitted in range(4):
    others=[v for v in range(4)if v!=omitted]
    fan=np.empty((n,n,n),dtype=object)
    for x in product(range(n),repeat=3):
        total=Q(0)
        for y in range(n):
            term=mu[y]
            for index,v in enumerate(others):
                term*=Ks[edge_lookup[frozenset((omitted,v))]][y,x[index]]
            total+=term
        fan[x]=total
    fans[omitted]=(others,fan)
Z=Q(0)
for x in product(range(n),repeat=4):
    term=Q(1)
    for v in x:term*=mu[v]
    for omitted,(others,fan)in fans.items():term*=fan[tuple(x[v]for v in others)]
    Z+=term
exact_covers[7]=Z

integer_checks=[]
for bits in range(1,8):
    cert=exact_integer_certificate(G.tolist(),tpl,KEYS[bits])
    Fi=Q(cert['base_numerator'],cert['base_denominator'])
    Zi=Q(cert['cover_numerator'],cert['cover_denominator'])
    assert Fi==F and Zi==exact_covers[bits]
    direct,width=contract_cover(np.array(mu,dtype=object),Ks,KEYS[bits],objects=True)
    assert direct==Zi
    integer_checks.append({'bits':bits,'exact_F':str(F),'exact_Z':str(Zi),
                           'exact_defect_F2_minus_Z':str(F*F-Zi),'width':width})

# Walsh decomposition checked by independent weighted power compositions.
coarse_s=L.sum(axis=(1,2)); coarse_C=int(coarse_s.sum()); pi=[Q(int(s),coarse_C)for s in coarse_s]
LF=np.einsum('ijg,ag->aij',L,WALSH)
blocks=[np.array([[Q(coarse_C*int(LF[a,i,j]),int(coarse_s[i])*int(coarse_s[j]))
                  for j in range(2)]for i in range(2)],dtype=object)for a in range(4)]
for e in (1,2,3):
    BP=[kernel_power(B,pi,2*e)for B in blocks]
    full=kernel_power(T,mu,2*e)
    recovered=np.array([[sum(BP[alpha][i,j]*int(WALSH[alpha,a])*int(WALSH[alpha,b])for alpha in range(4))
                         for j in range(2)for b in range(4)]for i in range(2)for a in range(4)],dtype=object)
    assert np.array_equal(full,recovered)

numeric=values(L,tpl)
assert abs(numeric['F']/float(F)-1)<2e-13
assert all(abs(numeric['covers'][b-1]['Z']/float(exact_covers[b])-1)<4e-13 for b in range(1,8))

# Equality, genuinely disconnected roots, and a connected bipartite root
# whose square is disconnected. These are implementation controls, not
# additional search samples or newly claimed density classes.
boundary_tuple=(2,2,3,3,1)
control_specs=[]
weights=(1,3)
constant=np.array([[[weights[i]*weights[j]]*4 for j in range(2)]for i in range(2)])
control_specs.append(('constant_weighted',constant,Q(1),Q(1)))
disconnected=np.zeros((2,2,4),dtype=int);disconnected[0,0]=1;disconnected[1,1]=2
control_specs.append(('disconnected_weighted',disconnected,Q(45,4),Q(1377,16)))
bipartite=np.zeros((2,2,4),dtype=int);bipartite[0,1]=bipartite[1,0]=1
control_specs.append(('connected_bipartite_root',bipartite,Q(8),Q(32)))
controls=[]
for label,Lcontrol,expectedF,expectedZ in control_specs:
    Gcontrol=fine_flow(Lcontrol)
    for bits in range(1,8):
        cert=exact_integer_certificate(Gcontrol.tolist(),boundary_tuple,KEYS[bits])
        assert Q(cert['base_numerator'],cert['base_denominator'])==expectedF
        assert Q(cert['cover_numerator'],cert['cover_denominator'])==expectedZ
    controls.append({'label':label,'L_integer':Lcontrol.tolist(),'tuple':boundary_tuple,
                     'exact_F':str(expectedF),'every_connected_two_cover_Z':str(expectedZ),
                     'complete_two_cover_checks':7})

# Gradient checks for both optimization coordinate systems, at fixed
# positive points away from support changes or near-constant cancellation.
rng=np.random.default_rng(2026101401); m=3
Lgrad=rng.uniform(.2,2,(m,m,4)); Lgrad=(Lgrad+Lgrad.transpose(1,0,2))/2
Lgrad[np.arange(m),np.arange(m),0]+=8
ii,jj,gg=np.nonzero(np.triu(np.ones((m,m),dtype=bool))[:,:,None] & (Lgrad>0))
start={'mode':'free_original_measure_flow','coarse_states':m,
       'coordinate_indices':np.column_stack((ii,jj,gg)).tolist()}
unpack,pullback,_=unpack_factory(start); x=np.log(Lgrad[ii,jj,gg]); grad_checks=[]
for bits in (1,3,7):
    score,GL,_,_=one_value_gradient(unpack(x),tpl,bits)
    analytic=pullback(x,GL)
    d=rng.normal(size=len(x)); d/=np.linalg.norm(d); eps=1e-5
    sp=one_value_gradient(unpack(x+eps*d),tpl,bits)[0]
    sm=one_value_gradient(unpack(x-eps*d),tpl,bits)[0]
    fd=(sp-sm)/(2*eps); ad=float(analytic@d); err=abs(fd-ad)/max(1,abs(fd),abs(ad))
    assert err<2e-8
    grad_checks.append({'mode':'flow','bits':bits,'finite_difference':fd,'analytic':ad,'scaled_error':err})

from continuation4_search_engine import uniform_matching
Lm,extra=uniform_matching(rng,4)
start={'mode':'fixed_uniform_mixture','coarse_states':4,'generators':extra['generators']}
unpack,pullback,_=unpack_factory(start);x=np.log(np.array(extra['weights'],dtype=float))
for bits in (2,5,7):
    val,GL,_,_=one_value_gradient(unpack(x),tpl,bits);analytic=pullback(x,GL)
    d=rng.normal(size=len(x));d/=np.linalg.norm(d);eps=1e-5
    sp=one_value_gradient(unpack(x+eps*d),tpl,bits)[0];sm=one_value_gradient(unpack(x-eps*d),tpl,bits)[0]
    fd=(sp-sm)/(2*eps);ad=float(analytic@d);err=abs(fd-ad)/max(1,abs(fd),abs(ad))
    assert err<2e-8
    assert np.max(np.ptp(unpack(x).sum(axis=(1,2))))<1e-10
    grad_checks.append({'mode':'fixed_uniform','bits':bits,'finite_difference':fd,'analytic':ad,'scaled_error':err})

rejected=0
for bad in (np.ones((2,2)),np.ones((2,3,4)),np.ones((0,0,4)), -np.ones((2,2,4)),
            np.zeros((2,2,4)),np.full((2,2,4),np.nan),np.array([[[1]*4,[1]*4],[[2]*4,[1]*4]])):
    try:validate_L(bad)
    except (ValueError,TypeError):rejected+=1
    else:raise AssertionError('Invalid L was accepted')

out={'exact_original_fine_mu':list(map(str,mu)), 'exact_p':str(p),
     'fine_flow_integer':G.tolist(),'exact_cover_checks':integer_checks,
     'Walsh_exact_even_power_checks':3,'numeric_full_cover_checks':7,
     'equality_disconnected_and_boundary_controls':controls,
     'gradient_checks':grad_checks,'invalid_flow_rejections':rejected,
     'source_sha256':hashlib.sha256(Path('continuation4_search_engine.py').read_bytes()).hexdigest(),
     'dependency_sha256':hashlib.sha256(Path('continuation_cover_engine.py').read_bytes()).hexdigest(),
     'checks_source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
Path('continuation4_search_checks.json').write_text(json.dumps(out,indent=2)+'\n')
print('PASS exact weighted gate: seven covers, three Walsh powers, 21 equality/disconnected boundary controls, six gradient directions, seven rejected flows')
