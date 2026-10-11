# Exact manuscript build and visual review

## Current readability revision

Current source SHA256:
`7b0dc06f31631f2c8bd73d5e24c503ee5a7579663f4f6adbc5e9a65c9fc503fe`.
Current PDF SHA256:
`dd7301b8d5176d19db528aca551fb832861f642e07559174d7072c02a4fe035b`.
The fresh PDF has 59 pages and 738,205 bytes. Both actual serial native
compiler calls returned zero; the second final log has no unresolved
references/citations, rerun request or overfull/underfull boxes. The expected
disabled-shell warning remains. The built-in preview initialization failed
at the known Windows path boundary; it is not counted as successful.

The existing open source was edited in place, its editor left open, and the
generated PDF was copied to the public review packet. Exact source and PDF
matching passes. All mathematical/citation bodies remain unchanged against
the previous draft head; the [new checker](humanizer-static-qa.json) verifies
this editorial scope.

Pages 1–4, 44 and 46 were newly rendered and inspected at full-page scale,
covering every changed prose group, title/abstract metadata, introduction,
formalization caveat, appendix opening and adjacent proof layout. No clipping,
overlap, bad glyph or detached heading was found. This restrained pass did not
repeat the earlier all-page visual audit or a Lean build. The full historical
render review below belongs to the preceding substantive revision.

## Previous substantive revision

Final source SHA256:
`bee441b2372759dd97d29312efd26f549be9b8708eb09dec4ef7180f5c867562`.

Final PDF SHA256:
`bf3edecdecb6f4bbacc682cfda2578066a230ca6a447ab6391a27f5696163083`.

The saved document is **59 A4 pages, 738,880 bytes**, with 44 cited references
in first-citation order. The open source and public review copy have identical
bytes; the local and public review PDFs also agree. The original author/editor
document was edited in place; no replacement document or editor tab was opened.

## Actual compiler boundary

The built-in document compiler failed before TeX initialization with
`windows sandbox: path contains invalid UTF-8 characters`. This is recorded
as a platform limitation, not a successful compilation or a source error.

The existing MiKTeX pdfLaTeX runtime then compiled the saved source, with
automatic installation and shell execution disabled:

```text
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error
         -no-shell-escape -disable-installer
         erdos593_obligatory_triple_systems.tex
```

The final dedicated compiler call returned **exit zero**. Earlier successful
passes resolved the new labels; the final log contains no unresolved
references/citations, rerun request, overfull/underfull box or TeX error.
The expected `epstopdf` disabled-shell warning is retained. An ancillary
text-extraction print command had a Windows-console encoding error after its
combined invocation had already built the PDF; it is not relabeled as a
compiler error. UTF-8-safe checks and the dedicated final compiler call
subsequently returned zero.

No TeX installation, Lean compiler, proof service, scheduler job or cache/pin
change was needed. PDF typesetting is not mathematical or Lean acceptance.

## Visual checks

All 59 pages were rendered and reviewed as five contact sheets. Pages
1, 3, 4, 41–43 and 54–59 were additionally rendered and inspected at full-page
scale. Checks covered:

- the dated title, abstract, MSC/keywords placement and introduction transition;
- the quantitative overview and visible unrestricted-problem boundary;
- Proposition 11.8 across pages 41–42, including its law/zero-channel conditions;
- the formal-verification qualification and Appendix A transition;
- the weighted trace identities, spectral remainder and quadrilateral proof;
- acknowledgment/disclosure and all 44 numbered bibliography entries.

No clipped equations, overlapping text, bad glyphs, missing citation numbers
or broken section transitions were found. The proposition has an ordinary
page break, not a detached heading. Rendered QA images remain local; the
matching source/PDF and mechanical [static report](static-qa.json) are delivered
in the public review packet. No full external audit is claimed.
