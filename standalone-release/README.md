# Standalone synchronization checkpoint

These release-control files are mirrored between the proof repositories.
**Their presence does not mean the proof files have already been synchronized.**
The public root standalone is still the earlier snapshot. The accepted source
for the next release is locked in lock.json; pending extensions are separate.

Use the exact author-supplied `erdos593-standalone-sync-20260923.zip` bundle.
The launcher checks its SHA-256, rejects unsafe archive members, and runs its
reviewed source program locally. It performs no automatic downloads.

```sh
python standalone-release/run.py --bundle /path/to/erdos593-standalone-sync-20260923.zip \
  --source /path/to/Erdos593-private --kind accepted --output /new/path/release \
  --mirror /path/to/Erdos593-private --mirror /path/to/Erdos593 \
  --mirror /path/to/Erdos593-formalization --push
```

The actual frozen Git objects must exist in the source checkout. This creates
fresh branches, never replaces a current worktree or merges main. Each receives
the same managed `standalone/` proof, pins, license, audits, and release manifest.
Their Git subtree hashes must match; with --push their remote heads are checked.
Only an explicit publication allowlist is copied, not private evidence or logs.
Omit --push for local branches, or omit --mirror entirely for a local export.

For the consolidated extended proof, use --kind extended and --compile with the
actual installed --lean binary. Mirroring an extended candidate is refused unless
its full standalone, all ordered standard-only axiom reports, and full-type
checks succeed in that same run. Even success is not an assertion that every
statement of the expanded manuscript is formalized or canonically accepted.

The review package contains the 50 extension modules, the single concatenated
extension file, exact PR50 repair reconciliation, the full release program,
and 32 source/synchronization-tool tests. Fixture repositories in those tests
are not evidence that live proof mirrors or Lean compilation succeeded.

The root-level historical sources and challenge adapters are not silently
relabelled as the new release. Their final integration remains a reviewed step.
