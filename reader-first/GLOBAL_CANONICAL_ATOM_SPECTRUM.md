# Global componentwise canonical atom spectra

## Purpose

The connected canonical-atom results admit an exact extension to arbitrary
reduced obligatory triple systems.  No new structural input is required: the
canonical atom incidence graph is a forest rather than a tree, and each of its
connected components is handled by the connected theory.

Let \(F\) be a finite reduced obligatory triple system with

\[
 m=|E(F)|,\qquad n=|V(F)|,\qquad c=c(F)\ge1
\]

connected components.  Put

\[
 s=n-m,\qquad
 \beta=2m-n+c=m-s+c,
\]

and define

\[
 \kappa(r)=\left\lceil2\sqrt r\right\rceil
 \qquad(r\ge0).
\]

Thus \(\beta\) is the total cyclomatic number of the Levi graph, equivalently
of any bipartite parameter shadow.

As in the canonical atom theorem, a single-triple atom is represented by the
core \(K_2\), of order two and cycle rank zero.

## The forest-additive law

### Theorem

Let the canonical atoms of \(F\) have bipartite cores
\(J_1,\ldots,J_k\).  Write

\[
 v_i=|V(J_i)|,\qquad
 e_i=|E(J_i)|,\qquad
 r_i=e_i-v_i+1.
\]

Then

\[
 \boxed{
 m=\sum_{i=1}^k e_i,\qquad
 s=c+\sum_{i=1}^k(v_i-1),\qquad
 \beta=\sum_{i=1}^k r_i.
 }
\]

In particular:

- the positive atom ranks form an intrinsic integer partition of \(\beta\);
- the component cycle ranks form an intrinsic weak composition of \(\beta\)
  into \(c\) nonnegative parts; and
- every canonical atom forest has at least \(c\) atoms.

### Proof

The atoms partition the hyperedges, so \(m=\sum_i e_i\).  If the \(j\)-th
connected component contains \(k_j\) atoms, its forest assembly makes exactly
\(k_j-1\) one-point identifications.  Since \(\sum_j k_j=k\), the full system
makes \(k-c\) identifications.  Therefore

\[
 n=\sum_i(e_i+v_i)-(k-c).
\]

Subtracting \(m\) gives

\[
 s=\sum_i v_i-k+c
  =c+\sum_i(v_i-1).
\]

Finally,

\[
 \beta=m-s+c
 =\sum_i(e_i-v_i+1)
 =\sum_i r_i.
 \qquad\square
\]

## Global feasibility

### Corollary

A reduced obligatory triple system with shadow order \(s\), total cycle rank
\(\beta\), and exactly \(c\) connected components exists if and only if

\[
 \boxed{
 \begin{array}{ll}
 \beta=0:& s\ge2c,\\[1mm]
 \beta\ge1:& s\ge2c+\kappa(\beta).
 \end{array}}
\]

### Proof

A rank-zero component needs at least one single-triple atom and hence shadow
order two.  A positive-rank component containing rank \(r\) needs shadow order
at least \(2+\kappa(r)\).  Concentrating the full rank \(\beta\) in one
component and taking \(c-1\) single-triple components gives the displayed
lower bound.

Conversely, use one minimum-order rank-\(\beta\) cyclic atom in one component,
one single triple in each remaining component, and realize every unit of
slack by adding another single-triple atom without changing the number of
components.  The case \(\beta=0\) is the same construction with no cyclic
atom. \(\square\)

## Prescribed cyclic atom-rank partition

### Theorem

Let \(r_1,\ldots,r_q\) be positive integers; the empty list \(q=0\) is
allowed.  There exists a reduced obligatory triple system with

- exactly \(c\) connected components;
- shadow order \(s\); and
- canonical cyclic-atom rank multiset
  \(\{r_1,\ldots,r_q\}\)

if and only if

\[
 \boxed{
 s\ge
 c+\sum_{i=1}^q\bigl(1+\kappa(r_i)\bigr)
   +\max(0,c-q).
 }
\]

For \(q=0\), this says exactly \(s\ge2c\).

At equality:

- if \(q\ge c\), every component contains a cyclic atom and there are no
  single-triple atoms;
- if \(q<c\), exactly \(c-q\) components are single triples; and
- every cyclic atom has minimum possible order
  \(2+\kappa(r_i)\).

Every additional unit of \(s\) is realized by one additional single-triple
atom.

### Proof

A cyclic atom of rank \(r_i\) costs at least

\[
 v_i-1\ge1+\kappa(r_i)
\]

in the forest-additive formula.  If \(q<c\), at least \(c-q\) rank-zero atoms
are needed so that every forest component contains an atom.  This proves
necessity.

For sufficiency, take minimum-order cyclic cores of ranks \(r_i\).  Distribute
them among the \(c\) components, placing at least one in every component when
\(q\ge c\).  If \(q<c\), add one single-triple component for every uncovered
component.  Assemble multiple atoms within each component by one-point sums.
Finally attach one single-triple atom for every unit of remaining slack.
\(\square\)

## Prescribed component-rank profile

Define

\[
 g(r)=
 \begin{cases}
 2,&r=0,\\
 2+\kappa(r),&r\ge1.
 \end{cases}
\]

### Theorem

Let \(\beta_1,\ldots,\beta_c\) be nonnegative integers.  There exists a reduced
obligatory triple system whose connected components have cycle ranks exactly

\[
 \beta_1,\ldots,\beta_c
\]

and whose total shadow order is \(s\) if and only if

\[
 \boxed{
 s\ge\sum_{j=1}^c g(\beta_j).
 }
\]

### Proof

Apply the connected minimum-order theorem separately to each component.
A rank-zero component has minimum shadow order two; a positive-rank component
of rank \(r\) has minimum shadow order \(2+\kappa(r)\).  Disjoint union adds
shadow orders.  Any remaining slack is absorbed by bridge atoms in one
component. \(\square\)

This gives a complete classification of the possible component-rank
multisets: they are precisely the partitions of \(\beta\), padded by zeros to
length \(c\), whose \(g\)-cost is at most \(s\).

## Exact number of cyclic components

### Corollary

If \(\beta=0\), every component is acyclic.  Let \(\beta\ge1\).  Exactly \(h\)
of the \(c\) connected components have positive cycle rank if and only if

\[
 \boxed{
 1\le h\le\min(c,\beta),
 \qquad
 s\ge
 2c+2h-2+\kappa(\beta-h+1).
 }
\]

The extremal component-rank profile is

\[
 (\beta-h+1,1,\ldots,1,0,\ldots,0).
\]

Hence the possible numbers of cyclic components form an initial interval.

### Proof

For positive component ranks \(b_1+\cdots+b_h=\beta\), the component-profile
theorem gives minimum order

\[
 2c+\sum_{j=1}^h\kappa(b_j).
\]

The sharp concentration inequality

\[
 \sum_{j=1}^h\kappa(b_j)
 \ge
 2h-2+\kappa(\beta-h+1)
\]

is attained by
\((\beta-h+1,1,\ldots,1)\).  This proves the criterion.  The threshold is
strictly increasing in \(h\), so the admissible values form an initial
interval. \(\square\)

## Exact number of cyclic atoms

### Corollary

If \(\beta=0\), there are no cyclic atoms.  Let \(\beta\ge1\).  Exactly \(q\)
cyclic atoms occur if and only if

\[
 \boxed{
 1\le q\le\beta,
 \qquad
 s\ge
 c+3q-2+\kappa(\beta-q+1)+\max(0,c-q).
 }
\]

Again the extremal positive atom-rank partition is

\[
 (\beta-q+1,1,\ldots,1),
\]

and the possible cyclic-atom counts form an initial interval.

### Proof

Minimize the prescribed-partition threshold over all positive
\(q\)-partitions of \(\beta\).  The same concentration inequality gives

\[
 \min\sum_{i=1}^q\kappa(r_i)
 =
 2q-2+\kappa(\beta-q+1),
\]

which yields the displayed formula. \(\square\)

## Exact total atom-count spectrum

### Theorem

Let \(k\) be the total number of canonical atoms, including single-triple
atoms.  For every feasible triple \((s,\beta,c)\), the possible values of
\(k\) are exactly

\[
 \boxed{
 \begin{array}{ll}
 \beta=0:
   & k=s-c,\\[1mm]
 \beta=1:
   & c\le k\le s-c-2,\quad
     k\equiv s-c\pmod2,\\[1mm]
 \beta\ge2:
   & c\le k\le s-c-\kappa(\beta).
 \end{array}}
\]

Thus the spectrum is an interval for every \(\beta\ge2\); the parity
obstruction at total rank one is the only gap phenomenon.

For \(\beta\ge1\),

\[
 \boxed{
 k_{\max}=s-c-\kappa(\beta).
 }
\]

Every maximizer has one minimum-order cyclic atom carrying all of \(\beta\);
all other atoms are single triples.

The minimum number of atoms is

\[
 \boxed{
 k_{\min}=
 \begin{cases}
 s-c,&\beta=0,\\
 c,&\beta=1\text{ and }s\text{ is even},\\
 c+1,&\beta=1\text{ and }s\text{ is odd},\\
 c,&\beta\ge2.
 \end{cases}}
\]

### Proof

If \(\beta=0\), every atom has core \(K_2\), so the forest-additive formula is

\[
 s=c+k.
\]

Suppose \(\beta=1\).  There is exactly one cyclic atom, and its core is an even
cycle of order \(v\ge4\).  The remaining \(k-1\) atoms are single triples.
Hence

\[
 s=c+(k-1)+(v-1)=c+k+v-2.
\]

Thus

\[
 v=s-c-k+2
\]

must be even and at least four.  This is equivalent to the stated interval
and parity condition.  The condition \(k\ge c\) is exactly what is needed to
distribute the atoms among \(c\) nonempty forest components.

Now let \(\beta\ge2\).  If the positive atom ranks are \(r_1,\ldots,r_q\),
then

\[
 s
 \ge
 c+k+\sum_{i=1}^q\kappa(r_i)
 \ge
 c+k+\kappa(\beta),
\]

so

\[
 k\le s-c-\kappa(\beta).
\]

The lower bound \(k\ge c\) is forced by the \(c\) forest components.  Every
integer in the interval is realized by taking \(c-1\) single-triple
components and applying the connected atom-count theorem to the remaining
component.

Equality in the upper bound forces equality in the strict rank-concentration
inequality.  Hence there is one cyclic atom, it has rank \(\beta\), and its
order is minimum.  All remaining atoms have rank zero.  The formulas for
\(k_{\min}\) follow immediately. \(\square\)

## Relation to the connected theory

Setting \(c=1\) recovers all connected formulas from the canonical atom-rank
spectrum:

\[
\begin{array}{c|c}
\beta & \text{possible total atom counts}\\ \hline
0 & k=s-1\\
1 & 1\le k\le s-3,\quad k\equiv s+1\pmod2\\
\beta\ge2 & 1\le k\le s-1-\kappa(\beta).
\end{array}
\]

The global theorem therefore adds no separate exceptional family.  It only
shifts the atom floor from one to the number \(c\) of connected components and
records the exact cost of allocating cycle rank among those components.

## Manuscript placement

The main paper should retain the connected form, which is the clearest
quantitative consequence of the canonical atom theorem.  The global extension
is best stated as one proposition after the connected theorem or placed in an
appendix:

1. forest-additive law;
2. global feasibility;
3. exact total atom-count spectrum; and
4. component-rank profile as a short corollary.

The prescribed atom-rank and cyclic-component formulas are useful for the
repository and for later applications, but need not all appear in the main
text.

## Exact audit

`experiments/verify_global_canonical_atom_spectrum.py` independently checks
the componentwise formulas on bipartite parameter shadows.

The exhaustive fixed-bipartition search through \(s=8\) examines

- 108,622 labelled bipartite graphs;
- 61,096 reduced graphs with no isolated vertices;
- 222,559 recovered edge blocks; and
- 51,179 recovered cyclic blocks.

It compares every observed rank partition, component-rank profile,
cyclic-component count, cyclic-atom count, and total atom count for 46 feasible
parameter triples \((s,\beta,c)\).

The constructive audit through \(s=30\), with up to six components, checks

- 767 prescribed atom-rank partitions;
- 540 prescribed component-rank profiles;
- 20,656 cyclic-atom-count witnesses;
- 13,759 cyclic-component-count witnesses; and
- 45,650 total-atom-count witnesses.

The arithmetic audit checks global feasibility through total rank 4096 and
128 components, with 1,048,832 endpoint checks and 8,386,560 monotonicity
checks.

## Literature and priority boundary

The passage from a block tree to a block forest is standard.  The results here
are exact arithmetic consequences of the canonical atom normal form, the
connected minimum-order theorem, and elementary integer-partition
concentration.  They are presented as structural corollaries under review,
not as an independent priority claim.
