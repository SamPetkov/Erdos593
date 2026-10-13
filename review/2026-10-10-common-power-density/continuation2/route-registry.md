# Route registry: signed-channel bounds and exact contraction obstructions

**Exact verdict: unrestricted target unresolved; no certified `F<1` host.**
Every complete result in this folder has its stated restricted hypotheses.
Negative examples concern stronger sufficient assertions and carry separate
positive lower bounds for the actual target.

| Route | Mechanism tested | Final status |
|---|---|---|
| Actual multiplication tensor and ordered fans | Retain the two actual ordered fan sources from the long `ac` edge. | The proposed modewise positivity and PSD reflection premise fail on an exact admissible thirty-two-state host; full `F>1`. |
| Actual fiber multiplication coefficients | Keep the actual cubic moments in an orthogonal fiber-channel expansion. | Complete weighted contraction when those moments and squared channel entries are nonnegative; complete bases give every finite graph. |
| Flat coarse square, arbitrary signed channel | Average the four binary signs, then contract complementary identity forests. | Complete contraction for `S^2=rho Id+(1-rho)Pi`, including arbitrary unequal original weights and signed even channel entries. |
| Markov projection in the coarse square | Use support forced by `S^2=rho Id+(1-rho)P`. | Complete extension; the even channel preserves projection blocks, with exact original-measure factor `m_B^-2`. |
| Flat signed-channel square, arbitrary coarse root | Expand cycle edges into `Id` and `Id-Pi`; bound all contracted coarse expressions. | Complete quantitative theorem for every uniform coarse size. Unequal weights with `d=1/max pi>=4` have the proved surplus `sum_C[alpha^q+(d-1)beta^q]`. |
| Adding positive global mixing to a partial-averaging coarse projection | Compress common even channel powers into the coarse blocks. | General individual-cycle positivity and even total coarse domination are false. Exact ten- and eighteen-state actual hosts satisfy `1<Ffine<Fcoarse`; the eighteen-state version has `SH=HS`. |
| Complete graph covers | Compare each actual common-power cover partition function to the corresponding power of the base density. | Still open; the precise remaining sufficient obligation is stated below. Neither coarse-domination obstruction settles it. |
| Actual-host optimization | Search both complete two-covers and signed cycle/coarse differences with original-measure admissible roots. | The fixed numerical batches found no negative candidate. The first batch's target cases were already density-covered; the second reaches `p<1/4,max A>4`. Exact analytic coarse-domination failure supersedes any universal interpretation of the latter negative scan. |

The unrestricted target always keeps one actual nonnegative Markov square
root and the original measure. The new positive proofs use Schur products,
common-power ordering where it is actually available, and explicit weighted
contractions. They do not assert nonnegativity of a trace of three arbitrary
PSD matrices.

## Remaining obligation: complete covers of arbitrary actual roots

For an actual root `T`, an admissible target tuple, a positive integer `M`,
and one permutation `sigma_e` of the sheets for each base edge, define

\[
Z_\sigma=
\mathbb E_{x_{v,t}\sim\mu}
\prod_{e=vw}\prod_{t=1}^M
K_{n_e}(x_{v,t},x_{w,\sigma_e(t)}).
\]

The unproved sufficient assertion is

\[
\boxed{Z_\sigma\le F(T;n)^M\quad\text{for every such cover}.}
\tag{C}
\]

The parent packet proves the original-measure entropy/type lower bound
`limsup_M (E_sigma Z_sigma)^(1/M)>=1`. Thus (C), if established under the
exact unrestricted actual-root hypotheses, would prove the requested
inequality. This is a stronger graph-cover comparison, not the supplied
Dirichlet target reformulation under another name.

No proof of (C) is claimed. For a single-edge two-sheet switch, the actual
root sandwich in `continuation2_tensor.md` is entrywise nonnegative but its
symmetric part can have a negative quadratic form. The identity retaining
trace surplus and skew part remains only an identity. A theorem-strength
collective estimate is missing. All-cover domination does not follow from
checking finitely many two-covers, or from the restricted contractions.

This registry deliberately leaves the generic signed-cycle and commuting
coarse-domination assertions **closed as false**, not listed as missing
lemmas to be assumed later. It states only one remaining open sufficient
obligation. No representation of every arbitrary actual root by the proved
channel classes is asserted.

## What the exact coarse-domination obstruction closes

For actual coarse `S`, symmetric `H` with `|H|<=S`, and a cycle `C`, the
previously proposed universal nonnegativity assertion concerned

\[
J_C=\mathbb E_{\pi^4}
\prod_{e\in C}H^{2n_e}\prod_{e\notin C}S^{2n_e}.
\]

At tuple `(k,u,r,l,h)=(8,2,3,1,1)`, the exact commuting eighteen-state host
has `J_bcd<0` and `sum_C J_C=Ffine-Fcoarse<0`. Its coarse square is a strict
convex combination of `Id`, `Pi`, and a nonnegative Markov projection.
The negative compressed trace is embedded into an actual strictly positive
Markov root, with all original masses and fixed rational parameters given.
The same proof establishes `Ffine>D^2/162-1>1`.

Thus this closes both coefficientwise and aggregate coarse domination for
that proposed general class, even after adding commutation. It does not
refute (C) or the original density inequality. The support-preserving
projection endpoint theorem and the channel-spectrum theorem retain their
proved scope.

## Verified primary-literature hypotheses

Yuqi Zhao, [*Sidorenko-Type Inequalities for Even Subdivisions over Finite
Abelian Groups*](https://arxiv.org/abs/2507.15723), Theorem 1.4, establishes the
even-subdivision inequality for finite abelian Cayley hosts and allows
different even subdivision lengths. The primary
[PDF](https://arxiv.org/pdf/2507.15723) was checked at the theorem statement.
This is background for scalar character-flow arguments; it is not applied
as a theorem about arbitrary weighted coarse matrix channels or all actual
roots. The channel theorems in this packet are proved directly.

The precise hypotheses of the earlier Ruozzi cover results and
Sah--Sawhney--Stoner--Zhao interaction theorem remain as recorded in the
[parent route registry](../route-registry.md). A homogeneous PSD interaction
result is not silently applied to six unequal powers. No novelty conclusion
is inferred from a missing citation.

## Boundedness, equality and measure checks

The frozen cover batch contains 224 rational hosts, 2,688 host/tuple cases,
18,816 nontrivial two-cover comparisons and twelve capped optimizations.
Its support family has `p>=2/5`, so its target values calibrate an already
proved density case. The signed-channel batch contains 180 fixed rational
host/tuple pairs, 1,260 cycle evaluations and twelve starts capped at 100
iterations. It includes 173 samples with `p<1/4,max A>4`; all twelve retained
optimizer points meet both tests. Eight starts hit the cap and four converged.
No further search followed those caps. Later exact replays are validation.

The notes and checkers explicitly handle original unequal measures,
strictly positive roots, root zeros, centered zero bands, negative actual
root eigenvalues, disconnected squares, equality, and `k=u`, `r=l`, `h=1`.
They distinguish the true spectral trace from the weighted atom-bound
coefficient. Atom splitting is not silently used to preserve an identity
kernel or a root constraint.

The source, full data, exact certificates and detached analytical reviews
form one coherent follow-up PR. No Lean interface is added while the
unrestricted mathematical target is incomplete.
