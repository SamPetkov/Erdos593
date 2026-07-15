# Aristotle provenance log

## G1: private endpoint implies bridge

- Submitted (UTC): 2026-07-14 22:50
- Aristotle CLI: `aristotlelib 2.1.0`
- Aristotle project: `92385af1-34ca-4ad3-aee1-4f6ae2cabfa8`
- Aristotle task: `3a93fca3-3618-4f8b-a128-7f99279c805c`
- Initial status: `QUEUED`
- Prompt: `Follow TASK.md exactly and do not exceed its stated scope.`
- Scope: prove only `isBridge_of_adj_of_unique_neighbor` in
  `Erdos593/Graph/Bridge.lean`.
- Submitted directory: a fresh staging directory outside the Git worktree.
- Submitted files: `Erdos593.lean`, `Erdos593/Graph/Bridge.lean`,
  `lakefile.toml`, `lean-toolchain`, and `TASK.md` (2,036 bytes total).
- Sensitive-pattern scan: clear.
- Toolchain: Lean and mathlib `v4.32.0`.
- Service warning: Aristotle reported that it works best with Lean `v4.28.0`
  and that the staged directory had no `.lake` dependency directory.
- Returned archive SHA-256:
  `DD6FF956BDB02D1FE4FC1370D0916007B96A0BBDEE47F064558A3E37EC8246B0`.
- Archive path audit: eight relative paths; no absolute or parent-traversal path.
- Remote diff: only the marked proof changed among submitted source files.
- Compatibility repair: Aristotle resolved the project with mathlib `v4.28.0`,
  whose `IsBridge` definition includes edge membership.  In canonical `v4.32.0`,
  `IsBridge` is only endpoint non-reachability.  The proof was therefore adapted
  without changing the theorem statement: the obsolete adjacency conjunct was
  removed and `deleteEdges_adj` replaced the old set-difference adjacency API.
- Canonical verification: `lake build Erdos593.Graph.Bridge` succeeded; the
  source gap scan was clear; `#print axioms` reported exactly `propext`,
  `Classical.choice`, and `Quot.sound`.
- Accepted canonical file SHA-256:
  `2D2576A0B6C7C478F87C90AADDB48E04197A757FFE3232F3812B3E4D46014E2A`.
- Disposition: accepted after the documented Lean 4.32 API repair.

Staged SHA-256 values:

```text
EB87F56A53425749F578382A57E1CD1D340117DF93B1A71C8A67A899578F4537  Erdos593.lean
74031B114598CA6D8EF12F3C0D585ADA96B8AC31C4620814A0038813D42ED9CE  Erdos593/Graph/Bridge.lean
331CC56C040B395D5DD5C57988C96B90B2F9AE688687FDBD096C9AA9A5CEF416  lakefile.toml
2773C517AA90B66EA8A2C52BDDDDF84393157797F8341BE0DF45294FFF7FD32E  lean-toolchain
632B5B6DEAFDD963E206A96AFFB2D1CB868200CFDA9E2ABD1A7A34E7B0026472  TASK.md
```

## B1: linearity as pairwise subsingleton intersection

- Submitted (UTC): 2026-07-14 23:08
- Aristotle CLI: `aristotlelib 2.1.0`
- Aristotle project: `5eeb422f-64d0-4a8a-906d-25de15d88507`
- Aristotle task: `cb9bd46f-e885-4bb2-aceb-b38fd1834588`
- Initial status: `IN_PROGRESS`
- Prompt: `Follow TASK.md exactly and do not exceed its stated scope.`
- Scope: prove only `linear_iff_pairwise_inter_subsingleton` in
  `Erdos593/TripleSystem/Basic.lean`.
- Submitted directory: an independently built Lean/mathlib `v4.28.0` staging
  directory outside the Git worktree.
- Upload preview: six files, 6,191 bytes, with the SDK's own ignore rules.
- Sensitive-pattern scan: clear.
- Canonical acceptance condition: the returned proof must also compile without
  changes under the repository's Lean/mathlib `v4.32.0` project.
- Returned archive SHA-256:
  `A6978D5CCD13E70E8A96A0493919456B04ED30EE81DEDB5A7A9DC4656386ABFB`.
- Archive path audit: eight relative paths; no absolute or parent-traversal path.
- Remote diff: only the marked proof changed among submitted source files.
- Version portability: the proof body was transplanted unchanged from 4.28 to
  the canonical 4.32 declaration.
- Canonical verification: `lake build Erdos593.TripleSystem.Basic` succeeded;
  the source gap scan was clear; `#print axioms` reported exactly `propext`,
  `Classical.choice`, and `Quot.sound`.
- Accepted canonical file SHA-256:
  `69F255A9B613D90E7173F15B1499875AB374653FBA971265E47EE9E0318AED11`.
- Disposition: accepted unchanged.

Staged SHA-256 values:

```text
3045DE26EFF90B549755C4B05BC615C96E0B3422469CE64950DAED59E8531A4A  Erdos593/TripleSystem/Basic.lean
DD82F373ABBE0DBAB2CA28B6DF3BE3D2534911AFD7EB4CFB65B77D2C2BF39C45  Erdos593.lean
FF4F3A82C7E128849DCA9AA705AEC93CB139B78F4E3770AB7AB77C1A45A014D5  lake-manifest.json
06792D5734F93FCA761248F3E61894517838966003385E4C8267CAA0F09D8AAA  lakefile.toml
DB7BB24B756D745BBDE83FE92718B51BD3625DAE3701BA0F598D0EEDCD3F3028  lean-toolchain
9A0E36F2B668B715E63706968A79796EBABC4A42A80537BC3B551AA85417C7A3  TASK.md
```

## G5: two-colourability from simple-cycle parity

- Submitted (UTC): 2026-07-14 23:25
- Aristotle CLI: `aristotlelib 2.1.0`
- Aristotle project: `75d077dd-965a-49fa-b231-8556386f7152`
- Aristotle task: `2528cf41-231f-4b1f-99d6-bafb706cd82c`
- Initial status: `QUEUED`
- Prompt: `Follow TASK.md exactly and do not exceed its stated scope.`
- Scope: prove only `two_colorable_iff_every_cycle_even` in
  `Erdos593/Graph/Parity.lean`.
- Submitted directory: a minimal Lean/mathlib `v4.28.0` staging directory
  outside the Git worktree.
- Version adaptation: the staging file imports the 4.28 module
  `SimpleGraph.ConcreteColorings`; the canonical 4.32 declaration imports
  `SimpleGraph.Coloring.Constructions`.  The theorem statement is identical,
  and only the proof body may be transplanted.
- Upload preview: six files, 4,676 bytes, with the SDK's own ignore rules.
- Sensitive-pattern scan: clear.
- Canonical acceptance condition: the returned proof must compile under the
  repository's Lean/mathlib `v4.32.0` project without changing the statement.
- Independent fallback: while the remote task remained in progress, a separate
  strong-induction proof was developed and checked locally. It splits every
  non-cycle closed walk at a nonempty closed subwalk of its tail and applies the
  induction hypothesis to the two strictly shorter closed walks.
- Canonical verification of fallback: `lake build Erdos593.Graph.Parity
  Erdos593` succeeded; `#print axioms` reported exactly `propext`,
  `Classical.choice`, and `Quot.sound`.
- Accepted canonical file SHA-256:
  `2146915B6213E1949A659F4A7C18245A534A271F8C0DCD371C708386C5E40995`.
- Remote status at local acceptance: still `IN_PROGRESS` at 18 percent after
  about one hour. The remote result is retained only for adversarial comparison
  and is no longer on the canonical proof's critical path.
- Disposition: canonical fallback accepted; Aristotle comparison pending.

Staged SHA-256 values:

```text
45DA9F10EAED5E7CBFE9AF7F28A85B58788343329B0611B9E083BAD57150C283  Erdos593/Graph/Parity.lean
DE7CDC2D2E77E42FBEE27DA70206214570EE030B4FD9E1AE64AF21E7F54829E8  Erdos593.lean
FF4F3A82C7E128849DCA9AA705AEC93CB139B78F4E3770AB7AB77C1A45A014D5  lake-manifest.json
06792D5734F93FCA761248F3E61894517838966003385E4C8267CAA0F09D8AAA  lakefile.toml
DB7BB24B756D745BBDE83FE92718B51BD3625DAE3701BA0F598D0EEDCD3F3028  lean-toolchain
0AFE0DE258CD7FE221338AD950BD05FC6888C0476D99719B3957A6B7B1C2D92B  TASK.md
```

## B2: Levi hyperedge-node degree

- Submitted (UTC): 2026-07-14 23:45
- Aristotle CLI: `aristotlelib 2.1.0`
- Aristotle project: `29042932-d0cf-4b82-9108-805d1e360181`
- Aristotle task: `73b4dcef-20f5-4b67-8455-d2f7e41570ae`
- Initial status: `QUEUED`
- Prompt: `Follow TASK.md exactly and do not exceed its stated scope.`
- Scope: prove only `levi_edge_neighbor_ncard` in
  `Erdos593/TripleSystem/Levi.lean`.
- Submitted directory: a minimal Lean/mathlib `v4.28.0` staging directory
  outside the Git worktree.
- Upload preview: seven files, 7,804 bytes, with the SDK's own ignore rules.
- Sensitive-pattern scan: clear.
- Canonical acceptance condition: the returned proof must compile under the
  repository's Lean/mathlib `v4.32.0` project without changing the statement.
- Returned archive SHA-256:
  `9BD98DD710F7653DD9596CAE0CD3A8B9C55725F87C257DA83FC1C8A01AD8FE82`.
- Archive path audit: nine relative paths; no absolute or parent-traversal path.
- Remote diff: only the marked proof changed among submitted Lean source files.
- Version portability: the proof body was transplanted unchanged from 4.28 to
  the canonical 4.32 declaration.
- Canonical verification: `lake build Erdos593.TripleSystem.Levi` succeeded;
  the source gap scan was clear; `#print axioms` reported exactly `propext`,
  `Classical.choice`, and `Quot.sound`.
- Accepted canonical file SHA-256:
  `A666B40F90C05232F5CE5E80148ADFBAF3583E70157254CFD0E198CEE3E1DD7B`.
- Disposition: accepted unchanged.

Staged SHA-256 values:

```text
69F255A9B613D90E7173F15B1499875AB374653FBA971265E47EE9E0318AED11  Erdos593/TripleSystem/Basic.lean
A72EA2B07B3AD27DDCD65A6D03287969217F190269B871A26BA213335A96F332  Erdos593/TripleSystem/Levi.lean
8FB6E53723A40B76D8444DE26D1A525396E19565D30AE27F819507AD6099BAB2  Erdos593.lean
FF4F3A82C7E128849DCA9AA705AEC93CB139B78F4E3770AB7AB77C1A45A014D5  lake-manifest.json
06792D5734F93FCA761248F3E61894517838966003385E4C8267CAA0F09D8AAA  lakefile.toml
DB7BB24B756D745BBDE83FE92718B51BD3625DAE3701BA0F598D0EEDCD3F3028  lean-toolchain
30C6A9EFC11607C1E182AB6EF63AE5B8B28DA4D81ACBAE85633DF9640B81D22E  TASK.md
```

## F1: linearity of a private-vertex expansion

- Submitted (UTC): 2026-07-15 00:24
- Aristotle CLI: `aristotlelib 2.1.0`
- Aristotle project: `19530016-3fe7-421c-911c-5ed142394479`
- Aristotle task: `84fa32f0-1c8a-4088-b32f-b4c2cca6e5a0`
- Initial status: `QUEUED`; first poll: `IN_PROGRESS`.
- Prompt: `Follow TASK.md exactly and do not exceed its stated scope.`
- Scope: prove only `privateVertexExpansion_linear` in
  `Erdos593/TripleSystem/ForwardExpansion.lean`.
- Submitted directory: a clean copy of an independently built Lean/mathlib
  `v4.28.0` staging directory outside the Git worktree; `.lake` was excluded
  from the upload.
- Upload manifest: eight files, 10,803 bytes.
- Sensitive-pattern scan: clear.
- Canonical acceptance condition: the returned proof must compile under the
  repository's Lean/mathlib `v4.32.0` project without changing the statement.
- Returned archive SHA-256:
  `AFBF745E1FB23E819E2A126A217BE2735DF32B2F0F042946DBB897C32AC5E03D`.
- Archive path audit: ten relative paths; no absolute or parent-traversal path.
- Remote diff: only the marked proof changed among submitted Lean source files.
- Compatibility repair: the remote proof compiled under canonical 4.32 but
  triggered the `unnecessarySeqFocus` linter. The same generated tactics were
  regrouped with `all_goals`, without changing the theorem statement or proof
  argument, to remove the warning.
- Canonical verification: `lake build
  Erdos593.TripleSystem.ForwardExpansion` succeeded without warnings; the source
  gap scan was clear; `#print axioms` reported exactly `propext`,
  `Classical.choice`, and `Quot.sound`.
- Accepted canonical file SHA-256:
  `C02222248B1E8EAA67724D648695CAD2F8EAA6733A584685384EDB7DFCC433C2`.
- Disposition: accepted after the documented non-logical linter repair.

Staged SHA-256 values:

```text
B5AA0B6BE6DF20C4548B28FB1106560865B16921B9120EAB5C2008FA32554E02  Erdos593.lean
69F255A9B613D90E7173F15B1499875AB374653FBA971265E47EE9E0318AED11  Erdos593/TripleSystem/Basic.lean
8EEDB4203064487022B53CDA4FCC165CC6919C6AA325CE2E27AAEA0737685387  Erdos593/TripleSystem/Expansion.lean
EC2D6D0B90136F30AD157FCD4FBB9293546C82C3203F432B03B08C3A988D90A8  Erdos593/TripleSystem/ForwardExpansion.lean
06792D5734F93FCA761248F3E61894517838966003385E4C8267CAA0F09D8AAA  lakefile.toml
FF4F3A82C7E128849DCA9AA705AEC93CB139B78F4E3770AB7AB77C1A45A014D5  lake-manifest.json
DB7BB24B756D745BBDE83FE92718B51BD3625DAE3701BA0F598D0EEDCD3F3028  lean-toolchain
7141AE9C856742749280431531D2F0C957F0CF7FD3C8453D65415E2B1BA16F19  TASK.md
```

## F2: private-point incidence is a Levi bridge

- Submitted (UTC): 2026-07-15 00:24
- Aristotle CLI: `aristotlelib 2.1.0`
- Aristotle project: `8581047e-d81b-4fe3-81f5-021eb2b16ff7`
- Aristotle task: `8eaac532-68ae-44e7-8ef3-4e05caab9660`
- Initial status: `QUEUED`; first poll: `IN_PROGRESS`.
- Prompt: `Follow TASK.md exactly and do not exceed its stated scope.`
- Scope: prove only `privateVertexExpansion_bridgeAtEveryEdge` in
  `Erdos593/TripleSystem/ExpansionIntrinsic.lean`.
- Submitted directory: a clean copy of an independently built Lean/mathlib
  `v4.28.0` staging directory outside the Git worktree; `.lake` was excluded
  from the upload.
- Version adaptation: the staging `Bridge.lean` contains the already audited
  4.28 form of G1 because `SimpleGraph.IsBridge` changed in 4.32. Only the F2
  proof body may be transplanted into the canonical project.
- Upload manifest: eleven files, 15,198 bytes.
- Sensitive-pattern scan: clear.
- Canonical acceptance condition: the returned proof must compile under the
  repository's Lean/mathlib `v4.32.0` project without changing the statement.
- Returned archive SHA-256:
  `105A9C8748C3923536D62F60E790A563007BDA73B3BDF6B6356AB03761ED0C84`.
- Archive path audit: thirteen relative paths; no absolute or parent-traversal
  path.
- Remote diff: only the marked proof changed among submitted Lean source files.
- Version portability: the proof body was transplanted unchanged from 4.28 to
  the canonical 4.32 declaration.
- Independent comparison: a separately developed private-leaf proof had already
  compiled under 4.32; the returned proof uses the same argument more concisely.
- Canonical verification: `lake build
  Erdos593.TripleSystem.ExpansionIntrinsic` succeeded; the source gap scan was
  clear; `#print axioms` reported exactly `propext`, `Classical.choice`, and
  `Quot.sound`.
- Accepted canonical file SHA-256:
  `3BA58AAB4A728DDB3555C99DAE3338BBB444B38F5FBE9C831747DFFD20DA1F7D`.
- Disposition: accepted unchanged.

Staged SHA-256 values:

```text
7DB9073D737F8603A3AFA5FA10ABAA2CCF38295D7BB3C28B8B43D0FEEC7CB26F  Erdos593.lean
CE7311040AEA3A2ED19594CCA1F429A3746245544E8496A548556E78C9B258A1  Erdos593/Graph/Bridge.lean
69F255A9B613D90E7173F15B1499875AB374653FBA971265E47EE9E0318AED11  Erdos593/TripleSystem/Basic.lean
8EEDB4203064487022B53CDA4FCC165CC6919C6AA325CE2E27AAEA0737685387  Erdos593/TripleSystem/Expansion.lean
50D3F45BB1076F989007FA0C583646FEAB9FA8341E5BF48651A1635EBFDDCA39  Erdos593/TripleSystem/ExpansionIntrinsic.lean
764CF4D904AA0F59607E4D5BFE1EAA3710240051BE5446D6E5F6776B54C29356  Erdos593/TripleSystem/Intrinsic.lean
A666B40F90C05232F5CE5E80148ADFBAF3583E70157254CFD0E198CEE3E1DD7B  Erdos593/TripleSystem/Levi.lean
06792D5734F93FCA761248F3E61894517838966003385E4C8267CAA0F09D8AAA  lakefile.toml
FF4F3A82C7E128849DCA9AA705AEC93CB139B78F4E3770AB7AB77C1A45A014D5  lake-manifest.json
DB7BB24B756D745BBDE83FE92718B51BD3625DAE3701BA0F598D0EEDCD3F3028  lean-toolchain
C858C021E2818D5506A7ECD3E7195EBF3035A9B966AA7CC1C4719A653ABF4C9F  TASK.md
```

For every submission, record:

- UTC timestamp and Aristotle project/task identifier;
- exact prompt and submitted file set;
- returned files and local diff;
- `lake build` result;
- remaining `sorry`/`admit`/axiom audit;
- whether the result was accepted, repaired, or rejected.
