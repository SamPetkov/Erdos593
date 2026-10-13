"""Exact actual-host obstruction to pointwise unequal-star positivity.

Only Python's standard library is used.  The averaged contraction and the
requested density inequality are NOT refuted; this host has F>15.
"""
from fractions import Fraction as R
from pathlib import Path
import hashlib, json

def transpose(a):return [list(v) for v in zip(*a)]
def mm(a,b):
    return [[sum((a[i][k]*b[k][j] for k in range(len(b))),R(0))
             for j in range(len(b[0]))] for i in range(len(a))]
def wm(a,b,pi):return mm([[x*pi[k] for k,x in enumerate(row)] for row in a],b)
def eye(n):return [[R(i==j) for j in range(n)] for i in range(n)]
def powers(a,pi,cap):
    out={1:a}
    for j in range(2,cap+1):out[j]=wm(out[j-1],a,pi)
    return out
def tr(a):return sum((a[i][i] for i in range(len(a))),R(0))
def inv2(a):
    d=a[0][0]*a[1][1]-a[0][1]*a[1][0]
    assert d>0
    return [[a[1][1]/d,-a[0][1]/d],[-a[1][0]/d,a[0][0]/d]]
def frac(x):return f'{x.numerator}/{x.denominator}'
def det(a):
    a=[row[:] for row in a];s=R(1)
    for k in range(len(a)):
        j=next(i for i in range(k,len(a)) if a[i][k])
        if j!=k:a[k],a[j]=a[j],a[k];s=-s
        q=a[k][k];s*=q
        for i in range(k+1,len(a)):
            f=a[i][k]/q
            for j in range(k+1,len(a)):a[i][j]-=f*a[k][j]
    return s

def characteristic(a):
    n=len(a);B=eye(n);out=[R(1)]
    for k in range(1,n+1):
        C=mm(a,B);c=-tr(C)/k;out.append(c)
        B=[[C[i][j]+(c if i==j else 0) for j in range(n)] for i in range(n)]
    return out

def build():
    q=64;delta=R(1,2**16);alpha=delta/8;beta=alpha**2
    D=2*sum(q**i for i in range(6))+q**6
    G=[[R(0) for _ in range(7)] for _ in range(7)]
    for i in range(6):G[i][i+1]=G[i+1][i]=R(q**i)
    G[6][6]=R(q**6)
    s=[sum(row) for row in G];assert sum(s)==D
    pi=[v/(2*D) for v in s]+[R(1,4),R(1,4)]
    P0=[[R(0) for _ in range(9)] for _ in range(9)]
    for i in range(7):
        for j in range(7):P0[i][j]=G[i][j]/s[i]
    P0[7][7]=P0[8][8]=R(1)
    S0=[[P0[i][j]/pi[j] for j in range(9)] for i in range(9)]
    S=[[(1-delta)*S0[i][j]+delta for j in range(9)] for i in range(9)]
    V=[[R(0),R(0)] for _ in range(9)]
    V[2]=[R(1,10),R(0)]
    V[4]=[R(3,50),R(2,25)]
    V[6]=[R(3,50),-R(2,25)]
    V[7]=[R(2),R(0)];V[8]=[R(0),R(2)]
    gram=mm(transpose(V),[[pi[i]*x for x in V[i]] for i in range(9)])
    gi=inv2(gram);Q=mm(mm(V,gi),transpose(V))
    states=[(i,a) for i in range(9) for a in [-1,1]]
    mu=[pi[i]/2 for i,a in states]
    T=[[S[i][j]+a*b*alpha*Q[i][j] for j,b in states] for i,a in states]
    p=R(1,4*D);W=[[p*x for x in row] for row in T]
    return locals()

def main():
    x=build();pi=x['pi'];Q=x['Q'];S=x['S'];T=x['T'];mu=x['mu']
    V=x['V'];gi=x['gi'];delta=x['delta'];beta=x['beta'];states=x['states']
    assert sum(pi)==sum(mu)==1 and min(pi)>0 and min(mu)>0
    assert S==transpose(S) and T==transpose(T)
    assert all(sum(pi[j]*S[i][j] for j in range(9))==1 for i in range(9))
    assert all(sum(mu[j]*T[i][j] for j in range(18))==1 for i in range(18))
    assert min(v for row in T for v in row)>0
    assert all(0<v<=1 for row in x['W'] for v in row)
    assert all(sum(mu[j]*x['W'][i][j] for j in range(18))==x['p'] for i in range(18))
    assert Q==transpose(Q) and wm(Q,Q,pi)==Q
    assert sum(pi[i]*Q[i][i] for i in range(9))==2
    assert max(abs(v) for row in Q for v in row)<=4
    assert all(abs(x['alpha']*Q[i][j])<=S[i][j] for i in range(9) for j in range(9))
    assert Q[2][4]*Q[4][6]*Q[6][2]<0
    SQ=wm(S,Q,pi);QS=wm(Q,S,pi)
    assert SQ[1][7]-QS[1][7]>0
    qone=[sum(pi[j]*Q[i][j] for j in range(9)) for i in range(9)]
    assert qone!=[R(0)]*9 and qone!=[R(1)]*9

    sp=powers(S,pi,6);tp=powers(T,mu,6)
    for j in [1,2,3]:
        assert all(tp[2*j][a][b]==sp[2*j][i][k]+sa*sb*beta**j*Q[i][k]
                   for a,(i,sa) in enumerate(states) for b,(k,sb) in enumerate(states))
    fields={}
    for j in [1,2,3]:
        fields[j]=[]
        for t in range(9):
            M=mm(transpose(V),[[pi[i]*sp[2*j][i][t]*z for z in V[i]] for i in range(9)])
            fields[j].append(mm(gi,M))
    local=[tr(mm(mm(fields[1][t],fields[2][t]),fields[3][t])) for t in range(9)]
    # Independent direct three-leaf contraction, using original pi.
    direct=[]
    for t in range(9):
        v=sum((pi[a]*pi[b]*pi[c]*Q[a][b]*Q[b][c]*Q[c][a]*
               sp[2][a][t]*sp[4][b][t]*sp[6][c][t]
               for a in range(9) for b in range(9) for c in range(9)),R(0))
        direct.append(v)
    assert direct==local
    assert -R(1,2**24)<local[0]<-R(1,2**25)
    J=sum(pi[t]*local[t] for t in range(9))
    assert 31<J<32

    tpl=(3,1,1,1,1);k,u,r,l,h=tpl;edge_exponents=[k,r+h,u,r,u,l];N=sum(edge_exponents)
    assert k>=u>=1 and r>=l>=1 and h>=1 and N==9
    assert not (k==u and r==l)
    assert not (k==r and u==l)
    assert not (k==r+h and u==l)
    # The bcd channel cycle has complementary exponents (k,r+h,u)=(3,2,1).
    # Real symmetric triple trace is invariant under reversal, so local[0]
    # equals the direct conditional bcd coefficient with exponents (3,2,1).
    assert tr(mm(mm(fields[3][0],fields[2][0]),fields[1][0]))==local[0]
    fiber=[a for a,(i,sa) in enumerate(states) if i==7]
    assert sum(mu[a] for a in fiber)==R(1,4)
    assert all(T[a][b]>=4*(1-delta) for a in fiber for b in fiber)
    for j in [1,2,3]:
        assert all(tp[2*j][a][b]>=4*(1-delta)**(2*j) for a in fiber for b in fiber)
    full_lower=16*(1-delta)**(2*N)
    bernoulli_lower=16*(1-2*N*delta)
    assert full_lower>=bernoulli_lower>15

    path=[row[:7] for row in x['P0'][:7]]
    path_det=det(path)
    assert path_det==-R(64**3,65**6)
    assert beta<(1-delta)**2*path_det**2
    cp=characteristic(path)
    # For this Jacobi chain, distinct eigenvalues and no opposite pair are
    # proved in the note; this exact coprimality calculation also checks it.
    def trim(p):
        while len(p)>1 and p[0]==0:p=p[1:]
        return p
    def rem(a,b):
        a=trim(a[:]);b=trim(b[:])
        while a!=[0] and len(a)>=len(b):
            c=a[0]/b[0]
            a=trim([z-c*b[i] if i<len(b) else z for i,z in enumerate(a)])
        return a
    def gcd(a,b):
        while b!=[0]:a,b=b,rem(a,b)
        return [z/a[0] for z in a]
    reflected=[c*((-1)**(7-i)) for i,c in enumerate(cp)]
    assert gcd(cp,reflected)==[R(1)]
    assert gcd(cp,[cp[i]*(7-i) for i in range(7)])==[R(1)]
    notes=Path(__file__).with_name('continuation5_search_pointwise.md')
    out=dict(status='passed',scope='Pointwise actual unequal-star negativity only; average J>31 and full F>15.',
      source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      note_sha256=hashlib.sha256(notes.read_bytes()).hexdigest() if notes.exists() else None,
      coarse_state_count=9,fine_state_count=18,tuple=tpl,edge_exponents=edge_exponents,
      D=x['D'],delta=frac(delta),alpha=frac(x['alpha']),beta=frac(beta),p=frac(x['p']),
      pi=[frac(z) for z in pi],mu=[frac(z) for z in mu],
      gram=[[frac(z) for z in row] for row in x['gram']],
      inverse_gram=[[frac(z) for z in row] for row in gi],
      local_trace_bounds=['-1/16777216','-1/33554432'],local_trace=float(local[0]),
      local_trace_exact=frac(local[0]),average_J_bounds=[31,32],average_J=float(J),
      average_J_exact=frac(J),
      full_F_lower_formula='16*(1-2^-16)^18',full_F_lower=frac(full_lower),
      full_F_bernoulli_lower=frac(bernoulli_lower),
      min_T=frac(min(z for row in T for z in row)),max_T=frac(max(z for row in T for z in row)),
      min_W=frac(min(z for row in x['W'] for z in row)),max_W=frac(max(z for row in x['W'] for z in row)),
      path_characteristic=[frac(z) for z in cp],path_determinant=frac(path_det),
      centered_band_count=9,centered_zero_multiplicity=7,
      centered_dimension_count={'coarse_stationary_band':2,'six_path_bands':6,'channel_beta':2,'zero':7},
      original_measure_power_checks=[2,4,6],direct_star_checks=9,
      exact_characteristic_gcd_checks=['simple path spectrum','no opposite path eigenvalue pair'])
    dest=Path(__file__).with_name('continuation5_search_pointwise_checks.json')
    dest.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:out[k] for k in ['status','scope','local_trace','average_J','p','centered_band_count','centered_zero_multiplicity']},indent=2))

if __name__=='__main__':main()
