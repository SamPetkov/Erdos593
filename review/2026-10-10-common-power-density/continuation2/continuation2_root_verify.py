"""Independent exact checks for the second bounded density continuation."""
from fractions import Fraction as Q
from itertools import product
from pathlib import Path
import json

EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))

def qstr(x):
    return str(x.numerator) if x.denominator==1 else f"{x.numerator}/{x.denominator}"

def stars(z):
    return (z[0]*z[1]*z[2], z[0]*z[3]*z[4], z[1]*z[3]*z[5], z[2]*z[4]*z[5])

def verify_ordered_fan():
    states=[z for z in product((-1,1),repeat=6) if (lambda v:v[0]+v[1]+v[2]-v[3])(stars(z))==2]
    assert len(states)==32
    phi=[[1,*z] for z in states]
    mu=Q(1,32)
    for i in range(7):
        for j in range(7):
            assert mu*sum(v[i]*v[j] for v in phi)==int(i==j)
    C=[[[mu*sum(v[i]*v[j]*v[k] for v in phi) for k in range(7)] for j in range(7)] for i in range(7)]
    s=[Q(1,2**20),Q(1,8),Q(1,8),Q(1,2),Q(1,2**10),Q(1,8)]
    theta=[Q(1),*[x*x for x in s]]
    T=[[1+sum(s[i]*phi[a][i+1]*phi[b][i+1] for i in range(6)) for b in range(32)] for a in range(32)]
    assert all(mu*sum(row)==1 for row in T)
    assert all(T[a][b]==T[b][a] for a in range(32) for b in range(32))
    p=Q(1048576,1967105)
    W=[[p*x for x in row] for row in T]
    assert min(map(min,W))>0 and max(map(max,W))<=1
    assert all(mu*sum(row)==p for row in W)
    def kernel(n):
        return [[sum(theta[i]**n*phi[a][i]*phi[b][i] for i in range(7)) for b in range(32)] for a in range(32)]
    K1,K6=kernel(1),kernel(6)
    # This checks that K1 really is T squared in the ORIGINAL measure.
    assert all(mu*sum(T[a][x]*T[x][b] for x in range(32))==K1[a][b] for a in range(32) for b in range(32))
    i=1
    fan61=[[mu*sum(phi[a][i]*K6[a][b]*K1[a][d] for a in range(32)) for d in range(32)] for b in range(32)]
    fan11=[[mu*sum(phi[a][i]*K1[a][b]*K1[a][d] for a in range(32)) for d in range(32)] for b in range(32)]
    w=mu**2*sum(K1[b][d]*fan61[b][d]*fan11[b][d] for b in range(32) for d in range(32))
    t=Q(1,2**40)
    b=Q(1,2**19)+Q(1,2**26)+Q(1,2**44)
    a=b+Q(1,2**36)+Q(1,2**48)+Q(1,2**54)+3*Q(1,2**58)+Q(1,2**126)+Q(1,2**144)+Q(1,2**148)
    expected=-Q(1,2**56)-Q(1,2**73)-3*Q(1,2**146)+a*t+t*t+t**3+b*t**6+t**7+t**8
    assert w==expected and w < -Q(1,2**57)
    # Exact spectral contraction, cubic moments computed above from all32 states.
    ns=(6,2,1,1,1,1)
    F=Q(0); nonzero=0
    for labels in product(range(7),repeat=6):
        ab,ac,ad,bc,bd,cd=labels
        coefficient=C[ab][ac][ad]*C[ab][bc][bd]*C[ac][bc][cd]*C[ad][bd][cd]
        if not coefficient:
            continue
        nonzero+=1
        term=coefficient
        for e,n in enumerate(ns):
            term*=theta[labels[e]]**n
        F+=term
    assert F>1
    return {"states":32,"tuple_k_u_r_l_h":[6,1,1,1,1],"root_coefficients":list(map(qstr,s)),"p":qstr(p),"minimum_W":qstr(min(map(min,W))),"maximum_W":qstr(max(map(max,W))),"ordered_fan_coefficient":qstr(w),"strict_upper_bound":qstr(-Q(1,2**57)),"F":qstr(F),"F_minus_one":qstr(F-1),"nonzero_spectral_terms":nonzero,"checks":["original_mu_orthonormality","actual_root_T_nonnegative","original_mu_regular_W","original_mu_T_squared_equals_K1","actual_source_fan_sums","independent_exact_cubic_density"]}

if __name__=="__main__":
    result={"ordered_fan":verify_ordered_fan()}
    Path("continuation2_root_checks.json").write_text(json.dumps(result,indent=2)+"\n")
    print(json.dumps(result,indent=2))
