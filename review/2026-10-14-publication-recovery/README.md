# Current draft preview and integration audit — 14 October 2026

The current author-review draft previously had no verified PDF because the app
preview preparer failed with a Windows UTF-8 path error. The existing local
MiKTeX installation compiled the exact reviewed source successfully. The
[59-page PDF](erdos593_author_review.pdf) makes that draft readable without
changing its mathematics or replacing the historical classification release.

## Source and build

- Source: [13 October author-review manuscript](../2026-10-13-readability/erdos593_obligatory_triple_systems.tex).
- Source SHA256: `78e12f0ee68e4dd340a9d6771a47893ed37b2797f34f675af9a3232122e2eab1`.
- PDF SHA256: `2ad8f57f509df90e1ed375f17870c082b700632444671780acaa858d7c3593f3`.
- Engine: pdfTeX 1.40.29, MiKTeX 26.2; three successful passes, shell escape
  disabled and automatic package installation disabled.
- Final log: no unresolved references/citations, no requested rerun and no
  overfull/underfull boxes. The sole warning reports disabled shell escape in
  epstopdf; no EPS conversion is used by this source.
- All 59 pages were rendered and inspected in five contact sheets. The title,
  open-problem page, two-level proof page and final bibliography page were also
  inspected individually. All pages have extractable text; fonts are checked
  in the [build receipt](build-verification.json).

The source is standalone and embeds its bibliography. A local reproduction is
three `pdflatex -no-shell-escape -interaction=nonstopmode -halt-on-error` passes
from the source directory, with an existing LaTeX installation and a separate
output directory. A different engine/version or PDF timestamp can change the
PDF bytes; the source hash is the stable manuscript identity.

## GitHub scope

Before this preview update, public `main` was
`1f78ebcf1adbfca7771e8fb5875dca88bbf211fd`. Its tree
`84ea1f463111986a11e0f08746bfebf2d6d44cc0` exactly matched the reviewed PR #67
head. The [dated PR inventory](pr-inventory.json) contains 63 PRs: 20 merged,
43 closed, and zero open. The active research stack #53–64 and additions
#65–67 are integrated. The three final-head checks for #67 succeeded.

Closed legacy drafts were archived/deferred rather than universally integrated;
the [consolidation record](../2026-10-13-consolidation/README.md) and its frozen
inventory preserve their disposition. Some contain distinct side-paper or proof
work, so closure must not be represented as merger of every historical change.
All branches remain available. The unrelated draft PR in `SamPetkov/Erdos` is
outside this `SamPetkov/Erdos593` publication audit.

## What remains before an extended publication claim

| Item | Evidence and status |
| --- | --- |
| Original finite classification | Accepted Lean endpoints and preserved formalization evidence; the snapshot integrity checker passed on 258 files, 250 modules and 401 ordered standard-only audits. This pass did not rerun Lean. |
| Current author-review manuscript preview | Built and rendered successfully from the exact reviewed source; this does not certify every mathematical claim. |
| Recent conditional density results | Rank-at-most-two, compatible-block, two-level and cubic-orthogonal results are in the research supplement with their precise hypotheses; not an unrestricted theorem or new accepted Lean implementation. |
| Unrestricted ordered common-power density | Still open in Problem 11.7 of this PDF. The latest local reciprocal/collision continuation has not been promoted to a complete proof. |
| Uniformity audit issues #20 and #25 | Still open. Their explicit independent-review requirements have not been discharged by this repository/preview audit. |
| Novelty, complete manuscript crosswalk and external review | Not certified by this preview build or by a GitHub merge. |

The author authorized one new GPT-6 Pro consultation on the latest exact density
gap. Its response requires a separate mathematical audit before any theorem
closure or manuscript change. Compilation, repository integration, analytical
proof, Lean acceptance and publication approval are separate claims.
