"""Independent exact audit of the projection-channel contractions."""
from fractions import Fraction as Q
from itertools import product
from pathlib import Path
import hashlib,json
from continuation4_cover_verify import weighted,power,mm,tr,rank

pi=[Q(1,2),Q(1,4),Q(1,8),Q(1,8)];n=4
V=[[1,0],[1,1],[-1,1],[0,-2]]
G=[[sum(pi[t]*V[t][i]*V[t][j] for t in range(n)) for j in range(2)] for i in range(2)]
det=G[0][0]*G[1][1]-G[0][1]*G[1][0]
inv=[[G[1][1]/det,-G[0][1]/det],[-G[1][0]/det,G[0][0]/det]]
P=mm(mm(V,inv),[list(x) for x in zip(*V)])
assert weighted(P,P,pi)==P and rank(P)==2
assert min(x for row in P for x in row)<0
assert any(sum(pi[j]*P[i][j] for j in range(n)) for i in range(n))
f=[Q(1),Q(-2),Q(0),Q(0)];g=[Q(1),Q(0),Q(-4),Q(0)]
nf=sum(pi[i]*f[i]**2 for i in range(n));ng=sum(pi[i]*g[i]**2 for i in range(n))
assert sum(pi[i]*f[i] for i in range(n))==sum(pi[i]*g[i] for i in range(n))==0
Pf=[[f[i]*f[j]/nf for j in range(n)] for i in range(n)]
Pg=[[g[i]*g[j]/ng for j in range(n)] for i in range(n)]
L=[[1+Pf[i][j]/16 for j in range(n)] for i in range(n)]
M=[[1+Pg[i][j]/64 for j in range(n)] for i in range(n)]
assert weighted(L,M,pi)!=weighted(M,L,pi)
assert all(x>0 for a in (L,M) for row in a for x in row)

inner=lambda a,b:sum(pi[i]*pi[j]*a[i][j]*b[i][j] for i in range(n) for j in range(n))
operator_trace=lambda a:sum(pi[i]*a[i][i] for i in range(n))
J=sum(pi[a]*pi[b]*pi[c]*pi[d]*P[a][b]*P[b][c]*P[c][d]*P[d][a]*L[a][c]*M[b][d] for a,b,c,d in product(range(n),repeat=4))
GG=[[sum(pi[b]*pi[d]*M[b][d]*P[a][b]*P[a][d]*P[c][b]*P[c][d] for b,d in product(range(n),repeat=2)) for c in range(n)] for a in range(n)]
surplus1=inner([[x-1 for x in row] for row in L],GG)
surplus2=inner([[x-1 for x in row] for row in M],[[x*x for x in row] for row in P])
assert surplus1>=0 and surplus2>=0 and J-2==surplus1+surplus2

S=[[1+Pf[i][j]/8+Pg[i][j]/16 for j in range(n)] for i in range(n)]
assert min(x for row in S for x in row)>0
assert all(sum(pi[j]*S[i][j] for j in range(n))==1 for i in range(n))
A=weighted(S,S,pi)
def compressed(f):return [[sum(pi[j]*P[i][j]*f[j]*P[j][k] for j in range(n)) for k in range(n)] for i in range(n)]
rows=[]
for x,z in [(1,1),(2,5),(4,1)]:
    Ax=power(A,x,pi);Az=power(A,z,pi)
    B=[compressed(Ax[t]) for t in range(n)];C=[compressed(Az[t]) for t in range(n)]
    gg=sum(pi[t]*operator_trace(weighted(B[t],C[t],pi)) for t in range(n))
    fieldJ=sum(pi[t]*operator_trace(weighted(weighted(B[t],B[t],pi),C[t],pi)) for t in range(n))
    directJ=sum(pi[a]*pi[b]*pi[c]*pi[d]*P[a][b]*P[b][c]*P[c][a]*Ax[a][d]*Ax[b][d]*Az[c][d] for a,b,c,d in product(range(n),repeat=4))
    assert fieldJ==directJ and gg>=2 and 2*directJ>=gg*gg
    assert directJ>2 # This particular actual host/projection has a strict surplus.
    rows.append({'x':x,'z':z,'g':str(gg),'J':str(directJ),'cauchy_schwarz_defect':str(2*directJ-gg*gg)})
# Formula (13) holds for centered unit vectors under the original heavy law.
P0=[[Q(i==j)/pi[i]-1 for j in range(n)] for i in range(n)]
for phi in [[Q(1),-Q(1),-Q(1),-Q(1)],[Q(0),Q(0),Q(2),-Q(2)]]:
    assert sum(pi[i]*phi[i] for i in range(n))==0 and sum(pi[i]*phi[i]**2 for i in range(n))==1
    B0=[[sum(pi[j]*P0[i][j]*phi[j]*P0[j][k] for j in range(n)) for k in range(n)] for i in range(n)]
    assert inner(B0,B0)==sum(x*x for x in phi)-2

note=Path('continuation4_tensor_projection_lemmas.md')
reviewed_note_sha256=hashlib.sha256(note.read_bytes()).hexdigest()
assert reviewed_note_sha256=='9d4a862b2d62a5d064ed8a9ae84f5df7de599ec02d31a52896b75b665805491c'
out={'status':'pass','reviewed_note_sha256':reviewed_note_sha256,
     'reviewer_source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
     'original_pi':list(map(str,pi)),'projection':[[str(x) for x in row] for row in P],
     'projection_rank':2,'projection_has_negative_entries':True,'projection_does_not_annihilate_constants':True,
     'quadrilateral':{'J':str(J),'first_surplus':str(surplus1),'second_surplus':str(surplus2),'L_M_noncommuting':True},
     'paired_star_checks':rows,
     'mathematical_review':{'quadrilateral':'Both reductions are pairwise PSD pairings; the first auxiliary kernel is a nonnegative rank-one mixture. Q^2=Q is used only under the original pi law.',
      'paired_star':'The R-field has mean I on ran Q; A^(x+z) is PSD on each matrix coefficient. The Hilbert-Schmidt Cauchy-Schwarz pairing is B C^(1/2) with C^(1/2), giving J=E tr(B^2 C), not an unjustified trace-of-three positivity.',
      'spectral_surplus':'Each Fourier coefficient of R is exactly Q D_phi Q. Additional eigenvalue-one modes of disconnected A and zero modes are retained.',
      'weighted_norm_formula':'Multiplication by phi has HS square sum_i phi(i)^2 without pi because the operator basis is 1_i/sqrt(pi_i); removing the constant row and column subtracts two and adds zero.',
      'boundary':'At k=u,r=l the four complementary stars are exactly (u,u,r),(r+h,r,r),(u,r,u),(u,r+h,u); all have a repeated pair.',
      'second_paired_star_region':'The star at c forces r=l. If k differs from u, repetition at a and b forces k=r+h and r=u. Thus the only other ordered target region is r=l=u,k=u+h, which has a direct b,c reflection.',
      'trace_comparison':'In formula (15), the fine square splits as S^2 on the constant binary fiber and beta Q on the signed binary fiber. Its trace at power 2(u+r) is tr((S^2)^(2(u+r)))+d beta^(2(u+r)). The quadrilateral ab,bc,cd,da has exponent sum 2(u+r), so the coarse trace plus seven cycle terms exceeds the direct fine trace by the remaining six terms; the excess is strictly positive when d>0 and beta>0.',
      'reflection_scope':'For every actual root at k=u,r=l, reflection first uses K_u-Pi against the actual source and then K_(r+h)-Pi against the Schur square of K_(u+r), giving F>=tr A^(2(u+r))>=1. The projection assumption adds a comparison with the original coarse density, not new density coverage.',
      'scope':'Restricted quantitative comparison for actual H^2=beta Q, with coarse density and cycle surplus retained on the stated paired-star regions. Both ordered target regions already have direct reflection density proofs. The unrestricted target and arbitrary-channel coarse comparison remain unresolved.'}}
Path('continuation4_cover_peer_review.json').write_text(json.dumps(out,indent=2)+'\n')
print('PROJECTION_CONTRACTION_PEER_REVIEW_PASSED',out['reviewed_note_sha256'])
