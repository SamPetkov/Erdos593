"""Exact sixteen-configuration loop diagnostic; no files or network writes."""
from fractions import Fraction as Q
from itertools import product, combinations
import json

signs = (-1, 1)
mu = Q(1, 2)
root = {(a,b): 1+Q(a*b,2) for a,b in product(signs,repeat=2)}
assert all(v>0 for v in root.values())
assert all(sum(mu*root[a,b] for b in signs)==1 for a in signs)
powers = {0:{(a,b):Q(2*int(a==b)) for a,b in root}}
for j in range(1,17):
    powers[j] = {(a,b):sum(mu*powers[j-1][a,z]*root[z,b] for z in signs)
                 for a,b in root}
theta = Q(1,4)
def K(j,a,b):
    actual = powers[2*j][a,b]
    assert actual==1+theta**j*a*b
    return actual
states=list(product(signs,repeat=4))
raw={}
density={}
for a,b,c,d in states:
    q=K(4,a,d)*K(4,b,d)*K(3,b,c)*K(4,a,c)
    raw[a,b,c,d]=q/16
    density[a,b,c,d]=q*K(5,a,b)*K(2,c,d)/16
C=sum(raw.values())
assert C==1+theta**15
rho={x:v/C for x,v in raw.items()}
m=(theta**7+theta**8)/C
s=(theta**4+theta**11)/C
t=(theta**3+theta**12)/C
assert 2*m+3*s+t<=Q(225,4096)<Q(1,10)
alternative={}
for a,b,c,d in states:
    alternative[a,b,c,d]=(1+m*(a*b+c*d)+s*(a*c+a*d+b*d)+t*b*c-Q(9,10)*a*b*c*d)/16
assert sum(alternative.values())==1
assert all(v>0 for v in alternative.values())
def marginal(law,i,j):
    return {(a,b):sum(p for x,p in law.items() if x[i]==a and x[j]==b)
            for a,b in product(signs,repeat=2)}
for i,j in combinations(range(4),2):
    assert marginal(rho,i,j)==marginal(alternative,i,j)
for i in range(4):
    assert all(sum(p for x,p in alternative.items() if x[i]==a)==mu for a in signs)
four=lambda law:sum(p*x[0]*x[1]*x[2]*x[3] for x,p in law.items())
assert four(rho)==m
assert four(alternative)==-Q(9,10)
F=sum(density.values())
P_payoff=C*sum(p*K(5,x[0],x[1])*K(2,x[2],x[3]) for x,p in alternative.items())
assert F==Q(536873515,536870912)>1
assert P_payoff==Q(35182609779915,35184372088832)<1
frechet=C*(1-theta**7)+(theta**5+theta**2+2*theta**7)*(theta**7+theta**8)
assert frechet==Q(17591197679615,17592186044416)<1
print(json.dumps({
    "scope":"Exact actual-loop and pair-marginal-relaxation diagnostic; not a density counterexample",
    "actual_root_positive_markov":True,
    "weighted_matrix_powers_constructed":16,
    "even_powers_compared_with_closed_form":[4,6,8,10],
    "configurations":16,
    "all_six_full_pair_tables_identical":True,
    "alternative_min_probability":str(min(alternative.values())),
    "actual_fourth_moment":str(four(rho)),
    "alternative_fourth_moment":str(four(alternative)),
    "actual_density":str(F),
    "all_pair_relaxation_payoff":str(P_payoff),
    "two_chord_relaxation_payoff":str(frechet),
    "all_assertions_passed":True
},indent=2))
