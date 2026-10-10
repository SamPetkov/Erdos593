"""Exact checks of the constant-trace rank-two unequal-star mechanism.

Only standard-library rational arithmetic is used. The mathematical
theorem is in continuation6_unequal_balanced_rank2.md. This program does
not call any earlier restricted-case host checker or optimization.
"""
from fractions import Fraction as F
from itertools import combinations, product
from pathlib import Path
import hashlib
import json
import sys

HERE = Path(__file__).resolve().parent
OLD = HERE.parent / "continuation4"
if not OLD.is_dir():
    OLD = (HERE / "erdos593-density-continuation" / "review"
           / "2026-10-10-common-power-density" / "continuation4")
sys.path.insert(0, str(OLD))
from continuation4_projection_verify import (
    EDGES, CYCLES, mat, plus, scale, eye, ones, zero, mm, power,
    trace, hs, markov, proj, exp_tuple, density, field, charpoly,
    polymul, serialize,
)


def action(K, f, pi):
    return [sum(pi[j]*K[i][j]*f[j] for j in range(len(pi)))
            for i in range(len(pi))]


def rank(A):
    A = [list(map(F, row)) for row in A]
    out = 0
    for j in range(len(A[0])):
        pivot = next((i for i in range(out, len(A)) if A[i][j]), None)
        if pivot is None:
            continue
        A[out], A[pivot] = A[pivot], A[out]
        q = A[out][j]
        A[out] = [x/q for x in A[out]]
        for i in range(len(A)):
            if i != out and A[i][j]:
                q = A[i][j]
                A[i] = [x-q*y for x, y in zip(A[i], A[out])]
        out += 1
        if out == len(A):
            break
    return out


def determinant(A):
    A = [list(map(F, row)) for row in A]
    d = F(1)
    for j in range(len(A)):
        pivot = next((i for i in range(j, len(A)) if A[i][j]), None)
        if pivot is None:
            return F(0)
        if pivot != j:
            A[j], A[pivot] = A[pivot], A[j]
            d = -d
        q = A[j][j]
        d *= q
        for i in range(j+1, len(A)):
            r = A[i][j]/q
            A[i] = [x-r*y for x, y in zip(A[i], A[j])]
    return d


def original_host():
    pi = [F(1,4), F(1,12)]*3
    q = mat(((2,1,-1),(1,2,1),(-1,1,2)))
    Q = [[q[i//2][j//2] for j in range(6)] for i in range(6)]
    S0 = mat(((F(23,6),F(1,2),0,0,0,0),
              (F(1,2),9,F(1,2),0,0,0),
              (0,F(1,2),F(89,24),F(3,8),0,0),
              (0,0,F(3,8),F(75,8),F(1,2),0),
              (0,0,0,F(1,2),F(11,3),F(1,2)),
              (0,0,0,0,F(1,2),F(21,2))))
    S = plus(scale(F(15,16), S0), scale(F(1,16), ones(6)))
    assert markov(S0, pi) and markov(S, pi)
    assert proj(Q, pi) and trace(Q, pi) == 2
    assert all(Q[i][i] == 2 for i in range(6))
    assert Q[0][2]*Q[2][4]*Q[4][0] == -1
    assert action(Q, [F(1)]*6, pi) == [F(2,3)]*2+[F(4,3)]*2+[F(2,3)]*2
    commutator = plus(mm(S,Q,pi),scale(-1,mm(Q,S,pi)))
    assert commutator != zero(6)
    assert min(pi[i]*S0[i][i] for i in range(6)) == F(3,4)
    conductances=[F(1,96),F(1,96),F(1,128),F(1,96),F(1,96)]
    for i in range(5):
        assert pi[i]*pi[i+1]*S0[i][i+1] == conductances[i]
    return pi, S0, S, Q, commutator


def star_check(pi, S, Q, triple, require_two=True):
    assert markov(S, pi) and proj(Q, pi)
    d = trace(Q, pi)
    B = mm(S,S,pi)
    diag = [Q[i][i] for i in range(len(pi))]
    if require_two:
        assert d == 2 and action(B, diag, pi) == [F(2)]*len(pi)
    else:
        assert d == 0
    K = {s:power(B,s,pi) for s in set(triple)}
    M = {s:[field(Q,K[s],pi,t) for t in range(len(pi))]
         for s in set(triple)}
    X = {s:[plus(v,scale(-1,Q)) for v in M[s]] for s in M}
    for s in M:
        assert all(trace(v,pi) == d for v in M[s])
        assert all(trace(v,pi) == 0 for v in X[s])
        assert [[sum(pi[t]*M[s][t][i][j] for t in range(len(pi)))
                 for j in range(len(pi))] for i in range(len(pi))] == Q
    x,y,z = triple
    cubic_pointwise = [trace(mm(mm(X[x][t],X[y][t],pi),X[z][t],pi),pi)
                       for t in range(len(pi))]
    assert cubic_pointwise == [F(0)]*len(pi)
    pairs = [sum(pi[t]*hs(X[a][t],X[b][t],pi) for t in range(len(pi)))
             for a,b in ((x,y),(x,z),(y,z))]
    assert min(pairs) >= 0
    J = sum(pi[t]*trace(mm(mm(M[x][t],M[y][t],pi),M[z][t],pi),pi)
            for t in range(len(pi)))
    direct = density((Q,Q,K[x],Q,K[y],K[z]), pi)
    assert J == direct == d+sum(pairs)
    return {"triple":triple, "rank_Q":d, "J":J,
            "pair_surpluses":pairs, "cubic_pointwise":cubic_pointwise,
            "identity_exact":True, "J_at_least_rank":J>=d}


def fine_checks(pi,S,Q):
    H=scale(F(1,64),Q); beta=F(1,4096)
    assert mm(H,H,pi)==scale(beta,Q)
    assert all(abs(H[i][j])<=S[i][j] for i in range(6) for j in range(6))
    states=list(product(range(6),(-1,1)))
    mu=[pi[i]/2 for i,a in states]
    T=[[S[i][j]+a*b*H[i][j] for j,b in states] for i,a in states]
    assert markov(T,mu)
    p=1/max(map(max,T)); W=scale(p,T)
    assert p==F(16,159) and min(map(min,T))==F(3,64)
    assert max(map(max,T))==F(159,16)
    assert min(map(min,W))==F(1,212) and max(map(max,W))==1
    assert all(sum(mu[j]*W[i][j] for j in range(12))==p for i in range(12))
    B=mm(S,S,pi); Af=mm(T,T,mu)
    assert max(map(max,Af))>4
    rows=[]
    for tpl in ((3,1,1,1,1),(1,1,2,1,6)):
        ep=exp_tuple(tpl)
        k,u,r,l,h=tpl
        assert not (k==u and r==l)
        assert not (k==r and u==l)
        assert not (k==r+h and u==l)
        K={e:power(B,e,pi) for e in set(ep)}
        KF={e:power(Af,e,mu) for e in set(ep)}
        for e in K:
            predicted=[[K[e][i][j]+a*b*beta**e*Q[i][j]
                        for j,b in states] for i,a in states]
            assert KF[e]==predicted
        coarse=density([K[e] for e in ep],pi)
        fine=density([KF[e] for e in ep],mu)
        contractions=[]; star_details=[]
        for cyc in CYCLES:
            contraction=density([Q if e in cyc else K[ep[e]]
                                 for e in range(6)],pi)
            assert contraction>=2
            contractions.append(contraction)
            if len(cyc)==3:
                complement=[e for e in range(6) if e not in cyc]
                exponents=tuple(ep[e] for e in complement)
                cert=star_check(pi,S,Q,exponents)
                assert cert["J"]==contraction
                star_details.append(cert)
        weights=[sum(ep[e] for e in cyc) for cyc in CYCLES]
        exact_correction=sum(beta**w*c for w,c in zip(weights,contractions))
        bound=2*sum(beta**w for w in weights)
        strengthened=sum(beta**w*(c if len(cyc)==3 else 2)
                         for cyc,w,c in zip(CYCLES,weights,contractions))
        assert fine==coarse+exact_correction
        assert fine>=coarse+strengthened>=coarse+bound
        assert fine>coarse>1
        rows.append({"tuple":tpl,"edge_exponents":ep,"cycle_exponents":weights,
                     "F_coarse":coarse,"F_fine":fine,
                     "cycle_contractions":contractions,
                     "channel_surplus":exact_correction,
                     "rank_only_bound":bound,"strengthened_surplus_bound":strengthened,
                     "triangle_certificates":star_details})
    cochar=charpoly(B,pi); fichar=charpoly(Af,mu)
    factor=polymul(polymul(cochar,[F(1),-beta]),[F(1),-beta])
    factor=polymul(factor,[F(1),F(0),F(0),F(0),F(0)])
    assert fichar==factor
    return {"fine_mu":mu,"S":S,"H":H,"Q":Q,"T":T,"p":p,"W":W,
            "beta":beta,"min_T":min(map(min,T)),"max_T":max(map(max,T)),
            "max_A":max(map(max,Af)),"rows":rows,
            "coarse_square_charpoly":cochar,"fine_square_charpoly":fichar,
            "fine_square_factorization_exact":True,
            "entire_centered_distinct_band_count":7,
            "fine_zero_multiplicity":4}


def boundary_checks(pi,S,Q):
    rows=[]
    for triple in ((1,1,1),(1,1,2),(1,2,3),(1,2,8),(2,5,7)):
        rows.append({"label":"primary_balanced", **star_check(pi,S,Q,triple)})
    # The pulled-back root erases genuine trace variation in a zero band.
    clones=list(product(range(6),range(2)))
    nu=[F(1,3),F(2,3)]
    mup=[pi[i]*nu[a] for i,a in clones]
    Sp=[[S[i][j] for j,b in clones] for i,a in clones]
    Qp=[[F(3,2)*Q[i][j] if a==b==1 else F(0)
         for j,b in clones] for i,a in clones]
    assert proj(Qp,mup) and markov(Sp,mup)
    assert set(Qp[i][i] for i in range(12))=={F(0),F(3)}
    Bp=mm(Sp,Sp,mup)
    assert action(Bp,[Qp[i][i] for i in range(12)],mup)==[F(2)]*12
    assert rank([[mup[j]*Bp[i][j] for j in range(12)] for i in range(12)])==6
    for triple in ((1,2,3),(1,2,8)):
        cert=star_check(mup,Sp,Qp,triple)
        original=star_check(pi,S,Q,triple)
        assert cert["J"]==original["J"]
        assert cert["pair_surpluses"]==original["pair_surpluses"]
        rows.append({"label":"nonconstant_diagonal_zero_band", **cert})
    # A refresh root erases all source information, including diagonal variation.
    cert=star_check(mup,ones(12),Qp,(1,2,8))
    assert cert["J"]==2 and cert["pair_surpluses"]==[F(0)]*3
    rows.append({"label":"refresh_equality", **cert})
    # The two original-law components have masses 3/4 and 1/4.
    Sdisc=[[1/(F(3,4) if i%2==0 else F(1,4)) if i%2==j%2 else F(0)
            for j in range(6)] for i in range(6)]
    assert markov(Sdisc,pi)
    cert=star_check(pi,Sdisc,Q,(1,2,8))
    assert cert["J"]==2 and cert["pair_surpluses"]==[F(0)]*3
    rows.append({"label":"weighted_disconnected_equality", **cert})
    # An actual connected bipartite root whose square is disconnected.
    pu=[F(1,6)]*6
    Sbi=[[F(2) if i%2!=j%2 else F(0) for j in range(6)] for i in range(6)]
    assert markov(Sbi,pu) and proj(Q,pu)
    cert=star_check(pu,Sbi,Q,(1,2,8))
    assert cert["J"]==2 and cert["pair_surpluses"]==[F(0)]*3
    rows.append({"label":"connected_bipartite_root_equality", **cert})
    rows.append({"label":"rank_zero", **star_check(pi,S,zero(6),(1,2,8),False)})
    return rows,{"original_refined_mu":mup,"refined_S":Sp,"refined_Q":Qp,
                 "diagonal_values":[0,3],"square_rank":6,"square_nullity":6,
                 "trace_flattening_exact":True}


def interaction_check(pi,S0):
    f0=list(map(F,(2,2,-1,-1,-1,-1)))
    f2=list(map(F,(-1,-1,-1,-1,2,2)))
    assert sum(x*y for x,y in zip(pi,f0))==0
    assert sum(x*y for x,y in zip(pi,f2))==0
    vectors=[[F(1)]*6]
    for f in (f0,f2):
        v=f
        for j in range(6):
            vectors.append(v)
            v=action(S0,v,pi)
    r=rank(vectors); assert r==6
    chosen=[[F(1)]*6,f0,f2,action(S0,f0,pi),action(S0,f2,pi),
            action(S0,action(S0,f0,pi),pi)]
    det=determinant(chosen); assert det==F(-9,4096)
    return {"source_functions":[f0,f2],"observability_rank":r,
            "six_vector_minor":chosen,"six_vector_minor_determinant":det,
            "all_five_coarse_centered_bands_interact":True}


def coarse_tp2_check(S0):
    pairs=list(combinations(range(6),2))
    minors=[S0[i][k]*S0[j][l]-S0[i][l]*S0[j][k]
            for i,j in pairs for k,l in pairs]
    assert len(minors)==225 and min(minors)>=0
    adjacent=[S0[i][i]*S0[i+1][i+1]-S0[i][i+1]*S0[i+1][i]
              for i in range(5)]
    assert adjacent==list(map(F,("137/4","265/8","277/8","273/8","153/4")))
    for i,j in pairs:
        for k,l in pairs:
            if S0[i][l]*S0[j][k]:
                assert (i,j)==(k,l) and j==i+1
    prior=OLD.parent/"tp2-class.md"
    assert prior.is_file()
    return {"minor_count":len(minors),"minimum_minor":min(minors),
            "negative_minor_count":sum(v<0 for v in minors),
            "adjacent_principal_minors":adjacent,
            "crossed_support_reduction_checked":True,
            "prior_theorem":"../tp2-class.md, Corollaries 2 and 3",
            "prior_theorem_sha256":hashlib.sha256(prior.read_bytes()).hexdigest(),
            "consequence":"All positive coarse powers belong to the original-law common-order convex TP2 class. Combining its prior density theorem with the new projection identity proves F_fine>=1+2 sum_D beta^(sum_D n_e) for every six positive exponents."}


def main():
    pi,S0,S,Q,commutator=original_host()
    boundary,refinement=boundary_checks(pi,S,Q)
    fine=fine_checks(pi,S,Q)
    interaction=interaction_check(pi,S0)
    tp2=coarse_tp2_check(S0)
    out={"scope":"Rank-two one-step trace-flattening theorem and exact finite certificates; unrestricted target unresolved.",
         "source_sha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         "frozen_arithmetic_sha256":hashlib.sha256((OLD/"continuation4_projection_verify.py").read_bytes()).hexdigest(),
         "tuple_order":["k","u","r","l","h"],"edge_order":EDGES,"cycle_order":CYCLES,
         "primary_pi":pi,"primary_S0":S0,"primary_Q":Q,
         "commutator_SQ_minus_QS":commutator,"negative_Q_triangle_product":F(-1),
         "star_boundary_check_count":len(boundary),"star_boundary_checks":boundary,
         "nonconstant_trace_refinement":refinement,"band_interaction":interaction,
         "coarse_tp2":tp2,
         "actual_full_density_host_count":1,"actual_full_density_tuple_count":2,
         "fine_host":fine,"all_exact_checks_passed":True}
    target=HERE/"continuation6_unequal_balanced_checks.json"
    target.write_text(json.dumps(serialize(out),indent=2)+"\n")
    print(json.dumps(serialize({"star_boundary_checks":len(boundary),
          "actual_full_density_host_count":1,"actual_full_density_tuple_count":2,
          "p":fine["p"],"min_T":fine["min_T"],"max_T":fine["max_T"],
          "max_A":fine["max_A"],"interacting_coarse_bands":5,
          "fine_centered_distinct_bands":7,
          "coarse_TP2_minor_count":tp2["minor_count"],
          "observability_minor":interaction["six_vector_minor_determinant"]})))
    print("ALL_EXACT_CHECKS_PASSED")


if __name__=="__main__":
    main()
