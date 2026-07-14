#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="Erdos593"

if ! command -v gh >/dev/null 2>&1; then
  printf 'GitHub CLI (gh) is required: https://cli.github.com/\n' >&2
  exit 1
fi

gh auth status >/dev/null

if git remote get-url origin >/dev/null 2>&1; then
  printf 'The origin remote already exists: %s\n' "$(git remote get-url origin)" >&2
  exit 1
fi

# GitHub CLI fails rather than replacing an existing repository of this name.
gh repo create "$REPO_NAME" --private --source=. --remote=origin --push
printf 'Created and pushed private repository %s.\n' "$REPO_NAME"
