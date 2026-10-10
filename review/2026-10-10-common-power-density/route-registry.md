# Distinct routes and verified source scope

## Verdict

The unrestricted target remains open in this consultation. There is no certified actual-host counterexample. The proved results are in [research-note.md](research-note.md), with the separate literature-based class in [tp2-class.md](tp2-class.md). The bounded numerical record is in [numerical-report.md](numerical-report.md). This registry distinguishes mechanisms, their exact outputs, and their actual blockers; a failed sufficient assertion is not counted as failure of the target.

The current consultation continued after the user expressly requested further research and PRs. The work used three actual independent agents, with separate mathematical and numerical tasks, followed by adversarial review. Review provenance and file hashes appear in [final-review.json](final-review.json). These are analytical agent reviews, not external mathematical refereeing or formal-kernel acceptance.

## Route registry

| Route | Distinct mechanism | Proved or certified output | Remaining scope |
| --- | --- | --- | --- |
| A. Collective multiplication tensor | Retain all proper centered cores and the constant contribution; cancel the entire full-tetrahedron coefficient under independent edge resampling. | Unconditional inequality (3), exact identity (4), decreasing normalized defect (5), and transport of any strict violation to an actual-root zero. | The complete tetrahedral coefficient can have either sign. The ray reduction alone does not decide its admissible endpoint. |
| B. Reversible block refinement | Condition on coarse colors; proper fiber subgraphs integrate to at least one, while the all-one-fiber deficit has an exact coefficient. | Inequality (11), the arbitrary-inner budget (14), and entrywise recognition condition (15). Weighted examples have three or more interacting centered bands, including a genuine zero mode. | Constant off-diagonal blocks and the coarse surplus hypothesis are substantive structure. An arbitrary actual root is not thereby certified. |
| C. Finite covers and monotonicity | Bound every cover from above, and use one family of locally consistent types to obtain an asymptotic lower bound. | The TP2 finite-chain class, its finite convex hull at the base-graph level, and original-measure composition closure. | The unrestricted unequal-common-power cover bound is unproved. It is the one theorem-strength obligation stated below. |
| D. Admissible optimization | Parametrize an actual reversible root by symmetric nonnegative flux; test the original density and cover comparisons, including root-boundary projections. | Reproducible finite searches and an exact integer verification engine. No target or cover violation was certified. | Sampled and optimized hosts do not quantify over all finite hosts, weights, or exponent tuples. An optimizer stopping successfully is not an inequality proof. |

### The negative mode is retained faithfully

The supplied six-sign 32-state host has an actual strictly positive Markov root and an actual source with negative modewise quantity at the specified exponents. That defeats the attempted claim that each mode contributes nonnegatively. It does not give a negative total density defect: the constant mode and proper-cycle/diamond surplus remain. This packet neither substitutes arbitrary functions for the actual cubic sources nor presents that host as a counterexample to the target.

### A two-sheet tensor diagnostic

For paired states $x=(x_1,x_2)$ and $y=(y_1,y_2)$, on the original product measure $\mu\otimes\mu$, set

$$
\begin{aligned}
P_j(x,y)&=K_j(x_1,y_1)K_j(x_2,y_2)+K_j(x_1,y_2)K_j(x_2,y_1),\\
D_j(x,y)&=K_j(x_1,y_1)K_j(x_2,y_2)-K_j(x_1,y_2)K_j(x_2,y_1).
\end{aligned}
$$

The tensor transport uses exactly this product measure. Expanding the two finite sums shows

$$
\bigl[(B\otimes C)(D\otimes E)\bigr](x,y)
=\sum_{z_1,z_2}\mu_{z_1}\mu_{z_2}
B(x_1,z_1)C(x_2,z_2)D(z_1,y_1)E(z_2,y_2)
=[BD\otimes CE](x,y).
$$

In particular, $T\otimes T$ is nonnegative, symmetric, and Markov on the original product measure, and its square is $A\otimes A$. No conditional or rescaled measure is substituted. Coordinate swap is unitary for that same product measure. If tensor-product densities are formed, their full original-measure sum factors by the two coordinates, giving $F(T\otimes R;n)=F(T;n)F(R;n)$ with the respective product probability; this identity is not used to infer an unrestricted theorem here.

If $\mathsf S$ swaps the two coordinates and $P_\pm=(I\pm\mathsf S)/2$, these operators are exactly

$$
P_j=2(A\otimes A)^jP_+,
\qquad D_j=2(A\otimes A)^jP_-.
$$

Both are PSD commuting families on their invariant sectors; $D_j$ need not be entrywise nonnegative. Expanding a two-cover and swapping replicas at each vertex kills every edge subset of odd degree somewhere. For $K_4$, the survivors are the empty subset, its four triangles, and its three quadrilaterals. A cycle coefficient is

$$
c_C=2^{-6}\mathbb E_{(\mu\otimes\mu)^4}
\prod_{e\in C}D_{n_e}\prod_{e\notin C}P_{n_e}.
$$

The outside-edge factors produce multiplication operators. PSD of the sector operators does not establish a sign for this integral: in particular, traces of products of three or more PSD operators have no general nonnegative-sign rule. Individual cycle-coefficient positivity would be stronger than the required complete-cover comparisons. This diagnostic did not produce a proof or a certified counterexample, and it is not asserted as a second missing global lemma.

## One exact outstanding sufficient obligation

For the requested actual host and tuple, every positive integer $M$, and every set of edge permutations $\sigma_e\in S_M$, define

$$
Z_\sigma=\sum_{x\in X^{V(K_4)\times[M]}}
\prod_{v,i}\mu_{x_{v,i}}
\prod_{e=vw}\prod_{i=1}^M
K_{n_e}(x_{v,i},x_{w,\sigma_e(i)}).
$$

The unproved obligation is

$$
Z_\sigma\le F(T;n)^M.
$$

Without any TP2 assumption, the supported rational-type argument in the TP2 note still proves

$$
\limsup_{M\to\infty}(\mathbb E_\sigma Z_\sigma)^{1/M}\ge1.
$$

To see the logical distinction, that lower estimate merely retains a family of assignments and edge permutations with locally consistent beliefs $b_v=\mu$, $b_e(x,y)=\mu_x\mu_yK_{n_e}(x,y)$. Its entropy and kernel-energy terms cancel. The proposed cover upper comparison is a genuinely additional statement about different finite graphs and would complete this route. No purported proof is supplied. Failure of that stronger comparison, if one is eventually found, would not by itself disprove $F\ge1$.

## Primary literature: hypotheses checked

### Ruozzi: log-supermodular cover bounds

Nicholas Ruozzi, [*The Bethe Partition Function of Log-supermodular Graphical Models*](https://arxiv.org/abs/1202.6035), 2012, Theorem 3.8 gives the Boolean $2k$-functions inequality; Theorem 4.1 gives graph-cover domination for the relevant nonnegative log-supermodular factorization. The finite-chain proof here uses threshold-word encoding, a sublattice support, zero extension, and sorting. Original node weights remain explicit.

Ruozzi, [*Beyond Log-Supermodularity: Lower Bounds and the Bethe Partition Function*](https://arxiv.org/abs/1309.6859), 2013, explicitly discusses finite distributive lattices and total orders in its introduction. Thus the chain extension is an application of known results. The convex-hull result uses multilinearity of the base partition function; it does **not** claim that arbitrary mixtures preserve cover domination.

### Sah–Sawhney–Stoner–Zhao: the same edge kernel

Ashwin Sah, Mehtaab Sawhney, David Stoner, and Yufei Zhao, [*A reverse Sidorenko inequality*](https://arxiv.org/abs/1809.09462), version 3, Theorem 1.14, proves clique maximality for a single nonnegative PSD interaction kernel. Every $M$-cover of $K_4$ is cubic, so the equal-edge-kernel case yields its cover density at most the $M$th power of the base $K_4$ density. The paper allows vertex weights, so finite original-measure weights present no obstacle. Theorem 5.1 adds vertex/list factors; it still uses one shared edge interaction. It does not state the comparison for six unequal powers. Completely positive factorizations of the actual squares do not remove that unproved step.

### Subdivision and group-class results

The earlier source check also examined Im, Li, and Liu, [*Sidorenko's conjecture for subdivisions and theta substitutions*](https://www.cambridge.org/core/journals/combinatorics-probability-and-computing/article/sidorenkos-conjecture-for-subdivisions-and-theta-substitutions/7587A22E3A717B29DBAB2A6E99875345). Theorem 1.4 imposes divisibility by $\binom h2$ on the number of paths of each length; six single edges with arbitrary unequal subdivision lengths do not automatically meet it. Theorem 1.6 has specific star-versus-clique length groupings, which are not the general prescribed pattern here.

Yuqi Zhao, [*Conjugacy Class Averages and Sidorenko's Conjecture*](https://arxiv.org/abs/2606.15368), Theorem 1.4, addresses the stated subdivision inequalities for its real class Cayley kernels. It is useful positive coverage for that host class. A comparison between a general actual host and a suitable conjugacy-class average remains an additional assertion; the averaging cannot be silently treated as original-measure normalization.

These checks identify precise available results and their hypotheses. They establish no absence-of-prior-work or novelty claim for the present structural corollaries.
