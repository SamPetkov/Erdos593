# Proof audit gate 1: uniform cycle collapse

**Parent audit:** issue #20  
**Gate issue:** issue #25  
**Proof source:** PR #21, Theorem 4.1  
**Status:** internally passed after an indexed rewrite and adversarial assumption tests; independent mathematical review remains required.

This audit concerns only the cycle-collapse lemma. It does not certify the later apex-bridge, derivative-embedding, cycle-descent, bridge-persistence, chromatic, or final-classification steps.

## 1. Sharpened statement

Fix an integer $s\ge 2$. Let $H$ be an edge-indexed $s$-uniform hypergraph and let

$$
\operatorname{Lift}(H)
$$

be a one-apex lift in which each target edge has the form

$$
B(σ,a)\cup\{(τ,z)\},
\qquad
σ\lhd τ,
\qquad
B(σ,a)=\{(σ,x):x\in a\},
\qquad |a|=s,
$$

with $a=τ(\operatorname{lh}σ)$.

Let

$$
v_0,e_0,v_1,e_1,\ldots,v_{m-1},e_{m-1},v_0,
\qquad m\ge 3,
$$

be a Berge cycle in a source hypergraph, embedded by a vertex-injective, edge-injective, exact edge-set-preserving map into the lift. Assume only that the distinct source edges

$$
e_0,\ldots,e_{m-1}
$$

are pairwise linear:

$$
|e_i\cap e_j|\le 1\qquad(i\ne j).
$$

Write the image of $v_i$ as $(ν_i,ξ_i)$. Then

$$
ν_0=ν_1=\cdots=ν_{m-1}.
$$

Thus the cycle-collapse statement is local to the displayed cycle. The whole source hypergraph need not be finite or globally linear.

## 2. Indexed proof

All subscripts below are read modulo $m$, and $e_i$ contains the two consecutive connector points $v_i,v_{i+1}$.

### C1. Consecutive connector nodes are comparable

A lifted edge has points at exactly two sequence nodes: its repeated base node and its unique apex node. Hence, for every $i$, either

$$
ν_i=ν_{i+1},
$$

or one of $ν_i,ν_{i+1}$ is a proper prefix of the other.

**Audit status:** passed. This uses only the full-base-plus-one-apex edge shape.

### C2. A minimum connector is a prefix of every connector

Choose $j$ such that $ν_j$ has minimum ordinal length. Rotate the cycle so that $j=0$, and put

$$
σ=ν_0,
\qquad
d=\operatorname{lh}(σ).
$$

We prove inductively along the cyclic order that

$$
σ\preccurlyeq ν_i
\qquad(0\le i<m).
$$

Assume $σ\preccurlyeq ν_i$. If $ν_i\preccurlyeq ν_{i+1}$, the claim is immediate. Otherwise

$$
ν_{i+1}\preccurlyeq ν_i.
$$

Both $σ$ and $ν_{i+1}$ are prefixes of $ν_i$, and minimum length gives

$$
d\le\operatorname{lh}(ν_{i+1}).
$$

Prefixes of one sequence are linearly ordered by length, so

$$
σ\preccurlyeq ν_{i+1}.
$$

In particular, every connector of length $d$ is equal to $σ$.

**Audit status:** passed. This handles transfinite lengths and arbitrary non-immediate prefix jumps; no cofinality assumption is used.

### C3. Select a maximal above-minimum cyclic interval

Suppose some connector node is strictly above $σ$. After a second cyclic rotation if necessary, choose a maximal nonempty interval

$$
ν_1,ν_2,\ldots,ν_t
$$

such that

$$
σ\lhd ν_i\quad(1\le i\le t),
$$

and

$$
ν_0=ν_{t+1}=σ.
$$

The equality $ν_{t+1}=σ$ is an equality of node values at a boundary connector occurrence. If the minimum node occurs only once on the cycle, then $t=m-1$ and the two boundary occurrences are the same connector occurrence $v_0$, approached from opposite sides.

The two boundary hyperedges are $e_0$ and $e_t$. They are distinct because Berge-cycle edge indices are distinct. In the unique-minimum subcase, $t=m-1$, so the second boundary edge is $e_{m-1}$; it is still distinct from $e_0$ because $m\ge3$.

**Audit status:** passed. The original proof was correct but compressed the distinction between a connector occurrence and its sequence-node value; this indexed form removes that ambiguity.

### C4. The first new coordinate is constant on the interval

For $1\le i\le t$, define

$$
a_i=ν_i(d).
$$

This is defined because $\operatorname{lh}(ν_i)>d$. Consecutive nodes $ν_i,ν_{i+1}$ are comparable and both extend $σ$, so they agree at coordinate $d$. Therefore

$$
a_1=a_2=\cdots=a_t=:a.
$$

**Audit status:** passed. Comparability, not merely common extension of $σ$, is the key input.

### C5. The two boundary edges contain the same complete base

The edge $e_0$ has connectors at the two distinct nodes $σ$ and $ν_1$. Since $σ\lhd ν_1$, these must be respectively the base and apex nodes of the lifted image of $e_0$. Its base-edge index is

$$
ν_1(d)=a.
$$

Hence the target edge contains

$$
B=B(σ,a)=\{(σ,x):x\in a\}.
$$

Likewise, $e_t$ has connectors at $ν_t$ and $σ$, with $σ\lhd ν_t$, so its target image contains the same complete base $B$, because

$$
ν_t(d)=a.
$$

**Audit status:** passed. No immediate-extension assumption is present.

### C6. Pull the common base back to the source

The set $B$ has exactly $s$ distinct target vertices. Exact edge-set preservation says every point of $B$ is the image of a source point of $e_0$ and also of a source point of $e_t$. Vertex injectivity forces these preimages to be the same $s$ source points. Consequently

$$
|e_0\cap e_t|\ge s\ge2.
$$

But $e_0\ne e_t$, contradicting pairwise linearity of the cycle edges.

Therefore no connector lies strictly above $σ$, and all connector nodes equal $σ$.

**Audit status:** passed.

## 3. Hypothesis audit

| Hypothesis | Status | Reason |
|---|---|---|
| $s\ge2$ | Essential | For $s=1$, a complete-rank lift of one singleton edge contains a linear graph triangle whose three connector nodes are distinct. |
| Pairwise linearity of cycle edges | Essential | Removing it gives explicit noncollapsed Berge triangles; the two boundary edges share the complete base. |
| Global source linearity | Stronger than needed | Only the edges on the displayed cycle need be pairwise linear. |
| Global source finiteness | Not used | A Berge cycle is finite by definition; the minimum and interval arguments occur inside that cycle. |
| Infinite $κ$ | Not used here | It is needed for the chromatic construction, not for collapse. |
| Complete-rank saturation | Not used locally | Collapse holds in any sublift whose edges retain the same full-base-plus-one-apex form. |
| Simplicity of $H$ | Construction-level | It makes the extensional lift simple and permits recovery of an indexed base edge; the minimum-node contradiction itself only uses the common $s$-point base. |
| Distinct cycle edge indices | Essential | It distinguishes the two boundary edges, including the unique-minimum occurrence case. |
| Vertex injectivity | Essential | It identifies the two source preimages of each target base point. |
| Exact edge-set preservation | Essential | Incidence preservation in one direction alone would not show that the full target base pulls back into both source edges. |

## 4. Explicit sharpness certificates

### 4.1 Dropping linearity

Take $H=K_3$, let $a=\{0,1\}$, and use the nodes

$$
\varnothing,
\qquad
(a),
\qquad
(a,a).
$$

The three lifted edges

$$
\begin{aligned}
E_0&=B(\varnothing,a)\cup\{((a),0)\},\\
E_1&=B(\varnothing,a)\cup\{((a),1)\},\\
E_2&=B((a),a)\cup\{((a,a),0)\}
\end{aligned}
$$

form a Berge triangle with connectors

$$
((a),0),
\qquad
(\varnothing,0),
\qquad
((a),1).
$$

Their connector nodes are $(a),\varnothing,(a)$, so collapse fails. Precisely as predicted by the proof, the two boundary edges $E_0,E_1$ share the full two-point base $B(\varnothing,a)$, so the source is not linear.

The exhaustive relaxed search in `FullLift_2(K3)` finds 162 noncollapsed Berge triangles. Every one has:

- exactly one minimum connector occurrence;
- two boundary edges sharing the complete two-point base;
- at least one non-linear edge pair;
- no pairwise-linear counterexample.

### 4.2 Dropping $s\ge2$

Let the base be the one-uniform hypergraph with one vertex $x$ and one edge $\{x\}$. At nodes

$$
\varnothing\lhd(a)\lhd(a,a),
$$

the complete-rank lift contains the graph edges

$$
\{(\varnothing,x),((a),x)\},
\quad
\{(\varnothing,x),((a,a),x)\},
\quad
\{((a),x),((a,a),x)\}.
$$

They form a simple graph triangle, hence a linear two-uniform source, but its three connector nodes are distinct. Thus $s\ge2$ is sharp.

## 5. Computational evidence

The pre-existing direct adversary in PR #21 checked

$$
2{,}818{,}435
$$

pairwise-linear Berge cycles, including

$$
2{,}795{,}352
$$

cycles using at least one non-immediate prefix jump, with zero collapse or projection failures.

The audit script adds assumption-removal tests and machine-readable minimal counterexamples. It does not increase the epistemic status beyond finite evidence.

## 6. Audit verdict

No logical gap was found in the cycle-collapse mechanism after expanding it into the indexed steps C1--C6. The proof can be sharpened from global finite linearity to pairwise linearity of the displayed cycle edges.

The gate is **internally passed but externally open**. Issue #25 should remain open until an independent reader checks the indexed proof. The next gate—selected apex incidence is a bridge—must remain formally blocked until then.

## 7. Lean target

The preferred formal target is cycle-local:

```text
cycleEdgesPairwiseLinear c
→ all connector sequence nodes of c are equal
```

This avoids carrying irrelevant global finiteness and linearity assumptions into the most delicate theorem. A useful decomposition is:

1. adjacent connector-node comparability;
2. minimum connector prefix propagation;
3. maximal cyclic interval above the minimum;
4. first-new-coordinate constancy;
5. common boundary-base extraction;
6. pullback of an `s`-point intersection.
