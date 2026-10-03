# Erdős 593 formalization status

Source-delivery preparation: 3 October 2026. This document certifies the accepted
source packet selected below, not completion of the extended manuscript or
publication readiness. Push, merge and post-merge byte readback are separate.

Final live reconciliation: **passed**. Frozen four-module cover/deficit/grading
source `51c7fa59619f88dacc010a934fda1fde441655b8` passed canonical run 66570 and
separately authorized source-only final run 66573. Acceptance-record
SHA-256: `21ae71b360bf270915064398bc5b7044266e0d31ce57726dac32d36c90eb47bd`. Repository synchronization is not inferred
from proof acceptance or from this status document.

## Accepted modular and standalone checkpoint

The accepted source manifest contains **258 files / 3,533,550 bytes**. The root
closure contains **250 internal modules**, 70 external imports, 42,090 standalone
lines and **401 ordered permanent audit declarations**.

- Lean 4.32.0, compiler commit `8c9756b28d64dab099da31a4c09229a9e6a2ef35`;
  Mathlib `81a5d257c8e410db227a6665ed08f64fea08e997`, all nine pins fixed and clean.
- Canonical 66570 compiled all 250 root modules sequentially, followed by the
  separate permanent audit and the standalone file. Warnings were fatal;
  compilation used one awaited direct Lean child and no old project-artifact seed.
  This was **not a Lake build**.
- All 256 actual child stages returned zero; 251 fresh project artifacts were
  produced. All 518 actual canonical originals were retained and reconciled.
  Job and batch accounting were `COMPLETED`, exit `0:0`, elapsed 26:47.
- All 401 actual audit records match the permanent declarations in order with
  no parser remainder, duplication or clipping. Axiom lists contain only
  `propext`, `Classical.choice`, `Quot.sound`, or subsets.
- Deterministic standalone regeneration and warning-fatal standalone replay
  passed. Standalone SHA-256:
  `42b8955cc2ba5ffe5aaf32fa7ff111d04096bf0f485271ac9ba6e9a4b19304c9`.
- Final run 66573 reconciled the live source/archive/manifest, nine clean
  pins, actual dependency link, all 251 artifacts, executed tools, all 518
  canonical originals and recorded child/wrapper/accounting exits. It invoked
  **no Lean or version command**. Actual final originals are retained privately.

## Mathematical coverage

The preceding 246-module/383-audit checkpoint remains accepted. It includes the
original finite classification; canonical atom reconstruction and canonicity;
finite parameter, cycle-rank and connected atom-count spectra; original-edge
decomposition/product/lattice interfaces; unrestricted classical supported-block
characterization; conditional unique original-edge canonical labels; connected
positive-rank deficit accounting; original-carrier atomic cycle/theta boundaries;
the abstract capacity-two incidence-profile forest; and exact actual supported-piece
counting with genuine component/local-quotient transports.

The present four-module addition establishes covers and actual-piece deficit in
the **supported partition subtype**, using the accepted product order isomorphism.
An upward step coarsens the original-edge partition. A supported cover changes
exactly one actual shared-point factor by one quotient-class merger; all other
factors stay fixed. Conversely, a strict comparable pair is a cover exactly when
its actual piece count drops by one, equivalently when its actual piece deficit
increases by one. The changed original shared-point coordinate is unique.

For a finite intrinsic triple system, the deficit is actual canonical atom count
minus actual original-edge piece count. It equals the sum of local quotient
deficits, and pieces plus deficit equals atoms. The local bounds justify every
natural subtraction. The general supported statements add neither reducedness,
global connectedness nor nonempty-edge assumptions; the separate obligatory
wrapper derives intrinsicity. Empty, isolated and disconnected cases are retained.

The immutable proof headers still contain historical candidate language. Their
unchanged bytes were subsequently validated by the preserved focused and canonical
evidence and the separate final source check; delivery does not edit proof bytes.

## Still pending

The four-module cover/increment result is not by itself an equal-maximal-chain
length, maximal-flag or exact-height endpoint. Fixed-atom distinct-port geometry,
intrinsic assembly and capacity-safe profile realization with actual canonical
labels remain separate. Retained all-maximal-block running order, sorted theta
normalization, separate retained 048 integration and the exhaustive manuscript/release
crosswalk are not certified by this source packet. No pending candidate is exported.

Root adoption is **independent=false** under the author's self-review authorization.
Actual supplemental reviews are identified in retained evidence; no independent
external reviewer or complete audit is fabricated. The full external audit remains
pending. Manuscript review, repository delivery and publication remain separate.

Final child SHA-256: `f9e248c2f132e757d99db2ca5eaa48f655c7886df778862ade9980143b49689b`.
Final wrapper SHA-256: `592c0ad96d6225ed248372a8be1b68d9e0757b626c549477bd36f99ce222c758`.
Final accounting-record SHA-256: `cf46e54e0e0afdcabd5dc6806a8d5929af5a603f32374b15540976ee319e0659`.
These identify privately preserved originals, not public exports of their contents.

See [validation](FORMALIZATION_VALIDATION_COVERS_GRADING_2026-10-03.md),
[crosswalk](MANUSCRIPT_LEAN_CROSSWALK.md) and
[preceding piece validation](FORMALIZATION_VALIDATION_PIECE_ACCOUNTING_2026-10-02.md).
The read-only `python scripts/check_verified_snapshot.py` checks source/evidence
hashes and structure; it neither elaborates proofs nor establishes GitHub state.
