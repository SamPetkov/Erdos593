# Erdős 593: external theorem interface audit

## Scope

This audit checks every external result named in the Problem 593 manuscript
against the exact form in which it is used.  The purpose is not to reprove the
classical results.  It is to verify that the manuscript does not strengthen an
imported theorem silently, omit a cardinal hypothesis, confuse induced and
non-induced containment, or use a theorem outside its stated parameter range.

The principal comparison sources are:

- N. G. de Bruijn and P. Erdős, *A colour problem for infinite graphs and a
  problem in the theory of relations* (1951), pp. 371--373;
- P. Erdős and R. Rado, *A partition calculus in set theory* (1956), Theorem
  4(i), formula (95), p. 471;
- P. Erdős and A. Hajnal, *On chromatic number of graphs and set-systems*
  (1966), Theorem 7.4, p. 76, as quoted in Erdős--Galvin--Hajnal (1975),
  Theorem C, p. 428;
- P. Erdős, A. Hajnal, and B. Rothschild, *On chromatic number of graphs and
  set-systems* (1973), Theorem 2, p. 532;
- C. Reiher, *Obligatory hypergraphs*, arXiv:2403.11223, Theorem 1.2;
- E. Li, *A Resolution of Erdős Problems 593 and 1177*, arXiv:2606.24882v2,
  Theorem 1.1 and Sections 3--5.

Li's v2 contains an explicit external-interface section and provides a useful
parallel point of comparison for the older theorem substitutions.  Reiher's
theorem is checked from his own paper.

## Verdict

**PASS.**  No imported theorem is used outside its verified interface.  The
classification proof remains a ZFC argument with the following actual black-box
inputs:

1. finite-colouring compactness for graphs;
2. one pair-partition relation of Erdős--Rado;
3. existence of uncountably chromatic graphs with prescribed finite odd girth.

Reiher's expansion theorem and Li's bridge-trace theorem are cited for
attribution and comparison, but the manuscript supplies its own direct
expansion-atom proof and its own fibre-forest proof of the finite trace
consequence it needs.  They are therefore not hidden proof premises.

Four publication clarifications are recommended at the end of this audit.

---

## 1. De Bruijn--Erdős compactness

### Source interface

For a fixed finite integer `k`, an infinite graph is `k`-colourable if every
finite subgraph is `k`-colourable.

### Manuscript use

Lemma 1.3 starts with an orientation of an arbitrary graph in which every
vertex has outdegree at most `d<omega`.  Every finite subgraph has at most
`d|V|` edges, hence has a vertex of degree at most `2d`; iterative deletion
makes every finite subgraph `(2d+1)`-colourable.  Compactness then gives a
`(2d+1)`-colouring of the whole graph.

### Check

- The number of colours is finite.
- The finite-subgraph hypothesis is proved before compactness is invoked.
- No local-finiteness hypothesis is required.
- The argument does not claim an effective colouring.

**Status: exact interface match.**

Recommended wording: call this the `finite-colouring compactness theorem of de
Bruijn and Erdős` at first use.  This prevents confusion with unrelated results
bearing the same names.

---

## 2. Erdős--Rado pair relation

### Source interface

The manuscript uses

```text
(2^{aleph_0})^+ -> (aleph_1)^2_{aleph_0}.
```

This is the pair case of the Erdős--Rado theorem with `kappa=aleph_0`.

### Manuscript use

The vertices of the nonlinear-obstruction triple system are pairs in
`[kappa]^2`, where `kappa=(2^{aleph_0})^+`.  A countable colouring of these
vertices is a countable colouring of the pairs of `kappa`.  The partition
relation supplies an `aleph_1`-sized homogeneous set, and any three members of
that set give a monochromatic hyperedge.

### Check

- The carrier cardinal is exactly the left side of the partition relation.
- The exponent is two, matching a colouring of unordered pairs.
- The number of colours is at most `aleph_0`.
- The conclusion needed is only a homogeneous triple, weaker than the
  `aleph_1`-sized homogeneous set supplied.
- The resulting triple system is linear: two distinct triangles of a complete
  graph cannot share two graph edges.

**Status: exact interface match.**

No continuum hypothesis is used.  The successor cardinal
`(2^{aleph_0})^+` is available in ZFC.

---

## 3. Erdős--Hajnal high odd girth

### Source interface

For every positive integer `i` there is an uncountably chromatic graph
containing no cycle `C_{2j+1}` for `0<j<i`.  Li's exact-interface restatement
records the stronger cardinal-calibrated form, but the present manuscript uses
only existence of an uncountably chromatic graph.

### Manuscript substitution

Given `m>=1`, choose `i` such that `2i-1>=m`.  The excluded odd lengths
`3,5,...,2i-1` then include every odd cycle length at most `m`.

### Check

- The parameter substitution is correct for both even and odd `m`.
- `contains no C_l` means no ordinary, not-necessarily-induced cycle.
- The lift trace produces an ordinary graph cycle of the same Berge length, so
  the source theorem is used at exactly the required notion of containment.
- The manuscript does not require high ordinary girth: even cycles are allowed.

**Status: exact interface match.**

Recommended wording: use `odd girth greater than m` rather than `prescribed odd
girth` when describing the chosen host.  The theorem gives a lower bound, not
an assertion that the odd girth is exactly a prescribed integer.

---

## 4. Erdős--Hajnal--Rothschild nonlinear obstruction

### Literature interface

The `i=2` case of their theorem gives an uncountably chromatic uniform
hypergraph in which distinct edges do not share two vertices.  Consequently a
finite uniform hypergraph with two edges meeting in at least two vertices is
non-obligatory.

### Manuscript route

The manuscript proves the triple-system case directly from the Erdős--Rado
pair relation, using the hypergraph of graph triangles on `[kappa]^2`.

### Check

- The direct construction proves precisely what is needed for triple systems.
- The historical attribution to Erdős--Hajnal--Rothschild is correct.
- Their theorem is not used as an additional black box in the written proof.

**Status: correct attribution; direct proof supplied.**

---

## 5. Reiher's expansion theorem

### Source interface

Reiher's Theorem 1.2 states that for all integers `r>=2` and `n>=1`, the
`r`-uniform expansion of `K_{n,n}` is obligatory.  At `r=3` this is exactly the
private-vertex expansion `K_{n,n}^+`.

Reiher also records the established closure of obligatory uniform hypergraphs
under finite disjoint unions and one-point amalgamations.

### Manuscript use

The introduction identifies Reiher's theorem as the established source of the
positive atoms.  The manuscript then gives a separate direct proof of
`K_{n,n}^+` and complete proofs of the two closure operations.

### Check

- The parameter specialization `r=3` is exact.
- The manuscript does not use a theorem about arbitrary bipartite expansions;
  it reduces those to a balanced complete bipartite expansion by ordinary graph
  embedding.
- Since containment is non-induced, a copy of `K_{N,N}^+` contains `J^+` for
  every finite bipartite `J` embedded in `K_{N,N}`.

**Status: exact interface match; direct proof stronger for self-containment.**

---

## 6. Li's parallel classification and bridge-trace formulation

### Source interfaces

Li's Theorem 1.1 gives the same constructive and intrinsic classification.
His complete-rank one-apex lift and exact bridge-trace theorem give an
equivalence between finite linear traces and suitable bridge-selector graph
derivatives.

### Manuscript use

The manuscript:

- records the 23 June 2026 posting date for chronology;
- cites Li's alternative complete-rank one-apex and bridge-trace formulation
  at the relevant points;
- states that the present proof and Lean implementation were developed
  independently, in parallel with Li's work;
- proves its forward finite-trace theorem in base-fibre language; and
- does not invoke Li's classification or bridge-trace theorem as a premise.

### Check

The theorem called `Finite linear trace decomposition` is the forward statement
needed for the two lift-based avoiding hosts, and the manuscript supplies its
proof.  Li's theorem is cited as a parallel formulation.  The manuscript does
not claim Li's full exact converse in base-fibre language.

**Status: chronology, comparison, and the absence of logical dependence are
stated explicitly.**

Current wording before Theorem 6.3:

> The following trace theorem uses the fibre decomposition described above.
> Li gives a parallel bridge-trace formulation (Theorem 4.6).

This wording distinguishes a comparison citation from a proof dependency and
does not suggest that Li's full equivalence is being restated.

---

## 7. ZFC and choice boundary

The written proof uses ordinary classical choice in three places:

- selection of minimal-cardinality counterexamples;
- construction of continuous closure chains and witness choices;
- the classical partition relations and compactness theorem.

All are standard ZFC uses.  No CH, GCH, forcing axiom, or large-cardinal
hypothesis appears.  The statement `All arguments are in ZFC` is therefore
correct.

The Lean endpoint uses `Classical.choice`, `propext`, and `Quot.sound`, as
reported by the axiom audit.  This is compatible with the manuscript's
classical-mathematics scope; it is not a formal derivation inside a set-theory
library called ZFC and should not be described that way.

---

## 8. Additional publication patches

The external-interface audit adds the following four precision edits to the
existing line-edit ledger.

1. **Name the compactness input precisely.**
   Replace `the de Bruijn--Erdős compactness theorem` by
   `the de Bruijn--Erdős finite-colouring compactness theorem` at first use.

2. **Use lower-bound language for odd girth.**
   Replace `a graph ... of prescribed odd girth` by
   `a graph ... with odd girth exceeding a prescribed finite bound`.

3. **Retain the Li dependency boundary.**
   Keep the present point-of-use comparison citation and the explicit statement
   that no result of Li is used as a black box.

4. **State that Reiher is not a hidden premise.**
   After the direct expansion proof, retain the present sentence that it also
   follows from Reiher and add `The proof above is the route used in this
   manuscript.`

These edits change no theorem and no proof dependency.

## Final conclusion

The manuscript's external mathematical interfaces are conservative and
correct.  No citation is being used to supply a stronger conclusion than its
source.  The only required changes are terminology and dependency
clarifications that make the proof's actual black-box boundary explicit.
