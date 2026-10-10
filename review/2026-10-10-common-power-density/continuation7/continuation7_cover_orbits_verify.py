"""Exact all-k certificate for sign-host covers with monodromy orbits <=3.

This verifier uses only Python's standard library and dyadic rational sums.
It never promotes the orbit restriction to arbitrary cover degree.
"""
from collections import defaultdict
from fractions import Fraction as Q
from itertools import permutations, product
from pathlib import Path
import hashlib, json, time

BASE_EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
CHAR=(0,3,5,6,1,2,4)
MODE={c:i for i,c in enumerate(CHAR)}
DENEXP=(0,128,10,4,6,8,6)
N_FIXED=(0,9,4,1,4,1)

def lifted_edges(M,perms):
    return [(4*s+v,4*perms[e][s]+w,e)
            for e,(v,w) in enumerate(BASE_EDGES) for s in range(M)]

def forest(n,edges):
    par=list(range(n))
    def find(i):
        while par[i]!=i:i=par[i]
        return i
    tree=[];free=[]
    for i,(v,w,_) in enumerate(edges):
        a,b=find(v),find(w)
        if a!=b:par[a]=b;tree.append(i)
        else:free.append(i)
    adj=[[] for _ in range(n)]
    for e in tree:
        v,w,_=edges[e];adj[v].append((w,e));adj[w].append((v,e))
    seen=set();order=[];roots=[]
    def dfs(v,parent):
        seen.add(v)
        for w,e in adj[v]:
            if w!=parent:dfs(w,v);order.append((w,v,e))
    for v in range(n):
        if v not in seen:roots.append(v);dfs(v,-1)
    return free,order,roots

def character_polynomial(M,perms):
    edges=lifted_edges(M,perms);n=4*M
    free,order,roots=forest(n,edges)
    assert len(roots)==1
    assert len(free)==2*M+1
    incident=[[] for _ in range(n)]
    for j,(v,w,_) in enumerate(edges):incident[v].append(j);incident[w].append(j)
    assert all(len(es)==3 for es in incident)
    # All fixed powers total 19M, and each character denominator exponent
    # is at most128; each of4M cubic moments adds at most one more bit.
    B=2436*M
    coeff=defaultdict(int);valid=negative=0
    for choices in product(CHAR,repeat=len(free)):
        colors=[0]*len(edges);boundary=[0]*n
        for e,c in zip(free,choices):
            colors[e]=c;v,w,_=edges[e];boundary[v]^=c;boundary[w]^=c
        good=True
        for v,w,e in order:
            c=boundary[v]
            if c==7:good=False;break
            colors[e]=c;boundary[w]^=c
        if not good or any(boundary[v] for v in roots):continue
        sign=1;den=0
        for inds in incident:
            cs=tuple(colors[i] for i in inds)
            assert cs[0]^cs[1]^cs[2]==0
            if all(cs):
                den+=1
                if set(cs)=={2,4,6}:sign=-sign
        power=0
        for c,(_,_,e) in zip(colors,edges):
            d=DENEXP[MODE[c]]
            if e==0:power+=d
            else:den+=d*N_FIXED[e]
        assert den<=B
        coeff[power]+=sign*(1<<(B-den))
        valid+=1;negative+=sign<0
    return {q:Q(a,1<<B) for q,a in coeff.items() if a}, {
        'free_edges':len(free),'candidate_flows':7**len(free),
        'valid_flows':valid,'negative_flows':negative}

def mul(p,q):
    out=defaultdict(Q)
    for i,a in p.items():
        for j,b in q.items():out[i+j]+=a*b
    return {i:a for i,a in out.items() if a}

def defect(p,q):
    out=defaultdict(Q,p)
    for i,a in q.items():out[i]-=a
    return {i:a for i,a in out.items() if a}

def interval_lower(p):
    q0=min(p)
    bound=p[q0]+sum((a/Q(1<<(4*(q-q0)))
                    for q,a in p.items() if q>q0 and a<0),Q(0))
    return q0,bound

def compose(a,b):return tuple(a[b[i]] for i in range(len(a)))
def inverse(p):return tuple(p.index(i) for i in range(len(p)))
def conjugate(g,p):return compose(compose(g,p),inverse(g))
def orbit_partition(M,ps):
    remaining=set(range(M));out=[]
    while remaining:
        seen={min(remaining)};pending=list(seen)
        while pending:
            i=pending.pop()
            for p in ps:
                j=p[i]
                if j not in seen:seen.add(j);pending.append(j)
        remaining-=seen;out.append(tuple(sorted(seen)))
    return tuple(out)

def orbit_representatives(M):
    group=list(permutations(range(M)))
    reps={}
    for triple in product(group,repeat=3):
        representative=min(tuple(conjugate(g,p) for p in triple) for g in group)
        reps[representative]=len(orbit_partition(M,representative))
    connected=[r for r,n in sorted(reps.items()) if n==1]
    return connected,{'raw_triples':len(group)**3,'simultaneous_conjugacy_classes':len(reps),
                      'connected_classes':len(connected),
                      'disconnected_classes':len(reps)-len(connected)}

def single_edge_classes(M):
    group=list(permutations(range(M)));identity=tuple(range(M));out=set()
    for e in range(6):
        for p in group:
            if len(orbit_partition(M,[p]))!=1:continue
            perms=[identity]*6;perms[e]=p
            gauges=[identity,perms[0],perms[1],perms[2]]
            chords=[]
            for j in (3,4,5):
                v,w=BASE_EDGES[j]
                chords.append(compose(compose(inverse(gauges[w]),perms[j]),gauges[v]))
            out.add(min(tuple(conjugate(g,c) for c in chords) for g in group))
    assert len(out)==6
    return out

def actual_moments():
    states=[]
    for signs in product((-1,1),repeat=6):
        a,b,c,d,e,f=signs
        if a*b*c+a*d*e+b*d*f-c*e*f==2:states.append(signs)
    assert len(states)==32
    phi=[(1,)+s for s in states]
    assert all(sum(v[i]*v[j] for v in phi)==32*(i==j)
               for i in range(7) for j in range(7))
    moments={}
    for i,j,k in product(range(7),repeat=3):
        actual=Q(sum(v[i]*v[j]*v[k] for v in phi),32)
        cs=(CHAR[i],CHAR[j],CHAR[k])
        predicted=Q(0)
        if cs[0]^cs[1]^cs[2]==0:
            predicted=Q(1) if 0 in cs else Q(-1 if set(cs)=={2,4,6} else 1,2)
        assert actual==predicted
        if actual:moments[(i,j,k)]=actual
    assert len(moments)==43
    # Original relative T, with common row1 and exact normalization.
    rootden=(0,64,5,2,3,4,3)
    T=[[Q(1)+sum(Q(v[i]*w[i],1<<rootden[i]) for i in range(1,7))
        for w in phi] for v in phi]
    p=1/(Q(51,32)+Q(1,1<<64))
    assert all(sum(row,Q(0))==32 for row in T)
    assert min(map(min,T))>0 and max(map(max,T))*p==1
    for i in range(32):
        for j in range(32):
            a=sum(T[i][x]*T[x][j] for x in range(32))/32
            expected=Q(1)+sum(Q(phi[i][q]*phi[j][q],1<<DENEXP[q]) for q in range(1,7))
            assert a==expected
    return {'states':states,'original_mu':'1/32','p':fstr(p),
            'min_T':fstr(min(map(min,T))),'max_T':fstr(max(map(max,T))),
            'cubic_nonzero':len(moments),
            'moments':{','.join(map(str,k)):fstr(v) for k,v in moments.items()}}

def direct_base_polynomial(moments):
    out=defaultdict(Q);valid=0
    for colors in product(range(7),repeat=6):
        triples=((colors[0],colors[1],colors[2]),(colors[0],colors[3],colors[4]),
                 (colors[1],colors[3],colors[5]),(colors[2],colors[4],colors[5]))
        weight=Q(1)
        for t in triples:
            key=','.join(map(str,t))
            if key not in moments:weight=Q(0);break
            weight*=Q(moments[key])
        if not weight:continue
        den=sum(N_FIXED[e]*DENEXP[colors[e]] for e in range(1,6))
        out[DENEXP[colors[0]]]+=weight/Q(1<<den);valid+=1
    assert valid==235
    return dict(out)

def fstr(q):return str(q.numerator)+'/'+str(q.denominator)
def encode_dyadic(q):
    d=q.denominator.bit_length()-1
    assert q.denominator==1<<d
    return [format(q.numerator,'x'),d]
def export_poly(p):return {str(q):encode_dyadic(a) for q,a in sorted(p.items())}

def main():
    start=time.perf_counter()
    actual=actual_moments()
    f,meta=character_polynomial(1,[(0,)]*6)
    assert f==direct_base_polynomial(actual['moments'])
    assert sum(a/Q(1<<(4*q)) for q,a in f.items())>1
    powers={1:f,2:mul(f,f),3:mul(mul(f,f),f)}
    records=[];class_counts={};minimum=None
    for M in (2,3):
        reps,counts=orbit_representatives(M);class_counts[str(M)]=counts
        assert len(reps)==(7 if M==2 else 41)
        old_single_edge=single_edge_classes(M)
        assert old_single_edge.issubset(set(reps))
        identity=tuple(range(M))
        for index,triple in enumerate(reps):
            perms=[identity]*3+list(triple)
            z,stats=character_polynomial(M,perms)
            delta=defect(powers[M],z)
            q0,bound=interval_lower(delta)
            assert bound>0
            assert q0 in (0,4)
            # Common uniform bound: delta(z)>2^-60 z^4,0<z<=1/16.
            assert bound>Q(1,1<<60)
            commutes=all(compose(p,q)==compose(q,p) for p in triple for q in triple)
            minimum=bound if minimum is None else min(minimum,bound)
            records.append({'M':M,'index':index,'chord_permutations':triple,
                            'commuting':commutes,'single_edge_gauge':triple in old_single_edge,
                            'flow_stats':stats,
                            'first_power':q0,'interval_lower':encode_dyadic(bound),
                            'negative_defect_coefficients':sum(a<0 for a in delta.values()),
                            'defect_coefficients':export_poly(delta)})
            print('certified',M,index,'first_power',q0,'commuting',commutes,flush=True)
    assert sum(r['M']==3 and not r['commuting'] for r in records)==28
    assert sum(not r['single_edge_gauge'] for r in records)==36
    output={'scope':'actual sign host;(k,4,1,1,8),all integer k>=4;monodromy orbits of size at most3',
            'dyadic_encoding':'Each [h,d] represents the exact rational int(h,16)/2**d; h may be negative.',
            'status':'PASS','actual_host':actual,'class_counts':class_counts,
            'base_flow_stats':meta,'base_polynomial':export_poly(f),
            'connected_types':len(records),'noncommuting_three_types':28,
            'genuinely_simultaneous_types':36,
            'minimum_interval_lower':encode_dyadic(minimum),'common_defect_bound':'2^(-4k-60)',
            'records':records,'seconds':time.perf_counter()-start,
            'checker_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    Path('continuation7_cover_orbits_checks.json').write_text(json.dumps(output,indent=2)+'\n')
    print('PASS',len(records),'types; seconds',output['seconds'],flush=True)

if __name__=='__main__':main()
