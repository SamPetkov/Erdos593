"""Exact all-sheet, single-edge certificates for the actual 32-sign host.

Only the Python standard library is used.  The independent source replay
uses integer relative kernels and literal sums on the ORIGINAL 32 states.
No numerical eigenvalues or optimizer output enter this certificate.
"""
from fractions import Fraction as Q
from itertools import product, permutations
from pathlib import Path
from collections import Counter
import json, time

STARS=((0,1,2),(0,3,4),(1,3,5),(2,4,5))
STAR_SIGNS=(1,1,1,-1)
ROOT_BITS=(64,5,2,3,4,3)
THETA=(Q(1),)+(tuple(Q(1,2**(2*a)) for a in ROOT_BITS))
FIXED_N=(None,9,4,1,4,1)
EDGE_NAMES=('ab','ac','ad','bc','bd','cd')
EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))

def prod(xs):
    ans=1
    for x in xs:ans*=x
    return ans

def dyadic(x):
    x=Q(x); d=x.denominator
    assert d&(d-1)==0
    return {'numerator':str(x.numerator),'denominator_power_of_two':d.bit_length()-1}

def rational(x):
    x=Q(x)
    return {'numerator':str(x.numerator),'denominator':str(x.denominator)}

def build():
    states=[r for r in product((-1,1),repeat=6)
            if sum(s*prod(r[j] for j in star) for star,s in zip(STARS,STAR_SIGNS))==2]
    assert len(states)==32
    phi=[tuple([1]+list(r)) for r in states]
    for i,j in product(range(7),repeat=2):
        assert sum(v[i]*v[j] for v in phi)==32*(i==j)
    M={}
    for i,j,k in product(range(7),repeat=3):
        v=Q(sum(row[i]*row[j]*row[k] for row in phi),32)
        if v:M[i,j,k]=v
    expected={(0,0,0):Q(1)}
    for i in range(1,7):
        for key in set(permutations((0,i,i))):expected[key]=Q(1)
    for star,sgn in zip(STARS,STAR_SIGNS):
        for key in permutations(tuple(i+1 for i in star)):expected[key]=Q(sgn,2)
    assert M==expected
    return states,phi,M

def integer_kernel(states,j):
    """Numerator of K_j with common denominator 2^(128j)."""
    den=1<<(128*j)
    coeff=[1<<((128-2*a)*j) for a in ROOT_BITS]
    return [[den+sum(c*x*y for c,x,y in zip(coeff,r,s)) for s in states] for r in states]

def source_coefficients(M):
    B=[[[Q() for j in range(7)] for i in range(7)] for e in range(6)]
    assignments=0
    for modes in product(range(7),repeat=6):
        i,j,k,l,m,n=modes
        coeff=M.get((i,j,k),0)*M.get((i,l,m),0)*M.get((j,l,n),0)*M.get((k,m,n),0)
        if not coeff:continue
        assignments+=1
        for mode,power in zip(modes[1:],FIXED_N[1:]):coeff*=THETA[mode]**power
        for edge in range(6):B[edge][modes[edge]][modes[0]]+=coeff
    assert assignments==235
    return B,assignments

def all_k_bounds(row):
    lo=row[0]+sum(min(Q(),row[j])*THETA[j]**4 for j in range(1,7))
    hi=row[0]+sum(max(Q(),row[j])*THETA[j]**4 for j in range(1,7))
    return lo,hi

def weighted_transport_controls():
    """Literal 12-variable, nonuniform controls for the general transport."""
    mu=[Q(1,3),Q(2,3)];eye=[[Q(i==j,mu[j]) for j in range(2)] for i in range(2)]
    one=[[Q(1),Q(1)],[Q(1),Q(1)]]
    def compose(A,B):
        return [[sum(mu[z]*A[x][z]*B[z][y] for z in range(2)) for y in range(2)] for x in range(2)]
    def trace(A):return sum(mu[x]*A[x][x] for x in range(2))
    def literal(Ks,edge):
        value=Q()
        for xs in product(range(2),repeat=12):
            weight=prod(mu[x] for x in xs)
            for sheet in range(3):
                for e,(v,w) in enumerate(EDGES):
                    target=(sheet+1)%3 if e==edge else sheet
                    weight*=Ks[e][xs[4*sheet+v]][xs[4*target+w]]
                    if not weight:break
                if not weight:break
            value+=weight
        return value
    records=[]
    for name,T,edges in [('weighted_positive',[[Q(1,2)*(eye[i][j]+1) for j in range(2)] for i in range(2)],range(6)),
                         ('weighted_disconnected_identity',eye,(0,)),('Pi_equality',one,(0,))]:
        A=compose(T,T);A2=compose(A,A);A3=compose(A2,A)
        # Tuple (3,1,1,1,1): k>=u, r=l, h=1.
        Ks=[A3,A2,A,A,A,A]
        for edge in edges:
            v,w=EDGES[edge];internal=[z for z in range(4) if z not in (v,w)]
            D=[[Q() for _ in range(2)] for _ in range(2)]
            for x,y,a,b in product(range(2),repeat=4):
                state={v:x,w:y,internal[0]:a,internal[1]:b}
                D[x][y]+=mu[a]*mu[b]*prod(Ks[e][state[i]][state[j]] for e,(i,j) in enumerate(EDGES) if e!=edge)
            R=compose(Ks[edge],[list(row) for row in zip(*D)])
            F=trace(R);Z=literal(Ks,edge)
            assert Z==trace(compose(compose(R,R),R))
            S2=trace(compose(R,R))
            assert S2<=F*F
            if name=='Pi_equality':assert F==Z==1
            if name=='weighted_disconnected_identity':assert F==Q(45,4) and Z==Q(47385,64)
            records.append({'host':name,'edge':EDGE_NAMES[edge],'tuple':[3,1,1,1,1],
                            'original_mu':list(map(rational,mu)),'F':rational(F),'literal_3_cycle_cover':rational(Z),
                            'assignments':4096})
    return records

def main():
    started=time.time();states,phi,M=build();n=len(states)
    rootden=1<<64
    rootcoeff=[1<<(64-a) for a in ROOT_BITS]
    T=[[rootden+sum(c*x*y for c,x,y in zip(rootcoeff,r,s)) for s in states] for r in states]
    assert min(map(min,T))>0
    assert all(sum(row)==32*rootden for row in T)
    maximum=Q(max(map(max,T)),rootden)
    assert maximum==Q(51,32)+Q(1,2**64)
    p=1/maximum
    K1=integer_kernel(states,1);K4=integer_kernel(states,4)
    K8=integer_kernel(states,8);K9=integer_kernel(states,9)
    for a,b in product(range(n),repeat=2):
        assert sum(T[a][x]*T[x][b] for x in range(n))==32*K1[a][b]
        assert sum(K1[a][x]*K8[x][b] for x in range(n))==32*K9[a][b]
    assert all(sum(row)==32*(1<<128) for row in K1)

    # Three independent even-cycle sign flips preserve the original law.
    generators=((-1,-1,1,-1,1,1),(-1,1,-1,1,-1,1),(1,-1,-1,1,1,-1))
    G={tuple(prod(g[j] for g,b in zip(generators,bits) if b) for j in range(6))
       for bits in product((0,1),repeat=3)}
    assert len(G)==8
    state_set=set(states)
    assert all(tuple(a*b for a,b in zip(g,r)) in state_set for g in G for r in states)
    chars=[(1,1,1)]+[tuple(g[j] for g in generators) for j in range(6)]
    assert len(set(chars))==7

    B,assignment_count=source_coefficients(M)
    assert all(B[0][i][j]==0 for i,j in product(range(7),repeat=2) if i!=j)
    q=[B[0][i][i] for i in range(7)]
    assert Q(1)<q[0]<1+Q(1,2**23)
    assert -Q(1,2**117)<q[1]<-Q(66554167313,2**154)
    assert Q(1,2**25)<q[3]<Q(1,2**23)
    assert all(q[i]>0 for i in (2,4,5,6))

    # Direct ORIGINAL-law actual sources g_i and A_c^8 g_i.  Numerator
    # denominators are respectively 32*2^(128*(1+4)) and
    # 32*2^(128*(9+4)); the final Kl average contributes 32^2*2^128.
    g=[[0]*(n*n) for _ in range(7)]
    gh=[[0]*(n*n) for _ in range(7)]
    for c,d in product(range(n),repeat=2):
        products=[K1[x][c]*K4[x][d] for x in range(n)]
        products_h=[K9[x][c]*K4[x][d] for x in range(n)]
        for i in range(7):
            g[i][c*n+d]=sum(phi[x][i]*products[x] for x in range(n))
            gh[i][c*n+d]=sum(phi[x][i]*products_h[x] for x in range(n))
    denominator=1<<2452
    for i,j in product(range(7),repeat=2):
        num=sum(K1[c][d]*gh[i][c*n+d]*g[j][c*n+d] for c,d in product(range(n),repeat=2))
        assert Q(num,denominator)==(q[i] if i==j else 0)

    # A separate literal four-variable numerator at the boundary k=u=4.
    # The six factors are K4(ab),K9(ac),K4(ad),K1(bc),K4(bd),K1(cd).
    Fnum=0
    for c,d in product(range(n),repeat=2):
        left=[K9[a][c]*K4[a][d] for a in range(n)]
        right=[K1[b][c]*K4[b][d] for b in range(n)]
        inner=sum(left[a]*K4[a][b]*right[b] for a,b in product(range(n),repeat=2))
        Fnum+=K1[c][d]*inner
    F4=Q(Fnum,1<<2964)
    eig4=[[sum(B[e][i][j]*THETA[j]**4 for j in range(7)) for i in range(7)] for e in range(6)]
    assert all(sum(ev)==F4 for ev in eig4)
    assert F4>1
    assert eig4[0][1]<0 and eig4[2][1]<0
    bounds={}
    for e in range(1,6):
        intervals=[all_k_bounds(B[e][i]) for i in range(7)]
        assert intervals[0][0]>=1
        assert intervals[3][0]>Q(1,2**60) and intervals[3][1]<1
        assert intervals[1][0]>-Q(1,2**200)
        assert all(intervals[i][0]>0 for i in (2,4,5,6))
        bounds[EDGE_NAMES[e]]=[{'lower':dyadic(lo),'upper':dyadic(hi)} for lo,hi in intervals]
    for e,ev in enumerate(eig4):
        delta=F4**2-sum(v*v for v in ev)
        assert delta>(Q(1,2**41) if e==0 else Q(1,2**60))

    transport_controls=weighted_transport_controls()

    result={
      'verdict':'PASS; all k>=4 and all sheet counts for one permuted edge of the displayed actual host only',
      'tuple_family':{'k':'every integer >=4','u':4,'r':1,'l':1,'h':8},
      'states':[list(r) for r in states], 'mu':'1/32 on each of the listed 32 states',
      'root_eigenvalues':[rational(Q(1,2**a)) for a in ROOT_BITS],
      'p':rational(p),'root_minimum':rational(Q(min(map(min,T)),rootden)),
      'active_characters':chars,'square_centered_spectrum':{
          str(a):b for a,b in sorted(Counter([2*a for a in ROOT_BITS]).items())},
      'additional_zero_multiplicity':25,
      'nonzero_moment_tensor_entries':len(M),'nonzero_tetrahedron_assignments':assignment_count,
      'actual_source_matrix_entries_replayed':49,
      'actual_direct_F4_assignments':32**4,
      'weighted_literal_cover_controls':transport_controls,
      'q_ab_source':list(map(dyadic,q)),
      'edge_eigenvalue_coefficient_matrices':[[list(map(dyadic,row)) for row in mat] for mat in B],
      'all_k_ge4_bounds_for_non_ab_edges':bounds,
      'F_at_k4':dyadic(F4),
      'edge_transfer_eigenvalues_at_k4':dict(zip(EDGE_NAMES,[list(map(dyadic,row)) for row in eig4])),
      'edge_two_sheet_defects_at_k4':{name:dyadic(F4**2-sum(x*x for x in vals)) for name,vals in zip(EDGE_NAMES,eig4)},
      'elapsed_seconds':time.time()-started}
    Path(__file__).with_name('continuation6_cover_moments_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('verdict','nonzero_tetrahedron_assignments','actual_source_matrix_entries_replayed','actual_direct_F4_assignments','elapsed_seconds')},indent=2))

if __name__=='__main__':main()
