"""Reproduce this frozen research packet without changing its inputs.

Run in the continuation6 directory.  The default uses only the Python
standard library.  --include-numerical adds replay of the saved numerical
records; it requires NumPy/SciPy and starts no optimization.
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
MANIFEST = HERE/'continuation6_manifest.json'

EXACT = [
    ('continuation6_graded_verify.py', 'continuation6_graded_checks.json'),
    ('continuation6_jordan_verify.py', 'continuation6_jordan_checks.json'),
    ('continuation6_unequal_balanced_verify.py', 'continuation6_unequal_balanced_checks.json'),
    ('continuation6_cover_moments_verify.py', 'continuation6_cover_moments_checks.json'),
    ('continuation6_search_codimension_one_verify.py', 'continuation6_search_codimension_one_checks.json'),
]
INDEPENDENT = [
    ('continuation6_root_review.py', 'continuation6_root_review.json'),
    ('continuation6_unequal_jordan_review.py', 'continuation6_unequal_jordan_review.json'),
    ('continuation6_unequal_cover_review.py', 'continuation6_unequal_cover_review.json'),
    ('continuation6_cover_rank2_jordan_review.py', 'continuation6_cover_rank2_jordan_review.json'),
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalized(value):
    if isinstance(value, dict):
        return {key: normalized(item) for key, item in value.items()
                if key != 'elapsed_seconds'}
    if isinstance(value, list):
        return [normalized(item) for item in value]
    return value


def bound_path(name):
    if (HERE/name).is_file():
        return HERE/name
    if name in ('continuation4_projection_verify.py', 'continuation4_tensor_projection_lemmas.md'):
        return BASE/'continuation4'/name
    if name == 'tp2-class.md':
        return BASE/name
    raise AssertionError('Unknown review-bound file: '+name)


def verify_review_bindings(names):
    counts = {}
    for name in names:
        if not name.endswith('_review.json'):
            continue
        record = json.loads((HERE/name).read_text())
        bindings = record.get('reviewed_files', record.get('reviewed_sha256', {}))
        for source, digest in bindings.items():
            assert sha(bound_path(source)) == digest, (name, source)
        source_name = name[:-5]+'.py'
        digest = record.get('review_source_sha256', record.get('source_sha256'))
        if digest is not None and (HERE/source_name).is_file():
            assert sha(HERE/source_name) == digest, name
        counts[name] = len(bindings)
    return counts


def isolated_run(source, result, files, compare):
    expected = json.loads((HERE/result).read_text())
    with tempfile.TemporaryDirectory(prefix='e593-continuation6-replay-') as temp:
        base = Path(temp)
        stage = base/'continuation6'
        stage.mkdir()
        (base/'continuation4').mkdir()
        shutil.copy2(BASE/'continuation4/continuation4_projection_verify.py',
                     base/'continuation4/continuation4_projection_verify.py')
        shutil.copy2(BASE/'tp2-class.md', base/'tp2-class.md')
        for name in files:
            shutil.copy2(HERE/name, stage/name)
        # Search replay never invokes the optimizer main functions.  One
        # BLAS thread also matches the retained diagnostic environment.
        env = dict(os.environ, OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1',
                   MKL_NUM_THREADS='1', NUMEXPR_NUM_THREADS='1',
                   PYTHONDONTWRITEBYTECODE='1')
        proc = subprocess.run([sys.executable, source], cwd=stage, env=env,
                              capture_output=True, text=True)
        assert proc.returncode == 0, (source, proc.stdout[-2000:], proc.stderr[-4000:])
        actual = json.loads((stage/result).read_text())
        status = str(actual.get('status', actual.get('verdict', ''))).lower()
        assert status.startswith('pass') or actual.get('all_exact_checks_passed') is True, (source, status)
        if compare:
            assert normalized(actual) == normalized(expected), source
        else:
            # The cover review preserves an amendment history in its
            # frozen JSON.  A fresh full replay asserts the current inputs
            # again; it does not recreate the earlier review chronology.
            for source_name, digest in actual.get('reviewed_files', actual.get('reviewed_sha256', {})).items():
                assert sha(bound_path(source_name)) == digest
        return {'source': source, 'result': result, 'exit_code': 0,
                'fresh_assertions_passed': True,
                'compared_frozen_json': compare,
                'ignored_json_keys_when_compared': ['elapsed_seconds'] if compare else [],
                'scope': 'Numerical diagnostic replay only' if source == 'continuation6_search_audit.py'
                         else 'Exact rational checks and stated-scope review assertions'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--include-numerical', action='store_true')
    args = parser.parse_args()
    manifest = json.loads(MANIFEST.read_text())
    files = manifest['files']
    for name, info in files.items():
        assert sha(HERE/name) == info['sha256'], name
        assert (HERE/name).stat().st_size == info['bytes'], name
    for name, digest in manifest['inherited_dependencies'].items():
        assert sha(BASE/name) == digest, name
    bindings = verify_review_bindings(files)
    frozen = {name: (HERE/name).read_bytes() for name in files}
    results = []
    for source, result in EXACT:
        results.append(isolated_run(source, result, files, compare=True))
        print(json.dumps({'passed': source}), flush=True)
    for source, result in INDEPENDENT:
        # Root and unequal6 reviews are deterministic; cover6's historical
        # amendment record is preserved and separately bound by hash.
        compare = source != 'continuation6_cover_rank2_jordan_review.py'
        results.append(isolated_run(source, result, files, compare=compare))
        print(json.dumps({'passed': source}), flush=True)
    if args.include_numerical:
        results.append(isolated_run('continuation6_search_audit.py',
                                    'continuation6_search_audit.json', files, compare=True))
        print(json.dumps({'passed': 'continuation6_search_audit.py'}), flush=True)
    assert all((HERE/name).read_bytes() == data for name, data in frozen.items())
    output = {'status': 'PASS',
              'scope': 'Reproduction and hash audit only; unrestricted F, U, and C remain unresolved.',
              'source_sha256': sha(Path(__file__)), 'manifest_sha256': sha(MANIFEST),
              'frozen_file_count': len(files), 'all_frozen_inputs_unchanged': True,
              'review_binding_counts': bindings, 'runs': results,
              'numerical_replay_requested': args.include_numerical,
              'optimizer_started': False}
    (HERE/'continuation6_packet_audit.json').write_text(json.dumps(output, indent=2)+'\n')
    print(json.dumps({'status': 'PASS', 'runs': len(results),
                      'all_frozen_inputs_unchanged': True, 'optimizer_started': False}))


if __name__ == '__main__':
    main()
