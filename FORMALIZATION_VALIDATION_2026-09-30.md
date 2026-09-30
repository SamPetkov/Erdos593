# Validation of the synchronized 30 September 2026 proof snapshot

This source-only synchronization changes no theorem body, statement or dependency
pin from the accepted classical-label integration. It brings the verified modular
sources and generated standalone into both repositories using an explicit file
allowlist. Private coordination records, service credentials, machine paths,
unreviewed candidate proofs and unrelated research are not exported.

## Evidence

Canonical run 66460 completed with scheduler and batch exit 0 in 18m49s:
3,364 warning-fatal all-root jobs, 329 ordered standard-only axiom records and
deterministic standalone regeneration/replay. Final source-only reconciliation
66465 completed with child, batch and scheduler exit 0 in one second. It checked
the actual live source, nine clean dependency pins, dependency link, original logs,
executed tools and real process exits. It did not rerun Lean.

Accepted source checkpoint: `d97bbf0b15160853262985ebb19929541d2dc3e8`.
Publicly reproducible identity is given by every SHA-256 entry in
`validation/2026-09-30-classical-labels/source-manifest.json`, not by access to a private
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

The unrestricted classical converse and conditional unique canonical-label
identification are included in this 233-module snapshot. The latter assumes
`Intrinsic F`; it does not weaken the former or prove core-isomorphism uniqueness. The
complete expanded paper, later boundary/profile results and independent external
audit remain incomplete. Manuscript, bibliography and attribution files are not
replaced by this synchronization. No proof-site upload is included.
