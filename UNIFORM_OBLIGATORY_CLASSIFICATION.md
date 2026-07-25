# An iterated one-apex classification of obligatory uniform hypergraphs

**Status:** complete ordinary-mathematics proof draft, stacked on the finite
bridge-block theorem. The argument has passed finite model checks but has not
yet received independent specialist review or Lean formalisation.

## 1. Main result

Fix an integer \(r\ge 2\). For a finite graph \(J\), write \(J^{(r)}\) for the
\(r\)-uniform expansion obtained by adjoining \(r-2\) new private vertices to
each graph edge. Let \(\mathcal B_r\) be the smallest class of finite
\(r\)-uniform hypergraphs that

1. contains \(J^{(r)}\) for every finite bipartite graph \(J\);
2. contains all finite edgeless systems; and
3. is closed under finite disjoint unions and one-point amalgamations.

For a finite hypergraph \(F\), let \(F^\circ\) be obtained by deleting all
isolated vertices.

### Theorem A (uniform obligatory-hypergraph classification)

For every finite simple \(r\)-uniform hypergraph \(F\), the following are
equivalent.

1. \(F\) occurs in every \(r\)-uniform hypergraph of uncountable chromatic
   number.
2. \(F^\circ\in\mathcal B_r\).
3. \(F^\circ\) is linear, every hyperedge-node of its Levi graph is incident
   with at least \(r-2\) bridges, and every Berge cycle of \(F^\circ\) has even
   length.

For \(r=2\), this is the Erdős--Hajnal characterization of obligatory graphs.
For \(r=3\), it is the classification proved by Eric Li and independently
implemented and formalised in this repository. The new step is that the
one-apex trace mechanism is rank-free and can be iterated.

The finite equivalence between (2) and (3) is proved in
`UNIFORM_BRIDGE_BLOCK_THEOREM.md`. The purpose of this note is to prove the
remaining infinitary avoidance direction for every finite uniformity.

## 2. Closure under one-point amalgamation

The positive direction uses Reiher's theorem that every uncountably chromatic
\(r\)-uniform hypergraph contains the \(r\)-uniform expansion of every finite
complete bipartite graph. Hence it contains \(J^{(r)}\) for every finite
bipartite graph \(J\). We record the closure argument because it is independent
of the uniformity.

### Lemma 2.1 (finite deletion)

If \(H\) has uncountable chromatic number and \(S\subseteq V(H)\) is finite,
then \(H-S\) has uncountable chromatic number.

Indeed, a countable colouring of \(H-S\), together with finitely many new
colours for \(S\), would countably colour \(H\).

### Lemma 2.2 (rooted abundance)

Let \(F\) be a finite obligatory \(r\)-uniform hypergraph and fix
\(x\in V(F)\). If \(H\) has uncountable chromatic number, let \(R(F,x;H)\) be
the set of vertices \(v\in V(H)\) such that, for every finite
\(S\subseteq V(H)\setminus\{v\}\), there is an embedding
\(\varphi:F\hookrightarrow H\) with
\[
\varphi(x)=v,\qquad
\varphi(V(F))\cap S=\varnothing.
\]
Then \(H-R(F,x;H)\) is countably chromatic.

#### Proof

Put \(B=V(H)\setminus R(F,x;H)\). For each \(v\in B\), choose a finite set
\(S_v\subseteq V(H)\setminus\{v\}\) meeting every copy of \(F\) rooted at
\(v\). Form a directed graph on \(B\) with arcs \(v\to s\) for
\(s\in S_v\cap B\). It has finite outdegree.

Its underlying undirected graph is countably colourable. To see this, partition
\(B\) according to an upper bound \(n\) on the outdegree. In every finite
subgraph of the \(n\)-th part, the number of undirected edges is at most
\(n\) times the number of vertices. Hence each finite subgraph is
\(2n\)-degenerate and \((2n+1)\)-colourable. Compactness gives the same finite
bound for the full \(n\)-th part, and the countable union is countably
colourable.

Let \(C\) be an independent colour class of this auxiliary graph. If \(H[C]\)
contained a copy of \(F\), and \(v\in C\) were the image of \(x\), that copy
would have to meet \(S_v\). But \(S_v\cap C=\varnothing\), a contradiction.
Thus \(H[C]\) is \(F\)-free. Since \(F\) is obligatory, \(H[C]\) is countably
chromatic. Taking countably many such classes proves that \(H[B]\) is
countably chromatic. \(\square\)

### Corollary 2.3 (one-point closure)

The one-point amalgamation of two finite obligatory \(r\)-uniform hypergraphs
is obligatory.

#### Proof

Let \((F_0,x_0)\) and \((F_1,x_1)\) be rooted obligatory systems in an
uncountably chromatic host \(H\). Put
\[
R_i=R(F_i,x_i;H).
\]
By Lemma 2.2, both complements \(V(H)\setminus R_i\) are countably chromatic.
If \(R_0\cap R_1=\varnothing\), their union would countably colour \(H\), a
contradiction. Choose \(v\in R_0\cap R_1\). First embed \(F_0\) rooted at \(v\).
Then use the abundance of \(v\) for \(F_1\) to embed \(F_1\) rooted at \(v\)
while avoiding the other vertices of the first copy. The two copies meet
exactly at \(v\). \(\square\)

Finite disjoint-union closure follows by successively embedding the factors
after finite deletion. Reiher's expansion theorem and these closure lemmas
therefore show that every member of \(\mathcal B_r\) is obligatory.

## 3. The arbitrary-rank one-apex lift

The construction below is the rank-\(q\) version of Li's complete-rank
one-apex lift. The proof of the triple-system bridge-trace theorem uses only
that the base contains at least two vertices, so it extends without change in
substance.

Let \(H\) be a simple \(q\)-uniform hypergraph, where \(q\ge 2\), and let
\(\kappa\) be infinite. Put
\[
T(H,\kappa)=\bigcup_{\alpha<\kappa}E(H)^\alpha.
\]

### Definition 3.1

The **one-apex lift**
\[
\operatorname{Lift}(H,\kappa)
\]
is the \((q+1)\)-uniform hypergraph on
\[
T(H,\kappa)\times V(H)
\]
whose edges are
\[
\{(\sigma,x):x\in a\}\cup\{(\tau,z)\},
\tag{3.1}
\]
where
\[
\sigma\subsetneq\tau,\qquad
\tau(\operatorname{lh}(\sigma))=a\in E(H),\qquad
z\in V(H).
\]
The \(q\) vertices at node \(\sigma\) form the base and \((\tau,z)\) is the
unique apex.

### Theorem 3.2 (chromatic preservation)

If \(\chi(H)=\kappa\), then
\[
\chi(\operatorname{Lift}(H,\kappa))=\kappa.
\]

#### Proof

A proper \(\kappa\)-colouring of \(H\), applied to the second coordinate,
properly colours the lift because every lifted edge contains a full source
edge in its base.

Conversely, suppose
\[
c:T(H,\kappa)\times V(H)\longrightarrow\theta,
\qquad \theta<\kappa.
\]
Recursively construct \(t\in E(H)^\kappa\). At stage \(\alpha\), the map
\[
x\longmapsto c(t\mathbin{\upharpoonright}\alpha,x)
\]
is not a proper \(\theta\)-colouring of \(H\). Choose a source edge
\(t(\alpha)\) monochromatic in a colour \(d_\alpha\). Since
\(\theta<\kappa\), there are \(\alpha<\beta<\kappa\) with
\(d_\alpha=d_\beta\). Choose \(z\in t(\beta)\). The lifted edge with base
\(t(\alpha)\) at node \(t\mathbin{\upharpoonright}\alpha\) and apex
\((t\mathbin{\upharpoonright}\beta,z)\) is monochromatic, a contradiction.
No cofinality assumption on \(\kappa\) is used. \(\square\)

## 4. Rank-free bridge traces

Let \(F\) be a finite linear \((q+1)\)-uniform hypergraph and let
\[
\varphi:F\hookrightarrow\operatorname{Lift}(H,\kappa).
\]
Write
\[
\varphi(v)=(\nu(v),a(v)).
\]

### Lemma 4.1 (cycle collapse)

On every Berge cycle of \(F\), all connector vertices have the same sequence
node under \(\nu\).

#### Proof

Consecutive connector nodes are equal or comparable in the initial-segment
order, because they lie in a lifted edge whose node multiset consists of
\(q\) copies of one source node and one proper extension.

Choose a connector node \(\sigma\) of minimum length \(d\). Traversing the
cycle shows that every connector node extends \(\sigma\). Suppose some
connector properly extends it. Choose a maximal cyclic interval
\[
\sigma,\tau_1,\ldots,\tau_s,\sigma
\]
whose internal nodes properly extend \(\sigma\). Consecutive internal nodes
are comparable, so all \(\tau_i\) have the same value
\[
b=\tau_i(d)\in E(H)
\]
at coordinate \(d\).

At each boundary hyperedge, the connector with node \(\tau_i\) is the unique
apex, while the connector at \(\sigma\) is one of the \(q\) base vertices.
Both boundary hyperedges therefore contain the same full host base
\[
\{(\sigma,x):x\in b\}.
\]
The boundary hyperedges are distinct, but injectivity of \(\varphi\) gives a
unique source preimage for each host base vertex. Hence the two source
hyperedges share all \(q\ge2\) of those vertices, contradicting linearity.
\(\square\)

### Definition 4.2 (rank-\(q\) derivative)

A bridge selector for a finite \((q+1)\)-uniform hypergraph \(F\) is a map
\[
p:E(F)\longrightarrow V(F),\qquad p(e)\in e,
\]
such that every Levi incidence \(ep(e)\) is a bridge. Delete all selected
incidences. For every resulting component \(C\) containing hyperedge-nodes,
define the \(q\)-uniform derivative \(D_C(F,p)\) by replacing each
\(e\in C\) with
\[
e\setminus\{p(e)\}.
\]

### Theorem 4.3 (arbitrary-rank bridge-trace theorem)

Let \(F\) be finite, linear, without isolated vertices, and with at least one
edge. Then
\[
F\hookrightarrow\operatorname{Lift}(H,\kappa)
\]
if and only if \(F\) has a bridge selector \(p\) such that every derivative
\(D_C(F,p)\) embeds in \(H\).

#### Necessity

For each source edge \(e\), select the preimage \(p(e)\) of its unique lifted
apex. If the incidence \(ep(e)\) lay on a Levi cycle, that cycle would use
the apex and a base vertex at \(e\). Lemma 4.1 would force their sequence
nodes to be equal, contrary to the strict prefix relation. Thus every selected
incidence is a bridge.

After deleting these incidences, every surviving incidence is a base
incidence. Along an active component all point vertices therefore have one
common sequence node. Projection to the second coordinate is injective there
and sends every derivative edge to an edge of \(H\). Two derivative edges
cannot collapse to the same source edge, because then the corresponding
source hyperedges of \(F\) would share \(q\ge2\) vertices. Hence each
derivative embeds in \(H\).

#### Sufficiency

Suppose the derivatives embed in \(H\). Contract the components obtained after
deleting the selected bridges. The quotient is a forest. Orient the quotient
edge corresponding to \(ep(e)\) from the component containing \(e\) towards
the component containing \(p(e)\), and label it by the image in \(H\) of
\(e\setminus\{p(e)\}\).

The labelled-forest lemma used in the triple case is independent of the rank:
one can assign distinct finite words \(w_C\in E(H)^{<\omega}\) to the quotient
components so that every oriented edge \(C\to C'\), labelled by \(a\in E(H)\),
satisfies
\[
w_C\subsetneq w_{C'},\qquad
w_{C'}(\operatorname{lh}(w_C))=a.
\]
Map point vertices in an active component by the derivative embedding at node
\(w_C\), and map point-only components using arbitrary second coordinates.
Equation (3.1) is then satisfied edge by edge, giving an embedding into the
lift. \(\square\)

### Corollary 4.4 (cycle projection)

Every Berge cycle in a finite linear trace of
\(\operatorname{Lift}(H,\kappa)\) projects, preserving its length, to a Berge
cycle in \(H\).

Indeed, Lemma 4.1 puts all connector vertices at one source node. They are
therefore base vertices in every cycle hyperedge, and second-coordinate
projection gives the source cycle.

## 5. Iterating the lift

Let \(A\) be a graph with \(\chi(A)=\kappa\). Define
\[
L_2(A,\kappa)=A,
\qquad
L_{s+1}(A,\kappa)
 =\operatorname{Lift}(L_s(A,\kappa),\kappa)
\quad(s\ge2).
\]

### Lemma 5.1 (bridge inheritance)

Let \(S\) be a set of bridges in a finite graph \(G\), and let \(C\) be a
component of \(G-S\). If an edge is a bridge of \(G[C]\), then it is a bridge
of \(G\).

If it were not, it would lie on a cycle of \(G\). A cycle contains no bridge
from \(S\), so the whole cycle would lie in \(C\), contradicting that it is a
bridge of \(G[C]\).

### Theorem 5.2 (iterated trace theorem)

For every \(s\ge2\):

1. \(\chi(L_s(A,\kappa))=\kappa\);
2. every edge-node of every finite linear \(s\)-uniform subhypergraph of
   \(L_s(A,\kappa)\) is incident with at least \(s-2\) bridges; and
3. every Berge cycle in such a finite trace projects, preserving length, to an
   ordinary cycle in \(A\).

#### Proof

Chromatic preservation follows by iterating Theorem 3.2. The other statements
are proved simultaneously by induction on \(s\). The case \(s=2\) is
immediate.

Apply Theorem 4.3 at the top lift level. It supplies one apex bridge at each
hyperedge and sends each active derivative component into
\(L_{s-1}(A,\kappa)\). By induction, each derivative edge has at least
\(s-3\) further bridge incidences. Lemma 5.1 shows that these remain bridges
in the original Levi graph. Together with the apex bridge, this gives
\(s-2\).

Every Levi cycle avoids the selected apex bridges and lies in one derivative
component. Corollary 4.4 sends it, with unchanged length, one rank lower.
Iteration ends at an ordinary cycle in \(A\). \(\square\)

Equivalently, the finite linear traces of \(L_s(A,\kappa)\) admit an
\((s-2)\)-stage hierarchical bridge peeling whose terminal graph derivatives
embed in \(A\).

## 6. Three avoidance hosts

We now prove the contrapositive of Theorem A(1)\(\Rightarrow\)(3).

### 6.1 Nonlinearity

For \(r\ge3\), put
\[
\lambda_r=\exp_{r-2}(\aleph_0)^+,
\]
where \(\exp_0(\mu)=\mu\) and
\(\exp_{j+1}(\mu)=2^{\exp_j(\mu)}\). Define the \(r\)-uniform boundary
hypergraph \(\partial_r(\lambda_r)\) by
\[
V(\partial_r(\lambda_r))=[\lambda_r]^{r-1}
\]
and, for each \(X\in[\lambda_r]^r\), the hyperedge
\[
\partial X=[X]^{r-1}.
\]

This hypergraph is linear. If \(\partial X\) and \(\partial Y\) shared two
distinct \((r-1)\)-sets \(P,Q\), then
\[
X=P\cup Q=Y.
\]

It is uncountably chromatic. Given a countable colouring of
\([\lambda_r]^{r-1}\), the Erdős--Rado relation
\[
\exp_{r-2}(\aleph_0)^+
 \longrightarrow(\aleph_1)^{r-1}_{\aleph_0}
\]
gives an uncountable homogeneous set. The boundary of any \(r\)-subset of it
is a monochromatic hyperedge.

Consequently every nonlinear finite \(r\)-uniform hypergraph is avoided by an
uncountably chromatic linear \(r\)-uniform host. For \(r=2\), distinct simple
graph edges cannot share two vertices.

### 6.2 Too few bridges

Let \(F\) be finite, linear, and suppose some hyperedge-node of \(I(F^\circ)\)
has fewer than \(r-2\) incident bridges. Take
\[
A=K_{\omega_1}.
\]
Then \(L_r(A,\omega_1)\) is uncountably chromatic, while Theorem 5.2 says that
every edge-node in every finite linear trace has at least \(r-2\) incident
bridges. Hence \(F^\circ\), and therefore \(F\), does not embed.

More generally, replacing \(\omega_1\) by any uncountable cardinal \(\kappa\)
gives an exact-\(\kappa\)-chromatic avoiding host.

### 6.3 An odd Berge cycle

Let \(F\) be finite and linear and suppose \(F^\circ\) contains an odd Berge
cycle of length \(\ell\). For any prescribed uncountable cardinal \(\kappa\),
the Erdős--Hajnal high-odd-girth theorem gives a graph \(A\) with
\[
|V(A)|=\chi(A)=\kappa
\]
and no odd cycle of length at most \(\ell\). The iterated lift
\(L_r(A,\kappa)\) has chromatic number exactly \(\kappa\). If \(F\) embedded,
Theorem 5.2 would project its odd Berge cycle to an ordinary odd cycle of the
same length in \(A\), a contradiction.

Thus every linear failure of the intrinsic criterion has an
exact-\(\kappa\)-chromatic avoiding host for every uncountable \(\kappa\).

## 7. Proof of Theorem A

The finite bridge-block theorem gives
\[
F^\circ\in\mathcal B_r
\quad\Longleftrightarrow\quad
\begin{cases}
F^\circ\text{ is linear},\\
\text{every edge-node has at least }r-2\text{ bridge incidences},\\
\text{every Berge cycle is even}.
\end{cases}
\]

Every member of \(\mathcal B_r\) is obligatory by Reiher's expansion theorem,
finite disjoint-union closure, and Corollary 2.3.

Conversely, if one of the three intrinsic conditions fails, one of the hosts
in Section 6 is uncountably chromatic and avoids \(F^\circ\). Since an infinite
host contains \(F\) if and only if it contains \(F^\circ\), the original
system is non-obligatory. This proves all equivalences. \(\square\)

## 8. Consequences

### Corollary 8.1 (exact finite parameters for obligatory systems)

Let \(m\ge1\), \(1\le c\le m\), and \(r\ge2\). An obligatory finite
\(r\)-uniform hypergraph without isolated vertices exists with \(m\)
hyperedges, \(n\) vertices, and exactly \(c\) connected Levi components if and
only if
\[
\boxed{
(r-2)m+2(c-1)+\left\lceil2\sqrt{m-c+1}\right\rceil
\le n\le
(r-1)m+c.
}
\]
Every integer in the interval occurs.

This upgrades the parameter theorem in `UNIFORM_BRIDGE_BLOCK_THEOREM.md` from
the generated class to the full obligatory class.

### Corollary 8.2 (uniform recognition)

For fixed \(r\), obligatory finite \(r\)-uniform hypergraphs can be recognized
with a certificate in time linear in the incidence size, after the
\(O(mr^2)\) linearity check:

1. compute all Levi bridges;
2. verify the \(r-2\) bridge lower bound at each edge-node;
3. delete all bridges;
4. suppress degree-two edge-nodes in active components;
5. verify that every resulting core graph is bipartite.

### Corollary 8.3 (linear exact-spectrum dichotomy)

If a finite linear \(r\)-uniform hypergraph is not obligatory, then for every
uncountable cardinal \(\kappa\) there is an exact-\(\kappa\)-chromatic
\(r\)-uniform hypergraph avoiding it.

The nonlinear exact-cardinal calibration is a separate question and is not
claimed here.

## 9. Computational checks

`experiments/iterated_lift_trace.py` constructs finite truncations of the
arbitrary-rank lift and checks:

- every linear trace with at most four edges in a rank-three lift of \(K_2\);
- every linear trace with at most three edges in the iterated rank-four lift;
- accumulation of one guaranteed bridge per lift level;
- absence of Berge cycles over the acyclic base \(K_2\); and
- all 1,809 Berge triangles in a finite rank-three lift of \(C_3\); and
- all 216 Berge triangles in a finite rank-four lift of the 3-uniform
  expansion \(C_3^{(3)}\), verifying again that connector nodes collapse and
  cycles project to the source triangle.

These are finite sanity checks, not a substitute for the proof.

## 10. Literature and attribution boundary

The rank-three complete-rank one-apex lift and exact bridge-trace theorem are
due to Eric Li, *A Resolution of Erdős Problems 593 and 1177: Obligatory Triple
Systems and Exact Spectra*, arXiv:2606.24882. The present argument observes
that the definitions and proofs are rank-free and may be iterated.

The positive expansion theorem is Christian Reiher, *Obligatory Hypergraphs*,
arXiv:2403.11223, Theorem 1.2. The odd-cycle host is the Erdős--Hajnal
high-odd-girth theorem, quoted as Theorem C in Erdős--Galvin--Hajnal (1975).
The nonlinear boundary construction uses the Erdős--Rado partition theorem.

A targeted search did not locate the arbitrary-rank bridge-trace theorem, its
iteration, or the resulting full uniform classification. This is a source
screen rather than an absolute priority claim.

## 11. Review boundary

Before manuscript integration, the following points should receive independent
checking:

1. the rank-free cycle-collapse argument;
2. bridge inheritance through iterated derivatives;
3. the rooted-abundance proof of one-point closure;
4. the precise Erdős--Rado exponent in the nonlinear boundary host; and
5. the scope of Reiher's expansion theorem and closure interface.

The theorem should remain on a draft research branch until those checks have
been completed.
