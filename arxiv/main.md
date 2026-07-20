# Obligatory Triple Systems

**Samuil Petkov**  
11 July 2026

**2020 Mathematics Subject Classification.** Primary 05C65; Secondary 05C15, 05C63, 03E05  
**Keywords.** obligatory triple system; hypergraph colouring; Levi graph; Berge cycle; uncountable chromatic number; Erdős Problem 593

## Abstract

A finite triple system is obligatory if it embeds in every triple system of uncountable chromatic number. We prove that, after isolated vertices are removed, obligatoriness is equivalent to linearity, the incidence of every hyperedge-node of the Levi graph with a bridge, and the evenness of every Berge cycle. Equivalently, the obligatory systems are precisely those built from private-vertex expansions of finite bipartite graphs and finite edgeless systems by finite disjoint unions and one-point amalgamations. The positive direction follows from a probabilistic rainbow lemma and a rooted-abundance argument, while the intrinsic description follows by deleting Levi-graph bridges and reassembling the resulting expansion pieces along a quotient forest. For the converse, one-apex sequence lifts, shift graphs of large odd girth, and an Erdős–Rado host exclude each failure of the intrinsic conditions; all arguments are in ZFC.

# Introduction

A finite triple system is *obligatory* if it occurs in every triple system of uncountable chromatic number. Erdős asked for a characterization of these finite systems [1]; the question is catalogued as Erdős Problem 593 [2]. The answer has both a constructive form and an intrinsic form.

For a finite graph $J$, write $J^+$ for its private-vertex expansion. Let $\mathcal B$ be the smallest class containing $J^+$ for every finite bipartite graph $J$ and every finite edgeless triple system, and closed under finite disjoint unions and one-point amalgamations. If $F$ is a triple system, let $F^\circ$ denote the system obtained by deleting its isolated vertices.

**Theorem A.** *For every finite triple system $F$, the following are equivalent:*

1.  *$F$ is obligatory;*

2.  *$F\in\mathcal B$;*

3.  *$F^\circ$ is linear, every hyperedge-node of $I(F^\circ)$ is incident with a bridge, and every Berge cycle of $F^\circ$ has even length.*

The graph analogue was proved by Erdős and Hajnal: the obligatory finite graphs are exactly the bipartite graphs [3, Corollary 5.6 and Theorem 7.4]. The classical nonlinearity obstruction for uniform hypergraphs is due to Erdős, Hajnal, and Rothschild [4, Theorem 2, p. 532]. Obligatory triple systems were studied further by Erdős et al. [5], Komjáth [6], Hajnal and Komjáth [7], and Komjáth [8]; the expansion theorem of Reiher [9, Theorem 1.2] supplies the positive atoms used below. Independent work of Li [10, Theorems 1.1 and 4.6] gives the same classification by a related sequence-lift argument. The proof here is self-contained and does not use that manuscript.

The proof separates the positive and negative directions. First, a probabilistic rainbow lemma provides the local injectivity needed to force complete bipartite expansions. A rooted-abundance lemma then proves closure under one-point amalgamation, including at singular uncountable cardinals. Deleting the bridges of the Levi graph identifies each remaining active component with the expansion of a finite bipartite graph; the quotient graph is a forest, and its running-intersection property gives the required amalgamation order.

For the converse, a one-apex sequence lift transfers uncountable chromatic number from a graph to a triple system while controlling every finite linear trace. Such a trace decomposes into finite graph expansions joined only at cut points. This prevents a bridge-free hyperedge-node or a Berge cycle from being assembled across different fibres. The three possible failures of the intrinsic conditions are then excluded respectively by an Erdős–Rado linear host, the lift of $K_{\omega_1}$, and the lift of an uncountably chromatic shift graph with sufficiently large odd girth.

All embeddings are injective and non-induced. The argument is carried out in ZFC. The only non-elementary results used as black boxes are the de Bruijn–Erdős compactness theorem [11, Theorem 1, pp. 371–373] and the pair case of the Erdős–Rado partition theorem [12, Theorem 4(i), formula (95), p. 471].

# Preliminaries

A *triple system* is a simple $3$-uniform hypergraph $H=(V(H),E(H))$, so $E(H)\subseteq[V(H)]^3$. A colouring $c:V(H)\to\lambda$ is *proper* when no hyperedge is monochromatic, and $\chi(H)$ is the least cardinal $\lambda$ admitting such a colouring. An embedding of a triple system $F$ in $H$ is an injective map $f:V(F)\to V(H)$ such that $f[e]\in E(H)$ for every $e\in E(F)$; embeddings are not required to be induced. A finite triple system $F$ is *obligatory* if every triple system $H$ with $\chi(H)>\aleph_0$ contains an embedding of $F$. A point is *isolated* if it belongs to no hyperedge, and $F^\circ$ denotes the result of deleting all isolated points.

All ordinary graphs in this paper are simple. A triple system is *linear* when any two distinct hyperedges meet in at most one point. Its *Levi graph* $I(F)$ is the bipartite graph with classes $V(F)$ and $E(F)$, where a point-node $p$ is adjacent to a hyperedge-node $e$ exactly when $p\in e$. A *bridge* is an edge of a graph whose deletion increases the number of connected components. A *Berge cycle of length* $\ell\ge2$ consists of distinct points $p_0,\ldots,p_{\ell-1}$ and distinct hyperedges $e_0,\ldots,e_{\ell-1}$ such that $p_i\in e_i\cap e_{i+1}$, with indices modulo $\ell$. Equivalently, it is a simple cycle of length $2\ell$ in $I(F)$.

For a finite simple graph $J$, its *private-vertex expansion* $J^+$ has vertex set $$V(J)\mathbin{\dot\cup}\{p_a:a\in E(J)\}$$ and hyperedges $\{u,v,p_{\{u,v\}}\}$ for $\{u,v\}\in E(J)$, where the points $p_a$ are new and pairwise distinct. A *one-point amalgamation* of vertex-disjoint triple systems $F_0,F_1$ is obtained by choosing $x_i\in V(F_i)$, identifying $x_0$ with $x_1$, and making no other identifications or new hyperedges. Finite disjoint unions and finite edgeless systems include the empty cases.

#### Finite reductions.

**Lemma 1.1** (Isolated-vertex reduction).

*Let $F$ be a finite triple system and let $F^\circ$ be obtained by deleting all isolated vertices. Then*

*$$F\text{ is obligatory}\iff F^\circ\text{ is obligatory},$$*

*and*

*$$F\in\mathcal B\iff F^\circ\in\mathcal B.$$*

*Proof.* If $F^\circ$ is obligatory and $H$ has uncountable chromatic number, then $H$ has infinitely many vertices. After embedding the finite system $F^\circ$, map the isolated vertices of $F$ injectively to unused host vertices. Containment is non-induced, so additional host edges are irrelevant. The converse follows because $F^\circ$ is a subhypergraph of $F$.

For membership in $\mathcal B$, the implication $F^\circ\in\mathcal B\Rightarrow F\in\mathcal B$ follows by taking the disjoint union with a finite edgeless system.

For the converse, use structural induction on a construction of $F$ in $\mathcal B$. If $F=J^+$, delete the isolated graph vertices of $J$ to obtain $J_0$; then $(J^+)^\circ=J_0^+\in\mathcal B$. If $F$ is edgeless, its reduction is the empty edgeless system. Reduction commutes with disjoint union.

Suppose finally that $F$ is a one-point amalgamation of $F_0$ and $F_1$, identifying $x_i\in V(F_i)$. By induction, $F_0^\circ,F_1^\circ\in\mathcal B$. If both selected vertices are nonisolated in their factors, then $F^\circ$ is the one-point amalgamation of the two reductions at those vertices. If exactly one selected vertex is nonisolated, the isolated side disappears at the identified point and $F^\circ$ is the disjoint union of the two reductions. The same description applies when both selected vertices are isolated, because the identified point is then deleted. Hence $F^\circ\in\mathcal B$ in every case. ◻

Thus isolated vertices may be suppressed throughout the substantive argument and restored at the end.

**Lemma 1.2** (Finite deletion).

*If $\chi(H)>\aleph_0$ and $S\subseteq V(H)$ is finite, then*

*$$\chi(H-S)>\aleph_0.$$*

*Proof.* Otherwise a countable colouring of $H-S$, together with finitely many fresh colours for $S$, would colour $H$ countably. ◻

#### Colouring and closure tools.

**Lemma 1.3** (Two elementary colouring facts).

*We shall use the following two facts repeatedly.*

1.  *If $E(H)=E_1\cup\cdots\cup E_r$ and every $(V(H),E_i)$ is countably chromatic, then $H$ is countably chromatic.*

2.  *If a graph $G$ admits an orientation in which every vertex has outdegree at most $d<\omega$, then $\chi(G)\le 2d+1$.*

*Proof.* For the first assertion, take the product of the $r$ countable colourings.

For the second, every finite subgraph has at most $d|V|$ edges and therefore a vertex of degree at most $2d$. It is $(2d+1)$-colourable by greedy deletion. The de Bruijn–Erdős compactness theorem [11, Theorem 1] then gives a $(2d+1)$-colouring of all of $G$. ◻

**Lemma 1.4** (Closure-chain lemma).

*Let $\kappa$ be an uncountable cardinal, let $1\le r<\omega$, and let*

*$$\Phi:[\kappa]^r\longrightarrow[\kappa]^{<\omega}$$*

*have uniformly finite values. There is an increasing continuous chain*

*$$\varnothing=M_0\subseteq M_1\subseteq\cdots
\subseteq M_i\subseteq\cdots\qquad(i<\operatorname{cf}\kappa)$$*

*such that*

*$$\bigcup_{i<\operatorname{cf}\kappa}M_i=\kappa,
\qquad |M_i|<\kappa,$$*

*and every $M_i$ is $\Phi$-closed:*

*$$a\in[M_i]^r\quad\Longrightarrow\quad\Phi(a)\subseteq M_i.$$*

*Proof.* Choose sets $A_i\subseteq\kappa$, each of cardinality below $\kappa$, whose union is $\kappa$. At a successor stage close $M_i\cup A_i$ under $\Phi$, iterating the operation $\omega$ times. Since $\Phi$ is finitary and finite-valued, this does not increase an infinite cardinal below $\kappa$. At a limit stage take the union. A union of an increasing chain of sets closed under a finitary operation remains closed; and because the stage is below $\operatorname{cf}\kappa$, its cardinality remains below $\kappa$. ◻

Write

$$I_i=M_{i+1}\setminus M_i.$$

Then $(I_i)_{i<\operatorname{cf}\kappa}$ partitions $\kappa$, and $M_i=\bigcup_{j<i}I_j$.

# A bipartite subgraph lemma

The next lemma is the finite complete-bipartite consequence of Erdős and Hajnal [3, Corollary 5.6, p. 72]. We include its short closure-chain proof because the same construction is used later.

**Lemma 2.1** (Uncountable chromatic number forces complete bipartite graphs).

*For every positive integer $n$, every graph of uncountable chromatic number contains $K_{n,n}$.*

*Proof.* Suppose otherwise, and choose a $K_{n,n}$-free graph $G$ of uncountable chromatic number whose vertex cardinality $\kappa$ is minimal.

For $A\in[\kappa]^n$, let

$$N(A)=\{v\in\kappa:v\text{ is adjacent to every member of }A\}.$$

Because $G$ is $K_{n,n}$-free, $|N(A)|<n$. Apply Lemma 1.4 to $A\mapsto N(A)$, and let $M_i,I_i$ be the resulting chain and layers.

By minimality of $\kappa$, every induced graph $G[I_i]$ is countably chromatic. Let $G^\times$ consist of the edges joining distinct layers, and orient each such edge from the later endpoint toward the earlier endpoint. If $v\in I_i$ had $n$ earlier neighbours, those neighbours would form an $n$-set $A\subseteq M_i$, and closure would give

$$v\in N(A)\subseteq M_i,$$

contrary to $v\in I_i$. Thus the orientation of $G^\times$ has outdegree at most $n-1$. By Lemma 1.3, $G^\times$ is finitely colourable.

Colour each $G[I_i]$ with colours in $\omega$, reusing the same palette on all layers, and combine this with a finite proper colouring of $G^\times$. The resulting countable product colouring is proper on all of $G$, a contradiction. ◻

# Bipartite expansions

#### Rainbow bipartite submatrices.

**Lemma 3.1** (Rainbow bipartite submatrices).

*For all positive integers $n,t$, there exists $q=q(n,t)$ with the following property. Suppose the edges of $K_{q,q}$ are coloured, with an arbitrary colour set, so that at every vertex each individual colour occurs on fewer than $t$ incident edges. Then there are $n$-element subsets $X'$ and $Y'$ of the two vertex classes such that all $n^2$ edges between $X'$ and $Y'$ have distinct colours.*

*Proof.* Choose independent uniformly random $n$-subsets $X'$ and $Y'$. For every unordered pair $P$ of distinct same-coloured edges, let $I_P$ be the indicator that both edges of $P$ lie in the selected $K_{n,n}$, and put $$Z=\sum_P I_P.$$ Thus $Z=0$ exactly when all selected edges have distinct colours.

Let $m_\gamma$ be the number of edges of colour $\gamma$. The local bound gives

$$m_\gamma\le(t-1)q.$$

At a fixed vertex and for a fixed colour $\gamma$, fewer than $t$ incident edges have colour $\gamma$. Summing $\binom{d_{v,\gamma}}2\le(d_{v,\gamma})(t-1)/2$ over the $2q$ vertices shows that the number of same-coloured pairs sharing a vertex is at most $(t-1)q^2$. The total number of same-coloured pairs is at most

$$\sum_\gamma\binom{m_\gamma}{2}
\le \frac12\bigl(\max_\gamma m_\gamma\bigr)\sum_\gamma m_\gamma
\le \frac12(t-1)q^3.$$

If the two edges share a vertex in the left class, their exact selection probability is $$\frac nq\frac{(n)_2}{(q)_2};$$ the same formula holds when the shared vertex is on the right. If the two edges are disjoint, the exact probability is $$\left(\frac{(n)_2}{(q)_2}\right)^2.$$ For $q\ge2n$, these are at most $2n^3/q^3$ and $4n^4/q^4$, respectively. By linearity of expectation,

$$\mathbb{E}\!\left[Z\right]
 \le\frac{2(t-1)n^3}{q}+\frac{2(t-1)n^4}{q}.$$

This is below $1$ for sufficiently large $q$. Since $Z$ is integer-valued and nonnegative, it cannot satisfy $Z\ge1$ for every choice when $\mathbb{E}\!\left[Z\right]<1$. Hence some choice has $Z=0$, and the selected $K_{n,n}$ is rainbow. ◻

#### The complete bipartite expansion atom.

**Proposition 3.2** (The complete bipartite expansion atom).

*For every positive integer $n$, the triple system $K_{n,n}^{+}$ is obligatory.*

*Proof.* Suppose not. Choose a $K_{n,n}^{+}$-free triple system

$$H=(\kappa,E)$$

with $\chi(H)>\aleph_0$ and with $\kappa$ minimal.

For a pair $xy$, write

$$d_H(xy)=|\{z:\{x,y,z\}\in E\}|.$$

Set $t=3n^2+1$ and define a graph $R$ on $\kappa$ by

$$xy\in E(R)\quad\Longleftrightarrow\quad d_H(xy)\ge t.$$

**Claim 3.2.1 (the graph $R$ is countably chromatic).**

Otherwise Lemma 2.1 gives a $K_{n,n}$ in $R$, with core vertex set $C$, $|C|=2n$. For each of its $n^2$ graph edges $xy$, choose a third vertex $p_{xy}$ with

$$\{x,y,p_{xy}\}\in E,$$

avoiding $C$ and all previously chosen private vertices. At every stage fewer than $2n+n^2<t$ vertices are forbidden, while $xy$ has at least $t$ possible third vertices. Thus the $p_{xy}$ can be chosen distinct and outside $C$, producing a copy of $K_{n,n}^{+}$, a contradiction. $\square$

Let

$$E_1=\{e\in E:\text{some pair contained in }e\text{ is an edge of }R\},
\qquad E_2=E\setminus E_1.$$

A proper colouring of $R$ is a proper colouring of $(\kappa,E_1)$, since every $E_1$-edge contains an $R$-edge. Hence $\chi(\kappa,E_1)\le\aleph_0$, and therefore

$$\chi(\kappa,E_2)>\aleph_0. \tag{3.1}$$

For a pair $xy$, define

$$\Phi(xy)=
\begin{cases}
\{z:\{x,y,z\}\in E\},&d_H(xy)<t,\\
\varnothing,&d_H(xy)\ge t.
\end{cases}$$

Apply Lemma 1.4 to $\Phi$, obtaining $M_i,I_i$.

Every $e\in E_2$ has at least two vertices in its highest layer. Indeed, suppose the highest layer met $e$ only in $z\in I_i$. Then the other pair $xy=e\setminus\{z\}$ lies in $M_i$. Since $e\in E_2$, $xy\notin R$, so $d_H(xy)<t$. Closure gives $z\in\Phi(xy)\subseteq M_i$, a contradiction.

Thus every $E_2$-edge is either contained in one layer, or has exactly two vertices in its highest layer $I_i$ and its third vertex in $M_i$. Let $E_i^*$ be the $E_2$-edges contained in $I_i$. Since $|I_i|<\kappa$ and $H$ is $K_{n,n}^{+}$-free, minimality of $\kappa$ gives $\chi(I_i,E_i^*)\le\aleph_0$. Consequently

$$E^*=\bigcup_iE_i^*$$

is countably chromatic. By (3.1), the remaining crossing-edge system

$$E^{**}=E_2\setminus E^*$$

has uncountable chromatic number.

For each $i$, define a graph $G_i$ on $I_i$ by declaring $xy\in E(G_i)$ when there is a $\beta\in M_i$ such that $\{x,y,\beta\}\in E^{**}$. If every $G_i$ were countably chromatic, colour each $I_i$ properly in $G_i$, using the same countable palette on every layer. Every edge of $E^{**}$ would then have differently coloured top-layer vertices, giving a countable colouring of $(\kappa,E^{**})$, a contradiction. Hence some $G_i$ is uncountably chromatic.

Choose $q=q(n,t)$ from Lemma 3.1. Lemma 2.1 gives a $K_{q,q}$ in $G_i$, with sides $X,Y$. For every $xy\in X\times Y$, choose

$$\beta_{xy}\in M_i$$

such that $\{x,y,\beta_{xy}\}\in E^{**}$, and regard $\beta_{xy}$ as the colour of the edge $xy$.

This edge-colouring is locally $(t-1)$-bounded. For example, if for fixed $x$ and fixed $\beta$ there were $t$ different vertices $y$ with $\beta_{xy}=\beta$, then the pair $\{x,\beta\}$ would have codegree at least $t$. It would belong to $R$, forcing the triples $\{x,y,\beta\}$ into $E_1$, contrary to their membership in $E^{**}\subseteq E_2$. The same argument applies at vertices of $Y$.

Lemma 3.1 gives $n$-sets $X'\subseteq X$, $Y'\subseteq Y$ for which the $\beta_{xy}$, $x\in X'$, $y\in Y'$, are all distinct. They lie in $M_i$, whereas $X'\cup Y'\subseteq I_i$, so none is a core vertex. The triples

$$\{x,y,\beta_{xy}\},
\qquad x\in X',\ y\in Y',$$

form $K_{n,n}^{+}$, the final contradiction. ◻

**Corollary 3.3** (Every finite bipartite expansion is obligatory).

*If $J$ is any finite bipartite graph, then $J^+$ is obligatory.*

*Proof.* Embed the two vertex classes of $J$ in the two classes of some $K_{n,n}$. Then $J^+$ is a subhypergraph of $K_{n,n}^+$. Obligatoriness is downward closed under non-induced containment: a copy of the larger finite system contains a copy of the smaller one. Apply Proposition 3.2. ◻

Corollary 3.3 is also a consequence of Reiher [9, Theorem 1.2]; the preceding argument gives a direct proof in the present notation.

# Closure properties

Closure under disjoint unions and one-point amalgamations is part of the established theory; see Komjáth [6, pp. 233–238] and the summary in Reiher [9, p. 1]. We include complete proofs because the rooted abundance argument is used below.

#### Disjoint-union closure.

**Lemma 4.1** (Disjoint-union closure).

*The class of finite obligatory triple systems is closed under finite disjoint unions.*

*Proof.* Let $F_1,F_2$ be obligatory and let $H$ be uncountably chromatic. First find a copy of $F_1$. Delete its finite vertex set. By Lemma 1.2 the remaining triple system is still uncountably chromatic, so it contains $F_2$. The two copies are disjoint. Iteration proves the finite case. ◻

#### Rooted abundance and one-point amalgamation.

**Definition 4.2** (Rooted abundance).

Let $(F,r)$ be a finite rooted triple system with $|V(F)|>1$. For a triple system $H$ and $m\ge1$, let $R_m(F,r;H)$ be the set of vertices $v$ for which there are $m$ rooted copies of $F$, all sending $r$ to $v$, whose off-root vertex sets are pairwise disjoint.

**Lemma 4.3** (Rooted-abundance lemma).

*If $(F,r)$ is finite, $|V(F)|>1$, and $F$ is obligatory, and if $\chi(H)>\aleph_0$, then*

*$$\chi\bigl(H[R_m(F,r;H)]\bigr)>\aleph_0.$$*

*Proof.* Put

$$B=V(H)\setminus R_m(F,r;H).$$

For each $v\in B$, consider the family of off-root vertex sets of all copies of $F$ rooted at $v$. Because $v\notin R_m(F,r;H)$, this family has matching number at most $m-1$. Choose a maximal pairwise disjoint subfamily. It contains at most $m-1$ members; let $S_v$ be their union. Then

$$|S_v|\le(m-1)(|V(F)|-1)=:D.$$

Moreover, $S_v$ meets the off-root part of every rooted copy at $v$: otherwise that off-root set would be disjoint from every member of the chosen subfamily and could be added to it, contradicting maximality.

Form a graph $D_B$ on $B$ by joining $v$ to each member of $S_v\cap B$. If an edge is generated in both directions, assign it to one of its generators, and orient it away from that generator. Every vertex has outdegree at most $D$, so Lemma 1.3 gives a finite proper colouring of $D_B$.

Let $A$ be one colour class. Then

$$S_v\cap A=\varnothing\qquad(v\in A).$$

Consequently $H[A]$ contains no copy of $F$. Indeed, if $\varphi$ were such a copy and $v=\varphi(r)$, its off-root part would have to meet $S_v$ although both are subsets of $A$. Since $F$ is obligatory, every $F$-free triple system is countably chromatic. Thus each of the finitely many colour classes of $D_B$ induces a countably chromatic subsystem. Tagging a vertex by its finite $D_B$-colour and its countable colour inside that class gives a countable proper colouring of $H[B]$.

If $H[R_m(F,r;H)]$ were countably chromatic as well, tagging the two sides would give a countable colouring of $H$. This contradicts $\chi(H)>\aleph_0$. ◻

**Proposition 4.4** (One-point amalgamation closure).

*The class of finite obligatory triple systems is closed under one-point amalgamations.*

*Proof.* Let $F_1,F_2$ be obligatory, with selected vertices $r_1,r_2$, and let $F$ be their one-point amalgamation. If one factor consists only of its selected vertex, the assertion is immediate. Otherwise set

$$m=|V(F_2)|.$$

By Lemma 4.3, the set

$$R=R_m(F_1,r_1;H)$$

induces an uncountably chromatic subsystem of every uncountably chromatic $H$. Hence $H[R]$ contains a copy of $F_2$; write $\varphi$ for its embedding and let $v=\varphi(r_2)$.

At $v$ there are $m$ rooted copies of $F_1$ with pairwise disjoint off-root sets. The set $\varphi(V(F_2)\setminus\{r_2\})$ has $m-1$ vertices, so it meets at most $m-1$ of those off-root sets. One rooted $F_1$-copy therefore avoids the $F_2$-copy outside $v$. Their union is the required one-point amalgamation. ◻

Corollary 3.3, Lemma 4.1, Proposition 4.4, and the trivial edgeless case prove

$$(2)\Longrightarrow(1). \tag{4.1}$$

# The intrinsic decomposition

We prove $(2)\Longleftrightarrow(3)$. Isolated vertices may be ignored by Lemma 1.1.

#### Forward preservation.

**Proposition 5.1** (The intrinsic conditions are preserved by the generators and operations).

*Every generator of $\mathcal B$ satisfies the intrinsic conditions, and the conditions are preserved under finite disjoint unions and one-point amalgamations.*

*Proof.* For a bipartite graph $J$, the expansion $J^+$ is linear. Every hyperedge-node is joined to its private point by a bridge. A Berge cycle cannot use a private point, so the Berge cycles of $J^+$ are precisely the ordinary graph cycles of $J$, with the same lengths; these are even. Edgeless systems satisfy the conditions vacuously, and disjoint union plainly preserves them.

Consider a one-point amalgamation. Hyperedges belonging to different factors intersect only in the identified point, so linearity is preserved. Its Levi graph is the vertex-sum of the two Levi graphs at a point-node. Every simple cycle in a vertex-sum lies wholly in one factor: a cycle crossing into the other factor would have to pass through the cut vertex twice. Consequently bridges in the factors remain bridges, and every Berge cycle lies in one factor and retains its parity. ◻

Thus

$$(2)\Longrightarrow(3). \tag{5.1}$$

#### Bridge-block reconstruction.

**Proposition 5.2** (Bridge-block decomposition).

*Suppose $F$ is finite, has no isolated vertices, and satisfies the three intrinsic conditions. Then $F\in\mathcal B$.*

*Proof.* If $E(F)=\varnothing$, then the assumption that $F$ has no isolated vertices gives $V(F)=\varnothing$, and $F$ is an edgeless generator. Hence assume $E(F)\ne\varnothing$. Put $L=I(F)$, let $B(L)$ be its set of bridges, and let $\mathscr C$ be the set of connected components of $L-B(L)$.

Consider a hyperedge-node $e$. Since $e$ is incident with a bridge and has degree three, it has at most two nonbridge incidences. It cannot have exactly one: a nonbridge incidence lies on a cycle, and that cycle must leave $e$ through a second nonbridge incidence. Therefore every hyperedge-node has either no nonbridge incidences or exactly two.

#### The nontrivial components.

Let $C\in\mathscr C$ contain a nonbridge incidence. Every hyperedge-node $e\in C$ has exactly two point-neighbours in $C$. Contract each such $e$ to an ordinary graph edge between those two point-neighbours. This produces a finite graph $J_C$.

The graph $J_C$ is simple: parallel edges would correspond to two hyperedges of $F$ sharing two points, contrary to linearity. Every cycle in $J_C$ gives a Berge cycle of the same length in $F$. Hence $J_C$ has no odd cycle and is bipartite.

Each hyperedge-node $e\in C$ has a third point-neighbour $p_e$ across a bridge. These third points satisfy:

1.  $p_e\notin C$; otherwise a path in $C$ from $p_e$ to $e$, together with the incidence $ep_e$, would place that incidence on a cycle.

2.  If $e\ne f$ lie in $C$, then $p_e\ne p_f$; otherwise a path in $C$ from $e$ to $f$, together with $ep_e$ and $p_ff$, would place those bridge incidences on a cycle.

Define a map from $J_C^+$ to the subsystem $P_C$ formed by these hyperedges as follows. Send every graph vertex of $J_C$ to the corresponding point-node of $C$, send the private vertex indexed by the contracted edge associated with $e$ to $p_e$, and send that expanded edge to the hyperedge $e$ of $F$. The two observations above show that the vertex map is injective: the private points are pairwise distinct and lie outside $C$. Every $e$ has exactly the two contracted endpoints and $p_e$ as its three vertices, so this map is incidence-preserving and surjective on the vertices and hyperedges of $P_C$. Hence it is an isomorphism $J_C^+\cong P_C$.

#### Components consisting of one hyperedge-node.

If a hyperedge-node $e$ has no nonbridge incidence, it is an isolated component after the bridges are deleted. Its single triple is the expansion of a one-edge bipartite graph. Thus every hyperedge of $F$ belongs to a piece $P_C$ isomorphic to $J^+$ for a finite bipartite graph $J$. The hyperedge sets of these pieces partition $E(F)$. Their vertex sets cover $V(F)$: every point is incident with a hyperedge, and it either lies in that hyperedge-node’s bridge-deleted component or is the point endpoint of a bridge leaving it.

#### Quotient forest.

Contract every component of $L-B(L)$. The original bridges become edges of a quotient multigraph $T$. Two distinct bridges cannot join the same pair of bridge-deleted components: paths inside those two components, together with the two bridges, would form a cycle containing both, contradicting that they are bridges. Thus $T$ is a simple graph.

To see that $T$ is a forest, suppose that it contained a cycle. Within each contracted component on this cycle, choose a path joining the endpoints of the two incident quotient edges. Concatenating these paths with the corresponding bridges gives a closed walk in $L$ that traverses each of those bridges exactly once. This is impossible: deleting a bridge separates its endpoints, so every closed walk crosses the resulting cut an even number of times. Hence $T$ is a forest.

A vertex $C\in V(T)=\mathscr C$ is called *active* if the bridge-deleted component $C$ contains a hyperedge-node. For an active $C$, the piece $P_C$ consists of the hyperedges represented in $C$, all point-nodes of $C$, and the point endpoints of bridge incidences leaving hyperedge-nodes in $C$. An inactive component contains no hyperedge-node and hence no incidence of $L-B(L)$, so it is a singleton point-node.

At this stage every hyperedge already belongs to a bipartite expansion piece. The only remaining issue is global: the pieces must be ordered so that a new piece never meets the assembled system in two different points. The quotient forest records exactly the attachment geometry needed for this running intersection.

**Claim 1** (5.2.1. Running intersection). *Every component of $T$ contains an active vertex, because $F$ has no isolated vertices. Choose an active root in each component, and order the active vertices by nondecreasing depth, with arbitrary order among equal-depth vertices. When an active component $C$ is added, its piece $P_C$ meets the union of the earlier pieces in at most one point.*

*Proof of the claim.* For a point $p\in V(F)$, let $X(p)\in\mathscr C$ be the component of $L-B(L)$ containing the point-node $p$. The active pieces containing $p$ are precisely $P_{X(p)}$, when $X(p)$ is active, together with the pieces $P_D$ at active neighbours $D$ of $X(p)$ whose corresponding original bridge has point endpoint $p$. Thus the vertices of $T$ indexing pieces that contain $p$ are contained in the closed star centred at $X(p)$.

Suppose that $p\in P_C$ also lies in an earlier piece. If $X(p)=C$, every other piece containing $p$ is indexed by a neighbour of $C$. A tree has only one neighbour of $C$ at smaller depth, namely its parent, so only that piece can be earlier. If $X(p)\ne C$, then $C$ is a neighbour of $X(p)$. The vertex $X(p)$ cannot be a child of $C$, because then both $X(p)$ and every other vertex in its closed star would be deeper than $C$. Hence $X(p)$ is the parent of $C$. In either case, $p$ is the point endpoint of the unique parent edge of $C$. The same reasoning applies to every point shared with an earlier piece, so all such points coincide with this parent point $p_C$, and

$$P_C\cap\bigcup_{D\text{ earlier}}P_D\subseteq\{p_C\}.$$

For a root active component the intersection is empty. ◻

Starting with the root piece in each component, add the active pieces in this order. If the new intersection is empty, use a disjoint union. If it is the singleton $\{p_C\}$, use a one-point amalgamation at that point. Several earlier pieces may already contain the same inactive attachment point, but the new step still identifies only that one existing vertex.

For completeness, the identity maps from the pieces into $F$ assemble inductively to an incidence isomorphism from the constructed system onto the union of the pieces already added. Indeed, the running-intersection claim shows that the next piece and the preceding union have either no common vertex or exactly the one vertex used in the amalgamation; hence the construction makes no unintended identification. The piece hyperedge sets are disjoint and partition $E(F)$, while their vertex sets cover $V(F)$. After all active pieces have been added, the resulting subsystem is therefore all of $F$. Different components of $T$ are combined by disjoint union. Hence $F\in\mathcal B$. ◻

This proves

$$(3)\Longrightarrow(2). \tag{5.2}$$

Combining (5.1) and (5.2),

$$(2)\Longleftrightarrow(3). \tag{5.3}$$

# The sequence lift

#### The one-apex construction.

Let $G=(X,A)$ be an arbitrary graph, where $A=E(G)$ is also regarded as an alphabet. Let

$$T=A^{<\omega_1}$$

be the tree of all sequences of graph edges of countable ordinal length. For $s\in T$ and $x\in X$, write $x_s=(s,x)$.

**Definition 6.1** (The one-apex lift).

Define the triple system $\mathcal L(G)$ by

$$V(\mathcal L(G))=T\times X.$$

For $s\in T$, an edge $a=\{x,y\}\in A$, a sequence $t\in T$ extending $s^\frown a$, and $z\in X$, put

$$\{x_s,y_s,z_t\}\in E(\mathcal L(G)). \tag{6.1}$$

The two vertices $x_s,y_s$ form the base pair and $z_t$ is the apex. Since $t$ properly extends $s$, these are three distinct vertices. In the resulting triple, the sequence node occurring twice uniquely identifies $s$; its two graph labels identify the edge $a=\{x,y\}$, and the remaining vertex identifies $t,z$. Thus each hyperedge arises from unique data, up to interchanging $x$ and $y$, and the system is simple and $3$-uniform.

#### Chromatic and finite-trace properties.

**Lemma 6.2** (Chromatic lower bound).

*If $\chi(G)>\aleph_0$, then*

*$$\chi(\mathcal L(G))>\aleph_0.$$*

*Proof.* Suppose $c:T\times X\to\omega$ is proper. For every $s\in T$, the restriction $x\mapsto c(x_s)$ is a countable colouring of $G$. Hence there is an edge

$$a_s=\{x_s^0,x_s^1\}\in E(G)$$

whose two vertices at node $s$ have a common colour $k_s$.

Construct $s_\alpha\in A^\alpha$ for $\alpha<\omega_1$ by

$$s_0=\varnothing,
\qquad s_{\alpha+1}=s_\alpha^\frown a_{s_\alpha},$$

and at limit ordinals take unions.

If $\alpha<\beta$, then $s_\beta$ extends $s_\alpha^\frown a_{s_\alpha}$. If $k_{s_\alpha}=k_{s_\beta}$, take either endpoint $z$ of the monochromatic edge at $s_\beta$. By (6.1),

$$\{(s_\alpha,x_{s_\alpha}^0),
  (s_\alpha,x_{s_\alpha}^1),
  (s_\beta,z)\}$$

is a monochromatic hyperedge. Therefore the colours $k_{s_\alpha}$, $\alpha<\omega_1$, are pairwise distinct, impossible in $\omega$. ◻

**Theorem 6.3** (Exact finite linear trace theorem).

*Every finite, not necessarily induced, linear subhypergraph $K$ of $\mathcal L(G)$ is obtainable, by finite disjoint unions and one-point amalgamations, from systems $J^+$ where $J$ is a finite subgraph of $G$.*

*Proof.* The following dictionary records the three local objects used in the assembly. A *base node* is a sequence $s$ at which a lift hyperedge begins. Its two vertices with sequence coordinate $s$ are the *core vertices*; its third vertex, whose coordinate properly extends $s$, is the *apex*. The *base fibre* $K_s$ consists of all hyperedges of $K$ based at $s$, together with their incident vertices. An *active base node* is one whose fibre is nonempty. The proof first identifies each fibre with one expansion atom and then shows that the fibres are attached along a forest of one-point overlaps.

First set aside every isolated vertex of $K$. Each is a one-vertex edgeless factor, hence isomorphic to $J^+$ for a one-vertex edgeless subgraph $J$ of $G$, and may be restored by disjoint union at the end. We may therefore assume that every vertex of $K$ lies in a hyperedge.

Every hyperedge of $\mathcal L(G)$ has a unique base node: exactly two of its vertices have sequence coordinate $s$, while the apex has a strictly longer sequence coordinate. We group the hyperedges of $K$ by this coordinate and use the notation $K_s$ from the dictionary.

**Claim 6.3.1 (each base fibre is one expansion atom).** For every active base node $s$, there is a finite subgraph $J_s$ of $G$ such that $K_s\cong J_s^+$.

*Proof of Claim 6.3.1.* For a fixed graph edge $a=\{x,y\}\in E(G)$, at most one hyperedge of $K_s$ can have base pair $\{x_s,y_s\}$, since two such hyperedges would share two vertices and violate linearity. Let $J_s$ be the finite subgraph of $G$ whose edges are precisely the graph edges used by hyperedges of $K_s$, with vertex set consisting of their endpoints.

Define a map $J_s^+\to K_s$ by sending each graph vertex $x\in V(J_s)$ to the core vertex $x_s$, and by sending the private vertex of $a=\{x,y\}$ to the apex of the unique hyperedge of $K_s$ with base pair $\{x_s,y_s\}$. Distinct graph edges have distinct apices: if $z_t$ were the apex for $a$ and $a'$, the coordinate of $t$ immediately after $s$ would have to equal both $a$ and $a'$. No apex is a core vertex, because an apex has sequence coordinate strictly extending $s$, whereas every core vertex has coordinate $s$. The map is therefore injective, and by construction it is bijective on hyperedges and preserves each incidence. Hence $K_s\cong J_s^+$. ◻

**Claim 6.3.2 (two fibres have at most one common point).** For distinct active base nodes $s$ and $u$, $$|V(K_s)\cap V(K_u)|\le 1.$$

*Proof of Claim 6.3.2.* If a point $z_t$ lies in both $K_s$ and $K_u$, then both $s$ and $u$ are prefixes of $t$, so they are comparable. Suppose $s\subsetneq u$. A common point cannot be a core point of $K_s$; it is an apex of $K_s$. The graph edge used by its hyperedge in $K_s$ is the coordinate of $u$ immediately following $s$. Hence all points in $K_s\cap K_u$ would be apices of the same base edge of $K_s$. There is at most one such apex. Therefore

$$|V(K_s)\cap V(K_u)|\le1. \tag{6.2}$$ ◻

Let $Q$ be the bipartite incidence graph of the base fibres. Its left class is the set of active base nodes. Its right class consists of points that lie in at least two fibres. Join a base node $s$ to a point $p$ exactly when $p\in V(K_s)$.

**Claim 6.3.3 (the overlap graph is a forest).** The graph $Q$ is acyclic.

*Proof of Claim 6.3.3.* Suppose that $Q$ has a cycle, and choose on it a base node $s$ of minimum sequence length. Its two neighbouring base nodes on the cycle are proper descendants of $s$. The two intervening shared points are distinct, so they are distinct apices in $K_s$, arising from two distinct graph edges $a\ne a'$. Thus the two neighbouring base nodes lie in different immediate branches below $s$, one beginning with $a$ and the other with $a'$.

Starting from one neighbour of $s$, every base node on the remaining part of the cycle lies in the same immediate branch below $s$. Indeed, consecutive base nodes share a point and are therefore comparable. For two comparable proper descendants of $s$, the first sequence coordinate after $s$ is the same, so a length-two step through a shared point cannot move from one immediate branch to another. Induction along the remaining path therefore keeps every base node in the first branch, contradicting that its final node lies in the other branch. Hence $Q$ is acyclic. ◻

Root each component of $Q$ at a base node, and order its base nodes by nondecreasing even distance from the root. For a nonroot base node $s$, let $p_s$ be the point-node adjacent to $s$ on the path to the root.

**Claim 2** (6.3.4. Base-fibre running intersection). *Every earlier factor that meets $K_s$ meets it at $p_s$.*

*Proof of Claim 6.3.4.* Suppose $K_u$ is earlier and contains a point $p\in K_s$. Then $Q$ contains the length-two path $s-p-u$. Let the distance of $s$ from the root be $2d$. The point-node $p$ has distance either $2d-1$ or $2d+1$. In the second case $u$ has distance $2d+2$, so it cannot be earlier. Thus $p$ has distance $2d-1$, and the uniqueness of the path to the root in the tree $Q$ gives $p=p_s$. This also covers an earlier sibling $u$, which shares the same parent point $p_s$. ◻

**Claim 6.3.5 (the ordered fibres assemble to $K$).** Let $U_s$ be the union of the factors preceding $K_s$. Equation (6.2) and Claim 6.3.4 give $$V(K_s)\cap U_s\subseteq\{p_s\}.$$ Starting with the root factor, add the remaining factors in this order by disjoint unions or one-point amalgamations as appropriate. At each step the natural maps into $K$ identify exactly the displayed common point and nothing else, so they assemble to an isomorphism onto the union of the factors already added. Different components of $Q$, and the isolated factors removed at the start, are combined by disjoint union. This is the running-intersection step: Claim 6.3.1 supplies the expansion atoms, while Claims 6.3.2–6.3.4 certify that each new atom is attached along at most one previous point. ◻

**Corollary 6.4** (Restrictions on finite linear traces).

*Every finite linear $K\subseteq\mathcal L(G)$ satisfies:*

1.  *every hyperedge-node of $I(K)$ is incident with a bridge;*

2.  *every Berge cycle of $K$ is contained in a single factor $J_s^+$;*

3.  *a Berge cycle of length $\ell$ in $K$ yields an ordinary cycle of length $\ell$ in $G$.*

*Proof.* In every $J_s^+$ the incidence with the private vertex is a bridge. Bridgehood is preserved by one-point amalgamation. A simple Levi cycle cannot cross a one-point cut, so every Berge cycle lies in one factor. Berge cycles in $J_s^+$ are exactly ordinary graph cycles in $J_s$. ◻

# Shift graphs of large odd girth

The shift-graph mechanism used here is classical; compare Erdős and Hajnal [3, §7, especially Theorem 7.4]. We include proofs of the precise cardinal and odd-girth bounds needed below.

#### Chromatic growth of shift graphs.

For a positive integer $r$ and an infinite cardinal $\kappa$, define the directed shift graph $D_r(\kappa)$ as follows:

- its vertices are increasing $r$-tuples $$(\alpha_0,\ldots,\alpha_{r-1}),\qquad
      \alpha_0<\cdots<\alpha_{r-1}<\kappa;$$

- it has an arc $$(\alpha_0,\ldots,\alpha_{r-1})
      \longrightarrow
      (\alpha_1,\ldots,\alpha_r)$$ whenever $\alpha_0<\cdots<\alpha_r$.

Let $S_r(\kappa)$ be its underlying graph. Write

$$\beth_0(\aleph_0)=\aleph_0,
\qquad
\beth_{j+1}(\aleph_0)=2^{\beth_j(\aleph_0)}.$$

**Lemma 7.1** (Chromatic number of shift graphs).

*If*

*$$\kappa>\beth_{r-1}(\aleph_0),$$*

*then*

*$$\chi(S_r(\kappa))>\aleph_0.$$*

*Proof.* The case $r=1$ is immediate because $S_1(\kappa)=K_\kappa$. Assume $r\ge2$. Suppose $S_r(\kappa)$ has a proper colouring $c$ with $\lambda$ colours. For every increasing $(r-1)$-tuple $u$, define

$$C(u)=\{c(u^\frown\beta):\beta>\max u\}\subseteq\lambda.$$

If

$$u=(\alpha_0,\ldots,\alpha_{r-2}),
\qquad
v=(\alpha_1,\ldots,\alpha_{r-1})$$

are adjacent in $S_{r-1}(\kappa)$, then

$$c(\alpha_0,\ldots,\alpha_{r-1})\in C(u).$$

It cannot belong to $C(v)$, since that would give some $\beta>\alpha_{r-1}$ for which the adjacent $r$-tuples

$$(\alpha_0,\ldots,\alpha_{r-1}),
\qquad
(\alpha_1,\ldots,\alpha_{r-1},\beta)$$

have the same colour. Hence $C(u)\ne C(v)$. Thus a $\lambda$-colouring of $S_r(\kappa)$ yields a $2^\lambda$-colouring of $S_{r-1}(\kappa)$.

Starting with a countable colouring of $S_r(\kappa)$ and iterating $r-1$ times would give a colouring of

$$S_1(\kappa)=K_\kappa$$

with at most $\beth_{r-1}(\aleph_0)$ colours, impossible when $\kappa$ is larger. ◻

#### Odd-girth growth.

**Lemma 7.2** (Odd girth of shift graphs).

*The odd girth of $S_r(\kappa)$ is at least*

*$$2r+1.$$*

*Proof.* For a digraph $D$, let $\delta D$ be its arc digraph: the vertices of $\delta D$ are the arcs of $D$, and

$$(u,v)\longrightarrow(v,w)$$

is an arc of $\delta D$. We have

$$D_{r+1}(\kappa)\cong\delta D_r(\kappa).$$

We use the following fact: if $D$ is acyclic and the underlying graph of $D$ has odd girth $g$, then the underlying graph of $\delta D$ has odd girth at least $g+2$. Indeed, a directed cycle in $\delta D$ would concatenate to a directed closed walk in $D$, which would contain a directed cycle; hence $\delta D$ is also acyclic.

Take an odd cycle $a_0,\ldots,a_{m-1}$ in the underlying graph of $\delta D$, with indices modulo $m$. For the adjacency of $a_{i-1}$ and $a_i$, put $\varepsilon_i=+$ when $\operatorname{head}(a_{i-1})=\operatorname{tail}(a_i)$, and put $\varepsilon_i=-$ in the reverse case. Since $\delta D$ is acyclic, the cyclic sign sequence is not constant. Its number $c$ of sign changes is therefore a positive even integer, so $c\ge2$.

Let $v_i$ be the common endpoint in $D$ of the consecutive arcs $a_{i-1}$ and $a_i$. If $\varepsilon_i=\varepsilon_{i+1}$, then $v_i$ and $v_{i+1}$ are the two endpoints of $a_i$, in one order or the other. If $\varepsilon_i\ne\varepsilon_{i+1}$, then $v_i=v_{i+1}$: both are the tail of $a_i$ in the $+,-$ case and both are its head in the $-,+$ case. Thus $v_0,\ldots,v_{m-1},v_0$ is a closed walk in the underlying graph of $D$ with exactly $c$ stationary steps. Deleting those steps gives a closed walk of length $m-c$. Since $m$ is odd and $c$ is even, $c\ne m$. Together with $c\ge2$, this gives $$1\le m-c\le m-2,$$ and $m-c$ is odd.

Every odd closed walk contains an odd cycle. Indeed, if a vertex occurs twice internally, split the walk at two consecutive occurrences; one of the two resulting closed walks has odd length. Repeating this reduction produces an odd closed walk with no repeated internal vertex, hence an odd cycle. Therefore $m-c\ge g$, and so $m\ge g+2$.

Now $D_1(\kappa)$ is the transitive tournament; it is acyclic and its underlying graph $K_\kappa$ has odd girth $3$. Iterating the preceding observation gives odd girth at least

$$3+2(r-1)=2r+1.$$ ◻

**Corollary 7.3** (ZFC graphs with uncountable chromatic number and prescribed odd girth).

*For every finite $m$ there is a graph $G$ with $\chi(G)>\aleph_0$ and no odd cycle of length at most $m$.*

*Proof.* Choose $r$ with $2r+1>m$, and let

$$G=S_r\bigl(\beth_{r-1}(\aleph_0)^+\bigr).$$

Apply Lemmas 7.1 and 7.2. ◻

# Avoidance hosts

We prove

$$\neg(3)\Longrightarrow\neg(1).$$

#### Nonlinearity obstruction.

**Proposition 8.1** (Avoidance of every nonlinear finite triple system).

*There is an uncountably chromatic linear triple system. Consequently, every finite nonlinear triple system is non-obligatory.*

*Proof.* We use the Erdős–Rado relation [12, Theorem 4(i), formula (95), p. 471]

$$(2^{\aleph_0})^+\longrightarrow(\aleph_1)^2_{\aleph_0}. \tag{8.1}$$

Let $\kappa=(2^{\aleph_0})^+$. Define a triple system $T_\kappa$ whose vertices are the pairs in $[\kappa]^2$, and whose hyperedges are

$$\bigl\{
\{\alpha,\beta\},
\{\alpha,\gamma\},
\{\beta,\gamma\}
\bigr\},
\qquad \alpha<\beta<\gamma<\kappa.$$

This triple system is linear: two distinct triangles of a complete graph cannot share two graph edges, because two graph edges of a triangle determine the third edge and the three underlying vertices.

It is uncountably chromatic. A countable vertex-colouring of $T_\kappa$ is a countable edge-colouring of $K_\kappa$. By (8.1) there is a monochromatic subset of cardinality $\aleph_1$, and in particular a monochromatic graph triangle. This is a monochromatic hyperedge of $T_\kappa$.

If a finite triple system $F$ is nonlinear, it has two distinct edges sharing at least two vertices. No injective embedding of those edges can exist in the linear host $T_\kappa$. Thus $T_\kappa$ is $F$-free. ◻

#### Missing-bridge obstruction.

**Proposition 8.2** (Avoidance when the bridge condition fails).

*Let $F$ be finite and linear, and suppose some hyperedge-node of $I(F^\circ)$ is incident with no bridge. Then $F$ is non-obligatory.*

*Proof.* By Lemma 1.1 it is enough to avoid $F^\circ$, so assume that $F$ has no isolated vertices. Take $G=K_{\omega_1}$. Then $\chi(G)>\aleph_0$, and Lemma 6.2 gives

$$\chi(\mathcal L(G))>\aleph_0.$$

If $F$ appeared in $\mathcal L(G)$, retain exactly the host hyperedges corresponding to the edges of $F$. Because the embedding is injective and $F$ is linear, these selected host hyperedges form a finite linear subhypergraph isomorphic to $F$. Corollary 6.4 says that every hyperedge-node of such a trace is incident with a bridge, contradicting the chosen hyperedge of $F$. Therefore $\mathcal L(K_{\omega_1})$ is an uncountably chromatic $F$-free host. ◻

#### Odd-cycle obstruction.

**Proposition 8.3** (Avoidance of an odd Berge cycle).

*Let $F$ be finite and linear, and suppose $F^\circ$ has an odd Berge cycle. Then $F$ is non-obligatory.*

*Proof.* Again suppress isolated vertices. The following dictionary separates the three kinds of cycles in the argument. A *Berge cycle* in a triple system is a simple cycle in its Levi graph, with Levi length twice its Berge length. A *factor cycle* is the corresponding cycle inside one expansion atom $J_s^+$. Its *host trace* is the ordinary cycle in the graph $J_s\subseteq G$ obtained by deleting the private vertices. Berge length and host-cycle length are equal.

Put $m=|E(F)|$. Choose $r$ with $2r+1>m$, and set

$$G=S_r\bigl(\beth_{r-1}(\aleph_0)^+\bigr).$$

**Claim 8.3.1 (the chosen host is large-chromatic and has the required odd-girth bound).** By Lemmas 7.1 and 7.2, $\chi(G)>\aleph_0$, and $G$ has no odd cycle of length at most $m$. Lemma 6.2 then gives

$$\chi(\mathcal L(G))>\aleph_0.\tag*{\(\square\)}$$

**Claim 8.3.2 (cycle localisation).** If $F$ embeds in $\mathcal L(G)$, every Berge cycle in its selected image is contained in a single factor $J_s^+$.

*Proof of Claim 8.3.2.* Retain exactly the host hyperedges corresponding to the hyperedges of $F$. Injectivity of the embedding and linearity of $F$ make them a finite linear trace isomorphic to $F$. Theorem 6.3 assembles this trace by one-point amalgamations. The amalgamation point is a cut vertex of the Levi graph. A simple cycle cannot enter a component through that cut vertex and later leave through it without repeating the vertex. Hence a simple Levi cycle, and therefore a Berge cycle, cannot cross from one factor to another. This is precisely the localisation assertion in Corollary 6.4. ◻

**Claim 8.3.3 (length and parity are preserved).** A Berge cycle of length $\ell$ localised in $J_s^+$ gives an ordinary cycle of length $\ell$ in $J_s\subseteq G$.

*Proof of Claim 8.3.3.* Write the local Berge cycle in alternating form as core vertices and hyperedges. In a private-vertex expansion, each hyperedge contains exactly two core vertices; consecutive hyperedges of the Berge cycle meet at their common core vertex, so their graph edges are consecutive in $J_s$. Simplicity of the Levi cycle makes both the core vertices and the hyperedges distinct; consequently the resulting closed graph walk is a simple graph cycle. There is one graph edge for each hyperedge of the Berge cycle. Thus the graph cycle has length $\ell$, not the Levi length $2\ell$, and in particular has the same parity. ◻

Now suppose that $F$ embeds in $\mathcal L(G)$. Its given odd Berge cycle uses distinct hyperedges, so its length $\ell$ satisfies $\ell\le m$. Claims 8.3.2 and 8.3.3 produce an odd graph cycle of length $\ell$ in $G$, contradicting Claim 8.3.1. Therefore $\mathcal L(G)$ is an uncountably chromatic $F$-free host, and $F$ is non-obligatory. ◻

The three propositions cover every failure of the intrinsic conditions, and prove

$$\neg(3)\Longrightarrow\neg(1). \tag{8.2}$$

# Proof of the classification

Sections 3 and 4 prove $(2)\Longrightarrow(1)$. Section 5 proves $(2)\Longleftrightarrow(3)$, and Section 8 proves the contrapositive $\neg(3)\Longrightarrow\neg(1)$. These implications establish all equivalences in Theorem A. In particular,

$$\begin{gathered}
F\text{ is obligatory}
\iff
F\in\mathcal B,\\[1mm]
F\in\mathcal B
\iff
\begin{array}{l}
F^\circ\text{ is linear},\\[1mm]
\text{every hyperedge-node of }I(F^\circ)
\text{ is incident with a bridge},\\[1mm]
\text{every Berge cycle of }F^\circ\text{ has even length}.
\end{array}
\end{gathered}$$

All embeddings are non-induced: additional host hyperedges on the image vertices are irrelevant throughout. The proof uses only ZFC, the displayed successor cardinals, graph-colouring compactness, and the standard Erdős–Rado relation (8.1). It assumes neither CH nor GCH, and no forcing axiom or large-cardinal hypothesis.

# Formal verification and reproducibility

The complete finite classification in Theorem A has been machine-checked in Lean 4. Its self-contained source file is available in the public [`Erdos593` repository](https://github.com/SamPetkov/Erdos593/blob/main/formalization/Erdos593SelfContained.lean). For every finite triple system $F$, the exported theorems establish $$\begin{aligned}
\mathtt{F.IsObligatory}
&\Longleftrightarrow \mathtt{F.isolatedReduction.Intrinsic},\\
\mathtt{F.IsObligatory}
&\Longleftrightarrow \mathtt{Constructible\ F.isolatedReduction}.
\end{aligned}$$ Thus the development verifies both directions of the classification, including the isolated-vertex reduction. Here “finite” refers to the system $F$ being classified; the host triple systems in the definition of obligatoriness remain unrestricted. The formalisation supplements, rather than replaces, mathematical review.

# Acknowledgments

The author thanks Tom de Groot for his advice on how to revise the manuscript for greater clarity.

# AI assistance

ChatGPT-5.6 Sol Pro and Aristotle [13] were used for proof development, adversarial checking, editorial restructuring, and the Lean formalisation. In particular, the one-apex sequence lift and its finite-linear-trace decomposition were developed with this assistance. The author reviewed all incorporated suggestions and assumes full responsibility for the arguments, citations, and final manuscript.

# Funding

The author received no funding for this work.

# Competing interests

The author declares no competing interests.

# References

[1] Paul Erdős. On some problems in combinatorial set theory. *Publikacije Instituta Matematičkog (Beograd) (N.S.)*, 57(71): 61–65, 1995.

[2] Thomas F. Bloom. Erdős problem 593. <https://www.erdosproblems.com/593>, 2026. Accessed 11 July 2026.

[3] Paul Erdős and András Hajnal. On chromatic number of graphs and set-systems. *Acta Mathematica Academiae Scientiarum Hungaricae*, 17 (1–2): 61–99, 1966. doi: 10.1007/BF02020444.

[4] Paul Erdős, András Hajnal, and Bruce L. Rothschild. On chromatic number of graphs and set-systems. In *Cambridge Summer School in Mathematical Logic (Cambridge, 1971)*, volume 337 of *Lecture Notes in Mathematics*, pages 531–538. Springer, Berlin and New York, 1973.

[5] Paul Erdős, Fred Galvin, and András Hajnal. On set-systems having large chromatic number and not containing prescribed subsystems. In *Infinite and Finite Sets (Keszthely, 1973)*, volume 10 of *Colloquia Mathematica Societatis János Bolyai*, pages 425–513. North-Holland, 1975.

[6] Péter Komjáth. Some remarks on obligatory subsystems of uncountably chromatic triple systems. *Combinatorica*, 21 (2): 233–238, 2001. doi: 10.1007/s004930100021.

[7] András Hajnal and Péter Komjáth. Obligatory subsystems of triple systems. *Acta Mathematica Hungarica*, 119 (1–2): 1–13, 2008. doi: 10.1007/s10474-007-6231-2.

[8] Péter Komjáth. An uncountably chromatic triple system. *Acta Mathematica Hungarica*, 121 (1–2): 79–92, 2008. doi: 10.1007/s10474-008-7179-6.

[9] Christian Reiher. Obligatory hypergraphs. *Proceedings of the American Mathematical Society*, 2024. doi: 10.1090/proc/17021. URL <https://arxiv.org/abs/2403.11223>. Accepted for publication; arXiv:2403.11223.

[10] Eric Li. A resolution of Erdős Problems 593 and 1177: Obligatory triple systems and exact spectra, June 2026. URL <https://arxiv.org/abs/2606.24882>. arXiv:2606.24882.

[11] Nicolaas Govert de Bruijn and Paul Erdős. A colour problem for infinite graphs and a problem in the theory of relations. *Nederl. Akad. Wetensch. Proc. Ser. A*, 54 (5): 371–373, 1951. doi: 10.1016/S1385-7258(51)50053-7.

[12] Paul Erdős and Richard Rado. A partition calculus in set theory. *Bulletin of the American Mathematical Society*, 62 (5): 427–489, 1956. doi: 10.1090/S0002-9904-1956-10036-0.

[13] Tudor Achim, Alex Best, Kevin Der, Mathïs Fédérico, Sergei Gukov, Daniel Halpern-Leistner, Kirsten Henningsgard, Yury Kudryashov, Alexander Meiburg, Martin Michelsen, Riley Patterson, Eric Rodriguez, Laura Scharff, Vikram Shanker, Vladimir Sicca, Hari Sowrirajan, Aidan Swope, Matyas Tamas, Vlad Tenev, Jonathan Thomm, Harold Williams, and Lawrence Wu. *Aristotle*: IMO-level automated theorem proving, 2025. URL <https://arxiv.org/abs/2510.01346>. arXiv:2510.01346.
