#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="erdos593_obligatory_triple_systems"
BUILD_DIR="$(mktemp -d "${TMPDIR:-/tmp}/erdos593-annals.XXXXXX")"
trap 'rm -rf "$BUILD_DIR"' EXIT

cp "$ROOT/$BASE.tex" "$ROOT/references.bib" "$BUILD_DIR/"
cd "$BUILD_DIR"

# Fix the reproducible PDF creation/modification timestamp at 11 July 2026,
# 12:00 UTC. LuaTeX and hyperref honour SOURCE_DATE_EPOCH.
export TZ=UTC
export SOURCE_DATE_EPOCH=1783771200
export FORCE_SOURCE_DATE=1

lualatex -interaction=nonstopmode -halt-on-error "$BASE.tex"
biber "$BASE"
lualatex -interaction=nonstopmode -halt-on-error "$BASE.tex"
lualatex -interaction=nonstopmode -halt-on-error "$BASE.tex"

cp "$BASE.pdf" "$ROOT/$BASE.pdf"
printf 'Built %s\n' "$ROOT/$BASE.pdf"
