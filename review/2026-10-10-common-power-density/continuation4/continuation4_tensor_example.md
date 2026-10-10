# An exact noncentral projection channel over a weighted star

**Scope.** This is an eight-state actual strictly positive host certified by
the projection-channel contraction at the target boundary `k=u`, `r=l`.
It does not prove the unrestricted target. It demonstrates an arbitrary
noncentral projection, unequal original weights, noncommuting coarse and
signed-channel operators, and four values on the entire centered square.
The entire boundary is already density-covered for every actual root by
[direct reflection](continuation4_boundary_scope.md). This example
illustrates the retained-coarse-surplus comparison and its quantitative
strengthening of the direct trace bound; it supplies no new boundary
density coverage and makes no literature-novelty claim.

## 1. Exact original data

Use four coarse states with original probability

\[
\pi=(1/2,1/4,1/8,1/8).
\]

Define the relative kernels

\[
S_0=\begin{pmatrix}
7/4&1/4&1/4&1/4\\
1/4&7/2&0&0\\
1/4&0&7&0\\
1/4&0&0&7
\end{pmatrix},\qquad
Q=\frac1{19}\begin{pmatrix}
32&-8&8&24\\
-8&40&-40&32\\
8&-40&40&-32\\
24&32&-32&56
\end{pmatrix}.
\tag{1}
\]

Every composition uses `pi`. Each row of `S_0` has original weighted sum
one. Set

\[
S=\frac{15}{16}S_0+\frac1{16}\Pi,\qquad
H=\frac1{64}Q,\qquad \beta=\frac1{4096}.
\tag{2}
\]

The original fine space consists of `(i,a)`, with `i in {0,1,2,3}` and
`a in {-1,1}`, and its original law is `mu(i,a)=pi_i/2`. An explicit host is

\[
\boxed{W((i,a),(j,b))=\frac{76}{507}
 \left[S(i,j)+\frac1{64}Q(i,j)ab\right],
 \qquad p=\frac{76}{507}.}
\tag{3}
\]

Its normalized root is `T=S+Hab`. Direct substitution gives

\[
\min T=\frac9{304},\qquad \max T=\frac{507}{76},
\qquad \min W=\frac3{676}>0,\qquad \max W=1.
\tag{4}
\]

Summing the target sign with its original probability `1/2` removes the
channel. Therefore every original-`mu` row of `T` has sum one, and every
row of `W` has sum `p`. All root, boundedness, symmetry, positivity, and
normalization requirements are satisfied exactly.

## 2. Why this is the arbitrary-projection case

Let `V` have rows `(1,0),(-1,1),(1,-1),(0,1)`. Its original weighted Gram
matrix and inverse are

\[
V^T\operatorname{diag}(\pi)V
 =\begin{pmatrix}7/8&-3/8\\-3/8&1/2\end{pmatrix},
\qquad
\left(V^T\operatorname{diag}(\pi)V\right)^{-1}
 =\frac1{19}\begin{pmatrix}32&24\\24&56\end{pmatrix}.
\tag{5}
\]

Formula (1) equals `Q=V(V^T diag(pi)V)^(-1)V^T`. Thus `Q=Q*=Q^2` in
original-`pi` composition and has rank two. In particular `H^2=beta Q`.
Its action on constants is

\[
Q1=\frac1{19}(18,5,-5,23)^T.
\tag{6}
\]

It neither annihilates nor fixes constants. No centered projection or
Markov projection is being inserted in place of this operator.

The triangle products on `013` and `023` are both `-6144/6859<0`. A
diagonal sign gauge leaves every cycle product unchanged, so no such gauge
makes `Q` entrywise nonnegative. Also, original-measure composition gives

\[
(SQ-QS)(0,1)=-\frac{157}{1216}\ne0.
\tag{7}
\]

The proof therefore does not rest on channel nonnegativity or commutation
of the coarse and channel operators.

## 3. Complete spectrum and a certified coarse surplus

The coarse root has eigenvalues `1`, `105/128` with multiplicity two, and
`45/64` with multiplicity one. Put

\[
x=(105/128)^2,\qquad y=(45/64)^2.
\]

Its actual square has exactly the two centered values `x>y>0`, with no
additional coarse zero band. The fine root splits into `S` on fiberwise
constant functions and `H` on odd functions. Hence the **entire centered
fine square** has the following values and multiplicities:

| Centered value | Multiplicity |
|---|---:|
| `(105/128)^2` | 2 |
| `(45/64)^2` | 1 |
| `1/4096` | 2 |
| `0` | 2 |

All seven centered dimensions are counted, including both zero modes.
The companion checker verifies the exact characteristic polynomial of
the original weighted fine operator, with this complete factorization.

The already established common-cone lemma gives an additional explicit
coarse surplus. Coarse positivity on this boundary is already guaranteed
by reflection; it does not require this extra coarse hypothesis.
Indeed, for the centered rank-two projection `P` of its `x` eigenspace,

`S^2=y Id+(1-y)Pi+(x-y)P`.

The relative kernel `R=(S^2-y Id)/(1-y)` is nonnegative PSD and Markov.
Every coarse power lies in `conv{Id,Pi,R}`; the coefficient of `Id` can be
chosen to be exactly `y^n` at power `n`. The all-identity `K4` term is
`sum_i pi_i^(-2)=148`. Keeping that term and the baseline one supplied by
the complete common-cone lemma for every other term gives

\[
F(S;n)\ge1+147y^N,\qquad N=\sum_{e\in E(K_4)}n_e.
\tag{8}
\]

This invokes the proved restricted common-cone result from
[PR #57](https://github.com/SamPetkov/Erdos593/pull/57); it does not assume
an unrestricted coarse density theorem.

## 4. Quantitative target-boundary conclusion

Let `k=u>=1`, `r=l>=1`, `h>=1`, and use the target edge exponents
`n=(u,r+h,u,r,u,r)`. Each complementary triangle star has a repeated pair
of coarse powers. The paired-star triangle and arbitrary-projection
quadrilateral lemmas in
[continuation4_tensor_projection_lemmas.md](continuation4_tensor_projection_lemmas.md)
therefore give

\[
\boxed{F(T;n)\ge1+147y^N+2\sum_C\beta^{q_C},}
\tag{9}
\]

where the sum is over the four triangles and three quadrilaterals,
`q_C=sum_(e in C)n_e`, and `beta=1/4096`. All terms refer to actual powers
of the single root in (3), under the original fine law.

For instance, at `(k,u,r,l,h)=(2,2,1,1,1)`, the six exponents are
`(2,2,2,1,2,1)`, `N=10`, and

\[
F(T)\ge1+147y^{10}
 +2\left(\beta^4+2\beta^5+2\beta^6+2\beta^7\right)>1.
\tag{10}
\]

The old density/mixing thresholds at `r=l` do not provide this displayed
certificate: here

\[
p=76/507<1/4,\qquad \max T^2=861135/155648>4.
\tag{11}
\]

No exclusion from every earlier fixed-host local neighborhood or every
possible relabeling is asserted. The point of (9) is the stated projection
mechanism, its original-measure validity, and the retained coarse surplus.

For a direct quantitative comparison with reflection, coarse reflection
and the complete spectrum also give

\[
F(T;n)\ge
1+2x^{2(u+r)}+y^{2(u+r)}+2\sum_C\beta^{q_C}.
\tag{12}
\]

The direct fine reflection bound is the same expression with the final
sum replaced by the single term `2 beta^(2(u+r))`. That exponent belongs
to one quadrilateral, so (12) adds the other six positive cycle terms.
This establishes a strict quantitative improvement on that trace bound,
while leaving the boundary's prior density validity explicit. Bounds
(9) and (12) are both valid; either coarse surplus may be retained.

The standard-library file
[continuation4_tensor_example_verify.py](continuation4_tensor_example_verify.py)
checks the weighted Gram projection, noncommutation, actual root and host,
all characteristic-polynomial factors, exact powers and all seven cycle
contractions, and the full finite density at three target-boundary tuples.
The finite checks supplement the analytic proofs and do not substitute for
them.
