# Copy-ready standard-definition patches for Erdős 593

These edits standardise terminology without changing any mathematical content.
They should be applied to the canonical TeX in a later publication-integration
PR, followed by regeneration of every synchronized artifact.

## Patch 1: weak chromatic number

### Current

```tex
A colouring \(c:V(H)\to\lambda\) is \emph{proper} when no hyperedge is
monochromatic, and \(\chi(H)\) is the least cardinal \(\lambda\) admitting
such a colouring.
```

### Replace with

```tex
Throughout, chromatic number means the weak vertex chromatic number.  A
colouring \(c:V(H)\to\lambda\) is \emph{proper} (equivalently, weakly
proper) when no hyperedge is monochromatic, and \(\chi(H)\) is the least
cardinal \(\lambda\) admitting such a colouring.
```

### Reason

Hypergraph theory also uses strong/rainbow colouring.  The manuscript uses the
standard weak notion throughout and should say so once.

## Patch 2: Levi graph synonym

### Current

```tex
Its \emph{Levi graph} \(I(F)\) is the bipartite graph with classes \(V(F)\)
and \(E(F)\), where a point-node \(p\) is adjacent to a hyperedge-node \(e\)
exactly when \(p\in e\).
```

### Replace with

```tex
Its \emph{Levi graph} (or incidence graph) \(I(F)\) is the bipartite graph
with classes \(V(F)\) and \(E(F)\), where a point-node \(p\) is adjacent to a
hyperedge-node \(e\) exactly when \(p\in e\).
```

### Reason

Both names are standard.  Giving the synonym helps readers outside design and
incidence geometry.

## Patch 3: Berge-cycle length convention

### Current

```tex
A \emph{Berge cycle of length} \(\ell\ge2\) consists of distinct points
\(p_0,\ldots,p_{\ell-1}\) and distinct hyperedges
\(e_0,\ldots,e_{\ell-1}\) such that \(p_i\in e_i\cap e_{i+1}\), with
indices modulo \(\ell\). Equivalently, it is a simple cycle of length
\(2\ell\) in \(I(F)\).
```

### Replace with

```tex
A \emph{Berge cycle of length} \(\ell\ge2\) consists of distinct points
\(p_0,\ldots,p_{\ell-1}\) and distinct hyperedges
\(e_0,\ldots,e_{\ell-1}\) such that \(p_i\in e_i\cap e_{i+1}\), with
indices modulo \(\ell\).  Its length is the number \(\ell\) of hyperedges
(and connector points); equivalently, it is a simple cycle of length
\(2\ell\) in \(I(F)\).  In a linear triple system one automatically has
\(\ell\ge3\).
```

### Reason

This prevents the phrase `even Berge cycle` from being misread as referring to
the always-even Levi-cycle length.

## Patch 4: one-point amalgamation synonym

### Current

```tex
A \emph{one-point amalgamation} of vertex-disjoint triple systems
\(F_0,F_1\) is obtained by choosing \(x_i\in V(F_i)\), identifying \(x_0\)
with \(x_1\), and making no other identifications or new hyperedges.
```

### Replace with

```tex
A \emph{one-point amalgamation} (one-vertex sum) of otherwise
vertex-disjoint triple systems \(F_0,F_1\) is obtained by choosing
\(x_i\in V(F_i)\), identifying \(x_0\) with \(x_1\), and making no other
identifications and adding no new hyperedges.
```

### Reason

The original definition is correct.  The synonym and parallel grammar make the
construction immediately recognizable.

## Patch 5: Section 10 parameter conventions

### Current opening

```tex
In this section a triple system is \emph{connected} when its Levi graph is
connected.  We work first without isolated vertices.
```

### Replace with

```tex
In this section the \emph{order} and \emph{size} of a finite triple system
are respectively its numbers of vertices and hyperedges.  The system is
\emph{connected} when its Levi graph is connected, and its connected
components are the components of that Levi graph.  We work first without
isolated vertices.
```

### Reason

These are standard conventions, but the numerical theorems should state them
before using `order`, `size`, and `components` simultaneously.

## Patch 6: cycle-rank terminology

### Current

```tex
The cyclomatic number of its Levi graph is
```

### Replace with

```tex
The cycle rank (cyclomatic number) of its Levi graph is
```

### Reason

`Cycle rank` is the most immediately recognizable term in graph theory, while
`cyclomatic number` is also standard.

## Patch 7: non-induced finite trace

Retain the phrase `finite, not necessarily induced, linear subhypergraph` in
Theorem 6.3.  Do not shorten it to `finite induced subhypergraph` or leave the
containment convention implicit.

## Patch 8: Theorem A isolated-reduction interface

After the proof-of-classification paragraph, add:

```tex
For the implication from the intrinsic condition to constructibility, apply
Proposition~\ref{proposition-5.2-bridge-block-decomposition} to \(F^\circ\)
and then use Lemma~\ref{lemma-1.1-isolated-vertex-reduction} to restore the
isolated vertices.
```

This is not a definition change, but it makes the standard isolated-reduction
interface explicit.

## Publication instruction

After applying these patches:

1. regenerate root, arXiv, PDF, and Markdown mirrors;
2. rerun the theorem-by-theorem manuscript audit;
3. rerun the complete Lean endpoint workflow;
4. visually inspect every definition and Theorem A in the rendered PDF.