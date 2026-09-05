# Hostile audit of the block / factorization-lattice manuscript insertion

**Target:** `MANUSCRIPT_BLOCK_AND_LATTICE_EXTENSION.tex`  
**Audit date:** 5 September 2026  
**Status after repairs:** **PASS as an ordinary-mathematics manuscript candidate; not yet Lean-formalized and not yet integrated into the authoritative TeX.**

This audit treats the proposed insertion as a hostile-referee target rather than as a research note.  It checks theorem quantifiers, edge cases, proof dependencies, attribution, and whether every result used by the fragment is actually available in the main manuscript.

---

## 1. Executive verdict

No mathematical blocker remains in the revised fragment.  Four issues were found and repaired:

1. **Wrong outer quantifier in the spectrum corollary.**  The old draft began with one fixed `F` and then spoke about the possible ranks at fixed `(s,beta,c)`.  The revised statement fixes a feasible parameter triple and explicitly lets `F` range over all reduced obligatory systems with those parameters.
2. **Isolated-point gap in the block-formulation converse.**  The old proof jumped from obligatoriness of the blocks of `F^circ` directly to obligatoriness of `F`.  The revised proof first obtains obligatoriness of `F^circ` by Komjath's reduction and then invokes the existing isolated-vertex reduction lemma.
3. **Repository-only dependency.**  The old lattice-spectrum proof invoked the shared-point multiplicity realization theorem, which is not part of the authoritative manuscript.  The revised fragment contains a self-contained capacity-safe chain-of-stars realization lemma.
4. **Underexplained local-product converse.**  The old proof asserted that independently chosen local partitions at the shared points could be glued without accidental identifications.  The revised proof explicitly uses the canonical atom--shared-point forest: generated global classes span connected subtrees, contractions of those subtrees preserve acyclicity, and two local classes at one shared point cannot reconnect elsewhere without creating a cycle.

The resulting manuscript insertion is self-contained relative to the current manuscript plus the two classical citations supplied in `MANUSCRIPT_BLOCK_AND_LATTICE_BIBLIOGRAPHY.bib`.

---

## 2. Source and attribution audit

### Komjath 2001 — verified established input

P. Komjath, *Some Remarks on Obligatory Subsystems of Uncountably Chromatic Triple Systems*, Combinatorica 21 (2001), 233--238, DOI 10.1007/s004930100021.

The publicly indexed abstract states that a finite triple system is obligatory if and only if every 2-connected component is obligatory.  This is exactly the historical reduction used by the block-formulation corollary.  The current `references.bib` already contains this source.

**Boundary:** no novelty claim is made for block-locality of obligatoriness.

### Bahmanian--Sajna 2015 — verified established block theory

M. Amin Bahmanian and Mateja Sajna, *Connection and Separation in Hypergraphs*, Theory and Applications of Graphs 2(2) (2015), Article 5, DOI 10.20429/tag.2015.020205; arXiv:1504.04274.

The accessible paper develops separating vertices, blocks, edge decomposition into blocks, and the relation between hypergraph blocks and incidence-graph blocks.  In particular, its general block theory already covers the existence/uniqueness framework that the canonical atom decomposition specializes.

**Boundary:** no novelty claim is made for the existence of hypergraph blocks, uniqueness of the block decomposition, or a block-cut tree.

### Simon--Tittmann--Trinks 2011 — verified established bond-lattice input

F. Simon, P. Tittmann and M. Trinks, *Counting Connected Set Partitions of Graphs*, Electronic Journal of Combinatorics 18 (2011), P14, DOI 10.37236/501; arXiv:1005.1726.

The paper uses connected set partitions and the bond lattice.  The fragment gives its own short proof of the special direct-product formula needed here, so no theorem from this source is used as a black box beyond terminology/context.

**Boundary:** partition lattices, bond lattices, characteristic polynomials, Bell numbers and direct-product identities are classical.  The potentially new 593-specific content is the exact allowable spectrum after combining those classical objects with the obligatory-block classification, the atom-count spectrum, and the explicit realizability of every attachment profile.

### Novelty status

A bounded search found substantial prior literature on hypergraph blocks and on partitions of block graphs.  No source was located in this audit that states the exact obligatory-triple-system factorization-lattice phase diagram at fixed `(s,beta,c)`.  This is **not** an absolute priority guarantee.  The manuscript should describe the result as an exact structural corollary under review, not as the invention of a new general decomposition theory.

---

## 3. Theorem-by-theorem audit

### A. Remark: blocks and the earlier reduction

**Verdict: PASS after attribution repair.**

The revised wording distinguishes three layers correctly:

- Komjath: obligatoriness is block-local;
- general hypergraph theory: blocks and their incidence-graph relationship are classical;
- this manuscript: the blocks allowed by Erdős 593 are exactly one triple or `J^+` with `J` finite, 2-connected, simple and bipartite, and the later sections give sharp quantitative spectra.

The remark avoids claiming that the block tree itself is new.

### B. Corollary: block formulation of the classification

**Verdict: PASS.**

Forward direction:

1. `F` obligatory implies `F^circ` obligatory by the existing isolated-vertex lemma.
2. Komjath gives obligatoriness of every 2-connected block.
3. A nonempty block is one-point indecomposable.
4. The manuscript's existing indecomposable classification yields exactly one triple or `J^+` with a finite 2-connected simple bipartite `J`.

Reverse direction:

1. Every displayed block is obligatory by the positive expansion theorem (including the one-triple case).
2. Komjath gives obligatoriness of `F^circ`.
3. The isolated-vertex lemma gives obligatoriness of `F`.

**Edge case:** if `F^circ` has no hyperedges, it is empty; the block condition is vacuous and obligatoriness follows from the isolated-vertex reduction.  This case is now explicit.

### C. Lemma: local product for one-point decompositions

**Verdict: PASS.**

The convention for `D(F)` is explicit: pieces are supported, nonempty and connected; pairwise intersections have size at most one; and the piece--shared-point incidence graph is a forest.

The proof has two load-bearing steps.

1. **Blocks cannot be split by a valid decomposition.**  If a block met two pieces, the unique path between those pieces in the decomposition forest would provide a separating point for two hyperedges of the block, contradicting nonseparability.
2. **Local partitions are independent.**  At each canonical shared point `p`, a decomposition induces a partition of the `mu(p)` incident atoms.  Conversely, arbitrary local partitions generate connected atom classes.  Because the canonical atom--shared-point graph is a forest, no two local classes at `p` can reconnect away from `p`, and two distinct global classes cannot share two points.  Contracting the connected subtrees corresponding to the generated classes preserves acyclicity.

Thus

```text
D(F) ~= product_p Pi_{mu(p)}.
```

The rank identity follows exactly from the forest edge count

```text
sum_p mu(p) = k + |S(F)| - c.
```

No hidden connectedness assumption is used; disconnected systems are handled componentwise and the product has rank `k-c`.

### D. Lemma: capacity-safe realization of every attachment profile

**Verdict: PASS; newly made self-contained.**

For `N=k-c=0`, all atoms are separate components.

For `N>0`, the construction uses `N+1` atoms in one nontrivial component and leaves `c-1` singleton-atom components.

For a profile `lambda=(lambda_1,...,lambda_t) |- N`:

- `t=1`: all `N+1` active atoms meet at one point;
- `t>=2`: shared points are arranged in a chain, using `t-1` connector atoms and

```text
lambda_1 + lambda_t + sum_{i=2}^{t-1}(lambda_i-1)
  = N-t+2
```

leaf atoms.

The active atom total is therefore `(t-1)+(N-t+2)=N+1`.  Connector atoms use two distinct ports and leaf atoms one.  Every canonical atom has at least three vertices, so no capacity obstruction occurs.

Every forest assembly of the fixed atom list into `c` components makes exactly `k-c` identifications, giving

```text
m = sum_i |E(A_i)|,
n = sum_i |V(A_i)| - (k-c).
```

Hence `m,n,s,beta,c,k` are independent of the profile.  This is the exact preservation needed by the global spectrum proof.

### E. Corollary: exact one-point factorization-lattice spectrum

**Verdict: PASS after quantifier repair.**

The statement now fixes a *feasible* `(s,beta,c)` and lets `F` range over all reduced obligatory systems with those parameters.

The rank spectrum is exactly the existing componentwise atom-count spectrum shifted by `c`:

```text
beta=0: N=s-2c;
beta=1: 0<=N<=s-2c-2 and N == s-2c (mod 2);
beta>=2: 0<=N<=s-2c-ceil(2 sqrt beta).
```

For every allowed `N`:

1. the atom-count theorem supplies a system with `k=N+c` atoms and the prescribed global parameters;
2. the capacity-safe lemma realizes every `lambda |- N` using that fixed atom list and the same parameters;
3. the local-product lemma gives `product_i Pi_{lambda_i+1}`;
4. every system necessarily has some excess profile partitioning `N`, so the list is exhaustive.

Distinct partitions produce nonisomorphic lattices because

```text
chi_{Pi_r}(x) = product_{j=1}^{r-1}(x-j),
```

and direct products multiply characteristic polynomials.  The multiplicity of the root `j` is the number of parts `lambda_i >= j`, which recovers `lambda` uniquely.

---

## 4. Edge cases explicitly checked

The audited statement and verifier cover:

- the empty reduced system / purely isolated original system;
- `k=c` and `N=0` (empty profile, one-element decomposition lattice);
- a single shared point of multiplicity `N+1`;
- all-binary shared points (`lambda=1^N`);
- disconnected systems with `c>1`;
- the acyclic line `beta=0`;
- the unicyclic parity obstruction `beta=1`;
- the full interval for `beta>=2`;
- single-triple atoms used as connector atoms (two distinct ports are available);
- preservation of `(m,n,s,beta,c,k)` under reassembly;
- characteristic-polynomial separation of all profiles through the checked range.

---

## 5. Executable hostile checks

`experiments/verify_manuscript_block_lattice_fragment.py` directly tests the new manuscript-facing interfaces rather than only the older research notes.

The committed deterministic run checks:

- **890** chain-of-stars profile realizations for all `1<=k<=13` and all `1<=c<=k`;
- **684** characteristic-polynomial profile recoveries for all integer partitions through weight 15;
- **11,016** feasible `(s,beta,c)` rank-spectrum translations in the configured range; and
- **684** Bell-extremal profile checks through weight 15.

The result file is `experiments/manuscript_block_lattice_fragment_results.json`.

Finite computation is not used as the proof; it targets boundary cases and the interfaces most likely to suffer convention or off-by-one errors.

---

## 6. Dependency ledger for integration

The audited fragment depends only on the following results already in the authoritative manuscript:

- `lemma-1.1-isolated-vertex-reduction`;
- positive obligatoriness of finite bipartite expansions;
- `theorem-canonical-atom-normal-form`;
- `corollary-minimal-generators-indecomposables`; and
- `proposition-componentwise-atom-count-spectrum`.

It additionally cites the established external inputs `komjath2001`, `bahmanian2015`, and `simon2011`.

The previous dependency on the repository-only shared-point multiplicity theorem has been removed by the self-contained realization lemma.

---

## 7. Formalization boundary

The block/lattice insertion is **not** currently a Lean theorem.  The existing Lean endpoint verifies the core obligatory/intrinsic and obligatory/constructible equivalences, not the new quantitative lattice corollary.

A sensible formalization order is:

1. formalize the canonical atom/block object;
2. formalize shared-point multiplicity and the forest excess identity;
3. formalize the local partition-product map; and
4. formalize the elementary chain-of-stars realization and translated atom-count spectrum.

The paper must not describe the lattice result as machine-checked until those steps exist.

---

## 8. Editorial recommendation

**Recommended for the main 593 paper after one independent mathematical read:**

- the short literature-aware block remark;
- the block formulation corollary; and
- the exact factorization-lattice spectrum, with the two short supporting lemmas now included.

**Keep supplementary / out of the main paper:**

- the full automorphism exact sequence;
- GI-completeness discussion;
- random-coarsening laws;
- Bell/Möbius/maximal-chain extremal tables; and
- the longer bond-lattice development.

The audited insertion is now strong enough to test in a publication-integration branch without turning the main 593 manuscript into an omnibus.
