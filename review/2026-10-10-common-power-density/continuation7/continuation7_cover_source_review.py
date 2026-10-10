"""Independent original-matrix review of the weighted complement theorem.

No author implementation is imported. Operators are represented as ordinary
transition matrices on the original weighted space; compressed fields are
formed in the full ambient space and annihilate the complement exactly.
"""
from fractions import Fraction as Q
from itertools import combinations
from pathlib import Path
import hashlib,json

def eye(n):return [[Q(i==j) for j in range(n)] for i in range(n)]
def mul(a,b):
    return [[sum((a[i][k]*b[k][j] for k in range(len(b))),Q(0))
             for j in range(len(b[0]))] for i in range(len(a))]
def power(a,s):
    r=eye(len(a))
    while s:
        if s&1:r=mul(r,a)
        a=mul(a,a);s//=2
    return r
def trace(a):return sum((a[i][i] for i in range(len(a))),Q(0))
def sub(a,b):return [[x-y for x,y in zip(ra,rb)] for ra,rb in zip(a,b)]
def det(a):
    a=[r[:] for r in a];out=Q(1);n=len(a)
    for j in range(n):
        pivot=next((i for i in range(j,n) if a[i][j]),None)
        if pivot is None:return Q(0)
        if pivot!=j:a[pivot],a[j]=a[j],a[pivot];out=-out
        t=a[j][j];out*=t
        for i in range(j+1,n):
            q=a[i][j]/t
            for k in range(j+1,n):a[i][k]-=q*a[j][k]
    return out

def audit(pi,P,tu):
    n=len(pi);one=eye(n);f=[Q((-1)**i) for i in range(n)]
    assert sum(pi)==1 and min(pi)>0
    assert all(min(row)>=0 and sum(row)==1 for row in P)
    assert all(pi[i]*P[i][j]==pi[j]*P[j][i] for i in range(n) for j in range(n))
    q=[[one[i][j]-f[i]*pi[j]*f[j] for j in range(n)] for i in range(n)]
    assert mul(q,q)==q and trace(q)==n-1
    R=[[[q[i][z]*q[z][j]/pi[z] for j in range(n)] for i in range(n)] for z in range(n)]
    assert [[sum(pi[z]*R[z][i][j] for z in range(n)) for j in range(n)] for i in range(n)]==q
    x,y,z=sorted(tu);times=set((x,y,z,x+y,x+z,y+z,2*y,2*z))
    ps={s:power(P,2*s) for s in times}
    L={s:[[ps[s][i][j]/pi[j]-1 for j in range(n)] for i in range(n)] for s in times}
    fields={s:[[[sum(ps[s][i][t]*R[t][v][w] for t in range(n))
                 for w in range(n)] for v in range(n)] for i in range(n)] for s in (x,y,z)}
    centered={s:[sub(A,q) for A in fields[s]] for s in (x,y,z)}
    J=sum(pi[i]*trace(mul(mul(fields[x][i],fields[y][i]),fields[z][i])) for i in range(n))
    C=sum(pi[i]*trace(mul(mul(centered[x][i],centered[y][i]),centered[z][i])) for i in range(n))
    gs={(s,t):sum(pi[i]*trace(mul(centered[s][i],centered[t][i])) for i in range(n))
        for s,t in ((x,y),(x,z),(y,z))}
    a=[1/pi[i]-n for i in range(n)];delta=max(map(abs,a));m=n-2-delta;M=n+delta-1
    sig={s:trace(ps[s])-1 for s in times}
    for s,t in ((x,y),(x,z),(y,z)):
        spectral=(n-2)*sig[s+t]+sum(a[i]*(ps[s+t][i][i]-pi[i]) for i in range(n))
        assert gs[s,t]==spectral and gs[s,t]>=m*sig[s+t]
    assert J-(n-1)==gs[x,y]+gs[x,z]+gs[y,z]+C
    H=[[L[x][i][j]*L[y][i][j]*L[z][i][j] for j in range(n)] for i in range(n)]
    for size in range(1,n+1):
        for ix in combinations(range(n),size):assert det([[H[i][j] for j in ix] for i in ix])>=0
    h11=sum(pi[i]*pi[j]*H[i][j] for i in range(n) for j in range(n))
    ha1=sum(pi[i]*pi[j]*a[i]*H[i][j] for i in range(n) for j in range(n))
    haa=sum(pi[i]*pi[j]*a[i]*a[j]*H[i][j] for i in range(n) for j in range(n))
    assert C==(n-3)*h11+ha1
    assert 4*(n-3)*C+haa>=0
    assert haa>=0 and haa*haa<=delta**4*M*M*sig[2*y]*sig[2*z]
    assert m>0 and delta*delta*M<=8*(n-3)*m
    lower=m*sig[x+z]+(m-delta*delta*M/Q(8*(n-3)))*(sig[x+y]+sig[y+z])
    assert J-(n-1)>=lower>=0
    square_left=m*(sig[2*y]+2*sig[2*z])-(J-(n-1))
    assert square_left<=0 or square_left*square_left<=4*m*m*sig[2*y]*sig[2*z]
    refresh=[[pi[j] for j in range(n)] for i in range(n)]
    assert (J==n-1)==(P==refresh)
    return {'n':n,'pi':list(map(str,pi)),'times':tu,'delta':str(delta),
            'J':str(J),'centered_cubic':str(C),'Schur_error':str(haa),
            'quantitative_lower':str(lower),'visible_trace':list(map(str,[trace(A) for A in fields[x]])),
            'negative_Schur_entries':sum(H[i][j]<0 for i in range(n) for j in range(n))}

def path(pi):
    n=len(pi);P=eye(n);c=Q(1,1000)
    for i in range(n-1):
        P[i][i+1]=c/pi[i];P[i+1][i]=c/pi[i+1]
        P[i][i]-=c/pi[i];P[i+1][i+1]-=c/pi[i+1]
    return [[Q(12,13)*P[i][j]+pi[j]/13 for j in range(n)] for i in range(n)]

def large_example_parameters():
    n=13;pi=[Q(17,208),Q(15,208)]+[Q(1,13)]*11
    P0=eye(n);c=Q(1,4096)
    for i in range(n-1):
        P0[i][i+1]=c/pi[i];P0[i+1][i]=c/pi[i+1]
        P0[i][i]-=c/pi[i];P0[i+1][i+1]-=c/pi[i+1]
    assert min(P0[i][i] for i in range(n))==Q(1907,1920)
    assert 2*min(P0[i][i] for i in range(n))-1==Q(947,960)
    S0=[[P0[i][j]/pi[j] for j in range(n)] for i in range(n)]
    assert all(S0[i][k]*S0[j][l]>=S0[i][l]*S0[j][k]
               for i,j in combinations(range(n),2) for k,l in combinations(range(n),2))
    S=[[Q(1023,1024)*S0[i][j]+Q(1,1024) for j in range(n)] for i in range(n)]
    f=[Q((-1)**i) for i in range(n)]
    qr=[[Q(i==j)/pi[i]-f[i]*f[j] for j in range(n)] for i in range(n)]
    qo=[[qr[i][j]*pi[j] for j in range(n)] for i in range(n)]
    P=[[S[i][j]*pi[j] for j in range(n)] for i in range(n)]
    assert mul(P,qo)!=mul(qo,P)
    B=mul(P,P)
    visible=[sum(B[i][j]*qr[j][j] for j in range(n)) for i in range(n)]
    assert len(set(visible))>1
    cap=P[1][1]**2*qr[1][1]
    assert cap>12
    alpha=Q(1,32768);beta=alpha*alpha
    states=[(i,s) for i in range(n) for s in (-1,1)]
    mu=[pi[i]/2 for i,s in states]
    T=[[S[i][j]+s*t*alpha*qr[i][j] for j,t in states] for i,s in states]
    assert min(map(min,T))==Q(31,32768)
    assert max(map(max,T))==Q(11272763,819200)
    p=1/max(map(max,T));assert p==Q(819200,11272763)
    assert p*min(map(min,T))==Q(775,11272763)
    Pf=[[T[i][j]*mu[j] for j in range(26)] for i in range(26)]
    assert all(sum(r)==1 for r in Pf)
    Af=mul(Pf,Pf)
    assert all(Af[a][b]/mu[b]==B[i][j]/pi[j]+s*t*beta*qr[i][j]
               for a,(i,s) in enumerate(states) for b,(j,t) in enumerate(states))
    return {'pi':list(map(str,pi)),'p':str(p),'source_cap_lower':str(cap),
            'min_T':str(min(map(min,T))),'max_T':str(max(map(max,T))),
            'weighted_TP2_minors':6084,'actual_fine_square_checked':True}

def main():
    cases=[]
    pi=[Q(1,5),Q(4,15),Q(4,15),Q(4,15)]
    for tu in ((1,2,5),(1,1,1),(1,1,2)):cases.append(audit(pi,path(pi),tu))
    pi=[Q(1,4),Q(1,4),Q(1,6),Q(1,6),Q(1,6)]
    P=[[2*pi[j] if ((i<2)!=(j<2)) else Q(0) for j in range(5)] for i in range(5)]
    r=audit(pi,P,(1,2,5));assert len(set(r['visible_trace']))==2;cases.append(r)
    pi=[Q(1,4)]*4
    cases.append(audit(pi,eye(4),(1,2,5)))
    cases.append(audit(pi,[[pi[j] for j in range(4)] for i in range(4)],(1,2,5)))
    pi=[Q(1,5),Q(1,4),Q(1,4),Q(3,10)]
    v=[Q(-4),Q(-4),Q(-1),Q(41,6)]
    assert sum(pi[i]*v[i] for i in range(4))==0
    norm=sum(pi[i]*v[i]*v[i] for i in range(4));assert norm==Q(515,24)
    third=sum(pi[i]*v[i]**3 for i in range(4));assert third==Q(9601,144)
    projected=sum(t**3 for t in v)-3*third;assert projected==Q(-4295,432)
    P=[[(1+v[i]*v[j]/128)*pi[j] for j in range(4)] for i in range(4)]
    r=audit(pi,P,(1,2,3));assert Q(r['centered_cubic'])==(norm/128)**12*third*projected/norm**3<0
    cases.append(r)
    large=large_example_parameters()
    note=Path('continuation7_source_weighted_complement.md')
    result={'reviewer':'cover7','status':'PASS','independent_cases':cases,
            'independent_large_example_parameters':large,
            'author_implementation_imported':False,'reviewed_note_sha256':hashlib.sha256(note.read_bytes()).hexdigest(),
            'proof_checks':[
              'Weighted diagonal trace is unweighted sum, equivalently E_pi[(n+a)g].',
              'All two-P and three-P cubic terms contain an individual centered mean and vanish.',
              'H is a Schur product PSD operator under diagonal congruence; no entrywise positivity used.',
              'The same H controls both cubic uniform term and reciprocal-mass perturbation.',
              'The complete-square coefficient is exactly1/[4(n-3)].',
              'Original Hilbert-Schmidt norms give sigma_2y and sigma_2z.',
              'Spectral ordering and arithmetic-geometric mean give the factor1/[8(n-3)].',
              'The m sigma_(x+z) term retains strictness even at the other coefficient endpoint.',
              'S^2=Pi implies S=Pi for the stipulated actual self-adjoint Markov root.',
              'The delta<=sqrt(n)/2 sufficient range is valid at n=4 and all larger n.',
              'The stated n=13 path holding bound1907/1920 and eigenvalue bound947/960 check exactly.',
              'The source-cap obstruction uses a positive actual source summand; invertibility preserves nonconstant trace.',
              'The binary sign-channel composition needs no commutation between coarse S and Q.'
            ]}
    Path('continuation7_cover_source_review.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS independent ordinary-matrix cases',len(cases))

if __name__=='__main__':main()
