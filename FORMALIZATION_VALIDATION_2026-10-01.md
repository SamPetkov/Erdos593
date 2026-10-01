# Validation of the synchronized 1 October 2026 proof snapshot

This source-preserving delivery adds the accepted `CanonicalAtomDeficit.lean`
module, its root import and permanent audit entry, and the deterministic standalone.
All other 238 accepted source files and all dependency pins remain unchanged.
The explicit allowlist excludes private coordination records, operational
wrappers, machine paths, credentials, unreviewed candidates and manuscript edits.

## Evidence

Focused run 66475 compiled the unchanged theorem and its full-type/axiom probe
warning-fatal on pinned Lean 4.32.0. Canonical run 66476 completed with scheduler
and batch exit 0 in 19m27s: 3,365 warning-fatal all-root jobs, 330 exact ordered
standard-only axiom records, and deterministic standalone regeneration/replay.
The standalone contains 234 modules, 62 external imports and 39,659 lines.

Final source-only reconciliation 66477 completed with child, batch and scheduler
exit 0 in one second. It compared all 242 live source files (3,325,820 bytes),
the source archive and manifest, nine clean pinned dependencies, the actual
dependency link, eight original logs and two executed tools. It did not run Lean.
Original evidence and process exits were reviewed by Codex and a separate agent.
The author-authorized acceptance is Codex self-review, not an external audit.

Accepted source checkpoint: `554159ba63c61ff4fc36d23a2ab5daf3ab5dc55a`.
The publicly reproducible identity is the source manifest at
`validation/2026-10-01-atom-deficit/source-manifest.json`, not access to that
private Git commit. Six public-safe stdout logs are unedited actual originals;
the empty standalone log was actually retrieved. Operational wrappers remain private.

## Commands

With the pinned toolchain and matching dependencies already available:

```sh
python scripts/check_verified_snapshot.py
cd formalization
python scripts/generate_self_contained.py --check
lake build --wfail
lake env lean -DwarningAsError=true Erdos593/AxiomAudit.lean
lake env lean -DwarningAsError=true Erdos593SelfContained.lean
```

The hash checker is read-only; it neither installs dependencies nor runs Lean.
These build commands document reproduction, not an automatic local build.
Choose resource bounds appropriate to the machine. Source-preserving delivery
uses hash and generator reconciliation, without repeating accepted proof jobs.
Commits use `[skip ci]` to avoid unsolicited duplicate computation; branch
protections are not bypassed and CI status does not replace recorded Lean evidence.

## Mathematical scope

For a finite linear system with the bridge and even-Berge-cycle properties,
connected Levi graph and positive actual cycle rank, the additive deficit
equation gives exact accounting over actual canonical atoms. If `p` is the
positive-rank atom set and `slack` is excess over the core-order lower bound,
the result includes `p.card + sum slack <= d + 1` and `1 <= p.card`.
The frozen full declaration defines every quantity; no assembly-list count,
profile-realization premise or new extremality assumption is substituted.

The original classification and previously synchronized classical-block results
remain accepted. All-maximal-block running order, genuine graded/profile/capacity
realization, remaining atomic/theta endpoints, the separate uniqueness integration,
the exhaustive manuscript crosswalk and external audit remain open. This delivery
does not replace the manuscript, bibliography or attribution, claim novelty or
whole-paper verification, or upload anything to a proof site.
