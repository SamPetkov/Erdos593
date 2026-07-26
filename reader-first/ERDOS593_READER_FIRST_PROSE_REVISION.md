# Erdős 593: reader-first prose revision

## Scope

This is an exposition-only revision for the publication manuscript based on PR
#12.  It preserves the theorem statements, attribution, formalisation scope,
and finite parameter results.  It does not merge the all-uniformity programme
or the Berge-matroid/Potts follow-up into the Problem 593 paper.

The revision addresses four concrete weaknesses.

1. The conceptual finite geometry appears too late.
2. The direct proof of the positive expansion atom is long relative to its role.
3. The one-apex lift is introduced before the reader has a compact dictionary
   for its finite traces.
4. Attribution, provenance, and formalisation qualifications recur more often
   than the mathematical narrative requires.

## The theorem in one paragraph

A finite triple system is obligatory when it embeds in every triple system of
uncountable chromatic number.  After isolated vertices are removed, the
obligatory systems are exactly the linear systems in which every hyperedge-node
of the Levi graph is incident with a bridge and every Berge cycle has even
length.  Equivalently, they are obtained from private-vertex expansions of
finite bipartite graphs and finite edgeless systems by disjoint unions and
one-point amalgamations.  The proof has three parts: the expansion pieces and
the two closure operations are obligatory; deleting all Levi bridges recovers
those pieces and a quotient forest; and each failure of the intrinsic condition
is excluded by an explicit uncountably chromatic host.

That paragraph should appear, in essentially this form, before any auxiliary
lemma.

## Recommended main-text order

### 1. Introduction and exact characterisation

State the problem, define \(J^+\), \(F^\circ\), and \(\mathcal B\), and give
Theorem A immediately.  Follow it with a three-line dependency display:

```text
positive direction:        B -> obligatory
finite structural theorem: B <-> intrinsic
negative direction:        not intrinsic -> not obligatory
```

The paper should then tell the reader which part is elementary finite graph
geometry and which part uses infinitary colouring.

### 2. Minimal preliminaries

Keep only definitions and lemmas used in more than one later section:

- isolated-vertex reduction;
- finite deletion;
- product colouring;
- bounded-outdegree colouring;
- the closure-chain lemma.

Local technical definitions should be introduced at first use.

### 3. Finite bridge-block geometry

This is the conceptual centre of the paper and should precede the long positive
and negative host constructions.

Delete all bridges from the Levi graph.  Since every hyperedge-node has degree
three and is incident with a bridge, its remaining degree is \(0\) or \(2\).
Each active bridge-free component therefore suppresses to an ordinary simple
bipartite graph; the third incidences become private points.  Contracting the
bridge-free components gives a forest, and a root order gives the required
one-point-amalgamation sequence.

The section should be organised around one picture and four claims:

1. residual hyperedge degree is \(0\) or \(2\);
2. active components are bipartite expansion pieces;
3. the bridge quotient is a forest;
4. the pieces satisfy running intersection.

Do not interrupt this argument with provenance or formalisation commentary.

### 4. Positive direction

For the shortest publication narrative, cite Reiher for the obligatory
expansion atoms and retain the direct proof in an appendix titled
`A direct proof of the expansion atom`.  Keep the short proofs of closure under
disjoint union and one-point amalgamation in the main text, because the rooted
abundance lemma is used again and clarifies the construction.

If self-containedness is retained in the main text, mark the direct atom proof
as optional:

> Readers interested only in the classification may take the expansion theorem
> from Reiher and continue with Section X.  We include a direct proof in the
> present notation for completeness and for compatibility with the Lean
> implementation.

This single sentence prevents the long codegree/closure-chain argument from
obscuring the theorem's structure.

### 5. The one-apex lift and finite traces

Introduce the lift with a concrete finite picture before the transfinite branch
argument.  Each lifted edge has:

- a base node \(s\);
- two core points at \(s\);
- one apex at a proper extension \(t\).

Then state the finite trace theorem in its final form:

> Every finite linear trace is a tree-like one-point amalgamation of expansion
> fibres \(J_s^+\).

The proof should be divided visibly into:

1. one fibre is one expansion atom;
2. two fibres share at most one point;
3. the support-incidence graph is a forest;
4. the rooted order assembles the trace.

These are already the real proof steps.  The prose should not describe them as
mere bookkeeping.

### 6. Avoidance hosts

Open with the classification of failures:

```text
nonlinear | missing bridge | odd Berge cycle
```

and then give one host per column.  Repeat neither the complete theorem
statement nor the whole lift construction.  Each proposition should begin with
the violated intrinsic condition and end with the precise contradiction.

### 7. Finite parameter consequences

The bipartite shadow should be introduced as a consequence of the bridge-block
proof, not as a second decomposition.  State once that

\[
  |V(J)|=|V(F)|-|E(F)|,
\]

with the same edge and component counts.  The order--size--component interval
then becomes an ordinary bipartite-graph extremal calculation.  Keep the main
spectrum theorem and its most informative corollaries in the paper:

- connected and unrestricted order ranges;
- fixed-order edge range;
- missing orders;
- Levi cycle-rank spectrum;
- balanced endpoint rigidity.

Move exhaustive arithmetic checks to the repository.

### 8. Formal verification and provenance

One compact section is enough.  It should distinguish:

- the mathematical theorem and its priority;
- the alternative implementation in this paper;
- the Lean endpoints and ambient-universe convention;
- the use of AI tools;
- the author's responsibility.

The same attribution paragraph should not be repeated in the introduction,
sequence-lift section, conclusion, formalisation section, and AI statement.
Point-of-use citations to Li remain appropriate.

## Proposed section order

```text
1. Introduction and Theorem A
2. Preliminaries
3. The finite bridge-block theorem
4. Positive direction
   4.1 expansion atoms
   4.2 disjoint unions
   4.3 rooted abundance and one-point amalgamation
5. The one-apex lift
6. Finite linear traces
7. Avoidance hosts
8. Proof of Theorem A
9. Bipartite shadows and finite parameter spectra
10. Formal verification and reproducibility
Appendix A. Direct proof of the expansion atom
Appendix B. Exact arithmetic and build information
```

This order lets the reader understand the finite classification before entering
the hardest infinitary construction.

## Notation dictionary

| Symbol | Meaning | First use |
|---|---|---|
| \(F^\circ\) | delete isolated vertices from \(F\) | introduction |
| \(I(F)\) | Levi graph of \(F\) | introduction |
| \(J^+\) | private-vertex expansion of a graph \(J\) | introduction |
| \(\mathcal B\) | constructive class generated by bipartite expansions | introduction |
| bridge condition | every hyperedge-node of \(I(F^\circ)\) meets a bridge | Theorem A |
| Berge-even | every Berge cycle has even length | Theorem A |
| base fibre \(K_s\) | trace edges based at sequence node \(s\) | lift section |
| support-incidence graph | incidence graph of fibres and shared points | trace section |
| bipartite shadow | ordinary graph preserving edge count, components, and cycles | spectra section |

Do not introduce alternative names for these objects later.

## Rewritten proof transitions

Before the finite decomposition:

> The intrinsic condition is finite and graph-theoretic.  We first show that it
> is exactly the constructive condition, independently of the infinite host
> problem.

Before the positive direction:

> Having identified the finite objects, we now show that every generator and
> every permitted attachment operation is forced in an uncountably chromatic
> triple system.

Before the lift:

> To prove necessity, we need hosts that retain uncountable chromatic number
> while controlling all finite linear traces.  The one-apex lift provides that
> interface.

Before the trace theorem:

> A finite trace sees only finitely many base nodes.  Its geometry is therefore
> captured by expansion fibres and the graph recording their shared points.

Before the avoidance hosts:

> The intrinsic test can fail in exactly three ways.  The trace theorem supplies
> a separate avoiding host for each failure.

Before the finite spectra:

> The bridge-block proof retains more information than classification alone: it
> produces an ordinary bipartite shadow with the same cycle structure and a
> fixed vertex-count shift.

## Attribution compression

Use one introduction paragraph of the following form.

> Li's preprint contains the first publicly posted complete proof of the
> classification and introduces the complete-rank one-apex lift and
> bridge-trace method used in the negative direction.  The present paper gives
> an alternative implementation, a direct bridge-block decomposition,
> additional finite parameter consequences, and a Lean formalisation of this
> implementation.  No competing priority claim is made for the classification
> or the shared lift architecture.

At later points, use short citations such as `following Li's lift` rather than
reopening the full chronology.

## Separation from the follow-up PRs

The Problem 593 paper should contain only:

- the triple-system classification;
- the alternative proof;
- the finite parameter spectrum;
- the Lean scope.

The following belong in separate manuscripts.

1. the finite all-uniformity bridge-block theorem and its cycle shadow;
2. the still-audited all-uniformity avoidance theorem;
3. the Berge-cycle matroid, Tutte--Potts, polyhedral, and probabilistic theory.

Cross-reference those papers only after their theorem and priority audits are
complete.  Do not expand the Problem 593 introduction into a catalogue of every
later consequence.

## Editorial acceptance test

After reading the introduction and the first page of the finite bridge-block
section, a graph theorist should be able to explain:

1. the three equivalent characterisations;
2. why deleting Levi bridges leaves degree \(0\) or \(2\) at hyperedge-nodes;
3. why active components are bipartite expansions;
4. why the quotient is a forest;
5. why the lift is needed only for the negative direction;
6. why the later numerical spectrum reduces to a bipartite graph problem.

If the reader must first understand the transfinite lift or the probabilistic
rainbow lemma, the conceptual order is still wrong.
