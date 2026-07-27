# Erdős 593 manuscript audit: copy-ready line edits

These edits implement the precision corrections identified in
`MANUSCRIPT_THEOREM_BY_THEOREM_AUDIT.md`.  They do not change a theorem
statement, proof strategy, attribution boundary, or asymptotic formula.  Line
numbers should be resolved against the canonical TeX at integration time.

## 1. Abstract: all bridges, not selected bridges

Replace

```tex
while the intrinsic decomposition deletes selected Levi-graph bridges and
reassembles the resulting expansion pieces along a quotient forest.
```

by

```tex
while the intrinsic decomposition deletes all Levi-graph bridges and
reassembles the resulting expansion pieces along a quotient forest.
```

Reason: Proposition 5.2 uses the components of `I(F)-B(I(F))`, where `B(I(F))`
is the complete bridge set.

## 2. Theorem A assembly: make isolated reduction explicit

After the displayed equivalence `(2) <-> (3)`, insert

```tex
Here Proposition~\ref{proposition-5.2-bridge-block-decomposition} is applied to
$F^\circ$; Lemma~\ref{lemma-1.1-isolated-vertex-reduction} then converts
$F^\circ\in\mathcal B$ back to $F\in\mathcal B$.
```

Reason: item (ii) of Theorem A is stated for `F`, while the intrinsic condition
and the bridge-block proposition are stated after isolated vertices are
removed.

## 3. Closure-chain lemma: define the successor step precisely

Replace the first two proof sentences by

```tex
Choose sets $A_i\subseteq\kappa$, each of cardinality below $\kappa$, whose
union is $\kappa$.  Given $M_i$, let $M_{i+1}$ be the closure of
$M_i\cup A_i$ under $\Phi$, obtained by iterating the finite-arity operation
$\omega$ times.  If the seed is infinite of cardinality $\mu<\kappa$, this
closure still has cardinality at most $\mu$; a finite seed may grow to a
countable set, which is still smaller than the uncountable cardinal $\kappa$.
```

Retain the existing limit-stage argument afterward.

Reason: “does not increase an infinite cardinal” is correct but does not
explicitly cover finite seeds or define `M_{i+1}`.

## 4. Complete-bipartite subgraph lemma: expose the minimality interface

Replace

```tex
By minimality of $\kappa$, every induced graph $G[I_i]$ is countably
chromatic.
```

by

```tex
Each induced graph $G[I_i]$ is still $K_{n,n}$-free and has cardinality below
$\kappa$.  By the minimality of $\kappa$, it is therefore countably chromatic.
```

Reason: both hypotheses needed for the minimal-counterexample argument should
be stated.

## 5. Bridge-block decomposition: rule out loops in the suppressed core

After

```tex
Contract each such $e$ to an ordinary graph edge between those two
point-neighbours.  This produces a finite graph $J_C$.
```

insert

```tex
The two endpoints of every contracted edge are distinct, since a hyperedge is
a three-element set; thus $J_C$ has no loops.
```

Then retain the current parallel-edge argument proving simplicity.

## 6. Finite trace corollary: prove bridge preservation under amalgamation

Replace

```tex
In every $J_s^+$ the incidence with the private vertex is a bridge. Bridgehood
is preserved by one-point amalgamation.
```

by

```tex
In every $J_s^+$ the incidence with the private vertex is a bridge.  A
one-point amalgamation is a vertex-sum of Levi graphs.  Removing such a bridge
still separates the same component on its original side, because the other
factor meets it only at the amalgamation vertex; hence bridgehood is preserved.
```

Reason: this is the only graph-theoretic step used to transfer one bridge per
edge from the fibres to the full trace.

## 7. Component-spectrum merge inequality: write the literal algebra

Replace

```tex
because, after squaring, the assertion reduces to
$(a-1)(b-1)\ge0$; taking ceilings gives (10.5).
```

by

```tex
because
\[
 \bigl(\sqrt a+\sqrt b-1\bigr)^2-(a+b-1)
   =2(\sqrt a-1)(\sqrt b-1)\ge0.
\]
Both sides of the desired inequality are nonnegative, so this proves
$\sqrt a+\sqrt b\ge\sqrt{a+b-1}+1$.  Multiplying by two and taking ceilings
gives (10.5).
```

Reason: the old conclusion is correct, but the displayed calculation now
matches exactly one squaring of the stated inequality.

## 8. Unrestricted spectrum: add the missing lower-bound necessity

At the beginning of the proof of Corollary
`connected-order-size-spectrum`, after the connected case, insert

```tex
For arbitrary component count $c$, repeated application of (10.5) gives
\[
 q(m-c+1)+2(c-1)\ge q(m).
\]
Thus the lower endpoint in Theorem~\ref{theorem-order-size-component-spectrum}
is never below the connected lower endpoint
$m+\lceil2\sqrt m\rceil$.
```

After the sentence adjoining isolated vertices, add

```tex
Conversely, deleting isolated vertices leaves the edge count unchanged and
produces a reduced obligatory system, so the same lower bound remains
necessary.
```

Reason: the current proof gives the constructions but leaves these two
necessity statements implicit.

## 9. Bipartite shadow: state why the shadow has no isolated vertices

After constructing each connected shadow `J_H`, insert

```tex
Every graph piece has at least one edge and is taken without isolated
vertices; a one-point sum cannot create an isolated vertex.  Hence $J_H$ has
none.
```

Reason: “without isolated vertices” is part of the lemma statement and should
be checked explicitly.

## 10. Formalisation scope: distinguish the odd-cycle routes

Replace the current formal-verification paragraph by a version containing the
following explicit scope sentence:

```tex
The ordinary proof above invokes the classical Erdős--Hajnal high-odd-girth
theorem.  The Lean development proves the same classification endpoint through
an explicit shift-graph high-odd-girth host and a closed-walk transfer theorem;
it is therefore a formal verification of the stated classification, not a
line-by-line encoding of every intermediate paragraph of the manuscript.
```

Then add

```tex
The finite parameter results of Section~\ref{finite-parameter-consequences} are
conventional consequences of the classification supported by exact integer
checks; they are not presently claimed as separate public Lean endpoints.
```

Reason: this states the actual formal trust boundary without weakening the
complete classification claim.

## Integration protocol

A publication integration PR should:

1. apply these edits to `erdos593_obligatory_triple_systems.tex`;
2. regenerate every deterministic TeX/Markdown/PDF/arXiv mirror;
3. update the manifest and checksums;
4. run `scripts/audit_manuscript_theorems.py`;
5. rerun the bridge-core certificate checker;
6. compile the complete Lean endpoints with warnings treated as errors;
7. visually inspect the regenerated PDF.
