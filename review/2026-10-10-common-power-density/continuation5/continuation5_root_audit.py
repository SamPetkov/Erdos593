"""Isolated replay of the frozen continuation-five proof certificates.

Each program receives its own copy, so no archived result or peer review
is rewritten. The numerical diagnostic replay remains separate from the
exact rational certificates. No optimizer is run by this audit.
"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile

HERE=Path(__file__).resolve().parent
PROGRAMS=[
    ("continuation5_cone_verify.py","continuation5_cone_checks.json","exact"),
    ("continuation5_unequal_cancellation_verify.py","continuation5_unequal_cancellation_checks.json","exact"),
    ("continuation5_unequal_quadratic_verify.py","continuation5_unequal_quadratic_checks.json","exact"),
    ("continuation5_search_pointwise_verify.py","continuation5_search_pointwise_checks.json","exact"),
    ("continuation5_cover_obstructions_verify.py","continuation5_cover_obstructions_checks.json","exact"),
    ("continuation5_search_cone_review.py","continuation5_search_cone_review.json","exact"),
    ("continuation5_root_cover_review.py","continuation5_root_cover_review.json","exact"),
    ("continuation5_search_projection_audit.py","continuation5_search_projection_audit.json","floating_diagnostic"),
]


def normalized(x):
    if isinstance(x,dict):return {k:normalized(v) for k,v in x.items() if k!="elapsed_seconds"}
    if isinstance(x,list):return [normalized(v) for v in x]
    return x


def main():
    snapshot=[p for p in HERE.iterdir() if p.is_file() and p.suffix in (".md",".py",".json",".log")]
    hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in snapshot}
    utility=HERE.parent/"continuation4"/"continuation4_projection_verify.py"
    assert hashlib.sha256(utility.read_bytes()).hexdigest()=="4ab0f3f2b28107b46c917536ea7de1acc9c15626b1cf9f93d225264c1cd5b33e"
    temp=Path(tempfile.mkdtemp(prefix="e593_continuation5_root_audit_"))
    environment=os.environ.copy()
    environment["OPENBLAS_NUM_THREADS"]="1"
    environment["OMP_NUM_THREADS"]="1"
    def run(item):
        source,result,kind=item
        parent=temp/Path(source).stem
        work=parent/"continuation5";old=parent/"continuation4"
        work.mkdir(parents=True);old.mkdir()
        for p in snapshot:shutil.copyfile(p,work/p.name)
        shutil.copyfile(utility,old/utility.name)
        expected=json.loads((HERE/result).read_text())
        process=subprocess.run([sys.executable,source],cwd=work,env=environment,
                               capture_output=True,text=True,timeout=60)
        assert process.returncode==0,(source,process.stdout,process.stderr)
        observed=json.loads((work/result).read_text())
        assert normalized(observed)==normalized(expected),(source,"archival replay mismatch")
        return {"program":source,"result":result,"kind":kind,"status":"PASS",
                "source_sha256":hashes[source],"archived_result_sha256":hashes[result],
                "archival_values_identical_excluding_elapsed_seconds":True}
    with ThreadPoolExecutor(max_workers=4) as pool:
        checks=list(pool.map(run,PROGRAMS))
    # Peer-review basename/hash bindings must name the exact shipped bytes.
    bound=0
    def check_bindings(x):
        nonlocal bound
        if isinstance(x,dict):
            for k,v in x.items():
                if isinstance(v,str) and len(v)==64 and all(c in "0123456789abcdef" for c in v):
                    if k in hashes:
                        assert hashes[k]==v,(k,"peer-review hash mismatch")
                        bound+=1
                check_bindings(v)
        elif isinstance(x,list):
            for v in x:check_bindings(v)
    reviews=[p for p in snapshot if "review" in p.name and p.suffix==".json"]
    for p in reviews:check_bindings(json.loads(p.read_text()))
    # Verify the original package was not modified by a replay.
    for p in snapshot:assert hashlib.sha256(p.read_bytes()).hexdigest()==hashes[p.name]
    out={"status":"PASS","source_sha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         "program_count":len(checks),"exact_program_count":sum(r["kind"]=="exact" for r in checks),
         "floating_diagnostic_program_count":sum(r["kind"]=="floating_diagnostic" for r in checks),
         "programs":checks,"peer_review_basename_hash_bindings_checked":bound,
         "archived_package_unchanged":True,
         "proof_review_scope":[
             "Common-cone comparison is for an actual binary projection channel; it has no reflection restriction but is not a reduction of every target root.",
             "Quadratic unequal-star estimate has no unknown cubic on its right; its exact limitation control rules out treating it as a necessary or universal certificate.",
             "Cancellation, pointwise, and cover-core signs are failures of stronger mechanisms; all complete densities displayed are positive relative to the target baseline.",
             "Original probability, actual roots, zero bands and full centered multiplicities are explicit in every certificate."
         ],
         "limitation":"The finite programs audit displayed instances and identities. Universal proofs and asymptotic claims are established by the written mathematics; the unrestricted target remains unresolved."}
    (HERE/"continuation5_root_audit.json").write_text(json.dumps(out,indent=2)+"\n")
    print(json.dumps({k:out[k] for k in ("status","program_count","exact_program_count","floating_diagnostic_program_count","peer_review_basename_hash_bindings_checked","archived_package_unchanged")}))


if __name__=="__main__":main()
