# Academic readability pass — 11 October 2026

Setting: medium English academic edit using the academic-humanizer skill.
The clean revision is the existing open TeX source and matching public review copy.
This comparison covers every changed paragraph group, not the unchanged paper.
No detector score was used to rewrite the source, and no authorship or novelty claim is inferred from a score.

## Abstract

### Original

```latex
\begin{abstract}
Erdős Problem~593 asks which finite triple systems occur in every triple
system of uncountable chromatic number.  We give an independent proof of the
classification and develop its finite structural consequences.  After
isolated vertices are removed, a system is obligatory if and only if it is
linear, every hyperedge-node of its Levi graph is incident with a bridge,
and every Berge cycle has even length.  Its canonical atoms are single
triples and private-vertex expansions of finite $2$-connected bipartite
graphs.  For reduced obligatory systems with at least one hyperedge, we
determine the exact parameter and atom-count spectra, including the parity
obstruction at cycle rank one.  The supported one-point factorizations form
a product of partition lattices: every attachment excess profile can be
realized with the atoms and component count fixed, and the lattice type
recovers that profile.  For connected systems of positive cycle rank, an
exact budget relates cyclic-rank splitting and excess core order to the
available factorization rank.  At every prescribed original-edge piece
count we obtain sharp binomial and Stirling-number bounds, with binary
joints and a common joint as the interior equality cases.  The two
extremal assemblies can have the same atoms and global parameters.
These results separate the constraints imposed by cyclic content from
the freedom of assembly.  For the associated graph cores, we also prove
exact edge-marginal entropy bounds for uniform Potts laws and nearby general
pair laws, and common-power density bounds for two-level regular hosts.
For a class of weighted signed projection lifts, a comparison retains the
full coarse density with an explicit positive cycle margin
for every choice of the six positive exponents.  These comparisons are separate
from the obligatory classification; their unrestricted versions remain open.
The classification and specified structural
extensions are verified in Lean~4; profile realization, full lattice
spectra, the new counting endpoints and the entropy--density arguments
are not yet fully formalized.
All arguments are in ZFC.
```

### Revised

```latex
\begin{abstract}
Erdős Problem~593 asks which finite triple systems occur in every triple
system of uncountable chromatic number.  We give an independent proof of the
classification and derive its finite structural consequences.  After
isolated vertices are removed, a system is obligatory if and only if it is
linear, every hyperedge-node of its Levi graph is incident with a bridge,
and every Berge cycle has even length.  Its canonical atoms are single
triples and private-vertex expansions of finite $2$-connected bipartite
graphs.  For reduced obligatory systems with at least one hyperedge, we
determine the exact parameter and atom-count spectra, including the parity
obstruction at cycle rank one.  Supported one-point factorizations form a
product of partition lattices.  Every attachment excess profile can be
realized while keeping the atoms and component count fixed, and the lattice
type recovers the profile.  For connected systems of positive cycle rank, an
exact budget relates cyclic-rank splitting and excess core order to the
available factorization rank.  At every prescribed original-edge piece
count, sharp binomial and Stirling-number bounds describe the number of
factorizations.  Binary joints and a common joint characterize the interior
equality cases; the extremal assemblies can have the same atoms and global
parameters.  These results distinguish the constraints of cyclic content
from the freedom of assembly.  For the associated graph cores, we also prove
exact edge-marginal entropy bounds for uniform Potts laws and nearby general
pair laws, and common-power density bounds for two-level regular hosts.
For a class of weighted signed projection lifts, a comparison retains the
full coarse density and gives an explicit positive cycle margin
for every choice of the six positive exponents.  These comparisons are separate
from the obligatory classification, and their unrestricted versions remain open.
The classification and specified structural extensions are verified in Lean~4.
Profile realization, full lattice spectra, the new counting endpoints and
the entropy--density arguments are not yet fully formalized.
All arguments are in ZFC.
```

Note: Separate contribution clauses and make the Lean acceptance boundary a separate sentence; all mathematical restrictions remain.

## Introduction: finite classifications

### Original

```latex
The finite results give two complementary classifications.  The numerical
spectra determine which global parameters and canonical atom counts are
possible.  The local partition product determines which decompositions
remain available once the atoms have been fixed.  Neither classification
alone captures the other: even assemblies with identical atoms, order,
size and cycle rank can have different factorization lattices and different
numbers of decompositions.
```

### Revised

```latex
The finite results address two complementary classification questions.
The numerical spectra determine which global parameters and canonical atom
counts are possible.  The local partition product describes the
decompositions available once the atoms have been fixed.  These questions
are distinct: assemblies with identical atoms, order, size and cycle rank
can still have different factorization lattices and different numbers of
decompositions.
```

Note: Distinguish possible global parameters from decompositions of fixed atoms without suggesting core-isomorphism uniqueness.

## Introduction: formalization boundary

### Original

```latex
The classification and substantial structural extensions have accepted
Lean implementations.  The distinction is between the mathematical results
proved in the manuscript and the exact interfaces already exported by Lean,
not between a numerical test and a proof.  Full profile realization, lattice
spectra, maximal-chain and height endpoints, and the new counting statements
still have unfinished formal interfaces.  The finite results above have
manuscript proofs; they are not all claimed as accepted Lean exports.
The entropy and density arguments have no accepted Lean implementation.
Appendix~\ref{appendix-formalization} records the implementation routes,
validation records and remaining obligations without interrupting the
mathematical arguments.
```

### Revised

```latex
The classification and substantial structural extensions have accepted
Lean implementations.  The manuscript also proves results whose full
formal interfaces remain unfinished: profile realization, lattice spectra,
maximal-chain and height endpoints, and the new counting statements.
Thus a manuscript proof is not, by itself, a claim that the corresponding
Lean interface has been exported and accepted.  The entropy and density
arguments have no accepted Lean implementation.
Appendix~\ref{appendix-formalization} records the implementation routes,
validation records and remaining obligations.
```

Note: Name the unfinished interfaces directly and distinguish manuscript proofs from accepted Lean exports.

## Appendix B: conventions and scope

### Original

```latex
\section{Exact marginal entropy and common-power densities}
\label{appendix-entropy-density}

All logarithms in this appendix are natural.  If $R$ is a strictly positive
probability law on a finite set, we use
$D(\nu\Vert R)=\sum_x\nu(x)\log(\nu(x)/R(x))$, with $0\log0=0$.
Every marginal below is attached to an actual vertex or edge; it is not an
average over edges.  The arguments establish the restricted statements in
Theorems~\ref{theorem-potts-edge-entropy}, \ref{theorem-local-table-entropy}
and~\ref{theorem-two-level-density}.  They do not resolve the arbitrary-table
entropy question or the unrestricted common-power inequality.
```

### Revised

```latex
\section{Exact marginal entropy and common-power densities}
\label{appendix-entropy-density}

All logarithms in this appendix are natural.  For a strictly positive
probability law $R$ on a finite set, we use
$D(\nu\Vert R)=\sum_x\nu(x)\log(\nu(x)/R(x))$, with $0\log0=0$.
Every marginal below refers to a specified vertex or edge, not an average
over edges.  We prove the restricted statements in
Theorems~\ref{theorem-potts-edge-entropy}, \ref{theorem-local-table-entropy}
and~\ref{theorem-two-level-density}.  The arbitrary-table entropy question
and the unrestricted common-power inequality remain open.
```

Note: State actual specified marginals and restricted-versus-open boundaries without repetitive hedging.

## Validation boundary

The read-only checker compares against the exact previous draft head.
All statement/proof bodies, inline and displayed mathematical expressions,
labels, reference/citation calls, bibliography and revision date remain unchanged.
The full separate-agent claim review passes, but this is not a full external
mathematical audit, new Lean acceptance, or a detector guarantee.
