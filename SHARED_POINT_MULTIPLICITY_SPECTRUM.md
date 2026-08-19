# Shared-point multiplicity spectra for canonical atom forests

## Scope

This note continues the canonical-atom normal form and the connected and
componentwise atom-count spectra.  It does not alter the classification of
obligatory triple systems.  It extracts the exact information carried by the
**shared points** at which canonical atoms are amalgamated.

Let `F` be a finite reduced obligatory triple system with at least one
hyperedge.  Let

- `A_1,...,A_k` be its canonical atoms;
- `c` be the number of connected components of `F`;
- `P_sh(F)` be the points belonging to at least two atoms; and
- `mu(p)` be the number of atoms containing `p`.

The atom--shared-point incidence graph `Q(F)` is bipartite, with one class the
canonical atoms and the other class `P_sh(F)`, and with `A_i p` an edge exactly
when `p` belongs to `A_i`.  By the canonical atom theorem, `Q(F)` is a forest.
Its connected components are exactly the connected components of `F`.

Throughout, `p(N)` denotes the integer partition number, with `p(0)=1`, and
`Par(N)` denotes the set of integer partitions of `N`.  The empty partition is
the unique element of `Par(0)`.

## 1. Forest excess identity

### Theorem 1 — exact shared-point excess

For every finite reduced obligatory `F` as above,

\[
\boxed{
  \sum_{p\in P_{\rm sh}(F)}\bigl(\mu(p)-1\bigr)=k-c.
}
\tag{1.1}
\]

Equivalently, if `t=|P_sh(F)|`, then

\[
|E(Q(F))|=k+t-c
\quad\text{and}\quad
\sum_{p\in P_{\rm sh}(F)}\mu(p)=k+t-c.
\tag{1.2}
\]

#### Proof

The forest `Q(F)` has `k+t` vertices and `c` connected components.  Hence

\[
|E(Q(F))|=k+t-c.
\]

On the other hand, summing degrees over the shared-point class gives

\[
|E(Q(F))|=\sum_{p\in P_{\rm sh}(F)}\mu(p).
\]

Subtracting `t` proves (1.1).  The assertion that `Q(F)` has exactly `c`
components follows by contracting each connected atom inside the Levi graph:
a path between hyperedges in one component of `F` becomes an alternating path
through atoms and shared points, while distinct components cannot meet.

## 2. Exact multiplicity profiles

Define the **shared-point excess profile**

\[
\lambda(F)=\operatorname{sort}_{\ge}
  \{\mu(p)-1:p\in P_{\rm sh}(F)\}.
\]

Thus `lambda(F)` records only the multiplicities, not the labels of the shared
points.

### Theorem 2 — integer partitions are the exact profiles

Let `F` have `k` canonical atoms and `c` connected components.  Then

\[
\lambda(F)\in\operatorname{Par}(k-c).
\tag{2.1}
\]

Conversely, fix any list of `k` canonical atom types and any integer
`1 <= c <= k`.  Every partition

\[
\lambda=(\lambda_1,\ldots,\lambda_t)\vdash k-c
\tag{2.2}
\]

is realised by a forest assembly of those atoms into exactly `c` connected
components, with

\[
\mu(p_j)=\lambda_j+1.
\tag{2.3}
\]

The construction preserves the isomorphism type of every atom and therefore
preserves the total numbers of vertices and hyperedges, the total Levi cycle
rank, `c`, and `k`.

#### Proof

The forward implication is Theorem 1: all numbers `mu(p)-1` are positive and
their sum is `k-c`.

For the converse, first suppose `k>c`, and put `N=k-c`.  Reserve `c-1` atoms
as isolated connected components.  The remaining `N+1` atoms will form one
component.  Choose one as a root and process the parts of `lambda` in order.
At step `j`, choose a fresh point of the current frontier atom and fresh points
of `lambda_j` unused atoms, and identify all of these points.  This creates one
shared point of multiplicity `lambda_j+1`.  Choose one of the newly attached
atoms as the next frontier.

Exactly

\[
\sum_j\lambda_j=N
\]

new atoms are used.  Each frontier atom is incident with at most two distinct
shared points: one by which it entered the construction and one by which the
next group is attached.  Every canonical atom has at least three points, so no
vertex-capacity issue occurs.  The atom--point incidence graph is a tree in the
nontrivial component together with `c-1` isolated atom nodes.  Distinct shared
points use distinct atom vertices.  Hence the original atoms remain precisely
the canonical atoms of the assembly.  When `k=c`, the partition is empty and
the disjoint union of the `k` atoms is the required assembly.

### Corollary 2.1 — exact number of profiles

For fixed `k` and `c`, the number of possible shared-point multiplicity
profiles is exactly

\[
\boxed{p(k-c)}.
\tag{2.4}
\]

This counts multiplicity multisets.  It does not count labelled incidence
forests or isomorphism classes of the resulting triple systems.

### Corollary 2.2 — prescribed component atom counts

Suppose the `c` components are labelled and contain respectively
`k_1,...,k_c` atoms, with `sum_i k_i=k`.  The possible componentwise profiles
are exactly the tuples

\[
(\lambda^{(1)},\ldots,\lambda^{(c)}),
\qquad
\lambda^{(i)}\vdash k_i-1.
\tag{2.5}
\]

Consequently, the number of labelled componentwise profile tuples is

\[
\boxed{\prod_{i=1}^c p(k_i-1)}.
\tag{2.6}
\]

The global profile is the multiset union of the component profiles.  Different
componentwise tuples can have the same global multiset, so (2.6) is not in
general the number of unlabelled global profiles with the vector
`(k_1,...,k_c)` fixed.

## 3. Number of shared points and largest multiplicity

Put

\[
N=k-c,
\qquad
t=|P_{\rm sh}(F)|,
\qquad
M=\max_{p\in P_{\rm sh}(F)}\mu(p)
\]

when `N>0`.

### Theorem 3 — exact `(t,M)` spectrum

If `N=0`, then `t=0`.  If `N>0`, then

\[
1\le t\le N.
\tag{3.1}
\]

For fixed `N>0` and `1<=t<=N`, the possible values of the largest shared-point
multiplicity are exactly

\[
\boxed{
1+\left\lceil\frac Nt\right\rceil
\le M\le
N-t+2.
}
\tag{3.2}
\]

Every integer in this interval occurs.

#### Proof

A profile with `t` shared points is a partition of `N` into `t` positive parts.
If its largest part is `r=M-1`, then averaging gives

\[
r\ge\left\lceil\frac Nt\right\rceil,
\]

and the other `t-1` positive parts give

\[
r\le N-t+1.
\]

Conversely, suppose

\[
\left\lceil\frac Nt\right\rceil\le r\le N-t+1.
\]

After reserving one part equal to `r`, the remaining sum `N-r` lies between
`t-1` and `(t-1)r`.  It can therefore be distributed among `t-1` positive
parts, each at most `r`.  This gives a partition of `N` into `t` parts with
largest part exactly `r`.  Theorem 2 realises it.

### Extremes

- `t=1` gives one common point contained in `N+1=k-c+1` atoms.
- `t=N` gives `N` binary amalgamation points, all of multiplicity two.
- The average shared-point multiplicity is

  \[
  1+\frac Nt.
  \]

Thus concentration of all identifications at a few points and complete binary
separation are the two exact endpoints of the same partition spectrum.

## 4. Full incidence degree sequences

The multiplicity profile sees only the shared-point side of `Q(F)`.  In a
connected system with `k>=2` atoms, let

- `p_1,...,p_t` be the shared points;
- `d_i=deg_Q(A_i)` be the number of distinct shared points used by atom `A_i`;
- `mu_j=deg_Q(p_j)`; and
- `v_i=|V(A_i)|`.

Since `Q(F)` is a bipartite tree,

\[
\sum_{i=1}^k(d_i-1)=t-1,
\qquad
\sum_{j=1}^t(\mu_j-1)=k-1.
\tag{4.1}
\]

### Theorem 4 — capacity-aware degree-sequence realisation

Fix labelled canonical atoms `A_1,...,A_k`, with `k>=2`, and a positive integer
`t`.  Let

\[
1\le d_i\le v_i,
\qquad
2\le\mu_j,
\tag{4.2}
\]

and assume

\[
\sum_i d_i=\sum_j\mu_j=k+t-1.
\tag{4.3}
\]

Then there is a connected forest assembly whose atom--shared-point incidence
tree has atom degrees `(d_i)` and shared-point degrees `(mu_j)`.

#### Proof

Positive bipartite degree sequences satisfying (4.3) are degree sequences of a
bipartite tree.  One direct induction repeatedly removes a degree-one vertex
from one side and decreases by one a vertex of degree greater than one on the
opposite side.  Unless only one edge remains, such a choice always exists;
reattaching the removed leaves in reverse order constructs the tree.

For every atom `A_i`, choose `d_i` distinct vertices, possible by (4.2), and
assign them injectively to the incident shared-point nodes.  For each point
node `p_j`, identify the selected vertices in its `mu_j` incident atoms.  The
incidence graph is a tree, so no two atoms meet in more than one point and no
cycle is created across atoms.  The canonical atom partition is therefore
unchanged.

### Theorem 5 — exact labelled Prüfer count

For fixed labelled atom nodes and labelled shared-point nodes, the number of
bipartite incidence trees with degree sequences `(d_i)` and `(mu_j)` is

\[
\boxed{
T(d,\mu)=
\frac{(t-1)!(k-1)!}
 {\prod_{i=1}^k(d_i-1)!\prod_{j=1}^t(\mu_j-1)!}.
}
\tag{4.4}
\]

If the vertices inside each atom are also labelled, the number of
vertex-decorated assemblies with this fixed incidence degree sequence is

\[
\boxed{
T(d,\mu)\prod_{i=1}^k(v_i)_{d_i},
}
\tag{4.5}
\]

where `(v)_d=v(v-1)...(v-d+1)`.  These are labelled counts; no quotient by atom
or hypergraph automorphisms is taken.

#### Proof

The bipartite Prüfer code is a pair of words: a word of length `t-1` on the
atom labels and a word of length `k-1` on the shared-point labels.  Atom `i`
appears `d_i-1` times in the first word, and point `j` appears `mu_j-1` times
in the second.  Counting the two multisets of word positions gives (4.4).
For (4.5), each atom admits `(v_i)_{d_i}` injections from its incident labelled
point nodes to distinct atom vertices.

Summing (4.4) over all degree sequences recovers the bipartite Cayley formula

\[
|\mathcal T_{k,t}|=k^{t-1}t^{k-1}.
\tag{4.6}
\]

If only the shared-point excess profile
`lambda=(lambda_1,...,lambda_t) partition k-1` is fixed and the point labels are
retained, let `m_r` be the number of parts of `lambda` equal to `r`.  The number
of labelled incidence trees with that profile is

\[
\boxed{
\frac{t!}{\prod_r m_r!}
\;k^{t-1}\;
\frac{(k-1)!}{\prod_{j=1}^t\lambda_j!}.
}
\tag{4.7}
\]

## 5. Combination with the exact atom-count spectrum

Let

\[
s=|V(F)|-|E(F)|,
\qquad
\beta=2|E(F)|-|V(F)|+c,
\qquad
q(r)=\lceil2\sqrt r\rceil.
\]

Let `K(s,beta,c)` be the exact set of feasible canonical atom counts from the
componentwise atom-count theorem:

\[
\begin{array}{ll}
\beta=0:
  & k=s-c,\\[1mm]
\beta=1:
  & c\le k\le s-c-2,\quad k\equiv s-c\pmod2,\\[1mm]
\beta\ge2:
  & c\le k\le s-c-q(\beta).
\end{array}
\tag{5.1}
\]

The inequalities are understood only for feasible `(s,beta,c)`.

### Theorem 6 — exact profile set at fixed global invariants

For fixed feasible `(s,beta,c)`, the possible shared-point excess profiles are
exactly

\[
\boxed{
\bigcup_{k\in K(s,\beta,c)}\operatorname{Par}(k-c).
}
\tag{5.2}
\]

The union is disjoint by partition weight.  Hence the exact number of profiles
is

\[
\boxed{
\sum_{k\in K(s,\beta,c)}p(k-c).
}
\tag{5.3}
\]

Equivalently,

\[
\begin{array}{ll}
\beta=0:
  & p(s-2c),\\[1mm]
\beta=1:
  & \displaystyle
    \sum_{\substack{0\le N\le s-2c-2\\N\equiv s-2c\ ({\rm mod}\ 2)}}p(N),\\[4mm]
\beta\ge2:
  & \displaystyle
    \sum_{N=0}^{s-2c-q(\beta)}p(N).
\end{array}
\tag{5.4}
\]

#### Proof

For each feasible `k`, Theorem 1 forces a partition of `k-c`, and Theorem 2
realises every such partition while preserving the atom types and all global
parameters.  Profiles arising from different `k` have different total excess
and therefore cannot coincide.  Substitution of (5.1) gives (5.4).

## 6. What this adds and what it does not

This extension shows that the canonical atom count is not the end of the
finite structure.  Once `k` and `c` are fixed, the entire multiplicity spectrum
is controlled by ordinary integer partitions, while the labelled attachment
geometry is controlled by bipartite Prüfer codes.

It does **not**:

- alter the obligatory-system classification;
- strengthen the infinitary avoiding-host argument;
- count unlabelled triple-system isomorphism classes;
- remove the vertex-capacity condition for arbitrary atom-side degree
  sequences; or
- add a new Lean theorem.

The unrestricted multiplicity-profile converse avoids the capacity issue by a
chain-of-stars construction in which every atom is incident with at most two
shared points.

## 7. Reproducibility

Run

```bash
python experiments/verify_shared_point_multiplicity_spectrum.py
```

The finite audit checks integer partitions, the exact `(t,M)` spectrum,
exhaustive labelled bipartite-tree counts, capacity-aware degree-sequence
realisations, and recovery of the canonical atom partition after actual
hypergraph assemblies.
