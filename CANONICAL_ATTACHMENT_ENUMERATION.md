# Exact enumeration of canonical atom attachments

## Scope and counting convention

This note continues the canonical atom normal form and the shared-point
multiplicity spectrum.  It counts the **attachment geometry** of a fixed list
of canonical atoms.  It does not change the classification of obligatory
triple systems.

Fix pairwise disjoint, labelled canonical atoms

\[
A_1,\ldots,A_k.
\]

Every vertex inside every atom is also labelled.  Put

\[
w_i=|V(A_i)|,\qquad
P=\prod_{i=1}^k w_i,\qquad
R=\sum_{i=1}^k(w_i-1).
\tag{0.1}
\]

An **admissible connected attachment** is an equivalence relation on the
disjoint union of the atom vertex sets such that:

1. every non-singleton equivalence class contains vertices from at least two
   atoms and at most one vertex from each atom;
2. the non-singleton classes are the shared points; and
3. the bipartite incidence graph between atoms and shared points is a tree.

The quotient is therefore a forest assembly by one-point amalgamations, and
the original atoms remain its canonical atoms.  Conversely, every connected
forest assembly of the fixed atoms determines exactly one such equivalence
relation.

Atoms and their internal vertices remain labelled.  Shared points are **not**
given external labels: they are the actual non-singleton equivalence classes
in the quotient.  Counts are not divided by automorphism groups of the atoms
or of the resulting triple system.

Write

\[
(x)_r=x(x-1)\cdots(x-r+1),\qquad (x)_0=1
\]

for the falling factorial, and let \(S(n,t)\) denote a Stirling number of the
second kind.

## 1. Exact count by the number of shared points

Let \(N_t(\mathbf A)\) be the number of admissible connected attachments of
\(A_1,\ldots,A_k\) with exactly \(t\) shared points.

### Theorem 1 — canonical attachment formula

If \(k=1\), then \(N_0(\mathbf A)=1\) and \(N_t(\mathbf A)=0\) for \(t>0\).
If \(k\ge2\), then

\[
\boxed{
N_t(\mathbf A)
=
P\,S(k-1,t)\,(R)_{t-1}
}
\tag{1.1}
\]

for \(1\le t\le k-1\), and \(N_t(\mathbf A)=0\) otherwise.  Equivalently,

\[
N_t(\mathbf A)
=
P\,(t-1)!\,S(k-1,t)\binom{R}{t-1}.
\tag{1.2}
\]

For canonical atoms, \(w_i\ge3\), so every value \(1\le t\le k-1\) has positive
count.

#### Proof

Temporarily label the \(t\) shared-point nodes.  Let

\[
d_i=\deg(A_i),\qquad
\mu_j=\deg(p_j)
\]

in the bipartite incidence tree, and put

\[
x_i=d_i-1,\qquad y_j=\mu_j-1.
\]

The tree identities give

\[
x_i\ge0,\quad \sum_i x_i=t-1,
\qquad
y_j\ge1,\quad \sum_j y_j=k-1.
\tag{1.3}
\]

The fixed-degree Prüfer formula from the shared-point spectrum gives

\[
\frac{(t-1)!(k-1)!}
{\prod_i x_i!\prod_j y_j!}
\prod_i(w_i)_{x_i+1}
\tag{1.4}
\]

vertex-decorated trees with these degrees.

The atom-side sum is

\[
\begin{aligned}
\sum_{\substack{x_i\ge0\\\sum_i x_i=t-1}}
\prod_i\frac{(w_i)_{x_i+1}}{x_i!}
&=
P\sum_{\substack{x_i\ge0\\\sum_i x_i=t-1}}
\prod_i\binom{w_i-1}{x_i}\\
&=P\binom{R}{t-1},
\end{aligned}
\tag{1.5}
\]

by Vandermonde's identity.  The shared-point-side sum is

\[
(k-1)!
\sum_{\substack{y_j\ge1\\\sum_j y_j=k-1}}
\frac1{\prod_jy_j!}
=
t!\,S(k-1,t),
\tag{1.6}
\]

because it counts surjections from a labelled \((k-1)\)-set onto the \(t\)
labelled point nodes.

Multiplying (1.5), (1.6), and the remaining factor \((t-1)!\) from (1.4)
gives

\[
t!\,P\,(t-1)!\,S(k-1,t)\binom{R}{t-1}
\]

attachments with labelled shared-point nodes.  Forgetting those labels is
exactly \(t!\)-to-one: the point nodes are distinct non-singleton equivalence
classes.  Division by \(t!\) proves (1.1).

### Corollary 1.1 — attachment polynomial

Define

\[
\Phi_{\mathbf A}(z)=\sum_{t\ge0}N_t(\mathbf A)z^t.
\]

For \(k\ge2\),

\[
\boxed{
\Phi_{\mathbf A}(z)
=
P\sum_{t=1}^{k-1}S(k-1,t)(R)_{t-1}z^t.
}
\tag{1.7}
\]

Thus the complete attachment count depends on the atom sizes only through

\[
k,\qquad P=\prod_iw_i,\qquad R=\sum_i(w_i-1).
\tag{1.8}
\]

In particular, the internal hyperedge structures of the fixed labelled atoms
play no further role in the attachment enumeration.

### Corollary 1.2 — expression in quotient order

Every connected attachment performs exactly \(k-1\) vertex identifications.
If the resulting quotient has \(n\) vertices, then

\[
n=\sum_iw_i-k+1,\qquad R=n-1.
\tag{1.9}
\]

Hence

\[
\boxed{
N_t(\mathbf A)=P\,S(k-1,t)(n-1)_{t-1}.
}
\tag{1.10}
\]

This is independent of the multiplicity profile and of the shape of the
attachment tree.

## 2. Exact count for a prescribed multiplicity profile

Let

\[
\lambda=(\lambda_1,\ldots,\lambda_t)\vdash k-1
\]

be written in nonincreasing order.  A shared point corresponding to
\(\lambda_j\) has multiplicity \(\mu_j=\lambda_j+1\).  For \(r\ge1\), let

\[
m_r(\lambda)=|\{j:\lambda_j=r\}|.
\]

Let \(N_\lambda(\mathbf A)\) count admissible attachments whose unordered
shared-point excess profile is exactly \(\lambda\).

### Theorem 2 — profile-refined attachment formula

\[
\boxed{
N_\lambda(\mathbf A)
=
P\,(R)_{t-1}\,
\frac{(k-1)!}
{\displaystyle\prod_{j=1}^t\lambda_j!\prod_{r\ge1}m_r(\lambda)!}.
}
\tag{2.1}
\]

#### Proof

For one fixed assignment of the ordered values
\((\lambda_1,\ldots,\lambda_t)\) to labelled shared-point nodes, summing only
over the atom degrees in (1.4) gives

\[
P\,(R)_{t-1}\frac{(k-1)!}{\prod_j\lambda_j!}.
\tag{2.2}
\]

There are

\[
\frac{t!}{\prod_rm_r(\lambda)!}
\]

distinct assignments of the profile multiset to the \(t\) labelled nodes.
After summing these assignments, forget the point labels and divide by \(t!\).
This gives (2.1).

### Corollary 2.1 — recovery of Theorem 1

\[
\sum_{\substack{\lambda\vdash k-1\\\ell(\lambda)=t}}
N_\lambda(\mathbf A)=N_t(\mathbf A).
\tag{2.3}
\]

Equivalently,

\[
S(k-1,t)
=
\sum_{\substack{\lambda\vdash k-1\\\ell(\lambda)=t}}
\frac{(k-1)!}
{\displaystyle\prod_j\lambda_j!\prod_rm_r(\lambda)!}.
\tag{2.4}
\]

The right-hand side is the ordinary decomposition of a set partition count by
its block-size multiset.

## 3. Largest shared-point multiplicity

For integers \(n,t,q\ge0\), let \(S_{\le q}(n,t)\) denote the number of
partitions of an \(n\)-element labelled set into \(t\) nonempty blocks, each of
size at most \(q\).  Equivalently,

\[
S_{\le q}(n,t)
=
\frac{n!}{t!}[u^n]
\left(\sum_{r=1}^q\frac{u^r}{r!}\right)^t.
\tag{3.1}
\]

Let \(N_{t,\le M}(\mathbf A)\) count attachments with \(t\) shared points and
maximum shared-point multiplicity at most \(M\).

### Theorem 3 — restricted-Stirling refinement

\[
\boxed{
N_{t,\le M}(\mathbf A)
=
P\,(R)_{t-1}\,S_{\le M-1}(k-1,t).
}
\tag{3.2}
\]

Consequently, the number with largest multiplicity exactly \(M\) is

\[
\boxed{
N_{t,=M}(\mathbf A)
=
P\,(R)_{t-1}
\left(S_{\le M-1}(k-1,t)-S_{\le M-2}(k-1,t)\right).
}
\tag{3.3}
\]

#### Proof

Sum (2.1) over partitions of \(k-1\) into \(t\) parts, all at most \(M-1\).
The weighted profile sum is exactly the restricted Stirling number in (3.1).

The formula vanishes outside the sharp spectrum

\[
1+\left\lceil\frac{k-1}{t}\right\rceil
\le M\le k-t+1,
\tag{3.4}
\]

in agreement with the multiplicity-spectrum theorem.

## 4. Shape of the attachment polynomial

### Theorem 4 — strict log-concavity

Assume \(k\ge3\) and \(R\ge k-2\).  Then the positive coefficient sequence

\[
N_1(\mathbf A),N_2(\mathbf A),\ldots,N_{k-1}(\mathbf A)
\]

is strictly log-concave:

\[
N_t(\mathbf A)^2>N_{t-1}(\mathbf A)N_{t+1}(\mathbf A)
\qquad(1<t<k-1).
\tag{4.1}
\]

Hence the number of attachments by shared-point count is unimodal and has at
most two adjacent modes.

#### Proof

The Stirling row

\[
S(k-1,1),\ldots,S(k-1,k-1)
\]

is strictly log-concave.  One standard proof uses the Touchard polynomials

\[
B_q(z)=\sum_tS(q,t)z^t,\qquad B_{q+1}(z)=z(B_q(z)+B_q'(z)).
\]

Starting from \(B_1(z)=z\), the logarithmic-derivative interlacing argument
shows inductively that every \(B_q\) has only simple nonpositive real zeros.
Newton's inequalities then give strict log-concavity of its positive
coefficients.

The falling-factorial row is also strictly log-concave on its positive
support, since

\[
\frac{(R)_{t-1}^2}{(R)_{t-2}(R)_t}
=
\frac{R-t+2}{R-t+1}>1.
\tag{4.2}
\]

The pointwise product of two positive log-concave sequences is log-concave,
and the second factor is strict.  Multiplication by \(P>0\) does not change
the inequalities.

For canonical atoms \(w_i\ge3\), so \(R\ge2k\), and the hypothesis is automatic.

## 5. The binary endpoint and an injective-port Cayley identity

At \(t=1\), every atom meets one common shared point, so

\[
N_1(\mathbf A)=P.
\tag{5.1}
\]

At the other endpoint \(t=k-1\), every shared point has multiplicity two.
Contracting the point nodes produces an ordinary labelled tree \(T\) on the
atom labels.  Atom \(i\) must assign distinct vertices to its
\(\deg_T(i)\) incident tree edges.

### Corollary 5.1 — weighted injective-port Cayley identity

\[
\boxed{
\sum_{T\in\mathcal T_k}\prod_{i=1}^k(w_i)_{\deg_T(i)}
=
P\,(R)_{k-2}.
}
\tag{5.2}
\]

Here \(\mathcal T_k\) is the set of labelled trees on \(\{1,\ldots,k\}\).

This is the \(t=k-1\) case of Theorem 1.  It can also be proved directly from
the ordinary Prüfer code by summing the injective vertex assignments.

For comparison only, if an atom vertex were allowed to be reused by several
incident tree edges, the corresponding noninjective port model would give

\[
P\left(\sum_iw_i\right)^{k-2}=P(R+k)^{k-2}.
\tag{5.3}
\]

Thus the exact retention factor imposed by distinct attachment vertices is

\[
\frac{(R)_{k-2}}{(R+k)^{k-2}}.
\tag{5.4}
\]

The noninjective model in (5.3) is not itself a valid distinct-shared-point
hypergraph assembly; it is only a comparison count.

## 6. Large-capacity asymptotics

Fix \(k\) and let \(R\to\infty\) along any family of labelled atom lists.
For each fixed \(t\),

\[
N_t(\mathbf A)
=
P\,S(k-1,t)R^{t-1}\left(1+O_k(R^{-1})\right).
\tag{6.1}
\]

Therefore the binary endpoint \(t=k-1\) dominates the total attachment count.
For \(k\ge3\), the exact first ratio is

\[
\frac{N_{k-2}(\mathbf A)}{N_{k-1}(\mathbf A)}
=
\frac{\binom{k-1}{2}}{R-k+3}.
\tag{6.2}
\]

All lower terms are \(O_k(R^{-2})\) relative to \(N_{k-1}\).  Hence

\[
\sum_tN_t(\mathbf A)
=
P(R)_{k-2}
\left(1+\frac{\binom{k-1}{2}}{R-k+3}+O_k(R^{-2})\right),
\tag{6.3}
\]

and a uniformly chosen vertex-decorated attachment satisfies

\[
\Pr(t=k-1)
=
1-\frac{\binom{k-1}{2}}{R}+O_k(R^{-2}).
\tag{6.4}
\]

Thus high vertex capacity makes binary one-point attachments overwhelmingly
dominant, even though every higher-multiplicity profile remains feasible.

## 7. Prescribed connected components

Let \(\pi\) be a prescribed set partition of the atom labels into \(c\)
nonempty blocks.  The blocks specify which atoms belong to each connected
component.

For \(B\in\pi\), put

\[
P_B=\prod_{i\in B}w_i,\qquad R_B=\sum_{i\in B}(w_i-1),
\]

and define

\[
\Phi_B(z)=
\begin{cases}
1,&|B|=1,\\[1mm]
P_B\displaystyle\sum_{r=1}^{|B|-1}S(|B|-1,r)(R_B)_{r-1}z^r,&|B|\ge2.
\end{cases}
\tag{7.1}
\]

### Proposition 7 — componentwise factorisation

The number of forest assemblies with component partition \(\pi\) and exactly
\(t\) shared points is

\[
\boxed{[z^t]\prod_{B\in\pi}\Phi_B(z).}
\tag{7.2}
\]

If only the number \(c\) of connected components is prescribed, sum (7.2)
over all set partitions \(\pi\) of \(\{1,\ldots,k\}\) into \(c\) blocks.

#### Proof

Attachments in distinct components use disjoint atom sets and make independent
vertex choices, so their generating polynomials multiply.  Conversely, the
connected components of an assembly recover the unique atom-label partition
\(\pi\), so no assembly is counted twice.

The quotient order is

\[
n=\sum_iw_i-k+c,
\tag{7.3}
\]

because the incidence forest makes exactly \(k-c\) vertex identifications.
Thus changing the attachment profile preserves \(n\), the number of
hyperedges, the shadow order, the total cycle rank, \(c\), and \(k\).

## 8. Relevance to the Erdős 593 paper

The previous spectra answer which canonical atom counts and shared-point
multiplicity profiles are possible.  The present formula answers the next
enumerative question:

> For a fixed labelled atom list, how many distinct capacity-respecting
> quotient assemblies realise each attachment complexity?

The answer is governed by Stirling numbers and one falling factorial:

\[
N_t
=
\left(\prod_i|V(A_i)|\right)
S(k-1,t)
\left(\sum_i(|V(A_i)|-1)\right)_{t-1}.
\]

This formula is compact enough for a supplement or a short enumerative
subsection.  The profile-refined and restricted-multiplicity formulas are
better placed in an appendix.

## 9. Non-goals

This note does not:

- alter the classification of obligatory triple systems;
- count unlabelled hypergraph isomorphism classes;
- quotient by automorphisms of repeated or symmetric atoms;
- count construction histories;
- claim that the noninjective comparison model is a valid attachment model;
- enumerate possible canonical atom isomorphism types of a given order;
- strengthen the infinitary avoiding-host argument; or
- add a Lean theorem.

The formulas count quotient equivalence relations on a fixed disjoint union of
labelled atom vertices.  This precise convention is essential.
