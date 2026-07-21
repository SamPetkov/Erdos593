#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE=erdos593_obligatory_triple_systems
BUILD_DIR="$(mktemp -d "${TMPDIR:-/tmp}/erdos593.XXXXXX")"
trap 'rm -rf "$BUILD_DIR"' EXIT
cp "$ROOT/$BASE.tex" "$BUILD_DIR/"
cd "$BUILD_DIR"
export TZ=UTC SOURCE_DATE_EPOCH=1784635200 FORCE_SOURCE_DATE=1
latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error "$BASE.tex"
cp "$BASE.pdf" "$ROOT/$BASE.pdf"
