# Dependency audit of the tensor overlap constraint

## Audit boundary

The conclusion under audit is the tensor identity and two-sided bound
(4)--(5) in [Tensor constraint for collective overlap payment](tensor-overlap-constraint.md),
followed by its universal-certificate equivalence and conditional
implication (6). The original finite positive law, actual nonnegative
symmetric Markov root and ordered integer exponents remain fixed.

Accepted primitives are the earlier fully reviewed Hellinger lower
bound and actual-channel processing inequality, finite product
factorization, Cauchy--Schwarz, variance, \(A^h-\Pi\succeq0\),
nonnegative powers, elementary inequalities and the squeeze theorem.
No universal payment or density conclusion is accepted as a primitive.

## Obligation graph

```text
C0 tensor identity and exponential rate
 <- R0 (AND: O1, O2, C1)
C1 M^N <= LB_N <= 3 M^N
 <- R1 (AND: O3, O4, O5)
C2 equivalence of the two universal certificate statements
 <- R2 (AND: C0, O6, O7)
C3 W_u>=1 implies F(k)>=1 for all k>=u
 <- R3 (AND: O8, O9, O10)

C4 unrestricted density via the proposed W route
 <- R4 (AND: C3, O11)
```

The first four conclusions are proved. The final route is a separately
identified proposal, not an additional conclusion of the proved note.

## Critical findings

Tensorization uses powers of each individual scalar, not the power of
their signed sum. The lower bounds require three different regroupings;
positivity of the whole sum alone would not establish its exponential
rate. A failed certificate on an actual tensor host is not a density
counterexample. The universal \(W_u\ge1\) leaf remains missing: neither
its monotonicity nor a nonnegative Gram representation establishes a
lower bound of one under the original coupled weights.

## Dependency table

| ID | Exact claim or obligation | Needed by | Route / edge | Classification | Support | Status |
| --- | --- | --- | --- | --- | --- | --- |
| C0 | (4)--(5), including the zero case | root, C2 | R0 | major claim | O1, O2, C1 | discharged |
| O1 | Tensor root is admissible; all defined flags, kernels and overlaps factor | C0, O6 | R0 / AND | algebraic/logical step | finite products, root marginals and nonnegativity | discharged |
| O2 | Credit is S-S0, gradient overlap is W-X, giving (3)--(4) | C0 | R0 / AND | algebraic/logical step | definitions and symmetry; earlier Hellinger bound | discharged |
| C1 | M^N <= LB_N <= 3M^N | C0, O7, O10 | R1 | major claim | O3, O4, O5 | discharged |
| O3 | G0>=S0 and S>=S0 | C1 | R1 / AND | proved earlier | PSD projection and variance, explicitly reapplied | discharged |
| O4 | W>=X and G0>=X | C1 | R1 / AND | algebraic/logical step | square gradient and H²<=ff | discharged |
| O5 | Three displayed regroupings, upper bound and squeeze, including M=0 | C1, C0 | R1 / AND | algebraic/logical step | nonnegative powers and finite max | discharged |
| C2 | The two universal certificate statements are equivalent | root | R2 | major claim | C0, O6, O7 | discharged |
| O6 | A host with M<1 admits tensor powers at the same allowed tuple | C2 | R2 / AND | side condition | O1; tuple inequalities unchanged | discharged |
| O7 | 3M^N<1 eventually when 0<=M<1, while M>=1 pays LB at N=1 | C2 | R2 / AND | algebraic/logical step | geometric powers and C1 | discharged |
| C3 | Conditional implication (6) | root, C4 | R3 | major claim | O8--O10 | discharged |
| O8 | W_u>=1 in the conditional implication | C3 | R3 / AND | hypothesis | explicitly stated condition, not a universal fact | discharged |
| O9 | W_k>=W_u for k>=u | C3 | R3 / AND | proved earlier | actual Markov Hellinger processing, nonnegative fixed weights | discharged |
| O10 | F>=LB>=W_k | C3 | R3 / AND | proved earlier | earlier Hellinger bound and C1 at N=1 | discharged |
| C4 | Universal F>=1 by this proposed W route | proposal only | R4 | major claim | C3 and O11 | failing |
| O11 | W_u>=1 on every actual host for all u>=1,r>=l>=1,h>=1 | C4 | R4 / AND | missing | no proof supplied | failing |

## Verdict

**FOLLOWS** for the tensor identities, exponential rate, universal-certificate
equivalence and explicitly conditional implication, C0--C3.
**NOT ESTABLISHED BY THIS PROOF** for the unrestricted density theorem
via this proposal, C4: O11 is missing. This does not show that O11 or
the density theorem is false, nor does it exclude a different proof.
