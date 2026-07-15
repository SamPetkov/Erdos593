#!/usr/bin/env python3
"""Regenerate the repository manifest and package checksums from Git's index."""

from __future__ import annotations

import hashlib
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MANIFEST = ROOT / "MANIFEST.txt"
CHECKSUMS = ROOT / "SHA256SUMS"


def indexed_paths() -> list[str]:
    result = subprocess.run(
        ["git", "-C", str(ROOT), "ls-files", "-z"],
        check=True,
        capture_output=True,
    )
    return sorted(path for path in result.stdout.decode("utf-8").split("\0") if path)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    paths = indexed_paths()
    required = {"MANIFEST.txt", "SHA256SUMS"}
    missing = required.difference(paths)
    if missing:
        raise SystemExit(f"package metadata is not tracked: {sorted(missing)}")

    MANIFEST.write_text("\n".join(paths) + "\n", encoding="utf-8", newline="\n")
    checksum_lines = [
        f"{sha256(ROOT / path)}  {path}"
        for path in paths
        if path != "SHA256SUMS"
    ]
    CHECKSUMS.write_text(
        "\n".join(checksum_lines) + "\n", encoding="utf-8", newline="\n"
    )


if __name__ == "__main__":
    main()
