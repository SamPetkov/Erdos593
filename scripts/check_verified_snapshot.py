"""Read-only accepted-checkpoint hashes and evidence structure; no Lean/network."""
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / 'validation/2026-10-02-piece-accounting'
MANIFEST_SHA = '90805ce2f51fd47babcdcef06cebd5ab78d89b93e8ba90c69ccbc17f903099e8'
STANDALONE_SHA = 'ff6ced8b086ce4d02d8a603436b9440b9ec870518d7015ecb6bade65b3b6dede'


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def main():
    assert not sys.flags.optimize, 'Assertions must remain enabled'
    raw = (EVIDENCE / 'source-manifest.json').read_bytes()
    assert sha(raw) == MANIFEST_SHA
    sources = json.loads(raw)
    assert len(sources) == 254
    total = 0
    for name, digest in sources.items():
        assert name.startswith('formalization/') and '..' not in Path(name).parts
        assert re.fullmatch(r'[0-9a-f]{64}', digest)
        data = (ROOT / name).read_bytes()
        assert sha(data) == digest, name
        total += len(data)
    assert total == 3491437
    standalone = (ROOT / 'formalization/Erdos593SelfContained.lean').read_bytes()
    assert sha(standalone) == STANDALONE_SHA and len(standalone.splitlines()) == 41606
    for directory in sorted((ROOT / 'validation').iterdir()):
        record = directory / 'evidence-manifest.json'
        if not record.is_file():
            continue
        for name, digest in json.loads(record.read_bytes()).items():
            assert Path(name).name == name and name not in ('.', '..')
            assert sha((directory / name).read_bytes()) == digest, (directory.name, name)
    coverage = json.loads((EVIDENCE / 'root-coverage.json').read_bytes())
    summary = json.loads((EVIDENCE / 'roots-summary.json').read_bytes())
    assert summary['all_root_pass'] is True and summary['module_count'] == 246
    assert [row['module'] for row in coverage['ordered_modules']] == summary['ordered_modules']
    assert len(coverage['ordered_modules']) == 246 and len(coverage['external_imports']) == 69
    audit = (ROOT / 'formalization/Erdos593/AxiomAudit.lean').read_text(encoding='utf-8')
    expected = re.findall(r'^#print axioms (\S+)$', audit, re.M)
    axioms = (EVIDENCE / 'axioms.log').read_text(encoding='utf-8')
    pattern = r"^['`]([^'`]+)['`]\s+(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)\s*$"
    records = re.findall(pattern, axioms, re.M)
    assert [name for name, _ in records] == expected
    assert len(expected) == len(set(expected)) == 383
    assert re.sub(pattern, '', axioms, flags=re.M).strip() == '', 'Unparsed axiom output'
    for name, raw_axioms in records:
        ordered = [part.strip() for part in raw_axioms.split(',') if part.strip()]
        assert len(ordered) == len(set(ordered))
        assert set(ordered) <= {'propext', 'Classical.choice', 'Quot.sound'}, (name, ordered)
    assert (EVIDENCE / 'standalone.log').read_bytes() == b''
    print('PASS: 254 accepted source files, 246-module coverage, 383 ordered standard-only audits and all evidence hashes.')
    print('Hash/source verification only; proof acceptance followed canonical66494/final66495. GitHub delivery is separate.')


if __name__ == '__main__':
    main()
