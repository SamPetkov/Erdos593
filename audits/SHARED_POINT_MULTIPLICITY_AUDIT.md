# Audit: shared-point multiplicity spectrum

## Result

**Status: PASS as a mathematical and finite-computational extension.**

The extension is downstream of the canonical atom normal form.  It does not
change the classification theorem, the one-apex lift, the avoiding hosts, or
the Lean development.

## Claims checked

### 1. Forest excess identity

For `k` atom nodes, `t` shared-point nodes, and `c` forest components,

\[
|E|=k+t-c.
\]

The point-side degree sum is `sum_p mu(p)=|E|`, hence

\[
\sum_p(mu(p)-1)=k-c.
\]

No assumption about binary amalgamation is used.  A single point may belong to
three or more atoms.

### 2. Exact profile converse

Every profile is a partition of `k-c`.  The converse construction is
capacity-safe:

- `c-1` atoms are left as singleton components;
- the remaining atoms are assembled by a chain of stars;
- a part `lambda_j` attaches `lambda_j` new atoms at one point of the current
  frontier atom; and
- one child becomes the next frontier.

Every atom uses at most two distinct attachment vertices.  Canonical atoms
have at least three points, including the single-triple atom, so arbitrary
profiles require no hidden high-degree capacity hypothesis.

### 3. Fixed number of shared points

A profile with `t` shared points is a partition of `N=k-c` into `t` positive
parts.  The largest part `r=M-1` satisfies

\[
\lceil N/t\rceil\le r\le N-t+1.
\]

Both inequalities are sharp.  For any integer in the interval, the residual
sum `N-r` lies between `t-1` and `(t-1)r`, so it can be distributed among the
remaining positive parts without exceeding `r`.

### 4. Full degree-sequence converse

For a connected incidence tree, atom degrees `d_i` and shared-point degrees
`mu_j` have common sum `k+t-1`.  Positive bipartite degree sequences with this
sum admit a tree.  The hypergraph realization additionally requires

\[
d_i\le |V(A_i)|,
\]

because different shared points incident with the same atom must use distinct
atom vertices.  This capacity condition is explicit and is not needed for the
profile-only converse above.

### 5. Prüfer enumeration

The labelled degree-sequence count

\[
\frac{(t-1)!(k-1)!}
 {\prod_i(d_i-1)!\prod_j(\mu_j-1)!}
\]

counts incidence trees, not unlabelled hypergraph isomorphism classes.  With
labelled vertices inside each atom, decorating the incidences contributes
`prod_i (v_i)_{d_i}`.  No automorphism quotient is claimed.

### 6. Combination with previous spectra

For every feasible atom count `k`, reassembling the same atoms according to a
new profile makes exactly `k-c` vertex identifications.  It therefore
preserves `m`, `n`, `s=n-m`, total cycle rank `beta`, `c`, and `k`.  Profiles
for distinct `k` have different total weight and are disjoint.

## Edge cases

- `k=c`: the profile is empty and all atoms are separate components.
- `k-c=1`: there is one binary shared point.
- `t=1`: all nontrivial identifications occur at one point of multiplicity
  `k-c+1`.
- `t=k-c`: every shared point has multiplicity two.
- one connected atom: `k=1`, `t=0`; the Prüfer degree theorem is stated only
  for `k>=2`.
- repeated use of one point for several one-point amalgamations is permitted;
  it creates one higher-multiplicity shared point rather than several points.
- componentwise profile tuples are counted with labelled components.  Their
  multiset unions can collide after component labels are forgotten.

## Finite verification

`experiments/verify_shared_point_multiplicity_spectrum.py` uses only the Python
standard library.  The committed run checks:

- 7,338 integer partitions through weight 24;
- 300 exact fixed-length largest-part spectra;
- 5,140 exhaustively enumerated labelled bipartite trees for class sizes at
  most four;
- 697 degree-sequence Prüfer formulas;
- 120 capacity-aware degree-sequence realizations by actual expansion atoms;
- 556 realizations of all profiles through weight 10 and component counts one
  through four; and
- independent canonical-atom recovery from the assembled Levi graph.

The generated JSON result is committed at
`experiments/shared_point_multiplicity_audit.json`.

## Non-goals

This PR does not claim:

- a new solution of Erdős Problem 593;
- a count of unlabelled obligatory systems;
- a Lean formalization of the new profile theorem;
- that arbitrary atom-side degrees are realizable without vertex capacity;
  or
- priority over any equivalent general block-tree or bipartite Prüfer result.

The contribution is the exact specialization and integration of these facts
with the canonical atom and exact finite-spectrum theory developed in the
preceding PRs.
