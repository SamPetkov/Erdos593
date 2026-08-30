# Academic humanization report

## Revised version

The clean revised manuscript is
[`erdos593_obligatory_triple_systems.tex`](../erdos593_obligatory_triple_systems.tex).
The synchronization script generates the PDF, Markdown, arXiv source, and
mirror TeX files from that canonical source.

The revision used a medium-intensity English academic pass. It retains the
manuscript's first-person plural and impersonal scholarly voice. The pass is
editorial: it does not change a theorem, hypothesis, quantifier, equation,
citation, cross-reference, or the stated boundary of the current Lean
formalization. In particular, it does not present the A3--A5 extension work as
a completed public Lean endpoint.

## Comparison and notes

Because the manuscript is long, the comparison is representative and
section-level.

| Section | Earlier wording | Revised wording | Note |
|---|---|---|---|
| Abstract | “We prove the classification … and give a Lean 4 verification …” | “We classify … and formalise the finite structural core … in Lean 4.” | Uses a direct research verb and states the verified scope compactly. |
| Abstract | “The bridge decomposition sharpens to a canonical forest of atoms …” | “The associated bridge decomposition yields a canonical forest of atoms …” | Removes metaphor while preserving the implication. |
| Introduction | “The hosts in this problem are infinite, but the answer is decided by a small piece of finite geometry.” | “Although the host systems are infinite, the classification is determined by finite structure.” | Replaces conversational framing with precise academic prose. |
| Parallel work | Priority-focused wording about Li's preprint. | “The present proof and Lean implementation were developed independently, in parallel with closely related work by Li.” | Records chronology and independence in neutral scholarly language. |
| Parallel work | Dependence-adjacent descriptions of Li's method. | “We cite this work for chronology and comparison; none of its results is used below as a black box.” | Makes the mathematical dependency boundary explicit without alleging misconduct. |
| Proof overview | “The proof is best read as two stories. On the positive side …” | “The proof separates into positive and negative directions. For the positive direction …” | Replaces tutorial-like language with the logical division of the proof. |
| Rooted abundance | “Moreover, $S_v$ meets …” | “By maximality, $S_v$ meets …” | States the logical reason instead of using a generic transition. |
| Intrinsic decomposition | “The only remaining issue is global …” | “It remains to order the pieces so that each new piece meets the assembled system in at most one point.” | Names the exact remaining proof obligation. |
| Trace theorem | “The following dictionary records the three local objects …” | “We use three local objects in the assembly …” | Removes outline-like phrasing while retaining every definition. |
| Avoidance hosts | “The intrinsic criterion has exactly three possible failures …” | “The intrinsic criterion can fail in three ways …” | Tightens the sentence without changing exhaustiveness. |
| Formal verification | One dense paragraph combining the finite endpoint and host universe. | Separate sentences distinguish the finite classified system, the host universe, and the non-Lean spectra. | Prevents overreading of the verified boundary. |

## Terminology control

The pass keeps the following terms fixed: obligatory triple system,
private-vertex expansion, Levi graph, hyperedge-node, Berge cycle, one-point
amalgamation, canonical atom, atom--point forest, base fibre, and
support-incidence graph. It also retains the manuscript's British spelling
convention.

## Preservation and validation

Against the public base revision, the revised canonical TeX preserves the
exact ordered sequences of all 65 labels, 8 `\ref`/`\eqref` commands, 29
citations, 3 hyperlinks, 29 equation tags, selected theorem/proof environment
delimiters, and all 99 display-math blocks. The theorem inventory still
contains 37 theorem-like environments. No displayed mathematical block was
changed.

The non-Lean audits pass for theorem inventory and finite arithmetic,
standard-definition alignment, the public external/Lean interface, and the
bridge-core certificate. The AMS audit has no remaining required finding;
its remaining items distinguish the designed preprint from a later
AMS-submission-layout branch.
