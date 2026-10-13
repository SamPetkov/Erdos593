"""Replay the frozen continuation7 packet without changing its inputs.

The default is exact standard-library arithmetic. --include-numerical
adds independent replay of saved results, not an optimizer or a search.
Each checker receives its own temporary copy, so generated timing fields
cannot change another checker's hash-bound inputs.
"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
BASE = HERE.parent
MANIFEST = HERE/'continuation7_manifest.json'
EXACT = [
    ('continuation7_source_weighted_verify.py','continuation7_source_weighted_checks.json'),
    ('continuation7_opt_ac_exact.py','continuation7_opt_ac_exact_checks.json'),
    ('continuation7_cover_orbits_verify.py','continuation7_cover_orbits_checks.json'),
    ('continuation7_cover_source_review.py','continuation7_cover_source_review.json'),
    ('continuation7_root_review.py','continuation7_root_review.json'),
]
NUMERICAL = ('continuation7_opt_highrank_audit.py','continuation7_opt_highrank_audit.json')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalized(value):
    if isinstance(value,dict):
        return {k:normalized(v) for k,v in value.items() if k not in ('seconds','elapsed_seconds')}
    if isinstance(value,list):return [normalized(v) for v in value]
    return value


def check_bindings():
    explicit = {
        'continuation7_source_weighted_checks.json':{
            'source_sha256':'continuation7_source_weighted_verify.py',
            'note_sha256':'continuation7_source_weighted_complement.md'},
        'continuation7_opt_ac_exact_checks.json':{
            'source_sha256':'continuation7_opt_ac_exact.py'},
        'continuation7_cover_orbits_checks.json':{
            'checker_sha256':'continuation7_cover_orbits_verify.py'},
        'continuation7_cover_source_review.json':{
            'reviewed_note_sha256':'continuation7_source_weighted_complement.md'},
        'continuation7_opt_cover_review.json':{
            'note_sha256':'continuation7_cover_orbits.md',
            'source_sha256':'continuation7_cover_orbits_verify.py',
            'certificate_sha256':'continuation7_cover_orbits_checks.json'},
        'continuation7_opt_highrank_audit.json':{
            'source_sha256':'continuation7_opt_highrank.py',
            'results_sha256':'continuation7_opt_highrank_results.json',
            'audit_source_sha256':'continuation7_opt_highrank_audit.py'},
        'continuation7_root_review.json':{
            'review_program_sha256':'continuation7_root_review.py'},
    }
    checked = 0
    for name,fields in explicit.items():
        value = json.loads((HERE/name).read_text())
        for key,source in fields.items():
            assert value[key] == sha(HERE/source),(name,key,source)
            checked += 1
    for name,key in [('continuation7_root_review.json','reviewed_file_sha256'),
                     ('continuation7_source_ac_review.json','bindings_sha256')]:
        value = json.loads((HERE/name).read_text())
        for source,digest in value[key].items():
            assert sha(HERE/source) == digest,(name,source)
            checked += 1
    return checked


def replay(source,result,files):
    expected = json.loads((HERE/result).read_text())
    with tempfile.TemporaryDirectory(prefix='e593-continuation7-') as directory:
        work = Path(directory)
        for name in files:shutil.copy2(HERE/name,work/name)
        env = dict(os.environ,OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',
                   MKL_NUM_THREADS='1',NUMEXPR_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
        proc = subprocess.run([sys.executable,source],cwd=work,env=env,
                              capture_output=True,text=True)
        assert proc.returncode == 0,(source,proc.stdout[-3000:],proc.stderr[-4000:])
        actual = json.loads((work/result).read_text())
        status = str(actual.get('status',actual.get('verdict',''))).lower()
        assert status.startswith('pass'),(source,status)
        assert normalized(actual) == normalized(expected),source
    return {'source':source,'result':result,'exact_stable_json_match':True,
            'ignored_timing_fields':['seconds','elapsed_seconds'],
            'scope':'numerical replay only' if (source,result)==NUMERICAL else 'exact finite certificate/review'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--include-numerical',action='store_true')
    args = parser.parse_args()
    manifest = json.loads(MANIFEST.read_text())
    files = manifest['files']
    for name,info in files.items():
        assert sha(HERE/name) == info['sha256'],name
        assert (HERE/name).stat().st_size == info['bytes'],name
    for name,digest in manifest['inherited_dependencies'].items():
        assert sha(BASE/name) == digest,name
    bindings = check_bindings()
    before = {name:sha(HERE/name) for name in files}
    runs = []
    for source,result in EXACT + ([NUMERICAL] if args.include_numerical else []):
        runs.append(replay(source,result,files))
        print(json.dumps({'passed':source}),flush=True)
    assert before == {name:sha(HERE/name) for name in files}
    output = {'status':'PASS','scope':'reproducibility only; unrestricted target, U and C remain unresolved',
              'source_sha256':sha(Path(__file__)),'manifest_sha256':sha(MANIFEST),
              'frozen_files':len(files),'inherited_dependencies':len(manifest['inherited_dependencies']),
              'review_and_certificate_hash_bindings':bindings,'runs':runs,
              'all_frozen_inputs_unchanged':True,'optimizer_started':False,
              'numerical_replay_requested':args.include_numerical}
    (HERE/'continuation7_packet_audit.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({'status':'PASS','runs':len(runs),'frozen_files':len(files),'optimizer_started':False}))


if __name__ == '__main__':main()
