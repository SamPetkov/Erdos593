# Audit of the canonical attachment enumeration

## 1. Object being counted

The count is for a fixed ordered list of canonical atoms.  Atom labels and
every vertex label inside each atom are retained.

An assembly is represented by an equivalence relation on the initially
disjoint atom vertex sets.  Each non-singleton class is a shared point.  It
must contain at most one vertex from each atom, and the atom--class incidence
graph must be a tree.

The count is therefore of quotient assemblies, not:

- sequences of one-point amalgamation operations;
- abstract incidence trees without vertex choices;
- atom-isomorphism classes; or
- unlabelled hypergraph isomorphism classes.

## 2. Why division by `t!` is valid

The Prüfer calculation temporarily labels the `t` shared-point nodes.  In the
quotient, these nodes are distinct non-singleton equivalence classes.  Every
unlabelled quotient therefore has exactly `t!` labellings of its shared
points.  The action is free even when two shared points have equal
multiplicity: equal degree does not identify distinct equivalence classes.

For a prescribed unordered profile, the number of assignments of the parts
to labelled point nodes is `t! / prod_r m_r!`; division by `t!` then leaves
the factor `1 / prod_r m_r!`.

## 3. Capacity and falling factorials

Atom `i` has `w_i` available vertices.  If its incidence-tree degree is `d_i`,
its incident shared-point nodes must use distinct vertices.  The number of
assignments is therefore `(w_i)_{d_i}`, not `w_i^{d_i}`.

The falling factorial is interpreted as zero when `d_i>w_i`.  Thus the closed
formula automatically removes capacity-violating degree sequences.

Every canonical atom has at least three vertices.  Consequently
`R=sum_i(w_i-1)>=2k`, so all shared-point counts `1<=t<=k-1` lie in the
positive support.

## 4. Vandermonde step

With `x_i=d_i-1`,
\[
\frac{(w_i)_{x_i+1}}{x_i!}
=
w_i\binom{w_i-1}{x_i}.
\]
Hence
\[
\sum_{\sum x_i=t-1}
\prod_i\frac{(w_i)_{x_i+1}}{x_i!}
=
\left(\prod_iw_i\right)
\binom{\sum_i(w_i-1)}{t-1}.
\]
No independence or asymptotic approximation is used.

## 5. Stirling step

With `y_j=mu_j-1>=1`,
\[
(k-1)!\sum_{\sum y_j=k-1}\frac1{\prod_jy_j!}
=
t!S(k-1,t).
\]
This counts surjections from a labelled `(k-1)`-set to the labelled shared
nodes.  Restricting `y_j<=M-1` gives the associated number
`t! S_{<=M-1}(k-1,t)`.

## 6. Quotient order

For a connected attachment, the incidence tree has total shared-point excess
`k-1`.  It therefore identifies exactly `k-1` vertices:
\[
n=\sum_iw_i-k+1.
\]
Thus `R=sum_i(w_i-1)=n-1`.  This relation uses atom **total vertex counts**,
not the orders of their bipartite cores.

For `c` components, the corresponding identity is
\[
n=\sum_iw_i-k+c.
\]

## 7. Canonicality after attachment

The incidence graph is a tree and each shared point uses at most one vertex
from each atom.  Therefore two atoms meet in at most one point and no cycle is
created across atoms.  By the canonical-atom converse, the input atoms remain
exactly the canonical atoms of the quotient.

The enumeration would be invalid for an incidence graph with a cycle, because
the attachment could fuse canonical blocks.

## 8. Binary endpoint

At `t=k-1`, every shared point has degree two.  Suppressing the point nodes
gives an ordinary labelled tree on the atoms.  The formula becomes
\[
\sum_T\prod_i(w_i)_{\deg_T(i)}
=
\left(\prod_iw_i\right)
\left(\sum_i(w_i-1)\right)_{k-2}.
\]

The comparison `prod_i w_i * (sum_i w_i)^(k-2)` allows repeated use of one
atom vertex.  It is not a valid distinct-shared-point assembly count and is
labelled only as a comparison model.

## 9. Log-concavity

The log-concavity statement uses two exact ingredients:

1. the classical real-rootedness of the Touchard polynomial, giving strict
   log-concavity of the positive Stirling row;
2. the direct identity
   \[
   (R)_{t-1}^2/((R)_{t-2}(R)_t)
   =(R-t+2)/(R-t+1)>1.
   \]

Strict log-concavity implies unimodality and at most two adjacent modes.  It
does not by itself imply a unique mode.

## 10. Large-capacity statement

The asymptotic keeps `k` fixed and lets `R` tend to infinity.  The product
`P=prod_iw_i` may vary arbitrarily and cancels from all relative statements.

The exact first ratio is
\[
N_{k-2}/N_{k-1}
=
\binom{k-1}{2}/(R-k+3).
\]
Terms with at most `k-3` shared points are `O_k(R^{-2})` relative to the
binary endpoint.  No uniformity in growing `k` is claimed.

## 11. Computational boundary

The verifier checks the combinatorial formulas independently by:

- exhaustive enumeration of small bipartite incidence trees;
- explicit enumeration and deduplication of quotient equivalence classes;
- ordinary Prüfer enumeration for the binary identity;
- profile and restricted-maximum refinements;
- strict log-concavity over a large exact integer range; and
- the exact first-correction identity.

The finite audit is evidence and regression protection.  It is not used as a
proof of the unbounded theorems.

## 12. Non-goals

The PR does not count unlabelled hypergraphs, quotient by automorphisms,
classify atom isomorphism types of a given size, modify the main classification,
or add a Lean theorem.
