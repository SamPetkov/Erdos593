#!/usr/bin/env python3
"""Run the exact reviewed local standalone bundle; no downloads or background jobs.

Example: python run.py --bundle erdos593-standalone-sync-20260923.zip
  --source /path/private --kind accepted --output /new/path
Arguments other than --bundle are forwarded to the locked release program.
"""
from __future__ import annotations
import argparse
import hashlib
from pathlib import Path, PurePosixPath
import stat
import subprocess
import sys
import tempfile
import zipfile

SHA256 = '7eeba509e47c900d4f9d13c514dfca70981f54f95b8ae806f3bb4b706744c58c'
TOP = 'erdos593-standalone-sync-20260923'


def extract(bundle: Path, destination: Path) -> Path:
    raw = bundle.read_bytes()
    if hashlib.sha256(raw).hexdigest() != SHA256:
        raise ValueError('Wrong source bundle; no code has been executed')
    with zipfile.ZipFile(bundle) as archive:
        members = archive.infolist()
        if len(members) > 200 or sum(m.file_size for m in members) > 32 * 2**20:
            raise ValueError('Unexpected archive size')
        seen = set()
        for m in members:
            p = PurePosixPath(m.filename)
            mode = m.external_attr >> 16
            if (p.is_absolute() or '..' in p.parts or not p.parts or p.parts[0] != TOP
                    or '\\' in m.filename or ':' in m.filename or stat.S_ISLNK(mode)
                    or m.filename in seen):
                raise ValueError('Unsafe archive member')
            seen.add(m.filename)
            target = destination.joinpath(*p.parts)
            if m.is_dir():
                target.mkdir(parents=True, exist_ok=True)
            else:
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(archive.read(m))
    main = destination / TOP / 'release.py'
    if not main.is_file():
        raise ValueError('Release program is absent')
    return main


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bundle', type=Path, required=True)
    args, rest = parser.parse_known_args()
    if rest and rest[0] == '--':
        rest = rest[1:]
    with tempfile.TemporaryDirectory(prefix='e593-locked-release-') as tmp:
        program = extract(args.bundle.resolve(), Path(tmp))
        return subprocess.run([sys.executable, str(program), *rest], check=False).returncode


if __name__ == '__main__':
    raise SystemExit(main())
