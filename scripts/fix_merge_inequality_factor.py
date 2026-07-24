from pathlib import Path

replacements = {
    Path('erdos593_obligatory_triple_systems.tex'): (
        r'$(\sqrt a-1)(\sqrt b-1)\ge0$; taking ceilings gives (10.5).',
        r'$(a-1)(b-1)\ge0$; taking ceilings gives (10.5).',
    ),
    Path('FINITE_PARAMETER_SPECTRUM.md'): (
        '`(sqrt(a)-1)(sqrt(b)-1) >= 0`.',
        '`(a-1)(b-1) >= 0`.',
    ),
}

for path, (old, new) in replacements.items():
    text = path.read_text(encoding='utf-8')
    if text.count(old) != 1:
        raise SystemExit(f'{path}: expected one occurrence, found {text.count(old)}')
    path.write_text(text.replace(old, new, 1), encoding='utf-8')

print('corrected merge-inequality factorization')
