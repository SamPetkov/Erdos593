"""Independent original-vertex polynomial check of the cover obstruction.

This expands the two-state vertex integral as polynomials. It does not use
the author's 2^12 edge-subset enumeration or trace-source implementation.
The review concerns a failed coefficientwise mechanism, not F<1.
"""
from fractions import Fraction as F
from itertools import product
from pathlib import Path
import hashlib
import json

HERE=Path(__file__).resolve().parent
EDGES=((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))
EXP=(1,2,1,1,1,1)


def exact_vertex_polynomial(switched):
    mu=(F(1,10),F(9,10));phi=(F(3),-F(1,3))
    out=[F(0)]*15
    for xs in product(range(2),repeat=8):
        weight=F(1)
        for v in xs:weight*=mu[v]
        poly=[weight]
        for sheet in (0,1):
            for e,(u,v) in enumerate(EDGES):
                target=1-sheet if switched and e==0 else sheet
                c=phi[xs[4*sheet+u]]*phi[xs[4*target+v]]
                n=EXP[e]
                new=poly+[F(0)]*n
                for j,q in enumerate(poly):new[j+n]+=q*c
                poly=new
        assert len(poly)==15
        out=[a+b for a,b in zip(out,poly)]
    return out


def main():
    trivial=exact_vertex_polynomial(False)
    switched=exact_vertex_polynomial(True)
    defect=[a-b for a,b in zip(trivial,switched)]
    c=F(64,9)
    expected={3:F(2),4:F(4),5:2+2*c,6:2+8*c,7:6+2*c*c,
              8:8-2*c,9:6+8*c,10:2+2*c,11:-2*c}
    assert defect==[expected.get(j,F(0)) for j in range(15)]
    assert defect[8]==-F(56,9) and defect[11]==-F(128,9)
    assert defect[8]/4**8==-F(7,73728)
    assert defect[11]/4**11==-F(1,294912)
    # Expand the displayed nonnegative grouping symbolically, not by
    # matching sampled values. Each term is nonnegative for 0<=z<=1.
    grouped=[F(0)]*15
    for monomial in ({3:2},{4:4},{5:2*(1+c)},{6:2},
                     {6:8*c,8:-2*c},{7:6+2*c*c},{8:8},
                     {9:6+8*c},{10:2},{10:2*c,11:-2*c}):
        for j,v in monomial.items():grouped[j]+=v
    assert grouped==defect
    files=("continuation5_cover_obstructions.md",
           "continuation5_cover_obstructions_verify.py",
           "continuation5_cover_obstructions_checks.json")
    out={"status":"PASS","reviewer":"root independent polynomial integration",
         "review_source_sha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         "source_hashes":{name:hashlib.sha256((HERE/name).read_bytes()).hexdigest() for name in files},
         "independent_method":"Literal original-law eight-vertex sums with polynomial-valued edge multiplication; no edge-subset counting or diamond trace formula imported.",
         "assignments_per_cover":256,"polynomial_degree":14,
         "defect_coefficients_in_z":[str(z) for z in defect],
         "full_grouping_identity_exact":True,
         "mathematical_review":[
             "Original trace-source R=K_k D* follows by integrating each sheet's c,d and matching crossed endpoints.",
             "The full symbolic rank-one defect matches the independent vertex polynomial; its two negative coefficients coexist with the nonnegative grouped formula.",
             "The proper centered barbell reduces to <diag C_s,C_k diag C_t> by original-law cycle composition, so PSD does not force its cross pairing nonnegative.",
             "The five-state projection has original conditional mean-zero rows and is orthogonal to the pulled-back coarse root; the claimed power transport and diagonal-variance reduction use those exact identities.",
             "Three centered positive bands plus zero are all counted; complete F>1 and Z_ab<F^2 are separate exact finite assertions, not inferred from an individual barbell.",
             "For fixed bridge exponent, the stated matrix of length-indexed barbells is a Gram matrix; its diagonal budget in arbitrary covers is not assumed available."
         ],
         "scope":"Exact obstruction to coefficientwise positivity, with whole polynomial nonnegative; no global cover or target counterexample."}
    (HERE/"continuation5_root_cover_review.json").write_text(json.dumps(out,indent=2)+"\n")
    print("PASS: independent polynomial-valued original-vertex integration and exact nonnegative regrouping")


if __name__=="__main__":main()
