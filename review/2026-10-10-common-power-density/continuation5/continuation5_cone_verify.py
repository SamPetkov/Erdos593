"""Exact checks for the common-cone projection-channel transfer.

The proof is continuation5_cone_theorem.md. This checker imports the frozen
standard-library original-measure arithmetic from the sibling PR60 packet;
it does not call that packet's boundary-only host checker or its main().
No floating-point calculation or eigenvalue approximation is used.
"""
from fractions import Fraction as F
from itertools import product, combinations_with_replacement
from pathlib import Path
import hashlib
import json
import sys

HERE = Path(__file__).resolve().parent
OLD = HERE.parent / "continuation4"
sys.path.insert(0, str(OLD))
from continuation4_projection_verify import (
    EDGES, CYCLES, mat, plus, scale, eye, ones, zero, mm, power, trace,
    hs, markov, proj, exp_tuple, density, field, charpoly, polymul,
    primary_host, serialize,
)


def triangle(q, kernels, pi):
    L, M, N = kernels
    return density((q, q, L, q, M, N), pi)


def ten_case_checks():
    # This C itself has three distinct positive centered eigenvalues.
    # The common-cone lemma does not impose a two-band hypothesis on C.
    pi, _, S, Q, Qcenter = primary_host()
    C = mm(S, S, pi)
    generators = [eye(pi), ones(len(pi)), C]
    projections = [zero(len(pi)), ones(len(pi)), Q, Qcenter, eye(pi)]
    rows = []
    for qi, q in enumerate(projections):
        assert proj(q, pi)
        d = trace(q, pi)
        R = [field(q, generators[0], pi, t) for t in range(len(pi))]
        Z = [field(q, C, pi, t) for t in range(len(pi))]
        assert [[sum(pi[t]*R[t][i][j] for t in range(len(pi)))
                 for j in range(len(pi))] for i in range(len(pi))] == q
        a = sum(pi[t]*hs(R[t], R[t], pi) for t in range(len(pi)))
        b = sum(pi[t]*hs(R[t], Z[t], pi) for t in range(len(pi)))
        c = sum(pi[t]*hs(Z[t], Z[t], pi) for t in range(len(pi)))
        assert min(a, b, c) >= d
        expected = {
            (0, 0, 0): a*a/d if d else F(0),
            (0, 0, 1): a,
            (0, 0, 2): b*b/d if d else F(0),
            (0, 1, 1): d,
            (0, 1, 2): b,
            (0, 2, 2): b*b/d if d else F(0),
            (1, 1, 1): d,
            (1, 1, 2): d,
            (1, 2, 2): c,
            (2, 2, 2): c*c/d if d else F(0),
        }
        for triple in combinations_with_replacement(range(3), 3):
            ks = [generators[i] for i in triple]
            J = triangle(q, ks, pi)
            fields = [[field(q, K, pi, t) for t in range(len(pi))]
                      for K in ks]
            direct_trace = sum(pi[t]*trace(mm(mm(fields[0][t], fields[1][t], pi),
                                              fields[2][t], pi), pi)
                               for t in range(len(pi)))
            assert J == direct_trace and J >= expected[triple] >= d
            if triple in ((0,0,1),(0,1,1),(0,1,2),(1,1,1),(1,1,2),(1,2,2)):
                assert J == expected[triple]
            rows.append({"projection": qi, "rank": d, "triple": triple,
                         "J": J, "proved_bound": expected[triple]})
        coeff = [list(map(F, row)) for row in
                 (("1/7", "2/7", "4/7"),
                  ("1/3", "1/2", "1/6"),
                  ("1/5", "1/10", "7/10"))]
        kernels = []
        for row in coeff:
            kernels.append([[sum(row[z]*generators[z][i][j] for z in range(3))
                             for j in range(len(pi))] for i in range(len(pi))])
        expanded = F(0)
        lower = F(0)
        for labels in product(range(3), repeat=3):
            weight = coeff[0][labels[0]]*coeff[1][labels[1]]*coeff[2][labels[2]]
            expanded += weight*triangle(q, [generators[z] for z in labels], pi)
            lower += weight*expected[tuple(sorted(labels))]
        J = triangle(q, kernels, pi)
        assert J == expanded and J >= lower >= d
        rows.append({"projection": qi, "rank": d, "type": "independent_mixtures",
                     "J": J, "proved_bound": lower})
    return rows


def weighted_example():
    pi = [F(1,2), F(1,4), F(1,8), F(1,8)]
    Q = scale(F(1,19), mat(((32,-8,8,24),(-8,40,-40,32),
                            (8,-40,40,-32),(24,32,-32,56))))
    S0 = mat(((F(7,4),F(1,4),F(1,4),F(1,4)),
              (F(1,4),F(7,2),0,0),(F(1,4),0,7,0),(F(1,4),0,0,7)))
    S = plus(scale(F(15,16), S0), scale(F(1,16), ones(4)))
    assert proj(Q, pi) and trace(Q, pi) == 2
    assert [sum(pi[j]*Q[i][j] for j in range(4)) for i in range(4)] == [F(x,19) for x in (18,5,-5,23)]
    assert Q[0][1]*Q[1][3]*Q[3][0] == -F(6144,6859)
    assert plus(mm(S,Q,pi),scale(-1,mm(Q,S,pi)))[0][1] == -F(157,1216)
    x,y = F(105,128)**2, F(45,64)**2
    B = mm(S,S,pi)
    C = scale(1/(1-y), plus(B,scale(-y,eye(pi))))
    assert markov(C, pi)
    expected = [F(1)]
    for lam in (F(1), (x-y)/(1-y), (x-y)/(1-y), F(0)):
        expected = polymul(expected,[F(1),-lam])
    assert charpoly(C,pi) == expected
    return pi,S,Q,F(1,64),x,y,C


def reflection_families(tpl):
    k,u,r,l,h = tpl
    return [k == u and r == l, k == r and u == l, k == r+h and u == l]


def actual_host(label, pi, S, H, Q, beta, tuples, x=None, y=None, C=None):
    m = len(pi)
    assert markov(S,pi) and proj(Q,pi) and mm(H,H,pi) == scale(beta,Q)
    assert all(abs(H[i][j]) <= S[i][j] for i in range(m) for j in range(m))
    states = list(product(range(m),(-1,1)))
    mu = [pi[i]/2 for i,s in states]
    T = [[S[i][j]+s*t*H[i][j] for j,t in states] for i,s in states]
    assert markov(T,mu)
    p = 1/max(map(max,T))
    W = scale(p,T)
    assert all(0 <= z <= 1 for row in W for z in row)
    assert all(sum(mu[j]*W[i][j] for j in range(2*m)) == p for i in range(2*m))
    B, A = mm(S,S,pi), mm(T,T,mu)
    d = trace(Q,pi)
    rows = []
    for tpl in tuples:
        ep = exp_tuple(tpl)
        ks = {e:power(B,e,pi) for e in set(ep)}
        kf = {e:power(A,e,mu) for e in set(ep)}
        coefficients = {}
        for e in set(ep):
            predicted = [[ks[e][i][j]+s*t*beta**e*Q[i][j] for j,t in states] for i,s in states]
            assert predicted == kf[e]
            if C is not None:
                z = (1-y)*(x**e-y**e)/(x-y)
                a,b = y**e,1-y**e-z
                assert min(a,b,z) >= 0 and a+b+z == 1
                assert ks[e] == plus(plus(scale(a,eye(pi)),scale(b,ones(m))),scale(z,C))
                coefficients[e] = [a,b,z]
        coarse = density([ks[e] for e in ep],pi)
        fine = density([kf[e] for e in ep],mu)
        contractions = [density([Q if e in cyc else ks[ep[e]] for e in range(6)],pi) for cyc in CYCLES]
        q = [sum(ep[e] for e in cyc) for cyc in CYCLES]
        correction = sum(beta**s*z for s,z in zip(q,contractions))
        lower = d*sum(beta**s for s in q)
        assert all(z >= d for z in contractions)
        assert fine == coarse+correction and fine >= coarse+lower and coarse >= 1
        coarse_bound = F(1)
        if y is not None:
            coarse_bound += (sum(v**-2 for v in pi)-1)*y**sum(ep)
            assert coarse >= coarse_bound
        assert fine >= coarse_bound+lower
        rows.append({"tuple":tpl,"edge_exponents":ep,"N":sum(ep),"reflection_families":reflection_families(tpl),
                     "cone_coefficients":coefficients,"cycle_exponents":q,"cycle_contractions":contractions,
                     "F_coarse":coarse,"F_fine":fine,"coarse_bound":coarse_bound,
                     "projection_surplus_bound":lower,"full_bound":coarse_bound+lower})
    return {"label":label,"pi":pi,"mu":mu,"S":S,"H":H,"Q":Q,"rank":d,"beta":beta,
            "p":p,"W":W,"min_W":min(map(min,W)),"max_W":max(map(max,W)),
            "max_A":max(map(max,A)),"square_charpoly":charpoly(A,mu),"rows":rows}


def main():
    lemmas = ten_case_checks()
    pi,S,Q,alpha,x,y,C = weighted_example()
    tuples = [(3,1,1,1,1),(4,2,3,1,2),(8,2,3,1,1),(1,1,2,1,6),
              (1,1,1,1,1),(2,2,3,3,5)]
    primary = actual_host("weighted_signed_noncentral_noncommuting_projection",pi,S,scale(alpha,Q),Q,alpha**2,tuples,x,y,C)
    assert all(not any(r["reflection_families"]) for r in primary["rows"][:4])
    assert primary["p"] == F(76,507) and primary["min_W"] == F(3,676)
    assert primary["max_A"] == F(861135,155648)
    expected = [F(1)]
    for lam in (F(1),x,x,y,alpha**2,alpha**2,F(0),F(0)):
        expected = polymul(expected,[F(1),-lam])
    assert primary["square_charpoly"] == expected
    assert primary["rows"][0]["cycle_exponents"] == [6,5,4,3,6,7,5]
    assert primary["rows"][0]["N"] == 9
    extras = []
    extras.append(actual_host("negative_root_channel",pi,S,scale(-alpha,Q),Q,alpha**2,[tuples[0]],x,y,C))
    extras.append(actual_host("zero_channel",pi,S,zero(4),Q,F(0),[tuples[0]],x,y,C))
    extras.append(actual_host("rank_zero_projection",pi,S,zero(4),zero(4),F(1,4),[tuples[0]],x,y,C))
    extras.append(actual_host("constant_root_equality",pi,ones(4),zero(4),Q,F(0),[tuples[0]]))
    assert extras[-1]["rows"][0]["F_fine"] == 1
    pi2 = [F(1,2),F(1,2)]
    flip = mat(((0,2),(2,0)))
    extras.append(actual_host("connected_bipartite_root_disconnected_square",pi2,flip,scale(F(1,2),flip),eye(pi2),F(1,4),[tuples[0],tuples[-1]]))
    pi3 = [F(1,2),F(1,3),F(1,6)]
    q3 = eye(pi3);q3[2][2] = F(0)
    extras.append(actual_host("weighted_disconnected_root",pi3,eye(pi3),scale(F(1,2),q3),q3,F(1,4),[tuples[0]]))
    extras.append(actual_host("one_coarse_state",[F(1)],[[F(1)]],[[F(1,2)]],[[F(1)]],F(1,4),[tuples[0]]))
    records = [primary]+extras
    root_keys = [json.dumps(serialize([rec["mu"],scale(1/rec["p"],rec["W"])]),sort_keys=True)
                 for rec in records]
    distinct_pairs = {(key,tuple(row["tuple"])) for key,rec in zip(root_keys,records)
                      for row in rec["rows"]}
    out = {"scope":"Restricted common-cone projection-channel transfer for all exponents; unrestricted target unresolved.",
           "source_sha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           "frozen_arithmetic_sha256":hashlib.sha256((OLD/"continuation4_projection_verify.py").read_bytes()).hexdigest(),
           "tuple_order":["k","u","r","l","h"],"edge_order":EDGES,"cycle_order":CYCLES,
           "lemma_check_count":len(lemmas),"actual_root_specification_count":len(records),
           "distinct_actual_root_count":len(set(root_keys)),
           "root_specification_tuple_count":len(tuples)+sum(len(r["rows"]) for r in extras),
           "distinct_root_tuple_count":len(distinct_pairs),
           "lemma_checks":lemmas,"primary_host":primary,"additional_hosts":extras,
           "entire_centered_fine_spectrum":[[x,2],[y,1],[alpha**2,2],[F(0),2]],
           "all_exact_checks_passed":True}
    (HERE/"continuation5_cone_checks.json").write_text(json.dumps(serialize(out),indent=2)+"\n")
    print(json.dumps(serialize({k:out[k] for k in ("lemma_check_count","actual_root_specification_count","distinct_actual_root_count","root_specification_tuple_count","distinct_root_tuple_count","all_exact_checks_passed")})))
    print(json.dumps(serialize({k:primary[k] for k in ("p","min_W","max_W","max_A")})))


if __name__ == "__main__":
    main()
