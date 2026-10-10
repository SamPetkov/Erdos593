"""Independent cover6 review of the rank-two and Jordan packets.

Frozen verifiers are replayed only inside an isolated temporary packet.
Additional finite-example arithmetic below uses ordinary transition
matrices and does not import either packet's arithmetic functions.
"""
from fractions import Fraction as F
from itertools import product, combinations
from pathlib import Path
import hashlib,json,shutil,subprocess,sys,tempfile,time

HERE=Path(__file__).resolve().parent
NAMES=['continuation6_unequal_balanced_rank2.md','continuation6_unequal_balanced_verify.py',
       'continuation6_unequal_balanced_checks.json','continuation6_jordan_contraction.md',
       'continuation6_jordan_examples.md','continuation6_jordan_verify.py',
       'continuation6_jordan_checks.json','continuation6_graded_verify.py']
BASE=HERE.parent
if not (BASE/'tp2-class.md').is_file():
    BASE=HERE/'erdos593-density-continuation/review/2026-10-10-common-power-density'
OLD=BASE/'continuation4/continuation4_projection_verify.py'
TP2=BASE/'tp2-class.md'
EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))

def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def clean(x):
    if isinstance(x,dict):return {k:clean(v) for k,v in x.items() if k!='elapsed_seconds'}
    if isinstance(x,list):return [clean(v) for v in x]
    return x
def ser(x):
    if isinstance(x,F):return str(x)
    if isinstance(x,dict):return {k:ser(v) for k,v in x.items()}
    if isinstance(x,(tuple,list)):return list(map(ser,x))
    return x
def matmul(A,B):
    return [[sum(a*b for a,b in zip(row,col)) for col in zip(*B)] for row in A]
def ident(n):return [[F(i==j) for j in range(n)] for i in range(n)]
def op(K,mu):return [[K[i][j]*mu[j] for j in range(len(mu))] for i in range(len(mu))]
def relative(P,mu):return [[P[i][j]/mu[j] for j in range(len(mu))] for i in range(len(mu))]
def raised(P,n):
    out=ident(len(P))
    for _ in range(n):out=matmul(out,P)
    return out
def trace(P):return sum(P[i][i] for i in range(len(P)))
def action(P,f):return [sum(a*b for a,b in zip(row,f)) for row in P]
def rank(A):
    A=[list(map(F,row)) for row in A];r=0
    for c in range(len(A[0])):
        p=next((i for i in range(r,len(A)) if A[i][c]),None)
        if p is None:continue
        A[r],A[p]=A[p],A[r];z=A[r][c];A[r]=[v/z for v in A[r]]
        for i in range(r+1,len(A)):
            z=A[i][c];A[i]=[v-z*w for v,w in zip(A[i],A[r])]
        r+=1
        if r==len(A):break
    return r
def determinant(A):
    A=[list(map(F,row)) for row in A];out=F(1)
    for c in range(len(A)):
        p=next((i for i in range(c,len(A)) if A[i][c]),None)
        if p is None:return F()
        if p!=c:A[c],A[p]=A[p],A[c];out=-out
        z=A[c][c];out*=z
        for i in range(c+1,len(A)):
            a=A[i][c]/z;A[i]=[v-a*w for v,w in zip(A[i],A[c])]
    return out
def root_check(T,mu):
    assert sum(mu)==1 and min(mu)>0
    P=op(T,mu)
    assert all(sum(row)==1 for row in P)
    assert all(T[i][j]==T[j][i] and T[i][j]>=0 for i,j in product(range(len(mu)),repeat=2))
    return P
def density(K,mu):
    # Independent nested original-measure integration, not a sign expansion.
    n=len(mu);out=F()
    for a,b in product(range(n),repeat=2):
        inner=F()
        for c in range(n):
            inner+=mu[c]*K[1][a][c]*K[3][b][c]*sum(mu[d]*K[2][a][d]*K[4][b][d]*K[5][c][d] for d in range(n))
        out+=mu[a]*mu[b]*K[0][a][b]*inner
    return out
def lift(S,Q,pi,alpha):
    mu=[w/2 for w in pi for _ in (0,1)]
    states=list(product(range(len(pi)),(-1,1)))
    T=[[S[i][j]+a*b*alpha*Q[i][j] for j,b in states] for i,a in states]
    P=root_check(T,mu);p=1/max(map(max,T));W=[[p*x for x in row] for row in T]
    assert min(map(min,W))>0 and max(map(max,W))==1
    assert all(sum(mu[j]*W[i][j] for j in range(len(mu)))==p for i in range(len(mu)))
    return mu,T,P,p,W
def projection_check(Q,pi,d):
    q=op(Q,pi)
    assert matmul(q,q)==q and trace(q)==d and rank(q)==d
    assert all(Q[i][j]==Q[j][i] for i,j in product(range(len(pi)),repeat=2))
    return q
def mixed(S0,eps):return [[(1-eps)*x+eps for x in row] for row in S0]

def rank2_tp2_review(S0):
    pairs=list(combinations(range(6),2))
    minors=[S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k]
            for i,j in pairs for k,l in pairs]
    assert len(minors)==225 and min(minors)==0 and all(v>=0 for v in minors)
    adjacent=[S0[i][i]*S0[i+1][i+1]-S0[i][i+1]*S0[i+1][i] for i in range(5)]
    assert adjacent==list(map(F,('137/4','265/8','277/8','273/8','153/4')))
    assert all(not S0[i][l]*S0[j][k] or (i,j)==(k,l)==(i,i+1)
               for i,j in pairs for k,l in pairs)
    return {'all_TP2_minors_checked':len(minors),'minimum_minor':min(minors),
            'adjacent_principal_minors':adjacent,'crossed_support_reduction_checked':True}

def independent_examples(rank2_stored,jordan_stored):
    pi=[F(1,4),F(1,12)]*3
    base=[[2,1,-1],[1,2,1],[-1,1,2]]
    Q=[[F(base[i//2][j//2]) for j in range(6)] for i in range(6)]
    S0=[[F(x) for x in row] for row in
        [[F(23,6),F(1,2),0,0,0,0],[F(1,2),9,F(1,2),0,0,0],
         [0,F(1,2),F(89,24),F(3,8),0,0],[0,0,F(3,8),F(75,8),F(1,2),0],
         [0,0,0,F(1,2),F(11,3),F(1,2)],[0,0,0,0,F(1,2),F(21,2)]]]
    S=mixed(S0,F(1,16));P0=root_check(S0,pi);P=root_check(S,pi);q=projection_check(Q,pi,2)
    assert min(P0[i][i] for i in range(6))==F(3,4)
    f0=list(map(F,(2,2,-1,-1,-1,-1)));f2=list(map(F,(-1,-1,-1,-1,2,2)))
    assert f0==[Q[0][t]**2-2 for t in range(6)] and f2==[Q[4][t]**2-2 for t in range(6)]
    minor=[[F(1)]*6,f0,f2,action(P0,f0),action(P0,f2),action(raised(P0,2),f0)]
    assert determinant(minor)==-F(9,4096)
    mu,T,PT,p,W=lift(S,Q,pi,F(1,64));assert p==F(16,159)
    assert min(map(min,T))==F(3,64) and min(map(min,W))==F(1,212)
    ns=(3,2,1,1,1,1)
    coarse=density([relative(raised(P,2*s),pi) for s in ns],pi)
    fine=density([relative(raised(PT,2*s),mu) for s in ns],mu)
    row=rank2_stored['fine_host']['rows'][0]
    assert fine==F(row['F_fine']) and coarse==F(row['F_coarse']) and fine>coarse>1
    rank2={'p':p,'min_T':min(map(min,T)),'min_W':min(map(min,W)),
           'observability_minor':determinant(minor),'F_coarse':coarse,'F_fine':fine,
           'full_density_tuple':[3,1,1,1,1],'full_fine_assignments':12**4}
    rank2.update(rank2_tp2_review(S0))

    n=12;pi=[F(1,n)]*n;eps=F(1,1024)
    P0=[[F(0) for _ in range(n)] for _ in range(n)]
    for i in range(n-1):P0[i][i+1]=P0[i+1][i]=eps
    for i in range(n):P0[i][i]=1-sum(P0[i])
    S0=relative(P0,pi);S=mixed(S0,eps);P=root_check(S,pi)
    Pminor=[S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k] for i,j in combinations(range(n),2) for k,l in combinations(range(n),2)]
    assert len(Pminor)==4356 and min(Pminor)>=0
    PP=[[F(base[i//4][j//4]) for j in range(n)] for i in range(n)]
    Q=[[F(i==j)/pi[j]-PP[i][j] for j in range(n)] for i in range(n)]
    q=projection_check(Q,pi,10)
    assert set(Q[i][i] for i in range(n))=={F(10)} and Q[0][1]*Q[1][2]*Q[2][0]==-8
    assert matmul(P,q)!=matmul(q,P)
    B=relative(matmul(P,P),pi)
    ray=sum(pi[i]*B[i][0]*Q[i][0]**2 for i in range(n))/Q[0][0]
    assert ray==F(1711756696579,171798691840)>F(97,10)
    assert (F(97,10)-4)**2>32
    compression=[[pi[t]*Q[i][t]*Q[t][j] for t in range(n)] for i,j in product(range(n),repeat=2)]
    assert rank(compression)==12
    mu,T,PT,p,W=lift(S,Q,pi,F(1,20480))
    assert p==F(262144,3139971) and min(map(min,T))==F(9,10240)
    A=relative(matmul(PT,PT),mu)
    assert max(map(max,A))==F(8215521496079,687194767360)>11
    coarse=density([relative(raised(P,2*s),pi) for s in ns],pi)
    fine=density([relative(raised(PT,2*s),mu) for s in ns],mu)
    stored=jordan_stored['balanced_rank_ten_host']
    assert fine==F(stored['F_fine']) and coarse==F(stored['F_coarse']) and fine>coarse>1
    rank10={'p':p,'min_T':min(map(min,T)),'max_A':max(map(max,A)),'first_source_Rayleigh':ray,
            'all_TP2_minors_checked':len(Pminor),'compression_map_rank':rank(compression),
            'F_coarse':coarse,'F_fine':fine,'full_density_tuple':[3,1,1,1,1],'full_fine_assignments':24**4}

    pi=list(map(F,('3/5','1/5','1/10','1/10')));s=(60,20,10,10)
    G=((59,1,0,0),(1,18,1,0),(0,1,8,1),(0,0,1,9))
    S0=[[F(100*G[i][j],s[i]*s[j]) for j in range(4)] for i in range(4)]
    S=mixed(S0,F(1,32));P=root_check(S,pi)
    f=(1,0,-3,-3);Q=[[1+F(5,12)*f[i]*f[j] for j in range(4)] for i in range(4)]
    q=projection_check(Q,pi,2);B=relative(matmul(P,P),pi)
    cap=max(map(max,B));assert cap==F(9929,1280)<9
    qdiag=[Q[i][i] for i in range(4)];visible=action(matmul(P,P),qdiag)
    assert len(set(visible))>1
    assert all(S0[i][k]*S0[j][l]>=S0[i][l]*S0[j][k] for i,j in combinations(range(4),2) for k,l in combinations(range(4),2))
    mu,T,PT,p,W=lift(S,Q,pi,F(1,128));assert p==F(512,4499)
    old=jordan_stored['old_unbalanced_host_new_cap']
    assert cap==F(old['max_coarse_B']) and visible==list(map(F,old['first_step_actual_traces']))
    unbalanced={'p':p,'first_step_scalar_cap':cap,'visible_trace':visible,
                'balanced_visible_condition_fails':True,'source_cap_below_9':True,
                'coarse_TP2_minors_checked':36}
    return {'balanced_rank2':rank2,'balanced_rank10':rank10,'old_unbalanced_cap':unbalanced}

def main():
    started=time.time();hashes={name:digest(HERE/name) for name in NAMES};hashes['continuation4_projection_verify.py']=digest(OLD)
    hashes['tp2-class.md']=digest(TP2)
    frozen={name:(HERE/name).read_bytes() for name in NAMES}
    replays=[]
    with tempfile.TemporaryDirectory(prefix='e593-cover6-rank-jordan-review-') as temporary:
        base=Path(temporary);stage=base/'continuation6';stage.mkdir();old=base/'continuation4';old.mkdir()
        shutil.copy2(OLD,old/OLD.name)
        shutil.copy2(TP2,base/TP2.name)
        for name in NAMES:
            if name.endswith('.py') or name.endswith('.md'):shutil.copy2(HERE/name,stage/name)
        for source,result in [('continuation6_unequal_balanced_verify.py','continuation6_unequal_balanced_checks.json'),
                              ('continuation6_jordan_verify.py','continuation6_jordan_checks.json')]:
            run=subprocess.run([sys.executable,source],cwd=stage,text=True,capture_output=True,check=True)
            expected=json.loads(frozen[result]);actual=json.loads((stage/result).read_text())
            assert clean(actual)==clean(expected)
            replays.append({'verifier':source,'result':result,'exit_code':run.returncode,
                            'normalized_json_identical':True,'ignored_metadata_only':['elapsed_seconds'] if 'elapsed_seconds' in expected else [],
                            'stdout':run.stdout.strip(),'stderr':run.stderr.strip()})
    rank2=json.loads(frozen['continuation6_unequal_balanced_checks.json']);jordan=json.loads(frozen['continuation6_jordan_checks.json'])
    independent=independent_examples(rank2,jordan)
    assert all((HERE/name).read_bytes()==data for name,data in frozen.items())
    assert digest(OLD)==hashes['continuation4_projection_verify.py']
    assert digest(TP2)==hashes['tp2-class.md']
    out={'status':'PASS','reviewer':'/root/cover6','scope':'independent theorem and finite-example audit; no unrestricted conclusion',
         'reviewed_sha256':hashes,'isolated_exact_replays':replays,'independent_transition_matrix_examples':independent,
         'mathematical_review':{
             'rank2_traceless_identity':'UV+VU=tr(UV)I on real symmetric traceless 2x2 matrices; tr(UVZ)=0 by transpose and cyclic trace symmetry.',
             'rank2_one_step_and_equality':'B diag(Q)=2 makes every positive-time centered field traceless. Original-law spectral expansion includes stationary and zero modes; equality iff BR=I.',
             'projection_channel_transport':'Uniform sign integration gives S^(2n)+sigma*tau*beta^n Q with original pi/2, even for noncentral and noncommuting Q.',
             'quadrilateral_lemma':'Verified two PSD pairings, with pointwise-positive mixture first and Schur square second. No trace product of 3 PSD factors assumed nonnegative.',
             'PSD_field_refinement':'Feature Gram identity proves rational relative Q, actual pulled-back root, and positive-time field transport. No nonzero |H|<=S channel is claimed automatically.',
             'Jordan_interval':'Hilbert--Schmidt Jordan operator is self-adjoint. Bounds [-1,L-1] are quadratic form bounds from PSD Y^2; centering gives radius L/2.',
             'Jordan_cap_threshold':'Using x<=y<=z and nonnegative spectral coefficient squares yields the quadratic coefficient 1+L/2-L^2/16. Its positive endpoint is 4+4sqrt(2).',
             'balanced_rank_interval':'For traceless Y, ||Y||op^2 <= (d-1)||Y||HS^2/d. Compression, not assumed invariance, gives Jordan interval [-1,d-2].',
             'balanced_rank_threshold':'Completion of the square gives (-d^2+10d+7)/16>0 for integers 2 through 10. Rank 1 is constant after smoothing; rank 0 trivial.',
             'Jordan_equality':'Strict cap threshold and ranks <=10 have positive v_z coefficient; spectral positivity implies equality iff BR=I, including extra stationary modes.',
             'spectral_band_counts':'Positive irreducible Jacobi roots have simple spectra; refresh preserves centered eigenvectors and positivity; channel eigenvalue separated by rational lower bounds; characteristic factors retain all zeros.',
             'visibility':'Rank2 explicit source squares and nonzero Krylov minor prove all five coarse bands interact. Independent rank12 diagonal-compression check proves every rank10 example coarse mode interacts.',
             'coarse_density_input':'All-exponent coarse bounds use the explicitly identified prior common-order TP2 convex-hull theorem. The refreshed kernels are not asserted TP2.',
             'scope_boundary':'Source cap and balanced visible rank are hypotheses, not automatic reductions. A coarse density bound and a projection-channel realization remain explicit requirements.'},
         'issues':[],'frozen_inputs_unchanged':True,
         'review_source_sha256':digest(Path(__file__)), 'elapsed_seconds':time.time()-started}
    (HERE/'continuation6_cover_rank2_jordan_review.json').write_text(json.dumps(ser(out),indent=2)+'\n')
    print(json.dumps({'status':'PASS','isolated_replays':len(replays),'independent_actual_examples':len(independent),
                      'frozen_inputs_unchanged':True,'elapsed_seconds':out['elapsed_seconds']}))

def rebind_rank2():
    """Replay only the final TP2 amendment; retain the hash-identical Jordan audit."""
    started=time.time();target=HERE/'continuation6_cover_rank2_jordan_review.json'
    previous_bytes=target.read_bytes();out=json.loads(previous_bytes)
    assert out['status']=='PASS' and not out['issues']
    old_hashes=dict(out['reviewed_sha256'])
    changed=NAMES[:3]
    hashes={name:digest(HERE/name) for name in NAMES}
    hashes['continuation4_projection_verify.py']=digest(OLD)
    hashes['tp2-class.md']=digest(TP2)
    unchanged=[name for name in hashes if name not in changed]
    assert all(hashes[name]==old_hashes[name] for name in unchanged)
    frozen={name:(HERE/name).read_bytes() for name in NAMES}
    with tempfile.TemporaryDirectory(prefix='e593-cover6-rank2-tp2-rebind-') as temporary:
        base=Path(temporary);stage=base/'continuation6';stage.mkdir();old=base/'continuation4';old.mkdir()
        shutil.copy2(OLD,old/OLD.name);shutil.copy2(TP2,base/TP2.name)
        source,result=changed[1:]
        shutil.copy2(HERE/source,stage/source)
        run=subprocess.run([sys.executable,source],cwd=stage,text=True,capture_output=True,check=True)
        expected=json.loads(frozen[result]);actual=json.loads((stage/result).read_text())
        assert actual==expected
    S0=[[F(x) for x in row] for row in expected['primary_S0']]
    assert S0==[[F(x) for x in row] for row in
        [[F(23,6),F(1,2),0,0,0,0],[F(1,2),9,F(1,2),0,0,0],
         [0,F(1,2),F(89,24),F(3,8),0,0],[0,0,F(3,8),F(75,8),F(1,2),0],
         [0,0,0,F(1,2),F(11,3),F(1,2)],[0,0,0,0,F(1,2),F(21,2)]]]
    tp2=rank2_tp2_review(S0)
    assert expected['coarse_tp2']['prior_theorem_sha256']==hashes['tp2-class.md']
    out['isolated_exact_replays'][0]={'verifier':source,'result':result,'exit_code':run.returncode,
        'normalized_json_identical':True,'ignored_metadata_only':[],
        'stdout':run.stdout.strip(),'stderr':run.stderr.strip()}
    out['independent_transition_matrix_examples']['balanced_rank2'].update(tp2)
    out['mathematical_review']['rank2_all_exponent_coarse_input']=(
        'All 225 ordered 2x2 minors of the actual six-state S0 are nonnegative. '
        'A nonzero crossed term forces a principal adjacent pair, whose five determinants are positive. '
        'S0 and Pi use the same original pi. The exact Markov identity '
        'S^(2n)=(15/16)^(2n) S0^(2n)+(1-(15/16)^(2n)) Pi and weighted Cauchy--Binet '
        'put every coarse power in the previously proved common-order convex-TP2 class. '
        'Corollaries 2 and 3 of the hash-bound prior theorem give the all-exponent coarse density bound. '
        'Combining with the actual projection-channel identity proves F_fine>=1+2 sum_D beta^q_D '
        'for this host at every six positive exponents; no convex-mixture TP2 or fine-root TP2 claim is made.')
    out['amendment']={
        'reason':'Final rank2 packet adds the named all-exponent convex-TP2 coarse input.',
        'previous_review_sha256':hashlib.sha256(previous_bytes).hexdigest(),
        'previous_review_source_sha256':out['review_source_sha256'],
        'superseded_rank2_input_sha256':{name:old_hashes[name] for name in changed},
        'retained_hash_identical_input_sha256':{name:hashes[name] for name in unchanged},
        'new_replay_count':1,'new_independent_TP2_minor_checks':225,
        'unrelated_Jordan_replay_and_independent_examples_retained':True,
        'elapsed_seconds':time.time()-started}
    assert all((HERE/name).read_bytes()==data for name,data in frozen.items())
    assert digest(OLD)==hashes['continuation4_projection_verify.py'] and digest(TP2)==hashes['tp2-class.md']
    out['reviewed_sha256']=hashes;out['review_source_sha256']=digest(Path(__file__))
    out['frozen_inputs_unchanged']=True
    target.write_text(json.dumps(ser(out),indent=2)+'\n')
    print(json.dumps({'status':'PASS','amended_rank2_replays':1,'independent_TP2_minors':225,
                      'unrelated_reviews_retained':True,'frozen_inputs_unchanged':True}))

if __name__=='__main__':
    if '--rank2-rebind' in sys.argv:rebind_rank2()
    else:main()
