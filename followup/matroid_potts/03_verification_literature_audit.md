# 12. Uniqueness and transfer of shadow invariants

Any two cycle shadows \(J,J'\) represent the same labelled graphic matroid.
Whitney's 2-isomorphism theorem implies that connected shadows differ only by
Whitney switches and the standard cut-vertex operations [@whitney1933;
@truemper1980]. If the matroid has a simple 3-connected graphic
representation, the shadow is unique up to graph isomorphism.

Thus the reduction is canonically graph-valued in the 3-connected case and
canonically matroid-valued in general.

Every graphic-matroid invariant transfers to \(F\), including:

- ranks and nullities of all edge subsets;
- spanning-forest counts;
- reliability, flow, and tension evaluations;
- broken-circuit and activity data;
- the base-polytope face structure;
- deletion--contraction identities at the matroid level.

# 13. Computational verification

Two independent standard-library programs support the derivations:

1. `experiments/berge_matroid_coloring.py`;
2. `experiments/monochromatic_dependence_hypertutte.py`.

The first constructs expansion atoms and one-point amalgamations for
\(r=3,4,5\), including attachments at private hypergraph points that do not
correspond canonically to a selected shadow core vertex. It checks the subset
rank formula, incidence nullity, weak and strong colorings, Potts evaluations,
and the forest and unicyclic formulas.

The second constructs 24 deterministic examples and checks:

- 1,410 subset-rank identities;
- 1,410 modular-plus-graphic polymatroid identities;
- 1,410 termwise hypergraph-Tutte transformations;
- 2,820 exact dependence identities;
- 48 multivariate Potts-polynomial identities;
- 32 direct coloring distributions, totaling 5,383,754 colorings;
- 24 bipartite Ising gauge identities;
- forest and unicyclic laws.

All committed checks report zero failures. These computations verify finite
instances and algebraic transformations; they do not replace review of the
cycle-shadow theorem or the general proofs.

# 14. Literature and novelty boundary

The following inputs and surrounding theories are established:

- the complete \(r=3\) obligatory classification and its one-apex trace method
  [@li2026];
- obligatory uniform expansions of complete bipartite graphs [@reiher2024];
- graph and matroid Tutte--Potts theory [@sokal2005];
- multivariate hypergraph chromatic polynomials [@white2010];
- balanced-hypergraph strong coloring [@berge1972];
- polymatroid Tutte theory and translation invariance [@bernardi2020];
- the general 2026 hypergraph Tutte polynomial and its Potts relations
  [@berrekkal2026];
- monochromatic-edge limit theory [@bhattacharya2013; @fang2014; @xie2024];
- Whitney 2-isomorphism [@whitney1933; @truemper1980];
- the ferromagnetic-Ising FPRAS [@jerrum1993].

The contributions under review are the exact consequences of the bridge-block
cycle shadow:

1. the canonical Berge-cycle matroid and intrinsic rank formula;
2. the modular-plus-graphic polymatroid and base-polytope translation;
3. the weak and strong Tutte--Potts coloring formulas;
4. the specialization (7.2) of the 2026 hypergraph Tutte polynomial;
5. the exact monochromatic-event dependence matroid;
6. the complete joint law and factorial-moment reconstruction;
7. the high-Berge-girth transfer theorems;
8. the Property-B-to-ferromagnetic-Ising reduction.

Targeted searches did not locate this combined package. This is not an
absolute priority claim. The manuscript should remain a draft until the
cycle-shadow theorem and the probabilistic and polyhedral consequences receive
independent specialist review.

# 15. Audit status and dependency map

The logical dependency is:

\[
\text{bridge-block theorem}
\Longrightarrow
\text{cycle shadow}
\Longrightarrow
\text{canonical matroid and rank}
\Longrightarrow
\begin{cases}
\text{coloring and Potts identities},\\
\text{polymatroid and polytope identities},\\
\text{probabilistic dependence laws}.
\end{cases}
\]

The \(r\ge4\) avoidance proof is **not** used. For \(r=3\), the results apply to
all obligatory triple systems after isolated vertices are removed. For general
\(r\), they apply unconditionally to the generated class \(\mathcal B_r\).

Before external submission:

1. independently audit the cycle-shadow theorem and subset-rank formula;
2. compare (7.2) directly against the authors' exact convention for
   \(T_{\mathrm{HG}}\);
3. obtain a matroid/polymatroid specialist check of Section 3;
4. obtain a probability specialist check of Sections 8--10;
5. rerun the complete deterministic verification workflow;
6. perform a final literature and attribution audit.
