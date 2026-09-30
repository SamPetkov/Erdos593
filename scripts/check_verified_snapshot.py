"""Read-only verification of the published source and evidence snapshot; no Lean."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / 'validation/2026-09-30-classical-labels'

def sha(raw):
    return hashlib.sha256(raw).hexdigest()

def main():
    sources = json.loads((EVIDENCE / 'source-manifest.json').read_text(encoding='utf-8'))
    assert len(sources) == 241
    for name, digest in sources.items():
        assert name.startswith('formalization/') and '..' not in Path(name).parts
        assert sha((ROOT / name).read_bytes()) == digest, name
    report = json.loads((EVIDENCE / 'evidence-manifest.json').read_text(encoding='utf-8'))
    for name, digest in report.items():
        assert Path(name).name == name
        assert sha((EVIDENCE / name).read_bytes()) == digest, name
    print('PASS: 241 accepted source files and all published evidence hashes; no Lean executed.')

if __name__ == '__main__':
    main()
