"""Exact checks for the second-continuation channel examples.

All mathematical generalizations are proved in continuation2_markov.md.
This standard-library script checks displayed finite examples only.
"""
from fractions import Fraction as F
from itertools import product
import json

M = [[5,1,1,1],[1,7,0,0],[1,0,7,0],[1,0,0,7]]
C = [[16,1,2,3],[1,40,0,0],[2,0,44,0],[3,0,0,48]]
EDGES = [(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]

def mm(a,b):
    return [[sum(a[i][k]*b[k][j] for k in range(len(b)))
             for j in range(len(b[0]))] for i in range(len(a))]

def mp(a,n):
    out=[[int(i==j) for j in range(len(a))] for i in range(len(a))]
    while n:
        if n&1:out=mm(out,a)
        a=mm(a,a);n//=2
    return out

def trace(a):return sum(a[i][i] for i in range(len(a)))

def charpoly(a):
    n=len(a);tr=[0]+[trace(mp(a,k)) for k in range(1,n+1)]
    c=[F(1)]
    for k in range(1,n+1):
        c.append(-sum(c[k-i]*tr[i] for i in range(1,k+1))/k)
    assert all(v.denominator==1 for v in c)
    return [int(v) for v in c]

def dens_from_transition_numerator(a,den,n):
    q=len(a);powers={j:mp(a,2*j) for j in set(n)}
    total=0
    for colors in product(range(q),repeat=4):
        term=1
        for (v,w),j in zip(EDGES,n):term*=powers[j][colors[v]][colors[w]]
        total+=term
    return F(q*q*total,den**(2*sum(n)))

def encode(f):return str(f.numerator)+('/'+str(f.denominator) if f.denominator!=1 else '')

def verify_eight():
    states=list(product(range(4),(1,-1)))
    D=[[8*M[i][j]+C[i][j]*a*b for j,b in states] for i,a in states]
    assert max(map(max,D))==104 and min(map(min,D))==0
    assert all(sum(row)==128 for row in D)
    assert all(D[i][j]==D[j][i] for i in range(8) for j in range(8))
    M2=mp(M,2);C2=mp(C,2);D2=mp(D,2)
    for u,(i,a) in enumerate(states):
        for v,(j,b) in enumerate(states):
            assert D2[u][v]==2*(64*M2[i][j]+C2[i][j]*a*b)
    A_num=[[v//2 for v in row] for row in D2]
    assert max(map(max,A_num))==5513
    # First/last-column necessary conditions already exclude every order.
    possible_endpoints=[]
    for first,last in product(range(8),repeat=2):
        if first==last:continue
        remaining=[i for i in range(8) if i not in (first,last)]
        if any(A_num[first][last]>A_num[z][last] for z in remaining):continue
        if any(A_num[z][first]<A_num[last][first] for z in remaining):continue
        possible_endpoints.append((first,last))
    # Some leaf endpoint pairs survive endpoint-only tests; a center and a
    # third-group leaf then require opposite relative orders.
    for first,last in possible_endpoints:
        f=states[first][0];l=states[last][0]
        assert f!=0 and l!=0
        z=next(s for s,(g,_) in enumerate(states) if g not in (0,f,l))
        center=0
        assert A_num[center][first]>A_num[z][first]
        assert A_num[center][last]>A_num[z][last]
    # A proper constant-cross-block fiber must be a matrix module.
    modules=[]
    for mask in range(1,1<<8):
        inside=[i for i in range(8) if mask>>i&1]
        if len(inside)<2 or len(inside)==8:continue
        outside=[j for j in range(8) if not(mask>>j&1)]
        if all(D[i][j]==D[inside[0]][j] for i in inside for j in outside):
            modules.append(inside)
    assert modules==[]
    pc=charpoly(C)
    assert pc==[1,-148,7890,-175952,1326048]
    rows=[]
    for label,n in [('interior',(3,2,1,1,1,1)),('boundary',(1,2,1,1,1,1))]:
        full=dens_from_transition_numerator(D,128,n)
        coarse=dens_from_transition_numerator(M,8,n)
        assert full>coarse>1
        rows.append({'label':label,'edge_exponents':n,'F':encode(full),'F_coarse':encode(coarse),'difference':encode(full-coarse)})
    return {'mu':'1/8 at all eight states','p':'2/13','max_A':'5513/1024',
            'charpoly_C':pc,'proper_matrix_modules':modules,'densities':rows,
            'positive_refresh':{'rho':'99/100','p':'200/1289','minimum_W':'2/1289',
                                'max_A':encode(1+F(99,100)**2*(F(5513,1024)-1))}}

def verify_six():
    states=list(product(range(3),(1,-1)))
    # T=E/4, transition matrix E/24, and W=E/6.
    E=[[4+(3*int(i==j)-1)*a*b for j,b in states] for i,a in states]
    assert min(map(min,E))==2 and max(map(max,E))==6
    assert all(sum(row)==24 for row in E)
    n=(3,2,1,1,1,1)
    exact=dens_from_transition_numerator(E,24,n)
    x=F(1,16)
    predicted=1+2*(x**3+x**4+2*x**5+2*x**6+x**7)
    assert exact==predicted==1+F(70177,134217728)
    coarse_colors=(0,0,1,2)
    conditional=F(0)
    for signs in product((1,-1),repeat=4):
        term=F(1)
        for (v,w),j in zip(EDGES,n):
            term*=1+x**j*(3*int(coarse_colors[v]==coarse_colors[w])-1)*signs[v]*signs[w]
        conditional+=term/16
    assert conditional==1-F(34433,134217728)<1
    return {'mu':'1/6 at all six states','p':'2/3','minimum_W':'1/3',
            'conditional_coarse_colors':coarse_colors,'conditional_density':encode(conditional),
            'conditional_defect':encode(conditional-1),'global_F':encode(exact),
            'global_defect':encode(exact-1),'scope':'Pointwise conditional obstruction only; global density is above one.'}

if __name__=='__main__':
    result={'eight_state':verify_eight(),'six_state_conditional_obstruction':verify_six()}
    print(json.dumps(result,indent=2))
