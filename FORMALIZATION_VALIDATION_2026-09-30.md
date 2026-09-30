# Validation of the synchronized 30 September 2026 proof snapshot

This source-only synchronization changes no theorem body, statement or dependency
pin from the accepted classical-block integration. It brings the verified modular
sources and generated standalone into both repositories using an explicit file
allowlist. Private coordination records, service credentials, machine paths,
unreviewed candidate proofs and unrelated research are not exported.

## Evidence

Canonical run 66454 completed with scheduler and batch exit 0 in 19m01s:
3,363 warning-fatal all-root jobs, 325 ordered standard-only axiom records and
deterministic standalone regeneration/replay. Final source-only reconciliation
66455 completed with child, batch and scheduler exit 0 in one second. It checked
the actual live source, nine clean dependency pins, dependency link, original logs,
executed tools and real process exits. It did not rerun Lean.

Accepted source checkpoint: `95e421c081bbaef3b8b4036990f56df910b46f8d`.
Publicly reproducible identity is given by every SHA-256 entry in
`validation/2026-09-30-classical-blocks/source-manifest.json`, not by access to a private
Git commit. The six public-safe stdout files there are unedited actual originals;
the empty standalone log is the actual retrieved zero-byte file.
Operational wrappers and private coordination data are retained privately.
The latest integration review is author-authorized Codex self-review, not an
external independent audit.

## Commands

With the pinned toolchain and existing matching dependencies available:

```sh
python scripts/check_verified_snapshot.py
cd formalization
python scripts/generate_self_contained.py --check
lake build --wfail
lake env lean -DwarningAsError=true Erdos593/AxiomAudit.lean
lake env lean -DwarningAsError=true Erdos593SelfContained.lean
```

The hash checker is read-only and does not install dependencies or run Lean.
The build commands are documented reproduction instructions, not an automatic
local build. Users should choose resource limits appropriate to their machine.

A source-preserving repository merge needs source/hash/generator reconciliation,
not repetition of the accepted proof jobs. GitHub CI status is not substituted for
the recorded kernel evidence. Synchronization commits use `[skip ci]` to avoid
unrequested duplicate compute; no required branch protection is bypassed.

## Boundaries

The unrestricted classical converse is included in this 232-module snapshot. The
complete expanded paper, later boundary/profile results and independent external
audit remain incomplete. Manuscript, bibliography and attribution files are not
replaced by this synchronization. No proof-site upload is included.
