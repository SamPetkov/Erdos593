# Accepted supported-cover and actual-piece-deficit checkpoint

Source-delivery preparation: 3 October 2026. This note identifies the accepted
source and validation evidence, not remote repository delivery or whole-paper
completion. Actual pushes, reviewed merges and fetched merged-blob comparisons
are recorded separately. This preparation template is rendered only after actual
canonical and final acceptance gates pass.

## Frozen source

- Source: `51c7fa59619f88dacc010a934fda1fde441655b8`.
- Tree: `d77845a4c2cf84757e6f1a800cf2cc40fc184fe6`.
- Package SHA-256:
  `3689efc61c26a537eef87af475f82a4b353245e01f514d3e0bca9478da4238aa`.
- Source archive SHA-256:
  `e98bb9fd08cb9fd81573f1b18e01720023221607537f3f33d66453e4133538bb`.
- Source manifest SHA-256:
  `7dbb8996abd260727157a2d7d64b1f21f61d2600007a70d07bb82af569a1895a`.
- Standalone SHA-256:
  `42b8955cc2ba5ffe5aaf32fa7ff111d04096bf0f485271ac9ba6e9a4b19304c9`.
- Acceptance-record SHA-256: `21ae71b360bf270915064398bc5b7044266e0d31ce57726dac32d36c90eb47bd`.

The source contains 258 files / 3,533,550 bytes; 250 internal modules,
70 external imports, 42,090 standalone lines and 401 ordered permanent audits.
The seven changed source paths are the unchanged four focused-accepted modules,
the root imports, the audit imports plus 18 ordered entries, and the generated
standalone. All 251 other accepted source files are byte-fixed.

| Module | Exact source SHA-256 |
|---|---|
| `Erdos593/Order/FiniteSetoidCover.lean` | `a846435a3630649ff0a8333c3ef44693a560fd2058c80192076a901d77a18e0f` |
| `Erdos593/TripleSystem/SupportedDecompositionCovers.lean` | `1140d7c1a8ee9e8a01c5dd069ab99ed41bff27bde85ac2a9e52ce8e5c9875b24` |
| `Erdos593/TripleSystem/SupportedPieceDeficitAccounting.lean` | `a3045888c87bcf16166a1cb9ee6fce846faab2c4a15ae81eaea92f4ba0fb7839` |
| `Erdos593/TripleSystem/SupportedDecompositionGrading.lean` | `50e6ad4dc827ad5520d3e258187ecc5bc37ad3c74ccfb8104e4b8329feca5263` |

## Validation and actual evidence

The preserved joint focused acceptance
`fc28dec6751635ed6ea3f53ac32eb549b3c4b4bb71a6638bb59877d9090497f8`
reviews 18 actual complete theorem types, one complete deficit definition and
18 ordered standard-only axiom lists. Failed clipped-output run 66540 and
successful Probe-only recovery 66546 retain their actual originals; successful
proof artifacts were not redundantly rebuilt. Focused attempts: 2 of 2 spent.

Canonical 66570 and its batch completed `0:0` in 26:47. Explicit serial direct
Lean compilation covered all 250 root modules, the separate audit and the
standalone; it was not a Lake build and used no old project-artifact seed.
All 256 child stages returned zero with warnings fatal; all 250 module logs
and the standalone diagnostic log are byte-empty. The 251 fresh artifact hashes
and their creation chain, 518 actual originals and all 1,030 wrapper lines were
reconciled. The root stage took 1,358.565 seconds under its shared 1,380-second
bound; standalone compilation took 234.483 seconds under its 600-second bound.

All 401 actual ordered audit records have no remainder, duplication or clipping.
They use only standard axioms or subsets. The final 18 raw records are exactly
the same as the preserved focused records. Lean 4.32.0/compiler
`8c9756b28d64dab099da31a4c09229a9e6a2ef35`, Mathlib
`81a5d257c8e410db227a6665ed08f64fea08e997` and all nine clean pins were checked.
Deterministic regeneration before and after the build reproduces the fixed
standalone bytes.

Canonical report SHA-256:
`953d031322d07d2e126be78b13b00e05e510fbbb7a6713ee2e2ff8b3145e5c54`.
Actual-original archive SHA-256:
`5dd39953cd0426ffc78b4d25634623e9f93fef2443f15695cf945aeb81188957`.
Archive receipt SHA-256:
`1cbcc4b6c3c0c096cef9dd4f1dfb6d80b2445fa5098c1b76337f5ca6ff67345c`.

Separate final run 66573 passed live source/pins/link/tools/artifacts/
originals/exit reconciliation with actual child, wrapper and terminal accounting
all reviewed. It was source-only and invoked no Lean or version command.
Final child SHA-256: `f9e248c2f132e757d99db2ca5eaa48f655c7886df778862ade9980143b49689b`.
Final wrapper SHA-256: `592c0ad96d6225ed248372a8be1b68d9e0757b626c549477bd36f99ce222c758`.
Final accounting-record SHA-256: `cf46e54e0e0afdcabd5dc6806a8d5929af5a603f32374b15540976ee319e0659`.
Canonical attempt: 1 of 1 spent. Final attempt: 1 of 1 spent. Delivery does not
rerun either accepted gate.

## Exact mathematical scope

The generic finite-setoid result proves that a cover coarsens by one quotient
class, using an independent constructive one-class merge. Project covers are
transported through the already accepted order isomorphism of the supported
partition subtype. Exactly one actual shared-point coordinate changes, and its
factor undergoes a cover; all other factors are equal. The obligatory wrapper
derives intrinsicity rather than assuming it separately.

Actual piece deficit equals the sum of local quotient deficits. Both actual
canonical atom labels and actual original-edge quotient blocks are used; every
natural subtraction has a proved bound. Under strict comparability, a cover is
equivalent to one-unit loss of piece count and one-unit gain of deficit. These
statements retain empty, isolated and disconnected cases and do not strengthen
the general finite intrinsic hypotheses with reducedness or connectedness.

No maximal-chain, flag, exact-height, fixed-atom realization, sorted-theta,
all-maximal-block-order or whole-manuscript theorem is certified by this packet.
The immutable candidate comments are historical provenance, not current status.
Root adoption is **independent=false**; real supplemental reviews are retained,
but the full external audit remains pending.

## Public/private delivery boundary

The narrowly scoped export contains seven accepted source paths, four shared
status/checker paths and eleven public-safe evidence paths. The evidence is
source/root manifests and summary, compiler/audit/regeneration/standalone logs,
checksums and byte-preserving attributes. Prior evidence stays byte-identical.

Private coordination, raw report/stage/wrapper/final logs, machine paths,
credentials, package/artifact archives, unaccepted candidate sources, manuscript,
bibliography, attribution, workflows, dependencies and clocks are excluded.
The public hash checker verifies bytes and evidence structure, not proof
elaboration, GitHub delivery or publication readiness.

See [status](CURRENT_FORMALIZATION_STATUS.md),
[crosswalk](MANUSCRIPT_LEAN_CROSSWALK.md) and
[preceding piece validation](FORMALIZATION_VALIDATION_PIECE_ACCOUNTING_2026-10-02.md).
