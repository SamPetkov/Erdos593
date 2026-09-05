# Direction 4 — Tensor and graphical reductions

## Objective

Use the canonical atom forest as an exact computational interface for higher-order constraint and Gibbs models. The scalar graph-shadow identities already developed in the repository are only the colour-symmetric, boundary-free case. The broader target is an exact boundary-state theory that preserves fields, pins, and correlations.

For a finite state space `[q]`, consider

`Z_F = sum_sigma product_x h_x(sigma_x) product_e psi_e(sigma_e)`.

If `F` is obligatory, its canonical atom forest `Q(F)` separates the system into atoms meeting only at shared points. For each atom `A`, let `P_A` be its incident shared points. Define the exact atom response tensor

`T_A(tau) = sum_{sigma on V(A), sigma|P_A=tau} product local weights`.

Then the global partition function is the tree contraction

`Z_F = sum_{assignments on shared points} product_A T_A`.

This factorization is immediate from the reconstruction theorem, but several nontrivial research questions remain.

## Main research targets

### 1. Minimal boundary representation

The raw tensor has `q^{|P_A|}` entries. Determine when symmetries or the graph core of `A=J^+` allow a smaller sufficient state space. For colour-symmetric Delta-Potts interactions, equality-pattern sectors may replace raw colour assignments; with arbitrary site fields they generally cannot.

### 2. Pairwise reduction with observables

Characterize exactly which terminal sets can be preserved by an edge-preserving scalar graph reduction. The existing mixed-size bridge-rank work suggests a sharp structural criterion. The canonical atom forest should allow a blockwise version in which incompatible observables are retained as finite boundary tensors rather than discarded.

### 3. Complexity parameter

Define an inference width from the maximum effective boundary complexity of the port-marked atoms, not merely the hyperedge size. A plausible target is an algorithm polynomial in the number of atoms and exponential only in this width. High-width 2-connected graph cores must remain visible: the tree decomposition does not make arbitrary atom internals easy.

### 4. Defects and hybrid solvers

For a hypergraph that is not bridge-reducible, delete or isolate a small exceptional interaction set `D`. Solve the reducible part exactly and sum/perturb over the defects. Combine this with rigorous partition-function and marginal error bounds when defects are approximated rather than summed exactly.

## Paper boundary

This should not be inserted into the Erdős 593 classification paper beyond perhaps one motivating remark. If developed, it is a separate mathematical/statistical-physics paper whose central theorem should be an exact reduction or inference theorem with a converse, not merely an application of tree factorization.

## Concrete next experiments

- implement atom-response tensors for single triples, `C_{2k}^+`, and `K_{a,b}^+`;
- compare scalar graph reduction with full boundary tensors under nonuniform fields;
- search for the smallest terminal state compression compatible with colour permutation symmetry;
- benchmark exact atom-tree contraction against direct enumeration on synthetic assemblies;
- formulate a precise theorem for the interaction between canonical ports and graph-core treewidth.
