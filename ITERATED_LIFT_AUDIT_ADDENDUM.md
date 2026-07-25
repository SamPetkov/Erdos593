# Audit addendum for the iterated one-apex lift

This file records local details that are easy to suppress in the main proof
narrative but must be checked before any theorem claim.

## 1. The lift is simple and has the claimed uniformity

Let `H` be a simple `s`-uniform hypergraph with `s >= 2`. A lifted edge has the
form

\[
\widehat a(\sigma,\tau,z)
 =\{(\sigma,x):x\in a\}\cup\{(\tau,z)\},
\]

where `sigma` is a proper initial segment of `tau` and
`tau(lh(sigma))=a`.

The base has exactly `s` points. The apex is not one of them because its first
coordinate is `tau`, whereas all base points have first coordinate `sigma`.
Hence every lifted edge has exactly `s+1` points.

Suppose two lifted edges are equal as vertex sets. Since `s >= 2`, each set has
one sequence node occurring once and one sequence node occurring `s` times.
Thus equality determines the apex node, base node, apex coordinate, and the
complete set of base coordinates. Simplicity of `H` then determines the base
edge. Therefore the lifted edge-index map is injective.

This is the first place where `s >= 2` is essential. It also explains why the
construction naturally starts from graphs.

## 2. The selected apex is intrinsic to an embedded edge

If a finite `(s+1)`-uniform source edge embeds in a lifted edge, its image is the
entire lifted edge, not merely a proper subset: both sets have cardinality
`s+1`, and the vertex map is injective. The unique host point at the apex node
therefore has a unique source preimage. This justifies selecting one apex
incidence for every source edge.

## 3. Derivative simplicity and edge injectivity

After the selected apex point is removed from every source edge, each derivative
edge has exactly `s` points. If two derivative edges had the same point set,
the two original source edges would share all `s` of those points. Since
`s >= 2`, source linearity forces the original edges to be equal. Thus the
derivative remains simple.

In one connected derivative component, every retained point and every edge base
has a common sequence node. Projection to the second coordinate is injective on
points because the original embedding is injective and the first coordinate is
constant. It is injective on edge indices by the preceding paragraph and
simplicity of the base hypergraph.

## 4. Nonbridges and finite Levi cycles

The source system is finite. In a finite graph, an edge is a nonbridge exactly
when it belongs to a simple cycle. Consequently, if a selected apex incidence
were not a bridge, it would lie on a simple Levi cycle and hence on a Berge
cycle of the source. The uniform cycle-collapse lemma rules this out because
that source edge would have one connector at the apex node and one at its base
node.

## 5. Bridge persistence through lift levels

Let `S` be any set of bridge edges in a finite graph `G`, and let `C` be a
component of `G-S`. If an edge `f` of `C` is a bridge of `C` but not a bridge of
`G`, then `f` lies on a cycle of `G`. A cycle contains no bridge from `S`, so the
cycle lies in `G-S`, necessarily inside `C`, contradicting that `f` is a bridge
of `C`.

This permits lower-level derivative bridges to be promoted back through every
higher lift level. The promoted incidences are distinct from the newly selected
apex incidence because all derivative incidences survive the top-level apex
deletion.

## 6. Cycle descent preserves all combinatorial data needed for avoidance

A Berge cycle cannot contain a selected apex incidence because that incidence is
a bridge. It therefore survives in one derivative component with the same
ordered list of source edge indices and connector points. Projection to the
base hypergraph preserves those edge indices injectively and preserves the
connector points injectively. Hence the descended cycle has exactly the same
length; in particular, parity and any upper bound on its length are preserved.

## 7. Remaining review boundary

The local points above remove the most immediate cardinality and injectivity
ambiguities. The consequential step that still merits line-by-line external
review is the uniform cycle-collapse lemma on transfinite sequence nodes,
followed by its iteration. The complete-rank depth-two experiment directly
stresses that lemma on non-immediate prefix pairs, while the iterated
immediate-extension experiment stresses bridge persistence over multiple lift
levels. Neither computation replaces an ordinary proof or Lean verification.
