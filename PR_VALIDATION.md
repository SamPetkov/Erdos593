# Finite parameter spectrum branch validation

- synchronization exit status: 1
- PDF and mirror verification exit status: 1
- Pandoc: pandoc 3.1.3
- TeX: pdfTeX 3.141592653-2.6-1.40.25 (TeX Live 2023/Debian)

## Synchronization log tail
```text
Traceback (most recent call last):
  File "/home/runner/work/Erdos593/Erdos593/scripts/sync_manuscript_artifacts.py", line 274, in <module>
    synchronize()
  File "/home/runner/work/Erdos593/Erdos593/scripts/sync_manuscript_artifacts.py", line 245, in synchronize
    canonical = normalize_tex(CANONICAL_TEX.read_text(encoding="utf-8"))
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/runner/work/Erdos593/Erdos593/scripts/sync_manuscript_artifacts.py", line 83, in normalize_tex
    raise RuntimeError(f"canonical TeX is missing required release wording: {missing}")
RuntimeError: canonical TeX is missing required release wording: ['first publicly posted complete mathematical proof']
```
