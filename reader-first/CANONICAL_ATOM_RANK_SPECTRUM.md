# Canonical atom-rank and block-count spectra for obligatory triple systems

## Purpose

The canonical atom theorem partitions every connected reduced obligatory triple
system into one-point-amalgamation atoms.  The preceding indecomposability
spectrum detects whether one atom is possible, or forced, from the order and
size.  The present note determines substantially more:

- the additive cycle-rank carried by every canonical cyclic atom;
- the exact minimum order required by a cyclic atom of prescribed rank;
- the exact realizability criterion for an arbitrary partition of the total
  cycle rank among cyclic atoms;
- the exact possible number of cyclic atoms; and
- the exact possible total number of canonical atoms.

The only non-interval phenomenon in the total atom-count spectrum is a parity
obstruction in the unicyclic case.  Thus the canonical decomposition has a
complete quantitative theory at the level of order, size, cycle rank, and
number of atoms.

This is a structural corollary of the canonical atom normal form, the exact
2-connected bipartite parameter interval, and elementary block-additivity.  It
does not alter the classification theorem or the infinitary avoidance proof.

## Notation

Let \(F\) be a connected reduced obligatory triple system with

\[
 m=|E(F)|,\qquad n=|V(F)|.
\]

Put

\[
 s=n-m,
 \qquad
 \beta=2m-n+1=m-s+1.
\]

The connected shadow spectrum gives

\[
 s\ge2,
 \qquad
 0\le\beta\le\left\lfloor\frac{(s-2)^2}{4}\right\rfloor.
\]

This is what “feasible” means below.  The integer \(s\) is the order of a
connected bipartite shadow of \(F\).  The integer \(\beta\) is simultaneously

- the cyclomatic number of that shadow; and
- the cyclomatic number of the Levi graph \(I(F)\), since \(I(F)\) has
  \(n+m\) vertices and \(3m\) edges.

Let

\[
 c(r)=\left\lceil 2\sqrt r\right\rceil
 \qquad (r\in\mathbb Z_{\ge0}).
\]

Use the canonical atom partition from the atom normal form.  A **bridge atom**
is a single triple, represented on the shadow side by one copy of \(K_2\).  A
**cyclic atom** is \(J^+\), where \(J\) is finite, simple, bipartite, and
2-connected.  Its **atom rank** is

\[
 \beta(J)=|E(J)|-|V(J)|+1.
\]

This is also the cyclomatic number of the atom's Levi graph.  Every cyclic atom
has positive atom rank; every bridge atom has atom rank zero.

## Additive rank law

### Proposition

Suppose that the canonical atoms of \(F\) have shadow cores
\(J_1,\ldots,J_k\).  Write

\[
 v_i=|V(J_i)|,\qquad e_i=|E(J_i)|,
 \qquad \beta_i=e_i-v_i+1.
\]

Here a bridge atom has \((v_i,e_i,\beta_i)=(2,1,0)\).  Then

\[
 m=\sum_{i=1}^k e_i,
 \qquad
 s=1+\sum_{i=1}^k(v_i-1),
 \qquad
 \beta=\sum_{i=1}^k\beta_i.
\]

In particular, the positive entries among the \(\beta_i\) form an intrinsic
integer partition of \(\beta\), determined by \(F\).

### Proof

The atom--shared-point incidence graph is a tree because \(F\) is connected.
If a shared point belongs to \(d\) atoms, identifying the \(d\) copies of that
point subtracts \(d-1\) vertices.  Summing over all shared points subtracts
exactly \(k-1\), since a bipartite tree with \(k\) atom nodes has

\[
 \sum_{p}(\deg p-1)=k-1.
\]

Therefore

\[
 n=\sum_i(v_i+e_i)-(k-1),
 \qquad
 m=\sum_i e_i,
\]

and hence

\[
 s=n-m=\sum_i v_i-(k-1)
   =1+\sum_i(v_i-1).
\]

Finally,

\[
 \beta=m-s+1
 =\sum_i(e_i-v_i+1)
 =\sum_i\beta_i.
\]

Canonicity follows from canonicity of the atom partition and of every
suppressed core up to graph isomorphism. \(\square\)

## Minimum order of one cyclic atom

### Lemma

For every integer \(r\ge1\), the minimum possible number of vertices of a
finite 2-connected simple bipartite graph of cycle rank \(r\) is

\[
 \boxed{2+c(r)=2+\left\lceil2\sqrt r\right\rceil.}
\]

Equivalently, a cyclic atom of rank \(r\) contributes at least

\[
 1+c(r)
\]

to \(s-1\).

### Proof

Let \(J\) have \(v\) vertices and rank \(r\).  Then

\[
 |E(J)|=v-1+r.
\]

The bipartite extremal inequality gives

\[
 v-1+r\le\left\lfloor\frac{v^2}{4}\right\rfloor,
\]

or equivalently

\[
 r\le
 \left\lfloor\frac{(v-2)^2}{4}\right\rfloor.
\]

Thus \(v-2\ge c(r)\).

For sharpness put \(v=2+c(r)\) and \(e=v-1+r\).  The defining inequality for
\(c(r)\) gives \(e\le\lfloor v^2/4\rfloor\).  If \(v\) is even, then
\(e\ge v\).  If \(v\) is odd, the only additional lower requirement for a
2-connected bipartite graph is \(e\ge v+1\); this holds because the exceptional
rank \(r=1\) gives \(v=4\), while every odd \(v\) arising here has \(r\ge2\).
The exact 2-connected bipartite edge interval therefore supplies such a graph.
Concretely, start from an even cycle when \(v\) is even, or from an even cycle
plus one new vertex of degree two when \(v\) is odd, and add missing bipartite
edges until there are \(e\) edges. \(\square\)

## Exact prescribed atom-rank partition

### Theorem

Let \(\lambda=(r_1,\ldots,r_q)\) be a finite sequence of positive integers and
put

\[
 \beta=\sum_{i=1}^q r_i.
\]

There exists a connected reduced obligatory triple system of shadow order
\(s\) whose canonical cyclic atoms have rank multiset exactly
\(\{r_1,\ldots,r_q\}\) if and only if

\[
 \boxed{
 s\ge 1+\sum_{i=1}^q\bigl(1+c(r_i)\bigr).
 }
\]

When equality holds, every cyclic atom has minimum possible order and there are
no bridge atoms.  For larger \(s\), the slack can always be realized by bridge
atoms.

### Proof

Necessity follows from the additive rank law and the minimum-order lemma: a
cyclic atom of rank \(r_i\) contributes at least \(1+c(r_i)\) to \(s-1\).

Conversely, choose for every \(i\) a minimum-order 2-connected simple bipartite
graph \(J_i\) of rank \(r_i\).  Form the one-point sum of the expansions
\(J_i^+\), identifying one chosen core point from every atom.  Its cyclic atoms
are exactly the chosen expansions, and its shadow order is

\[
 1+\sum_i(1+c(r_i)).
\]

If the desired \(s\) is larger, attach exactly the difference many
single-triple atoms by one-point amalgamation.  Each bridge atom raises both
\(m\) and \(s\) by one and leaves the cycle rank and cyclic-rank multiset
unchanged. \(\square\)

### Interpretation

The theorem is an exact resource law.  The total rank \(\beta\) may be split
among canonical cyclic atoms in an arbitrary positive integer partition, but a
part of rank \(r\) costs exactly \(1+c(r)\) units of minimum shadow order.
Bridge atoms are precisely the free slack variable after those rank costs are
paid.

## Exact number of cyclic atoms

The elementary inequality

\[
 c(a)+c(b)\ge c(a+b-1)+2
 \qquad(a,b\ge1)
\]

follows from

\[
 \sqrt a+\sqrt b\ge\sqrt{a+b-1}+1,
\]

which in turn is equivalent to \((a-1)(b-1)\ge0\).  Repeatedly concentrating
two positive parts into one part and one unit shows that, among partitions of
\(\beta\) into exactly \(q\) positive parts,

\[
 \sum_{i=1}^q c(r_i)
 \ge 2(q-1)+c(\beta-q+1).
\]

Equality is attained by

\[
 (\beta-q+1,1,\ldots,1).
\]

### Corollary

If \(\beta=0\), then \(F\) has no cyclic atoms.  Let \(\beta\ge1\).  There
exists a connected reduced obligatory triple system with shadow order \(s\),
total cycle rank \(\beta\), and exactly \(q\) canonical cyclic atoms if and
only if

\[
 \boxed{
 1\le q\le\beta,
 \qquad
 s\ge 3q-1+c(\beta-q+1).
 }
\]

Equivalently, the minimum shadow order with total rank \(\beta\) fragmented
among \(q\) cyclic atoms is

\[
 s_{\min}(\beta,q)
 =3q-1+\left\lceil2\sqrt{\beta-q+1}\right\rceil.
\]

The possible values of \(q\) form an initial interval
\(1,\ldots,q_{\max}(s,\beta)\), where \(q_{\max}\) is the largest integer
satisfying the displayed inequality.

### Proof

Apply the prescribed-partition theorem and minimize its right-hand side over
all \(q\)-part partitions of \(\beta\).  The preceding inequality gives the
lower bound and the partition
\((\beta-q+1,1,\ldots,1)\) attains it.  Increasing \(s\) is handled by bridge
atoms.

Finally, the threshold is strictly increasing in \(q\): when \(q\) rises by
one, the linear term rises by three while
\(c(\beta-q+1)\) decreases by at most one.  Hence feasibility is an initial
interval. \(\square\)

## Exact total atom-count spectrum

Let \(k\) be the total number of canonical atoms, including bridge atoms.

### Theorem

For a feasible connected parameter pair \((s,\beta)\), the possible values of
\(k\) are exactly the following.

1. **Acyclic case \(\beta=0\):**

   \[
   \boxed{k=s-1.}
   \]

   Every atom is a single triple.

2. **Unicyclic case \(\beta=1\):**

   \[
   \boxed{
   1\le k\le s-3,
   \qquad
   k\equiv s+1\pmod 2.
   }
   \]

3. **Higher-rank case \(\beta\ge2\):**

   \[
   \boxed{
   1\le k\le s-1-c(\beta).
   }
   \]

Thus every integer in the allowed interval occurs once \(\beta\ge2\).  The
unicyclic parity restriction is the only gap phenomenon.

### Proof

Suppose first that \(\beta=0\).  Every atom has rank zero and is therefore a
bridge atom.  A connected shadow of rank zero is a tree, whose \(s-1\) edges
are its \(s-1\) edge blocks.

Now assume \(\beta>0\).  Let the cyclic atoms have ranks
\(r_1,\ldots,r_q\), and let \(b\) be the number of bridge atoms, so
\(k=b+q\).  From the minimum-order lemma,

\[
 s-1
 =b+\sum_{i=1}^q(v_i-1)
 \ge b+q+\sum_{i=1}^q c(r_i)
 =k+\sum_{i=1}^q c(r_i).
\]

Since

\[
 \sum_i c(r_i)\ge c\!\left(\sum_i r_i\right)=c(\beta),
\]

we obtain the universal upper bound

\[
 k\le s-1-c(\beta).
\]

If \(\beta=1\), there is exactly one cyclic atom and it has rank one.  A
2-connected graph of rank one is a cycle, and bipartiteness forces its order
\(v\) to be even.  The remaining \(s-v\) shadow vertices are supplied by
bridge atoms, so

\[
 k=1+(s-v).
\]

As \(v\) ranges over the even integers from \(4\) to the largest even integer
at most \(s\), the displayed parity progression for \(k\) is obtained.

Let \(\beta\ge2\), and choose any

\[
 1\le k\le s-1-c(\beta).
\]

Put \(v=s-k+1\).  Then \(v\ge2+c(\beta)\).  There is a 2-connected simple
bipartite graph on \(v\) vertices and of rank \(\beta\): its required edge
count is \(v-1+\beta\), which lies in the exact 2-connected bipartite edge
interval.  The lower endpoint is valid for both parities because
\(\beta\ge2\).  Expand this graph and attach \(k-1\) bridge atoms.  The result
has shadow order \(s\), rank \(\beta\), and exactly \(k\) atoms. \(\square\)

## Extremal structure and compressed consequences

### Maximum number of atoms

For every \(\beta\ge1\),

\[
 \boxed{
 k_{\max}(s,\beta)=s-1-c(\beta).
 }
\]

Moreover, every maximizer has exactly one cyclic atom; that atom has minimum
possible order \(2+c(\beta)\), and every other atom is a bridge atom.

Indeed, for positive \(a,b\),

\[
 c(a)+c(b)\ge c(a+b)+1.
\]

To see the strict unit, the function
\(\sqrt a+\sqrt b-\sqrt{a+b}\) is increasing in each variable and is
therefore at least \(2-\sqrt2>1/2\); after multiplication by two, integrality
of the ceilings supplies the extra one.  Thus two or more cyclic atoms make
\(\sum_i c(r_i)>c(\beta)\), preventing equality in the upper bound for
\(k\).  Conversely, one minimum-order rank-\(\beta\) atom plus bridge atoms
attains equality.

### Minimum number of atoms

The exact minimum is

\[
 k_{\min}(s,\beta)=
 \begin{cases}
 s-1, & \beta=0,\\
 2, & \beta=1\text{ and }s\text{ is odd},\\
 1, & \text{otherwise}.
 \end{cases}
\]

This recovers the indecomposability spectrum in cycle-rank language.  Apart
from forests, the only feasible parameter pairs that cannot be represented by
one canonical atom are odd-order unicyclic shadows.

### Rank-fragmentation penalty

A single cyclic atom of rank \(\beta\) first appears at shadow order

\[
 2+c(\beta).
\]

Forcing exactly \(q\) cyclic atoms raises the minimum to

\[
 3q-1+c(\beta-q+1).
\]

The difference

\[
 3q-3+c(\beta-q+1)-c(\beta)
\]

is the exact minimum vertex cost of fragmenting the cycle rank into \(q\)
canonical cyclic atoms.

## Examples

### Unicyclic parity

For \(s=8\) and \(\beta=1\), the unique cyclic atom is an even cycle of order
\(8\), \(6\), or \(4\).  Therefore the possible total atom counts are

\[
 k=1,3,5,
\]

and the missing values \(2,4\) are genuine.

### Four units of cycle rank

Take \(\beta=4\).  One cyclic atom requires at least

\[
 2+c(4)=6
\]

shadow vertices.  Two cyclic atoms require at least

\[
 3\cdot2-1+c(3)=9
\]

vertices, attained by atom ranks \((3,1)\).  Three cyclic atoms require at
least \(11\) vertices, and four rank-one atoms require \(13\).  Thus at
\(s=10\) the possible numbers of cyclic atoms are exactly \(1\) and \(2\).

## Algorithmic consequence

The canonical decomposition gives a linear-time certificate once the Levi
block decomposition is available.  For each cyclic block, suppress the
hyperedge-nodes and record

\[
 (v_i,e_i,\beta_i).
\]

The additive identities and the exact spectra above then provide independent
integer consistency checks for

- total shadow order;
- total cycle rank;
- cyclic-rank partition;
- number of cyclic atoms; and
- total number of atoms.

A malformed certificate cannot pass these checks merely by reproducing the
global values \((m,n)\); it must also satisfy the local square-root costs of
every cyclic atom.

## Manuscript placement

The strongest paper-level presentation is compact.

1. After the canonical atom theorem, state the additive rank law and the
   minimum-order lemma.
2. Put the exact total atom-count spectrum in the main text as the quantitative
   payoff.
3. State the cyclic-atom count formula as a corollary or short proposition.
4. Move the arbitrary prescribed-rank partition theorem and its full proof to
   an appendix if page pressure is significant.
5. Add one small diagram whose horizontal coordinate is \(\beta\) and whose
   vertical coordinate is the possible atom count \(k\); mark the parity gaps
   on the line \(\beta=1\).

This sharpens the paper without changing its main proof architecture: the
classification gives the atoms, and the present result measures exactly how
many atoms and how much cyclic complexity can occur.

## Exact finite audit

`experiments/verify_canonical_atom_rank_spectrum.py` uses only the Python
standard library.  It performs three independent checks.

1. **Exhaustive graph audit.**  It enumerates all fixed-bipartition labelled
   bipartite graphs through shadow order \(s=8\), computes their edge blocks by
   Tarjan's algorithm, and compares the observed cyclic-rank partitions,
   cyclic-atom counts, and total atom counts with the exact formulas.
2. **Constructive audit.**  It realizes every admissible total atom count and
   every admissible cyclic-atom count through \(s=40\), and every admissible
   cyclic-rank partition through \(s=16\).
3. **Arithmetic audit.**  It checks the minimum-order identity and the three
   square-root inequalities used in the proofs for ranks through \(4096\).

The committed deterministic run covers

- 108,622 labelled bipartite graphs;
- 53,510 connected graphs;
- 186,809 recovered edge blocks;
- 47,761 recovered cyclic blocks;
- 807 prescribed-rank-partition witnesses;
- 17,728 cyclic-atom-count witnesses;
- 47,767 total-atom-count witnesses; and
- 516,160 arithmetic pairs for each square-root inequality.

No mismatch occurs.

## Literature and priority boundary

Komjáth's reduction to 2-connected components and the standard block-cut
decomposition are prior work.  The current Li preprint states the obligatory
classification and explains that its selected-incidence decomposition is finer
than the block reduction.  The present formulas are elementary consequences of
the canonical atom normal form and bipartite extremal arithmetic.  A targeted
screen of the current preprint did not locate the prescribed atom-rank
partition criterion or the exact atom-count spectra.  They should therefore be
presented as new corollaries under review, not as absolute priority claims.
