# Exact examples separating the Jordan hypotheses

**Scope.** The main Jordan theorem proves an explicit source-cap class
and a balanced-visible-trace class. This note checks actual hosts for
both, with original measures and complete centered spectral counts. The
rank-ten example violates the source cap but meets the balanced-trace
condition. The reused heavy-atom example has nonconstant visible trace
but meets the source cap. Neither is an unrestricted target proof or a
counterexample.

The rational certificate is `continuation6_jordan_verify.py`, using only
the finite arithmetic functions in `continuation6_graded_verify.py`.
No stored result or optimizer output is a proof input.

## 1. Balanced rank ten, thirteen centered fine values

Let `n=12`, `pi_i=1/12`, and `eta=epsilon=1/1024`. Define the relative
root `S0` of the uniform lazy path by

\[
S_0(i,i+1)=S_0(i+1,i)=12\eta,
\quad S_0(i,i)=12-\sum_{j\ne i}S_0(i,j),
\quad S_0(i,j)=0\quad(|i-j|>1),
\]

\[
S=(1-\epsilon)S_0+\epsilon\Pi.\tag{1}
\]

All its original weighted rows equal one. The least holding probability
of `S0` is `511/512`. In particular, every eigenvalue of `S0` is at
least `255/256`. Its reversible coordinate matrix is an irreducible
symmetric Jacobi matrix, so all twelve eigenvalues are simple and
positive.

Divide the twelve indices into three consecutive groups of four. Write
`g(i)=floor(i/4)` and put

\[
P(i,j)=p_{g(i),g(j)},\qquad
p=\begin{pmatrix}2&1&-1\\1&2&1\\-1&1&2\end{pmatrix},
\qquad Q=I-P.\tag{2}
\]

Each group has original probability `1/3`, so direct weighted
composition gives `P^2=P`, `rank P=2`, and `Q^2=Q`, `rank Q=10`.
Furthermore `Q(i,i)=10`. It is signed: the triangle on `0,1,2` has
product `(-2)^3=-8`. It is noncentral:

\[
Q\mathbf1=(1/3,1/3,1/3,1/3,-1/3,-1/3,-1/3,-1/3,
                          1/3,1/3,1/3,1/3),\tag{3}
\]

and `SQ!=QS`.

On twenty-four states `(i,sigma)`, take the original law `mu=1/24` and

\[
\alpha={1\over20480},\quad\beta=\alpha^2,
\quad T((i,\sigma),(j,\tau))=S(i,j)+\alpha\sigma\tau Q(i,j),
\quad p={262144\over3139971},\quad W=pT.\tag{4}
\]

Since `max |Q|=10` and `min S=epsilon`, (4) is strictly positive.
The exact certificate gives

\[
\min T=9/10240,\qquad \max T=3139971/262144,
\quad\max A={8215521496079\over687194767360}>11,
\tag{5}
\]

where `A=T^2`. Thus `0<W<=1` and all original weighted row sums are
exactly `p`. The actual signed channel has `H^2=beta Q`.

### The source cap really fails

For the actual first-time field `M1(t)=Q D_(B(.,t)) Q`, `B=S^2`, use
the nonzero test vector `Q e_0` in `L2(pi)`. Its exact Rayleigh quotient
is

\[
{\sum_i\pi_i B(i,0)Q(i,0)^2\over Q(0,0)}
={1711756696579\over171798691840}>{97\over10}
>4+4\sqrt2.\tag{6}
\]

The last comparison follows by squaring positive numbers:
`(97/10-4)^2=3249/100>32`. Thus this example is outside the new
source-cap hypothesis. It is covered by balanced visible rank ten,
because `B[Q(i,i)]=10`. Its centered cubic term at powers `(1,2,3)`
is exactly nonzero, so cubic vanishing is not the mechanism used.

### Complete centered spectrum and actual density

The eleven centered eigenvalues of `S` are positive and distinct:
refresh multiplies those of `S0` by `1023/1024`. Their squares stay
distinct and exceed `beta`. The fine square has exactly thirteen values
on its entire centered space:

| Centered fine value | Multiplicity |
|---|---:|
| Eleven distinct positive values from `S^2` | One each |
| `beta=1/419430400` | Ten |
| `0` | Two |

The exact factorization is
`chi_A(z)=chi_(S^2)(z)(z-beta)^10 z^2`.
The original diagonal-compression map
`f -> Q D_f Q` has rank twelve, checked rationally. Therefore every
nonzero coarse eigenfunction, including all eleven centered modes,
contributes a nonzero actual compression coefficient. The extra bands
are interacting, rather than merely an unused spectral decoration.

The balanced-rank-ten theorem gives the triangle bound for every three
positive exponents. Together with the quadrilateral lemma it gives

\[
F(T;n)\ge F(S;n)+10\sum_{D\in\mathcal C(K_4)}
                             \beta^{\sum_{e\in D}n_e}.\tag{7}
\]

The coarse density lower bound is an explicit prior input: `S0` is TP2
in its path order (all `binom(12,2)^2=4356` minors are checked), and
`S^(2j)=(1-epsilon)^(2j)S0^(2j)+[1-(1-epsilon)^(2j)]Pi`.
Weighted Cauchy--Binet preserves TP2 under composition, and the earlier
common-order TP2-convex-hull theorem applies at the base-density level.
It does not say the refreshed kernel itself is TP2. Hence `F(S;n)>=1`
for every six positive exponents.

The checker independently integrates the full twenty-four-state density
at the nonreflection target tuple `(3,1,1,1,1)`, as an exact integer
numerator with all original weights. It checks all actual powers and
the seven-cycle identity. Separately, it integrates the original
four-variable star and verifies the signed interval bound

\[
\left(C_{123}-{7\over2}g_{23}\right)^2
\le {81\over4}v_2v_3,
\quad J_{123}-10\ge {7\over16}v_3>0.\tag{8}
\]

No floating-point eigenvalue matching enters these certificates.

## 2. A reused unbalanced host: the fixed-tuple restriction is removed

The following is the heavy-atom actual host already used in PRs #60 and
#61; it is not a newly found host. Use

\[
\pi=(3/5,1/5,1/10,1/10),\quad s=(60,20,10,10),
\quad G=\begin{pmatrix}
59&1&0&0\\1&18&1&0\\0&1&8&1\\0&0&1&9
\end{pmatrix},
\]

\[
S_0(i,j)={100G_{ij}\over s_i s_j},\quad
S={31\over32}S_0+{1\over32}\Pi,
\quad f=(1,0,-3,-3),\quad Q=\Pi+{5\over12}f\otimes f.
\tag{9}
\]

This is a signed rank-two original-law projection, noncommuting with
`S`. Its actual first-time field has nonconstant trace, so the balanced
theorem does not apply. However, direct rational computation gives

\[
\max_{i,j}B(i,j)={9929\over1280}<9,\quad B=S^2.\tag{10}
\]

For every `t`, multiplication by `B(.,t)` is bounded above by the
quantity in (10). Compression to `ran Q` therefore gives
`M1(t)<= (9929/1280)I`. Subsequent fields are Markov averages of these
first fields. The new cap theorem proves **all** positive unequal-star
triples for this host, not just the former `(1,2,8)` numerical or
quadratic certificate.

The actual eight-state binary root is

\[
\mu(i,\sigma)=\pi_i/2,\quad
T((i,\sigma),(j,\tau))=S(i,j)+{\sigma\tau\over128}Q(i,j),
\quad\beta=1/16384,\quad p={512\over4499},\quad W=pT.
\tag{11}
\]

The earlier exact root verification and the current reconstruction agree.
Its fine square has three distinct positive coarse centered bands, the
channel band, and zero: five values on the entire centered space.
Using its established coarse convex-TP2 density bound, (11) now has the
all-exponent estimate

\[
F(T;n)\ge1+2\sum_{D\in\mathcal C(K_4)}
                             \beta^{\sum_{e\in D}n_e}>1.\tag{12}
\]

This is the concrete improvement over the fixed-host/fixed-tuple
comparison in PR #61. It remains coverage of a specified host and an
explicit class of sources; it is not a global band theorem.

**Prior inputs:** the coarse common-order convex-hull theorem is in
`../tp2-class.md`; the original heavy-atom host and its spectrum are in
the frozen PR #60 projection packet. Both are explicitly separate from
the new Jordan argument.
