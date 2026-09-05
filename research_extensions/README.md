# Erdős 593 research extensions

This subtree separates follow-up research from the main Problem 593 manuscript. The main paper should remain focused on the classification, canonical atom normal form, sharp finite spectra, and the existing Lean verification boundary.

The folders here develop broader consequences without silently enlarging the theorem claimed in the manuscript.

## 01 — Functorial canonical atom forest

Priority direction for strengthening the 593 paper. The manuscript already proves that the canonical atom partition and the atom--shared-point incidence forest are determined by the triple system. The new target is therefore stronger:

- functoriality under isomorphisms;
- an exact reconstruction/universal property;
- an isomorphism reduction to a decorated forest plus port-marked atoms;
- an automorphism exact sequence and counting formula;
- executable finite audits of equivariance and reconstruction.

If the proof package survives review, a compact functorial-reconstruction proposition and automorphism corollary could plausibly enter the main paper. The full group-theoretic and algorithmic development should remain supplementary.

## 02 — Tensor / graphical reductions

Use the canonical atom forest as an exact factorization interface for higher-order Gibbs models and constraint systems. The objective is not merely a scalar partition-function identity but preservation of fields, pinned observables, and boundary responses. This direction should become a separate paper if developed far enough.

## 03 — Stability and repair

Study distance from the obligatory class. The correct object is an edge-deletion or edit distance to the intrinsic class, not an informal count of local defects. The main questions concern removal/stability theorems, approximation, and property testing.

## 04 — Global questions

Records related directions: obstruction/certificate formulations, recognition algorithms, random models, uniformity-wide extensions, and formalization targets.

## Research discipline

Every theorem file distinguishes:

- proved statements;
- conjectures or proposed extensions;
- computational evidence;
- literature/priority boundaries.

No file in this subtree changes Theorem A unless it is separately integrated into the canonical manuscript after review.
