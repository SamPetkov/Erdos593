# Finite parameter spectrum branch validation

- synchronization exit status: 0
- PDF and mirror verification exit status: 1
- Pandoc: pandoc 3.1.3
- TeX: pdfTeX 3.141592653-2.6-1.40.25 (TeX Live 2023/Debian)

## Synchronization log tail
```text
------------
Running 'pdflatex  -interaction=nonstopmode -halt-on-error -file-line-error -recorder  "erdos593_obligatory_triple_systems.tex"'
------------
This is pdfTeX, Version 3.141592653-2.6-1.40.25 (TeX Live 2023/Debian) (preloaded format=pdflatex)
 restricted \write18 enabled.
entering extended mode
(./erdos593_obligatory_triple_systems.tex
LaTeX2e <2023-11-01> patch level 1
L3 programming layer <2024-01-22>
(/usr/share/texlive/texmf-dist/tex/latex/amscls/amsart.cls
Document Class: amsart 2020/05/29 v2.20.6
(/usr/share/texlive/texmf-dist/tex/latex/amsmath/amsmath.sty
For additional information on amsmath, use the `?' option.
(/usr/share/texlive/texmf-dist/tex/latex/amsmath/amstext.sty
(/usr/share/texlive/texmf-dist/tex/latex/amsmath/amsgen.sty))
(/usr/share/texlive/texmf-dist/tex/latex/amsmath/amsbsy.sty)
(/usr/share/texlive/texmf-dist/tex/latex/amsmath/amsopn.sty))
(/usr/share/texlive/texmf-dist/tex/latex/amsfonts/umsa.fd)
(/usr/share/texlive/texmf-dist/tex/latex/amsfonts/amsfonts.sty))
(/usr/share/texlive/texmf-dist/tex/latex/geometry/geometry.sty
(/usr/share/texlive/texmf-dist/tex/latex/graphics/keyval.sty)
(/usr/share/texlive/texmf-dist/tex/generic/iftex/ifvtex.sty
(/usr/share/texlive/texmf-dist/tex/generic/iftex/iftex.sty)))
(/usr/share/texlive/texmf-dist/tex/latex/base/fontenc.sty)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/newtxtext.sty
`newtxtext' v1.737, 2024/01/11 Text macros taking advantage of TeXGyre Termes a
nd its extensions (msharpe)
(/usr/share/texlive/texmf-dist/tex/latex/xpatch/xpatch.sty
(/usr/share/texlive/texmf-dist/tex/latex/l3kernel/expl3.sty
(/usr/share/texlive/texmf-dist/tex/latex/l3backend/l3backend-pdftex.def))
(/usr/share/texlive/texmf-dist/tex/latex/l3packages/xparse/xparse.sty)
(/usr/share/texlive/texmf-dist/tex/latex/etoolbox/etoolbox.sty))
(/usr/share/texlive/texmf-dist/tex/latex/xcolor/xcolor.sty
(/usr/share/texlive/texmf-dist/tex/latex/graphics-cfg/color.cfg)
(/usr/share/texlive/texmf-dist/tex/latex/graphics-def/pdftex.def)
(/usr/share/texlive/texmf-dist/tex/latex/graphics/mathcolor.ltx))
(/usr/share/texlive/texmf-dist/tex/latex/xkeyval/xkeyval.sty
(/usr/share/texlive/texmf-dist/tex/generic/xkeyval/xkeyval.tex
(/usr/share/texlive/texmf-dist/tex/generic/xkeyval/xkvutils.tex)))
(/usr/share/texlive/texmf-dist/tex/latex/base/textcomp.sty)
(/usr/share/texlive/texmf-dist/tex/generic/xstring/xstring.sty
(/usr/share/texlive/texmf-dist/tex/generic/xstring/xstring.tex))
(/usr/share/texlive/texmf-dist/tex/latex/base/ifthen.sty)
(/usr/share/texlive/texmf-dist/tex/latex/carlisle/scalefnt.sty)
(/usr/share/texlive/texmf-dist/tex/generic/kastrup/binhex.tex)
(/usr/share/texlive/texmf-dist/tex/latex/fontaxes/fontaxes.sty))
(/usr/share/texlive/texmf-dist/tex/latex/newtx/newtxmath.sty
`newtxmath' v1.732, 2023/11/05 Math macros based originally on txfonts (msharpe
) (/usr/share/texlive/texmf-dist/tex/latex/oberdiek/centernot.sty)
(/usr/share/texlive/texmf-dist/tex/generic/kastrup/binhex.tex)
amsthm NOT loaded
) (/usr/share/texlive/texmf-dist/tex/latex/microtype/microtype.sty
(/usr/share/texlive/texmf-dist/tex/latex/microtype/microtype-pdftex.def)
(/usr/share/texlive/texmf-dist/tex/latex/microtype/microtype.cfg))
(/usr/share/texlive/texmf-dist/tex/latex/mathtools/mathtools.sty
(/usr/share/texlive/texmf-dist/tex/latex/tools/calc.sty)
(/usr/share/texlive/texmf-dist/tex/latex/mathtools/mhsetup.sty))
(/usr/share/texlive/texmf-dist/tex/latex/natbib/natbib.sty)
(/usr/share/texlive/texmf-dist/tex/latex/enumitem/enumitem.sty)
(/usr/share/texlive/texmf-dist/tex/latex/needspace/needspace.sty)
(/usr/share/texlive/texmf-dist/tex/latex/xurl/xurl.sty
(/usr/share/texlive/texmf-dist/tex/latex/url/url.sty))
(/usr/share/texlive/texmf-dist/tex/latex/hyperref/hyperref.sty
(/usr/share/texlive/texmf-dist/tex/latex/kvsetkeys/kvsetkeys.sty)
(/usr/share/texlive/texmf-dist/tex/generic/kvdefinekeys/kvdefinekeys.sty)
(/usr/share/texlive/texmf-dist/tex/generic/pdfescape/pdfescape.sty
(/usr/share/texlive/texmf-dist/tex/generic/ltxcmds/ltxcmds.sty)
(/usr/share/texlive/texmf-dist/tex/generic/pdftexcmds/pdftexcmds.sty
(/usr/share/texlive/texmf-dist/tex/generic/infwarerr/infwarerr.sty)))
(/usr/share/texlive/texmf-dist/tex/latex/hycolor/hycolor.sty)
(/usr/share/texlive/texmf-dist/tex/latex/auxhook/auxhook.sty)
(/usr/share/texlive/texmf-dist/tex/latex/hyperref/nameref.sty
(/usr/share/texlive/texmf-dist/tex/latex/refcount/refcount.sty)
(/usr/share/texlive/texmf-dist/tex/generic/gettitlestring/gettitlestring.sty
(/usr/share/texlive/texmf-dist/tex/latex/kvoptions/kvoptions.sty)))
(/usr/share/texlive/texmf-dist/tex/latex/hyperref/pd1enc.def)
(/usr/share/texlive/texmf-dist/tex/generic/intcalc/intcalc.sty)
(/usr/share/texlive/texmf-dist/tex/latex/hyperref/puenc.def)
(/usr/share/texlive/texmf-dist/tex/generic/stringenc/stringenc.sty)
(/usr/share/texlive/texmf-dist/tex/latex/hyperref/psdextra.def)
(/usr/share/texlive/texmf-dist/tex/generic/bitset/bitset.sty
(/usr/share/texlive/texmf-dist/tex/generic/bigintcalc/bigintcalc.sty))
(/usr/share/texlive/texmf-dist/tex/latex/base/atbegshi-ltx.sty))
(/usr/share/texlive/texmf-dist/tex/latex/hyperref/hpdftex.def
(/usr/share/texlive/texmf-dist/tex/latex/base/atveryend-ltx.sty)
(/usr/share/texlive/texmf-dist/tex/latex/rerunfilecheck/rerunfilecheck.sty
(/usr/share/texlive/texmf-dist/tex/generic/uniquecounter/uniquecounter.sty)))
(/usr/share/texlive/texmf-dist/tex/latex/bookmark/bookmark.sty
(/usr/share/texlive/texmf-dist/tex/latex/bookmark/bkm-pdftex.def))
(/usr/share/texlive/texmf-dist/tex/generic/stringenc/se-pdfdoc.def)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/t1ntxtlf.fd)
(./erdos593_obligatory_triple_systems.aux)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/omlntxmi.fd)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/untxexa.fd)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/lmsntxsy.fd)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/lmxntxexx.fd)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/ot1minntx.fd)
(/usr/share/texlive/texmf-dist/tex/latex/amsfonts/umsa.fd)
(/usr/share/texlive/texmf-dist/tex/latex/amsfonts/umsb.fd)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/untxmia.fd)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/untxsym.fd)
(/usr/share/texlive/texmf-dist/tex/latex/newtx/untxsyc.fd)
*geometry* driver: auto-detecting
*geometry* detected driver: pdftex
(/usr/share/texlive/texmf-dist/tex/context/base/mkii/supp-pdf.mkii
[Loading MPS to PDF converter (version 2006.09.02).]
) (/usr/share/texlive/texmf-dist/tex/latex/microtype/mt-ptm.cfg)
(/usr/share/texlive/texmf-dist/tex/latex/graphics/graphicx.sty
(/usr/share/texlive/texmf-dist/tex/latex/graphics/graphics.sty
(/usr/share/texlive/texmf-dist/tex/latex/graphics/trig.sty)
(/usr/share/texlive/texmf-dist/tex/latex/graphics-cfg/graphics.cfg)))
(/usr/share/texlive/texmf-dist/tex/latex/microtype/mt-msa.cfg)
(/usr/share/texlive/texmf-dist/tex/latex/microtype/mt-msb.cfg) [1{/var/lib/texm
f/fonts/map/pdftex/updmap/pdftex.map}{/usr/share/texlive/texmf-dist/fonts/enc/d
vips/newtx/ntx-ec-tlf.enc}{/usr/share/texlive/texmf-dist/fonts/enc/dvips/newtx/
ntx-ec-tlf-pc.enc}{/usr/share/texlive/texmf-dist/fonts/enc/dvips/newtx/ntx-ot1-
tlf.enc}] [2] [3] [4] [5] [6] [7] [8] [9] [10] [11] [12] [13] [14] [15]
[16] (/usr/share/texlive/texmf-dist/tex/latex/newtx/t1ntxtt.fd) [17] [18]
(./erdos593_obligatory_triple_systems.aux) )</usr/share/texlive/texmf-dist/font
s/type1/public/newtx/NewTXMI.pfb></usr/share/texlive/texmf-dist/fonts/type1/pub
lic/newtx/NewTXMI5.pfb></usr/share/texlive/texmf-dist/fonts/type1/public/newtx/
NewTXMI7.pfb></usr/share/texlive/texmf-dist/fonts/type1/public/newtx/stxscr.pfb
></usr/share/texlive/texmf-dist/fonts/type1/public/txfonts/t1xtt.pfb></usr/shar
e/texlive/texmf-dist/fonts/type1/public/newtx/txexs.pfb></usr/share/texlive/tex
mf-dist/fonts/type1/public/newtx/txmiaX.pfb></usr/share/texlive/texmf-dist/font
s/type1/public/txfonts/txsyc.pfb></usr/share/texlive/texmf-dist/fonts/type1/pub
lic/newtx/txsym.pfb></usr/share/texlive/texmf-dist/fonts/type1/public/newtx/txs
ys.pfb></usr/share/texlive/texmf-dist/fonts/type1/public/newtx/ztmb.pfb></usr/s
hare/texlive/texmf-dist/fonts/type1/public/newtx/ztmr.pfb></usr/share/texlive/t
exmf-dist/fonts/type1/public/newtx/ztmri.pfb>
Output written on erdos593_obligatory_triple_systems.pdf (18 pages, 301880 byte
s).
Transcript written on erdos593_obligatory_triple_systems.log.
Latexmk: Getting log file 'erdos593_obligatory_triple_systems.log'
Latexmk: Examining 'erdos593_obligatory_triple_systems.fls'
Latexmk: Examining 'erdos593_obligatory_triple_systems.log'
Latexmk: Log file says output to 'erdos593_obligatory_triple_systems.pdf'
Latexmk: Log file says output to 'erdos593_obligatory_triple_systems.pdf'
Latexmk: All targets (erdos593_obligatory_triple_systems.pdf) are up-to-date

```

## PDF metadata
```text
Title:           Obligatory Triple Systems: An Alternative Proof
Subject:         An alternative proof, finite parameter consequences, and Lean verification for obligatory triple systems
Keywords:        obligatory triple system, hypergraph colouring, Levi graph, Berge cycle, uncountable chromatic number, Erdos Problem 593
Author:          Samuil Petkov
Creator:         LaTeX with amsart
Producer:        pdfTeX
CreationDate:    Fri Jul 24 12:00:00 2026 UTC
ModDate:         Fri Jul 24 12:00:00 2026 UTC
Custom Metadata: yes
Metadata Stream: no
Tagged:          no
UserProperties:  no
Suspects:        no
Form:            none
JavaScript:      no
Pages:           18
Encrypted:       no
Page size:       595.276 x 841.89 pts (A4)
Page rot:        0
File size:       301880 bytes
Optimized:       no
PDF version:     1.5
```
