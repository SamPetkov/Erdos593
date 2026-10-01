"""Read-only accepted-checkpoint hash verification; no Lean or delivery-state inference."""
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / 'validation/2026-10-01-boundary-profile'
MANIFEST_SHA = '5acaa12e7e57d2a232251a7a1f99fd00f477439fae6653abd16c8ad5ebd533f0'

def sha(raw):
    return hashlib.sha256(raw).hexdigest()

def main():
    raw = (EVIDENCE / 'source-manifest.json').read_bytes()
    assert sha(raw) == MANIFEST_SHA
    sources = json.loads(raw)
    assert len(sources) == 253
    total = 0
    for name, digest in sources.items():
        assert name.startswith('formalization/') and '..' not in Path(name).parts
        data = (ROOT / name).read_bytes()
        assert sha(data) == digest, name
        total += len(data)
    assert total == 3465834
    for directory in sorted((ROOT / 'validation').iterdir()):
        record = directory / 'evidence-manifest.json'
        if not record.is_file():
            continue
        for name, digest in json.loads(record.read_bytes()).items():
            assert Path(name).name == name
            assert sha((directory / name).read_bytes()) == digest, (directory.name, name)
    coverage = json.loads((EVIDENCE / 'root-coverage.json').read_bytes())
    summary = json.loads((EVIDENCE / 'roots-summary.json').read_bytes())
    assert summary['all_root_pass'] is True and summary['module_count'] == 245
    assert [row['module'] for row in coverage['ordered_modules']] == summary['ordered_modules']
    assert len(coverage['ordered_modules']) == 245 and len(coverage['external_imports']) == 69
    audit = (ROOT / 'formalization/Erdos593/AxiomAudit.lean').read_text(encoding='utf-8')
    expected = re.findall(r'^#print axioms (\S+)$', audit, re.M)
    actual = re.findall(r"['`]([^'`]+)['`]\s+(?:depends on axioms:|does not depend on any axioms)",
                        (EVIDENCE / 'axioms.log').read_text(encoding='utf-8'))
    assert actual == expected and len(expected) == len(set(expected)) == 379
    assert (EVIDENCE / 'standalone.log').read_bytes() == b''
    print('PASS: 253 accepted-checkpoint source files, 245-module coverage, 379 audit names and all evidence hashes.')
    print('Hash verification only; source acceptance followed final66491. GitHub delivery state is separate.')

if __name__ == '__main__':
    main()
