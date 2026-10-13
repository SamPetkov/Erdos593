# Readability pass — 13 October 2026

## Scope and evidence

Medium-intensity academic prose revision in the existing open manuscript, not a mathematical rewrite or a claim of completed formalization. The academic-writing skill was used to shorten repeated framing, make the cyclic-content/assembly distinction explicit and separate manuscript proofs from accepted Lean interfaces. No formula, theorem statement, citation key, label, hypothesis, bibliography, date or proof body was intentionally changed.

Source review copy: `review/2026-10-13-readability/erdos593_obligatory_triple_systems.tex`.
Before SHA256: `7b0dc06f31631f2c8bd73d5e24c503ee5a7579663f4f6adbc5e9a65c9fc503fe`.
Revised SHA256: `78e12f0ee68e4dd340a9d6771a47893ed37b2797f34f675af9a3232122e2eab1`.

The clean revised version is the saved `.tex` file. The six comparisons below are the complete changed paragraph units. Compilation and source-only inverse reconciliation are separate checks, not Lean evidence. The newly audited rank-at-most-two density proof remains a research note rather than a silently inserted manuscript theorem.

## Comparison and notes

### 1. Abstract

Original:

```tex
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

Revised:

```tex
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
product of partition lattices whose type recovers the attachment excess
profile.  Every such profile is realizable with the atoms and component
count fixed.  For connected systems of positive cycle rank, an exact budget
relates cyclic-rank splitting and excess core order to the available
factorization rank.  Sharp binomial and Stirling-number bounds count
factorizations at each prescribed original-edge piece count.  Binary joints
and a common joint characterize the interior equality cases; the extremal
assemblies can have the same atoms and global parameters.  Thus cyclic
content constrains the system without determining its assembly.  For the
associated graph cores, we also prove
exact edge-marginal entropy bounds for uniform Potts laws and nearby general
pair laws, and common-power density bounds for two-level regular hosts.
For a class of weighted signed projection lifts, we retain the full coarse
density and obtain an explicit positive cycle margin for every choice of
the six positive exponents.  These comparisons are separate from the
obligatory classification; their unrestricted versions remain open.
The classification and specified structural extensions are verified in Lean~4.
Profile realization, full lattice spectra, the new counting endpoints and
the entropy--density arguments are not yet fully formalized.
All arguments are in ZFC.
```

Note: Links profile recovery directly to the lattice product and uses direct verbs for the counting and density statements. Keeps the connected/positive-rank conditions, all six-exponent scope and incomplete-formalization qualification.

### 2. Finite-structure overview

Original:

```tex
Theorem~A answers an embedding question about infinite hosts.  The further
results concern a different question: how much finite structure is fixed by
cyclic content, and how much remains free under one-point assembly?  The finite
systems considered in this overview are reduced (they have no isolated
vertices), obligatory, and have at least one hyperedge.  Write \(n=|V(F)|\),
\(m=|E(F)|\), and \(c\) for their number of components; put \(s=n-m\) and
\(\beta=2m-n+c\), the Levi cycle rank.  The
canonical normal form identifies the atoms as single triples and expansions
of finite \(2\)-connected bipartite graphs
(Theorem~\ref{theorem-canonical-atom-normal-form}).  Block decomposition itself
is classical \citep{whitney1932,diestel2017}; the point here is the exact list
of allowable block types and what it implies about the systems assembled
from them.
```

Revised:

```tex
Theorem~A answers an embedding question about infinite hosts.  We then ask
which finite features are fixed by cyclic content and which can change under
one-point assembly.  Throughout this overview, the systems are reduced
(they have no isolated vertices), obligatory, and have at least one
hyperedge.  Write \(n=|V(F)|\), \(m=|E(F)|\), and \(c\) for their number
of components; put \(s=n-m\) and \(\beta=2m-n+c\), the Levi cycle rank.
The canonical normal form identifies the atoms as single triples and expansions
of finite \(2\)-connected bipartite graphs
(Theorem~\ref{theorem-canonical-atom-normal-form}).  Block decomposition itself
is classical \citep{whitney1932,diestel2017}; the point here is the exact list
of allowable block types and what it implies about the systems assembled
from them.
```

Note: States the two mathematical questions directly. All definitions, assumptions, references and classical attribution are retained.

### 3. Two classification questions

Original:

```tex
The finite results address two complementary classification questions.
The numerical spectra determine which global parameters and canonical atom
counts are possible.  The local partition product describes the
decompositions available once the atoms have been fixed.  These questions
are distinct: assemblies with identical atoms, order, size and cycle rank
can still have different factorization lattices and different numbers of
decompositions.
```

Revised:

```tex
There are two complementary classification questions.  The numerical
spectra determine which global parameters and canonical atom counts are
possible.  The local partition product describes the decompositions
available with the atoms fixed.  The questions are distinct: assemblies
with identical atoms, order, size and cycle rank can have different
factorization lattices and different numbers of decompositions.
```

Note: Removes repetition without replacing the one-way non-determination example by an unjustified two-way independence claim.

### 4. Local assembly description

Original:

```tex
The remaining freedom is described by a lattice, not another numerical
invariant.  At each point \(p\) shared by \(\mu(p)\) canonical atoms, one may
choose a partition of those atoms independently.  The supported one-point
forest decompositions of the original hyperedge set, ordered by refinement,
therefore form \(\mathcal D(F)\cong\prod_{p\in S(F)}\Pi_{\mu(p)}\), where
\(S(F)\) is the set of shared points and \(\Pi_r\) is the partition lattice
on \(r\) elements (Lemma~\ref{lemma-local-decomposition-lattice-product}).
Its rank is \(N=k-c\).  Every integer partition \(\lambda\vdash N\) is
realized as an attachment excess profile by reassembling the same atoms
with the same component count, order, size and cycle rank
(Lemma~\ref{lemma-capacity-safe-profile-realization}).  This gives the exact
factorization-lattice spectrum: its types are
\(\prod_i\Pi_{\lambda_i+1}\), and the classical characteristic polynomials
of partition lattices \citep[Chapter~3]{stanley2012} recover \(\lambda\)
(Corollary~\ref{corollary-factorization-lattice-spectrum}).  The classification
is of lattice types,
not of all triple systems with the same parameters.
```

Revised:

```tex
The remaining assembly freedom has a local description.  At each point
\(p\) shared by \(\mu(p)\) canonical atoms, one may independently choose a
partition of those atoms.  The supported one-point
forest decompositions of the original hyperedge set, ordered by refinement,
therefore form \(\mathcal D(F)\cong\prod_{p\in S(F)}\Pi_{\mu(p)}\), where
\(S(F)\) is the set of shared points and \(\Pi_r\) is the partition lattice
on \(r\) elements (Lemma~\ref{lemma-local-decomposition-lattice-product}).
Its rank is \(N=k-c\).  Every integer partition \(\lambda\vdash N\) is
realized as an attachment excess profile by reassembling the same atoms
with the same component count, order, size and cycle rank
(Lemma~\ref{lemma-capacity-safe-profile-realization}).  This gives the exact
factorization-lattice spectrum: its types are
\(\prod_i\Pi_{\lambda_i+1}\), and the classical characteristic polynomials
of partition lattices \citep[Chapter~3]{stanley2012} recover \(\lambda\)
(Corollary~\ref{corollary-factorization-lattice-spectrum}).  The classification
is of lattice types,
not of all triple systems with the same parameters.
```

Note: Makes the independent local partition choices the entry point. Product, grading, realization and scope statements are unchanged.

### 5. Quantitative questions

Original:

```tex
The description of the cyclic atoms also identifies graph cores for finite
quantitative questions.  Every simple bipartite subdivision of $K_4$ is
$2$-connected and has cycle rank three, so its private-vertex expansion is
an allowable atom.  This observation motivates, but does not prove, a density
comparison for the original graph.  Section~\ref{sec:quantitative-cores}
studies exact pair-marginal entropy witnesses and regular-host homomorphism
densities for these cores.  The first results cover uniform $q$-state Potts
tables, arbitrary tables in specified open families, and hosts with two
centered spectral levels.  A further transfer theorem allows signed
projection channels over mildly nonuniform original measures, with no
bound on the number of spectral levels
(Proposition~\ref{proposition-weighted-projection-lift}).
They are not a universal Sidorenko theorem.
```

Revised:

```tex
The cyclic atoms lead to quantitative questions about their graph cores.
Every simple bipartite subdivision of $K_4$ is
$2$-connected and has cycle rank three, so its private-vertex expansion is
an allowable atom.  This observation motivates, but does not prove, a density
comparison for the original graph.  Section~\ref{sec:quantitative-cores}
studies exact pair-marginal entropy witnesses and regular-host homomorphism
densities for these cores.  The first results cover uniform $q$-state Potts
tables, arbitrary tables in specified open families, and hosts with two
centered spectral levels.  A further transfer theorem allows signed
projection channels over mildly nonuniform original measures, with no
bound on the number of spectral levels
(Proposition~\ref{proposition-weighted-projection-lift}).
They are not a universal Sidorenko theorem.
```

Note: Shortens the transition. The motivation/proof distinction and all restricted density/entropy scopes remain explicit.

### 6. Formalization status

Original:

```tex
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

Revised:

```tex
The classification and substantial structural extensions have accepted
Lean implementations.  Other manuscript proofs still lack complete formal
interfaces: profile realization, lattice spectra, maximal-chain and height
endpoints, and the new counting statements.  The entropy and density
arguments have no accepted Lean implementation.  We distinguish these
manuscript results from the interfaces already exported and accepted in Lean.
Appendix~\ref{appendix-formalization} records the implementation routes,
validation records and remaining obligations.
```

Note: Gives readers the unfinished endpoints once, then refers to the audit appendix. Does not upgrade analytical proofs to kernel-checked results.
