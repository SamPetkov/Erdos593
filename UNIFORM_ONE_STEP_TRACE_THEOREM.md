# Uniform one-step bridge-trace theorem

**Status:** complete ordinary proof draft with exhaustive finite adversarial
testing; stacked on the iterated-avoidance research branch. This note isolates
the load-bearing one-step statement. It is not yet independently refereed and
is not part of the Problem 593 publication manuscript.

## 1. Construction

Fix a simple $s$-uniform hypergraph $H$, where $s\ge 2$, and an infinite
cardinal $\kappa$. Let

$$
T(H,\kappa)=\bigcup_{\alpha<\kappa}E(H)^\alpha .
$$

Elements of $T(H,\kappa)$ are transfinite sequences of indexed edges of $H$,
of ordinal length below $\kappa$. Write $\sigma\lhd\tau$ when $\sigma$ is a
proper initial segment of $\tau$.

The **complete-rank one-apex lift** $\operatorname{Lift}_\kappa(H)$ has vertex
set $T(H,\kappa)\times V(H)$. For $\sigma\lhd\tau$, put

$$
a=\tau(\operatorname{lh}\sigma)\in E(H).
$$

For every $z\in V(H)$, include the $(s+1)$-edge

$$
\widehat e(\sigma,\tau,z)
 =\{(\sigma,x):x\in a\}\cup\{(\tau,z)\}.
\tag{1.1}
$$

The $s$ points at $\sigma$ are the **base** and $(\tau,z)$ is the **apex**.

### Lemma 1.1: uniformity and simplicity

$\operatorname{Lift}_\kappa(H)$ is a simple $(s+1)$-uniform hypergraph.

#### Proof

The base contains exactly $s$ distinct points. The apex is not a base point
because $\sigma\ne\tau$, so (1.1) has $s+1$ points.

The edge set recovers all of its indexing data. Since $s\ge2$, the sequence
node occurring on at least two vertices is the base node $\sigma$; the other
sequence node is $\tau$. The second coordinates at $\sigma$ recover the base
edge $a$, and simplicity of $H$ recovers its edge index. The second coordinate
at $\tau$ recovers $z$. Thus equal lifted edge sets have equal indexing data.
$\square$

The condition $s\ge2$ is essential for this intrinsic base/apex distinction.

## 2. Chromatic preservation

### Theorem 2.1

If $\chi(H)=\kappa$, then

$$
\chi(\operatorname{Lift}_\kappa(H))=\kappa.
\tag{2.1}
$$

#### Proof

A proper $\kappa$-colouring $d$ of $H$ gives a proper colouring of the lift by
$(\sigma,x)\mapsto d(x)$, because every lifted edge contains a complete edge
of $H$ in its base.

Conversely, suppose that the lift has a proper colouring $c$ with a colour set
of cardinality $\theta<\kappa$. Recursively construct $t\in E(H)^\kappa$.
At stage $\alpha$, the slice

$$
x\longmapsto c(t\restriction\alpha,x)
$$

uses fewer than $\kappa$ colours and is not a proper colouring of $H$. Choose
an edge $t(\alpha)$ whose entire slice is monochromatic, and write $d_\alpha$
for that colour. Since $\theta<\kappa$, the map $\alpha\mapsto d_\alpha$ is
not injective. Choose $\alpha<\beta<\kappa$ with $d_\alpha=d_\beta$, and
choose $z\in t(\beta)$. Then

$$
\{(t\restriction\alpha,x):x\in t(\alpha)\}
 \cup\{(t\restriction\beta,z)\}
$$

is a lifted edge: the value of $t\restriction\beta$ at coordinate $\alpha$ is
$t(\alpha)$. Its base has colour $d_\alpha$, while its apex has colour
$d_\beta=d_\alpha$, a contradiction. No regularity or cofinality property of
$\kappa$ is used. $\square$

## 3. Prefix-chain lemma

### Lemma 3.1

Let $\rho_0,\rho_1,\ldots,\rho_m$ be transfinite sequences such that
consecutive terms are comparable in the initial-segment order. Suppose every
term has length at least $d$, $\operatorname{lh}(\rho_0)=d$, and $\rho_i$
extends $\rho_0$. Then $\rho_{i+1}$ also extends $\rho_0$.

#### Proof

If $\rho_i$ is a prefix of $\rho_{i+1}$, this is immediate. Otherwise
$\rho_{i+1}$ is a prefix of $\rho_i$. Its length is at least $d$, and
$\rho_i$ extends the length-$d$ sequence $\rho_0$, so this prefix also extends
$\rho_0$. $\square$

Thus a cyclic chain of consecutively comparable nodes is contained above any
node of minimum length.

## 4. Uniform cycle collapse

Let $F$ be a finite linear $(s+1)$-uniform hypergraph and let

$$
\varphi:F\hookrightarrow\operatorname{Lift}_\kappa(H)
$$

be an injective non-induced embedding. Write
$\varphi(v)=(\nu(v),\xi(v))$.

### Theorem 4.1: cycle collapse

On every Berge cycle

$$
v_0,e_0,v_1,e_1,\ldots,v_{m-1},e_{m-1},v_0
\tag{4.1}
$$

of $F$, all connector nodes $\nu(v_0),\ldots,\nu(v_{m-1})$ are equal.

#### Proof

The two connectors belonging to one lifted edge have equal or comparable
nodes: they are either both base points, or one is a base point and the other
is the unique apex. Choose a connector node $\sigma$ of minimum ordinal length
$d$. Lemma 3.1, applied while traversing the cycle, shows that every connector
node extends $\sigma$. Every connector node of length $d$ is therefore exactly
$\sigma$.

Assume that some connector node properly extends $\sigma$. In cyclic order,
choose a maximal nonempty interval $\tau_1,\ldots,\tau_t$ of connector nodes
properly above $\sigma$, bounded at each end by a connector at $\sigma$. The
two boundary connectors at $\sigma$ may be the same connector occurrence.
This covers the case in which the minimum node occurs only once; the two
boundary hyperedges are still distinct because a Berge cycle has distinct
hyperedges and length at least three.

Consecutive $\tau_i$ are comparable and all extend $\sigma$. Hence they have
one common value at coordinate $d$; call that edge of $H$ $a$.

At the first boundary hyperedge, the connector at $\tau_1$ is the apex and the
connector at $\sigma$ is a base point. Therefore the image of that source edge
contains the complete $s$-point base

$$
B=\{(\sigma,x):x\in a\}.
$$

The return boundary hyperedge has the same base $B$, because
$\tau_t(d)=a$. The two boundary source edges are distinct, and injectivity of
$\varphi$ gives a unique source preimage for every point of $B$. Thus the two
source edges share all $s$ corresponding source points. Since $s\ge2$, this
contradicts linearity. No connector node properly extends $\sigma$.
$\square$

The proof permits arbitrary proper-prefix rank jumps; it does not reduce the
lift to immediate extensions.

## 5. Selected apex incidences

For each source edge $e$, its image has a unique apex. Let $p(e)$ be the source
point mapped to that apex.

### Lemma 5.1

The Levi incidence $ep(e)$ is a bridge of $I(F)$.

#### Proof

An actual edge of a finite graph is a nonbridge if and only if it belongs to a
simple cycle. If $ep(e)$ were a nonbridge, a simple Levi cycle containing it
would give a Berge cycle in $F$. At the hyperedge-node $e$, one connector
would be $p(e)$, whose image has the apex node, and the other connector would
be a base point of $\varphi(e)$, whose image has the base node. These nodes are
distinct, contradicting Theorem 4.1. $\square$

Hence $p$ is a bridge selector.

## 6. Derivative components

Delete every selected incidence $ep(e)$ from $I(F)$. Let $C$ be a component
containing at least one hyperedge-node. Replace each source edge in $C$ by its
$s$ surviving points; call the resulting $s$-uniform system $D_C$.

### Lemma 6.1

There is an embedding $D_C\hookrightarrow H$.

#### Proof

All surviving points of a source edge are mapped to the base node of its
lifted image. Two edge-nodes adjacent through a surviving point therefore have
equal base nodes. Connectedness of $C$ yields one common node $\sigma_C$ for
every surviving point and every edge base in $C$.

Map a source point $v\in C$ to its second coordinate $\xi(v)$. This map is
injective: every relevant lift point has first coordinate $\sigma_C$, and
$\varphi$ is injective.

The surviving points of each edge map onto one edge of $H$. If two different
derivative edge indices mapped to the same indexed edge of $H$, their $s$
surviving image points would coincide. Injectivity on vertices would make the
two source edges share $s\ge2$ points, contradicting linearity. Thus edge
indices are also injected. $\square$

### Lemma 6.2: length-preserving cycle descent

Every Berge cycle in $F$ survives the selected-incidence deletion, lies in one
active component $C$, and becomes a Berge cycle of the same length in $D_C$.
Under Lemma 6.1 it becomes a Berge cycle of the same length in $H$.

#### Proof

A bridge is absent from every simple Levi cycle, so none of the displayed
cycle incidences is selected. The displayed Levi cycle survives and lies in
one component. Its connector point-nodes and edge-nodes remain distinct. The
derivative embedding is injective on both, so the same alternating sequence
remains a Berge cycle with unchanged length. $\square$

## 7. One-step theorem

### Theorem 7.1: uniform forward bridge trace

Let $H$ be a simple $s$-uniform hypergraph with $s\ge2$, and let $F$ be a
finite linear $(s+1)$-uniform hypergraph embedded in
$\operatorname{Lift}_\kappa(H)$. Then there is a bridge selector $p$ such
that:

1. every active derivative $D_C(F,p)$ embeds in $H$;
2. every Berge cycle of $F$ descends to a Berge cycle of the same length in
   one derivative and then in $H$.

Only this forward theorem is required for avoidance. No converse trace
classification is used.

## 8. Iteration

Starting from a graph $A$ with $\chi(A)=\kappa$, define

$$
L_2(A,\kappa)=A,\qquad
L_{q+1}(A,\kappa)=\operatorname{Lift}_\kappa(L_q(A,\kappa)).
$$

Theorem 2.1 gives $\chi(L_q(A,\kappa))=\kappa$.

Apply Theorem 7.1 successively. At each level every source edge receives one
new selected apex bridge. A bridge in a derivative component persists as a
bridge in the original finite Levi graph: otherwise an original cycle through
that edge would avoid all already selected bridges and remain inside the
component. Thus every finite linear $q$-uniform trace in $L_q(A,\kappa)$ has
at least $q-2$ incident bridges at every hyperedge-node, and every Berge cycle
projects length-preservingly to an ordinary cycle in $A$.

This is the forward interface used by the $r\ge4$ avoidance draft.

## 9. Adversarial finite search

`experiments/cycle_collapse_adversary.py` enumerates Berge cycles directly,
rather than sampling arbitrary finite traces. It uses complete-rank finite
lifts containing all proper-prefix pairs and checks pairwise linearity before
accepting a cycle.

The checked search covers graph bases $K_3,C_4$, a depth-three lift of $K_3$,
three-uniform bases $C_3^{(3)},C_4^{(3)}$, cycle lengths three and four, and
both immediate and non-immediate proper-prefix jumps. For every cycle it
checks connector-node collapse, base-node agreement, injective
length-preserving projection, and exclusion of selected apices from the
connector set. The committed JSON contains the exact counts. These
computations are adversarial evidence only.

## 10. Attribution and source boundary

The graph-to-triple complete-rank one-apex lift, its chromatic-preservation
argument, and the original cycle-collapse/bridge-trace mechanism are due to
Eric Li:

- Eric Li, *A Resolution of Erdős Problems 593 and 1177: Obligatory Triple
  Systems and Exact Spectra*, arXiv:2606.24882, Sections 3--4.

The contribution investigated here is the uniform $s\to s+1$ statement and
its iteration. Reiher's positive all-uniformity theorem is the complementary
source interface:

- Christian Reiher, *Obligatory Hypergraphs*, arXiv:2403.11223, Theorem 1.2
  and the closure discussion.

A targeted search did not locate the uniform one-step theorem or the iterated
classification. This is a source screen, not an absolute priority claim.

## 11. Remaining review gates

Before using Theorem 7.1 in a publication claim:

1. independently verify the prefix-chain and unique-minimum boundary case;
2. verify the finite nonbridge/cycle equivalence in the exact Levi convention;
3. check derivative edge-index injectivity and points that are an apex in one
   edge and a base point in another;
4. formalise the one-step lift and cycle-collapse theorem in Lean;
5. perform an independent literature and attribution review.
