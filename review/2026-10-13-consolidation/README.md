# Consolidating the research record — 13 October 2026

The author requested a review of the PR stack, consolidation of the current paper and closure of older drafts. This packet records the scope before those GitHub actions; the inventory is not a fabricated merge receipt.

## Current work

- [Current author-review manuscript](../2026-10-13-readability/erdos593_obligatory_triple_systems.tex) and its [six-paragraph editorial comparison](../2026-10-13-readability/comparison.md).
- [Full ordered common-power density at rank at most two](../2026-10-11-direction-audit/rank-two-ordered-density.md) and [complete actual-source reviews](../2026-10-11-direction-audit/rank-two-ordered-density-review.json).
- [Research overview and exact remaining questions](../2026-10-11-direction-audit/README.md).

The rank-at-most-two result is analytical, not an arbitrary-rank theorem, accepted Lean export or novelty clearance. The full entropy/density programme and several manuscript formal interfaces remain open. The current manuscript is source-reviewed; the built-in compiler failed while preparing its preview, so it is not accompanied by a newly verified PDF.

## Review and acceptance criteria

The fresh inventory contains 39 open public PRs. PRs #53–64 form a linear 12-PR stack. Every earlier head in the #53–64 stack is an ancestor of the reviewed tip. Before this pass's new documentation, all 461 cumulative main-to-tip changed paths were under `review/`: the accepted Lean tree, repository-root manuscript, provenance and workflows were unchanged. Candidate Lean files in the research packet remain explicitly segregated and unaccepted.

The intended consolidation is one ordinary merge of the updated tip, preserving its ancestry, plus a README entry that puts the current author-review draft first. Check the exact head, root/protected-path fidelity, review metadata and final merged blobs; do not infer mathematical acceptance from a GitHub merge or from historical CI. No expensive Lean, optimizer, compiler-service or literature campaign is part of this administrative consolidation.

The root and real separate-agent reviews confirm source/package scope. PR #53 has two successful historical checks; PRs #54–64 have no reported checks, which is neither a pass nor a failure. This documentation/research merge must not be advertised as fresh CI or whole-paper verification.

## Legacy drafts

The [exact pre-consolidation inventory](preconsolidation-inventory.json) preserves every PR URL, title, branch and full head SHA. The 27 legacy PRs are divergent; some have unique side-paper, proof, provenance or workflow content that is absent from current main and the current research stack. PR #28 also has historical failed verification jobs. These drafts are to be closed as **archived/deferred**, not declared merged, proved, superseded in every detail or transferred wholesale into the current paper.

All remote branches and PR references are retained. No source, evidence, accepted snapshot, frozen package, local checkout or dependency cache is deleted. In particular, PR #33 is a divergent sibling, not automatically preserved by PR #44. Recover any deferred work from its own recorded head, not by assuming the newest historical branch contains everything.

Closing PRs reduces interface clutter, not local disk use. The separate read-only disk audit found dependency build caches to be the main local contributor; reclaiming those requires an exact recovery-aware cleanup decision. No cleanup permission is inferred from this PR consolidation.

The final GitHub state and merged-source reconciliation must be recorded after the actions actually succeed, in [PR #64](https://github.com/SamPetkov/Erdos593/pull/64) and the closing records of the archived PRs. No branch deletion, force-push, direct main push, administrator bypass, private-repository copying or monitor restart is authorized by this plan.
