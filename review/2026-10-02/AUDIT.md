# Mathematics and Lean coverage audit — 2 October 2026

## Research brief

Question: do the manuscript's supplied spectrum, local-product and capacity routes establish their stated conclusions, and does the verification section describe the actual accepted Lean scope faithfully?

Deliverable: a bounded conclusion-first source audit, a Lean interface crosswalk and a restrained revised manuscript. Acceptance requires explicit quantifiers and edge cases, preserved mathematical displays and attribution, no unsupported verification or uniqueness claim, and a compiled, visually checked PDF. This pass is not a broad proof search, new service submission, full-paper external audit or novelty determination.

Conventions: finite simple triple systems; injective non-induced embeddings; isolated reduction where stated; actual original-edge carriers for supported decompositions; actual canonical-atom indices, not assembly-list counts. In Section 10, `s` is shadow order, `m` is hyperedge count, `beta` is cyclic rank, `k` is canonical-atom count, `c` is component count and `N=k-c` is the attachment excess. All feasibility, reducedness, connectivity and nonempty-edge conditions remain local to their stated results. Analytical source reasoning, accepted kernel evidence and proposed future targets are kept separate.

Method and cost: two bounded source reviews and a direct comparison with accepted Lean declarations, followed by ordinary TeX compilation and rendering. No new Lean gate or expensive mathematical campaign is needed to audit the stated coverage. A new proof or service request would require its own exact theorem brief and resource/attempt checkpoint.

## Supplied-route mathematics audit

The targeted routes are the minimum-core-order lemma, connected atom-count spectrum and maximizers, structural phase and boundary cases, componentwise spectrum, local product, capacity-safe assembly and factorization-lattice spectrum. The audit takes the earlier classification/canonical normal form, the bipartite-shadow construction, finite graph tree/cycle facts, bipartite extremal bound and standard finite partition-lattice polynomial formula as its stated primitives. It does not silently replace a failed route by a different proof.

The route has the following dependencies. The classifications describe the manuscript's support, not new Lean results.

| ID | Exact obligation | Needed by | Route/classification | Support in the manuscript | Status |
| --- | --- | --- | --- | --- | --- |
| O1 | Canonical atom types, original-edge partition and incidence forest | Atom spectra, local product, capacity | Earlier theorem | Canonical atom normal form | Discharged within audit boundary |
| O2 | `r <= floor((v-2)^2/4)` and constructions at every claimed order | Minimum-order lemma | Bound plus even/odd constructions | Lemma 10.8; odd construction requires `r >= 2` | Discharged |
| O3 | Strict aggregation `q(a)+q(b) >= q(a+b)+1` for positive ranks | Maximum atom count | Algebraic step | Proof of Theorem 10.9 | Discharged |
| O4 | `s=1+sum(v_i-1)` and `beta=sum(r_i)` | Connected spectrum | Canonical forest count | Equation (10.15) | Discharged |
| O5 | Cut-vertex edge bound, attainment and equality structure | Phase/boundaries | Extremal graph argument | Theorem 10.10 and Corollary 10.11 | Discharged; domains and transport clarified |
| O6 | Equality shadow's cyclic blocks identify actual canonical cores | Boundary rigidity | Earlier normal form plus core-shadow assembly | Revised Corollary 10.11 proof; `s >= 5`, tree cases `s=3,4` separate | Discharged |
| O7 | Concentration in one component gives the exact componentwise interval | Componentwise spectrum | Connected result plus forest counts | Proposition 10.12 | Discharged |
| O8 | Supported decompositions cannot split canonical atoms | Local product | Nonseparability | First paragraph of Lemma 10.15 proof | Discharged |
| O9 | Local partitions generate supported pieces and restriction is inverse | Local product | Auxiliary forest and vertex-disjoint contractions | Revised Lemma 10.15 proof | Discharged; earlier overlapping-subtree route replaced |
| O10 | Product rank equals `sum(mu(p)-1)=k-c` | Lattice rank | Partition-lattice rank plus forest count | Last paragraph of Lemma 10.15 | Discharged as prose, not a new kernel endpoint |
| O11 | A chain with leaves realizes every positive excess partition using at most two ports per atom | Capacity lemma | Explicit finite construction | Lemma 10.16 | Discharged |
| O12 | Distinct ports, closure and separating shared points preserve the supplied atoms as canonical blocks | Actual profile realization | Geometric transport/normal form | Added bridge in Lemma 10.16 | Discharged as prose; Lean interface remains open |
| O13 | Exactly `k-c` identifications preserve global parameters | Full lattice spectrum | Assembly count | Lemma 10.16 conclusion | Discharged |
| O14 | Root multiplicities of the product characteristic polynomial recover the excess partition | Nonisomorphic lattice types | Standard polynomial formula | Corollary 10.17 | Discharged as prose; no new Lean endpoint claimed |

### Edge cases and corrections

- The connected atom-count theorem now quantifies only over feasible parameters and systems with an edge. The single-triple case is `s=2, beta=0`; an empty feasible class is not assigned a maximum.
- The three phase zones use functions defined for `s >= 3`. Corollary 10.11 explicitly defines `m=|E(F)|`.
- The odd-order theta boundary has total path length `s+1`, which is even; the three equally-paritied paths are therefore even. Sorting half-lengths is still a separate Lean interface.
- At the decomposable extremal boundary, the cyclic-core argument applies for `s >= 5`. For `s=4`, the factor `K_{1,2}^+` comprises two singleton atoms rather than one canonical atom; `s=3,4` are handled as tree cases.
- For four atoms through one point split into two local pairs, the original forest's spanning subtrees overlap. The new proof splits the shared-point star into a two-level tree, then contracts genuinely vertex-disjoint atom-containing components. It checks that local blocks cannot reconnect elsewhere, restores the central edges for contraction, and verifies both inverses.
- The empty attachment profile (`N=0`), a single shared point and disconnected parent forests are included. Reducedness excludes isolated components in the componentwise spectrum; `k >= c` is retained.
- Parameters and attachment profiles do not classify assembled systems up to isomorphism. Maximizer rigidity concerns the distribution of cyclic rank, not uniqueness of a graph with a prescribed numerical tuple. Canonical labels identify actual edge sets in a given system, not a universal graph-isomorphism type.

### Verdict

**The targeted supplied routes follow within this bounded source audit, conditional on the stated primitives.** The second pass found no further major defect after the first-pass forest/capacity repairs. This is not certification of all manuscript mathematics, whole-paper Lean coverage, priority or publication readiness.

## Lean crosswalk

This is a source-fidelity review, not a new compiler run. Public/private merged mains inspected for this packet remain at 245 modules and 379 permanent audits. The separately accepted actual-piece extension has 246 modules and 383 audits, but source delivery is still pending. It must not be described as present on public main merely because its local acceptance is complete.

The following paths are relative to the review branch, whose inherited proof tree is byte-unchanged from the inspected public main `b5130a71f0b022fdf63c0a186f0892ab9b599f84`.

| Manuscript interface | Accepted endpoint/support | Exact scope and limitation |
| --- | --- | --- |
| Classification | [ObligatoryClassification.lean](../../formalization/Erdos593/TripleSystem/ObligatoryClassification.lean) | Finite classified system; ambient host convention and isolated reduction retained. Both directions accepted. |
| Canonical normal form and atom running assembly | [CanonicalAtomForestReconstruction.lean](../../formalization/Erdos593/TripleSystem/CanonicalAtomForestReconstruction.lean) | Actual canonical indices and original system reconstruction under stated structural hypotheses; not a generic running-order theorem for arbitrary finite systems. |
| Core transport | [CanonicalAtomCanonicity.lean](../../formalization/Erdos593/TripleSystem/CanonicalAtomCanonicity.lean) | Transport of a chosen core up to graph isomorphism for the given atom. Does not make order/rank parameters determine one core graph. |
| Connected atom-count spectrum | [CanonicalAtomCountSpectrum.lean](../../formalization/Erdos593/TripleSystem/CanonicalAtomCountSpectrum.lean): `exists_connected_atom_count_iff` | Obligatory, reduced, connected, nonempty-edge system with actual cardinalities. Does not by itself discharge the componentwise theorem. |
| Positive-rank maximizers | [CanonicalAtomMaximizer.lean](../../formalization/Erdos593/TripleSystem/CanonicalAtomMaximizer.lean): `every_maximizer_structure` | One minimum-order positive-rank atom, all other atoms singleton; positive total rank is essential. |
| Classical block equivalence | [SupportedClassicalBlockConverse.lean](../../formalization/Erdos593/TripleSystem/SupportedClassicalBlockConverse.lean): `isObligatory_iff_forall_supportedBlock_allowed` | Finite original carriers, no `Intrinsic` premise added to the unrestricted equivalence; empty/disconnected/isolated cases retained. |
| Canonical block labels | [SupportedClassicalBlockLabels.lean](../../formalization/Erdos593/TripleSystem/SupportedClassicalBlockLabels.lean): `supportedBlock_iff_canonicalAtom` | Conditional on `Intrinsic`; unique actual canonical index with the specified original-edge set. Not core-isomorphism uniqueness. |
| Supported local product | [SupportedDecompositionProduct.lean](../../formalization/Erdos593/TripleSystem/SupportedDecompositionProduct.lean), [SupportedStandardPartitions.lean](../../formalization/Erdos593/TripleSystem/SupportedStandardPartitions.lean) | Actual supported edge partitions and order isomorphisms; do not reprove this accepted result or replace its carrier with atom-list partitions. |
| Actual-piece accounting | `SupportedPieceAccountingCandidate.lean`: `supportedPartitions_block_card_accounting` | Separately accepted at source `bc36a54a0239a5c46d52752d7125d3259d7dd38a`; module SHA256 `5e1907693defd0f146d8f1261e9bbbdb82cf71c84ea5d83731e6f8bbb052e2ce`. Finite `Intrinsic`, no global connectedness/reducedness/nonempty-edge assumption. Counts and transport, **not covers/grading**. Delivery pending; no nonexistent public-source link is supplied. |
| Forward atomic cycle/theta boundary | [AtomicBoundaryNormalForms.lean](../../formalization/Erdos593/TripleSystem/AtomicBoundaryNormalForms.lean): `obligatory_atomic_alpha_boundary` | Original reduced obligatory connected literal-indecomposable system at the stated boundary. Even theta lengths; sorted half-length normalization remains separate. |
| Abstract profile forest | [IncidenceProfile.lean](../../formalization/Erdos593/Graph/IncidenceProfile.lean): `exists_incidence_forest` | `1 <= c <= k`, positive weights summing to `k-c`; actual bipartite forest, component count and capacity two. Not assembly of fixed triple-system atoms with distinct ports/canonical labels. |

Relative links resolve within this repository's review branch. The recorded inspected base fixes the audit's source scope; this packet does not assert coverage for a mutable future `main`.

Still open as exact retained interfaces: covers/grading on the actual supported subtype; fixed-atom geometry and profile realization; componentwise atom-count/full lattice spectra; retained all-maximal-block running order; full phase/decomposable equality interfaces; sorted theta normalization; characteristic-polynomial recovery; separate 048 integration; exhaustive manuscript crosswalk. Full external audit remains pending.

## Connected mathematical directions, not inserted claims

The strongest next step is the genuine cover bridge on actual supported decompositions. The already accepted product and piece counting suggest the target `D covers R` in the appropriate refinement orientation iff there is a strict comparison and a one-block count difference. Its exact Lean orientation and signatures must be frozen before proof work. A cover in the supported subtype cannot simply be assumed to be a cover in the whole setoid lattice. This bridge would connect the decomposition's rank to its structural budget without adding an unrelated fact.

The complementary next step is actual fixed-atom geometry: select distinct ports, build a running forest assembly, prove admission/parameter preservation, and transport its canonical indices. The abstract profile forest is a useful input, not an equivalent replacement for that construction. This would support the paper's claim that the same cyclic content allows controlled assembly freedom.

Only after these interfaces are established should rank-resolved counts, coefficientwise profile-merger comparisons or a Boolean/distributive criterion be added as connected corollaries. They remain proposals, not accepted Lean results or novelty claims. General majorization and a broad new research programme are outside this pass.
