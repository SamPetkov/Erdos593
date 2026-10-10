# Fourth continuation: actual-source constraints for the two-cover route

## Verdict and scope

The unrestricted common-power target and the complete finite-cover comparison remain unresolved. This note proves structural restrictions on the *canonical* coarse/channel pair arising from a two-copy host. In particular, the exact commuting coarse-domination obstructions of PR #59 cannot themselves be these canonical pairs, even after duplicating states without changing kernels. This is an obstruction to a proposed transfer, not a positive cover comparison and not a target counterexample.

The determinant/permanent expansion used below is an original-measure specialization of an existing two-lift method. It is not presented as a new general theorem: Péter Csikvári, *Extremal regular graphs: the case of the infinite regular tree*, arXiv:1612.01295v2, Section 4, especially Theorem 4.2 and Lemmas 4.5–4.6, supplies that method, with the sign-gauge hypothesis discussed in Section 5 below. Section 5 of that paper treats vertex weights. The present note spells out the exact common-power transport and the additional rank and commutation constraints needed in this task.

## 1. Canonical unordered pairs and the original measure

Let `T` be an actual finite self-adjoint nonnegative Markov root on `(X,mu)`, with `mu_x>0`. Fix an ordering of `X`. Let

`I={{x,y}: x,y in X}`

include repeated pairs. Write a representative as `i=(x,y)` with `x<=y`, and put

`pi_(x,y)=2mu_x mu_y` if `x<y`, and `pi_(x,x)=mu_x^2`.

These are positive and sum to one. For `i=(x,y), j=(z,w)`, define relative kernels

`S(i,j)=[T(x,z)T(y,w)+T(x,w)T(y,z)]/2`,

`H(i,j)=[T(x,z)T(y,w)-T(x,w)T(y,z)]/2`.

Both kernels are self-adjoint on the original pair measure `pi`, `S` is nonnegative Markov, and `|H|<=S`. Every row or column of `H` indexed by a diagonal pair `(x,x)` is zero. Uniform binary fibers give the actual root

`T_hat((i,a),(j,b))=S(i,j)+H(i,j)ab`,

`mu_hat(i,a)=pi_i/2`, `a,b in {-1,1}`.

On distinct pairs the signs select the two orientations of the ordered pair. On a diagonal pair both signs select the same ordered pair. The map to `X^2` pushes `mu_hat` forward to `mu tensor mu`. Thus `T_hat` is a duplication of the genuine product root `T tensor T`. If `W=pT`, then `W_hat=p^2 T_hat` is actual and lies in `[0,1]`.

For every nonnegative integer `m`, on the nonzero antisymmetric subspace, and for `m>=1` on the full pair space,

`S^m(i,j)=[T^m(x,z)T^m(y,w)+T^m(x,w)T^m(y,z)]/2`,

`H^m(i,j)=[T^m(x,z)T^m(y,w)-T^m(x,w)T^m(y,z)]/2`.

All compositions on the left use `pi`; those on the right use `mu`. At `m=0`, the full pair-space identity for `H^0` needs the diagonal-pair zero extension removed, so we use only positive powers throughout this note.

### Proof of the transport

An isometry from `L2(pi)` onto the symmetric functions in `L2(mu tensor mu)` assigns `f({x,y})` to both ordered pairs. The original norm is preserved because the two distinct orientations have total mass `2mu_x mu_y`. Restriction of `T tensor T` to that subspace is exactly `S` by grouping ordered pairs in its original-measure sum.

The functions on distinct unordered pairs, extended as `f(x,y)` for `x<y` and `-f(y,x)` for `x>y`, give the same isometry onto the antisymmetric subspace. The restriction there is `H`; the additional diagonal-pair coordinates are in the kernel of `H`. Symmetric and antisymmetric subspaces are invariant under `T tensor T`. Taking powers proves the displayed identities without changing any measure.

Finite product integration also gives

`F(T_hat;n)=F(T tensor T;n)=F(T;n)^2`.

Each original variable has two independent `mu` coordinates, so the product of all six edge factors splits into the two original K4 integrands. This proves the tensor transport rather than assuming it.

## 2. Rank and spectral constraints, including zeros

Let `lambda_1,...,lambda_n` be the complete real eigenvalue list of `T`, including zeros. Then

- `S` has eigenvalues `lambda_i lambda_j` for `i<=j`;
- on distinct pairs `H` has eigenvalues `lambda_i lambda_j` for `i<j`, and its full pair-space realization has `n` additional zero eigenvalues.

This follows by using symmetrized and antisymmetrized tensor products of a complete original orthonormal eigenbasis. If `r=rank(T)`, necessarily

`rank(S)=r(r+1)/2`, `rank(H)=r(r-1)/2`.

In particular, if `s=rank(S)` and `h=rank(H)`, then

`r=s-h`, `2s=r(r+1)`, `2h=r(r-1)`.

These restrictions also apply to `S^2,H^2`, since the kernels are self-adjoint. They do not rely on positivity or simplicity of the nonzero root eigenvalues.

For each integer `m>=1` there are the additional trace identities

`tr(S^m)=[tr(T^m)^2+tr(T^(2m))]/2`,

`tr(H^m)=[tr(T^m)^2-tr(T^(2m))]/2`.

Here traces are the original-measure operator traces. In particular, for the square eigenvalues `theta_i=lambda_i^2`, the nonzero channel spectrum consists of the products `theta_i theta_j` with distinct eigenbasis indices; these are not independently selectable centered bands.

### Consequence for PR #59's exact obstructions

The commuting 18-state signed-fiber construction has `rank(S)=9` and `rank(H)=3`. Their difference is six, whereas a canonical pair with `r=6` would require ranks `21` and `15`. The ten-state construction has ranks `5` and `3`; a canonical pair with rank difference two would require ranks `3` and `1`. Neither pair can be a canonical unordered-pair quotient of an actual root.

This remains true after pure state duplication: if `q:Y->X` pushes a positive probability `nu` onto `mu`, the pulled-back kernel `B'(y,z)=B(qy,qz)` intertwines with `B` on functions constant on each fiber and annihilates their orthogonal complement. Thus it preserves the full nonzero spectrum and rank. This statement concerns duplication or relabelling, not arbitrary larger constructions that might alter the operators.

## 3. A commutation rigidity theorem

**Theorem.** Suppose the original actual root `T` is invertible. For its canonical pair `(S,H)` above, the following are equivalent:

1. `S H=H S` under the original pair measure.
2. `S^2 H^2=H^2 S^2` under the original pair measure.
3. `T^2=Id` under the original state measure.

Consequently, an invertible actual host with `A=T^2 != Id` has genuinely noncommuting canonical channels, for every choice of orientations of the distinct unordered pairs. In particular, no strictly positive invertible root on more than one state has commuting canonical channels.

### Proof

Let `D` be the subspace of functions supported on diagonal pairs and `O` its orthogonal complement. The canonical `H` is zero on `D`, while on `O` it is an invertible copy of `wedge^2 T`. If `n=1`, the conclusion is immediate. Otherwise, commutation in the block `D <- O` gives

`S_DO H_OO=0`, hence `S_DO=0`.

But for `j<k`,

`S((i,i),(j,k))=T(i,j)T(i,k)`.

The entries of `T` are nonnegative, so every row has at most one positive entry. Its Markov row sum is one, so it has exactly one. Symmetry makes the selected column map an involution `sigma`. The Markov normalization gives `T(i,sigma(i))=1/mu_(sigma(i))`; symmetry gives `mu_i=mu_(sigma(i))`. Therefore `Tf(i)=f(sigma(i))` and `T^2=Id`.

Conversely, a nonnegative self-adjoint Markov root with square `Id` is such a measure-preserving involution. On unordered pairs `S` is the induced permutation and `H` is the same permutation with the orientation sign, and is zero on diagonal pairs. The orientation sign is unchanged when the involution is applied twice. Hence `S H=H S`, giving 3=>1=>2.

For 2=>3, apply the preceding block argument to the actual invertible PSD Markov kernel `A=T^2`. Its canonical pair is `(S^2,H^2)` by Section 1. Thus `A^2=Id`; since `A` is PSD, all its eigenvalues are nonnegative, so `A=Id`.

This theorem does not remove singular hosts. For example, `T=Pi` has `H=0`, so commutation holds while `T^2` need not equal `Id`. The rank identities of Section 2 retain all zero modes and continue to apply there.

## 4. The exact seven comparisons and what they do not prove

Write `K_n=T^(2n)`, and let `S_n=S^(2n), H_n=H^(2n)`. A two-cover sign `epsilon_e in {-1,1}` replaces the ordered-pair product along edge `e` by

`S_(n_e)(i_v,i_w)+epsilon_e H_(n_e)(i_v,i_w)a_v a_w`.

Averaging the four independent signs leaves exactly the empty edge set and the seven cycles of `K4`: four triangles and three quadrilaterals. Define

`Gamma_C=E_(i_a,i_b,i_c,i_d iid pi) product_(e in C) H_(n_e)(i_v,i_w) product_(e notin C) S_(n_e)(i_v,i_w)`.

Then

`Z_epsilon=F(S;n)+sum_C (product_(e in C) epsilon_e) Gamma_C`,

`F(T;n)^2=F(S;n)+sum_C Gamma_C`,

and therefore

`F(T;n)^2-Z_epsilon=2 sum_(C: product_(e in C)epsilon_e=-1) Gamma_C`.

Gauge the three edges `ab,ac,ad` to sign `+1`. Each of the seven nonzero sign choices on `bc,bd,cd` selects exactly four of the seven cycles in this last sum. This follows because the seven cycles are exactly the seven nonzero vectors of the binary cycle space of `K4`, of dimension three; each nonzero linear functional is one on four vectors.

Thus individual `Gamma_C>=0` would suffice, but the actual comparison only requires the relevant four-cycle sums. Neither sign assertion is proved in unrestricted generality here. The algebraic identity is a diagnostic reduction, not by itself progress on the unrestricted sign. The additional mathematical progress in this note is the source compatibility and commutation rigidity proved in Sections 2–3.

## 5. Precise literature boundary and explicit failed automatic hypotheses

Csikvári's Theorem 4.2(a) assumes a diagonal sign gauge making his determinant matrix entrywise nonnegative. Its proof expands into Eulerian edge sets and uses that gauge to make their products nonnegative. The same proof permits edge-dependent matrices if **one common gauge** works for all determinant channels. For actual common powers, a gauge making `H^2` nonnegative also works for every `H^(2n)` by original-`pi` composition. These are sufficient additional hypotheses, not consequences of PSD.

### A strictly positive actual three-state gauge obstruction

Take uniform `mu=1/3` and

`T=(Id+Pi)/2`, `p=1/2`, `W=pT`.

Then `W` has diagonal entries one and off-diagonal entries `1/4`. The actual square is

`A=Id/4+3Pi/4`,

with relative entries `A(i,i)=3/2`, `A(i,j)=3/4` for `i!=j`. On the three distinct pairs `(0,1),(0,2),(1,2)`, the three off-diagonal entries of the canonical `H^2` are respectively

`9/32`, `-9/32`, `9/32`.

Their triangle product is negative. A diagonal sign gauge preserves a triangle product, so no gauge can make this channel entrywise nonnegative. Its diagonal entries are positive, so it also cannot be made entrywise nonpositive. Reordering the original states only permutes pairs and changes orientation signs, so it does not fix this failure.

This host is already in a restricted density class. It is used to disprove automatic applicability of the determinant sign criterion, not as new density progress or a cover counterexample. It also shows that passing to an actual nonnegative Markov square does not eliminate sign-frustrated compound entries.

### Actual cubic moments are not automatically nonnegative

For any centered original eigenfunction `phi_i`, the coarse symmetric-square eigenfunction is

`psi_i({x,y})=[phi_i(x)+phi_i(y)]/sqrt(2)`.

The original pair measure gives exactly

`E_pi psi_i psi_j psi_k = (E_mu phi_i phi_j phi_k)/sqrt(2)`.

Use the actual 32-state star-moment law from PR #59. Its four distinct cubic star moments are `1/2,1/2,1/2,-1/2`, and every one of the six participating original eigenfunctions occurs in two stars. The corresponding four canonical coarse cubic moments have product `-1/64`. Sign changes of these six induced eigenfunctions preserve that negative product. Thus their natural induced eigenbasis cannot be made to have all nonnegative cubic moments merely by changing eigenfunction signs. No claim is made here about rotations within other degenerate eigenspaces or existence of a different full basis.

## 6. Bounded diagnostics and remaining scope

`continuation4_cover_search.py` explores only the special canonical cycle coefficients, not arbitrary signed channels. It uses 252 exact nonnegative integer-flow seeds (84 each in original dimensions 3,4,5), with one assigned tuple and one assigned cycle per seed. Twelve subsequent bounded finite-difference optimizations use positive symmetric flow coordinates. None of these twelve runs certified numerical convergence: nine reached the 60-iteration cap and three ended with an abnormal line-search status. No negative sampled or retained optimized coefficient was found. This is numerical evidence only; it proves neither an individual-cycle theorem nor a complete cover comparison. The samples are not a Cartesian sweep of every tuple and cycle. The provenance audit records 95 seeds with `p<1/4`, 72 of which also have `max A>4`, and 146 seeds with actual root zeros. Only one retained optimized point has `p<1/4`; the numerical improvement mostly moved into that previously density-covered region.

The exact verification companion independently reconstructs the pair measure, power and trace identities, ranks, commutators, and finite-cover identities on eight explicit rational hosts. Seven hosts undergo all seven nontrivial two-cover checks, for 49 exact comparisons. It also checks the three-state sign-gauge obstruction, equality, singularity, nonuniform normalization, a four-state host with three distinct positive centered square eigenvalues, and a five-state host with three distinct positive centered values **plus an additional zero value**. The last host undergoes the source-structure checks but is not included in the 49 cover comparisons. These finite checks validate the implementation and the stated examples; the structural statements above have their own proofs.

The cover route remains blocked at a genuinely collective sign question on the constrained symmetric/exterior-square channels. PR #59's arbitrary signed-channel deficit does not answer that question, and the determinant sign-gauge theorem does not apply automatically.
