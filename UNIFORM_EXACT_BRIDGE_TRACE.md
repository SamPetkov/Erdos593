# Exact arbitrary-rank bridge traces for the complete-rank one-apex lift

**Status:** complete ordinary proof draft with constructive finite checks. This
is a focused extension of the uniform forward theorem in PR #21. It is not
needed for the all-uniformity avoidance argument, but it gives the exact finite
trace class of one lift step and the exact hierarchical trace class of an
iterated lift.

## 1. Setting

Fix an integer \(s\ge2\), an infinite cardinal \(\kappa\), and a simple
\(s\)-uniform hypergraph \(H\) with at least one edge. Write
\[
T(H,\kappa)=\bigcup_{\alpha<\kappa}E(H)^\alpha.
\]
The complete-rank one-apex lift \(\operatorname{Lift}_\kappa(H)\) is the
\((s+1)\)-uniform hypergraph on \(T(H,\kappa)\times V(H)\) whose edges are
\[
\{(\sigma,x):x\in a\}\cup\{(\tau,z)\},
\tag{1.1}
\]
where
\[
\sigma\lhd\tau,
\qquad
\tau(\operatorname{lh}\sigma)=a\in E(H),
\qquad
z\in V(H).
\]
Here \(\sigma\lhd\tau\) means that \(\sigma\) is a proper initial segment of
\(\tau\). The first \(s\) points form the complete base and the last point is
the unique apex.

Let \(F\) be a finite linear \((s+1)\)-uniform hypergraph without isolated
vertices. A **bridge selector** is a map
\[
p:E(F)\longrightarrow V(F),\qquad p(e)\in e,
\]
such that every Levi incidence \(ep(e)\) is a bridge. Delete all selected
incidences. For every resulting component \(C\) containing edge-nodes, define
the \(s\)-uniform derivative \(D_C(F,p)\) by replacing each edge \(e\in C\)
with \(e\setminus\{p(e)\}\).

## 2. Main theorem

### Theorem A (exact arbitrary-rank bridge trace)

The following are equivalent.

1. \(F\hookrightarrow\operatorname{Lift}_\kappa(H)\).
2. There is a bridge selector \(p\) such that every active derivative
   \(D_C(F,p)\) embeds in \(H\).

The forward implication is the uniform one-step theorem isolated and
stress-tested in PR #21. We include its logical interface and prove the
converse explicitly.

## 3. Necessity

Suppose
\[
\varphi:F\hookrightarrow\operatorname{Lift}_\kappa(H).
\]
Every lifted edge has a unique apex. Let \(p(e)\) be its source preimage.

The uniform cycle-collapse theorem says that all connector sequence nodes on a
Berge cycle in \(F\) are equal. If \(ep(e)\) were not a bridge, it would lie on
a simple Levi cycle. At the node \(e\), that cycle would use the apex point
\(p(e)\) and one base point. Their sequence nodes are different, contradicting
cycle collapse. Hence \(p\) is a bridge selector.

After deleting the selected incidences, every surviving incidence is a base
incidence. In an active component \(C\), connectedness forces every surviving
point and every edge base to have one common sequence node \(\sigma_C\).
Second-coordinate projection is then injective on the points of \(C\), and it
maps every derivative edge onto an edge of \(H\). Two derivative edges cannot
map to the same indexed edge of \(H\), because the corresponding source edges
of \(F\) would share all \(s\ge2\) surviving points. Thus
\[
D_C(F,p)\hookrightarrow H.
\]

This proves (1)\(\Rightarrow\)(2).

## 4. Quotient forest

Let
\[
S_p=\{ep(e):e\in E(F)\}.
\]
Because every member of \(S_p\) is a bridge, contracting the components of
\(I(F)-S_p\) and retaining the selected incidences gives a finite simple
forest \(Q\). Indeed, a quotient cycle would give every selected incidence on
that cycle an alternative path in \(I(F)\).

For an edge \(e\), let \(C_e\) be the component containing its edge-node and
let \(C_{p(e)}\) be the component containing the selected point. Orient the
quotient edge from \(C_e\) to \(C_{p(e)}\). Fix an embedding
\[
\psi_C:D_C(F,p)\hookrightarrow H
\]
for every active component. Label the oriented quotient edge belonging to
\(e\) by
\[
a_e=\psi_{C_e}(e\setminus\{p(e)\})\in E(H).
\tag{4.1}
\]

## 5. Labelled-forest lemma

### Lemma 5.1

Let \(Q\) be a finite forest whose edges are oriented arbitrarily and labelled
by elements of a nonempty alphabet \(\Omega\). There are pairwise distinct
finite words
\[
(w_C:C\in V(Q))\subseteq\Omega^{<\omega}
\]
such that every oriented edge \(C\to C'\), with label \(a\), satisfies
\[
w_C\lhd w_{C'},
\qquad
w_{C'}(\operatorname{lh}w_C)=a.
\tag{5.1}
\]

#### Proof

It is enough to treat one tree. Induct on its number of vertices and remove a
leaf \(z\) with neighbour \(y\).

If the new edge is oriented \(y\to z\) and labelled \(a\), retain all old
words and set
\[
w_z=w_y\mathbin{{}^\frown}\langle a\rangle\mathbin{{}^\frown}u,
\]
where the finite padding word \(u\) is chosen so that \(w_z\) has a length
larger than every old word.

If it is oriented \(z\to y\), set \(w_z=\varnothing\) and prefix every old
word by \(\langle a\rangle\). Common prefixing preserves all old edge
conditions, while the new condition holds at coordinate zero.

For several tree components, prefix all words in successive components by a
sufficiently long common constant word so that the sets of word lengths are
disjoint. This preserves internal conditions and gives global distinctness.
\(\square\)

Apply the lemma to \(Q\) with alphabet \(E(H)\) and labels (4.1).

## 6. Constructing the lift embedding

For every point \(v\in V(F)\), let \(C(v)\) be its component in
\(I(F)-S_p\).

If \(C(v)\) is active, define
\[
\Phi(v)=(w_{C(v)},\psi_{C(v)}(v)).
\tag{6.1}
\]
A component containing no edge-node is a singleton point-node. For such a
point choose any \(b_v\in V(H)\) and define
\[
\Phi(v)=(w_{C(v)},b_v).
\tag{6.2}
\]

The map \(\Phi\) is injective. Inside an active component this follows from
injectivity of \(\psi_C\); a point-only component contains one point; and
points in different components have distinct first coordinates because all
words \(w_C\) are distinct.

Let \(e\in E(F)\). Its \(s\) unselected points lie in \(C_e\), and (6.1) maps
them to the complete edge \(a_e\) of \(H\) at node \(w_{C_e}\). The selected
point \(p(e)\) lies in \(C_{p(e)}\). By (5.1),
\[
w_{C_e}\lhd w_{C_{p(e)}},
\qquad
w_{C_{p(e)}}(\operatorname{lh}w_{C_e})=a_e.
\]
The second coordinate of the apex is unrestricted in (1.1). Therefore
\(\Phi(e)\) is exactly a lifted edge. This proves
\[
F\hookrightarrow\operatorname{Lift}_\kappa(H)
\]
and completes (2)\(\Rightarrow\)(1). \(\square\)

## 7. Isolated vertices

Every complete-rank lift is infinite when the source has an edge. Hence a
finite system embeds in the lift if and only if its isolated reduction does.
Theorem A therefore extends to arbitrary finite linear \(F\) after replacing
it by \(F^\circ\).

## 8. Exact hierarchical traces of iterated lifts

Let \(A\) be a graph and define
\[
L_2(A,\kappa)=A,
\qquad
L_{q+1}(A,\kappa)=\operatorname{Lift}_\kappa(L_q(A,\kappa)).
\]

### Corollary 8.1 (hierarchical bridge-trace certificate)

A finite linear \(r\)-uniform hypergraph \(F\) embeds in \(L_r(A,\kappa)\) if
and only if it admits an \((r-2)\)-level hierarchy with the following data at
each level:

1. one selected bridge incidence at every current hyperedge;
2. the active derivatives obtained after deleting those incidences; and
3. at the terminal level, embeddings of all graph derivatives into \(A\).

#### Proof

Apply Theorem A recursively. Necessity gives one bridge-selector layer and
source embeddings at every rank. Conversely, start with the terminal graph
embeddings and apply the sufficiency construction one level at a time.
\(\square\)

This is an exact trace theorem, not merely the necessary bridge-count and cycle
projection used in the avoidance classification.

## 9. Constructive finite validation

`experiments/exact_bridge_trace_constructor.py` independently tests the
sufficiency construction. It generates random oriented quotient trees. Every
non-sink quotient node carries a connected linear derivative embedded in a
fixed star hypergraph; every oriented tree edge is a selected bridge
incidence.

For each generated certificate, the checker:

1. verifies that the reconstructed \((s+1)\)-uniform source is linear;
2. verifies every selected incidence with a Tarjan bridge computation;
3. deletes the selected incidences and recovers the prescribed quotient tree;
4. constructs the labelled-forest words by the leaf induction in Lemma 5.1;
5. builds \(\Phi\) from (6.1)--(6.2); and
6. verifies injectivity and every lifted edge exactly.

The checked run contains 2,000 random certificates at each base rank
\(s=2,3,4,5\), for 8,000 certificates total. They use up to ten quotient
components and collectively verify 39,804 source hyperedges. Every certificate
produced a valid lift embedding.

These finite checks validate the constructor, not the transfinite theorem.

## 10. Attribution and scope

Eric Li proved the exact graph-to-triple bridge-trace theorem for the
complete-rank one-apex lift in arXiv:2606.24882. PR #21 isolates and
stress-tests the arbitrary-rank forward implication. The contribution proposed
here is the arbitrary-rank converse, its explicit labelled-forest constructor,
and the exact hierarchical trace characterization of iterated lifts.

The theorem is not needed to prove the all-uniformity obligatory-hypergraph
classification: the forward implication suffices for avoidance. Its value is a
complete description of finite linear traces of the lift, a clean target for
Lean formalisation, and a reusable interface for future exact-spectrum work.

## 11. Review boundary

Independent review should check:

1. that deleting the selected incidences gives the derivative Levi components
   used by the quotient construction;
2. the arbitrary orientation case of the labelled-forest lemma;
3. injectivity when selected points lie in active target components; and
4. the recursive formulation of the hierarchical certificate.
