"""Independent exact four-state checks for the common-cone theorem review."""
from fractions import Fraction as F
from pathlib import Path
import itertools,json,hashlib

HERE=Path(__file__).resolve().parent
def mm(a,b):return [[sum((a[i][k]*b[k][j] for k in range(len(b))),F(0)) for j in range(len(b[0]))] for i in range(len(a))]
def trace(a):return sum((a[i][i] for i in range(len(a))),F(0))
def scale(a,c):return [[c*z for z in row] for row in a]
def add(*a):return [[sum(v[i][j] for v in a) for j in range(len(a[0][0]))] for i in range(len(a[0]))]
def mean(fields,pi):return add(*(scale(a,w) for a,w in zip(fields,pi)))
def val(a):return str(a)

def main():
    theorem=next(p for p in [HERE/'continuation5_cone_theorem.md',HERE/'erdos593-density-continuation/review/2026-10-10-common-power-density/continuation5/continuation5_cone_theorem.md'] if p.exists())
    pi=[F(2,5),F(3,10),F(1,5),F(1,10)];n=4
    flow=[[F(0) for _ in range(n)] for _ in range(n)]
    for i,j,w in [(0,1,F(1,20)),(1,2,F(1,40)),(2,3,F(1,80)),(0,3,F(1,100))]:flow[i][j]=flow[j][i]=w
    for i in range(n):flow[i][i]=pi[i]-sum(flow[i])
    S=[[flow[i][j]/pi[i] for j in range(n)] for i in range(n)]
    C=mm(S,S);Cr=[[C[i][j]/pi[j] for j in range(n)] for i in range(n)]
    f=[F(1),F(2),F(-1),F(3)];norm=sum(pi[i]*f[i]*f[i] for i in range(n))
    Q=[[F(i==j)/pi[j]-f[i]*f[j]/norm for j in range(n)] for i in range(n)]
    qo=[[Q[i][j]*pi[j] for j in range(n)] for i in range(n)]
    assert mm(qo,qo)==qo and trace(qo)==3
    assert Q[0][1]*Q[1][2]*Q[2][0]<0
    assert mm(C,qo)!=mm(qo,C)
    R=[[[Q[i][t]*Q[t][j]*pi[j] for j in range(n)] for i in range(n)] for t in range(n)]
    Z=[mean(R,[C[t][i] for i in range(n)]) for t in range(n)]
    assert mean(R,pi)==mean(Z,pi)==qo
    I=[qo for _ in range(n)]
    def pair(a,b):return sum(pi[t]*trace(mm(a[t],b[t])) for t in range(n))
    def triple(a,b,c):return sum(pi[t]*trace(mm(mm(a[t],b[t]),c[t])) for t in range(n))
    d=F(3);a=pair(R,R);b=pair(R,Z);c=pair(Z,Z)
    assert a>=d and b>=d and c>=d
    fields={'I':R,'Pi':I,'C':Z}
    cases=[(('I','I','I'),a*a/d),(('I','I','Pi'),a),(('I','I','C'),b*b/d),
      (('I','Pi','Pi'),d),(('I','Pi','C'),b),(('I','C','C'),b*b/d),
      (('Pi','Pi','Pi'),d),(('Pi','Pi','C'),d),(('Pi','C','C'),c),(('C','C','C'),c*c/d)]
    checked=[]
    for labels,lower in cases:
        actual=triple(*(fields[k] for k in labels));assert actual>=lower>=d
        for perm in set(itertools.permutations(labels)):assert triple(*(fields[k] for k in perm))==actual
        checked.append(dict(generators=labels,value=val(actual),table_lower=val(lower)))
    coeffs=[(F(1,3),F(1,2),F(1,6)),(F(1,5),F(1,5),F(3,5)),(F(2,7),F(3,7),F(2,7))]
    mixed_fields=[];mixed_kernels=[]
    Irel=[[F(i==j)/pi[j] for j in range(n)] for i in range(n)]
    Pirel=[[F(1) for _ in range(n)] for _ in range(n)]
    for w in coeffs:
        mixed_fields.append([add(scale(R[t],w[0]),scale(qo,w[1]),scale(Z[t],w[2])) for t in range(n)])
        mixed_kernels.append(add(scale(Irel,w[0]),scale(Pirel,w[1]),scale(Cr,w[2])))
    mv=triple(*mixed_fields)
    direct=sum((pi[a]*pi[b]*pi[c]*pi[t]*Q[a][b]*Q[b][c]*Q[c][a]*
      mixed_kernels[0][a][t]*mixed_kernels[1][b][t]*mixed_kernels[2][c][t]
      for a,b,c,t in itertools.product(range(n),repeat=4)),F(0))
    assert mv==direct and mv>=d
    coefchecks=[]
    for x,y in [(F(1,2),F(0)),(F(3,4),F(1,3)),(F(1),F(2,3)),(F(3,5),F(3,5)),(F(1),F(1))]:
        for power in [1,2,5,13]:
            if y==1:alpha,eta,gamma=F(1),F(0),F(0)
            elif x==y:alpha,eta,gamma=y**power,1-y**power,F(0)
            else:
                alpha=y**power;gamma=(1-y)*(x**power-y**power)/(x-y);eta=1-alpha-gamma
                assert alpha+gamma*(x-y)/(1-y)==x**power
            assert min(alpha,eta,gamma)>=0 and alpha+eta+gamma==1
            coefchecks.append(dict(x=val(x),y=val(y),n=power,coefficients=list(map(val,[alpha,eta,gamma]))))
    out=dict(status='passed',reviewer='search5 independent route',
      theorem_file=theorem.name,theorem_sha256=hashlib.sha256(theorem.read_bytes()).hexdigest(),
      review_source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      mathematical_review={
       'original_law':'Checked R_t normalization, tr(Ra Rb Rc)=Qab Qbc Qca, ER=I on range, and LR=QD_LQ.',
       'ten_generators':'All ten cases use a,c>=d by the Hilbert-space mean and b>=d by C-Pi PSD; repeated factors use legitimate two-field HS Cauchy-Schwarz.',
       'permutation_symmetry':'Valid for three real self-adjoint factors by cyclicity and transpose; no sign is inferred from symmetry.',
       'convexity':'Trilinearity and nonnegative coefficients produce a convex combination of the ten types.',
       'quadrilaterals':'The quoted proof uses a nonnegative mixture of rank-one kernels and two pairwise PSD pairings; Schur and operator squares are distinct.',
       'fine_transport':'Original independent signs remove cross terms in composition and odd-degree subsets in the density; all seven remaining cycles are counted.',
       'coefficients':'For x>y, sum x^(n-1-j)y^j<=sum y^j proves Pi coefficient >=0; x=y and y=1 are separately correct.',
       'degeneracies':'Rank0, beta0, a centered zero band, repeated bands, disconnected coarse roots and one-state spaces are consistent with the formulas.',
       'scope':'This remains a restricted binary projection-channel transfer with one common coarse cone. It does not establish the unrestricted target.'},
      exact_fixture=dict(pi=list(map(val,pi)),flow=[[val(z) for z in row] for row in flow],
       projection_form='I - f tensor f / E_pi(f^2)',f=list(map(val,f)),d=3,
       negative_projection_triangle=val(Q[0][1]*Q[1][2]*Q[2][0]),coarse_projection_noncommutation=True,
       a=val(a),b=val(b),c=val(c)),
      ten_generator_checks=checked,mixed_kernel_direct_original_integral=val(mv),
      coefficient_checks=coefchecks,
      limitation='Finite checks supplement the reviewed finite proof and are not a universal computational certificate.')
    outpath=HERE/'continuation5_search_cone_review.json';outpath.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:out[k] for k in ['status','theorem_sha256','review_source_sha256']},indent=2))

if __name__=='__main__':main()
