"""Independent coefficient reconstruction and proof audit of one-edge covers.

No author arithmetic is imported. Moments are obtained from the original
32 states; generic vertex incidence, rather than a prewritten tensor
contraction, reconstructs every coefficient. The literal source/density
and weighted-cover checks are also replayed in an isolated directory.
"""
from fractions import Fraction as F
from itertools import product
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile

HERE=Path(__file__).resolve().parent
EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
INCIDENT=[tuple(e for e,(a,b) in enumerate(EDGES) if v in (a,b))
          for v in range(4)]


def prod(xs):
    ans=1
    for x in xs:
        ans*=x
    return ans


def decode(d):
    return F(int(d['numerator']),1<<d['denominator_power_of_two'])


def main():
    names=['continuation6_cover_moments.md','continuation6_cover_moments_verify.py',
           'continuation6_cover_moments_checks.json']
    hashes={n:hashlib.sha256((HERE/n).read_bytes()).hexdigest() for n in names}
    saved=json.loads((HERE/names[2]).read_text())
    states=[]
    for row in product((-1,1),repeat=6):
        stars=[prod(row[e] for e in inc) for inc in INCIDENT]
        if stars[0]+stars[1]+stars[2]-stars[3]==2:
            states.append(row)
    assert len(states)==32 and set(states)==set(map(tuple,saved['states']))
    phi=[(1,)+row for row in states]
    assert all(sum(row[i]*row[j] for row in phi)==32*(i==j)
               for i,j in product(range(7),repeat=2))
    moments={(i,j,k):F(sum(row[i]*row[j]*row[k] for row in phi),32)
             for i,j,k in product(range(7),repeat=3)}
    root=[F(1,2**b) for b in (64,5,2,3,4,3)]
    theta=[F(1)]+[v*v for v in root]
    # Verify the actual host independently in rational relative coordinates.
    T=[[F(1)+sum(s*a*b for s,a,b in zip(root,x,y)) for y in states]
       for x in states]
    assert min(v for row in T for v in row)>0
    assert all(sum(row)==32 for row in T)
    maximum=max(v for row in T for v in row)
    assert maximum==F(51,32)+F(1,2**64)
    pp=1/maximum
    assert pp==F(int(saved['p']['numerator']),int(saved['p']['denominator']))
    # Reconstruct all coefficients from generic graph incidence.
    n=(4,9,4,1,4,1)
    coeff=[[[F(0) for _ in range(7)] for _ in range(7)] for _ in EDGES]
    count=0
    for labels in product(range(7),repeat=6):
        m=prod(moments[tuple(labels[e] for e in inc)] for inc in INCIDENT)
        if not m:
            continue
        count+=1
        term=m*prod(theta[labels[e]]**n[e] for e in range(1,6))
        for e in range(6):
            coeff[e][labels[e]][labels[0]]+=term
    assert count==235
    archived=[[[decode(z) for z in row] for row in matrix]
              for matrix in saved['edge_eigenvalue_coefficient_matrices']]
    assert coeff==archived
    assert all(coeff[0][i][j]==0 for i,j in product(range(7),repeat=2) if i!=j)
    q=[coeff[0][i][i] for i in range(7)]
    assert q==[decode(d) for d in saved['q_ab_source']]
    assert 1<q[0]<1+F(1,2**23)
    assert -F(1,2**117)<q[1]<-F(66554167313,2**154)<0
    assert F(1,2**25)<q[3]<F(1,2**23)
    assert all(q[i]>0 for i in (2,4,5,6))
    intervals={}
    for e,name in enumerate(('ab','ac','ad','bc','bd','cd')):
        if e==0:
            continue
        pairs=[]
        for row in coeff[e]:
            lower=row[0]+sum(min(F(0),row[j])*theta[j]**4 for j in range(1,7))
            upper=row[0]+sum(max(F(0),row[j])*theta[j]**4 for j in range(1,7))
            pairs.append((lower,upper))
        assert pairs[0][0]>=1
        assert pairs[3][0]>F(1,2**60) and pairs[3][1]<1
        assert pairs[1][0]>-F(1,2**200)
        assert all(pairs[i][0]>0 for i in (2,4,5,6))
        archived_pairs=[(decode(d['lower']),decode(d['upper']))
                        for d in saved['all_k_ge4_bounds_for_non_ab_edges'][name]]
        assert pairs==archived_pairs
        intervals[name]=True
    eig4=[[sum(coeff[e][i][j]*theta[j]**4 for j in range(7))
           for i in range(7)] for e in range(6)]
    F4=decode(saved['F_at_k4'])
    assert all(sum(eigs)==F4 for eigs in eig4) and F4>1
    assert eig4[0][1]<0 and eig4[2][1]<0
    for e,eigs in enumerate(eig4):
        defect=F4*F4-sum(v*v for v in eigs)
        assert defect>(F(1,2**41) if e==0 else F(1,2**60))
    with tempfile.TemporaryDirectory(prefix='e593_one_edge_independent_') as td:
        shutil.copy2(HERE/names[1],Path(td)/names[1])
        subprocess.run([sys.executable,names[1]],cwd=td,text=True,
                       capture_output=True,check=True)
        replay=json.loads((Path(td)/names[2]).read_text())
    a=dict(saved);b=dict(replay)
    a.pop('elapsed_seconds');b.pop('elapsed_seconds')
    assert a==b
    assert hashes=={n:hashlib.sha256((HERE/n).read_bytes()).hexdigest() for n in names}
    proof_checks=[
      {'item':'Original measure and orientation','detail':'Integrating y_a in the one-edge cover pairs D(x_a,y_a) with K(x_sigma_inverse(a),y_a), giving R(x_sigma_inverse(a),x_a). Disjoint permutation cycles factor under the unchanged full product measure.'},
      {'item':'Real spectrum is proved only for this host','detail':'The range is the seven active characters. Simultaneous triangle sign flips preserve the original law and kernels; seven distinct characters diagonalize the active compression of D. The complementary block can map into the active range but cannot change eigenvalues or power traces.'},
      {'item':'Second moment controls all lengths','detail':'Real eigenvalues, with algebraic multiplicity, give tr(R^m)=sum lambda^m even without diagonalizability. The l_m<=l_2 inequality yields absolute trace at most tr(R^2)^(m/2). Entrywise nonnegative actual R makes every power trace nonnegative, permitting multiplication over cycles.'},
      {'item':'Negative mode budget','detail':'For rho>=1,0<w<1,z>=-w/4, the three-mode square defect exceeds w: when z<0 it is at least3w/2-w^2/2>w. The sum of those modes is positive, so adding other nonnegative modes increases the defect.'},
      {'item':'Infinite k range','detail':'All k dependence is exactly theta_j^k in the reconstructed coefficients. For k>=4, 0<=theta_j^k<=theta_j^4 proves each signed coefficient interval. For ab, the exact bounds give -z/w<2^(-124k-92)<1/4 and w>2^(-(4k+25)).'},
      {'item':'Strict all-sheet deficit','detail':'The certified trace-square gap is strictly larger than delta_e(k)>0. Real spectrum and rho>=1 also ensure F^2-delta_e(k)>0. Each nontrivial permutation cycle contributes at most that quantity to the appropriate half power; identity cycles contribute F exactly.'},
      {'item':'Spectral count','detail':'The six centered active functions have five positive square values, with the value2^-6 repeated; the other25 centered eigenvalues vanish. Zero is a sixth entire-centered value, not omitted from the band count.'},
      {'item':'Scope barrier','detail':'The proof covers one permuted edge among six, all sheet counts, and the displayed tuple family on one reused actual host. It does not factor arbitrary multi-edge permutations, establish real spectra for arbitrary hosts, prove global cover domination, or supply a density counterexample.'}
    ]
    out={'reviewer':'/root/unequal6','status':'PASS_FOR_STATED_ONE_EDGE_FAMILY',
         'reviewed_files':hashes,'review_source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         'independent_coefficient_reconstruction':{'original_state_count':32,
             'original_third_moments_checked':343,'nonzero_tetrahedron_assignments':count,
             'edge_mode_coefficient_count':294,'all_five_signed_interval_tables_match':intervals,
             'actual_negative_ab_eigenvalue_at_every_k_ge4':True,
             'actual_negative_ad_eigenvalue_at_k4':True},
         'proof_checks':proof_checks,
         'isolated_author_replay_matches_except_elapsed_seconds':True,
         'author_literal_checks_replayed':{'source_entries':49,'original_density_assignments':1048576,
                                         'weighted_cover_controls':8,'assignments_per_cover_control':4096},
         'original_files_unchanged':True,
         'scope':'One-edge all-sheet comparisons only; unrestricted target and all-edge cover comparison remain unresolved.'}
    (HERE/'continuation6_unequal_cover_review.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({'status':'PASS','independent_coefficients':294,'proof_checks':len(proof_checks),
                      'original_states':32,'isolated_author_replay':'PASS'}))


if __name__=='__main__':
    main()
