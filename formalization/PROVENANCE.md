# Formalisation provenance and attribution

Eric Li's preprint arXiv:2606.24882 was posted on 23 June 2026 and contains the
first publicly posted complete proof of Erdős Problem 593. It introduces the
complete-rank one-apex sequence lift and exact bridge-trace theorem, and its
positive proof uses the selected-incidence decomposition, quotient forest, and
running-intersection assembly.

The Lean development in this repository formalises a separate implementation
of that classification. Shared architecture is credited to Li. The code's
principal implementation choices are:

- an explicit base-node, base-letter, base-fibre, and canonical-apex API;
- a support-incidence forest proof of the global finite-linear trace theorem;
- direct finite graph-factor and private-vertex-expansion interfaces;
- a machine-checked rooted-abundance and one-point-amalgamation closure route;
- a machine-checked Erdős--Rado nonlinear host; and
- an explicit shift-graph realisation of the classical high-odd-girth input.

The project is not a line-by-line formalisation of Li's manuscript, but neither
its separate code structure nor an instruction to AI systems to work without
internet access establishes informational independence. The repository makes no
such claim and assigns Li priority for the first publicly posted complete proof.
The formalisation's contribution is a reproducible kernel check of the
implementation presented here.
