# Weighted source compensation and simultaneous cover certificates

**Exact verdict: the unrestricted common-power density inequality remains
unresolved. No admissible finite counterexample with `F<1` is certified.**
This bounded continuation proves a uniform weighted extension of an actual
source contraction, extends the supplied sign-host cover comparison to
genuinely simultaneous permutations, and gives an exact actual-host
obstruction to a newly tested modewise shortcut. Their scopes are separate.

This packet is stacked on [PR 62](https://github.com/SamPetkov/Erdos593/pull/62),
commit `bb919054eab3248e45ce1cd0c9a8cf1f39329025`. All earlier packets are
preserved. No accepted theorem classification, manuscript theorem, or Lean
interface is changed. No priority or novelty assertion is made.

## 1. Exact target retained

The original finite law is `mu_x>0`, with total one. The symmetric host
`W in [0,1]` has every original weighted row sum `p>0`. Its actual
nonnegative self-adjoint Markov root is `T=W/p`, and

\[
A=T^2,\qquad K_j=A^j.
\]

The open target is

\[
F=\mathbb E_{\mu^4}
K_k(a,b)K_{r+h}(a,c)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d)\ge1,
\]

for `k>=u>=1`, `r>=l>=1`, `h>=1`. Every integral and composition retains
the original law. All six edge kernels come from that one actual root.
Tuple order is `(k,u,r,l,h)`; edge order is `ab,ac,ad,bc,bd,cd`.
The target remains the prescribed all-even subdivision pattern.

## 2. Main positive derivation: weighted flat complements

The [full source proof](continuation7_source_weighted_complement.md)
extends continuation6's uniform flat-complement calculation to specified
nonuniform original laws, uniformly over **every actual root and every
positive exponent triple** within the class.

Let `pi` be the original law on `n>=4` states, let `S` be any actual
nonnegative self-adjoint Markov root on it, and put `B=S^2`. Choose any
sign vector `f_i=+-1` and set

\[
Q=I-f\otimes f,\qquad
Q(i,j)=\frac{\mathbf1_{i=j}}{\pi_i}-f_if_j.
\]

It is an original-law orthogonal projection of rank `n-1`. Neither
centering of `f` nor commutation with the root is assumed. Its actual
fields on `E=ran Q` are

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_E,\qquad
M_s=B^sR,\qquad X_s=M_s-I_E,
\]

and `J_xyz=E_pi tr(M_x M_y M_z)`.

Define

\[
a_i=\pi_i^{-1}-n,\quad\delta=\max_i|a_i|,\quad
m=n-2-\delta,\quad M=n+\delta-1.
\]

If

\[
\boxed{\delta<n-2,\qquad
\delta^2(n+\delta-1)\le8(n-3)(n-2-\delta),}
\]

then **`J_xyz>=n-1` for all positive integer triples**, with equality
exactly when `S=Pi`. In particular `delta<=sqrt(n)/2`, and therefore
`delta<=1`, suffices for every `n>=4`. This is a restriction on the
original law and projection shape, not a fixed-host continuity radius.
There is no spectral band bound, source-cap hypothesis, or visible-trace
balance assumption in this theorem.

### The additional mechanism

For `L_s=B^s-Pi`, form the **entrywise** product

\[
H=L_x\circ L_y\circ L_z.
\]

The Schur product theorem makes `H` a PSD operator in the original
weighted space. It need not be entrywise nonnegative. The exact
multiplication-tensor calculation gives

\[
C_{xyz}:=\mathbb E\operatorname{tr}(X_xX_yX_z)
=(n-3)\langle1,H1\rangle+\langle a,H1\rangle.
\]

Completing the square in this same positive form yields

\[
C_{xyz}\ge-\frac{\langle a,Ha\rangle}{4(n-3)}.
\]

This converts the potentially negative weighted cubic into an error
controlled by quadratic spectral quantities. It retains the uniform
positive cubic form instead of discarding it before bounding the error.
For `x<=y<=z`, put `sigma_t=tr(B^t)-1`, retaining additional stationary
modes and zero modes. The exact pair calculation gives
`g_st=E tr(X_s X_t)>=m sigma_(s+t)`. Also

\[
\langle a,Ha\rangle
\le\delta^2M\sqrt{\sigma_{2y}\sigma_{2z}}.
\]

Here `|L_x(i,t)|<=M` follows from the original relative identity diagonal
`1/pi_i`; the remaining factors are bounded by Cauchy--Schwarz under
`pi tensor pi`. Spectral ordering and arithmetic--geometric mean then
prove the fully explicit surplus

\[
\boxed{J_{xyz}-(n-1)\ge
m\sigma_{x+z}
 +\left(m-\frac{\delta^2M}{8(n-3)}\right)
   (\sigma_{x+y}+\sigma_{y+z}).}
\]

The first coefficient remains positive even at equality in the second
parameter condition, so equality forces `B=Pi`, hence `S=Pi`.
Disconnected roots and squares with extra stationary components give
strictness rather than disappearing from the spectral sum.

An actual four-state example in the note has `delta=1` and a strictly
negative centered cubic for every positive triple. The quadratic surplus
still proves the bound. That small example is already within the old
source cap; it tests the compensation mechanism and is not counted as a
new host class.

### Complete weighted example outside the previous cap and balance tests

The theorem supplies all triangle-star inputs for an explicit original
26-state binary projection channel. Its coarse law is

\[
\pi=(17,15,16,\ldots,16)/208
\]

on 13 states; `delta=13/15`, and the flat-complement projection has rank
twelve. A reversible lazy path, refreshed by `1/1024`, is its actual
coarse root. The fine law is exactly `mu(i,sign)=pi_i/2`, and

\[
T((i,s),(j,t))=S(i,j)+st\,2^{-15}Q(i,j),\qquad
p=\frac{819200}{11272763},\qquad W=pT.
\]

The note and [exact certificate](continuation7_source_weighted_checks.json)
specify every entry. They prove strict positivity, original weighted
Markovness, and the actual square-channel formula. The visible source
trace is nonconstant, and an exact first-step Rayleigh lower bound
exceeds twelve, so the old cap `4+4sqrt(2)` fails as a sufficient test.
The entire centered square spectrum has fourteen distinct values,
including its additional zero value. Each coarse centered mode has a
nonzero compressed multiplication source; zero is not omitted from the
band count.

The prior projection four-cycle bound and the separate, already proved
coarse convex-TP2 density theorem give

\[
F(T;n_e)\ge F(S;n_e)+12\sum_{D\in\mathcal C(K_4)}
                  (2^{-30})^{\sum_{e\in D}n_e}>1
\]

for all six positive exponents on this host. The coarse density term is
retained and has its own input. The checker verifies all 6,084 ordered
TP2 minors of the unrefreshed coarse root and independently evaluates
the full 26-state density at `(k,u,r,l,h)=(3,1,1,1,1)` from actual powers.
This is a complete positive example, not a general reduction of target
hosts to projection channels.

## 3. Simultaneous covers with component degree at most three

The [cover proof](continuation7_cover_orbits.md) works on the question's
actual 32-state sign host at every tuple

\[
(k,u,r,l,h)=(k,4,1,1,8),\qquad k\ge4.
\]

It proves `Z_sigma<=F(k)^M` for arbitrary sheet count `M` when **each
connected component of the cover has covering degree at most three**.
The edge permutations may be noncommuting.

After an original-product-law sheet relabeling makes the three tree-edge
permutations identities, the three chord permutations determine the
components by their joint orbits. Exact simultaneous-conjugacy
classification gives seven connected two-sheet types and 41 connected
three-sheet types, including 28 noncommuting three-sheet types. Twelve
of these 48 types were already gauge-equivalent to one permuted edge.
The other **36 are genuinely simultaneous**: one double cover and 35
three-covers. The host's density was already covered; this result extends
the cover scope.

The seven active original eigenfunctions have distinct three-bit
characters. Their actual original-law cubic moments enforce character
flow at every lifted vertex. On a connected degree-`m` cover, only
`2m+1` non-tree characters are free; the tree characters are uniquely
determined. Thus every surviving term can be enumerated exactly without
assigning arbitrary functions to the vertices.

With `z=2^-k`, both the base partition function and each cover partition
function are exact dyadic polynomials. Write their complete defect as

\[
\Delta_\sigma(z)=P(z)^m-P_\sigma(z)=\sum_q a_qz^q.
\]

Every certificate retains negative coefficients. For all 48 types the
least nonzero degree `q0` is zero or four, and exact arithmetic verifies

\[
a_{q_0}+\sum_{q>q_0}\min(a_q,0)2^{-4(q-q_0)}>2^{-60}.
\]

For `0<z<=1/16`, this bounds the whole negative tail in the correct
direction and proves

\[
\boxed{F(k)^m-Z_\sigma(k)>2^{-4k-60},\qquad m=2,3.}
\]

Every complete defect has between five and eleven negative coefficients;
coefficientwise positivity is not used. The
[full dyadic coefficient table](continuation7_cover_orbits_checks.json)
and standard-library verifier retain all coefficients and class data.
The result holds for the entire infinite integer family `k>=4`, not
just sampled exponent values.

Components involve disjoint integration variables under the unchanged
original law, so `Z_sigma=product_O Z_(sigma|O)` exactly. Consequently

\[
Z_\sigma(k)\le F(k)^M
\prod_{|O|\ge2}\left(1-\frac{2^{-4k-60}}{F(k)^{|O|}}\right)
\le F(k)^M.
\]

The product is strict if a nonsingleton component occurs. No component
probability is renormalized. Connected covers of degree four or larger
remain outside this theorem, even on this fixed host.

## 4. A second actual modewise shortcut is refuted exactly

The [ten-state obstruction](continuation7_opt_ac_obstruction.md) addresses
a newly tested coefficient, obtained by expanding **only the `ac` edge**:

\[
d_i=\mathbb E_{\mu^4}\phi_i(a)\phi_i(c)
K_k(a,b)K_u(a,d)K_r(b,c)K_u(b,d)K_l(c,d).
\]

Then `F(h)=sum_i theta_i^(r+h)d_i`. Its constant coefficient is
`E K_u K_(k+u) K_(r+l)>=1`; if every active `d_i` were nonnegative,
this would prove the target. The order conditions do **not** supply
that sign.

For a fully specified positive rational ten-state actual root and
`(k,u,r,l,h)=(8,1,2,1,1)`, let `P` be the ordinary original-law transition
matrix and let `D^op` represent the five-edge coefficient kernel. The
positive commuting trace-one filter

\[
H=\frac{\operatorname{adj}(1024P-I)^2}
        {\operatorname{tr}[\operatorname{adj}(1024P-I)^2]}
\]

satisfies the exact inequality

\[
\boxed{-1/10000<\operatorname{tr}(H D^{\rm op})<-1/20000.}
\]

Exact root invertibility makes every square mode active. Therefore some
centered active actual eigenfunction has `d_i<-1/20000`. This avoids any
uncertified sign for an irrational eigenvector. A separate exact cyclic
matrix determinant proves nine distinct positive values on the entire
centered square space, with no zero band.

The original normalization is

\[
p=159/127138411826,\qquad W=pT,\qquad0<W\le1/2.
\]

The same certificate proves

\[
\boxed{F\ge\mu_0^{-2}P_{00}^{32}>4.}
\]

Thus this refutes a sufficient modal lemma only. It is neither `F<1` nor
a proof that the complete density fails to be monotone in `h`. The
actual-root construction, original-law weighted trace, full sign
certificate, and discovery accounting are all explicit in the packet.

## 5. Verification and completed numerical scope

Three separate research agents pursued source contractions, simultaneous
covers, and actual-host optimization. Independent analytical reviews are
bound to the final mathematical files. The root review imports no author
verifier: it rebuilds actual weighted fields, computes the ac filter by
ordinary rational inverse-square arithmetic and all 100 literal source
entries, and reconstructs cover polynomials by three independent binary
cycle-space planes. It checks every saved interval bound, all seven
double-cover polynomials, and one noncommuting three-cover polynomial.

The source checks include repeated exponents, `n=4,delta=1`, larger
parameter values allowed by the full criterion, equality, disconnected
roots, connected bipartite roots whose squares disconnect, additional
stationary and zero modes, nonuniform original weights, and an actual
negative centered cubic. The full-target examples include `r=l` and
`h=1`; no boundary check is promoted to the unrestricted result.

From this directory, run:

```bash
python continuation7_packet_audit.py
```

The default uses only standard-library exact arithmetic. It checks every
manifest hash and runs the exact authors' checkers and independent
executable reviews in separate temporary copies, preserving frozen
inputs. The full cover enumeration takes about two minutes on the
recorded environment. With NumPy and SciPy, `--include-numerical` also
replays the retained twelve-start data; it starts no optimizer.

The [bounded high-rank report](continuation7_opt_highrank_report.md)
records twelve fixed starts with ranks eleven through sixteen and
codimension two or three: 2,400 iterations, 2,740 real calls, and 181,001
calls including complex-step derivatives. All reached the 200-iteration
cap. No strict `J<rank Q` candidate appeared; the smallest retained
independently replayed ratio was approximately `1.0009264415412857`.
All retained shortest-time source caps exceeded 2049 and traces varied.
No complete target `F` was optimized in that stage.

A separate 1,512-comparison diagnostic scan tested actual roots against
all nontrivial double-cover gauges. It found no violation exceeding its
stated floating tolerance. The
[ac discovery record](continuation7_opt_ac_discovery.md) separately
accounts for fixed coefficient tables, fourteen flow restrictions,
rounding, and filter selection. Those diagnostics supply no proof; the
displayed ten-state integer certificate is independent of them.

## 6. Exactly two remaining theorem-strength obligations

The [route registry](continuation7_route_registry.md) retains only:

1. **(U): the unrestricted actual averaged projection-star contraction.**
   The weighted theorem closes one more family, not arbitrary laws and
   projections. Even a general U theorem would extend a projection-channel
   comparison and would still retain its coarse density term; it would
   not automatically solve every target host.
2. **(C): the arbitrary simultaneous cover comparison under the original
   law.** The finite degree-two/three certificates do not prove arbitrary
   connected degree, arbitrary host, or arbitrary target tuple. Together
   with the earlier original-law cover-entropy lower bound, a full C
   theorem would imply the requested target. A C counterexample alone
   would not imply `F<1`.

The exact `ac` obstruction closes a false shortcut; it is not an extra
missing obligation. The supplied Dirichlet identity is not counted as
progress. This packet records the completed bounded pass and schedules no
automatic continuation.
