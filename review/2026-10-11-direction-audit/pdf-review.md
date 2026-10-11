# Exact manuscript build and visual review

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
