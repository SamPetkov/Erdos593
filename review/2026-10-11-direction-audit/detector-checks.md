# Bounded excerpt checks — 11 October 2026

The author authorized submitting the revised abstract and a passage from a
random section to the free detector sites used in the other prose task.
No full draft, private chat, credentials or proof evidence was uploaded.
These checks assess neither mathematical correctness nor publication quality.
They do not establish authorship, and no detector guarantee is claimed.

## Source and selection

The checked revision has SHA256
`7b0dc06f31631f2c8bd73d5e24c503ee5a7579663f4f6adbc5e9a65c9fc503fe`.
Its complete abstract contains 2,145 characters and 315 whitespace-separated
words after replacing TeX spacing/math delimiters by plain-text equivalents.

Before inspecting scores, the first eight hex characters of the baseline
source SHA256 (`bee441b2`) were taken modulo the 13 ordinary section headings.
This selected section 13, **Exact marginal entropy and common-power densities**.
Within that section, the complete “removed-edge sign” prose paragraph was used
as a bounded readable excerpt: 1,324 characters, 196 words. This is not a test
of the entire appendix or a uniform random sample of every paragraph.
TeX formula delimiters were converted to plain mathematical notation and
`\citet{csikvarilin2017}` to “Csikvári and Lin (2017)”; no mathematical assertion
or citation attribution was changed in the submitted passage.

## Actual observations

| Site and input | Visible result | Measurement boundary |
| --- | --- | --- |
| Sapling, complete abstract submitted | 99.3% AI-generation score | The site explicitly checked only its first 2,000 characters. This is a prefix score, **not a complete-abstract or whole-paper score**. |
| Sapling, selected proof paragraph | 0.1% AI-generation score | Entire 1,324-character excerpt checked; no truncation warning. This does not clear other sections. |
| GPTZero, complete abstract submitted | 100% AI displayed | The result tab simultaneously said “Text changed / Scan to update” and showed “Sign up to Continue.” This display is **excluded as a verified current score** because the UI did not establish a current scan. |

The first GPTZero homepage action opened a result in a new tab without
navigating the input tab. A second action after the cookie prompt was dismissed
opened another result tab. Both displayed the same input and stale-status/
registration boundary; no further scan, signup, account, subscription or quota
workaround was attempted. The two tab openings are recorded, not concealed as
one successful measurement.

Sapling screenshots preserve both actual scores and the truncation notice:
[abstract prefix](sapling-abstract-prefix-20261011.png) and
[selected passage](sapling-random-passage-20261011.png).
The [GPTZero screenshot](gptzero-abstract-registration-20261011.png)
preserves the registration boundary. Sapling's temporary share URLs expire;
the screenshots and exact input scope are the durable evidence.

The other prose task's reported free Pangram credits were exhausted.
No new Pangram check or reset was attempted.

## Editorial decision

The academic-humanizer pass improved clarity before these measurements.
All mathematical statements, proofs, formulas, citations and attribution remain
unchanged, as recorded in [the source check](humanizer-static-qa.json) and
[complete changed-paragraph comparison](humanizer-comparison.md).
The selected proof paragraph was not rewritten for a low score.
The abstract still triggers Sapling's prefix classifier; this pass does not
claim the author's detector-related goal has been achieved. Further editorial
work should serve mathematical readers, not remove qualifications or change
claims merely to alter a proprietary score.
