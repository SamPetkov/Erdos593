"""Independent search-agent review of the root's exact projection example.

The archival verifier is copied into a fresh temporary directory and run
there. An independent construction below uses ordinary weighted transition
matrices and Newton identities, rather than importing verifier helpers.
"""
from fractions import Fraction as Q
from itertools import combinations, product
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import tempfile


ROOT=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
inputs={name:sha(ROOT/name)for name in ('continuation4_projection_example.md',
                                     'continuation4_projection_verify.py',
                                     'continuation4_projection_checks.json',
                                     'continuation4_tensor_projection_lemmas.md',
                                     'continuation4_boundary_scope.md')}
with tempfile.TemporaryDirectory(prefix='continuation4_projection_search_review_')as temporary:
    work=Path(temporary)
    source=(ROOT/'continuation4_projection_verify.py').read_bytes()
    (work/'continuation4_projection_verify.py').write_bytes(source)
    completed=subprocess.run([sys.executable,'continuation4_projection_verify.py'],cwd=work,
                             text=True,capture_output=True,check=True)
    reproduced=(work/'continuation4_projection_checks.json').read_bytes()
    assert reproduced==(ROOT/'continuation4_projection_checks.json').read_bytes()
    reproduced_json=json.loads(reproduced)


def mm(A,B):
    return [[sum(x*y for x,y in zip(row,col))for col in zip(*B)]for row in A]


def ident(n):return [[Q(i==j)for j in range(n)]for i in range(n)]


def mpow(A,e):
    R=ident(len(A))
    for _ in range(e):R=mm(R,A)
    return R


def charpoly(A):
    # Newton identities using independently computed power traces.
    n=len(A);power=ident(n);traces=[Q(0)];elementary=[Q(1)]
    for k in range(1,n+1):
        power=mm(power,A);traces.append(sum(power[i][i]for i in range(n)))
        elementary.append(sum((-1)**(i-1)*elementary[k-i]*traces[i]for i in range(1,k+1))/k)
    return [(-1)**k*elementary[k]for k in range(n+1)]


def poly_mul(A,B):
    C=[Q(0)]*(len(A)+len(B)-1)
    for i,a in enumerate(A):
        for j,b in enumerate(B):C[i+j]+=a*b
    return C


pi=[Q(3,5),Q(1,5),Q(1,10),Q(1,10)]
M=[[59,1,0,0],[1,18,1,0],[0,1,8,1],[0,0,1,9]]
s=[sum(row)for row in M];assert s==[60,20,10,10]and sum(s)==100
P0=[[Q(M[i][j],s[i])for j in range(4)]for i in range(4)]
S0=[[P0[i][j]/pi[j]for j in range(4)]for i in range(4)]
S=[[Q(31,32)*S0[i][j]+Q(1,32)for j in range(4)]for i in range(4)]
P=[[S[i][j]*pi[j]for j in range(4)]for i in range(4)]
f=[Q(1),Q(0),Q(-3),Q(-3)]
assert sum(pi[i]*f[i]for i in range(4))==0
assert sum(pi[i]*f[i]**2 for i in range(4))==Q(12,5)
projection=[[1+Q(5,12)*f[i]*f[j]for j in range(4)]for i in range(4)]
Qop=[[projection[i][j]*pi[j]for j in range(4)]for i in range(4)]
assert mm(Qop,Qop)==Qop and all(sum(row)==1 for row in Qop)
assert sum(Qop[i][i]for i in range(4))==2
assert charpoly(Qop)==[Q(1),Q(-2),Q(1),Q(0),Q(0)]
assert mm(P,Qop)!=mm(Qop,P)
Sf=[sum(P[i][j]*f[j]for j in range(4))for i in range(4)]
assert Sf[1]==-Q(31,320)and f[1]==0
assert projection[0][1]*projection[1][2]*projection[2][0]==-Q(1,4)
tp2=[]
for i,j in combinations(range(4),2):
    for k,l in combinations(range(4),2):
        raw=M[i][k]*M[j][l]-M[i][l]*M[j][k]
        relative=S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k]
        assert raw>=0 and relative==Q(10000*raw,s[i]*s[j]*s[k]*s[l])
        tp2.append({'rows':[i,j],'columns':[k,l],'integer_minor':raw,
                    'relative_minor':str(relative)})
assert len(tp2)==36
hold=[P0[i][i]for i in range(4)];assert min(hold)==Q(4,5)
R=[[5*P0[i][j]-4*Q(i==j)for j in range(4)]for i in range(4)]
assert all(x>=0 for row in R for x in row)and all(sum(row)==1 for row in R)
assert all(pi[i]*R[i][j]==pi[j]*R[j][i]for i in range(4)for j in range(4))
assert all(P0[i][i+1]>0 and P0[i+1][i]>0 for i in range(3))
assert all(P0[i][j]==0 for i in range(4)for j in range(4)if abs(i-j)>1)

states=list(product(range(4),(-1,1)));mu=[pi[i]/2 for i,a in states]
beta=Q(1,16384)
T=[[S[i][j]+a*b*projection[i][j]/128 for j,b in states]for i,a in states]
Pfine=[[T[i][j]*mu[j]for j in range(8)]for i in range(8)]
assert all(sum(row)==1 for row in Pfine)
assert all(mu[i]*Pfine[i][j]==mu[j]*Pfine[j][i]for i in range(8)for j in range(8))
assert min(x for row in T for x in row)==Q(3,128)
assert max(x for row in T for x in row)==Q(4499,512)
p=Q(512,4499);W=[[p*x for x in row]for row in T]
assert min(x for row in W for x in row)==Q(12,4499)
assert max(x for row in W for x in row)==1
assert all(sum(mu[j]*W[i][j]for j in range(8))==p for i in range(8))
Aordinary=mm(Pfine,Pfine)
A=[[Aordinary[i][j]/mu[j]for j in range(8)]for i in range(8)]
S2=mm(P,P)
predicted=[[S2[i][j]/pi[j]+a*b*beta*projection[i][j]for j,b in states]for i,a in states]
assert A==predicted
maxA=max(x for row in A for x in row)
assert maxA==Q(2541919,327680)==Q(9929,1280)+Q(19,65536)
assert p<Q(1,4)and maxA>4
assert Q(93,160)**2>beta

# Four ordinary coarse eigenvalues, multiplied by the two beta and two zero
# odd-channel values. Exactly one coarse stationary factor is later removed
# when discussing the centered space.
coarse_char=charpoly(S2);fine_char=charpoly(Aordinary)
expected=poly_mul(poly_mul(coarse_char,[Q(1),-2*beta,beta*beta]),[Q(1),Q(0),Q(0)])
assert fine_char==expected
assert list(map(str,fine_char))==reproduced_json['fine_square_charpoly']

# Direct original-measure density at the minimal boundary tuple, with no
# reference to the verifier's density or channel-contraction helpers.
ordinary_powers={1:Aordinary,2:mm(Aordinary,Aordinary)}
kernels={e:[[ordinary_powers[e][i][j]/mu[j]for j in range(8)]for i in range(8)]for e in (1,2)}
edges=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3));ep=(1,2,1,1,1,1)
F=Q(0)
for colors in product(range(8),repeat=4):
    term=Q(1)
    for vertex in colors:term*=mu[vertex]
    for (i,j),e in zip(edges,ep):term*=kernels[e][colors[i]][colors[j]]
    F+=term
simple_bound=1+4*beta**3+6*beta**4+4*beta**5
assert F>=simple_bound and str(F)==reproduced_json['primary_host']['rows'][0]['F_fine']

# Check the revised quantitative scope on the same already-checked tuple.
# This is not a new search: it verifies the retained coarse density and the
# separation of the one trace cycle from the six further positive cycles.
coarse_powers={1:S2,2:mm(S2,S2)}
coarse_kernels={e:[[coarse_powers[e][i][j]/pi[j]for j in range(4)]for i in range(4)]for e in (1,2)}
Fcoarse=Q(0)
for colors in product(range(4),repeat=4):
    term=Q(1)
    for vertex in colors:term*=pi[vertex]
    for (i,j),e in zip(edges,ep):term*=coarse_kernels[e][colors[i]][colors[j]]
    Fcoarse+=term
assert str(Fcoarse)==reproduced_json['primary_host']['rows'][0]['F_coarse']
qcycles=[4,3,4,3,4,5,5]
assert qcycles==reproduced_json['primary_host']['rows'][0]['cycle_exponents']
channel_lower_surplus=2*sum(beta**q for q in qcycles)
assert F>=Fcoarse+channel_lower_surplus
fine_trace_matrix=mpow(Aordinary,4);coarse_trace_matrix=mpow(S2,4)
fine_trace=sum(fine_trace_matrix[i][i]for i in range(8))
coarse_trace=sum(coarse_trace_matrix[i][i]for i in range(4))
assert fine_trace==coarse_trace+2*beta**4
six_cycle_surplus=2*sum(beta**q for i,q in enumerate(qcycles)if i!=4)
assert six_cycle_surplus==4*beta**3+4*beta**4+4*beta**5
assert Fcoarse>=coarse_trace>=1
assert F>=fine_trace+six_cycle_surplus>fine_trace

assert inputs=={name:sha(ROOT/name)for name in inputs}
out={'verdict':'The exact projection example and the retained-coarse-density quantitative comparison pass this independent review. The reflection boundary already has F>=1 for every actual root, so this is not new density coverage. The unrestricted target remains unresolved.',
     'source_bindings_sha256':inputs,
     'archival_verifier_rerun':'Executed in a fresh temporary directory; archival result left unchanged.',
     'reproduced_archival_checks_byte_identical':True,
     'reproduced_counts':{k:reproduced_json[k]for k in ('lemma_check_count','actual_host_count','actual_host_tuple_count')},
     'independent_exact_checks':{'original_mu':list(map(str,mu)),'original_coarse_pi':list(map(str,pi)),
       'all_36_TP2_minors':tp2,'holding_probabilities':list(map(str,hold)),
       'minimum_holding_probability':str(min(hold)),
       'spectrum_argument':'Positive adjacent entries give a simple symmetric tridiagonal spectrum by eigenvector recurrence. S0=(4/5)I+(1/5)R with reversible stochastic R gives eigenvalues at least 3/5; connectedness makes the eigenvalue one simple. The three centered squares are distinct and exceed beta.',
       'entire_centered_square_values_count':5,'centered_zero_multiplicity':2,
       'channel_beta_multiplicity':2,'rank_Q':2,'Q_preserves_constant':True,
       'Sf_at_zero_coordinate':str(Sf[1]),'S_and_Q_do_not_commute':True,
       'p':str(p),'min_T':'3/128','max_T':'4499/512','max_A':str(maxA),
       'fine_square_characteristic_polynomial':list(map(str,fine_char)),
       'coarse_square_characteristic_polynomial':list(map(str,coarse_char)),
       'minimal_boundary_tuple_F':str(F),'simple_boundary_lower_bound':str(simple_bound),
       'minimal_boundary_coarse_F':str(Fcoarse),
       'minimal_boundary_channel_lower_surplus':str(channel_lower_surplus),
       'minimal_boundary_fine_trace_lower_bound':str(fine_trace),
       'minimal_boundary_coarse_trace_lower_bound':str(coarse_trace),
       'minimal_boundary_six_further_cycle_surplus':str(six_cycle_surplus)},
     'analytical_scope_review':{
       'status':'The following are analytical proof checks, not claims of formal verification or consequences of the finite examples.',
       'generic_reflection_proof':'For twins with incident powers s,t, use the actual source g_ac(b)=K_s(a,b)K_t(c,b). Subtract Pi from the PSD inner-edge kernel, integrate the two actual source factors to K_(s+t), then pair the PSD outside-edge kernel minus Pi with the PSD Schur square K_(s+t) circ K_(s+t). This yields F>=tr(A^(2(s+t)))>=1 under the original measure.',
       'reflection_families':[
         {'vertices':['b','d'],'equalities':['k=u','r=l'],'bound':'tr(A^(2(u+r)))'},
         {'vertices':['a','c'],'equalities':['k=r','u=l'],'bound':'tr(A^(2(u+r)))'},
         {'vertices':['b','c'],'equalities':['k=r+h','u=l'],'bound':'tr(A^(2(k+u)))'}],
       'exhaustiveness':'The other three transpositions require h=0 or r+h<=l, both impossible under the target assumptions.',
       'equality':'F=1 in any of these reflection families forces all centered eigenvalues of A to vanish. Thus A=Pi, and self-adjointness with T1=1 gives T=Pi. The converse holds. Zero modes, disconnected hosts and the one-state case require no changed measure.',
       'paired_star_classification':'All four complementary stars have a repeated pair exactly for r=l,k=u or for r=l=u,k=u+h. Both are ordinary reflection families and give no new density coverage.',
       'projection_comparison':'For H^2=beta Q, d=rank Q, the separate cycle proof retains F(T;n)>=F(S;n)+d sum_C beta^(q_C). Coarse reflection gives F(S;n)>=tr((S^2)^(2(u+r))) on k=u,r=l.',
       'trace_transport':'The original binary-sign decomposition is an orthogonal direct sum: T acts as S on sign-constant functions and H on sign-odd functions. Therefore tr((T^2)^(2(u+r)))=tr((S^2)^(2(u+r)))+d beta^(2(u+r)). No commutation of S and H is needed.',
       'six_extra_cycles':'The quadrilateral abcd has q_C=2(u+r). Removing exactly that term leaves F(T;n)>=tr((T^2)^(2(u+r)))+d sum_(C!=abcd) beta^(q_C), with six additional positive terms when d>0 and beta>0. If d=0 or beta=0 the gain is zero.',
       'arbitrary_channel_scope':'The scalar fine and coarse reflection bounds do not compare F(T;n) with F(S;n). No general coarse-domination conclusion is made for arbitrary H; that comparison retains signed cross terms outside the proved projection mechanism.',
       'novelty':'No novelty claim and no extension of the unrestricted tuple range is made.'},
     'literature_scope':'The coarse TP2-convex certificate is checked as an application of the already-reviewed repository note; no new primary-literature or novelty claim is made by this audit.',
     'review_source_sha256':sha(__file__)}
(ROOT/'continuation4_search_projection_review.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'verdict':out['verdict'],'source_bindings_sha256':inputs,
                  'p':str(p),'max_A':str(maxA),'fine_centered_band_count':5,
                  'archival_output_byte_identical':True},indent=2))
