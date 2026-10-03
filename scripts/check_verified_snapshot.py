"""Read-only accepted-checkpoint bytes and evidence structure; no Lean or network.

This does not create proof acceptance or infer GitHub push/merge state. The
recorded canonical and separately reconciled final checks supply proof provenance.
"""
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import sys

if sys.flags.optimize:
    raise RuntimeError('Optimized Python removes required evidence guards')

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / 'validation/2026-10-03-covers-grading'
MANIFEST_SHA = '7dbb8996abd260727157a2d7d64b1f21f61d2600007a70d07bb82af569a1895a'
STANDALONE_SHA = '42b8955cc2ba5ffe5aaf32fa7ff111d04096bf0f485271ac9ba6e9a4b19304c9'
SAFE_HASHES = {
    'source-manifest.json': MANIFEST_SHA,
    'root-coverage.json': 'aa3cf5bdb0252e7be8eae33c024c6c5dbaf027cfa3b74c6397bf18e025887fc1',
    'roots-summary.json': '8297ddff4276d49c5aa67668e58f7dadef8084c10b2d2ed778b7846d43b3a8d4',
    'compiler.log': '98e0981047bbf5c7289f7eb988532a4e923f301d2014b5633936cba0b1ffbc0a',
    'axioms.log': '40bdf0ec877a4cfe4ce888d669e634f843962ce7e00eaf0f2c247f272a792b23',
    'regeneration-before.log': '8f83f9aa99141736125c696d7da34382d45c3cc86801c0435766b1b94d431bc4',
    'regeneration.log': '2920c41e9440973b29e290c4156a92a2c458c2d6620a6a008f7fbc913425554d',
    'regeneration-after.log': '8f83f9aa99141736125c696d7da34382d45c3cc86801c0435766b1b94d431bc4',
    'standalone.log': 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
}
NEW_NAMES = [
    'E593FiniteSetoid.map_of_le_surjective', 'E593FiniteSetoid.quotient_card_antitone',
    'E593FiniteSetoid.quotient_card_strict_antitone', 'E593FiniteSetoid.exists_one_class_coarsening',
    'E593FiniteSetoid.quotient_card_of_covBy', 'E593FiniteSetoid.covBy_of_quotient_card',
    'E593FiniteSetoid.covBy_iff_quotient_card',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPartitions_covBy_iff',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPartitions_covBy_iff_exists_unique',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPartitions_standard_covBy_iff',
    'Erdos593.TripleSystem.CanonicalAtom.obligatory_supportedPartitions_covBy_iff',
    'Erdos593.TripleSystem.CanonicalAtom.supportedProduct_block_card_le',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPieceDeficit_eq_sum',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPieces_add_deficit',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPartitions_block_card_strict_antitone',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPartitions_block_card_of_covBy',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPartitions_covBy_iff_block_card',
    'Erdos593.TripleSystem.CanonicalAtom.supportedPartitions_covBy_iff_piece_deficit',
]


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def safe_relative(name):
    path = PurePosixPath(name)
    assert name and '\\' not in name and ':' not in name and not path.is_absolute()
    assert path.parts and path.as_posix() == name and all(part not in ('', '.', '..') for part in path.parts)
    return path


def local_path(root, name):
    path = root / safe_relative(name)
    assert path.resolve().is_relative_to(root.resolve())
    cursor = path
    while cursor != root:
        assert not cursor.is_symlink(), name
        cursor = cursor.parent
    return path


def parse_axioms(output, expected):
    assert expected and len(expected) == len(set(expected))
    record = re.compile(r"(['`])([^'`\r\n]+)\1\s+(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)", re.S)
    token = r'(?:propext|(?:Classical\.choice|Quot\.sound)(?:\.\{[A-Za-z_][A-Za-z0-9_]*\})?)'
    remaining, result = output.strip(), []
    for index, name in enumerate(expected):
        match = record.match(remaining)
        assert match and match[2] == name, name
        body = match[3]
        if body is None or not body.strip():
            used = []
        else:
            assert re.fullmatch(r'\s*' + token + r'(?:\s*,\s*' + token + r')*\s*', body)
            used = [re.sub(r'\.\{[A-Za-z_][A-Za-z0-9_]*\}$', '', part.strip()) for part in body.split(',')]
            assert len(used) == len(set(used)) and set(used) <= {'propext', 'Classical.choice', 'Quot.sound'}
        result.append({'declaration': name, 'axioms': used})
        tail = remaining[match.end():]
        if index + 1 < len(expected):
            assert re.match(r'^[ \t]*\r?\n', tail)
        remaining = tail.strip()
    assert not remaining
    return result


def main():
    source_manifest = local_path(ROOT, 'validation/2026-10-03-covers-grading/source-manifest.json').read_bytes()
    assert sha(source_manifest) == MANIFEST_SHA
    sources = json.loads(source_manifest)
    assert isinstance(sources, dict) and len(sources) == 258
    total = 0
    for name, digest in sources.items():
        assert safe_relative(name).parts[0] == 'formalization'
        assert re.fullmatch('[0-9a-f]{64}', digest)
        raw = local_path(ROOT, name).read_bytes()
        assert sha(raw) == digest, name
        total += len(raw)
    assert total == 3533550
    standalone = local_path(ROOT, 'formalization/Erdos593SelfContained.lean').read_bytes()
    assert sha(standalone) == STANDALONE_SHA and len(standalone.splitlines()) == 42090
    assert json.loads(local_path(ROOT, 'validation/2026-10-03-covers-grading/evidence-manifest.json').read_bytes()) == SAFE_HASHES
    for name, digest in SAFE_HASHES.items():
        assert sha(local_path(EVIDENCE, name).read_bytes()) == digest, name
    assert local_path(EVIDENCE, '.gitattributes').read_bytes() == b'*.log -text\n*.json -text\n'
    for directory in sorted((ROOT / 'validation').iterdir()):
        assert not directory.is_symlink()
        record = directory / 'evidence-manifest.json'
        if not record.is_file():
            continue
        for name, digest in json.loads(record.read_bytes()).items():
            assert safe_relative(name).name == name
            assert re.fullmatch('[0-9a-f]{64}', digest)
            assert sha(local_path(directory, name).read_bytes()) == digest
    coverage = json.loads(local_path(EVIDENCE, 'root-coverage.json').read_bytes())
    summary = json.loads(local_path(EVIDENCE, 'roots-summary.json').read_bytes())
    assert summary['all_root_pass'] is True and summary['module_count'] == 250
    assert [row['module'] for row in coverage['ordered_modules']] == summary['ordered_modules']
    assert len(coverage['ordered_modules']) == len({row['module'] for row in coverage['ordered_modules']}) == 250
    assert len(coverage['external_imports']) == 70 and summary['elapsed_seconds'] <= 1380
    for row in coverage['ordered_modules']:
        assert sources['formalization/' + row['path']] == row['source_sha256']
    audit = local_path(ROOT, 'formalization/Erdos593/AxiomAudit.lean').read_text(encoding='utf-8')
    expected = re.findall(r'^#print axioms (\S+)$', audit, re.M)
    assert len(expected) == len(set(expected)) == 401 and expected[-18:] == NEW_NAMES
    parse_axioms(local_path(EVIDENCE, 'axioms.log').read_text(encoding='utf-8'), expected)
    assert local_path(EVIDENCE, 'standalone.log').read_bytes() == b''
    print('PASS: 258 source files, 250-module coverage, 401 ordered standard-only audits and all evidence hashes.')
    print('Source/evidence verification only; canonical66570 and separate final acceptance supply proof provenance. GitHub delivery is separate.')


if __name__ == '__main__':
    main()
