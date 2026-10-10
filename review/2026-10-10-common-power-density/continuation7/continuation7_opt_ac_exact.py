"""Exact actual-host obstruction to active ac-mode positivity only.

No eigensolver, floating-point sign, or nonrealizable square root appears
in this verifier. The complete target F is certified above four at h=1.
"""
from fractions import Fraction as Q
from math import gcd,lcm
from functools import reduce
from pathlib import Path
import hashlib,json,time,sys
sys.set_int_max_str_digits(0)

DIAGONAL=(1480000000000,2450,602,20500,385,152,780,445000,611000000,1480000000000)
ADJACENT=(188000,321000,12800000,5990000,6520,801,97700,41200000,9200000000)
BYPASS=(3,9,4310000000)
TUPLE=(8,1,2,1,1)

def identity(n):return [[int(i==j) for j in range(n)] for i in range(n)]

def mul(A,B):
    cols=list(zip(*B))
    return [[sum(x*y for x,y in zip(row,col)) for col in cols] for row in A]

def power(A,k):
    out=identity(len(A));base=A
    while k:
        if k&1:out=mul(out,base)
        k//=2
        if k:base=mul(base,base)
    return out

def determinant(A):
    a=[row[:] for row in A];n=len(a);old=1;sgn=1
    for k in range(n-1):
        if not a[k][k]:
            candidates=[i for i in range(k+1,n) if a[i][k]]
            if not candidates:return 0
            i=candidates[0];a[k],a[i]=a[i],a[k];sgn=-sgn
        pivot=a[k][k]
        for i in range(k+1,n):
            for j in range(k+1,n):
                v=pivot*a[i][j]-a[i][k]*a[k][j]
                assert v%old==0
                a[i][j]=v//old
            a[i][k]=0
        old=pivot
    return sgn*a[-1][-1]

def adjugate(A):
    """Fraction-free Gauss-Jordan; every claimed division is checked."""
    n=len(A);I=identity(n);a=[row[:]+I[i] for i,row in enumerate(A)];old=1
    for k in range(n):
        pivot=a[k][k]
        assert pivot!=0,'The fixed certificate must have nonzero leading pivots.'
        for i in range(n):
            if i==k:continue
            aik=a[i][k]
            for j in range(2*n):
                if j==k:continue
                v=pivot*a[i][j]-aik*a[k][j]
                assert v%old==0
                a[i][j]=v//old
            a[i][k]=0
        old=pivot
    det=a[0][0]
    assert det!=0
    assert all(a[i][j]==det*(i==j) for i in range(n) for j in range(n))
    adj=[row[n:] for row in a]
    assert mul(A,adj)==[[det*x for x in row] for row in I]
    return det,adj

def rational(x):
    x=Q(x)
    return {'numerator':str(x.numerator),'denominator':str(x.denominator)}

def integer_hash(n):return hashlib.sha256(str(n).encode()).hexdigest()

def main():
    started=time.time();n=len(DIAGONAL)
    G=[[0]*n for _ in range(n)]
    for i,x in enumerate(DIAGONAL):G[i][i]=x
    for i,x in enumerate(ADJACENT):G[i][i+1]=G[i+1][i]=x
    i,j,x=BYPASS;G[i][j]=G[j][i]=x
    rows=list(map(sum,G));mass=sum(rows);mu=[Q(x,mass) for x in rows]
    assert min(mu)>0 and sum(mu)==1
    L=lcm(*rows)
    # Ordinary stochastic matrix P=N/R, relative kernel T_ij=P_ij/mu_j.
    R=4096*L*mass
    N=[[4095*mass*(L//rows[i])*G[i][j]+L*rows[j] for j in range(n)] for i in range(n)]
    common=reduce(gcd,[R]+[x for row in N for x in row])
    R//=common;N=[[x//common for x in row] for row in N]
    assert min(map(min,N))>0
    assert all(sum(row)==R for row in N)
    assert all(rows[i]*N[i][j]==rows[j]*N[j][i] for i in range(n) for j in range(n))
    T=[[Q(N[i][j]*mass,R*rows[j]) for j in range(n)] for i in range(n)]
    assert min(map(min,T))>=Q(1,4096)
    assert all(T[i][j]==T[j][i] for i in range(n) for j in range(n))
    assert all(sum(mu[j]*T[i][j] for j in range(n))==1 for i in range(n))
    p=min(mu)/2
    W=[[p*x for x in row] for row in T]
    assert 0<min(map(min,W))<=max(map(max,W))<=Q(1,2)
    assert all(sum(mu[j]*W[i][j] for j in range(n))==p for i in range(n))
    detN=determinant(N)
    assert detN!=0 # Every actual square eigenvalue is active.
    # Ten independent Krylov columns for N^2 prove ten distinct actual
    # square eigenvalues, since the weighted operator is self-adjoint.
    N2=mul(N,N);column=[int(i==0) for i in range(n)];columns=[]
    for _ in range(n):
        columns.append(column)
        column=[sum(N2[i][j]*column[j] for j in range(n)) for i in range(n)]
    krylov=[[columns[j][i] for j in range(n)] for i in range(n)]
    detKrylov=determinant(krylov)
    assert detKrylov!=0

    kernel={}
    for s in (1,2,4,8):
        Npower=power(N,2*s)
        kernel[s]=[[mass*(L//rows[j])*Npower[i][j] for j in range(n)] for i in range(n)]
        assert all(kernel[s][i][j]==kernel[s][j][i] for i in range(n) for j in range(n))
        assert all(sum(rows[j]*kernel[s][i][j] for j in range(n))==mass*L*R**(2*s) for i in range(n))
    for a,b in ((1,1),(2,2),(4,4)):
        lhs=mul([[rows[j]*kernel[a][i][j] for j in range(n)] for i in range(n)],kernel[b])
        assert lhs==[[mass*L*x for x in row] for row in kernel[a+b]]

    K1,K2,K8=kernel[1],kernel[2],kernel[8]
    # D_ac has common positive denominator mass^2 L^5 R^26.
    D=[[0]*n for _ in range(n)]
    for b in range(n):
        inner=mul([[rows[d]*K1[a][d]*K1[b][d] for d in range(n)] for a in range(n)],K1)
        for a in range(n):
            for c in range(n):D[a][c]+=rows[b]*K8[a][b]*K2[b][c]*inner[a][c]
    Dden=mass**2*L**5*R**26
    # A separate literal b,d sum checks the orientation and all original
    # weights at nonsymmetric entries, not just at a diagonal entry.
    for a,c in ((0,0),(0,4),(4,0),(8,6),(6,8)):
        literal=sum(rows[b]*rows[d]*K8[a][b]*K1[a][d]*K2[b][c]*K1[b][d]*K1[c][d]
                    for b in range(n) for d in range(n))
        assert D[a][c]==literal

    # C=R(1024 P-I). Its adjugate is a scalar multiple of a real
    # polynomial in P, hence self-adjoint in the original weighted space.
    C=[[1024*N[i][j]-R*(i==j) for j in range(n)] for i in range(n)]
    detC,adj=adjugate(C)
    agcd=reduce(gcd,[abs(x) for row in adj for x in row])
    J=[[x//agcd for x in row] for row in adj]
    assert all(rows[i]*J[i][j]==rows[j]*J[j][i] for i in range(n) for j in range(n))
    assert mul(N,J)==mul(J,N)
    H=mul(J,J)
    traceH=sum(H[i][i] for i in range(n))
    assert traceH>0
    numerator=sum(H[i][j]*D[j][i]*rows[i] for i in range(n) for j in range(n))
    denominator=mass*Dden*traceH
    filtered=Q(numerator,denominator)
    assert -Q(1,10000)<filtered<-Q(1,20000)<0

    # At the actual target tuple (8,1,2,1,1), sum of the six powers is 16.
    # Restrict all branch and every intermediate vertex to state zero.
    # Relative K_s(0,0)>=P_00^(2s)/mu_0, under original mu.
    stay=Q(N[0][0],R)
    F_lower=stay**32/mu[0]**2
    assert F_lower>4
    result={'verdict':'PASS: an active ac-mode coefficient is negative; full target at h=1 is greater than four',
      'tuple_k_u_r_l_h':TUPLE,'original_mu':list(map(rational,mu)),
      'flow_diagonal':DIAGONAL,'flow_adjacent':ADJACENT,'flow_bypass':BYPASS,
      'flow_row_sums':rows,'flow_total':mass,'refresh':rational(Q(1,4096)),
      'p':rational(p),'W_minimum':rational(min(map(min,W))),'W_maximum':rational(max(map(max,W))),
      'root_is_invertible':True,'integer_root_determinant_sign':1 if detN>0 else -1,
      'integer_root_determinant_sha256':integer_hash(detN),
      'square_krylov_determinant_nonzero':True,
      'square_krylov_determinant_sha256':integer_hash(detKrylov),
      'entire_centered_square_distinct_positive_values':9,
      'filter':'H=adj(1024 P-I)^2 / tr[adj(1024 P-I)^2]',
      'filter_shift':rational(Q(1,1024)),
      'adjugate_determinant_nonzero':detC!=0,
      'filtered_ac_average':rational(filtered),
      'filtered_ac_certified_interval':[rational(-Q(1,10000)),rational(-Q(1,20000))],
      'full_F_lower_bound':rational(F_lower),'full_F_lower_bound_certified_above':4,
      'kernel_composition_checks':[[1,1,2],[2,2,4],[4,4,8]],
      'literal_D_entries_checked':[[0,0],[0,4],[4,0],[8,6],[6,8]],
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'elapsed_seconds':time.time()-started}
    Path(__file__).with_name('continuation7_opt_ac_exact_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'verdict':result['verdict'],'p':result['p'],
        'filtered_ac_certified_interval':result['filtered_ac_certified_interval'],
        'filtered_ac_approximation':float(filtered),'full_F_lower_approximation':float(F_lower),
        'elapsed_seconds':result['elapsed_seconds']},indent=2))

if __name__=='__main__':main()
