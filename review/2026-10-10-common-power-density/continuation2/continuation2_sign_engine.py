"""Exact sparse cubic-tensor engine for actual six-sign Markov roots.

Finite host: r in {-1,+1}^6 with original mass
    mu(r) = (1 + sum_v t_v prod_{e incident to v} r_e)/64.
The seven functions 1,r_1,...,r_6 are orthonormal whenever all masses
are nonnegative. Their cubic moments are 1 for (0,0,0)/(0,i,i)
and t_v for the three distinct edges incident to v; all others vanish.
Consequently each pair of indices determines at most one nonzero third.
T(r,r')=1+sum_i lambda_i r_i r'_i is checked entrywise on positive-mass
states. A=T^2 has eigenvalues lambda_i^2 on the six active modes.
Tuples are (k,u,r,l,h); A exponents are (k,r+h,u,r,u,l).
This engine concerns two-cover comparison F^2-Z, not the target alone.
"""
from collections import deque
from fractions import Fraction
from functools import lru_cache
from itertools import product
from math import gcd,lcm
from numbers import Integral
import numpy as np

EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
STARS=((0,1,2),(0,3,4),(1,3,5),(2,4,5))
CUBE=np.array(list(product((-1,1),repeat=6)),dtype=int)
STAR_VALUES=np.column_stack([np.prod(CUBE[:,s],axis=1)for s in STARS])
NEXT=np.full((7,7),-1,dtype=int);STAR_TYPE=np.full((7,7),-1,dtype=int)
NEXT[0,0]=0
for i in range(1,7):NEXT[0,i]=i;NEXT[i,0]=i;NEXT[i,i]=0
for v,st in enumerate(STARS):
    a,b,c=[i+1 for i in st]
    for i,j,k in [(a,b,c),(a,c,b),(b,c,a)]:
        NEXT[i,j]=NEXT[j,i]=k;STAR_TYPE[i,j]=STAR_TYPE[j,i]=v

def valid_tuple(tpl):
    try:tpl=tuple(tpl)
    except TypeError as exc:raise ValueError('expected (k,u,r,l,h)')from exc
    if len(tpl)!=5 or any(not isinstance(v,Integral)or isinstance(v,(bool,np.bool_))for v in tpl):raise ValueError('five integer entries required')
    k,u,r,l,h=map(int,tpl)
    if not(k>=u>=1 and r>=l>=1 and h>=1):raise ValueError('ordered target constraints required')
    return k,u,r,l,h

def exponents(tpl):
    k,u,r,l,h=valid_tuple(tpl);values=(k,r+h,u,r,u,l)
    if sum(values)>1000000:raise ValueError('implemented certificate degree bound exceeded; this is not a restriction on the mathematical target')
    return np.array(values,dtype=np.int64)

def graph(bits=None):
    if bits is None:return 4,tuple((a,b,e)for e,(a,b)in enumerate(EDGES))
    if not isinstance(bits,Integral)or isinstance(bits,(bool,np.bool_))or not 1<=bits<=7:raise ValueError('nontrivial two-cover bits must lie in 1,...,7')
    out=[]
    for e,(a,b)in enumerate(EDGES):
        flip=0 if e<3 else (int(bits)>>(e-3))&1
        for s in range(2):out.append((4*s+a,4*(s^flip)+b,e))
    return 8,tuple(out)

@lru_cache(maxsize=None)
def color_records(bits=None):
    nv,edges=graph(bits);ne=len(edges);incident=[[]for _ in range(nv)]
    for j,(a,b,_)in enumerate(edges):incident[a].append(j);incident[b].append(j)
    parent=[None]*nv;parentedge=[None]*nv;seen={0};order=[0];q=deque([0]);tree=set()
    while q:
        a=q.popleft()
        for e in incident[a]:
            x,y,_=edges[e];b=y if x==a else x
            if b in seen:continue
            seen.add(b);parent[b]=a;parentedge[b]=e;tree.add(e);order.append(b);q.append(b)
    if len(seen)!=nv:raise ValueError('connected graph required')
    chords=[e for e in range(ne)if e not in tree]
    chord_colors=np.array(list(product(range(7),repeat=len(chords))),dtype=np.int8)
    nc=len(chord_colors);colors=np.zeros((nc,ne),dtype=np.int8);colors[:,chords]=chord_colors
    counts=np.zeros((nc,4),dtype=np.int8);valid=np.ones(nc,dtype=bool)
    for v in reversed(order[1:]):
        e=parentedge[v];others=[f for f in incident[v]if f!=e]
        i,j=colors[:,others[0]],colors[:,others[1]];k=NEXT[i,j];st=STAR_TYPE[i,j]
        valid&=k>=0;colors[:,e]=np.maximum(k,0)
        for z in range(4):counts[:,z]+=(st==z)
    a,b,c=[colors[:,e]for e in incident[0]];valid&=(NEXT[a,b]==c);st=STAR_TYPE[a,b]
    for z in range(4):counts[:,z]+=(st==z)
    colors=colors[valid];counts=counts[valid]
    edgecounts=np.zeros((len(colors),6,6),dtype=np.int8)
    for j,(_,_,e)in enumerate(edges):
        for mode in range(6):edgecounts[:,e,mode]+=(colors[:,j]==mode+1)
    return counts,edgecounts,len(chords),nc

def _coalesce(rows,coef=None):
    rows=np.asarray(rows,dtype=np.int64)
    u,inv=np.unique(rows,axis=0,return_inverse=True)
    if coef is None:c=np.bincount(inv)
    else:c=np.bincount(inv,weights=np.asarray(coef,dtype=float)).astype(np.int64)
    keep=c!=0
    return u[keep],c[keep]

@lru_cache(maxsize=None)
def base_poly(tpl):
    ep=exponents(tpl);ct,ec,_,_=color_records()
    powers=2*np.einsum('vem,e->vm',ec,ep)
    return _coalesce(np.column_stack((ct,powers)))

@lru_cache(maxsize=None)
def cover_poly(tpl,bits):
    ep=exponents(tpl);ct,ec,_,_=color_records(bits)
    powers=2*np.einsum('vem,e->vm',ec,ep)
    return _coalesce(np.column_stack((ct,powers)))

@lru_cache(maxsize=None)
def defect_poly(tpl,bits):
    """Return the polynomial F^2-Z without its identically canceled constant."""
    br,bc=base_poly(tpl);cr,cc=cover_poly(tpl,bits)
    sums=(br[:,None,:]+br[None,:,:]).reshape((-1,10));coef=(bc[:,None]*bc[None,:]).ravel()
    return _coalesce(np.concatenate((sums,cr)),np.r_[coef,-cc])

def evaluate(poly,t,lam,gradient=False,longdouble=False):
    dtype=np.longdouble if longdouble else float
    rows,coefs=poly;x=np.asarray(tuple(t)+tuple(lam),dtype=dtype);powers=rows
    terms=coefs.astype(dtype)*np.prod(x[None,:]**powers,axis=1)
    val=np.sum(terms,dtype=dtype);scale=np.sum(np.abs(terms),dtype=dtype)
    if not gradient:return val,scale
    grads=[]
    for j in range(10):
        nz=powers[:,j]>0
        if not np.any(nz):grads.append(dtype(0));continue
        p=powers[nz].copy();p[:,j]-=1
        grads.append(np.sum(coefs[nz].astype(dtype)*powers[nz,j]*np.prod(x[None,:]**p,axis=1),dtype=dtype))
    return val,np.asarray(grads),scale

def rational_vector(values):
    fs=tuple(Fraction(v)for v in values);D=lcm(*(v.denominator for v in fs));nums=tuple(int(v*D)for v in fs)
    g=gcd(D,gcd(*nums));return tuple(v//g for v in nums),D//g

def law_data(t):
    nums,D=rational_vector(t)
    if len(nums)!=4:raise ValueError('four star coefficients required')
    masses=D+STAR_VALUES@np.array(nums,dtype=object)
    if any(v<0 for v in masses):raise ValueError('negative original state mass')
    keep=np.array([v>0 for v in masses]);states=CUBE[keep];mn=[int(v)for v in masses[keep]]
    assert sum(mn)==64*D
    products=np.unique((states[:,None,:]*states[None,:,:]).reshape((-1,6)),axis=0)
    return {'t_numerators':nums,'t_denominator':D,'states':states,'mu_numerators':mn,'mu_denominator':64*D,'products':products}

def actual_root(t,lam,boundary=False):
    law=law_data(t);nums,D=rational_vector(lam)
    if len(nums)!=6:raise ValueError('six root coefficients required')
    dots=law['products']@np.array(nums,dtype=object);q=int(min(dots))
    if D+q<0:raise ValueError('root has a negative entry')
    if boundary:
        if q>=0:raise ValueError('nontrivial centered root required')
        D=-q
    denominator_before_reduction=D;vals=[D+int(v)for v in dots]
    if min(vals)<0:raise AssertionError('boundary root is not actual')
    g=gcd(D,gcd(*nums));nums=tuple(v//g for v in nums);D//=g
    law.update({'lambda_numerators':nums,'lambda_denominator':D,'lambda':np.array(nums,dtype=float)/D,
                'min_root':Fraction(min(vals),denominator_before_reduction),
                'max_root':Fraction(max(vals),denominator_before_reduction)})
    return law

def boundary_float(raw,products,gradient=False):
    q=products@raw;j=int(np.argmin(q));den=-float(q[j])
    if den<=0:raise ValueError('boundary denominator nonpositive')
    lam=raw/den
    if not gradient:return lam,j
    return lam,(np.eye(6)/den+np.outer(raw,products[j])/den**2),j

def exact_value(poly,t_nums,t_den,lambda_nums,lambda_den,vertices,total_root_degree):
    rows,coefs=poly
    # Fixed common denominator also represents lower-degree monomials exactly.
    den=t_den**vertices*lambda_den**total_root_degree;num=0
    for row,c in zip(rows,coefs):
        tc=row[:4];lp=row[4:];term=int(c)*t_den**(vertices-int(sum(tc)))*lambda_den**(total_root_degree-int(sum(lp)))
        for x,p in zip(t_nums,tc):term*=int(x)**int(p)
        for x,p in zip(lambda_nums,lp):term*=int(x)**int(p)
        num+=term
    return num,den

def exact_certificate(t,lam,tpl,bits):
    tpl=valid_tuple(tpl);data=actual_root(t,lam);ep=exponents(tpl);rootdegree=2*int(sum(ep))
    tn,td=data['t_numerators'],data['t_denominator'];ln,ld=data['lambda_numerators'],data['lambda_denominator']
    B,D=exact_value(base_poly(tpl),tn,td,ln,ld,4,rootdegree)
    Z,E=exact_value(cover_poly(tpl,bits),tn,td,ln,ld,8,2*rootdegree)
    diff,DD=exact_value(defect_poly(tpl,bits),tn,td,ln,ld,8,2*rootdegree)
    assert E==D*D==DD and diff==B*B-Z
    return {'t_numerators':tn,'t_denominator':td,'lambda_numerators':ln,'lambda_denominator':ld,
       'mu_numerators':data['mu_numerators'],'mu_denominator':data['mu_denominator'],'states':data['states'].tolist(),
       'p':str(1/data['max_root']),'tuple':tpl,'tuple_order':'k,u,r,l,h','two_cover_bits_bc_bd_cd':int(bits),
       'base_numerator':B,'base_denominator':D,'cover_numerator':Z,'cover_denominator':E,
       'target_defect_integer':B-D,'cover_defect_integer_F2_minus_Z':diff,
       'target_violation':B<D,'cover_violation':diff<0,'root_minimum':str(data['min_root']),
       'W_definition':'p*(1+sum_i lambda_i*state[x][i]*state[y][i]); every sum uses the listed original mu'}
