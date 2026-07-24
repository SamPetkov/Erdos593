from pathlib import Path

path = Path('scripts/sync_manuscript_artifacts.py')
text = path.read_text(encoding='utf-8')
old = '''        "first publicly posted complete mathematical proof",
'''
new = '''        "first publicly posted",
        "complete mathematical proof of Theorem",
'''
if text.count(old) != 1:
    raise SystemExit(f'expected one wording check, found {text.count(old)}')
path.write_text(text.replace(old, new, 1), encoding='utf-8')
print('fixed synchronization release wording checks')
